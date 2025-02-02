		.ORIG   x3000
		AND R0, R0, #0                  ;x3000  CLEARS REGISTERS 0 THROUGH 7
		AND R1, R1, #0                  ;x3001
		AND R2, R2, #0                  ;x3002
		AND R3, R3, #0                  ;x3003
		AND R4, R4, #0                  ;x3004
		AND R5, R5, #0                  ;x3005
		AND R6, R6, #0                  ;x3006
		AND R7, R7, #0                  ;x3007
		
		;R3 HAS SOURCE ADDRESS, R5 HAS DEST ADDRESS, R6 HAS COUNT, R7 HAS MASK LOCATION, R1 HAS MASK, R0 HAS MEM[R3]
		LEA R3, SOURCE              ;ADDRESS TO WHERE DATA SHOULD BE PULLED, START WITH FIRST ADDRESS (x4000)
		LDB R3, R3, #0
		LEA R5, DEST				;ADDRESS TO WHERE THE NEW STORES SHOULD BE (x4005)
		LDB R5, R5, #0
		ADD R6, R6, #4              ;KEEPS COUNT OF NUMBER OF TIMES WE SHIFT
		LEA R7, MASK				;THIS MAKES R7 EQUAL TO THE MASK LOCATION (x4004)
		LDB R7, R7, #0
		LDB R1, R7, #0              ;LOADS THE SHIFTING INSTRUCTION INTO R1, R1 = MEM[R7] = MEM[x4004]
		BR FIRST					;SKIP THE INCREMENTS THE FIRST TIME

START	RSHFL R1, R1, #2;			;SHIFT THE MASK TWO BITS TO THE RIGHT WITHOUT PRESERVING BITS (PAD WITH 0)
		ADD R5, R5, #1;				;INCREMENT THE STORING ADDRESS
		ADD R6, R6, #-1             ;SUBTRACTS COUNT
		BRZ DONE                    ;IF WE HAVE DONE 4 OPERATIONS THEN GO TO DONE
FIRST	AND R4, R1, x0003			;MASKS THE RIGHTMOST TWO BITS
		BR OFFSET                   ;BRANCHES TO CALCULATE WHICH DATA LOCATION TO PULL

OFFSET	ADD R4, R4, #-1				;SUBTRACT 1 FROM THE MASK
		BRN ZERO					;MASK IS [00] IF R4-1<0
		BRZ ONE						;MASK IS [01] IF R4-1=0
		ADD R4, R4, #-1
		BRZ TWO						;MASK IS [10] IF R4-2=0
		BR THREE					;MASK IS [11]

ZERO	LDB	R0, R3, #0				;R0 = MEM[R3]
		STB R0, R5, #0              ;MEM[R5] = R0 = MEM[R3]
		BR START

ONE		LDB	R0, R3, #1				;R0 = MEM[R3+1]
		STB R0, R5, #0              ;MEM[R5] = R0 = MEM[R3+1]
		BR START

TWO		LDB	R0, R3, #2				;R0 = MEM[R3+2]
		STB R0, R5, #0              ;MEM[R5] = R0 = MEM[R3+2]
		BR START

THREE	LDB	R0, R3, #3				;R0 = MEM[R3+3]
		STB R0, R5, #0              ;MEM[R5] = R0 = MEM[R3+3]
		BR START

DONE	TRAP x25                   ;HALT THE MACHINE

SOURCE	.FILL x4000
MASK	.FILL x4004
DEST	.FILL x4005
		.END


