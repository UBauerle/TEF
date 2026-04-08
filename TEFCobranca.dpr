program TEFCobranca;

uses
  Vcl.Forms,
  SysUtils,
  Dialogs,
  MidasLib,
  TEFPrincipal in 'TEFPrincipal.pas' {FTEFPrincipal},
  TEFCobrar in 'TEFCobrar.pas' {FTEFCobrar},
  uGenericas in '..\UsoGeral\uGenericas.pas' {FGen},
  TEFImprimir in 'TEFImprimir.pas' {FTEFImprimir},
  FortesReportCtle in '..\uFortesReport\FortesReportCtle.pas' {FFRCtle},
  SelfPrintDefs in '..\uFortesReport\SelfPrintDefs.pas',
  uSysPrinters in '..\UsoGeral\uSysPrinters.pas' {FuSysPrinters},
  TEFEstornos in 'TEFEstornos.pas' {FTEFEstornos},
  TEFEstManual in 'TEFEstManual.pas' {FTEFEstManual},
  TEFCPF in 'TEFCPF.pas' {FuTEFCPF},
  uSobre10 in '..\UsoGeral\uSobre10.pas' {FSobre},
  uProcessos in '..\UsoGeral\uProcessos.pas',
  uMsgTimer in '..\UsoGeral\uMsgTimer.pas' {FuMsgTimer};

var
  wExePath,wExeName,wUser,wAcess,wPath: String;
  wIdOperacao,wValor: String;
  wArqRetorno: String;
  wModoExec: String;
  wParm1: String;

{$R *.res}

begin
  wUser    := '';
  wAcess   := '';
  wPath    := '';
  wExePath := ExtractFilePath(Application.ExeName);
  wExeName := ExtractFileName(Application.ExeName);
  FormatSettings.ShortDateFormat  := 'dd/mm/yyyy';
  FormatSettings.DecimalSeparator := ',';

  if not exVerificaFinalizaProcesso(wExeName        // Executavel
                                    ,True           // Exibe mensagem
                                    ,False)         // Não permite outro processo
     then Halt(0);
  //
  if ParamCount = 0 then
  begin
    wIdOperacao := '';
    wValor := '';
    wArqRetorno := '';
    wModoExec := 'MANUAL';
  end
  else begin
    wParm1 := AnsiUpperCase(ParamStr(1));
    if (Pos('AJUDA',wParm1) > 0) or
       (Pos('HELP',wParm1) > 0) or
       (Pos('?',wParm1) > 0) then
    begin
      MessageDlg('Comando:' + #13 +
                 'TEFCobranca IdOperacao VlrOperacao' + #13 +
                 '  IdOperacao: Nro de uma operação / venda' + #13 +
                 '  VlrOperacao: Valor a ser considerado (Ex: 125,46)' + #13#13 +
                 'Em ParmGerais (uso em "Caixa"):' + #13 +
                 '  TEF_COBRAR_PGTOMISTO: S  ou  N' + #13 +
                 '  TEF_COBRAR_RETORNO: Path retorno'+ #13 +
                 '     Ex: C:\TEFCobr\Retornos',
                 mtInformation,[mbOk],0);
      Halt(0);
    end;

    if ParamCount < 3 then
    begin
      MessageDlg('Erro de parametros, obrigatório 3'+ #13 +
                 'Nr.operação, Valor e Arq.retorno' + #13 +
                 'Informado: ' + IntToStr(ParamCount) + #13 +
                 'Processo finalizado',mtError,[mbOk],0);
      Halt(0);
    end;
    wIdOperacao := ParamStr(1);
    wValor := ParamStr(2);
    wArqRetorno := ParamStr(3);
    wModoExec := 'AUTOM';
  end;
  //
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFTEFPrincipal, FTEFPrincipal);
  Application.CreateForm(TFTEFCobrar, FTEFCobrar);
  Application.CreateForm(TFTEFImprimir, FTEFImprimir);
  Application.CreateForm(TFGen, FGen);
  Application.CreateForm(TFFRCtle, FFRCtle);
  Application.CreateForm(TFuSysPrinters, FuSysPrinters);
  Application.CreateForm(TFTEFEstornos, FTEFEstornos);
  Application.CreateForm(TFTEFEstManual, FTEFEstManual);
  Application.CreateForm(TFuTEFCPF, FuTEFCPF);
  Application.CreateForm(TFSobre, FSobre);
  //
  FTEFPrincipal.wModoExec := wModoExec;
  FTEFCobrar.xNrOperacao := wIdOperacao;
  FTEFCobrar.xValor := wValor;
  FTEFCobrar.xArqRetorno := wArqRetorno;
  //
  Application.Run;

end.

