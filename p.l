%{
#include <stdlib.h>
#include "calc3.h"
#include "y.tab.h"
void yyerror(char *);
%}

%%

0           {
                yylval.iValue = atoi(yytext);
                return INTEGER;
            }

[1-9][0-9]* {
                yylval.iValue = atoi(yytext);
                return INTEGER;
            }
			
[0-9]+\.[0-9]* {
                yylval.fValue = atof(yytext);
                return FLOAT;
            }
			
[-()<>=+*/;:{}.] {
                return *yytext;
             }

">="            return GE;
"<="            return LE;
"=="            return EQ;
"!="            return NE;
"&&"			return AND;
"||"			return OR;
"!"				return NOT;
"while"         return WHILE;
"if"            return IF;
"else"          return ELSE;
"print"         return PRINT;
"for"			return FOR;
"do" 			return DO;
"switch"		return SWITCH;
"case"			return CASE;
"break"			return BREAK;
"int"			return INT;
"float"			return FLOAT;
"char"			return CHAR;
"string"		return STRING;
"return"		return RETURN;

\"[a-zA-Z0-9 \t\n-()<>=+*/:.,_\@\#\$\%]+\"		return STRING;
\'[a-zA-Z]\'									return CHAR;

[a-zA-Z_]+  { 
                yylval.sIndex = *yytext - 'a';
                return VARIABLE;
            }

[ \t\n]+        ;       /* ignore whitespace */

.               yyerror("Unknown character");
%%
int yywrap(void) {
    return 1;
}
