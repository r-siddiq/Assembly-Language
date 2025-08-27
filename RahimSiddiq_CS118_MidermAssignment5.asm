TITLE Rahim Siddiq CS118 Midterm Assignment 5							(RahimSiddiq_CS118_MidermAssignment5.asm)

COMMENT !
Program description: Midterm on Chapter 6. This program asks the user to input 5 temperatures between 0 and 100 (Invalid entries are
rejected, such as temperatures below 0 and above 100).
(1) Calculates and displays average temperature.
(2) Finds and displays the lowest temperature.
(3) Finds and displays the higest temperature.
(4) Counts and displays the number of times the temperature was above 50 degrees.

Author: Rahim Siddiq
Date: 11/03/2022
!

INCLUDE Irvine32.inc													;Import library
.386																	;.386 directive allows program to access 32 bit registers
.model flat,stdcall														;flat memory model protected mode
.stack 4096																;directive to assembler for how many bytes reserved for stack
ExitProcess PROTO,dwExitCode:DWORD										;exit process function declaration

MAXTEMP = 100															;constant variable for maximum temp
MINTEMP = 0																;constant variable for minimum temp

.data																	;area to designate variables
;;;;;;;;;; Description of program function to user ;;;;;;;;;;
msgIntro BYTE " Program takes 5 temperature inputs and outputs the average, lowest, highest, and frequency of comfotable temperatures.",0
msgDivider BYTE "=======================================================================================================================",0
msgPrompt BYTE "----------------------------------------- Please enter 5 temperature readings -----------------------------------------",0
msgPrompt1 BYTE " Please enter a temperature, then press enter to continue: ",0
msgAvgTemp BYTE " The average of the temperatures you entered is: ",0
msgLowTemp BYTE " The lowest temperature in the sample is: ",0
msgHighTemp BYTE " The highest temperature in the sample is: ",0
msgAbove50 BYTE " The number of times the temperature was 50 degrees or higher: ",0
msgError BYTE " ************ The temperature entered cannot be below 0 or above 100, please re-enter the last temperature ************",0

arrayInputTemp DWORD 5 DUP (0)											;array to store user input temperatures
tempAvg DWORD 0															;variable to store average temp
numMTemp DWORD 0														;variable to store number of temp > 50
cTemp DWORD 50															;sentinel value
lowTemp DWORD 0															;variable to store low temp
highTemp DWORD 0														;variable to store high temp

.code																	;beginning of functions
main PROC																;main procedure
	mov edx, OFFSET msgIntro											;point to msgIntro string / move to edx register
	call WriteString													;output msgIntro to console for user
	call Crlf															;module function to call a new line
	call Crlf															;module function to call a new line
	call Crlf															;module function to call a new line
	mov edx, OFFSET msgPrompt											;move msg prompt for user input to edx
	call WriteString													;module function outputs msgPrompt to console
	call Crlf															;module function to call a new line
	call Crlf															;module function to call a new line

	call UserInput														;calls procedure to get/validate user input
	call AvgTemp														;calls procedure to sum temps and div for average
	call FindMid														;calls procedure to find temps > 50
	call FindLow														;calls procedure to find low temp
	call FindHigh														;calls procedure to find high temp
	call DisplayTemp													;calls procedure to display outputs

	INVOKE ExitProcess,0												;return 0 to check completion

main ENDP																;marks end of main procedure

;==================================================================================================================================
;UserInput
;procedure promts for input and takes 5 user inputs. Each input is validated then stored to esi (arrayInputTemp)
;all registers are restored on return
;==================================================================================================================================

UserInput PROC															;user input procedure start
	pushad																;push all register content to stack
	mov esi, OFFSET arrayInputTemp										;point to arrayInputTemp
	mov ecx, LENGTHOF arrayInputTemp									;puts length of array into ecx for counter

L1:
	mov edx, OFFSET msgPrompt1											;point to prompt1 for user input / move to edx register
	call WriteString													;output prompt1 to console for user
	call Readint														;module function to allow user integer input
	cmp eax, MAXTEMP													;userinput > 100
	jg L2																;jump if greater than max to output error msg
	cmp eax, MINTEMP													;userinput < 0
	jl L2																;jump if less than min to output error msg
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

UserInput ENDP															;end of user input procedure

;==================================================================================================================================
;AvgTemp
;procedure sums the values in esi arrayInputTemp then divides by the length of array. stores them to tempAvg variable. All
;registers restored on return
;==================================================================================================================================

AvgTemp PROC															;start of average temp procedure
	pushad																;push all register content to stack
	mov eax,0															;clear eax register
	mov esi, OFFSET arrayInputTemp										;point to array
	mov ecx, LENGTHOF arrayInputTemp									;puts length of array into ecx for counter

L1:																		;start loop
	add eax, [esi]														;add each integer to sum
	add esi,TYPE DWORD													;point to next integer in array
	loop L1																;repeat for array size

	mov esi, OFFSET arrayInputTemp										;point to array
	mov ecx, LENGTHOF arrayInputTemp									;loop count
	sub edx, edx														;clearing remainder
	div ecx																;divides sum of array for average
	mov tempAvg, eax													;moves average into variable
	popad																;restores all registers
	ret																	;returns to main procedure average in tempAvg

AvgTemp ENDP															;end of average procedure

;==================================================================================================================================
;FindMid
;procedure scans array for temps >= 50. Results stored in numMTemp. All registers restored on return
;==================================================================================================================================

FindMid PROC															;start of procedure for temps > 50
	pushad																;push register content to stack
	mov	eax,0															;clear eax register
	mov	edx,cTemp														;sentinel value moved to edx
	mov esi, 0															;clear esi register
	mov ecx, LENGTHOF arrayInputTemp									;loop counter length of array

L1:
	cmp	esi,ecx															;compares inital condition to force loop
	jl L2																;branches to l2 while counter not 0
	jmp	L5																;jumps out of loop to exit

L2:
	cmp	arrayInputTemp[esi*4], edx										;compares array position value to sentinel value
	jge L3																;if greater or equal branches to L3
	jmp L4																;jumps to L4 if conditon is not met

L3:
	add	eax, 1															;eax holds tally of temps > 50

L4:
	inc	esi																;increments esi to compare to ecx for nested loop
	jmp	L1																;jumps to start of loop

L5:
	mov numMTemp, eax													;moves value in eax to variable numMTemp
	popad																;restores content of registers
	ret																	;returns to main

FindMid ENDP															;end of Mid procedure

;==================================================================================================================================
;FindLow
;procedure scans array for lowest temp. Results stored in lowTemp. All registers restored on return
;==================================================================================================================================

FindLow PROC															;start of procedure to find lowest temp
	pushad																;push register content to stack
	mov	eax, MAXTEMP													;mov eax 100 maximum temp allowed
	mov	edi, 0															;0 index for loop
	mov esi, 0															;clear esi
	mov ecx, LENGTHOF arrayInputTemp									;loop counter

L1:																		;start of loop
	cmp	edi,ecx															;conditon to force loop to length of array
	jl L2																;jump if less than
	jmp L5																;unconditonal jump to exit

L2:																		;compare loop
	cmp	arrayInputTemp[esi*4], eax										;compares value in array to eax
	jle L3																;jump if less than or equal to
	jmp L4																;unconditional jump to inc index

L3:																		;add lower value loop
	mov eax, 0															;clear eax register
	add	eax, arrayInputTemp[esi*4]										;add array value to eax

L4:																		;continue loop
	inc	edi																;increment counter
	inc esi																;increment array
	jmp	L1																;jump to start

L5:																		;exit loop
	mov	lowTemp, eax													;store eax in variable lowTemp
	popad																;restore registers
	ret																	;return main

FindLow ENDP															;end of FindLow procedure

;==================================================================================================================================
;FindHigh
;procedure scans array for highest temp. Results stored in highTemp. All registers restored on return
;==================================================================================================================================

FindHigh PROC															;start of procedure to find higest temp
	pushad																;push register content to stack
	mov	eax, MINTEMP													;mov eax to MINTEMP for lowest temp allowed
	mov	edi, 0															;0 index for loop
	mov esi, 0															;clear esi
	mov ecx, LENGTHOF arrayInputTemp									;loop counter

L1:																		;start of loop
	cmp	edi,ecx															;conditon to force loop to length of array
	jl L2																;jump if less than
	jmp L5																;unconditonal jump to exit

L2:																		;compare loop
	cmp	arrayInputTemp[esi*4], eax										;compares value in array to eax
	jge L3																;jump if greater than or equal to
	jmp L4																;unconditional jump to inc index

L3:																		;add higher value loop
	mov eax, 0															;clear eax register
	add	eax, arrayInputTemp[esi*4]										;add array value to eax

L4:																		;continue loop
	inc	edi																;increment counter
	inc esi																;increment array
	jmp	L1																;jump to start

L5:																		;exit loop
	mov	highTemp, eax													;store eax in variable highTemp
	popad																;restore registers

	ret																	;return main

FindHigh ENDP															;end of FindHigh procedure

;==================================================================================================================================
;DisplayTemp
;procedure displays all output prompts with edx and all variables with eax. all registers restored on return
;==================================================================================================================================

DisplayTemp PROC
	pushad																;push 32 bit registers to stack
	call Crlf															;module function to call a new line
	mov edx, OFFSET msgDivider											;move format divider into edx
	call WriteString													;module function outputs string to console
	call Crlf															;module function to call a new line
	call Crlf															;module function to call a new line

	mov edx, OFFSET msgLowTemp											;move prompt for low temp edx
	call WriteString													;module function outputs string to console
	mov eax, lowTemp													;move low temp variable into eax
	call WriteInt														;module function to output int to console
	call Crlf															;module function to call a new line

	mov edx, OFFSET msgHighTemp											;move prompt for high temp edx
	call WriteString													;module function outputs string to console
	mov eax, highTemp													;move high temp variable into eax
	call WriteInt														;module function to output int to console
	call Crlf															;module function to call a new line

	mov edx, OFFSET msgAbove50											;move prompt for number for temps >= 50 edx
	call WriteString													;module function outputs string to console
	mov eax, numMTemp													;move mid temp variable into eax
	call WriteInt														;module function to output int to console
	call Crlf															;module function to call a new line

	mov edx, OFFSET msgAvgTemp											;move prompt for average temp edx
	call WriteString													;module function outputs string to console
	mov eax, tempAvg													;move mid temp variable into eax
	call WriteInt														;module function to output int to console
	call Crlf															;module function to call a new line

	call Crlf															;module function to call a new line
	mov edx, OFFSET msgDivider											;move format divider into edx
	call WriteString													;module function outputs string to console
	call Crlf															;module function to call a new line

	popad																;restore 32 bit registers
	ret																	;return main

DisplayTemp ENDP														;end of DisplayTemp procedure

END main																;marks end of program