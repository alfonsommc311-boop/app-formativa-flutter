# clone_app.ps1 — Clona el shell de una app formativa y aplica la identidad nueva.
# Uso:
#   pwsh -File clone_app.ps1 -Src "D:\especialista en agentes ia" -Dst "D:\especialista en topografia" `
#        -OldSlug agentesiaexperto -NewSlug topografiaexperto -Name "Topografia Experto" `
#        -SnakeName topografia_experto -Port 8986 -Prefix topo
# Tras ejecutarlo quedan MANUALES (contenido creativo): pubspec description, index.html
# (title/h1/lead/buscador/foot) y el catálogo + lecciones.
param(
  [Parameter(Mandatory=$true)][string]$Src,
  [Parameter(Mandatory=$true)][string]$Dst,
  [Parameter(Mandatory=$true)][string]$OldSlug,
  [Parameter(Mandatory=$true)][string]$NewSlug,
  [Parameter(Mandatory=$true)][string]$Name,
  [Parameter(Mandatory=$true)][string]$SnakeName,
  [Parameter(Mandatory=$true)][int]$Port,
  [Parameter(Mandatory=$true)][string]$Prefix
)
$ErrorActionPreference = 'Stop'

if (-not (Test-Path $Src)) { throw "No existe Src: $Src" }
if (Test-Path $Dst) { Write-Host "AVISO: $Dst ya existe; se sobreescribiran archivos." }

# 1) Clonar excluyendo build y contenido
robocopy $Src $Dst /E /XD build .dart_tool .gradle ".idea" "lessons" /XF "build_apk_log.txt" "pubspec.lock" "*.iml" | Out-Null
New-Item -ItemType Directory -Force "$Dst\assets\web\lessons" | Out-Null

# 2) Renombrar paquete Kotlin
$kotlinBase = "$Dst\android\app\src\main\kotlin\com\alfonso"
$oldPkg = Join-Path $kotlinBase $OldSlug
$newPkg = Join-Path $kotlinBase $NewSlug
if (Test-Path $oldPkg) {
  if (Test-Path $newPkg) { Remove-Item $newPkg -Recurse -Force }
  Rename-Item $oldPkg $NewSlug
}
if (-not (Test-Path $newPkg)) { throw "No se encontro el paquete Kotlin ($oldPkg)" }

function Edit-File([string]$Path, [scriptblock]$Transform) {
  $t = Get-Content $Path -Raw
  $t2 = & $Transform $t
  if ($t2 -ne $t) { Set-Content -Path $Path -Value $t2 -NoNewline -Encoding UTF8 }
}

# 3) MainActivity.kt — package
Edit-File "$newPkg\MainActivity.kt" { param($t) $t -replace "com\.alfonso\.$OldSlug", "com.alfonso.$NewSlug" }

# 4) build.gradle.kts — namespace + applicationId
Edit-File "$Dst\android\app\build.gradle.kts" { param($t) $t -replace "com\.alfonso\.$OldSlug", "com.alfonso.$NewSlug" }

# 5) AndroidManifest — label
Edit-File "$Dst\android\app\src\main\AndroidManifest.xml" { param($t) $t -replace 'android:label="[^"]+"', ('android:label="' + $Name + '"') }

# 6) pubspec.yaml — name (la description se edita despues, es creativa)
Edit-File "$Dst\pubspec.yaml" { param($t) $t -replace "(?m)^name:\s*\S+", "name: $SnakeName" }

# 7) main.dart — puerto, title y clase XxxApp
$mainPath = "$Dst\lib\main.dart"
$main = Get-Content $mainPath -Raw
$main = $main -replace "kServerPort\s*=\s*\d+", "kServerPort = $Port"
$main = $main -replace "title:\s*'[^']*'", ("title: '" + $Name + "'")
$m = [regex]::Match($main, "class\s+(\w+App)\s+extends")
if ($m.Success) {
  $newClass = ((($Name -replace "[^A-Za-z0-9]", "")) + "App")
  $main = $main -replace $m.Groups[1].Value, $newClass
}
Set-Content -Path $mainPath -Value $main -NoNewline -Encoding UTF8

# 8) engine.js — prefijo de localStorage y cabecera
Edit-File "$Dst\assets\web\assets\engine.js" {
  param($t)
  $t = $t -replace "localStorage\.getItem\('[^':]+:'", ("localStorage.getItem('" + $Prefix + ":'")
  $t = $t -replace "localStorage\.setItem\('[^':]+:'", ("localStorage.setItem('" + $Prefix + ":'")
  $t
}

# 9) Verificaciones
$manifest = Get-Content "$Dst\android\app\src\main\AndroidManifest.xml" -Raw
if ($manifest -notmatch "EnableImpeller") { Write-Warning "FALTA el meta-data EnableImpeller=false (pantalla negra en Honor). Agregarlo." }
$checks = @(
  @{ f="$newPkg\MainActivity.kt";                        must="com.alfonso.$NewSlug" },
  @{ f="$Dst\android\app\build.gradle.kts";              must="com.alfonso.$NewSlug" },
  @{ f="$Dst\android\app\src\main\AndroidManifest.xml";  must=$Name },
  @{ f="$Dst\lib\main.dart";                             must="kServerPort = $Port" }
)
$fail = 0
foreach ($c in $checks) {
  if ((Get-Content $c.f -Raw) -notmatch [regex]::Escape($c.must)) { Write-Warning ("CHECK FALLO: " + $c.f + " no contiene '" + $c.must + "'"); $fail++ }
}
if ($fail -eq 0) {
  Write-Host "OK: clon e identidad aplicados en $Dst (puerto $Port)."
  Write-Host "Pendiente manual: pubspec description, index.html (title/h1/lead/buscador/foot), catalog.js y lessons/."
} else { throw "$fail checks fallaron" }
