.data
unorderedList: .word 13, 26, 44, 8, 16, 37, 23, 67, 90, 87, 29, 41, 14, 74, 39, -1

insertValues: .word 46, 85, 24, 25, 3, 33, 45, 52, 62, 17

space: .asciiz " "
newLine: .asciiz "\n"

#Gürcan Gül 260201069

####################################
#   4 Bytes - Value
#   4 Bytes - Address of Left Node
#   4 Bytes - Address of Right Node
#   4 Bytes - Address of Root Node
####################################

.text 
main:
	la $a0, unorderedList


	jal build
	move $s3, $v0

	move $a0, $s3
	jal print

	li $s0, 8
	li $s2, 0
	la $s1, insert
	insertLoopMain: 
		beq $s2, $s0, insertLoopMainDone

		lw $a0, ($s1)
		move $a1, $s3
		jal insert

		addi $s1, $s1, 4
		addi $s2, $s2, 1 
		b insertLoopMain

	insertLoopMainDone:

		move $a0, $s3
		jal print


		move $a0, $s3
		jal remove


		move $a0, $s3
		jal print


		li $v0, 10
		syscall 


########################################################################
# Write your code after this line
########################################################################


####################################
# Build Procedure
####################################
build:
	la $a3, unorderedList
	move $t1, $a3
	lw $t4, 0($t1)	 #first element of list to a temp register
	li $a0, 16
	li $v0, 9
	syscall
	move $s0, $v0
	move $s1, $v0	#this address won't change, it will return
	sw $t4, 0($s0)	#write t4(first element of the list) to first node of s0

	move $t9, $ra	#store $ra

	insertNodes: 
		addi $t1, $t1, 4	# get the next address of list
		lw $t4, 0($t1)		# load current element to t4
		beq $t4, -1, returnMain		#if the element is -1, exit the program
		move $a0, $t4		#moving the value to a0
		jal insert		#jump insert
		j insertNodes		

####################################
# Insert Procedure
####################################
insert:
	move $t6, $a0		#copying a0 
	li $a0, 16		#creating a new node
	li $v0, 9
	syscall
	move $a0, $t6
	move $t5, $v0 		#address of the current node
	sw $a0, 0($t5)		

	pqWhile:
		move $t8, $s1		#copying the address of the tree
		lw $t7, 0($s1)		
		bgt $a0, $t7, swap	#if next node greater than the tree's element, then go to swap
		jal leftChild		#jump leftchild
		beq $t8, $zero, rightChild
		bne $t8, $zero, leftPqWhile
		jr $ra

	leftChild:
		addi $t8, $t8, 4
		lw $t8, 0($t8)
		bne $t8, $zero, rightChild
		sw $t5, 4($s1)
		sw $s1, 12($t5)
		move $s1, $s0
		j $ra

	rightChild:
		addi $t8, $t8, 8
		lw $t8, 0($t8)
		bne $t8, $zero, leftPqElse
		sw $t5, 8($s1)		#load the current node's address to the right child of the parent node
		sw $s1, 12($t5)		
		move $s1, $s0		
		j $ra
	
	leftPqElse:
		lw $s1,4($s1) 
		j bstWhile	 
	swap:
		move $t9, $a0
		move $a0, $t7
		move $t7, $t9
		j $ra

	returnMain:
		move $v0, $s0 # return address of the root with the $v0 register	
		jr $t9
		
####################################
# Remove Procedure
####################################
remove:



jr $ra

####################################
# Print Procedure
####################################

print:
  move $t0, $ra	
  move $t5, $s0
  move $t9, $s0
  
  lw $t5, 0($t5)	#first element
  
  move $a0, $t5
  li $v0, 1        
  syscall
  la $a0, newline    
  li $v0, 4
  syscall
  

  jal printLoop		

  j $t0

  
printLoop:

  lw $t6, 4($t9)
  beq $t6, $zero, prX	#if node equals zero, print x
  lw $t6, 0($t6)	#left node


  move $a0, $t6		#print left child
  li $v0, 1        
  syscall

  la $a0, endash     # (-) character print
  li $v0, 4
  syscall
  
  lw $t7, 8($t9)
  lw $t7, 0($t7)
  beq $t9, $zero, prX

  move $a0, $t7	#print right child
  li $v0, 1        
  syscall
  la $a0, tab     # for "   " character print
  li $v0, 4,
  
  
  j $ra
  

	
prX:
  la $a0, letterX    # for x character print
  li $v0, 4       
  syscall 


jr $ra

####################################
# Extra Procedures
####################################
extraProcedures:


