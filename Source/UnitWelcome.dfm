object FormWelcome: TFormWelcome
  Left = 687
  Top = 422
  BorderIcons = []
  BorderStyle = bsDialog
  Caption = 'HLHL Ver1.2.07'
  ClientHeight = 159
  ClientWidth = 213
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -15
  Font.Name = #23435#20307
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 15
  object lblUpdateTime: TLabel
    Left = 17
    Top = 3
    Width = 152
    Height = 15
    Caption = 'Updated: 2022.08.31'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = #40657#20307
    Font.Style = []
    ParentFont = False
  end
  object lblSelectID: TLabel
    Left = 6
    Top = 30
    Width = 56
    Height = 15
    Caption = 'Player:'
  end
  object lblEditer: TLabel
    Left = 57
    Top = 86
    Width = 112
    Height = 13
    Caption = 'HlReborn Edition'
    Font.Charset = GB2312_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = #23435#20307
    Font.Style = []
    ParentFont = False
  end
  object lblLinkBBS: TLabel
    Left = 57
    Top = 101
    Width = 40
    Height = 16
    Cursor = crHandPoint
    Alignment = taCenter
    Caption = '<Link>'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = [fsUnderline]
    ParentFont = False
    OnClick = lblLinkBBSClick
  end
  object lblThank: TLabel
    Left = 0
    Top = 133
    Width = 213
    Height = 26
    Align = alBottom
    Caption = 'Please insure map.ini is present.'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = #38582#20070
    Font.Style = []
    ParentFont = False
    WordWrap = True
    ExplicitWidth = 175
  end
  object cmbGameList: TComboBox
    Left = 76
    Top = 26
    Width = 125
    Height = 23
    Style = csDropDownList
    ImeName = #32043#20809#25340#38899#36755#20837#27861
    TabOrder = 0
    OnChange = cmbGameListChange
    OnKeyDown = cmbGameListKeyDown
  end
  object btnOK: TButton
    Left = 5
    Top = 58
    Width = 60
    Height = 22
    Caption = 'OK'
    Enabled = False
    ModalResult = 1
    TabOrder = 1
  end
  object btnExit: TButton
    Left = 143
    Top = 57
    Width = 60
    Height = 22
    Caption = 'Close'
    ModalResult = 2
    TabOrder = 2
  end
  object btnRefresh: TButton
    Left = 71
    Top = 57
    Width = 66
    Height = 22
    Caption = 'Refresh'
    TabOrder = 3
    OnClick = btnRefreshClick
  end
end
