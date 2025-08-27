TITLE Rahim Siddiq CS118 Assignment 3			(RahimSiddiq_CS118_Assignment3.asm)

; Program description: This program uses a loop function and indirect addressing to copy a string from source to target in reverse order.
; Author: Rahim Siddiq
; Date: 10/04/2022

INCLUDE Irvine32.inc							; Import library

.386											; .386 directive allows program to access 32 bit registers
.model flat,stdcall                             ; flat memory model protected mode 
.stack 4096										; directive to assembler for how many bytes reserved for stack
ExitProcess proto,dwExitCode:dword				; exit process function declaration

.data											; area to designate variables
source BYTE "This is the source string",0		; source variable
target BYTE SIZEOF source DUP('#')				; target variable

.code											; beginning of functions
main PROC										; main procedure
	mov esi,0									; clear index register
	mov edi, LENGTHOF source - 2				; find length for source subtract 2 and move to edi
	mov ecx, SIZEOF source						; loop counter
	L1:											; start of loop
		mov al,source[esi]						; get value for source in esi move to al
		mov target[edi],al						; move al into target array in edi
		inc esi									; increment value in esi
		dec edi									; decrement value in edi
		loop L1									; loop directive

	mov edx, OFFSET target						; get address for target move to edx
	call WriteString							; print string

	invoke ExitProcess,0						; return 0 to check completion
main ENDP										; marks end of procedure										
END main										; directive marks end of program