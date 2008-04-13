Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from fg-out-1718.google.com ([72.14.220.159])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <bikalexander@gmail.com>) id 1Jl8N0-0001Vg-5U
	for linux-dvb@linuxtv.org; Sun, 13 Apr 2008 22:00:13 +0200
Received: by fg-out-1718.google.com with SMTP id 22so1587112fge.25
	for <linux-dvb@linuxtv.org>; Sun, 13 Apr 2008 13:00:04 -0700 (PDT)
Message-ID: <39d4b8530804131300i11fd03ebt1fea354209a7ee43@mail.gmail.com>
Date: Sun, 13 Apr 2008 22:00:04 +0200
From: Bikalexander <bikalexander@gmail.com>
To: linux-dvb@linuxtv.org
MIME-Version: 1.0
Content-Disposition: inline
Subject: [linux-dvb] Scan found no PIDs (NIT and TID)
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Hello,

When I'm using the scan with option -o vdr I have the problem with
some channels into channels.conf.
In channels.conf for some of them channels the TID & NID pids are missing

for example
#########################
Sirius:
# cat /channels/S4.8E_channels.conf|grep :0:0:0$
B4U;DEFAULT PROVIDER:12302:h:S0.0W:25546:1260:1220:0:0:11:0:0:0
Universal TV;DEFAULT PROVIDER:12302:h:S0.0W:25546:1360:1320:0:0:12:0:0:0
OU Enterprise;DEFAULT PROVIDER:12302:h:S0.0W:25546:1460:1420:0:0:13:0:0:0
Disc_Romania;DEFAULT PROVIDER:12302:h:S0.0W:25546:1560:1520,1522:0:0:14:0:0:0
.........
###################################
Hotbird:
# cat /channels/S13.0E_channels.conf|grep :0:0:0$
Servizio 23;(null):11432:v:S0.0W:27500:710:711=ita,712=Oth:0:0:23:0:0:0
Servizio 24 ;(null):11432:v:S0.0W:27500:720:721=ita,722=Oth:0:0:24:0:0:0
Servizio 25;(null):11432:v:S0.0W:27500:730:731=ita,732=Oth:0:0:25:0:0:0
......

Amos:
# cat /channels/S4.0W_channels.conf|grep :0:0:0$
K1;SPACECOM:10722:h:S0.0W:27500:257:258:0:0:1:0:0:0
OTV;SPACECOM:10722:h:S0.0W:27500:513:514:0:0:2:0:0:0
1PLUS1;SPACECOM:10722:h:S0.0W:27500:769:770,771:773:0:3:0:0:0
TV KYIV;SPACECOM:10722:h:S0.0W:27500:1025:1026:0:0:4:0:0:0
MEGASPORT;SPACECOM:10722:h:S0.0W:27500:1281:1282:0:0:5:0:0:0
K2;SPACECOM:10722:h:S0.0W:27500:1537:1538:0:0:6:0:0:0
1PLUS1 Intern-l;SPACECOM:10722:h:S0.0W:27500:1793:1794:0:0:7:0:0:0
1PLUS1 CINEMA;SPACECOM:10722:h:S0.0W:27500:2049:2050,2051:0:0:8:0:0:0
..........

the full list this channels with missing pids you can find here
http://upload.sat-universum.de/down/channels/no-tid-nid-channels.conf

the log of scan -vvv
http://upload.sat-universum.de/down/channels/scan.log

 My system:
 Debian ETCH
 Techno Trend Premium (Full Featured) S2300 V 2.3 "modified"
 Latest version of Scan from http://linuxtv.org/hg/dvb-apps/
 a list of log is created where the two missing PIDs

Scan has started with the following options:
$ scan -o vdr -p -a 0 -f 0 -d 0 -t 3 -5 -vvv  S4.0W.ini > S4.0W_channels.conf

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
