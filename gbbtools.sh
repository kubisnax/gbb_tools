#!/bin/bash

clearGbb () {
  /usr/share/vboot/bin/set_gbb_flags.sh 0  &> /dev/null #sets gbb_flags to 0x0
}

viewGbb () {
  flashrom -r bios.bin &> /dev/null #generates bios.bin file of current ROM
  gbb_utility --get --flags bios.bin | grep -w "flags:" | tr -d "flags :" #pulls gbb_flag info from bios.bin
  rm bios.bin #deletes bios.bin file from current directory
}

setGbb() {
  flashrom -r bios.bin &> /dev/null #generates bios.bin file of current ROM
  gbb_utility --set --flags=0x$gbbSet bios.bin &> /dev/null #sets gbb_flags to user input given to gbbSet variable
  flashrom -i GBB -w bios.bin &> /dev/null #writes updated bios.bin file to ROM
  rm bios.bin #deletes bios.bin file from current directory
}

while true;do
  echo -e "\e[92mWelcome to gbb_tools\e[0m"
  echo ""
  echo -e "\e[96mWhat do you want to do with gbb_flags?\e[0m"
  echo ""
  select gbb in Reset View Set Exit
  do
    case $gbb in
      Reset )
      clearGbb
      echo -e "gbb_flags now set to \e[31m$(viewGbb)\e[0m";;
      View )
      echo -e "gbb_flags set to \e[31m$(viewGbb)\e[0m";;
      Set )
      echo "Enter gbb_flag value: "
      read -e gbbSet
      setGbb
      echo -e "gbb_flags now set to \e[31m$(viewGbb)\e[0m";;
      Exit ) exit 0;;
      * )
      echo -e "\e[31mInvalid Input\e[0m";;
    esac
  done
done



