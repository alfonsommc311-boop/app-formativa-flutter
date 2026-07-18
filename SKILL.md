---
name: app-formativa-flutter
description: Crea una nueva app formativa Android (Flutter WebView + TTS) de la familia "Experto/PRO" del usuario — apps que enseñan un tema con lecciones (teoría, audio, fichas, autoevaluación), funcionan sin internet y se compilan a APK. Úsalo cuando el usuario pida "crear/hacer una app/aplicativo formativo o educativo", "un especialista en X", "una app para aprender/dominar X", "otra app como Calidad PRO / MTC Experto / igual a las anteriores", o pida clonar/derivar una de esas apps con un tema nuevo. Cubre el ciclo completo: clonar el shell con script, dar identidad (puerto único + fix de Impeller ya incluidos), diseñar el catálogo, generar decenas de lecciones con subagentes en paralelo, verificar, compilar el APK, generar un ícono propio e instalar en el celular por adb.
---

# App formativa Flutter (familia "Experto/PRO")

Metodología probada (8+ apps creadas) para apps Android educativas del usuario (alfonsommc311).
Cada app enseña un tema con ~70 lecciones en ~12 áreas. Todas comparten un **shell Flutter**
(InAppWebView + flutter_tts) que sirve una web app local sin internet; solo cambian el
CONTENIDO (catálogo + lecciones), la IDENTIDAD y el ÍCONO.

**Antes de empezar:** lee `reference/checklist.md` (resumen de todos los pasos) y
`reference/ports.md` (elige el siguiente puerto libre). Duración típica del proceso completo:
30–60 min, dominado por la generación de lecciones y el build.

## Arquitectura del shell
```
lib/main.dart                 # Shell: InAppLocalhostServer(kServerPort) + InAppWebView + flutter_tts
assets/web/index.html         # Home (construye tarjetas desde CATALOG)
assets/web/lesson.html        # Cargador de lección (?l=<id>)
assets/web/assets/engine.js   # Motor: Speak (TTS) + framework Lesson + Store (prefijo localStorage)
assets/web/assets/catalog.js  # var CATALOG = [ { area, icon, acc:'aN', desc, lessons:[{id,icon,t,d}] } ]
assets/web/assets/styles.css  # Estilos (acentos --a1..--a14 ya definidos)
assets/web/lessons/<id>.js    # Una lección por archivo: Lesson.start({...})
```

## Procedimiento

### 1. Identidad y puerto
- Nombre visible (convención "X Experto" / "X PRO"), `applicationId com.alfonso.<slug>`
  (slug sin guiones), carpeta `D:\especialista en <tema>`.
- **Puerto único** del registro `reference/ports.md` (siguiente libre). CRÍTICO: dos apps con
  el mismo puerto → la segunda se CONGELA en el splash si ambas están abiertas.

### 2-3. Clonar el shell y cambiar identidad — usar `scripts/clone_app.ps1`
```powershell
pwsh -File scripts/clone_app.ps1 `
  -Src "D:\especialista en agentes ia" -Dst "D:\especialista en <tema>" `
  -OldSlug agentesiaexperto -NewSlug <slug> -Name "<Nombre Visible>" `
  -SnakeName <slug_snake> -Port <PUERTO> -Prefix <prefijo-storage>
```
El script clona (excluye build/lessons/logs), renombra el paquete Kotlin y edita:
MainActivity.kt, build.gradle.kts (namespace+applicationId), AndroidManifest (label),
pubspec.yaml (name), main.dart (puerto, clase, title) y engine.js (prefijo).
**Quedan manuales (contenido creativo):** `pubspec.yaml description:` y en
`assets/web/index.html` el `<title>`, `<h1>`, `.lead`, placeholder del buscador y `.foot`.
- Verificar que AndroidManifest conserve el fix de Impeller (viene del clon):
  `<meta-data android:name="io.flutter.embedding.android.EnableImpeller" android:value="false"/>`
  (sin esto → pantalla NEGRA en GPU Huawei/Honor).

### 4. Diseñar el catálogo (`assets/web/assets/catalog.js`)
- 10–14 áreas con `acc:'a1'..'a14'` (los colores ya existen). 65–80 lecciones en total.
- Cada área: `{ area, icon, acc, desc, lessons:[{id:'kebab-id', icon, t:'Título', d:'una línea'}] }`.
- Ids kebab-case ÚNICOS (el validador detecta duplicados). La última área suele ser la
  integradora/motivacional ("El especialista destacado").
- Cubrir TODO lo que el usuario pidió; sus palabras clave deben aparecer como lecciones.

### 5. Generar lecciones con SUBAGENTES EN PARALELO
- **Un subagente por área**, `Agent` (general-purpose) con `run_in_background: true`,
  lanzados en tandas de 4–5. Esperar las notificaciones entre tandas.
- Construir cada prompt desde `reference/agent-prompt-template.md` (plantilla probada):
  incluye el formato exacto de `Lesson.start`, las reglas de HTML/JS y cómo anclar el
  contenido técnico con bullets por lección (evita alucinaciones).
- **Recuperación**: si un agente termina con uso de tokens mínimo o el resultado menciona
  "session limit", NO escribió sus archivos. Detectar faltantes y relanzar SOLO esos ids:
```bash
cd "D:/especialista en <tema>/assets/web"
ids=$(grep -oE "id: '[a-z0-9-]+'" assets/catalog.js | sed "s/id: '//;s/'//")
for id in $ids; do [ -f "lessons/$id.js" ] || echo "FALTA: $id"; done
```

### 6. Verificar TODO con `scripts/validate_lessons.js`
```bash
cd "D:/especialista en <tema>/assets/web"
node "<ruta-skill>/scripts/validate_lessons.js"
```
Exige: ids catálogo == archivos (sin faltantes/huérfanos ni duplicados), `area` de cada
lección == catálogo, sections/keypoints/flashcards/quiz completos, `quiz.correct` en rango,
sin comillas curvas ni HTML fuera de la lista permitida. Debe terminar `problemas=0`.
(Opcional) probar el render: `python -m http.server 5610 --directory .` + curl 200 del
index, catalog y 1–2 lecciones.

### 7. Compilar el APK
```powershell
cd "D:\especialista en <tema>"; flutter pub get; flutter build apk --release
```
Correr en background (tarda 1–3 min). Los `exception:` del log son warnings de flutter_tts,
NO errores. Éxito = `√ Built ...app-release.apk (~42MB)`.

### 8. Ícono propio (recomendado: el usuario quiere diferenciarlas)
Generar con `scripts/make_icon.py` (parametrizable: carpeta, colores del degradado, glifo):
```powershell
python "<ruta-skill>/scripts/make_icon.py" --dir "D:\especialista en <tema>" --top "#7c3aed" --bot "#4338ca"
```
Editar `draw_glyph()` para un símbolo alusivo al tema y colores distintos de las apps previas
(ver tabla de colores usados en `reference/ports.md`). Luego:
```powershell
dart run flutter_launcher_icons ; dart run flutter_native_splash:create ; flutter build apk --release
```
Mostrar el icon.png al usuario (Read de la imagen) antes de recompilar, por si quiere cambios.

### 9. Instalar en el celular (adb)
```powershell
$adb="$env:LOCALAPPDATA\Android\Sdk\platform-tools\adb.exe"
# Detectar con get-state en bucle (evita patrones que bloquea el sandbox y falsos negativos):
# for(...){ if((& $adb get-state 2>$null) -eq 'device'){break}; Start-Sleep 5 }
& $adb install -r "D:\especialista en <tema>\build\app\outputs\flutter-apk\app-release.apk"
& $adb logcat -c; & $adb shell svc power stayon true; & $adb shell input keyevent KEYCODE_WAKEUP
& $adb shell am start -n com.alfonso.<slug>/.MainActivity
Start-Sleep 8
# Verificar logcat: "Server running on http://localhost:<PUERTO>" y SIN "EGL Error"/"FATAL"
```
- Device del usuario: Honor/Huawei ABR-LX3. Se bloquea/dormita rápido: para captura real debe
  estar DESBLOQUEADO; `screencap` devuelve ~15KB negro si está bloqueado → reintentar.
- Si adb no detecta el teléfono: `adb kill-server; adb start-server`, pedir al usuario cable de
  datos + desbloquear + aceptar "Depuración USB". No insistir más de ~2 min; ofrecer el APK
  copiado para instalación manual.
- Confirmar visualmente con screenshot (app en foco, contenido renderizado) y mostrarla.
- Copiar el APK a Escritorio y Descargas como `<Nombre>-v1.0.apk`.

### 10. Cerrar
- Añadir la app y su puerto en `reference/ports.md` (y color de ícono usado).
- Actualizar la memoria persistente del proyecto (nota `calidad-pro-app.md`) con la nueva app.
- Resumen al usuario: tabla de verificaciones + dónde quedó el APK + cómo ampliar lecciones.

## Errores conocidos (resueltos en el shell; re-verificar)
1. **Splash congelado** — puerto compartido → `SocketException: Address already in use` antes
   de `runApp()`. Fix: puerto único + try/catch en `_server.start()` (ya en el shell).
2. **Pantalla negra Huawei/Honor** — Impeller falla (`EGL Bad Access`). Fix: meta-data
   `EnableImpeller=false` en AndroidManifest (ya en el shell).
3. **Captura negra** — el device está bloqueado/dormido; no es bug de la app.
4. **Agentes que "terminan" sin escribir** — límite de sesión; relanzar solo los ids faltantes.
5. **PowerShell del sandbox** — evitar patrones tipo regex con `\t...$` en pipes complejos
   (falsos positivos de borrado); preferir `adb get-state` y comandos simples.
