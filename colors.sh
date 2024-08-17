#!/bin/bash

# Define color codes
COLOR_RESET="\033[0m"
COLOR_RED="\033[0;31m"
COLOR_GREEN="\033[0;32m"
COLOR_YELLOW="\033[0;33m"
COLOR_BLUE="\033[0;34m"
COLOR_MAGENTA="\033[0;35m"
COLOR_CYAN="\033[0;36m"

# Print the ASCII boat in rainbow colors
echo -e "${COLOR_RED}  _________.__    .__        ${COLOR_RESET}"
echo -e "${COLOR_ORANGE}/   _____/|  |__ |__|_____  ${COLOR_RESET}"
echo -e "${COLOR_YELLOW}\_____  \ |  |  \|  \____ \ ${COLOR_RESET}"
echo -e "${COLOR_GREEN}/        \|   Y  \  |  |_> > ${COLOR_RESET}"
echo -e "${COLOR_CYAN}/_______  /|___|  /__|   __/ ${COLOR_RESET}"
echo -e "${COLOR_BLUE}        \/      \/   |__|    ${COLOR_RESET}"
echo -e "${COLOR_PURPLE}                             ${COLOR_RESET}"

# Print a colored prompt and read user input
read -p "$(echo -e "${COLOR_CYAN}Enter a summary of the changes make? ${COLOR_RESET}")" SUMMARY

# Print a personalized message
echo -e "${COLOR_GREEN}The following changes have been made: \n\n ${SUMMARY}!${COLOR_RESET}"
