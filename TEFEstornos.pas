unit TEFEstornos;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Data.DB, Vcl.Grids,
  Vcl.DBGrids, Vcl.StdCtrls, Vcl.Buttons, Vcl.DBCtrls, DateUtils;

  Function EstornoPgtos: Currency;

  Procedure ProcessaEstorno(pmtTerminal:String;
                            pmtAfiliacao:String;
                            pmtValor:Currency;
                            pmtAutorizacao:String;
                            pmtData:String;
                            pmtTPag:String;
                            pmtNrDocto:String;
                            pmtNSU:String;
                            pmtOrigem:String);


type
  TFTEFEstornos = class(TForm)
    PanCobrancas: TPanel;
    dbGrid: TDBGrid;
    PanRodape: TPanel;
    Panel1: TPanel;
    Label1: TLabel;
    LabIdOperacao: TLabel;
    DBNavigator1: TDBNavigator;
    LabDtHr: TLabel;
    btEstornar: TBitBtn;
    btSair: TBitBtn;
    LabEstornar: TLabel;
    procedure FormResize(Sender: TObject);
    procedure btEstornarClick(Sender: TObject);
    procedure btSairClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }

  end;

var
  FTEFEstornos: TFTEFEstornos;

implementation

{$R *.dfm}

uses TEFCobrar, uGenericas, TEFPrincipal, TEFEstManual;

// Funcao de estorno durante as cobranças
Function EstornoPgtos: Currency;
var wVlrCobrado: Currency;
begin
  Result := 0;
  FTEFCobrar.CDRetorno.First;
  FTEFEstornos.LabIdOperacao.Caption := FTEFCobrar.CDRetornoNrOperacao.AsString;
  FTEFEstornos.LabDtHr.Caption := '';
  FTEFEstornos.ShowModal;
  wVlrCobrado := 0;
  FTEFCobrar.CDRetorno.First;
  while not FTEFCobrar.CDRetorno.Eof do
  begin
    if FTEFCobrar.CDRetornoStatus.AsInteger = 1 then
      wVlrCobrado := wVlrCobrado + FTEFCobrar.CDRetornoValor.AsCurrency;
    FTEFCobrar.CDRetorno.Next;
  end;
  Result := wVlrCobrado;

end;

Procedure ProcessaEstorno(pmtTerminal:String;
                          pmtAfiliacao:String;
                          pmtValor:Currency;
                          pmtAutorizacao:String;
                          pmtData:String;
                          pmtTPag:String;
                          pmtNrDocto:String;
                          pmtNSU:String;
                          pmtOrigem:String);
var wIdTerminal,wAfil,wValor,wAutoriz,wData,wtPag,wDocto,wNSU,wOrig: String;
    wPgma,wParm,wMsg: String;
    ctaRestante: Integer;
begin
  wIdTerminal := pmtTerminal;
  wAfil := pmtAfiliacao;
  wValor := ValorTxt(pmtValor,15,2);
  wValor := StringReplace(wValor, '.', ',', [rfIgnoreCase]);
  wAutoriz := pmtAutorizacao;
  wData := Copy(pmtData,1,6) + Copy(pmtData,9,2);
  wtPag := pmtTPag;
  wDocto := pmtNrDocto;                 // Operacao
  wNSU := pmtNSU;
  wOrig := pmtOrigem;       // '1'Estornos normais    '2'Estorno Extra
  //
  wPgma := FTEFPrincipal.wExecACNFe;
  wParm := FTEFPrincipal.wCmdoCancelTEF + ' ' +       // '/TEF /ESTORNAR ' +
           wIdTerminal + ' ' +                        // Terminal
           wAfil + ' ' +                              // CIELO, VERO, ETC..
           wValor + ' ' +                             // 9999,99
           wAutoriz + ' ' +                           // Nro autorizacao
           wData + ' ' +                              // Data
           wtPag + ' ' +                              // 03 ou 04 (Credito/Débito)
           wDocto + ' ' +                             // Docto
           wNSU;                                      // NSU
  if FTEFPrincipal.wDebug then
    ShowMessage(wParm);
  DeleteFile(FTEFPrincipal.wRetornoACNFe);
  DeleteFile(FTEFPrincipal.wRetornoTEF);
  //
  if FTEFPrincipal.wDebug then
    MessageDlg('Chamada' + #13 +
               '> ' + wPgma + #13 +
               '> ' + wParm,mtInformation,[mbOk],0);
  EncadeamentoExecutavel(wPgma, wParm,
                         FTEFPrincipal.wAtivarACNFe,
                         FTEFPrincipal.wExibirACNFe);
  wMsg := 'Estornando...';
  ctaRestante := FTEFPrincipal.wTimeOut;
  while (ctaRestante > 0) and
        (not FileExists(FTEFPrincipal.wRetornoACNFe)) do
  begin
    if wOrig = '1' then
      FTEFEstornos.LabEstornar.Caption := wMsg + IntToStr(ctaRestante)
    else
      FTEFEstManual.LabEstornar.Caption := wMsg + IntToStr(ctaRestante);
    Application.ProcessMessages;
    Sleep(1000);
    ctaRestante := ctaRestante - 1;
  end;
  //
  if not FileExists(FTEFPrincipal.wRetornoACNFe) then
  begin
    MessageDlg('Pagamento NÃO estornado, timeout',mtError,[mbOk],0);
    Exit;
  end;
  if RetornoArqTxt then
    if wOrig = '1' then
    begin
      FTEFCobrar.CDRetorno.Edit;
      FTEFCobrar.CDRetornoStatus.AsInteger := 2;
      FTEFCobrar.CDRetorno.Post;
    end
    else MessageDlg('Pagamento estornado',mtInformation,[mbOk],0);

{
Retorno
Posição Inicial	Posição Final	Conteúdo
0001	0020	Data Hora da Transação Local
0021	0040	Data Hora do Comprovante
0041	0060	Nro da Finalização
0061	0080	Serial POS
0081	0100	Estabelecimento
0101	0120	Bandeira
0121	0140	BIN
0141	0160	Nro Documento
0161	0180	Valor
0181	0420	Arquivo de Impressão 1a via (via do cliente)
0421	0660	Arquivo de Impressão 2a via (via do estabelecimento)
}

end;

procedure TFTEFEstornos.btEstornarClick(Sender: TObject);
var wMsg: String;
    wPgma,wParm: String;
    wValor,wAfil,wData,wtPag,wAutoriz,wDocto,wNSU: String;
    ctaRestante: Integer;
begin
  wMsg := '';
  if (FTEFCobrar.CDRetornoTPag.AsString = '17') or
     (FTEFCobrar.CDRetornoTPag.AsString = '01') then
    wMsg := 'Pagamento PIX ou Dinheiro não pode ser estornado' + #13;
  case FTEFCobrar.CDRetornoStatus.AsInteger of
    0:wMsg := 'Cobrança NÃO efetivada' + #13;
    2:wMsg := 'Pagamento anteriormente estornado';
  end;
  if wMsg = '' then
    if DayOf(now) <> DayOf(FTEFCobrar.CDRetornoDtHr.AsDateTime) then
      wMsg := 'Estorno de pagamento deve ocorrer no mesmo dia do pagamento';
  if wMsg <> '' then
  begin
    MessageDlg(wMsg,mtWarning,[mbOk],0);
    Exit;
  end;
  //
  ProcessaEstorno(FTEFPrincipal.wIdTerminal,
                  Trim(FTEFCobrar.CDRetornoAfiliacao.AsString),
                  FTEFCobrar.CDRetornoValor.AsCurrency,
                  FTEFCobrar.CDRetornoAutorizacao.AsString,
                  FTEFCobrar.CDRetornoDtHr.AsString,
                  FTEFCobrar.CDRetornoTPag.AsString,
                  FTEFCobrar.CDRetornoNrOperacao.AsString,
                  FTEFCobrar.CDRetornoNSU.AsString, '1');

end;

{
  wAfil := Trim(FTEFCobrar.CDRetornoAfiliacao.AsString);
  wValor := ValorTxt(FTEFCobrar.CDRetornoValor.AsCurrency,15,2);
  wValor := StringReplace(wValor, '.', ',', [rfIgnoreCase]);
  wAutoriz := Trim(FTEFCobrar.CDRetornoAutorizacao.AsString);
  wData := Copy(FTEFCobrar.CDRetornoDtHr.AsString,1,6) +
           Copy(FTEFCobrar.CDRetornoDtHr.AsString,9,2);
  wtPag := FTEFCobrar.CDRetornoTPag.AsString;   // 03 ou 04
  wDocto := Trim(FTEFCobrar.CDRetornoNrOperacao.AsString);
  wNSU := FTEFCobrar.CDRetornoNSU.AsString;

  wPgma := FTEFPrincipal.wExecACNFe;
  wParm := FTEFPrincipal.wCmdoCancelTEF + ' ' +       // '/TEF /ESTORNAR ' +
           FTEFPrincipal.wIdTerminal + ' ' +          // Terminal
           wAfil + ' ' +                              // CIELO, VERO, ETC..
           wValor + ' ' +                             // 9999,99
           wAutoriz + ' ' +                           // Nro autorizacao
           wData + ' ' +                              // Data
           wtPag + ' ' +                              // 03 ou 04 (Credito/Débito)
           wDocto + ' ' +                             // Docto
           wNSU;                                      // NSU
  if FTEFPrincipal.wDebug then
    ShowMessage(wParm);

  DeleteFile(FTEFPrincipal.wRetornoACNFe);
  DeleteFile(FTEFPrincipal.wRetornoTEF);
  //
  if FTEFPrincipal.wDebug then
    MessageDlg('Chamada' + #13 +
               '> ' + wPgma + #13 +
               '> ' + wParm,mtInformation,[mbOk],0);
  EncadeamentoExecutavel(wPgma, wParm,
                         FTEFPrincipal.wAtivarACNFe,
                         FTEFPrincipal.wExibirACNFe);
  wMsg := 'Estornando...';
  ctaRestante := FTEFPrincipal.wTimeOut;
  while (ctaRestante > 0) and
        (not FileExists(FTEFPrincipal.wRetornoACNFe)) do
  begin
    LabEstornar.Caption := wMsg + IntToStr(ctaRestante);
    Application.ProcessMessages;
    Sleep(1000);
    ctaRestante := ctaRestante - 1;
  end;
  //
  if not FileExists(FTEFPrincipal.wRetornoACNFe) then
  begin
    MessageDlg('Pagamento NÃO estornado, timeout',mtError,[mbOk],0);
    Exit;
  end;
  if RetornoArqTxt then
  begin
    FTEFCobrar.CDRetorno.Edit;
    FTEFCobrar.CDRetornoStatus.AsInteger := 2;
    FTEFCobrar.CDRetorno.Post;
  end;
}
{
Retorno
Posição Inicial	Posição Final	Conteúdo
0001	0020	Data Hora da Transação Local
0021	0040	Data Hora do Comprovante
0041	0060	Nro da Finalização
0061	0080	Serial POS
0081	0100	Estabelecimento
0101	0120	Bandeira
0121	0140	BIN
0141	0160	Nro Documento
0161	0180	Valor
0181	0420	Arquivo de Impressão 1a via (via do cliente)
0421	0660	Arquivo de Impressão 2a via (via do estabelecimento)
}


procedure TFTEFEstornos.btSairClick(Sender: TObject);
begin
  FTEFEstornos.Close;

end;

procedure TFTEFEstornos.FormActivate(Sender: TObject);
begin
  FTEFEstornos.FormResize(nil);

end;

procedure TFTEFEstornos.FormResize(Sender: TObject);
begin
  if FTEFEstornos.Width < 750 then
    FTEFEstornos.Width := 750;
  if FTEFEstornos.Height < 360 then
    FTEFEstornos.Height := 360;
  dbGrid := DefineGrid(dbGrid, [0.03, 0.09, 0.07, 0.07, 0.33, 0.33, 0.14, 0.14, 0.14], 4, 5);

end;

end.
