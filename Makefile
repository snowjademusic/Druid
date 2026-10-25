druid: druid.asm
	nasm -f elf64 -gdwarf druid.asm -o druid.o
	ld druid.o -o druid
	./druid