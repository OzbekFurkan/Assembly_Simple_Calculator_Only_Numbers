
org 100h      

 .data
 new_line db 0x0A, 0x0D, 0x24    
 operations_text db "0-Addition  1-Subtraction  2-Multiplication 3-Division $"
 select_operation_text db "Which operation do you want to apply: $"   
 first_number_text db "Enter First Number: $"
 second_number_text db "Enter Second Number: $"    
 result_text db "Result: $"     
 
 
 .code
 
 main proc
       
 ;to display operation options   
 mov ah, 09h
 mov dx, offset operations_text
 int 21h
 
 ;new line
 mov ah, 09h
 mov dx, offset new_line
 int 21h  
 
 ;to ask which operation user wants
 mov ah, 09h
 mov dx, offset select_operation_text
 int 21h
 
 ;to get wanted operation input
 mov ah, 01h
 int 21h
 push ax     ;pushing the wanted operation to be used after getting numbers
 
 ;new line
 mov ah, 09h
 mov dx, offset new_line
 int 21h 
 
 ;we will get 2 numbers from user
 ;ask user to enter first number
 mov ah, 09h
 mov dx, offset first_number_text
 int 21h
 
 ;get first number input from user
 mov ah, 01h
 int 21h
 sub al, 30h
 mov bl, al
 
 ;new line
 mov ah, 09h
 mov dx, offset new_line
 int 21h 
 
 ;ask user to enter second number
 mov ah, 09h
 mov dx, offset second_number_text
 int 21h
 
 ;get second number input from user
 mov ah, 01h
 int 21h
 sub al, 30h
 mov cl, al
 
 ;new line
 mov ah, 09h
 mov dx, offset new_line
 int 21h
 
 mov ch, '+'    ;making our result's sign + by default
 
 pop ax         ;wanted operation received from stack
 
 cmp al, '0'
 je addition
 
 cmp al, '1'
 je subtraction
 
 cmp al, '2'
 je multiplication
 
 cmp al, '3'
 je division
 
 
     
 make_result_neg:
    neg bl
    mov ch, '-'
 
     
 make_result_two_digit:
    mov ax, 0
    mov al, bl   ;we will divide the al at below so result(bl) should be at al
    mov dl, 0Ah  ;we will obtain digits seperately by dividing dl by 10
    div dl
    jmp display_result
 
 addition:
    add bl, cl
    jmp make_result_two_digit
    
 subtraction:
    sub bl, cl
    js make_result_neg
    jns make_result_two_digit
    
 multiplication:
    mov ah, 00h
    mov al, cl
    mul bl
    mov bl, al
    jmp make_result_two_digit
 
 division:
    mov ah, 00h
    mov al, bl
    div cl
    mov bl, al
    jmp make_result_two_digit
 
 display_result:
    add al, '0'
    add ah, '0'
    mov bx, ax
    mov ah, 09h
    mov dx, offset result_text
    int 21h
    ;sign char
    mov ah, 02h
    mov dl, ch
    int 21h
    ;first digit
    mov ah, 02h
    mov dl, bl
    int 21h
    ;second digit
    mov ah, 02h
    mov dl, bh
    int 21h
  
 ret