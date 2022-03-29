.globl classify

.text
classify:
    # =====================================
    # COMMAND LINE ARGUMENTS
    # =====================================
    # Args:
    #   a0 (int)    argc
    #   a1 (char**) argv
    #   a2 (int)    print_classification, if this is zero,
    #               you should print the classification. Otherwise,
    #               this function should not print ANYTHING.
    # Returns:
    #   a0 (int)    Classification
    # Exceptions:
    # - If there are an incorrect number of command line args,
    #   this function terminates the program with exit code 72
    # - If malloc fails, this function terminates the program with exit code 88
    #
    # Usage:
    #   main.s <M0_PATH> <M1_PATH> <INPUT_PATH> <OUTPUT_PATH>

    li t0, 5
    bne a0, t0, inc_args

    #save a bunch of shit kms 
    addi sp, sp, -52
    sw s0, 0(sp)
    sw s1, 4(sp)
    sw s2, 8(sp)
    sw s3, 16(sp)
    sw s4, 20(sp)
    sw s5, 24(sp)
    sw s6, 28(sp)
    sw s7, 32(sp)
    sw s8, 36(sp)
    sw s9, 40(sp)
    sw s10, 44(sp)
    sw s11, 48(sp)
    sw ra, 12(sp)

    #put the fucking arguments 
    mv s0, a0
    mv s1, a1 
    mv s2, a2 


	# =====================================
    # LOAD MATRICES
    # =====================================

    # Load pretrained m0
    li a0, 8
    jal malloc 

    mv a1, a0
    mv s4, a0
    addi a0, a0, 4
    mv a2, a0
    mv s5, a0

    lw a0, 4(s1) 

    jal read_matrix
    
    mv s3, a0
    
    # Load pretrained m1

    li a0, 8
    jal malloc 

    mv a1, a0
    mv s7, a0
    addi a0, a0, 4
    mv a2, a0
    mv s8, a0
    lw a0, 8(s1) 

    jal read_matrix
    
    mv s6, a0

    # Load input matrix

    li a0, 8
    jal malloc 
    
    mv a1, a0
    mv s10, a0
    addi a0, a0, 4
    mv a2, a0
    mv s11, a0
    
    lw a0, 12(s1) 

    jal read_matrix
    
    mv s9, a0


    # =====================================
    # RUN LAYERS
    # =====================================
    # 1. LINEAR LAYER:    m0 * input
    # 2. NONLINEAR LAYER: ReLU(m0 * input)
    # 3. LINEAR LAYER:    m1 * ReLU(m0 * input)

    lw t0, 0(s4)
    lw t1, 0(s11)
    mul t2, t1, t0
    li t0, 4
    mul t2, t2, t0 

    mv a0, t2 

    jal malloc 
    beq a0, x0, malloc_failed

    mv s0, a0
    mv a6, a0 
    mv a0, s3
    lw a1, 0(s4)
    lw a2, 0(s5)
    mv a3, s9
    lw a4, 0(s10)
    lw a5, 0(s11)

    jal matmul

    mv a0, s0

    lw t0, 0(s4)
    lw t1, 0(s11)
    mul t2, t1, t0

    mv a1, t2


    jal relu


    #row size of output matrix 
    lw t3, 0(s7)
    lw t4, 0(s11)

    #t1 is size of column output matrix

    #malloc memory for o
    mul t5, t3, t4
    li t0, 4
    mul t5, t5, t0
    mv a0, t5 
    
    jal malloc
    beq a0, x0, malloc_failed


    mv a6, a0
    mv t6, a6
    mv a0, s6
    lw a1, 0(s7)
    lw a2, 0(s8)
    mv a3, s0
    lw a4, 0(s4)
    lw a5, 0(s11)

    addi sp, sp, -4
    sw t6, 0(sp)

    jal matmul


    # =====================================
    # WRITE OUTPUT
    # =====================================
    # Write output matrix

    # t3 is rows t1 is columns
    lw t6, 0(sp)
    addi sp, sp, 4

    lw a0, 16(s1)
    mv a1, t6
    lw a2, 0(s7)
    lw a3, 0(s11)

    addi sp, sp, -4
    sw t6, 0(sp)

    jal write_matrix

    lw t6, 0(sp)
    addi sp, sp, 4

    # =====================================
    # CALCULATE CLASSIFICATION/LABEL
    # =====================================
    # Call argmax
    

    mv a0, t6
   
    lw t3, 0(s7)
    lw t4, 0(s11)

    mul t5, t3, t4
    mv a1, t5

    addi sp, sp, -4
    sw t6, 0(sp)

    jal argmax

    lw t6, 0(sp)
    addi sp, sp, 4

    mv a1, a0
    mv t0, a0

   

    addi sp, sp, -4
    sw t0, 0(sp)

    addi sp, sp, -4
    sw t6, 0(sp)
    beq s2, x0, print
    
    j done


    # Print classificatio



    # Print newline afterwards for clarity

done:
    lw t6, 0(sp)
    addi sp, sp, 4

    mv a0, t6
    jal free

    mv a0, s0 
    jal free

    mv a0, s3 
    jal free

    mv a0, s4
    jal free 

    mv a0, s6
    jal free

    mv a0, s7
    jal free

    mv a0, s9
    jal free

    mv a0, s10
    jal free

   
    lw t0, 0(sp)
    addi sp, sp, 4
    mv a0, t0

    lw s0, 0(sp)
    lw s1, 4(sp)
    lw s2, 8(sp)
    lw s3, 16(sp)
    lw s4, 20(sp)
    lw s5, 24(sp)
    lw s6, 28(sp)
    lw s7, 32(sp)
    lw s8, 36(sp)
    lw s9, 40(sp)
    lw s10, 44(sp)
    lw s11, 48(sp)
    lw ra, 12(sp)
    addi sp, sp, 52   
    
    ret

malloc_failed: 
    li a1, 88  
    call exit2

inc_args:
    li a1, 72
    call exit2

print:
    jal print_int
    addi a1, x0, '\n'
    jal print_char
    j done