hash exiftool 2>/dev/null || { echo >&2 "Exiftool not installed. Please install exiftool from your package manager."; exit 1; }

for file in *; do
ext=${file: -4}
if [[ $ext == ".jpg" || $ext == ".JPG" || $ext == ".png" || $ext == ".PNG" || $ext == "HEIC" || $ext == ".ARW" ]]; then
originaldate=$(exiftool -T -createdate $file) #read the original creation date
#replace the first two occurances of : with a / to format it correctly for date time
originaldate=${originaldate/://}
originaldate=${originaldate/://}
echo $file  $(date -d "${originaldate}") #print out the file name and the original datetime
epochoriginal=$(date -d "${originaldate}" +%s)
touch -m --date="@$epochoriginal" $file #write out to file metadata
elif [[ $ext == ".mp4" || $ext == ".MP4" ]]; then #mp4 files for some reason store the creation time in UTC
originaldate=$(exiftool -T -createdate $file)
originaldate=${originaldate/://}
originaldate=${originaldate/://}
echo $file  $(TZ=UTC date -d "${originaldate}") # same thing as before except the time is in UTC
epochoriginal=$(TZ=UTC date -d "${originaldate}" +%s)
touch -m --date="@$epochoriginal" $file
else
echo $file was not changed
fi
done
exit 0
