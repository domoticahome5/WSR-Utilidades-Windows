Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Crear ventana principal
$form = New-Object System.Windows.Forms.Form
$form.Text = "Mantenimiento Windows 10/11 WSR - GUI"
$form.Size = New-Object System.Drawing.Size(600, 750)
$form.StartPosition = "CenterScreen"

# Crear pestañas
$tabControl = New-Object System.Windows.Forms.TabControl
$tabControl.Dock = "Fill"
$form.Controls.Add($tabControl)

# Crear pestaña principal
$tabPrincipal = New-Object System.Windows.Forms.TabPage
$tabPrincipal.Text = "Herramientas"
$tabControl.Controls.Add($tabPrincipal)

$panel = New-Object System.Windows.Forms.Panel
$panel.Dock = "Fill"
$panel.AutoScroll = $true
$tabPrincipal.Controls.Add($panel)

function Add-Button {
    param($text, $posY, $action)
    $btn = New-Object System.Windows.Forms.Button
    $btn.Text = $text
    $btn.Size = New-Object System.Drawing.Size(550, 35)
    $btn.Location = New-Object System.Drawing.Point(15, $posY)
    $btn.Add_Click($action)
    $panel.Controls.Add($btn)
}

# Crear pestaña de Programas
$tabProgramas = New-Object System.Windows.Forms.TabPage
$tabProgramas.Text = "Descargas"
$tabControl.Controls.Add($tabProgramas)

$programas = @(
    @{Nombre="Google Chrome"; Url="https://dl.google.com/chrome/install/375.126/chrome_installer.exe"},
    @{Nombre="Mozilla Firefox"; Url="https://download.mozilla.org/?product=firefox-latest&os=win&lang=es-ES"},
    @{Nombre="WinRAR"; Url="https://www.rarlab.com/rar/winrar-x64-621es.exe"},
    @{Nombre="VLC Player"; Url="https://get.videolan.org/vlc/3.0.20/win64/vlc-3.0.20-win64.exe"},
    @{Nombre="Thunderbird"; Url="https://download.mozilla.org/?product=thunderbird-latest&os=win&lang=es-ES"}
)

$yList = 50
$checkBoxes = @()
foreach ($p in $programas) {
    $chk = New-Object System.Windows.Forms.CheckBox
    $chk.Text = $p.Nombre
    $chk.Tag = $p.Url
    $chk.AutoSize = $true
    $chk.Location = New-Object System.Drawing.Point(20, $yList)
    $tabProgramas.Controls.Add($chk)
    $checkBoxes += $chk
    $yList += 30
}

$progressBar = New-Object System.Windows.Forms.ProgressBar
$progressBar.Location = New-Object System.Drawing.Point(20, $yList + 10)
$progressBar.Size = New-Object System.Drawing.Size(520, 5)
$tabProgramas.Controls.Add($progressBar)

$btnDescargar = New-Object System.Windows.Forms.Button
$btnDescargar.Text = "Descargar Seleccionados"
$btnDescargar.Location = New-Object System.Drawing.Point(20, $yList + 40)
$btnDescargar.Size = New-Object System.Drawing.Size(520, 30)
$btnDescargar.Add_Click({
    $seleccionados = $checkBoxes | Where-Object { $_.Checked }
    foreach ($chk in $seleccionados) {
        $nombre = $chk.Text
        $url = $chk.Tag
        $destino = "$env:TEMP\$($nombre -replace '\\s','_').exe"
        $wc = New-Object System.Net.WebClient
        $wc.DownloadProgressChanged += {
            $progressBar.Value = $_.ProgressPercentage
        }
        $wc.DownloadFileAsync($url, $destino)
        while ($wc.IsBusy) { Start-Sleep -Milliseconds 100 }
        Start-Process $destino
    }
    [System.Windows.Forms.MessageBox]::Show("Descargas completadas.")
})


$tabProgramas.Controls.Add($btnDescargar)

# Variables para botones en panel principal
$y = 15
$spacing = 40

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

# Mostrar el formulario
$form.Topmost = $true
$form.Add_Shown({$form.Activate()})
[void] $form.ShowDialog()
