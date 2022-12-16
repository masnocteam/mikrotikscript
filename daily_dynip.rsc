# by @afrahman23
# Two Scheduler for daily reboot, and send 'dynip' to Telegram
/system scheduler
add interval=1d name=daily_reboot on-event="/system reboot" policy=\
    ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon \
    start-date=nov/09/2022 start-time=03:30:00
add interval=1d name=daily_dynip on-event=":local bot \"yourtokenbot\";\r\
    \n:local chat \"yourchatid\";\r\
    \n:local tanggal \"reboot_daily: \$[/system clock get date] %0A\";\r\
    \n:local ip (.[/ip address get [find interface=\"pppoe-ISP-A\"] address].\
    \"%0A\")\r\
    \n/tool fetch url=\"https://api.telegram.org/bot\$bot/sendmessage\?chat_id\
    =\$chat&text=\$tanggal \\E2\\9C\\85 [NEW] DYNAMIC IP (ISP-A): %0A\$ip\" ke\
    ep-result=no;" policy=\
    ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon \
    start-date=nov/09/2022 start-time=03:35:00
