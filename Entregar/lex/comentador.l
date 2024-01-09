%{
#include <stdio.h>
#include <stdlib.h>

int total_letters = 0;
int comment_letters = 0;  
int comment_letters_global = 0;  

int contarLetras(const char* texto);

%}

%x INCOMMENTBLOCK INCOMMENTLINE

%%

"/*" {
    BEGIN(INCOMMENTBLOCK);
    printf("\nComentario en bloque: ");
    comment_letters = 0;
}

<INCOMMENTBLOCK>"*/" {
    BEGIN(INITIAL);
    printf("\nNúmero de letras en comentario en bloque: %d\n", comment_letters);
    comment_letters = 0;
}

<INCOMMENTBLOCK>[^*\n]+ {
    int letras_comentario = contarLetras(yytext);
    printf("%s", yytext);
    comment_letters += letras_comentario;
    comment_letters_global += letras_comentario;
}


<INCOMMENTBLOCK>\n {
    // No contar el salto de línea
}

"//" {
    BEGIN(INCOMMENTLINE);
    printf("\nComentario en línea: ");
}

<INCOMMENTLINE>\n {
    BEGIN(INITIAL);
    printf("\nNúmero de letras en comentario en línea: %d\n", comment_letters);
    comment_letters = 0;
}

<INCOMMENTLINE>[^\n]+ {
    printf("%s", yytext);
    comment_letters += contarLetras(yytext);
    comment_letters_global += contarLetras(yytext);
}

.|\n {
    total_letters += contarLetras(yytext);
}


%%

// sin salto de línea al final, solo cuento letras simbolos y numeros
int contarLetras(const char* texto) {
    int contador = 0;
    while (*texto) {
        if (*texto != '\n' && *texto != '\t' && *texto != ' ' && *texto != '\r') {
            contador++;
        }
        texto++;
    }
    return contador;
}

// conslato de linea
int main(int argc, char* argv[]) {
    printf("--------------------------------------------------\n");
    printf("DEBUG:\n");
    yylex();

    printf("\n--------------------------------------------------\n");
    printf("RESULTADO:\n");
    printf("\nNúmero total de letras en código: %d\n", total_letters);
    printf("Número total de letras en comentarios: %d\n", comment_letters_global );
    printf("Porcentaje de Comentarios: %.2f \%\n\n", (float)(comment_letters_global) / total_letters * 100);

    return EXIT_SUCCESS;
}

