# install dependencies
cargo install nu gitui starship

# initialize submodule(s)
git submodule init
git submodule update

# setup gitui config
ln -s ~/.dotfiles/gitui/key_bindings.ron ~/.config/gitui/key_bindings.ron
ln -s ~/.dotfiles/gitui/key_symbols.ron ~/.config/gitui/key_symbols.ron
ln -s ~/.dotfiles/gitui/theme.ron ~/.config/gitui/theme.ron

# setup lazygit
ln -s ~/.dotfiles/lazygit/config.yml `~/Library/Application Support/lazygit/config.yml`

# setup neovim
ln -s ~/.dotfiles/neovim/init.lua ~/.config/nvim/init.lua

# setup nushell
ln -s ~/.dotfiles/nushell/env.nu `~/Library/Application Support/nushell/env.nu`
ln -s ~/.dotfiles/nushell/config.nu `~/Library/Application Support/nushell/config.nu`

# setup zellij
ln -s ~/.dotfiles/zellij ~/.config/zellij
