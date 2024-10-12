; Layout of a GDT Entry (64 bits)
; Bits	Field
; 0-15	Segment limit (0-15)
; 16-31	Base address (0-15)
; 32-39	Base address (16-23)
; 40-47	Access byte (flags)
; 48-51	Segment limit (16-19)
; 52-55	Flags
; 56-63	Base address (24-31)

; The GDT data structure defines different memory segments for the processor to access. 
; This lets the CPU know how to access different regions and sets up memory protection and privilege levels;
; without the GDT the system will remain in real mode. The GDT is needed for 32bit protected mode

; dq: defines an 8-byte value
; dw defines a two byte value
; db defines a one byte value
gdt_start:
    ; marks the first segment of the global descriptor table
    ; the first entry in the GDT must be a null descriptor which is required by the CPU
    dq 0x0 ;null segment descriptor

;code segment descriptor
gdt_code:
    ; set of 0xffff to make the segment 64KiB long. This represents the largest possible segment in 16 bit mode
    dw 0xffff ; segment length
    dw 0x0 ; bits 0-15
    db 0x0 ; bits 16-25
    ; 1: Present bit (the segment is available).
    ; 00: Descriptor privilege level (DPL). It specifies the segment's privilege (ring 0, the most privileged).
    ; 1: Descriptor type (1 for code/data segments).
    ; 1: Code segment.
    ; 0: Executable in only one direction (upwards).
    ; 1: Readable segment.
    ; 0: Accessed bit (0 means not accessed yet).
    db 10011010b ; access byte
    db 11001111b ; defines flags
    db 0x0

; data segment descriptor
gdt_data:
    dw 0xffff    
    dw 0x0       
    db 0x0
    ; 1: Present bit.
    ; 00: Descriptor privilege level (ring 0).
    ; 1: Descriptor type (code/data segment).
    ; 0: Not a code segment (this makes it a data segment).
    ; 0: Executable in one direction.
    ; 1: Writable (data segments can be read and written to).
    ; 0: Accessed bit.       
    db 10010010b ; different access byte. allows both reading and writing data
    db 11001111b 
    db 0x0       

    gdt_end: ; calculate the size of the gdt

; GDT descriptor
gdt_descriptor:
    dw gdt_end - gdt_start - 1 ; size (16 bit)
    dd gdt_start ; address (32 bit). will be loaded into the GDTR register

;calculate the offsets
CODE_SEG equ gdt_code - gdt_start
DATA_SEG equ gdt_data - gdt_start

; why the GDT is needed in a bootloader (summary)
; Memory Segmentation and the needed boundaries and access permisions
; enable protected mode