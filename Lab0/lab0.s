.data

.text
main:
# Calculating the sum of range [1, 6]

# range
li $t4, 6
# sum
move $t5, $0



### Your code starts here: (Just uncomment the following instructions)


inc:
add $t5, $t5, $t4
addi $t4, $t4, -1
bgt $t4, 0, inc  


### Your code ends here



# Print the results
li $v0, 1
move $a0, $t5
syscall


_end:
# end program
li $v0, 10
syscall
