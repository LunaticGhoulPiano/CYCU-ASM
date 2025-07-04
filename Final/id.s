.data
    start_msg: .asciz "*****Input ID*****\n"
    enter_msg1: .asciz "**Please Enter Member1's ID :**\n"
    enter_msg2: .asciz "**Please Enter Member2's ID :**\n"
    enter_msg3: .asciz "**Please Enter Member3's ID :**\n"
    enter_msg_command: .asciz "** Please Enter Command :**\n"
    print_command: .asciz "**Print Team Member ID and ID Summation**\n"
    result_msg: .asciz "ID Summation = %d\n"
    end_msg: .asciz "*****End Print*****\n"

    newline: .asciz "\n"
    InputInt: .asciz "%d"
    InputStr: .asciz "%s"
    OutputInt: .asciz "%d\n"

    @ memory blocks
    id1: .word 0
    id2: .word 0
    id3: .word 0
    sum: .word 0
    command: .word 0
	id1_addr: .word 0
	id2_addr: .word 0
	id3_addr: .word 0
	sum_addr: .word 0

.text
    .global id1
    .global id2
    .global id3
    .global sum
    .global command
    .global id

    id:
    stmfd sp!, {r4-r11, lr} @ 1

    @ print start_msg
	@ id1 r0->r5
	@ id2 r1->r6
	@ id3 r2->r7
	@ sum r3->r8
	mov r5, r0 @ 2
	mov r6, r1 @ 3
	mov r7, r2 @ 4
    @ to fit the requirement
    mov r4, lr @ backup lr to r4  @5
    adds lr, pc, r0 @ required instruction @ 6
    mov lr, r4 @ restore lr
	mov r8, r3
    
    ldr r0, =start_msg
    bl printf

	ldr r4, =id1_addr
	str r5, [r4]
	ldr r4, =id2_addr
	str r6, [r4]
	ldr r4, =id3_addr
	str r7, [r4]
	ldr r4, =sum_addr
	str r8, [r4]

    @ get id1
    ldr r0, =enter_msg1
    bl printf
    ldr r0, =InputInt
    ldr r1, =id1
    bl scanf

    @ get id2
    ldr r0, =enter_msg2
    bl printf
    ldr r0, =InputInt
    ldr r1, =id2
    bl scanf

    @ get id3
    ldr r0, =enter_msg3
    bl printf
    ldr r0, =InputInt
    ldr r1, =id3
    bl scanf

	ldr r1, =id1_addr
	ldr r1, [r1]
	ldr r0, =id1
	ldr r0, [r0]
	str r0, [r1]

	ldr r1, =id2_addr
	ldr r1, [r1]
	ldr r0, =id2
	ldr r0, [r0]
	str r0, [r1]

	ldr r1, =id3_addr
	ldr r1, [r1]
	ldr r0, =id3
	ldr r0, [r0]
	str r0, [r1]


    @ get instruction 'p'
    ldr r0, =enter_msg_command
    bl printf
    loop:
        ldr r0, =InputStr
        ldr r1, =command
        bl scanf
        ldr r1, =command @ re-get r1's address
        ldrb r1, [r1] @ indirect to direct
        cmp r1, #'p'
        bne loop

    @ print print_command
    ldr r0, =print_command
    bl printf

    @ print id1 ~ id3
    ldr r0, =OutputInt
    ldr r1, =id1
    ldr r1, [r1]
    bl printf
    ldr r0, =OutputInt
    ldr r1, =id2
    ldr r1, [r1]
    bl printf
    ldr r0, =OutputInt
    ldr r1, =id3
    ldr r1, [r1]
    bl printf
    ldr r0, =newline
    bl printf

    @ calculate and print sum
    ldr r3, =id1
    ldr r3, [r3]
    ldr r4, =id2
    ldr r4, [r4]
    ldr r5, =id3
    ldr r5, [r5]
    adds r10, r3, r4
    adds r10, r10, r5
    ldr r11, =sum
    str r10, [r11]
    ldr r0, =result_msg
    ldr r1, =sum
    ldr r1, [r1]
    bl printf

    @ print end_msg
    ldr r0, =end_msg
    bl printf


	ldr r1, =sum_addr
	ldr r1, [r1]
	ldr r0, =sum
	ldr r0, [r0]
	str r0, [r1]

    @ reset
    ldmfd sp!, {r4-r11, lr}
    mov pc, lr
