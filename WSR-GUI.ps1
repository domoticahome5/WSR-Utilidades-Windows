
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Crear ventana principal
$form = New-Object System.Windows.Forms.Form
$form.Text = "Mantenimiento Windows 10/11 WSR - GUI"
$form.Size = New-Object System.Drawing.Size(600, 700)
$form.StartPosition = "CenterScreen"

# Crear panel scroll para contener botones
$panel = New-Object System.Windows.Forms.Panel
$panel.Dock = "Fill"
$panel.AutoScroll = $true
$form.Controls.Add($panel)

# Función para crear botones
function Add-Button {
    param($text, $posY, $action)
    $btn = New-Object System.Windows.Forms.Button
    $btn.Text = $text
    $btn.Size = New-Object System.Drawing.Size(550, 35)
    $btn.Location = New-Object System.Drawing.Point(15, $posY)
    $btn.Add_Click($action)
    $panel.Controls.Add($btn)
}

# Variables para posición de botones
$y = 10
$spacing = 40

# Agregar botones según tu menú batch
Add-Button "1. Limpiar Archivos Temporales" $y { LimpiarTemporales }
$y += $spacing
Add-Button "2. Ejecutar Liberador de Espacio en Disco" $y { Liberador }
$y += $spacing
Add-Button "3. Optimizar discos (Admin)" $y { OptimizarDiscos }
$y += $spacing
Add-Button "4. Herramienta de Software Malintencionado (MRT)" $y { EjecutarMRT }
$y += $spacing
Add-Button "5. Reparar Integridad Datos Disco Duro (Requiere Reiniciar)" $y { RepararDisco }
$y += $spacing
Add-Button "6. Desfragmentador de Unidades Windows" $y { Desfragmentador }
$y += $spacing
Add-Button "7. Eliminar Archivos Temporales Y Cache De Sistema" $y { EliminarTemporalesCache }
$y += $spacing

Add-Button "8. Limpiar Cache DNS" $y { LimpiarCacheDNS }
$y += $spacing
Add-Button "9. Reiniciar Adaptador de Red" $y { ReiniciarAdaptadorRed }
$y += $spacing
Add-Button "10. Mostrar Informacion de Red (ipconfig /all)" $y { MostrarInfoRed }
$y += $spacing
Add-Button "11. Ver Direccion MAC (Redes)" $y { VerMAC }
$y += $spacing
Add-Button "12. Reparacion de red - automatica" $y { ReparacionRedAutomatica }
$y += $spacing

Add-Button "13. Reparar Archivos Del Sistema" $y { RepararSistema }
$y += $spacing
Add-Button "14. Escanear Archivos Corruptos (SFC /scannow) (Admin)" $y { SFC_Scan }
$y += $spacing
Add-Button "15. Comprobar Salud Windows (SFC y DISM) (Admin)" $y { ComprobarSalud }
$y += $spacing

Add-Button "16. Buscar Actualizaciones (Windows Update)" $y { AbrirWindowsUpdate }
$y += $spacing
Add-Button "17. Diagnostico Memoria RAM" $y { DiagnosticoRAM }
$y += $spacing
Add-Button "18. Reparacion de actualizaciones Windows" $y { RepararWindowsUpdate }
$y += $spacing
Add-Button "19. Actualizar Windows (Winget Upgrade)" $y { WingetActualizar }
$y += $spacing
Add-Button "20. Crear Punto de Restauracion" $y { CrearPuntoRestauracion }
$y += $spacing

Add-Button "00. Salir" $y { $form.Close() }

# Funciones que ejecutan comandos

function Ejecutar-ComandoElevado($scriptBlock) {
    # Ejecutar con elevación
    $psi = New-Object System.Diagnostics.ProcessStartInfo
    $psi.FileName = "powershell.exe"
    $psi.Arguments = "-NoProfile -WindowStyle Hidden -Command & {Start-Process powershell -ArgumentList '-NoProfile -Command & { $($scriptBlock.ToString()) }' -Verb RunAs}"
    $psi.UseShellExecute = $true
    [Diagnostics.Process]::Start($psi) | Out-Null
}

function LimpiarTemporales {
    [System.Windows.Forms.MessageBox]::Show("Limpiando archivos temporales...")
    del /s /f /q $env:TEMP\*.* 2>$null
    del /s /f /q C:\Windows\Temp\*.* 2>$null
    del /s /f /q "$env:USERPROFILE\AppData\Local\Temp\*.*" 2>$null
    [System.Windows.Forms.MessageBox]::Show("Archivos temporales eliminados.")
}

function Liberador {
    Start-Process cleanmgr
}

function OptimizarDiscos {
    Ejecutar-ComandoElevado { defrag C: /O }
}

function EjecutarMRT {
    Start-Process mrt
}

function RepararDisco {
    Ejecutar-ComandoElevado { chkdsk C: /f /r }
}

function Desfragmentador {
    Start-Process dfrgui
}

function EliminarTemporalesCache {
    $result = [System.Windows.Forms.MessageBox]::Show("¿Quieres eliminar archivos temporales y cache del sistema?","Confirmar", [System.Windows.Forms.MessageBoxButtons]::YesNo)
    if ($result -eq [System.Windows.Forms.DialogResult]::Yes) {
        LimpiarTemporales
    }
}

function LimpiarCacheDNS {
    ipconfig /flushdns | Out-Null
    [System.Windows.Forms.MessageBox]::Show("Cache DNS limpiada.")
}

function ReiniciarAdaptadorRed {
    Ejecutar-ComandoElevado {
        netsh interface set interface "Wi-Fi" admin=disable
        netsh interface set interface "Wi-Fi" admin=enable
    }
    [System.Windows.Forms.MessageBox]::Show("Adaptador de red reiniciado.")
}

function MostrarInfoRed {
    Start-Process powershell -ArgumentList "ipconfig /all; pause"
}

function VerMAC {
    Start-Process powershell -ArgumentList "getmac /v; pause"
}

function ReparacionRedAutomatica {
    Ejecutar-ComandoElevado {
        ipconfig /release
        ipconfig /renew
        ipconfig /flushdns
        netsh winsock reset
        netsh int ip reset
    }
    $restart = [System.Windows.Forms.MessageBox]::Show("Configuración de red actualizada.`n¿Deseas reiniciar ahora?","Reinicio requerido",[System.Windows.Forms.MessageBoxButtons]::YesNo)
    if ($restart -eq [System.Windows.Forms.DialogResult]::Yes) {
        shutdown /r /t 5
    }
}

function RepararSistema {
    Ejecutar-ComandoElevado { sfc /scannow }
}

function SFC_Scan {
    Ejecutar-ComandoElevado { sfc /scannow }
}

function ComprobarSalud {
    Ejecutar-ComandoElevado {
        sfc /scannow
        DISM /Online /Cleanup-Image /RestoreHealth
    }
}

function AbrirWindowsUpdate {
    Start-Process ms-settings:windowsupdate
}

function DiagnosticoRAM {
    Start-Process mdsched
}

function RepararWindowsUpdate {
    Ejecutar-ComandoElevado {
        net stop wuauserv
        net stop bits
        net stop cryptsvc
        net stop msiserver
        rd /s /q $env:windir\SoftwareDistribution
        rd /s /q $env:windir\System32\catroot2
        net start wuauserv
        net start bits
        net start cryptsvc
        net start msiserver
    }
    [System.Windows.Forms.MessageBox]::Show("Restablecimiento de componentes de Windows Update completado.")
}

function WingetActualizar {
    if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
        [System.Windows.Forms.MessageBox]::Show("Winget no está instalado. Instálalo desde Microsoft Store.")
        return
    }
    Start-Process winget -ArgumentList "upgrade --all --include-unknown"
}

function CrearPuntoRestauracion {
    Start-Process rstrui
}

# Mostrar el formulario
$form.Topmost = $true
$form.Add_Shown({$form.Activate()})
[void] $form.ShowDialog()
