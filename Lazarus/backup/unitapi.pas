unit unitAPI;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, DB, BufDataset, csvdataset, Forms, Controls, Graphics,
  Dialogs, DBGrids, DBCtrls, StdCtrls, DateTimePicker, fpjson, jsonparser,
  fphttpclient;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    CSVDataset1: TCSVDataset;
    CSVDataset1Codigo: TStringField;
    CSVDataset1Nome: TStringField;
    CSVDataset1Quantidade: TStringField;
    CSVDataset1ValorTotal: TStringField;
    CSVDataset1ValorUnitario: TStringField;
    DataSource1: TDataSource;
    DateTimePicker1: TDateTimePicker;
    DateTimePicker2: TDateTimePicker;
    DBGrid1: TDBGrid;
    EditProduto: TEdit;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private

  public

  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.Button1Click(Sender: TObject);
const
   URL = 'http://localhost:8080/relatorio/produtos?';
   dataIn = '&dataInicial=';
   dataFin = '&dataFinal=';
   codigoPro = '&codigoProduto=';
var
  VParse: TJSONParser;
  VJson: TJSONArray;
  Str: String;
  data1, data2: String;
  valueEnum:TJSONEnum;
  item:TJSONObject;


begin
  try
    data1 := FormatDateTime('YYYY-MM-DD', DateTimePicker1.Date);
    data2 := FormatDateTime('YYYY-MM-DD', DateTimePicker2.Date);
    Str := TFPHTTPClient.SimpleGet(URL+dataIn+data1+dataFin+data2+codigoPro+EditProduto.Text);
    VParse := TJSONParser.Create(Str);
    VJson:=(VParse.Parse as TJSONArray);

    for valueEnum in VJson do begin
      CSVDataset1.Append;
      item := TJSONObject(valueEnum.Value);
      CSVDataset1Codigo.AsString := item.Find('Codigo').AsString;
      CSVDataset1Nome.AsString := item.Find('Nome').AsString;
      CSVDataset1Quantidade.AsString := item.Find('Quantidade').AsString;
      CSVDataset1ValorUnitario.AsString := item.Find('ValorUnitario').AsString;
      CSVDataset1ValorTotal.AsString := item.Find('ValorTotal').AsString;
      CSVDataset1.post;
    end;
  finally
    FreeAndNil(VParse);
    FreeAndNil(VJson);
  end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
   CSVDataset1.CreateDataset;
end;

end.

