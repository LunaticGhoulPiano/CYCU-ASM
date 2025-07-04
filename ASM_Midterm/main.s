.data
    SubFunc1: .asciz "Function1: Name\n"
    SubFunc2: .asciz "Function2: ID\n"
    MainFunc: .asciz "Main Function:\n"
    start_msg: .asciz "*****Print All*****\n"
    end_msg: .asciz "*****End Print*****\n"
    sum_msg: .asciz "ID Summation = %d\n"

    IDandNAME: .asciz "%d %s"
    OutputInt: .asciz "%d"
    OutputStr: .asciz "%s"

.text
    .global main

    main:
    stmfd sp!, {lr}

    @ call & print name.s, id.s
    ldr r0, =SubFunc1
    bl printf
    bl name
    ldr r0, =SubFunc2
    bl printf
    bl id

    @ print MainFunc
    ldr r0, =MainFunc
    bl printf

    @ print start_msg
    ldr r0, =start_msg
    bl printf

    @ print team
    ldr r0, =team
    bl printf

    @ print id1 ~ id3
    ldr r0, =IDandNAME
    ldr r1, =id1
    ldr r1, [r1]
    ldr r2, =member1
    bl printf
    ldr r0, =IDandNAME
    ldr r1, =id2
    ldr r1, [r1]
    ldr r2, =member2
    bl printf
    ldr r0, =IDandNAME
    ldr r1, =id3
    ldr r1, [r1]
    ldr r2, =member3
    bl printf

    @ print end_msg
    ldr r0, =end_msg
    bl printf

    @ reset
    ldmfd sp!, {lr}
    mov r0, #0
    mov pc, lr
    swi 0
