program RTHExemplo;

uses
  Vcl.Forms,
  UFrmExemplo in 'UFrmExemplo.pas' {frmExemplo},
  URunningTimeHelper in '..\src\URunningTimeHelper.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmExemplo, frmExemplo);
  Application.Run;
end.
