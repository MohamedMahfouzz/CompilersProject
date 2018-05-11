
/* A Bison parser, made by GNU Bison 2.4.1.  */

/* Skeleton interface for Bison's Yacc-like parsers in C
   
      Copyright (C) 1984, 1989, 1990, 2000, 2001, 2002, 2003, 2004, 2005, 2006
   Free Software Foundation, Inc.
   
   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.
   
   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.
   
   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.
   
   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */


/* Tokens.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
   /* Put the tokens into the symbol table, so that GDB and other debuggers
      know about them.  */
   enum yytokentype {
     INTEGER = 258,
     FLOAT = 259,
     VARIABLE = 260,
     WHILE = 261,
     IF = 262,
     PRINT = 263,
     CASE = 264,
     DO = 265,
     FOR = 266,
     SWITCH = 267,
     BREAK = 268,
     RETURN = 269,
     STRING = 270,
     CHAR = 271,
     INT = 272,
     IFX = 273,
     ELSE = 274,
     NOT = 275,
     OR = 276,
     AND = 277,
     NE = 278,
     EQ = 279,
     LE = 280,
     GE = 281,
     UMINUS = 282
   };
#endif
/* Tokens.  */
#define INTEGER 258
#define FLOAT 259
#define VARIABLE 260
#define WHILE 261
#define IF 262
#define PRINT 263
#define CASE 264
#define DO 265
#define FOR 266
#define SWITCH 267
#define BREAK 268
#define RETURN 269
#define STRING 270
#define CHAR 271
#define INT 272
#define IFX 273
#define ELSE 274
#define NOT 275
#define OR 276
#define AND 277
#define NE 278
#define EQ 279
#define LE 280
#define GE 281
#define UMINUS 282




#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
typedef union YYSTYPE
{

/* Line 1676 of yacc.c  */
#line 19 "p.y"

    int iValue;                 /* integer value */
	float fValue;				/* float value */
    char sIndex;                /* symbol table index */
    nodeType *nPtr;             /* node pointer */



/* Line 1676 of yacc.c  */
#line 115 "y.tab.h"
} YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define yystype YYSTYPE /* obsolescent; will be withdrawn */
# define YYSTYPE_IS_DECLARED 1
#endif

extern YYSTYPE yylval;


