unit URunningTimeHelper;

interface

uses
  System.Diagnostics, Generics.Collections, Classes;

type
  TRunningTime = class
    LSWatch: TStopWatch;
    LParent: TRunningTime;
    LElapsedTicks: Int64;
    LCount: Integer;
    LChilds: TDictionary<string, TRunningTime>;
    LChildKeys: TList<string>;
    LKey: string;
    LStarted: boolean;
  public
    constructor create(const Key: string);
    destructor destroy; override;

    procedure Start;
    procedure Stop;
    function Report: TStringList;
    procedure AddChild(const Key: string);

    property Key: string read LKey write LKey;
    property Parent: TRunningTime read LParent write LParent;
    property Childs: TDictionary<string, TRunningTime> read LChilds;
  end;

procedure RTHReset;

procedure RTHInit(const Key: string);

procedure RTHStart(const Key: string);

procedure RTHStopStart(const Key: string);

procedure RTHStop;

function RTHReport: string;

implementation

uses
  System.SysUtils;

var
  RHTIncialized: boolean;
  RTHCurrent: TRunningTime;

procedure RTHReset;
begin
  RTHStop;
  if assigned(RTHCurrent) then
    FreeAndNil(RTHCurrent);
  RHTIncialized := true;
end;

procedure RTHInit(const Key: string);
begin
  RTHReset;
  RTHStart(Key);
end;

procedure RTHStart(const Key: string);
var
  LNew: TRunningTime;
begin
  if not RHTIncialized then
    exit;
  if assigned(RTHCurrent) then
  begin
    if not RTHCurrent.Childs.ContainsKey(Key) then
      RTHCurrent.AddChild(Key);
    RTHCurrent.Childs[Key].Parent := RTHCurrent;
    RTHCurrent := RTHCurrent.Childs[Key];
  end
  else
    RTHCurrent := TRunningTime.create(Key);
  RTHCurrent.Start;
end;

procedure RTHStopStart(const Key: string);
begin
  RTHStop;
  RTHStart(Key);
end;

procedure RTHStop;
begin
  if not RHTIncialized then
    exit;
  if assigned(RTHCurrent) then
  begin
    RTHCurrent.Stop;
    if assigned(RTHCurrent.Parent) then
      RTHCurrent := RTHCurrent.Parent;
  end;
end;

function RTHReport: string;
var
  LCurrent: TRunningTime;
begin
  Result := '';
  LCurrent := RTHCurrent;
  if assigned(LCurrent) then
    while assigned(LCurrent.Parent) do
      LCurrent := LCurrent.Parent;
  if assigned(LCurrent) then
  begin
    Result := LCurrent.Report.Text;
    LCurrent.Report.Free;
    FreeAndNil(LCurrent);
  end;
  RTHCurrent := nil;
  RHTIncialized := false;
end;

constructor TRunningTime.create(const Key: string);
begin
  LChilds := TDictionary<string, TRunningTime>.Create;
  LChildKeys := TList<string>.Create;
  Self.Key := Key;
  LCount := 0;
end;

destructor TRunningTime.destroy;
var
  LItem: TPair<string, TRunningTime>;
begin
  if Assigned(LChilds) then begin
    for LItem in LChilds do
      LItem.Value.Free;
    FreeAndNil(LChilds);
  end;
  if assigned(LChildKeys) then
    FreeAndNil(LChildKeys);
  inherited;
end;

procedure TRunningTime.Start;
begin
  if LStarted then
  begin
    LSWatch.Stop;
    LElapsedTicks := LElapsedTicks + LSWatch.ElapsedTicks;
  end;
  Inc(LCount);
  LSWatch := TStopWatch.StartNew;
  LStarted := true;
end;

procedure TRunningTime.AddChild(const Key: string);
begin
  if not LChilds.ContainsKey(Key) then
  begin
      LChilds.Add(Key, TRunningTime.Create(Key));
      LChilds[Key].Parent := Self;
      LChildKeys.Add(Key);
  end;
end;

procedure TRunningTime.Stop;
begin
  if LStarted then
    LSWatch.Stop;
end;

function TRunningTime.Report: TStringList;
var
  LCReport: TStringList;
  I: Integer;
  LKey: string;
begin
  Result := TStringList.Create;
  Result.Add(Format('- %s: %.2f ms (%d)', [Key, (LElapsedTicks + LSWatch.ElapsedTicks) / LSWatch.Frequency * 1000, LCount]));
  for LKey in LChildKeys do
  begin
    LCReport := Childs[LKey].Report;
    for I := 0 to Pred(LCReport.Count) do
      Result.Add(Format('   %s', [LCReport[I]]));
    LCReport.Free;
  end;
  Stop;
end;

end.

