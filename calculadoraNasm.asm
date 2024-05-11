; IMPORTANTE: ao colocar os valores no programa coloque sempre o valor maior primeiro para não dar erro no programa, pois não imprimo valores negativos

; COMANDOS :
; nasm -f elf64 calc.asm
; ld calc.o -o calc
; ./calc

section .data
    bem_vindo db "Chega ae",10,10,0
    Cgh equ $ - bem_vindo
    Entrada_1 db "Digite um número: ",0
    Enter_1 equ $ - Entrada_1
    Entrada_2 db "Digite outro número: ",0
    Enter_2 equ $ - Entrada_2
    Entrada_op db "Digite a operação (+,-,*,/): ",0
    Enter_op equ $ - Entrada_op
    Entrada_cont db "Deseja continuar? (s/n): ",0
    Enter_cont equ $ - Entrada_cont
    Resultado db "O resultado é: ",0
    Resul equ $ - Resultado
    Pula_linha db 10,10,0
    num_lin equ $ - Pula_linha

section .bss
    Num_1: resb 10
    Num_2: resb 10
    Oper: resb 2
    Cont: resb 2
    Res: resb 10 ; Reserva espaço para até 10 dígitos

section .text
    global _start
_start:
    mov rax, 1
    mov rdi, 1
    mov rsi, bem_vindo
    mov rdx, Cgh
    syscall

_loop:
    ; Solicita o primeiro número
    mov rax, 1
    mov rdi, 1
    mov rsi, Entrada_1
    mov rdx, Enter_1
    syscall

    mov rax, 0
    mov rdi, 0
    mov rsi, Num_1
    mov rdx, 10
    syscall

    ; Converte o primeiro número para um inteiro
    mov rsi, Num_1
    call string_to_int
    mov [Num_1], rax

    ; Solicita o segundo número
    mov rax, 1
    mov rdi, 1
    mov rsi, Entrada_2
    mov rdx, Enter_2
    syscall

    mov rax, 0
    mov rdi, 0
    mov rsi, Num_2
    mov rdx, 10
    syscall

    ; Converte o segundo número para um inteiro
    mov rsi, Num_2
    call string_to_int
    mov [Num_2], rax

    ; Solicita a operação
    mov rax, 1
    mov rdi, 1
    mov rsi, Entrada_op
    mov rdx, Enter_op
    syscall

    mov rax, 0
    mov rdi, 0
    mov rsi, Oper
    mov rdx, 2
    syscall

    ; Realiza a operação
    mov rax, [Num_1]
    mov rbx, [Num_2]
    cmp byte [Oper], '+'
    je _soma
    cmp byte [Oper], '-'
    je _sub
    cmp byte [Oper], '*'
    je _mul
    cmp byte [Oper], '/'
    je _div

_soma:
    add rax, rbx
    jmp _fim_op

_sub:
    sub rax, rbx
    jmp _fim_op

_mul:
    imul rax, rbx
    jmp _fim_op

_div:
    xor rdx, rdx
    div rbx
    jmp _fim_op

_fim_op:
    ; Converte o resultado para uma string
    mov rsi, Res
    call int_to_string

    ; Exibe o resultado
    mov rax, 1
    mov rdi, 1
    mov rsi, Resultado
    mov rdx, Resul
    syscall

    mov rax, 1
    mov rdi, 1
    mov rsi, Res
    mov rdx, 10 ; Assume que o resultado tem no máximo 10 dígitos
    syscall

    ; Quebra de linha após o resultado
    mov rax, 1
    mov rdi, 1
    mov rsi, Pula_linha
    mov rdx, num_lin
    syscall

    ; Pergunta se o usuário deseja continuar
    mov rax, 1
    mov rdi, 1
    mov rsi, Entrada_cont
    mov rdx, Enter_cont
    syscall

    mov rax, 0
    mov rdi, 0
    mov rsi, Cont
    mov rdx, 2
    syscall

    cmp byte [Cont], 's'
    je _loop

    ; Sai do programa
    mov rax, 60
    mov rdi, 0
    syscall

; Função para converter uma string em um número inteiro
string_to_int: 
    mov rax, 0
.next:
    mov dl, byte [rsi]
    inc rsi
    cmp dl, 48
    jl .fim
    cmp dl, 57
    jg .fim
    sub dl, 48
    imul rax, 10
    add rax, rdx
    jmp .next
.fim:
    ret

; Função para converter um número inteiro em uma string
int_to_string:
    add rsi, 9
    mov byte [rsi], 0
    mov rbx, 10
.prox_digito:
    xor edx, edx
    div rbx
    add dl, '0'
    dec rsi
    mov [rsi], dl
    test eax, eax
    jnz .prox_digito
    ret
