.globl relu

.text
# ==============================================================================
# FUNCTION: Performs an inplace element-wise ReLU on an array of ints
# Arguments:
# 	a0 (int*) is the pointer to the array
#	a1 (int)  is the # of elements in the array
# Returns:
#	None
# Exceptions:
# - If the length of the vector is less than 1,
#   this function terminates the program with error code 57
# ==============================================================================
relu:
    # Prologue
    li t0, 1
    blt a1, t0, error
loop_start:
	beq a1, x0, loop_end
    lw t1, 0(a0)
    blt t1, x0, change
    j loop_continue
loop_continue:
	addi a0, a0, 4
    addi a1, a1, -1
    j loop_start
loop_end:
    # Epilogue
	ret 
change:
	sw zero, 0(a0)
    j loop_start
error:
	li a1, 57
    call exit2