$vowels = @("a", "e", "i", "o", "u", "y")
$consonants = @("b", "c", "d", "f", "g", "h", "j", "k", "l", "m", "n", "p", "q", "r", "s", "t", "v", "w", "x", "y", "z")
$random = New-Object System.Random
$passwordList = @()

### Configuration ###
$passwordLength = 8
$passwordsToGenerate = 10
$capitalizationChance = 0.5 # The range is between 0 and 1, 0.5 means 50% chance of capitalizing the character, 0.2 means 20% chance, etc.
### Configuration ###


for ($j = 0; $j -lt $passwordsToGenerate; $j++) {
    $pronounceablePassword = ""
    $lastCharWasVowel = $false # Start with a consonant
    for ($i = 0; $i -lt $passwordLength; $i++) {
        if ($lastCharWasVowel) {
            $char = $consonants[$random.Next(0, $consonants.Length)]
        } else {
            $char = $vowels[$random.Next(0, $vowels.Length)]
        }

        if ($random.NextDouble() -lt $capitalizationChance) { # Currently set to 50% chance of capitalizing the character
            $char = $char.ToUpper()
        }
        $pronounceablePassword += $char
        $lowerChar = $char.ToLower()
        $lastCharWasVowel = $lowerChar -in $vowels # If the last character was a vowel, the next one should be a consonant and vice versa
    }
    $passwordList += $pronounceablePassword
}
$passwordList