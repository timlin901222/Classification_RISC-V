.globl matmul

.text
# =======================================================
# FUNCTION: Matrix Multiplication of 2 integer matrices
# 	d = matmul(m0, m1)
# Arguments:
# 	a0 (int*)  is the pointer to the start of m0
#	a1 (int)   is the # of rows (height) of m0
#	a2 (int)   is the # of columns (width) of m0
#	a3 (int*)  is the pointer to the start of m1
# 	a4 (int)   is the # of rows (height) of m1
#	a5 (int)   is the # of columns (width) of m1
#	a6 (int*)  is the pointer to the the start of d
# Returns:
#	None (void), sets d = matmul(m0, m1)
# Exceptions:
#   Make sure to check in top to bottom order!
#   - If the dimensions of m0 do not make sense,
#     this function terminates the program with exit code 59
#   - If the dimensions of m1 do not make sense,
#     this function terminates the program with exit code 59
#   - If the dimensions of m0 and m1 don't match,
#     this function terminates the program with exit code 59
# =======================================================
matmul:

    # Error checks
    li t0, 1
    #check that dimensions are not 0
    blt a1, t0, error 
    blt a2, t0, error
    blt a4, t0, error
    blt a5, t0, error
    #check that dimensions match
    bne a2, a4, error
	
    addi sp, sp, -32
    sw ra, 0(sp)
    sw s0, 4(sp)
    sw s1, 8(sp)
    sw s2, 12(sp)
    sw s3, 16(sp)
    sw s4, 20(sp)
    sw s5, 24(sp)
    sw s6, 28(sp)


    # Prologue
    #initialize the fucking counter for outer loops goddamnit
    mv t0, x0
    #throw the arguments into callee saved s
    addi s0, a0, 0
    addi s1, a1, 0
    addi s2, a2, 0
    addi s3, a3, 0
    addi s4, a4, 0
    addi s5, a5, 0
    addi s6, a6, 0
    
 
    
    
    j outer_loop_start
    


outer_loop_start:
    #loop rows of the outer shit
    beq t0, s1, outer_loop_end

    #initialize for innerloop columns
    mv t1, x0
   	j inner_loop_start



inner_loop_start:  
    #loop columns of the inner pieces of blasphemy
    beq t1, s5, inner_loop_end
    #save a bunch of shit before we call do
    addi sp, sp, -36
    sw s0, 0(sp)
    sw s1, 4(sp)
    sw s2, 8(sp)
    sw s3, 12(sp)
    sw s4, 16(sp)
    sw s5, 20(sp)
    sw s6, 24(sp)
    sw t0, 28(sp)
    sw t1, 32(sp)
   
    
    #load arguments for dot
    #t2 temporary variable for vector length
    mv t2, s2
    #t3 stride length
    mv t3, s5
    
    
    mv a0, s0
    mv a1, s3
    mv a2, t2
    li a3, 1
    mv a4, t3
   
    #call dot
    jal ra, dot
    
    #move result to d
    sw a0, 0(s6)
    #might violate calling convention !!!
    
    #restore the shit we had before
    lw s0, 0(sp)
    lw s1, 4(sp)
    lw s2, 8(sp)
    lw s3, 12(sp)
    lw s4, 16(sp)
    lw s5, 20(sp)
    lw s6, 24(sp)
    lw t0, 28(sp)
    lw t1, 32(sp)
    addi sp, sp, 36
    
    #increment the pointer to d
    addi s6, s6, 4
    
    #increment the pointer to the second matrix
    addi s3, s3, 4
    
    #increment counter
    addi t1, t1, 1
    
    #recurse
    j inner_loop_start
    
inner_loop_end:
	#move the pointer to the second matrix back to the original position
    li t4, -4
    mul t4, t4, s5
    add s3, s3, t4
    
    #increment the outerloop counter by one
    addi t0, t0, 1
    
    #move the outer loop pointer by a2
    li t4, 4
    mul t4, t4, s2
    add s0, s0, t4
    
    j outer_loop_start




outer_loop_end:
	#move the pointer to the first matrix back
    
    
    
    
    
    #move the pointer to d back a1*a5*4
    #li t5, -4
    #mul s1, s1, s5
    #mul t5, t5, s1
    add a6, s6, x0
    
    

    # Epilogue
 	j done
   

error:
	li a1, 59
    call exit2
 
 #dot product 
dot:
    
    addi sp, sp, -4
    sw ra, 0(sp)

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
    lw ra, 0(sp)
    addi sp, sp, 4
    ret

error1:
    li a1, 57
    call exit2
error2:
    li a1, 58
    call exit2
    
done:
	lw ra, 0(sp)
    lw s0, 4(sp)
    lw s1, 8(sp)
    lw s2, 12(sp)
    lw s3, 16(sp)
    lw s4, 20(sp)
    lw s5, 24(sp)
    lw s6, 28(sp)
    addi sp, sp, 32
	ret