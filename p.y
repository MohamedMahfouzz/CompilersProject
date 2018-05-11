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
        function                				{ exit(0); }
        ;

function:
          function stmt         				{ printf("function \n"); }
        | /* NULL */
        ;
		
func:	
		types VARIABLE '(' params ')' '{' func_b RETURN expr ';' '}'						{ printf("Func\n"); }
		  
params:
		  types VARIABLE ',' params				{ printf("Params\n"); }
		| types VARIABLE						{ printf("Params\n"); }
		|										{ printf("Params: empty\n"); }
		;
		
func_b:	
		stmt func_b								{ printf("Func_Body\n"); }
		|										{ printf("Func_Body: empty\n"); }
		;

stmt:
          ';'                            		{ printf("Stmt: \n"); }
        | expr ';'                       		{ printf("Stmt: expr\n"); }
        | PRINT expr ';'                 		{ printf("Stmt: print expr\n"); }
        | VARIABLE '=' expr ';'          		{ printf("Stmt: var = expr\n"); }
        | WHILE '(' expr ')' stmt        		{ printf("Stmt: While\n"); }
        | IF '(' expr ')' stmt %prec IFX 		{ printf("Stmt: if \n"); }
        | IF '(' expr ')' stmt ELSE stmt 		{ printf("Stmt: if else \n"); }
        | '{' stmt_list '}'              		{ printf("Stmt: list \n"); }
		| DO stmt WHILE '(' expr ')'			{ printf("Stmt: Do While \n"); } 
		| FOR '(' types VARIABLE '=' expr ';' expr ';' expr ')' stmt		{ printf("Stmt: For v1 \n"); }
		| FOR '(' VARIABLE '=' expr ';' expr ';' expr ')' stmt				{ printf("Stmt: For v2 \n"); }
		| FOR '(' VARIABLE ';' expr ';' expr ')' stmt						{ printf("Stmt: For v3 \n"); }
		| SWITCH '(' expr ')' stmt				{ printf("Stmt: SWITCH \n"); }
		| CASE expr ':' stmt					{ printf("Stmt: case \n"); }
		| CASE '(' expr ')' ':' stmt			{ printf("Stmt: case \n"); }
		| types VARIABLE '=' expr ';'			{ printf("Stmt: type variable = expr\n"); }
		| types VARIABLE ';'					{ printf("Stmt: type variable\n"); }
		| types VARIABLE '=' VARIABLE ';'		{ printf("Stmt: type variable = variable\n"); }
		| VARIABLE '=' VARIABLE ';'				{ printf("Stmt: variable = variable\n"); }
        ;

stmt_list:
          stmt                  { printf("Stmt_list: stmt\n"); }
        | stmt_list stmt        { printf("Stmt_list: stmt_list stmt\n"); }
        ;

expr:
          INTEGER               { printf("expr: INTEGER\n"); }
		| values				{ printf("expr: values\n"); }
        | VARIABLE      		{ printf("expr: Variable\n"); }
        | '-' expr %prec UMINUS { printf("expr: meh\n"); }
        | expr '+' expr         { printf("expr: +\n"); }
        | expr '-' expr         { printf("expr: -\n"); }
        | expr '*' expr         { printf("expr: *\n"); }
        | expr '/' expr         { printf("expr: /\n"); }
        | expr '<' expr         { printf("expr: <\n"); }
        | expr '>' expr         { printf("expr: >\n"); }
        | expr GE expr          { printf("expr: >=\n"); }
        | expr LE expr          { printf("expr: <=\n"); }
        | expr NE expr          { printf("expr: !=\n"); }
        | expr EQ expr          { printf("expr: ==\n"); }
        | '(' expr ')'          { printf("expr: (expr)\n"); }
		| expr AND expr			{ printf("expr: &&\n"); }
		| expr OR expr			{ printf("expr: ||\n"); }
		| NOT expr				{ printf("expr: !\n"); }
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
		
for_stmt: expr ';'				{ printf("FOR expr\n"); }
		| expr ';' for_stmt		{ printf("Types: INT\n"); }
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
