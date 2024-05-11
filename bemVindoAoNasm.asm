section .data
    welcome db "Bem vindo, "
    welcomeLen equ $-welcome
    toThisPC db " a este PC", 0xa
    toThisPCLen equ $-toThisPC

section .bss
    name resb 50
    nameLen resb 1

section .text
    global _start

_start:
    ; lê o nome do usuário
    mov eax, 3
    mov ebx, 0
    mov ecx, name
    mov edx, 50
    int 0x80

    ; encontra o comprimento real do nome
    xor esi, esi        ; contador para comprimento do nome
.next_char:
    cmp byte [name + esi], 0   ; verifica se chegamos ao final da string
    je .name_read
    inc esi
    jmp .next_char
.name_read:
    mov [nameLen], sil   ; armazena o comprimento real do nome

    ; imprime 'Bem vindo, '
    mov eax, 4
    mov ebx, 1
    mov ecx, welcome
    mov edx, welcomeLen
    int 0x80

    ; imprime o nome do usuário
    mov eax, 4
    mov ebx, 1
    mov ecx, name
    mov edx, [nameLen]  ; usa o comprimento real do nome
    int 0x80

    ; imprime ' a este PC'
    mov eax, 4
    mov ebx, 1
    mov ecx, toThisPC
    mov edx, toThisPCLen
    int 0x80

    ; sai do programa
    mov eax, 1
    xor ebx, ebx
    int 0x80
