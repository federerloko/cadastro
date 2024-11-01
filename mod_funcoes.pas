unit mod_Funcoes;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils;

function IsInteger(value:string):Boolean;
function FormataCampo(value:string;tamanho:Integer):String;

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

end.

