		.ORIG x3000
START	LEA R0, A
		LDW R0, R0, #0
		ADD R0, R0, #1
		JSRR R0
DONE	TRAP x25

A		.FILL x2100
B		.FILL x4000
		.END