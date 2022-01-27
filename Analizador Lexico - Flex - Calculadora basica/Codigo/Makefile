LEX=flex
CC=g++

expresiones: lex.yy.o
	$(CC) -o calculator lex.yy.o -lfl

lex.yy.o: lex.yy.cc
	$(CC) -c lex.yy.cc -lfl

lex.yy.cc: expresiones.l
	$(LEX) -+ expresiones.l

clean :
	-rm calculator lex.* salida_ejemplo.txt

ejemplo:
	make
	./calculator < instrucciones_ejemplo.txt > salida_ejemplo.txt
	cat salida_ejemplo.txt

run :
	make
	./calculator