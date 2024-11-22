unit endereco;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ComCtrls,
  mod_Funcoes;

type
    TEnderecoDados = record
       Logradouro:string;
       Numero:string;
       Complemento:string;
       CEP:string;
       Bairro:string;
       Cidade:string;
       Estado:string;
       Ativo:Int64;
    end;

type

  { TfrmEndereco }

  TfrmEndereco = class(TForm)
    btncadastrar: TButton;
    edtCEP: TEdit;
    edtCidade: TEdit;
    edtEstado: TEdit;
    edtComplemento: TEdit;
    edtNumero: TEdit;
    edtBairro: TEdit;
    edtLogradouro: TEdit;
    StatusBar1: TStatusBar;
    procedure btncadastrarClick(Sender: TObject);
    procedure edtLogradouroExit(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private

  public

  end;

var
  frmEndereco: TfrmEndereco;
  iIdPessoa:integer;
  iIdEndereco:integer;
  DEndereco:TEnderecoDados;

implementation

{$R *.lfm}

{ TfrmEndereco }

procedure TfrmEndereco.FormCreate(Sender: TObject);
begin

end;

procedure TfrmEndereco.FormActivate(Sender: TObject);
begin
     StatusBar1.Panels[0].Text:='Código da pessoa: '+IntToStr(iIdPessoa)+'Endereço ID: '+IntToStr(iIdEndereco);
     LimpaEdits(Self);
end;

procedure TfrmEndereco.edtLogradouroExit(Sender: TObject);
begin
     if(TEdit(Sender).Text='')then
     begin
          ShowMessage('Preencha o campo');
          TEdit(Sender).SetFocus;
     end;
end;

procedure TfrmEndereco.btncadastrarClick(Sender: TObject);
begin
     DEndereco.Ativo:=1;
     DEndereco.Bairro:=QuotedStr(edtBairro.Text);
     DEndereco.CEP:=QuotedStr(edtCEP.Text);
     DEndereco.Cidade:=QuotedStr(edtCidade.Text);
     DEndereco.Complemento:=QuotedStr(edtComplemento.Text);
     DEndereco.Estado:=QuotedStr(edtEstado.Text);
     DEndereco.Logradouro:=QuotedStr(edtLogradouro.Text);
     DEndereco.Numero:=QuotedStr(edtNumero.Text);

     ModalResult:=mrOK;
end;

end.

