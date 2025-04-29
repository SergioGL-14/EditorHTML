# Gestor de Procedimientos + Editor HTML

Este proyecto está compuesto por dos herramientas que trabajan juntas:

- **Gestor de Procedimientos.ps1**  
  Aplicación gráfica en PowerShell (WinForms) para la creación, edición y gestión de procedimientos técnicos almacenados en una base de datos SQLite.

- **EditorHTML.exe**  
  Editor HTML ligero, desarrollado en Python (PyQt5), que permite editar contenido HTML enriquecido e insertar imágenes embebidas en base64.

---

## 📦 Estructura del Proyecto

```
/GestorProcedimientos/
 ├── GestorProcedimientos.ps1
 ├── XestAd.sqlite
 ├── /EditorHTML/
 │    ├── editor_html.py
 │    └── dist/
 │         └── EditorHTML.exe
 ├── System.Data.SQLite.dll
 ├── README.md
 └── .gitignore
```

---

## 🚀 Requisitos

### Para el GestorProcedimientos.ps1:
- Windows 10/11
- PowerShell 5.1 o superior
- `.NET Framework` (incluido por defecto en Windows)
- `System.Data.SQLite.dll`

### Para el EditorHTML.exe (desarrollo o recompilación):
- Python 3.8+
- PyQt5 (`pip install PyQt5`)
- BeautifulSoup4 (`pip install beautifulsoup4`)

---

## 🛠 Instalación y Uso

1. **Clonar el repositorio:**
   ```bash
   git clone https://github.com/usuario/gestor-procedimientos.git
   ```

2. **Configurar rutas si es necesario:**
   - El script `GestorProcedimientos.ps1` espera encontrar:
     - `XestAd.sqlite` en la misma carpeta o ruta relativa indicada.
     - `EditorHTML.exe` en `/EditorHTML/dist/`.

3. **Ejecutar el gestor de procedimientos:**
   - Botón derecho sobre `GestorProcedimientos.ps1` > **Ejecutar con PowerShell**.

4. **Editar contenido HTML enriquecido:**
   - Dentro del formulario, pulsar el botón **"Editor HTML"** para abrir el editor embebido.

5. **Guardar cambios:**
   - Al guardar en el EditorHTML, el contenido actualizado se inyecta directamente en el formulario.

---

## 🎯 Funcionalidades Principales

- Crear y editar **procedimientos** almacenados en SQLite.
- Organización en **tablas** (`PROCEDIMIENTOS`, `PROCEDIMIENTOS_USUARIOS`, `PROCEDIMIENTOS_HOSPITALES`).
- **Filtro dinámico** de procedimientos con autocompletado.
- **Carga de categorías y áreas sanitarias** desde tablas externas.
- **Envío de correos electrónicos** opcional (excepto en hospitales).
- **Editor HTML embebido** con soporte para imágenes incrustadas en base64.

---

## 📃 Licencia

Este proyecto se distribuye bajo licencia **MIT**.  
Consulta el archivo [LICENSE](LICENSE) para más detalles.

---

## ✏️ Créditos

- **Desarrollador principal:** Sergio (Galvik)
- **Tecnologías:** PowerShell, SQLite, Python, PyQt5, BeautifulSoup

---