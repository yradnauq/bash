#
# Common Bourne/Bash Functions for Unix/Linux Operating Systems
#
# libcolors.sh
#
# Color variables and functions
#
# Source these in other scripts with this syntax (without the "# "):
# . lib/libcolors.sh
#
#
#################################################################################
# Color Variables
#################################################################################
# NOTE: use colors in screen output like this:
# echo "${COLOR_RED}Some Text Here${COLOR_RESET}"
#
# Test whether ${USE_LIB_COLORS} is set and use colors if it is
# test -z "${USE_LIB_COLORS}" && echo "Status message text" || echo "${COLOR_BG_GREEN}Status message text${COLOR_RESET}"
#
# Test whether $USE_LIB_COLORS is set and use colors if it is
# if [ ! -z "${USE_LIB_COLORS}" ]; then
#       echo "${COLOR_BG_GREEN}Status message text${COLOR_RESET}"
# else
#       echo "Status message text"
# fi
#
# In reality though it shouldn't matter if you reference undefined variables in echo output strings,
# if the colors variables aren't defined then just the text message itself will be output
#

# Set whether colors should be used in other scripts/functions
USE_LIB_COLORS="yes"

# Normal colors
COLOR_RESET="^[[0m"
COLOR_BLACK="^[[0;30m"
COLOR_RED="^[[0;31m"
COLOR_GREEN="^[[0;32m"
COLOR_YELLOW="^[[0;33m"
COLOR_BLUE="^[[0;34m"
COLOR_MAGENTA="^[[0;35m"
COLOR_CYAN="^[[0;36m"
COLOR_LGRAY="^[[0;37m"
COLOR_NORMAL="^[[0;39m"

# Light colors
COLOR_DGRAY="^[[0;90m"
COLOR_LRED="^[[0;91m"
COLOR_LGREEN="^[[0;92m"
COLOR_LYELLOW="^[[0;93m"
COLOR_LBLUE="^[[0;94m"
COLOR_LMAGENTA="^[[0;95m"
COLOR_LCYAN="^[[0;96m"
COLOR_WHITE="^[[0;97m"

# Bold colors
COLOR_BRED="^[[1;31m"
COLOR_BGREEN="^[[1;32m"
COLOR_BYELLOW="^[[1;33m"
COLOR_BBLUE="^[[1;34m"
COLOR_BMAGENTA="^[[1;35m"
COLOR_BCYAN="^[[1;36m"
COLOR_BGRAY="^[[1;37m"

# Background colors
COLOR_BG_GREEN="^[[1;42;37m"
COLOR_BG_BLUE="^[[1;44;37m"
#BG_GREEN="^[[42m^[[1m"

# Normalize colors
COLOR_NORMAL="^[[0;39m"
COLOR_RESET="^[[0m"

# EOF
