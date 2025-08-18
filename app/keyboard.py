from PyQt5.QtWidgets import (QWidget, QVBoxLayout, QPushButton, QGridLayout, 
                            QApplication, QSizePolicy, QSpacerItem)
from PyQt5.QtCore import Qt
from .text_editor import TextEditor
import sys

class VirtualKeyboard(QWidget):
    def __init__(self):
        super().__init__()
        self.setWindowTitle("Virtual Keyboard")
        
        screen = QApplication.primaryScreen().geometry()
        screen_width = screen.width()
        screen_height = screen.height()
        
        if screen_width <= 1200:
            self.window_width = min(950, screen_width - 50)
            self.window_height = min(400, screen_height - 100)
            self.key_height = 40
        elif screen_width <= 1600:
            self.window_width = min(1100, screen_width - 100)
            self.window_height = min(500, screen_height - 150)
            self.key_height = 50
        else:
            self.window_width = min(1300, screen_width - 200)
            self.window_height = min(600, screen_height - 200)
            self.key_height = 60
        
        self.setFixedSize(self.window_width, self.window_height)
        
        x = (screen_width - self.window_width) // 2
        y = (screen_height - self.window_height) // 2
        self.move(x, y)

        self.text_editor = TextEditor()
        
        self.create_keyboard()
        
        main_layout = QVBoxLayout()
        main_layout.setContentsMargins(10, 10, 10, 10)
        main_layout.addWidget(self.text_editor)
        main_layout.addLayout(self.keyboard_layout)
        self.setLayout(main_layout)
        
        self.setStyleSheet(open("app/styles.css").read())
    
    def create_keyboard(self):
        self.keyboard_layout = QGridLayout()
        self.keyboard_layout.setSpacing(3)  
        self.keyboard_layout.setContentsMargins(15, 8, 15, 8)
        
        
        keyboard_rows = [
            {
                'keys': ['`', '1', '2', '3', '4', '5', '6', '7', '8', '9', '0', '-', '=', '⌫'],
                'offset': 0,  
                'spans': {'⌫': 2}
            },
            {
                'keys': ['Tab', 'q', 'w', 'e', 'r', 't', 'y', 'u', 'i', 'o', 'p', '[', ']', '\\'],
                'offset': 0,  
                'spans': {'Tab': 2}
            },
            {
                'keys': ['Caps', 'a', 's', 'd', 'f', 'g', 'h', 'j', 'k', 'l', ';', "'", '↵'],
                'offset': 0,  
                'spans': {'Caps': 2, '↵': 2}
            },
            {
                'keys': ['⇧', 'z', 'x', 'c', 'v', 'b', 'n', 'm', ',', '.', '/', '⇧'],
                'offset': 0,  
                'spans': {'⇧': 2} 
            },
            {
                'keys': ['Copy', 'Paste', '⎵', 'Clear'],
                'offset': 0, 
                'spans': {'Copy': 3, 'Paste': 3, '⎵': 8, 'Clear': 3}
            }
        ]
        
        self.shift_on = False
        self.buttons = {}
        
        self.shift_map = {
            '`': '~', '1': '!', '2': '@', '3': '#', '4': '$', '5': '%',
            '6': '^', '7': '&&', '8': '*', '9': '(', '0': ')', '-': '_',
            '=': '+', '[': '{', ']': '}', '\\': '|', ';': ':', "'": '"',
            ',': '<', '.': '>', '/': '?'
        }
        
        for row_idx, row_data in enumerate(keyboard_rows):
            keys = row_data['keys']
            offset = row_data['offset']
            spans = row_data.get('spans', {})
            
            if offset > 0:
                spacer_width = int(10 * offset) 
                spacer = QSpacerItem(spacer_width, 20, QSizePolicy.Fixed, QSizePolicy.Minimum)
                self.keyboard_layout.addItem(spacer, row_idx, 0, 1, max(1, int(offset)))
            
            col_pos = max(1, int(offset)) if offset > 0 else 0
            
            for key in keys:
                button = QPushButton(key)
                button.setSizePolicy(QSizePolicy.Expanding, QSizePolicy.Expanding)
                button.setMinimumHeight(self.key_height)
                button.setMaximumHeight(self.key_height + 10)
                
                font_size = max(8, self.key_height // 4)
                button.setStyleSheet(f"font-size: {font_size}px;")
                
                if key in ['⇧', '⌫', '↵', 'Tab', 'Caps']:
                    button.setProperty('class', 'modifier-key')
                elif key in ['Copy', 'Paste', 'Clear']:
                    button.setProperty('class', 'action-key')
                elif key == '⎵':
                    button.setProperty('class', 'space-key')
                    button.setText('Space')  
                elif len(key) > 1:
                    button.setProperty('class', 'special-key')
                
                button.clicked.connect(self.on_key_pressed)
                self.buttons[key] = button
                
                span = spans.get(key, 1)
                
                self.keyboard_layout.addWidget(button, row_idx, col_pos, 1, span)
                col_pos += span
    
    def on_key_pressed(self):
        sender = self.sender()
        key = sender.text()
        
        if sender == self.buttons.get('⎵'):
            key = '⎵'
        
        if key == '⌫':  # Backspace
            self.text_editor.backspace()
        elif key == '↵':  # Enter
            self.text_editor.insert_text('\n')
        elif key == '⎵':  # Space
            self.text_editor.insert_text(' ')
        elif key == 'Tab':  # Tab
            self.text_editor.insert_text('\t')
        elif key == 'Caps':  
            self.shift_on = not self.shift_on
            self.update_key_labels()
        elif key == '⇧':  # Shift
            self.shift_on = not self.shift_on
            self.update_key_labels()
        elif key == 'Copy':
            self.text_editor.copy_text()
        elif key == 'Paste':
            self.text_editor.paste_text()
        elif key == 'Clear':
            self.text_editor.clear()
        else:
            if len(key) == 1:
                char = self.get_shifted_char(key) if self.shift_on else key
                self.text_editor.insert_text(char)
                if self.shift_on:
                    self.shift_on = False
                    self.update_key_labels()
    
    def get_shifted_char(self, key):
        """Return the shifted version of the character"""
        if key.isalpha():
            return key.upper()
        return self.shift_map.get(key, key)
    
    def update_key_labels(self):
        """Update key labels when shift state changes"""
        for key, button in self.buttons.items():
            if len(key) == 1 and key in self.shift_map:
                button.setText(self.shift_map[key] if self.shift_on else key)
            elif len(key) == 1 and key.isalpha():
                button.setText(key.upper() if self.shift_on else key.lower())
    
    def resizeEvent(self, event):
        """Handle window resize events to maintain keyboard proportions"""
        super().resizeEvent(event)