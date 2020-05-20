#                         ICS 51, Lab #3
#
#      IMPORTANT NOTES:
#
#      Write your assembly code only in the marked blocks.
#
#      DO NOT change anything outside the marked blocks.
#
###############################################################
#                           Data Section
j main
.data

new_line: .asciiz "\n"
space: .asciiz " "
i_str: .asciiz "Program input: " 
po_str: .asciiz "Obtained output: " 
eo_str: .asciiz "Expected output: "
t2_str: .asciiz "Testing fibonacci_recur: \n"
t3_str: .asciiz "Testing GCD: \n"
dump_str: .asciiz "Testing dump_file: \n" 

num_numeric_tests:          .word 8

numerical_inputs:           .word       0, 1, 2, 3, 6, 9 , 10, 13
fibonacci_recur_expected_outputs: .word 0, 1, 1, 2, 8, 34, 55, 233

gcd_inputs:                 .word 1, 12, 4, 79322, 1378, 75, 28300, 74000
gcd_expected_outputs:       .word     1, 4,     2,     2, 1,     25,  100 

file_read_lbl1: .asciiz "\nI love ics 51.\nI am so glad that I am taking ics 51..\n"
file_read_lbl2:	.asciiz	"And I love assembly language even more than java or c or pyhton...\n"
file_read_lbl3: .asciiz "Because it is such fun....:D)\n4\n"

file_name:
	.asciiz	"lab3_data.dat"	# File name
	.word	0
read_buffer:
	.space	300			# Place to store character


###############################################################
#                           Text Section
.text
# Utility function to print integer arrays
#a0: array
#a1: length
print_array:

li $t1, 0
move $t2, $a0
print:

lw $a0, ($t2)
li $v0, 1   
syscall

li $v0, 4
la $a0, space
syscall

addi $t2, $t2, 4
addi $t1, $t1, 1
blt $t1, $a1, print
jr $ra

###############################################################
###############################################################
###############################################################
#                           PART 1 (Fibonacci_recur)
#a0: input number
###############################################################
fibonacci_recur:
############################### Part 1: your code begins here ##

###################
# PROLOUGUE START #
addi $sp, $sp, -12 #Move stack pointer down by 8
sw $ra, 0($sp)
sw $a0, 4($sp) #Store input x
sw $s0, 8($sp) #Store returned value
###################

#Set $s0 to 0
li $s0, 0

checkFibZero:
bnez $a0, checkFibOne #Check if argument is 0
li $v0, 0 #Set return register to 0
j fibDone

checkFibOne:
bne $a0, 1, continueFib #Check if argument is 1
li $v0, 1 #Set return register to 1
j fibDone

continueFib:
addi $a0, $a0, -1 #Subract 1 from $a0
jal fibonacci_recur #x-1 fibonacci with $a0
add $s0, $s0, $v0 #Add return val to $s0
 
addi $a0, $a0, -1 #Subract 1 from $a0
jal fibonacci_recur #x-2 fibonacci with $a0
add $s0, $s0, $v0 #Add return val to $s0

move $v0, $s0

fibDone:

################
# PROLOGUE END #
lw $ra, 0($sp)
lw $a0, 4($sp)
lw $s0, 8($sp)
addi $sp, $sp, 12 #Move stack pointer up by 12
################


############################### Part 1: your code ends here  ##
jr $ra

###############################################################
###############################################################
###############################################################
#                           PART 2 (GCD)
#a0: input number
#a1: input number
###############################################################
gcd:
############################### Part 2: your code begins here ##

###################
# PROLOUGUE START #
addi $sp, $sp, -12 #Move stack pointer down by 8
sw $ra, 0($sp)
sw $a0, 4($sp) #Store input a
sw $a1, 8($sp) #Store input b
###################

bnez $a1, continueGCD
move $v0, $a0
j gcdDone

continueGCD:
    #Modulo Operator
    div $a0, $a1 #Divide
    move $a0, $a1 #Move b to a
    mfhi $a1 #Set b to quotient of mod
    jal gcd

gcdDone:

################
# PROLOGUE END #
lw $ra, 0($sp)
lw $a0, 4($sp)
sw $a1, 8($sp)
addi $sp, $sp, 12 #Move stack pointer up by 12
################

############################### Part 2: your code ends here  ##
jr $ra

###############################################################
###############################################################
###############################################################
#                           PART 3 (SYSCALL: read a file, print)
#
# You will read characters (bytes) from a file (lab3_data.dat) and print them.
# You should print strings of each line from the file and print number of lines read.
# file_name : the array that stores the file name
# read_buffer : the arrary that you use to hold string (MAXIMUM: 300 bytes)
#
dump_file:
############################### Part 3: your code begins here ##

#Open the file
    #Prep for opening file
    li $v0, 13 #Syscall for opening file
    la $a0, file_name #File to read from
    li $a1, 0
    li $a2, 0
    syscall
    #Save file descriptor
    move $s6, $v0
    
#Read lines
    li $t0, 0 #Number of lines read

    #Read characters from file until buffer full
    readFile:
    li $v0, 14 #Syscall for reading file
    move $a0, $s6 #Move file descriptor
    la $a1, read_buffer #Address of read buffer
    li $a2, 300 #Buffer length
    syscall

    #Check if EOF
    beqz $v0, closeFile

    #Read lines and count number of lines read
    readLine:
    la $t7, read_buffer #Load buffer address
    li $t8, 0 #Counter for buffer size
         
         readLineLoop:
              lb $t1, 0($t7) #Load character
         
              beq $t8, 300, readLineDone #Check if reach buffer size
         
              bne $t1, 10, readLineLoopContinue #Check if character is /n
              addi $t0, $t0, 1
              
              readLineLoopContinue:
              addi $t7, $t7, 1 #Increment buffer address
              addi $t8, $t8, 1 #Increment buffer size counter
              j readLineLoop
         
         readLineDone:
         #Print out buffer
         li $v0, 4
         la $a0, read_buffer
         syscall
         #Continue to read rest of file
         j readFile
    
#Close the file
closeFile:
li $v0, 16
move $a0, $s6
syscall

#Print out number of lines read
li $v0, 1
move $a0, $t0
syscall

############################### Part 3: your code ends here   ##
jr $ra

###############################################################
###############################################################
###############################################################

#                          Main Function
main:

###############################################################
# Test fibonacci_recur function
li $v0, 4
la $a0, t2_str
syscall

la $a0, i_str
syscall
li $s0, 0 # used to index current test input
la $s1, num_numeric_tests
lw $s1, 0($s1)  # number of tests
la $s2, numerical_inputs
move $a0, $s2
move $a1, $s1
jal print_array
la $a0, new_line
syscall


la $a0, eo_str
syscall
li $s0, 0 # used to index current test input
la $s1, num_numeric_tests
lw $s1, 0($s1)  # number of tests
la $s2, fibonacci_recur_expected_outputs
move $a0, $s2
move $a1, $s1
jal print_array
la $a0, new_line
syscall


la $a0, po_str
syscall

la $s2, numerical_inputs
test_fibonacci_recur:
bge $s0, $s1, end_test_fibonacci_recur
# call the function
lw $a0, 0($s2)
jal fibonacci_recur
# print results
move $a0, $v0
li $v0, 1   
syscall

li $v0, 4
la $a0, space
syscall

addi $s0, $s0, 1
addi $s2, $s2, 4
j test_fibonacci_recur


end_test_fibonacci_recur:
la $a0, new_line
syscall
syscall
###############################################################
# Test GCD function
li $v0, 4
la $a0, t3_str
syscall

la $a0, i_str
syscall
li $s0, 0 # used to index current test input
la $s1, num_numeric_tests
lw $s1, 0($s1)  # number of tests
la $s2, gcd_inputs
move $a0, $s2
move $a1, $s1
jal print_array
la $a0, new_line
syscall


la $a0, eo_str
syscall
li $s0, 0 # used to index current test input
la $s1, num_numeric_tests
lw $s1, 0($s1)  # number of tests
addi $s1, $s1, -1 # tests are in pairs
la $s2, gcd_expected_outputs
move $a0, $s2
move $a1, $s1
jal print_array
la $a0, new_line
syscall


la $a0, po_str
syscall

la $s2, gcd_inputs

test_gcd:
bge $s0, $s1, end_test_gcd
# call the function
lw $a0, 0($s2)
lw $a1, 4($s2)
jal gcd
# print results
move $a0, $v0
li $v0, 1   
syscall

li $v0, 4
la $a0, space
syscall

addi $s0, $s0, 1
addi $s2, $s2, 4
j test_gcd


end_test_gcd:
la $a0, new_line
syscall

###############################################################
# Test dump_file function
li $v0, 4
la $a0, new_line
syscall
la $a0, dump_str
syscall

la $a0, eo_str
syscall
la $a0, file_read_lbl1
syscall
la $a0, file_read_lbl2
syscall
la $a0, file_read_lbl3
syscall

la $a0, po_str
syscall
la $a0, new_line
syscall
jal dump_file

_end:
# end program
li $v0, 10
syscall
