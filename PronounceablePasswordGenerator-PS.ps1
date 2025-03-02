$vowels = @("a", "e", "i", "o", "u", "y")
$consonants = @("b", "c", "d", "f", "g", "h", "j", "k", "l", "m", "n", "p", "q", "r", "s", "t", "v", "w", "x", "y", "z")
$length = 8
$passwordsToGenerate = 10
$random = New-Object System.Random
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
        $pronounceablePassword += $char
        $lastCharWasVowel = $char -in $vowels # If the last character was a vowel, the next one should be a consonant and vice versa
    }
    $passwordList += $pronounceablePassword
}
$passwordList