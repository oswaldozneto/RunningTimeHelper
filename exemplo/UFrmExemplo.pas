unit UFrmExemplo;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, URunningTimeHelper;

type
  TfrmExemplo = class(TForm)
    memReport: TMemo;
    btnExemplo: TButton;
    procedure btnExemploClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmExemplo: TfrmExemplo;

implementation

{$R *.dfm}

procedure Aguardar(AMin, AMax: Integer);
var
  Delay: Integer;
begin
  Randomize;
  Delay := AMin + Random(AMax - AMin + 1);
  Sleep(Delay);
end;



procedure TfrmExemplo.btnExemploClick(Sender: TObject);
var
  I: Integer;
begin
  {
    O objetivo aqui � utilizar essas chamadas apenas em desenvolvimento para analisar o tempo de processamento
    e depois remover as chamadas bem como a refer�ncia � URunningTimeHelper.
    A tabula��o ilustra a hierarquia na qual os blocos de tomada de tempo ser�o criados, a regra geral
    � que se um bloco for criado sem que o anterior seja parado ele se tornar� um filho do bloco anterior,
    e se o anterior for parado antes do in�cio de um novo ent�o o novo ficara no mesmo n�vel do anterior.
  }

  Screen.Cursor := crHourGlass;

  //RTHInit inicializa a tomada de tempo. Antes do init o RTHStart, RTHStop, RTHReport n�o ter�o efeito
  RTHInit('Geral');

      Aguardar(100, 200);

      //Inicia o Bloco 1 que vai ser "filho" do Geral.
      RTHStart('Bloco 1');

      Aguardar(50, 300);

      //Para o bloco anteiror (Bloco 1) e cria um novo bloco (Bloco 2), Bloco 1 e 2 s�o "irm�os filhos do Geral".
      RTHStopStart('Bloco 2');

          for i:= 1 to 10 do begin

            //Inicia o Bloco 2.1 "filho" de Bloco 2
            //Como est� dentro de um loop a tomada de tempo ser� acumulada e o relat�rio vai mostrar o n�mero de parciais
            RTHStart('Bloco 2.1');

            Aguardar(10, 50);

            //Para o bloco 2.1
            RTHStop;
          end;

          //Cria o bloco 2.2 "filho" de Bloco 2.
          RTHStart('Bloco 2.2');

          Aguardar(50, 150);

          //Para o bloco 2.2 e volta para o n�vel anterior
          RTHStop;

      //Para o Bloco 2 e inicia o Bloco 3
      RTHStopStart('Bloco 3');

      Aguardar(50, 150);

      //Para o bloco 3;
      RTHStop;

  Screen.Cursor := crDefault;

  //Para tudo que ainda n�o parou e gera o relat�rio, exemplo:
  //-Nome do bloco: 123 ms (5)
  //onde 5 � o n�mero de parciais e 123 � o tempo total em milissegundos
  memReport.Text := RTHReport;

end;

end.
