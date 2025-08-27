TITLE Rahim Siddiq CS118 Assignment 2			(RahimSiddiq_CS118_Assignment2.asm)

; Program description: This program subtracts three 16-bit integers and displays the values
; Author: Rahim Siddiq
; Date: 09/13/2022

INCLUDE Irvine32.inc							; Import library

.386											; .386 directive allows program to access 32 bit registers
.model flat,stdcall                             ; flat memory model protected mode 
.stack 4096										; directive to assembler for how many bytes reserved for stack
ExitProcess proto,dwExitCode:dword				; exit process function declaration

.data											; area to designate variables
val1 word 200									; variable 1 set to 200
val2 word 20									; variable 2 set to 20
val3 word 39									; variable 3 set to 39
val4 word 41									; variable 4 set to 41

.code											; beginning of functions
main PROC										; main procedure
	mov eax,0									; initialize eax to 0
	mov	ax,val1									; move 200 into 16 bit register			
	sub	ax,val2									; subtract 20 from value in ax register
	sub ax,val3									; subtract 39 from value in ax register
	sub ax,val4									; subtract 41 from value in ax register
	call DumpRegs								; output content of registers

	invoke ExitProcess,0						; return 0 to check completion
main ENDP										; marks end of procedure										
END main										; directive marks end of program