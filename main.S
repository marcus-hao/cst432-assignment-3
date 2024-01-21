.equ LED, 16	// LED on GPIO 16
.equ BUZZER, 5	// BUZZER on GPIO 5
.equ BUTTON, 26	// BUTTON on GPIO 26
.equ PIR, 6		// PIR Sensor on GPIO 6

.text
.global main

main:
	mov x0, #0
	bl lgGpiochipOpen
	cbnz x0, done

	// setup
	mov x0, #0
	mov x1, #0
	mov x2, #LED
	mov x3, #0
	bl lgGpioClaimOutput
	cbnz x0, done

	mov x0, #0
	mov x1, #0
	mov x2, #BUZZER
	mov x3, #0
	bl lgGpioClaimOutput
	cbnz x0, done

	mov x0, #0
	mov x1, #0
	mov x2, #BUTTON
	bl lgGpioClaimInput
	cbnz x0, done

	mov x0, #0
	mov x1, #0
	mov x2, #PIR
	bl lgGpioClaimInput
	cbnz x0, done

	// run
	bl loop			// Keep reading sensors

	mov x0, #0
	bl lgGpiochipClose

	b done

loop:
	mov x0, #0
	mov x1, #BUTTON
	bl lgGpioRead	// Read button press
	cmp x0, #0
	bne blink		// If active, then blink
	mov x0, #0
	mov x1, #PIR
	bl lgGpioRead	// Read PIR motion
	cmp x0, #0
	bne blink		// If motion detected, then blink

	b loop

blink:
	mov x19, #0			// Initialize counter

loop_blink:
	cmp x19, #5			// Loop 5 times
	beq end_loop

	mov x0, #0
	mov x1, #LED
	mov x2, #1
	bl lgGpioWrite		// LED HIGH

	mov x0, #0
	mov x1, #BUZZER	
	mov x2, #1
	bl lgGpioWrite		// Buzzer HIGH

	bl delay			// Delay 0.5s

	mov x0, #0
	mov x1, #LED
	mov x2, #0
	bl lgGpioWrite		// LED LOW

	mov x0, #0
	mov x1, #BUZZER
	mov x2, #0
	bl lgGpioWrite		// Buzzer LOW

	bl delay			// Delay 0.5s

	add x19, x19, #1	// Increment counter
	b loop_blink		// Keep looping

delay:
	// NOP takes 2 cycles
	// 0.5 / (1/1.5GHz * 2)
	ldr x20, =375000000

loop_delay:
	NOP
	sub x20, x20, #1	// Decrement counter
	cmp x20, #0			// i > 0?
	bne loop_delay		// Keep looping
	ret

end_loop:
	b loop 	// go back to read input

done:
	mov x0, #0
	mov x8, #93
	svc 0
	.end