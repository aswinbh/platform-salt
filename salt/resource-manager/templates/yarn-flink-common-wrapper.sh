#!/usr/bin/env bash
# Find which script to call
CALLER_DIR="$(cd "`dirname "$0"`"; pwd)"
CLI=`basename "$0"`
EXECUTABLE="/opt/pnda/flink-1.4.0/bin/flink"

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
    *)
      KEEP+=("$1")
      shift
      ;;
  esac
done

# define the appropriate queue according to the policy
echo "REQUEST----- $REQUEST"
QUEUE=`/opt/pnda/rm-wrapper/yarn-policy.sh $REQUEST`
EXIT_CODE=$?
if [ $EXIT_CODE -ne 0 ]; then
  echo "Warning: yarn-policy returned exit $EXIT_CODE:  $QUEUE" >> /var/log/pnda/wrapper.log
  QUEUE=''
fi

# assemble the arguments and call the function
if [ "X$QUEUE" != "X" ]; then
    echo "${KEEP[@]:0:3} -yqu $QUEUE ${KEEP[@]:3}"
    exec "$EXECUTABLE" `echo "${KEEP[@]:0:3} -yqu $QUEUE ${KEEP[@]:3}"`
    # exec "$EXECUTABLE" `echo "${KEEP[0]} ${KEEP[1]} ${KEEP[2]} -yqu $QUEUE ${KEEP[@]:3}"`
else
    echo "$REQUEST queue is not exist or user is not authorized to use $REQUEST queue"
    exit 1    
fi

