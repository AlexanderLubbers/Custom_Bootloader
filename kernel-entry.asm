[bits 32]
extern main ;indicates that main is not declared in this file
global _start
section .multiboot_header
align 4 ; align everything on the 4-byte boundary. multiboot compliant bootloaders expect the header to aligned to 4 bytes
; dd means define double word
dd 0x1BADB002 ; code for multiboot
dd 0x0 ;reserve 4 bytes and intialize them with 0 which means only the basic loading of kernel
dd -(0x1BADB002 + 0x0) ; checksum (sum of all fields should be zero)
section .text
_start:
    call main
hang:
    hlt
    jmp hang