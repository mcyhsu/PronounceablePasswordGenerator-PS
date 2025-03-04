function New-LetterPassword() {
    param (
        [int]$length = 8,
        [int]$passwordsToGenerate = 10,
        [double]$capitalizationChance = 0.2 # The range should be between 0 and 1, 0.5 means 50% chance of capitalizing the character, 0.2 means 20% chance, etc.
    )
    $random = New-Object System.Random
    $vowels = @("a", "e", "i", "o", "u", "y", "a", "e", "i") # Duplicates intentional
    $consonants = @("b", "c", "d", "f", "g", "h", "j", "k", "l", "m", "n", "p", "r", "s", "t", "v", "w", "z", "b", "d", "l", "n", "r", "s", "t") # Duplicates intentional
    $passwordList = @()

    for ($j = 0; $j -lt $passwordsToGenerate; $j++) {
        $pronounceablePassword = ""
        $lastCharWasVowel = $false # Start with a consonant
        for ($i = 0; $i -lt $length; $i++) {
            if ($lastCharWasVowel) {
                $char = $consonants[$random.Next(0, $consonants.Length)]
            } else {
                $char = $vowels[$random.Next(0, $vowels.Length)]
            }
    
            if ($random.NextDouble() -lt $capitalizationChance) { # NextDouble returns a number between 0 and 1, e.g. 0.5 means 50% chance
                $char = $char.ToUpper()
            }
            $pronounceablePassword += $char
            $lowerChar = $char.ToLower()
            $lastCharWasVowel = $lowerChar -in $vowels # If the last character was a vowel, the next one should be a consonant and vice versa
        }
        $passwordList += $pronounceablePassword
    }
    $passwordList
}


function New-SyllablePassword {
    param(
        [int]$length = 8,
        [int]$passwordsToGenerate = 10,
        [double]$capitalizationChance = 0.15 # The range should be between 0 and 1, 0.5 means 50% chance of capitalizing the character, 0.2 means 20% chance, etc.
    )

    $cvChunks = @(
        "ba", "be", "bi", "bo", "bu",
        "ca", "ce", "co", "cu",
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
        "va", "ve", "vo",
        "wa", "we", "wi", "wo",
        "za", "ze", "zi", "zo"
    )
    $vcChunks = @(
        "am", "ar", "as", "an", "al",
        "el", "em", "en", "er", "es",
        "il", "in", "ir", "is", "im",
        "on", "or", "os", "om", "ol",
        "um", "un", "ur", "us", "ul"
    )
    $cvcChunks = @(
        "bat", "ben", "cat", "dar", "dom",
        "fan", "fen", "gam", "gon", "lam",
        "man", "mat", "nan", "nor", "pal",
        "pan", "ran", "ren", "sam", "sen",
        "tan", "tel", "van", "zan", "zor"
    )
    $vowels = @("a", "e", "i", "o", "u", "y")
    $random = New-Object System.Random
    $passwordList = @()

    for($j = 0; $j -lt $passwordsToGenerate; $j++) {
        $pronounceablePassword = ""
        $initialChunkRoll = $random.NextDouble()
        
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
                if($nextChunkRoll -lt 0.5) {
                    $pronounceablePassword += $cvChunks[$random.Next(0, $cvChunks.Length)]
                } else {
                    $pronounceablePassword += $cvcChunks[$random.Next(0, $cvcChunks.Length)]
                }
            } else { # If the chunk ends in a consonant, the next chunk starts with a vowel
                if($nextChunkRoll -lt 0.5) {
                    $pronounceablePassword += $vcChunks[$random.Next(0, $vcChunks.Length)]
                } else {
                    $pronounceablePassword += $vowels[$random.Next(0, $vowels.Length)]
                }
            }
        
        } while ($pronounceablePassword.Length -lt $length)
        
        # Ensures the password is exactly the specified length by removing any extra characters
        if($pronounceablePassword.Length -gt $length) {
            $pronounceablePassword = $pronounceablePassword.Substring(0, $length)
        }
        
        # Capitalizes random characters in the password
        $charArray = $pronounceablePassword.ToCharArray()
        for($i = 0; $i -lt $charArray.Length; $i++) {
            if($random.NextDouble() -lt $capitalizationChance) {
                $charArray[$i] = $charArray[$i].ToString().ToUpper() # Need to convert char to string in order to use ToUpper()
            }
        }
        $pronounceablePassword = -join $charArray

        # Checks if there is at least 1 capital letter in the password
        $containsCapital = $false
        $charArray = $pronounceablePassword.ToCharArray()
        foreach($char in $charArray) {
            if($char -ceq $char.ToString().ToUpper()) {
                $containsCapital = $true
                break
            }
        }
        
        # If there aren't any capital letters, then randomly capitalize a letter in the password
        if($containsCapital -eq $false) {
            $charArray = $pronounceablePassword.ToCharArray()
            $randomChar = $random.Next(0, $charArray.Length)
            $charArray[$randomChar] = $charArray[$randomChar].ToString().ToUpper()
            $pronounceablePassword = -join $charArray
        }   
        $passwordList += $pronounceablePassword
    }
    $passwordList
}

New-SyllablePassword
