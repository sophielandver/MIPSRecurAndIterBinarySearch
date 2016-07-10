#Sophie Landver

.data                                                          #data section
	my_array: .word 1, 4, 5, 7, 9, 12, 15, 18, 20, 21, 30      #setting up my_array variable
	array_size: .word 11                                       #setting up array_size variable 

.text                                                          #text section
.globl main                                                    #global main 

main:                       #main function 
	la $s0 my_array 		#load base address of my_array into $s0 
	lw $s1 array_size		#load size of my_array into $s1

###################################
	addi $s2, $0, 15		#$s2=element searching array for
	#setting arguments up
	add $a0, $0, $s0		#put base address of my_array in $a0
	add $a1, $0, $s1		#put size of array in $a1
	add $a2, $0, $s2		#put element searching for in $a2

	jal binary_search		#call subroutine binary_search
	add $s3, $0, $v0		#put index that fuction returned in $s3
####################################

####################################
	addi $s2, $0, 4         #$s2=element searching array for
	#setting arguments up
	add $a2, $0, $s2		#put element searching for in $a2

	jal binary_search		#call subroutine binary_search
	add $s4, $0, $v0		#put index that fuction returned in $s4
####################################

#####################################
	addi $s2, $0, 30		#$s2=element searching array for
	#setting arguments up
	add $a2, $0, $s2		#put element searching for in $a2

	jal binary_search		#call subroutine binary_search
	add $s5, $0, $v0		#put index that fuction returned in $s5
######################################

######################################
	addi $s2, $0, 0 		#$s2=element searching array for
	#setting arguments up
	add $a2, $0, $s2		#put element searching for in $a2

	jal binary_search		#call subroutine binary_search
	add $s6, $0, $v0		#put index that fuction returned in $s6
	j exit 					#exit, done 
#######################################


binary_search:
    add $t0, $0, $0		#low = 0
    addi $t1, $a1, -1 	#high = size-1

    LOOP:
    	slt $t2, $t1, $t0		#$t2=(high<low)
    	bne $t2, $0, LOOPDONE		#if (high<low) go to LOOPDONE
    	add $t3, $t0, $t1		#mid = low+high
    	srl $t3, $t3, 1 		#mid = mid/2 (so mid = (low+high)/2) 
    	sll $t4, $t3, 2 		#offset = mid*4
    	add $t6, $a0, $t4		#$t6 = base address + offset
    	lw $t5, 0($t6)			#$t5 = my_array[mid]
    	
    	slt $t2, $t5, $a2		#$t2 = (my_array[mid] < element_searching_for)
    	beq $t2, $0, ELSEIF 	#if $t2 = 0 go to ELSEIF
    	#if here means my_array[mid]<x
    	addi $t0, $t3, 1 		#low = mid +1
    	j CONDITIONALDONE       #jump over the else if and else sections

    	ELSEIF:
    		slt $t2, $a2, $t5		#$t2 = (element_searching_for < my_array[mid])
    		beq $t2, $0, ELSE 		#if $t2=0 go to ELSE
    		#if here means x<my_array[mid]
    		addi $t1, $t3, -1 		#high = mid - 1
    		j CONDITIONALDONE       #jump over the else section

    	ELSE:
    		add $v0, $0, $t3	#put mid index in return register 
    		jr $ra				#jump back to caller return address 

    	CONDITIONALDONE:
    		j LOOP              #jump up to LOOP

   LOOPDONE:
   		addi $v0, $0, -1 		#put -1 in return register 
   		jr $ra                  #jump to return address 

exit: 
	addi $v0, $0, 10           #set $v0=10
	syscall                    #system call

