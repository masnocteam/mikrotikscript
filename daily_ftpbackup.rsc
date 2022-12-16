# by @afrahman23
# Scheduler for daily backup .backup and .rsc files
# 1. ftp config
# 2. date format for file names
# 3. /export file and /system backup to flash
# 4. /tool fetch for upload to ftp server
# 5. remove from flash after 40 seconds
# 6. Loggging!
/system scheduler
add name=daily_backupfile on-event="# ftp config -!change the variables only here!-\r\
    \n:local ftpip \"192.168.xx.xx\";\r\
    \n:local ftpport \"yourftport\";\r\
    \n:local ftpuser \"ftpusername\";\r\
    \n:local ftppass \"ftppassword\";\r\
    \n:local ftppath \"/NetBackup/mikrotik/\";\r\
    \n:local bot \"yourtokenbot\";\r\
    \n:local chat \"yourchatid\";\r\
    \n\r\
    \n# date format for file names\r\
    \n:local tgl [/system clock get date];\r\
    \n:local bulannya {\"jan\"=\"01\";\"feb\"=\"02\";\"mar\"=\"03\";\"apr\"=\"\
    04\";\"may\"=\"05\";\"jun\"=\"06\";\"jul\"=\"07\";\"aug\"=\"08\";\"sep\"=\
    \"09\";\"oct\"=10;\"nov\"=11;\"dec\"=12};\r\
    \n:local hari [:tonum [:pick \$tgl 4 6]];:local tahun [:tonum [:pick \$tgl\
    \_7 11]];:local bulan [:pick \$tgl 0 3];:local bln (:\$bulannya->\$bulan);\
    \r\
    \n:local tanggal \"\$tahun-\$bln-\$hari\";\r\
    \n:local backupfile ([/system identity get name] . \"-\" . \$tanggal);\r\
    \n\r\
    \n:do {\r\
    \n# /export file and /system backup to flash\r\
    \n/export file=(\"\$backupfile\"); \\\r\
    \n/system backup save name=(\"\$backupfile\");\r\
    \n\r\
    \n# /tool fetch for upload to ftp server\r\
    \n/tool fetch address=\"\$ftpip\" port=\"\$ftpport\" mode=ftp upload=yes user=\"\$f\
    tpuser\" password=\"\$ftppass\" src-path=(\"\$backupfile.rsc\") dst-path=(\
    \"\$ftppath\$backupfile.rsc\");\r\
    \n# message success to log\r\
    \n:log info message= (\"\$backupfile.rsc has been successfully uploaded to\
    \_FTP!\");\r\
    \n\r\
    \n/tool fetch address=\"\$ftpip\" port=\"\$ftpport\" mode=ftp upload=yes user=\"\$f\
    tpuser\" password=\"\$ftppass\" src-path=(\"\$backupfile.backup\") dst-pat\
    h=(\"\$ftppath\$backupfile.backup\");\r\
    \n# message success to log\r\
    \n:log info message=\"\$backupfile.backup has been successfully uploaded t\
    o FTP!\";\r\
    \n\r\
    \n# remove from flash after 40 seconds\r\
    \n:delay 40\r\
    \n/file remove \"\$backupfile.rsc\";\r\
    \n/file remove \"\$backupfile.backup\";\r\
    \n\r\
    \n# message success to log\r\
    \n:log info message=(\"All \$backupfile has been removed from flash!\");\r\
    \n:log info message=\"Done!!!\"\r\
    \n\r\
    \n# message fail to log\r\
    \n} on-error={:log warning (\"\$backupfile has failed to Upload!\"); /tool\
    \_fetch url=\"https://api.telegram.org/bot\$bot/sendmessage\?chat_id=\$cha\
    t&text=\$backupfile backup to FTP failed\" keep-result=no; }" policy=\
    ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon \
    start-date=dec/16/2022 start-time=23:00:05
