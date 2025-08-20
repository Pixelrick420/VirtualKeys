# VirtualKeys

 A virtual keyboard application built with PyQt5, specifically designed for KDE Plasma on Kubuntu systems. This application provides a full-featured on-screen keyboard with text editing capabilities, responsive design, and accessibility features.

<img width="1304" height="628" alt="image" src="https://github.com/user-attachments/assets/1e108b4c-dae3-4dd1-9829-460273322a07" />

## Features

### Core Functionality
- **Complete QWERTY Layout**: Full keyboard layout with all standard keys including modifiers
- **Text Editor Integration**: Built-in text editor with copy, paste, and clear functionality
- **Special Character Support**: Access to symbols and special characters via shift combinations
- **Multi-row Layout**: Standard keyboard arrangement with function row, letter rows, and action row

### User Interface
- **Responsive Design**: Automatic scaling based on screen resolution
- **Dark Theme**: Modern dark theme optimized for KDE Plasma
- **Hover Effects**: Visual feedback on button hover and press states
- **Keyboard Focus**: Maintains proper focus management between virtual keyboard and text editor

### Technical Features
- **Cross-platform Compatibility**: Built on PyQt5 for broad Linux distribution support
- **Memory Efficient**: Lightweight application with minimal resource usage
- **Event-driven Architecture**: Proper signal-slot implementation for user interactions

## System Requirements

### Operating System
- KDE Plasma desktop environment
- Ubuntu/Kubuntu (primary target)
- Other Linux distributions with KDE Plasma support

### Dependencies
- Python 3.6 or higher
- PyQt5 5.15.11 or compatible version
- Qt5 development libraries

### Hardware Requirements
- Minimum screen resolution: 1024x768
- Recommended: 1200x800 or higher for optimal experience
- 50MB available disk space
- 64MB RAM (typical usage)

## Installation

### Automated Installation
Use the provided setup script for complete automated installation:

```bash
curl -O https://raw.githubusercontent.com/Pixelrick420/VirtualKeys/main/setup_virtualkeys.sh
chmod +x setup_virtualkeys.sh
./setup_virtualkeys.sh
```

### Manual Installation

#### Prerequisites Installation
```bash
sudo apt update
sudo apt install git python3 python3-pip python3-venv python3-dev build-essential qtbase5-dev qttools5-dev-tools
```

#### Repository Setup
```bash
mkdir -p ~/Applications
cd ~/Applications
git clone https://github.com/Pixelrick420/VirtualKeys.git
cd VirtualKeys
```

#### Virtual Environment Configuration
```bash
python3 -m venv venv
source venv/bin/activate
pip install --upgrade pip
pip install -r requirements.txt
```

#### Application Execution
```bash
python run.py
```

## Architecture

### Project Structure
```
VirtualKeys/
├── app/
│   ├── __init__.py          # Package initialization
│   ├── keyboard.py          # Main keyboard widget implementation
│   ├── text_editor.py       # Text editor component
│   ├── styles.css           # Application stylesheet
│   └── resources.py         # Resource management (future use)
├── run.py                   # Application entry point
├── requirements.txt         # Python dependencies
├── venv/                    # Virtual environment (created during setup)
└── README.md               # Documentation
```

### Component Overview

#### VirtualKeyboard Class (`app/keyboard.py`)
- **Purpose**: Main application window and keyboard layout management
- **Responsibilities**: 
  - Dynamic window sizing based on screen resolution
  - Keyboard layout generation and management
  - Key event handling and text input processing
  - Shift state management and character mapping
  - Integration with text editor component

**Key Methods:**
- `create_keyboard()`: Generates the complete keyboard layout with proper spacing and sizing
- `on_key_pressed()`: Handles all keyboard input events and special key functions
- `get_shifted_char()`: Manages character shifting for symbols and uppercase letters
- `update_key_labels()`: Updates visual key labels when shift state changes

#### TextEditor Class (`app/text_editor.py`)
- **Purpose**: Text input and editing functionality
- **Responsibilities**:
  - Text insertion and deletion operations
  - Clipboard integration (copy/paste)
  - Text formatting and display
  - Cursor management

**Key Methods:**
- `insert_text()`: Handles text insertion at cursor position
- `backspace()`: Implements character deletion functionality
- `copy_text()`: Provides copy-to-clipboard functionality
- `paste_text()`: Handles paste-from-clipboard operations

### Keyboard Layout Specification

#### Row Configuration
The keyboard uses a 5-row layout with the following structure:

**Row 1 (Numbers and Symbols)**
```
Keys: ` 1 2 3 4 5 6 7 8 9 0 - = ⌫
Special: Backspace key spans 2 columns
```

**Row 2 (Top Letter Row)**
```
Keys: Tab q w e r t y u i o p [ ] \
Special: Tab key spans 2 columns
```

**Row 3 (Home Row)**
```
Keys: Caps a s d f g h j k l ; ' ↵
Special: Caps Lock spans 2 columns, Enter spans 2 columns
```

**Row 4 (Bottom Letter Row)**
```
Keys: ⇧ z x c v b n m , . / ⇧
Special: Both Shift keys span 2 columns
```

**Row 5 (Action Row)**
```
Keys: Copy Paste ⎵ Clear
Spans: Copy(3), Paste(3), Space(8), Clear(3)
```

#### Character Mapping
The application implements complete shift character mapping:

**Symbol Shifts:**
- Numbers: `1!2@3#4$5%6^7&8*9(0)`
- Punctuation: `=+-_[{]}\|;:'",<.>/?`
- Special: `` `~ ``

**Letter Shifts:**
- All alphabetic characters support uppercase/lowercase toggling
- Caps Lock provides persistent uppercase mode
- Shift provides temporary uppercase mode

### Responsive Design Implementation

#### Screen Size Detection
The application automatically detects screen resolution and adjusts interface elements:

**Small Screens (≤1200px width):**
- Window: 950x400 maximum
- Key height: 40px
- Optimized for laptops and smaller displays

**Medium Screens (≤1600px width):**
- Window: 1100x500 maximum  
- Key height: 50px
- Standard desktop configuration

**Large Screens (>1600px width):**
- Window: 1300x600 maximum
- Key height: 60px
- High-resolution display optimization

#### Dynamic Sizing Algorithm
```python
if screen_width <= 1200:
    window_width = min(950, screen_width - 50)
    window_height = min(400, screen_height - 100)
    key_height = 40
# Additional size categories...
```

## Styling and Theming

### CSS Architecture
The application uses external CSS styling (`app/styles.css`) with the following structure:

**Base Styling:**
- Dark theme color scheme (#2d2d2d background)
- Noto Sans font family for consistent rendering
- 16px base font size

**Button Categories:**
- `.modifier-key`: Shift, Ctrl, Alt styling (#5a5a5a)
- `.action-key`: Copy, Paste, Clear styling (#3a5a78)  
- `.space-key`: Spacebar specific styling (200px minimum width)
- `.special-key`: Function keys and special characters (#4a4a4a)

**Interactive States:**
- `:hover`: Lighter background on mouse over
- `:pressed`: Darker background on key press
- Focus indicators for accessibility

### Color Scheme
```css
Primary Background: #2d2d2d
Button Background: #3a3a3a
Button Hover: #4a4a4a
Button Pressed: #2a2a2a
Text Color: #ffffff
Text Editor Background: white
Text Editor Text: black
Action Buttons: #3a5a78
```

## Usage

### Basic Operation
1. Launch the application using desktop shortcut or command line
2. Click virtual keys to input text into the integrated text editor
3. Use modifier keys (Shift, Caps Lock) for uppercase and symbols
4. Utilize action buttons (Copy, Paste, Clear) for text manipulation

### Keyboard Shortcuts
- **Backspace (⌫)**: Delete previous character
- **Enter (↵)**: Insert newline
- **Space (⎵)**: Insert space character
- **Tab**: Insert tab character
- **Shift (⇧)**: Temporary uppercase/symbol mode
- **Caps Lock**: Toggle persistent uppercase mode

### Text Editor Functions
- **Copy**: Select all text and copy to system clipboard
- **Paste**: Insert clipboard content at cursor position
- **Clear**: Remove all text from editor
- **Direct Editing**: Click in text area to position cursor manually

## Development

### Code Style
- PEP 8 compliance for Python code
- Type hints recommended for new development
- Comprehensive docstrings for public methods
- Consistent naming conventions

### Extension Points
- **Custom Layouts**: Modify `keyboard_rows` in `VirtualKeyboard.create_keyboard()`
- **Theme Customization**: Edit `app/styles.css` for visual changes
- **Additional Languages**: Extend character mapping in `shift_map`
- **Plugin Architecture**: Utilize `app/resources.py` for future enhancements

### Testing
```bash
# Activate virtual environment
source venv/bin/activate

# Run application in debug mode
python -c "import sys; sys.argv.append('--debug'); exec(open('run.py').read())"
```

### Building from Source
```bash
git clone https://github.com/Pixelrick420/VirtualKeys.git
cd VirtualKeys
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt
python run.py
```

## Troubleshooting

### Common Issues

**Import Error: No module named 'PyQt5'**
```bash
pip install PyQt5==5.15.11
```

**Qt Platform Plugin Error**
```bash
sudo apt install qt5-qmltooling-plugins qtdeclarative5-dev
export QT_QPA_PLATFORM=xcb
```

**Permission Denied on Desktop Shortcut**
```bash
chmod +x ~/Desktop/VirtualKeys.desktop
```

**Application Window Not Appearing**
- Verify display server compatibility (X11/Wayland)
- Check virtual environment activation
- Ensure all dependencies are installed

### Debug Information
Enable debug output by modifying `run.py`:
```python
import sys
import logging
logging.basicConfig(level=logging.DEBUG)
```

### Performance Optimization
- Close unused applications to free memory
- Use hardware acceleration if available
- Consider disabling visual effects on older systems

## Contributing

### Development Setup
1. Fork the repository on GitHub
2. Clone your fork locally
3. Create a feature branch
4. Make changes with appropriate tests
5. Submit pull request with detailed description

### Code Guidelines
- Follow PEP 8 style guidelines
- Add docstrings to new methods
- Include type hints where appropriate
- Update tests for modified functionality

### Issue Reporting
Include the following information:
- Operating system and version
- Python and PyQt5 versions
- Complete error traceback
- Steps to reproduce the issue
- Expected vs actual behavior
