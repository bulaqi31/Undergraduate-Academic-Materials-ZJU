.386
data segment use16
num2 dd 0 ;用来更新新加入的数字
op db '+'
aa db 0
ans dd 0 ;用来更新运算后的最新数字结果
data ends

stack1 segment stack use16
   dw 100h dup(?)
stack1 ends
code segment use16
assume cs:code,ds:data
main:
   mov ax,data
   mov ds,ax
input:
   mov edx, 0
   mov ah, 1
   int 21h; al=getchar()
   mov aa, al; 若后续有运算，al的值会被更改
   sub aa, '0'
   cmp al, '0'
   jb operation; 如果比字符零小，那么不是操作符就是回车，要进行一次操作
number:
   mov eax, num2
   mov ebx, 10
   mul ebx; *10
   mov dl, aa
   add eax, edx
   mov num2, eax
   jmp input

operation:
   mov cl, op;          读取之前那一个运算符
   mov op, al;          修正为当前的运算符
   cmp cl, '+'
   je do_add
   cmp cl, '*'
   je do_mul
   cmp cl, '/'
   je do_div
do_add:;                 加法
   mov eax, ans
   add eax, num2
   mov ans, eax
   jmp ok
do_mul:;                 乘法
   mov eax, ans
   mul num2
   mov ans, eax
   jmp ok
do_div:; 除法
   mov edx, 0;           把edx变为0
   mov eax, ans
   div num2
   mov ans, eax
ok:
   mov dl, op
   cmp dl, 0Dh;   如果是回车，跳到输出环节
   je output
   mov eax, 0
   mov num2, eax;  将这个数字清零
   jmp input;
output:
   mov dl, 0Dh
   mov ah, 2
   int 21h
   mov dl, 0Ah
   mov ah, 2
   int 21h
   mov eax, ans
   mov cx,0
output_dec:;           输出十进制
   mov edx, 0
   cmp eax, 0
   je output_
   mov ebx, 10
   div ebx
   add dl, '0'
   push dx;    让这个字符入栈
   add cx, 1
   jmp output_dec
output_:
   cmp cx, 0
   je output_it
   pop dx;      让字符出栈并输出
   mov ah, 2
   int 21h
   sub cx, 1
   jmp output_
output_it:
   mov dl, 0Dh
   mov ah, 2
   int 21h
   mov dl, 0Ah
   mov ah, 2
   int 21h
   mov eax, ans
output_hex:
   mov edx, 0
   cmp eax, 0
   je output0_
   mov ebx, 16
   div ebx
   add dl, '0';    除这一步之外与十进制相同，这里要判断是不是字母
   cmp dl, '9'
   jbe numb
letter:
   add dl, 7
numb:
   push dx
   add cx, 1
   jmp output_hex
output0_:
   mov bx, 8
   sub bx, cx
output1_:
   cmp bx, 0
   je output2_
   mov dl, '0';   按照样例前面补0
   mov ah, 2
   int 21h
   sub bx, 1
   jmp output1_
output2_:
   cmp cx, 0
   je done
   pop dx;      让字符出栈并输出
   mov ah, 2
   int 21h
   sub cx, 1
   jmp output2_
done:
   mov dl, 'h';  按照样例，最后补上一个h
   mov ah, 2
   int 21h
   mov dl, 0Dh
   mov ah, 2
   int 21h
   mov dl, 0Ah
   mov ah, 2
   int 21h
   mov ah, 4Ch
   int 21h
code ends
end main