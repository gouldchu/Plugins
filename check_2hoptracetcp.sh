#! /bin/bash
PROG="sudo /bin/traceroute -n -T"
GREP="/bin/egrep"
HOST=$1
FILE=/tmp/check_tracert-`date +%N`.txt
START="$2"
LAST="$3"

if [ $# -lt 2 ]
  then
    echo "Usage: check_tracert [host] [ip we should route via] [last hop]"
  exit 2
fi

$PROG $HOST > $FILE

RESULT=`$GREP -c "($START|$LAST)" $FILE`

case "$RESULT" in
  0) echo "CRITICAL! Routing not matching!!!"
     rm -f $FILE
     echo $RESULT > /tmp/result
     exit 2
  ;;

  1) echo "WARNING! One hop route not found!" 
     rm -f $FILE
     echo $RESULT > /tmp/result
     exit 1
  ;;
  
  2) echo "OK! Currently routing via $LAST" 
     rm -f $FILE
     echo $RESULT > /tmp/result
     exit 0
  ;;
  
  *) echo "UNKNOWN!"
     rm -f $FILE
     echo $RESULT > /tmp/result
     exit 3
esac

