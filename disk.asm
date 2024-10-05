; Register	Parameter
; ah	    Mode (0x02 = read from disk)
; al	    Number of sectors to read
; ch	    Cylinder
; cl	    Sector
; dh	    Head
; dl	    Drive
; es:bx	    Memory address to load into (buffer address pointer)

disk_load:
    ; the stack is like a temperoray storage area where values can be saved for later use. registers should be stored in the stack to ensure that none of their value are changed
    pusha ; push all general purpose registers onto the stack
    push dx

    ; tell BIOS what type of disk operating is going to be performed
    mov ah, 0x02 ; read mode
    mov al, dh   ; read dh number of sectors
    mov cl, 0x02 ; start from sector 2
                 ; (as sector 1 is our boot sector)
    mov ch, 0x00 ; cylinder 0
    mov dh, 0x00 ; head 0

    ; dl = drive number is set as input to disk_load
    ; es:bx = buffer pointer is set as input as well

    int 0x13      ; BIOS interrupt. will allow the bootloader to read data from the disk
    jc disk_error ; check carry bit for error. If there is an error then the program should enter in an error loop

    pop dx     ; get back original number of sectors to read
    cmp al, dh ; BIOS sets 'al' to the # of sectors actually read
               ; compare it to 'dh' and error out if they are !=
    jne sectors_error ; jne follows a cmp command it is means jump if not equal
    popa ; remove everything from the stack
    ret ; return control to whatever called this function

; create infinite loops that stop the program
disk_error:
    jmp disk_loop

sectors_error:
    jmp disk_loop

disk_loop:
    jmp $