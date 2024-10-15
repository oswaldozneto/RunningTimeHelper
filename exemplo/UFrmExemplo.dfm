object frmExemplo: TfrmExemplo
  Left = 0
  Top = 0
  Caption = 'RunningTimeHelper'
  ClientHeight = 299
  ClientWidth = 577
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object memReport: TMemo
    Left = 8
    Top = 8
    Width = 385
    Height = 283
    Lines.Strings = (
      'memReport')
    ReadOnly = True
    TabOrder = 0
  end
  object btnExemplo: TButton
    Left = 448
    Top = 24
    Width = 75
    Height = 25
    Caption = 'Exemplo'
    TabOrder = 1
    OnClick = btnExemploClick
  end
end
