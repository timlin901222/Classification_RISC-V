.globl argmax

.text
# =================================================================
# FUNCTION: Given a int vector, return the index of the largest
#	element. If there are multiple, return the one
#	with the smallest index.
# Arguments:
# 	a0 (int*) is the pointer to the start of the vector
#	a1 (int)  is the # of elements in the vector
# Returns:
#	a0 (int)  is the first index of the largest element
# Exceptions:
# - If the length of the vector is less than 1,
#   this function terminates the program with error code 57
# =================================================================
argmax:

    # Prologue

    li t0, 1
    blt a1, t0, error

    addi sp, sp, -4 
    sw ra, 0(sp)
    
    j loop_start
   


loop_start:
    # initialize counter (t0) to 0
    li t0, 0
    # load the first word into t1
    lw t1, 0(a0)
    # load the index into the return
    mv t3, t0

    # increment shit
    addi a0, a0, 4
    addi t0, t0, 1
    j loop_continue



loop_continue:
    # check the fking condition bro
    beq a1, t0, loop_end


    lw t2, 0(a0)
    beq t2, t1, equal
    bge t2, t1, change
    addi a0, a0, 4
    addi t0, t0, 1
    
    
    j loop_continue


loop_end:


    # Epilogue
    
    mv a0, t3
    lw ra, 0(sp)
    addi sp, sp, 4
    ret

error:
    li a1, 57
    call exit2
change:
	beq t1, t2, loop_continue
    mv t1, t2
    mv t3, t0
    addi a0, a0, 4
    addi t0, t0, 1
    j loop_continue
equal:
    addi a0, a0, 4
    addi t0, t0, 1
    
    
    j loop_continue



