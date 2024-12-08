{$G+}
const
  slovo: string = 'Hello world!';
var
  x, y: integer;
begin
  asm
    mov y, 12
    mov x, 33

    mov ax, 3
    int 10h

    push $b800
    pop es

    lea si, slovo
    mov cl, [si]
    add cl, cl

    jmp @print

  @clear:
    add bx,bx
    mov di,bx
    xor ax, ax
    mov cx, 80
    rep stosw

  @print:
    mov ax, y
    mov cl, 80
    mul cl
    mov bx, ax
    add ax, x
    shl ax, 1
    mov di, ax
    mov ah, $1f
    lea si, slovo
    mov cl, [si]
    xor ch, ch
    inc si
    mov dx, x
  @p:
    lodsb
    cmp dx, 80
    jne @normalPrint
    sub di, 160
  @normalPrint:
    stosw
    inc dx
    loop @p

  @readKey:
    xor ah, ah
    int 16h
    cmp ah, 48h
    je @up
    cmp ah, 50h
    je @down
    cmp ah, 4bh
    je @left
    cmp ah, 4dh
    je @right
    cmp ah, 01h
    je @exit
    jmp @readKey

  @up:
    cmp y, 0
    jne @upNormal
    mov y, 24
    jmp @clear
  @upNormal:
    dec y
    jmp @clear

  @down:
    cmp y, 24
    jne @downNormal
    mov y, 0
    jmp @clear
  @downNormal:
    inc y
    jmp @clear

  @left:
    cmp x, 0
    jne @leftNormal
    mov x, 79
    jmp @clear
  @leftNormal:
    dec x
    jmp @clear

  @right:
    mov ax, 80
    cmp x, ax
    jne @rightNormal
    mov x, 0 
    jmp @clear
  @rightNormal:
    inc x
    jmp @clear

  @exit:
  end;
end.