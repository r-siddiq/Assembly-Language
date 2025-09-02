TITLE Rahim Siddiq EuclideanGCD											(EuclideanGCD.asm)

COMMENT !
Program description: Program takes two integer inputs from user and outputs the greatest common denominator (GCD)

Author: Rahim Siddiq
Date: 11/21/2022
!

INCLUDE Irvine32.inc													;Import library
.386																	;.386 directive allows program to access 32 bit registers
.model flat,stdcall														;flat memory model protected mode
.stack 4096																;directive to assembler for how many bytes reserved for stack
ExitProcess PROTO,dwExitCode:DWORD										;exit process function declaration

.data
;;;;;;;;;; Program messages to user for program functions and errors ;;;;;;;;;;
msgIntro BYTE "                   This program finds and displays, the greatest common denominator of two numbers.",0
msgPrompt BYTE " ---------------------------- Enter two numbers to see their greatest common denominator ----------------------------",0
msgDivider BYTE " ====================================================================================================================",0
msgPrompt1 BYTE " Please provide a number, then press [enter] to continue: ",0
msgError BYTE " ***** Invalid input. Please enter a non-zero integer value for number ***** ",0
msgGcd BYTE " The greatest common denominator is: ",0

arrayUserNumChoice SDWORD 2 DUP (0)

.code
main PROC
	call Crlf															;module function to call a new line
    mov edx, OFFSET msgIntro											;point to msgIntro string / move to edx register
	call WriteString													;output msgIntro to console for user
	call Crlf															;module function to call a new line
	mov edx, OFFSET msgDivider											;move msgDivider to edx
	call WriteString													;output msgDivider to console
	call Crlf															;module function to call a new line
	call Crlf															;module function to call a new line
    mov edx, OFFSET msgPrompt											;move msg prompt for user input to edx
	call WriteString													;module function outputs msgPrompt to console
	call Crlf															;module function to call a new line
	call Crlf															;module function to call a new line
	call Crlf															;module function to call a new line
    
	call NumberChoice													;calls procedure to get/validate user input
	
	mov ecx, LENGTHOF arrayUserNumChoice /2								;every two elements of array
	mov esi, OFFSET arrayUserNumChoice									;point to array

L1:																		;start loop
	mov edi,2															;loop counter for individual element

L2:																		;loop checks for negative value
	mov eax, [esi]														;move array element to eax
	add esi, 4															;increment esi byte size of array
	cmp eax, 0															;compare to 0 to check negative value
	jl L3																;if negative jump to L3
	jmp L4																;if positive jump to L4

L3:																		;loop converts negative values to positive
	neg eax																;neg insttruction converts negative values

L4:
	push eax															;push contents of eax to stack
	dec edi																;decrement edi
	cmp edi, 0															;check for 0
	jne L2																;if not 0 jmp L2 for second element
	call CalcGcd														;call to CalcGcd procedure
	
	mov edx, offset msgGcd												;move output message to edx
	call writeString													;function prints edx content to console
	call writeDec														;print final result in eax to console
	call Crlf															;module function to call a new line
	call Crlf															;module function to call a new line
	loop l1																;loop directive

    INVOKE ExitProcess, 0												;return 0 to check completion

main ENDP																;marks end of main procedure

;==================================================================================================================================
;NumberChoice
;procedure prompts user for input of two integers. Input is validated then stored to esi (arrayUserNumChoice)
;all registers are restored on return
;==================================================================================================================================

NumberChoice PROC														;user input procedure start
	pushad																;push all register content to stack
	mov eax, 0
	mov esi, OFFSET arrayUserNumChoice									;point to arrayInputTemp
	mov ecx, LENGTHOF arrayUserNumChoice								;puts length of array into ecx for counter

L1:
	mov edx, OFFSET msgPrompt1											;point to prompt1 for user input / move to edx register
	call WriteString													;output prompt1 to console for user
	call Readint														;module function to allow user integer input
	cmp eax, 0															;userinput cannot be 0
	je L2																;jump L2 for error if value entered is 0
	mov [esi], eax														;move eax contents into array
	add esi, TYPE DWORD													;point at next location in array
	loop L1																;loop directive
	popad																;restore all registers
	ret																	;returns to main

L2:
	call Crlf															;module function calls a new line
	mov edx, OFFSET msgError											;move error msg into edx
	call WriteString													;module funciton to output error msg to console
	call Crlf															;module function calls a new line
	call Crlf															;module function calls a new line
	jmp L1																;unconditional jump to restart loop w/o counter decriment

NumberChoice ENDP														;end of user input procedure

;==================================================================================================================================
;CalcGcd
;procedure calculates the greatest common denominator for two elements in arrayUserNumChoice.
;uses: data in edi, eax, ebx returns result in eax
;==================================================================================================================================

CalcGcd PROC															;start of procedure to find higest temp
	pop edi																;restore edi register
	pop eax																;restore eax register
	pop ebx																;restore ebx register

L1:																		;division loop
	mov edx, 0															;clear edx register
	div ebx																;div eax by ebx
	mov eax, ebx														;move result to eax
	mov ebx, edx														;move remainder to ebx
	cmp ebx, 0															;check if remainder generated
	jg L1																;if remainder jump to start of loop
	push edi															;restore loop count
	ret																	;return result in eax

CalcGcd ENDP															;end of CalcGcd procedure

END main																;marks end of program