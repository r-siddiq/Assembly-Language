TITLE Rahim Siddiq CS118 Final Assignment 8							(RahimSiddiq_CS118_FinalAssignment8.asm)

COMMENT !
Program description: Final Exam Project. Assembly language program takes user input from a user and stores information in an array.
Program accomplishes the following
(1) Counts and displays the number of words in the user input string
(2) Flips the case of all alphabetical characters (upper/lower) (lower/upper)
(3) Counts and displays the number of vowels (a,e,i,o,u) in the string

Author: Rahim Siddiq
Date: 12/04/2022
!

INCLUDE Irvine32.inc													;Import library
.386																	;.386 directive allows program to access 32 bit registers
.model flat,stdcall														;flat memory model protected mode
.stack 4096																;directive to assembler for how many bytes reserved for stack
ExitProcess PROTO,dwExitCode:DWORD										;exit process function declaration

;;; Prototype declaration for FindVowels procedure. Passes: Two pointers and three DWORD arguments
FindVowels PROTO, ptrArray1:PTR BYTE, ptrArray2:PTR BYTE, array1Size:DWORD, array2Size:DWORD, vowelHits:DWORD

.data																	;area to designate variables
;;;;;;;;;; Description of program function to user ;;;;;;;;;;
msgIntro BYTE " Program takes allows the user to enter a string and displays the entry in reverse case, the number of words, and vowels",0
msgDivider BYTE " =======================================================================================================================",0
msgPrompt1 BYTE " Please enter a string of your choice, then press enter to continue: ",0
msgNumWords BYTE " The number of words in your string: ",0
msgNumVowels BYTE " The number of vowels (a,e,i,o,u) in your string: ",0
msgRevCase BYTE " The output of your string in revesre case: ",0

userString BYTE 150 DUP (0)												;array to store user string input
vowelString BYTE "aAeEiIoOuU",0											;array containing vowels
numVowels DWORD 0														;variable to store number of vowels found in string

.code																	;beginning of functions
main PROC																;main procedure
	call Crlf															;module function to call a new line
	mov edx, OFFSET msgDivider											;move msgDivider to edx
	call WriteString													;output msgDivider to console
	call Crlf															;module function to call a new line
	mov edx, OFFSET msgIntro											;point to msgIntro string / move to edx register
	call WriteString													;output msgIntro to console for user
	call Crlf															;module function to call a new line
	mov edx, OFFSET msgDivider											;move msgDivider to edx
	call WriteString													;output msgDivider to console
	call Crlf															;module function to call a new line
	call Crlf															;module function to call a new line

	mov edx, OFFSET msgPrompt1											;point to prompt1 for user input / move to edx register
	call WriteString													;output prompt1 to console for user	
	mov edx, OFFSET userString											;point to userString starting address
	mov ecx, LENGTHOF userString										;puts length of array into ecx
	call ReadString														;module function to prompt user input
	call Crlf															;module function to call a new line

	call FlipCase														;calls the FlipCase procedure

	;;; INVOKE directive used to pass pointers and arguments to FindVowels sub-routine. ;;;
	INVOKE FindVowels, ADDR userString, ADDR vowelString, LENGTHOF userString, LENGTHOF vowelString, numVowels

	call CountWords														;calls the CountWords procedure

	INVOKE ExitProcess,0												;return 0 to check completion

main ENDP																;marks end of main procedure

;============================================================================================================================================
FlipCase PROC USES edx eax edi esi ecx
;Flips the case of alphabetical characters in a string (lower -> upper / upper -> lower)
;Receives: userString
;Returns: nothing
;============================================================================================================================================
	
	mov esi, OFFSET userString											;move address of userString into esi

L1:																		;loop checks null to exit & converts lower case to upper case
	mov al, [esi]														;move userString element to al
	cmp al, 0															;check for null terminator marking end of string
	je L4																;if null found jumps to exit loop
	cmp al, 'a'															;compare element to char 'a'
	jb L2																;if ascii value is less jump to L2 check uppercase
	cmp al, 'z'															;compare array element to char 'z'
	ja L3																;if greater char is non-alpha jump to increment array loop
	sub BYTE PTR [esi], 32d												;subtracts decimal value in acsii to convert case

L2:																		;loop converts upper case to lower case
	cmp al, 'A'															;check if value = char 'A'
	jb L3																;if below char is non-alpha jump to increment loop
	cmp al, 'Z'															;check uppercase alpha range
	ja L3																;if above jump to increment array loop
	add BYTE PTR [esi], 32d												;element in range converted by adding ascii decimal value

L3:																		;loop increments array address, restarts loop unconditionally
	inc esi																;increments address to point to next element
	jmp L1																;unconditional jump to start of loop with no counter decrement

L4:																		;exit loop
	mov edx, OFFSET msgRevCase											;moves msgRevCase prompt to edx
	call WriteString													;module function to output string to console
	mov edx,OFFSET userString											;move userString array to edx
	call WriteString													;module function to output string to console
	call Crlf															;module function to call a new line

	ret																	;returns to main procedure

	FlipCase ENDP														;marks end for FlipCase procedure

;============================================================================================================================================
FindVowels PROC USES eax edx esi edi, ptrArray1:PTR BYTE, ptrArray2:PTR BYTE, array1Size:DWORD, array2Size:DWORD, vowelHits:DWORD
;compares elements in two arrays, updates variable when match found and displays result in console
;Receives: two Byte pointers, two arguments for size of arrays, variable for matches
;Returns: nothing
;============================================================================================================================================

	mov esi, ptrArray1													;move address of first element in userString to esi
	mov edi, ptrArray2													;move address of first element in vowelString to edi

L1:																		;exits upon null userString increments userString if null vowelString
	mov al, [esi]														;move userString index in esi to al register
	cmp al, 0															;check for null terminator
	je L4																;if null jump to exit loop
	mov dl, [edi]														;move vowelString index in edi to dl register
	cmp dl, 0															;check for null terminator
	je L3																;if null jump to increment userString loop
	cmp al, dl															;compare the elements in userString and vowelString
	je L2																;match jumps to L2 to increment match count and userString index
	inc edi																;no match increments vowelString index
	jmp L1																;unconditional jump to start of loop with no counter decrement

L2:																		;loop index match found updates count resets vowelString address
	add numVowels, 1													;count variable numVowels incremented
	inc esi																;userString index incremented
	mov edi, OFFSET vowelString											;vowelString index reset to starting address
	jmp L1																;unconditional jump to L1 with no counter decrement

L3:																		;loop no match/ increments userString address resets vowelString
	inc esi																;userString index incremented
	mov edi, OFFSET vowelString											;vowelString index reset to starting address
	jmp L1																;unconditional jump to L1 with no counter decrement

L4:																		;exit loop outputs results to console
	mov edx, OFFSET msgNumVowels										;move prompt to edx
	call WriteString													;module function to output string to console
	mov eax, numVowels													;move number of vowel matches to eax
	call WriteDec														;fucntion to display unsigned int in console
	call Crlf															;module function to call a new line

	ret																	;returns to main procedure

	FindVowels ENDP														;marks end of FindVowels procedure

;============================================================================================================================================
CountWords PROC USES edx eax edi esi ecx
;Scans array to find [space] character and updates count in variable for matching elements
;Receives: userString
;Returns: nothing
;============================================================================================================================================

.data
numWords DWORD 1

.code
	mov esi, OFFSET userString											;move address of userString into esi

L1:																		;loop checks null to exit & and checks for [space]
	mov al, [esi]														;move userString element to al
	cmp al, 0															;check for null terminator marking end of string
	je L3																;if null found jumps to exit loop
	cmp al, ' '															;compare element to char ' '
	je L2																;if ascii value is equal jump to L2
	inc esi																;not equal increment array index
	jmp L1																;unconditional jump to L1 without counter decrement

L2:																		;loop increments variable for vowel matches
	add numWords, 1														;numWords incremented by one if match found
	inc esi																;increment index of array
	jmp L1																;unconditional jump to L1

L3:																		;exit loop
	mov edx, OFFSET msgNumWords											;moves msgNumWords prompt to edx
	call WriteString													;module function to output string to console
	mov eax, numWords													;move numWords to eax
	call WriteDec														;module function to output string to console
	call Crlf															;module function to call a new line
	call Crlf															;module function to call a new line

	ret																	;returns to main procedure

	CountWords ENDP														;marks end for CountWords procedure

END main																;marks end of program