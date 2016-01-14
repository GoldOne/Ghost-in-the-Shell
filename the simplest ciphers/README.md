The simplest ciphers
==================

The simplest substitution ciphers are where each letter in the alphabet is replaced by another letter in the alphabet. Thus, for example, the mapping below defines a shift cipher, where the substituted elements are related by a shift from the original (by thretters). Thus a &rarr d, b &rarr e, etc.  

<table>
    <tr>
<td>a</td><td>b</td><td>c</td><td>d</td><td>e</td><td>f</td><td>g</td><td>h</td><td>i</td><td>j</td><td>k</td><td>l</td><td>m</td><td>n</td><td>o</td><td>p</td><td>q</td><td>r</td><td>s</td><td>t</td><td>u</td><td>v</td><td>w</td><td>x</td><td>y</td><td>z</td>
    </tr>
    <tr>
<td>d</td><td>e</td><td>f</td><td>g</td><td>h</td><td>i</td><td>j</td><td>k</td><td>l</td><td>m</td><td>n</td><td>o</td><td>p</td><td>q</td><td>r</td><td>s</td><td>t</td><td>u</td><td>v</td><td>w</td><td>x</td><td>y</td><td>z</td><td>a</td><td>b</td><td>c</td>
    </tr>
</table>

Your task is to implement, in a BASH shell script `SubCip.sh`, a substitution cipher with the following specifications.

* The command line usage should be:
```shell
        SubCip.sh <mode> <keyword> <inputfile> > <outputfile>
```        
* You should add appropriate error checking on the input.
* The`<mode> ` should be ` -e` for encryption, and `-d` for decryption.
* The`<keyword>` is any list of lowercase letters. The usage is as follows.
For encryption, the ith letter of the alphabet is mapped to the ith distinct letter of `<keyword>`. The remaining letters in the alphabet are mapped, in alphabetical order, to the alphabetical list of letters not in the keyword. Thus, for example, if the keyword is “`cabbage`”, the following mapping should be implemented.

<table>
    <tr>
<td>a</td><td>b</td><td>c</td><td>d</td><td>e</td><td>f</td><td>g</td><td>h</td><td>i</td><td>j</td><td>k</td><td>l</td><td>m</td><td>n</td><td>o</td><td>p</td><td>q</td><td>r</td><td>s</td><td>t</td><td>u</td><td>v</td><td>w</td><td>x</td><td>y</td><td>z</td>
    </tr>
    <tr>
<td>c</td><td>a</td><td>b</td><td>g</td><td>e</td><td>d</td><td>f</td><td>h</td><td>i</td><td>j</td><td>k</td><td>l</td><td>m</td><td>n</td><td>o</td><td>p</td><td>q</td><td>r</td><td>s</td><td>t</td><td>u</td><td>v</td><td>w</td><td>x</td><td>y</td><td>z</td>
    </tr>
</table>

For decryption the resverse subtitution should occur.

The cipher acts only on lower case, both in the input file and in the key. Thus, in particular, any upper case letters are ignored.


