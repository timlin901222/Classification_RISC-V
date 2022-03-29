.globl read_matrix

.text
# ==============================================================================
# FUNCTION: Allocates memory and reads in a binary file as a matrix of integers
#
# FILE FORMAT:
#   The first 8 bytes are two 4 byte ints representing the # of rows and columns
#   in the matrix. Every 4 bytes afterwards is an element of the matrix in
#   row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is a pointer to an integer, we will set it to the number of rows
#   a2 (int*)  is a pointer to an integer, we will set it to the number of columns
# Returns:
#   a0 (int*)  is the pointer to the matrix in memory
# Exceptions:
# - If malloc returns an error,
#   this function terminates the program with error code 88
# - If you receive an fopen error or eof,
#   this function terminates the program with error code 89
# - If you receive an fclose error or eof,
#   this function terminates the program with error code 90
# - If you receive an fread error or eof,
#   this function terminates the program with error code 91
# ==============================================================================
read_matrix:

    addi sp, sp, -28
    sw s0, 0(sp)
    sw s1, 4(sp)
    sw s2, 8(sp)
    sw ra, 12(sp)
    sw s4, 16(sp)
    sw s5, 20(sp)
    sw s3, 24(sp)

    # Prologue
    mv s4, a1
    mv s5, a2

    #open the file with read permisiions

    #move the arguments
    mv a1, a0
    li a2, 0

  
    #call fopen with read perm
    jal ra fopen 

   

    li t0, -1
    beq a0, t0, fopen_failed
    #fread the file 

    mv s0, a0

    
    #malloc 8 bytes for 2 numbers
    li a0, 8

   

    jal ra malloc 
    #mv malloced location to a2



    beq a0, x0, malloc_failed
    mv a2, a0
    mv s3, a2
    li a3, 8

   #move the Arguments
    mv a1, s0

    jal ra fread 

   
    li a3, 8

    bne a0, a3, fread_failed


    lw t0, 0(s3)
    lw t1, 4(s3)


    mul t2, t0, t1
    li t3, 4
    mul t2, t2, t3

    #t2 is the number of bytes to malloc 
    addi sp, sp, -8
    sw t0, 0(sp)
    sw t1, 4(sp)

    mv s1, t2

    mv a0, t2
    jal ra malloc

    # s0 is the file descriptor, s1 is the number of bytes
  

    beq a0, x0, malloc_failed

    #move arguments to their correct locations
    mv a1, s0 
    mv a2, a0
    mv a3, s1 

    mv s2, a0

    jal ra fread 

    bne a0, s1, fread_failed

    mv a1, s0 

    jal ra fclose 

  

    li t3, -1
    beq a0, t3, fclose_failed

    mv a0, s2

    lw t0, 0(sp)
    lw t1, 4(sp)
    addi sp, sp, 8


    sw t0, 0(s4)
    sw t1, 0(s5)

    lw s0, 0(sp)
    lw s1, 4(sp)
    lw s2, 8(sp)
    lw ra, 12(sp)
    lw s4, 16(sp)
    lw s5, 20(sp)
    lw s3, 24(sp)
    addi sp, sp, 28
    ret

malloc_failed:
    li a1, 88
    call exit2
fopen_failed:
    li a1, 89
    call exit2
fread_failed:
    li a1, 91
    call exit2

fclose_failed:
    li a1, 90
    call exit2