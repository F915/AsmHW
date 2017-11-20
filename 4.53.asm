STACK   SEGMENT STACK 'STACK'
        DW 100H DUP(?)
TOP     LABEL WORD
STACK   ENDS
DATA    SEGMENT
BUFFER  LABEL WORD
        X=17
        REPT 100
        X=(X+80)mod 43
        DW X
        ENDM
BUF     DW 100 DUP(?)
DATA    ENDS
CODE    SEGMENT 
        ASSUME CS:CODE,DS:DATA,ES:DATA,SS:STACK
START:
        MOV AX,DATA
        MOV DS,AX
        MOV ES,AX
        MOV AX,STACK
        MOV SS,AX
        LEA SP,TOP
        MOV CX,100
        LEA SI,BUFFER
        LEA DI,BUF
L1:
        MOV AX,[SI]
        INC SI
        INC SI
        MOV [DI],AX
        INC DI
        INC DI
        LOOP L1
        MOV CX,100
        DEC CX
        LEA SI,BUFFER
        PUSH CX
        ADD CX,CX
        ADD SI,CX
        POP CX
L2:
        PUSH CX
        PUSH SI
L3:
        MOV AX,[SI]
        CMP AX,[SI-2]
        JAE NOXCHG
        XCHG AX,[SI-2]
        MOV [SI],AX
NOXCHG:
        SUB SI,2
        LOOP L3
        POP SI
        POP CX
        LOOP L2
        MOV CX,100
        LEA SI,BUFFER
L4:
        MOV AX,[SI]
        CALL DISPAX
        ADD SI,2
        CALL XIAOYU
        CALL XUHAO
        CALL DAYU
        CALL DISPCR
        LOOP L4
        MOV AH,4CH
        MOV AL,0
        INT 21H
DISPAX  PROC NEAR
        PUSH AX
        PUSH BX
        PUSH CX
        PUSH DX
        PUSH DI
        MOV BX,10
        MOV CX,3
L7:
        XOR DX,DX
        DIV BX
        MOV [DI],DX
        INC DI
        INC DI
        LOOP L7
        MOV CX,3
L8:
        DEC DI
        DEC DI
        MOV AL,[DI]
        ADD AL,30H
        MOV AH,02
        MOV DL,AL
        INT 21H
        LOOP L8
        POP DI
        POP DX
        POP CX
        POP BX
        POP AX
        RET
DISPAX  ENDP
DISPCR  PROC NEAR
        PUSH AX
        PUSH DX
        MOV AH,2
        MOV DL,0AH
        INT 21H
        MOV AH,2
        MOV DL,0DH
        INT 21H
        POP DX
        POP AX
        RET
DISPCR  ENDP
XIAOYU  PROC NEAR
        PUSH AX
        PUSH DX
        MOV AH,02
        MOV DL,3CH
        INT 21H
        POP DX
        POP AX
        RET
XIAOYU  ENDP
XUHAO   PROC NEAR
        PUSH AX
        PUSH BX
        PUSH CX
        PUSH SI
        MOV CX,100
        MOV BX,AX
        LEA SI,BUF
L5:
        CMP BX,[SI]
        JZ  L6
        ADD SI,2
        LOOP L5
L6:
        MOV AX,101
        SUB AX,CX
        CALL DISPAX
        POP SI
        POP CX
        POP BX
        POP AX
        RET 
XUHAO   ENDP
DAYU    PROC NEAR
        PUSH AX
        PUSH DX
        MOV AH,02
        MOV DL,3EH
        INT 21H
        POP DX
        POP AX
        RET
DAYU    ENDP
CODE    ENDS
        END START
