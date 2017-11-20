STACK	SEGMENT STACK
		DB 256 DUP(?)
TOP		LABEL WORD
STACK	ENDS
DATA		SEGMENT
TABLE	DW L1, L2, L3, L4, L5
STRING1	DB '1. Change string;', 0DH, 0AH, '$'
STRING2	DB '2. Find the maximum ;', 0DH, 0AH, '$'
STRING3	DB '3. Rank;', 0DH, 0AH, '$'
STRING4	DB '4. Time;', 0DH, 0AH, '$'
STRING5	DB '5. Exit.', 0DH, 0AH, '$'
STRINGN	DB 'Input the number 1-5 : $'
STRBUF	DB 'Input the string:', 0DH, 0AH, '$'
MAXCHR	DB 'The maximum is $'
NUMBER	DB 'Input the numbers: ', 0DH, 0AH, '$'
TIMES	DB 'Correct the time (HH:MM:SS) : $'
STRBUF2	DB 'Press ESC to exit; or press any key to continue$'
KEYBUF	DB 61
			DB ?
			DB 61 DUP (?)
NUMBUF	DB ?
			DB 20 DUP (?)
DATA		ENDS
CODE	SEGMENT
		ASSUME CS:CODE, DS:DATA, SS:STACK
START:
		MOV AX, DATA
		MOV DS, AX
		MOV AX, STACK
		MOV SS, AX
		LEA SP, TOP
MAIN:	CALL FAR PTR MENU		
AGAIN:
		MOV AH, 2
		MOV BH, 0				
		MOV DL, 41				
		MOV DH, 10				
		INT 10H					
		MOV AH, 1
		INT 21H
		CMP AL, '1'
		JB AGAIN
		CMP AL, '5'
		JA  AGAIN
		SUB AL, '1'				
		SHL AL, 1				
		CBW					
		LEA BX, TABLE
		ADD BX, AX
		JMP WORD PTR [BX]
L1:
		CALL FAR PTR CHGLTR
		MOV AH, 8
		INT 21H
		CMP AL, 1BH
		JZ MAIN
		JMP L1
L2:
		CALL FAR PTR MAXLTR
		MOV AH, 8
		INT 21H
		CMP AL, 1BH
		JZ MAIN
		JMP L2
L3:
		CALL FAR PTR SORTNUM
		MOV AH, 8
		INT 21H
		CMP AL, 1BH
		JZ MAIN
		JMP L3
L4:
		CALL FAR PTR TIMCHK
		MOV AH, 8
		INT 21H
		CMP AL, 1BH
	    JZ MAIN
		JMP L4
L5:
		MOV AH, 4CH
		INT 21H

MENU	PROC FAR			;设置显示器方式
		MOV AH, 0
		MOV AL, 3;
		MOV BL, 0;
		INT 10H					
		MOV AH, 2
		MOV BH, 0				
		MOV DL, 5				
		MOV DH, 5				
		INT 10H					
		MOV AH, 9
		LEA DX, STRING1
		INT 21H
		MOV AH, 2
		MOV DL, 5				
		MOV DH, 6				
		INT 10H					
		MOV AH, 9
		LEA DX, STRING2
		INT 21H
		MOV AH, 2
		MOV DL, 5				
		MOV DH, 7				
		INT 10H					
		MOV AH, 9
		LEA DX, STRING3
		INT 21H
		MOV AH, 2
		MOV DL, 5				
		MOV DH, 8				
		INT 10H					
		MOV AH, 9
		LEA DX, STRING4
		INT 21H
		MOV AH, 2
		MOV DL, 5				
		MOV DH, 9				
		INT 10H					
		MOV AH, 9
		LEA DX, STRING5
		INT 21H
		MOV AH, 2
		MOV DL, 5				
		MOV DH, 10				
		INT 10H					
		MOV AH, 9
		LEA DX, STRINGN
		INT 21H
		RET
MENU	ENDP
CHGLTR		PROC FAR			
RECHG:
		                               
		MOV AH, 0
		MOV AL, 3
		MOV BL, 0
		INT 10H					
		MOV AH, 2
		MOV BH, 0				
		MOV DL, 5				
		MOV DH, 5				
		INT 10H					
		MOV AH, 9
		LEA DX, STRBUF
		INT 21H					; 输入字符串提示
		MOV AH, 2
		MOV DL, 5				
		MOV DH, 6			
		INT 10H					
		MOV AH, 0AH
		LEA DX, KEYBUF
		INT 21H					; 输入字符串
		CMP KEYBUF + 1, 0
		JZ RECHG 				; 判断输入字符串是否为空串
		LEA BX, KEYBUF + 2
		MOV AL, KEYBUF + 1
		CBW
		MOV CX, AX
		ADD BX, AX
		MOV BYTE PTR [BX], '$'	             ; 在输入字符串尾加结束标志$
		MOV AH, 2
		MOV BH, 0				
		MOV DL, 5				
		MOV DH, 7				
		INT 10H				
		LEA BX, KEYBUF + 2
LCHG:
		CMP BYTE PTR [BX], 61H
		JB NOCHG
		AND BYTE PTR [BX], 0DFH
NOCHG:	
		INC BX
		LOOP LCHG				; 将字符串中小写字母转换成大写字母
						
		MOV AH, 9
		LEA DX, KEYBUF + 2
		INT 21H					; 输出新字符串
		MOV AH, 2
		MOV BH, 0				
		MOV DL, 5				
		MOV DH, 9				
		INT 10H					
		MOV AH, 9
		LEA DX, STRBUF2
		INT 21H					; 输出提示信息
		RET
CHGLTR		ENDP
MAXLTR	PROC FAR			       ; 在输入字符串中找出最大值
REMAX:
		;设置显示器方式
		MOV AH, 0
		MOV AL, 3
		MOV BL, 0
		INT 10H					
		MOV AH, 2
		MOV BH, 0				
		MOV DL, 5				
		MOV DH, 5				
		INT 10H					
		MOV AH, 9
		LEA DX, STRBUF
		INT 21H					; 输入字符串提示
		MOV AH, 2
		MOV DL, 5				
		MOV DH, 6				
		INT 10H					
		MOV AH, 0AH
		LEA DX, KEYBUF
		INT 21H					; 输入字符串
		CMP KEYBUF + 1, 0
		JZ REMAX				; 判断输入字符串是否为空串
		LEA BX, KEYBUF + 2
		MOV AL, KEYBUF + 1
		CBW
		MOV CX, AX
		ADD BX, AX
		MOV BYTE PTR [BX], '$'	               ; 在输入字符串位加结束标志$
		MOV AH, 2
		MOV BH, 0				
		MOV DL, 5				
		MOV DH, 7				
		INT 10H						
						
		MOV AH, 2
		MOV BH, 0				
		MOV DL, 5				
		MOV DH, 8				
		INT 10H					
		MOV AH, 9
		LEA DX, MAXCHR
		INT 21H					; 输出字符串中最大值提示
		MOV DL, 0
		LEA BX, KEYBUF + 2
LCMP:
		CMP [BX], DL
		JB NOLCHG
		MOV DL, [BX]
NOLCHG:
		INC BX
		LOOP LCMP				; 找出字符串中最大字符，放入DL
		MOV AH, 2
		INT 21H					; 输出字符串中最大字符
		MOV AH, 2
		MOV BH, 0				
		MOV DL, 5				
		MOV DH, 9				
		INT 10H					
		MOV AH, 9
		LEA DX, STRBUF2
		INT 21H					; 输出提示信息
		RET
MAXLTR	ENDP
SORTNUM	PROC FAR			            ; 对输入数据组排序
RESORT:
		;设置显示器方式
		MOV AH, 0
		MOV AL, 3
		MOV BL, 0
		INT 10H					
		MOV AH, 2
		MOV BH, 0				
		MOV DL, 5				
		MOV DH, 5				
		INT 10H					
		MOV AH, 9
		LEA DX, NUMBER
		INT 21H
		MOV AH, 2
		MOV DL, 5				
		MOV DH, 6				
		INT 10H					
		MOV AH, 0AH
		LEA DX, KEYBUF
		INT 21H					; 输入数据组字符串
		CALL CIN_INT			; 字符串转换成数据串
		CMP AL, 0
		JZ RESORT				; 判断数据串是否有错
		CMP NUMBUF, 0
		JZ RESORT				; 判断数据串是否为空


		
		MOV AH, 2
		MOV BH, 0				
		MOV DL, 5				
		MOV DH, 8				
		INT 10H					
		CALL FAR PTR MPSORT               	; 数据组排序
		CALL FAR PTR INT_OUT	                ; 数据组的输出
		MOV AH, 2
		MOV BH, 0				
		MOV DL, 5				
		MOV DH, 9				
		INT 10H					
		MOV AH, 9
		LEA DX, STRBUF2
		INT 21H					; 输出提示信息
		RET
SORTNUM	ENDP
CIN_INT	PROC NEAR				        ; 读入整型数
		MOV CL, KEYBUF + 1
		LEA SI, KEYBUF + 2
		MOV CH, 0				; 数据组数据个数置0
		MOV DH, 10
		MOV AL, 0				; 当前数据x=0
		MOV DL, 0				; 有无数据标志置0，即无数据
FNDNUM:
		CMP BYTE PTR [SI], ' '
		JZ ADDNUM				; 判断当前字符是否为空格
		CMP BYTE PTR [SI], '0'
		JB ERRNUM
		CMP BYTE PTR [SI], '9'
		JA ERRNUM				; 判断当前字符是否在'0'-'9'之间
		MOV DL, 1				; 有无数据标志置1，即有数据
		MUL DH

		XOR BH, BH
		MOV BL, [SI]
		ADD AX, BX
		SUB AX, '0'				; 计算出当前数据x
		CMP AH, 0
		JA ERRNUM				; 判断x是否越界
		JMP NEXT
ADDNUM:
		CMP DL, 1
		JNZ NEXT				; 判断是否有数据
		INC CH					; 数据组数据个数加1
		CALL ADDNEW
		MOV DL, 0
		MOV AL, 0				; 清零
NEXT:
		INC SI
		DEC CL
		CMP CL, 0
		JNZ FNDNUM			      ; 依次检查各字符
		CMP DL, 1
		JNZ TOTAL				; 判断是否有未加入的数据
		INC CH
		CALL ADDNEW
TOTAL:
		MOV NUMBUF, CH		              ; 置数据组数据个数
		MOV AL, 1				; 输入数据无错误
		JMP CRTNUM
ERRNUM:
		MOV AL, 0				; 输入数据有错误
CRTNUM:
		RET 
CIN_INT ENDP
ADDNEW	PROC NEAR			                 ; 增加新数
		PUSH AX
		LEA BX, NUMBUF
		MOV AL, CH
		CBW
		ADD BX, AX
		POP AX
		MOV [BX], AL
		RET
ADDNEW		ENDP
MPSORT		PROC FAR			       ; 数据组排序
		MOV AL, NUMBUF
		CMP AL, 1
		JBE NOSORT				; 若只有一个元素，停止排序
		CBW
		MOV CX, AX
		LEA SI, NUMBUF			         ; SI指向数据组首地址
		ADD SI, CX				; SI指向数据组末地址
		DEC CX					; 外循环次数
LP1:								; 外循环开始
		PUSH CX
		PUSH SI
		MOV DL, 0				; 交换标志置0
LP2:								; 内循环开始
		MOV AL, [SI]
		CMP AL, [SI - 1]
		JAE NOXCHG
		XCHG AL, [SI - 1]			; 交换操作
		MOV [SI], AL
		MOV DL, 1				; 交换标志置1
NOXCHG:
		DEC SI
		LOOP LP2
		POP SI
		POP CX
		CMP DL, 1
		JNZ NOSORT				; 判断交换标志
		LOOP LP1
NOSORT:RET
MPSORT	ENDP
INT_OUT	PROC FAR			               ; 输出数据组
		MOV AL, NUMBUF
		CBW
		MOV CX, AX
		MOV BL, 10H
		LEA SI, NUMBUF + 1
PRINT:
		MOV AL, [SI]
		CALL OUTNUM
		INC SI
		MOV AH, 2
		MOV DL, ' '
		INT 21H
		LOOP PRINT
		RET
INT_OUT ENDP
OUTNUM	PROC NEAR			                  ; 将十进制数以十六进制输出
                                                         
		MOV AH, 0
		DIV BL
		PUSH AX
		CMP AH, 10
		JB PNUM
		ADD AH, 7
PNUM:		ADD AH, 30H
		MOV DL, AH
		POP AX
		PUSH DX
		CMP AL, 0
		JZ OUTN
		CALL OUTNUM
OUTN:
		POP DX
		MOV AH, 2
		INT 21H
		RET
OUTNUM	ENDP
TIMCHK		PROC FAR				; 设定并显示时间
		;设置显示器方式
		MOV AH, 0
		MOV AL, 3;
		MOV BL, 0;
		INT 10H					
		MOV AH, 2
		MOV BH, 0				
		MOV DL, 5				
		MOV DH, 6				
		INT 10H					
		MOV AH, 9
		LEA DX, TIMES
		INT 21H					; 时间串提示
		MOV AH, 0AH
		LEA DX, KEYBUF
		INT 21H					; 输入时间串


		MOV BL, 10
		MOV AL, KEYBUF + 2
		SUB AL, '0'
		MUL BL
		ADD AL, KEYBUF + 3
		SUB AL, '0'
		CMP AL, 0
		JB INVALID
		CMP AL, 24
		JAE INVALID			; 判断 时 有效性
		MOV CH, AL
		MOV AL, KEYBUF + 5
		SUB AL, '0'
		MUL BL
		ADD AL, KEYBUF + 6
		SUB AL, '0'
		CMP AL, 0
		JB INVALID
		CMP AL, 60
		JAE INVALID			; 判断 分 有效性
		MOV CL, AL
		MOV AL, KEYBUF + 8
		SUB AL, '0'
		MUL BL
		ADD AL, KEYBUF + 9
		SUB AL, '0'
		CMP AL, 0
		JB INVALID
		CMP AL, 60
		JAE INVALID			; 判断 秒 有效性
		MOV DH, AL
		MOV DL, 0
		MOV AH, 2DH
		INT 21H					; 置系统时间
INVALID:
		CALL TIME
		RET
TIMCHK		ENDP
TIME	PROC					; 显示时间子程序
		;设置显示器方式
		MOV AH, 0
		MOV AL, 3;
		MOV BL, 0;
		INT 10H					
		MOV AH, 2
		MOV BH, 0				
		MOV DL, 10				
		MOV DH, 9				
		INT 10H					
		MOV AH, 9
		LEA DX, STRBUF2
		INT 21H					; 输出提示信息
DISP1:
		MOV AH, 2
		MOV BH, 0				
		MOV DL, 72				
		MOV DH, 0				
		INT 10H					; 提示光标位置设置
		MOV AH, 2CH			; 取系统时间,CH,CL,DH分别存放时/分/秒
		INT 21H
		MOV AL, CH				; 显示 时
		CALL SHOWNUM
		MOV AH, 2
		MOV DL, ':'
		INT 21H
		MOV AL, CL				; 显示 分
		CALL SHOWNUM
		MOV AH, 2
		MOV DL, ':'
		INT 21H
		MOV AL, DH				; 显示 : 秒
		CALL SHOWNUM
		MOV AH,02H				
		MOV DX,090AH
		MOV BH,0
		INT 10H
		MOV BX,0018H
RE:		MOV CX,0FFFFH			; 延时
REA:	LOOP REA
		DEC BX
		JNZ RE
		MOV AH, 0BH			
		INT 21H					
		CMP AL, 0					
		JZ DISP1					; 检查键盘状态
		RET
TIME	ENDP

SHOWNUM PROC				; 把AL中的数字以十进制输出
                                     
		CBW
		PUSH CX
		PUSH DX
		MOV CL, 10
		DIV CL
		ADD AH, '0'
		MOV BH, AH
		ADD AL, '0'
		MOV AH, 2
		MOV DL, AL
		INT 21H
		MOV DL, BH
		INT 21H
		POP DX
		POP CX
		RET
SHOWNUM ENDP
CODE	ENDS
		END	START
