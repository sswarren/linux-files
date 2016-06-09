# My bash customizations.  Called from .bashrc at startup.

export PATH=$HOME/bin:$PATH

# export ANT_HOME=/c/Tools/apache-ant-1.9.2
# export ANT_HOME=$APP_HOME/ant
export PATH=$PATH:$ANT_HOME/bin

# default command prompt
#export PS1='\[\e]0;\w\a\]\n\[\e[32m\]\u@\h \[\e[33m\]\w\[\e[0m\]\n\$ '
export PS1='\[\e]0;\w\a\]\n\[\e[32m\]\u@\h \[\e[33m\]\w\[\e[0m\] \[\e[36m\]($(gitbranch))\[\e[0m\]\n\$ '
