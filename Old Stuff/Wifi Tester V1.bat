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
for /l %%x in (1,1,%tests%) do ( 
	echo 	Test #%%x initiating...
	for /l %%n in (1,1,%wallabies%) do (
		
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



cls
color FD
echo FINISHED
pause
EXIT \B 0

:ERROR

color CF
echo. WALLABY MALFUNCTION OR ERROR HAS OCCURED PLEASE TRY AGAIN
pause
GOTO BEGIN