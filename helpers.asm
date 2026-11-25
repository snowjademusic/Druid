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

; wait_for_return
; leverage raw mode to read 1 byte into the stack and from stack into rax
;   Args: 
;       __none
;   Returns:
;       __rax: Byte that was read in IO
;   IO:
;       reads one byte of keaboard input (one key)
read_key:

    mov rax, 0              ; syscall read
    mov rdi, 0              ; Filedescriptor read
    push 0                  ; writes 8 bytes worth of 0s to the stack (reserving space)
    mov rsi, rsp            ; write input to stack (terminal should be in raw mode atp)
    mov rdx, 1              ; read only 1 byte
    syscall

    cmp rax, 0              ; error occured?
    jle error_out

    ; movzx rax, byte [rsp] ; write the revieved byte into rax lowest byte

    pop rax                 ; revert the stack pointer back
    ret                     ; return with byte loaded in rax 


; poll_key:
; polls for a key, so it doesn't block and wait for input
;   Returns:
;       __rax: 0 if no key was pressed, otherwise the byte read from stdin
poll_key:
    mov word [pollfd + poll.revents], 0     ; clear previous revents

    mov rax, 7                              ; sys_poll(struct pollfd *fds, nfds_t nfds, int timeout)
    mov rdi, pollfd                         ; pointer to pollfd struct
    mov rsi, 1                              ; number of file descriptors
    mov rdx, 60                              ; (timeout = 0 is non-blocking; use e.g. 16 for 16ms)
    syscall                                 ; returns amount of elements read into pollfd.revents

    cmp rax, 0                              ; error occured?
    jl error_out
    je .no_input

    test word [pollfd + poll.revents], POLLIN
    jz .no_input

    call read_key
    ret

.no_input:
    xor eax, eax

    ret

; key_debug:
; takes the bytes in rax and writes them to the buffer
key_debug:
    
    push 0
    mov rdi, rax
    mov rsi, rsp
    call write_int_as_str

    mov rdi, rsp
    mov rsi, rax
    call append_to_frame_buffer

    pop rax
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