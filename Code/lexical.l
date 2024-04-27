%option yylineno
%{
#include<stdio.h> 

FILE *outputFile;
%}
ws [ \t]
digit [0-9]
letter [_a-zA-Z]
ld[0-9_a-zA-Z]
nonletter [^_a-zA-Z]
RELOP 	>|<|>=|<=|==|!=
IF if
ELSE else
WHILE while
TYPE int|float
CONST const
STRUCT struct
RETURN return
PLUS "+"
MINUS "-"
STAR "*"
DIV "/"
AND "&&"
OR "||"
NOT "!"
DOT "."
SEMI ";"
COMMA ","
ASSIGNOP "="
LP "("
RP ")"
LB "["
RB "]"
LC "{"
RC "}"
ID {letter}{ld}*
INT 0|[+-]?[1-9]+[0-9]*
OINT [+-]?0[0-7]+
NOINT [+-]?0([89]+|[0-7]+[89]+)
HINT [+-]?[xX][a-fA-F0-9]+
NHINT [+-]?0[xX]([g-zG-Z]+|[a-fA-F0-9]+[g-zG-Z]+)
FLOAT [+-]?({digit}+\.{digit}+|{digit}+\.|\.{digit}+)
EFLOAT ({INT}|{FLOAT})[eE][+-]?{digit}+
NEFLOAT ({INT}|{FLOAT})[eE][+-]?
%%
{ws}+ {;}
[\n\r] {;}
{IF} {fprintf(outputFile, "IF,%s\n", yytext);}
{ELSE} {fprintf(outputFile, "ELSE,%s\n", yytext);}
{WHILE} {fprintf(outputFile, "WHILE,%s\n", yytext);}
{TYPE} {fprintf(outputFile, "TYPE,%s\n", yytext);}
{CONST} {fprintf(outputFile, "CONST,%s\n", yytext);}
{STRUCT} {fprintf(outputFile, "STRUCT,%s\n", yytext);}
{RETURN} {fprintf(outputFile, "RETURN,%s\n", yytext);}
{RELOP} {fprintf(outputFile, "RELOP,%s\n", yytext);}

{PLUS} {fprintf(outputFile, "PLUS,%s\n", yytext);}
{MINUS} {fprintf(outputFile, "MINUS,%s\n", yytext);}
{STAR} {fprintf(outputFile, "STAR,%s\n", yytext);}
{DIV} {fprintf(outputFile, "DIV,%s\n", yytext);}
{AND} {fprintf(outputFile, "AND,%s\n", yytext);}
{OR} {fprintf(outputFile, "OR,%s\n", yytext);}
{NOT} {fprintf(outputFile, "NOT,%s\n", yytext);}

{DOT} {fprintf(outputFile, "DOT,%s\n", yytext);}
{SEMI} {fprintf(outputFile, "SEMI,%s\n", yytext);}
{COMMA} {fprintf(outputFile, "COMMA,%s\n", yytext);}
{ASSIGNOP} {fprintf(outputFile, "ASSIGNOP,%s\n", yytext);}

{LP} {fprintf(outputFile, "LP,%s\n", yytext);}
{RP} {fprintf(outputFile, "RP,%s\n", yytext);}
{LB} {fprintf(outputFile, "LB,%s\n", yytext);}
{RB} {fprintf(outputFile, "RB,%s\n", yytext);}
{LC} {fprintf(outputFile, "LC,%s\n", yytext);}
{RC} {fprintf(outputFile, "RC,%s\n", yytext);}

{INT} {fprintf(outputFile, "INT,%s\n", yytext);}
{OINT} {fprintf(outputFile, "OINT,%s\n", yytext);}
{NOINT} {fprintf(outputFile, "Error type A at Line %d: Illegal octal number \"%s\".\n",yylineno, yytext);}
{HINT} {fprintf(outputFile, "HINT,%s\n", yytext);}
{NHINT} {fprintf(outputFile, "Error type A at Line %d: Illegal hexadecimal number \"%s\".\n",yylineno, yytext);}
{FLOAT} {fprintf(outputFile, "FLOAT,%s\n", yytext);}
{EFLOAT} {fprintf(outputFile, "EFLOAT,%s\n", yytext);}
{NEFLOAT} {fprintf(outputFile, "Error type A at Line %d: Illegal floating point number \"%s\".\n",yylineno, yytext);}
{ID} {fprintf(outputFile, "ID,%s\n", yytext);}


\"[^\"]*\" {
if (yytext[yyleng - 2] == '\\') {
yyless(yyleng - 1);
yymore();
} else {
fprintf(outputFile, "CONSTCHAR,%s\n",yytext);
}
}

"//" {
char c = input();
while (c != '\n') c = input();
}

"/*" {
char c = input();
while (c != 0){
  if(c=='*'){
    c=input();
    if(c=='/')break;
  }
  else c=input();
}
}

{digit}+{ID} { fprintf(outputFile, "Error type A at Line %d: Illegal ID \"%s\".\n",yylineno, yytext);}

. {
fprintf(outputFile, "Error type A at Line %d: Mysterious characters '%s'\n", yylineno, yytext);
}

%%
int main(int argc, char** argv) {
    outputFile = fopen("output.txt", "w");
    if (!outputFile) {
        perror("Failed to open output file");
        return 1;
    }

    if (argc > 1) {
        if (!(yyin = fopen(argv[1], "r"))) {
            perror(argv[1]);
            fclose(outputFile);
            return 1;
        }
    }

    yylex();

    fprintf(outputFile, "%d", yylineno);
    fclose(outputFile); 
    return 0;
}