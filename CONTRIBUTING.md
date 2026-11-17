# Cómo colaborar

Gracias por querer mejorar la wiki. Cualquier aporte suma: corregir un typo, aclarar una explicación, arreglar código que no compila o sumar ejercicios.

## Reportar un problema

Si no tenés tiempo de arreglarlo vos, abrí un **issue** contando:

- En qué página está (el link o la ruta del archivo, p. ej. `docs/5-construccion/06-login.md`).
- Qué está mal o qué no se entiende.
- Si es código: qué esperabas que pasara y qué pasó (con el error copiado).

## Proponer un cambio

1. Creá una rama desde `main` con un nombre descriptivo:

   ```bash
   git switch -c fix/login-validacion
   ```

2. Levantá la wiki localmente (ver el [README](README.md#verla-en-tu-compu)) y hacé los cambios en `docs/`.
3. Antes de subir, verificá que compile sin advertencias:

   ```bash
   mkdocs build --strict
   ```

4. Hacé commit y abrí un **Pull Request** contra `main`. Alguien del equipo lo revisa antes de mezclarlo.

### Mensajes de commit

Usamos el mismo formato que se explica en [Trabajo en equipo con Git](docs/6-pruebas-y-entrega/8-trabajo-en-equipo.md):

```text
docs: aclarar null safety en variables y tipos
fix: corregir import en el capítulo 6 (login)
```

## Convenciones de escritura

- **Español rioplatense**, tuteando con voseo ("leé", "probá", "tenés"), igual que el resto de la wiki.
- **Código completo**: en la Parte 5 cada archivo se muestra entero, con su ruta como título y numeración de líneas:

  ````markdown
  ```dart title="lib/ejemplo.dart" linenums="1"
  void main() {}
  ```
  ````

- Para explicar líneas puntuales usá **notas numeradas** (`// (1)!`) con la lista debajo del bloque.
- Usá los recuadros (`!!! tip`, `!!! warning`, `!!! abstract "Objetivo"`, etc.) como en las páginas existentes.
- Las capturas van en `docs/assets/capturas/` y los diagramas preferentemente en Mermaid, dentro del Markdown.

## Agregar una página nueva

1. Creá el `.md` dentro de la parte que corresponda en `docs/`.
2. Sumala al menú en la sección `nav:` de `mkdocs.yml`. Si no la agregás, `mkdocs build --strict` avisa.
3. Enlazá otras páginas con rutas relativas al archivo `.md` (p. ej. `../2-dart/5-clases.md`), no a URLs del sitio.
