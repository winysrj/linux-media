Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from wf-out-1314.google.com ([209.85.200.170])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <vivichrist@gmail.com>) id 1Jt24k-0000cv-Kq
	for linux-dvb@linuxtv.org; Mon, 05 May 2008 16:54:03 +0200
Received: by wf-out-1314.google.com with SMTP id 27so986426wfd.17
	for <linux-dvb@linuxtv.org>; Mon, 05 May 2008 07:53:53 -0700 (PDT)
Message-ID: <481F1F7E.1030406@gmail.com>
Date: Tue, 06 May 2008 02:53:50 +1200
From: vivian stewart <vivichrist@gmail.com>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] LNB: L.O is 11300
Reply-To: vivichrist@gmail.com
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

  I think I may know what is wrong ... my LNB is weird well ... not for 
this part of the world so I think I need to make a custom sec.conf or 
something? any Ideas? I can watch tv with 'dvbstream...|mplayer' and 
'mplayer dvb://' works with an edited channels.conf and 'scan -l 
11300,11300,1 OptusD1' works on all listed transponders (file) from 
lyngsat. but no programs seem to tune to a list of actual transponders, 
including mythtv (finds channels and epg data but can't tune in channels).
am I doomed to watch tv with mplayer and no remote control?

L.O is 11300
card is HVR3000

dvbsnoop -s pidscan
Quote:
Basic capabilities:
Name: "Conexant CX24123/CX24109"
Frontend-type: QPSK (DVB-S)
Frequency (min): 950.000 MHz
Frequency (max): 2150.000 MHz
Frequency stepsiz: 1.011 MHz
Frequency tolerance: 5.000 MHz
Symbol rate (min): 1.000000 MSym/s
Symbol rate (max): 45.000000 MSym/s
Symbol rate tolerance: 0 ppm
Notifier delay: 0 ms
Frontend capabilities:
auto inversion
FEC 1/2
FEC 2/3
FEC 3/4
FEC 4/5
FEC 5/6
FEC 6/7
FEC 7/8
FEC AUTO
QPSK

viv.

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
