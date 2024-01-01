all: comentador

comentador: lex.yy.c
	gcc -o comentador lex.yy.c -lfl

lex.yy.c: comentador.l
	flex comentador.l

run: comentador
	./comentador < ./ejemplos/ejemplo1.c
	./comentador < ./ejemplos/ejemplo2.c
