.globl write_matrix

.text
# ==============================================================================
# FUNCTION: Writes a matrix of integers into a binary file
# FILE FORMAT:
#   The first 8 bytes of the file will be two 4 byte ints representing the
#   numbers of rows and columns respectively. Every 4 bytes thereafter is an
#   element of the matrix in row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is the pointer to the start of the matrix in memory
#   a2 (int)   is the number of rows in the matrix
#   a3 (int)   is the number of columns in the matrix
# Returns:
#   None
# Exceptions:
# - If you receive an fopen error or eof,
#   this function terminates the program with error code 89
# - If you receive an fclose error or eof,
#   this function terminates the program with error code 90
# - If you receive an fwrite error or eof,
#   this function terminates the program with error code 92
# ==============================================================================
write_matrix:

    # Prologue
    #all the fucking bullshit saves and fuckery
    addi sp, sp, -24
    sw s0, 16(sp)
    sw s1, 0(sp)
    sw s2, 4(sp)
    sw s3, 8(sp)
    sw s4, 20(sp)
    sw ra, 12(sp)

    #fucking save all the fucking arguments bro
    mv s1, a1
    mv s2, a2
    mv s3, a3
    mul s4, s2, s3

    #load the arguments into fopen
    mv a1, a0
    li a2, 1

    jal fopen

    #check for errors
    li t0, -1
    beq a0, t0, fopen_failed

    mv s0, a0

    #store the columns and rows into a pointer 
    li a0, 8
    jal malloc 

    sw s2, 0(a0)
    sw s3, 4(a0)

    #fwrite row and column 
    mv a1, s0 
    mv a2, a0
    li a3, 2 
    li a4, 4 

    jal fwrite

    li t2, 2  
    bne a0, t2, fwrite_failed 

    #fwrite matrix 
    mv a1, s0 
    mv a2, s1
    mv a3, s4
    li a4, 4 

    jal fwrite

    bne a0, s4, fwrite_failed

    mv a1, s0 
    jal fclose 

    bne a0, x0, fclose_failed

    lw s0, 16(sp)
    lw s1, 0(sp)
    lw s2, 4(sp)
    lw s3, 8(sp)
    lw s4, 20(sp)
    lw ra, 12(sp)
    addi sp, sp, 24

    ret
    
fopen_failed:
    li a1, 89
    call exit2

fwrite_failed:
    li a1, 92
    call exit2
fclose_failed:
    li a1, 90
    call exit2
