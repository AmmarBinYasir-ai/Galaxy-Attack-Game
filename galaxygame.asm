intoDec MACRO  decimal, printableDecimal ;Converting the decimal value to the floating point 
	mov al,decimal
	xor ah,ah 
	mov cl,10 
	div cl 
	add ax,3030h
	mov printableDecimal,ax
ENDM intoDec

screenset macro srow,scol,erow,ecol,attrib ;setting the screen 
	mov ah,06h
	mov al,0h
	mov bh,attrib
	mov ch,srow
	mov cl,scol
	mov dh,erow
	mov dl,ecol
	int 10h
endm
 

onscreenpoint macro row,col ;setting the cursor through adjusting the row and column
	mov ah,02
	mov bh,0h
	mov dh,row
	mov dl,col
	int 10h
endm

textprinting macro string ;Printing the string and using it through the macros
mov ah,09h
mov dx,offset string
int 21h
endm

Print MACRO row, column, color ;printing the colors 
   push ax
   push bx
   push cx
   push dx   
   
   mov Ah,02h
   mov Bh,0h
   mov Dh,row
   mov Dl,column
   INT 10h 
   mov Ah,09
   mov Al,' '
   mov Bl,color
   mov Cx, 1h
   INT 10h   
   
   pop dx
   pop cx
   pop bx
   pop ax
ENDM Print     

PrintShooter MACRO column ;printing the shooter of the ball
   push ax
   push bx
   push cx
   push dx   
   
   mov Ah, 02h
   mov Bh, 0h
   mov Dh, 24
   mov Dl, column
   INT 10h 
   mov Ah,09
   mov Al,254 ;Arrow shape
   mov Bl,02h
   mov Cx,1h
   INT 10h   
   
   pop dx
   pop cx
   pop bx
   pop ax
ENDM PrintShooter    

PrintShot MACRO row, column ;printing the shooting ball
   push ax
   push bx
   push cx
   push dx   
   
   mov Ah,02h
   mov Bh,0h
   mov Dh,row
   mov Dl,column
   INT 10h 
   mov Ah,09
   mov Al,254
   mov Bl,0Ch
   mov Cx,1h
   INT 10h   
   
   pop dx
   pop cx
   pop bx
   pop ax
ENDM PrintShot  

PrintText Macro row,column,text ;Printing the text which is used in the menu
   push ax
   push bx
   push cx
   push dx   
   
   mov ah,2
   mov bh,0
   mov dl,column
   mov dh,row
   int 10h
   mov ah,9
   mov dx,offset text
   int 21h
   
   pop dx
   pop cx
   pop bx
   pop ax
ENDM PrintText

Delete Macro row,column ;deleting the enemies
   mov Ah,02h
   mov Bh,0h
   mov Dh,row
   mov Dl,column
   int 10h 
   mov Ah,09
   mov Al,' '
   mov Bl,0h
   mov Cx,1h
   int 10h 
ENDM Delete

Delay Macro Seconds,MilliSeconds ;Using the delay code in order to slow down the moving objects
    push ax
    push bx
    push cx
    push dx 
    push ds

    mov cx,Seconds ;The cx,dx:Thenumber of microseconds to wait
    mov dx,MilliSeconds
    mov ah, 86h
    int 15h
	
    pop ds
    pop dx
    pop cx
    pop bx
    pop ax
ENDM Delay 


ClearScreen MACRO ;Clearing the screen 
        
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
ENDM ClearScreen

.MODEL SMALL
.STACK 64    
.DATA 
;The declaration of the varaibles in the data segment
RocketColLeft db ? 										 
RocketColRight db ? 
RocketColCenter db ?

RocketRow db 15    
RocketColor db 0d0h    
ShooterCol db 40
   
ShotRow db ?
ShotCol db ?
ShotStatus db 0 ;1 means there exist a displayed shot or 0 otherwise
bullets db 6 ;there are 6 bullets which the space ship will shoot
Misses db 0
Hits db 0 ;The Score
p_name db 20,?,20 dup('$')
Askp_name db 'Input Your Good Name: ','$'
scoring db 'Score: ??','$'
bullets_left db 'Bullets: ','$'
FinalScoreString db 'Your final score is: ??','$'
RocketDirection	db 0 ;0 is for the Left, 1 is for the Right


intro db ' Welcome to the Alien Shooter Game $'	
spoint db 'The Outbreak has Affected Whole Universe$'
epoint db 'Kill the Enemies to Save your Universe $'
press db 'Press Any Key to Continue $'
ulabel db '^ $'
lrlabel db 'Controls are :         < + > $'
ready db 'Are you Ready? $'
dlabel db 'v $'
ins1   db '1.Your Bullets are Precious$'
ins2   db '	Dont Waste Them$'
ins3   db '2.In Start You Have 4 Bullets$'
ins4   db '	You Gain Bullets on Killing$'
ins5   db '3.You can Hover over the Plain$'
ins6   db '4.Keep Shooting to Win$'
ins7   db '4.Press Enter To Continue$'
ins8   db '4.Press Esc To Quit$'
over1  db 'Very Well Played$'
over2  db 'Game over But there is always a Second Try$'
over3  db '************$'


.CODE   
MAIN PROC FAR  
mov ax, @DATA
mov ds, ax  
    
  ClearScreen ;clearing the screen
  ;calling the procedures
  call StartMenu 
  ClearScreen ;clearing the screen after displaying the welcome starting screen
 ; call ResetRocket
  PrintShooter 40
  call UpdateStrings
  
  MainLoop: ;Setting the loop in order to move the shot ball postion towards the enemy
   cmp RocketDirection,1
   jz moveRocketRight
   call RocketMoveLeft
   jmp AfterRocketMove
   
   moveRocketRight:
   call RocketMoveRight
   
   AfterRocketMove:
   cmp ShotStatus,1
   jnz NoShotExist
   call CheckShotStatus ;if the shotStatus alter to 0 then move to the checkshot status
   
   cmp ShotStatus,1
   jnz NoShotExist
   call MoveShot
   PrintShooter ShooterCol ;because the shot deletes the shooter at the beginning
   
   NoShotExist: ;The shot won't exist       
   mov ah,1h
   int 16h ;ZeroFlag is 1 when a key is pressed                        
   jz NokeyPress
   call KeyisPressed
   
   NokeyPress:
   call Difficulty
   
   EndOfMainLoop:
   jmp MainLoop
   hlt
MAIN ENDP 

UpdateStrings Proc ;The procedure for displaying the hits and final score and the number of lifes  
	 push ax
	 
     intoDec Hits, ax
	 mov scoring[8], ah
	 mov FinalScoreString[22],ah
	 mov scoring[7],al
	 mov FinalScoreString[21], al
		
     mov ah,bullets
     add ah,30h
   	 mov bullets_left[7],ah
	
	PrintText 1,56,scoring
	PrintText 1,70,bullets_left	

	pop ax
	ret             
UpdateStrings ENDP 

RocketMoveLeft Proc ;The procedure of the rocket moving towards the left   
    dec RocketColLeft
    Print   RocketRow,RocketColLeft,RocketColor 
    Delete RocketRow,RocketColRight     
    dec RocketColRight  
    dec RocketColCenter
    cmp RocketColLeft,0   
    Jnz endOfRocketMoveLeft 
    call DeleteRocket
    ;call ResetRocket
    endOfRocketMoveLeft: ret              
RocketMoveLeft ENDP 


RocketMoveRight Proc ;The procedure of the rocket moving towards the right  
    inc RocketColRight
    Print RocketRow,RocketColRight,RocketColor 
    Delete RocketRow,RocketColLeft     
    inc RocketColleft 
    inc RocketColCenter
    cmp RocketColRight,80   
    Jnz endOfRocketMoveRight 
    call DeleteRocket
;    call ResetRocket
    endOfRocketMoveRight: ret              
RocketMoveRight ENDP 


KeyisPressed Proc ;The Procedure for the space button and both left and right of the spaceship 
    mov ah,0
    int 16h

    cmp ah,4bh                            ;Move Shooter Left if left button is pressed
    jnz NotLeftKey
    call MoveShooterLeft 
    jmp EndofKeyisPressed
	
    NotLeftKey:
    cmp ah,4dh					
    jnz NotRightKey			 ;Move Shooter Right if Right button is pressed
    call MoveShooterRight
    jmp EndofKeyisPressed
	
    NotRightKey:
    cmp ah,1H                 	 ;Esc to exit the game

	Jnz NotESCKey
	call Gameover 
		
	NotESCKey:
    cmp ah,39h                            ;go spaceKey if up button is pressed

    jnz EndofKeyisPressed
    cmp ShotStatus,1
    jz EndofKeyisPressed
    mov al,1                      	  ;intialize a new shot
    mov ShotStatus,1 
    mov al,ShooterCol
    mov ShotCol,al
    mov al,24				  ;it will be decremented in the new MainLoop
    mov ShotRow,al 
			
    EndofKeyisPressed:
    ret
KeyisPressed ENDP 


MoveShooterLeft Proc  ;The procedure of the Shooter of left
     cmp ShooterCol,0
     JZ NoMoveLeft
     dec ShooterCol
     PrintShooter ShooterCol 
     mov al,ShooterCol   
     inc al
     delete 24,al
    NoMoveLeft:
    ret
MoveShooterLeft  ENDP 


MoveShooterRight  Proc ;The procedure of the shooter right
     cmp ShooterCol,79
     JZ NoMoveRight
     inc ShooterCol
     PrintShooter ShooterCol  
     mov al,ShooterCol   
     dec al
     delete 24,al 
     NoMoveRight:
    ret
MoveShooterRight  ENDP 


MoveShot  Proc ;moving the shot procedure 
    dec ShotRow
    PrintShot ShotRow,ShotCol 
    mov al,ShotRow  
    inc al
    delete al,ShotCol    
    ret
MoveShot  ENDP 

CheckShotStatus  Proc ;The procedure for checking the status of the rocket
    push ax
	
    mov ah,RocketRow
    inc ah  ;Checking the row if occupied by a rocket
    cmp ah,ShotRow  
    JNZ CheckEndRange 
    mov al,ShotCol
    cmp al,RocketColLeft
    JZ Hit      
	cmp al,RocketColCenter
	JZ Hit
    cmp al,RocketColRight
    JZ Hit 	
    cmp RocketDirection,0
	jnz RightDirection
	mov ah,RocketColLeft
	dec ah
	cmp al,ah
    JZ Hit
    jmp CheckEndRange
	RightDirection:
	mov ah,RocketColRight
	inc ah
	cmp al,ah
    JZ Hit
		
   CheckEndRange:
	 cmp ShotRow,2	
	 jnz noChange			
	 dec bullets
	 cmp bullets,0
     jnz ResetTheShot
     call Gameover
	 
     Hit: inc Hits
	 inc bullets
	 call DeleteRocket
;	 call ResetRocket
	 ResetTheShot:
  ;   call ResetShot
     call UpdateStrings
     noChange:
	 
    pop ax
    ret    
CheckShotStatus ENDP 


Difficulty Proc ;the difficulity of hard level and using the delay code of 24,000
	jle gaming
	jmp EndDifficulty
	
	gaming: Delay 0,24000 ;Hard Mode when 10<=Hits<5
	jmp EndDifficulty
	
	EndDifficulty:
	ret
Difficulty ENDP


StartMenu Proc ;Starting the menu procedure
	push ax
	push bx
	push cx
	push dx
	push ds 

	ClearScreen
	screenset 0,0,24,79,15h ;in order to clear the screen
	LoopOnName:
	PrintText 8,8,Askp_name

	;Receiving the  player name from the user
	mov ah,0Ah
	mov dx,offset p_name
	int 21h

	cmp p_name[1],0	;Checking that input is not empty
	jz LoopOnName
	;Checks on the first letter to ensure that it's either a capital letter or a small letter
	cmp p_name[2],40h
	jbe LoopOnName
	cmp p_name[2],7Bh
	jae LoopOnName
	cmp p_name[2],60h
	jbe	anotherCheck
	ja ExitLoopOnName
	anotherCheck:
	cmp p_name[2],5Ah
	ja	LoopOnName

ExitLoopOnName: ;Exiting the screen after entering the name of the user
	ClearScreen

	screenset 0,0,24,79,40h ;in order to clear the screen
	screenset 7,19,15,60,0eh
	onscreenpoint 8,21
	textprinting intro
	onscreenpoint 9,21
	textprinting spoint
	onscreenpoint 10,21
	textprinting epoint
	onscreenpoint 11,46
	textprinting ulabel
	onscreenpoint 12,21
	textprinting lrlabel
	onscreenpoint 13,46
	textprinting dlabel
	onscreenpoint 14,25
    textprinting ready
	onscreenpoint 15,25
	textprinting press

	mov ah,01h
	int 21h

    ClearScreen 

	screenset 0,0,24,79,50h ;in order to clear the screen
	screenset 7,19,15,60,0eh
	onscreenpoint 8,21
	textprinting ins1
	onscreenpoint 9,21
	textprinting ins2
	onscreenpoint 10,21
	textprinting ins3
	onscreenpoint 11,21
	textprinting ins4
	onscreenpoint 12,21
	textprinting ins5
	onscreenpoint 13,21
	textprinting ins6
	onscreenpoint 14,25
    textprinting ins7
	onscreenpoint 15,25
	textprinting ins8

	;hiding the curser
	 mov ah,01h
	 mov cx,2607h 
	 int 10h

	checkforinput:
	mov AH,0            		 
	int 16H 
	cmp al,13;Entering to Start Game   
	JE StartTheGame
	cmp ah,1H ;Escaping to exit the game
	JE ExitMenu
	JNE checkforinput
	
	ExitMenu:
	mov ah,4CH
	int 21H

	StartTheGame: 
	pop ds
	pop dx
	pop cx
	pop bx
	pop ax 
	RET
StartMenu ENDP

Gameover Proc ;Gameover screen procedure
	ClearScreen
	screenset 0,0,24,79,15h	;in order to clear the screen
	screenset 7,19,15,60,0eh
	onscreenpoint 9,21
	textprinting over1
	onscreenpoint 10,21
	textprinting over2
	onscreenpoint 11,21
	textprinting over3
	PrintText 12,21,FinalScoreString

;Exiting the program
mov ah,4CH
int 21H 
ret
Gameover ENDP 
END MAIN