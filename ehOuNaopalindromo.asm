section .data
    prompt db 'Digite uma palavra: ', 0
    palindrome_msg db 'eh palindromo', 0
    not_palindrome_msg db 'n eh palindromo', 0

section .bss
    input resb 256
    stack resb 256

section .text
    global _start

_start:
    ; Solicita ao usuário que insira uma palavra
    mov eax, 4
    mov ebx, 1
    mov ecx, prompt
    mov edx, 19
    int 0x80

    ; Lê a entrada do usuário
    mov eax, 3
    mov ebx, 0
    mov ecx, input
    mov edx, 256
    int 0x80

    ; Empilha cada caractere da palavra
    mov esi, input
    mov edi, stack
    xor ecx, ecx  ; Inicializa o contador de caracteres
push_loop:
    mov al, [esi]
    cmp al, 0xA
    je check_palindrome
    mov [edi], al
    inc esi
    inc edi
    inc ecx         ; Incrementa o contador de caracteres
    jmp push_loop

    ; Verifica se a palavra é um palíndromo
check_palindrome:
    dec edi             ; ajusta o ponteiro da pilha para apontar para o último caractere empilhado
    mov esi, input      ; reinicia o ponteiro de entrada para o início da palavra

palindrome_check:
    mov al, [esi]       ; carrega o caractere atual da entrada original
    cmp al, 0xA         ; verifica se chegamos ao final da palavra
    je is_palindrome    ; se sim, a palavra é um palíndromo
    mov bl, [edi]       ; carrega o caractere correspondente da pilha
    cmp al, bl          ; compara os caracteres
    jne not_a_palindrome    ; se não forem iguais, a palavra não é um palíndromo
    inc esi             ; move o ponteiro da entrada para o próximo caractere
    dec edi             ; move o ponteiro da pilha para o caractere anterior
    jmp palindrome_check    ; continua verificando

is_palindrome:
    ; se chegou ao final, a palavra é um palíndromo
    mov eax, 4
    mov ebx, 1
    mov ecx, palindrome_msg
    mov edx, 13
    int 0x80
    jmp exit

not_a_palindrome:
    ; Imprime 'n eh palindromo' se a palavra não for um palíndromo
    mov eax, 4
    mov ebx, 1
    mov ecx, not_palindrome_msg
    mov edx, 15
    int 0x80

exit:
    ; Sai do programa
    mov eax, 1
    xor ebx, ebx
    int 0x80
