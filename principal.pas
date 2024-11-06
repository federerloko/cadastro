unit principal;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, mod_Funcoes;

type

  { Tfrmprincipal }

  Tfrmprincipal = class(TForm)
    btnCadastrar: TButton;
    btnSalvar: TButton;
    edtSalario: TEdit;
    edtNome: TEdit;
    edtIdade: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    memLista: TMemo;
    procedure btnCadastrarClick(Sender: TObject);
    procedure btnSalvarClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private

  public

  end;

var
  frmprincipal: Tfrmprincipal;

implementation

{$R *.lfm}

{ Tfrmprincipal }

procedure Tfrmprincipal.btnCadastrarClick(Sender: TObject);
begin
     if(edtSalario.Text = '')then
        edtSalario.Text:='0';

     if((edtIdade.Text<>'')and(edtNome.Text<>'')and(IsInteger(edtIdade.Text))and(IsFloat(edtSalario.Text)))then
     begin
          memLista.Lines.Add(FormataCampo(edtNome.Text,15)+FormataCampo(edtIdade.Text,4)+FormataMoeda(edtSalario.Text));
     end;
end;

procedure Tfrmprincipal.btnSalvarClick(Sender: TObject);
var
   stListaVirtual:TStringList;
   i:Integer;

   sNome,sIdade,sSalario,sLinhaVirtual:string;
begin
     try
        stListaVirtual:=TStringList.Create;

        for i:=0 to memLista.Lines.Count -1  do
        begin
             sNome:=Copy(memLista.Lines[i],1,15);
             sIdade:=Copy(memLista.Lines[i],16,4);
             sSalario:=Copy(memLista.Lines[i],20,Length(memLista.Lines[i]));

             sLinhaVirtual:=sNome+sIdade+SalarioNumero(sSalario);

             stListaVirtual.Add(sLinhaVirtual);
        end;

        stListaVirtual.SaveToFile('nomes_.txt');
     finally
        stListaVirtual.Free;
     end;

     {if(memLista.Lines.Count>0)then
        if(FileExists('nomes.txt'))then
           memLista.Lines.SaveToFile('nomes.txt')
        else
        begin
            ShowMessage('Arquivo de dados não existe. Será criado');
            memLista.Lines.SaveToFile('nomes.txt');
        end;}
end;

procedure Tfrmprincipal.FormCreate(Sender: TObject);
begin

end;

procedure Tfrmprincipal.FormShow(Sender: TObject);
var
   i:Integer;
begin
     if(FileExists('nomes.txt'))then
        memLista.Lines.LoadFromFile('nomes.txt');

     for i:=0 to memLista.Lines.Count-1 do
         if not(BuscaSalario(memLista.Lines[i]))then
            memLista.Lines[i]:=memLista.Lines[i]+'  S\ Salario Cadastrado';
end;

end.

