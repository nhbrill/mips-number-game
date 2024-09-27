# asm.s
# Nate Brill
# How to use:
# 	Go to "Tools->Keyboard and Display MMIO Simulator",
#	Enter a number (1-4) or s to see high scores,
#	Enter a guess followed by the enter key,
#	Keep entering guesses or n to exit.

.data
MSG_START:	.asciiz "Select Difficulty:\n"
MSG_EASY:	.asciiz	"1 - easy (0-10)\n"
MSG_MED:	.asciiz "2 - normal (0-100)\n"
MSG_HARD:	.asciiz "3 - hard (0-1000)\n"
MSG_IMP:	.asciiz "4 - imposible (0-100000)\n"
MSG_HS:		.asciiz	"Press S to see high scores.\n"
MSG_TRY:	.asciiz "Guess a number followed by pressing enter:\n"
MSG_CORRECT:	.asciiz "Correct! It took you "
MSG_TRIES:	.asciiz " tries.\n"
MSG_HIGH:	.asciiz "Too high, guess agian:\n"
MSG_LOW:	.asciiz "Too low, guess again:\n"
MSG_SEL:	.asciiz	" has been selected.\n"
MSG_SEL_EASY:	.asciiz "Easy "
MSG_SEL_MED:	.asciiz "Normal "
MSG_SEL_HARD:	.asciiz "Hard "
MSG_SEL_IMP:	.asciiz "Impossible "
MSG_HS_EASY:	.asciiz "Easy         "
MSG_HS_MED:	.asciiz "Normal       "
MSG_HS_HARD:	.asciiz "Hard         "
MSG_HS_IMP:	.asciiz "Impossible   "
MSG_AGAIN:	.asciiz "Would you like to play again? Press any key to start or N to exit.\n"
MSG_INVALID:	.asciiz "Invalid selection.\n"
MSG_NEW_HS:	.asciiz "New High Score!\n"
MSG_RIGHT:	.asciiz "Correct!\n"

.text
# REGISTERS
#	s0 - difficulty
#	s1 - impossible hs
#	s2 - tries
#	s3 - enter
#	s4 - easy hs
#	s5 - normal hs
#	s6 - hard hs
#	s7 - random number
addi	$s3, $zero, -38			# Global constant for enter
addi	$s4, $zero, 0x0fffffff		# easy hs = 0
addi	$s5, $zero, 0x0fffffff		# normal hs = 0
addi	$s6, $zero, 0x0fffffff		# hard hs  = 0
addi	$s1, $zero, 0x0fffffff		# impossible hs = 0

main:
	lui	$t0, 0xffff
	
	addi    $v0, $zero, 4		# printf("Select Difficulty:\n")
	la	$a0, MSG_START
	syscall
	
	jal	PRINT
	
	addi    $v0, $zero, 4		# printf("1 - easy (0-10)\n")
	la	$a0, MSG_EASY
	syscall
	
	jal	PRINT
	
	addi    $v0, $zero, 4		# printf("1 - easy (0-10)\n")
	la	$a0, MSG_MED
	syscall
	
	jal	PRINT
	
	addi    $v0, $zero, 4		# printf("1 - easy (0-10)\n")
	la	$a0, MSG_HARD
	syscall
	
	jal	PRINT
	
	addi    $v0, $zero, 4		# printf("1 - easy (0-10)\n")
	la	$a0, MSG_IMP
	syscall
	
	jal	PRINT
	
	addi    $v0, $zero, 4		# printf("Press S to see high scores.\n")
	la	$a0, MSG_HS
	syscall
	
	jal	PRINT
	
	lw      $t1, 0($t0)      	# read control register
	andi    $t1, $t1, 0x1    	# mask off all but bit 0 (the 'ready' bit)

	bne     $t1, $zero, START	# Starts the game
	
NOT_START:
	lw      $t1, 0($t0)      	# read control register
	andi    $t1, $t1, 0x1     	# mask off all but bit 0 (the 'ready' bit)
	beq     $t1, $zero, NOT_START
	
START:
	lw      $t1, 4($t0)		# read the actual typed character
	
	
	subi	$s0, $t1, 48		# int s0 = length (difficulty)

	addi    $t6, $zero, 'n'		# press n to exit
	beq	$t1, $t6, EXIT
	addi    $t6, $zero, 's'
	bne	$t1, $t6, EASY
	
	addi    $v0, $zero, 4		# printf("Easy ")
	la	$a0, MSG_HS_EASY
	syscall
	
	addi    $v0, $zero, 1		# print_chr(easy hs)
	add     $a0, $zero, $s4
	syscall
	
	addi    $v0, $zero, 11		# print_chr('\n')
	addi    $a0, $zero, '\n'
	syscall
	
	addi    $v0, $zero, 4		# printf("Normal ")
	la	$a0, MSG_HS_MED
	syscall
	
	addi    $v0, $zero, 1		# print_chr(normal hs)
	add     $a0, $zero, $s5
	syscall
	
	addi    $v0, $zero, 11		# print_chr('\n')
	addi    $a0, $zero, '\n'
	syscall
	
	addi    $v0, $zero, 4	        # printf("Easy ")
	la	$a0, MSG_HS_HARD
	syscall
	
	addi    $v0, $zero, 1		# print_chr(hard hs)
	add     $a0, $zero, $s6
	syscall
	
	addi    $v0, $zero, 11		# print_chr('\n')
	addi    $a0, $zero, '\n'
	syscall
	
	addi    $v0, $zero, 4		# printf("Impossible ")
	la	$a0, MSG_HS_IMP
	syscall
	
	addi    $v0, $zero, 1		# print_chr(impossible hs)
	add     $a0, $zero, $s1
	syscall
	
	addi    $v0, $zero, 11		# print_chr('\n')
	addi    $a0, $zero, '\n'
	syscall
	
	j main
EASY:
	addi	$t3, $zero, 1		# easy
	bne	$s0, $t3, MED 
	addi 	$a1, $zero, 10		# 0 - 10
	la      $a0, MSG_SEL_EASY	# "easy"
	
	j	BEGIN
MED:
	addi	$t3, $zero, 2		# normal
	bne	$s0, $t3, HARD
	addi 	$a1, $zero, 100		# 0 - 100
	la      $a0, MSG_SEL_MED	# "normal"
	
	j	BEGIN
HARD:
	addi	$t3, $zero, 3		# hard
	bne	$s0, $t3, IMP
	addi 	$a1, $zero, 1000	# 0 - 1000
	la      $a0, MSG_SEL_HARD	# "hard"
	
	j	BEGIN
IMP:
	addi	$t3, $zero, 4		# impossible
	bne	$s0, $t3, INVALID
	addi	$a1, $zero, 100000	# 0 - 100000
	la      $a0, MSG_SEL_IMP	# "impossible"
	
	j	BEGIN
INVALID:
	addi    $v0, $zero, 4		# printf("Invalid selection\n");
	la      $a0, MSG_INVALID
	syscall	
	
	jal	PRINT
	
	j 	main
	
BEGIN:
	addi    $v0, $zero, 4		# printf("selection\n");
	syscall	
	
	addi    $v0, $zero, 4		# printf(" has been selected.\n");
	la      $a0, MSG_SEL
	syscall	

	addi	$v0, $zero, 42		# Randomizes number
	syscall
	
	add 	$s7, $a0, $zero

GUESS_START:
	lui     $t0, 0xffff
	
	add	$s2, $zero, $zero	# int tries = 0;
	
	add	$t8, $zero, $zero	# stores entered number n, int n = 0;
	
	addi    $v0, $zero, 4		# printf("Guess a number:\n");
	la      $a0, MSG_TRY
	syscall	
	
	jal	PRINT
	
	j 	OUTER_LOOP
GUESS:
	lui     $t0, 0xffff
	
	addi    $v0, $zero, 1		# print_int(guess);
	add     $a0, $t8, $zero
	syscall
	
	addi    $v0, $zero, 11		# print_chr('\n')
	addi    $a0, $zero, '\n'
	syscall
	
	beq	$t8, $s7, CORRECT
	
	slt	$t3, $t8, $s7		# guess < n
	beq	$t3, $zero, HIGH	# if (guess > n) goto HIGH
	addi    $v0, $zero, 4		# printf("Too low, guess again:\n");
	la      $a0, MSG_LOW
	syscall
	
	jal	PRINT
	
	j	RESET	
HIGH:
	addi    $v0, $zero, 4		# printf("too high, guess again:\n");
	la      $a0, MSG_HIGH
	syscall	
	
	jal	PRINT

RESET:
	add	$t8, $zero, $zero	# stores entered number guess, int guess = 0;
	
OUTER_LOOP:
	lw      $t1, 0($t0)      	# read control register
	andi    $t1, $t1, 0x1    	# mask off all but bit 0 (the 'ready' bit)

	bne     $t1, $zero, READY

NOT_READY:
	lw      $t1, 0($t0)      	# read control register
	andi    $t1, $t1, 0x1     	# mask off all but bit 0 (the 'ready' bit)
	beq     $t1, $zero, NOT_READY

READY:
	lw      $t1, 4($t0)		# read the actual typed character
	
	addi    $t6, $zero, 'n'		# press n to exit
	beq	$t1, $t6, EXIT
	
	subi	$t9, $t1, 48		# Converts char to int
	
	beq	$t9, $s3, GUESS
	
	sll	$t2, $t8, 1		# n * 10;
	sll	$t3, $t8, 3
	add	$t8, $t2, $t3
	add	$t8, $t8, $t9		# n = n + entered number;
	
	addi	$s2, $s2, 1		# tries ++;

	j       OUTER_LOOP
CORRECT:
	addi    $v0, $zero, 4		# printf("Correct! It took you ");
	la	$a0, MSG_CORRECT
	syscall
	
	la	$a0, MSG_RIGHT		# printf("Correct!");
	jal	PRINT
	
	addi    $v0, $zero, 1		# print_int(tries);
	add     $a0, $s2, $zero
	syscall
	
	addi    $v0, $zero, 4		# printf(" tries.\n")
	la	$a0, MSG_TRIES
	syscall
	
	addi	$t3, $zero, 1		# easy
	bne	$s0, $t3, HS_MED
	slt	$t3, $s2, $s4		# easy tries < hs
	beq	$t3, $zero, NO_SCORE
	add	$s4, $zero, $s2		# sets new easy high score
	
	j	HIGHSCORE
HS_MED:
	addi	$t3, $zero, 2		# normal
	bne	$s0, $t3, HS_HARD
	slt	$t3, $s2, $s5		# normal tries < hs
	beq	$t3, $zero, NO_SCORE
	add	$s5, $zero, $s2		# sets new normal high score
	
	j	HIGHSCORE
HS_HARD:
	addi	$t3, $zero, 3		# hard
	bne	$s0, $t3, HS_IMP
	slt	$t3, $s2, $s6		# hard tries < hs
	beq	$t3, $zero, NO_SCORE
	add	$s6, $zero, $s2		# sets new hard high score
	
	j	HIGHSCORE
HS_IMP:
	slt	$t3, $s2, $s1		# impossible tries < hs
	beq	$t3, $zero, NO_SCORE
	add	$s1, $zero, $s2		# sets new immposible high score
	
	j	HIGHSCORE 
HIGHSCORE:
	addi    $v0, $zero, 4		# printf("New High Score!\n")
	la	$a0, MSG_NEW_HS
	syscall
	
	jal	PRINT

NO_SCORE:
	
	addi    $v0, $zero, 4		# printf("Would you like to play again? Press any key or N to exit.\n")
	la	$a0, MSG_AGAIN
	syscall
	
	jal	PRINT
	
	lui	$t0, 0xffff
	
	lw      $t1, 0($t0)      	# read control register
	andi    $t1, $t1, 0x1    	# mask off all but bit 0 (the 'ready' bit)

	bne     $t1, $zero, AGAIN	# Restarts the game
	
NOT_AGAIN:
	lw      $t1, 0($t0)      	# read control register
	andi    $t1, $t1, 0x1     	# mask off all but bit 0 (the 'ready' bit)
	beq     $t1, $zero, NOT_AGAIN

AGAIN:
	lw      $t1, 4($t0)		# read the actual typed character
	addi    $t6, $zero, 'n'		# press n to exit
	beq	$t1, $t6, EXIT
	
	j	main
	
.globl PRINT				# void PRINT(char* a0)
PRINT:					# for (int i = 0, a0[i] != '\0'; i++)
	addiu	$sp, $sp, -24		# allocate stack space -- default of 24 here
	sw	$fp, 0($sp)		# save caller's frame pointer
	sw	$ra, 4($sp)		# save return address
	addiu	$fp, $sp, 20		# setup main's frame pointer
	
	lb	$t3, ($a0)		# t3 = a0[i]
	lui	$t5, 0xffff
PRINTLOOP:
	lw	$t4, 8($t5)		# Reads the typed register	
	andi	$t4, $t4, 0x1		# mask off all but bit 0 (the 'ready' bit)
	beq	$t4, $zero, PRINTLOOP
	sw	$t3, 12($t5)		# Stores in display memory
	addi	$a0, $a0, 1		# i ++;
	bne	$t3, $zero, PRINT
	
	lw	$ra, 4($sp)		# get return address from stack
	lw	$fp, 0($sp)		# restore the caller's frame pointer
	addiu 	$sp, $sp, 24		# resotre the caller's stack pointer
	jr	$ra

EXIT:
