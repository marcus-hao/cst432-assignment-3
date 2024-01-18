.text
.global main

main:
	mov x0, #0
	bl lgGpiochipOpen
	cbnz x0, done

	// setup
	mov x0, #0
	mov x1, #0
	mov x2, #17
	mov x3, #0
	bl lgGpioClaimOutput
	cbnz x0, done

	mov x0, #0
	mov x1, #0
	mov x2, #22
	mov x3, #0
	bl lgGpioClaimOutput
	cbnz x0, done

	mov x0, #0
	mov x1, #0
	mov x2, #23
	bl lgGpioClaimInput
	cbnz x0, done

	mov x0, #0
	mov x1, #0
	mov x2, #24
	bl lgGpioClaimInput
	cbnz x0, done

	// run
	bl loop

	mov x0, #0
	bl lgGpiochipClose

	b done

loop:
	mov x0, #0
	mov x1, #23
	bl lgGpioRead
	cmp x0, #0
	bne blink
	mov x0, #0
	mov x1, #24
	bl lgGpioRead
	cmp x0, #0
	bne blink

	b loop

blink:
	mov x19, #0

loop_blink:
	cmp x19, #5
	beq end_loop

	mov x0, #0
	mov x1, #17
	mov x2, #1
	bl lgGpioWrite

	mov x0, #0
	mov x1, #22
	mov x2, #1
	bl lgGpioWrite

	bl delay

	mov x0, #0
	mov x1, #17
	mov x2, #0
	bl lgGpioWrite

	mov x0, #0
	mov x1, #22
	mov x2, #0
	bl lgGpioWrite

	bl delay

	add x19, x19, #1
	b loop_blink

delay:
	ldr x20, =750000000

loop_delay:
	NOP
	sub x20, x20, #1
	cmp x20, #0
	bne loop_delay
	ret

end_loop:
	b loop // go back to read input

done:
	mov x0, #0
	mov x8, #93
	svc 0
	.end