
"""
DLX - by GASPY

-Emin Arakelian
-Michael Galczynski

Notes:

    - More Instructions should be added as required
"""
#FILE ADDRESS HERE



add='lin_time_fibo.txt'



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
    global pc
    if op=='ADDI':
        reg[a]=reg[b]+c
        pc+=1
        return
    elif op=='SUBI':
        reg[a]=reg[b]-c
        pc+=1
        return
    elif op=='MULI':
        reg[a]=reg[b]*c
        pc+=1
        return
    elif op=='DIVI':
        reg[a]=reg[b]/c
        pc+=1
        return
    elif op=='MODI':
        reg[a]=reg[b]%c
        pc+=1
        return
    elif op=='CMPI':
        reg[a]=reg[b]-c
        pc+=1
        return

    elif op=='LDW':
        reg[a]=memory[reg[b]+c][0]
        pc+=1
        return
    elif op=='STW':
        memory[reg[b]+c][0]=reg[a]
        pc+=1
        return
    elif op=='BEQ':
        if reg[a]==0:
            pc+=c
        else:
            pc+=1
        return
    elif op=='BGE':
        if reg[a]>=0:
            pc+=c
        else:
            pc+=1
        return
    elif op=='BGT':
        if reg[a]>0:
            pc+=c
        else:
            pc+=1
        return
    elif op=='BLE':
        if reg[a]<=0:
            pc+=c
        else:
            pc+=1
        return
    elif op=='BLT':
        if reg[a]<0:
            pc+=c
        else:
            pc+=1
        return
    elif op=='BNE':
        if reg[a]!=0:
            pc+=c
        else:
            pc+=1
        return
    elif op=='BR':
        pc+=c
        return
    elif op=='BSR':
        reg[31]=pc+1
        pc+=c
        return
    elif op=='POP':
        reg[a]=memory[reg[b]][0]
        reg[b]=reg[b]+c
        pc+=1
        return
    elif op=='PSH':
        reg[b]=reg[b]-c
        memory[reg[b]][0]=reg[a]
        pc+=1
        return
    #F2
    if op=='ADD':
        reg[a]=reg[b]+reg[c]
        pc+=1
        return
    elif op=='SUB':
        reg[a]=reg[b]-reg[c]
        pc+=1
        return
    elif op=='MUL':
        reg[a]=reg[b]*reg[c]
        pc+=1
        return
    elif op=='DIV':
        reg[a]=reg[b]/reg[c]
        pc+=1
        return
    elif op=='MOD':
        reg[a]=reg[b]%reg[c]
        pc+=1
        return
    elif op=='CMP':
        reg[a]=reg[b]-reg[c]
        pc+=1
        return
    elif op=='MOV':
        reg[a]=reg[c]
        pc+=1
        return
    elif op=='RET':
        pc=reg[c]
        return
    #F3

    elif op=='JSR':
        reg[31]=pc+1
        pc=c


#Reading the code

with open(add,'rb') as f:
    read=f.readlines()

memory=mem(1024) #creating an arbitrary sized memory
reg=mem(1,True) #creating a 32 bit register
pc=0            #Where we are globally
ir=[]
#reg[0] should always be zero and reg[27] is for the return values

reg[27]=0                           #Return value for functions
reg[28]=int(len(memory)*0.1)        #The stack pointer, starting at the end, where we are locally
reg[29]=len(memory)                 #The Frame pointer, value does not change in a function , where we were locally
reg[31]=0                           #The Link pointer, where we were globally
reg[30]=0                           #Function input



#Reading the code
memory[0].pop()#cleaning the zero in register zero
for i,entry in enumerate(read):
    memory[0]+=[entry.split()] #Loading and decoding the code into mem[0]



while True:
    if not memory[0][pc]:
        pc+=1
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
    #print reg

#print 'Memory: ',memory #Outputting the final memory state
#print '\n\n'

print 'Memory: ',memory[1:] #plotting the first 10 Fiboncacci sequence numbers
print 'Register: ',reg

print 'DONE'
