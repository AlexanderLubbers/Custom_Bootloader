[bits 16]
to32bit:
    cli ; disable interputs. If the CPU is interupted while switching modes then bad things could happen
    lgdt [gdt_descriptor] ; load the GDT descriptor. the lgdt command loads the gdt
    ; enable protected mode
    mov eax, cr0 ; copy the contents of cr0 into eax
    or eax, 0x1 ; set the loest bit of eax to 1 which enables protected mode
    mov cr0, eax ; write the updated value back to cr0 to enable protected mode
    jmp CODE_SEG:init_32bit ;perform a far jump to this section in the 32bit code section CODE_SEG refers to the code segment selector in th e GDT which tells the CPU where to find 32bit protected code

[bits 32]
init_32bit:
    ; update the segment registers
    mov ax, DATA_SEG ; lets the CPU know where th read/write data and how to access the stack. DATA_SEG refers to the data segment in the GDT
    mov ds, ax
    mov ss, ax
    mov es, ax
    mov fs, ax
    mov gs, ax

    ; setup the stack
    mov ebp, 0x90000 ; this is the location where the stack wil start
    mov esp, ebp

    call BEGIN_32BIT ; start executing the kernal and other 32bit code