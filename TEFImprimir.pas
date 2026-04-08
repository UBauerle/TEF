unit TEFImprimir;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, RLReport, RLPrinters, Data.DB, Datasnap.DBClient;
  Procedure ImprimeComprovante(pmtArqTxt:String; pmtPreview:Boolean=False);

type
  TFTEFImprimir = class(TForm)
    RLComprovante: TRLReport;
    RLBand1: TRLBand;
    RLCabecalho: TRLBand;
    RLRodape: TRLBand;
    RLLabHeader: TRLLabel;
    RLLabFooter: TRLLabel;
    CDImpr: TClientDataSet;
    SCDImpr: TDataSource;
    CDImprLinha: TStringField;
    RLDBLinha: TRLDBText;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FTEFImprimir: TFTEFImprimir;
  lPreview: Boolean;

implementation

{$R *.dfm}

uses TEFPrincipal, FortesReportCtle, uSysPrinters;    // uGenericas;


Function CriaAbreImpr: Boolean;
begin
  with FTEFImprimir
  do begin
    CDImpr.Active  := False;
    CDImpr.FieldDefs.Clear;
    CDImpr.FieldDefs.Add('Linha', ftString, 40);
    CDImpr.CreateDataSet;
    Try
      CDImpr.Active := True;
      Result := True;
    Except
      Result := False;
    End;

  end;

end;


Procedure ImprimeComprovante(pmtArqTxt:String; pmtPreview:Boolean=False);
var nAltura,tmPagina,i: Integer;
    xPrinter,xportaPrt,xdriverPrt: String;
    indexPrt: Integer;
    lstLinhas: TStringList;
begin
  FTEFImprimir := TFTEFImprimir.Create(nil);
  with FTEFImprimir do
  begin
    if not FileExists(pmtArqTxt) then
      Exit;
    lstLinhas := TStringList.Create;
    lstLinhas.LoadFromFile(pmtArqTxt);
    //
    CriaAbreImpr;
    for i := 0 to lstLinhas.count-1 do
    begin
      CDImpr.Append;
      CDImprLinha.AsString := lstLinhas[i];
      CDImpr.Post;
    end;
    lstLinhas.Free;
    CDImpr.First;
    //
    lPreview := pmtPreview;
    RLComprovante.Margins.TopMargin := FTEFPrincipal.wMargTopo;
    RLComprovante.Margins.BottomMargin := FTEFPrincipal.wMargRodape;
    RLComprovante.Margins.LeftMargin := FTEFPrincipal.wMargEsq;
    RLComprovante.Margins.RightMargin := FTEFPrincipal.wMargDir;
    //
    RLLabHeader.Caption := '_';
    RLLabFooter.Caption := '_';
    nAltura := FTEFPrincipal.wMargTopo + FTEFPrincipal.wMargRodape +
               RLCabecalho.Height + RLRodape.Height +
               (CDImpr.RecordCount * 12);
    tmPagina := Trunc(nAltura / 3.7795) + 1;
    if tmPagina < 35 then
      tmPagina := 35
    else if tmPagina > 80 then
              tmPagina := 80;
    //
    xPrinter := FTEFPrincipal.wImpressora;
    if not DefineImpressora(True,xPrinter,xportaPrt,xdriverPrt,indexPrt) then
      lPreview := True;
    //
    RLComprovante.PageSetup.PaperHeight := tmPagina;
    FFRCtle.RLPreviewSetup1.CustomActionText := '';      // 'Impressao';  //lstAction;
    RLComprovante.PrintDialog := lPreview;
    RLPrinters.RLPrinter.PrinterName := xPrinter;
    //
    if lPreview then
      RLComprovante.Preview
    else
      RLComprovante.Print;
    //
    CDImpr.EmptyDataSet;
    CDImpr.Active := False;

  end;
  FTEFImprimir.Free;
end;

end.
