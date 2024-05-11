section .data
    newline db 0xA ; define um caractere de nova linha
    prompt db 'Digite uma opção: (i)nserir, (r)emover, (v)er topo, (s)air',0xA, 0
    insert_prompt db 'Digite um caractere para inserir na pilha: ', 0
    remove_msg db 'Caractere removido: ',0xA, 0
    top_msg db 'Caractere no topo da pilha: ', 0
    empty_msg db 'A pilha está vazia.',0xA, 0

section .bss
    stack resb 256
    top resb 1
    input resb 2

section .text
    global _start
_start:
    mov edi, stack

_loop:
    ; Solicita a opção do usuário
    mov eax, 4
    mov ebx, 1
    mov ecx, prompt
    mov edx, 61
    int 0x80

    ; Limpa o buffer de entrada
    mov eax, 3
    mov ebx, 0
    mov ecx, input
    mov edx, 2
    int 0x80

    cmp byte [input], 'i'
    je _insert
    cmp byte [input], 'r'
    je _remove
    cmp byte [input], 'v'
    je _view
    cmp byte [input], 's'
    je _exit
    jmp _loop

_insert:
    ; Solicita o caractere a ser inserido
    mov eax, 4
    mov ebx, 1
    mov ecx, insert_prompt
    mov edx, 43
    int 0x80

    mov eax, 3
    mov ebx, 0
    mov ecx, top
    mov edx, 1
    int 0x80

    ; Insere o caractere na pilha
    mov al, [top]
    mov [edi], al
    inc edi

    mov eax, 3
    mov ebx, 0
    mov ecx, input
    mov edx, 2
    int 0x80

    jmp _loop

_remove:
    ; Verifica se a pilha está vazia
    cmp edi, stack
    je _empty
    ; Remove o caractere do topo da pilha
    dec edi
    mov al, [edi]
    mov [top], al
    ; Imprime o caractere removido
    mov eax, 4
    mov ebx, 1
    mov ecx, remove_msg
    mov edx, 20
    int 0x80

    mov eax, 4
    mov ebx, 1
    mov ecx, top
    mov edx, 1
    int 0x80

    ; Imprime uma quebra de linha
    mov eax, 4
    mov ebx, 1
    mov ecx, newline
    mov edx, 1
    int 0x80

    jmp _loop

_view:
    ; Verifica se a pilha está vazia
    cmp edi, stack
    je _empty
    ; Imprime o caractere no topo da pilha
    dec edi
    mov al, [edi]
    mov [top], al
    inc edi

    mov eax, 4
    mov ebx, 1
    mov ecx, top_msg
    mov edx, 28
    int 0x80

    mov eax, 4
    mov ebx, 1
    mov ecx, top
    mov edx, 1
    int 0x80

    ; Imprime uma quebra de linha
    mov eax, 4
    mov ebx, 1
    mov ecx, newline
    mov edx, 1
    int 0x80

    jmp _loop

_empty:
    ; Imprime uma mensagem indicando que a pilha está vazia
    mov eax, 4
    mov ebx, 1
    mov ecx, empty_msg
    mov edx, 20
    int 0x80

    ; Imprime uma quebra de linha
    mov eax, 4
    mov ebx, 1
    mov ecx, newline
    mov edx, 1
    int 0x80

    jmp _loop

_exit:
    ; Sai do programa
    mov eax, 60
    xor edi, edi
    syscall

; COMANDOS :
; nasm -f elf64 pilha.asm
; ld pilha.o -o pilha
; ./pilha