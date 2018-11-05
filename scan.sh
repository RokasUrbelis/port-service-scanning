#!/bin/bash
##welcome to use my sciprt       
echo "The scirpt by qq1798996632,welocme to visit me."
trap "echo 'STOP ERROR'" SIGINT
trap "echo 'Bye~'" EXIT
NULL=/dev/null
PV_URL='http://ftp.br.debian.org/debian/pool/main/p/pv/pv_1.6.0-1+b1_amd64.deb'
PV_i3URL='http://ftp.br.debian.org/debian/pool/main/p/pv/pv_1.6.0-1+b1_i386.deb'
PV_URL_C='http://dl.fedoraproject.org/pub/epel/6/x86_64/Packages/p/pv-1.1.4-3.el6.x86_64.rpm'
PV_i3URL_C='http://dl.fedoraproject.org/pub/epel/6/i386/Packages/p/pv-1.1.4-3.el6.i686.rpm'
RELEASE=$(cat /etc/issue|awk '{print $1}'|sed -ne '1p')
ARCH=$(uname -a|awk -F '[.| ]+' '{print $9}')
[ $RELEASE = 'CentOS' ] && CENTOS_PV=$(rpm -eq pv >& $NULL && echo $?)
[ $RELEASE = 'Kali' ] && KALI_PV=$(dpkg -s pv >& $NULL && echo $?)
[ $RELEASE != 'CentOS' -a $RELEASE != 'Kali' ] && echo "Your system don't support the scirpt" && exit 1
[ $RELEASE != 'CentOS' -a $RELEASE != 'Kali' ] && exit 1
[ $RELEASE = 'CentOS' ] && INSTALL="sudo yum install -y" || ([ $RELEASE = 'Kali' -o $RELEASE = 'Debian' ] && INSTALL="sudo apt-get install -y")

function FILTER()   ##filter the scan result 
{
  sleep 2
  cat result|sed -ne '/Nmap scan/,+3p'|grep -vE "host down|Nmap done|Read data|Raw pa"|grep "Nmap scan"|awk '{print $5}' > ipv4 
  cat result|sed -ne '/Nmap scan/,+3p'|grep -vE "host down|Nmap done|Read data|Raw pa"|grep '[[:digit:]]/' >portv4 
  for i in ipv4  port statu service version;do touch $i;done && awk '{print $1}' portv4 > port && awk '{print $2}' portv4 > statu && \
  awk '{print $3}' portv4 > service && awk '{print $4" "$5}' portv4 >version 
  paste ipv4  port statu service version|sed '1 itest'|awk -F \
     '[ ]+' 'NR==1 {printf "%-16s%-8s%-8s%-8s%-12s","IP","PORT","STATUS","SERVICE","VERSION\n"} \
     NR>=2 {printf "%16s%-8s%-9s%-12s%-12s\n",$1,$2,$3,$4,$5}'|awk '{printf "%-20s%-12s%-14s%-14s%-12s\n",$1,$2,$3,$4,$5}'\
     |sort -n|tee $(date "+%F-%H:%M").RESULT && echo && echo -e "[Scan Finished!]" && echo \
     "Successfully scanned $(expr $(cat $(ls -rt|tail -1)|wc -l) - 1) targets" && \
      RESULT=$(ls -rlt *.RESULT|awk '{print $9}'|sed -ne '$p'); echo && echo "Scan result saved to ==> '$(pwd)/$RESULT'" && echo 
}
function DOS2UNIX()  ##check and install dos2unix
{
    WIN_LIN=$(head -1 $2|cat -A); LAST=${WIN_LIN:0-3}  ##检查文件是否是Windows文件格式
    if [ "$LAST" = '^M$' ];then 
       if [ "$RELEASE" = 'CentOS' -o $RELEASE = 'RedHat' ]; then 
        rpm -eq dos2unix >& $NULL

         CONFIRM=$(echo $?)
       elif [ "$RELEASE" == 'Kali' -o "$RELEASE" == 'Debian' ]; then
            dpkg -s dos2unix >& $NULL && CONFIRM=$(echo $?)
       fi

              if [ "$CONFIRM" = '0' ];then

               dos2unix $2 >& $NULL

              elif [[ "$CONFIRM" != '0' ]];then 
                    $INSTALL dos2unix >& $NULL && INSTALL_CONFIRM=`echo $?`      #install dos2unix
                   if [ "$INSTALL_CONFIRM" == '0' ];then 
                        dos2unix $2 >& $NULL
                   else  echo "Sorry,your file is windows file,and I can't convert it to unix file,error reason:install 'dos2unix' false,you can \
                            manual installation it then run the scirpt" && exit 1
                    fi 
              fi
    fi
}
function INSTALL_CHECK()  ##check and install pv
{
if [ $CENTOS_PV != 0 ];then
 [ $RELEASE = 'CentOS' -a $ARCH = 'x86_64' ] && { wget -q $PV_URL_C >& $NULL; sudo rpm -ih $(basename $PV_URL_C) >& $NULL &&\
 rm -f `basename $PV_URL_C` || echo 'install pv error' && exit 1 ;}

 [ $RELEASE = 'CentOS' -a $ARCH = 'i386' ] && { wget -q $PV_i3URL_C >& $NULL; sudo rpm -ih $(basename $PV_i3URL_C) >& $NULL &&\
 rm -f `basename $PV_i3URL_C`|| echo 'install pv error' && exit 1 ;}
fi
if [ "$KALI_PV" != '0' ];then
 [ $RELEASE = 'Kali' -a $ARCH = 'x86_64' ] && { wget -q $PV_URL >& $NULL; sudo dpkg -i `basename $PV_URL` >& $NULL &&\
 rm -f `basename $PV_URL` || echo 'install pv error' && exit 1 ; }

 [ $RELEASE = 'Kali' -a $ARCH = 'i386' ] && { wget -q $PV_i3URL >& $NULL; sudo dpkg -i `basename $PV_i3URL` >& $NULL &&\
 rm -f `basename $PV_i3URL` || echo "install pv error" && exit 1; }
fi
 }
function DISTORY()   ##finished filter data and destroy the generated file
{
 shred -f -u -z result ipv4 portv4 port statu service version >$NULL 2>&1   
}

#######################main############################

#INSTALL_CHECK  ###安装pv和检查pv是否安装成功，如不需要实时同步可以注释掉

[ -e "result" ] && cat $NULL > result || touch result 
while [ -n '$1' ]
do 
case  "$1" in 
  -f) 

    if [ -f $2 ];then
       DOS2UNIX && echo -n "Scanning..."     
        while read line
        do 
          IP=$(echo $line|sed -ne 's/\([[:digit:]]\{1,3\}.*\):[[:alnum:]].*$/\1/gp') 
          PORT=$(echo $line|sed -ne 's@^.*:\([[:digit:]].\)@\1@gp') 
          (nmap -sV -p $PORT -n -Pn $IP >> result 2>&1) &
        done < $2
           judgment=$(jobs -l|wc -l)     ##monitoring background process...
           sleep 2 && echo -ne '##### (33%)\r'
          # sleep 2 |pv && echo -ne '##### (33%)\r'  ##使用pv执行实时同步,如不使用实时同步，则去掉|pv       
           while [ $judgment != '1' ];do
             #sleep 3|pv &&  judgment=$(jobs -l|wc -l)
             sleep 3 && judgment=$(jobs -l|wc -l)
              if [ $judgment = '1' ];then
                echo -ne '######################### (66%)\r' && 
                sleep 3 && echo -ne '######################################## (100%)\r' && echo -ne '\n' && FILTER  &&  break
              fi  
           done && DISTORY

    elif [ -d $2 ];then
         echo "scan: $2 is a drecrory"
    else
         echo "scan: $2:No such file or directory"
    fi;; 
  "-h") echo '-f [file] '
        echo '          file format: ipv4adress1:port1'
        echo '                       ipv4adress2:port2';;
  *)
     echo "Usage:" 
     echo "       scan [-f file]"
     echo '                      file format: ipv4adress1:port1'
     echo '                                   ipv4adress2:port2'
     echo "       scan [-h]"
     exit 1;;
  esac
break
done
exit 0
