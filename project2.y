%{
#include <stdio.h>
#include <stdlib.h>
#include <stdarg.h>
#include "calc3.h"

/* prototypes */
nodeType *opr(int oper, int nops, ...);
nodeType *id(int i);
nodeType *con(int value);
void freeNode(nodeType *p);
int ex(nodeType *p);
int yylex(void);

void yyerror(char *s);
int sym[26];                    /* symbol table */
%}

%union {
    int iValue;                 /* integer value */
	float fValue;				/* float value */
    char sIndex;                /* symbol table index */
    nodeType *nPtr;             /* node pointer */
};

%token <iValue> INTEGER
%token <fValue> FLOAT
%token <sIndex> VARIABLE
%token WHILE IF PRINT CASE DO FOR SWITCH BREAK RETURN STRING CHAR INT
%nonassoc IFX
%nonassoc ELSE

%left GE LE EQ NE '>' '<' AND OR NOT
%left '+' '-'
%left '*' '/'
%nonassoc UMINUS

%type <nPtr> stmt expr stmt_list

%%

program:
        function                { exit(0); }
        ;

function:
          function stmt         { ex($2); freeNode($2); }
        | /* NULL */
        ;

stmt:
          ';'                            		{ $$ = opr(';', 2, NULL, NULL); }
        | expr ';'                       		{ $$ = $1; }
        | PRINT expr ';'                 		{ $$ = opr(PRINT, 1, $2); }
        | types VARIABLE '=' expr ';'          	{ $$ = opr('=', 2, id($1), $3); }
        | WHILE '(' expr ')' stmt        		{ $$ = opr(WHILE, 2, $3, $5); }
        | IF '(' expr ')' stmt %prec IFX 		{ $$ = opr(IF, 2, $3, $5); }
        | IF '(' expr ')' stmt ELSE stmt 		{ $$ = opr(IF, 3, $3, $5, $7); }
        | '{' stmt_list '}'              		{ $$ = $2; }
		| DO stmt WHILE '(' expr ')'			{ $$ = opr(DO, 2, $2, $5); } 
		| FOR '(' stmt_list ')' stmt			{ $$ = opr(FOR, 2, $3, $5); }
		| SWITCH '(' expr ')' stmt				{ $$ = opr(SWITCH, 2, $3, $5); }
		| CASE expr ':' stmt					{ $$ = opr(CASE, 2, $2, $4); }
        ;

stmt_list:
          stmt                  { $$ = $1; }
        | stmt_list stmt        { $$ = opr(';', 2, $1, $2); }
        ;

expr:
          INTEGER               { $$ = con($1); }
		| values				{ $$ = $1; }
        | types VARIABLE        { $$ = id($1); }
        | '-' expr %prec UMINUS { $$ = opr(UMINUS, 1, $2); }
        | expr '+' expr         { $$ = opr('+', 2, $1, $3); }
        | expr '-' expr         { $$ = opr('-', 2, $1, $3); }
        | expr '*' expr         { $$ = opr('*', 2, $1, $3); }
        | expr '/' expr         { $$ = opr('/', 2, $1, $3); }
        | expr '<' expr         { $$ = opr('<', 2, $1, $3); }
        | expr '>' expr         { $$ = opr('>', 2, $1, $3); }
        | expr GE expr          { $$ = opr(GE, 2, $1, $3); }
        | expr LE expr          { $$ = opr(LE, 2, $1, $3); }
        | expr NE expr          { $$ = opr(NE, 2, $1, $3); }
        | expr EQ expr          { $$ = opr(EQ, 2, $1, $3); }
        | '(' expr ')'          { $$ = $2; } 
		| expr AND expr			{ $$ = opr(AND, 2, $1, $3); }
		| expr OR expr			{ $$ = opr(OR, 2, $1, $3); }
		| NOT expr				{ $$ = opr(NOT, 1, $2); }
        ;
		
values:
		  INTEGER				{ printf("Values: INTEGER\n"); }
		| FLOAT					{ printf("Values: FLOAT\n"); }
		| CHAR					{ printf("Values: CHAR\n"); }
		| STRING				{ printf("Values: STRING\n"); }
		;
types:
		  INT					{ printf("Types: INT\n"); }
		| FLOAT					{ printf("Types: FLOAT\n"); }
		| CHAR					{ printf("Types: CHAR\n"); }
		| STRING				{ printf("Types: STRING\n"); }
		;

%%

nodeType *con(int value) {
    nodeType *p;

    /* allocate node */
    if ((p = malloc(sizeof(nodeType))) == NULL)
        yyerror("out of memory");

    /* copy information */
    p->type = typeCon;
    p->con.value = value;

    return p;
}

nodeType *id(int i) {
    nodeType *p;

    /* allocate node */
    if ((p = malloc(sizeof(nodeType))) == NULL)
        yyerror("out of memory");

    /* copy information */
    p->type = typeId;
    p->id.i = i;

    return p;
}

nodeType *opr(int oper, int nops, ...) {
    va_list ap;
    nodeType *p;
    int i;

    /* allocate node, extending op array */
    if ((p = malloc(sizeof(nodeType) + (nops-1) * sizeof(nodeType *))) == NULL)
        yyerror("out of memory");

    /* copy information */
    p->type = typeOpr;
    p->opr.oper = oper;
    p->opr.nops = nops;
    va_start(ap, nops);
    for (i = 0; i < nops; i++)
        p->opr.op[i] = va_arg(ap, nodeType*);
    va_end(ap);
    return p;
}

void freeNode(nodeType *p) {
    int i;

    if (!p) return;
    if (p->type == typeOpr) {
        for (i = 0; i < p->opr.nops; i++)
            freeNode(p->opr.op[i]);
    }
    free (p);
}

void yyerror(char *s) {
    fprintf(stdout, "%s\n", s);
}

int main(void) {
    yyparse();
    return 0;
}
