.text
#Test number
li $t0, 1


#Counter for number of leading zeros
li $t2, 0
#Counter for bits traveled
li $t3, 0

countLoop:
    #Check if checked 32 bits
    beq $t3, 32, countLoopDone
    
    #Query first bit
    andi $t4, $t0, 2147483648
    
    #See if first bit is zero or nah
    bnez $t4, countLoopDone
    
    #Add to leading zero counter
    addi $t2, $t2, 1
    #Shift number to the left by one bit
    sll $t0, $t0, 1
    #Add to bits travelled counter
    addi $t3, $t3, 1
    
    #Jump to loop
    j countLoop
    
countLoopDone:
    li $v0, 1
    move $a0, $t2
    syscall