@echo off
setlocal enabledelayedexpansion
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
set /A runtime = %tests%*5

cls
color 0c
echo -----------------------------------
echo ^|KIPR Wallaby Wifi Testing Utility^|
echo ^|Created by: Zachary Sasser       ^|
echo -----------------------------------
echo The test will run %tests% times and will take approxamately %runtime% min.
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
		echo Connecting to Wallaby !serial[%%n]!... 
		netsh wlan connect name="!serial[%%n]!-wallaby" ssid="!serial[%%n]!-wallaby" 
		if errorlevel==1 GOTO ERROR
		timeout 10 
		

		echo rebooting Wallaby !serial[%%n]!... 
		ssh root@192.168.125.1 "reboot" 
	)
	echo Wallabies rebooted. Waiting 300 seconds for the wifi to turn on...

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
echo WALLABY MALFUNCTION OR ERROR HAS OCCURED
pause
EXIT \B 1