# AGENTS.md

<!-- knowledge-base-maintenance:start -->
## Mantenimiento obligatorio de la base de conocimiento

Todo cambio que añada, elimine o modifique funcionalidades, entradas, salidas, integraciones, tecnologías relevantes, estado operativo o relaciones con otros proyectos debe actualizar la base de conocimiento en el mismo cambio.

1. Actualiza la descripción funcional de `project\README.md`; documenta únicamente comportamiento implementado y distingue capacidades principales de utilidades auxiliares.
2. Actualiza la entrada del proyecto en `D:\Antonio\PROYECTOS\Resumen_proyectos\catalogo.json`, incluidos `status`, `summary`, `primaryCapabilities`, `secondaryCapabilities`, `inputs`, `outputs`, `technologies`, `integrations`, `keywords`, `relatedProjects`, `possibleOverlaps`, `lastVerified` y `verificationBasis`.
3. Usa nombres de capacidades ya existentes cuando describan la misma responsabilidad; crea un término nuevo solo cuando represente una capacidad realmente distinta.
4. Registra en `possibleOverlaps` únicamente candidatos razonables a duplicidad o consolidación. Una dependencia, una implementación compartida o dos proyectos complementarios no constituyen por sí solos una duplicidad.
5. Ejecuta `D:\Antonio\PROYECTOS\Resumen_proyectos\Actualizar_resumenes.ps1` para regenerar el front matter, la copia central y `CAPACIDADES.md`.
6. Antes de cerrar, ejecuta `D:\Antonio\PROYECTOS\Resumen_proyectos\Actualizar_resumenes.ps1 -Check`; la tarea no está completa si existe cualquier desfase.

Estados permitidos: `active`, `experimental`, `legacy` y `external`. No incluyas secretos, credenciales, cadenas de conexión ni rutas sensibles en los resúmenes o metadatos.
<!-- knowledge-base-maintenance:end -->

<!-- resumenes-syncthing:start -->
## Changelog y publicación sincronizada

Cuando un commit modifique código de la aplicación:

1. Actualiza `project\changelog.md` en el mismo commit con una entrada Markdown que describa el cambio.
2. Si cambia el comportamiento funcional, actualiza también `project\README.md` y los metadatos del catálogo central mediante el flujo habitual.
3. No edites manualmente `README_<proyecto>.md` ni `Historiales de cambios\changelog_<proyecto>.md` en Syncthing: son publicaciones generadas.
4. Después del commit, ejecuta `Publicar_resumenes.ps1 -Project <proyecto>` desde `D:\Syncthing\SSD Syncthing\Resumen_proyectos` o, si D: no existe, desde la misma ruta en E:.
5. El publicador conserva una instantánea por SHA, actualiza los documentos canónicos y usa el repositorio privado `ABmall/Resumen_proyectos` para resolver concurrencia. Si hay un conflicto, no sobrescribas el canónico: integra el conflicto en Git y vuelve a publicar.
6. Ejecuta `Publicar_resumenes.ps1 -Project <proyecto> -Check` antes de cerrar la tarea.

El hook `project\.githooks\pre-commit` verifica que un cambio de código preparado incluya una entrada nueva en el changelog. Instálalo o restáuralo con `project\scripts\Verificar-ChangelogPreparado.ps1` y la configuración local `core.hooksPath` gestionada por esta migración.
<!-- resumenes-syncthing:end -->
