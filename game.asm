.data
	#INTENDED BITMAP DISPLAY SETTINGS
	#Unit width: 16
	#Unit height: 16
	#Display width: 512
	#Display height: 512
	#Base address 0x10010000 (static data)
	#This creates a 32 x 32 pixel playable area
	
display:	.space 0x1000		# 32 x 32 pixels of 4 byte integers
backgroundColor:.word 0x00323232	# dark gray background color for display
playerColor:	.word 0x00FF00FF	# purple color for player
baseEnemyColor:	.word 0x00FF0000	# red color for basic enemy

	#integers below may only be stored with one byte as it does not need
	#more than 8 bits to represent the int

playing: 	.byte 1			# 1 byte int: is the game running? 1 = yes
rows: 		.byte 32		# 1 byte int: rows for game array
columns: 	.byte 32		# 1 byte int: columns for game array
MAX_ENEMIES: 	.byte 60		# 1 byte int: max number of enemies for the game
playerPosX:	.byte 0			# 1 byte int: starting X position, or row
playerPosY:	.byte 0			# 1 byte int: starting Y position, or column
moveDir:	.byte 0			# 1 byte char: player input for movement
period:		.byte '.'		# 1 byte char: a period
player:		.byte 't'		# 1 byte char: a 't'
baseEnemy:	.byte 'e'		# 1 byte char: 'e'
newline:	.asciiz "\n"		# a new line
demo:		.asciiz "Demo Complete! \n\n"	#Demonstration of grandchild function
loopCounter:	.word 0			# 4 byte int: increment for each frame of gameplay
timeLimit:	.word 28000		# 4 byte int: max number of frames the game will run, at 30fps ~ 15 minutes
	# The next three labels MUST have (MAX_ENEMIES * 1) byte allocated to them
	# 60 * 1 bytes per int
enemyPosX:	.space 60		# 1 byte int array: each enemy will have its own index in both enemyPos arrays
enemyPosY:	.space 60		# 1 byte int array
enemyIndex:	.space 60		# 1 byte int array: this array will store each enemy's index, dead or alive 
	# 2D game array MUST have (rows * columns) bytes allocated to it
	# 32 * 32 = 551 bytes, 1 byte per char
game:		.space 1024		# 1 byte 2D char array: reserve 1024 bytes for 2D game array


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
	
	
	lw	$t7, loopCounter	#load loopCounter or i from memory in preparation for loop
	MainLoop:
	bge	$t7, 100, MainDone	# if i >= 100 loop is done, 50 is arbitrary for now
	sw	$t7, loopCounter	#store loopCounter or i to memory after comparison
	
	#sleep for 33 ms leading to ~30 frames / sec
	addi	$a0, $zero, 33		#33 ms 
	addi	$v0, $zero, 32		#code for sleep
	syscall
	
	#Call MovePlayer
	addi	$v0, $zero, 12		#code for read char
	syscall
	
	sb	$v0, moveDir		#assign read char to movedir
	la	$a1, game		#base address of game array
	lb	$a2, playerPosX		#player X coordinate
	lb	$a3, playerPosY		#player Y coordinate
	jal	MovePlayer
	
	#Call PrintGame
	la	$a0, game		#base address of game array
	jal	PrintGame
	
	lw	$t7, loopCounter	#load loopCounter or i from memory
	addi	$t7, $t7, 1		#increment i = i + 1
	j	MainLoop
	
	MainDone:
	li	$v0, 10
	syscall
	
##################################################################################################################################		
MovePlayer:
	#First gameplay boundaries will be checked, then movement will occur
	#Full list of registers during execution of this subroutine
	#la	$a1, game			#base address of game array
	#lb	$a2, playerPosX			#player X coordinate
	#lb	$a3, playerPosY			#player Y coordinate
	addi	$t0, $zero, 119			#ascii code for 'w'
	addi	$t1, $zero, 97			#ascii code for 'a'
	addi	$t2, $zero, 115			#ascii code for 's'
	addi	$t3, $zero, 100			#ascii code for 'd'
	lb	$t4, rows			#load # of rows int to $t4
	lb	$t5, columns			#load # of columns int to $t5
	lb	$t6, moveDir			#load movedir into $t6
	
	addi 	$t4, $t4, -1			#(# of rows) - 1
	addi 	$t5, $t5, -1			#(# of columns) - 1
	
	addi	$sp, $sp, -8			#allocate 8 bytes for the stack
	sw	$s0, 0($sp)			#store $s0 on stack
	sw	$s1, 4($sp)			#store $s1 on stack
	
	lb	$s0, period			#load period onto $s0
	lb	$s1, player			#load player onto $s1
	
MovePlayerComparison1:				#this label is not used, other than for readability	
	#The next two lines check for the top gameplay boundary
	#if(playerPosX == 0 && moveDir == 'w'){return;}
	bne	$a2, $zero, MovePlayerComparison2	#If PlayerPosX != 0 go to next comparison
	beq	$t6, $t0, MovePlayerDone		#If movedir is 'w' MovePlayer is done
	
MovePlayerComparison2:
	#Check for bottom gameplay boundary
	#if(playerPosX == (rows - 1) && moveDir == 's'){return;}
	bne	$a2, $t4, MovePlayerComparison3 	#If PlayerPosX != max row go to next comparison
	beq	$t6, $t2, MovePlayerDone		#If movedir is 's' MovePlayer is done
	
MovePlayerComparison3:
	#Check for left gameplay boundary, similar to above
	bne	$a3, $zero, MovePlayerComparison4	#If PlayerPosY != 0 go to next comparison
	beq	$t6, $t1, MovePlayerDone		#If movedir is 'a' MovePlayer is done
	
MovePlayerComparison4:
	#Check for right gameplay boundary. similar to above
	bne	$a3, $zero, MovePlayerLogic		#If PlayerPos Y != max column, go to logic
	beq	$t6, $t3, MovePlayerDone		#If movedir is 'd' MovePlayer is done

MovePlayerLogic:
	addi 	$t4, $t4, 1				#t4 now holds # of rows
	addi 	$t5, $t5, 1				#t5 now holds # of oclumns

	bne	$t6, $t0, MovePlayerDir2		#if movedir is not 'w' move to next direction logic
	mul	$t7, $a2, $t5				#array offset for player position, Row(playerPosX) * (# of columns)
	add	$t7, $t7, $a3				#add columns(playerPosY) to offset
	add	$t7, $t7, $a1				#add base address to offset
	sb	$s0, 0($t7)				#store '.' where player position is
	
	addi 	$a2, $a2, -1				#moving up with 'w' is decreasing by one row
	sb	$a2, playerPosX				#store new player X position in memory
	#Recalculate array position for new player position
	mul	$t7, $a2, $t5				#array offset for player position, Row(playerPosX) * (# of columns)
	add	$t7, $t7, $a3				#add columns(playerPosY) to offset
	add	$t7, $t7, $a1				#add base address to offset
	sb	$s1, 0($t7)				#store 't' where player position is
	
	j	MovePlayerDone
	
MovePlayerDir2:
	bne	$t6, $t1, MovePlayerDir3		#if movedir is not 'a' move to next direction logic
	mul	$t7, $a2, $t5				#array offset for player position, Row(playerPosX) * (# of columns)
	add	$t7, $t7, $a3				#add columns(playerPosY) to offset
	add	$t7, $t7, $a1				#add base address to offset
	sb	$s0, 0($t7)				#store '.' where player position is
	
	addi 	$a3, $a3, -1				#moving left with 'a' is decreasing by one column
	sb	$a3, playerPosY				#store new player Y position in memory
	#Recalculate array position for new player position
	mul	$t7, $a2, $t5				#array offset for player position, Row(playerPosX) * (# of columns)
	add	$t7, $t7, $a3				#add columns(playerPosY) to offset
	add	$t7, $t7, $a1				#add base address to offset
	sb	$s1, 0($t7)				#store 't' where player position is
	
	j	MovePlayerDone
	
MovePlayerDir3:
	bne	$t6, $t2, MovePlayerDir4		#if movedir is not 's' move to next direction logic
	mul	$t7, $a2, $t5				#array offset for player position, Row(playerPosX) * (# of columns)
	add	$t7, $t7, $a3				#add columns(playerPosY) to offset
	add	$t7, $t7, $a1				#add base address to offset
	sb	$s0, 0($t7)				#store '.' where player position is
	
	addi 	$a2, $a2, 1				#moving down with 's' is increasing by one row
	sb	$a2, playerPosX				#store new player X position in memory
	#Recalculate array position for new player position
	mul	$t7, $a2, $t5				#array offset for player position, Row(playerPosX) * (# of columns)
	add	$t7, $t7, $a3				#add columns(playerPosY) to offset
	add	$t7, $t7, $a1				#add base address to offset
	sb	$s1, 0($t7)				#store 't' where player position is
	
	j	MovePlayerDone
	
MovePlayerDir4:
	bne	$t6, $t3, MovePlayerDir3		#if movedir is not 'd' move to next direction logic
	mul	$t7, $a2, $t5				#array offset for player position, Row(playerPosX) * (# of columns)
	add	$t7, $t7, $a3				#add columns(playerPosY) to offset
	add	$t7, $t7, $a1				#add base address to offset
	sb	$s0, 0($t7)				#store '.' where player position is
	
	addi 	$a3, $a3, 1				#moving right with 'd' is increasing by one column
	sb	$a3, playerPosY				#store new player Y position in memory
	#Recalculate array position for new player position
	mul	$t7, $a2, $t5				#array offset for player position, Row(playerPosX) * (# of columns)
	add	$t7, $t7, $a3				#add columns(playerPosY) to offset
	add	$t7, $t7, $a1				#add base address to offset
	sb	$s1, 0($t7)				#store 't' where player position is
	
	j	MovePlayerDone
		
MovePlayerDone:
	#restore $s registers from stack
	lw	$s1, 4($sp)				#load $s1 from stack
	lw	$s0, 0($sp)				#load $s0 from stack
	addi 	$sp, $sp, 8				#place stack pointer back to its original position
	
	jr	$ra
##################################################################################################################################	
PrintGame:
	#This function prints the 2D game array to the screen 
	#Full list of registers during execution of this subroutine
	#la	$a0, game		#base address of game array
	addi	$t0, $zero, 0		#int i = 0
	addi	$t1, $zero, 0		#int j = 0
	lb	$t2, rows		#load # of rows int to $t2
	lb	$t3, columns		#load # of columns int to $t3
	add	$t4, $zero, $a0		#$t4 now holds the base address of game, $a0 needs to be used for printing chars
	
	addi	$sp, $sp, -24		#allocate 12 bytes on stack
	sw	$s0, 0($sp)		#store s0 - s2 on stack
	sw	$s1, 4($sp)
	sw	$s2, 8($sp)
	sw	$s3, 12($sp)
	sw	$s4, 16($sp)
	sw	$s5, 20($sp)
	
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
	syscall				#print string
	
	addi	$t0, $t0, 1		# i = i + 1
	j	PrintWhile
	
PrintDone:
	#Portion below is for bitmap display
	addi	$t0, $zero, 0		#int i = 0
	addi	$t1, $zero, 0		#int j = 0
	#lb	$t2, rows		#load # of rows int to $t2
	#lb	$t3, columns		#load # of columns int to $t3
	la	$t4, display		# load base address of display into $t4
	lw	$t5, backgroundColor	#load background color into $t5
	lw	$t6, playerColor	#load player color into $t6
	lw	$t7, baseEnemyColor	#load basic enemy color into $t7
	lb	$s0, period		#load '.' into $s0
	lb	$s1, player		#load 't' into $s1
	lb	$s2, baseEnemy		#load 'e' into $s2
	# s3 for offset calc
	lb	$s4, playerPosX 	#for posX
	lb	$s5, playerPosY 	#for posY
	#Likely will need more registers to implement the display
	
DisplayWhile:
	bge	$t0, $t2, PrintDisplayDone	#if i >= rows, loop is done
	addi	$t1, $zero, 0			# j = 0
	
	DisplayNestWhile:
	bge	$t1, $t3, DisplayNestDone	#if j >= columns, loop is done
	
	# this is where the code goes to read existing 2d array, reading the char and correlating it to a 
	# color on the bitmap display, so the bitmap would read from the 'real' array to provide visuals
	####

	mul	$s3, $t0, $t3		#$s3 will hold array offset, each int is 4 bytes. Start by finding addr for the row i is at (Row * (# of col))
	add	$s3, $s3, $t1		#add j to $s3, again each int is 4 bytes.
	sll	$s3, $s3, 2		# shift left logical to multiply by 4, due to int size
	add	$s3, $s3, $t4		#add base address of display to offset
	
	sw	$t5, 0($s3)			#overwrite all pixels to background color
	bne	$t0, $s4, skipPlayerChar	#if i != posX skip
	bne	$t1, $s5, skipPlayerChar	#if j != posY skip

	sw	$t6, 0($s3)			#assign where the 't' char is with the player color on bitmap
	
	skipPlayerChar: 
	####
	addi	$t1, $t1, 1		# j = j + 1
	j	DisplayNestWhile
	
DisplayNestDone:
	
	addi	$t0, $t0, 1		# i = i + 1
	j	DisplayWhile
	
PrintDisplayDone:
	sw	$s5, 20($sp)
	sw	$s4, 16($sp)
	lw	$s3, 12($sp)
	lw	$s2, 8($sp)		#restore s0 - s2 from stack
	lw	$s1, 4($sp)
	lw	$s0, 0($sp)		
	addi	$sp, $sp, 24		#deallocate 12 bytes on stack
	
	jr	$ra

##################################################################################################################################
InitializeGame:	
	#This function puts a '.' in each element of the char array
	#Then it puts a 't' where the player is in the char array
	#Utilizes a nested while loop
	#This function also initlizes bitmap display with background color and player pixel
	#Full list of registers during execution of this subroutine
	#la	$a0, game		#base address of game array
	#add	$a1, $zero, $t0		#playerPosX
	#add	$a2, $zero, $t1		#playerPosY
	addi	$t0, $zero, 0		#int i = 0
	addi	$t1, $zero, 0		#int j = 0
	lb	$t2, rows		#load # of rows int to $t2
	lb	$t3, columns		#load # of columns int to $t3
	lb	$t5, period		#load period ascii code into $t5
	lb	$t6, player		#char representing the player
	
	addi	$sp, $sp, -12			#allocate 12 bytes for the stack
	sw	$s0, 0($sp)			#store $s0 on stack
	sw	$s1, 4($sp)			#store $s1 on stack
	sw	$ra, 8($sp)			#store $ra on stack
	
	jal	GrandChildDemo			#go to grandchild function demo
	
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
	mul	$t4, $a1, $t3		#array offset for player position, Row(playerPosX) * (# of columns)
	add	$t4, $t4, $a2		#add columns(playerPosY) to offset
	add	$t4, $t4, $a0		#add base address to offset
	sb	$t6, 0($t4)		#store player char in game array
	
	#Portion below is for bitmap display initialization
	
	addi	$t0, $zero, 0		# i = 0 to prep for bitmap display initialization
	addi	$t1, $zero, 0		# j = 0
	#lb	$t2, rows		#load # of rows int to $t2
	#lb	$t3, columns		#load # of columns int to $t3
	#lb	$t5, period		#load period ascii code into $t5
	#lb	$t6, player		#char representing the player
	la	$t7, display		#base address of bitmap display
	lw	$s0, backgroundColor	#load background color into $s0
	lb	$s1, playerColor	#load player color into $s1
	
InitDisplayWhile:				#First loop
	bge	$t0, $t2, InitDisplayDone	#if i >= rows, loop is done
	addi 	$t1, $zero, 0			# j = 0
	
	InitDisplayNestWhile:			#Start of nested while loop
	bge	$t1, $t3, InitDisplayNestDone	#if j >= columns, loop is done
	
	mul	$t4, $t0, $t3		#$t4 will hold array offset, each int is 4 bytes. Start by finding addr for the row i is at (Row * (# of col))
	add	$t4, $t4, $t1		#add j to $t4, again each int is 4 bytes.
	sll	$t4, $t4, 2		# shift left logical to multiply by 4, due to int size
	add	$t4, $t4, $t7		#add base address of display to offset
	
	sw	$s0, 0($t4)		#assign display[i][j] = background color
	  
	addi	$t1, $t1, 1 		# j = j + 1
	j	InitDisplayNestWhile
	
InitDisplayNestDone:
	addi	$t0, $t0, 1		# i = i + 1
	j	InitDisplayWhile
	
InitDisplayDone:
	lw	$ra, 8($sp)			#restore $ra from stack
	lw	$s1, 4($sp)			#restore $s1 from stack
	lw	$s0, 0($sp)			#restore $s0 from stack
	addi	$sp, $sp, 12			#deallocate 8 bytes from stack
	jr	$ra
##################################################################################################################################
GrandChildDemo:
	addi	$sp, $sp, -8		#allocate 8 bytes for the stack
	sw	$a0, 0($sp)		#store $a0 on stack
	sw	$v0, 4($sp)		#store $v0 on stack
	
	la	$a0, demo		#load demo string into $a0
	li	$v0, 4			#$v0 code for print string
	syscall
	
	lw	$v0, 4($sp)		#restore $v0 from stack
	lw	$a0, 0($sp)		#restore $a0 from stack
	addi	$sp, $sp, 8		#deallocate 8 bytes from stack
	
	jr	$ra			#jump back without leaving a trace
##################################################################################################################################
