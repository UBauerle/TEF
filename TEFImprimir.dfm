object FTEFImprimir: TFTEFImprimir
  Left = 0
  Top = 0
  Caption = 'FTEFImprimir'
  ClientHeight = 530
  ClientWidth = 624
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Courier New'
  Font.Style = []
  TextHeight = 15
  object RLComprovante: TRLReport
    Left = 8
    Top = 16
    Width = 302
    Height = 189
    Margins.LeftMargin = 8.000000000000000000
    Margins.TopMargin = 5.000000000000000000
    Margins.RightMargin = 8.000000000000000000
    Margins.BottomMargin = 5.000000000000000000
    DataSource = SCDImpr
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -9
    Font.Name = 'Courier New'
    Font.Style = []
    PageSetup.PaperSize = fpCustom
    PageSetup.PaperWidth = 80.000000000000000000
    PageSetup.PaperHeight = 50.000000000000000000
    object RLBand1: TRLBand
      Left = 30
      Top = 39
      Width = 242
      Height = 12
      AutoSize = True
      object RLDBLinha: TRLDBText
        Left = 0
        Top = 0
        Width = 30
        Height = 12
        Align = faLeftTop
        DataField = 'Linha'
        DataSource = SCDImpr
        Text = ''
      end
    end
    object RLCabecalho: TRLBand
      Left = 30
      Top = 19
      Width = 242
      Height = 20
      BandType = btHeader
      object RLLabHeader: TRLLabel
        Left = 0
        Top = 0
        Width = 242
        Height = 12
        Align = faTop
        Alignment = taCenter
      end
    end
    object RLRodape: TRLBand
      Left = 30
      Top = 51
      Width = 242
      Height = 20
      BandType = btFooter
      object RLLabFooter: TRLLabel
        Left = 0
        Top = 8
        Width = 242
        Height = 12
        Align = faBottom
        Alignment = taCenter
      end
    end
  end
  object CDImpr: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 373
    Top = 31
    object CDImprLinha: TStringField
      FieldName = 'Linha'
      Size = 40
    end
  end
  object SCDImpr: TDataSource
    DataSet = CDImpr
    Left = 417
    Top = 31
  end
end
