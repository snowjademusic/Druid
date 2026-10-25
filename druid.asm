; nasm -f elf64 -gdwarf druid.asm -o druid.o
; ld druid.o -o druid

default rel

section .data
    SYS_EXIT    equ 60
    SYS_WRITE   equ 1
    SYS_IOCTL   equ 16

    Terminal_IOC_Get_WINSZ  equ 0x5413          ;       TIOCGWINSZ, TIOCSWINSZ - get and set window size
    Terminal_IOC_Set_WINSZ  equ 0x5414



    DRUID_ASCIIART_1 db "[0;34m▀███▄[0;90m   [0;37m [0;34m█▄█▀▀[0;94;44m▒[0;93;44m░[0;90m [0;37m [0;90m   [0;34m▄[0;90m     [0;37m [0;90m [0;34m▄▄[0;37m [0;34m▀███▄[0;90m   [0m", 10
    DRUID_ASCIIART_1_LEN equ $ - DRUID_ASCIIART_1

    DRUID_ASCIIART_2 db "[0;34m▀[0;90m [0;34m▀[0;90m [0;34m▀█▄[0;90m [0;37m [0;90m [0;34m█[0;90m    [0;94;44m▒[0;34m█[0;37m [0;90m [0;34m▄[0;94;44m░[0;90m    [0;34m▄[0;90m [0;37m [0;90m [0;34m▄▄[0;37m [0;34m▀[0;90m [0;34m▀[0;90m [0;34m▀█▄[0;90m [0m", 10
    DRUID_ASCIIART_2_LEN equ $ - DRUID_ASCIIART_2

    DRUID_ASCIIART_3 db "[0;90m [0;34m░[0;90m   [0;34m▐[0;93;44m░[0;94;44m▒[0;37m [0;34m██[0;90m   [0;34m▄█[0;90m [0;37m [0;34m█[0;94;44m▓[0;34m▌[0;90m    [0;34m█▌[0;37m [0;34m▐[0;93;44m░[0;94;44m▒[0;37m [0;90m [0;34m░[0;90m   [0;34m▐[0;93;44m░[0;94;44m▒[0m", 10
    DRUID_ASCIIART_3_LEN equ $ - DRUID_ASCIIART_3

    DRUID_ASCIIART_4 db "[0;90m [0;34m▓░[0;90m   [0;94;44m▒[0;34m█[0;37m [0;34m█[0;94;44m░[0;34m█▄▄▀[0;90m  [0;37m [0;94;44m▒░[0;90m     [0;34m▐█[0;37m [0;34m▐[0;94;44m▒[0;34m█[0;37m [0;90m [0;34m▓░[0;90m   [0;94;44m▒[0;34m█[0m", 10
    DRUID_ASCIIART_4_LEN equ $ - DRUID_ASCIIART_4

    DRUID_ASCIIART_5 db "[0;90m [0;34m█░[0;90m  [0;34m▌▓█[0;37m [0;34m█[0;94;44m░[0;90m [0;34m▀█▄[0;90m  [0;37m [0;94;44m░▒[0;90m     [0;34m█▌[0;37m [0;34m▐▓█[0;37m [0;90m [0;34m█░[0;90m  [0;34m▌▓█[0m", 10
    DRUID_ASCIIART_5_LEN equ $ - DRUID_ASCIIART_5

    DRUID_ASCIIART_6 db "[0;34m▀[0;94;44m░[0;34m▓[0;90m [0;34m▄█▀[0;90m [0;37m [0;34m█[0;94;44m▒[0;90m   [0;34m██▄[0;37m [0;90m [0;34m▀▄[0;90m  [0;34m▄[0;94;44m░[0;34m█[0;90m [0;37m [0;90m [0;34m█▓[0;37m [0;34m▀[0;94;44m░[0;34m▓[0;90m [0;34m▄█▀[0;90m [0m", 10
    DRUID_ASCIIART_6_LEN equ $ - DRUID_ASCIIART_6

    DRUID_ASCIIART_7 db "[0;90m [0;34m▀▀▀▀[0;90m   [0;37m [0;34m▀[0;90m     [0;34m▀[0;90m [0;37m [0;90m   [0;34m▀▀▀▀[0;90m  [0;37m [0;90m [0;34m▀[0;90m [0;37m [0;90m [0;34m▀▀▀▀[0;90m   [0m", 10, 10
    DRUID_ASCIIART_7_LEN equ $ - DRUID_ASCIIART_7

    CLEAR_TERMINAL db 0x1b, "[2J" ,0x1b, "[3J"
    CLEAR_TERMINAL_LEN equ $ - CLEAR_TERMINAL

    MOVE_CURSOR_0_0_TXT db 0x1b, "[0;0H"
    MOVE_CURSOR_0_0_TXT_LEN equ $ - MOVE_CURSOR_0_0_TXT

    MOVE_CURSOR_RIGHT db 0x1b, "[C"
    MOVE_CURSOR_RIGHT_LEN equ $ - MOVE_CURSOR_RIGHT

    MOVE_CURSOR_DOWN db 0x1b, "[B"
    MOVE_CURSOR_DOWN_LEN equ $ - MOVE_CURSOR_DOWN

    MOVE_CURSOR_TXT db 0x1b, "[0;0H"
    MOVE_CURSOR_TXT_LEN equ $ - MOVE_CURSOR_TXT

    STARTER_TXT db "[5mplease press enter to start the sequencer[0m", 10
    STARTER_TXT_LEN equ $ - STARTER_TXT
    
section .bss
    section .bss
    ; struct winsize {
    ;     unsigned short ws_row;    ; 2 bytes
    ;     unsigned short ws_col;    ; 2 bytes
    ;     unsigned short ws_xpixel; ; 2 bytes (unused by most terminals)
    ;     unsigned short ws_ypixel; ; 2 bytes (unused by most terminals)
    ; };
    winsize resw 4

section .text

    global _start

_start:
    
    call clear_terminal

    call print_druid_ascii
    call wait_for_return

    call clear_terminal

    call sys_exit

sys_exit:
    mov rax, SYS_EXIT
    mov rdi, 0
    syscall

print_druid_ascii:
    call get_window_size
    movzx r8w, word [winsize]       ; r8w  = ws_row (height)
    movzx r9w, word [winsize + 2]   ; r9w  = ws_col (width)
    shr r8w, 1                      ; divide by 2
    shr r9w, 1
    sub r8w, 3                      ; shift cursor upwards, so the middle of text is in the middle
    sub r9w, 20                     ; shift cursor left

    .move_down:
    call move_cursor_down
    dec r8w
    jnz .move_down

    movzx di, r9w
    call move_right

    mov rsi, DRUID_ASCIIART_1
    mov rdx, DRUID_ASCIIART_1_LEN
    call print

    movzx di, r9w
    call move_right

    mov rsi, DRUID_ASCIIART_2
    mov rdx, DRUID_ASCIIART_2_LEN
    call print

    movzx di, r9w
    call move_right

    mov rsi, DRUID_ASCIIART_3
    mov rdx, DRUID_ASCIIART_3_LEN
    call print

    movzx di, r9w
    call move_right

    mov rsi, DRUID_ASCIIART_4
    mov rdx, DRUID_ASCIIART_4_LEN
    call print

    movzx di, r9w
    call move_right

    mov rsi, DRUID_ASCIIART_5
    mov rdx, DRUID_ASCIIART_5_LEN
    call print

    movzx di, r9w
    call move_right

    mov rsi, DRUID_ASCIIART_6
    mov rdx, DRUID_ASCIIART_6_LEN
    call print

    movzx di, r9w
    call move_right

    mov rsi, DRUID_ASCIIART_7
    mov rdx, DRUID_ASCIIART_7_LEN
    call print

    movzx di, r9w
    sub di, 1
    call move_right

    mov rsi, STARTER_TXT
    mov rdx, STARTER_TXT_LEN
    call print

    movzx di, r9w
    add di, 20
    call move_right

    ret

clear_terminal:
    mov rsi, CLEAR_TERMINAL
    mov rdx, CLEAR_TERMINAL_LEN
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

print:
    mov rax, SYS_WRITE
    mov rdi, 1                          ; FileDescriptor
    syscall
    ret

get_window_size:
    mov rax, SYS_IOCTL
    mov rdi, 1                          ; FileDesriptor
    mov rsi, Terminal_IOC_Get_WINSZ
    mov rdx, winsize
    syscall
    ret

set_cursor_to_middle:
    call get_window_size
    movzx r8w, word [winsize]     ; r8w  = ws_row (height)
    movzx r9w, word [winsize + 2] ; r9w  = ws_col (width)
    shr r8w, 1
    shr r9w, 1

.move_down:
    call move_cursor_down
    dec r8w
    jnz .move_down

.move_right:
    call move_cursor_right
    dec r9w
    jnz .move_right

    ret

move_right:
    push r9w
    movzx r9w, di

.move_loop:
    call move_cursor_right
    dec r9w
    jnz .move_loop

    pop r9w
    ret

wait_for_return:
    mov rax, 0
    mov rdi, 0
    mov rsi, 0
    mov rdx, 1
    syscall
    ret