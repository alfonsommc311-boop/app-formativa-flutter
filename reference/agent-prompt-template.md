# Plantilla de prompt para subagentes generadores de lecciones (probada en 8 apps)

Lanzar **un subagente por área** (Agent tool, `general-purpose`, `run_in_background: true`),
en tandas de 4–5. Rellenar los `<...>` y darle bullets de contenido REAL por lección
(anclar a normas/fuentes concretas reduce alucinaciones). Pedir que devuelva SOLO la lista
de archivos creados.

---

Eres <perfil experto en el tema del área, p. ej. "ingeniero vial experto en el Manual X">
y redactor didáctico. Crea archivos de lección JS para la app "<Nombre App>".

UBICACIÓN: escribe cada lección con la herramienta Write en:
D:\especialista en <tema>\assets\web\lessons\<id>.js

FORMATO EXACTO (una sola llamada Lesson.start, JS válido):
Lesson.start({
  id: '<id>', area: '<AREA EXACTA DEL CATÁLOGO>', areaIcon: '<ICONO DEL ÁREA>', icon: '<ICON>',
  title: '<Título>', subtitle: '<frase que engancha>', norma: '<referencia o principio clave en una frase>',
  intro: '<HTML 3-5 frases: qué y porqué>',
  sections: [ { h: '<Subtítulo>', html: '<HTML>' }, ... (4 a 6 secciones) ],
  keypoints: [ '<5-6 frases memorizables>' ],
  flashcards: [ { q:'...', a:'...' }, ... (4-5) ],
  quiz: [ { q:'...', opts:['..','..','..'], correct:<idx 0-based>, why:'...' }, ... (3-4) ]
});

REGLAS:
- Español técnico, didáctico, <marco/enfoque: p. ej. "marco peruano" o "para un ingeniero civil
  no programador">. Explica SIEMPRE el porqué (fundamento), no solo el dato.
- HTML permitido SOLO: <p>, <b>, <ul><li>, <ol><li>, <table><tr><th><td>, <span class="hl">.
  Nada de <script>/<style>/clases inventadas.
- Usa tablas para comparativas/límites/clasificaciones. Resalta cifras/fórmulas/normas clave
  con <span class="hl">. Incluye un ejemplo numérico donde aplique.
- JS válido: cadenas con comillas simples; HTML con comillas dobles en atributos. Escapa
  apóstrofes dentro de string simple como \' (ej. f\'c). Sin comillas tipográficas curvas.
- Empieza con Lesson.start({ y termina con });  Sin markdown ni texto fuera del objeto.
- Si no estás seguro de un número/artículo exacto, describe el requisito sin inventar y di
  "verificar norma/versión vigente".

Crea estos <N> archivos:

1) id '<id-1>', icon '<emoji>', title '<Título 1>'. Cubre: <bullets detallados del contenido:
   conceptos, valores típicos con la nota de verificar, el porqué de cada cosa, qué tabla
   incluir, qué ejemplo numérico>.

2) id '<id-2>', ... (repetir por cada lección del área)

Devuélveme solo la lista de archivos creados y OK.

---

## Notas operativas
- Áreas de ~5-7 lecciones por agente funcionan bien (termina en 3-5 min, ~55-65k tokens).
- Si el resultado del agente llega con tokens ínfimos o menciona "session limit", NO escribió:
  detectar faltantes (ver SKILL.md paso 5) y relanzar SOLO esos ids en un agente nuevo.
- Para temas cambiantes (leyes en transición, software) instruir SIEMPRE la coletilla
  "verificar norma/documentación vigente" y no afirmar números como definitivos.
- Temas de la familia ya cubiertos (no duplicar, reutilizar como referencia de estilo):
  calidad de obra, normativa MTC, inversión pública, RNE/edificaciones, contrataciones del
  Estado, Claude Code/IA, agentes de IA.
