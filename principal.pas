unit principal;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, DBGrids,
  mod_Funcoes, endereco, SQLite3Conn, SQLDB, DB;

type

  { Tfrmprincipal }

  Tfrmprincipal = class(TForm)
    btnCadastrar: TButton;
    btnEndereco: TButton;
    grdPessoas: TDBGrid;
    dsPessoas: TDataSource;
    edtSalario: TEdit;
    edtNome: TEdit;
    edtIdade: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    conexao: TSQLite3Connection;
    qryID: TSQLQuery;
    qryPessoas: TSQLQuery;
    transacao: TSQLTransaction;
    procedure btnCadastrarClick(Sender: TObject);
    procedure btnEnderecoClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    function ProximoID(tabela:string):integer;
  private

  public

  end;

var
  frmprincipal: Tfrmprincipal;
  NomesCampos:array[0..3]of string=('Código','Nome','Idade','Salário');

implementation

{$R *.lfm}

{ Tfrmprincipal }



procedure Tfrmprincipal.btnCadastrarClick(Sender: TObject);
var
   sId,sNome,sSalario,sIdade,sSql:string;
begin


     try


        sId:=IntToStr(ProximoID('pessoas'));
        sNome:=QuotedStr(edtNome.Text);
        sSalario:=edtSalario.Text;
        sIdade:=edtIdade.Text;

        sSql:=Format('insert into pessoas values(%s,%s,%s,%s)',[sId,sNome,sIdade,sSalario]);

        transacao.EndTransaction;
        conexao.Transaction.StartTransaction;
        conexao.ExecuteDirect(sSql);
        conexao.Transaction.Commit;

        ShowMessage(sId+' Cadastrado com sucesso');

        qryPessoas.Open;


     except on E:Exception do
     begin

           conexao.Transaction.Rollback;
           ShowMessage('Erro ao cadastrar '+E.Message);
           Exit;
     end;
     end;
end;

procedure Tfrmprincipal.btnEnderecoClick(Sender: TObject);
var
   Dados:TEnderecoDados;
   sSql:string;
begin
     with TfrmEndereco.Create(nil) do
     try
        iIdPessoa:=qryPessoas.FieldByName('id').AsInteger;
        iIdEndereco:=ProximoID('enderecos');
        ShowModal;

        if(ModalResult = mrOK)then
        begin

              Dados:=DEndereco;
              with Dados do
                   sSql:=Format('insert into enderecos (id,id_pessoa,logradouro,complemento,cep,bairro,cidade,estado,numero,ativo) values(%d,%d,%s,%s,%s,%s,%s,%s,%s,%d)',
                   [iIdEndereco,iIdPessoa,Logradouro,Complemento,CEP,Bairro,Cidade,Estado,Numero,Ativo]);

              try


                 transacao.EndTransaction;
                 conexao.Transaction.StartTransaction;
                 conexao.ExecuteDirect(sSql);
                 conexao.Transaction.Commit;

              except on E:exception do
              begin

                    transacao.Rollback;
                    ShowMessage(e.Message);

              end;

             end;
        end;

     finally
        Free;
     end;

end;


procedure Tfrmprincipal.FormActivate(Sender: TObject);
var
   i:integer;
begin

     transacao.Active:=false;

     qryPessoas.SQL.Add('select * from pessoas');
     qryPessoas.Open;

     if(qryPessoas.RecordCount > 0)then
       for i:=0 to qryPessoas.FieldCount -1 do
           with grdPessoas.Columns.Add do
           begin
                 FieldName:=qryPessoas.Fields[i].FieldName;
                 if(qryPessoas.Fields[i].DataType = ftString)then
                    Width:=160
                 else
                    Width:=80;

                 if(qryPessoas.Fields[i].DataType = ftLargeint)then
                    DisplayFormat:='R$ 0.00';

                 Title.Caption:=NomesCampos[i];
           end;
end;

procedure Tfrmprincipal.FormCreate(Sender: TObject);
begin

end;

function Tfrmprincipal.ProximoID(tabela: string): integer;
begin
     try
        try

          qryID.SQL.Clear;
          qryID.SQL.Add('select max(id) from '+tabela);
          qryID.Open;

          if(qryID.RecordCount > 0)and (qryID.Fields[0].Value <> null) then

             Result:=qryID.Fields[0].AsInteger + 1
          else
             Result:=1;
        except
              Exit;
        end;
     finally
        qryID.Close;
     end;
end;

end.

