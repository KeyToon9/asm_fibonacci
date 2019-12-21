;----------------------
; Fibonacci sequence
; 2019/12/21 by KeyToon
;----------------------
NUM EQU 10

DATA SEGMENT PUBLIC 'FORMAT'
    CRLF DB 0AH, 0DH, '$'
DATA ENDS

CODE SEGMENT PUBLIC 'CODE'
ASSUME cs:CODE, ds:DATA
START:
    mov ax, DATA
    mov ds, ax
    mov cx, 1
CAL:
    mov ax, cx
    call FIBO
    call PRINT
    mov dl, ' '
    mov ah, 02H
    int 21H
    inc cx
    cmp cx, NUM
    jle CAL
    
    ; 回车换行，可要可不要
    mov dx, offset CRLF
    mov ah, 09H
    int 21H
EXIT:
    mov ah, 4CH
    int 21H

;-----------
; 计算F(AX)
FIBO:
    ; if(n == 0 || n == 1 || n ==2) return 1;
    cmp ax, 0
    je _OUT
    cmp ax, 1
    je _OUT
    cmp ax, 2
    je _OUT

    ;保存上文寄存器状态
    push bx
    push cx
    push dx

    ; f(n-1)
    mov dx, ax
    sub ax, 1
    call FIBO
    mov bx, ax
    ;f(n-2)
    mov ax, dx
    sub ax, 2
    call FIBO
    mov cx, ax
    ; f(n)=f(n-1)+f(n-2)
    mov ax, bx
    add ax, cx

    pop dx
    pop cx
    pop bx

    ret
_OUT:
    mov ax, 1
    ret    

;-----------------
; 打印AX中的内容
; 其实就是数字转字符
PRINT:
    push ax
    push bx
    push cx
    push dx

    mov bx, 10
    mov cx, 0
PL1:
    xor dx, dx
    div bx
    add dl, '0'
    push dx
    inc cx
    cmp ax, 0
    jnz PL1
    mov ah, 02H
PL2:
    pop dx
    int 21H
    loop PL2

    pop dx
    pop cx
    pop bx
    pop ax

    ret    
CODE ENDS
END
