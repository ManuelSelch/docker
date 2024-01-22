!/bin/bash
TMP=/tmp/rocketbook
MAILDIR=/root/nextcloud/mails/INBOX/cur
PROCESSEDDIR=/root/nextcloud/mails/Processed/cur
CONTAINER=10199f82490a # nextcloud-app container id
NOTES=/var/www/html/data/manuel/files/Obsidian/handwritten-notes

offlineimap
mkdir $TMP
cd $TMP
echo "start unpacking files"
for i in `ls $MAILDIR`
do
    echo $i
    munpack -tf $MAILDIR/$i
    # munpack -t -C /tmp/rocketbook < "$MAILDIR/$i"
    mv $MAILDIR/$i $PROCESSEDDIR/$i

done
echo "start moving files"
#rm ./*.desc
find . -type f ! -name '*.pdf' -delete
docker cp $TMP/. $CONTAINER:$NOTES
rm -rf /tmp/rocketbook
docker exec nextcloud-app su -s /bin/bash -c "chown -R www-data:www-data $NOTES"
docker exec --user www-data nextcloud-app /var/www/html/occ files:scan manuel
offlineimap
