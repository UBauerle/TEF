object FTEFEstornos: TFTEFEstornos
  Left = 0
  Top = 0
  Caption = 'Cancelamentos'
  ClientHeight = 371
  ClientWidth = 852
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Position = poScreenCenter
  OnActivate = FormActivate
  OnResize = FormResize
  TextHeight = 16
  object PanCobrancas: TPanel
    Left = 0
    Top = 30
    Width = 852
    Height = 276
    Align = alClient
    TabOrder = 0
    object dbGrid: TDBGrid
      Left = 1
      Top = 1
      Width = 850
      Height = 274
      Align = alClient
      DataSource = FTEFCobrar.DSRetorno
      DrawingStyle = gdsClassic
      FixedColor = clMoneyGreen
      TabOrder = 0
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -13
      TitleFont.Name = 'MS Sans Serif'
      TitleFont.Style = []
      Columns = <
        item
          Alignment = taCenter
          Expanded = False
          FieldName = 'Seq'
          Title.Alignment = taCenter
          Width = 31
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'Valor'
          Title.Alignment = taRightJustify
          Width = 83
          Visible = True
        end
        item
          Alignment = taCenter
          Expanded = False
          FieldName = 'ZC_TPag'
          Title.Alignment = taCenter
          Title.Caption = 'Pgt'
          Width = 41
          Visible = True
        end
        item
          Alignment = taCenter
          Expanded = False
          FieldName = 'ZC_Status'
          Title.Alignment = taRightJustify
          Title.Caption = 'Status'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'Autorizacao'
          Title.Caption = 'Autoriza'#231#227'o'
          Width = 140
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'Referencia'
          Title.Caption = 'Refer'#234'ncia'
          Width = 140
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'NSU'
          Width = 140
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'Cartao'
          Title.Caption = 'Cart'#227'o'
          Width = 117
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'Bandeira'
          Visible = True
        end>
    end
  end
  object PanRodape: TPanel
    Left = 0
    Top = 306
    Width = 852
    Height = 65
    Align = alBottom
    TabOrder = 1
    object LabEstornar: TLabel
      Left = 452
      Top = 12
      Width = 73
      Height = 16
      Caption = 'LabEstornar'
      Visible = False
    end
    object DBNavigator1: TDBNavigator
      Left = 12
      Top = 8
      Width = 152
      Height = 45
      DataSource = FTEFCobrar.DSRetorno
      VisibleButtons = [nbFirst, nbPrior, nbNext, nbLast]
      Ctl3D = True
      ParentCtl3D = False
      TabOrder = 0
    end
    object btEstornar: TBitBtn
      Left = 212
      Top = 8
      Width = 221
      Height = 45
      Caption = '&Estornar pagamento'
      Glyph.Data = {
        76040000424D7604000000000000760000002800000040000000200000000100
        0400000000000004000000000000000000001000000000000000000000000000
        8000008000000080800080000000800080008080000080808000C0C0C0000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00DDDDDDDDDDDD
        DDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDD
        DDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDD
        DDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDFFFFDDDDDDDDDDDDDDDDDDDDDDDDDDD22
        22DDDDDDDDDDDDDDDDDDDDDDDDDDDD8888FDDDDDDDDDDDDDDDDDDDDDDDDDDD22
        222DDDDDDDDDDDDDDDDDDDDDDDDDDD88888FDDDDDDDDDDDDDDDDDDDDDDDDDD22
        222DDDDDDDDDDDDDDDDDDDDDDDDDDD88888FDDDDDDDDDDDDDDDDDDDDDDDDDD22
        222DDDDDDDDDDDDDDDDDDDDDDDDDDD88888FDDDDDDDDDDDDDDDDDDDDDDDDD222
        2222DDDDDDDDDDDDDDDDDDDDDDDDD8888888FDDDDDDDDDDDDDDDDDDDDDDDD222
        2222DDDDDDDDDDDDDDDDDDDDDDDDD8888888FDDDDDDDDDDDDDDDDDDDDDDDD222
        22222DDDDDDDDDDDDDDDDDDDDDDDD88888888FDDDDDDDDDDDDDDDDDDDDDD2222
        22222DDDDDDDDDDDDDDDDDDDDDDD888888888FDDDDDDDDDDDDDDDDDDDDDD2222
        D2222DDDDDDDDDDDDDDDDDDDDDDD8888F8888FDDDDDDDDDDDDDDDDDDDDDD2222
        DD2222DDDDDDDDDDDDDDDDDDDDDD8888FD8888FDDDDDDDDDDDDDDDDDDDD22222
        DD2222DDDDDDDDDDDDDDDDDDDDD88888DD8888FDDDDDDDDDDDDDDDDDDDD2222D
        DD22222DDDDDDDDDDDDDDDDDDDD8888DDD88888FDDDDDDDDDDDDDDDDDD22222D
        DDD22222DDDDDDDDDDDDDDDDDD88888DDDD88888FDDDDDDDDDDDDDDDDD2222DD
        DDD22222DDDDDDDDDDDDDDDDDD8888DDDDD88888FDDDDDDDDDDDDDDDD22222DD
        DDDD22222DDDDDDDDDDDDDDDD88888DDDDDD88888FDDDDDDDDDDDDDD22222DDD
        DDDDD22222DDDDDDDDDDDDDD88888DDDDDDDD88888FDDDDDDDDDDDD222222DDD
        DDDDD222222DDDDDDDDDDDD888888DDDDDDDD888888FDDDDDDDDD2222222DDDD
        DDDDDD222222DDDDDDDDD8888888DDDDDDDDDD888888FDDDDDDDDD22222DDDDD
        DDDDDDD222222DDDDDDDDD88888DDDDDDDDDDDD888888FDDDDDDDDD222DDDDDD
        DDDDDDDD222222DDDDDDDDD888DDDDDDDDDDDDDD888888FFDDDDDDDDDDDDDDDD
        DDDDDDDDD2222222DDDDDDDDDDDDDDDDDDDDDDDDD8888888FDDDDDDDDDDDDDDD
        DDDDDDDDDD2222222DDDDDDDDDDDDDDDDDDDDDDDDD8888888FFDDDDDDDDDDDDD
        DDDDDDDDDDD2222222DDDDDDDDDDDDDDDDDDDDDDDDD8888888FDDDDDDDDDDDDD
        DDDDDDDDDDDDD22222DDDDDDDDDDDDDDDDDDDDDDDDDDD88888FDDDDDDDDDDDDD
        DDDDDDDDDDDDDD2222DDDDDDDDDDDDDDDDDDDDDDDDDDDD8888FDDDDDDDDDDDDD
        DDDDDDDDDDDDDDD222DDDDDDDDDDDDDDDDDDDDDDDDDDDDD888DDDDDDDDDDDDDD
        DDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDD
        DDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDD
        DDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDD}
      NumGlyphs = 2
      TabOrder = 1
      OnClick = btEstornarClick
    end
    object btSair: TBitBtn
      Left = 693
      Top = 8
      Width = 137
      Height = 45
      Caption = '&Sair'
      Glyph.Data = {
        76020000424D7602000000000000760000002800000020000000200000000100
        0400000000000002000000000000000000001000000000000000000000000000
        8000008000000080800080000000800080008080000080808000C0C0C0000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00FFF000000000
        0000000000000000FFFFFFF010BBBBBBBBBBBBBBBBBBBBB0FFFFFFF011000BBB
        BBBBBBBBBBBBBBB0FFFFFFF01111100BBBBBBBBBBBBBBBB0FFFFFFF011111110
        0BBBBBBBBBBBBBB0FFFFFFF011111111100BBBBBBBBBBBB0FFFFFFF011111111
        11100BBBBBBBBBB0FFFFFFF01111111111110BBBBBBBBBB0FFFFFFF011111111
        11110BBBBBBBBBB0FFFFFFF01111111111110BBBBBBBBBB0FFFFFFF011111111
        11110BBBBBBBBBB0FFFFFFF01111111111110BBBBBBBBBB0FFFFFFF011111111
        11110BBBBBBBBBB09FFFFFF01111111111110BBBB99BBBB999FFFFF011111111
        11110BBBB99BBB99999FFFF01111111111110BBBB99BB999999FFFF011111111
        11110BBBB99B999999FFFFF01111111111110BBBB99999999FFFFFF011111111
        111000BBB9999999FFFFFFF011111111110880BBB9999990FFFFFFF011111111
        110880BBB99999B0FFFFFFF011111111111000BBB999999999FFFFF011111111
        11110BBBB999999999FFFFF01111111111110BBBBBBBBBB0FFFFFFF011EE1111
        11110BBBBBBBBBB0FFFFFFF011EEE11111110BBBBBBBBBB0FFFFFFF011EEEEE1
        11110BBBBBBBBBB0FFFFFFF011EEEEEEE1110BBBBBBBBBB0FFFFFFF011EEEEEE
        EE110BBBBBBBBBB0FFFFFFF011111EEEEE110BBBBBBBBBB0FFFFFFF0111111EE
        EE110BBBBBBBBBB0FFFFFFF0000000000000000000000000FFFF}
      TabOrder = 2
      OnClick = btSairClick
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 852
    Height = 30
    Align = alTop
    TabOrder = 2
    object Label1: TLabel
      Left = 20
      Top = 8
      Width = 67
      Height = 16
      Caption = 'Opera'#231#227'o: '
    end
    object LabIdOperacao: TLabel
      Left = 88
      Top = 8
      Width = 95
      Height = 16
      Caption = 'LabIdOperacao'
    end
    object LabDtHr: TLabel
      Left = 764
      Top = 7
      Width = 66
      Height = 16
      Alignment = taRightJustify
      Caption = 'Data/Hora:'
    end
  end
end
