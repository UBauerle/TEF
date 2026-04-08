unit TEFCPF;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, ExtCtrls, StdCtrls, Buttons, Mask, IniFiles;
  Function TEF_ObterCPF(pExibir:Boolean = False): String;

type
  TFuTEFCPF = class(TForm)
    Panel1: TPanel;
    LabMsg1: TLabel;
    btSim: TBitBtn;
    btNao: TBitBtn;
    LabMsg2: TLabel;
    sbBorda: TSpeedButton;
    procedure btNaoClick(Sender: TObject);
    procedure btSimClick(Sender: TObject);
    procedure sbBordaClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FuTEFCPF: TFuTEFCPF;
  wExec,wParm,wAtivar,wCPF: String;
  nShow,wTimeOut: Integer;
  wIni: TIniFile;
  wArqIni,wArqSaida: String;
  wBorda: Integer;

implementation

uses uGenericas, TEFPrincipal;

{$R *.dfm}


Function TEF_ObterCPF(pExibir:Boolean = False): String;
var wSaveArqSaida: String;
begin
  wBorda := 3;
  Result := '';
  wExec := FTEFPrincipal.wExecACNFe;
  wParm := '/TEF /OBTERCPF';
  wAtivar := FTEFPrincipal.wAtivarACNFe;
  nShow := FTEFPrincipal.wExibirACNFe;
  wTimeOut := FTEFPrincipal.wTimeOut;
  wArqIni := ExtractFilePath(Application.ExeName) + ChangeFileExt(wExec,'.ini');
  wArqSaida := ExtractFilePath(Application.ExeName) + 'SaidaCPF.Txt';
  if not FileExists(wArqIni) then
  begin
    MessageDlg('Não é possivel obter CPF' + #13 + 'Arquivo de inicializacao [ ' + wArqIni + ' ] inexistente',
               mtError,[mbOk],0);
    Exit;
  end;
  wIni := TIniFile.Create(wArqIni);
  wSaveArqSaida := wIni.ReadString('Geral','ArquivoSaidaPadrao','XXX');
  wIni.WriteString('Geral','ArquivoSaidaPadrao',wArqSaida);
  wIni.Free;
  //

  FuTEFCPF := TFuTEFCPF.Create(nil);
  FuTEFCPF.Caption := 'Informar CPF' + FTEFPrincipal.wVersao;
  FuTEFCPF.LabMsg2.Caption := '';
  wCPF := '';
  if pExibir then
  begin
    FuTEFCPF.LabMsg1.Caption := 'Informar CPF ?';
    FuTEFCPF.btSim.Visible := True;
    FuTEFCPF.btNao.Visible := True;
    FuTEFCPF.sbBorda.Visible := True;
    FuTEFCPF.Height := 260;
    FuTEFCPF.ShowModal;
  end
  else begin
    FuTEFCPF.LabMsg1.Caption := 'Informe CPF';
    FuTEFCPF.btSim.Visible := False;
    FuTEFCPF.btNao.Visible:= False;
    FuTEFCPF.Height := 146;
    FuTEFCPF.Show;
    FuTEFCPF.btSimClick(nil);
  end;
  Result := wCPF;
  FuTEFCPF.Free;
  //
  if wSaveArqSaida <> 'XXX' then
  begin
    wIni := TIniFile.Create(wArqIni);
    wIni.WriteString('Geral','ArquivoSaidaPadrao',wSaveArqSaida);
    wIni.Free;
  end;

end;


procedure TFuTEFCPF.btNaoClick(Sender: TObject);
begin
  wCPF := '';
  FuTEFCPF.Close;

end;

procedure TFuTEFCPF.btSimClick(Sender: TObject);
var i: Integer;
    wConteudo: TStringList;
begin
  btSim.Enabled := False;
  btNao.Enabled := False;
  LabMsg2.Caption := '...';
  LabMsg2.Visible := True;
  Application.ProcessMessages;
  //
  DeleteFile(wArqSaida);
  EncadeamentoExecutavel(wExec,wParm,wAtivar,nShow);
  //
  LabMsg2.Caption := '... Aguarde';
  Application.ProcessMessages;
  wConteudo := TStringList.Create;
  //
  for i := 1 to wTimeOut do
  begin
    if FileExists(wArqSaida) then
    begin
      wConteudo.Clear;
      wConteudo.LoadFromFile(wArqSaida);
      wCPF := Copy(wConteudo[0],84,11);
      Break;
    end
    else
      Sleep(1000);
  end;
  wCPF := Trim(wCPF);
  wConteudo.Free;
  FuTEFCPF.Close;

end;

procedure TFuTEFCPF.sbBordaClick(Sender: TObject);
begin
  wBorda := wBorda + 1;
  if wBorda > 5 then
    wBorda := 0;
  FuTEFCPF.BorderStyle := TFormBorderStyle(wBorda);

end;

procedure TFuTEFCPF.FormActivate(Sender: TObject);
begin
  Form_Define(FuTEFCPF);

end;

procedure TFuTEFCPF.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Form_Salva(FuTEFCPF);

end;

end.
