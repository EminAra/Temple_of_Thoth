
class Cipher(object):
    """https://en.wikipedia.org/wiki/Vigen%C3%A8re_cipher"""
    def __init__(self):
        alphabet = 'a b c d e f g h i j k l m n o p q r s t u v w x y z'.split()

        table_cheat = {}
        for i in range(len(alphabet)):
            table_cheat[alphabet[i]] = []
            for j in range(len(alphabet)):
                table_cheat[alphabet[i]].append(alphabet[(j+i)%len(alphabet)])

        table = {}
        for letter in alphabet:
            table[letter] = {}
            for i,cheat_letter in enumerate(table_cheat[letter]):
                table[letter][cheat_letter] = alphabet[i]

        self.table = table

    def encoder(self, string, key):
        spaces = [i for i,x in enumerate(string) if x==' ']
        string = string.replace(' ','').lower()
        key = key.lower()

        temp = ''
        for i,letter in enumerate(string):
            temp+= self.table[letter][key[i%len(key)]]

        encrypted = ''
        #everytime we add a space the letter falls behind by one letter, this j will account for that
        j=0
        for i,letter in enumerate(temp):
            if i+j in spaces:
                j+=1
                encrypted += ' '
            encrypted += letter

        return encrypted
