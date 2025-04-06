/*這個檔案負責拆解文字後 傳給t_parse.y 負責檢查文字是後合法 */
/* definition area */
%{
#include "t2c.h"
#include "t_parse.h"
%}

%x C_COMMENT

ID  [A-Za-z][A-Za-z0-9]*
DIG [0-9][0-9]*
RNUM {DIG}"."{DIG}
NQUO [^"]

/* 回傳給t_parse.y 的 token */
/* rules area */
%%

WRITE		{return lWRITE;}
READ		{return lREAD;}
IF		{return lIF;}
ELSE		{return lELSE;}
RETURN		{return lRETURN;}
BEGIN		{return lBEGIN;}
END		{return lEND;}
MAIN		{return lMAIN;}
INT		{return lINT;}
REAL		{return lREAL;}
";"		{return lSEMI;}
","		{return lCOMMA;}
"("		{return lLP;}
")"		{return lRP;}
"+"		{return lADD;}
"-"		{return lMINUS;}
"*"		{return lTIMES;}
"/"		{return lDIVIDE;}
">"		{return lGT;}
"<"		{return lLT;}
":="		{return lASSIGN;}
"=="		{return lEQU;}
"!="		{return lNEQ;}
">="		{return lGE;}
"<="		{return lLE;}


{RNUM}  { sscanf(yytext, "%f", &rval); return lRNUM; }
{DIG}    { sscanf(yytext, "%d", &ival); return lINUM; }
{ID}    { strcpy(name, yytext); return lID; }
\"{NQUO}*\"	{sscanf(yytext,"%s", qstr); return lQSTR;}
"/*"		{ BEGIN(C_COMMENT); }
<C_COMMENT>"*/"	{ BEGIN(INITIAL); }


<C_COMMENT>\n	{ }
<C_COMMENT>.	{ }
[ \t\n]		{}
.		{}


%%

int yywrap() {return 1;}

void print_lex( int t ) {
    switch( t ) {
    case lWRITE: printf("WRITE\n");
        break;
    case lREAD: printf("READ\n");
        break;
    case lIF: printf("IF\n");
        break;
    case lELSE: printf("ELSE\n");
        break;
    case lRETURN: printf("RETURN\n");
        break;
    case lBEGIN: printf("BEGIN\n");
        break;
    case lEND: printf("END\n");
        break;
    case lMAIN: printf("MAIN\n");
        break;
    case lSTRING: printf("STRING\n");
        break;
    case lINT: printf("INT\n");
        break;
    case lREAL: printf("REAL\n");
        break;
    case lSEMI: printf("SEMI\n");
        break;
    case lCOMMA: printf("COMMA\n");
        break;
    case lLP: printf("LP\n");
        break;
    case lRP: printf("RP\n");
        break;
    case lADD: printf("ADD\n");
        break;
    case lMINUS: printf("MINUS\n");
        break;
    case lTIMES: printf("TIMES\n");
        break;
    case lDIVIDE: printf("DIVIDE\n");
        break;
    case lASSIGN: printf("ASSIGN\n");
        break;
    case lEQU: printf("EQU\n");
        break;
    case lNEQ: printf("NEQ\n");
        break;
    case lID: printf("ID(%s)\n", name);
        break;
    case lINUM: printf("INUM(%d)\n", ival);
        break;
    case lRNUM: printf("RNUM(%f)\n", rval);
        break;
    case lQSTR: printf("QSTR(%s)\n", qstr);
        break;
    default: printf("******** lexical error!!!");
    }
}

