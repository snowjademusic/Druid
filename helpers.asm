; DOCS::

; Callee vs Caller Saved
; The registers RAX, RCX, RDX, RDI, RSI, R8, R9, R10, and R11 are considered volatile (caller-saved).[30]
; The registers RBX, RBP, R12, R13, R14, and R15 are considered nonvolatile (callee-saved). (Wikipedia(System V ABI))

; Arguments to functions
; Argument 1	*rdi*	First parameter
; Argument 2	*rsi*	Second parameter
; Argument 3	*rdx*	Third parameter
; Argument 4	*rcx*	Fourth parameter
; Argument 5	*r8*	Fifth parameter
; Argument 6	*r9*	Sixth parameter

; DOCS OVER::

;write_int_as_str 
;   Args: 
;       __edi: value to convert, 
;       __rsi: where to write, provides at least 10 writable bytes; no check for this
;   Returns:
;       __eax: nr of bytes written
;   Clobbers:
;       rax, rdx, r9, r10, rsi, rdi, flags
write_int_as_str:
    mov eax, edi
    xor r9d, r9d            ; init counter to 0 to keep track of string len
    mov r10d, 10            ; store divisor in a register

.push_loop:
    xor edx, edx
    div r10d              ; rax / 10 -> quotient in rax, remainder in rdx(edx, dx, dl)
    add dl, "0"         ; add the ascii value of 0 to the remainder to get ascii remainder
    push rdx
    inc r9             ; increment string len
    test rax, rax       ; idiomatic way of doing cmp rax, 0 (specifically 0)
    jnz .push_loop

    mov eax, r9d

.pop_loop:
    pop rdx
    mov [rsi], dl
    inc rsi
    dec r9
    jnz .pop_loop
    
    ;once full number is written to rsi
    ret

;print
;   Args:
;       rsi: location of what to write
;       rdx: len(bytes) of what to write
;   IO:
;       prints to terminal
print:
    mov rax, SYS_WRITE
    mov rdi, 1                          ; FileDescriptor
    syscall
    ret


wait_for_return:
    mov rax, 0
    mov rdi, 0

    sub rsp, 8
    ;TODO READ INTO STACK
    mov rsi, 0
    mov rdx, 1
    syscall
    ret

;enter_alt_screen
;   doesn't take args
enter_alt_screen:
    mov rdi, ALT_BUFFER_TXT
    mov rsi, ALT_BUFFER_TXT_LEN
    call append_to_frame_buffer
    ret

;return_to_terminal
;   returns to original terminal
return_to_terminal:
    mov rdi, RETURN_TO_TERMINAL
    mov rsi, RETURN_TO_TERMINAL_LEN
    call append_to_frame_buffer
    ret

;sys_exit:
;   exit with code: 0
sys_exit:
    mov rax, SYS_EXIT
    mov rdi, 0
    syscall