%{
   int num_lines;
   FILE *errors_file;
   int reel;
%}

ERREUR_CHAINE ["].*
CHAINE ["].*[a-zA-Z0-9 ]*.*["]

ERREUR_REEL [+-]?[0-9]*[.][0-9]*e
REEL [+-]?[0-9]*[.][0-9]*e?[+-]?[0-9]+

ENTIER [+-]?[0-9]+
ERREUR_ENTIER [+-].*
IDENTIFICATEUR [a-zA-Z_]+[a-zA-Z0-9]*
COMMENTAIRE [#][ ]*[a-zA-Z0-9]*
MCLEF ("else"|"while"|"if")
WHILE .


%%
\n ++num_lines;
{REEL}   {printf("REEL : %s\n",yytext);reel++;}
{ERREUR_REEL} {fprintf(errors_file, "%s *** ligne %d *** exposant attendu\n",yytext,num_lines);}
{ENTIER} {printf("ENTIER : %s\n",yytext);}
{ERREUR_ENTIER} fprintf(errors_file, "%s *** ligne %d *** nombre attendue\n",yytext,num_lines);
{CHAINE} {printf("CHAINE : %s\n",yytext);}
{ERREUR_CHAINE} {fprintf(errors_file, "%s *** ligne %d *** fin de chaine attendue\n",yytext,num_lines);}

{MCLEF} {printf("MCLEF : %s\n",yytext);}
{IDENTIFICATEUR} {printf("IDENT : %s\n",yytext);}
{COMMENTAIRE} {printf("CMT : %s\n",yytext);}
. printf("caractere incorrect \n");
%%

int yywrap(){
return 1;
}

int main(int argc, char *argv[]){
    num_lines = 1;
    errors_file = fopen("compilation_erros_output.txt","w+");
    yyin = fopen(argv[1], "r");
    printf("nombre de reel est : %d\n",reel);
	yylex();
    fclose(errors_file);
    fclose(yyin);
	return 0;
}
