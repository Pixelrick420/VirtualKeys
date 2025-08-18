from PyQt5.QtWidgets import QApplication
from app.keyboard import VirtualKeyboard

def main():
    app = QApplication([])
    
    app.setStyle('Fusion')
    
    keyboard = VirtualKeyboard()
    keyboard.show()
    
    app.exec_()

if __name__ == "__main__":
    main()