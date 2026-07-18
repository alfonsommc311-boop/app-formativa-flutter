# Checklist — nueva app formativa (marcar en orden)

## Preparación
- [ ] Tema, nombre visible, slug (`com.alfonso.<slug>`), carpeta `D:\especialista en <tema>`
- [ ] Puerto único elegido de `ports.md` y ANOTADO ahí mismo
- [ ] Confirmar con el usuario nombre/alcance si hay ambigüedad (AskUserQuestion)

## Shell e identidad
- [ ] `scripts/clone_app.ps1` ejecutado sin warnings (checks OK)
- [ ] `pubspec.yaml` → description editada (creativa)
- [ ] `index.html` → title, h1, .lead, placeholder buscador, .foot editados
- [ ] AndroidManifest conserva `EnableImpeller=false`

## Contenido
- [ ] `catalog.js` con 10–14 áreas (`acc:'a1'..'a14'`), 65–80 lecciones, ids únicos
- [ ] Las palabras clave del pedido del usuario existen como lecciones
- [ ] Subagentes lanzados (1 por área, tandas de 4–5, run_in_background)
- [ ] Todas las notificaciones recibidas; faltantes detectados y relanzados si hubo
- [ ] `validate_lessons.js` → `problemas=0, faltantes=0, huerfanos=0`

## Build + ícono
- [ ] `flutter pub get` + `flutter build apk --release` → `√ Built (~42MB)`
- [ ] Ícono propio generado (`make_icon.py`, color/glifo distinto a apps previas), mostrado al usuario
- [ ] `dart run flutter_launcher_icons` + `flutter_native_splash:create` + rebuild

## Instalación y verificación en device
- [ ] `adb get-state` = device (tel. conectado, desbloqueado, depuración USB)
- [ ] `adb install -r` → Success
- [ ] `am start` + logcat: `Server running on http://localhost:<PUERTO>`, sin EGL/FATAL
- [ ] Screenshot del home renderizado (device desbloqueado; reintentar si sale negro)
- [ ] APK copiado a Escritorio y Descargas como `<Nombre>-v1.0.apk`

## Cierre
- [ ] `ports.md` actualizado (puerto + color de ícono)
- [ ] Memoria del proyecto actualizada (nota calidad-pro-app.md)
- [ ] Resumen final al usuario (tabla de verificaciones + cómo ampliar lecciones)
