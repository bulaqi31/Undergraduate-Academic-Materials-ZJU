data segment stack; 这个地方不加stack  link的时候总会报错
s db 100 dup(0)
t db 100 dup(0)
data ends
code segment
assume cs:code, ds:data
main:
   mov ax, data
   mov ds, ax
   mov bx,0
input1:
   mov ah,1
   int 21h; al=getchar()
   cmp al, 0Dh; 		判断回车
   je input2
   mov s[bx], al
   add bx, 1
   jmp input1
input2:
   mov s[bx], 0
   mov dl, 0Dh
   int 21h; 输出回车
   mov ah, 2
   mov dl, 0Ah
   int 21h; 输出换行
   mov bx, offset s
   mov si, 0
   mov di, 100;  t数组地址比s后了100
doit:
   mov dl, [bx+si]
   cmp dl, 0
   je output0
   cmp dl, 20h
   je blank;	判断是不是空格
   sub dl, 61h
   cmp dl, 19h
   jbe small; 		判断是不是小写字母
   add dl, 61h
   mov [bx+di], dl
   add di, 1
   add si, 1
   jmp doit
small:
   add dl, 41h;  确定是小写，改为大写
   mov [bx+di], dl
   add di, 1
   add si, 1
   jmp doit
blank:
   add si, 1
   jmp doit
output0:
   add di, 1
   mov byte ptr [bx+di], 0
   mov di, 100
output1:
   mov dl, [bx+di]
   cmp dl, 0
   je output2
   mov ah, 2
   int 21h; 		输出dl中的字符
   add di, 1
   jmp output1
output2:
   mov ah, 4Ch
   int 21h
code ends
end main