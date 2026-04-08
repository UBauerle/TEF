unit TEFCobrar;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, ExtCtrls, StdCtrls, Buttons, Mask, DB, DBClient, DBCtrls;
  Function CriaDataSets(pmtDados:Integer=3): Boolean;
  Function RetornoArqTxt: Boolean;

type
  TFTEFCobrar = class(TForm)
    PanRodape: TPanel;
    btCancel: TBitBtn;
    DSInfo: TDataSource;
    CDInfo: TClientDataSet;
    CDInfoTerminal: TStringField;
    CDInfoValor: TCurrencyField;
    CDInfoNParc: TIntegerField;
    CDInfoBanricompras: TIntegerField;
    CDInfoTPag: TStringField;
    CDInfoAfiliacao: TStringField;
    CDInfoIndPag: TStringField;
    CDInfoAfilCNPJ: TStringField;
    Panel1: TPanel;
    PanUtil: TPanel;
    LabValor: TLabel;
    dbValor: TDBEdit;
    LabMeioPgto: TLabel;
    dbTPag: TDBRadioGroup;
    LabAfiliacao: TLabel;
    dbAfiliacao: TDBComboBox;
    LabBanricompras: TLabel;
    dbBanricompras: TDBRadioGroup;
    LabParcelas: TLabel;
    dbParcelas: TDBComboBox;
    LabNrDocto: TLabel;
    dbNrOperacao: TDBEdit;
    LabTerminal: TLabel;
    dbTerminal: TDBEdit;
    dbIndPag: TDBRadioGroup;
    btOkCobrar: TBitBtn;
    dbCNPJs: TDBComboBox;
    LabTitulo: TLabel;
    CDRetorno: TClientDataSet;
    CDRetornoNrOperacao: TIntegerField;
    CDRetornoNSU: TStringField;
    CDRetornoAutorizacao: TStringField;
    CDRetornoReferencia: TStringField;
    CDRetornoCartao: TStringField;
    CDRetornoBandeira: TStringField;
    CDRetornoDtHr: TStringField;
    CDRetornoArqImpr1: TStringField;
    CDRetornoArqImpr2: TStringField;
    CDRetornoSeq: TIntegerField;
    Label2: TLabel;
    CDInfoNrOperacao: TIntegerField;
    CDRetornoTPag: TStringField;
    CDRetornoIndPag: TStringField;
    CDRetornoNParc: TIntegerField;
    CDRetornoValor: TCurrencyField;
    Label1: TLabel;
    Label3: TLabel;
    CDInfoSeq: TIntegerField;
    Label4: TLabel;
    dbSeq: TDBEdit;
    edACobrar: TMaskEdit;
    edCobrado: TMaskEdit;
    edPendente: TMaskEdit;
    CDRetornoStatus: TIntegerField;
    PanProcesso: TPanel;
    LabTimer: TLabel;
    LabRestante: TLabel;
    Label5: TLabel;
    PanFinalOk: TPanel;
    LabCtaFim: TLabel;
    DSRetorno: TDataSource;
    CDRetornoZC_TPag: TStringField;
    CDRetornoZC_Status: TStringField;
    CDRetornoAfiliacao: TStringField;
    CDRetornoAfilNro: TIntegerField;
    CDRetornoAfilCNPJ: TStringField;
    CDInfoAfilNro: TIntegerField;
    Image1: TImage;
    procedure btOkCobrarClick(Sender: TObject);
    procedure btCancelClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure dbValorExit(Sender: TObject);
    procedure dbTPagExit(Sender: TObject);
    procedure dbTPagEnter(Sender: TObject);
    procedure dbAfiliacaoEnter(Sender: TObject);
    procedure dbAfiliacaoExit(Sender: TObject);
    procedure dbValorEnter(Sender: TObject);
    procedure dbBanricomprasEnter(Sender: TObject);
    procedure dbBanricomprasExit(Sender: TObject);
    procedure dbParcelasEnter(Sender: TObject);
    procedure dbParcelasExit(Sender: TObject);
    procedure dbNrOperacaoEnter(Sender: TObject);
    procedure dbNrOperacaoExit(Sender: TObject);
    procedure dbTerminalEnter(Sender: TObject);
    procedure dbTerminalExit(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure dbAfiliacaoChange(Sender: TObject);
    procedure dbNrOperacaoKeyPress(Sender: TObject; var Key: Char);
    procedure FormCreate(Sender: TObject);
    procedure CDRetornoCalcFields(DataSet: TDataSet);
    procedure Image1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    xNrOperacao: String;              // Nr. da operação
    xValor: String;                   // Valor total da operação
    xArqRetorno: String;              // Arq. retorno (CD XML)

    nOperWrk: Integer;                // Nro da operacao
    wValorACobrar: Currency;          // Valor total a ser cobrado
    wValorCobrado: Currency;          // Valor já cobrado
    wValorPendente: Currency;         // Valor pendente de cobrança

  end;

var
  FTEFCobrar: TFTEFCobrar;
  nMaxParcel: Integer;
  wPgma,wParm: String;

implementation

uses uGenericas, TEFPrincipal, TEFImprimir, TEFEstornos;

{$R *.dfm}

Function CriaDataSets(pmtDados:Integer=3): Boolean;
var wMsg: String;
begin
  with FTEFCobrar
  do begin
    wMsg := '';
    //
    if (pmtDados = 1) or (pmtDados = 3) then
    begin
      CDInfo.Active  := False;
      CDInfo.FieldDefs.Clear;
      CDInfo.FieldDefs.Add('NrOperacao', ftInteger);
      CDInfo.FieldDefs.Add('Seq', ftInteger);
      CDInfo.FieldDefs.Add('Valor', ftCurrency);
      CDInfo.FieldDefs.Add('TPag', ftString, 2);           // 03-CCred 04-CDeb 17-PIX
      CDInfo.FieldDefs.Add('Afiliacao', ftString, 60);
      CDInfo.FieldDefs.Add('AfilCNPJ', ftString, 20);
      CDInfo.FieldDefs.Add('Banricompras', ftInteger);     // 0-AV  1-30Dd  2-Parcelado  3-Parcelado 30Dd  (Somente VERO) Banricompras
      CDInfo.FieldDefs.Add('NParc', ftInteger);
      CDInfo.FieldDefs.Add('IndPag', ftString, 1);         // 0-AV  1-Prazo
      CDInfo.FieldDefs.Add('Terminal', ftString, 20);
      CDInfo.FieldDefs.Add('AfilNro', ftInteger);
      CDInfo.CreateDataSet;
      Try
        CDInfo.Active := True;
        CDInfo.Active := False;
      Except
        wMsg := wMsg + 'CDInfo   ';
      End;
    end;
    //
    if (pmtDados = 2) or (pmtDados = 3) then
    begin
      CDRetorno.Active  := False;
      CDRetorno.FieldDefs.Clear;
      CDRetorno.FieldDefs.Add('NrOperacao', ftInteger);
      CDRetorno.FieldDefs.Add('Seq', ftInteger);
      CDRetorno.FieldDefs.Add('Valor', ftCurrency);
      CDRetorno.FieldDefs.Add('TPag', ftString, 2);
      CDRetorno.FieldDefs.Add('IndPag', ftString, 1);
      CDRetorno.FieldDefs.Add('NParc', ftInteger);
      CDRetorno.FieldDefs.Add('NSU', ftString, 200);
      CDRetorno.FieldDefs.Add('Autorizacao', ftString, 200);
      CDRetorno.FieldDefs.Add('Referencia', ftString, 200);
      CDRetorno.FieldDefs.Add('Cartao', ftString, 20);
      CDRetorno.FieldDefs.Add('Bandeira', ftString, 20);
      CDRetorno.FieldDefs.Add('DtHr', ftString, 20);
      CDRetorno.FieldDefs.Add('ArqImpr1', ftString, 240);
      CDRetorno.FieldDefs.Add('ArqImpr2', ftString, 240);
      CDRetorno.FieldDefs.Add('Status', ftInteger);
      CDRetorno.FieldDefs.Add('Afiliacao', ftString, 60);
      CDRetorno.FieldDefs.Add('AFilCNPJ', ftString, 20);
      CDRetorno.FieldDefs.Add('AfilNro', ftInteger);

      CDRetorno.CreateDataSet;
      Try
        CDRetorno.Active := True;
        CDRetorno.Active := False;
      Except
        wMsg := wMsg + 'CDRetorno   ';
      End;
    end;
    //
    if wMsg <> '' then
    begin
      MessageDlg('Falha na abertura das áreas de trabalho' + #13 + wMsg + #13,
                 mtError,[mbOk],0);
      Result := False;
    end
    else begin
      if (pmtDados = 1) or (pmtDados = 3) then
        CDInfo.Active := True;
      if (pmtDados = 2) or (pmtDados = 3) then
        CDRetorno.Active := True;
      Result := True;
    end;

  end;


end;


Procedure ExibeValores;
begin
  with FTEFCobrar do
  begin
    wValorPendente := wValorACobrar - wValorCobrado;
    edACobrar.Text := FloatToStrF(wValorACobrar,ffNumber,15,2);
    edCobrado.Text := FloatToStrF(wValorCobrado,ffNumber,15,2);
    edPendente.Text := FloatToStrF(wValorPendente,ffNumber,15,2);
    Application.ProcessMessages;
  end;

end;


Procedure NovaCobranca;
var nSeq: Integer;
begin
  with FTEFCobrar do
  begin
    ExibeValores;
    CDInfo.Last;
    nSeq := CDInfoSeq.AsInteger + 1;
    //
    CDInfo.Append;
    CDInfoNrOperacao.AsInteger := nOperWrk;
    CDInfoSeq.AsInteger := nSeq;
    CDInfoValor.AsCurrency := FTEFCobrar.wValorPendente;
    CDInfoTPag.Clear;
    CDInfoAfiliacao.Clear;
    CDInfoBanricompras.Clear;
    CDInfoNParc.Clear;
    CDInfoIndPag.Clear;
    CDInfoTerminal.AsString := FTEFPrincipal.wIdTerminal;
    dbValor.Enabled := True;
    dbTPag.Enabled := True;
    dbAfiliacao.Enabled := True;
    LabBanricompras.Enabled := False;
    dbBanricompras.Enabled := False;
    dbParcelas.Enabled := True;
    dbTerminal.Enabled := True;
    dbValor.SetFocus;

  end;

end;

Function IniciaCobranca: Boolean;
begin
  with FTEFCobrar
  do begin
    nOperWrk := StrToIntDef(xNrOperacao,0);
    xValor := StringReplace(xValor, '.', ',', [rfIgnoreCase]);
    wValorACobrar := StrToCurrDef(xValor,0);
    wValorCobrado := 0;
    wValorPendente := wValorACobrar;
    //
    Result := CriaDataSets;
    if not Result then
      Exit;
    NovaCobranca;
    LabRestante.Caption := '';
    LabTimer.Caption := '';

  end;

end;

Function RetornoArqTxt: Boolean;
var lstTxt: TStringList;
    wTodas,wLinha: String;
    wMsg: String;
    i: Integer;
begin
  Result := False;
  if not FileExists(FTEFPrincipal.wRetornoACNFe) then
  begin
    MessageDlg('Retorno não encontrado' + #13 +
               '[ ' + FTEFPrincipal.wRetornoACNFe + ' ]',mtError,[mbOk],0);
    Exit;
  end;
  lstTxt := TStringList.Create;
  lstTxt.LoadFromFile(FTEFPrincipal.wRetornoACNFe);    // Carrega TXT
  wLinha := '';
  if lstTxt.Count > 0 then
    wLinha := lstTxt[0];
  wTodas := '';
  for i := 0 to lstTxt.Count-1 do
    wTodas := wTodas + lstTxt[i] + #13;
  lstTxt.Free;
  //
  if FTEFPrincipal.wDebug then
    MessageDlg('Linha=' + #13 + wLinha + #13#13 +
               'Todas=' + #13 + wTodas, mtInformation, [mbOk],0);
  //
  if wLinha = '' then
  begin
    MessageDlg('Retorno vazio' + #13 +
               '[ ' + FTEFPrincipal.wRetornoACNFe + ' ]',mtError,[mbOk],0);
    Exit;
  end;
  if Pos('ERRO',wLinha) > 0 then
  begin
    MessageDlg('Retorno com Erro' + #13 +
               Trim(Copy(wLinha,1,83)) + #13 +
               Trim(Copy(wLinha,84,Length(wLinha)-83)),mtError,[mbOk],0);
    Exit;
  end;
  Result := True;

end;


Function RetornoArqTEF(var pmtLinha:String): Boolean;
var lstTEF: TStringList;
begin
  Result := False;
  pmtLinha := '';
  if not FileExists(FTEFPrincipal.wRetornoTEF) then
  begin
    MessageDlg('Retorno TEF inexistente' + #13 +
               '[ ' + FTEFPrincipal.wRetornoTEF + ' ]', mtError,[mbOk],0);
    Exit;
  end;
  lstTEF := TStringList.Create;
  lstTEF.LoadFromFile(FTEFPrincipal.wRetornoTEF);    // Carrega TEF
  if lstTEF.Count > 0 then
    pmtLinha := lstTEF[0];
  lstTEF.Free;
  if pmtLinha = '' then
  begin
    MessageDlg('Retorno TEF vazio',mtError,[mbOk],0);
    Exit;
  end;
  Result := True;

end;


procedure TFTEFCobrar.btOkCobrarClick(Sender: TObject);
var wMsg: String;
    wValor: String;
    ctaTempo,ctaTMax,ctaRestante: Integer;
    wLinhaRet: String;
    rNSU,rAutoriz,rRefer,rCartao,rBand,rDtHr,rArq1V,rArq2V: String;
    retOk: Boolean;
    //wArqSaveRet: String;
const xPonto: string = '.';
      xVirgula: string = ',';
begin
  if CDInfoTPag.AsString <> '01' then    // Cartoes + Pix
  begin
    wMsg := '';
    if CDInfoNParc.AsInteger = 0 then
      CDInfoNParc.AsInteger := 1;
    if CDInfoTerminal.AsString = '' then
      CDInfoTerminal.AsString := FTEFPrincipal.wIdTerminal;
    if (CDInfoTPag.AsString <> '03') and
     (CDInfoTPag.AsString <> '04') and
     (CDInfoTPag.AsString <> '17') then
    wMsg := wMsg + 'Meio de pagamento inválido' + #13;
    if CDInfoAfiliacao.AsString = '' then
      wMsg := wMsg + 'Afiliação não informada' + #13;
    if CDInfoNParc.AsInteger > nMaxParcel then
      wMsg := wMsg + 'Quant. parcelas superior ao permitido [' +
                     IntToStr(nMaxParcel) + ']' + #13;
    if wMsg <> ''
    then begin
      MessageDlg('Erro(s)' + #13 + wMsg + 'Reinforme',mtError,[mbOK],0);
      dbValor.SetFocus;
      Exit;
    end;
    //
    PanUtil.Enabled := False;
    PanRodape.Enabled := False;
    //
    CDInfoIndPag.AsString := '0';                // A Vista
    if (CDInfoNParc.AsInteger > 1) or            // Nr. parcelas > 1  ou
       (CDInfoBanricompras.AsInteger > 1) then   // Banricompras 30DD ou parcelado
      CDInfoIndPag.AsString := '1';              // Prazo
    CDInfoAfilCNPJ.AsString := dbCNPJS.Items[dbAfiliacao.ItemIndex];
    CDInfoAfilNro.AsInteger := dbAfiliacao.ItemIndex + 1;
    CDInfo.Post;
    //
    wValor := ValorTxt(CDInfoValor.AsCurrency,15,2);
    wValor := StringReplace(wValor, '.', ',', [rfIgnoreCase]);
    wPgma := FTEFPrincipal.wExecACNFe;
    wParm := '/TEF /COBRAR ' + Trim(CDInfoTerminal.AsString) + ' ' +
                               Trim(CDInfoAfiliacao.AsString) + ' ' +
                               Trim(CDInfoNrOperacao.AsString) + ' ' +
                               CDInfoTPag.AsString + ' ' +
                               CDInfoIndPag.AsString + ' ' +
                               wValor + ' ' +
                               CDInfoNParc.AsString;
    DeleteFile(FTEFPrincipal.wRetornoACNFe);
    DeleteFile(FTEFPrincipal.wRetornoTEF);
    if CDInfoTPag.AsString = '17' then
    begin
      PanProcesso.Caption := 'PIX';
    end
    else begin          // C.Crédito ou Débito
      if CDInfoTPag.AsString = '03' then
        PanProcesso.Caption := 'Cartão de crédito'
      else
        PanProcesso.Caption := 'Cartão de débito';
    end;
    LabRestante.Caption := '';
    LabTimer.Caption := '';
    PanProcesso.Visible := True;
    Application.ProcessMessages;
    //
    if FTEFPrincipal.wDebug then
       ShowMessage('Pgma=' + wPgma + #13 +
                   'Parm=' + wParm + #13 +
                   'Term=' + Trim(CDInfoTerminal.AsString) + #13 +
                   'Afil=' + Trim(CDInfoAfiliacao.AsString) + #13 +
                   'NrOp=' + Trim(CDInfoNrOperacao.AsString) + #13 +
                   'TPag=' + CDInfoTPag.AsString + #13 +
                   'IndPag=' + CDInfoIndPag.AsString + #13 +
                   'Valor=' + wValor + #13 +
                   'NParc='+ CDInfoNParc.AsString + #13 +
                   'Vai ativar.....');

    EncadeamentoExecutavel(wPgma, wParm,
                           FTEFPrincipal.wAtivarACNFe,
                           FTEFPrincipal.wExibirACNFe);
    //
    LabTimer.Caption := '';
    LabTimer.Visible := True;
    ctaRestante := FTEFPrincipal.wTimeOut;
    if CDInfoTPag.AsString = '17' then        // Se PIX, duplica o timeout
      ctaRestante := ctaRestante * 2;
    LabRestante.Font.Color := clWindowText;
    LabRestante.Font.Style := [];
    LabRestante.Caption := 'Tempo restante: ' + IntToStr(ctaRestante);
    LabRestante.Visible := True;
    ctaTMax := ctaRestante * 2;        // Timeout convertido 2 x por segundo
    if CDInfoTPag.AsString = '17' then
      ctaTMax := ctaTMax * 2;                     // Se 'PIX', duplica o tempo de timeout
    ctaTempo := 0;
    while (ctaTempo < ctaTMax) and
          (not FileExists(FTEFPrincipal.wRetornoACNFe)) do
    begin
      sleep(500);
      ctaTempo := ctaTempo + 1;
      if (ctaTempo mod 2) = 0 then
      begin
        LabTimer.Caption := LabTimer.Caption + '.';
        if LabTimer.Width > (PanProcesso.Width - 28) then
          LabTimer.Caption := '.';
        ctaRestante := ctaRestante - 1;
        if ctaRestante < 30 then
        begin
          LabRestante.Font.Color := clRed;
          LabRestante.Font.Style := [fsBold];
        end;
        LabRestante.Caption := 'Tempo restante: ' + IntToStr(ctaRestante);
        Application.ProcessMessages;
      end;
    end;
    PanProcesso.Visible := False;
    LabTimer.Caption := '';
    LabTimer.Visible := False;
    LabRestante.Caption := '';
    LabRestante.Visible := False;
    PanRodape.Enabled := True;
    PanUtil.Enabled := True;
    //
    retOk := False;
    if RetornoArqTxt then
      if RetornoArqTEF(wLinhaRet) then
      begin
        rNSU := Trim(Copy(wLinhaRet,1,200));
        rAutoriz := Trim(Copy(wLinhaRet,201,200));
        rRefer := Trim(Copy(wLinhaRet,401,200));
        rCartao := Trim(Copy(wLinhaRet,601,20));
        rBand := Trim(Copy(wLinhaRet,621,20));
        rDtHr := Trim(Copy(wLinhaRet,641,20));
        rArq1V := Trim(Copy(wLinhaRet,661,240));
        rArq2V := Trim(Copy(wLinhaRet,900,240));
        if FTEFPrincipal.wDebug then
          ShowMessage('NrOperacao: ' + CDInfoNrOperacao.AsString + '/' +
                      'Seq: ' + CDInfoSeq.AsString + #13 +
                      'NSU: ' + rNSU + #13 +
                      'Autorizacao: ' + rAutoriz + #13 +
                      'Referencia: ' + rRefer + #13 +
                      'Cartao: ' + rCartao + #13 +
                      'Bandeira: ' + rBand + #13 +
                      'DtHr: ' + rDtHr + #13 +
                      'Arq1V: ' + rArq1V + #13 +
                      'Arq2V: ' + rArq2V);
        if FTEFPrincipal.wImprimir then
        begin
          ImprimeComprovante(rArq1V, FTEFPrincipal.wPreview);
          ImprimeComprovante(rArq2V, FTEFPrincipal.wPreview);
        end;
        retOk := True;
      end;
  end
  else begin
    rDtHr := DateTimeToStr(now);
    retOk := True;    // Reais
  end;
  //
  if retOk then
  begin
    CDRetorno.Append;
    CDRetornoNrOperacao.AsInteger := CDInfoNrOperacao.AsInteger;
    CDRetornoSeq.AsInteger := CDInfoSeq.AsInteger;
    CDRetornoValor.AsCurrency := CDInfoValor.AsCurrency;
    CDRetornoTPag.AsString := CDInfoTPag.AsString;
    CDRetornoIndPag.AsString := CDInfoIndPag.AsString;
    CDRetornoNParc.AsInteger := CDInfoNParc.AsInteger;
    CDRetornoNSU.AsString := rNSU;
    CDRetornoAutorizacao.AsString := rAutoriz;
    CDRetornoReferencia.AsString := rRefer;
    CDRetornoCartao.AsString := rCartao;
    CDRetornoBandeira.AsString := rBand;
    CDRetornoDtHr.AsString := rDtHr;
    CDRetornoArqImpr1.AsString := rArq1V;
    CDRetornoArqImpr2.AsString := rArq2V;
    CDRetornoStatus.AsInteger := 1;           // Cobrança efetuada
    CDRetornoAfiliacao.AsString := CDInfoAfiliacao.AsString;
    CDRetornoAfilCNPJ.AsString := CDInfoAfilCNPJ.AsString;
    CDRetornoAfilNro.AsInteger := CDInfoAfilNro.AsInteger;
    CDRetorno.Post;
    //
    FTEFCobrar.wValorCobrado := FTEFCobrar.wValorCobrado + CDInfoValor.AsCurrency;
    ExibeValores;
  end;
  if FTEFCobrar.wValorPendente > 0 then
  begin
    NovaCobranca;
    Exit;
  end;
  PanFinalOk.Visible := True;
  Application.ProcessMessages;
  CDRetorno.SaveToFile(FTEFCobrar.xArqRetorno, dfXMLUTF8);
  CDInfo.Active := False;
  CDRetorno.Active := False;
  ctaRestante := FTEFPrincipal.wTempoFinal;
  while ctaRestante > 0 do
  begin
    LabCtaFim.Caption := IntToStr(ctaRestante);
    Application.ProcessMessages;
    Sleep(1000);
    ctaRestante := ctaRestante - 1;
  end;
  PanFinalOk.Visible := False;
  FTEFCobrar.Close;

end;

procedure TFTEFCobrar.CDRetornoCalcFields(DataSet: TDataSet);
begin
  if CDRetornoTPag.AsString = '03' then
    CDRetornoZC_TPag.AsString := 'CCred'
  else if CDRetornoTPag.AsString = '04' then
         CDRetornoZC_TPag.AsString := 'CDeb'
       else if CDRetornoTPag.AsString = '17' then
              CDRetornoZC_TPag.AsString := 'PIX'
            else if CDRetornoTPag.AsString = '01' then
                   CDRetornoZC_TPag.AsString := 'R$'
                 else
                   CDRetornoZC_TPag.AsString := '*';
  case CDRetornoStatus.AsInteger of
    1:CDRetornoZC_Status.AsString := 'Cobr';
    2:CDRetornoZC_Status.AsString := 'Est.';
    else CDRetornoZC_Status.AsString := '';
  end;

end;

procedure TFTEFCobrar.btCancelClick(Sender: TObject);
begin
  if wValorCobrado = 0 then
  begin
    if MessageDlg('Não há cobranças efetivadas' + #13#13 + 'Finalizar processo ?',
                  mtConfirmation,[mbYes,mbNo],0,mbNo,['&Sim','&Não']) = mrYes
    then begin
      CDInfo.Active := False;
      CDRetorno.Active := False;
      FTEFCobrar.Close;
    end
    else dbValor.SetFocus;
    Exit;
  end;
  //
  if MessageDlg('CANCELAR as cobranças já efetivadas ?' + #13 +
                'Total: ' + FloatToStrF(wValorACobrar,ffNumber,15,2) + #13 +
                'Cobrado: ' + FloatToSTrF(wValorCobrado,ffNumber,15,2) + #13 +
                'Pendente: ' + FloatToStrF(wValorPendente,ffNumber,15,2) + #13#13 +
                'Atenção' + #13 +
                '     PIX não pode ser cancelado !!!!' + #13,
                mtConfirmation,
                [mbYes,mbNo],0,mbNo,['Cancelar pagtos','Manter pagtos']) = mrYes
  then begin
    wValorCobrado := EstornoPgtos;
    ExibeValores;
  end;
  dbValor.SetFocus;

end;


procedure TFTEFCobrar.FormShow(Sender: TObject);
begin
  IniciaCobranca;

end;

procedure TFTEFCobrar.Image1Click(Sender: TObject);
begin
  TEF_SobrePgma;

end;

procedure TFTEFCobrar.dbValorExit(Sender: TObject);
begin
  LabValor.Font.Style := [];
  if CDInfoValor.AsCurrency = 0 then
  begin
    MessageDlg('Valor não pode ser zerado, re-informe',mtError,[mbOk],0);
    dbValor.SetFocus;
    Exit;
  end;
  if CDInfoValor.AsCurrency > FTEFCObrar.wValorPendente then
  begin
    MessageDlg('Valor [' + FloatToStrF(CDInfoValor.AsCurrency,ffNumber,15,2) +
               '] não pode ser superior ao valor pendente [' +
               FloatToStrF(FTEFCobrar.wValorPendente,ffNumber,15,2) +
               '], re-informe',mtError,[mbOk],0);
    dbValor.SetFocus;
    Exit;
  end;

end;

procedure TFTEFCobrar.dbTPagExit(Sender: TObject);
var selTipo: String;
    i,idx: Integer;
begin
  if CDInfoTPag.AsString = '' then
  begin
    MessageDlg('Meio de pagamento não informado',mtError,[mbOk],0);
    dbTPag.SetFocus;
    Exit;
  end;
  labMeioPgto.Font.Style := [];
  nMaxParcel := FTEFPrincipal.wMaxParcel;
  if CDInfoTPag.AsString = '01' then
  begin     // Reais - DInheiro
    CDInfoAfiliacao.Clear;
    CDINfoAfilCNPJ.Clear;
    CDInfoBanricompras.Clear;
    CDInfoNParc.AsInteger := 1;
    CDInfoIndPag.AsInteger := 0;
    CDInfoTerminal.Clear;
    dbAfiliacao.Enabled := False;
    dbBanricompras.Enabled := False;
    dbParcelas.Enabled := False;
    dbTerminal.Enabled := False;
    btOkCobrar.SetFocus;
    Exit;
  end;

  selTipo := 'C';
  if CDInfoTPag.AsString = '17' then
    selTipo := 'P';

  idx := 0;
  dbAfiliacao.Items.Clear;
  dbCNPJs.Items.Clear;
  for i := 0 to FTEFPrincipal.wAfil_Tipo.Count-1 do
    if FTEFPrincipal.wAfil_Tipo[i] = selTipo then
    begin
      dbAfiliacao.Items.Add(FTEFPrincipal.wAfil_Nome[i]);
      dbCNPJs.Items.Add(FTEFPrincipal.wAfil_CNPJ[i]);
      if CDInfoTPag.AsString = '03' then
      begin
        if FTEFPrincipal.wAfil_Nome[i] = FTEFPrincipal.wAfilCCred then
          idx := i;
      end
      else if CDInfoTPag.AsString = '04' then
             if FTEFPrincipal.wAfil_Nome[i] = FTEFPrincipal.wAfilCDeb then
               idx := i;
    end;
  //
  CDInfoAfiliacao.Clear;
  CDInfoAfilCNPJ.Clear;
  CDInfoBanricompras.Clear;
  CDInfoNParc.Clear;
  dbBanricompras.Enabled := False;
  //
  CDInfoAfiliacao.AsString := dbAfiliacao.Items[idx];
  CDInfoAfilCNPJ.AsString := dbCNPJs.Items[idx];

end;

procedure TFTEFCobrar.dbTPagEnter(Sender: TObject);
begin
  LabMeioPgto.Font.Style := [fsBold];

end;

procedure TFTEFCobrar.dbAfiliacaoEnter(Sender: TObject);
begin
  LabAfiliacao.Font.Style := [fsBold];

end;

procedure TFTEFCobrar.dbAfiliacaoExit(Sender: TObject);
begin
  LabAfiliacao.Font.Style := [];
  LabBanricompras.Enabled := False;
  dbBanricompras.Enabled := False;
  if CDInfoTPag.AsString = '04' then                   // Cartão de débito
  begin
    if Pos('VERO',CDInfoAfiliacao.AsString) > 0 then      // É VERO ? (Banrisul)
    begin
      LabBanricompras.Enabled := True;
      dbBanricompras.Enabled := True;
      if CDInfoBanricompras.AsInteger = 0 then
        CDInfoBanricompras.AsInteger := 1;
      nMaxParcel := FTEFPrincipal.wMaxParcel;
      dbBanricompras.SetFocus;
    end
    else begin
      nMaxParcel := 1;
      dbParcelas.ItemIndex := 0;
    end;
  end
  else begin           //  Cartão de crédito ou PIX
    CDInfoBanricompras.Clear;
    if CDInfoNParc.AsInteger = 0 then
      dbParcelas.ItemIndex := 0;
    nMaxParcel := FTEFPrincipal.wMaxParcel;
    if CDInfoTPag.AsString = '17' then
      nMaxParcel := 1;
  end;

end;

procedure TFTEFCobrar.dbValorEnter(Sender: TObject);
begin
  LabValor.Font.Style := [fsBold];
  
end;

procedure TFTEFCobrar.dbBanricomprasEnter(Sender: TObject);
begin
  LabBanricompras.Font.Style := [fsBold];
  
end;

procedure TFTEFCobrar.dbBanricomprasExit(Sender: TObject);
begin
  LabBanricompras.Font.Style := [];
  nMaxParcel := FTEFPrincipal.wMaxParcel;
  if CDInfoBanricompras.AsInteger < 3 then
    nMaxParcel := 1;
  if CDInfoNParc.AsInteger <= 1 then
    dbParcelas.ItemIndex := 0;
    
end;

procedure TFTEFCobrar.dbParcelasEnter(Sender: TObject);
var i: Integer;
begin
 LabParcelas.Font.Style := [fsBold];
 dbParcelas.Items.Clear;
 for i := 1 to nMaxParcel do
   if i < 10 then
     dbParcelas.Items.Add('0' + IntToStr(i))
   else
     dbParcelas.Items.Add(IntToStr(i));

end;

procedure TFTEFCobrar.dbParcelasExit(Sender: TObject);
begin
  LabParcelas.Font.Style := [];
  CDInfoIndPag.AsInteger := 0;     // A vista
  if ((CDInfoTPag.AsString = '03') and (CDInfoNParc.AsInteger > 1)) or             // CCred parcelado OU
     ((CDInfoTPag.AsString = '04') and (CDInfoBanricompras.AsInteger > 2)) then    // CDeb + Banricompras
    CDInfoIndPag.AsInteger := 1;   // Prazo

end;

procedure TFTEFCobrar.dbNrOperacaoEnter(Sender: TObject);
begin
  LabNrDocto.Font.Style := [fsBold];
  
end;

procedure TFTEFCobrar.dbNrOperacaoExit(Sender: TObject);
begin
  LabNrDocto.Font.Style := [];
  
end;

procedure TFTEFCobrar.dbNrOperacaoKeyPress(Sender: TObject; var Key: Char);
begin
  if not (Key in ['0'..'9', #8]) then             // Permite Apenas dígitos (0-9) e Backspace (#8)
    Key := #0; // Ignora o caractere pressionado

end;

procedure TFTEFCobrar.dbTerminalEnter(Sender: TObject);
begin
  LabTerminal.Font.Style := [fsBold];
  
end;

procedure TFTEFCobrar.dbTerminalExit(Sender: TObject);
begin
  LabTerminal.Font.Style := [];
  
end;

procedure TFTEFCobrar.FormActivate(Sender: TObject);
begin
  with FTEFCobrar
  do begin
    dbTPag.Items.Clear;
    dbTPag.Items.Add('Cartão de &Crédito');
    dbTPag.Items.Add('Cartão de &Débito');
    dbTPag.Values.Clear;
    dbTPag.Values.Add('03');
    dbTPag.Values.Add('04');
    if FTEFPrincipal.wPixIntegr then
    begin
      dbTPag.Items.Add('&PIX');
      dbTPag.Values.Add('17');
    end;
    dbTPag.Items.Add('&Reais');
    dbTPag.Values.Add('01');
    //
    dbBanricompras.Items.Clear;
    dbBanricompras.Items.Add('&1 - Débito à vista');
    dbBanricompras.Items.Add('&2 - Débito 30 dd');
    dbBanricompras.Items.Add('&3 - Parcelado');
    dbBanricompras.Items.Add('&4 - Parcelado 30 dd');
    dbBanricompras.Values.Clear;
    dbBanricompras.Values.Add('1');
    dbBanricompras.Values.Add('2');
    dbBanricompras.Values.Add('3');
    dbBanricompras.Values.Add('4');
    //
    dbCNPJs.Visible := FTEFPrincipal.wDebug;
    dbIndPag.Visible := FTEFPrincipal.wDebug;

  end;

end;

procedure TFTEFCobrar.FormCreate(Sender: TObject);
begin
  Caption := 'TEF - Cobrança / Recebimento' + FTEFPrincipal.wVersao;
  PanProcesso.Visible := False;
  PanProcesso.Caption := 'Cartões / Pix';
  PanProcesso.Width := 528;
  PanProcesso.Height := 105;
  PanProcesso.Left := 32;
  PanProcesso.Top := 196;
  LabRestante.Caption := 'Tempo ....';
  LabRestante.Left := PanProcesso.Width - (LabRestante.Width + 16);
  LabRestante.Top := 68;
  LabTimer.Caption := '...';
  LabTimer.Left := 12;
  LabTimer.Top := 84;
  PanFinalOk.Visible := False;
  PanFinalOk.Caption := 'Cobrança finalizada';
  PanFinalOk.Left := PanProcesso.Left;
  PanFinalOk.Top := PanProcesso.Top;
  PanFinalOk.Width := PanProcesso.Width;
  LabCtaFim.Caption := 'Fim';
  LabCtaFim.Left := PanFinalOk.Width - (LabCtaFim.Width + 16);

end;

procedure TFTEFCobrar.dbAfiliacaoChange(Sender: TObject);
begin
  dbCNPJs.ItemIndex := dbAfiliacao.ItemIndex;

end;

end.
