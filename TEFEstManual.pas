unit TEFEstManual;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.DBCtrls, Vcl.Mask,
  Vcl.ExtCtrls, Data.DB, Datasnap.DBClient, Vcl.Buttons;
  Procedure EstornoManual;

type
  TFTEFEstManual = class(TForm)
    CDEstorno: TClientDataSet;
    DSEstorno: TDataSource;
    CDEstornoIdTerminal: TStringField;
    CDEstornoAfiliacao: TStringField;
    CDEstornoValor: TCurrencyField;
    CDEstornoAutorizacao: TStringField;
    CDEstornoData: TDateField;
    CDEstornoTPag: TStringField;
    CDEstornoNrDocto: TStringField;
    CDEstornoNSU: TStringField;
    Panel1: TPanel;
    PanInfo: TPanel;
    LabTerminal: TLabel;
    dbTerminal: TDBEdit;
    LabAfiliacao: TLabel;
    dbAfiliacao: TDBComboBox;
    LabValor: TLabel;
    dbValor: TDBEdit;
    LabAutoriz: TLabel;
    dbAutorizacao: TDBEdit;
    LabData: TLabel;
    dbData: TDBEdit;
    LabNrDoc: TLabel;
    dbNrDoc: TDBEdit;
    LabNSU: TLabel;
    dbNSU: TDBEdit;
    dbTPag: TDBRadioGroup;
    LabEstornar: TLabel;
    BitBtn1: TBitBtn;
    btCancelar: TBitBtn;
    procedure btCancelarClick(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FTEFEstManual: TFTEFEstManual;

implementation

{$R *.dfm}

uses TEFPrincipal, TEFEstornos;


Function CriaDataSetEstorno: Boolean;
var wMsg: String;
begin
  with FTEFEstManual
  do begin
    wMsg := '';
    CDEstorno.Active  := False;
    CDEstorno.FieldDefs.Clear;
    CDEstorno.FieldDefs.Add('IdTerminal', ftString, 20);
    CDEstorno.FieldDefs.Add('Afiliacao', ftString, 60);
    CDEstorno.FieldDefs.Add('Valor', ftCurrency);
    CDEstorno.FieldDefs.Add('Autorizacao', ftString, 200);
    CDEstorno.FieldDefs.Add('Data', ftDate);
    CDEstorno.FieldDefs.Add('TPag', ftString, 2);           // 03-CCred 04-CDeb 17-PIX
    CDEstorno.FieldDefs.Add('NrDocto', ftString, 200);
    CDEstorno.FieldDefs.Add('NSU', ftString, 200);
    CDEstorno.CreateDataSet;
    Try
      CDEstorno.Active := True;
      CDEstorno.Active := False;
    Except
      wMsg := wMsg + 'CDEstorno   ';
    End;
    //
    if wMsg <> '' then
    begin
      MessageDlg('Falha na abertura das áreas de trabalho' + #13 + wMsg + #13,
                 mtError,[mbOk],0);
      Result := False;
    end
    else begin
      CDEstorno.Active := True;
      Result := True;
    end;

  end;

end;

Procedure EstornoManual;
var i: Integer;
begin
  if not CriaDataSetEstorno then
    Exit;
  with FTEFEstManual do
  begin
    Caption := 'Estorno manual' + FTEFPrincipal.wVersao;
    LabEstornar.Caption := '';
    dbAfiliacao.Items.Clear;
    for i := 0 to FTEFPrincipal.wAfil_Tipo.Count-1 do
      if FTEFPrincipal.wAfil_Tipo[i] = 'C' then
        dbAfiliacao.Items.Add(FTEFPrincipal.wAfil_Nome[i]);
    CDEstorno.Active := True;
    CDEstorno.Append;
    ShowModal;
    CDEstorno.Active := False;
  end;

end;


procedure TFTEFEstManual.BitBtn1Click(Sender: TObject);
begin
  ProcessaEstorno(CDEstornoIdTerminal.AsString,
                  CDEstornoAfiliacao.AsString,
                  CDEstornoValor.AsCurrency,
                  CDEstornoAutorizacao.AsString,
                  CDEstornoData.AsString,
                  CDEstornoTPag.AsString,
                  CDEstornoNrDocto.AsString,
                  CDEstornoNSU.AsString, '2');
  FTEFEstManual.Close;

end;

procedure TFTEFEstManual.btCancelarClick(Sender: TObject);
begin
  FTEFEstManual.Close;

end;

end.
