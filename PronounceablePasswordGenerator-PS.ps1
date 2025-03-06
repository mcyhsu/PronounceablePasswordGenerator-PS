function New-PronounceablePassword {
    param(
        [int]$length = 8,
        [int]$passwordsToGenerate = 10,
        [double]$capitalizationChance = 0.15, # The range should be between 0 and 1, 0.5 means 50% chance of capitalizing the character, 0.2 means 20% chance, etc.
        [bool]$includeNumbers = $false,
        [bool]$includeSymbols = $false
    )

    $cvChunks = @( # Follows consonant-vowel pattern (with an exception for 'y')
        "ba", "be", "bi", "bo", "bu",
        "ca", "ce", "co", "cu", "cy",
        "da", "de", "di", "do", "du",
        "fa", "fe", "fi", "fo", "fu",
        "ga", "ge", "gi", "go", "gu",
        "ja", "je", "jo", "ju",
        "ka", "ke", "ki", "ko", "ku",
        "la", "le", "li", "lo", "lu",
        "ma", "me", "mi", "mo", "mu",
        "na", "ne", "ni", "no", "nu",
        "pa", "pe", "pi", "po", "pu",
        "ra", "re", "ri", "ro", "ru",
        "sa", "se", "si", "so", "su",
        "ta", "te", "ti", "to", "tu",
        "va", "ve", "vo", "vy", "ty",
        "wa", "we", "wi", "wo", "wy",
        "za", "ze", "zi", "zo", "zy"
    )
    $vcChunks = @( # Follows vowel-consonant pattern
        "am", "ar", "as", "an", "al",
        "el", "em", "en", "er", "es",
        "il", "in", "ir", "is", "im",
        "on", "or", "os", "om", "ol",
        "um", "un", "ur", "us", "ul"
    )
    $cvcChunks = @( # Follows consonant-vowel-consonant pattern
        "bat", "ben", "cat", "dar", "dom",
        "fan", "fen", "gam", "gon", "lam",
        "man", "mat", "nan", "nor", "pal",
        "pan", "ran", "ren", "sam", "sen",
        "tan", "tel", "van", "zan", "zor"
    )
    $vowels = @("a", "e", "i", "o", "u", "y")
    $numbers = @("0", "1", "2", "3", "4", "5", "6", "7", "8", "9")
    $symbols = @("!", "@", "#", "$", "%", "&", "*", "-", "_")

    $random = New-Object System.Random
    $passwordList = @()

    for($j = 0; $j -lt $passwordsToGenerate; $j++) {
        $pronounceablePassword = ""
        $initialChunkRoll = $random.NextDouble()
        $protectedChars = @() # Array to store the indexes of the characters that are protected from being replaced (Capital letters, numbers, symbols)
        
        # Deciding initial chunk
        if($initialChunkRoll -lt 0.25) {
            $pronounceablePassword += $cvChunks[$random.Next(0, $cvChunks.Length)]
        } elseif ($initialChunkRoll -lt 0.4) {
            $pronounceablePassword += $vcChunks[$random.Next(0, $vcChunks.Length)]
        } elseif ($initialChunkRoll -lt 0.9) {
            $pronounceablePassword += $cvcChunks[$random.Next(0, $cvcChunks.Length)]
        } else {
            $pronounceablePassword += $vowels[$random.Next(0, $vowels.Length)]
        }
        
        # Keep adding chunks until the target password length is reached or exceeded, default is 8
        do {
            $nextChunkRoll = $random.NextDouble()
            if($pronounceablePassword[-1] -in $vowels) { # If the chunk ends in a vowel, the next chunk starts with a consonant
                if($nextChunkRoll -lt 0.5) { # Roll to decide which array that starts with consonants to pick from
                    $pronounceablePassword += $cvChunks[$random.Next(0, $cvChunks.Length)]
                } else {
                    $pronounceablePassword += $cvcChunks[$random.Next(0, $cvcChunks.Length)]
                }
            } else { # If the chunk ends in a consonant, the next chunk starts with a vowel
                if($nextChunkRoll -lt 0.5) { # Roll to decide which array that starts with vowels to pick from
                    $pronounceablePassword += $vcChunks[$random.Next(0, $vcChunks.Length)]
                } else {
                    $pronounceablePassword += $vowels[$random.Next(0, $vowels.Length)]
                }
            }


            # If numbers or symbols are included, roll for a chance to add them at the end of each chunk
            $symAndNumRoll = $random.NextDouble()
            if($includeNumbers -and $symAndNumRoll -lt 0.5) { # Chance to add a number
                $randomNum = $random.Next(0, $numbers.Length)
                $pronounceablePassword += $numbers[$randomNum]
                $protectedChars += $pronounceablePassword.Length - 1 # This will add the newly added number to the $protectedChars array
            } elseif($includeSymbols -and $symAndNumRoll -lt 0.75) { # Chance to add a symbol
                $randomNum = $random.Next(0, $symbols.Length)
                $pronounceablePassword += $symbols[$randomNum]
                $protectedChars += $pronounceablePassword.Length - 1 # This will add the newly added symbol to the $protectedChars array
            } else {
                # Occasionally don't add a number or symbol, this code block intentionally left blank
            }
        
        } while ($pronounceablePassword.Length -lt $length)
        
        # Ensures the password is exactly the specified length by removing any extra characters
        if($pronounceablePassword.Length -gt $length) {
            $pronounceablePassword = $pronounceablePassword.Substring(0, $length)
        }
        
        # Capitalizes random characters in the password
        $charArray = $pronounceablePassword.ToCharArray()
        for($i = 0; $i -lt $charArray.Length; $i++) {
            if($random.NextDouble() -lt $capitalizationChance -and $i -notin $protectedChars) { # There is a chance that no characters will be capitalized here
                if($charArray[$i] -notin ($numbers + $symbols)) { # Makes sure the char at index $i is a letter
                    $charArray[$i] = $charArray[$i].ToString().ToUpper() # Need to convert char to string in order to use ToUpper()
                }
            }
        }
        $pronounceablePassword = -join $charArray

        # Checks if there is at least 1 capital letter in the password
        $containsCapital = $false
        $charArray = $pronounceablePassword.ToCharArray()
        foreach($char in $charArray) {
            if($char -cmatch "[A-Z]") {
                $containsCapital = $true
                $protectedChars += $charArray.IndexOf($char) # Add the index of the capital letter to the protectedChars array
            }
        }
        
        # If $includeNumbers is true and there aren't any numbers in the password, then randomly add a number
        if($includeNumbers -and $pronounceablePassword.IndexOfAny($numbers) -eq -1) {
            $charArray = $pronounceablePassword.ToCharArray()
            $randomChar = $random.Next(0, $charArray.Length)
            do {
                $randomChar = $random.Next(0, $charArray.Length)
            } while ($protectedChars -contains $randomChar) # Keep rolling to ensure the randomly selected character to be replaced with a number is not a capital letter
            
            $charArray[$randomChar] = $numbers[$random.Next(0, $numbers.Length)]
            $protectedChars += $randomChar # Add the index of the number to the protectedChars array, it will be protected from being replaced with a symbol
            $pronounceablePassword = -join $charArray
        }

        # If $includeSymbols is true and there aren't any symbols in the password, then randomly add a symbol
        if($includeSymbols -and $pronounceablePassword.IndexOfAny($symbols) -eq -1) {
            $charArray = $pronounceablePassword.ToCharArray()
            do {
                $randomChar = $random.Next(0, $charArray.Length)
            } while ($protectedChars -contains $randomChar) # Keep rolling to ensure the randomly selected character is not a number or capital letter before replacing it with a symbol

            $charArray[$randomChar] = $symbols[$random.Next(0, $symbols.Length)]
            $protectedChars += $randomChar # Add the index of the symbol to the protectedChars array, it will be protected from being replaced with a capital letter
            $pronounceablePassword = -join $charArray
        }

        # If there aren't any capital letters, then randomly capitalize a letter in the password
        if($containsCapital -eq $false) {
            $charArray = $pronounceablePassword.ToCharArray()
            do {
                $randomChar = $random.Next(0, $charArray.Length)
            } while ($protectedChars -contains $randomChar) # Keep rolling to ensure the randomly selected character is not a number or symbol before capitalizing it
            
            $charArray[$randomChar] = $charArray[$randomChar].ToString().ToUpper()
            $protectedChars += $randomChar # Add the index of the capital letter to the protectedChars array
            $pronounceablePassword = -join $charArray
        }   
        $passwordList += $pronounceablePassword
    }
    $passwordList
}



# Debugging
$debugging = $true

if($debugging -eq $true) {
    $passwords = New-PronounceablePassword -passwordsToGenerate 1000 -length 10 -includeNumbers $true -includeSymbols $true
    $passwords

    foreach($password in $passwords) {
        $containsCapital = $false
        $charArray = $password.ToCharArray()
        foreach($char in $charArray) {
            if($char -cmatch "[A-Z]") {
                $containsCapital = $true
            }
        }
    
        if($containsCapital -eq $false) {
            Write-Host "This password $password does not contain any capitals"
        }
    }
}
