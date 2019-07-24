@echo off
setlocal enabledelayedexpansion
:BEGIN
cls
color 0E
echo -----------------------------------
echo ^|KIPR Wallaby Wifi Testing Utility^|
echo ^|Created by: Zachary Sasser       ^|
echo -----------------------------------
set /p wallabies="How many Wallabies?: "
for /l %%i in (1, 1, %wallabies%) do (
	set /p serial[%%i]="Enter serial number %%i: "
	echo Wallaby %%i has Serial Number !serial[%%i]!
)

set /p tests="How many tests?: "
set /A runtime = %tests%*5+(%wallabies%*30)/60

cls
color 0d
echo -----------------------------------
echo ^|KIPR Wallaby Wifi Testing Utility^|
echo ^|Created by: Zachary Sasser       ^|
echo -----------------------------------



set /A hours=%runtime%/60
set /A minutes=(%runtime%)%%60
echo The test will run %tests% times and will take approxamately %hours% hours and  %minutes% minutes.


timeout 5

cls 
echo -----------------------------------
echo ^|KIPR Wallaby Wifi Testing Utility^|
echo ^|Created by: Zachary Sasser       ^|
echo -----------------------------------

color 0b
netsh wlan delete profile "*-wallaby"
for /l %%x in (1,1,%tests%) do ( 
	echo 	Test #%%x initiating...
	for /l %%n in (1,1,%wallabies%) do (
		
		for /f %%i in ('python getPassword.py !serial[%%n]!') do set PASS=%%i
		echo The password is:!PASS!
		timeout 5
		echo.^<?xml version="1.0"?^> > !serial[%%n]!-wallaby.xml
		echo.^<WLANProfile xmlns="http://www.microsoft.com/networking/WLAN/profile/v1"^> >> !serial[%%n]!-wallaby.xml
		echo.	^<name^>!serial[%%n]!-wallaby^</name^> >> !serial[%%n]!-wallaby.xml
		echo.	^<SSIDConfig^> >> !serial[%%n]!-wallaby.xml
		echo.		^<SSID^> >> !serial[%%n]!-wallaby.xml
		echo.			^<name^>!serial[%%n]!-wallaby^</name^> >> !serial[%%n]!-wallaby.xml
		echo.		^</SSID^> >> !serial[%%n]!-wallaby.xml
		echo.	^</SSIDConfig^> >> !serial[%%n]!-wallaby.xml
		echo.	^<connectionType^>ESS^</connectionType^> >> !serial[%%n]!-wallaby.xml
		echo.	^<connectionMode^>manual^</connectionMode^> >> !serial[%%n]!-wallaby.xml
		echo.	^<MSM^> >> !serial[%%n]!-wallaby.xml
		echo.		^<security^> >> !serial[%%n]!-wallaby.xml
		echo.			^<authEncryption^> >> !serial[%%n]!-wallaby.xml
		echo.				^<authentication^>WPA2PSK^</authentication^> >> !serial[%%n]!-wallaby.xml
		echo.				^<encryption^>TKIP^</encryption^> >> !serial[%%n]!-wallaby.xml
		echo.				^<useOneX^>false^</useOneX^> >> !serial[%%n]!-wallaby.xml
		echo.			^</authEncryption^> >> !serial[%%n]!-wallaby.xml
		echo.			^<sharedKey^> >> !serial[%%n]!-wallaby.xml
		echo.				^<keyType^>passPhrase^</keyType^> >> !serial[%%n]!-wallaby.xml
		echo.				^<protected^>false^</protected^> >> !serial[%%n]!-wallaby.xml
		echo.				^<keyMaterial^>!PASS!^</keyMaterial^> >> !serial[%%n]!-wallaby.xml
		echo.			^</sharedKey^> >> !serial[%%n]!-wallaby.xml
		echo.		^</security^> >> !serial[%%n]!-wallaby.xml
		echo.	^</MSM^> >> !serial[%%n]!-wallaby.xml
		echo.	^<MacRandomization xmlns="http://www.microsoft.com/networking/WLAN/profile/v3"^> >> !serial[%%n]!-wallaby.xml
		echo.		^<enableRandomization^>false^</enableRandomization^> >> !serial[%%n]!-wallaby.xml
		echo.	^</MacRandomization^> >> !serial[%%n]!-wallaby.xml
		echo.^</WLANProfile^> >> !serial[%%n]!-wallaby.xml
		netsh wlan add profile filename="!serial[%%n]!-wallaby.xml"
		
		
		echo. Connecting to Wallaby !serial[%%n]!... 
		netsh wlan connect name="!serial[%%n]!-wallaby" ssid="!serial[%%n]!-wallaby" 
		if errorlevel==1 GOTO ERROR 

		echo rebooting Wallaby !serial[%%n]!...
		timeout 10
		ssh root@192.168.125.1 "reboot"
		echo. Wallaby !serial[%%n]! should be rebooting now. ------------------ Check for "connection reset"
		timeout 0
	)
	echo. Wallabies rebooted. Waiting for the wifi to turn on...
	timeout 300
	cls
	echo -----------------------------------
	echo ^|KIPR Wallaby Wifi Testing Utility^|
	echo ^|Created by: Zachary Sasser       ^|
	echo -----------------------------------
)
netsh wlan delete profile "*-wallaby"


cls
color FD
echo FINISHED
pause
EXIT \B 0

:ERROR
netsh wlan delete profile "*-wallaby"
color CF
echo. WALLABY MALFUNCTION OR ERROR HAS OCCURED PLEASE TRY AGAIN
pause
GOTO BEGIN
