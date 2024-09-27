# MARS Assembly Number Game
### Author: Nate Brill
## Project Report:
&nbsp;&nbsp;&nbsp;&nbsp;The purpose of the program asm5.s is to make use of the MARS Keyboard and Display
MMIO simulator as well as various MIPS syscall functions. The program is a number guessing
game where the user can select the difficulty of the number to guess and decide what range of
numbers are randomized using the random int range syscall function. After generating a random
number the user is prompted to guess that number. By typing the number they want to guess in
the Keyboard MMIO simulator followed by the enter key they can guess the right number, or the
user can press ‘N’ quitting the game. If the user guesses wrong the program tells them if their
guess was too high or too low. Once the number is guessed the user has the option to play
again or quit. The text for the game is displayed mainly in the MARS Run I/O however some
output is displayed in the Display MMIO simulator. The game also keeps track of the user's high
score, scores are determined by how many tries it takes to guess the number. These high
scores can be accessed at the starting selection menu when the user presses ‘S’.
<br /><br />
&nbsp;&nbsp;&nbsp;&nbsp;The first thing that runs when the program is assembled and ran is the high scores are
set as well as a global constant -38 to represent the enter key. Then the label main runs printing
the starting menu. It then waits for user input before running the START label that determines
the difficulty, creates the randomly generated number or prints the users high scores. If a
number between (1-4) or s is not entered it will restart displaying that you entered an “Invalid
selection”. After the number is generated the program moves on to the GUESS_START and
GUESS label with processes the users guesses until they exit sending the program to the EXIT
label or guesses correctly which sends them to the CORRECT label. From there it prints the
amount of tries it took the user and whether they got a high score. The user can then restart by
pressing any key or exit by pressing ‘N’.
<br /><br />
&nbsp;&nbsp;&nbsp;&nbsp;In the game s registers are used to store the difficulty the user selected, the high scores
for the different difficulty levels, the amount of times the user has guessed, and the randomly
generated number. The high scores are default set to 0x0fffffff and change when a user guesses
a number in less than the current high score. The best high score for each difficulty is 1. The
users input is read from the Keyboard MMIO simulator by using the lui instruction to set a
registers address to 0xffff then reading from that register with lw, it is also necessary after this to
mask off all of the bits except the ready bit, bit 0. The number characters typed by the user are
converted into integers in memory by subtracting 48 from the character. When a new number is
being added the current number is multiplied by 10 using the bit shifting instruction sll then the
new number is added. Information is displayed the Run I/O using simple syscall functions, while
information is displayed on the Display MMIO simulator by using a function PRINT that loads
each byte from a ascii string and adds it to the MMIO simulators address in memory at 0xffff,
looping through each byte in the string. This function takes one parameter $a0 which contains
the address of the label that is printed. Overall the program asm5.s demonstrates some of the
capabilities of the Keyboard and Display MMIO simulator that is built into MARS, several MIPS
instructions, and several MIPS syscall functions like random int range and print string, print float,
and print char. In conclusion it is a simple number guessing game with several features.

## MIPS Instructions used:
add, addi, addiu, subi, andi, lui, slt, sll, sw, lb, la, lw, bne, beq, jr, jal, j, syscall

## Required Developer Software
 MARS Assembly Runtime Simulator - MARS 4.5