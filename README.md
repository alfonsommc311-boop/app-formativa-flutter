# app-formativa-flutter

**Skill / metodología probada** para crear apps Android educativas de la familia **"Experto/PRO"**: aplicaciones que enseñan un tema con ~70–80 lecciones organizadas en ~12–14 áreas, funcionan **sin internet** y se compilan a **APK**.

Cada app comparte un **shell Flutter ligero** (`InAppWebView` + `flutter_tts`) que sirve una web app local; solo cambian el **contenido** (catálogo + lecciones), la **identidad** y el **ícono**.

## Qué hace una app de la familia

- **Home** con buscador, barra de progreso e **índice rápido de áreas** (TOC) para saltar a cualquier tema.
- **Lecciones** con: introducción, secciones con **audio (TTS)**, puntos clave, **datos y fórmulas clave**, fichas de repaso (flashcards) y **autoevaluación** (quiz).
- **Audio en todo** (narración por voz nativa de Android) para aprender escuchando.
- **Offline total**: la web app se sirve desde `localhost` dentro del propio APK.

## Arquitectura del shell

```
lib/main.dart                 # Shell: InAppLocalhostServer(kServerPort) + InAppWebView + flutter_tts
assets/web/index.html         # Home (construye tarjetas desde CATALOG) + índice rápido
assets/web/lesson.html        # Cargador de lección (?l=<id>)
assets/web/assets/engine.js   # Motor: Speak (TTS) + framework Lesson + Store (progreso)
assets/web/assets/catalog.js  # var CATALOG = [ { area, icon, acc, desc, lessons:[{id,icon,t,d}] } ]
assets/web/assets/styles.css  # Estilos (acentos --a1..--a14, TOC, fórmulas)
assets/web/lessons/<id>.js    # Una lección por archivo: Lesson.start({...})
```

## Contenido de este repositorio

| Archivo | Para qué sirve |
|---|---|
| `SKILL.md` | Procedimiento completo, paso a paso (identidad, puerto, catálogo, generación de lecciones, build, ícono, instalación). |
| `reference/checklist.md` | Checklist para marcar en orden al crear una app nueva. |
| `reference/ports.md` | Registro de puertos e íconos de la familia (cada app usa un puerto único del servidor local). |
| `reference/agent-prompt-template.md` | Plantilla probada para los subagentes que generan lecciones en paralelo. |
| `reference/lesson-template.js` | Formato exacto de una lección (`Lesson.start({...})`). |
| `scripts/clone_app.ps1` | Clona el shell y aplica la nueva identidad (package, label, puerto, prefijo, colores). |
| `scripts/make_icon.py` | Genera el ícono propio (fondo degradado redondeado + glifo). |
| `scripts/validate_lessons.js` | Valida que ids del catálogo == archivos, campos completos, quizzes válidos, HTML permitido. |

## Flujo resumido

1. **Identidad y puerto** único (ver `reference/ports.md`).
2. **Clonar el shell** con `scripts/clone_app.ps1` y ajustar la identidad creativa.
3. **Diseñar el catálogo** (`catalog.js`): 10–14 áreas, 65–80 lecciones, ids **ASCII** (sin ñ/tildes).
4. **Generar lecciones** con subagentes en paralelo (uno por área) usando la plantilla.
5. **Validar** con `scripts/validate_lessons.js` (debe dar `problemas=0`).
6. **Compilar** el APK (`flutter build apk --release`).
7. **Ícono** propio con `scripts/make_icon.py`.
8. **Instalar** en el dispositivo por `adb`.

## Errores conocidos (resueltos en el shell)

- **Splash congelado**: dos apps con el mismo puerto → `SocketException: Address already in use`. Fix: **puerto único** por app + `try/catch` en `_server.start()`.
- **Pantalla negra en Huawei/Honor**: Impeller falla. Fix: `EnableImpeller=false` en `AndroidManifest`.
- **ids con ñ/tildes no cargan**: `lesson.html` elimina caracteres no-ASCII. Usar ids **ASCII**.

## Requisitos

- Flutter (stable), Android SDK + `adb`, Python con Pillow (para el ícono), Node.js (para el validador), PowerShell (para el clonado).

---

Metodología iterada en múltiples apps reales de ingeniería/obra (estructuras, medio ambiente, eléctrico, sanitario, electrónica, arquitectura, mecánica, etc.).
