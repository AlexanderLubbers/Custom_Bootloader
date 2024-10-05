[bits 16]
; org is short for origin and is an assembly directive
; this tells the program that the code starts at the memory address 0x7c00
; this location is where BIOS loads the boot sector into memory
[org 0x7c00]
; defines a constant called KERNAL_OFFSET with a certain value
; this is where the kernel will be loaded into memory
KERNAL_OFFSET equ 0x1000
; save the boot drive number to the dl register
mov [BOOT_DRIVE], dl;
; set up the stack
; the base pointer is used to keep track of the base of the stack
mov bp, 0x9000 ; the address where the stack wil start
; sp provides the offset value within the program
; sp is related to ss and ss refers to the current posiiton of data inthe program stack
; the stack pointer register wll always point to the top of the stack
mov sp, bp ; initialize the stack. any push or pop operatings will be in this memory region

call load_kernel ; this function will load the kernel from disk into memory at the address defined by KERNAL_OFFSET
; 16 bit real mode is used in bootloading and BIOS routines. The main goal of this mode is to get the system up and running and then switching to a more advanced mode
; 32 bit protected mode and 64 bit protected mode are used to start loading the operating system and applications. It is a more advanced version of 16 bit real mode.
call to_32bit ; switch the CPU from 16 bit real mode to 32 bit protected mode

; jump to the current address and give execution control to in. $ refers to current instruction
; this leads to the same instruction being executed over and over again
; this is a strategy used to pause the CPU
; This can be used to wait for the kernal to take over, show that the system has entered an invalid state, or simply stop the execution
; in this case, this is put here to make the system wait until the kernel takes control
jmp $

%include "disk.asm"
%include "gdt.asm"
%include "switch-to-32bit.asm"

[bits 16]
load_kernel:
    mov bx, KERNEL_OFFSET ; moves the address: 0x1000 into bx. This is where the kernel will be loaded
    mov dh, 2             ; dh -> num sectors
    mov dl, [BOOT_DRIVE]  ; dl -> boot drive number
    call disk_load
    ret ; return control back to the call program or function. This is used to end a function

[bits 32]
BEGIN_32BIT:
    call KERNEL_OFFSET ; give control to the kernel
    jmp $ ; loop in case kernel returns

; boot drive variable
BOOT_DRIVE db 0

; padding
; this part is saying that the remaining space should be filled with zeros
; $$ means starting position
times 510 - ($-$$) db 0 ;ensure that the boot sector is exactly 512 bytes long

; boot signature
dw 0xaa55