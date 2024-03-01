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
loopCounter:	.word 0		# 4 byte int: increment for each frame of gameplay
	# The next three labels MUST have (MAX_ENEMIES * 1) byte allocated to them
	# 60 * 1 bytes per int
enemyPosX:	.space 60	# 1 byte int array: each enemy will have its own index in both enemyPos arrays
enemyPosY:	.space 60	# 1 byte int array
enemyIndex:	.space 60	# 1 byte int array: this array will store each enemy's index, dead or alive 
test:		.space 32	# reserve 32 consecutive bytes, or 8 words and populate 0 in each
	# 2D game array MUST have (rows * columns) bytes allocated to it
	# 19 * 29 = 551 bytes, 1 byte per char
game:		.space 551	# 1 byte 2D char array: reserve 551 bytes for 2D game array
	
	

.text
	la $t0, test
	
