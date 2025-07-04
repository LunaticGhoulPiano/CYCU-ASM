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

.text
    .global id1
    .global id2
    .global id3
    .global sum
    .global command
    .global id

    id:
    stmfd sp!, {lr} @ 1

    @ print start_msg
    ldr r0, =start_msg @ 2
    bl printf @ 3

    @ to fit the requirement
    mov r4, lr @ backup lr to r4 @ 4
    mov r0, #0 @ 5
    adds lr, pc, r0 @ required instruction @ 6
    mov lr, r4 @ restore lr

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

    @ reset
    ldmfd sp!, {lr}
    mov r0, #0
    mov pc, lr
    swi 0
