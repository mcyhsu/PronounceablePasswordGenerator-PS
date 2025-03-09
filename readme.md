# Pronounceable Password Generator
A PowerShell script that generates a secure, pronounceable password that you can actually remember.

## How to Install This Script
Download a copy of the .ps1 file and run it in your preferred environment (e.g. VS Code).

## How to Use This Script
The main function is **New-PronounceablePassword**.

By default, it will do the following if no parameters are entered:

- Generate 10 passwords
- Each password is 10 letters in length
- Randomly capitalize at least 1 letter in each password

The script will then prompt you to **copy a single password to the clipboard**, **copy all passwords to the clipboard**, or **cancel**.

![](https://github.com/mcyhsu/PronounceablePasswordGenerator-PS/blob/main/Assets/default.png?raw=true)

## Optional Parameters
**-passwordsToGenerate \<int\>**
```
New-PronounceablePassword -passwordsToGenerate 20 # Generates 20 passwords
```
**-length \<int\>**
```
New-PronounceablePassword -length 20 # Passwords will be 20 characters long
```
**-includeNumbers \<boolean\>**
```
New-PronounceablePassword -includeNumbers $true # Passwords will include at least 1 number
```
**-includeSymbols \<boolean\>**
```
New-PronounceablePassword -includeSymbols $true # Passwords will include at least 1 symbol
```
**-capitalizationChance \<double\>**
```
New-PronounceablePassword -capitalizationChance 0.5 # Range of 0.0 to 1.0, sets the chance of capitalizing a letter
```

Note that **adding parameters will make the passwords less pronounceable**, and it will feel more like any other password generator.
## Examples
### Example 1:
```
New-PronounceablePassword -passwordsToGenerate 20 -length 10
```
This will generate 20 passwords, each 10 letters in length, with 15% capitalization chance by default.

![](https://github.com/mcyhsu/PronounceablePasswordGenerator-PS/blob/main/Assets/example1.png?raw=true)

### Example 2:

```
New-PronounceablePassword -passwordsToGenerate 20 -length 10 -includeSymbols $true
```
The same as before, but now at least 1 symbol is added.

![](https://github.com/mcyhsu/PronounceablePasswordGenerator-PS/blob/main/Assets/example2.png?raw=true)

### Example 3:
```
New-PronounceablePassword -passwordsToGenerate 20 -length 20 -includeSymbols $true -includeNumbers $true -capitalizationChance 0.5
```
This will generate 20 highly secure passwords, each one 20 characters in length, with numbers and symbols randomly added, and a 50% chance of capitalizing any letter.
 The password is not likely to be pronounceable.
 
 ![](https://github.com/mcyhsu/PronounceablePasswordGenerator-PS/blob/main/Assets/example3.png?raw=true)