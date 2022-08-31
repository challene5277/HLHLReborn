unit UnitGlobal;

interface

uses
  Windows, Messages, SysUtils, Classes,
  UnitConsts, IniFiles,
  UnitTypesAndVars, Math, UnitClasses, ClsMaps;

function GetHLHLVer: WideString;	// ���� HLHL �汾
function HexToInt(HexStr: String): Int64;
procedure WindowSetText(myhwnd: HWND; text: String);
function WindowGetText(myhwnd: HWND): WideString; // �õ��������ݵ�����
function GetItemXY(ItemPos:integer):TPoint;
procedure MoveToHL_Pos(X:DWORD; Y:DWORD; SendServer: bool);
function ReadFromHLMEM(addr:Pointer; lpBuffer: Pointer; numofbytes: integer):DWORD;
function ReadCurrMapID: DWORD;
function ReadCurrMap: TMapInfo;
function GetUserEnvState:WORD;
procedure LeftCtrlClickPlayWindow(X, Y: Integer);
procedure GetCurrPosXY(var X, Y:DWORD);
procedure RightClickOnSomeWindow_Send(myhwnd: HWND; X, Y: Integer);
procedure RightClickOnSomeWindow_Post(myhwnd: HWND; X, Y: Integer);
procedure LeftClickOnSomeWindow_Post(myhwnd: HWND; X, Y: Integer);
procedure LeftClickOnSomeWindow_Send(myhwnd: HWND; X, Y: Integer);
procedure LeftDblClickOnSomeWindow_Post(myhwnd: HWND; X, Y: Integer);
function IsNeiyao(Name: WideString): Boolean;  // �ж��Ƿ�����ҩ
//function ReadFate(Attr: integer; Rank: integer; Level: integer): Boolean;
function GetNPCDialog: WideString;
procedure InitNPCs;
procedure BeginCallNPC(Which: TNPCID);
procedure EndCallNPC;
procedure CancelNPCDialog;
function GetHLMemListNumberByNo(No, AddrBase, KeyAddr: DWORD):DWORD;
procedure UnPatchAll;
function CanCreateWG:String; // ����ֵΪ�մ���ʱ��˵��OK
procedure PatchSpeed;

implementation
uses
  ClsGames;
function GetHLHLVer: WideString;
// HLHLReborn Global Version
begin
	Result := '1.2.07';
end;

procedure UnPatchAll;
// �ָ�����
var
  tmpWin: TWindowInfo;
  HLHLini: TIniFile;
  tmpDWORD: DWORD;
//  iPlayWindowID: Integer;
begin
  HLHLini := TIniFile.Create('.\Info\HLHL.ini');
  tmpDWORD := HLHLini.ReadInteger('Main', 'UserCurrMapID'
    + IntToStr(HLInfoList.GlobalHL.ProcessId), 0);
  HLHLini.Free;

  if tmpDWORD <> 0 then
  begin
    CallNPCState.UserCurrMapID := ReadCurrMapID;
    EndCallNPC;
  end;

  if ThisBuyStuff <> Nil then ThisBuyStuff.UnpatchShop;
  if ThisCreateWG <> Nil then ThisCreateWG.UnPatchCreateWG;
  if ThisForge <> Nil then ThisForge.UnpatchUniverseStove;

  ThisUser.UnPatchItemWindow;


  tmpWin := HLInfoList.GlobalHL.ItemOfWindowTitle('��ϸ����');
  if tmpWin <> Nil
  then
  begin
    if IsWindow(tmpWin.Window) and (not IsWindowVisible(tmpWin.Window))
    then
    begin
      ShowWindow(tmpWin.Window, SW_SHOW);
      EnableWindow(tmpWin.Window, True);
    end;
  end;

  HLInfoList.GlobalHL.LocateToPlayWindow(tmpWin);
  if tmpWin = nil then Exit;
  EnableWindow(tmpWin.Window, True);
end;

function HexToInt(HexStr: String): Int64;
var RetVar: Int64;
  i: byte;
begin
  HexStr := UpperCase(HexStr);
  if HexStr[length(HexStr)] = 'H' then
    Delete(HexStr, length(HexStr), 1);
  RetVar := 0;
  for i := 1 to length(HexStr) do begin
    RetVar := RetVar shl 4;
    if HexStr[i] in ['0'..'9'] then
      RetVar := RetVar + (byte(HexStr[i]) - 48)
    else
      if HexStr[i] in ['A'..'F'] then
        RetVar := RetVar + (byte(HexStr[i]) - 55)
      else begin
        Retvar := 0;
        break;
      end;
  end;

  Result := RetVar;
end;

function WindowGetText(myhwnd: HWND): WideString;
// ���ش����ı�
var
  tmp: array[0..254] of Char;
begin
  SendMessage(myhwnd, WM_GETTEXT, 255, LPARAM(@tmp));
  Result := tmp;
end;

procedure WindowSetText(myhwnd: HWND; text: String);
// ���ô����ı�
var
  i:integer;
  Ch: Char;
begin
  EnableWindow(myhwnd, False);
  PostMessage(myhwnd, EM_SETSEL, 0, -1);
  PostMessage(myhwnd, WM_CLEAR, 0, 0);
  for i := 1 to Length(text) do
  begin
    Ch := text[i];
    PostMessage(myhwnd, WM_CHAR, Ord(Ch), 1);
  end;
  EnableWindow(myhwnd, True);
end;

function GetItemXY(ItemPos: Integer): TPoint;
var
  myX, myY: Integer;
begin
  case ItemPos of
    1: begin
         myX := Item1X;
         myY := Item1Y;
       end;
    2: begin
         myX := Item2X;
         myY := Item2Y;
       end;
    3: begin
         myX := Item3X;
         myY := Item3Y;
       end;
    4: begin
         myX := Item4X;
         myY := Item4Y;
       end;
    5: begin
         myX := Item5X;
         myY := Item5Y;
       end;
    6: begin
         myX := Item6X;
         myY := Item6Y;
       end;
    7: begin
         myX := Item7X;
         myY := Item7Y;
       end;
    8: begin
         myX := Item8X;
         myY := Item8Y;
       end;
    9: begin
         myX := Item9X;
         myY := Item9Y;
       end;
    10: begin
         myX := Item10X;
         myY := Item10Y;
       end;
    11: begin
         myX := Item11X;
         myY := Item11Y;
       end;
    12: begin
         myX := Item12X;
         myY := Item12Y;
       end;
    13: begin
         myX := Item13X;
         myY := Item13Y;
       end;
    14: begin
         myX := Item14X;
         myY := Item14Y;
       end;
    15: begin
         myX := Item15X;
         myY := Item15Y;
       end;
    else begin
         myX := Item15X;
         myY := Item15Y;
    end;
  end;

  Result.X := myX;
  Result.Y := myY;
end;

procedure MoveToHL_Pos(X:DWORD; Y:DWORD; SendServer: bool);
// �ƶ���ָ�������
var
  ProcessHandle: THandle;
  lpBuffer: DWORD;
  lpNumberOfBytes: SIZE_T;

  tmpWin: TWindowInfo;
  clickX, clickY: DWORD;
  tmpX, tmpY: DWORD;
begin
  lpBuffer := GetUserEnvState;	// ����û���ǰ״̬

  if lpBuffer <> UserEnvBattle then	// ����ս��״̬�������ƶ�
  begin
    CancelNPCDialog;	// ȡ���Ի�
    // �ƶ�
    ProcessHandle := OpenProcess(PROCESS_ALL_ACCESS, false,
      HLInfoList.GlobalHL.ProcessId);
    if ProcessHandle <> 0 then
    begin
      if SendServer then
      begin
        tmpX := x - 1;
        tmpY := y - 1;
        WriteProcessMemory(ProcessHandle, Pointer(UserPosXAdress), @tmpX, 4, lpNumberOfBytes);
        WriteProcessMemory(ProcessHandle, Pointer(UserPosYAdress), @tmpY, 4, lpNumberOfBytes);

        Sleep(100);
        ReadFromHLMEM(Pointer(UserRealXAddress), @clickX, 4);
        ReadFromHLMEM(Pointer(UserRealYAddress), @clickY, 4);
        HLInfoList.GlobalHL.LocateToPlayWindow(tmpWin);
        if tmpWin <> nil then
        begin
          LeftClickOnSomeWindow_Send(tmpWin.Window, PlayLeftJust + clickX, PlayTopJust + clickY + 32);
        end;

        //WriteProcessMemory(ProcessHandle, Pointer(UserPosXAdress), @X, 4, lpNumberOfBytes);
        //WriteProcessMemory(ProcessHandle, Pointer(UserPosYAdress), @Y, 4, lpNumberOfBytes);
      end
      else
      begin
        WriteProcessMemory(ProcessHandle, Pointer(UserPosXAdress), @X, 4, lpNumberOfBytes);
        WriteProcessMemory(ProcessHandle, Pointer(UserPosYAdress), @Y, 4, lpNumberOfBytes);
      end;
    end;
    CloseHandle(ProcessHandle);
  end;

  Sleep(200);	// ʱ���ӳ�
end;

function ReadFromHLMEM(addr: Pointer; lpBuffer: Pointer; numofbytes: integer): DWORD;
// ������Ϸ��ָ��λ�á�ָ�����ȵ��ڴ�����
var
  ProcessHandle: THandle;
  lpNumberOfBytes: SIZE_T;
begin
  ProcessHandle := OpenProcess(PROCESS_ALL_ACCESS, false, HLInfoList.GlobalHL.ProcessId);
  if ProcessHandle <> 0 then
    ReadProcessMemory(ProcessHandle, addr, lpBuffer, numofbytes, lpNumberOfBytes);
  CloseHandle(ProcessHandle);
  Result := lpNumberOfBytes;
end;

function ReadCurrMapID: DWORD;
// ��õ�ǰ��ͼ��ʶ
begin
  ReadFromHLMEM(Pointer(UserCurMapAddress), @result, 4);
end;

function ReadCurrMap: TMapInfo;
// ��ȡ��ǰ��ͼ��Ϣ
begin
  Result := GameMaps.ItemOfMapID(ReadCurrMapID);	// ��ȡָ����ʶ�ĵ�ͼ��Ϣ
end;

function GetUserEnvState:WORD;
var
  Buffer: WORD;
begin
  ReadFromHLMEM(Pointer(UserEnvironmentAdress), @Buffer, 2);
  Result := Buffer;
end;

procedure LeftCtrlClickPlayWindow(X, Y:integer);
// ��ס CTRL �������������Ϸ����
var
  tmpWin: TWindowInfo;
begin
  if HLInfoList.GlobalHL.LocateToPlayWindow(tmpWin) = -1 then Exit; // û�ҵ�
  PostMessage(tmpWin.Window, WM_KEYDOWN, VK_CONTROL, 1);
  PostMessage(tmpWin.Window, WM_LBUTTONDOWN, VK_CONTROL, X + Y * 65536);
  PostMessage(tmpWin.Window, WM_LBUTTONUP, VK_CONTROL, X + Y * 65536);
  PostMessage(tmpWin.Window, WM_KEYUP, VK_CONTROL, 1);
end;

procedure GetCurrPosXY(var X, Y:DWORD);
begin
  ReadFromHLMEM(Pointer(UserPosXAdress), @X, 4);
  ReadFromHLMEM(Pointer(UserPosYAdress), @Y, 4);
end;
 
procedure RightClickOnSomeWindow_Send(myhwnd:HWND; X, Y: Integer);
var
  tmpWin: TWindowInfo;
begin
  SendMessage(myhwnd, WM_RBUTTONDOWN, MK_RBUTTON, X + Y * 65536);
  SendMessage(myhwnd, WM_RBUTTONUP, 0, X + Y * 65536);
end;

procedure RightClickOnSomeWindow_Post(myhwnd:HWND; X, Y: Integer);
begin
  PostMessage(myhwnd, WM_RBUTTONDOWN, MK_RBUTTON, X + Y * 65536);
  PostMessage(myhwnd, WM_RBUTTONUP, 0, X + Y * 65536);
end;

procedure LeftClickOnSomeWindow_Post(myhwnd: HWND; X, Y: Integer);
begin
  PostMessage(myhwnd, WM_LBUTTONDOWN, MK_LBUTTON, X + Y * 65536);
  PostMessage(myhwnd, WM_LBUTTONUP, 0, X + Y * 65536);
end;

procedure LeftDblClickOnSomeWindow_Post(myhwnd:HWND; X, Y: Integer);
begin
  LeftClickOnSomeWindow_Post(myhwnd, X, Y);
  PostMessage(myhwnd, WM_LBUTTONDBLCLK, MK_LBUTTON, X + Y * 65536);
end;

function IsNeiyao(Name: WideString): Boolean;  // �ж��Ƿ�����ҩ
begin
  Result := False;
  if (name = '�����') or (name = '���鵤') or (name = '����') or (name = '��¶��') then
    Result := True;
end;

procedure DoRealMoveToHL_Pos(X: integer; Y:integer);
begin

end;

(*
function ReadFate(Attr: integer; Rank: integer; Level: integer): Boolean;
var
  i: integer;
  fateini: TINIFile;
  tmpStep: TStep;
  tmpstr: String;
begin
  result:=False;

  if (Attr<>ThisFate.Attr) or (Rank<>ThisFate.Rank) or (Level<>ThisFate.Level) then
  begin
    ThisFate.Attr:=Attr;
    ThisFate.Rank:=Rank;
    ThisFate.Level:=Level;
    if ThisFate.StepList.Count>0 then
    begin
      for i:=0 to ThisFate.StepList.Count-1 do
      begin
        tmpStep:=ThisFate.StepList.Items[i];
        tmpStep.Free;
      end;
    end;
    ThisFate.StepList.Clear;

    fateini:=TIniFile.Create('.\Info\fate.ini');
    ThisFate.MapID:=fateini.ReadInteger(format('Attr%dRank%dLevel%d', [Attr, Rank, Level]), 'mapid', 0);
    ThisFate.StepNum:=fateini.ReadInteger(format('Attr%dRank%dLevel%d', [Attr, Rank, Level]), 'StepNum', 0);
    ThisFate.PosX:=fateini.ReadInteger(format('Attr%dRank%dLevel%d', [Attr, Rank, Level]), 'PosX', 0);
    ThisFate.PosY:=fateini.ReadInteger(format('Attr%dRank%dLevel%d', [Attr, Rank, Level]), 'PosY', 0);
    if (ThisFate.StepNum<1) or (ThisFate.MapID<1) or (ThisFate.PosX<1) or (ThisFate.PosY<1) then Exit;

    for i:=0 to ThisFate.StepNum-1 do
    begin
      tmpStep:=TStep.Create;
      tmpstr:=fateini.ReadString(format('Attr%dRank%dLevel%d', [Attr, Rank, Level]), format('Step%d', [i]), '');
      extractstepinfo(tmpstr, tmpStep.Action, tmpStep.X, tmpStep.Y);
      ThisFate.StepList.Add(tmpStep);
    end;
    fateini.Free;
  end;
  result:=True;
end;
*)
function GetNPCDialog: WideString;
// ����NPC�Ի���Ϣ
var
  tmpaddr: DWORD;
  DialogBuffer: PAnsiChar;
begin
  DialogBuffer := AllocMEM(NPCDialogLength);
  ReadFromHLMEM(Pointer(NPCDialogAddressAddress), @tmpaddr, 4);
  ReadFromHLMEM(Pointer(tmpaddr), @tmpaddr, 4);
  ReadFromHLMEM(Pointer(tmpaddr + 4), DialogBuffer, NPCDialogLength);
  Result := DialogBuffer;
  FreeMEM(DialogBuffer, NPCDialogLength);
end;

procedure InitNPCs;
// ��ʼ�� NPC ��Ϣ��������ͼ��š�NPC���͡����ơ���������
begin
  CallNPCState.UserCurrMapID := 0;
  CallNPCState.IsWorking := False;

	// ----------- Blacksmith -----------------------------
  NPCs[Ord(ShuiCheng_Forge)].ShopMapID := 100001;
  NPCs[Ord(ShuiCheng_Forge)].ShopType := $64;
  NPCs[Ord(ShuiCheng_Forge)].Name := 'WaterCity Blacksmith';
  //NPCs[Ord(ShuiCheng_Forge)].SatisfiedCond := '����� - ��Ʒ����';
  NPCs[Ord(ShuiCheng_Forge)].SatisfiedCond := 'The Blacksmith - Item Sortation';
//  NPCIDsArray[Ord(ShuiCheng_Forge)] := ShuiCheng_Forge;

  NPCs[Ord(ShuCheng_Forge)] := NPCs[Ord(ShuiCheng_Forge)];
  NPCs[Ord(ShuCheng_Forge)].ShopMapID := 100003;
  NPCs[Ord(ShuCheng_Forge)].Name := 'TreeCity Blacksmith';

  NPCs[Ord(ShanCheng_Forge)] := NPCs[Ord(ShuiCheng_Forge)];
  NPCs[Ord(ShanCheng_Forge)].ShopMapID := 100002;
  NPCs[Ord(ShanCheng_Forge)].Name := 'HillCity Blacksmith';

  NPCs[Ord(ShaCheng_Forge)] := NPCs[Ord(ShuiCheng_Forge)];
  NPCs[Ord(ShaCheng_Forge)].ShopMapID := 200001;
  NPCs[Ord(ShaCheng_Forge)].Name := 'SandCity Blacksmith';

	// ----------- ��� -----------------------------
  NPCs[Ord(ShuiCheng_Med)].ShopMapID := 100000;
  NPCs[Ord(ShuiCheng_Med)].ShopType := $65;
  NPCs[Ord(ShuiCheng_Med)].Name := 'WaterCity Pharmacy';
  NPCs[Ord(ShuiCheng_Med)].SatisfiedCond := 'Monster&Me - Store';
//  NPCIDsArray[Ord(ShuiCheng_Med)] := ShuiCheng_Med;

  NPCs[Ord(ShuCheng_Med)] := NPCs[Ord(ShuiCheng_Med)];
  NPCs[Ord(ShuCheng_Med)].ShopMapID := 100006;
  NPCs[Ord(ShuCheng_Med)].Name := 'TreeCity Pharmacy';

  NPCs[Ord(ShanCheng_Med)] := NPCs[Ord(ShuiCheng_Med)];
  NPCs[Ord(ShanCheng_Med)].ShopMapID := 100059;
  NPCs[Ord(ShanCheng_Med)].Name := 'HillCity Pharmacy';

  NPCs[Ord(ShaCheng_Med)] := NPCs[Ord(ShuiCheng_Med)];
  NPCs[Ord(ShaCheng_Med)].ShopMapID := 200000;
  NPCs[Ord(ShaCheng_Med)].Name := 'SandCity Pharmacy';

  NPCs[Ord(XueCheng_Med)] := NPCs[Ord(ShuiCheng_Med)];
  NPCs[Ord(XueCheng_Med)].ShopMapID := 300000;
  NPCs[Ord(XueCheng_Med)].Name := 'SnowCity Pharmacy';

  NPCs[Ord(HaiCheng_Med)] := NPCs[Ord(ShuiCheng_Med)];
  NPCs[Ord(HaiCheng_Med)].ShopMapID := 400000;
  NPCs[Ord(HaiCheng_Med)].Name := 'OceanCity Pharmacy';

  NPCs[Ord(XinShanCheng_Med)] := NPCs[Ord(ShuiCheng_Med)];
  NPCs[Ord(XinShanCheng_Med)].ShopMapID := 100099;
  NPCs[Ord(XinShanCheng_Med)].Name := 'NewHillCity Pharmacy';

	// ----------- �鱦 -----------------------------
  NPCs[Ord(Shuicheng_Jewelry)].ShopMapID := 100034;
  NPCs[Ord(Shuicheng_Jewelry)].ShopType := $66;
  NPCs[Ord(Shuicheng_Jewelry)].Name := 'WaterCity Jeweler';
  NPCs[Ord(Shuicheng_Jewelry)].SatisfiedCond := 'Monster&Me - Store';
//  NPCIDsArray[Ord(Shuicheng_Jewelry)] := Shuicheng_Jewelry;

  NPCs[Ord(ShuCheng_Jewelry)] := NPCs[Ord(Shuicheng_Jewelry)];
  NPCs[Ord(ShuCheng_Jewelry)].ShopMapID := 100007;
  NPCs[Ord(ShuCheng_Jewelry)].Name := 'TreeCity Jeweler';

  NPCs[Ord(ShanCheng_Jewelry)] := NPCs[Ord(Shuicheng_Jewelry)];
  NPCs[Ord(ShanCheng_Jewelry)].ShopMapID := 100060;
  NPCs[Ord(ShanCheng_Jewelry)].Name := 'HillCity Jeweler';

  NPCs[Ord(ShaCheng_Jewelry)] := NPCs[Ord(Shuicheng_Jewelry)];
  NPCs[Ord(ShaCheng_Jewelry)].ShopMapID := 200030;
  NPCs[Ord(ShaCheng_Jewelry)].Name := 'SandCity Jeweler';

	// ----------- ��� -----------------------------
  // ����겻���ڱ�ĵط����У�����һ��������
  NPCs[Ord(Shuicheng_Pet)].ShopMapID := 100030;
  NPCs[Ord(Shuicheng_Pet)].ShopType := $67;
  NPCs[Ord(Shuicheng_Pet)].Name := 'WaterCity PetStore';
  NPCs[Ord(Shuicheng_Pet)].SatisfiedCond := 'Pet Store';
//  NPCIDsArray[Ord(Shuicheng_Pet)] := Shuicheng_Pet;
end;

procedure BeginCallNPC(Which: TNPCID);
// ��ʼ���� NPC
var
  ProcessHandle: THandle;
  lpNumberOfBytes: SIZE_T;
  BufferDWord: DWORD;
  BufferWord: WORD;
  BufferByte: Byte;
  HLHLini: TIniFile;
begin
  CallNPCState.IsWorking:=True;

  ProcessHandle := OpenProcess(PROCESS_ALL_ACCESS, false, HLInfoList.GlobalHL.ProcessId);

  if ProcessHandle<>0 then
  begin
  	// �����ֳ�
    ReadFromHLMEM(Pointer(UserCurMapAddress), @CallNPCState.UserCurrMapID, 4);
    HLHLini:=TIniFile.Create('.\Info\HLHL.ini');
    HLHLini.WriteInteger('Main', 'UserCurrMapID' + IntToStr(HLInfoList.GlobalHL.ProcessId),
    	CallNPCState.UserCurrMapID);
    HLHLini.Free;
    // Set the current map as the NPC location map (spoofing system)
    WriteProcessMemory(ProcessHandle, Pointer(UserCurMapAddress), @NPCs[Ord(Which)].ShopMapID, 4, lpNumberOfBytes);

    //change conditional jz to jmp
    BufferByte := $EB;
    //WriteProcessMemory(ProcessHandle, Pointer($53CF3F), @BufferByte, 1, lpNumberOfBytes);
    WriteProcessMemory(ProcessHandle, Pointer($53D899), @BufferByte, 1, lpNumberOfBytes);

    // Skip this section of code
    BufferDWord := $90909090;
    BufferByte := $90;
    //WriteProcessMemory(ProcessHandle, Pointer($53CF49), @BufferDWord, 4, lpNumberOfBytes);
    //WriteProcessMemory(ProcessHandle, Pointer($53CF4d), @BufferByte, 1, lpNumberOfBytes);
    WriteProcessMemory(ProcessHandle, Pointer($53D8AA), @BufferDWord, 4, lpNumberOfBytes);
    WriteProcessMemory(ProcessHandle, Pointer($53D8AE), @BufferByte, 1, lpNumberOfBytes);

    // Set the NPC type
    //$64: BufferDWord := $000152e9;
    //$65: BufferDWord := $000175e9;
    //$66: BufferDWord := $000198e9;
    //$67: BufferDWord := $0001bbe9;
    case NPCs[Ord(Which)].ShopType of
      //$64: BufferDWord := $00015fe9;
      //$65: BufferDWord := $000182e9;
      //$66: BufferDWord := $0001a5e9;
      //$67: BufferDWord := $0001c8e9;   why is the actual address -5 offset for the jump?
      $64: BufferDWord := $00015ae9;
      $65: BufferDWord := $00017de9;
      $66: BufferDWord := $0001a0e9;
      $67: BufferDWord := $0001c3e9;
    end;
    BufferByte := $00;
    //WriteProcessMemory(ProcessHandle, Pointer($53CF56), @BufferDWord, 4, lpNumberOfBytes);
    //WriteProcessMemory(ProcessHandle, Pointer($53CF5A), @BufferByte, 1, lpNumberOfBytes);
    WriteProcessMemory(ProcessHandle, Pointer($0053D8BA), @BufferDWord, 4, lpNumberOfBytes);
    WriteProcessMemory(ProcessHandle, Pointer($0053D8BE), @BufferByte, 1, lpNumberOfBytes);

    sleep(200);
    // ���Բ��ִ���
    BufferWord := $9090;
    //WriteProcessMemory(ProcessHandle, Pointer($53ceb2), @BufferWord, 2, lpNumberOfBytes);
    WriteProcessMemory(ProcessHandle, Pointer($0053D7E8), @BufferWord, 2, lpNumberOfBytes);
  end;
  CloseHandle(ProcessHandle);
end;

procedure EndCallNPC;
// ֹͣ���� NPC
var
  ProcessHandle: THandle;
  lpNumberOfBytes: SIZE_T;
  BufferDWord: DWORD;
  BufferWord: WORD;
  BufferByte: Byte;
  HLHLini: TIniFile;
begin
  ProcessHandle := OpenProcess(PROCESS_ALL_ACCESS, false, HLInfoList.GlobalHL.ProcessId);

  if ProcessHandle  <>0 then
  begin
    //BufferWORD := $0974;
    BufferWORD := $0F74;
    //WriteProcessMemory(ProcessHandle, Pointer($53ceb2), @BufferWORD, 2, lpNumberOfBytes);
    WriteProcessMemory(ProcessHandle, Pointer($0053D7E8), @BufferWORD, 2, lpNumberOfBytes);
    sleep(200);

    BufferDWord := $7f66f883;
    BufferByte := $3a;
    //WriteProcessMemory(ProcessHandle, Pointer($53CF56), @BufferDWord, 4, lpNumberOfBytes);
    //WriteProcessMemory(ProcessHandle, Pointer($53CF5A), @BufferByte, 1, lpNumberOfBytes);
    WriteProcessMemory(ProcessHandle, Pointer($0053D8BA), @BufferDWord, 4, lpNumberOfBytes);
    WriteProcessMemory(ProcessHandle, Pointer($0053D8BE), @BufferByte, 1, lpNumberOfBytes);

    BufferByte := $74;
    //WriteProcessMemory(ProcessHandle, Pointer($53CF3F), @BufferByte, 1, lpNumberOfBytes);
    WriteProcessMemory(ProcessHandle, Pointer($0053D899), @BufferByte, 1, lpNumberOfBytes);

    //BufferDWord := $0003b6e8;
    BufferDWord := $000415e8;
    BufferByte := $00;
    //WriteProcessMemory(ProcessHandle, Pointer($53CF49), @BufferDWord, 4, lpNumberOfBytes);
    //WriteProcessMemory(ProcessHandle, Pointer($53CF4d), @BufferByte, 1, lpNumberOfBytes);
    WriteProcessMemory(ProcessHandle, Pointer($53D8AA), @BufferDWord, 4, lpNumberOfBytes);
    WriteProcessMemory(ProcessHandle, Pointer($53D8AE), @BufferByte, 1, lpNumberOfBytes);

		// �ָ��ֳ����ָ���ǰ��ͼ
    WriteProcessMemory(ProcessHandle, Pointer(UserCurMapAddress),
    	@CallNPCState.UserCurrMapID, 4, lpNumberOfBytes);
    HLHLini := TIniFile.Create('.\Info\HLHL.ini');
    HLHLini.WriteInteger('Main', 'UserCurrMapID' + IntToStr(HLInfoList.GlobalHL.ProcessId), 0);
    HLHLini.Free;
  end;
  CloseHandle(ProcessHandle);

  CallNPCState.IsWorking := False;
end;

procedure CancelNPCDialog;
// ȡ�� NPC �Ի���
var
  ProcessHandle: THandle;
  lpBuffer, tmpaddr: DWORD;
  lpNumberOfBytes: SIZE_T;
begin
  if GetUserEnvState <> UserEnvDialog then Exit;
  
  lpBuffer := 0;
  ProcessHandle := OpenProcess(PROCESS_ALL_ACCESS, false, HLInfoList.GlobalHL.ProcessId);
  WriteProcessMemory(ProcessHandle, Pointer(DialogControlAddr), @lpBuffer, 4, lpNumberOfBytes);

  ReadFromHLMEM(Pointer(NPCDialogAddressAddress), @tmpaddr, 4);
  ReadFromHLMEM(Pointer(tmpaddr), @tmpaddr, 4);
  WriteProcessMemory(ProcessHandle, Pointer(tmpaddr+4), @lpBuffer, 4, lpNumberOfBytes);
  CloseHandle(ProcessHandle);

  repeat
    Sleep(100);
  until GetUserEnvState<>UserEnvDialog;
end;

procedure LeftClickOnSomeWindow_Send(myhwnd: HWND; X, Y:integer);
begin
  SendMessage(myhwnd, WM_LBUTTONDOWN, MK_LBUTTON, X + Y * 65536);
  SendMessage(myhwnd, WM_LBUTTONUP, 0, X + Y * 65536);
end;

function GetHLMemListNumberByNo(No, AddrBase, KeyAddr: DWORD):DWORD;
var
  KeyContent, ESI, EDI, CurrAddrAddr, CurrAddrAddr_4, CurrAddrAddr_C: DWORD;
begin
  ReadFromHLMEM(Pointer(KeyAddr), @KeyContent, 4);

  ReadFromHLMEM(Pointer(AddrBase), @CurrAddrAddr, 4);
  ReadFromHLMEM(Pointer(AddrBase + $4), @CurrAddrAddr_4, 4);
  ReadFromHLMEM(Pointer(AddrBase + $C), @CurrAddrAddr_C, 4);

  ESI:=CurrAddrAddr-CurrAddrAddr_4;
  if ESI < 0 then ESI := ESI + 3;

  ESI := ESI div 4;
  ESI := ESI + No;

  if ESI >= 0 then
  begin
    EDI:=ESI div KeyContent;
  end
  else
  begin
    EDI:=(ESI + 1) div KeyContent - 1;
  end;

  if EDI = 0 then
  begin
    CurrAddrAddr := CurrAddrAddr + No * 4;
  end
  else
  begin
    ReadFromHLMEM(Pointer(CurrAddrAddr_C + EDI * 4), @CurrAddrAddr_4, 4);
    CurrAddrAddr := (ESI - KeyContent*EDI) * 4 + CurrAddrAddr_4;
  end;
  
  ReadFromHLMEM(Pointer(CurrAddrAddr), @Result, 4);
end;

function CanCreateWG:String; // ����ֵΪ�մ���ʱ��˵��OK
var
  tmpMaxXishu: Real;
begin
  Result := '';

  if ThisWGAttrs.MC = '' then
  begin
    Result := 'You must enter a Kungfu Name';
    Exit;
  end;
  
  if StrToFloatDef(ThisWGAttrs.XS, -1) < 0 then
  begin
    Result := 'The Destructive Index cannot be ' + ThisWGAttrs.XS;
    Exit;
  end;

  if StrToIntDef(ThisWGAttrs.NL, -1) < 0 then
  begin
    Result := 'The Mana cannot be ' + ThisWGAttrs.NL;
    Exit;
  end;

  ThisUser.GetAttr;
  ThisUser.GetWGs;

  if (ThisUser.WGCount >= ThisUser.WGCountLimit) then
  begin
    Result := 'Full';
    Exit;
  end;

  if ThisUser.Level < 100 then
  begin  // ��Ҫ���ڵ���100��
    Result := 'You must be above level 100 to create Kungfu';
    Exit;
  end;
  if (ThisUser.Level < 300) and (ThisUser.Rank < 1) then
  begin // ������Ҫ���ڵ���300��
    Result := 'Mortals must be above level 300 to create Kungfu';
    Exit;
  end;

  // �����������100
  if ThisUser.Neigong < 100 then
  begin
    Result := 'You must have at least 100 Mana';
    Exit;
  end;

  // �Լ��Ĵ���Ҫ�����봴���е��ڵ�ֵ
  if ThisUser.Neigong<StrToInt(ThisWGAttrs.NL) then
  begin
    Result := 'You must have more Mana than the Kungfu you are trying to create.';
    Exit;
  end;

  // ������ϵ����˲��ܴ���2000
  if StrToInt(ThisWGAttrs.NL) * StrToFloat(ThisWGAttrs.XS) > 2000 then
  begin
    Result := 'Damage cannot exceed 2000';
    Exit;
  end;

  // ϵ�����ܳ������ֵ
  tmpMaxXishu:=(150 + (ThisUser.Gongji - 600) * 5 / 140 ) /100;
  if tmpMaxXishu > 2 then tmpMaxXishu:=2;
  if StrToFloat(ThisWGAttrs.XS) > tmpMaxXishu then
  begin
    Result := 'Destructive Index cannot exceed attack value '
        + FloatToStr(tmpMaxXishu)
        + '��You selected '
        + ThisWGAttrs.XS
        + '! Please re-enter the Destructive Index';
    Exit;
  end;
end;

procedure PatchSpeed;
var
  ProcessHandle: THandle;
  BufferByte: BYTE;
  BufferWord: WORD;
  BufferDWord: DWORD;
  lpNumberOfBytes: SIZE_T;
begin
  ProcessHandle := OpenProcess(PROCESS_ALL_ACCESS, false, HLInfoList.GlobalHL.ProcessId);

  if ProcessHandle <> 0 then
  begin
    //Attack Animation
    BufferDWord := $90909090;
    BufferWord := $9090;
    WriteProcessMemory(ProcessHandle, Pointer($5A6770), @BufferDWord, 4, lpNumberOfBytes);
    WriteProcessMemory(ProcessHandle, Pointer($5A6774), @BufferWord, 2, lpNumberOfBytes);
    WriteProcessMemory(ProcessHandle, Pointer($5A6C03), @BufferDWord, 4, lpNumberOfBytes);
    WriteProcessMemory(ProcessHandle, Pointer($5A6C07), @BufferWord, 2, lpNumberOfBytes);
    WriteProcessMemory(ProcessHandle, Pointer($5A62F6), @BufferDWord, 4, lpNumberOfBytes);
    WriteProcessMemory(ProcessHandle, Pointer($5A62FA), @BufferWord, 2, lpNumberOfBytes);

    //Battle Movement
    BufferDWord := $8910558B;
    WriteProcessMemory(ProcessHandle, Pointer($5A68F0), @BufferDWord, 4, lpNumberOfBytes);
    BufferDWord := $90902C50;
    WriteProcessMemory(ProcessHandle, Pointer($5A68F4), @BufferDWord, 4, lpNumberOfBytes);
    BufferDWord := $90909090;
    WriteProcessMemory(ProcessHandle, Pointer($5A68F8), @BufferDWord, 4, lpNumberOfBytes);
    WriteProcessMemory(ProcessHandle, Pointer($5A68FC), @BufferDWord, 4, lpNumberOfBytes);
    WriteProcessMemory(ProcessHandle, Pointer($5A6900), @BufferDWord, 4, lpNumberOfBytes);
    BufferWord := $9090;
    WriteProcessMemory(ProcessHandle, Pointer($5A6904), @BufferWord, 2, lpNumberOfBytes);

    //Catch Sequence
    BufferDWord := $00C082C7;
    WriteProcessMemory(ProcessHandle, Pointer($5A7AED), @BufferDWord, 4, lpNumberOfBytes);
    BufferDWord := $008C0000;
    WriteProcessMemory(ProcessHandle, Pointer($5A7AF1), @BufferDWord, 4, lpNumberOfBytes);
    BufferDWord := $90900000;
    WriteProcessMemory(ProcessHandle, Pointer($5A7AF5), @BufferDWord, 4, lpNumberOfBytes);
    BufferByte := $90;
    WriteProcessMemory(ProcessHandle, Pointer($5A7AF9), @BufferByte, 1, lpNumberOfBytes);

    //Lag and Bird Counter
    BufferDWord := $0000003D;
    BufferByte := $00;
    WriteProcessMemory(ProcessHandle, Pointer($58C7DA), @BufferDWord, 4, lpNumberOfBytes);
    WriteProcessMemory(ProcessHandle, Pointer($58C7DE), @BufferByte, 1, lpNumberOfBytes);
    WriteProcessMemory(ProcessHandle, Pointer($58C4A9), @BufferDWord, 4, lpNumberOfBytes);
    WriteProcessMemory(ProcessHandle, Pointer($58C4AD), @BufferByte, 1, lpNumberOfBytes);
  end;

  CloseHandle(ProcessHandle);
end;

end.
