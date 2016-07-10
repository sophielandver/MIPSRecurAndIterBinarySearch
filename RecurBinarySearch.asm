#Sophie Landver

.data
	my_array: .word 1, 4, 5, 7, 9, 12, 15, 18, 20, 21, 30      #setting up my_array variable
	array_size: .word 11                                       #setting up array_size variable 

.text                                                          #text section
.globl main                                                    #global main

main:
	la $s0 my_array 		#load base address of my_array into $s0 
	lw $s1 array_size		#load size of my_array into $s1

	#setting arguments up
	add $a0, $0, $s0		#put base address in $a0
	addi $a1, $0, 7			#put target in $a1
	add $a2, $0, $0			#put starting index=0 in $a2 (low)
	addi $a3, $s1, -1 		#put ending index=(size-1) in $a3 (high)

	jal binary_search       #call binary_search function
	add $s2, $0, $v0		#put index that function returned in $s2

	#setting arguments up
	add $a0, $0, $s0		#put base address in $a0
	add $a1, $0, 21			#put target in $a1
	add $a2, $0, $0			#put starting index=0 in $a2 (low)
	addi $a3, $s1, -1 		#put ending index =(size-1) in $a3 (high)

	jal binary_search       #call binary_search function
	add $s3, $0, $v0		#put index that function returned in $s1

	j exit					#exit, done


	binary_search:
		addi $sp, $sp, -4       #adjust stack pointer
		sw $ra, 0($sp)        	#save return address on stack

		slt $t0, $a3, $a2		#$t0=(high<low)
		beq $t0, $0, INITIALIZE	#if (!(high<low)) go to INITIALZE
		#if here high<low
		addi $v0, $0, -1 		#set return value to -1
		lw $ra, 0($sp)			#restore return address from stack 
		addi $sp, $sp, 4        #adjust stack pointer
        jr $ra                  #jump to caller return address

        INITIALIZE: 
       	add $t3, $a2, $a3		#mid = low+high
    	srl $t3, $t3, 1 		#mid = mid/2 (so mid = (low+high)/2) 

    	sll $t4, $t3, 2 		#offset = mid*4
    	add $t6, $a0, $t4		#$t6 = base address + offset
    	lw $t5, 0($t6)			#$t5 = my_array[mid]
    	
    	slt $t2, $t5, $a1		#$t2 = (my_array[mid] < x)
    	beq $t2, $0, ELSEIF 	#if $t2 = 0 go to ELSEIF
    	#if here means my_array[mid]<x
    	#update low argument
    	addi $a2, $t3, 1 		#low=mid+1
    	jal binary_search       #recursive call to binary_search function
    	lw $ra, 0($sp)			#restore return address from stack 
    	addi $sp, $sp, 4        #adjust stack pointer
    	jr $ra                  #jump to return address

    	ELSEIF:
    		slt $t2, $a1, $t5		#$t2 = (x < my_array[mid])
    		beq $t2, $0, ELSE 		#if $t2=0 go to ELSE
    		#if here means x<my_array[mid]
    		#update high argument
    		addi $a3, $t3, -1 		#high = mid-1
    		jal binary_search       #recursive call to binary_search function
    		lw $ra, 0($sp)			#restore return address from stack
    		addi $sp, $sp, 4        #adjust stack pointer
    		jr $ra                  #jump to return address

    	ELSE:
    		#if here x=my_array[mid] 
    		add $v0, $0, $t3 		#set return value to mid
    		lw $ra, 0($sp)			#restore return address from stack
    		addi $sp, $sp, 4        #adjust stack pointer
    		jr $ra                  #jump to return address

    	 

exit: 
	addi $v0, $0, 10               #set $v0=10
	syscall                        #system call

