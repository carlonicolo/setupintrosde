#!/bin/bash      
#title           : SetUpIntroSDE.sh
#description     : This script will install the full environment for the IntroSDE course
#author		 : Carlo Nicolò aka Karlitos
#usage		 : ./SetUpIntroSDE -A
#==============================================================================

#Set
Bold=1
Blink=5

#Foreground
Default=39
Black=30
Red=31
Green=32
Yellow=33
Blue=34
Magenta=35
Cyan=36
Lgray=37
DarkGray=90
LightRed=91
LightGreen=92
LightYellow=93
LightBlue=94
LightMagenta=95
LightCyan=96
White=97

#Background
Background_Default=49m
Background_Black=40m
Background_Red=41m
Background_Green=42m
Background_Yellow=43m
Background_Blue=44m
Background_Magenta=45m
Background_Cyan=46m
Background_Lgray=47m
Background_DarkGray=100m
Background_LightRed=101m
Background_LightGreen=102m
Background_LightYellow=103m
Background_LightBlue=104m
Background_LightMagenta=105m
Background_LightCyan=106m
Background_White=107m


function optionMenu {
  echo -e "\e[$Bold;$Blink;$LightRed;$Background_White Choice an option: \e[0m"
  echo -e "\e[$Bold;32m 1 Install JDK \e[0m"
  echo -e "\e[$Bold;32m 2 Install JDK and Git \e[0m"
  echo -e "\e[$Bold;32m 3 Full installation JDK, Git and Maven \e[0m"
  echo -e "\e[$Bold;31m 4 to exit \e[0m"
  echo " "
  read answer
  case $answer in
  '1')
      echo "Installing jdk"
      installjdk
      ;;

  '2')
      echo "Install jdk and Git"
      installjdk
      installGit
      ;;
  
  '3')
      echo "Full installation: jdk, Git and Maven"
      installjdk
      installGit
      installMaven
      ;;
      
  '4')
      exit 0
      ;;

  *)
      echo -e "\e[$Bold;31m Invalid request choice an option \e[0m"
      conferma
      ;;
     
   esac
}

#This function will install jdk. You need to download the jdk from Oracle website
#and put the jdk1.8.* in the same folder of the scritp
function installjdk {
  apt-get --yes --force-yes install curl
  if [ $( arch) == 'x86_64' ] ; then
     echo 'Downloading JDK 64bit...'
     curl -o jdk-8u60-linux-x64.tar.gz http://www.carlonicolo.com/IntroSDE/jdk-8u60-linux-x64.tar.gz
  else
     echo 'Downloading JDK 32bit...'
     curl -o jdk-8u60-linux-i586.tar.gz http://www.carlonicolo.com/IntroSDE/jdk-8u60-linux-i586.tar.gz
  fi  
  
  #Download the JDK 
#  echo 'Downloading jdk-8u60-linux-i586.tar.gz'
#  curl -o jdk-8u60-linux-i586.tar.gz http://www.carlonicolo.com/IntroSDE/jdk-8u60-linux-i586.tar.gz
  mkdir /usr/local/jvm/
  tar -xvf jdk-*.tar.gz
  mv jdk1.8.* jdk1.8.0
  mv jdk1.8.0 /usr/lib/jvm/

  update-alternatives --install "/usr/bin/java" "java" "/usr/lib/jvm/jdk1.8.0/bin/java" 1
  update-alternatives --install "/usr/bin/javac" "javac" "/usr/lib/jvm/jdk1.8.0/bin/javac" 1
  update-alternatives --install "/usr/bin/javaws" "javaws" "/usr/lib/jvm/jdk1.8.0/bin/javaws" 1 

  update-alternatives --config java
  update-alternatives --config javac
  update-alternatives --config javaws

  echo ""
  echo "Fine script, verifico la versione della jdk \n"
  java -version

  echo ""  
  echo "Java installed"
  }
  
  
  
  
  

#This function will install and configure git 
function installGit {
  echo ""
  echo "I'm going to install git and kdiff3"
  apt-get --yes --force-yes install git kdiff3
  
  echo ""
  echo "***** Configuring git *****"
  
  echo ""
  echo "Type the username to use in git"
  read username

  echo ""
  echo "Type the email to use in git"
  read email

  git config --global user.name $username
  git config --global user.email $email
  
  git config --global color.ui true
  git config --global color.status auto
  git config --global color.branch auto
  git config --global core.editor nano
  git config --global merge.tool kdiff3
  
  echo ""
  echo "Let's see if your configuration is right "
  git config --list
  
  echo ""
  echo "Git installed and configured !"
  
  user=$(logname)
  echo $user
  cd
  cp .gitconfig /home/$user

}



function installMaven {
  echo ""
  apt-get --yes --force-yes install maven
}


#Create a log file with the installed version of JDK, Git and Maven
function logInstalltionFile {
  echo "*** Java version ***" >> installationLog.txt 
  java -version 2>> installationLog.txt
  echo "" >> installationLog.txt

  echo "*** Git version ***" >> installationLog.txt 
  git --version >> installationLog.txt
  echo "" >> installationLog.txt

  echo "*** Maven version ***" >> installationLog.txt 
  mvn -version >> installationLog.txt
}



echo -e '\E[37;44m'"\033[1m*** Script for updating software and system ***\033[0m"
if [ "$1" == "-A" ] ; then
   echo -e "\e[$Bold;$Blink;$Green;$Background_White Install full environment: JDK, GIT and Maven \e[0m" #1°  è il Blink,2° foreground(text),3° foreground(text), 4° colore testo, 5° background
   installjdk
   installGit
   installMaven
   logInstalltionFile
else
   optionMenu
fi
