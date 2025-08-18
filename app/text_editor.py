from PyQt5.QtWidgets import QTextEdit, QApplication
from PyQt5.QtGui import QTextCursor, QFont

class TextEditor(QTextEdit):
    def __init__(self):
        super().__init__()
        self.setMinimumHeight(120)
        self.setPlaceholderText("Type here using the virtual keyboard...")
        self.setLineWrapMode(QTextEdit.WidgetWidth)
        
        font = QFont()
        font.setFamily('Noto Sans')
        font.setPointSize(14)
        self.setFont(font)
    
    def insert_text(self, text):
        self.insertPlainText(text)
    
    def backspace(self):
        text_cursor = self.textCursor()
        text_cursor.deletePreviousChar()
        self.setTextCursor(text_cursor)
    
    def copy_text(self):
        self.selectAll()
        self.copy()
        self.moveCursor(QTextCursor.End)
    
    def paste_text(self):
        clipboard = QApplication.clipboard()
        plain_text = clipboard.text()
        if plain_text:
            self.insertPlainText(plain_text)
    
    def clear(self):
        self.setPlainText("")