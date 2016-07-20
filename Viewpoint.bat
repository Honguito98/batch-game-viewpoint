:    Viewpoint Batch: The old video game from original 'Viewpoint' ported to Batch File
:    Copyright (C) 2012,2013  Honguito98
:
:    This program is free software: you can redistribute it and/or modify
:    it under the terms of the GNU General Public License as published by
:    the Free Software Foundation, either version 3 of the License, or
:    (at your option) any later version.
:
:    This program is distributed in the hope that it will be useful,
:    but WITHOUT ANY WARRANTY; without even the implied warranty of
:    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
:    GNU General Public License for more details.
:
:    You should have received a copy of the GNU General Public License
:    along with this program.  If not, see <http://www.gnu.org/licenses/>.

	@Echo Off
	SetLocal DisableDelayedExpansion EnableExtensions
	Set "Path=%ComSpec:~0,-8%"
	If "%1" Neq "LoadANSI" (
	Cd "%~p0"
	Set "Game=%~0"
	Core\Bin\Ansi.dll "%~0" LoadANSI
	EndLocal
	Exit
)
	:: -> Setuping Macro 'GPU' <- ::
	Set LF=^


	For /F "Skip=3 Tokens=1,* Delims=:" %%a in ('Find "@1:" "%Game%"') Do (
	Call Set "Gpu=%%Gpu%%%%b[#LineFeed#]"
	)
	Setlocal EnabledelayedExpansion EnableExtensions
	Set ^"Gpu=!Gpu:[#LineFeed#]=^%LF%%LF%!"
	:: -> End Of... <- ::

:Reinit
	Call :Set &  Cls & Color 0e
	Call :Stop
	For %%a in (Nul Nul Init) Do Call :Effect %%a
	%ui% _Kbd
	If %Key% Equ 13 Goto :Logo
	Call :Exec Logo.ani
:Logo
	Call :Stop
	Call :Set
	Call :Audio 1
	Type Core\Spec\Title
	Set/a Tm=0,Total=0,Rsec=0,Rsec_=0
:Graph
	For /l %%a in (1,1,36) Do (
		Type core\Spec\[%%a]
		Set/a Tm+=1,Rsec_+=1
		If !Rsec! Equ 1 %dip%[1;33m[23;23HPRESS ENTER^^!
		If !Rsec! Geq 2 set/a Rsec=0,Tm+=1
		If !Rsec_! Equ 10 Set/a Rsec+=1,Rsec_=0
		%ui% _kbd
		If %key%==13 Goto :M_
		If %Key%==27 Goto :Exit
		If !Tm! Geq 400 Goto :Scorage
		If Not !Total! Gtr 2000 Set/a Total+=!Errorlevel!
		If !Total! Equ 536 Goto :Select
		If !Total! Equ 750 Goto :End
	)
	Goto :Graph
:Scorage
	Call :Shad
	Call :Stop
	%ui% Sleep 400
	%ui% Font 6
	Mode 30,15
	Type Core\Spec\BgHs
	Call :High Noenter
	%Dip%[1;31m[3;4H      High Scores    
	%Dip%[4;3H                         
	%ui% Cursor 0
	Set/a Tm=0,Rsec=0,Rsec_=0
	:SCore_
	%ui% _Kbd
	If %key%==13 (
		Call :Shad
		Call :Stop
		%ui% Sleep 700
		Goto :logo
	)
	Set/a Tm+=1
	If !Tm! Geq 700 (
	Set Tm=0
	Call :Shad
	Call :Stop
	%ui% Sleep 700
	Goto :Logo
	)
	Goto :Score_

:Select
	Call :shad
	Call :Stop
	Mode 30,15 & %ui% Font 6
	:sel_
	cls
	Echo.[1;33mLevel Select:
	%Dip%[1;32mWrite The # Of Level (1-6^)[1;36m
	Set World=
	Set/p World=^>[1;31m
	If Not Defined World Goto :Sel_
	For /L %%a in (1,1,6) Do If "!World!" Equ "%%a" Goto :Sel__
	Goto :Sel_
	:Sel__
	Call :Info !World!
	Call :ToGame
	Goto :Main
	
	:M_
	Mode 30,15 & %ui% Font 6
	Call :Stop
	%Dip%[1;1H[1;36m[Viewpoint][3;1H
	Type Core\Spec\KeyBoard
	Call :Effect Key
		%ui% _Kbd 
		If %Key%==13 Goto :SkipH
	%Dip%[5;15H[1;32m^<ÄÄÄÄ Move Keys
	%ui% Sleep 4500
		%ui% _Kbd 
		If %Key%==13 Goto :SkipH
	Call :Effect Key
	%Dip%[11;14H[1;33m^<ÄÄÄ Shoot Key
	%ui% Sleep 4500
		%ui% _Kbd 
		If %Key%==13 Goto :SkipH
	Call :Effect Key
	%ui% Sleep 1000

	:SkipH
	cls
	Call :Info !World!
	Call :Stop
	Call :Bg
	Call :Stat
	Call :Audio 2
	Call :Border
	Set/a Co=0,tim=0,ccx=1,tm=0
	Set SP=
	Set ch=!Player!
:Blast Off
	(%Gpu%)
	Set/a Co+=1,Tm+=1
	%Dip%[9;!Ccx!H[1;31m !F%co%![[1;37m!SP!!Ch! 
	If !Co! Geq 4 Set Co=1
	If !Tm! Equ 4   Call :Effect Lose
	If !Tm! Equ 50  Call :Effect Blast1
	If !Tm! Equ 90 Call :Effect Blast2
	If !Tm! Geq 90 If Not !Ccx! Geq 16 Set/a Ccx+=1
	If !Tm! Geq 120 If !Tm! Leq 130 Set "SP=!SP! "
	If !Tm! Equ 131 Set "Ch="
	If !Tm! Equ 160 Goto :B1
	Goto :Blast
	:B1
	Call :ToGame Nop
:Main
	If !End! Gtr 0 ((%Gpu%) & Goto :Lose )
	%ui% _kbd
	If %key% Equ 332 Call :Mov H + Player
	If %key% Equ 330 Call :Mov H - Player
	If %key% Equ 327 Call :Mov V - Player
	If %key% Equ 335 Call :Mov V + Player
	If %key% Equ 32  Call :Shoot
	If %Key% Equ 27  Goto :Exit
:Enemies
	If Not Defined Enemies.Pos Goto :Boss
	If "!Enemies.Pos!" Equ "," Goto :Reload
	If !End! Gtr 0 Goto :Main
	Set Enemies=
	For %%z in (%Enemies.Pos%) Do (
	Set "Enemy.Pos=%%z"
	Set/a Rnd=!Random!%%4
	For %%a in (!Rnd!) Do Call :Mov !Mov[%%a]! Enemy
	Set "Enemies=!Enemies!,!Enemy.Pos!"
	)
	Set "Enemies.Pos=%Enemies%,"
	Goto :Main
:Boss
	If /i "!Win!" Equ "Yes" Goto :Win
	Set/a Rnd=!Random!%%8,Rnd1=!Random!%%9,Rnd2=!Random!%%5
	Call :Mov !Mov[%Rnd%]! Boss
	If !Rnd1! Equ 1 If !Rnd2! Equ 4 Call :Shotb
	Goto :Main
:Shotb
	Call :GetXy Boss.Pos
	Set Boss.Shot.Pos=!Y!.!X!
	Set Last[!Y!.!X!]=!Boss!
	Call :Effect Shoot3
	For /l %%b in (1,1,9) Do (
	If !End! Gtr 0 Goto :Eof
	If !X! Leq 1 Goto :NoShootBoss
	%ui% _kbd
	If %key% Equ 332 Call :Mov H + Player NoRender
	If %key% Equ 330 Call :Mov H - Player NoRender
	If %key% Equ 327 Call :Mov V - Player NoRender
	If %key% Equ 335 Call :Mov V + Player NoRender
	Call :Mov H - Boss.Shot
	)
	:NoShootBoss
	Set Boss.Shot=!Ground!
	Call :Mov H + Boss.Shot NoRender
	Set Boss.Shot=®
	Call :GetXy Boss.Pos
	Set Boss.Pos=!Y!.!X!
	Set Last[!Y!.!X!]=!Ground!
	Goto :Eof
:Mov
	For /F "Tokens=1-2 Delims=." %%x in ("!%3.Pos!") Do Set/a Y=%%x,X=%%y
	If %1 Equ H (Set/a n=X%21) Else (Set/a n=Y%21)
	If %1 Equ H (
		If !n! Gtr !Map.x! Exit/b 1
		If !n! Lss 1 Exit/b 1
	) Else (
		If !n! Gtr !Map.Y! Exit/b 1
		If !n! lss 1 Exit/b 1
	)
	If %1 Equ H (Set/a Col=n-1) Else (Set/a Col=X-1)
	If %1 Equ H (Set "Chr=!T[%Y%]:~%Col%,1!") Else (Set "Chr=!T[%n%]:~%Col%,1!")
	:: - - - - - - - - - - - -::
	::-> Start Of Colitions <-::
	:: - - - - - - - - - - - -::
	If /i %3 Equ Player (
		if "!chr!" Equ "!Enemy!" Set End=1
		If "!Chr!" Equ "!Boss!"  Set End=1
		If "!Chr!" Equ "!EnShot!" Set End=1
		If /i "%4" Equ "Hide"    (
			Set "Last[!Y!.!X!]=!Ground!"
			Set "T[%Y%]=!T[%Y%]:~0,%Col%!!Ground!!T[%Y%]:~%X%!"
			Exit/b 0
		)
	)
	If /i %3 Equ Enemy (
		if "!chr!" Equ "!player!" (
			Set End=1
			Set "Chr=!Ground!"
		)
		if "!chr!" Equ "!enemy!"  Exit/b 1
	)
	If /i %3 Equ Boss if "!chr!" Equ "!player!" (
		Set End=1
		Set "Chr=!Ground!"
	)
	If /i "%3" Equ "Player.Shot" (
	If "!chr!" Equ "!enemy!" (
		Set/a Score+=200
		Call :Stat
		Call :Effect Break
		Set "Enemies.pos=!Enemies.pos:,%Y%.%n%,=,!"
		Set "Chr=!Ground!"
		)
	If "!chr!" Equ "!Boss!" (
		Set/a LifeBoss-=1,Score+=200
		Call :Effect Shoot2
		If !LifeBoss! Leq 0 (
		If !Again! Equ 2 (
			Set/a Again=3,End=2,l=Y+5,t=X+1
			Call :Effect Break
			For /L %%# in (1,1,6) Do (
			For /l %%b in (4,-1,1) Do (
			(%Gpu%)
			%ui% Sleep 20
			%Dip%[1;31m[!l!;!t!H!F%%b!
			))
			Set Boss=Ñ
			Exit/b 2
			)
		Set "Last[!Y!.!n!]=!Chr!"
		Set "T[%Y%]=!T[%Y%]:~0,%Col%!!Ground!!T[%Y%]:~%n%!"
			Set Win=yes
			Set/a Score+=500
		)
		Call :Stat
		Exit/b 1
	)
)
	If /i %3 Equ Boss.Shot If "!chr!" Equ "!Player!" (
		Set End=1
		Set "Chr=!Ground!"
		)
	:: - - - - - - - - - - - -::
	:: -> End Of Colitions <- ::
	:: - - - - - - - - - - - -::
	Set/a Col=X-1
	Set "T[%Y%]=!T[%Y%]:~0,%Col%!!Last[%Y%.%X%]!!T[%Y%]:~%X%!"
	If %1 Equ H Set/a Col=n-1
	IF %1 Equ H (
		Set "Last[!Y!.!n!]=!Chr!"
		Set "T[%Y%]=!T[%Y%]:~0,%Col%!!%3!!T[%Y%]:~%n%!"
		Set %3.Pos=!Y!.!n!
	) Else (
		Set "Last[!n!.!X!]=!Chr!"
		Set "T[%n%]=!T[%n%]:~0,%Col%!!%3!!T[%n%]:~%X%!"
		Set %3.Pos=!n!.!X!
	)
	Set Last[!Y!.!X!]=
	If !End! Equ 1 Exit/b 1
	If !End! Equ 2 ( Call :GenBoss & Set End=0& Exit/b 0)
	If /i "%4" Equ "NoRender" Exit/b 1
	(%Gpu%)
	Exit/b 0

:Shoot
	Call :GetXY Player.Pos
	Set/a n=X+1
	If !n! Geq !Map.X! Goto :Eof
	Set Player.Shot.Pos=!Y!.!x!
	Set Last[!Y!.!x!]=!Player!
	Call :Effect Shoot
	For /l %%a In (1,1,7) Do (
	If !X! Geq !Map.X! Goto :Noshoot
	Call :Mov H + Player.Shot || Goto :NoShoot
	)
	:NoShoot
	Set Player.Shot=!Ground!
	Call :Mov H - Player.Shot NoRender
	Set Player.Shot=¯
	Call :GetXy Player.Pos
	Set Player.Pos=!Y!.!X!
	Set Last[!Y!.!X!]=!Ground!
	Goto :Eof
:GetXY
	For /F "Tokens=1-2 Delims=." %%x in ("!%~1!") Do Set/a Y=%%x,X=%%y
	Goto :Eof
:Border
	Set Border=
	For /F "Tokens=1-2 Delims=." %%a in ("!CBorder!") Do Set _B=%%a&Set _C=%%b
	For /l %%a in (1,1,30) Do Set Border=!Border!!_B!
	%dip%[!_C!m[5;1H!Border![13;1H!Border![;m
	Goto :Eof
:Lose
	Call :Stop
	Call :Effect Lose
	Set/a Live-=1,End=0
	Call :GetXy Player.Pos
	Set/a n=Y+5
	For /l %%a in (1,1,16) Do (
	For /l %%b in (4,-1,1) Do (
	%ui% Sleep 20
	%Dip%[1;31m[!n!;!X!H!F%%b!
	))
	%Dip%[%GR%m[!n!;!X!H!Ground!
	If !live! Lss 0 Goto :Continue
	Call :Togame
	Goto :Main
	:ToGame
	Call :Shad
	:Next
	Call :Bg
	For /l %%a in (1,1,50) Do %ui% _Kbd
	If "%1" Neq "Nop" Call :Audio !Track!
	Call :Info !World!
	%Dip%[1;33m[7;13HREADY
	Call :Stat
	%ui% Sleep 1000
	Call :Random
	Call :Border
	Goto :Main
:Continue
	For /l %%a in (1,1,50) Do %ui% _Kbd
	If !Live! Lss 0 Set Live=0
	Call :High
	If !Continues! Leq 0 Goto :GameOver
	(%Gpu%)
	Call :Stop
	Call :Effect Continue
	%Dip%[6;11H[1;31mCONTINUE?[8;5HPress Enter To Continue
	For /l %%a in (9,-1,0) Do (
	%Dip%[7;15H[1;33m%%a
	%ui% Sleep 1000
	%ui% _Kbd
	If !Errorlevel! Equ 13 (
		Set/a Continues-=1,Live=3,Score=0
		Call :Stop
		Call :ToGame
		Goto :Main
	)
)
	:GameOver
	Call :Shad
	%ui% Sleep 600
	Type Core\Spec\GameOver
	Call :Effect GameOver1
	%Dip%[8;2H[1;1;41;31m
	For %%a in (G A M E " " O V E R) Do (
	%Dip%. %%~a 
	%ui% Sleep 350
	)
	Call :Effect Gameover2
	%ui% Sleep 2000
	Call :Shad
	Goto :Reinit
:Win
	Set Win=no&Set lock=on
	Call :Effect Break
	Call :GetXy Boss.Pos
	Set/a l=Y+5
	For /l %%a in (1,1,16) Do (
	For /l %%b in (4,-1,1) Do (
	(%Gpu%)
	%ui% Sleep 20
	%Dip%[1;31m[!l!;!X!H!F%%b!
	))
	%Dip%[%GR%m[!l!;!X!H!Ground!
	For /l %%a in (1,1,110) Do (
		(%Gpu%)
		If %%a Geq 50 (
		Call :Mov H + Player
		If !Lock! Equ on (IF !X! Equ !Map.X! Call :Mov H - Player Hide&Set Lock=off)
		If %%a Equ 53 Call :Effect Blast2
	))
	%Dip%[!l!;29H!Ground!
	Call :Shad
	Call :Stop
	Call :Stat
	%ui% Sleep 800
	Call :Info !World!
	Set/a "Bonus=!LifeBoss!*100+!S.R.Enemy!+(!Random:~0,2!*5)+2349"
	Set Bonus_=!Bonus!
	%Dip%[5;8H[1;37mSTAGE [1;31m!World![1;37m COMPLETE
	%Dip%[7;10H[1;33mClear Bonus
	%Dip%[8;14H[1;37m!Bonus_!
	%ui% Sleep 1000
	Call :Effect Point
	%ui% Sleep 100
	For /l %%a in (1,1,20) Do (
	%Dip%[8;14H[1;37m         [8;14H[1;37m!Bonus_!
	If Not !Bonus_! Leq 0 Set/a Bonus_-=850
	If !Bonus_! Leq 0 Set Bonus_=0
	%ui% Sleep 20
	)
	Set/a World+=1,Score=!Score!+!Bonus!,Complete=1,w=0,Live+=1
	Call :Stat
	%ui% Sleep 1200
	If !World! Gtr 6 Goto :End
	Call :Info !World!
	cls
	Goto :Next
:End
	Call :Shad
	If "!Total!" Equ "750" (Mode 30,15 & %ui% Font 6)
	Call :Stat
	Call :Stop
	For /l %%a in (1,1,80) Do %ui% _Kbd
	Call :Effect End
	Call :Exec End.data
	:End__
	Call :High
	Call :Shad
	Goto :ReInit
:High Score
	If "%1" Equ "Noenter" (
		Call :Reg %1
		Goto :Eof
	)
	If !Score! Geq !Score5! If !Score! Lss !Score4! (
	Set Score5=!Score!&Set Ar5=!world!&Set Name5=
	Set "light=11#[1;33m[11;5H5TH[11;10H!Score5![11;18H!Ar5![11;23H   "
	Goto :Reg
	)
	If !Score! Geq !Score4! If !Score! Lss !Score3! (
	Set Score5=!Score4!&Set Ar5=!Ar4!&  Set Name5=!name4!
	Set Score4=!Score!& Set Ar4=!World!&Set Name4=
	Set "light=10#[1;33m[10;5H4TH[10;10H!Score4![10;18H!Ar4![10;23H   "
	Goto :Reg
	)
	If !Score! Geq !Score3! If !Score! Lss !Score2! (
	Set Score5=!Score4!&Set Ar5=!Ar4!&  Set Name5=!name4!
	Set Score4=!Score3!&Set Ar4=!Ar3!&  Set Name4=!name3!
	Set Score3=!Score!&Set Ar3=!World!& Set Name3=
	Set "light=9#[1;33m[9;5H3RD[9;10H!Score3![9;18H!Ar3![9;23H   "
	Goto :Reg
	)
	If !Score! Geq !Score2! If !Score! Lss !Score1! (
	Set Score5=!Score4!&Set Ar5=!Ar4!&  Set Name5=!name4!
	Set Score4=!Score3!&Set Ar4=!Ar3!&  Set Name4=!name3!
	Set Score3=!Score2!&Set Ar3=!Ar2!&  Set Name3=!name2!
	Set Score2=!Score!&Set Ar2=!World!&  Set Name2=
	Set "light=8#[1;33m[8;5H2ND[8;10H!Score2![8;18H!Ar2![8;23H   "
	Goto :Reg
	)
	If !score! Geq !Score1! (
	Set Score5=!Score4!&Set Ar5=!Ar4!&  Set Name5=!name4!
	Set Score4=!Score3!&Set Ar4=!Ar3!&  Set Name4=!name3!
	Set Score3=!Score2!&Set Ar3=!Ar2!&  Set Name3=!name2!
	Set Score2=!Score1!&Set Ar2=!Ar1!&  Set Name2=!name1!
	Set Score1=!Score!&Set Ar1=!World!& Set Name1=
	Set "light=7#[1;33m[7;5H1ST[7;10H!Score1![7;18H!Ar1![7;23H   "
	Goto :Reg
	)
	Goto :Eof
	:Reg
	Call :Effect Name
	%ui% Cursor 100
	For %%a in (
	"[1;37m[3;5HEnter Your Initials"
	"[1;31m[4;3H(Write With The Keyboard)"
	"[1;36m[6;5HRank Score  Area  Name"
	"[1;37m[7;5H1ST[7;10H!Score1![7;18H!Ar1![7;23H!Name1!"
	"[1;37m[8;5H2ND[8;10H!Score2![8;18H!Ar2![8;23H!Name2!"
	"[1;37m[9;5H3RD[9;10H!Score3![9;18H!Ar3![9;23H!Name3!"
	"[1;37m[10;5H4TH[10;10H!Score4![10;18H!Ar4![10;23H!Name4!"
	"[1;37m[11;5H5TH[11;10H!Score5![11;18H!Ar5![11;23H!Name5!"
	) Do %Dip%%%~a
	If "%1" Equ "Noenter" Goto :Eof
	For /F "Tokens=1-2 Delims=#" %%a in ("!light!") Do (Set Y=%%a&%Dip%%%b)
	Call :Stat
	If !Y!==7 Set w=1
	If !Y!==8 Set w=2
	If !Y!==9 Set w=3
	If !Y!==10 Set w=4
	If !Y!==11 Set w=5
	:Reg_
	%Dip%[!Y!;23H   [1;32m[!Y!;23H
	Set/p Name!w!=
	If Not Defined Name!w! Goto :Reg_
	Set "Name!w!=!Name%W%:~0,3!"
	%Dip%[1;33m[!Y!;23H!Name%W%!
	Call :Effect Enter
	%ui% Cursor 0
	%ui% Sleep 2000
	Del Core\Spec\Score >nul 2>nul
	For /l %%a in (1,1,5) Do Echo !Score%%a!,!Ar%%a!,!Name%%a!>>Core\Spec\Score
	Goto :Eof
:Shad
	For %%a in (0f,0f,07,07,08,08) Do (
		%ui% Sleep 10
		Color %%a
	)
	Cls
	Goto :Eof
:GetSec
	For /F "Tokens=3 Delims=:." %%a in ("!Time!") Do Set _Sec=%%a
	Goto :Eof
:Stat
If !Score! Geq 99999 Set Score=99999
For %%a in (
"[14;1H[1;32mLives[14;7H[1;31mHigh Score"
"[14;18H[1;36mScore[14;24H[1;33mCredits"
"[15;1H[1;37mõx!Live!"
"[15;27H[0;36mx!Continues!"
) Do %Dip%%%~a
If !Score! Gtr !Score1! (
	%Dip%[15;9H[0;32m!Score![15;18H[0;33m!Score!
	) Else (
	%Dip%[15;9H[0;32m!Score1![15;18H[0;33m!Score!
	) 
	Goto :Eof
:Set
	Call :Flush
	set Ui=Core\Bin\Fn.dll
	Set/a Sc=0,End=0,RSec=0
	Set "Dip=<Nul Set/p="
	%Dip%[;m
	Set Au=Core\bin\Dsp.dll
	Set Key=^^!Errorlevel^^!
	Set "String=icdgtor0CV1ss2emp8nwt3lyDvBgHu9, ^^^!&"
	Set/a Live=3,Continues=2,Score=0,Map.Y=7,Map.X=30,World=1,MaxChr=7
	%ui% Font 0 & %ui% Cursor 0
	Mode 60,30
	For %%a In (
	13,7,10,21,31,32,24,14,25,14,22,5,16,14,
	2,32,26,23,32,28,5,18,27,29,0,20,5,30,
	17,36,37,20,0,20,22,14,32,9,0,14,19,16,
	5,0,18,20
	) Do Set "Rcx=!Rcx!!String:~%%a,1!"
	%Dip%[1;32m[30;16H%Rcx:~0,29%^^![1;1H&%Rcx:~29%
	Set Player=õ
	Set Player.Shot=¯
	Set Boss.Shot=®
	Set EnShot=!Boss.Shot!
	Set Ground=Î
	Set count=0
	Set Win=no
	For /F "Tokens=1-3 Delims=," %%a in ('Type Core\Spec\Score') Do (
	Set/a Count+=1
	Set Score!Count!=%%a
	Set Ar!Count!=%%b
	Set Name!Count!=%%c
	)
	Set Count=0
	Set F1=.&Set F2=^*&Set F3=#&Set F4=
	Set Lf=^


	Set Mov[0]=V +
	Set Mov[1]=V -
	Set Mov[2]=H +
	Set Mov[3]=H -
	Goto :Eof
:Effect
	For %%a in (
	"Shoot 875.808 876.404"
	"Lose 876.661 878.579"
	"Break 878.713 879.314"
	"Blast1 881.428 882.473"
	"Blast2 880.265 881.335"
	"Shoot2 882.662 883.218"
	"Shoot3 883.395 884.016"
	"Continue 841.783 852.091"
	"GameOver1 852.583 854.527"
	"GameOver2 854.599 856.694"
	"End 576.614 718.874"
	"Point 874.111 875.644"
	"Name 718.981 782.257"
	"Enter 879.488 880.217"
	"Key 867.858 871.497"
	"Init 860.758 867.732"
	"Nul 230.680 231.712"
	) Do For /F "Tokens=1-3" %%b in ("%%~a") Do (
		If /i "%1" Equ "%%b" (Set I=%%c&Set F=%%d)
	)
	If Not Defined F Goto :Eof
	If Not Defined I Goto :Eof
	Start /min %AU% Core\Audio.str -q -d trim %I% =%F%
	Set I=&Set F=
	Goto :Eof
:Info World [#]
	Call :Exec Worlds.data %1
	Goto :Eof
:GenBoss
	For /l %%a in (1,1,!Map.Y!) Do Set "T[%%a]=!Blank!"
	Set "T[4]=!T[4]:~0,0!!Player!!T[4]:~1!"
	Set "T[4]=!T[4]:~0,9!!Boss!!T[4]:~10!"
	Set Player.Pos=4.1
	Set "Last[4.1]=!Ground!"
	Set Boss.Pos=4.10
	Set "Last[4.10]=!Ground!"
	Set Enemies.pos=
	Call :Stop
	If !World! Lss 6 ( Call :Audio 9) Else (
	If !Again! Equ 2 Call :Audio 9
	If !Again! Equ 3 (Call :Audio 8 & Set LifeBoss=!OgLifeBoss!)
	)
	Goto :Eof
:Random World
	Set Enemies.Pos=&Set Blank=
	Set MaxCount=0&Set Usedc=4.0
	For /L %%# in (1,1,!Map.x!) Do Set "Blank=!Blank!!Ground!"
	For /L %%# in (1,1,!Map.Y!) Do Set "T[%%#]=!Blank!"
	For /F "Tokens=1 Delims==" %%a in ('Set^|Find /i "Last["') Do Set "%%a="
	:runtime
	If !MaxCount! Geq !MaxChr! Goto :Generated
	Set/a MaxCount+=1
	:::::::::::::::::::::.
	:GndRnd
	Set/a X=!Random!*29/32768+1,Y=!Random!*7/32768+1
	For %%# in (!usedc!) Do For /F "Tokens=1-2 Delims=." %%x in ("%%#") Do (
	If %%x Equ !Y! If %%y Equ !X! Goto :GndRnd
	)
	:::::::::::::::::::::.
	Set "Usedc=!usedc!,!Y!.!X!"
	Set/a _X=X+1
	Set "T[!Y!]=!T[%Y%]:~0,%X%!!Enemy!!T[%Y%]:~%_X%!"
	Set "Enemies.Pos=!Enemies.Pos!,!Y!.!_X!"
	Set "last[!Y!.!_X!]=!Ground!"
	Goto :runtime
	:Generated
	Set "T[4]=!T[4]:~0,0!!Player!!T[4]:~1!"
	Set Player.Pos=4.1
	Set "Last[4.1]=!Ground!"
	Set usedc=
	Goto :Eof
:Reload
	Set/a Complete+=1
	If !Complete! Geq !Phases! (Call :GenBoss & Goto :Main)
	Call :Random
	Goto :Main
:Bg
	Set W=0
	for /F %%a in ('type Core\Spec\Bg!World!') do (
	set/a w+=1
	set "BG[!w!]=%%a"
	)
	Goto :Eof
:Audio
	Call :Exec Audio.data %1
	Goto :Eof
:Exit
	Call :Stop
	Cls & EndLocal
	Exit
:Stop
	Taskkill /fi "windowtitle eq [VpM]">nul 2>nul
	Taskkill /f /im Dsp.dll            >nul 2>nul
	Goto :Eof
:Flush
	For /f "Tokens=1 Delims==" %%a in ('Set') Do (
	If /i "%%a" Neq "Comspec" (
	If /i "%%a" Neq "Tmp" (
	If /i "%%a" Neq "Userprofile" (
	IF /i "%%a" Neq "SystemRoot" (
	IF /i "%%a" Neq "Game" (
	IF /i "%%a" Neq "Gpu" (
	Set "%%a="))))))
	)
	Set "Path=!comspec:~0,-8!;!SystemRoot!;!Comspec:~0,-8!\Wbem"
	Goto :Eof
:Exec [File] [Args]
	Set ".=%~1"
	Set "_~=!tmp!\Tmp$.%random%"
	Md "!_~!"
	Copy Core\Spec\!.! "!_~!\$Tmp.bat" >nul 2>nul
	Call "!_~!\$Tmp.bat" %2 %3 %4 %5 %6 %7 %8 %9 
	Rd /s /q "!_~!" >nul 2>nul
	Set .=&Set _~=
	Exit/b 0

	:: -> Macros area <- ::

@1:Set Gps=
@1:If Defined T[1] (
@1:For /F "Tokens=1-6" %%a in ("!Player! !Enemy! !Boss! !Boss.shot! !Player.Shot! !Gr!") Do (
@1:For /l %%# in (1,1,!Map.Y!) do Set Gps=!Gps!!T[%%#]!
@1:Set "Gps=!Gps:%%a=[1;37m%%a[%%fm!"
@1:Set "Gps=!Gps:%%b=[1;33m%%b[%%fm!"
@1:Set "Gps=!Gps:%%c=[1;36m%%c[%%fm!"
@1:Set "Gps=!Gps:%%d=[1;33m%%d[%%fm!"
@1:Set "Gps=!Gps:%%e=[1;31m%%e[%%fm!"
@1:))
@1:For %%a in (!Sc!) Do (
@1:<Nul Set/p=[1;1H!BG[1]:~%%a,510![2;1H!BG[2]:~%%a,510!
@1:<Nul Set/p=[3;1H!BG[3]:~%%a,510![4;1H!BG[4]:~%%a,510!
@1:)
@1:<Nul Set/p=[!GR!m[6;1H!Gps!
@1:Set/a Sc+=17
@1:If !Sc! Geq 646 Set Sc=0