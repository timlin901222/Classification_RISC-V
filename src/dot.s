.globl dot

.text
# =======================================================
# FUNCTION: Dot product of 2 int vectors
# Arguments:
#   a0 (int*) is the pointer to the start of v0
#   a1 (int*) is the pointer to the start of v1
#   a2 (int)  is the length of the vectors
#   a3 (int)  is the stride of v0
#   a4 (int)  is the stride of v1
# Returns:
#   a0 (int)  is the dot product of v0 and v1
# Exceptions:
# - If the length of the vector is less than 1,
#   this function terminates the program with error code 57
# - If the stride of either vector is less than 1,
#   this function terminates the program with error code 58
# =======================================================
dot:

    # Prologue
    li t0, 1
    blt a2, t0, error1
    addi t0, x0, 1
    blt a3, t0, error2
    blt a4, t0, error2
    j loop_start


loop_start:
    lw t3, 0(a0)
    lw t4, 0(a1)
    mul t2, t3, t4
    addi a2, a2, -1
    addi t0, x0, 4
    addi t1, x0, 4
    mul t0, t0, a3
    mul t1, t1, a4
    add a0, a0, t0
    add a1, a1, t1
    j loop_continue


loop_continue:
    beq a2, x0, loop_end
    lw t3, 0(a0)
    lw t4, 0(a1)
    mul t5, t3, t4
    add t2, t2, t5
    addi a2, a2, -1
    add a0, a0, t0
    add a1, a1, t1
    j loop_continue
    
   
loop_end:
    mv a0, t2
    # Epilogue
    ret

error1:
    li a1, 57
    call exit2
error2:
    li a1, 58
    call exit2

