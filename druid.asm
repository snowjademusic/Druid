; nasm -f elf64 -gdwarf druid.asm -o druid.o
; ld druid.o -o druid

default rel

section .rodata
    SYS_EXIT    equ 60
    SYS_WRITE   equ 1
    SYS_IOCTL   equ 16

    Terminal_IOC_Get_WINSZ  equ 0x5413          ;       TIOCGWINSZ - Terminal IO control get window size

    TCGETS equ 0x5401
    TCSETS equ 0x5402

    ICRNL equ 0x100
    IXON equ 0x400

    C_IFLAG_MASK equ ~(ICRNL|IXON)

    ISIG equ 0x1
    ICANON equ 0x2
    ECHO equ 0x8

    C_LFLAG_MASK equ ~(ISIG|ICANON|ECHO)        ; | does bitwise or, ~ is to negate the whole expression

    ENTER_KEY equ 0xd
    KEYBOARD_INTERRUPT equ 0x03

    VTIME_IDX equ 5
    VMIN_IDX equ 6

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

    MOVE_CURSOR_0_0_TXT db 0x1b, "[1;1H"
    MOVE_CURSOR_0_0_TXT_LEN equ $ - MOVE_CURSOR_0_0_TXT

    MOVE_CURSOR_RIGHT db 0x1b, "[C"
    MOVE_CURSOR_RIGHT_LEN equ $ - MOVE_CURSOR_RIGHT

    MOVE_CURSOR_DOWN db 0x1b, "[B"
    MOVE_CURSOR_DOWN_LEN equ $ - MOVE_CURSOR_DOWN

    HIDE_CURSOR db 0x1b, "[?25l"
    HIDE_CURSOR_LEN equ $ - HIDE_CURSOR

    STARTER_TXT db "[5mplease press enter to start the sequencer[0m"
    STARTER_TXT_LEN equ $ - STARTER_TXT

    STARTER_TXT_WIDTH equ 41

    ALT_BUFFER_TXT db 0x1b, "[?1049h", 0x1b, "[H"
    ALT_BUFFER_TXT_LEN equ $ - ALT_BUFFER_TXT

    RETURN_TO_TERMINAL db 0x1b, "[?1049l", 0x1b, "[0m", 0x1b, "[?25h"
    RETURN_TO_TERMINAL_LEN equ $ - RETURN_TO_TERMINAL

    TERMINAL_TOO_SMALL db "Terminal size too small"
    TERMINAL_TOO_SMALL_LEN equ $ - TERMINAL_TOO_SMALL

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

    ; struct termios{
    ; offset	size	field
    ;--------------------------
    ; 0	        4	    c_iflag
    ; 4	        4	    c_oflag
    ; 8	        4	    c_cflag
    ; 12	    4	    c_lflag (the one we change)
    ; 16	    1	    c_line
    ; 17	    19	    c_cc[19] (special characters)}
    raw_termios resb 36
    orig_termios resb 36
    TERMIOS_LEN equ 36


    framebuffer resb 30000          ; biggest Terminal size i tested on was 400x60, so I added some safty margin if I ever want to print to the whole screen
    framecursor resq 1              ;should hold the current address of where to write next

section .text

    global _start

_start:
    
    lea rax, [framebuffer]              ; move mem location of framebuffer
    mov [framecursor], rax              ; into framecursor
    call enter_alt_screen
    call raw_mode_Termios
    call print_druid_ascii
    call hide_cursor
    call render_frame
    call wait_for_return


    ; Tear down of raw input and alt Terminal
    call restore_Termios
    call return_to_terminal
    call render_frame
    call sys_exit


%include "helpers.asm"


render_frame:
    lea rsi, [framebuffer]
    mov rax, [framecursor]
    sub rax, rsi
    mov rdx, rax
    call print

    ;reset framecursor
    lea rax, [framebuffer]              ; move mem location of framebuffer
    mov [framecursor], rax              ; into framecursor

    ret

print_druid_ascii:
    push rbp
    push r13
    push r14
    push r15
    call get_window_size
    movzx r14d, word [winsize]          ; ws_row (height)
    movzx r15d, word [winsize + 2]      ; ws_col (width)
    sub r14d, DRUID_ART_HEIGHT
    jbe .terminal_too_small             ; check size
    sub r15d, DRUID_ART_WIDTH
    jbe .terminal_too_small             ; check size
    shr r14d, 1                         ; divide by 2
    shr r15d, 1

    inc r14d
    inc r15d

    mov rdi, r14
    mov rsi, r15
    call append_position

    mov r13, DRUID_ART_HEIGHT           ;load how long the table is to loop through
    lea rbp, [ART_TABLE]

.druid_art_loop:
    mov rdi, [rbp]
    mov rsi, [rbp + 8]
    call append_to_frame_buffer
    
    inc r14
    mov rdi, r14
    mov rsi, r15
    call append_position

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

    pop r15
    pop r14
    pop r13
    pop rbp
    ret

.terminal_too_small:

    mov rdi, TERMINAL_TOO_SMALL
    mov rsi, TERMINAL_TOO_SMALL_LEN
    call append_to_frame_buffer

    pop r15
    pop r14
    pop r13
    pop rbp
    ret

;append_position
;appends next cursor position to the framebuffer
;ESC[{row}:{col}H
;   Args:
;       __rdi: row
;       __rsi: col
;   Clobbers: 
;       rax, rcx, rsi, rdi, r9, rdx, r10
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

; append_to_frame_buffer
;   Args:
;       __rdi: location of what to write
;       __rsi: how long to write for
;   Clobbers:
;       rax, rcx, rsi, rdi
append_to_frame_buffer:
    mov rax, [framecursor]

    cld                         ; clear direction flag
    mov rcx, rsi                ; rep movsb takes number of bytes to copy in rcx
    mov rsi, rdi              ; rep movsb takes source address in rsi
    mov rdi, rax                ; rep movsb takes destination adress in rdi
    rep movsb

    mov [framecursor], rdi
    ret

hide_cursor:
    mov rdi, HIDE_CURSOR
    mov rsi, HIDE_CURSOR_LEN
    call append_to_frame_buffer
    ret

; Returns the window size of current Terminal in [winsize]
get_window_size:
    mov rax, SYS_IOCTL
    mov rdi, 1                          ; FileDesriptor of our terminal output we want to get the info from
    mov rsi, Terminal_IOC_Get_WINSZ
    mov rdx, winsize
    syscall
    
    cmp rax, 0
    jl error_out
    ret

; Exit with error code
error_out:
        ;TODO - keep track of what what program state we're in, how much cleanup needs to happen before exit!
    ; clean up
    call restore_Termios
    call return_to_terminal
    call render_frame
    mov rax, SYS_EXIT
    mov rdi, 1
    syscall


; get_Termios_state:
; -> get original Termios state and store it in orig_termios
; -> copy over to raw_termios
get_Termios_state:
    mov rax, SYS_IOCTL
    mov rdi, 0                          ; FileDesriptor of our terminal INPUT we want to get the info from
    mov rsi, TCGETS
    mov rdx, orig_termios
    syscall

    ; see if error occurred in syscall
    cmp rax, 0
    jl error_out

    ; copy over to raw_termios
    mov rsi, orig_termios
    mov rdi, raw_termios
    mov rcx, TERMIOS_LEN
    rep movsb

    ret

; set_Termios_state: 
; -> sets Termios state with struct given in rdi
;   Args:
;       __rdi: pointer to termios struct you want to set
;   Clobbers: 
;       rax, rdx, rdi, rsi
set_Termios_state:
    mov rdx, rdi
    mov rax, SYS_IOCTL
    mov rdi, 0                          ; FileDesriptor of our terminal INPUT we want to modify
    mov rsi, TCSETS
    syscall

    cmp rax, 0 
    jl error_out

    ret 


; raw_mode_Termios:
; 
; 
raw_mode_Termios:

    call get_Termios_state

    and dword [raw_termios], C_IFLAG_MASK
    and dword [raw_termios + 12], C_LFLAG_MASK              ; AND with our mask, so only the flags we want to affect are turned to 0
    mov byte [raw_termios + 17 + VMIN_IDX], 1                  ; set VMIN to 1 for returning after 1 byte
    mov byte [raw_termios + 17 + VTIME_IDX], 0                 ; set VTIME to 0 to always accept input

    mov rdi, raw_termios
    call set_Termios_state

    ret

restore_Termios:
    mov rdi, orig_termios
    call set_Termios_state
    ret

