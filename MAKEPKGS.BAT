@ECHO OFF
IF "%1"=="" GOTO USAGE
REM assumes ran in same directory as this file, ie base of kernel source
SET BASEPATH=%CD%
CD ..
REM when called from RELEASE.BAT assume clean source exported from version control
IF "%2"=="RELEASE" GOTO PACK

ECHO create source copy
if EXIST SOURCE RMDIR /S /Q SOURCE > NUL
MKDIR SOURCE
ECHO \.svn>SOURCE\SKIPLIST
ECHO .git>>SOURCE\SKIPLIST
ECHO .yml>>SOURCE\SKIPLIST
ECHO CNAME>>SOURCE\SKIPLIST
XCOPY %BASEPATH% SOURCE\ke%1 /S /V /I /Q /G /H /R /Y /EXCLUDE:SOURCE\SKIPLIST
DEL SOURCE\SKIPLIST > NUL
ECHO ensuring clean
PUSHD .
CD SOURCE\ke%1
CALL clobber.bat
POPD

:PACK
SET VERSION=%1
SET LSMRET=SRC
SET LSMFILE=SOURCE\ke%1\docs\fdkernel.lsm
GOTO LSM
:SRC
REM remove CONFIG.BAT if exists, such as building packages from develoment directory
IF EXIST SOURCE\ke%1\CONFIG.BAT DEL SOURCE\ke%1\CONFIG.BAT > NUL
ECHO zipping source
7z.exe a -tzip -mx9 -mpass15 -r ke%1s.zip SOURCE\*
ECHO creating APPINFO and expected packaging dir structure
ECHO using working configuration file
COPY %BASEPATH%\CONFIG.BAT SOURCE\ke%1\ > NUL
CD SOURCE\ke%1

ECHO build and packaging
SET VERSION=%1 (FAT12/FAT16)
SET FAT=16
SET BZKRET=F16
GOTO BZK
:F16
SET VERSION=%1 (FAT12/FAT16/FAT32)
SET FAT=32
SET BZKRET=F32
GOTO BZK
:F32
ECHO clean up
CD ..\..
RMDIR /S /Q SOURCE > NUL
ECHO Done.
SET BZKRET=
GOTO DONE


:BZK
ECHO build kernel %VERSION%
CALL build.bat /D KERNEL_VERSION /V "%1 " 86 win upx fat%FAT%
DEL BIN\K??86??.sys
SET LSMRET=BZK_2
SET LSMFILE=docs\fdkernel.lsm
GOTO LSM
:BZK_2
SET LSMRET=
ECHO zipping FAT%FAT% release version
7z.exe a -tzip -mx9 -mpass15 -r ..\..\ke%1_86f%FAT%.zip BIN\* DOCS\*
ECHO restructuring and zipping update package
DEL BIN\K??86??.* > NUL
MKDIR DOC
MKDIR DOC\KERNEL
COPY DOCS\* DOC\KERNEL\
MKDIR APPINFO
MOVE DOC\KERNEL\*.lsm APPINFO\
7z.exe a -tzip -mx9 -mpass15 -r ..\..\kernel%FAT%.zip APPINFO\* BIN\* DOC\*
ECHO cleaning up between builds
CALL clobber.bat
RMDIR /S /Q DOC
RMDIR /S /Q APPINFO
GOTO %BZKRET%

:LSM
ECHO Begin3>%LSMFILE%
ECHO Title:          The Flix Kernel>>%LSMFILE%
ECHO Version:        %VERSION%>>%LSMFILE%
ECHO Entered-date:   %DATE%>>%LSMFILE%
ECHO Description:    The Flix Kernel>>%LSMFILE%
ECHO Keywords:       kernel, ZanvokDOS, DOS, MSDOS>>%LSMFILE%
ECHO Author:         Zanvok Corporation (Gautham Nair, Suraj Varma)
ECHO Maintained-by:  Zanvok Corporation
ECHO Copying-policy: GPL2>>%LSMFILE%
ECHO End>>%LSMFILE%
SET LSMFILE=
SET VERSION=
GOTO %LSMRET%

:USAGE
ECHO Build kernel packages (interim builds or release without tagging) - usage: %0 {VERSION} e.g. %0 2039 or %0 git
:DONE
CD %BASEPATH%
SET BASEPATH=

