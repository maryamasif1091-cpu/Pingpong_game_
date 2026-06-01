
[org 0x0100]
jmp start
;==============================================================================================================================================;
paddleslength:	dw 5  ;paddles length    
counter:	dd 0   ;counter
;messages 
m: db ' Welcome to PING PONG GAME! ', 0 
msg1: db 'Press Enter To Continue', 0
msg2: db 'Enjoy The Game!', 0
;==============================================================================================================================================;
;instructions
instructions :db 'Use W and S to control Left Paddle.', 0
instructions2: db 'Use Up and Down Arrow to control Right Paddle.', 0
instructions3: db 'First player to reach 5 wins the game.', 0 
;==============================================================================================================================================;
player1:	db 'Player 1 Wins.' 
player2:	db 'Player 2 Wins.'
tie1:           db  '!!!Match tie!!'
gameOver:	db 'GAME OVER!'
score:		db 'Score: '	
press:		db 'Press Enter to start...' 
scoreP1:	db 'Player 1 Score: ' 
scoreP2:	db 'Player 2 Score: ' 
score1:		dw 0 ;score of players 
score2:		dw 0
win:		dw 5 
press1 db 'Press R to Restart or Q to Quit',0
;==============================================================================================================================================;
;............................................................................................................................................;
;label that clear screen 
    clrscr: 	
;push values to stack 
push es                          
push ax
push cx
push di
mov ax, 0xb800
mov es, ax
xor di, di
mov cx, 2000
mov ax, 0x0320 ;space asccii 
;auto increment 
cld
rep STOSW
pop di
pop cx
pop ax
pop es
ret
;==============================================================================================================================================;      
;label that color screen 
     color_screen:
mov ax, 0xb800      
mov es, ax
mov di, 0          
    color_loop:
mov word [es:di], 0x0407 ;color attribute 
add di, 2     ;for moving to next location        
cmp di, 4000       ;total size 
jne color_loop
ret
;==============================================================================================================================================;
	
;label that prints messages 	
  print_message:
mov ax, 0xb800   
mov es, ax
mov si, bx        ;address of message load 
   next_char:
lodsb              ;load value from al  or ax  to es:di 
cmp al, 0           ;check null character 
je done
mov ah, 0x05 ;color attributre       
mov [es:di], ax    
add di, 2          
jmp next_char
  done:
ret
 ;label that draw wall_drawing
 wall_drawing:
 push es 
 push ax 
 push di 
 mov ax,0xb800 
 mov es,ax 
 xor di,di 
 mov cx,80 
 loop_1:
 mov word[es:di],0x052A
 add di,2
 loop loop_1
 xor di,di 
 mov di,3680 
 mov cx,80
 loop_2:
 mov word[es:di],0x052A
 add di,2
 loop loop_2
 pop di 
 pop ax 
 pop es 
 ret 
;==============================================================================================================================================;  
  
;label that wait for user to press enter key 
   wait_for_enter:
mov ah, 0           ; BIOS keyboard interrupt function
int 16h             ;interrupt for keyboard 
cmp al, 0x0D       ;compare with ascii of key whether press or not 
jne wait_for_enter  ; Loop until Enter is pressed
ret	
;........................................................................................................................................;
;==============================================================================================================================================;
;  label that  Check  if the ball has touched the right side of grid 				
   right_Check:
cmp dx, si
je right_label
add dx, 160   ;move to next row 
cmp dx, 4000    ;total locations in screen
jl right_Check
ret	

;if ball hits with right  side then game over	
    right_label:
mov word[win], 1
call game_over	

;Checking if the ball has touched the left side of grid		
   left_Check:                    
cmp dx, si
je left_label
add dx, 160  ;move to next row 
cmp dx, 4000 ;total locations in screen
jl left_Check
ret
       
;if ball hits with left side then game over 
   left_label:
mov word[win], 2
call game_over
;==============================================================================================================================================;
                    ;.....................................................................;
                                               ;Ball movements 
;==============================================================================================================================================;
; label that move ball straight for player 1		
  moveball_player1:	
push ax
push si
push dx
mov ax, 0x0000
mov si, word[bp-10]
mov [es:si], ax
add word[bp-10], 2
mov si, word[bp-10]
call hitball_P2
mov dx, 158
call right_Check
mov ax, 0x0342
mov [es:si], ax
pop dx
pop si
pop ax
ret	 
            ;..............................................................................;
;label to control ball  movement straight  for player 2 
   moveball_player2:	
push ax
push si
push dx
mov ax, 0x0000
mov si, word[bp-10]
mov [es:si], ax
sub word[bp-10], 2
mov si, word[bp-10]
call hitball_P1
mov dx, 0
call left_Check
mov ax, 0x0342 
mov [es:si], ax
pop dx
pop si
pop ax
ret
           ;.................................................................................;
 ;mov ball diagonaly up for player 1
   balldiagnol_player1:  
push ax
push si
push dx
mov ax, 0x0000
mov si, word[bp-10]
mov [es:si], ax
sub word[bp-10], 158
mov si, word[bp-10]
call hitball_P2
mov dx, 158
call right_Check
mov ax, 0x0342 
mov [es:si], ax
pop dx
pop si
pop ax
ret
              ;.................................................................................;
   ;move ball diagonally up for player 2
    balldiagnol_player2:     
push ax
push si
push dx
mov ax, 0x0000
mov si, word[bp-10]
mov [es:si], ax
sub word[bp-10], 162
mov si, word[bp-10]
call hitball_P1
mov dx, 0
call left_Check   ;as player 2 controls left paddle so check  left position
mov ax, 0x0342 
mov [es:si], ax
pop dx
pop si
pop ax
ret
                 ;.................................................................................;
  ;move ball diagonally down for player 1
     balldown_player1:  
push ax
push si
push dx
mov ax, 0x0000
mov si, word[bp-10]
mov [es:si], ax
add word[bp-10], 162
mov si, word[bp-10]
call hitball_P2
mov dx, 158
call right_Check ;as player 1 controls right paddle so check right position
mov ax, 0x0342 
mov [es:si], ax
pop dx
pop si
pop ax
ret
                    ;.................................................................................;
;move ball diagonally down for player 2
    balldown_player2: 
push ax
push si
push dx
mov ax, 0x0000
mov si, word[bp-10]
mov [es:si], ax
add word[bp-10], 158
mov si, word[bp-10]
call hitball_P1
mov dx, 0
call left_Check
mov ax, 0x0342 
mov [es:si], ax
pop dx
pop si
pop ax
ret
;==============================================================================================================================================;
;...............................................................................................................;
; printing game over on screen along with which player wins and there scores
   game_over:	
call clrscr   ;screen clear 
mov ah, 0x13         ; service
mov al, 1            ;sub service
mov bh, 0 
mov bl, 3           ;color
mov dx, 0x0101     ;location
mov cx, 16           ; length
push cs              ; Push code segment and pop to ES
pop es 
mov bp, scoreP1      ; Address of score that prints score of Player 1
int 0x10             ; Interrupt 10 for video
mov dx, 0x0201       ; Position
mov cx, 16
push cs
pop es 
mov bp, scoreP2      ; Address of score that prints score of Player 2
int 0x10
mov dx, 0x0123  
push cs
pop es 	
mov cx, 14           ; Length of winning message 
cmp word[win], 1   
je tie
jmp p2_Win
tie:
mov bp, tie1
jmp print_messages
p1_Win:		
mov bp, player1
jmp print_messages
p2_Win:		
mov bp, player2	
print_messages:		
int 0x10 ; Print message using video interrupt
jmp score_printing
;label to print score 
  score_printing:	
mov dx, 196
push dx  
mov dx, [score1]  ; Score 1 value move to DX
push dx 
call print_scorevalue ; Call to print score
mov dx, 356
push dx
mov dx, [score2]  ; Value move to DX
push dx
call print_scorevalue
mov dx, 0x0C30
mov cx, 10        ; Length of "Game Over" message  
push cs
pop es 
mov bp, gameOver  ; "Game Over" message address 
int 0x10
call restart_or_exit ; Call to handle restart/exit logic
ret
;label for restart 
  restart_or_exit:
mov dx, 0x0D00       
push cs
pop es
mov bp, press1        ; "Press R to Restart or Q to Quit" message
mov cx, 31           ; Length of the message
int 0x10             ; Display message
call wait_for_input  ; Wait for user input
ret
;press e or r
    wait_for_input:
mov ah, 0           ; BIOS keyboard interrupt function
int 16h             ; Interrupt for keyboard input
cmp al, 'R'         ; Check if 'R' (Restart) is pressed
je handle_restart
cmp al, 'Q'         ; Check if 'Q' (Quit) is pressed
je handle_exit
jmp wait_for_input  ; Invalid input, wait again
ret
;if user enters R then game starts again 
   handle_restart:
call clrscr          ; Clear the screen
jmp start
;if uers entres e then exit              
handle_exit:
mov ax, 0x4c00       ; Exit the program
int 0x21
ret
;==============================================================================================================================================;
          
;print numbers  ; Printing the score of both players
     print_scorevalue:
;push all values to stack 	 
push bp 
mov  bp, sp
push es 
push ax 
push bx 
push cx 
push dx 
push di 
mov ax, [bp+4]   
mov bx, 10       
mov cx, 0   ;counter 
 ;for next digit      
   nextdigit:	
mov dx, 0    
div bx       
add dl, 0x30  ;add 30h for stroe values frrom A to F 
push dx      
inc cx       
cmp ax, 0    
jnz nextdigit 			
mov ax, 0xb800 
mov es, ax 
mov di, [bp+6]
;for next location 
nextpos:    
pop dx          
mov dh, 0x03  ;color attribute  
mov [es:di], dx 
add di, 2 
loop nextpos 
;restore all values    
pop di 
pop dx 
pop cx 
pop bx 
pop ax 
pop es
pop bp 
ret 8	 ;clear stcak
;==============================================================================================================================================;
;..................................................................................................................;
;delay 					
    delay_label:
mov dword[counter], 100000 
   incrementing_counter:
dec dword[counter] 
cmp dword[counter],0 
jne  incrementing_counter
ret
;...........................................................................................................................;
 ;==============================================================================================================================================;
 ; Sub-Routine of PingPong Game
        ;...............................................................................;
    game:	 	
push bp      
mov bp, sp
sub sp, 10 ;subtarct 10 to clean space for 5  local varaibles 
mov word[bp-2], 2 ; First player
mov word[bp-4], 156 ; Second Player
mov word[bp-6], 0 ; Last Position of player 1
mov word[bp-8], 0 ; Last Position of player 2
mov word[bp-10], 644 ; Ball position
push es
push ax
push bx
push cx
push dx
push si
push di
mov ax, 0xb800
mov es, ax		
mov si, word[bp-2] ; Load player 1 starting position
mov di, word[bp-4] ; Load player 2 starting position
mov cx, word[bp+4] ; Load player length
mov ax, 0x037C   ;ascii of | 
;==============================================================================================================================================;
 ; Printing both players
   players_printing:
mov [es:si], ax ; PLayer 1                           
mov [es:di], ax ; PLayer 2
mov word[bp-6], si
mov word[bp-8], di
add si, 160
add di, 160
loop players_printing
mov si, word[bp-10]; Printing ball
mov ax, 0x037C
mov [es:si], ax
call ball_movements1     

;ending game 				
  clearing_stack:
pop di                
pop si
pop dx
pop cx
pop bx
pop ax
pop es
mov sp, bp
pop bp
ret 2
;==============================================================================================================================================; 
 ;................................................................................;
 ; Ball movement Diagonally Down when player 1 hits the ball	
   ball_movements1:                     
call balldown_player1
call delay_label
add si, 162
call P2_controlkeys
cmp si, 4000
jl ball_movements1

 ;ball movement diagonally up for 1
    ballmove_up:  
call balldiagnol_player1
call delay_label
sub si, 158
call P2_controlkeys
cmp si, 0
jg ballmove_up
jmp ball_movements1

; Ball movement Diagonally Up when player 1 hits the ball			
    movementballdiagnol_P1:
call balldiagnol_player1
call delay_label
sub si, 158
call P2_controlkeys
cmp si, 0
jg movementballdiagnol_P1

; Ball movement Diagonally down when player 1 hits the ball
   ballmovement_P1:
call balldown_player1
call delay_label
add si, 162
call P2_controlkeys
cmp si, 4000
jl ballmovement_P1
jmp movementballdiagnol_P1   
	; Ball movement Diagonally Up when player 2 hits the ball		
     movementballdiagnol_P2:                         
call balldiagnol_player1
call delay_label
sub si, 162
call P1_controlkeys
cmp si, 0
jg movementballdiagnol_P2           
; Ball movement Diagonally down  when player 2 hits the ball
    ballmovement_P2:
call balldown_player1
call delay_label
add si, 158
call P1_controlkeys
cmp si, 4000
jl ballmovement_P2
jmp movementballdiagnol_P2
            
	   ; Ball movement Straight when player 1 hits the ball					
    ballMS1:                       
call moveball_player1
call delay_label
add si, 2
call P2_controlkeys
jmp ballMS1	
              
  ; Ball movement Straight when player 2 hits the ball	
      ballMS2:                                         
call moveball_player2
call delay_label
sub si, 2
push ax
call P1_controlkeys
jmp ballMS2	
                 
 ; Ball movement Diagonally Down when player 2 hits the ball
    ballmovements_2:                                   
call balldown_player2
call delay_label
add si, 158
call P1_controlkeys
cmp si, 4000
jl ballmovements_2
    ballmove_D2:
call balldiagnol_player2
call delay_label
sub si, 162
call P1_controlkeys
cmp si, 0
jg ballmove_D2
jmp ballmovements_2
;==============================================================================================================================================;
                  ;................................................................................;
 ; Checking if player 2 hits the ball	
   hitball_P2:
push bx
push si
mov bx, word[bp-4]
cmp si, bx
jne P2_label2
inc word[score2]
push ax
mov ax, 0x037C
mov [es:si], ax
pop ax
sub word[bp-10], 2
jmp movementballdiagnol_P2
    P2_label2:
add bx, 160
cmp si, bx
jne P2_label3
inc word[score2]
push ax
mov ax, 0x037C
mov [es:si], ax
pop ax
sub word[bp-10], 2
jmp movementballdiagnol_P2
    P2_label3:	
add bx, 160
cmp si, bx
jne P2_label4
inc word[score2]
push ax
mov ax, 0x037C
mov [es:si], ax
pop ax
sub word[bp-10], 2
jmp ballMS2
    P2_label4:	
add bx, 160
cmp si, bx
jne P2_label5 
inc word[score2]
push ax
mov ax, 0x037C
mov [es:si], ax
pop ax
sub word[bp-10], 2
jmp ball_movements1
   P2_label5:	
add bx, 160
cmp si, bx
jne hit_P2exit
inc word[score2]
push ax
mov ax, 0x037C
mov [es:si], ax
pop ax
sub word[bp-10], 2
jmp ballmovements_2
    hit_P2exit:	
pop si
pop bx
ret 
;==============================================================================================================================================; 
 ;................................................................................;
 ; Checking if player 1 hits the ball
   hitball_P1:           
push bx
push si
mov bx, word[bp-2]
cmp si, bx
jne P1_label2
inc word[score1]
push ax
mov ax, 0x037C ;asccii of |
mov [es:si], ax
pop ax
add word[bp-10], 2
jmp movementballdiagnol_P1
     P1_label2:	
add bx, 160
cmp si, bx
jne P1_label3
inc word[score1]
push ax
mov ax, 0x037C  ;ascii of |
mov [es:si], ax
pop ax
add word[bp-10], 2
jmp movementballdiagnol_P1
   P1_label3:		
add bx, 160
cmp si, bx
jne P1_label4
inc word[score1]
push ax
mov ax, 0x037C
mov [es:si], ax
pop ax
add word[bp-10], 2
jmp ballMS1
   P1_label4:	
add bx, 160
cmp si, bx
jne P1_label5
inc word[score1]
push ax
mov ax, 0x037C
mov [es:si], ax
pop ax
add word[bp-10], 2
jmp ball_movements1
   P1_label5:  
add bx, 160
cmp si, bx
jne hit_P1exit
inc word[score1]
push ax
mov ax, 0x037C
mov [es:si], ax
pop ax
add word[bp-10], 2
jmp ball_movements1				
   hit_P1exit:	
pop si
pop bx
ret			
 ;==============================================================================================================================================;
                  ;Players movements 
          ;.................................................................................;
 ; Movement of player 1 Downward
   moveP1D:             
push ax
push si
mov si, word[bp-6]
add si, 160
cmp si, 4000
jg exitP1_down
add word[bp-6], 160
mov ax, 0x037C
mov [es:si], ax
mov si, word[bp-2]
mov ax, 0x0000
mov [es:si], ax			
add word[bp-2], 160
	
   exitP1_down:	
pop si
pop ax
ret
               ;..............................................................................;
; Movement of player 1 Upward			
    player1_movement:                
push ax
push si
mov si, word[bp-2]
sub si, 160
cmp si, 0
jl exitP1_up
sub word[bp-2], 160
mov ax, 0x037C
mov [es:si], ax			
mov si, word[bp-6]
mov ax, 0x0000
mov [es:si], ax
sub word[bp-6], 160		
    exitP1_up:	
pop si
pop ax
ret
                  ;.................................................................................;
  ; Movement of player 2 Downward
    moveP2D:               
push es
push ax
push si
mov ax, 0xb800
mov es, ax
mov si, word[bp-8]
add si, 160
cmp si, 4000
jg exitP2_down
add word[bp-8], 160
mov ax, 0x037C
mov [es:si], ax
mov si, word[bp-4]
mov ax, 0x0000
mov [es:si], ax			
add word[bp-4], 160		
   exitP2_down:	
pop si
pop ax
pop es
ret
                 ;.................................................................................;
 ; Movement of player 2 Upward
     player2_movement:     
push ax
push si
mov si, word[bp-4]
sub si, 160
cmp si, 0
jl exitP2_up
sub word[bp-4], 160
mov ax, 0x037C
mov [es:si], ax			
mov si, word[bp-8]
mov ax, 0x0000
mov [es:si], ax
sub word[bp-8], 160	
    exitP2_up:	
pop si
pop ax
ret	
;==============================================================================================================================================;
                ;.................................................................................;
   ; Taking input from player 1 controls
   P1_controlkeys:	
mov ah, 1
int 0x16
jz exit_IP1
mov ah, 0     ; ah= BIOS scan code
int 0x16
cmp al, 'w'
je player1_movement
cmp al, 's'
je moveP1D
cmp ah, 01
je game_over
 exit_IP1:
ret
              ;.................................................................................;
; Taking input from player 2 controls
    P2_controlkeys:	
mov ah, 1
int 0x16
jz exit_IP2
mov ah, 0    ; ah = BIOS scan code
int 0x16
cmp ah, 0x48 ; Upper arrow key
je player2_movement
cmp ah, 0x50 ; Lower arrow key
je moveP2D
cmp ah, 01
je game_over
   exit_IP2:
ret
;==============================================================================================================================================;
;..............................................................................................................................;
;main start label 						
   start: 
call clrscr
call color_screen
call wall_drawing
mov bx, m    ; Display welcome messages
mov di, 830 ;location 
call print_message
mov bx, msg1   ;display member 1 information 
mov di, 1150 ;location 
call print_message
mov bx, msg2   ;display member  2 information 
mov di, 1630 ;location 
call print_message
call wait_for_enter; Wait for Enter key
;.............................................................................................................................;
call clrscr
call color_screen
call clrscr
call wall_drawing
mov bx, instructions ; Display instructions
mov di, 164
call print_message
mov bx, instructions2
mov di, 324
call print_message
mov bx, instructions3
mov di, 484
call print_message
call wait_for_enter	; Wait for Enter key	
call clrscr
;..............................................................................................................................;
push word [paddleslength] ;paddles length 
call game  ;call game 
mov ax,0x4c00
int 0x12
;==============================================================================================================================================;
