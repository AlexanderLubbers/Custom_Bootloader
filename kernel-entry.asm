[bits 32]
extern main ;indicates that main is not declared in this file
global _start

section .text
_start:
    call main
hang:
    hlt
    jmp hang