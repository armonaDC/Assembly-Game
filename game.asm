.data
	#integers below may only be stored with one byte as it does not need
	#more than 8 bits to represent the int
playing: 	.byte 1		# 1 byte int: is the game running? 1 = yes
rows: 		.byte 19	# 1 byte int: rows for game array
columns: 	.byte 29	# 1 byte int: columns for game array
MAX_ENEMIES: 	.byte 60	# 1 byte int: max number of enemies for the game
playerPosX:	.byte 0		# 1 byte int: starting X position, or row
playerPosY:	.byte 0		# 1 byte int: starting Y position, or column
moveDir:	.byte 0		# 1 byte char: player input for movement
period:		.byte '.'	# 1 byte char: a period
player:		.byte 't'	# 1 byte char: a 't'
newline:	.asciiz "\n"	# a new line
loopCounter:	.word 0		# 4 byte int: increment for each frame of gameplay
	# The next three labels MUST have (MAX_ENEMIES * 1) byte allocated to them
	# 60 * 1 bytes per int
enemyPosX:	.space 60	# 1 byte int array: each enemy will have its own index in both enemyPos arrays
enemyPosY:	.space 60	# 1 byte int array
enemyIndex:	.space 60	# 1 byte int array: this array will store each enemy's index, dead or alive 
	# 2D game array MUST have (rows * columns) bytes allocated to it
	# 19 * 29 = 551 bytes, 1 byte per char
game:		.space 551	# 1 byte 2D char array: reserve 551 bytes for 2D game array
	
	

.text
main:
	#calculate playerPosX and PlayerPosY starting point, then assign
	lb	$t0, rows		#X coordinate
	lb	$t1, columns		#Y coordinate
	srl	$t0, $t0, 1		#divide by 2
	srl	$t1, $t1, 1		#divide by 2
	sb	$t0, playerPosX		#assign playerPosX starting coord, held in $t0
	sb	$t1, playerPosY		#assign playerPosY starting coord, held in $t1

	#Call InitializeGame
	la	$a0, game		#base address of game array
	add	$a1, $zero, $t0		#playerPosX
	add	$a2, $zero, $t1		#playerPosY
	jal	InitializeGame
	
	#Call PrintGame
	la	$a0, game		#base address of game array
	jal	PrintGame
	
	
	li	$v0, 10
	syscall
	
##################################################################################################################################	
PrintGame:
	#This function prints the 2D game array to the screen 
	addi	$t0, $zero, 0		#int i = 0
	addi	$t1, $zero, 0		#int j = 0
	lb	$t2, rows		#load # of rows int to $t2
	lb	$t3, columns		#load # of columns int to $t3
	add	$t4, $zero, $a0		#$t4 now holds the base address of game, $a0 needs to be used for printing chars

	
PrintWhile:
	bge	$t0, $t2, PrintDone	#if i >= rows, loop is done
	addi	$t1, $zero, 0		# j = 0
	
PrintNestWhile:
	bge	$t1, $t3, PrintNestDone	#if j >= columns, loop is done
	
	mul	$t5, $t0, $t3		# $t5 holds addr offset, start with i * (# of col) for row position
	add	$t5, $t5, $t1		# Add column position to offset
	add	$t5, $t5, $t4		# Add offset and base array addr for addr of game[i][j] in $t5
	
	lb	$a0, 0($t5)		# load char from address into $a0
	li	$v0, 11			#code for print char on syscall
	syscall
	
	addi	$t1, $t1, 1		# j = j + 1
	j	PrintNestWhile

PrintNestDone:
	la	$a0, newline		# load address of newline into $a0
	li	$v0, 4			# code for print string in syscall
	
	addi	$t0, $t0, 1		# i = i + 1
	j	PrintWhile
	
PrintDone:
	jr	$ra

##################################################################################################################################
InitializeGame:	
	#This function puts a '.' in each element of the char array
	#Then it puts a 't' where the player is in the char array
	#Utilizes a nested while loop
	addi	$t0, $zero, 0		#int i = 0
	addi	$t1, $zero, 0		#int j = 0
	lb	$t2, rows		#load # of rows int to $t2
	lb	$t3, columns		#load # of columns int to $t3
	lb	$t5, period		#load period ascii code into $t5
	lb	$t6, player
	
InitWhile:				#start of initialization while loop for populating array
	bge	$t0, $t2, InitDone	#if i >= rows, loop is done
	addi 	$t1, $zero, 0		# j = 0
	
InitNestWhile:				#Start of nested while loop
	bge	$t1, $t3, InitNestDone	#if j >= columns, loop is done
	
	mul	$t4, $t0, $t3		#$t4 will hold array offset, each char is 1 byte. Start by finding addr for the row i is at (Row * (# of col))
	add	$t4, $t4, $t1		#add j to $t4, again each char is 1 byte.
	add	$t4, $t4, $a0		#add base address to offset
	
	sb	$t5, 0($t4)		#assign game[i][j] = '.'
	  
	addi	$t1, $t1, 1 		# j = j + 1
	j	InitNestWhile
	
InitNestDone:
	addi	$t0, $t0, 1		# i = i + 1
	j	InitWhile
	
InitDone:

	#Have not verified that the player is spawned at the correct location
	mul	$t4, $a1, $t3		#array offset for player position, Row * (# of columns)
	add	$t4, $t4, $a2		#add columns to offset
	add	$t4, $t4, $a0		#add base address to offset
	sb	$t6, 0($t4)
	
	
	jr	$ra
##################################################################################################################################
