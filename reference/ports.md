# Registro de puertos e íconos de la familia

CRÍTICO: cada app DEBE usar un puerto único del `InAppLocalhostServer`. Si dos apps con el
mismo puerto están abiertas a la vez, la segunda lanza `SocketException: Address already in
use` antes de `runApp()` y queda CONGELADA en el splash (no crashea → engaña). El shell base
ya envuelve `_server.start()` en try/catch, pero el puerto único es el fix real.

| Puerto | App | applicationId | Ícono |
|--------|-----|---------------|-------|
| 8973 | Aprende Inglés | com.alfonso.ingles_app | (propio, azul #2176c9) — variante propia del shell (motor Engine, no Lesson.start), en C:\Users\USUARIO\Downloads\aplicativos\ingles_app |
| 8974 | ObraPro | com.alfonso.obrapro | (propio) |
| 8975 | Costos PRO | com.alfonso.costospro | calculadora blanca sobre magenta (#db2777), glifo `calculadora` |
| 8976 | Calidad PRO | com.alfonso.calidadpro | medalla/sello con estrella sobre verde esmeralda (#10b981), glifo `sello` |
| 8977 | SSOMA Experto | com.alfonso.ssomaexperto | casco de seguridad sobre naranja (#f97316), glifo `casco` |
| 8978 | Estructuras Experto | com.alfonso.estructurasexperto | (propio, tijeral) |
| 8979 | Exporta PRO | com.alfonso.exportapro | (propio, globo) |
| 8980 | MTC Experto | com.alfonso.mtcexperto | carretera con lineas amarillas sobre asfalto (#4a5563), glifo `carretera` |
| 8981 | Invierte Experto | com.alfonso.invierteexperto | grafico de crecimiento con flecha sobre turquesa (#14b8a6), glifo `crecimiento` |
| 8982 | Edifica Experto | com.alfonso.edificaexperto | edificios con ventanas sobre indigo (#6366f1), glifo `edificio` |
| 8983 | Contrata Experto | com.alfonso.contrataexperto | contrato con sello sobre vino (#be123c), glifo `contrato` |
| 8984 | Claude Code Experto | com.alfonso.claudecodeexperto | codigo </> coral sobre carbon (#3a3f4b), glifo `code` |
| 8985 | Agentes IA Experto | com.alfonso.agentesiaexperto | robot violeta (#7c3aed→#4338ca) |
| 8986 | Expediente Experto | com.alfonso.expedienteexperto | documento+lupa ámbar (#d97706→#78350f) |
| 8987 | Medio Ambiente Experto | com.alfonso.medioambienteexperto | hoja verde (#16a34a→#166534), glifo `hoja` |
| 8988 | Electricista Experto | com.alfonso.electricistaexperto | rayo oscuro sobre amarillo (#fde047→#eab308), glifo `rayo` |
| 8989 | Sanitario Experto | com.alfonso.sanitarioexperto | gota blanca sobre azul (#0ea5e9→#0c4a6e), glifo `gota`; adaptive bg #0b86c8 |
| 8990 | Electrónica Experto | com.alfonso.electronicaexperto | chip blanco sobre cian (#06b6d4→#164e63), glifo `chip`; adaptive bg #0b7f99. TAMBIEN instalada en PC (Edge --app, carpeta C:\Users\USUARIO\ElectronicaExperto, acceso directo en Escritorio con app.ico) |
| 8991 | Arquitectura Experto | com.alfonso.arquitecturaexperto | fachada colonial limena sobre terracota (#ea7a3c→#9a3412), glifo `fachada`; adaptive bg #c2551f. MEJORADA: motor con bloque de formulas (spec.formulas) + indice rapido de areas (TOC) en index.html |
| 8993 | Producción Experto | com.alfonso.produccionexperto | grua torre blanca izando bloque sobre rojo (#dc2626→#7f1d1d), glifo `grua` (script local make_icon_grua.py); adaptive bg #b91c1c. MEJORADA: motor con ilustraciones SVG por leccion (spec.fig/figcap → assets/web/assets/img/*.svg, 23 imagenes propias); ademas hereda formulas+TOC de Arquitectura. Carpeta D:\especialista en produccion de obras |

**Próximo puerto libre: 8994.**

IMPORTANTE (aprendido en Arquitectura): los `id` de lecciones en catalog.js DEBEN ser ASCII
(sin ñ ni tildes). El cargador lesson.html hace id.replace(/[^a-z0-9\-]/gi,'') y rompe cualquier
id con ñ/acento (ej. 'señalizacion' -> no carga). Usar 'senalizacion', 'diseno', etc.
La MEJORA del motor (bloque `formulas` + TOC) puede portarse a las otras apps de la familia
si se quiere (el shell base de "agentes ia" NO los tiene).

Nota PC: para instalar una de estas apps en la computadora sin Visual Studio C++, copiar
assets/web a una carpeta del usuario y crear un .lnk a msedge.exe con
`--app="file:///.../index.html" --user-data-dir=<carpeta>\edgeprofile` e IconLocation al .ico.
El TTS funciona vía window.speechSynthesis del navegador (fallback ya en engine.js). Anota aquí cada app nueva (puerto + color/glifo del ícono,
para que la siguiente use un color distinto y todas se diferencien de un vistazo).

Nota: los glifos `hoja` y `rayo` se añadieron a una copia local de make_icon.py en el scratchpad
de la sesión (el clasificador bloquea editar el script del skill); para reusarlos, recrea las
funciones draw_hoja/draw_rayo o pídelas.

Colores sugeridos aún libres para íconos: naranja (#ea580c→#9a3412), verde (#16a34a→#166534),
rojo (#dc2626→#7f1d1d), cian (#0891b2→#164e63), rosa (#db2777→#831843).
