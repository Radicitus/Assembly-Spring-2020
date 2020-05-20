#                                           ICS 51, Lab #1
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
# 


new_line: .asciiz "\n"
space: .asciiz " "
triple_range_lbl: .asciiz "\nTrible range (Decimal Values) \nExpected output:\n240000 0 -300\nObtained output:\n"
swap_bits_lbl: .asciiz "\nSwap bits (Hexadecimal Values)\nExpected output:\n55555555 02138A9B FDEC7564\nObtained output:\n"
count_ones_lbl: .asciiz "\nCount ones \nExpected output:\n16 12 20\nObtained output:\n"

swap_bits_test_data:  .word 0xAAAAAAAA, 0x01234567, 0xFEDCBA98
swap_bits_expected_data:  .word 0x55555555, 0x02138A9B, 0xFDEC7564

triple_range_test_data: .word 80000, 111, 0, -111, 11
triple_range_expected_data: .word 240000, 0, -300

hex_digits: .byte '0','1','2','3','4','5','6','7','8','9','A','B','C','D','E','F'

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
#                            PART 1 (Count Bits)
# 
# You are given an 32-bits integer stored in $t0. Count the number of 1's
#in the given number. For example: 1111 0000 should return 4
count_ones:
move $t0, $a0
############################## Part 1: your code begins here ###

#Bit counter var
li $t1, 0
#Ones counter var
li $t2, 0

COloopStart:
beq $t1, 32, COloopDone

    #Query the first bit
    andi $t3, $t0, 00000001
    beqz $t3, COloopShift
    
    #Add to the ones counter
    addi $t2, $t2, 1
    
    #Shift the bits to the right 
    COloopShift:
         srl $t0, $t0, 1
         addi $t1, $t1, 1
         j COloopStart

#Complete loop
COloopDone:
move $t0, $t2
          
############################## Part 1: your code ends here ###
move $v0, $t0
jr $ra

###############################################################
###############################################################
###############################################################
###############################################################
###############################################################
###############################################################
#                            PART 2 (Swap Bits)
# 
# You are given an 32-bits integer stored in $t0. You need swap the bits
# at odd and even positions. i.e. b31 <-> b30, b29 <-> b28, ... , b1 <-> b0
# The result must be stored inside $t0 as well.
swap_bits:
move $t0, $a0 
############################## Part 2: your code begins here ###

#Store all even bits
andi $t1, $t0, 0xaaaaaaaa

#Store all odd bits
andi $t2, $t0, 0x55555555

#Shoft all even bits to the right
srl $t1, $t1, 1

#Shift all odd bits to the left
sll $t2, $t2, 1

#Add the shifted bits back together
add $t0, $t1, $t2

############################## Part 2: your code ends here ###
move $v0, $t0
jr $ra

###############################################################
###############################################################
###############################################################
#                           PART 3
# 
# You are given three integers. You need to find the smallest 
# one and the largest one and multiply their sum by three and return it.
# 
# Implementation details:
# The three integers are stored in registers $t0, $t1, and $t2. You 
# need to store the answer into register $t0. It will be returned by the
# function to the caller.

triple_range:
move $t0, $a0
move $t1, $a1
move $t2, $a2
############################### Part 3: your code begins here ##
#Set Min num
li $t3, 2147483647
#Set Max num
li $t4, -2147483648

#Set new max/min
    #Val 1
    VAL1Max:
         blt $t0, $t4, VAL1Min
         #Set max num
         move $t4, $t0 
    VAL1Min:
         bgt $t0, $t3, VAL2Max
         #Set min num
         move $t3, $t0
         
    #Val 2
    VAL2Max:
         blt $t1, $t4, VAL2Min
         #Set max num
         move $t4, $t1 
    VAL2Min:
         bgt $t1, $t3, VAL3Max
         #Set min num
         move $t3, $t1
         
    #Val 3
    VAL3Max:
         blt $t2, $t4, VAL3Min
         #Set max num
         move $t4, $t2 
    VAL3Min:
         bgt $t2, $t3, VALMultSum
         #Set min num
         move $t3, $t2
    
#Multiply and sum
    VALMultSum:
    #Add together
    add $t0, $t3, $t4
    #Multiply by 3
    mul $t0, $t0, 3

############################### Part 3: your code ends here  ##
move $v0, $t0
jr $ra

###############################################################
###############################################################
###############################################################
#                          Main Function 
main:

li $v0, 4
la $a0, new_line
syscall
la $a0, count_ones_lbl
syscall

# Testing part 2
li $s0, 3 # num of test cases
li $s1, 0
la $s2, swap_bits_test_data

test_p1:
add $s4, $s2, $s1
# Pass input parameter
lw $a0, 0($s4)
jal count_ones

move $a0, $v0        # $integer to print
li $v0, 1
syscall

li $v0, 4
la $a0, space
syscall

addi $s1, $s1, 4
addi $s0, $s0, -1
bgtz $s0, test_p1

li $v0, 4
la $a0, new_line
syscall
la $a0, swap_bits_lbl
syscall

# Testing part 2
li $s0, 3 # num of test cases
li $s1, 0
la $s2, swap_bits_test_data

test_p2:
add $s4, $s2, $s1
# Pass input parameter
lw $a0, 0($s4)
jal swap_bits

move $a0, $v0
jal print_hex
li $v0, 4
la $a0, space
syscall

addi $s1, $s1, 4
addi $s0, $s0, -1
bgtz $s0, test_p2

li $v0, 4
la $a0, new_line
syscall
la $a0, triple_range_lbl
syscall


# Testing part 3
li $s0, 3 # num of test cases
li $s1, 0
la $s2, triple_range_test_data

test_p3:
add $s4, $s2, $s1
# Pass input parameter
lw $a0, 0($s4)
lw $a1, 4($s4)
lw $a2, 8($s4)
jal triple_range

move $a0, $v0        # $integer to print
li $v0, 1
syscall

li $v0, 4
la $a0, space
syscall

addi $s1, $s1, 4
addi $s0, $s0, -1
bgtz $s0, test_p3

_end:
# end program
li $v0, 10
syscall

