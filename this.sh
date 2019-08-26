#!/bin/sh

# Give me startdate here
startdate="2019-07-29"

# Give me the limit number
limit=5

# Give me base URL
baseUrl=https://www.nseindia.com/content/historical/EQUITIES


# Start Downloading files
i=1
while [ "$i" -le "$limit" ]; do
  currentDate=$(date "+%d%^b%Y" -d "${startdate} +${i} days");
  currentMonth=$(date "+%^b" -d "${startdate} +${i} days");
  currentYear=$(date "+%Y" -d "${startdate} +${i} days");
  echo "------"
  echo "Downloading ZIP for date: $currentDate"
  curl "${baseUrl}/${currentYear}/${currentMonth}/cm${currentDate}bhav.csv.zip" --output "./downloadedFiles/${currentDate}.zip"
  echo "Download complete."
  echo "Checking File now"

  currentFile=$(cat "./downloadedFiles/${currentDate}.zip" | grep "404")
  if [ -z "$currentFile" ]
  then
	  echo "File found and is good to Unzip. Let me unzip.."
	  unzip ./downloadedFiles/${currentDate}.zip -d ./downloadedUnzipedFiles/
	  currentDateFormatted=$(date -d"${currentDate}" +%Y-%m-%d)	  
	  grep "EQ" "./downloadedUnzipedFiles/cm${currentDate}bhav.csv" | awk -F, '{print $1 ", " cfd ", " $3 ", " $4 ", " $5 ", " $6 ", " $9}' cfd=${currentDateFormatted} > ./finalFiles/${currentDateFormatted}.csv
  else
	  echo "File was not found when trying to download. Removing this file from local."
	  rm ./downloadedFiles/${currentDate}.zip
  fi
  echo ""
  i=$(($i+1))
done

echo "Download complete. Enjoy your day."
