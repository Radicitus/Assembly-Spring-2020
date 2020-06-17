j main
.data
input_4x4: .byte 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16
output_4x4: .space 16
expected_output_4x4: .byte 16, 15, 14, 13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1
.text

#####################
#a0: input buffer address
#a1: output buffer address
#a2: image dimension (Image will be square sized, i.e. total size = a2*a2)
#####################
rotation_180:
############## your code begins here #################
	
	mult $a2, $a2
	mflo $t0 
	addi $t0, $t0, -1 #Max pixel index
	
	li $t1, 0 #Row counter
	rotateLoopRow:
		beq $t1, $a2, rotateLoopDone
		
		li $t2, 0 #Col counter
		rotateLoopCol:
		
			beq $t2, $a2, rotateLoopRowNext
			
			#Calculate flipped index
			sub $t3, $t0, $t1 #Row index
			sub $t4, $t0, $t2 #Col index
			
			div $t3, $a2 #rIndex%iDimension
			mfhi $t3
			div $t4, $a2 #cIndex%iDimension
			mfhi $t4
			
			#Calculate offset
			mult $t3, $a2
			mflo $t3
			add $t3, $t3, $t4
			
			#Calculate output address
			add $t4, $t3, $a1
			
			#Store current value in flipped index
				
				#Load value at current index
				mult $t1, $a2
				mflo $t5
				add $t5, $t5, $t2
				add $t5, $t5, $a0
				
				lbu $t5, 0($t5) #Value at curIndex
				
				#Store value at flipped index
				sb $t5, 0($t4)
				
			#Increment
			addi $t2, $t2, 1
			j rotateLoopCol
			
		rotateLoopRowNext:
			addi $t1, $t1, 1
			j rotateLoopRow
			
	rotateLoopDone:
	
############## your code ends here ##################
jr $ra
#############################

main:
la $a0, input_4x4
la $a1, output_4x4
li $a2, 4
jal rotation_180

li $t0, 16
la $t1, output_4x4
print_4x4:
lbu $a0, ($t1)
li $v0, 1
syscall
li $v0, 11
li $a0, 32
syscall
addi $t0, $t0, -1
addi $t1, $t1, 1
bnez $t0, print_4x4

_end:
#end program
li $v0, 10
syscall