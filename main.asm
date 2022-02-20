assume cs:code,ds:data,ss:stack
stack segment
	db 128 dup(0)
stack ends
data segment
	db 0AH,0DH,"Welcome to VLSMB's 16-bit DOS Programe!",0AH,0DH
	db 0AH,0DH
	db 0AH,0DH
	db 'What would you want to do?(Please press "F+num" key)',0AH,0DH
	db 0AH,0DH
	db 'F1:restore default settings',0AH,0DH
	db 'F2:set font color',0AH,0DH
	db 'F3:set background color',0AH,0DH
	db 'ESC:exit the programe'
choose	db 0AH,0DH
	db 'Please enter:$'
illegal db 0AH,0DH,'Invalid Input!Press any to continue...$'
continue db 0AH,0DH,'Press any button to continue...$'
setfont db 0AH,0DH,0AH,0DH,'Please choose one color:',0AH,0DH,0AH,0DH,'R:red font',0AH,0DH,'G:green font',0AH,0DH,'B:blue font$'
setback db 0AH,0DH,0AH,0DH,'Please choose one color:',0AH,0DH,0AH,0DH,'R:red background',0AH,0DH,'G:green background',0AH,0DH,'B:blue background$'
data ends
code segment
start:	mov ax,stack
	mov ss,ax
	mov sp,128
	mov ax,data
	mov ds,ax
	mov dx,0
	mov ax,0900H
	int 21h

	mov ah,0
	int 16h
	cmp ah,01H
        je exit1
	cmp ah,3BH
        je F1_1
	cmp ah,3CH
        je F2_1
	cmp ah,3DH
        je F3_1
	mov dx,offset illegal
	mov ax,0900H
	int 21h
	mov ax,0
	int 16h
	jmp short start
exit1:  jmp near ptr exit
F1_1:   jmp near ptr F1
F2_1:   jmp near ptr F2
F3_1:   jmp near ptr F3
F1:	; clear the window
	mov ax,0b800H
	mov es,ax
	mov cx,2000
	mov si,0
s1:	mov byte ptr es:[si],0
	mov byte ptr es:[si+1],00000111B
	add si,2
	loop s1
	mov ax,0900H
	mov dx,offset continue
	int 21h
	mov ax,0
	int 16h
	jmp short start

F2:	;setfont choose
	mov ax,0900H
	mov dx,offset setfont
	int 21h
	mov ax,0900H
	mov dx,offset choose
	int 21h
	mov ax,0
	int 16h
	call fontcolor
	mov ax,0900H
	mov dx,offset continue
	int 21h
	mov ax,0
	int 16h
        jmp near ptr start
fontcolor:
	push ax
	push dx
	push cx
	push bx
	push es
	cmp ah,13H
	je redfont
	cmp ah,22H
	je greenfont
	cmp ah,30H
	je bluefont
	mov ax,0900h
	mov dx,offset illegal
	int 21h
	jmp short fontend
redfont:mov ax,0b800h
	mov es,ax
	mov bx,1
	mov cx,2000
rs:	and byte ptr es:[bx],11111100B
	add bx,2
	loop rs
	jmp short fontend
greenfont:
	mov ax,0b800h
	mov es,ax
	mov bx,1
	mov cx,2000
gs:	and byte ptr es:[bx],11111010B
	add bx,2
	loop gs
	jmp short fontend
bluefont:
	mov ax,0b800h
	mov es,ax
	mov bx,1
	mov cx,2000
bs:	and byte ptr es:[bx],11111001B
	add bx,2
	loop bs
	jmp short fontend
fontend:pop es
	pop bx
	pop cx
	pop dx
	pop ax
	ret

F3:	; set background color
	mov ax,0900H
	mov dx,offset setback
	int 21h
	mov ax,0900H
	mov dx,offset choose
	int 21h
	mov ax,0
	int 16h
	call backcolor
	mov ax,0900H
	mov dx,offset continue
	int 21h
	mov ax,0
	int 16h
	jmp near ptr start
backcolor:
	push ax
	push dx
	push cx
	push bx
	push es
	cmp ah,13H
	je redback
	cmp ah,22H
	je greenback
	cmp ah,30H
	je blueback
	mov ax,0900h
	mov dx,offset illegal
	int 21h
	jmp short backend
redback:mov ax,0b800h
	mov es,ax
	mov bx,1
	mov cx,2000
rs2:	or byte ptr es:[bx],01000000B
	add bx,2
	loop rs2
	jmp short backend
blueback:mov ax,0b800h
	mov es,ax
	mov bx,1
	mov cx,2000
bs2:	or byte ptr es:[bx],00010000B
	add bx,2
	loop bs2
	jmp short backend
greenback:mov ax,0b800h
	mov es,ax
	mov bx,1
	mov cx,2000
gs2:	or byte ptr es:[bx],00100000B
	add bx,2
	loop gs2
	jmp short backend
backend:pop es
	pop bx
	pop cx
	pop dx
	pop ax
	ret
exit:	mov ah,4ch
	int 21h
code ends
end start
