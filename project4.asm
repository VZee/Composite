TITLE Composite Numbers     (roject4.asm)

; Author: Louisa Katlubeck
; OSU email: katlubel@oregonstate.edu
; CS 271-400 Project 4                 Due Date: 2/18/2018
; Description: This program calculate composite numbers.  
; The user enters the number of composites to be displayed, and enters an integer in the range [1 .. 400].  
; The user enters a number, n, and the program verifies that 1 ? n? 400. The program then calculates and displays 
; all of the composite numbers up to and including the nth composite. 
; This program is implemented using global variables.

INCLUDE Irvine32.inc

.const
; upper and lower limits, inclusive, of input, and zero
	UPPER		EQU		400
	LOWER		EQU		1
	ZERO		EQU		0


.data
; greeting and goodbye
	greeting	BYTE	"Welcome to Project4.asm, Composite Numbers. My name is Louisa. ", 0
	description	BYTE	"You will the number of composites you would like to see, from 1 to 400, and the program will display that number of composites. ", 0
	goodbye		BYTE	"Thank you, goodbye. ", 0

; get user input
	getNum		BYTE	"Enter the number of composites to display [1...400]: ", 0
	error		BYTE	"Number out of range. ", 0

	userNum		DWORD	?

; spaces
	fiveSpaces	BYTE	"     ", 0

; next number we are checking to see if it is a composite
; nextNum is initalized to 4 since it is the first composite number
	nextNum		DWORD	4

; number of composities found
	numFound	DWORD	1

; flag for finding composites
	possible	DWORD	0

.code
main PROC
	call	introduction
	call	getUserData
	call	validate
	call	showComposites
	call	isComposite
	call	farewell

	exit	; exit to the operating system
main ENDP

; program procedures
;
; description: introduction introduces the developer and the program
; registers changed: EDX

introduction PROC
	mov		EDX, OFFSET greeting
	call	WriteString
	call	Crlf
	mov		EDX, OFFSET description
	call	WriteString
	call	CrLf
	call	CrLf
	ret
introduction ENDP


; description: getUserData reads in the user data
; registers changed: EDX, EAX
; get the user number
getUserData PROC
	mov		EDX, OFFSET getnum
	call	WriteString
	call	ReadInt
	mov		userNum, EAX
	ret
getUserData ENDP


; description: validate checks to make sure the user number is between 1 and 400 inclusive
; if it is not, call getUserData
; preconditions: user number has been read into userNum
; registers changed: EAX
validate PROC
; check to make sure the number is greater than or equal to 1
	mov		EAX, userNum
	cmp		EAX, LOWER
	jge		checkUpperBound
	call	getUserData
; check to make sure the number is less than or equal to 400
checkUpperBound:
	cmp		EAX, UPPER
	jle		doReturn
	call	getUserData
doReturn:
	ret
validate ENDP


; description: showComposites prints the composite number to the screen
; preconditions: the user has entered a number between 1 and 400, inclusive, and
; there are still more composite numbers to be printed
; registers changed: EAX, EDX, EBX, ECX
showComposites PROC
; userNum will be our loop counter
	mov		ECX, userNum

; print the composite number to the screen
compFinder:
	mov		EAX, nextNum
	call	WriteDec
	mov		EDX, OFFSET fiveSpaces
	call	WriteString

; check to see if this was the 10th composite on a line; if so call CrLf
	xor		EDX, EDX
	mov		EAX, numFound
	mov		EBX, 10
	div		EBX
	cmp		EDX, 0
	jne		getNext
	call	CrLf

getNext:
; get the next composite
	call	isComposite
	mov		EBX, numFound
	add		EBX, 1
	mov		numFound, EBX

; check to see if we need to print more composites
	loop	compFinder
	ret
showComposites ENDP


; description: isComposite calculates the next composite to be printed
; preconditions: the user has entered a number between 1 and 400, inclusive, and 
; there are still more composites numbers to be printed
; preconditions: the current composite is in EAX
; registers changed: EAX, EBX, EDX

isComposite PROC
findNext:
; add 1 to the current composite to get the next potential composite
	xor		EDX, EDX
	mov		EAX, nextNum
	add		EAX, 1
	mov		nextNum, EAX

; mov 2 into EBX
	mov		EBX, 2

; divide the potential composite by EBX
	div		EBX
	cmp		EDX, ZERO

; if the remainder is zero return because we found a composite 
	je		returnFromProc

; otherwise need to keep checking divisors see if this is a potential composite
checkNum:
	xor		EDX, EDX

; add 1 to EBX
	add		EBX, 1

; check to make sure EBX < nextNum
	cmp		EBX, nextNum

; if EBX = = nextNum, this number is prime and we need to start again
	jge		findNext

; else see if this number is a composite
	mov		EAX, nextNum
	div		EBX
	cmp		EDX, ZERO
	je		returnFromProc
	jmp		checkNum

returnFromProc:
	ret
isComposite ENDP


; description: farewell says goodbye to the user 
; registers changed: EDX
farewell PROC
	call	CrLf
	mov		EDX, OFFSET GOODBYE
	call	WriteString
	call	CrLf
	call	CrLf
	ret
farewell ENDP

END main

