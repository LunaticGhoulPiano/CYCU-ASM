.data
    start_msg: .asciz "** Print Name **\n"
    team: .asciz "Team 04\n" @ memory block 1
    member1: .asciz "SU, PO-HSUN\n" @ memory block 2
    member2: .asciz "YE, BO-YU\n" @ memory block 3
    member3: .asciz "LIN, PEI-WUN\n" @ memory block 4
    end_msg: .asciz "** End Print **\n"

.text
    .global name
    .global team
    .global member1
    .global member2
    .global member3

    name:
        stmfd sp!, {lr}

        @ print start_msg
        ldr r0, =start_msg
        bl printf

        @ print team, members
        ldr r0, =team
        bl printf
        ldr r0, =member1
        bl printf
        ldr r0, =member2
        bl printf
        ldr r0, =member3
        bl printf

        @ print end_msg
        ldr r0, =end_msg
        bl printf

        @ basic requirements 02
        ldr r3, [r2, #4]
        ldr r5, [r2, r4]

        @ basic requirements 03
        sub r0, r1, #3
        lsl r0, r1, #3

        @ basic requirements 04
        cmp r0, r1
        addgt r2, r0, r1
        cmp r0, r1
        addne r0, r1, r2
        cmp r0, r1
        sbcgt r0, r1, r2

        @ reset
        ldmfd sp!, {lr}
        mov r0, #0
        mov pc, lr
        swi 0
