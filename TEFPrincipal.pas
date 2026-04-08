unit TEFPrincipal;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, IniFiles, Vcl.Mask, Vcl.ExtCtrls, TlHelp32;
  Procedure TEF_SobrePgma;

type
  TFTEFPrincipal = class(TForm)
    btCobrar: TBitBtn;
    btEstornar: TBitBtn;
    btSair: TBitBtn;
    btCfgPinpad: TBitBtn;
    Label1: TLabel;
    Label2: TLabel;
    edNumero: TMaskEdit;
    edValor: TMaskEdit;
    OpenDialog1: TOpenDialog;
    btEstManual: TBitBtn;
    LabHelp: TLabel;
    btCPF: TBitBtn;
    Image1: TImage;
    procedure btCobrarClick(Sender: TObject);
    procedure btEstornarClick(Sender: TObject);
    procedure btSairClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btCfgPinpadClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btEstManualClick(Sender: TObject);
    procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure btEstornarMouseMove(Sender: TObject; Shift: TShiftState; X,Y: Integer);
    procedure btEstManualMouseMove(Sender: TObject; Shift: TShiftState; X,Y: Integer);
    procedure btCPFMouseMove(Sender: TObject; Shift: TShiftState; X,Y: Integer);
    procedure btCPFClick(Sender: TObject);
    procedure edNumeroMouseMove(Sender: TObject; Shift: TShiftState; X,Y: Integer);
    procedure edValorMouseMove(Sender: TObject; Shift: TShiftState; X,Y: Integer);
    procedure btCobrarMouseMove(Sender: TObject; Shift: TShiftState; X,Y: Integer);
    procedure btCfgPinpadMouseMove(Sender: TObject; Shift: TShiftState; X,Y: Integer);
    procedure btSairMouseMove(Sender: TObject; Shift: TShiftState; X,Y: Integer);
    procedure Image1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure edValorExit(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }
    wModoExec: String;                // Modo de execução  MANUAL ou AUTOMatico
    wIdTerminal: String;              // Identificação do terminal
    wAfilCCred: String;               // Afiliação padrao c.crédito
    wAfilCDeb: String;                // Afiliação padrão c.débito
    wPixIntegr: Boolean;              // PIX integrado (Y/N)
    wAfilPix: String;                 // Afiliacao PIX
    wCNPJPix: String;                 // CNPJ da afiliação PIX
    wMaxParcel: Integer;              // Nr.máximo de parcelas
    wValMinParcel: Currency;          // Valor mínimo da parcela
    wExecACNFe: String;               // Nome do executavel
    wAtivarACNFe: String;             // Forma de ativação do ACNFe  (Shell ou WinExec)
    wExibirACNFe: Integer;            // Exibir ACNFe  (0-Não  1-Sim)
    wRetornoACNFe: String;            // Arquivo de "SAIDA" (Caminho completo)
    wRetornoTEF: String;              // Saida do TEF
    wArquivoIniACNFe: String;         // Arquivo "ini" do ACNFe
    wTimeOut: Integer;                // Tempo limite
    wTempoFinal: Integer;             // Tempo de espera na finalizacão
    wQtdAfil: Integer;                // Qtd de afiliacoes
    wAfil_Nome: TStringList;          // Relação das afiliaçoes  Nome
    wAfil_CNPJ: TStringList;          // Relação das afiliaçoes  CNPJ
    wAfil_Tipo: TStringList;          // Tipo (C)artao  (P)ix
    wDebug: Boolean;                  // Debug ??  True / False
    wImprimir: Boolean;               // Realiza a impressao dos comprovantes sem ACNFE
    wImpressora: String;              // Impressora utilizada
    wMargTopo,wMargRodape: Integer;   // Margens (impressão)
    wMargEsq,wMargDir: Integer;
    wPreview: Boolean;
    wPathRetorno: String;             // Path dos retornos, para iniciar ESTORNOS
    wPDC: String;                     // Identificação do PDC
    wVerActefd: Boolean;              // Verifica a existencia de actefd.exe  e .ini
    wCfgPinPad: Boolean;              // Exibe botão 'configurar pinpad'
    wCmdoCancelTEF: String;           // Comando de cancelamento/estorno de pagto de cartão
    wPathRetTEF: String;              // 'Path' de retorno das cobranças efetivadas
    wEstornar: Boolean;               // Permite Estornos de pagamento
    wEstExtra: Boolean;               // Permite Estorno extra
    wObterCPF: Boolean;               // Solicitar CPF
    wDaemon: String;                  // Nome do executavel Daemon (ACTEFD.EXE)
    wVersao: String;                  // Versão do programa

  end;

var
  FTEFPrincipal: TFTEFPrincipal;
  wImag: String;
  vOperacao: Real;
  xValor: String;

implementation

uses TEFCobrar, uGenericas, TEFEstornos, TEFEstManual, TEFCPF, uSobre10, uMsgTimer;

{$R *.dfm}


Function Leitura_Ini: Boolean;
var wIni: TIniFile;
    wIniFile: String;
    wRetPath,wRetFile,wMsg: String;
    i,nP: Integer;
    xAfil,xParam,SaveIniName: String;

begin
  Result := False;
  wIniFile := ChangeFileExt(Application.ExeName,'.ini');
  SaveIniName := wIniFile;     // Salva o nome
  if not FileExists(wIniFile) then
  begin
    wIni := TIniFile.Create(wIniFile);
    wIni.WriteString('Config','IdTerminal','Term00');
    wIni.WriteString('Config','AfilCCred','CIELO');
    wIni.WriteString('Config','AfilCDeb','CIELO');
    wIni.WriteBool('Config','PIXIntegrado',True);
    wIni.WriteString('Config','AfilPIX','ITAU');
    wIni.WriteString('Config','CNPJPix','12345678000100');
    wIni.WriteInteger('Config','MaxParcel',3);
    wIni.WriteFloat('Config','ValMinParcel',5);
    wIni.WriteBool('Config','Debug',False);
    wIni.WriteBool('Config','Imprimir',False);
    wIni.WriteString('Config','Impressora','');
    wIni.WriteInteger('Config','MargemTopo',5);
    wIni.WriteInteger('Config','MargemRodape',5);
    wIni.WriteInteger('Config','MargemEsquerda',2);
    wIni.WriteInteger('Config','MargemDireita',8);
    wIni.WriteBool('Config','Preview',False);
    wIni.WriteString('Config','PathRetornos','C:\TEFCobranca\Retornos');
    wIni.WriteInteger('Config','TempoFinal',5);
    wIni.WriteBool('Config','Estornar',True);
    wIni.WriteBool('Config','EstornoExtra',True);
    wIni.WriteBool('Config','ObterCPF',False);
    wIni.WriteString('Config','Daemon','Actefd.exe');
    wIni.WriteInteger('Config','MsgTimer',3);
      //
    wIni.WriteInteger('Afiliacoes','QtdAfil',5);
    wIni.WriteString('Afiliacoes','Afil01','CIELO;01027058000191;1;1');    // Nome, CNPJ, Disponivel S/N, Nro
    wIni.WriteString('Afiliacoes','Afil02','REDE;01425787000104;1;2');
    wIni.WriteString('Afiliacoes','Afil03','GETNET;10440482000154;1;3');
    wIni.WriteString('Afiliacoes','Afil04','VERO;92934215000106;1;4');
    wIni.WriteString('Afiliacoes','Afil05','PAGSEGURO;08561701000101;1;5');
    //
    wIni.WriteString('ACNFe','Executavel','ACNFe.exe');
    wIni.WriteString('ACNFe','AtivarACNFe','SHELL');
    wIni.WriteInteger('ACNFe','Exibir',1);
    wIni.WriteString('ACNFe','Retorno','C:\TEFCobranca\Local\Retorno.txt');
    wIni.WriteInteger('ACNFe','TimeOut',45);
    wIni.WriteString('ACNFe','PDC','');
    wIni.WriteBool('ACNFe','VerActefd',True);
    wIni.WriteBool('ACNFe','CfgPinPad',True);
    wIni.WriteString('ACNFe','CancelarPgto','/TEF /ESTORNAR');
    //
    wIni.Free;
  end;

  wMsg := '';
  with FTEFPrincipal do
  begin
    // wVersao := '   ' + Versao(Application.ExeName,3,False);
    Caption := 'TEF - Cobrança';
    wIni := TIniFile.Create(wIniFile);
    wIdTerminal := wIni.ReadString('Config','IdTerminal','Term00');
    wAfilCCred := wIni.ReadString('Config','AfilCCred','CIELO');
    wAfilCDeb := wIni.ReadString('Config','AfilCDeb','CIELO');
    wPixIntegr := wIni.ReadBool('Config','PIXIntegrado',True);
    wAfilPix := wIni.ReadString('Config','AfilPIX','ITAU');
    wCNPJPix := wIni.ReadString('Config','CNPJPix','12345678000100');
    wMaxParcel := wIni.ReadInteger('Config','MaxParcel',3);
    wValMinParcel := wIni.ReadFloat('Config','ValMinParcel',5);
    wDebug := wIni.ReadBool('Config','Debug',False);
    wImprimir := wIni.ReadBool('Config','Imprimir',False);
    wImpressora := wIni.ReadString('Config','Impressora','Padrao');
    wMargTopo := wIni.ReadInteger('Config','MargemTopo',5);
    wMargRodape := wIni.ReadInteger('Config','MargemRodape',5);
    wMargEsq := wIni.ReadInteger('Config','MargemEsquerda',2);
    wMargDir := wIni.ReadInteger('Config','MargemDireita',8);
    wPreview := wIni.ReadBool('Config','Preview',False);
    wPathRetorno := wIni.ReadString('Config','PathRetornos','C:\TEFCobranca\Retornos');
    if not DirectoryExists(wPathRetorno) then
      if not ForceDirectories(wPathRetorno) then
        wMsg := wMsg + '[Config]' + #13 +
              'PathRetorno=' + wPathRetorno + #13 + 'Não foi possível criar pasta de retornos' + #13;
    wTempoFinal := wIni.ReadInteger('Config','TempoFinal',3);
    wEstornar := wIni.ReadBool('Config','Estornar',True);
    wEstExtra := wIni.ReadBool('Config','EstornoExtra',True);
    if wEstornar or wEstExtra then
      Caption := Caption + ' & Estorno';
    Caption := Caption + wVersao;
    wObterCPF := wIni.ReadBool('Config','ObterCPF',False);
    wDaemon := wIni.ReadString('Config','Daemon','Actefd.exe');
    //
    wQtdAfil := wIni.ReadInteger('Afiliacoes','QtdAfil',1);
    wAfil_Nome := TStringList.Create;
    wAfil_CNPJ := TStringList.Create;
    wAfil_Tipo := TStringList.Create;
    for i := 1 to wQtdAfil do
    begin
      xAfil := 'Afil' + IntToStr(i);
      xParam := wIni.ReadString('Afiliacoes',xAfil,'NomeAfiliacao;00000000000000;0');
      if Copy(xParam,Length(xParam),1) = '1'        // Última posição (0 ou 1)
      then begin
        xParam := Copy(xParam,1,Length(xParam)-2);              // Somente válidos (1)
        nP := Pos(';',xParam);
        wAfil_Nome.Add(Copy(xParam,1,nP-1));                    // Nome
        wAfil_CNPJ.Add(Copy(xParam,nP+1,Length(xParam)-nP));    // CNPJ
        wAfil_Tipo.Add('C');                                    // Cartao Cr/Db
        // Nro da filiação: ocorrencia + 1
      end;
    end;
    if wPixIntegr then
    begin
      wAfil_Nome.Add(wAfilPix);
      wAfil_CNPJ.Add(wCNPJPix);
      wAfil_Tipo.Add('P');
    end;
    //
    wExecACNFe := ChangeFileExt(wIni.ReadString('ACNFe','Executavel','ACNFe6.exe'),'.exe');
    wArquivoIniACNFe := ChangeFileExt(wExecACNFe,'.ini');
    wAtivarACNFe := wIni.ReadString('ACNFe','AtivarACNFe','SHELL');
    wExibirACNFe := wIni.ReadInteger('ACNFe','Exibir',1);
    wRetornoACNFe := wIni.ReadString('ACNFe','Retorno','C:\Aplicativo\Local\RetACNFe.txt');
    wRetornoTEF := ChangeFileExt(wRetornoACNFe,'.tef');
    wRetPath := ExtractFilePath(wRetornoACNFe);
    wRetFile := ExtractFileName(wRetornoACNFe);
    wPathRetTEF := wRetPath;
    wTimeOut := wIni.ReadInteger('ACNFe','TimeOut',45);
    wPDC := wIni.ReadString('ACNFe','PDC','82404');
    wVerActefd := wIni.ReadBool('ACNFe','VerActefd',True);
    wCfgPinpad := wIni.ReadBool('ACNFe','CfgPinPad',True);
    wCmdoCancelTEF := wIni.ReadString('ACNFe','CancelarPgto','/TEF /ESTORNAR');

    wIni.Free;
    //
    if wExecACNFe = '' then
      wMsg := wMsg + 'Executável ACNFe não informado' + #13
    else begin
      wIniFile := ExtractFilePath(Application.ExeName) + wArquivoIniACNFe;
      if not FileExists(wIniFile) then
        wMsg := wMsg + 'Arquivo ' + wIniFile + '  <-- inexistente' + #13
      else begin
        wIni := TIniFile.Create(wIniFile);
        wIni.WriteString('Geral','ArquivoSaidaPadrao',FTEFPrincipal.wRetornoACNFe);
        wIni.Free;
      end;
    end;
    if wCfgPinpad and (wPDC = '')then
        wMsg := 'Permite configurar PDC, mas PDC não informado' + #13;
    if wVerActefd then
    begin
      wIniFile := ExtractFilePath(Application.ExeName) + 'Actefd.ini';
      if not FileExists(wIniFile) then
        wMsg := wMsg + 'Arquivo ' + wIniFile + '  <-- inexistente' + #13
      else begin
        wIni := TIniFile.Create(wIniFile);
        wIni.WriteInteger('TEF','Indice',1);
        wIni.Free;
      end;
      xParam := ExtractFilePath(Application.ExeName) + 'Actefd.exe';
      if not FileExists(xParam) then
        wMsg := wMsg + 'Executável ' + xParam + '  <-- inexistente' + #13;
    end;

  end;
  //
  if wMsg = '' then
  begin
    Result := True;
    Exit;
  end;
  MessageDlg('Verifique em "' + SaveIniName + {wIniFile +} '"'#13 +
             wMsg + #13#13 +
             'Processo não pode ser ativado',mtError,[mbOk],0)

end;

Procedure TEF_SobrePgma;
begin
   ExibeSobre('SISV - Sistema Integrado de Serviços e Vendas',
              'TefCobranca',
             Application.ExeName,
             'Uli Bauerle',
             'ubauerle@gmail.com',
             '(54) 99105-0456',
             '+55 54 9105-0456',
             '');

end;


Function KillTask(pExeName: string): Integer;
var
  Snapshot: THandle;
  ProcessEntry: TProcessEntry32;
  nKilled: Integer;
begin
  Result := -1;
  nKilled := 0;
  Snapshot := CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
  if Snapshot = INVALID_HANDLE_VALUE then Exit;
  ProcessEntry.dwSize := SizeOf(ProcessEntry);
  if Process32First(Snapshot, ProcessEntry) then
  begin
    repeat
      if SameText(ExtractFileName(ProcessEntry.szExeFile), pExeName) then
        if TerminateProcess(OpenProcess(PROCESS_TERMINATE, False, ProcessEntry.th32ProcessID), 0) then
        begin
          Inc(Result);
          Inc(nKilled);
        end
        else begin
          Result := 0;
          nKilled := 0;
        end;
    until not Process32Next(Snapshot, ProcessEntry);
  end;
  CloseHandle(Snapshot);
  if nKilled > 0 then
    Result := nKilled;

end;




procedure TFTEFPrincipal.btCfgPinpadMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
begin
  LabHelp.Caption := 'Configurar PINPAD';

end;

procedure TFTEFPrincipal.btCobrarClick(Sender: TObject);
var xIdArqRetorno: String;
begin
  if wModoExec = 'MANUAL' then
  begin
    FTEFCobrar.xNrOperacao := Trim(edNumero.Text);
    FTEFCobrar.xValor := xValor;
    if (FTEFCobrar.xNrOperacao = '') or
       (vOperacao = 0) then                     // edValor convertido
    begin
      MessageDlg('Informe Nr.operação e Valor',mtError,[mbOk],0);
      edNumero.SetFocus;
      Exit;
    end;
    FTEFCobrar.xArqRetorno := IncludeTrailingPathDelimiter(wPathRetorno) +
                              'RetornoTEF_' + FTEFCobrar.xNrOperacao + '(MANUAL).XML';
  end;
  wImag := ExtractFilePath(Application.ExeName) + 'TmpImag.BMP';
  FTEFPrincipal.Image1.Picture.SaveToFile(wImag);
  FTEFCobrar.Image1.Picture.LoadFromFile(wImag);
  FTEFCobrar.ShowModal;
  if wModoExec = 'AUTOM' then
  begin
    btSairClick(nil);
    Exit;
  end;
  edNumero.Text := '';
  edValor.Text := '';

end;

procedure TFTEFPrincipal.btCobrarMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
begin
  LabHelp.Caption := 'Efetuar cobrança do valor';

end;

procedure TFTEFPrincipal.btCPFClick(Sender: TObject);
var wCPF,wEdCPF,wMsg: String;
begin
  wCPF := TEF_ObterCPF;
  wEdCPF := EditaCNPJ_CPF(wCPF);
  wMsg := #13#13 + wEdCPF + '     (' + wCPF + ')';
  if wCPF = '' then
    Exit;

  if ValidaCNPJ_CPF(wCPF) then                      //  if ValidaCPF(wCPF) then   xxx
    MessageDlg('CPF VÁLIDO' + wMsg,mtInformation,[mbOk],0)
  else
    MessageDlg('CPF INVÁLIDO' + wMsg,mtError,[mbOk],0);

end;

procedure TFTEFPrincipal.btCPFMouseMove(Sender: TObject; Shift: TShiftState; X,Y: Integer);
begin
    LabHelp.Caption := 'Obter CPF';

end;

procedure TFTEFPrincipal.btEstManualClick(Sender: TObject);
begin
  EstornoManual;

end;

procedure TFTEFPrincipal.btEstManualMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
begin
    LabHelp.Caption := 'Estornar pagamento sem registro';

end;

procedure TFTEFPrincipal.btEstornarClick(Sender: TObject);
begin
  OpenDialog1.InitialDir := FTEFPrincipal.wPathRetorno;
  OpenDialog1.FilterIndex := 0;
  OpenDialog1.FileName := '';
  OpenDialog1.Title := 'Indique operação à estornar' + FTEFPrincipal.wVersao;
  OpenDialog1.Execute();
  if OpenDialog1.FileName = '' then
    Exit;
  //
  if (Pos('RET',AnsiUpperCase(OpenDialog1.FileName)) = 0) or
     (ExtractFileExt(OpenDialog1.FileName) <> '.XML') then
  begin
    MessageDlg('Arquivo selecionado é inválido para a operação',mtError,[mbOk],0);
    Exit;
  end;
  if not CriaDataSets(2) then     // Somente CDRetorno
    Exit;
  Try
    FTEFCobrar.CDRetorno.LoadFromFile(OpenDialog1.FileName);
  Except
    MessageDlg('Arquivo selecionado é inválido para a operação (LoadFromFile)',mtError,[mbOk],0);
    Exit;
  End;
  FTEFCobrar.CDRetorno.Active := True;
  FTEFCobrar.CDRetorno.First;
  FTEFEstornos.LabIdOperacao.Caption := ExtractFileName(OpenDialog1.FileName);
  FTEFEstornos.LabDtHr.Caption := 'Data/Hora: ' +
                                  DataHoraString(FTEFCobrar.CDRetornoDtHr.AsDateTime,2,1);
  FTEFEstornos.Caption := 'Estorno de pagamento' + FTEFPrincipal.wVersao;
  FTEFEstornos.ShowModal;
  FTEFCobrar.CDRetorno.SaveToFile(OpenDialog1.FileName);
  FTEFCobrar.CDRetorno.Active := False;

end;

procedure TFTEFPrincipal.btEstornarMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
    LabHelp.Caption := 'Estornar pagamento registrado';

end;

procedure TFTEFPrincipal.btSairClick(Sender: TObject);
begin
  FTEFPrincipal.Close;

end;

procedure TFTEFPrincipal.btSairMouseMove(Sender: TObject; Shift: TShiftState; X,Y: Integer);
begin
  LabHelp.Caption := 'Finalizar aplicação';

end;

procedure TFTEFPrincipal.edNumeroMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
begin
  LabHelp.Caption := 'Informe número da operação';

end;

procedure TFTEFPrincipal.edValorExit(Sender: TObject);
begin
   xValor := Trim(edValor.Text);
   if edValor.Text <> '' then
     vOperacao := StrToFloatDef(edValor.Text,0)
   else
     vOperacao := 0;
   edValor.Text := FloatToSTrF(vOperacao,ffNumber,15,2);

end;

procedure TFTEFPrincipal.edValorMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
begin
  LabHelp.Caption := 'Informe valor da operação';

end;

procedure TFTEFPrincipal.FormClose(Sender: TObject; var Action: TCloseAction);
var nRet: Integer;
    wMsg: String;
begin
  wMsg := '';
  nRet := KillTask(wDaemon);
  if nRet < 0 then
    wMsg := wDaemon + ' não ativo'
  else
    if nRet = 0 then
      wMsg := wDaemon + ' não finalizado'
    else
      wMsg := wDaemon + ' finalizado  (' + IntToStr(nRet) + ')';
  msgTimer(wMsg,wTempoFinal);
  DeleteFile(wImag);

end;

procedure TFTEFPrincipal.FormCreate(Sender: TObject);
begin
  OpenDialog1.Filter := 'Retornos TEF|RetornoTEF_*.XML';   //|' + 'Todos|*.*';
  LabHelp.Caption := '';
  btEstornar.Caption := '';
  btEstManual.Caption := '';
  btCPF.Caption := '';
  wVersao := '   ' + Versao(Application.ExeName,3,False);

end;

procedure TFTEFPrincipal.FormMouseMove(Sender: TObject; Shift: TShiftState; X,Y: Integer);
begin
  LabHelp.Caption := '';

end;

procedure TFTEFPrincipal.FormShow(Sender: TObject);
begin
  if not Leitura_Ini then
  begin
    btSairClick(nil);
    Exit;
  end;
  btEstornar.Visible := FTEFPrincipal.wEstornar;
  btEstManual.Visible := FTEFPrincipal.wEstExtra;
  btCPF.Visible := FTEFPrincipal.wObterCPF;
  btCfgPinPad.Visible := FTEFPrincipal.wCfgPinPad;
  if wModoExec = 'AUTOM' then
    btCobrarClick(nil)
  else begin
    edNumero.Text := '';
    edValor.Text := '';
    edNumero.SetFocus;
  end;
  //btSair.SetFocus;

end;

procedure TFTEFPrincipal.Image1Click(Sender: TObject);
begin
  TEF_SobrePgma;

end;

procedure TFTEFPrincipal.btCfgPinpadClick(Sender: TObject);
var wPgma,wParm: String;
begin
  if MessageDlg('Configurar Pinpad ?',mtConfirmation,[mbYes,mbNo],0) <> mrYes then
    Exit;
  if wPDC = '' then
    MessageDlg('PDC não informado',mtError,[mbOk],0)
  else begin
    wPgma := wExecACNFe;
    wParm := '/TEF /CONFIGURAR ' + wPDC;
    DeleteFile(wRetornoACNFe);
    DeleteFile(wRetornoTEF);
    EncadeamentoExecutavel(wPgma, wParm, wAtivarACNFe, wExibirACNFe);
    Sleep(2500);
    ShowMessage('Verifique retorno no pinpad');
  end;

end;

end.

