redfire macro p1, p2
    mov ah,0ch
    mov al,04

    mov si,p1
    mov para1, si
    mov si,p2
    mov para2, si

    mov cx, para2
    sub cx, 21
    mov dx, para1
    sub dx, 6
    push count
    push count2
    push bx
    mov bx, 3
    mov count, 0
    mov count2, 0
    .repeat
    .repeat
    int 10h
    inc cx
    inc count2

    .until(count2==bx)
    inc count
    mov count2, 0
    mov cx, para2
    sub cx, 21
    inc dx
    .until(count==bx)

    pop bx
    pop count2
    pop count

endm

blackfire macro p1, p2
    mov ah,0ch
    mov al,00
   
    mov si,p1
    mov para1, si
    mov si,p2
    mov para2, si
    ;creating the boundary of the candy 

    mov cx, para2
    sub cx, 21
    mov dx, para1
    sub dx, 6
    push count
    push count2
    push bx
    mov bx, 3
    mov count, 0
    mov count2, 0
    .repeat
    .repeat
    int 10h
    inc cx
    inc count2

    .until(count2==bx)
    inc count
    mov count2, 0
    mov cx, para2
    sub cx, 21
    inc dx
    .until(count==bx)

    pop bx
    pop count2
    pop count

endm

Draw MACRO to_draw,start_X,start_Y,pixels,page_No
    PUSHA
    ;printString gameName
    mov si,to_draw
    mov bx,start_X
    mov var_1,bx
    mov cx,var_1


    mov ax,start_Y
    mov var_2,ax

    add bx,pixels
    add ax,pixels
    
    .WHILE ( var_2 <= ax )

        MOV var_1, CX
         drawPixel var_1, var_2 , page_No , [si]

        .WHILE ( var_1 < bx )
                drawPixel var_1, var_2 , page_No , [si]

                INC var_1
                INC si
        .ENDW
        drawPixel var_1, var_2 , page_No , [si]
        INC var_2
    .ENDW

    POPA

ENDM

drawpixel MACRO var_1,var_2,page_No,color
    PUSHA
    mov ah,0ch
    mov al,color
    mov bh,page_No
    mov cx, var_1
    mov dx, var_2
    int 10h
    POPA
endm

createpixel MACRO var_1,var_2,color
PUSHA
    mov ah,0ch
    mov al,color
    mov cx, var_1
    mov dx, var_2
    int 10h
    POPA
endm

EmptyScreen MACRO ;Clearing the screen 
    mov ax,0600h  ;al=0 => Clear
    mov bh,07     ;bh=07 => Normal Attributes              
    mov cx,0      ;From (cl=column, ch=row)
    mov dl,80     ;To dl=column
    mov dh,25     ;To dh=row
    int 10h    
    
    ;Moving the cursor to the beginning of the screen 
    mov ax,0
    mov ah,2
    mov dx,0
    int 10h     
ENDM EmptyScreen


delay macro number
	pushA
	mov cx,1000
	.repeat
		mov bx,number      ;; increase this number if you want to add more delay, and decrease this number if you want to reduce delay.
		.repeat
			dec bx
		.until(bx==0)
	dec cx
	.until(cx==0)
	popA
endm
;createshooter macro var_1,var_2,color
;endm

printblackrocekt macro to_draw,start_X,start_Y,pixels,page_No

    Draw OFFSET to_draw,start_X,start_Y,pixels,page_No

endm

.model small
.stack 120h
.data 
p1 dw ?
p2 dw ?
 
para1 dw ?
para2 dw ?
count dw ?
count2 dw ?

y_ax dw ?
x_ax dw ?

x dw ?
y dw ?
bullet dw 4
var_1 dw ?
var_2 dw ?
start_X db ?
start_y db ?
pixels db ?
color db ?
scoring db ?
score db 'Score : '
bullets_left db  "Bullets:"
bullets dw 4

.code
    mov ax, @data
    mov ds, ax
main proc
    mov ah, 0
    mov al, 13h
    int 10h	

    ;redfire 50,50
    ;code to display the side boundaries
    mov var_2, 5
    
    lo1:
        createpixel 10,var_2,04
        inc var_2
        .if var_2 == 206
        jmp loab
        .endif
    loop lo1
    
    loab:
    
    mov var_2,5 

    .WHILE (var_2 != 206)
        createpixel 310,var_2,04
        add var_2,1
    .ENDW

     mov var_1,10
     .WHILE (var_1 != 311)
        createpixel var_1,3,04
        add var_1,1
    .ENDW

    mov var_1,10
     .WHILE (var_1 != 311)
        createpixel var_1,199,04
        add var_1,1
    .ENDW

     ;redfire 150,250
     ;blackfire 150,250
                ;y,x


    Draw OFFSET spaceship,330,580,25,00h
;    Draw OFFSET tempshape,330,580,30,00h

    Draw OFFSET alien1,310, 210,25,00h    
    Draw OFFSET alien1,20, 210,25,00h
    Draw OFFSET alien1,50, 210,25,00h
    Draw OFFSET alien1,80, 210,25,00h
    Draw OFFSET alien1,110,210,25,00h
    Draw OFFSET alien1,140,210,25,00h
    Draw OFFSET alien1,170,210,25,00h

       
        
    ;x 10 x 628
        mov ah, 00h
        int 16h
        mov x, 330
        mov y,210
        ; mov y,210
		; 	.REPEAT
        ;         Draw OFFSET blackalien,310, 210,25,00h 
        ;         Draw OFFSET blackalien,20,  210,25,00h
        ;         Draw OFFSET blackalien,50,  210,25,00h
        ;         Draw OFFSET blackalien,80,  210,25,00h
        ;         Draw OFFSET blackalien,110, 210,25,00h
        ;         Draw OFFSET blackalien,140, 210,25,00h
        ;         Draw OFFSET blackalien,170, 210,25,00h   
        ;         add y,1
        ;         delay 150
        ;         Draw OFFSET alien1,310, y,25,00h    
        ;         Draw OFFSET alien1,20,  y,25,00h
        ;         Draw OFFSET alien1,50,  y,25,00h
        ;         Draw OFFSET alien1,80,  y,25,00h
        ;         Draw OFFSET alien1,110, y,25,00h
        ;         Draw OFFSET alien1,140, y,25,00h
        ;         Draw OFFSET alien1,170, y,25,00h
        ;     .UNTIL (y==350)

        left2:
        .while (ah==4dh)
        l1:
            printblackrocekt OFFSET blackspaceship,x,580,25,00h
            add x, 6
            Draw OFFSET spaceship,x,580,25,00h
            mov dx,y
         	.if(y==dx)
                 Draw OFFSET blackalien,310, 210,25,00h 
                 Draw OFFSET blackalien,20,  210,25,00h
                 Draw OFFSET blackalien,50,  210,25,00h
                 Draw OFFSET blackalien,80,  210,25,00h
                 Draw OFFSET blackalien,110, 210,25,00h
                 Draw OFFSET blackalien,140, 210,25,00h
                 Draw OFFSET blackalien,170, 210,25,00h   
                 add y,1
                 delay 150
                 Draw OFFSET alien1,310, y,25,00h    
                 Draw OFFSET alien1,20,  y,25,00h
                 Draw OFFSET alien1,50,  y,25,00h
                 Draw OFFSET alien1,80,  y,25,00h
                 Draw OFFSET alien1,110, y,25,00h
                 Draw OFFSET alien1,140, y,25,00h
                 Draw OFFSET alien1,170, y,25,00h
                    mov dx,y
                    add dx,1
                    .if(y==550)
                    EmptyScreen
                    .endif
             .endif     

             
        mov ah, 00h
        int 16h
        cmp ah,57
        je shotup
        cmp ah,4dh
        je l1
        jmp left
        .endw
        
        left:
        .while (ah==4Bh)
        l2:
            printblackrocekt OFFSET blackspaceship,x,580,25,00h
            sub x, 6
            Draw OFFSET spaceship,x,580,25,00h
            mov dx,y
            .if(y==dx)
                 Draw OFFSET blackalien,310, 210,25,00h 
                 Draw OFFSET blackalien,20,  210,25,00h
                 Draw OFFSET blackalien,50,  210,25,00h
                 Draw OFFSET blackalien,80,  210,25,00h
                 Draw OFFSET blackalien,110, 210,25,00h
                 Draw OFFSET blackalien,140, 210,25,00h
                 Draw OFFSET blackalien,170, 210,25,00h   
                 add y,1
                 delay 150
                 Draw OFFSET alien1,310, y,25,00h    
                 Draw OFFSET alien1,20,  y,25,00h
                 Draw OFFSET alien1,50,  y,25,00h
                 Draw OFFSET alien1,80,  y,25,00h
                 Draw OFFSET alien1,110, y,25,00h
                 Draw OFFSET alien1,140, y,25,00h
                 Draw OFFSET alien1,170, y,25,00h
                    mov dx,y
                    add dx,1
                    .if(y==550)
                    EmptyScreen
                    .endif
             .endif     
        mov ah, 00h
        int 16h
        cmp ah,57
        je shotup
        cmp ah,4Bh
        je l2
        jmp left2
        .endw

        shotup:
        .while(ah==57)
            mov y,570
            mov ax,y
            mov p1,ax
            add x,38
            mov bx,x
            mov p2,bx

            .REPEAT
              redfire p1,p2
            delay
            blackfire p1,p2
            sub p1,1
			
			;The alien one shot and disapper the alien
			.if(p1==450 && (p2>210 || p2<310)) ;p1 is y coordinate and p2 is x coordinate
				 Draw OFFSET alien1,310,210,25,00h 
                 Draw OFFSET blackalien,310,210,25,00h 
                 inc score
             .endif
			 
			 ;The alien two shot and disapper the alien
			 .if(p1==510 &&(p2>310 || p2<40))
				Draw OFFSET alien1,20,210,25,00h
				Draw OFFSET blackalien,20,210,25,00h
				inc score
			.endif
			
			;The alien three shot and disappear the alien
			.if(p1==530 && (p2>500|| p2<10))
			Draw OFFSET alien1,50,210,25,00h
			Draw OFFSET blackalien,50,210,25,00h
			inc score
			.endif
			;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
			;The alien four shot and disappear the alien
			.if(p1==530 && (p2>380|| p2<280))
		    Draw OFFSET alien1,80,210,25,00h
			Draw OFFSET blackalien,80,210,25,00h
			inc score
			.endif
		
			;The alien five shot and disappear the alien
			.if(p1==560 && (p2>400|| p2<300))
		    Draw OFFSET alien1,110,210,25,00h
			Draw OFFSET blackalien,110, 210,25,00h
			inc score
			.endif
			  
			;The alien six shot and disappear the alien
			.if(p1==565 && (p2>450|| p2<300))
		    Draw OFFSET alien1,140,210,25,00h
			Draw OFFSET blackalien,140, 210,25,00h
			inc score
			.endif
			

			;The alien seven shot and disappear the alien
			.if(p1==540 && (p2>500|| p2<300))
		   Draw OFFSET alien1,170,210,25,00h
			Draw OFFSET blackalien,170, 210,25,00h
			inc score
			.endif

            .UNTIL (p1==450)             

            mov ah, 00h
            int 16h
            cmp ah,4Bh
            je left 

            cmp ah,4dh
            je left2
        
            cmp ah,57
            je shotup
        .endw
     

    goaway:

    exit:
        mov ah,4ch
        int 21h
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;alien and spaceship shapesss
tempshape:
        DB 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h     ;  0
        DB 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h     ;  1
        DB 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,08h,07h,07h,08h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h     ;  2
        DB 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h     ;  3
        DB 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h     ;  4
        DB 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,08h,08h,08h,08h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h     ;  5
        DB 00h,00h,00h,00h,00h,00h,00h,00h,08h,0Fh,00h,00h,08h,07h,07h,07h,07h,08h,00h,00h,0Fh,08h,00h,00h,00h,00h,00h,00h,00h,00h     ;  6
        DB 00h,00h,00h,00h,00h,00h,00h,00h,07h,0Fh,08h,00h,07h,07h,07h,07h,07h,07h,00h,08h,0Fh,07h,00h,00h,00h,00h,00h,00h,00h,00h     ;  7
        DB 00h,00h,00h,00h,00h,00h,00h,08h,0Fh,0Fh,07h,00h,02h,08h,07h,07h,08h,02h,00h,07h,0Fh,0Fh,08h,00h,00h,00h,00h,00h,00h,00h     ;  8
        DB 00h,00h,00h,00h,00h,00h,00h,03h,0Fh,0Fh,07h,00h,08h,00h,08h,08h,00h,08h,00h,07h,0Fh,0Fh,03h,00h,00h,00h,00h,00h,00h,00h     ;  9
        DB 00h,00h,00h,00h,08h,08h,08h,00h,00h,08h,07h,00h,08h,07h,07h,07h,07h,08h,00h,07h,08h,00h,00h,08h,08h,08h,00h,00h,00h,00h     ; 10
        DB 00h,00h,04h,08h,08h,08h,08h,07h,08h,00h,00h,00h,00h,08h,08h,08h,08h,00h,00h,00h,00h,08h,07h,08h,08h,08h,08h,04h,00h,00h     ; 11
        DB 00h,04h,08h,08h,08h,00h,00h,00h,08h,08h,08h,08h,06h,00h,00h,00h,00h,06h,08h,08h,08h,08h,00h,00h,00h,08h,08h,08h,04h,00h     ; 12
        DB 00h,08h,08h,08h,00h,03h,07h,00h,06h,08h,08h,08h,08h,07h,08h,08h,07h,08h,08h,08h,08h,06h,00h,07h,03h,00h,08h,08h,08h,00h     ; 13
        DB 00h,08h,08h,08h,00h,08h,0Fh,08h,00h,07h,08h,08h,08h,00h,00h,00h,00h,08h,08h,08h,07h,00h,08h,0Fh,08h,00h,08h,08h,08h,00h     ; 14
        DB 00h,00h,08h,07h,08h,00h,00h,00h,08h,08h,08h,08h,08h,00h,0Fh,0Fh,00h,08h,08h,08h,08h,08h,00h,00h,00h,08h,07h,08h,00h,00h     ; 15
        DB 00h,00h,00h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,00h,07h,07h,00h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,00h,00h,00h     ; 16
        DB 00h,00h,00h,00h,00h,08h,08h,08h,08h,08h,08h,08h,08h,08h,00h,00h,08h,08h,08h,08h,08h,08h,08h,08h,08h,00h,00h,00h,00h,00h     ; 17
        DB 00h,00h,00h,00h,00h,00h,00h,00h,04h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,04h,00h,00h,00h,00h,00h,00h,00h,00h     ; 18
        DB 00h,00h,00h,00h,00h,00h,00h,08h,08h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,08h,08h,00h,00h,00h,00h,00h,00h,00h     ; 19
        DB 00h,00h,00h,00h,00h,00h,00h,0Fh,0Fh,0Fh,07h,07h,07h,07h,08h,08h,07h,07h,07h,07h,0Fh,0Fh,0Fh,00h,00h,00h,00h,00h,00h,00h     ; 20
        DB 00h,00h,00h,00h,00h,00h,07h,07h,07h,07h,07h,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,07h,07h,07h,07h,07h,00h,00h,00h,00h,00h,00h     ; 21
        DB 00h,00h,00h,00h,00h,08h,0Fh,07h,0Fh,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,0Fh,07h,0Fh,08h,00h,00h,00h,00h,00h     ; 22
        DB 00h,00h,00h,00h,08h,07h,07h,07h,08h,07h,08h,08h,07h,00h,07h,08h,02h,07h,00h,08h,07h,03h,07h,07h,07h,08h,00h,00h,00h,00h     ; 23
        DB 00h,00h,00h,00h,07h,00h,08h,07h,08h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,08h,07h,08h,08h,07h,00h,00h,00h,00h     ; 24
        DB 00h,00h,00h,00h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,00h,00h,00h,00h     ; 25
        DB 00h,00h,00h,00h,08h,08h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,08h,08h,00h,00h,00h,00h     ; 26
        DB 00h,00h,00h,00h,00h,00h,00h,02h,08h,08h,08h,07h,07h,07h,07h,07h,07h,07h,07h,08h,08h,08h,02h,00h,00h,00h,00h,00h,00h,00h     ; 27
        DB 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h     ; 28
        DB 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h     ; 29
blackalien:
        DB 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h     ;  0
        DB 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h     ;  1
        DB 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h     ;  2
        DB 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h     ;  3
        DB 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h     ;  4
        DB 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h     ;  5
        DB 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h     ;  6
        DB 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h     ;  7
        DB 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h     ;  8
        DB 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h     ;  9
        DB 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h     ; 10
        DB 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h     ; 11
        DB 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h     ; 12
        DB 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h     ; 13
        DB 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h     ; 14
        DB 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h     ; 15
        DB 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h     ; 16
        DB 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h     ; 17
        DB 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h     ; 18
        DB 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h     ; 19
        DB 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h     ; 20
        DB 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h     ; 21
        DB 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h     ; 22
        DB 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h     ; 23
        DB 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h     ; 24
alien1:
        DB 00h,00h,00h,00h,00h,00h,00h,0Ch,0Ch,00h,00h,00h,00h,00h,00h,0Ch,0Ch,00h,00h,00h,00h,00h,00h,00h,00h     ;  0
        DB 00h,00h,00h,00h,00h,0Ch,0Ch,0Ch,00h,00h,06h,00h,00h,0Ch,00h,00h,0Ch,0Ch,00h,00h,00h,00h,00h,00h,00h     ;  1
        DB 00h,00h,00h,00h,00h,0Ch,0Ch,0Fh,0Fh,0Fh,04h,08h,00h,00h,0Fh,0Fh,0Fh,0Ch,0Ch,00h,00h,00h,00h,00h,00h     ;  2
        DB 00h,00h,00h,00h,04h,0Ch,0Ch,0Fh,07h,00h,00h,00h,0Ch,08h,00h,0Fh,0Fh,0Ch,0Ch,00h,00h,00h,00h,00h,00h     ;  3
        DB 00h,00h,00h,00h,00h,0Ch,0Ch,00h,0Fh,07h,0Ch,00h,0Ch,0Ch,0Fh,0Fh,04h,0Ch,0Ch,08h,00h,00h,00h,00h,00h     ;  4
        DB 00h,00h,00h,00h,00h,0Ch,0Ch,0Ch,0Ch,0Ch,04h,00h,00h,0Ch,0Ch,0Ch,0Ch,0Ch,04h,00h,00h,00h,00h,00h,00h     ;  5
        DB 00h,00h,00h,00h,00h,00h,04h,04h,04h,04h,00h,00h,00h,00h,04h,04h,04h,04h,07h,00h,00h,00h,00h,00h,00h     ;  6
        DB 00h,00h,00h,00h,00h,00h,00h,04h,00h,00h,00h,00h,00h,00h,00h,00h,04h,0Ch,00h,00h,00h,00h,00h,00h,00h     ;  7
        DB 00h,00h,00h,00h,00h,00h,07h,0Ch,04h,00h,00h,00h,00h,00h,00h,00h,0Ch,0Ch,00h,00h,00h,00h,00h,00h,00h     ;  8
        DB 00h,00h,00h,00h,00h,00h,00h,0Ch,0Ch,00h,0Ch,0Ch,0Ch,0Ch,04h,07h,0Ch,0Ch,00h,00h,00h,00h,00h,00h,00h     ;  9
        DB 00h,00h,00h,00h,00h,00h,00h,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,00h,00h,00h,00h,00h,00h,00h     ; 10
        DB 00h,00h,00h,00h,00h,00h,0Ch,0Ch,0Ch,04h,0Ch,0Ch,0Ch,0Ch,0Ch,04h,0Ch,0Ch,00h,00h,00h,00h,00h,00h,00h     ; 11
        DB 00h,00h,00h,00h,00h,00h,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,00h,00h,00h,00h,00h,00h     ; 12
        DB 00h,00h,00h,00h,00h,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,07h,07h,07h,0Ch,0Ch,0Ch,06h,00h,00h,00h,00h,00h     ; 13
        DB 00h,00h,00h,00h,04h,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,07h,07h,07h,0Ch,0Ch,07h,0Ch,00h,00h,00h,00h,00h     ; 14
        DB 00h,00h,00h,00h,08h,07h,08h,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,07h,07h,07h,0Ch,0Ch,07h,08h,00h,00h,00h,00h,00h     ; 15
        DB 00h,00h,00h,00h,07h,07h,08h,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,08h,0Ch,04h,00h,00h,00h,00h     ; 16
        DB 00h,00h,00h,00h,08h,07h,0Ch,0Ch,0Ch,07h,07h,07h,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,04h,00h,00h,00h,00h     ; 17
        DB 00h,00h,00h,00h,0Ch,0Ch,07h,0Ch,0Ch,07h,07h,07h,07h,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,04h,00h,00h,00h,00h,00h     ; 18
        DB 00h,00h,00h,00h,04h,0Ch,08h,07h,0Ch,07h,07h,07h,07h,0Ch,07h,07h,0Ch,0Ch,0Ch,04h,00h,00h,00h,00h,00h     ; 19
        DB 00h,00h,00h,00h,00h,0Ch,0Ch,0Ch,0Ch,07h,07h,07h,0Ch,0Ch,08h,07h,0Ch,0Ch,04h,04h,00h,00h,00h,00h,00h     ; 20
        DB 00h,00h,00h,00h,00h,04h,0Ch,04h,0Ch,0Ch,06h,0Ch,0Ch,0Ch,0Ch,0Ch,0Ch,06h,04h,00h,00h,00h,00h,00h,00h     ; 21
        DB 00h,00h,00h,00h,00h,00h,04h,0Ch,0Ch,0Ch,00h,0Ch,0Ch,0Ch,04h,0Ch,0Ch,0Ch,04h,06h,00h,00h,00h,00h,00h     ; 22
        DB 00h,00h,00h,00h,06h,06h,00h,0Ch,0Ch,04h,00h,0Ch,04h,0Ch,06h,04h,0Ch,0Ch,00h,06h,00h,00h,00h,00h,00h     ; 23
        DB 00h,06h,06h,06h,06h,06h,08h,00h,04h,04h,0Ch,0Ch,04h,0Ch,0Ch,00h,04h,04h,00h,06h,06h,06h,06h,06h,00h     ; 24

spaceship:
        DB 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h     ;  0
        DB 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h     ;  1
        DB 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h     ;  2
        DB 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,07h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h     ;  3
        DB 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,07h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h     ;  4
        DB 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,01h,01h,09h,09h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h     ;  5
        DB 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,01h,01h,00h,08h,09h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h     ;  6
        DB 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,01h,01h,00h,07h,09h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h     ;  7
        DB 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,01h,01h,01h,09h,09h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h     ;  8
        DB 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,01h,01h,01h,09h,09h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h     ;  9
        DB 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,01h,01h,01h,09h,09h,08h,00h,00h,00h,00h,00h,00h,00h,00h,00h     ; 10
        DB 00h,00h,00h,00h,00h,00h,00h,00h,00h,01h,01h,01h,01h,09h,09h,01h,00h,00h,00h,00h,00h,00h,00h,00h,00h     ; 11
        DB 00h,00h,00h,00h,00h,00h,00h,00h,00h,01h,01h,01h,01h,09h,09h,09h,00h,00h,00h,00h,00h,00h,00h,00h,00h     ; 12
        DB 00h,00h,00h,00h,00h,00h,00h,00h,00h,09h,01h,01h,01h,09h,09h,09h,07h,00h,00h,00h,00h,00h,00h,00h,00h     ; 13
        DB 00h,00h,00h,00h,00h,00h,00h,00h,00h,09h,00h,00h,01h,08h,00h,09h,00h,00h,00h,00h,00h,00h,00h,00h,00h     ; 14
        DB 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Bh,01h,0Bh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h     ; 15
        DB 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Bh,07h,0Bh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h     ; 16
        DB 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h     ; 17
        DB 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Bh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h     ; 18
        DB 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Bh,0Bh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h     ; 19
        DB 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Bh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h     ; 20
        DB 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Bh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h     ; 21
        DB 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Bh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h     ; 22
        DB 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h     ; 23
        DB 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h     ; 24

blackspaceship:
        DB 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h     ;  0
        DB 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h     ;  1
        DB 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h     ;  2
        DB 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h     ;  3
        DB 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h     ;  4
        DB 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h     ;  5
        DB 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h     ;  6
        DB 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h     ;  7
        DB 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h     ;  8
        DB 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h     ;  9
        DB 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h     ; 10
        DB 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h     ; 12
        DB 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h     ; 11
        DB 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h     ; 13
        DB 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h     ; 14
        DB 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h     ; 15
        DB 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h     ; 16
        DB 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h     ; 17
        DB 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h     ; 18
        DB 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h     ; 19
        DB 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h     ; 20
        DB 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h     ; 21
        DB 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h     ; 22
        DB 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h     ; 23
        DB 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h     ; 24
main endp
end main