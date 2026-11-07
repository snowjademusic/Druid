; nasm -f elf64 -gdwarf druid.asm -o druid.o
; ld druid.o -o druid

default rel

section .rodata
    SYS_EXIT    equ 60
    SYS_WRITE   equ 1
    SYS_IOCTL   equ 16

    Terminal_IOC_Get_WINSZ  equ 0x5413          ;       TIOCGWINSZ, TIOCSWINSZ - get and set window size
    Terminal_IOC_Set_WINSZ  equ 0x5414


    DRUID_ASCIIART_1 db "[0;34m▀███▄[0;90m   [0;37m [0;34m█▄█▀▀[0;94;44m▒[0;93;44m░[0;90m [0;37m [0;90m   [0;34m▄[0;90m     [0;37m [0;90m [0;34m▄▄[0;37m [0;34m▀███▄[0;90m   [0m"
    DRUID_ASCIIART_1_LEN equ $ - DRUID_ASCIIART_1

    DRUID_ASCIIART_2 db "[0;34m▀[0;90m [0;34m▀[0;90m [0;34m▀█▄[0;90m [0;37m [0;90m [0;34m█[0;90m    [0;94;44m▒[0;34m█[0;37m [0;90m [0;34m▄[0;94;44m░[0;90m    [0;34m▄[0;90m [0;37m [0;90m [0;34m▄▄[0;37m [0;34m▀[0;90m [0;34m▀[0;90m [0;34m▀█▄[0;90m [0m"
    DRUID_ASCIIART_2_LEN equ $ - DRUID_ASCIIART_2

    DRUID_ASCIIART_3 db "[0;90m [0;34m░[0;90m   [0;34m▐[0;93;44m░[0;94;44m▒[0;37m [0;34m██[0;90m   [0;34m▄█[0;90m [0;37m [0;34m█[0;94;44m▓[0;34m▌[0;90m    [0;34m█▌[0;37m [0;34m▐[0;93;44m░[0;94;44m▒[0;37m [0;90m [0;34m░[0;90m   [0;34m▐[0;93;44m░[0;94;44m▒[0m"
    DRUID_ASCIIART_3_LEN equ $ - DRUID_ASCIIART_3

    DRUID_ASCIIART_4 db "[0;90m [0;34m▓░[0;90m   [0;94;44m▒[0;34m█[0;37m [0;34m█[0;94;44m░[0;34m█▄▄▀[0;90m  [0;37m [0;94;44m▒░[0;90m     [0;34m▐█[0;37m [0;34m▐[0;94;44m▒[0;34m█[0;37m [0;90m [0;34m▓░[0;90m   [0;94;44m▒[0;34m█[0m"
    DRUID_ASCIIART_4_LEN equ $ - DRUID_ASCIIART_4

    DRUID_ASCIIART_5 db "[0;90m [0;34m█░[0;90m  [0;34m▌▓█[0;37m [0;34m█[0;94;44m░[0;90m [0;34m▀█▄[0;90m  [0;37m [0;94;44m░▒[0;90m     [0;34m█▌[0;37m [0;34m▐▓█[0;37m [0;90m [0;34m█░[0;90m  [0;34m▌▓█[0m"
    DRUID_ASCIIART_5_LEN equ $ - DRUID_ASCIIART_5

    DRUID_ASCIIART_6 db "[0;34m▀[0;94;44m░[0;34m▓[0;90m [0;34m▄█▀[0;90m [0;37m [0;34m█[0;94;44m▒[0;90m   [0;34m██▄[0;37m [0;90m [0;34m▀▄[0;90m  [0;34m▄[0;94;44m░[0;34m█[0;90m [0;37m [0;90m [0;34m█▓[0;37m [0;34m▀[0;94;44m░[0;34m▓[0;90m [0;34m▄█▀[0;90m [0m"
    DRUID_ASCIIART_6_LEN equ $ - DRUID_ASCIIART_6

    DRUID_ASCIIART_7 db "[0;90m [0;34m▀▀▀▀[0;90m   [0;37m [0;34m▀[0;90m     [0;34m▀[0;90m [0;37m [0;90m   [0;34m▀▀▀▀[0;90m  [0;37m [0;90m [0;34m▀[0;90m [0;37m [0;90m [0;34m▀▀▀▀[0;90m   [0m"
    DRUID_ASCIIART_7_LEN equ $ - DRUID_ASCIIART_7

    ART_TABLE:
        dq DRUID_ASCIIART_1, DRUID_ASCIIART_1_LEN
        dq DRUID_ASCIIART_2, DRUID_ASCIIART_2_LEN
        dq DRUID_ASCIIART_3, DRUID_ASCIIART_3_LEN
        dq DRUID_ASCIIART_4, DRUID_ASCIIART_4_LEN
        dq DRUID_ASCIIART_5, DRUID_ASCIIART_5_LEN
        dq DRUID_ASCIIART_6, DRUID_ASCIIART_6_LEN
        dq DRUID_ASCIIART_7, DRUID_ASCIIART_7_LEN

    DRUID_ART_WIDTH equ 40
    DRUID_ART_HEIGHT equ 7

    CLEAR_TERMINAL db 0x1b, "[2J"
    CLEAR_TERMINAL_LEN equ $ - CLEAR_TERMINAL

    MOVE_CURSOR_0_0_TXT db 0x1b, "[0;0H"
    MOVE_CURSOR_0_0_TXT_LEN equ $ - MOVE_CURSOR_0_0_TXT

    MOVE_CURSOR_RIGHT db 0x1b, "[C"
    MOVE_CURSOR_RIGHT_LEN equ $ - MOVE_CURSOR_RIGHT

    MOVE_CURSOR_DOWN db 0x1b, "[B"
    MOVE_CURSOR_DOWN_LEN equ $ - MOVE_CURSOR_DOWN

    HIDE_CURSOR_AND_INPUT_TXT db 0x1b, "[?25l[8m"
    HIDE_CURSOR_AND_INPUT_TXT_LEN equ $ - HIDE_CURSOR_AND_INPUT_TXT

    STARTER_TXT db "[5mplease press enter to start the sequencer[0m"
    STARTER_TXT_LEN equ $ - STARTER_TXT

    STARTER_TXT_WIDTH equ 41

    ALT_BUFFER_TXT db 0x1b, "[?1049h", 0x1b, "[H"
    ALT_BUFFER_TXT_LEN equ $ - ALT_BUFFER_TXT

    RETURN_TO_TERMINAL db 0x1b, "[?1049l", 0x1b, "[0m"
    RETURN_TO_TERMINAL_LEN equ $ - RETURN_TO_TERMINAL

    ANSI_ESCAPE_OPEN db 0x1b, "["
    SEMICOLON db ";"
    ANSI_CURSOR_END db "H"
    
section .bss
    ; struct winsize {
    ;     unsigned short ws_row;    ; 2 bytes
    ;     unsigned short ws_col;    ; 2 bytes
    ;     unsigned short ws_xpixel; ; 2 bytes (unused by most terminals)
    ;     unsigned short ws_ypixel; ; 2 bytes (unused by most terminals)
    ; };
    winsize resw 4

    int_to_str resb 10

    framebuffer resb 30000          ; biggest Terminal size i tested on was 400x60, so I added some safty margin if I ever want to print to the whole screen
    framecursor resq 1              ;should hold the current address of where to write next

section .text

    global _start

_start:
    
    call enter_alt_screen
    call print_druid_ascii
    call hide_cursor
    call wait_for_return

    call return_to_terminal
    call sys_exit


%include "helpers.asm"


render_frame:
    lea rsi, [framebuffer]
    mov rax, [framecursor]
    sub rax, rsi
    mov rdx, rax
    call print
    ret

print_druid_ascii:
    push rbp
    push r12
    push r13
    push r14
    push r15
    call get_window_size
    movzx r14d, word [winsize]       ; r8w  = ws_row (height)
    movzx r15d, word [winsize + 2]   ; r9w  = ws_col (width)
    sub r14w, DRUID_ART_HEIGHT
    sub r15w, DRUID_ART_WIDTH
    shr r14w, 1                      ; divide by 2
    shr r15w, 1
    lea rax, [framebuffer]          ; move mem location of buffer
    mov [framecursor], rax          ; into framecursor

    mov rdi, r14
    mov rsi, r15
    call append_position

    mov r13, DRUID_ART_HEIGHT           ;load how long the table is to loop through
    lea rbp, [ART_TABLE]
    xor r12, r12

.druid_art_loop:
    mov rdi, [rbp]
    mov rsi, [rbp + 8]
    call append_to_frame_buffer
    
    inc r14
    mov rdi, r14
    mov rsi, r15
    call append_position

    inc r12
    add rbp, 16
    dec r13
    jnz .druid_art_loop

    inc r14
    dec r15
    mov rdi, r14
    mov rsi, r15
    call append_position

    mov rdi, STARTER_TXT
    mov rsi, STARTER_TXT_LEN
    call append_to_frame_buffer

    call render_frame

    pop r15
    pop r14
    pop r13
    pop r12
    pop rbp
    ret


;append_position
;appends next cursor position to the framebuffer
;ESC[{row}:{col}H
;   Args:
;       __rdi: row
;       __rsi: col
append_position:
    mov rcx, [framecursor]
    mov ax, [ANSI_ESCAPE_OPEN]      ;add the begin sequence ESC[
    mov [rcx], ax
    add rcx, 2

    ;call write_init_as_str for row
    push rsi
    mov rsi, rcx
    call write_int_as_str       ; edi already holds row, returns how many digits written in rax
    add rcx, rax

    mov r9b, [SEMICOLON]        ; add the semicolon in the position string
    mov [rcx], r9b
    inc rcx

    pop rdi                     ; edi holds col,
    mov rsi, rcx
    call write_int_as_str       ; returns how many digits written in rax
    add rcx, rax

    mov r9b, [ANSI_CURSOR_END]
    mov [rcx], r9b
    inc rcx

    mov [framecursor], rcx

    ret

;args:
;   __rdi: location of what to write
;   __rsi: how long to write for
append_to_frame_buffer:
    mov rax, [framecursor]
    .appender:
    mov r9b, [rdi]
    mov [rax], r9b
    inc rdi
    inc rax
    dec rsi
    jnz .appender
    
    mov [framecursor], rax
    ret

clear_terminal:
    mov rsi, CLEAR_TERMINAL
    mov rdx, CLEAR_TERMINAL_LEN
    call print
    ret

hide_cursor:
    mov rsi, HIDE_CURSOR_AND_INPUT_TXT
    mov rdx, HIDE_CURSOR_AND_INPUT_TXT_LEN
    call print
    ret

move_cursor_0_0:
    mov rsi, MOVE_CURSOR_0_0_TXT
    mov rdx, MOVE_CURSOR_0_0_TXT_LEN
    call print
    ret

move_cursor_down:
    mov rsi, MOVE_CURSOR_DOWN
    mov rdx, MOVE_CURSOR_DOWN_LEN
    call print
    ret

move_cursor_right:
    mov rsi, MOVE_CURSOR_RIGHT
    mov rdx, MOVE_CURSOR_RIGHT_LEN
    call print
    ret

; Returns the window size of current Terminal in [winsize]
get_window_size:
    mov rax, SYS_IOCTL
    mov rdi, 1                          ; FileDesriptor
    mov rsi, Terminal_IOC_Get_WINSZ
    mov rdx, winsize
    syscall
    ret
