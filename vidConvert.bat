@echo OFF
SETLOCAL
SET destination=
:Start
SET /p choice=Destination: Type [C] for CTP, [P] for PL:
IF %choice%==C GOTO CTP
IF %choice%==c GOTO CTP
IF %choice%==P GOTO PL
IF %choice%==p GOTO PL
GOTO Start
:CTP
SET destination=ctp-vids
GOTO Loop
:PL
SET destination=pl-imgs
GOTO Loop
:Loop
IF "%~1" == "" GOTO End
SET pathname=%~d1%~p1
SET filenameOriginal=%~n1
SET filename=%filenameOriginal: =-%
SET ext=%~x1
SET webm=%pathname%%filename%_web.webm
set mp4=%pathname%%filename%_web.mp4
ffmpeg -i "%pathname%%filenameOriginal%%ext%" -vcodec libvpx-vp9 -b:v 1M -acodec libvorbis "%webm%" -vcodec h264 -acodec aac -strict -2 "%mp4%" -vframes 1 -an -ss 15 "%pathname%%filename%.jpg"
aws s3 sync "%pathname%/" s3://%destination%/ --exclude "*" --include "%filename%*" --acl "public-read"
echo %date% %time%,%filename%_web >> "%pathname%output.csv"
SHIFT
GOTO Loop
:End
echo Videos encoded and uploaded to the %destination% s3 bucket! Press enter to exit...
set /p input= 
