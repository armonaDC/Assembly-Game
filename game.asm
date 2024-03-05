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
	
	li	$v0, 10
	syscall

InitializeGame:	
	#This function puts a '.' in each element of the char array
	#Then it puts a 't' where the player is in the char array
	#Utilizes a nested while loop
	addi	$t0, $zero, 0		#int i
	addi	$t1, $zero, 0		#int j
	lb	$t2, rows		#load rows int to $t2
	lb	$t3, columns		#load columns int to $t3
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
