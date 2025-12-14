#!/bin/zsh

echo "🚀 Setting up development environment..."

# ============================================
# Install zoxide if not present
# ============================================
if ! command -v zoxide &> /dev/null; then
    echo "\n📦 Installing zoxide..."
    curl -sS https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash
    echo "✅ Zoxide installed"
else
    echo "\n✅ Zoxide already installed"
fi

# ============================================
# Git Configuration
# ============================================
echo "\n📝 Configuring Git..."

git config --global core.editor "code --wait"
git config --global core.pager "less -FX"
git config --global alias.st "status -sb"
git config --global alias.lg "log --oneline --decorate --graph --all"

# Setup global gitignore
GITIGNORE_GLOBAL="$HOME/.gitignore_global"
git config --global core.excludesfile "$GITIGNORE_GLOBAL"
echo -e ".DS_Store\nnode_modules\n*.log\n.cache/clangd/" > "$GITIGNORE_GLOBAL"

echo "✅ Git configured"

# ============================================
# Zsh Aliases & Tools
# ============================================
echo "\n🔧 Setting up zsh aliases..."

ZSHRC="$HOME/.zshrc"

# Backup .zshrc if it exists
if [ -f "$ZSHRC" ]; then
    cp "$ZSHRC" "${ZSHRC}.backup.$(date +%Y%m%d_%H%M%S)"
    echo "📦 Backed up existing .zshrc"
fi

# Remove old dev setup section if it exists
sed -i '/# === DEV SETUP ===/,/# === END DEV SETUP ===/d' "$ZSHRC" 2>/dev/null

# Append new configuration
cat >> "$ZSHRC" << 'EOF'

# === DEV SETUP ===
# Editor shortcuts
alias c="code"
alias cu="cursor"

# CMake shortcuts
alias cmaked='cmake -DCMAKE_BUILD_TYPE=Debug -B build && cmake --build build'
alias cmaker='cmake -DCMAKE_BUILD_TYPE=Release -B build && cmake --build build'
alias cmakeclean='rm -rf build'

# Zoxide (smart cd)
eval "$(zoxide init zsh)"

# LLDB/GDB shortcuts
alias lldb-run='lldb -o run'
alias gdb-run='gdb -ex run'
# === END DEV SETUP ===
EOF

echo "✅ Zsh aliases added to ~/.zshrc"

# ============================================
# Cursor Settings
# ============================================
echo "\n⚙️  Configuring Cursor..."

CURSOR_CONFIG_DIR="$HOME/.config/Cursor/User"
CURSOR_SETTINGS="$CURSOR_CONFIG_DIR/settings.json"

# Create config directory if it doesn't exist
mkdir -p "$CURSOR_CONFIG_DIR"

# Write Cursor settings
cat > "$CURSOR_SETTINGS" << 'EOF'
{
  "editor.formatOnSave": true,
  "files.trimTrailingWhitespace": true,
  "git.blame.editorDecoration.enabled": false,
  "editor.multiCursorModifier": "ctrlCmd",
  "editor.rulers": [100]
}
EOF

echo "✅ Cursor settings configured"

# ============================================
# Verification
# ============================================
echo "\n🔍 Verifying setup..."

echo "\nGit aliases:"
git config --global --get-regexp alias

echo "\nZoxide version:"
zoxide --version

# ============================================
# Finish
# ============================================
echo "\n✨ Setup complete!"
echo "\n📌 Next steps:"
echo "1. Restart your terminal or run: source ~/.zshrc"
echo "2. Test aliases: git st, git lg, cmaked, z <directory>"
echo "\n💡 Your old .zshrc was backed up with timestamp"