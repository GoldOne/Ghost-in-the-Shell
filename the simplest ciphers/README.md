The simplest ciphers
==================

The simplest substitution ciphers are where each letter in the alphabet is replaced by another letter in the alphabet. Thus, for example, the mapping below defines a shift cipher, where the substituted elements are related by a shift from the original (by three letters). Thus a  d, b  e, etc. Your task is to implement, in a BASH shell script SubCip.sh, a substitution cipher with the following specifications.
 The command line usage should be:
SubCip.sh > 
 You should add appropriate error checking on the input.
 The should be -e for encryption, and -d for decryption.
 The is any list of lowercase letters. The usage is as follows.
For encryption, the ith letter of the alphabet is mapped to the ith distinct letter of . The remaining letters in the alphabet are mapped, in alphabetical order, to the alphabetical list of letters not in the keyword. Thus, for example, if the keyword is “cabbage”, the following mapping should be implemented.
The cipher acts only on lower case, both in the input file and in the key. Thus, in particular, any upper case letters are ignored.
