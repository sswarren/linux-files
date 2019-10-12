# My bash customizations.  Called from .bashrc at startup.

# Store all aliases in a separate file
test -s ~/bash/.alias && . ~/bash/.alias

# Store functions in a separate file
test -s ~/bash/.functions && . ~/bash/.functions

# Set Mac colors for ls command.
export LSCOLORS=gxBxhxDxfxhxhxhxhxcxcx
# Set linux colors for ls command.
export LS_COLORS="ow=01;90:di=01;32:ln=01;33:ex=01;36"

export PATH=$HOME/bin:$PATH

# export ANT_HOME=/c/Tools/apache-ant-1.9.2
# export ANT_HOME=$APP_HOME/ant
#export PATH=$PATH:$ANT_HOME/bin

# default command prompt
#export PS1='\[\e]0;\w\a\]\n\[\e[32m\]\u@\h \[\e[33m\]\w\[\e[0m\]\n\$ '
export PS1='\[\e]0;\w\a\]\n\[\e[32m\]\u@\h \[\e[33m\]\w\[\e[0m\] \[\e[36m\]($(gitbranch))\[\e[0m\]\n\$ '
