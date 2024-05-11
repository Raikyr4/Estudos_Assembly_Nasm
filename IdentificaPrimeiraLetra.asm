section .data
    msg_prompt db "Digite seu nome: ", 0
    msg_valid db "Começa com letra maiúscula.", 0
    msg_invalid db "Não começa com letra maiúscula.", 0
    newline db 0xA, 0xD

section .bss
    name resb 64 ; Reserva espaço para armazenar o nome do usuário

section .text
    global _start

_start:
    ; Imprime a mensagem solicitando o nome do usuário
    mov eax, 4
    mov ebx, 1
    mov ecx, msg_prompt
    mov edx, 17
    int 0x80

    ; Lê o nome digitado pelo usuário
    mov eax, 3
    mov ebx, 0
    mov ecx, name
    mov edx, 64
    int 0x80

    ; Verifica se o primeiro caractere é uma letra maiúscula
    mov al, byte [name]
    cmp al, 'A'
    jl .not_capital
    cmp al, 'Z'
    jg .not_capital

    ; Se for uma letra maiúscula, imprime a mensagem de validação
    mov eax, 4
    mov ebx, 1
    mov ecx, msg_valid
    mov edx, 28
    int 0x80
    jmp .exit

.not_capital:
    ; Se não for uma letra maiúscula, imprime a mensagem de invalidação
    mov eax, 4
    mov ebx, 1
    mov ecx, msg_invalid
    mov edx, 32
    int 0x80

.exit:
    ; Imprime uma nova linha
    mov eax, 4
    mov ebx, 1
    mov ecx, newline
    mov edx, 2
    int 0x80

    ; Termina o programa
    mov eax, 1
    xor ebx, ebx
    int 0x80

; COMANDO PARA MONTAR O NASM        :  nasm -f elf64 aula_4.asm
; COMANDO PARA LIGAR ELE AO SISTEMA :  ld aula_4.o -o aula_4
; COMANDO PARA EXECUTAR O PROGRAMA  :  ./aula_4