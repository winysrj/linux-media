Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m5GBbmqI025682
	for <video4linux-list@redhat.com>; Mon, 16 Jun 2008 07:37:48 -0400
Received: from outbound.icp-qv1-irony-out4.iinet.net.au
	(outbound.icp-qv1-irony-out4.iinet.net.au [203.59.1.150])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m5GBbUts005882
	for <video4linux-list@redhat.com>; Mon, 16 Jun 2008 07:37:31 -0400
Message-ID: <48565075.6040400@iinet.net.au>
Date: Mon, 16 Jun 2008 19:37:25 +0800
From: timf <timf@iinet.net.au>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@infradead.org>, video4linux-list@redhat.com,
	linux-dvb@linuxtv.org, hermann pitton <hermann-pitton@arcor.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: 
Subject: unstable tda1004x firmware loading
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

Mauro Carvalho Chehab wrote:
<snip>
> Now, all we need to do is to make tda1004x more stable. The weird 
> thing is that
> it works fine with my Intel based notebook. It just fails on my dual 
> core AMD,
> with a higher clock. I suspect that this is due to a timeout issue, 
> but not
> 100% sure.
>
>
> Cheers,
> Mauro
>
>   
I have an old box which I'm pretty sure has a cpu about 1.6, non-dual core.
Tomorrow,  (too much noise at this hour of night here!)  I will try 
either/or Kworld 210, Pinnacle 310i, Kworld 220.
I will  try  both current v4l-dvb and that patch of yours in  
tda10046x.c, and see what happens.

Is it worth trying different msleep values?

All I can think of is this is a relatively recent event with this 
"revision FF" business,
but I can't be exact as to how long ago I noticed it.
---
OK, tried all that.

For Hermann, cards are:
Pinnacle 310i
Kworld VS-DVBT210RF
Kworld VS-DVBT220RF

It's not very predictable.

Either with a fresh install of ubuntu 8.04 (no hg v4l-dvb yet)
(Linux ubuntu 2.6.24-18-generic #1 SMP Wed May 28 19:28:38 UTC 2008 
x86_64 GNU/Linux)
or install v4l-dvb,
with your patch or not,
it varies whether reboot, shutdown, power cycle.
Sometimes the firmware loads no problems, sometimes not at all.
The firmware file is the one which comes with ubuntu 8.04,
so I don't know why/how it changes revisions.
The same things happen if I use the revision 29 from lifeview.

The card which presents no problems is the Kworld 220, which of course 
is not a hybrid,
and this card has 2 x i2c eeproms: 24c02n, 24c256n

The others have just a 24c02n.

So, perhaps this indicates an timing error somewhere between checking 
for an on-board eeprom, finding none,
and then locating/loading a firmware file.

dmesg:
[   31.595793] saa7133[0]: subsystem: 17de:7201, board: Tevion/KWorld 
DVB-T 220RF [card=88,autodetected]
[   32.112301] tuner 1-004b: chip found @ 0x96 (saa7133[0])
[   32.160229] tda8290 1-004b: setting tuner address to 61
[   32.264048] tuner 1-004b: type set to tda8290+75a
[   32.311973] tda8290 1-004b: setting tuner address to 61
[   32.415792] tuner 1-004b: type set to tda8290+75a
[   32.418210] saa7133[0]: registered device video0 [v4l2]
[   32.418236] saa7133[0]: registered device vbi0
[   32.418266] saa7133[0]: registered device radio0
[   32.469475] saa7134 ALSA driver for DMA sound loaded
[   32.469523] saa7133[0]/alsa: saa7133[0] at 0xdc800000 irq 6 
registered as card -2
[   32.613516] DVB: registering new adapter (saa7133[0])
[   32.613526] DVB: registering frontend 0 (Philips TDA10046H DVB-T)...
[   32.687347] tda1004x: setting up plls for 48MHz sampling clock
[   34.679999] tda1004x: found firmware revision 23 -- ok

and:
[   36.403980] saa7133[0]: subsystem: 17de:7250, board: KWorld DVB-T 210 
[card=114,autodetected]
[   36.995403] tuner 1-004b: chip found @ 0x96 (saa7133[0])
[   37.043432] tda8290 1-004b: setting tuner address to 61
[   37.155417] tuner 1-004b: type set to tda8290+75a
[   37.203384] tda8290 1-004b: setting tuner address to 61
[   37.327378] tuner 1-004b: type set to tda8290+75a
[   37.895160] saa7133[0]: registered device video0 [v4l2]
[   37.895197] saa7133[0]: registered device vbi0
[   37.895223] saa7133[0]: registered device radio0
[   38.381654] saa7134 ALSA driver for DMA sound loaded
[   38.381697] saa7133[0]/alsa: saa7133[0] at 0xdc800000 irq 6 
registered as card -2
[   38.463596] DVB: registering new adapter (saa7133[0])
[   38.463606] DVB: registering frontend 0 (Philips TDA10046H DVB-T)...
[   38.535325] tda1004x: setting up plls for 48MHz sampling clock
[   40.791102] tda1004x: timeout waiting for DSP ready
[   40.831097] tda1004x: found firmware revision 0 -- invalid
[   40.831100] tda1004x: trying to boot from eeprom
[   43.162971] tda1004x: timeout waiting for DSP ready
[   43.202914] tda1004x: found firmware revision 0 -- invalid
[   43.202918] tda1004x: waiting for firmware upload...
[   48.675012] tda1004x: Error during firmware upload
[   48.676411] tda1004x: found firmware revision ff -- invalid
[   48.676416] tda1004x: firmware upload failed
[   48.678282] saa7133[0]/dvb: could not access tda8290 I2C gate
[   48.678517] tda827x_probe_version: could not read from tuner at addr: 
0xc2

and:
[   39.094117] saa7133[0]: subsystem: 11bd:002f, board: Pinnacle PCTV 
310i [card=101,autodetected]
[   39.644688] tuner 1-004b: chip found @ 0x96 (saa7133[0])
[   39.692578] tda8290 1-004b: setting tuner address to 61
[   40.060043] tuner 1-004b: type set to tda8290+75a
[   40.107961] tda8290 1-004b: setting tuner address to 61
[   40.215739] tuner 1-004b: type set to tda8290+75a
[   40.218187] saa7133[0]: registered device video0 [v4l2]
[   40.218210] saa7133[0]: registered device vbi0
[   40.218238] saa7133[0]: registered device radio0
[   40.317537] saa7134 ALSA driver for DMA sound loaded
[   40.317581] saa7133[0]/alsa: saa7133[0] at 0xdc800000 irq 6 
registered as card -2
[   40.447819] DVB: registering new adapter (saa7133[0])
[   40.447828] DVB: registering frontend 0 (Philips TDA10046H DVB-T)...
[   40.535209] tda1004x: setting up plls for 48MHz sampling clock
[   42.803429] tda1004x: timeout waiting for DSP ready
[   42.843362] tda1004x: found firmware revision 0 -- invalid
[   42.843365] tda1004x: trying to boot from eeprom
[   45.171515] tda1004x: timeout waiting for DSP ready
[   45.211448] tda1004x: found firmware revision 0 -- invalid
[   45.211451] tda1004x: waiting for firmware upload...
[   59.695512] tda1004x: found firmware revision 20 -- ok

I notice someone is having similar problems with an Asus card.

Regards,
Timf

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
