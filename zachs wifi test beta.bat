@echo off

color 0E
set /p serial="ENTER SERIAL #: "
set /p tests="How many tests?: "
set /A runtime = %tests%*5
echo The test will run %tests% times and will take approxamately %runtime% min.
for /l %%x in (1, 1, %tests%) do ( 

echo Connecting to Wallaby %serial%... 
netsh wlan connect name="%serial%-wallaby" ssid="%serial%-wallaby" 
if errorlevel==1 GOTO ERROR
timeout 10 

echo rebooting Wallaby %serial%... 
ssh root@192.168.125.1 "reboot" 

echo Wallaby %serial% rebooted. Waiting 300 seconds for the wifi to turn on...

timeout 300

)
color FD
cls
echo FINISHED
pause
EXIT \B 0

:ERROR
echo WALLABY MALFUNCTION OR ERROR HAS OCCURED
pause
EXIT \B 1