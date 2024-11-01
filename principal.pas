unit principal;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, mod_Funcoes;

type

  { Tfrmprincipal }

  Tfrmprincipal = class(TForm)
    btnCadastrar: TButton;
    edtNome: TEdit;
    edtIdade: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    memLista: TMemo;
    procedure btnCadastrarClick(Sender: TObject);
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
     if((edtIdade.Text<>'')and(edtNome.Text<>'')and(IsInteger(edtIdade.Text)))then
     begin
          memLista.Lines.Add(FormataCampo(edtNome.Text,15)+edtIdade.Text);
     end;
end;

end.

