Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail3.atlantis.sk ([80.94.52.52] helo=ocean.atlantis.sk)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <hajduk@francetech.sk>) id 1KXWNQ-0005zx-U4
	for linux-dvb@linuxtv.org; Mon, 25 Aug 2008 09:20:38 +0200
From: "Marek Hajduk" <hajduk@francetech.sk>
To: "'Goga777'" <goga777@bk.ru>
Date: Mon, 25 Aug 2008 09:20:09 +0200
MIME-Version: 1.0
In-Reply-To: <E1KW595-00086r-00.goga777-bk-ru@f61.mail.ru>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] HVR 4000 recomneded driver and firmware for VDR
	1.7.0
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
Message-Id: <E1KXWNX-00067q-Ti@www.linuxtv.org>
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>



-----Original Message-----
From: Goga777 [mailto:goga777@bk.ru] 
Sent: Thursday, August 21, 2008 10:04 AM
To: Ing.Marek Hajduk-Francetech s.r.o
Cc: linux-dvb@linuxtv.org
Subject: [?? Probable Spam] Re: [linux-dvb] HVR 4000 recomneded driver and
firmware for VDR 1.7.0

 Could somebody recomend me which driver and firmware is working without
> problem
> 
> with vdr 1.7.0 and reelbox extension eHD?

szap2 and drivers from 
http://liplianindvb.sourceforge.net/hg/

firmware from
http://steventoth.net/linux/cx24116/

> With liplianindvb I didnt have any Picture.


at first you have to try szap2 from http://liplianindvb.sourceforge.net/hg/


I have vdr 170 + h.264 patch + http://liplianindvb.sourceforge.net/hg/ +
hvr4000 and I can see any dvb-s/dvb-s2 channels without any problem

Goga

Thank You Goga for Your help, but it doesn't work in my case.
I don't know why, but with liplianindvb driver I don't have lock on any
channels at all.

Only what works for me is multiproto_plus driver and patch from 
http://www.linuxtv.org/pipermail/linux-dvb/2008-May/025844.html

Maybe I have card with different revision then You.

Here is dmesg list of cx88

[    9.190869] cx88/2: cx2388x MPEG-TS Driver Manager version 0.0.6
loaded
[    9.191815] cx88[0]: subsystem: 0070:6902, board: Hauppauge
WinTV-HVR4000 DVB-S/S2/T/Hybrid [card=68,autodetected]
[    9.191818] cx88[0]: TV tuner type 63, Radio tuner type -1
[    9.208483] cx88/0: cx2388x v4l2 driver version 0.0.6 loaded
[    9.456267] tuner' 0-0043: chip found @ 0x86 (cx88[0])
[    9.460285] tuner' 0-0061: chip found @ 0xc2 (cx88[0])
[    9.465687] tuner' 0-0063: chip found @ 0xc6 (cx88[0])
[    9.512864] cx88[0]: hauppauge eeprom: model=69009
[    9.512924] input: cx88 IR (Hauppauge WinTV-HVR400
as /class/input/input7
[    9.555713] cx88[0]/2: cx2388x 8802 Driver Manager
[    9.555713] cx88[0]/2: found at 0000:01:06.2, rev: 5, irq: 19,
latency: 248, mmio: 0xdd000000
[    9.555713] cx88[0]/0: found at 0000:01:06.0, rev: 5, irq: 19,
latency: 248, mmio: 0xdf000000
[    9.555713] cx88[0]/0: registered device video0 [v4l2]
[    9.555713] cx88[0]/0: registered device vbi0
[    9.555713] cx88[0]/0: registered device radio0
[    9.555713] cx88[0]/1: CX88x/0: ALSA support for cx2388x boards
[    9.747601] cx88/2: cx2388x dvb driver version 0.0.6 loaded
[    9.747601] cx88/2: registering cx8802 driver, type: dvb access:
shared
[    9.747601] cx88[0]/2: subsystem: 0070:6902, board: Hauppauge
WinTV-HVR4000 DVB-S/S2/T/Hybrid [card=68]
[    9.747601] cx88[0]/2: cx2388x based DVB/ATSC card
[   10.065783] DVB: registering new adapter (cx88[0])

Best Regards

Marky


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
