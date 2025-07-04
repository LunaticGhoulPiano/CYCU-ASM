.data
    start_msg: 	.asciz "** Print Name **\n"
    team: 		.asciz "Team 04\n"
    member1: 	.asciz "SU, PO-HSUN" 
    member2: 	.asciz "YEH, PO-YU" 
    member3: 	.asciz "LIN, PEI-WUN"
	output_format:	.asciz "%s\n"
    end_msg: 		.asciz "** End Print **\n"

	member1_addr: .word 0
	member2_addr: .word 0
	member3_addr: .word 0
.text
    .global name
    .global team
    .global member1
    .global member2
    .global member3

    name:
        stmfd sp!, {r4-r11, lr}

		ldr r4, =member1_addr
		str r0, [r4]
		ldr r4, =member2_addr
		str r1, [r4]
		ldr r4, =member3_addr
		str r2, [r4]

		ldr r1, =member1_addr
		ldr r1, [r1]
		ldr r0, =member1
		str r0, [r1]
		ldr r1, =member2_addr
		ldr r1, [r1]
		ldr r0, =member2
		str r0, [r1]
		ldr r1, =member3_addr
		ldr r1, [r1]
		ldr r0, =member3
		str r0, [r1]
		
@----------------------------------------printf
		ldr r0, =start_msg
		bl printf
		
		ldr r0, =team
		bl printf

		ldr r0, =output_format
		ldr r1, =member1
		bl printf

		ldr r0, =output_format
		ldr r1, =member2
		bl printf

		ldr r0, =output_format
		ldr r1, =member3
		bl printf

		ldr r0, =end_msg
		bl printf

@----------------------------------------reset
        ldmfd sp!, {r4-r11, lr}
        mov pc, lr
