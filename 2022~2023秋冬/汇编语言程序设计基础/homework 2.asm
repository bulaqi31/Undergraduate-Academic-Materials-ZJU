data segment stack
c db 0
d dw 0
data ends
code segment
assume cs:code, ds:data
main:
   mov ax, 0B800h;   显卡内存位置
   mov es, ax
   mov di,0
input1:
   mov ah, 1
   int 21h
   sub al, 30h
   cmp al, 9h;    判断是不是数字
   jbe number1
   sub al, 7h
number1:
   mov cl, 4;    先输入高位，要乘以16
   shl al, cl
   mov c, al
input2:
   mov ah, 1
   int 21h
   sub al, 30h
   cmp al, 9h
   jbe number2
   sub al, 7h
number2:
   add al, c;    加上原先的高位
   mov cx, 16
doit:
   cmp cx, 0
   je over
   mov byte ptr es:[di], al;     存入字符和颜色
   mov byte ptr es:[di+1], 7Ch
   mov bl, al
   mov d, cx;    此处先把cx 的值存下来， 否则修改cl后会导致死循环
   mov cl, 4;    左移四位以上要用cl
   shr bl, cl
   mov cx, d
   cmp bl, 9
   jbe num1
   add bl, 7
num1:
   add bl, '0'
   mov byte ptr es:[di+2], bl
   mov byte ptr es:[di+3], 1Ah
   mov bl, al
   and bl, 15
   cmp bl, 9
   jbe num2
   add bl, 7
num2:
   add bl, '0'
   mov byte ptr es:[di+4], bl
   mov byte ptr es:[di+5], 1Ah
   add al, 1;     读到下一个字符
   add di, 160;   输出换到下一行
   sub cx, 1
   jmp doit
over:
   mov ah, 0
   int 16h;       按esc退出程序
   mov ah, 4Ch
   int 21h
code ends
end main