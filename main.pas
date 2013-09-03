unit main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ExtCtrls, SdpoSerial;

type

  { TfrmMain }

  TfrmMain = class(TForm)
    btnPause: TButton;
    Button1: TButton;
    btnRoll: TButton;
    btnGo: TButton;
    ePort: TEdit;
    lblTime: TLabel;
    lblDice: TLabel;
    Panel1: TPanel;
    serial: TSdpoSerial;
    tmrStopWatch: TTimer;
    procedure btnGoClick(Sender: TObject);
    procedure btnPauseClick(Sender: TObject);
    procedure btnRollClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure serialRxData(Sender: TObject);
    procedure tmrStopWatchTimer(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  frmMain: TfrmMain;
  D1, D2, Dtot: integer;
      mytime: integer;
      player: integer;

implementation

{$R *.lfm}

{ TfrmMain }

procedure rollDice();
begin
  D1 := 1+random(6);
  D2 := 1+random(6);
  Dtot := D1+D2;
end;

procedure TfrmMain.btnRollClick(Sender: TObject);
begin
  rollDice();
  lblDice.caption := inttostr(D1) + '+' + inttostr(D2) + '= ' + inttostr(Dtot);
end;

procedure TfrmMain.btnGoClick(Sender: TObject);
begin
  tmrStopWatch.Enabled:=true;
end;

procedure TfrmMain.btnPauseClick(Sender: TObject);
begin
    tmrStopWatch.Enabled:=false;
end;

procedure TfrmMain.Button1Click(Sender: TObject);
begin
  serial.Device:= eport.Text;
  serial.Active:=true;
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  randomize();
  player := 1;
end;

procedure doCommand(c: char);
begin
  case (c) of
       'S':begin
         frmMain.btnGo.Click;
         frmMain.serial.WriteData('G');
         frmMain.serial.WriteData('0');
         frmMain.serial.WriteData(inttostr(player));
       end;
       'P':begin
         frmMain.btnPause.Click;
         frmMain.serial.WriteData('S');
       end;
       'G':begin
         mytime := 0;
         frmMain.lblTime.Caption:='0:00';
         //timer reset
       end;
       'R':frmMain.btnRoll.Click;

       '1':begin
         if player = 1 then begin
           if frmMain.tmrStopWatch.Enabled then begin
             player := 2;
             frmMain.serial.WriteData('02');
             frmMain.btnRoll.Click;
             mytime := 0;
             frmMain.lblTime.Caption:='0:00';
           end;
         end;
       end;
       '2':begin
         if player = 2 then begin
           if frmMain.tmrStopWatch.Enabled then begin
             player := 3;
             frmMain.serial.WriteData('03');
             frmMain.btnRoll.Click;
             mytime := 0;
             frmMain.lblTime.Caption:='0:00';
           end;
         end;
       end;
       '3':begin
         if player = 3 then begin
           if frmMain.tmrStopWatch.Enabled then begin
             player := 1;
             frmMain.serial.WriteData('01');
             frmMain.btnRoll.Click;
             mytime := 0;
             frmMain.lblTime.Caption:='0:00';
           end;
         end;
       end;
  end;
end;

procedure TfrmMain.serialRxData(Sender: TObject);
var s: string;
  i: integer;
begin
  s := serial.ReadData;
  for i:= 1 to length(s) do begin
    doCommand(s[i]);
  end;
end;

procedure TfrmMain.tmrStopWatchTimer(Sender: TObject);
var m, s: integer;
begin
  mytime := mytime + 1;
  m := myTime div 60;
  s := myTime mod 60;
  if (s<10) then
    lblTime.Caption:=inttostr(m) + ':0' + inttostr(s);
  if (s>=10) then
    lblTime.Caption:=inttostr(m) + ':' + inttostr(s);
  if (Dtot = 7) then
  begin
    if myTime >=150 then begin
       lblTime.Font.Color:=clRed;
    end else
    begin
      lblTime.Font.Color:=clBlack;
    end;
  end else
  begin
    if myTime >=120 then begin
      lblTime.Font.Color:=clRed;
    end else
    begin
      lblTime.Font.Color:=clBlack;
    end;
  end;
end;

end.

