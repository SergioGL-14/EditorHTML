#region GUI - Interfaz principal
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
Add-Type -Path "C:\Users\Galvik\Documents\Proyectos\EditorHTML\System.Data.SQLite.dll"

# FORM PRINCIPAL 
$form = New-Object System.Windows.Forms.Form
$form.Text = "Gestor de Procedimientos"
$form.Size = New-Object System.Drawing.Size(925, 625)
$form.StartPosition = "CenterScreen"
$form.BackColor = "Gainsboro"
$form.Font = New-Object System.Drawing.Font("Segoe UI", 9)

# COMBO DE TABLA 
$labelTabla = New-Object System.Windows.Forms.Label
$labelTabla.Text = "Tabla de Procedimientos:"
$labelTabla.Location = New-Object System.Drawing.Point(20, 20)
$labelTabla.Size = New-Object System.Drawing.Size(150, 25)
$form.Controls.Add($labelTabla)

$comboTabla = New-Object System.Windows.Forms.ComboBox
$comboTabla.Location = New-Object System.Drawing.Point(180, 18)
$comboTabla.Size = New-Object System.Drawing.Size(200, 25)
$comboTabla.DropDownStyle = 'DropDownList'
$comboTabla.Items.AddRange(@("PROCEDIMIENTOS", "PROCEDIMIENTOS_USUARIOS", "PROCEDIMIENTOS_HOSPITALES"))
$comboTabla.SelectedIndex = 0
$form.Controls.Add($comboTabla)

# COMBO DE PROCEDIMIENTOS 
$labelProcedimiento = New-Object System.Windows.Forms.Label
$labelProcedimiento.Text = "Procedimiento:"
$labelProcedimiento.Location = New-Object System.Drawing.Point(20, 60)
$labelProcedimiento.Size = New-Object System.Drawing.Size(150, 25)
$form.Controls.Add($labelProcedimiento)

$comboProcedimientos = New-Object System.Windows.Forms.ComboBox
$comboProcedimientos.Location = New-Object System.Drawing.Point(180, 58)
$comboProcedimientos.Size = New-Object System.Drawing.Size(500, 25)
$comboProcedimientos.DropDownStyle = 'DropDown'
$comboProcedimientos.Font = New-Object System.Drawing.Font("Segoe UI", 9.5)
$comboProcedimientos.GetType().GetProperty("MaxDropDownItems").SetValue($comboProcedimientos, 12, $null)
$comboProcedimientos.DisplayMember = "TITULO"
$form.Controls.Add($comboProcedimientos)

# Lista de procedimientos (se carga y actualiza en base a la tabla seleccionada)
$global:procedimientosListaCompleta = @()
$global:IsProgrammaticUpdate = $false

# BOTONES DE CABECERA 
$btnNuevo = New-Object System.Windows.Forms.Button
$btnNuevo.Text = "➕ Nuevo"
$btnNuevo.Location = New-Object System.Drawing.Point(700, 58)
$btnNuevo.Size = New-Object System.Drawing.Size(75, 25)
$btnNuevo.BackColor = 'SteelBlue'
$btnNuevo.ForeColor = 'White'
$btnNuevo.FlatStyle = 'Flat'
$form.Controls.Add($btnNuevo)

$btnEditar = New-Object System.Windows.Forms.Button
$btnEditar.Text = "✏️ Editar"
$btnEditar.Location = New-Object System.Drawing.Point(780, 58)
$btnEditar.Size = New-Object System.Drawing.Size(75, 25)
$btnEditar.BackColor = 'DarkOrange'
$btnEditar.ForeColor = 'White'
$btnEditar.FlatStyle = 'Flat'
$form.Controls.Add($btnEditar)

# SEPARADOR VISUAL 
$separator = New-Object System.Windows.Forms.Panel
$separator.BorderStyle = 'Fixed3D'
$separator.Size = New-Object System.Drawing.Size(850, 2)
$separator.Location = New-Object System.Drawing.Point(20, 88)
$form.Controls.Add($separator)

# GRUPO INFORMACIÓN
$groupCampos = New-Object System.Windows.Forms.GroupBox
$groupCampos.Text = "Información del Procedimiento"
$groupCampos.Location = New-Object System.Drawing.Point(20, 95)
$groupCampos.Size = New-Object System.Drawing.Size(850, 300)
$form.Controls.Add($groupCampos)

# ► TÍTULO
$labelTitulo = New-Object System.Windows.Forms.Label
$labelTitulo.Text = "Título:"
$labelTitulo.Location = New-Object System.Drawing.Point(20, 30)
$labelTitulo.Size = New-Object System.Drawing.Size(100, 20)
$groupCampos.Controls.Add($labelTitulo)

$textTitulo = New-Object System.Windows.Forms.TextBox
$textTitulo.Location = New-Object System.Drawing.Point(130, 28)
$textTitulo.Size = New-Object System.Drawing.Size(680, 25)
$groupCampos.Controls.Add($textTitulo)

# ► CATEGORÍA
$labelCategoria = New-Object System.Windows.Forms.Label
$labelCategoria.Text = "Categoría:"
$labelCategoria.Location = New-Object System.Drawing.Point(20, 65)
$labelCategoria.Size = New-Object System.Drawing.Size(100, 20)
$groupCampos.Controls.Add($labelCategoria)

$comboCategoria = New-Object System.Windows.Forms.ComboBox
$comboCategoria.Location = New-Object System.Drawing.Point(130, 63)
$comboCategoria.Size = New-Object System.Drawing.Size(250, 25)
$comboCategoria.DropDownStyle = 'DropDownList'
$groupCampos.Controls.Add($comboCategoria)

# ► VERSIÓN
$labelVersion = New-Object System.Windows.Forms.Label
$labelVersion.Text = "Versión:"
$labelVersion.Location = New-Object System.Drawing.Point(400, 65)
$labelVersion.Size = New-Object System.Drawing.Size(60, 20)
$groupCampos.Controls.Add($labelVersion)

$textVersion = New-Object System.Windows.Forms.TextBox
$textVersion.Location = New-Object System.Drawing.Point(460, 63)
$textVersion.Size = New-Object System.Drawing.Size(100, 25)
$groupCampos.Controls.Add($textVersion)

# ► ESTADO
$labelEstadoProc = New-Object System.Windows.Forms.Label
$labelEstadoProc.Text = "Estado:"
$labelEstadoProc.Location = New-Object System.Drawing.Point(580, 65)
$labelEstadoProc.Size = New-Object System.Drawing.Size(60, 20)
$groupCampos.Controls.Add($labelEstadoProc)

$comboEstado = New-Object System.Windows.Forms.ComboBox
$comboEstado.Location = New-Object System.Drawing.Point(640, 63)
$comboEstado.Size = New-Object System.Drawing.Size(170, 25)
$comboEstado.DropDownStyle = 'DropDownList'
$comboEstado.Items.AddRange(@("Activo", "Inactivo"))
$groupCampos.Controls.Add($comboEstado)

# ► ÁREA SANITARIA
$labelArea = New-Object System.Windows.Forms.Label
$labelArea.Text = "Área Sanitaria:"
$labelArea.Location = New-Object System.Drawing.Point(20, 100)
$labelArea.Size = New-Object System.Drawing.Size(100, 20)
$groupCampos.Controls.Add($labelArea)

$comboArea = New-Object System.Windows.Forms.ComboBox
$comboArea.Location = New-Object System.Drawing.Point(130, 98)
$comboArea.Size = New-Object System.Drawing.Size(300, 25)
$comboArea.DropDownStyle = 'DropDownList'
$groupCampos.Controls.Add($comboArea)

# ► DESCRIPCIÓN HTML
$labelHTML = New-Object System.Windows.Forms.Label
$labelHTML.Text = "Descripción (HTML):"
$labelHTML.Location = New-Object System.Drawing.Point(20, 135)
$labelHTML.Size = New-Object System.Drawing.Size(150, 20)
$groupCampos.Controls.Add($labelHTML)

$textHTML = New-Object System.Windows.Forms.RichTextBox
$textHTML.Location = New-Object System.Drawing.Point(20, 160)
$textHTML.Size = New-Object System.Drawing.Size(800, 100)
$groupCampos.Controls.Add($textHTML)

# ► BOTÓN EDITOR HTML
$btnEditorHTML = New-Object System.Windows.Forms.Button
$btnEditorHTML.Text = "Editor HTML"
$btnEditorHTML.Location = New-Object System.Drawing.Point(700, 265)
$btnEditorHTML.Size = New-Object System.Drawing.Size(120, 25)
$btnEditorHTML.BackColor = 'SlateGray'
$btnEditorHTML.ForeColor = 'White'
$btnEditorHTML.FlatStyle = 'Flat'
$groupCampos.Controls.Add($btnEditorHTML)

# GRUPO CORREO 
$groupCorreo = New-Object System.Windows.Forms.GroupBox
$groupCorreo.Text = "Notificación por Correo"
$groupCorreo.Location = New-Object System.Drawing.Point(20, 400)
$groupCorreo.Size = New-Object System.Drawing.Size(850, 140)
$form.Controls.Add($groupCorreo)

# ► CheckBox envío
$checkCorreo = New-Object System.Windows.Forms.CheckBox
$checkCorreo.Text = "Enviar correo"
$checkCorreo.Location = New-Object System.Drawing.Point(20, 25)
$checkCorreo.Size = New-Object System.Drawing.Size(150, 25)
$groupCorreo.Controls.Add($checkCorreo)

# ► Destinatario
$labelDestinatario = New-Object System.Windows.Forms.Label
$labelDestinatario.Text = "Destinatario:"
$labelDestinatario.Location = New-Object System.Drawing.Point(20, 55)
$labelDestinatario.Size = New-Object System.Drawing.Size(100, 20)
$groupCorreo.Controls.Add($labelDestinatario)

$textDestinatario = New-Object System.Windows.Forms.TextBox
$textDestinatario.Location = New-Object System.Drawing.Point(130, 53)
$textDestinatario.Size = New-Object System.Drawing.Size(680, 25)
$groupCorreo.Controls.Add($textDestinatario)

# ► Asunto
$labelAsunto = New-Object System.Windows.Forms.Label
$labelAsunto.Text = "Asunto:"
$labelAsunto.Location = New-Object System.Drawing.Point(20, 85)
$labelAsunto.Size = New-Object System.Drawing.Size(100, 20)
$groupCorreo.Controls.Add($labelAsunto)

$textAsunto = New-Object System.Windows.Forms.TextBox
$textAsunto.Location = New-Object System.Drawing.Point(130, 83)
$textAsunto.Size = New-Object System.Drawing.Size(680, 25)
$groupCorreo.Controls.Add($textAsunto)

# ► Cuerpo (opcional; oculto inicialmente)
$labelCuerpo = New-Object System.Windows.Forms.Label
$labelCuerpo.Text = "Cuerpo del correo:"
$labelCuerpo.Location = New-Object System.Drawing.Point(20, 115)
$labelCuerpo.Size = New-Object System.Drawing.Size(150, 20)
$labelCuerpo.Visible = $false
$groupCorreo.Controls.Add($labelCuerpo)

$textCuerpo = New-Object System.Windows.Forms.RichTextBox
$textCuerpo.Location = New-Object System.Drawing.Point(20, 140)
$textCuerpo.Size = New-Object System.Drawing.Size(0, 0) 
$textCuerpo.Visible = $false
$groupCorreo.Controls.Add($textCuerpo)

# ► CC
$labelCC = New-Object System.Windows.Forms.Label
$labelCC.Text = "CC (con copia):"
$labelCC.Location = New-Object System.Drawing.Point(20, 115)
$labelCC.Size = New-Object System.Drawing.Size(100, 20)
$groupCorreo.Controls.Add($labelCC)

$textCC = New-Object System.Windows.Forms.TextBox
$textCC.Location = New-Object System.Drawing.Point(130, 113)
$textCC.Size = New-Object System.Drawing.Size(680, 25)
$groupCorreo.Controls.Add($textCC)

# ► BOTÓN GUARDAR
$btnGuardar = New-Object System.Windows.Forms.Button
$btnGuardar.Text = "💾 Guardar Cambios"
$btnGuardar.Location = New-Object System.Drawing.Point(700, 545)
$btnGuardar.Size = New-Object System.Drawing.Size(160, 35)
$btnGuardar.BackColor = 'SeaGreen'
$btnGuardar.ForeColor = 'White'
$btnGuardar.FlatStyle = 'Flat'
$btnGuardar.Font = New-Object System.Drawing.Font("Segoe UI", 9, [System.Drawing.FontStyle]::Bold)
$form.Controls.Add($btnGuardar)

# ► ETIQUETA DE ESTADO
$labelEstado = New-Object System.Windows.Forms.Label
$labelEstado.Text = "Listo"
$labelEstado.Location = New-Object System.Drawing.Point(20, 550)
$labelEstado.Size = New-Object System.Drawing.Size(600, 20)
$form.Controls.Add($labelEstado)
#endregion

#region DB - Conexión SQLite
$databasePath = "C:\Users\Galvik\Documents\Proyectos\EditorHTML\XestAd.sqlite"
$connectionString = "Data Source=$databasePath;Version=3;BusyTimeout=5000;"
$connection = New-Object System.Data.SQLite.SQLiteConnection($connectionString)
$connection.Open()

# Configurar busy_timeout vía PRAGMA
$cmdTimeout = $connection.CreateCommand()
$cmdTimeout.CommandText = "PRAGMA busy_timeout = 5000;"
$cmdTimeout.ExecuteNonQuery()
$cmdTimeout.Dispose()
#endregion

#region FUNCIONES - Carga de procedimientos
function Get-ProcedimientosFromTabla($tabla) {
    $query = "SELECT ID_PROCEDIMIENTO, TITULO FROM $tabla ORDER BY ID_PROCEDIMIENTO ASC;"
    try {
        $cmd = $connection.CreateCommand()
        $cmd.CommandText = $query
        $reader = $cmd.ExecuteReader()
        $result = @()
        while ($reader.Read()) {
            $item = New-Object PSObject -Property @{
                ID     = $reader["ID_PROCEDIMIENTO"]
                Titulo = $reader["TITULO"]
            }
            $result += $item
        }
        $reader.Close()
        $cmd.Dispose()
        return $result
    } catch {
        [System.Windows.Forms.MessageBox]::Show("Error al cargar procedimientos de la tabla $tabla.`n$_")
        return @()
    }
}

function Load-Procedimientos {
    $tablaSeleccionada = $comboTabla.SelectedItem
    $comboProcedimientos.Items.Clear()
    $procedimientos = Get-ProcedimientosFromTabla -tabla $tablaSeleccionada
    $global:procedimientosListaCompleta = $procedimientos
    foreach ($p in $procedimientos) {
        $comboProcedimientos.Items.Add("$($p.ID) - $($p.Titulo)")
    }
    # No autoselecciona ningún procedimiento
    $comboProcedimientos.SelectedIndex = -1
    $labelEstado.Text = "Procedimientos cargados desde $tablaSeleccionada."
}
#endregion

#region FUNCIONES - Actualización de controles de correo
function Update-EmailFields {
    if ($comboTabla.SelectedItem -eq "PROCEDIMIENTOS_HOSPITALES") {
        # Deshabilitamos envío de correo
        $checkCorreo.Enabled = $false
        $textDestinatario.ReadOnly = $true
        $textAsunto.ReadOnly = $true
        $textCuerpo.ReadOnly = $true
        $textCC.ReadOnly = $true
    } else {
        $checkCorreo.Enabled = $true
        $textDestinatario.ReadOnly = $false
        $textAsunto.ReadOnly = $false
        $textCuerpo.ReadOnly = $false
        $textCC.ReadOnly = $false
    }
}
#endregion

#region FUNCIONES - Editor HTML externo (usando EditorHTML.exe portable)
function Launch-HTMLEditor {
    # Crear un archivo temporal para intercambiar el contenido HTML
    $tempFile = [System.IO.Path]::GetTempFileName() + ".html"
    
    # Escribe en el archivo temporal lo que ya existe en Descripción HTML
    $textHTML.Text | Out-File -FilePath $tempFile -Encoding UTF8

    # Definir la ruta absoluta del ejecutable portable EditorHTML.exe
    $editorExePath = "C:\Users\Galvik\Documents\Proyectos\EditorHTML\dist\EditorHTML.exe"
    if (-not (Test-Path $editorExePath)) {
        [System.Windows.Forms.MessageBox]::Show("No se encontró EditorHTML.exe en la ruta: $editorExePath", "Error", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
        return
    }

    # Configurar y lanzar el proceso para abrir el editor HTML portable
    $psi = New-Object System.Diagnostics.ProcessStartInfo
    $psi.FileName = $editorExePath
    $psi.Arguments = "-FilePath `"$tempFile`""
    $psi.UseShellExecute = $false
    $psi.CreateNoWindow = $false
    try {
        $proc = [System.Diagnostics.Process]::Start($psi)
        $proc.WaitForExit()
    } catch {
        [System.Windows.Forms.MessageBox]::Show("Error al iniciar el Editor HTML: $_", "Error", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
        return
    }

    Start-Sleep -Seconds 1

    if (Test-Path $tempFile) {
         $newContent = Get-Content -Path $tempFile -Raw -Encoding UTF8
         $textHTML.Text = $newContent
         Remove-Item $tempFile
         $labelEstado.Text = "Contenido HTML actualizado."
    } else {
         $labelEstado.Text = "No se actualizó el contenido HTML."
    }
}
#endregion

#region EVENTOS
# Al cambiar la tabla, actualiza campos de correo y recarga procedimientos
$comboTabla.add_SelectedIndexChanged({
    Update-EmailFields
    Load-Procedimientos
})

$comboProcedimientos.Add_SelectedIndexChanged({ Get-ProcedimientoDetails })

$btnEditar.Add_Click({ 
    UnlockFields; 
    $labelEstado.Text = "Modo edición activado." 
})

$btnNuevo.Add_Click({ 
    Clear-FormFields; 
    UnlockFields; 
    $comboProcedimientos.SelectedItem = $null; 
    $labelEstado.Text = "Modo nuevo procedimiento." 
})

$btnGuardar.Add_Click({ Save-Procedimiento })

# Manejador KeyDown para el ComboBox de procedimientos
$comboProcedimientos.Add_KeyDown({
    if ($_.KeyCode -ne [System.Windows.Forms.Keys]::Down -and -not $comboProcedimientos.DroppedDown) {
        $comboProcedimientos.DroppedDown = $true
    }
    if (
        $comboProcedimientos.SelectedItem -ne $null -and
        $comboProcedimientos.SelectionLength -eq $comboProcedimientos.Text.Length -and
        ($_.KeyCode -ge [System.Windows.Forms.Keys]::A -and $_.KeyCode -le [System.Windows.Forms.Keys]::Z)
    ) {
        $comboProcedimientos.SelectedIndex = -1
        $comboProcedimientos.Text = ""
        $comboProcedimientos.SelectionStart = 0
        $comboProcedimientos.SelectionLength = 0
    }
    if ($_.KeyCode -eq [System.Windows.Forms.Keys]::Back -or $_.KeyCode -eq [System.Windows.Forms.Keys]::Delete) {
        $comboProcedimientos.SelectedIndex = -1
        $comboProcedimientos.SelectionStart = $comboProcedimientos.Text.Length
        $comboProcedimientos.SelectionLength = 0
    }
})

# Manejador TextChanged unificado para filtrar el ComboBox de procedimientos
$comboProcedimientos.Add_TextChanged({
    if ($global:IsProgrammaticUpdate) { return }

    $filterText = $comboProcedimientos.Text.ToLower().Trim()
    $comboProcedimientos.Items.Clear()
    if (-not $global:procedimientosListaCompleta) { return }
    if ($filterText -eq "") {
        foreach ($p in $global:procedimientosListaCompleta) {
            $comboProcedimientos.Items.Add("$($p.ID) - $($p.Titulo)")
        }
    } else {
        foreach ($p in $global:procedimientosListaCompleta) {
            $entry = "$($p.ID) - $($p.Titulo)"
            if ($entry.ToLower().Contains($filterText)) {
                $comboProcedimientos.Items.Add($entry)
            }
        }
        if ($comboProcedimientos.Items.Count -gt 0) {
            $comboProcedimientos.DroppedDown = $true
        }
    }
    $comboProcedimientos.SelectionStart = $comboProcedimientos.Text.Length
    $comboProcedimientos.SelectionLength = 0
})

# Evento para lanzar el editor HTML
$btnEditorHTML.Add_Click({ Launch-HTMLEditor })
#endregion

#region FUNCIONES - Carga y edición
function Get-ProcedimientoDetails {
    $tabla = $comboTabla.SelectedItem
    if (-not $comboProcedimientos.SelectedItem) { return }
    $selectedID = $comboProcedimientos.SelectedItem.ToString().Split('-')[0].Trim()
    $query = "SELECT * FROM $tabla WHERE ID_PROCEDIMIENTO = $selectedID;"
    
    $cmd = $connection.CreateCommand()
    $cmd.CommandText = $query
    $reader = $cmd.ExecuteReader()

    if ($reader.Read()) {
        $textTitulo.Text = $reader["TITULO"]
        $textHTML.Text = $reader["DESCRIPCION_HTML"]
        $textVersion.Text = $reader["VERSION"]
        $comboEstado.SelectedItem = $reader["ESTADO"]

        if ($comboCategoria.Items.Count -gt 0) {
            $idCategoria = $reader["ID_CATEGORIA"]
            $nombreCategoria = $categoriasIndexadas.Keys | Where-Object { $categoriasIndexadas[$_] -eq $idCategoria }
            $comboCategoria.SelectedItem = $nombreCategoria
        }

        $checkCorreo.Checked = [bool]$reader["ENVIA_CORREO"]
        $textDestinatario.Text = $reader["DESTINATARIO_EMAIL"]
        $textAsunto.Text = $reader["ASUNTO_EMAIL"]
        $textCuerpo.Text = $reader["CUERPO_EMAIL"]
        $textCC.Text = $reader["CORREO_CC"]

        if ($tabla -eq "PROCEDIMIENTOS_HOSPITALES" -and $reader["ID_AREA"]) {
            $idAreaValue = $reader["ID_AREA"]
            $areaNombre = ($areasIndexadas.GetEnumerator() | Where-Object { $_.Value -eq $idAreaValue } | Select-Object -ExpandProperty Name)
            if ($areaNombre) {
                $comboArea.SelectedItem = $areaNombre
            }
        }
    }

    $reader.Close()
    $cmd.Dispose()

    if ($tabla -eq "PROCEDIMIENTOS") {
        $cmdArea = $connection.CreateCommand()
        $cmdArea.CommandText = "SELECT ID_AREA FROM PROCEDIMIENTOS_AREAS WHERE ID_PROCEDIMIENTO = $selectedID;"
        $areaID = $cmdArea.ExecuteScalar()
        $cmdArea.Dispose()
        if ($areaID) {
            $areaNombre = ($areasIndexadas.GetEnumerator() | Where-Object { $_.Value -eq $areaID } | Select-Object -ExpandProperty Name)
            if ($areaNombre) {
                $comboArea.SelectedItem = $areaNombre
            }
        }
    }
    $labelEstado.Text = "Procedimiento cargado."
    LockFields
}

function Clear-FormFields {
    $textTitulo.Text = ""
    $textHTML.Text = ""
    $textVersion.Text = ""
    $comboEstado.SelectedIndex = 0
    if ($comboCategoria.Items.Count -gt 0) { $comboCategoria.SelectedIndex = 0 }
    $checkCorreo.Checked = $false
    $textDestinatario.Text = ""
    $textAsunto.Text = ""
    $textCuerpo.Text = ""
    $textCC.Text = ""
}

function UnlockFields {
    $textTitulo.ReadOnly = $false
    $textHTML.ReadOnly = $false
    $textVersion.ReadOnly = $false
    $comboEstado.Enabled = $true
    $comboCategoria.Enabled = $true
    $checkCorreo.Enabled = $true
    $textDestinatario.ReadOnly = $false
    $textAsunto.ReadOnly = $false
    $textCuerpo.ReadOnly = $false
    $textCC.ReadOnly = $false
    if ($comboTabla.SelectedItem -eq "PROCEDIMIENTOS_HOSPITALES") {
        $checkCorreo.Enabled = $false
        $textDestinatario.ReadOnly = $true
        $textAsunto.ReadOnly = $true
        $textCuerpo.ReadOnly = $true
        $textCC.ReadOnly = $true
    }
}

function LockFields {
    $textTitulo.ReadOnly = $true
    $textHTML.ReadOnly = $true
    $textVersion.ReadOnly = $true
    $comboEstado.Enabled = $false
    $comboCategoria.Enabled = $false
    $checkCorreo.Enabled = $false
    $textDestinatario.ReadOnly = $true
    $textAsunto.ReadOnly = $true
    $textCuerpo.ReadOnly = $true
    $textCC.ReadOnly = $true
}

function Save-Procedimiento {
    $tabla = $comboTabla.SelectedItem

    if ($textTitulo.Text.Trim() -eq "") {
        [System.Windows.Forms.MessageBox]::Show("El título no puede estar vacío.")
        return
    }

    $titulo = $textTitulo.Text.Replace("'", "''")
    $descripcion = $textHTML.Text.Replace("'", "''")
    $version = $textVersion.Text.Replace("'", "''")
    $categoriaNombre = $comboCategoria.SelectedItem
    $estado = $comboEstado.SelectedItem
    $categoria = $null

    $enviaCorreo = [int]$checkCorreo.Checked
    $dest = $textDestinatario.Text.Replace("'", "''")
    $asunto = $textAsunto.Text.Replace("'", "''")
    $cuerpo = $textCuerpo.Text.Replace("'", "''")
    $correoCC = $textCC.Text.Replace("'", "''")
    $fechaActual = (Get-Date).ToString("yyyy-MM-dd")

    if ($tabla -ne "PROCEDIMIENTOS_HOSPITALES") {
        $categoria = $categoriasIndexadas[$categoriaNombre]
    }

    $idArea = $null
    if ($tabla -eq "PROCEDIMIENTOS" -or $tabla -eq "PROCEDIMIENTOS_HOSPITALES") {
        $areaNombre = $comboArea.SelectedItem
        if (-not $areaNombre) {
            [System.Windows.Forms.MessageBox]::Show("Debes seleccionar un Área Sanitaria.")
            return
        }
        $idArea = $areasIndexadas[$areaNombre]
    }

    $selected = $comboProcedimientos.SelectedItem
    $isUpdate = $false
    $id = $null
    if ($selected -and ($selected -match "^\d+")) {
        $id = $selected.Split('-')[0].Trim()
        $isUpdate = $true
    }

    $transaction = $connection.BeginTransaction()
    try {
        if ($isUpdate) {
            $query = "UPDATE $tabla SET "
            $fields = @()

            $fields += "TITULO = '$titulo'"
            $fields += "DESCRIPCION_HTML = '$descripcion'"
            $fields += "VERSION = '$version'"

            switch ($tabla) {
                "PROCEDIMIENTOS" {
                    $fields += "ESTADO = '$estado'"
                    $fields += "ID_CATEGORIA = $categoria"
                    $fields += "ENVIA_CORREO = $enviaCorreo"
                    $fields += "DESTINATARIO_EMAIL = '$dest'"
                    $fields += "ASUNTO_EMAIL = '$asunto'"
                    $fields += "CUERPO_EMAIL = '$cuerpo'"
                    $fields += "CORREO_CC = '$correoCC'"
                    $fields += "FECHA_ACTUALIZACION = '$fechaActual'"
                }
                "PROCEDIMIENTOS_USUARIOS" {
                    $fields += "ID_CATEGORIA = $categoria"
                    $fields += "ENVIA_CORREO = $enviaCorreo"
                    $fields += "DESTINATARIO_EMAIL = '$dest'"
                    $fields += "ASUNTO_EMAIL = '$asunto'"
                    $fields += "CUERPO_EMAIL = '$cuerpo'"
                    $fields += "CORREO_CC = '$correoCC'"
                }
                "PROCEDIMIENTOS_HOSPITALES" {
                    $fields += "CATEGORIA = '$categoriaNombre'"
                    $fields += "ACTIVO = " + ($(if ($estado -eq "Activo") {1} else {0}))
                    $fields += "ID_AREA = $idArea"
                }
            }

            $query += ($fields -join ", ") + " WHERE ID_PROCEDIMIENTO = $id;"
            $cmd = $connection.CreateCommand()
            $cmd.Transaction = $transaction
            $cmd.CommandText = $query
            $cmd.ExecuteNonQuery()
            $cmd.Dispose()
            if ($tabla -eq "PROCEDIMIENTOS") {
                $cmdUpdateArea = $connection.CreateCommand()
                $cmdUpdateArea.Transaction = $transaction
                $cmdUpdateArea.CommandText = "UPDATE PROCEDIMIENTOS_AREAS SET ID_AREA = $idArea WHERE ID_PROCEDIMIENTO = $id;"
                $cmdUpdateArea.ExecuteNonQuery()
                $cmdUpdateArea.Dispose()
            } 
        } else {
            $columnas = @("TITULO", "DESCRIPCION_HTML", "VERSION")
            $valores  = @("'$titulo'", "'$descripcion'", "'$version'")

            switch ($tabla) {
                "PROCEDIMIENTOS" {
                    $columnas += @("ESTADO", "ID_CATEGORIA", "ENVIA_CORREO", "DESTINATARIO_EMAIL", "ASUNTO_EMAIL", "CUERPO_EMAIL", "CORREO_CC", "FECHA_CREACION")
                    $valores  += @("'$estado'", $categoria, $enviaCorreo, "'$dest'", "'$asunto'", "'$cuerpo'", "'$correoCC'", "'$fechaActual'")
                }
                "PROCEDIMIENTOS_USUARIOS" {
                    $columnas += @("ID_CATEGORIA", "ENVIA_CORREO", "DESTINATARIO_EMAIL", "ASUNTO_EMAIL", "CUERPO_EMAIL", "CORREO_CC")
                    $valores  += @($categoria, $enviaCorreo, "'$dest'", "'$asunto'", "'$cuerpo'", "'$correoCC'")
                }
                "PROCEDIMIENTOS_HOSPITALES" {
                    $columnas += @("CATEGORIA", "ACTIVO", "ID_AREA")
                    $valores  += @("'$categoriaNombre'", ($(if ($estado -eq "Activo") {"1"} else {"0"})), "$idArea")
                }
            }

            $queryInsert = "INSERT INTO $tabla (" + ($columnas -join ", ") + ") VALUES (" + ($valores -join ", ") + ");"

            $cmd = $connection.CreateCommand()
            $cmd.Transaction = $transaction
            $cmd.CommandText = $queryInsert
            $cmd.ExecuteNonQuery()

            if ($tabla -eq "PROCEDIMIENTOS") {
                $cmdLastID = $connection.CreateCommand()
                $cmdLastID.Transaction = $transaction
                $cmdLastID.CommandText = "SELECT last_insert_rowid();"
                $newID = $cmdLastID.ExecuteScalar()
                $cmdLastID.Dispose()

                $cmdLink = $connection.CreateCommand()
                $cmdLink.Transaction = $transaction
                $cmdLink.CommandText = "INSERT INTO PROCEDIMIENTOS_AREAS (ID_PROCEDIMIENTO, ID_AREA) VALUES ($newID, $idArea);"
                $cmdLink.ExecuteNonQuery()
                $cmdLink.Dispose()
            }
        }
        $transaction.Commit()
        $labelEstado.Text = "Procedimiento guardado correctamente."
        $global:IsProgrammaticUpdate = $true
        $comboProcedimientos.SelectedIndex = -1
        # Recargar lista de procedimientos
        Load-Procedimientos

        # Si es actualización, re-selecciona el procedimiento editado
        if ($isUpdate -and $id) {
            for ($i = 0; $i -lt $comboProcedimientos.Items.Count; $i++) {
                if ($comboProcedimientos.Items[$i] -like "$id*") {
                    $comboProcedimientos.SelectedIndex = $i
                    break
                }
            }
        } else {
            $comboProcedimientos.SelectedIndex = -1
        }
    } catch {
        $transaction.Rollback()
        [System.Windows.Forms.MessageBox]::Show("Error en la operación: $_")
    }
    Load-Procedimientos
    $global:IsProgrammaticUpdate = $false
}
#endregion

#region FUNCIONES - Carga de Categorías y Áreas
function Load-Categorias {
    $comboCategoria.Items.Clear()
    $global:categoriasIndexadas = @{}

    try {
        $cmd = $connection.CreateCommand()
        $cmd.CommandText = "SELECT ID_CATEGORIA, NOMBRE FROM CATEGORIAS ORDER BY NOMBRE COLLATE NOCASE;"
        $reader = $cmd.ExecuteReader()

        while ($reader.Read()) {
            $nombre = $reader["NOMBRE"]
            $id = $reader["ID_CATEGORIA"]
            $comboCategoria.Items.Add($nombre)
            $categoriasIndexadas[$nombre] = $id
        }

        $reader.Close()
        $cmd.Dispose()
        if ($comboCategoria.Items.Count -gt 0) {
            $comboCategoria.SelectedIndex = 0
        }

        $labelEstado.Text = "Categorías cargadas correctamente."
    } catch {
        [System.Windows.Forms.MessageBox]::Show("Error al cargar categorías: $_")
    }
}

function Load-AreasSanitarias {
    $comboArea.Items.Clear()
    $global:areasIndexadas = @{}

    try {
        $cmd = $connection.CreateCommand()
        $cmd.CommandText = "SELECT ID_AREA, NOMBRE FROM AREAS_SANITARIAS ORDER BY NOMBRE COLLATE NOCASE;"
        $reader = $cmd.ExecuteReader()

        while ($reader.Read()) {
            $nombre = $reader["NOMBRE"]
            $id = $reader["ID_AREA"]
            $comboArea.Items.Add($nombre)
            $areasIndexadas[$nombre] = $id
        }

        $reader.Close()
        $cmd.Dispose()
        if ($comboArea.Items.Count -gt 0) {
            $comboArea.SelectedIndex = 0
        }

        $labelEstado.Text = "Áreas sanitarias cargadas correctamente."
    } catch {
        [System.Windows.Forms.MessageBox]::Show("Error al cargar áreas sanitarias: $_")
    }
}

Load-Categorias
Load-AreasSanitarias
Load-Procedimientos
$form.ShowDialog()
#endregion
