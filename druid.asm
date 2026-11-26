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

    SPACE_BAR_KEY equ 32

    UP_ARROW_KEY equ 65
    DOWN_ARROW_KEY equ 66
    RIGHT_ARROW_KEY equ 67
    LEFT_ARROW_KEY equ 68

    W_KEY equ 119
    S_KEY equ 115
    D_KEY equ 100
    A_KEY equ 97

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

%define TopLeft  0xE2, 0x95, 0xAD           ; ╭
%define TopRight  0xE2, 0x95, 0xAE          ; ╮
%define BottomRight  0xE2, 0x95, 0xAF       ; ╯
%define BottomLeft  0xE2, 0x95, 0xB0        ; ╰
%define Horizontal  0xE2, 0x94, 0x80        ; ─
%define Vertical  0xE2, 0x94, 0x82          ; │
%define TopSeparator  0xE2, 0x94, 0xAC      ; ┬
%define BottomSeparator  0xE2, 0x94, 0xB4   ; ┴

    ; Top border: ╭────────┬────────┬────────┬────────╮
    TOP_BORDER:
        db TopLeft
        times 8 db Horizontal
        db TopSeparator
        times 8 db Horizontal
        db TopSeparator
        times 8 db Horizontal
        db TopSeparator
        times 8 db Horizontal
        db TopRight, 0x1b, "[0m"
    TOP_BORDER_LEN equ $ - TOP_BORDER

    ; Bottom border: ╰────────┴────────┴────────┴────────╯
    BOT_BORDER:
        db BottomLeft
        times 8 db Horizontal
        db BottomSeparator
        times 8 db Horizontal
        db BottomSeparator
        times 8 db Horizontal
        db BottomSeparator
        times 8 db Horizontal
        db BottomRight, 0x1b, "[0m"
    BOT_BORDER_LEN equ $ - BOT_BORDER

    CLEAR_TERMINAL db 0x1b, "[2J"
    CLEAR_TERMINAL_LEN equ $ - CLEAR_TERMINAL

    CLEAR_FROM_CURSOR_ONWARD db 0x1b, "[0J"
    CLEAR_FROM_CURSOR_ONWARD_LEN equ $ - CLEAR_FROM_CURSOR_ONWARD

    MOVE_CURSOR_0_0_TXT db 0x1b, "[1;1H"
    MOVE_CURSOR_0_0_TXT_LEN equ $ - MOVE_CURSOR_0_0_TXT

    MOVE_CURSOR_RIGHT db 0x1b, "[C"
    MOVE_CURSOR_RIGHT_LEN equ $ - MOVE_CURSOR_RIGHT

    MOVE_CURSOR_DOWN db 0x1b, "[B"
    MOVE_CURSOR_DOWN_LEN equ $ - MOVE_CURSOR_DOWN

    HIDE_CURSOR_TXT db 0x1b, "[?25l"
    HIDE_CURSOR_TXT_LEN equ $ - HIDE_CURSOR_TXT

    SHOW_CURSOR_TXT db 0x1b, "[?25h"
    SHOW_CURSOR_TXT_LEN equ $ - SHOW_CURSOR_TXT

    STARTER_TXT db "[5mplease press enter to start the sequencer[0m"
    STARTER_TXT_LEN equ $ - STARTER_TXT

    STARTER_TXT_WIDTH equ 41

    ALT_BUFFER_TXT db 0x1b, "[?1049h", 0x1b, "[H"
    ALT_BUFFER_TXT_LEN equ $ - ALT_BUFFER_TXT

    RETURN_TO_TERMINAL db 0x1b, "[?1049l", 0x1b, "[0m", 0x1b, "[?25h"
    RETURN_TO_TERMINAL_LEN equ $ - RETURN_TO_TERMINAL

    TERMINAL_TOO_SMALL db "Terminal size too small"
    TERMINAL_TOO_SMALL_LEN equ $ - TERMINAL_TOO_SMALL

    VERTICAL db "│"
    VERTICAL_LEN equ $ - VERTICAL

    ANSI_ESCAPE_OPEN db 0x1b, "["
    SEMICOLON db ";"
    ANSI_CURSOR_END db "H"
    SCROLL_DOWN_END db "S" 

    incbin "kick.raw"

    SEQUENCER_CURSOR_HIGHLIGHT_START db 0x1b, "[48;5;231m", 0x1b, "[30m"
    SEQUENCER_CURSOR_HIGHLIGHT_START_LEN equ $ -  SEQUENCER_CURSOR_HIGHLIGHT_START

    PLAYER_HIGHLIGHT_START db 0x1b, "[48;5;232m",
    PLAYER_HIGHLIGHT_START_LEN equ $ - PLAYER_HIGHLIGHT_START

    RESET_TXT db 0x1b, "[0m"
    RESET_TXT_LEN equ $ - RESET_TXT

    BPM_TO_STEPSIZE_CONSTANT equ 7500                   ; with 8 steps per beat, we take 60000ms / 8 to get the ms per bpm -> divide by BPM to get the ms per step

section .data

    playing db 0

    BPM dq 125

    playhead dq 0

    KICK_STATE times 4 db "X       "
    KICK_STATE_LEN equ $ - KICK_STATE
    
    SNARE_STATE times 2 db "        X       "
    SNARE_STATE_LEN equ $ - SNARE_STATE

    HAT_STATE times 4 db "    X   "
    HAT_STATE_LEN equ $ - HAT_STATE

    PERCUSSION_STATE db "                      X   X     "
    PERCUSSION_STATE_LEN equ $ - PERCUSSION_STATE

    NUM_CHANNELS equ 4

    Sequencer_cursor dq 0
    MAX_SEQUENCER_CURSOR equ NUM_CHANNELS * 32

    PLAYHEAD dq 0

    POLLIN equ 0x0001
    ;   struct pollfd {
    ;       int fd;             ; file descriptor
    ;       short events;       ; requested events
    ;       short revents;      ; returned events
    ;}
    struc poll
        .fd:      resd 1
        .events:  resw 1
        .revents: resw 1
    endstruc

pollfd: 
    istruc poll
        at .fd, dd 0
        at .events, dw POLLIN
        at .revents, dw 0
    iend

section .bss
    ; struct winsize {
    ;     unsigned short ws_row;    ; 2 bytes
    ;     unsigned short ws_col;    ; 2 bytes
    ;     unsigned short ws_xpixel; ; 2 bytes (unused by most terminals)
    ;     unsigned short ws_ypixel; ; 2 bytes (unused by most terminals)
    ; };
    winsize resw 4

    cursor_x_position resb 8
    cursor_y_position resb 8

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

    ; kick_state resb 16
    ; snare_state resb 16
    ; hat_state resb 16
    ; percussion_state resb 16

    framebuffer resb 30000          ; biggest Terminal size i tested on was 400x60, so I added some safty margin if I ever want to print to the whole screen
    framecursor resq 1              ;should hold the current address of where to write next

section .text

    global _start


; ====================================================================
; =============================[START]================================
; ====================================================================
_start:
    

    ; setup
    lea rax, [framebuffer]              ; move mem location of framebuffer
    mov [framecursor], rax              ; into framecursor
    call enter_alt_screen
    call raw_mode_Termios
    call print_title_screen             ; TODO add info on programm usage below the art maybe? only once core features are implemented
    call render_frame
    call key_handler_title_screen       ; continues on enter; exits upon ctrl-c

.main_loop:
    call sequencer_logic
    call render_frame
    call key_handler
    jmp .main_loop



; ====================================================================
; ==============================[END]=================================
; ====================================================================


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

    mov rdi, CLEAR_TERMINAL
    mov rsi, CLEAR_TERMINAL_LEN
    call append_to_frame_buffer

    ret

print_title_screen:
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
    call hide_cursor

    mov [cursor_y_position], r14
    mov [cursor_x_position], r15

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

; scroll_down:
; scrolls down the terminal by amount of lines in rdi
;   Args:
;       __rdi: how many lines to scroll
;   Clobbers:
;       rax, rcx, rsi, rdi, rdx, r9, r10
scroll_down:
    mov rcx, [framecursor]
    mov ax, [ANSI_ESCAPE_OPEN]      ; add the begin sequence ESC[
    mov [rcx], ax
    add rcx, 2

    mov rsi, rcx
    call write_int_as_str           ; edi once again holds the number already
    add rcx, rax

    mov r9b, [SCROLL_DOWN_END]      ; add end sequence
    mov [rcx], r9b
    inc rcx

    mov [framecursor], rcx

    ret

hide_cursor:
    mov rdi, HIDE_CURSOR_TXT
    mov rsi, HIDE_CURSOR_TXT_LEN
    call append_to_frame_buffer
    ret

show_cursor:
    mov rdi, SHOW_CURSOR_TXT
    mov rsi, SHOW_CURSOR_TXT_LEN
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

error_out_Termios_fail:
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
    jl error_out_Termios_fail

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
    jl error_out_Termios_fail

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


; key_handler
key_handler:

    ; call read_key                         ; returns read byte in rax

    call poll_key

    test rax, rax                           ; check if 0 was returned
    jz .cursor_advance

    cmp rax, KEYBOARD_INTERRUPT
    jz tear_down

    cmp rax, ENTER_KEY
    jz .enter_key

    cmp rax, SPACE_BAR_KEY
    jz .space_bar

    cmp rax, UP_ARROW_KEY
    jz .up_arrow

    cmp rax, W_KEY
    jz .up_arrow

    cmp rax, DOWN_ARROW_KEY
    jz .down_arrow

    cmp rax, S_KEY
    jz .down_arrow

    cmp rax, RIGHT_ARROW_KEY
    jz .right_arrow

    cmp rax, D_KEY
    jz .right_arrow

    cmp rax, LEFT_ARROW_KEY
    jz .left_arrow

    cmp rax, A_KEY
    jz .left_arrow

    jmp .continue


.space_bar:
    
    movzx rcx, byte [playing]
    test rcx, rcx
    jz .playing_is_0

    mov [playing], byte 0

    jmp .continue

.playing_is_0:
    mov [playing], byte 1
    mov [playhead], qword 0

    jmp .continue

.cursor_advance:

    inc qword [playhead]
    mov rcx, [playhead]
    cmp rcx, qword 32               ; see if we're greater than 32(entire bar size)
    jl .continue

    mov [playhead], qword 0

    jmp .continue

.enter_key:
    
    mov rcx, KICK_STATE
    add rcx, [Sequencer_cursor]
    movzx rdx, byte [rcx]

    cmp rdx, byte "X"
    jz .x_was_there

    mov [rcx], byte "X"

    jmp .continue

.x_was_there:

    mov [rcx], byte " "
    jmp .continue

.up_arrow:

    mov rcx, [Sequencer_cursor]
    sub rcx, 32
    mov [Sequencer_cursor], rcx
    jge .continue

    xor rdx, rdx
    mov [Sequencer_cursor], rdx

    jmp .continue

.down_arrow:

    mov rcx, [Sequencer_cursor]
    add rcx, 32
    mov [Sequencer_cursor], rcx
    cmp rcx, MAX_SEQUENCER_CURSOR
    jl .continue

    mov [Sequencer_cursor], qword MAX_SEQUENCER_CURSOR - 1

    jmp .continue

.right_arrow:

    mov rcx, [Sequencer_cursor]
    add rcx, 1
    mov [Sequencer_cursor], rcx
    cmp rcx, MAX_SEQUENCER_CURSOR
    jl .continue

    mov [Sequencer_cursor], qword MAX_SEQUENCER_CURSOR - 1

    jmp .continue

.left_arrow:

    mov rcx, [Sequencer_cursor]
    sub rcx, 1
    mov [Sequencer_cursor], rcx
    jge .continue

    xor rdx, rdx
    mov [Sequencer_cursor], rdx

    jmp .continue

.continue:

    call key_debug
    
    ret

key_handler_title_screen:

.wait_for_valid_input:

    call read_key                       ; returns read byte in rax

    cmp rax, KEYBOARD_INTERRUPT
    jz tear_down

    cmp rax, ENTER_KEY
    jnz .wait_for_valid_input

    ret

tear_down:
    ; Tear down 
    call restore_Termios                ; return to normal input mode
    call return_to_terminal             ; return to Terminal we called from
    call render_frame                   ; final render of our escape codes
    call sys_exit                       ; clean exit with code 0

sequencer_logic:

    push rbx
    push rbp
    push r12
    push r13
    push r14
    push r15
    call get_window_size
    movzx r14d, word [winsize]          ; ws_row (height)
    movzx r15d, word [winsize + 2]      ; ws_col (width)
    ; sub r14d, 2
    sub r15d, 37
    shr r14d, 1                         ; divide by 2
    shr r15d, 1

    ; mov r14, [cursor_y_position]
    ; mov r15, [cursor_x_position]

    mov rdi, r14
    mov rsi, r15
    call append_position

    mov rdi, TOP_BORDER
    mov rsi, TOP_BORDER_LEN
    call append_to_frame_buffer

    mov r11, NUM_CHANNELS               ; loop for all channels
    mov r13, KICK_STATE                 ; start with Kick state, inc through since all are initialized consecutively/ contiguously
    mov rbx, [Sequencer_cursor]         ; where to print the cursor
    mov rbp, 0                          ; increases to be compared against the cursor

.middle_print:
    inc r14
    mov rdi, r14
    mov rsi, r15
    call append_position

    mov r12, 32                          ; print 1 bar per loop, loop 4 times

    mov rdi, VERTICAL
    mov rsi, VERTICAL_LEN
    call append_to_frame_buffer

.bar_loop:
    cmp rbp, rbx                        ; is the cursor here?
    jz .draw_sequencer_cursor

    mov rax, rbp
    and rax, 31
    cmp rax, [playhead]
    jz .draw_playhead
    ; TODO fix logic, currently broken


.continue_0:

    mov rdi, r13
    mov rsi, 1                          ; print 1 char
    call append_to_frame_buffer

.continue_1:
    inc r13                             ; put cursor 1 ahead
    inc rbp
    mov rax, rbp
    and rax, 7                          ; easy mod 8 operation
    jz .add_vertical_separator

.continue_2:


    dec r12                             ; looped through the state
    jnz .bar_loop

    ; mov rdi, VERTICAL
    ; mov rsi, VERTICAL_LEN
    ; call append_to_frame_buffer

    dec r11
    jnz .middle_print

    inc r14
    mov rdi, r14
    mov rsi, r15
    call append_position

    mov rdi, BOT_BORDER
    mov rsi, BOT_BORDER_LEN
    call append_to_frame_buffer

    pop r15
    pop r14
    pop r13
    pop r12
    pop rbp
    pop rbx

    ret

.add_vertical_separator:
    mov rdi, VERTICAL
    mov rsi, VERTICAL_LEN
    call append_to_frame_buffer

    jmp .continue_2

.draw_sequencer_cursor:
    mov rdi, SEQUENCER_CURSOR_HIGHLIGHT_START
    mov rsi, SEQUENCER_CURSOR_HIGHLIGHT_START_LEN
    call append_to_frame_buffer

    mov rdi, r13
    mov rsi, 1                          ; print 1 char
    call append_to_frame_buffer

    mov rdi, RESET_TXT
    mov rsi, RESET_TXT_LEN
    call append_to_frame_buffer

    jmp .continue_1

.draw_playhead:

    movzx rax, byte [playing]
    test rax, rax
    jz .continue_0

    mov rdi, PLAYER_HIGHLIGHT_START
    mov rsi, PLAYER_HIGHLIGHT_START_LEN
    call append_to_frame_buffer

    mov rdi, r13
    mov rsi, 1                          ; print 1 char
    call append_to_frame_buffer

    mov rdi, RESET_TXT
    mov rsi, RESET_TXT_LEN
    call append_to_frame_buffer

    jmp .continue_1