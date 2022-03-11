@echo off

cd c:\android-backup-extractor

rem パッケージ指定
:input_check
set pacname=
set /P pacname="抽出するアプリのパッケージ名を入力:"
if %pacname% =="" goto :input_check

rem バックアップ
adb backup -apk -obb %pacname%

rem 終わるまで待つ
:no_ok

if exist backup.ab (
    goto :ok
)
goto :no_ok

:ok

echo 一次展開中

rem 展開
java -jar abp.jar unpack backup.ab extracted_data.tar

rem 終わるまで待つ
:no_ok2

if exist extracted_data.tar (
    goto :ok2
)
goto :no_ok2

:ok2

echo 二次展開中

mkdir %USERPROFILE%\Documents\extracted_apps\%pacname%
cd %USERPROFILE%\Documents\extracted_apps\%pacname%

rem 7zipで展開
"C:\Program Files\7-Zip\7z.exe" x -y -o%USERPROFILE%\Documents\extracted_apps C:\android-backup-extractor\extracted_data.tar

del C:\android-backup-extractor\extracted_data.tar
del C:\android-backup-extractor\backup.ab

rem explorerを開く
explorer %USERPROFILE%\Documents\extracted_apps\%pacname%