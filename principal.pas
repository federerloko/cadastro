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
    btnSalvar: TButton;
    btnEndereco: TButton;
    grdPessoas: TDBGrid;
    dsPessoas: TDataSource;
    edtSalario: TEdit;
    edtNome: TEdit;
    edtIdade: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    memLista: TMemo;
    conexao: TSQLite3Connection;
    qryID: TSQLQuery;
    qryPessoas: TSQLQuery;
    transacao: TSQLTransaction;
    procedure btnCadastrarClick(Sender: TObject);
    procedure btnEnderecoClick(Sender: TObject);
    procedure btnSalvarClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    function ProximoID:integer;
  private

  public

  end;

var
  frmprincipal: Tfrmprincipal;

implementation

{$R *.lfm}

{ Tfrmprincipal }



procedure Tfrmprincipal.btnCadastrarClick(Sender: TObject);
var
   sId,sNome,sSalario,sIdade,sSql:string;
begin
     if(edtSalario.Text = '')then
        edtSalario.Text:='0';

     if((edtIdade.Text<>'')and(edtNome.Text<>'')and(IsInteger(edtIdade.Text))and(IsFloat(edtSalario.Text)))then
     begin
          memLista.Lines.Add(FormataCampo(edtNome.Text,15)+FormataCampo(edtIdade.Text,4)+FormataMoeda(edtSalario.Text));
     end;

     try
        sId:=IntToStr(ProximoID);
        sNome:=QuotedStr(edtNome.Text);
        sSalario:=edtSalario.Text;
        sIdade:=edtIdade.Text;

        sSql:=Format('insert into pessoas values(%s,%s,%s,%s)',[sId,sNome,sIdade,sSalario]);

        conexao.Transaction.Rollback;
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
begin
     with TfrmEndereco.Create(nil) do
     try
        iIdPessoa:=qryPessoas.FieldByName('id').AsInteger;
        ShowModal;
     finally
        Free;
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

procedure Tfrmprincipal.FormActivate(Sender: TObject);
begin
     qryPessoas.SQL.Add('select * from pessoas');
     qryPessoas.Open;
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

function Tfrmprincipal.ProximoID: integer;
begin
     qryID.Close;
     qryID.SQL.Clear;
     qryID.SQL.Add('select max(id) from pessoas');
     qryID.Open;

     if(qryID.RecordCount > 0)and (qryID.Fields[0].Value <> null) then

           Result:=qryID.Fields[0].AsInteger + 1
     else
         Result:=1;
end;

end.

