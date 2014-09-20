
"""
DLX - by GASPY

-Emin Arakelian
-Michael Galczynski

Notes:

    - Memory should be more minutely managed to include Stack, Heap etc
    - It will be better to find a way to parse using binary instead of the python split()
    - More Instructions should be added as required
"""

#Memory Function
def mem(n,reg=False): 
    """Initiates an n-bytes memory, use the reg=True to create a 32 bit register(n=1)"""
    mem=[]
    for i in range(n):
        mem.append([0])
        if reg==True:
            for j in range(32):
                mem[i]+=[0]
    if n==1:
        mem=mem.pop()
    return mem

#Executing Fucntion      
def execute(op,a,b,c):
    if op=='ADDI':
        reg[a]=[reg[b]+c]
        return
    elif op=='SUBI':
        reg[a]=[reg[0]-c]
        return
    elif op=='MULI':
        reg[a]=[reg[b][0]*c]
        return
    elif op=='DIVI':
        reg[a]=[reg[b][0]/c]
        return
        
    elif op=='LDW':
        reg[a]=[memory[b+c][0]]
    elif op=='STW':
        [memory[b+c][0]]=reg[a]
        
    #F2
    if op=='ADD':
        reg[a]=[reg[b][0]+reg[c][0]]
        return
    elif op=='SUB':
        reg[a]=[reg[b][0]-reg[c][0]]
        return
    elif op=='MUL':
        reg[a]=[reg[b][0]*reg[c][0]]
        return
    elif op=='DIV':
        reg[a]=[reg[b][0]/reg[c][0]]
        return

memory=mem(100) #creating an arbitrary sized memory
reg=mem(1,True) #creating a 32 bit register
pc=0
ir=[]

#Reading the code
add='Fibo.txt'
with open(add,'rb') as f:
    read=f.readlines()

#Reading the code
memory[0].pop()#cleaning the zero in register zero
for i,entry in enumerate(read):
    memory[0]+=[entry.split()] #Loading and decoding the code into mem[0]
        

while True:
    if not memory[0][pc]:
        pass
    elif memory[0][pc][0]=='END':
        break
    else:
        ir=memory[0][pc]
        op=ir[0]
        a=int(ir[1])
        b=int(ir[2])
        c=int(ir[3])
        execute(op,a,b,c)
    pc+=1 




print memory #Outputting the final memory state
print '\n\n'
print memory[1:11] #plotting the first 10 Fiboncacci sequence numbers


print 'DONE'
    


