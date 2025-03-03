$random = New-Object System.Random

function New-LetterPassword() {
    param (
        [int]$passwordLength = 8,
        [int]$passwordsToGenerate = 10,
        [double]$capitalizationChance = 0.2 # The range should be between 0 and 1, 0.5 means 50% chance of capitalizing the character, 0.2 means 20% chance, etc.
    )

    $vowels = @("a", "e", "i", "o", "u", "y", "a", "e", "i") # Duplicates intentional
    $consonants = @("b", "c", "d", "f", "g", "h", "j", "k", "l", "m", "n", "p", "r", "s", "t", "v", "w", "z", "b", "d", "l", "n", "r", "s", "t") # Duplicates intentional
    $passwordList = @()

    for ($j = 0; $j -lt $passwordsToGenerate; $j++) {
        $pronounceablePassword = ""
        $lastCharWasVowel = $false # Start with a consonant
        for ($i = 0; $i -lt $passwordLength; $i++) {
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



$cvChunks = @("ba", "be", "bo", "da", "de", "do", "fa", "fe", "fi", "ka", "ke", "ko", "la", "le", "lo", "ma", "me", "mo", "pa", "pe", "po", "ta", "te", "to")
$vcChunks = @("an", "ar", "el", "en", "im", "on", "ul", "um", "in", "ir", "or", "ur")
$cvcChunks = @("bat", "bel", "dam", "far", "kel", "lom", "man", "pan", "tel", "vor", "zan")
$vowels = @("a", "e", "i", "o", "u", "y")
$length = 12

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
    if($random.NextDouble() -lt 0.5) {
        $charArray[$i] = $charArray[$i].ToString().ToUpper() # Need to convert char to string in order to use ToUpper()
    }
    $pronounceablePassword = -join $charArray
}

$pronounceablePassword

<# TO DO:
- Add random capitalization
- Expand the array to include more interesting combinations of vowels and consonants
- Turn the syllable chunk generator into a function

#>


