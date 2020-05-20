#                                           ICS 51, Lab #2
# 
#                                          IMPORTATNT NOTES:
# 
#                       Write your assembly code only in the marked blocks.
# 
#                       DO NOT change anything outside the marked blocks.
#
#
j main
###############################################################
#                           Data Section
.data

new_line: .asciiz "\n"
space: .asciiz " "

fibonacci_label: .asciiz "\nTesting Fibonacci: fib(5), fib(7), fib(10)\n"
changecase_label: .asciiz "\nTesting Change Case: \n"
bcd_2_bin_lbl: .asciiz "\nBCD to Binary (Hexadecimal Values)\nExpected output:\n004CEF64 00BC614E 00008AE0\nObtained output:\n"
change_case_expected_output: .asciiz "Expected output:\nCashRulesEveryTHINGAroundMe\nObtained output:\n"
fibonacci_lbl: 	.asciiz "Expected output:\n5 13 55\nObtained output:\n"

change_case_input: .asciiz "cA+SH$$$___rU*LE S^^eVE@RY~~th~ing_aRO=/[]UND_mE:|"
change_case_output: .asciiz "cA+SH$$$___rU*LE S^^eVE@RY~~th~ing_aRO=/[]UND_mE:|"

bcd_2_bin_test_data: .word 0x05042020, 0x12345678, 0x35552

hex_digits: .byte '0','1','2','3','4','5','6','7','8','9','A','B','C','D','E','F'

fib_array: 
	.space	48

###############################################################
#                           Text Section
.text
# Utility function to print hexadecimal numbers
print_hex:
move $t0, $a0
li $t1, 8 # digits
lui $t2, 0xf000 # mask
mask_and_print:
# print last hex digit
and $t4, $t0, $t2 
srl $t4, $t4, 28
la    $t3, hex_digits  
add   $t3, $t3, $t4 
lb    $a0, 0($t3)            
li    $v0, 11                
syscall 
# shift 4 times
sll $t0, $t0, 4
addi $t1, $t1, -1
bgtz $t1, mask_and_print
exit:
jr $ra

###############################################################
###############################################################
###############################################################
#                            PART 1 (BCD to Binary)
# 
# You are given a 32-bits integer stored in $t0. This 32-bits
# present a BCD number. You need to convert it to a binary number.
# For example: 0x7654_3210 should return 0x48FF4EA.
# The result must be stored inside $t0 as well.
bcd2bin:
move $t0, $a0
############################ Part 1: your code begins here ###



############################ Part 1: your code ends here ###
move $v0, $t0
jr $ra

###############################################################
###############################################################
###############################################################
#                            PART 2 (Fibonacci)
#
# 	The Fibonacci Sequence is the series of integer numbers:
#
#		0, 1, 1, 2, 3, 5, 8, 13, 21, 34, ...

#	The next number is found by adding up the two numbers before it.
	
#	The 2 is found by adding the two numbers before it (1+1)
#	The 3 is found by adding the two numbers before it (1+2),
#	And the 5 is (2+3),
#	and so on!
#
# You should compute the 12 integer elements of fibonacci and put
# in array. The base address of this array is in $a0.
# 
fibonacci:
la $a0, fib_array
############################## Part 2: your code begins here ###

li $t0, 0
sw $t0, ($a0)
li $t0, 1
addi $a0, $a0, 4
sw $t0, ($a0)
addi $a0, $a0, 4

#Counter
li $t0, 2

fibLoop:
beq $t0, 12, fibLoopDone

lw $t1, -4($a0)
lw $t2, -8($a0)

add $t3, $t1, $t2

sw $t3, ($a0)

addi $a0, $a0, 4
addi $t0, $t0, 1

j fibLoop

fibLoopDone:

############################## Part 2: your code ends here   ###
jr $ra

###############################################################
###############################################################
###############################################################
#                       PART 3 (Change Case)
#a0: The base address of the input array
#a1: The base address of the output array
###############################################################
change_case:
############################## Part 3: your code begins here ###

caseLoop:
lb $t0, ($a0)

beqz $t0, caseLoopDone

	blt $t0, 65, caseLoopNext
	
	bgt $t0, 122, caseLoopNext
	
	blt $t0, 91, isUpper
		blt $t0, 97, caseLoopNext
		
	isLower:
	addi $t0, $t0, -32
	sb $t0, ($a1)
	addi $a1, $a1, 1
	j caseLoopNext
	
	isUpper:
	addi $t0, $t0, 32
	sb $t0, ($a1)
	addi $a1, $a1, 1
	j caseLoopNext
	
	caseLoopNext:
	addi $a0, $a0, 1
	j caseLoop
	
caseLoopDone:
li $t0, 0
sb $t0, ($a1)

############################## Part 3: your code ends here ###
jr $ra

###############################################################
###############################################################
###############################################################


#                          Main Function 
.globl main
main:
##############################################
##############################################
li $v0, 4
la $a0, new_line
syscall
la $a0, bcd_2_bin_lbl
syscall

# Testing part 1
li $s0, 3 # num of test cases
li $s1, 0
la $s2, bcd_2_bin_test_data

test_p1:
add $s4, $s2, $s1
# Pass input parameter
lw $a0, 0($s4)
jal bcd2bin

move $a0, $v0        # hex to print
jal print_hex

li $v0, 4
la $a0, space
syscall

addi $s1, $s1, 4
addi $s0, $s0, -1
bgtz $s0, test_p1

##############################################
##############################################
test_fibonacci:
li $v0, 4
la $a0, new_line
syscall
la $a0, fibonacci_label
syscall
jal fibonacci

li $v0, 4
la $a0, fibonacci_lbl
syscall

la $s0, fib_array

li $v0, 1
lw $a0, 20($s0)
syscall

li $v0, 4
la $a0, space
syscall

li $v0, 1
lw $a0, 28($s0)
syscall

li $v0, 4
la $a0, space
syscall

li $v0, 1
lw $a0, 40($s0)
syscall

###############################################################
###############################################################
# Test Change case function

li $v0, 4
la $a0, new_line
syscall
la $a0, changecase_label
syscall
# call the function
la $a0, change_case_input
la $a1, change_case_output
jal change_case
# print results
la $a0, change_case_expected_output
syscall
la $a0, change_case_output
syscall
la $a0, new_line
syscall

_end:
# end program
li $v0, 10
syscall

