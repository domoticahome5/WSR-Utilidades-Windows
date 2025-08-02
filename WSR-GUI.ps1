
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName PresentationFramework

# Crear ventana
$form = New-Object System.Windows.Forms.Form
$form.Text = "WSR - Mantenimiento Windows 10/11"
$form.Width = 600
$form.Height = 500
$form.BackColor = "#1e1e1e"
$form.ForeColor = "#00ff00"
$form.StartPosition = "CenterScreen"

# Crear título
$title = New-Object System.Windows.Forms.Label
$title.Text = "WSR - Mantenimiento de Windows 10/11"
$title.ForeColor = "White"
$title.Font = "Segoe UI,14,style=Bold"
$title.AutoSize = $true
$title.Location = New-Object System.Drawing.Point(100,20)
$form.Controls.Add($title)

# Crear función utilitaria
function Ejecutar-Comando($cmd) {
    Start-Process powershell -Verb runAs -ArgumentList "-NoExit", "-Command", $cmd
}

# Botones
$botones = @(
    @{Texto="Limpiar Archivos Temporales"; Comando='del /s /f /q $env:TEMP\*.*; del /s /f /q C:\Windows\Temp\*.*'},
    @{Texto="Liberador de Espacio en Disco"; Comando='cleanmgr'},
    @{Texto="Optimizar disco C:"; Comando='defrag C: /O'},
    @{Texto="Reparar Archivos (SFC/DISM)"; Comando='sfc /scannow; DISM /Online /Cleanup-Image /RestoreHealth'},
    @{Texto="Flush DNS y Reinicio Red"; Comando='ipconfig /flushdns; netsh winsock reset; netsh int ip reset'},
    @{Texto="Actualizar con Winget"; Comando='winget upgrade --all --include-unknown'},
    @{Texto="Crear Punto de Restauración"; Comando='rstrui'}
)

$y = 70
foreach ($b in $botones) {
    $btn = New-Object System.Windows.Forms.Button
    $btn.Text = $b.Texto
    $btn.Width = 400
    $btn.Height = 35
    $btn.Font = "Segoe UI,10"
    $btn.Location = New-Object System.Drawing.Point(90, $y)
    $btn.BackColor = "#2d2d30"
    $btn.ForeColor = "White"
    $btn.Add_Click({ Ejecutar-Comando $b.Comando })
    $form.Controls.Add($btn)
    $y += 45
}

# Mostrar ventana
$form.Topmost = $true
[void]$form.ShowDialog()
