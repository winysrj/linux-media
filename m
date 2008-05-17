Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from wa-out-1112.google.com ([209.85.146.177])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <bvidinli@gmail.com>) id 1JxJSd-0007Kv-M6
	for linux-dvb@linuxtv.org; Sat, 17 May 2008 12:16:21 +0200
Received: by wa-out-1112.google.com with SMTP id n7so656380wag.13
	for <linux-dvb@linuxtv.org>; Sat, 17 May 2008 03:16:14 -0700 (PDT)
Message-ID: <36e8a7020805170316j7e8f4cdaw2102e00b2d6d61f4@mail.gmail.com>
Date: Sat, 17 May 2008 13:16:14 +0300
From: bvidinli <bvidinli@gmail.com>
To: linux-dvb@linuxtv.org, "fahri donmez" <fahridon@gmail.com>,
	ozbilen@gmail.com
MIME-Version: 1.0
Content-Disposition: inline
Subject: [linux-dvb] merhaba: About Avermedia DVB-S Hybrid+FM A700
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-9"
Content-Transfer-Encoding: quoted-printable
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

i just compiled kernel version 2.6.26.rc2 on my ubuntu linux 8.04,
many things including sound not working, but i got finally name of my
tv/dvb card on dmesg output.
previously i was getting UNKNOWN/GENERIC on dmesg for my tv card,

 i use tvtime-scanner or tvtime, it does not scan, even analog channels,
 i use following to try new tuners, :
rmmod saa7134
modprobe saa7134 card=3D141 tuner=3D2

i run these two lines fo rtuner 0,1,2,3 and so on... to try different
tuner numbers... on some numbers, computers locks down.. i had to
reset...


currently i have two questions:
1- what is correct statements/commands to be able to scan tv channels...
2- the log says only analog inputs available now, when it will be
possible to watch dvb channels ?
3- what is best/good tutorials/sites that describe/help in
dvb/tv/multimedia for ubuntu/linux, (i already looked linuxtv,
searched google, many sites..)


thanks.


logs: dmesg,

[   39.243703] saa7133[0]: found at 0000:00:14.0, rev: 209, irq: 12,
latency: 32, mmio: 0xde003000
[   39.243776] saa7133[0]: subsystem: 1461:a7a2, board: Avermedia
DVB-S Hybrid+FM A700 [card=3D141,autodetected]
[   39.243858] saa7133[0]: board init: gpio is b400
[   39.243909] saa7133[0]: Avermedia DVB-S Hybrid+FM A700: hybrid
analog/dvb card
[   39.243915] saa7133[0]: Sorry, only the analog inputs are supported for =
now.


-- =

=DD.Bahattin Vidinli
Elk-Elektronik M=FCh.
-------------------
iletisim bilgileri (Tercih sirasina gore):
skype: bvidinli (sesli gorusme icin, www.skype.com)
msn: bvidinli@iyibirisi.com
yahoo: bvidinli

+90.532.7990607
+90.505.5667711
_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
