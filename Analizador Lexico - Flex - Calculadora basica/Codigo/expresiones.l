%{
    #include <stack>
    #include <vector>
    #include <iostream>
    #include <string>
    #include <map>

    #define toFloat(cadena) ((float)strtod(cadena,NULL))
    #define printn(cadena) (printf("He leido el numero %s\n",cadena))

    using namespace std;

    bool sum = 0;
    bool rest = 0;
    bool mult = 0;
    bool divi = 0;
    bool asignarVariable = 0;

    stack<float> pila;
    vector<pair<string, float>> mem;
    map<string, float> variables;
    string variable;
    
    float returnSol();
    void limpiarPila();
    void returnMemoria();
    void returnVariables();
    int memint(char* a);
    string popback(char* cstr);

%}

%option noyywrap c++
variable     ([A-Z][a-z]*)
asigVariable {variable}"="

ent          [0-9]*
numdec       {ent}"."{ent}
num          "-"?{ent}|{numdec}
memnum       "["{ent}"]"

sum          "suma"|"SUMA"|"sum"|"SUM"|"add"|"ADD"
mul          "multiplica"|"mult"|"multi"|"MULTIPLICA"|"MULT"|"MULTI"
res          "resta"|"rest"|"sub"|"substract"|"RESTA"|"REST"|"SUBSTRACT"|"SUB"
divi         "divide"|"div"|"DIVIDE"|"DIV"
peticion     ["MUESTRA ""muestra ""MUESTRAME ""muestrame ""dame ""DAME ""quiero ""QUIERO ""Enseña ""Enseñame ""enseña ""enseñame""ENSEÑAME ""ENSEÑA "]
memoria      ({peticion}"la memoria")|"mem"|"memoria"
variables    ({peticion}"las variables")|"vars"|"variables"


%%
{sum}           {sum  = 1; limpiarPila();}
{mul}           {mult = 1; limpiarPila();}
{res}           {rest = 1; limpiarPila();}
{divi}          {divi = 1; limpiarPila();}

{memoria}       {returnMemoria();}
{variables}     {returnVariables();}

{variable}      {if( sum || rest || mult || divi )pila.push(variables[string(yytext)]); else cout << "Variable <" << yytext << "> = " << variables[string(yytext)]<< endl; if(pila.size() >= 2) returnSol();}
{asigVariable}  {asignarVariable = 1; variable = popback(yytext);}

{num}           {if( sum || rest || mult || divi ) pila.push(toFloat(yytext)); else if(asignarVariable) {variables[variable] = toFloat(yytext); asignarVariable=0;} else printn(yytext); if(pila.size() >= 2) returnSol();}
{memnum}        {if(memint(yytext)<0 || memint(yytext)>mem.size() || mem.size()==0) cout << "ERROR: indice de memoria fuera de rango" << endl; else if( sum || rest || mult || divi ) pila.push(mem[memint(yytext)].second); else if(asignarVariable) {variables[variable] = mem[memint(yytext)].second; asignarVariable=0;} else printn(yytext); if(pila.size() >= 2) returnSol();}

[ \t]           {}
\n              {}
\n\n            {sum=0;mult=0;rest=0;divi=0;asignarVariable=0; cout << "**RESETEO**"<<endl;}
%% 

float returnSol(){
    float a, b, sol=0;
    string toMem;
    pair<string,float> par;

    //Extraccion de operandos
    a = pila.top();pila.pop();
    b = pila.top();pila.pop();
    limpiarPila();

    //Clasificación de operación
    if( sum ){       
        sol = b + a; //operación
        toMem = to_string(b) + " + " + to_string(a) + " = " +to_string(sol); //Almacenaje en memoria
    }
    else if( rest ){ 
        sol = b - a;
        toMem = to_string(b) + " - " + to_string(a) + " = " +to_string(sol);
    }
    else if( mult ){ 
        sol = b * a;
        toMem = to_string(b) + " * " + to_string(a) + " = " +to_string(sol);
    }
    else if( divi ){ 
        sol = b / a;
        toMem = to_string(b) + " / " + to_string(a) + " = " +to_string(sol);
    }

   par.first = toMem;
   par.second = sol;
   mem.push_back(par);

    sum  = 0;
    mult = 0;
    rest = 0;
    divi  = 0;
  
    cout << "Resultado de " << toMem << endl;

    return sol;
}

void limpiarPila(){
    while(!pila.empty()) pila.pop();
}

void returnMemoria(){
    int i = 0;
    cout << endl <<"    # Memoria" << endl;
    for(auto sol : mem){ 
        cout << "   # [" << i << "] " << sol.first << endl;
        i++;
    }
}

void returnVariables(){
    cout << endl << "    # Variables almacenadas" << endl;
    for(auto variable: variables)
        cout << "   # " << variable.first << " = " << variable.second << endl;
}

int memint(char* a){
    string s(a); //Lo convierto a string
    string num = s.substr(1,s.size()-2); //Extraigo el numero dentro de los corchetes 
    return stoi(num);
}

string popback(char* cstr){
    string str = string(cstr);
    str.pop_back();
    return str;
}

int main(int /* argc */, char** /* argv */){
    FlexLexer* lexer = new yyFlexLexer;
        while(lexer->yylex() != 0)
            ;
        return 0;
}