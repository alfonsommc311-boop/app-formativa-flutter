/* PLANTILLA de una lección. Cada archivo assets/web/lessons/<id>.js contiene
   EXACTAMENTE una llamada Lesson.start({...}) y debe ser JS válido.

   Reglas de formato (dárselas SIEMPRE a los subagentes que generan lecciones):
   - Cadenas JS con comilla simple.  HTML dentro de los campos con comilla doble en atributos.
   - Escapar apóstrofes dentro de string simple:  f\'c   a\/c   d\'obra
   - NADA de comillas tipográficas curvas.
   - HTML permitido SOLO:  <p> <b> <ul><li> <ol><li> <table><tr><th><td> <span class="hl">
     (span.hl resalta fórmulas/valores/normas clave). Nada de <script>/<style>/clases inventadas.
   - Explicar SIEMPRE el porqué (fundamento), no solo el dato. Marcar "verificar norma/versión
     vigente" en cifras que cambian. Incluir tablas y un ejemplo numérico cuando aplique.
   - id == nombre del archivo (kebab-case). area/areaIcon == exactamente los del catálogo. */

Lesson.start({
  id: 'ejemplo-id', area: 'Nombre exacto del área', areaIcon: '📚', icon: '🔧',
  title: 'Título de la lección',
  subtitle: 'Una frase que engancha y resume el valor de la lección.',
  norma: 'Referencia o principio clave en una frase (ej. la norma o la idea central).',
  intro: '<p>Párrafo introductorio en HTML (3-5 frases): qué es y <b>por qué importa</b>. Da el contexto y el fundamento antes de los detalles.</p>',
  sections: [
    { h: 'Primer subtítulo',
      html: '<p>Explicación con <b>negrita</b> para lo importante y <span class="hl">valor o fórmula clave</span>.</p><ul><li>Punto uno.</li><li>Punto dos.</li></ul>' },
    { h: 'Ejemplo / tabla',
      html: '<table><tr><th>Concepto</th><th>Valor</th></tr><tr><td>Ejemplo</td><td>123 (referencial, verificar norma vigente)</td></tr></table>' },
    { h: 'Tercer subtítulo', html: '<p>Más desarrollo, siempre explicando el porqué.</p>' },
    { h: 'Cuarto subtítulo', html: '<p>Cierre del tema o aplicación práctica.</p>' }
    // 4 a 6 secciones
  ],
  keypoints: [
    'Idea memorizable 1.',
    'Idea memorizable 2.',
    'Idea memorizable 3.',
    'Idea memorizable 4.',
    'Idea memorizable 5.'
    // 5 a 6 puntos
  ],
  flashcards: [
    { q: '¿Pregunta de repaso 1?', a: 'Respuesta breve y correcta.' },
    { q: '¿Pregunta de repaso 2?', a: 'Respuesta.' },
    { q: '¿Pregunta de repaso 3?', a: 'Respuesta.' },
    { q: '¿Pregunta de repaso 4?', a: 'Respuesta.' }
    // 4 a 5 fichas
  ],
  quiz: [
    { q: 'Pregunta de autoevaluación 1', opts: ['Opción A', 'Opción B', 'Opción C'], correct: 1,
      why: 'Explicación de por qué la opción correcta (índice 0-based) lo es.' },
    { q: 'Pregunta 2', opts: ['A', 'B', 'C'], correct: 0, why: 'Explicación.' },
    { q: 'Pregunta 3', opts: ['A', 'B', 'C'], correct: 2, why: 'Explicación.' }
    // 3 a 4 preguntas; correct es el índice (0-based) de la opción correcta
  ]
});
