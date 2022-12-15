# by RouterOS 6.49.6
# Two Scheduler for daily reboot and running dynip script
/system scheduler
add interval=1d name=reboot_daily on-event="/system reboot" policy=\
    ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon \
    start-date=nov/09/2022 start-time=06:30:00
add interval=1d name=ipbaruhariini on-event=dynip policy=\
    ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon \
    start-date=nov/09/2022 start-time=06:35:00
# Geeting dynamic ip from provider and send to Telegram
/system script
add dont-require-permissions=yes name=dynip owner=admin policy=\
    ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon source=":\
    local bot \"1425437090:AAE7PxeXQOcjUUg_Nehm_-dSXuX75Jp8G2g\";\r\
    \n:local chat \"-417789563\";\r\
    \n:local tanggal \"reboot_daily: \$[/system clock get date] %0A\";\r\
    \n:local ip (.[/ip address get [find interface=\"pppoe-ISP-A\"] address].\
    \"%0A\")\r\
    \n/tool fetch url=\"https://api.telegram.org/bot\$bot/sendmessage\?chat_id\
    =\$chat&text=\$tanggal \\E2\\9C\\85 [NEW] DYNAMIC IP (ISP-A): %0A\$ip\" ke\
    ep-result=no;"
