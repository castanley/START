#!/bin/bash
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# Script Name:  start.sh
# Script Desc:  [S]tanley's [T]rusty [A]utomated [R]egistering [T]ool
# Script Date:  12/2/2015
# Created By:   Christopher Stanley
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#!/bin/bash

# while-menu-dialog: a menu driven system information program

DIALOG_CANCEL=1
DIALOG_ESC=255
HEIGHT=15
WIDTH=50

display_result() {
  dialog --title "$1" \
    --no-collapse \
    --msgbox "$result" 0 0
}

menu1() {

while true; do
  exec 3>&1
selection=$(dialog \
        --backtitle "[S]tanley's [T]rusty [A]utomated [R]egistering [T]ool" \
        --title "Menu" \
        --clear \
        --cancel-label "Exit" \
        --menu "Please select:" $HEIGHT $WIDTH 5 \
        "1" "Configure IP Address" \
        "2" "Register to Satellite" \
        "3" "Tools" \
        "4" "Exit" \
        2>&1 1>&3)
      exit_status=$?
      exec 3>&-
      case $exit_status in
        $DIALOG_CANCEL)
          clear
          echo "Program terminated."
          exit
          ;;
        $DIALOG_ESC)
          clear
          echo "Program aborted." >&2
          exit 1
          ;;
      esac

      case $selection in
        0 )
          clear
          echo "Program terminated."
          ;;
        1 )
           exec 3>&1
            input=$(dialog \
                --backtitle "[S]tanley's [T]rusty [A]utomated [R]egistering [T]ool" \
                --inputbox "Enter I.P Address" 0 0 \
                2>&1 1>&3)
            result=$(echo "Changed IP to $input")
            exit_status=$?
            exec 3>&-

            case $input in
              0)
              display_result "$exit_status";;
              1)
              echo "Cancel pressed.";;
            esac
          ;;
        2 )
          result=$(echo "Not Implemented yet.")
          display_result "Sorry!"
          ;;
        3 )
            while true; do
            exec 3>&1
            selection=$(dialog \
                --backtitle "[S]tanley's [T]rusty [A]utomated [R]egistering [T]ool" \
                --title "Menu" \
                --clear \
                --cancel-label "Exit" \
                --menu "Please select:" $HEIGHT $WIDTH 4 \
                "1" "<-- Back" \
                "2" "Display System Information" \
                "3" "Display Disk Space" \
                "4" "Display Home Space Utilization" \
                2>&1 1>&3)
              exit_status=$?
              exec 3>&-
              case $exit_status in
                $DIALOG_CANCEL)
                  clear
                  echo "Program terminated."
                  exit
                  ;;
                $DIALOG_ESC)
                  clear
                  echo "Program aborted." >&2
                  exit 1
                  ;;
              esac
              case $selection in
                0 )
                  clear
                  echo "Program terminated."
                  ;;
                1 )
                  menu1
                  ;;
                2 )
                  result=$(echo "Hostname: $HOSTNAME"; uptime)
                  display_result "System Information"
                  ;;
                3 )
                  result=$(df -h)
                  display_result "Disk Space"
                  ;;
                4 )
                  if [[ $(id -u) -eq 0 ]]; then
                    result=$(du -sh /home/* 2> /dev/null)
                    display_result "Home Space Utilization (All Users)"
                  else
                    result=$(du -sh $HOME 2> /dev/null)
                    display_result "Home Space Utilization ($USER)"
                  fi
                  ;;
              esac
          done
          ;;
      esac
done
}
