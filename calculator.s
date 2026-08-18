.data
Input:	.space 20 @fills 20 bytes with 00. This is also where the string is stored.
Operand1_A:			.space 4 @This is where the first operand is stored in ascii.
Operand1B:			.space 1 @This will tell us the length of the number.
Operand1C:			.space 1 @This will tell us if the number is negative or not. 1 means yes, 0 means no.
Operand1_H:			.byte 0x00 @This is where the first operand is stored in hex
Operand2_A:			.space 4 @This is where the second operand is stored in ascii.
Operand2B:			.space 1 @This will tell us the length of the number.
Operand2C:			.space 1 @This will tell us if the number is negative or not. 1 means yes, 0 means no.
Operand2_H:			.byte 0x00 @This is where the second operand is stored in hex
Space1:				.word 0x00 @saves the address of the first space
Space2:				.word 0x00 @saves the address of the second space
Newline:			.word 0x00 @saves the address of the newline
Result_H:			.word 0x00 @This is where the results from the calculations are being stored.
Result_A:			.space 8
Result_N:			.space 1 @Save's the result negaive if it is
Operator:			.space 1
@////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@														PROMPT- the numbers refer to how many spaces each one takes
@////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
PROMPT0:		.ascii "	Hello and welcome to the Calculator Program.\n" @46
PROMPT1:		.ascii "Imput Algebraic Command Line Here:" @34
PROMPT4:		.ascii "Operators: + - * /\n"@22
PROMPT5:		.ascii "Manuel)\n"@8
PROMPT6:		.ascii "Input Format: Operand1 Operator Operand2\n"@41
PROMPT7:		.ascii "Example:12 + 100\n"@17
PROMPT8:		.ascii ":( Error:Please do not input more than two spaces.\n"@51
PROMPT9:		.ascii ":( Error:Please imput a number between -128 to 127.\n"@52
PROMPT12:		.ascii ":( Error:Please insert only one newline.\n"@41
PROMPT14:		.ascii ":( Error:Please insert two spaces. One after Operand1 and one after the Operator.\n" @82
PROMPT15:		.ascii "\n:( Error:Either the equation you inputed is too long or you didn't press enter after inputing the equation. Please follow the Manuel.\n"@135
PROMPT16:		.ascii "Only numbers between -128 to 127 are supported and can be entered to both operands.\n."@93
PROMPT19:		.ascii ":( Error:Operator1 has no numbers inputed.\n"@43
PROMPT20:		.ascii ":( Error:Operator1 has too many figures.\n"@41
PROMPT21:		.ascii ":( Error:Operator2 has no numbers inputed.\n"@43
PROMPT22:		.ascii ":( Error:Operator2 has too many figures.\n"@41
PROMPT23:		.ascii ":( Error:There is nothing inputed in the operand.\n"@50
PROMPT24:		.ascii ":( Error:The operand is too long.\n"@34
PROMPT25:		.ascii ":( Error:For Operand1 use: 0,1,2,3,4,5,6,7,8, or 9 as the input. Please DO NOT use any other values.\n"@101
PROMPT26:		.ascii ":( Error:For Operand2 use: 0,1,2,3,4,5,6,7,8, or 9 as the input. Please DO NOT use any other values.\n"@101
PROMPT27:		.ascii ":( Error:For the Operator use: +,-,*, or /. Please DO NOT use any other values.\n"@80
PROMPT28: 		.ascii ":( Error:You cannot divide by zero.\n"
PROMPT29:		.ascii ":( Error:Operand1's number that has been inputed is out of range.\n"@67
PROMPT30:		.ascii ":( Error:Operand2's number that has been inputed is out of range.\n"@67
PROMPT31:		.ascii "Operand 1:"@10
PROMPT32:		.ascii "Operand 2:"@10
PROMPT33:		.ascii "\n"@1
PROMPT34:		.ascii "Operator:"@9
PROMPT35:		.ascii "Result:"@7
PROMPT36:		.ascii "-"@1
@////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@													TEXT AND GLOBAL MAIN
@////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
.text
.global main

@////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@													Macro
@////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
.macro sdiv result_reg, A_reg, B_reg
    push {r4, r5, r6, lr}

    @ r4 = dividend
    @ r5 = divisor
    @ r6 = result sign
    mov r4, \A_reg
    mov r5, \B_reg
    mov r6, #0

    @ Determine result sign
    cmp r4, #0
    bge sdiv_check_b

    eor r6, r6, #1

    @ absolute value of dividend
    rsb r4, r4, #0

sdiv_check_b:
    cmp r5, #0
    bge sdiv_start

    eor r6, r6, #1

    @ absolute value of divisor
    rsb r5, r5, #0

sdiv_start:
    mov \result_reg, #0

    @ dividend < divisor => quotient = 0
    cmp r4, r5
    blt sdiv_sign

sdiv_loop:
    add \result_reg, \result_reg, #1
    sub r4, r4, r5

    cmp r4, r5
    bge sdiv_loop

sdiv_sign:
    @ If sign == 1, negate result
    cmp r6, #0
    beq sdiv_done

    rsb \result_reg, \result_reg, #0

sdiv_done:
    pop {r4, r5, r6, lr}
.endm
@////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@													SUBROUTINES
@////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@_______________________________________________________________________________________________________________________________________________________________________________
@				Subroutine #1- Checks for the postion of the spaces and the newline. This is done to know the length of the numbers. The Length is also stored in the stack
@_______________________________________________________________________________________________________________________________________________________________________________
SUB1:
	ldr r4,=Input
	mov r9, #0
	mov r0, #0
	mov r1, #0
	mov r2, #0
	mov r3, #0
	mov r11, #4 @sets up the loop to run 4 times
	mov r1, #5 @sets up loop2 to run 5 times
	mov r2, #0xff @sets the first bit of the word to be selected.
	
	SUB1_loop2:
		ldr r5,[r4] @loads the word to be tested
		mov r10, #0 @resets the counter when loading in parts of the word.
		SUB1_loop:
			and r3,r2,r5
			mov r6,#32 @loads in the space value
			cmp r3,r6
			BEQ SpaceSUB @checks if the number is equal to a space or not. If it is, then it will branch, if not, then it will continue.
			mov r6,#10 
			cmp r3,r6
			BEQ NewlineSUB @checks if the number is equal to a newline or not. If it is, then it will branch, if it is not, then it will continue.
SUB1_continue:
			add r10,r10,#1
			lsr r5,#8
			add r4,r4,#1
			cmp r10,r11
			BLE SUB1_loop @compares the counters. If it has looped 6 times or more, then it will exit. If not, then it will branch.		
			sub r4,r4,#1
			add r9,r9,#1
			cmp r1,r9
			BGE SUB1_loop2
			
			mov r6,#2
			cmp r8,r6
			BLO Error2_SUB1 @Checks if there are less than 2 spaces. If so it will branch.
			mov r6,#0
			cmp r6,r7
			BEQ Error4_SUB1 @Checks if there are no newlines. If so it will branch.			
			B Code0_SUB1	
	SpaceSUB:
			add r8,r8, #1
			mov r6,#1
			cmp r6,r8
			BEQ Space1_SUB1 @Sees if the first space has been found or not. If so, then it will branch. If not, then it will exit.
			mov r6,#2
			cmp r6,r8
			BEQ Space2_SUB1 @Sees if the second space has been found or not. If so, then it will branch. If not, then it will exit.
			B Error1_SUB1
	NewlineSUB:
			add r7,r7,#1
			mov r6,#1
			cmp r6,r7
			BEQ Newline_SUB1
			B Error3_SUB1			
	Space1_SUB1:
			ldr r6, =Space1
			str r4,[r6]
			B SUB1_continue
	Space2_SUB1:
			ldr r6,=Space2
			str r4,[r6]
			B SUB1_continue
	Newline_SUB1:
			ldr r6,=Newline
			str r4,[r6]
			B SUB1_continue
	Error1_SUB1: @Error Code 1:Greater than 2 spaces.
			mov r0,#1
			B END_SUB1
	Error2_SUB1: @Error Code 2: Less than 2 spaces.
			mov r0,#2	
			B END_SUB1
	Error3_SUB1: @Error Code 3:Greater than 1 newline.
			mov r0,#3
			B END_SUB1
	Error4_SUB1: @Error Code 4:Less than 1 newline.
			mov r0,#4
			B END_SUB1
	Code0_SUB1:
			mov r0,#0
			B END_SUB1
	END_SUB1:
			mov r1,#0
			mov r2,#0
			mov r3,#0
			@compare if there are no spaces or no newlines
			BX LR
@____________________________________________________________________________________________________________________________________________________
@		Subroutine 2-Initalizes the general purpose registers
@____________________________________________________________________________________________________________________________________________________
SUB2:
	mov r4, #0
	mov r5, #0
	mov r6, #0
	mov r7, #0
	mov r8, #0
	mov r10, #0
	mov r11, #0
	BX LR
@____________________________________________________________________________________________________________________________________________________	
@		Subroutine 3-Prints off Codes
@____________________________________________________________________________________________________________________________________________________
SUB3:
@Gets Registers ready
		mov r3,r0
		mov r7,#4
		mov r0,#1
@Possible branch to Code1		
		cmp r3,#1
		BEQ Code1
@Possible branch to Code2		
		cmp r3,#2
		BEQ Code2
@Possible branch to Code3		
		cmp r3,#3
		BEQ Code3
@Possible branch to Code4		
		cmp r3,#4
		BEQ Code4
@Possible branch to Code7		
		cmp r3,#7
		BEQ Code7
@Possible branch to Code8		
		cmp r3,#8
		BEQ Code8
@Branches to Code9 if 9 is in r0		
		cmp r3,#9
		BEQ Code9
@Branches to Code10 if 10 is in r0		
		cmp r3,#10
		BEQ Code10
@Branches to Code11 if 11 is in r0		
		cmp r3,#11
		BEQ Code11		
@Branches to Code12 if 12 is in r0		
		cmp r3,#12
		BEQ Code12
@Branches to Code14 if 14 is in r0
		cmp r3,#14
		BEQ Code14
@Branches to Code15 if 15 is in r0
		cmp r3,#15
		BEQ Code15									
@Branches to Code16 if 16 is in r0
		cmp r3,#16
		BEQ Code16										
@Branches to Code18 if 18 is in r0
		cmp r3,#18
		BEQ Code18		
@Branches to Code19 if 19 is in r0
		cmp r3,#19
		BEQ Code19	
@ Branch to Code20 for division by zero
		cmp r3,#20
		BEQ Code20	
		
		B END_SUB3		
		
@prints:Please do not input more than two spaces.			
	Code1:
			@ Prints Strings
			mov r0,#1
			mov r2,#51
			ldr r1,=PROMPT8
			swi 0 
			mov r0,#1
			mov r2,#17
			ldr r1,=PROMPT7
			swi 0 @prints:Example: 12 + 200
			B END_MAIN
	Code2:
			@ Prints Strings
			mov r0,#1
			mov r2,#82
			ldr r1,=PROMPT14
			swi 0 @prints:Please insert two spaces. One after Operand1 and one after the Operator.\n
			mov r0,#1
			mov r2,#17
			ldr r1,=PROMPT7
			swi 0 @prints:Example: 12 + 200
			B END_MAIN
	Code3:
			@ Prints Strings
			mov r0,#1
			mov r2,#41
			ldr r1,=PROMPT12
			swi 0 @prints:Please insert only one newline.
			mov r0,#1
			mov r2,#17
			ldr r1,=PROMPT7
			swi 0 @prints:Example: 12 + 200
			B END_MAIN
	Code4:
			@ Prints Strings
			mov r0,#1
			mov r2,#135
			ldr r1,=PROMPT15
			swi 0 @prints:Either the equation you inputed is too long or you didn't press enter after inputing the equation. Please follow the Manuel.
			mov r0,#1
			mov r2,#17
			ldr r1,=PROMPT7
			swi 0 @prints:Example: 12 + 200
			B END_MAIN
	Code7:
			@ Print: :( Error:operator1 has no numbers Example: 12 + 200
			mov r0,#1
			mov r2,#34
			ldr r1,=PROMPT19
			swi 0 
			mov r0,#1
			mov r2,#17
			ldr r1,=PROMPT7
			swi 0 
			B END_MAIN
	Code8:
			@ Prints Strings
			mov r0,#1
			mov r2,#41
			ldr r1,=PROMPT20
			swi 0 @prints:Operator1 too long
			mov r0,#1
			mov r2,#17
			ldr r1,=PROMPT7
			swi 0 @prints:Example: 12 + 200
			B END_MAIN
	Code9:
			@ Prints String
			mov r0,#1
			mov r2,#43
			ldr r1,=PROMPT21
			swi 0 @prints:Operator 2 has no many numbers
			@ Prints String
			mov r0,#1
			mov r2,#17
			ldr r1,=PROMPT7
			swi 0 @prints:Example: 12 + 200
			B END_MAIN
	Code10:
			@ Prints String
			mov r0,#1
			mov r2,#41
			ldr r1,=PROMPT22
			swi 0 @prints:Operator 2 has too many numbers
			@ Prints String
			mov r0,#1
			mov r2,#17
			ldr r1,=PROMPT7
			swi 0 @prints:Example: 12 + 200
			B END_MAIN
	Code11:
			@ Prints String
			mov r0,#1
			mov r2,#50
			ldr r1,=PROMPT23
			swi 0 @prints:There is nothing in the operand
			mov r0,#1
			mov r2,#17
			ldr r1,=PROMPT7
			swi 0 @prints:Example: 12 + 200
			B END_MAIN
	Code12:	
			@ Prints String
			mov r0,#1
			mov r2,#34
			ldr r1,=PROMPT24
			swi 0 @prints:The operand is too long
			mov r0,#1
			mov r2,#17
			ldr r1,=PROMPT7
			swi 0 @prints:Example: 12 + 200
			B END_MAIN	

	Code14:
			@ Prints String
			mov r0,#1
			mov r2,#101
			ldr r1,=PROMPT25
			swi 0 @prints:For Operand1 use: 0,1,2,3,4,5,6,7,8, or 9 as the input. Please DO NOT use any other values.
			@ Prints String
			mov r0,#1
			mov r2,#17
			ldr r1,=PROMPT7
			swi 0 @prints:Example: 12 + 200
			B END_MAIN	
			

	Code15:
			@ Prints String
			mov r0,#1
			mov r2,#101
			ldr r1,=PROMPT26
			swi 0 @prints:For Operand2 use: 0,1,2,3,4,5,6,7,8, or 9 as the input. Please DO NOT use any other values.
			@ Prints String
			mov r0,#1
			mov r2,#17
			ldr r1,=PROMPT7
			swi 0 @prints:Example: 12 + 200
			B END_MAIN				

	Code16:
			mov r0,#1
			mov r2,#80
			ldr r1,=PROMPT27
			swi 0 @prints:For Operand2 use:For the Operator use: +,-,*, or /. Please DO NOT use any other values.
			mov r0,#1
			mov r2,#17
			ldr r1,=PROMPT7
			swi 0 @prints:Example: 12 + 200
			B END_MAIN				
	Code18:
			@ Prints String
			mov r0,#1
			mov r2,#66
			ldr r1,=PROMPT29
			swi 0 @prints:Operand1's number that has been inputed is out of range.
			@ Prints String
			mov r0,#1
			mov r2,#17
			ldr r1,=PROMPT7
			swi 0 @prints:Example: 12 + 200
			B END_MAIN
			
	Code19:
			@ Prints String
			mov r0,#1
			mov r2,#66
			ldr r1,=PROMPT30
			swi 0 @prints:Operand2's number that has been inputed is out of range.
			@ Prints String
			mov r0,#1
			mov r2,#17
			ldr r1,=PROMPT7
			swi 0 @prints:Example: 12 + 200
			B END_MAIN	
	Code20:
        @ Prints division by zero error
        mov r0,#1
        mov r2,#44
        ldr r1,=PROMPT28
        swi 0
        B END_MAIN		
							
						
	END_SUB3:	mov r3,#0
				BX LR
@____________________________________________________________________________________________________________________________________________________	
@		Subroutine 4-Checks for Negatives in the First and Second Operand
@____________________________________________________________________________________________________________________________________________________

SUB4:
		ldr r4,=Input @loads the string address
		mov r5,#45 @loads the value for the negative sighn
		ldr r8,[r4] @Loads the value of the string
		mov r6, #0xFF @Selects the first byte to be tested
		and r7,r6,r8 @Removes everything but the byte 
		cmp r7,r5 
		BEQ NegativeOP1_SUB4 @checks if the first byte is a negative or not.
		ldr r10, =Operand1C
		mov r11, #0
		strb r11,[r10]
		
SUB4_Continue:
		mov r7, #0
		ldr r4,=Space2 @loads the address of Space2
		ldr r8,[r4] @Loads the address of the second space in the Input
		add r8,r8,#1 @Goes to the address after the second space in Input
		ldr r4,[r8] @Loads the content of the input after the second space.
		and r7,r6,r4 @Removes everything but the byte
		cmp r7,r5 
		BEQ NegativeOP2_SUB4 @checks if the first byte is a negative or not.
		ldr r10, =Operand2C
		mov r11, #0
		strb r11,[r10]
	    B END_SUB4
@Stores #1 in Operand1C to be used later on when figureing out if the operand is negative or not.	
		NegativeOP1_SUB4: 
					ldr r10, =Operand1C
					mov r11, #1
					strb r11,[r10]
					B SUB4_Continue
@Stores #1 in Operand1C to be used later on when figureing out if the operand is negative or not.			
		NegativeOP2_SUB4:
					ldr r10, =Operand2C
					mov r11, #1
					strb r11,[r10]
					B END_SUB4	
	
		END_SUB4:	BX LR

@____________________________________________________________________________________________________________________________________________________	
@		Subroutine 5-Checks the length of the operators and operand.\for Negatives in the First and Second Operand
@____________________________________________________________________________________________________________________________________________________

SUB5:
@loads in the address of the first operand		
		mov r0, #0 @ensures r0 is clear
		ldr r4, =Input
		ldr r5,=Operand1C
		ldrb r6, [r5]
		mov r7, #1
		cmp r6,r7
		BEQ NegativeOP1_SUB5 @If the operand is a negative, then it will branch to add to the address. If not then it will continue.
SUB5_Continue1:

@Checks for Spaces and records the length of the first operand
		ldr r8,[r4]
		mov r10, #0xFF @Selects the first byte to be tested
		and r11,r10,r8 @Removes everything but the byte 
		mov r9, #32
		cmp r9,r11
		BEQ Error7_SUB5 @checks to see if the first value is a space. If so then branch, if not continue.
		lsr r8, #8
		and r11,r10,r8 @Removes everything but the byte 
		cmp r9,r11
		BEQ SUB5A @checks to see if the first value is a space. If so then branch, if not continue.
		lsr r8, #8
		and r11,r10,r8 @Removes everything but the byte 
		cmp r9,r11
		BEQ SUB5B @checks to see if the first value is a space. If so then branch, if not continue.
		lsr r8, #8
		and r11,r10,r8 @Removes everything but the byte 
		cmp r9,r11
		BEQ SUB5C @checks to see if the first value is a space. If so then branch, if not continue.
		B Error8_SUB5

SUB5_Continue2: 
		ldr r4,=Space2 @loads the address of Space2
		ldr r8,[r4] @Loads the address of the second space in the Input
		add r8,r8,#1 @Goes to the address after the second space in Input
		mov r4,r8
		mov r7, #1 @Ensures r7 is one, then used be check for a negative.
		ldr r5,=Operand2C
		ldrb r6, [r5]
		cmp r6,r7
		BEQ NegativeOP2_SUB5 @If the operand is a negative, then it will branch to add to the address. If not then it will continue.
SUB5_Continue3:	

@Checks for Spaces and records the length of the second operand
		ldr r8,[r4]
		mov r10, #0xFF @Selects the first byte to be tested
		and r11,r10,r8 @Removes everything but the byte 
		mov r9, #10
		cmp r9,r11
		BEQ Error9_SUB5 @checks to see if the first value is a space. If so then branch, if not continue.
		lsr r8, #8
		and r11,r10,r8 @Removes everything but the byte 
		cmp r9,r11
		BEQ SUB5D @checks to see if the first value is a space. If so then branch, if not continue.
		lsr r8, #8
		and r11,r10,r8 @Removes everything but the byte 
		cmp r9,r11
		BEQ SUB5E @checks to see if the first value is a space. If so then branch, if not continue.
		lsr r8, #8
		and r11,r10,r8 @Removes everything but the byte 
		cmp r9,r11
		BEQ SUB5F @checks to see if the first value is a space. If so then branch, if not continue.
		B Error10_SUB5		

@Checks the length for the operator
SUB5_Continue4:
		ldr r4,=Space1 @loads the address of Space1
		ldr r8,[r4] @Loads the address of the first space in the Input
		add r8,r8,#1 @Goes to the address after the first space in Input
		mov r4,r8
		ldr r8,[r4]
		mov r10, #0xFF @Selects the first byte to be tested
		and r11,r10,r8 @Removes everything but the byte 
		mov r9, #32
		cmp r9,r11
		BEQ Error11_SUB5 @checks to see if the first value is a space. If so then branch, if not continue.
		lsr r8, #8
		and r11,r10,r8 @Removes everything but the byte 
		cmp r9,r11
		BEQ END_SUB5A @checks to see if the first value is a space. If so then branch, if not continue.
		B Error12_SUB5

@Advances the address if the operand is negative		
		NegativeOP1_SUB5: 
					add r4,r4,#1
					B SUB5_Continue1
		NegativeOP2_SUB5:
					add r4,r4,#1
					B SUB5_Continue3
@Returns corresponding code
		Error7_SUB5:
					mov r0,#7
					B END_SUB5		
		Error8_SUB5:
					mov r0,#8
					B END_SUB5
		Error9_SUB5:
					mov r0,#9
					B END_SUB5
		Error10_SUB5:			
					mov r0,#10
					B END_SUB5
		Error11_SUB5:
					mov r0,#11
					B END_SUB5
		Error12_SUB5:
					mov r0,#12
					B END_SUB5
					
@Stores the length of Operand1 as 1 figure					
		SUB5A: 	ldr r2, =Operand1B
				mov r3, #1
				strb r3, [r2]
				B SUB5_Continue2

@Stores the length of Operand1 as 2 figures				
		SUB5B:	ldr r2, =Operand1B
				mov r3, #2
				strb r3, [r2]
				B SUB5_Continue2

@Stores the length of Operand1 as 3 figures				
		SUB5C:	ldr r2, =Operand1B
				mov r3, #3
				strb r3, [r2]
				B SUB5_Continue2
				
@Stores the length of Operand2 as 1 figure	
		SUB5D:	ldr r2, =Operand2B
				mov r3, #1
				strb r3, [r2]
				B SUB5_Continue4

@Stores the length of Operand2 as 2 figures	
		SUB5E:	ldr r2, =Operand2B
				mov r3, #2
				strb r3, [r2]
				B SUB5_Continue4
	
@Stores the length of Operand2 as 3 figures
		SUB5F:	ldr r2, =Operand2B
				mov r3, #3
				strb r3, [r2]
				B SUB5_Continue4
		
		END_SUB5A:	mov r0,#0 @Clears the registers for use later
					mov r1,#0
					mov r2,#0
					mov r3,#0
					mov r0,#6			
		END_SUB5: 	BX LR
@____________________________________________________________________________________________________________________________________________________	
@		Subroutine 6-Loads each operand and the operator into memory.
@____________________________________________________________________________________________________________________________________________________
SUB6:	
@Loads in the first section of the string to be scanned. This also loads in the information about the negative and how many figures there are.		
		mov r0, #0 @ensures r0 is clear
		ldr r2,=Operand1B @Loads in how many figures operand 1 has.
		ldrb r3,[r2]
		sub r3,r3,#1 @decreases the length to meet the conditions of the loop so it can loop the correct amount of times
		ldr r4, =Input
		ldr r5,=Operand1C @loads in the data of the first operand being negative or not
		ldrb r12, [r5]
		mov r7, #1
		cmp r12,r7
		BEQ NegativeOP1_SUB6 @If the operand is a negative, then it will branch to add to the address. If not then it will continue.
@Scans in the number from the string in ascii and loops depending on how many figures there are.

C1A:	ldr r5,[r4]
		mov r7,#0xFF @selects the first byte
SUB6_Continue1:		
		add r9,r9,#1
		and r8,r7,r5 @finds the first byte

		mov r1,#2
		cmp r9,r1
		BEQ Logic_Shift_SUB6
C1B:	mov r1,#3
		cmp r9,r1
		BEQ Logic_Shift1_SUB6
C1C:	EOR	r6,r6,r8 @combines the first byte with the results from the previous loop
		lsr r5,#8 @takes the number and prepares it for the next loop
		cmp r3,r9 
		BGE SUB6_Continue1
		mov r4,#0
		mov r5,#0
		ldr r4,=Operand1_A @stores the first operand in memory.
		str r6,[r4]
		
	@Clears the Registers
	mov r4, #0
	mov r5, #0
	mov r6, #0
	mov r7, #0
	mov r8, #0
	mov r9, #0
	mov r10, #0
	mov r11, #0
		
@Loads in the first section of the string to be scanned. This also loads in the information about the negative and how many figures there are.		
		ldr r2,=Operand2B @Loads in how many figures operand 1 has.
		ldrb r3,[r2]
		sub r3,r3,#1
		
		ldr r4,=Space2 @loads the address of Space2
		ldr r8,[r4] @Loads the address of the second space in the Input
		add r8,r8,#1 @Goes to the address after the second space in Input
		mov r4,r8 @moves the address to register 4
		mov r0, #0 @ensures r0 is clear
		ldr r2,=Operand2B @Loads in the number of figures operand 2 has
		ldrb r3,[r2]
		sub r3,r3,#1
		ldr r5,=Operand2C @Loads in the information that tells if operand 2 is negative or not.
		ldrb r12, [r5]
		mov r7, #1
		cmp r12,r7
		BEQ NegativeOP2_SUB6 @If the operand is a negative, then it will branch to add to the address. If not then it will continue.
@Scans in the number from the string in ascii and loops depending on how many figures there are.



C2A:	ldr r5,[r4]
		mov r7,#0xFF @selects the first two bits
		
SUB6_Continue2:		
		add r9,r9,#1
		and r8,r7,r5 @finds the first byte

		mov r1,#2
		cmp r9,r1
		BEQ Logic_Shift2_SUB6
C2B:	mov r1,#3
		cmp r9,r1
		BEQ Logic_Shift3_SUB6
C2C:	EOR	r6,r6,r8 @combines the first byte with the results from the previous loop
		lsr r5,#8 @takes the number and prepares it for the next loop
		cmp r3,r9 
		BGE SUB6_Continue2
		mov r4,#0
		mov r5,#0
		ldr r4,=Operand2_A @stores the first operand in memory.
		str r6,[r4]
		
	@Clears the Registers
	mov r4, #0
	mov r5, #0
	mov r6, #0
	mov r7, #0
	mov r8, #0
	mov r9, #0
	mov r10, #0
	mov r11, #0
		
@Scans in the operator and stores it in the memory.
		mov r7,#0xFF @selects the first two bits
		ldr r4,=Space1 @loads the address of Space1
		ldr r8,[r4] @Loads the address of the first space in the Input
		add r8,r8,#1 @Goes to the address after the first space in Input
		ldr r4, [r8] @ loads in the operator
		and r8,r7,r4@finds the first byte
		ldr r10,=Operator @stores the first operand in memory.
		strb r8,[r10] @stores the operator into memory
		B END_SUB6

@Advances the address if the operand is negative		
		NegativeOP1_SUB6: 
					add r4,r4,#1
					B C1A
		NegativeOP2_SUB6:
					add r4,r4,#1
					B C2A

		Logic_Shift_SUB6:
					lsl r8,#8
					B C1B
		Logic_Shift1_SUB6:
					lsl r8,#16
					B C1C
		Logic_Shift2_SUB6:
					lsl r8,#8
					B C2B
		Logic_Shift3_SUB6:
					lsl r8,#16
					B C2C
END_SUB6: BX LR
@__________________________________________________________________________________________________________________________________________________________________________________	
@		Subroutine 7-Checks the value of the Operands, if the value isn't equal to 0,1,2,3,4,5,6,7,8, or 9 in ascii then 1 will be returned. Otherwise 0 will be returned.
@__________________________________________________________________________________________________________________________________________________________________________________	
SUB7:

	@Resets registers
	mov r0,#0
	mov r4, #0xff @gets the registers ready for the first byte to be selected
	and r5,r4,r6 @Selects the first byte and stores it in register 5
	
@Checks if the value is larger than 47 or is equal to 48, if not then it will move to the Other branch.
	CMP r5, #48
	BCS STWO @Goes to STWO if the value is larger than 47 (hex:0x2f)
	B Error14_SUB7 @Branches to prepare an error code

@Checks if the value is larger than 57 or is equal to 58, if not then it will move to the Small branch.
STWO:	CMP r5, #58
	BCS Error14_SUB7 @Branches to prepare an error code
	B ExitA_SUB7

@Returns 1 to prepare an error code to be displayed. This code will tell the user to use 0-9 when inputing in the input. The code is dependent in when this macro is used because it will tell the user which operand is having this trouble.
Error14_SUB7: mov r0,#1
			B Exit_SUB7
ExitA_SUB7:mov r0,#0
Exit_SUB7: BX LR
@__________________________________________________________________________________________________________________________________________________________________________________	
@		Subroutine 8-Checks the value of the Operator, if the value isn't equal to +, -, *, or / in ascii then 1 will be returned. Otherwise 0 will be returned.
@__________________________________________________________________________________________________________________________________________________________________________________	
SUB8:
	@Resets registers
	mov r0,#0
	mov r4, #0xff @gets the registers ready for the first byte to be selected
	and r5,r4,r6 @Selects the first byte and stores it in register 5
	cmp r5,#44
	BEQ Error14_SUB8
	cmp r5,#46
	BEQ Error14_SUB8
	
@Checks if the value is larger than 41 or is equal to 42, if not then it will move to the Other branch.
	CMP r5, #42
	BCS STWO2 @Goes to STWO if the value is larger than 47 (hex:0x2f)
	B Error14_SUB8 @Branches to prepare an error code

@Checks if the value is larger than 47 or is equal to 48, if not then it will move to the Small branch.
STWO2:	CMP r5, #48
	BCS Error14_SUB8 @Branches to prepare an error code
	B ExitA_SUB8

@Returns 1 to prepare an error code to be displayed. This code will tell the user to use 0-9 when inputing in the input. The code is dependent in when this macro is used because it will tell the user which operand is having this trouble.
Error14_SUB8: mov r0,#1
			B Exit_SUB8
ExitA_SUB8:mov r0,#0
Exit_SUB8: BX LR

@__________________________________________________________________________________________________________________________________________________________________________________	
@		Subroutine 9-Converts the ascii number to a hexadecimal number
@__________________________________________________________________________________________________________________________________________________________________________________	
SUB9:
		@Resets Registers r0-r3
		mov r0, #0
		mov r1, #0
		mov r2, #0
		mov r3, #0
@Loads in the information about Operand1
		ldr r12,=Operand1_A @ Loads the ascii value of the operand
		ldr r11,[r12]
		ldr r10,=Operand1B @Loads the length of the operand
		ldrb r9,[r10]
		mov r10,r9
		ldr r9, =Operand1C @Loads information about the operand being negative or not.
		ldrb r8,[r9]
		mov r9,r8
		ldr r8, =Operand1_H @Loads the address for the loaction where the hexadecimal value will be stored later.
		SUB r10,r10,#1
		mov r5,#0xFF @Sets up the first bytes to be selected
		
		
SUB9C0:	and r6,r11,r5 @Selects the first two bytes
		mov r7, #2 @used in the upcoming branch 
		
		cmp r7, r10
		BEQ Operand_Third_Value @Checks 
		
SUB9C1:	mov r7,#1
		cmp r7, r10
		BEQ Operand_Second_Value
SUB9C2:	mov r7,#0
		cmp r7, r10
		BEQ Operand_First_Value
SUB9C3:	add r1,r0,r1
		
		lsr r11,#8
		SUB r10,r10,#1
		mov r4,#0
		cmp r10,r4
		BGE SUB9C0
		mov r6,#1
		cmp r9,r6
		BEQ SUB9_Hexdecimalcheckneg @if the number is negaive then it will branch to see if the number is out of it's negative range or not (0 to -128)
		B SUB9_Hexdecimalcheck @Here, since it is established that the number is not a negative number, it will branch to check if the number is in range or not. (0 to 127)
SUB9C4:	strb r1,[r8]

		mov r0, #0
		mov r1, #0
		mov r2, #0
		mov r3, #0
@Loads in the information about Operand2
		ldr r12,=Operand2_A @ Loads the ascii value of the operand
		ldr r11,[r12]
		ldr r10,=Operand2B @Loads the length of the operand
		ldrb r9,[r10]
		mov r10,r9
		ldr r9, =Operand2C @Loads information about the operand being negative or not.
		ldrb r8,[r9]
		mov r9,r8
		ldr r8, =Operand2_H @Loads the address for the loaction where the hexadecimal value will be stored later.
		SUB r10,r10,#1
		mov r5,#0xFF @Sets up the first bytes to be selected
		
SUB9C5:	and r6,r11,r5 @Selects the first two bytes
		mov r7, #2 @used in the upcoming branch 
		
		cmp r7, r10
		BEQ Operand_Third_ValueA @Checks 
		
SUB9C6:	mov r7,#1
		cmp r7, r10
		BEQ Operand_Second_ValueA
SUB9C7:	mov r7,#0
		cmp r7, r10
		BEQ Operand_First_ValueA
SUB9C8:	add r1,r0,r1
		
		lsr r11,#8
		SUB r10,r10,#1
		mov r4,#0
		cmp r10,r4
		BGE SUB9C5
		mov r6,#1
		cmp r9,r6
		BEQ SUB9_HexdecimalchecknegA @if the number is negaive then it will branch to see if the number is out of it's negative range or not (0 to -128)
		B SUB9_HexdecimalcheckA @Here, since it is established that the number is not a negative number, it will branch to check if the number is in range or not. (0 to 127)
SUB9C9:	strb r1,[r8]		
	
		B Exit_SUB9

Operand_Third_Value:
			SUB r6,r6,#0x30
			mov r7,#100
			MUL r0,r6,r7
			mov r6,r0
			B SUB9C1
			
Operand_Third_ValueA:
			SUB r6,r6,#0x30
			mov r7,#100
			MUL r0,r6,r7
			mov r6,r0
			B SUB9C6			
			
Operand_Second_Value:
			SUB r6,r6,#0x30
			mov r7,#10
			MUL r0,r6,r7
			mov r6,r0
			B SUB9C2

Operand_Second_ValueA:
			SUB r6,r6,#0x30
			mov r7,#10
			MUL r0,r6,r7
			mov r6,r0
			B SUB9C7
						
Operand_First_Value:
			SUB r6,r6,#0x30
			mov r0,r6
			B SUB9C3

Operand_First_ValueA:
			SUB r6,r6,#0x30
			mov r0,r6
			B SUB9C8

SUB9_Hexdecimalcheck:	
			mov r4, #128
			cmp r1,r4
			BGE Error_OP1_SUB9
			B SUB9C4

SUB9_HexdecimalcheckA:	
			mov r4, #128
			cmp r1,r4
			BGE Error_OP2_SUB9
			B SUB9C9
			
SUB9_Hexdecimalcheckneg:
			mov r4, #129
			cmp r1,r4
			BGE Error_OP1_SUB9
			B SUB9C4
			
SUB9_HexdecimalchecknegA:
			mov r4, #129
			cmp r1,r4
			BGE Error_OP2_SUB9
			B SUB9C9			

Error_OP1_SUB9:
			mov r0,#18
			B	Exit_SUB9A

Error_OP2_SUB9:
			mov r0,#19
			B 	Exit_SUB9A
		
	Exit_SUB9: mov r0,#17
	
	Exit_SUB9A:	BX LR		

@__________________________________________________________________________________________________________________________________________________________________________________	
@		Subroutine 10-Returns a code corresponding to the type of operation
@__________________________________________________________________________________________________________________________________________________________________________________	
SUB10:
		mov r0, #0
		mov r1, #0
		mov r2, #0
		mov r3, #0

		ldr r4, =Operator
		ldrb r5,[r4]
		ldr r12,=Operand1C @loads address to tell if operand 1 is negative or not
		ldrb r11,[r12] @loads in the value
		mov r12,r11 @moves the value to save space
		ldr r11,=Operand2C @loads address to tell if operand 2 is negative or not
		ldrb r10,[r11] @loads in the value
		mov r11,r10 @moves the value to save space
		ldr r10,=Operand1_H
		ldrb r9,[r10]
		ldr r8,=Operand2_H 
		ldrb r7,[r8]
		ldr r3,=Result_H
		
		mov r6,#1
		cmp r6,r12
		BEQ NegOp1_SUB10
S10C1:		
		mov r6,#1
		cmp r6,r11
		BEQ NegOp2_SUB10
S10C2:	mov r6,#42
		cmp r6,r5
		BEQ Multiplication
		mov r6,#43
		cmp r6,r5
		BEQ Addition
		mov r6,#45
		cmp r6,r5
		BEQ Subtraction
		mov r6,#47
		cmp r6,r5
		B Division		
NegOp1_SUB10:
				mov r6, #-1
				muls r1,r9,r6
				mov r9,r1
				mov r1,#0
				B S10C1
NegOp2_SUB10:
				mov r6, #-1
				muls r1,r7,r6
				mov r7,r1
				mov r1,#0
				B S10C2					
Multiplication:
				muls r2,r9,r7
				B	END_SUB10
Division:	
		mov r1,r9
		mov r2,r7
		cmp r2,#0
		BEQ Error20_SUB10
		
		sdiv r3,r1,r2
		mov r2,r3
		ldr r3,=Result_H
		B END_SUB10
		
		Error20_SUB10:
        mov r0,#20
        B Exit_SUB10A
		
Addition:		
		adds r2,r9,r7
		B	END_SUB10
Subtraction:
		subs r2,r9,r7
		B	END_SUB10
		
Error19_SUB10: 	mov r0,#20
				B Exit_SUB10A
			
END_SUB10: 		mov r0,#21


@check for negative and convert




				str r2,[r3]@store result
Exit_SUB10A:	BX LR		

@__________________________________________________________________________________________________________________________________________________________________________________	
@		Subroutine 11-Turns hex to ascii
@__________________________________________________________________________________________________________________________________________________________________________________
hex_to_ascii:
        push    {r1, r2, r3, r5, r6, r7, r8, r9, lr}
	ldr	r0, =Result_H	@ the first parameter is the address of a hex value variable
	ldr	r1, =Result_A	@ the second parameter is the address of a ASCII value variable that is going store the results after conversion	
	ldr	r8, [r0]
	ldr r10, =0xf0000000
	and r11,r10,r8
	cmp r11, #0xF0000000
	BEQ Neg_SUB11
SUB11C:	mov	r9,r1
        @ Initialization for hex to ascii
        mov     r1, r8  @ dividend
        mov     r2, #10 @ divisor
        mov     r5, #0  @ counter
        @ Start conversion with dividing by 10
next_digit:
		udiv	r3, r1, r2
		mul		r7, r3, r2
		sub		r1, r1, r7

        add     r1, r1, #0x30   @ increment by 0x30 to get the ascii value
        push    {r1}            @ push the converted value into the stack
        add     r5, r5, #1      @ increment the counter
        mov     r1, r3          @ update the dividend
        cmp     r3, #0          @ check whether the conversion is finished
        bne     next_digit 
@ Store the converted value into memory
        ldr	r6, =Result_A	
store_asci:
        pop     {r1}            @ pop each digit from the stack
        strb    r1, [r6]        @ store the digit into memory
        add     r6, r6, #1      @ increment the address
        sub     r5, r5, #1      @ decrement the counter
        cmp     r5, #0
        bne     store_asci
        pop     {r1, r2, r3, r5, r6, r7, r8, r9, lr}
        B SkipSUB11
        Neg_SUB11:
		mvn r8,r8
		add r8,r8,#1
		ldr r12,=Result_N
		mov r11,#1
		strb r11,[r12]
		mov r12,#0
		B SUB11C
        
 SkipSUB11:       bx      lr											
@///////////////////////////////////////////////////MAIN/////////////////////////////////////////////////////////////////////////////////////////////
main:

@____________________________________________________________________________________________________________________________________________________
@		Beggining Prompt- Sets up information for the user to follow to use the calculator.
@____________________________________________________________________________________________________________________________________________________
@ Prints String
	mov r7,#4
	mov r0,#1
	mov r2,#46
	ldr r1,=PROMPT0
	swi 0 @prints:Hello and welcome to the Calculator Program
	mov r0,#1
	mov r2,#1 
	ldr r1,=PROMPT33
	swi 0 @prints new tab
	mov r0,#1
	mov r2,#8
	ldr r1,=PROMPT5
	swi 0 @prints:Manuel: 
	mov r0,#1
	mov r2,#41
	ldr r1,=PROMPT6
	swi 0 @prints:Input Format: Operand1 Operator Operand2
	mov r0,#1
	mov r2,#19
	ldr r1,=PROMPT4
	swi 0 @prints:Operators: + - * / % \n
	mov r0,#1
	mov r2,#84
	ldr r1,=PROMPT16
	swi 0 @prints:Only numbers between -128 to 127 are supported and can be entered to both operators.
	mov r0,#1
	mov r2,#34
	ldr r1,=PROMPT1
	swi 0 @prints: Imput Input Line Here:
@ Reading String Input
	mov r7,#3
	mov r0,#0
	mov r2,#20
	ldr r1,=Input
	SWI 0
		
@-	Error Checker- Checks the spacing, length, and value of each item inserted into the string. It will also collect data from the string. (Week 1 Deliverable)

@- Checks for Spaces and Newlines. It also checks to see if the string is too long.	This also saves the location of each space and newline.	
	BL SUB2 @Clears General Registers
	BL SUB1 @Checks Spaces and newlines
	BL SUB2 @Clears General Registers
	BL SUB3 @Prints off Codes	
@- Checks for Negative in the first postion of Operand1 and Operand2. Then it stores the results to be used for later.
	BL SUB2 @Makes sure the General Registers are clear
	BL SUB4 @Checks for Negatives	
@- Checks for figures of each operand and the operator. If the one of the operands is longer than 3 figures, then an error code will come back. If the operator is longer than one figure than an error code will come back. If neither occur, then a code will come back claming the check has been successful.
	BL SUB2 @Clears General Registers
	BL SUB5 @Checks how long each Operand and how long the operator is
	BL SUB2 @Clears General Registers
	mov r9,#0 @Clears r9
	BL SUB3 @Prints off Codes
@Loads the value of each operand and the operator into different memory spaces
	BL SUB2 @Clears General Registers
	BL SUB6 @Loads each number and operator into seperate memory spaces
	BL SUB2 @Clears General Registers
@Checks the values of each operator and the operand

@----Operand1 Value Check	
	ldr r11,=Operand1B @Loads in how many figures operand 1 has.
	ldrb r12,[r11]
	sub r12,r12,#1 @decreases the length to meet the conditions of the loop so it can loop the correct amount of times
	ldr r7,=Operand1_A
	ldr r6,[r7]
	mov r8,#0
Value_loop1:
	BL SUB7 @Branches to find the value of the current figure. If 1 is returned in r0, then an error code will be given out.
	mov r10,#1
	cmp r0,r10
	BEQ Operand1_Error @Branches to send error code. If 0 is in r0, then it will continue.
	lsr r6,#8
	add r8,r8,#1
	cmp r12,r8
	BGE Value_loop1
	B Skip_Value_loop1		
Operand1_Error:
	mov r0,#14
	BL SUB3 @Prints off Codes
Skip_Value_loop1:
	BL SUB2 @Clears General Registers
@----Operand2 Value Check	
	ldr r11,=Operand2B @Loads in how many figures operand 1 has.
	ldrb r12,[r11]
	sub r12,r12,#1 @decreases the length to meet the conditions of the loop so it can loop the correct amount of times
	ldr r7,=Operand2_A
	ldr r6,[r7]
	mov r8,#0
Value_loop2:
	BL SUB7 @Branches to find the value of the current figure. If 1 is returned in r0, then an error code will be given out.
	mov r10,#1
	cmp r0,r10
	BEQ Operand2_Error @Branches to send error code. If 0 is in r0, then it will continue.
	lsr r6,#8
	add r8,r8,#1
	cmp r12,r8
	BGE Value_loop2
	B Skip_Value_loop2		
Operand2_Error:
	mov r0,#15
	BL SUB3 @Prints off Codes
Skip_Value_loop2:
@-----Operator Check
	BL SUB2 @Clears General Registers
	ldr r7,=Operator
	ldrb r6,[r7]
	mov r8,#0
	BL SUB8
	mov r10,#1
	cmp r0,r10
	BEQ Operator_Error @Branches to send error code. If 0 is in r0, then it will continue.
	B Skip_Value
@Prints off the error code for the operator
Operator_Error:
	mov r0,#16
	BL SUB3 @Prints off Codes
Skip_Value:
	mov r0,#17
	BL SUB3 @Prints off Codes

@Note: The error checker to see if 	the numbers inputed in both operands are between -128 to 127. This is resolved later in Week 2's Deliverable when we translate the ascii code to hex. This is done to make things easier when finding the error. Later an error will also occur then operand1 is being divided by 0 in operand2.
	
@-		Ascii converter- This converts the ascii numbers to hexadecimal numbers depending on it's size and if it is negative or not. (Week 2 Deliverable)

	BL SUB2
	BL SUB9
	BL SUB2	
	BL SUB3 @Prints off Codes
	
@-		Arithmic Operations- This does the operations based off the operator

	BL SUB2
	BL SUB10 @checks the type of operation and does the operation based off the code found inside the subroutine. After that is done then the result is stored in result.
	cmp r0,#20
    BEQ Division_Error
	
	BL SUB2
	
@-		Hex Converter

	bl hex_to_ascii
	
	@ Prints String
	mov r7,#4
@prints: \n
	mov r0,#1
	mov r2,#1
	ldr r1,=PROMPT33
	swi 0 
@prints: Operand:
	mov r0,#1
	mov r2,#10
	ldr r1,=PROMPT31
	swi 0 
	ldr r8,=Operand1C
	ldrb r9,[r8]
	cmp r9,#1
	BEQ NegOp1_Main	
C1M:	
@prints: operand1
	ldr r11,=Operand1B
	ldrb r2,[r11]
	mov r0,#1
	ldr r1,=Operand1_A
	swi 0 	
@prints: \n
	mov r0,#1
	mov r2,#1
	ldr r1,=PROMPT33
	swi 0 
@prints: Operand:
	mov r0,#1
	mov r2,#10
	ldr r1,=PROMPT32
	swi 0 
	ldr r8,=Operand2C
	ldrb r9,[r8]
	cmp r9,#1
	BEQ NegOp2_Main	
C2M:	
@prints: operand 2
	ldr r11,=Operand2B
	ldrb r2,[r11]
	mov r0,#1
	ldr r1,=Operand2_A
	swi 0 	
@prints: \n
	mov r0,#1
	mov r2,#1
	ldr r1,=PROMPT33
	swi 0 
	
@prints: operator:
	mov r0,#1
	mov r2,#9
	ldr r1,=PROMPT34
	swi 0 	
@prints: operand 2
	mov r2,#1
	mov r0,#1
	ldr r1,=Operator
	swi 0 	
@prints: \n
	mov r0,#1
	mov r2,#1
	ldr r1,=PROMPT33
	swi 0 	
@prints: Result:
	mov r0,#1
	mov r2,#7
	ldr r1,=PROMPT35
	swi 0
@prints off - if needed
ldr r10,=Result_N
ldrb r11,[r10]
cmp r11,#1
BEQ NegOp3_Main	
C3M:
@prints: the result	
	mov r0,#1
	mov r2,#8
	ldr r1,=Result_A
	swi 0 
@prints: \n
	mov r0,#1
	mov r2,#1
	ldr r1,=PROMPT33
	swi 0 	
B END_MAIN
NegOp1_Main:
@prints: -
	mov r0,#1
	mov r2,#1
	ldr r1,=PROMPT36
	swi 0 	
B C1M
NegOp2_Main:
@prints: -
	mov r0,#1
	mov r2,#1
	ldr r1,=PROMPT36
	swi 0 	
B C2M
NegOp3_Main:
@prints: -
	mov r0,#1
	mov r2,#1
	ldr r1,=PROMPT36
	swi 0 	
B C3M
B END_MAIN
	
Division_Error:
	BL SUB3
	
END_MAIN:
    @ exit syscall
    mov r7, #1
    swi 0
