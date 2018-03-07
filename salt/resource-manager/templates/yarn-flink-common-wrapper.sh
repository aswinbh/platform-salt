#!/usr/bin/env bash
# Find which script to call
CALLER_DIR="$(cd "`dirname "$0"`"; pwd)"
CLI=`basename "$0"`
EXECUTABLE="/opt/pnda/flink-1.4.0/bin/$CLI"

# Set the queue in the argument list

REQUEST=''
KEEP=()
# Find the requested queue
# and keep all other the options
while [[ $# -gt 0 ]]
do
  case "$1" in
    -yqu)
        REQUEST="$2"
        shift 2
      ;;
    --yarnqueue)
        REQUEST="$2"
        shift 2
      ;;
	--qu)
        REQUEST="$2"
        shift 2
      ;;
    *)
      KEEP+=("$1")
      shift
      ;;
  esac
done

# define the appropriate queue according to the policy
QUEUE=`{{ policy_file_link }} $REQUEST`
EXIT_CODE=$?
if [ $EXIT_CODE -ne 0 ]; then
  echo "Warning: yarn-policy returned exit $EXIT_CODE:  $QUEUE" >> {{ log_file }}
  QUEUE=''
fi

# assemble the arguments and call the function
if [ "X$QUEUE" != "X" ]; then
    if [ $CLI == "flink" || $CLI == "pyflink.sh" ]; then
       echo "executing $EXECUTABLE ${KEEP[0]} -yqu $QUEUE ${KEEP[@]:1}"
       exec "$EXECUTABLE" `echo "${KEEP[0]} -yqu $QUEUE ${KEEP[@]:1}"`
    elif [ $CLI == "start-scala-shell.sh" ]; then
       echo "executing $EXECUTABLE ${KEEP[0]} -qu $QUEUE ${KEEP[@]:1}"
       exec "$EXECUTABLE" `echo "${KEEP[0]} -qu $QUEUE ${KEEP[@]:1}"`
    fi
else
    echo "$REQUEST queue is not exist or user is not authorized to use $REQUEST queue"
    exit 1    
fi


