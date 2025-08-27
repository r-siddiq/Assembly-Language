TITLE Rahim Siddiq CS118 Assignment 7												(RahimSiddiq_CS118_Assignment7.asm)

COMMENT !
Program description: Program finds similar elements in two seperate pairs of arrays with a procedure named CountNearMatches.

Author: Rahim Siddiq
Date: 11/27/2022
!

INCLUDE Irvine32.inc																;Import library
.386																				;.386 directive allows program to access 32 bit registers
.model flat,stdcall																	;flat memory model protected mode
.stack 4096																			;directive to assembler for how many bytes reserved for stack
ExitProcess PROTO, dwExitCode:DWORD													;exit process function declaration

;;; Function prototype declaration for CountNearMatches procedure. 4 defined elements two pointers and two DWORD arguments. ;;;
CountNearMatches PROTO, ptrArraySet1:PTR SDWORD, ptrArraySet2:PTR SDWORD, arraySize:DWORD, matchSpec:DWORD

.data
;;; Program messages to user for program functions and errors ;;;
msgIntro BYTE " Program finds matches within specified range for two seperate pairs of arrays with a procedure named CountNearMatches.",0
msgDivider BYTE " =======================================================================================================================",0
msgHits1 BYTE " The number of matches within the specified range for the first set of arrays is: ",0
msgHits2 BYTE " The number of matches within the specified range for the second set of arrays is: ",0

arraySet_1a SDWORD 3,18,8,12,5,1,8,5,11,13
arraySet_1b SDWORD 10,18,1,3,2,6,12,16,18,10
arraySet_2a SDWORD 9,15,4,18,1,5,0,3,5,14
arraySet_2b SDWORD 19,0,2,12,13,19,6,6,9,10
matchSpec1 DWORD 5
matchSpec2 DWORD 10
specHits DWORD ?

.code
main PROC
	call Crlf																		;module function to call a new line
	mov edx, OFFSET msgDivider														;move msgDivider to edx
	call WriteString																;output msgDivider to console
	call Crlf																		;module function to call a new line
    mov edx, OFFSET msgIntro														;point to msgIntro string / move to edx register
	call WriteString																;output msgIntro to console for user
	call Crlf																		;module function to call a new line
	mov edx, OFFSET msgDivider														;move msgDivider to edx
	call WriteString																;output msgDivider to console
	call Crlf																		;module function to call a new line
	call Crlf																		;module function to call a new line

	;;; Invoke directive used to pass arguments to sub-routine. ADDR operator used to pass pointers to starting address' of the arrays ;;;
	INVOKE CountNearMatches, ADDR arraySet_1a, ADDR arraySet_1b, LENGTHOF arraySet_1a, matchSpec1

	mov edx, OFFSET msgHits1														;contexual msg for matches in first pair of arrays
	call WriteString																;module function to output string to console
	call WriteDec																	;fucntion to display unsigned int in console
	call Crlf																		;module function to call a new line
	
	;;; Invoke directive used to pass arguments to sub-routine. ADDR operator used to pass pointers to starting address' of the arrays ;;;
	INVOKE CountNearMatches, ADDR arraySet_2a, ADDR arraySet_2b, LENGTHOF arraySet_2a, matchSpec2

	mov edx, OFFSET msgHits2														;contexual msg for matches in second pair of arrays
	call WriteString																;module function to output string to console
	call WriteDec																	;fucntion to display unsigned int in console
	call Crlf																		;module function to call a new line
	call Crlf																		;module function to call a new line

	INVOKE ExitProcess, 0															;return 0 to check completion

main ENDP																			;marks end of main procedure

;============================================================================================================================================
;CountNearMatches
;USES: edx, ebx, edi, esi, and ecx. Registers restored on return.
;Receives pointers for two arrays, arguments for size of array and updates matches to specification in matchSpec
;Returns: results in eax.
;============================================================================================================================================

CountNearMatches PROC USES edx ebx edi esi ecx, ptrArraySet1:PTR SDWORD, ptrArraySet2:PTR SDWORD, arraySize:DWORD, matchSpec:DWORD
	mov esi, ptrArraySet1															;move starting address recd array to esi
	mov edi, ptrArraySet2															;point to starting address of 2nd array
	mov ecx, arraySize																;counter set to size of array

L1:
	mov ebx,0																		;clear ebx register
	mov ebx,[esi]																	;move index of array 1 into ebx
	mov edx,0																		;clear edx register
	mov edx,[edi]																	;move index of array 2 into edx

.IF ebx > edx																		;compmarisson of values in register if array[] 1 > 2
	mov eax,ebx																		;move greater value into eax
	sub eax,edx																		;subtract value of second array to check match param
.ELSE																				;if not greater than
	mov eax,edx																		;move second array into eax
	sub eax,ebx																		;subtract value of first array to check match param
.ENDIF																				;marks the end of conditional

.IF (eax <= matchSpec)																;if value is les than equal to designated parameters
	inc specHits																	;increment variable for number of matches
.ENDIF																				;marks the end of conditional
	add esi, SIZEOF SDWORD															;add sdword to esi to point to the next element
	add edi, SIZEOF SDWORD															;add sdword to edi to point to the next element
	loop L1																			;loop directive

	mov eax,0																		;clear eax register
	mov eax,specHits																;move matches to eax register
	mov specHits,0																	;reset variable for matches
	ret																				;returns to main matches in eax

	CountNearMatches ENDP															;marks end of CountNearMatches procedure

END main																			;marks end of program