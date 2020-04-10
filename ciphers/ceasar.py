from functools import partial

def get_ord(num):
    return ord(num) - 65

def get_chr(num):
    return chr(num + 65)

def shifted(shift, char, length_of_alphabet=26):
    # skip the space
    if ord(char) == ord(' '):
        return ' '
    return get_chr((get_ord(char) + shift) % length_of_alphabet)

def ceasar(string, shift):
    _shifted = partial(shifted, shift)
    return ''.join(map(_shifted, string))

# example
# text = 'ZVVU DVYR SHKF SHDU'
# for shift in range(26):
#    print(ceasar(text.upper(), shift))
