The simplest ciphers
==================

The simplest substitution ciphers are where each letter in the alphabet is replaced by another letter in the alphabet. Thus, for example, the mapping below defines a shift cipher, where the substituted elements are related by a shift from the original (by thretters). Thus a  d, b  e, etc.

a|b|c|d|e|f|g|h|i|j|h|j|k|l|m|n|o|p|q|r|s|t|u|v|w|x|y|z
---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---
d|e|f|g|h|i|j|k|l|m|n|o|p|q|r|s|t|u|v|w|x|y|z|a|b|c

Your task is to implement, in a BASH shell script `SubCip.sh`, a substitution cipher with the following specifications.

* The command line usage should be:
        `SubCip.sh <mode> <keyword> <inputfile> > <outputfile>`
        
* You should add appropriate error checking on the input.
* The`<mode> ` should be ` -e` for encryption, and `-d` for decryption.
* The`<keyword>` is any list of lowercase letters. The usage is as follows.
For encryption, the ith letter of the alphabet is mapped to the ith distinct letter of `<keyword>`. The remaining letters in the alphabet are mapped, in alphabetical order, to the alphabetical list of letters not in the keyword. Thus, for example, if the keyword is “`cabbage`”, the following mapping should be implemented.

For decryption the resverse subtitution should occur.

The cipher acts only on lower case, both in the input file and in the key. Thus, in particular, any upper case letters are ignored.


a|b|c|d|e|f|g|h|i|j|h|j|k|l|m|n|o
---|--|---|---|---|---|---|---|---|---|---|---|---|---|---|---|----
a    | b    | cd    | e  d    | e  dd    | e  d    | e  d    | e|e  d    | e  d    | e   | e  d    | e  d  | e|sd|df|  
d    | e    | f
g    | h    | i

|a|b|c|
|-|-|-|
|s| D |a |
