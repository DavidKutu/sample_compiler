%{
	#include <stdio.h>
	#include <stdlib.h>
	#include <string.h>

	//printf("%.*s\n",strlen($3)-2,$3+1);
	void fixString(char *str);
	void yyerror (char *s);
%}

%union
{
	int integer;
	float floatnum;
	char *charac;
	char *id; 
	char *string;
}

%start LINEA
%token print
%token <floatnum> FLOAT
%token <integer> CTE_INT
%token <charac> CTE_CHAR
%token <id> ID
%token <string> STRING

%type <integer> LINEA EXP DESPLIEGUE

%%

LINEA		:EXP ';'						{printf("%d\n",$1);}
			|DESPLIEGUE ';'					{;}
			|LINEA EXP ';'					{printf("%d\n",$2);}
			|LINEA DESPLIEGUE ';'			{;} 
			;

EXP			:CTE_INT 						{$$ = $1;}
			|CTE_INT '+' EXP				{$$ = $1 + $3;}
			|CTE_INT '-' EXP				{$$ = $1 - $3;}
			|CTE_INT '*' EXP				{$$ = $1 * $3;}
			|CTE_INT '/' EXP				{$$ = $1 / $3;}
			;

DESPLIEGUE 	:print '(' EXP ')'				{printf("%d\n",$3);}
			|print '(' STRING ')'			{fixString($3);
											 printf("%s\n",$3);}
			|print '(' CTE_CHAR ')'			{fixString($3);
											 printf("%s\n",$3);}
			;

%%

void fixString(char *str)
{
	size_t len=strlen(str);
	memmove(str,str+1,len);
	str[len-2]=0;
}

void yyerror (char *s) 
{
	printf("%s\n", s);
}

int main(void)
{
	return yyparse();
}