unit endereco;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls;

type

  { TfrmEndereco }

  TfrmEndereco = class(TForm)
    Label1: TLabel;
    procedure FormActivate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private

  public

  end;

var
  frmEndereco: TfrmEndereco;
  iIdPessoa:integer;

implementation

{$R *.lfm}

{ TfrmEndereco }

procedure TfrmEndereco.FormCreate(Sender: TObject);
begin

end;

procedure TfrmEndereco.FormActivate(Sender: TObject);
begin
  Label1.Caption:='Código da pessoa: '+IntToStr(iIdPessoa);
end;

end.

