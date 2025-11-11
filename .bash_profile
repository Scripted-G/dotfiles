# .bash_profile

# Get the aliases and functions
if [ -f ~/.bashrc ]; then
    . ~/.bashrc
fi

# User specific environment and startup programs
export QT_QPA_PLATFORMTHEME=qt6ct
export GNOME_KEYRING_CONTROL=/run/user/$(id -u)/keyring
