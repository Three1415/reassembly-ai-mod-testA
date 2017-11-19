:: If post-build.bat is failing from Visual Studio and you can't tell
::   why, un-comment-out the "pause" at the end of this script and run
::   it manually, so you can see what it's trying to do and failing on.
@ECHO OFF

:: First arg: mod name (optionally quoted)

:: Remember to update your mod's directory!!
:: Note!  "robocopy" gets *really* confused by backslashes sometimes.
::   So be sure you don't leave a trailing one in your path here.
::   Also be sure the path here is double-quoted.
set MY_MOD_OUTPUT="%USERPROFILE%\Saved Games\Reassembly\mods\%~1"
set MY_AI_OUTPUT="%MY_MOD_OUTPUT:"=%\ai"
echo %MY_MOD_OUTPUT%
echo %MY_AI_OUTPUT%
::pause

:: Don't do any copying work if it doesn't look like we were run by Visual Studio.
if "%1"=="" echo "Warning: Only makes sense to run this from Visual Studio via Build." && exit /B 1

:: Copy AI DLL and PDB (for debugging) to your mod's AI dir.
:: That "%~dp0" craziness just means "this .bat file's location".
::   It *is* supposed to be against "Release" with no backslash.
::   Otherwise robocopy gets horribly confused by the "\\" since
::   "%~dp0" has a trailing backslash.
robocopy "%~dp0Release" %MY_AI_OUTPUT% *.dll *.pdb /FP
:: errorlevel 1: did something (copied some stuff)
if errorlevel 1 goto robocopy_success
:: errorlevel 0: did nothing (all skipped)
if errorlevel 0 goto robocopy_success
exit /B 1

:robocopy_success

:: Provide default template files if not already present.
::   Completing a build should completely prepare a mod for use.
if not exist "%MY_MOD_OUTPUT:"=%\factions.lua" (
    :: "%~dp0" has a trailing slash, which confuses robocopy.  Ending period removes it.
    robocopy "%~dp0." %MY_MOD_OUTPUT% factions.lua /FP
)
exit /B 1

::pause
exit /B 0