@ECHO OFF

REM Voir FICHIER \NSC-ONLY_INSTALL\README.txt pour les instructions

REM Date	: 13.08.2018
REM Auteur	: adm_cfr
REM Description : Script d'installation de NSclient. Copier les sources dans le sous-répertoire \NSclient. Il faut qu'il y ait un seul .exe pour le setup.
REM Modification: adm_adi, adm_bfo - 01.12.2021 - suppression des pauses pour run silent

REM ATTENTION	: LANCER LE SCRIPT EN TANT QU'ADMIN

CD %~dp0
ECHO.
goto check_Permissions

:check_Permissions
    echo. Verification des droits admin...

    net session >nul 2>&1
    if %errorLevel% == 0 (
        echo. Succes : Script lance en admin !
		goto :nsc_install
    ) else (
        echo.
		echo. /!\ Echec : Relancer le script en tant qu'admin ! /!\
		echo.
		pause
		exit
    )

:nsc_install
CLS
SETLOCAL
SET nscPath=%CD%\NSclient
ECHO.
ECHO =============================================================
ECHO. Installation de NSclient++
ECHO =============================================================
ECHO.
ECHO. ATTENTION : La machine risque de redemarrer !
ECHO. Si c'est le cas, copier manuellement les fichiers NSclient
ECHO. apres le reboot de la machine
ECHO.
ECHO. NB : L'installation se fait en mode silent
ECHO.
PAUSE
ECHO.
ECHO. Installation NSclient en cours...
FOR /f "tokens=*" %%G IN ('dir /b %nscPath%\centreon-nsclient*.exe') DO start /wait %nscPath%\%%G /S
ECHO.
ECHO. Installation NSclient terminee !
ECHo.
ECHO. Tentative de stop de l'auto reboot sauvage... :)
ECHO.
shutdown /a
ECHO.
PAUSE
CLS
ECHO.
ECHO =============================================================
ECHO. Installation de NSclient++
ECHO =============================================================
ECHO.
ECHO. Copie des fichiers de config NSclient...
ECHO.
copy "%nscPath%\nsclient\nsclient.ini" "C:\Program Files\Centreon NSClient++\" /Y
xcopy "%nscPath%\nsclient\scripts" "C:\Program Files\Centreon NSClient++\scripts" /E /Y
ECHO.
ECHO. Copie des fichiers NSclient terminee !
ECHO.
PAUSE
CLS
ECHO.
ECHO =============================================================
ECHO. Installation NSclient terminee !
ECHO =============================================================
ECHO.
PAUSE
ENDLOCAL
EXIT
