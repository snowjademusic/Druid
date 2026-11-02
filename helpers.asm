section .text

global _start


write_num:
    mov rbx, 10
    lea rsi, [rel buffer + 31] ; complains about absulute value? use rel?
    mov [rsi], 0x20     ; add a space after the number
    mov rcx, 1          ; counter to keep track of string len

.convert_loop:
    xor edx, edx
    div rbx             ; rax / 10(rdx) -> quotient in rax, remainder in rdx(edx, dx, dl)
    add dl, "0"         ; add the ascii value of 0 to the remainder to get ascii remainder
    dec rsi             ; decrement rsi by 1
    mov [rsi], dl       ; move dl into address stored in rsi
    inc rcx             ; increment string len
    test rax, rax       ; idiomatic way of doing cmp rax, 0 (specifically 0)
    jnz .convert_loop

    ; once whole number is converted to ascii and pushed to string 
    mov rax, 1          ; sys_write syscall
    mov rdi, 1          ; stdout
                        ; rsi already points to start of string
    mov rdx, rcx        ; len of string
    syscall
    ret