all: run
kernel.bin: kernel-entry.o kernel.o
	ld -m elf_i386 -Ttext 0x1000 --entry=_start -o $@ $^ --oformat binary

kernel-entry.o: kernel-entry.asm
	nasm kernel-entry.asm -f elf -o kernel-entry.o

kernel.o: kernel.c
	gcc -m32 -ffreestanding -nostdlib -fno-pie -no-pie -c $< -o $@

mbr.bin: mbr.asm
	nasm $< -f bin -o $@

os-image.bin: mbr.bin kernel.bin
	cat $^ > $@

run: os-image.bin
	qemu-system-i386 -fda $<

clean:
	$(RM) *.bin *.o *.dis