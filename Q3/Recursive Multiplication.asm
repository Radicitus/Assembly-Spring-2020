j main
.data
.text

#############################
multiply_recur:
######Your code begins here######

# PROLOGUE #
addi $sp, $sp, -16

sw $ra, 0($sp)
sw $a0, 4($sp)
sw $a1, 8($sp)
sw $s0, 12($sp)
# ######## #

li $v0, 0

XltY:
bge $a0, $a1, mrContinue
move $t0, $a0
move $a0, $a1
move $a1, $t0
jal multiply_recur
j mcDone

mrContinue:
beqz $a1, mrZero
addi $a1, $a1, -1 #Subtract 1 from y
add $s0, $s0, $a0 #Add x
jal multiply_recur
add $s0, $s0, $v0
j mcDone

mrZero:
move $v0, $s0

mcDone:
 
# EPILOGUE #
lw $ra, 0($sp)
lw $a0, 4($sp)
lw $a1, 8($sp)
lw $s0, 12($sp)

addi $sp, $sp, 16
# ######## # 

######Your code ends here#######
jr $ra
#############################

main:
li $a0, 4
li $a1, 5
jal multiply_recur
move $a0, $v0

li $v0, 1
syscall

_end:
#end program
li $v0, 10
syscall
