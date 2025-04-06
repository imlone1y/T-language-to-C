%{
	/*引入標頭檔*/
	#include <stdio.h>
	#include <stdlib.h>
	#include "t2c.h"
	#include "t_parse.h"
%}

/*left 為解決語法衝突的問題，越下面宣告的優先順序越高*/
%token lWRITE lREAD lIF lASSIGN
%token lRETURN lBEGIN lEND
%left  lEQU lNEQ lGT lLT lGE lLE
%left  lADD lMINUS
%left  lTIMES lDIVIDE
%token lLP lRP
%token lINT lREAL lSTRING
%token lELSE
%token lMAIN
%token lSEMI lCOMMA
%token lID lINUM lRNUM lQSTR

%expect 1

%%
prog	:	mthdcls // program -> 需要是合法的 methods
		{ printf("Program -> MethodDecls\n");
		  printf("Parsed OK!\n"); }
	|
		{ printf("****** Parsing failed!\n"); }	
	;

mthdcls	:	mthdcl mthdcls // method declarations
		{ printf("MethodDecls -> MethodDecl MethodDecls\n"); }	
	|	mthdcl
		{ printf("MethodDecls -> MethodDecl\n"); }	
	;

type	:	lINT //型別可接受int
		{ printf("Type -> INT\n"); }	
	|	lREAL
		{ printf("Type -> REAL\n"); }	
	;

mthdcl	:	type lMAIN lID lLP formals lRP block // 方法宣告由資料型別開頭（如 INT）、方法名稱（lID）、括號包住的參數（formals）、再加上一個 block（方法內容）構成。
		{ printf("MethodDecl -> Type MAIN ID LP Formals RP Block\n"); }	
	|	type lID lLP formals lRP block
		{ printf("MethodDecl -> Type ID LP Formals RP Block\n"); }	
	;

formals	:	formal oformal
		{ printf("Formals -> Formal OtherFormals\n"); }	
	|
		{ printf("Formals -> \n"); }	
	;

formal	:	type lID // 單一參數
		{ printf("Formal -> Type ID\n"); }	
	;

oformal	:	lCOMMA formal oformal // 多個參數
		{ printf("OtherFormals -> COMMA Formal OtherFormals\n"); }	
	|
		{ printf("OtherFormals -> \n"); }	
	;

block 	:	lBEGIN stmts lEND
	  	{ printf("Block -> BEGIN Stmt END\n"); }
	;

stmts 	: 	stmt stmts
	  	{ printf("stmts -> stmt stmts\n"); }
	| 		stmt
	  	{ printf("stmts -> stmt\n"); }
	;

stmt	: 	assign_stmt
        { printf("stmt -> assign_stmt\n"); }
    | 		return_stmt
        { printf("stmt -> return_stmt\n"); }
    | 		local_vardecl
        { printf("stmt -> local_vardecl\n"); }
    | 		if_stmt
        { printf("stmt -> if_stmt\n"); }
    | 		write_stmt
        { printf("stmt -> write_stmt\n"); }
    | 		read_stmt
        { printf("stmt -> read_stmt\n"); }
    | 		block
        { printf("stmt -> block\n"); }
    ;

assign_stmt	: lID lASSIGN expr lSEMI // 賦值語句
        { printf("assign_stmt -> ID := expr ;\n"); }
    ;

return_stmt : lRETURN expr lSEMI // 回傳語句
        { printf("return_stmt -> RETURN expr ;\n"); }
    ;

local_vardecl : type lID lSEMI // 變數宣告
        { printf("local_vardecl -> type ID ;\n"); }
	| 			type lID lASSIGN expr lSEMI // 加這行處理 “ REAL z := 3.14;”
        { printf("local_vardecl -> type ID := expr ;\n"); }
    ;

if_stmt	: lIF lLP boolexpr lRP stmt lELSE stmt // 條件語句
        { printf("if_stmt -> IF ( boolexpr ) stmt ELSE stmt\n"); }
    | lIF lLP boolexpr lRP stmt
        { printf("if_stmt -> IF ( boolexpr ) stmt\n"); }
    ;

write_stmt : lWRITE lLP expr lCOMMA lQSTR lRP lSEMI // 輸出語句
        { printf("write_stmt -> WRITE ( expr , QSTR ) ;\n"); }
    ;

read_stmt  : lREAD lLP lID lCOMMA lQSTR lRP lSEMI // 輸入語句
        { printf("read_stmt -> READ ( ID , QSTR ) ;\n"); }
    ;

actuals	   : expr lCOMMA actuals
        { printf("actuals -> expr , actuals\n"); }
    | expr
        { printf("actuals -> expr\n"); }
    ;

expr	: expr lADD expr
		{ printf("expr -> expr + expr\n"); }
    | 	expr lMINUS expr 
		{ printf("expr -> expr - expr\n"); }
    | 	expr lTIMES expr 
		{ printf("expr -> expr * expr\n"); }
    | 	expr lDIVIDE expr
		{ printf("expr -> expr / expr\n"); }
   	| 	lINUM
		{ printf("expr -> INUM\n"); }
    | 	lRNUM
		{ printf("expr -> RNUM\n"); }
    | 	lID
		{ printf("expr -> ID\n"); }
    | 	lLP expr lRP
		{ printf("expr -> ( expr )\n"); }
	| 	lID lLP actuals lRP
        { printf("expr -> ID ( actuals )\n"); }
    | 	lID lLP lRP
        { printf("expr -> ID ( )\n"); }
    ;


boolexpr: expr lEQU expr 
		{ printf("boolexpr -> expr == expr\n"); }
    | 	expr lNEQ expr 
		{ printf("boolexpr -> expr != expr\n"); }
    | 	expr lGT expr  
		{ printf("boolexpr -> expr > expr\n"); }
    | 	expr lGE expr  
		{ printf("boolexpr -> expr >= expr\n"); }
    | 	expr lLT expr  
		{ printf("boolexpr -> expr < expr\n"); }
    | 	expr lLE expr  
		{ printf("boolexpr -> expr <= expr\n"); }
    ;


// Statements and Expressions

%%

int yyerror(char *s)
{
	printf("%s\n",s);
	return 1;
}

