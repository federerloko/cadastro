unit mod_Funcoes;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils;

function IsInteger(value:string):Boolean;
function IsFloat(value:string):Boolean;
function FormataCampo(value:string;tamanho:Integer):String;
function FormataMoeda(value:string):string;
function BuscaSalario(sValorLinha:string):boolean;
function SalarioNumero(value:string):string;

implementation

function IsInteger(value: string): Boolean;
var
   iValue:integer;
begin
     try
        iValue:=StrToInt(value);
        Result:=True;
     except
        Result:=False;
     end;
end;

function IsFloat(value: string): Boolean;
var
   fValue:Real;
begin
     if(value <> '')then
        try
           fValue:=StrToFloat(value);
           Result:=True;
        except
           Result:=False;
        end;

end;

function FormataCampo(value: string; tamanho: Integer): String;
var
   iDif:Integer;
   sSpaces:string;
begin
     sSpaces:='';

     if(Length(value)>=tamanho)then
       Result:=Copy(value,1,tamanho-1)+' '
     else
     begin

          iDif:=tamanho-Length(value);
          sSpaces:=StringOfChar(' ',iDif);

          Result:=value+sSpaces;
     end;

end;

function FormataMoeda(value: string): string;
var
   fValue:Real;
begin
     fValue:=StrToFloat(value);
     Result:=FormatFloat('R$ 0.00',fValue);
end;

function BuscaSalario(sValorLinha: string): boolean;
begin
     Result:=(Length(sValorLinha)>19);
end;

function SalarioNumero(value: string): string;
var
   sSalario:string;
begin

     if(Pos('R$',value)>0)then
     begin
        sSalario:=Copy(value,4,Length(value));
        if(IsFloat(sSalario))then
           Result:=sSalario;
     end
     else
         if(IsFloat(value))then
            Result:=value
         else
             Result:='0';
end;

end.

