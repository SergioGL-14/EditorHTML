#!/usr/bin/env python3
import sys, os, base64
from PyQt5.QtWidgets import (
    QApplication, QMainWindow, QTextEdit, QAction, QFileDialog,
    QMessageBox, QToolBar
)
from PyQt5.QtGui import QFont, QKeySequence
from PyQt5.QtCore import QSize
from bs4 import BeautifulSoup

def image_to_data_uri(img_path):
    """
    Abre la imagen y la convierte a un data URI usando base64,
    determinando el MIME según la extensión.
    """
    ext = os.path.splitext(img_path)[1].lower()[1:]
    if ext in ("jpg", "jpeg"):
        mime = "image/jpeg"
    elif ext == "png":
        mime = "image/png"
    elif ext == "gif":
        mime = "image/gif"
    else:
        mime = "application/octet-stream"
    with open(img_path, "rb") as f:
        data = f.read()
    b64 = base64.b64encode(data).decode("utf-8")
    return f"data:{mime};base64,{b64}"

def embed_images_in_html(html):
    """
    Busca en el HTML las etiquetas <img> y, si el atributo src es un archivo local,
    lo reemplaza por un data URI con base64.
    """
    soup = BeautifulSoup(html, "html.parser")
    for img in soup.find_all("img"):
        src = img.get("src")
        if src and os.path.exists(src):
            data_uri = image_to_data_uri(src)
            img["src"] = data_uri
    return str(soup)

class EditorWindow(QMainWindow):
    def __init__(self, initialFile=None):
        super().__init__()
        self.initialFile = initialFile
        self.initUI()
        
    def initUI(self):
        self.setWindowTitle("Editor HTML")
        self.resize(1000, 800)  # Interfaz más grande
        
        # Aplicar un stylesheet para un aspecto moderno y accesible
        self.setStyleSheet("""
            QMainWindow {
                background-color: #ececec;
            }
            QTextEdit {
                background-color: #ffffff;
                font-size: 16px;
                color: #333333;
                padding: 10px;
            }
            QToolBar {
                background-color: #444444;
                spacing: 10px;
                padding: 5px;
            }
            QToolBar QToolButton {
                color: #ffffff;
                font-size: 14px;
                padding: 5px;
                border: none;
                background: transparent;
            }
            QToolBar QToolButton:hover {
                background-color: #666666;
            }
        """)
        
        # Editor de texto: QTextEdit admite HTML y rich text
        self.textEdit = QTextEdit()
        self.textEdit.setAcceptRichText(True)
        # Si se pasa un archivo inicial, cargar su contenido; si no, texto por defecto
        if self.initialFile and os.path.exists(self.initialFile):
            try:
                with open(self.initialFile, "r", encoding="utf-8") as f:
                    content = f.read()
                self.textEdit.setHtml(content)
            except Exception as e:
                self.textEdit.setHtml("<p>Error al cargar el archivo inicial.</p>")
        else:
            self.textEdit.setHtml("<p style='font-family: Arial; margin: 10px;'>Empieza a escribir tu contenido aquí...</p>")
        self.setCentralWidget(self.textEdit)
        
        # Barra de herramientas (sin iconos, solo texto)
        toolbar = QToolBar("Herramientas")
        toolbar.setMovable(False)
        self.addToolBar(toolbar)
        
        # Acción Negrita
        boldAction = QAction("Negrita", self)
        boldAction.setShortcut(QKeySequence("Ctrl+B"))
        boldAction.triggered.connect(self.makeBold)
        toolbar.addAction(boldAction)
        
        # Acción Cursiva
        italicAction = QAction("Cursiva", self)
        italicAction.setShortcut(QKeySequence("Ctrl+I"))
        italicAction.triggered.connect(self.makeItalic)
        toolbar.addAction(italicAction)
        
        # Acción Subrayado
        underlineAction = QAction("Subrayado", self)
        underlineAction.setShortcut(QKeySequence("Ctrl+U"))
        underlineAction.triggered.connect(self.makeUnderline)
        toolbar.addAction(underlineAction)
        
        # Acción Aumentar tamaño de fuente
        increaseAction = QAction("Aumentar Fuente", self)
        increaseAction.triggered.connect(self.increaseFont)
        toolbar.addAction(increaseAction)
        
        # Acción Disminuir tamaño de fuente
        decreaseAction = QAction("Disminuir Fuente", self)
        decreaseAction.triggered.connect(self.decreaseFont)
        toolbar.addAction(decreaseAction)
        
        # Acción Insertar imagen
        insertImageAction = QAction("Insertar Imagen", self)
        insertImageAction.triggered.connect(self.insertImage)
        toolbar.addAction(insertImageAction)
        
        # Acción Guardar HTML
        saveAction = QAction("Guardar HTML", self)
        saveAction.setShortcut(QKeySequence.Save)
        saveAction.triggered.connect(self.saveHtml)
        toolbar.addAction(saveAction)
        
    def makeBold(self):
        fmt = self.textEdit.currentCharFormat()
        fmt.setFontWeight(QFont.Bold if fmt.fontWeight() != QFont.Bold else QFont.Normal)
        self.textEdit.mergeCurrentCharFormat(fmt)
        
    def makeItalic(self):
        fmt = self.textEdit.currentCharFormat()
        fmt.setFontItalic(not fmt.fontItalic())
        self.textEdit.mergeCurrentCharFormat(fmt)
        
    def makeUnderline(self):
        fmt = self.textEdit.currentCharFormat()
        fmt.setFontUnderline(not fmt.fontUnderline())
        self.textEdit.mergeCurrentCharFormat(fmt)
        
    def increaseFont(self):
        fmt = self.textEdit.currentCharFormat()
        size = fmt.fontPointSize() or self.textEdit.font().pointSize()
        fmt.setFontPointSize(size + 2)
        self.textEdit.mergeCurrentCharFormat(fmt)
        
    def decreaseFont(self):
        fmt = self.textEdit.currentCharFormat()
        size = fmt.fontPointSize() or self.textEdit.font().pointSize()
        if size > 2:
            fmt.setFontPointSize(size - 2)
            self.textEdit.mergeCurrentCharFormat(fmt)
        
    def insertImage(self):
        options = QFileDialog.Options()
        fileName, _ = QFileDialog.getOpenFileName(
            self, "Insertar Imagen", "", "Archivos de Imagen (*.png *.jpg *.jpeg *.gif)", options=options)
        if fileName:
            cursor = self.textEdit.textCursor()
            cursor.insertHtml(f'<img src="{fileName}" alt="Imagen" style="max-width:100%; margin: 5px;">')
        
    def saveHtml(self):
        html = self.textEdit.toHtml()
        html_with_embedded_images = embed_images_in_html(html)
        # Si se abrió con un archivo inicial (vía -FilePath), guardamos directamente sin pedir ubicación
        if self.initialFile:
            try:
                with open(self.initialFile, "w", encoding="utf-8") as f:
                    f.write(html_with_embedded_images)
                QMessageBox.information(self, "Guardado", "El archivo HTML se ha guardado correctamente.")
                self.close()  # Cierra la ventana para que el .ps1 detecte que se ha cerrado
            except Exception as e:
                QMessageBox.critical(self, "Error", f"Error al guardar el archivo: {e}")
        else:
            # Si no se proporcionó -FilePath, se muestra el diálogo para guardar
            options = QFileDialog.Options()
            fileName, _ = QFileDialog.getSaveFileName(
                self, "Guardar HTML", "", "Archivos HTML (*.html);;Todos los archivos (*)", options=options)
            if fileName:
                try:
                    with open(fileName, "w", encoding="utf-8") as f:
                        f.write(html_with_embedded_images)
                    QMessageBox.information(self, "Guardado", "El archivo HTML se ha guardado correctamente.")
                except Exception as e:
                    QMessageBox.critical(self, "Error", f"Error al guardar el archivo: {e}")

def main():
    # Analizar los argumentos: se espera el parámetro -FilePath <ruta>
    filePath = None
    args = sys.argv[1:]
    if "-FilePath" in args:
        idx = args.index("-FilePath")
        if idx + 1 < len(args):
            filePath = args[idx+1]
    app = QApplication(sys.argv)
    editor = EditorWindow(filePath)
    editor.show()
    sys.exit(app.exec_())

if __name__ == "__main__":
    main()