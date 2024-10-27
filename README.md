# Custom_Bootloader
## Quick summary of how I think the bootloader works
* mbr.asm is first loaded by BIOS
* mbr then loads the kernel from the disk before converting the mode to 32 bit protected mode
* The control is then given to the kernel
* by transferring control to the kernel, execution begins at _start
## CPU
### Registers
* They are the working memory of the central processing unit
* Registers have different purposes
* Each have a specific size
* 32 bit systems have 32 bit registers and so on
* x86 assembly was made for 32 bit systems
* x86 assembly is compatible with x64 due to backwards compatibility
* the term x86 assembly came from the Intel 8086 processor
### Stack
* region of memory
* last in first out data structure (LIFO)
* is an array
* stack pointer. a special CPU register that points to the top of the stack. it automatically updates
* Random access
## Inspiration
A lot of the code is from:
https://dev.to/frosnerd/writing-my-own-boot-loader-3mld
