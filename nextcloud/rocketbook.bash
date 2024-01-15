!/bin/bash
MAILDIR=/root/nextcloud/mails/INBOX/cur
DESTINATION=/root/nextcloud/nextcloud/data/manuel/files/Obsidian/handwritten-notes

offlineimap
mkdir /tmp/rocketbook
cd /tmp/rocketbook
echo "start unpacking files"
for i in `ls $MAILDIR`
do
    echo $i
    munpack -tf $MAILDIR/$i
    # munpack -t -C /tmp/rocketbook < "$MAILDIR/$i"
    rm $MAILDIR/$i

done
echo "start moving files"
#rm ./*.desc
find . -type f ! -name '*.pdf' -delete
cp ./* $DESTINATION
rm -rf /tmp/rocketbook
chown -R www-data:www-data $DESTINATION
docker exec --user www-data nextcloud-app /var/www/html/occ files:scan manuel
offlineimap
