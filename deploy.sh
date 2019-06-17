#!/bin/sh
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color
printf "I ${RED}love${NC} Stack Overflow\n"

pushd $(pwd)

printf "\n${BLUE}--------------------------------------------------------${NC}\n"
printf "${YELLOW} Building hakyll site...${NC}\n"
printf "${BLUE}--------------------------------------------------------${NC}\n\n"
stack exec site rebuild

printf "\n${BLUE}--------------------------------------------------------${NC}\n"
printf "${YELLOW} Copying files to beeleebow.github.io dir...${NC}\n"
printf "${BLUE}--------------------------------------------------------${NC}\n\n"
cp -r _site/* ../beeleebow.github.io/
cd ../beeleebow.github.io

printf "\n${BLUE}--------------------------------------------------------${NC}\n"
printf "${YELLOW} Staging and commiting files...${NC}\n"
printf "${BLUE}--------------------------------------------------------${NC}\n\n"
git add .
git commit -m "deployment: $1"

printf "\n${BLUE}--------------------------------------------------------${NC}\n"
printf "${YELLOW} Pushing changes...${NC}\n"
printf "${BLUE}--------------------------------------------------------${NC}\n\n"
git push

printf "\n${BLUE}--------------------------------------------------------${NC}\n\n"
printf "${YELLOW} \xe2\x9c\x93 Done! ${NC}\n\n"

printf "Switching back to: "
popd
