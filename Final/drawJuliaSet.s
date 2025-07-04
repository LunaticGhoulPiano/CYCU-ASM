.data
cX: 	.word 0 @ cX's addr
width: 	.word 0 @ width's addr
height: .word 0 @ height's addr

.text
.global drawJuliaSet

drawJuliaSet:
	stmfd sp!, {r4-r11, lr}

	ldr r4, =cX
	str r0, [r4] 	@ cX: r0 -> [cX's addr]
	mov r11, r1	 	@ cY: r1 -> r11
	ldr r4, =width
	str r2, [r4] 	@ width: r0 -> [width's addr]
	ldr r4, =height
	str r3, [r4] 	@ height: r3 -> [height's addr]
					@ now r0, r1, r2, r3 could be used as temp

@----------------------------------------basic requirements 3 (orr)
	mov r0, sp 		@ backup
	orr sp, lr, r1 	@ The requirement 3
	mov sp, r0 		@ recall
@------------------------------------------------------------------

	ldr r4, [sp, #36] @ r4 = frame @ 36 = 4(byte) * 9(r4~r11 + lr)

	@ for Xloop init
	mov r5, #0 @ x = 0
	Xloop:
		@ Xloop condi. init (x < width;)
		ldr r0, =width 	@ get width
		ldr r0, [r0]
		cmp r5, r0		@ if (x < width)
		bge XDone

		@ for Yloop init
		mov r6, #0 @ y = 0
	Yloop:
		@ Yloop condi. (y < height;)
		ldr r0, =height @ get height
		ldr r0, [r0]
		cmp r6, r0 		@ if (y < height)
		bge YDone

		@ zx = 1500 * (x - (width>>1)) / (width>>1);
		ldr r2, .const 		@ r2 = 1500
		ldr r1, =width
		ldr r1, [r1] 		@ r1 = width
		mov r1, r1, asr #1 	@ r1 = width >> 1
		sub r0, r5, r1 		@ r0 = x - (r1 >> 1)
		mul r0, r0, r2 		@ r0 = r0 * 1500
		bl __aeabi_idiv 	@ r0 = r0 / r1
		mov r8, r0 			@ zx = r0

		@ zy = 1000 * (y - (height>>1)) / (height>>1);
		ldr r1, =height
		ldr r1, [r1] 		@ r1 = height
		ldr r2, .const+12	@ r2 = 1000
		mov r1, r1, asr #1 	@ r1 = height >> 1
		sub r0, r6, r1		@ r0 = y - (r1 >> 1)
		mul r0, r0, r2 		@ r0 = r0 * 1000
		bl __aeabi_idiv 	@ r0 = r0 / 1
		mov r9, r0 			@ zy = r0

		@ i = maxIter;
		mov r7, #255 	@ maxIter = 255

		@ while condi. init (zx * zx + zy * zy < 4000000 && i > 0)
		mul r0, r8, r8		@ r0 = zx * zx
		mul r1, r9, r9 		@ r1 = zy * zy
		add r0, r0, r1 		@ r0 = zx * zx + zy * zy
		ldr r3, .const+4 	@ r3 = 4000000
		cmp r0, r3
		bge WhileDone 		@ (zx * zx + zy * zy < 4000000)
		cmplt r7, #0		@ "lt" cuz "<"
		ble WhileDone 		@ (i > 0)

		While:
			@ int tmp = (zx * zx - zy * zy)/1000 + cX; // r10 = tmp
			mul r0, r8, r8		@ r0 = zx * zx
			mul r1, r9, r9 		@ r1 = zy * zy
			sub r0, r0, r1 		@ r0 = r0 - r1
			mov r1, #1000 		@ r1 = 1000 @ can't use ".const+12" here
			bl __aeabi_idiv 	@ r0 = r0 / r1
			ldr r2, =cX
			ldr r2, [r2]		@ r2 = cX
			add r10, r0, r2		@ r10 = r0 + cX

			@ zy = (2 * zx * zy)/1000 + cY; // r9 = zy
			mov r0, r8, lsl #1 	@ r0 = 2 * zx
			mul r0, r0, r9 		@ r0 = r0 * zy
			mov r1, #1000 		@ r1 = 1000 @ can't use ".const+12" here
			bl __aeabi_idiv 	@ r0 = r0 / r1 => r0 = r0 / 1000
			add r9, r0, r11 	@ r9 = r0 + cY

			@ zx = tmp;
			mov r8, r10

			@ i--;
			sub r7, r7, #1

			@ reset for the next stage's while condi. (zx * zx + zy * zy < 4000000 && i > 0)
			mul r0, r8, r8 		@ r0 = zx * zx
			mul r1, r9, r9 		@ r1 = zy * zy
			add r0, r0, r1 		@ r0 = zx * zx + zy * zy
			ldr r3, .const+4	@ r3 = 4000000
			cmp r0, r3
			bge WhileDone		@ (zx * zx + zy * zy < 4000000)
			cmplt r7, #0		@ "lt" cuz "<"
			ble WhileDone		@ (i > 0)
			b While

		WhileDone:
			@ color = ((i&0xff)<<8) | (i&0xff);
			and r7, r7, #0xff		@ i = i&0xff
			orr r7, r7, lsl #8		@ color = (i&0xff) | ((i&0xff) << 8)

			@ color = (~color)&0xffff;
			ldr r0, .const+8	@ r0 = 0xffff
			bic r7, r0, r7		@ color = 0xffff & ~(color)

			@ frame[y][x] = color;
			mov r0, r4 					@ r0 = frame
			ldr r2, =width
			ldr r2, [r2]				@ r2 = width
			mov r2, r2, lsl #1 			@ r2 = width * 2
			mov r1, r2 					@ r1 = width * 2
			mul r1, r1, r6 				@ r1 = width * 2 * y
			add r0, r0, r1 				@ r0 = frame + width * 2 * y
			add r3, r0, r5, lsl #1 		@ r3 = r0 + x * 2
			strh r7, [r3]

			add r6, #1 @ x++
			b Yloop

		YDone:
			add r5, #1 @ y++
			b Xloop

		XDone:
@----------------------------------------basic requirements 1 (op2)
			add r0, r1, #3 @ type1
			add r0, r1, r2 @ type2
			add r0, r1, r2, lsl #3 @ type3
@------------------------------------------------------------------
@----------------------------------------basic requirements 2 (conditional)
			cmp r0, r1
			addlt r2, r0, r1 @ condi.1
			cmp r0, r1
			addne r0, r1, r2 @ condi.2
			cmp r0, r1
			sbcgt r0, r1, r2 @ condi.3
@--------------------------------------------------------------------------

			@ reset
			ldmfd sp!, {r4-r11, lr}
			mov pc, lr

		.const:
			.word 1500 @ .const
			.word 4000000 @ .const+4
			.word 0xffff @ .const+8
			.word 1000 @ .const+12
