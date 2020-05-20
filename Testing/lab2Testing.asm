.data
initial: .word 2,1,2,1,2
end: .word 5,5,5,5,5

.text
li $a2, 5


la $a0, initial
la $a1, end
#Num entries
move $t0, $a2

#Move to second val
addi $a0, $a0, 4
addi $a1, $a1, 4

#placeholder
li $t7, 1

#index
li $t1, 2
maximaLoop:

beq $t1, $t0, maximaLoopDone

	lw $t2, -4($a0)
	lw $t3, ($a0)
	lw $t4, 4($a0)
	
	ble $t3, $t2, maximaLoopNext
	ble $t3, $t4, maximaLoopNext
	
	#Local Max
	sw $t7, ($a1)
	
	maximaLoopNext:
	addi $a0, $a0, 4
        addi $a1, $a1, 4
        addi $t1, $t1, 1
        j maximaLoop
        
maximaLoopDone:

