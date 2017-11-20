STACK   SEGMENT STACK 'STACK'
        DW 100H DUP(?)
TOP     LABEL WORD
STACK   ENDS
DATA    SEGMENT
BUFFER  LABEL BYTE
        X=17
        REPT 225
        X=(X+97)mod 50
        DB X
        ENDM
BUF     DB 45 DUP(?)
NUMBER  DW 6 DUP(?)
TOTAL   DB 54H,6FH,74H,61H,6CH
LETTER  DB 41H,42H,43H,44H,45H,46H
DECIMAL DB 5 DUP(?)
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
        LEA SI,BUFFER
        LEA DI,BUF
        MOV CX,45
L1:
        PUSH CX
        MOV CX,5
        XOR AX,AX
L2:
        MOV BL,[SI]
        MOV BH,0
        ADD AX,BX
        ADD AX,50
        INC SI
        LOOP L2
        POP CX
        MOV BL,5
        DIV BL
        MOV [DI],AL
        INC DI
        LOOP L1
        LEA SI,BUF
        LEA DI,NUMBER
        MOV CX,6
        MOV AX,0
L3:
        MOV [DI],AX
        INC DI
        INC DI
        LOOP L3
        MOV CX,45
        MOV BX,1
        LEA DI,NUMBER
L4:
        MOV AL,[SI]
        CMP AL,90
        JAE LA
        CMP AL,80
        JAE LB
        CMP AL,70
        JAE LC
        CMP AL,66
        JAE LD
        CMP AL,60
        JAE LM
        ADD [DI+10],BX
        JMP L5
LA:
        ADD [DI],BX
        JMP L5
LB:
        ADD [DI+2],BX
        JMP L5
LC:
        ADD [DI+4],BX
        JMP L5
LD:
        ADD [DI+6],BX
        JMP L5
LM:
        ADD [DI+8],BX
L5:
        INC SI
        LOOP L4
        LEA SI,TOTAL
        MOV CX,5
L6:
        MOV AH,02
        MOV DL,[SI]
        INT 21H
        INC SI
        LOOP L6
        CALL KONGGE
        CALL XIAOYU
        MOV AX,45
        CALL DISPAX
        CALL DAYU
        CALL DISPCR
        MOV CX,6
        LEA SI,LETTER
        LEA DI,NUMBER
L7:
        MOV AH,02
        MOV DL,[SI]
        INT 21H
        INC SI
        MOV AH,02
        MOV DL,3AH
        INT 21H
        CALL KONGGE
        CALL XIAOYU
        MOV AX,[DI]
        CALL DISPAX
        INC DI
        INC DI
        CALL DAYU
        CALL DISPCR
        LOOP L7
        MOV AH,4CH
        MOV AL,0
        INT 21H
KONGGE  PROC NEAR
        PUSH AX
        PUSH DX
        MOV AH,02
        MOV DL,20H
        INT 21H
        POP DX
        POP AX
        RET
KONGGE  ENDP
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
DISPAX  PROC NEAR
        PUSH AX
        PUSH BX
        PUSH CX
        PUSH DX
        PUSH DI
        LEA DI,DECIMAL
        CALL TRANS16TO10
        MOV CX,5
        LEA DI,DECIMAL+4
        MOV AH,2
DISPAX2:
        MOV DL,[DI]
        ADD DL,30H
        DEC DI
        INT 21H
        LOOP DISPAX2
        POP DI
        POP DX
        POP CX
        POP BX
        POP AX
        RET
DISPAX  ENDP
TRANS16TO10 PROC NEAR
        PUSH AX
        PUSH BX
        PUSH CX 
        PUSH DX
        PUSH DI
        MOV BX,10
        MOV CX,5
TRANS1:
        XOR DX,DX
        DIV BX
        MOV [DI],DL
        INC DI
        LOOP TRANS1
        POP DI
        POP DX
        POP CX
        POP BX
        POP AX
        RET
TRANS16TO10 ENDP
CODE    ENDS
        END START
