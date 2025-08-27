TITLE Rahim Siddiq CS118 Assignment 4			(RahimSiddiq_CS118_Assignment4.asm)

COMMENT !
Program description: This program clears the screen, locates the cursor near the middle of the screen, prompts the user for two 
integers, adds the integers, and displays their sum. Using the preceding function as a starting point, this program loops the same 
steps three times and clears the screen
!
; Author: Rahim Siddiq
; Date: 10/19/2022

INCLUDE Irvine32.inc												; Import library
.386																; .386 directive allows program to access 32 bit registers
.model flat,stdcall													; flat memory model protected mode 
.stack 4096															; directive to assembler for how many bytes reserved for stack
ExitProcess PROTO,dwExitCode:DWORD									; exit process function declaration

.data																; area to designate variables
msgIntro BYTE " Please enter two numbers to see their sum",0		; description of program function to user
msgSum BYTE " The sum of the two numbers entered is: ",0			; output message upon program completion of sum
prompt1 BYTE " Provide the first number, then press enter: ",0		; prompt to user for first number entry
prompt2 BYTE " Provide the second number, then press enter: ",0		; prompt to user for second number entry
userInput1 DWORD ?													; variable to store first user input
userInput2 DWORD ?													; variable to store second user input
theSum DWORD ?														; variable to store the sum of user inputs

.code																; beginning of functions
main PROC															; main procedure
	;;; Original assignment task ;;;
	call FormatInput												; calls FormatInput subroutine procedure
	call CalcDisplay												; calls CalcDisplay subroutine procedure
	call Crlf														; module function for new line
	call WaitMsg													; module function displays message wait for keypress
	
	;;; Second task to loop program 3 times ;;;
	mov ecx,3														; loop counter for second assignment objective
	L1:																; start of loop
	call FormatInput												; calls FormatInput subroutine procedure
	call CalcDisplay												; calls CalcDisplay subroutine procedure
	call Crlf														; module function to call a new line
	call WaitMsg													; module function displays message wait for keypress
	loop L1															; loop directive

	INVOKE ExitProcess,0											; return 0 to check completion

main ENDP															; marks end of main procedure

;----------------------------------------------------------------------------------------------------------------------
; FormatInput
; subroutine clears screen, locates cursor, and prompts the user for two integers.
;----------------------------------------------------------------------------------------------------------------------

FormatInput PROC													; start of loop procedure

	;;; Formatting / locate cursor :::
	call Clrscr														; module function to clear the screen
	mov dh,10														; passing y-coordinate for row 10
	mov dl,35														; passing x-coordinate for column 20
	call GotoXY														; module function to locate cursor

	;;; First & second user inputs ;;;
	mov edx, OFFSET msgIntro										; point to msgIntro string / move to edx register
	call WriteString												; output msgIntro to console for user
	call Crlf														; module function to call a new line
	call Crlf														; module function to call a new line
	mov edx, OFFSET prompt1											; point to prompt1 for user input / move to edx register
	call WriteString												; output prompt1 to console for user
	call ReadInt													; module function to allow user integer input
	mov userInput1,eax												; move user input to eax register
	call Crlf														; module function to call a new line

	mov edx, OFFSET prompt2											; point to prompt1 for user input / move to edx register
	call WriteString												; output prompt1 to console for user
	call ReadInt													; module function to allow user integer input
	mov userInput2,eax												; move user input to eax register
	call Crlf														; module function to call a new line
	ret																; directive returns to main procedure

FormatInput ENDP													; end of FormatInput procedure

;----------------------------------------------------------------------------------------------------------------------
; CalcDisplay
; subroutine calculates theSum and then outputs result to console for the user
;----------------------------------------------------------------------------------------------------------------------

CalcDisplay PROC													; start of loop procedure
	mov eax,0														; clear eax register

	;;; Calculations ;;;
	mov eax,userInput1												; move first user input to eax
	add eax,userInput2												; add second input to eax
	mov theSum,eax													; place sum in variable theSum

	;;; Display output to console ;;;
	mov edx, OFFSET msgSum											; program output prompt
	call WriteString												; output msgSum to console for user 
	mov theSum,eax													; move calculation output to eax register
	call WriteInt													; output result of calculation to console for user
	call Crlf														; module function to call a new line
	ret																; directive returns to main procedure

CalcDisplay ENDP													; end of SumLoop procedure

END main															; marks end of program