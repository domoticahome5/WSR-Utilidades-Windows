
@echo off
title Mantenimiento de Windows 10/11 WSR

color 0A

:menu
cls
echo              ===================================================================
echo                    MANTENIMIENTO  WINDOWS / UTILIDADES 10 - 11 v1  WSR
echo              ===================================================================

echo                           ===LIMPIEZA Y OPTIMIZACION ===
echo.
echo 1.      Limpiar Archivos Temporales                               2. Ejecutar Liberador de Espacio en Disco
echo 3.      Optimizar discos (Admin)                                  4. Herramienta de Software Malintencionado (MRT)
echo 5.      Reparar Integridad Datos Disco Duro (ReQuiere Reiniciar)  6. Desfragmentador de Unidades Windows
echo 7.      Eliminar Archivos Temporales Y Cache De Sistema
echo.
echo                          === Herramientas Redes ===
echo.                          
echo 8.      Limpiar Cache DNS                                         9. Reiniciar Adaptador de Red
echo 10.     Mostrar Informacion de Red (ipconfig /all)                11.Ver Mac Direccion Mac (Redes)
echo 12.     Reparacion de red - automatico
echo.
echo                           === SALUD SISTEMA ===
echo.
echo 13.     Reparar Archivos Del Sistema 
echo 14.     Escanear Archivos Corruptos (SFC /scannow) (Admin)
echo 15.     Comprobar Salud Windows  (SFC y DISM) (Admin)
echo.
echo                           === EXTRAS ===
echo.
echo 16.     Buscar Actualizaciones (Windows Update)                   17. Diagnostico Memoria Ram
echo 18.     Herramienta Reparacion de actualizaciones Windows.        19. Actualizar Windows (Winget Upgrade)
echo 20.     Crear Punto de Restauracion.                            
echo 00.     Salir.



echo.
set /p opcion=Seleccione una opcion [1-6]: 

if "%opcion%"=="1"  goto limpiar_temporales
if "%opcion%"=="2"  goto liberador
if "%opcion%"=="3"  goto optimizar 
if "%opcion%"=="4"  goto MRT
if "%opcion%"=="5"  goto Integridad_Discos
if "%opcion%"=="6"  goto Desfragmentador
if "%opcion%"=="7"  goto Temporales
if "%opcion%"=="8"  goto Dns
if "%opcion%"=="9"  goto Reinicio_Red
if "%opcion%"=="10" goto Info_Redes
if "%opcion%"=="11" goto mac
if "%opcion%"=="12" goto Red_automatico
if "%opcion%"=="13" goto Salud
if "%opcion%"=="14" goto SFC_Solo
if "%opcion%"=="15" goto reparar
if "%opcion%"=="16" goto actualizar
if "%opcion%"=="17" goto Ram
if "%opcion%"=="18" goto Reparar Windows Update
if "%opcion%"=="19" goto winget
if "%opcion%"=="20" goto Punto
if "%opcion%"=="00" goto Salir


goto menu

:Salud
cls
echo Comprobación del estado de salud de Windows (DISM /CheckHealth)...
dism /online /cleanup-image /checkhealth
pause
goto menu

:Info_Redes
cls
echo Mostrando Informacion de Redes...
ipconfig /all
pause
goto menu

:Temporales
cls

:confirm_loop
echo ¿Quieres eliminar archivos temporales y cache del sistema? (Y/N)
set /p confirm=Type Y or N: 

IF /I "%confirm%"=="Y" (
    goto delete_temp
) ELSE IF /I "%confirm%"=="YES" (
    goto delete_temp
) ELSE IF /I "%confirm%"=="N" (
    echo Operacion cancelada.
    pause
    goto menu
) ELSE IF /I "%confirm%"=="NO" (
    echo Operacion cancelada.
    pause
    goto menu
) ELSE (
    echo Entrada no valida. Por favor, escriba. Y or N.
    goto confirm_loop
)

:delete_temp
echo Eliminar archivos temporales y cache del sistema...
del /s /f /q %temp%\*.*
del /s /f /q C:\Windows\Temp\*.*
del /s /f /q "C:\Users\%USERNAME%\AppData\Local\Temp\*.*"
echo Archivos temporales eliminados.
pause
goto menu



:Reinicio_Red
cls
echo Reiniciando el adaptador de Red...
netsh interface set interface "Wi-Fi" admin=disable
netsh interface set interface "Wi-Fi" admin=enable
echo Adaptador de Red Reiniciado.
pause
goto menu

:Dns
cls
echo ======================================================
echo Borrar la cache DNS...
ipconfig /flushdns

:limpiar_temporales
echo Limpiando archivos temporales...
del /s /f /q %temp%\*.* >nul 2>&1
del /s /f /q C:\Windows\Temp\*.* >nul 2>&1
echo Limpieza completada.
pause
goto menu

:SFC_Solo
cls
echo Escaneando en busca de archivos corruptos (SFC /scannow)...
sfc /scannow
pause
goto menu

:liberador
echo Iniciando el liberador de espacio en disco...
cleanmgr
pause
goto menu

:reparar
echo Ejecutando SFC y DISM...
sfc /scannow
DISM /Online /Cleanup-Image /RestoreHealth
echo Reparacion completada.
pause
goto menu

:optimizar
echo Optimizando disco C:
defrag C: /O
echo Optimizacion completada.
pause
goto menu

:actualizar
echo Abriendo Windows Update...
start ms-settings:windowsupdate
pause
goto menu

:Ram
echo Iniciando Diagnostico Memoria RAM
mdsched
pause
goto menu

:MRT
echo Iniciando Herramienta Windows Malintencionado...
mrt
pause
goto menu

:Integridad_Discos
echo Iniciando Check Disk...
chkdsk C: /f /r
pause
goto menu

:Desfragmentador
echo iniciando..
dfrgui
pause
goto menu 

:Mac
Echo Inicando..
getmac /v
pause
goto menu

:Reparar Windows Update
cls
echo =============================================================
echo      Herramienta de reparacion de actualizaciones de Windows
echo =============================================================

echo Deteniendo Servicios...
net stop wuauserv >nul 2>&1
net stop bits >nul 2>&1
net stop cryptsvc >nul 2>&1
net stop msiserver >nul 2>&1

echo Eliminando -cache carpetas...
rd /s /q %windir%\SoftwareDistribution
rd /s /q %windir%\System32\catroot2

echo Iniciando Servicios...
net start wuauserv >nul 2>&1
net start bits >nul 2>&1
net start cryptsvc >nul 2>&1
net start msiserver >nul 2>&1

echo.
echo Restablecimiento de componentes de Windows Update.
pause
goto menu

:Red_automatico
title Resparando Su Configuracion de Red 
cls
echo.
echo ================================
echo     Reparador de Red Automatico
echo ================================
echo.
echo Step 1: Renovando su Direccion IP...
ipconfig /release >nul
ipconfig /renew >nul

echo Step 2: Refrescando Configuracion DNS...
ipconfig /flushdns >nul

echo Step 3: Restaurando componentes de Red...
netsh winsock reset >nul
netsh int ip reset >nul

echo.
echo Su configuracion de red se ha actualizado.
echo Se recomienda reiniciar el sistema para que funcione correctamente.
echo.
:askRestart
set /p restart=Te gustaria reiniciar ahora? (Y/N): 
if /I "%restart%"=="Y" (
    shutdown /r /t 5
) else if /I "%restart%"=="N" (
    goto menu
) else (
    echo Entrada invalida. Presione Y or N.
    goto askRestart
)
pause
goto menu

:winget
cls
where winget >nul 2>nul || (
    echo Winget no esta instalado. Instalalo desde Microsoft Store.
    pause
    goto menu
)
echo Ejecutando la actualizacion de Windows (Winget upgrade)...
winget upgrade --all --include-unknown
pause
goto menu


:Punto
Echo Inicando..
rstrui
pause
goto menu


:Salir
echo Saliendo del programa...
timeout /t 2 >nul
exit


