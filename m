Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from yw-out-2324.google.com ([74.125.46.31])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <andreacimino@gmail.com>) id 1KxSEJ-0002Bs-85
	for linux-dvb@linuxtv.org; Tue, 04 Nov 2008 21:10:27 +0100
Received: by yw-out-2324.google.com with SMTP id 3so1237318ywj.41
	for <linux-dvb@linuxtv.org>; Tue, 04 Nov 2008 12:10:19 -0800 (PST)
Message-ID: <3db0f14b0811041210r68083176r3f7c8db9fdcd934e@mail.gmail.com>
Date: Tue, 4 Nov 2008 21:10:17 +0100
From: "Andrea Cimino" <andreacimino@gmail.com>
To: linux-dvb@linuxtv.org
MIME-Version: 1.0
Content-Disposition: inline
Subject: [linux-dvb] Support for VP3020 Board
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

Hello to everyone, hoping that this is the right place to post.
I have almost from 2 years a VP3020 CARD (
http://www.bttv-gallery.de/high/IMG_6748.JPG_vp3020_a.jpg),
and seems to be supported as seen on BTTV Gallery
This reports:
[

chips: 25878-13 et al.
tuner: TU1216/I H P   3112 297 13641D#
pcb: VP3020 V1.0

Feb  9 20:36:42 localhost kernel:
Feb  9 20:36:42 localhost kernel: DST type flags : 0x10 firmware version = 2
Feb  9 20:36:42 localhost kernel: DVB: registering frontend 0 (DST DVB-T)...

]

Well, some time ago it worked nicely with a Gentoo system.
 Some time ago i upgraded to ubuntu 8.10 and now simply doesn't work,
the interface
dvb frontend does not come up

Here is the log from dmesg:

[ 3949.259468] bttv1: Bt878 (rev 17) at 0000:01:0a.0, irq: 18,
latency: 32, mmio: 0xbfffd000
[ 3949.262776] bttv1: subsystem: ffff:0001 (UNKNOWN)
[ 3949.262785] please mail id, board name and the correct card= insmod
option to video4linux-list@redhat.com
[ 3949.262791] bttv1: using:  *** UNKNOWN/GENERIC ***  [card=0,autodetected]
[ 3949.262846] bttv1: gpio: en=00000000, out=00000000 in=00f500ff [init]
[ 3949.324149] bttv1: tuner type unset
[ 3949.324164] bttv1: i2c: checking for MSP34xx @ 0x80... not found
[ 3949.326059] bttv1: i2c: checking for TDA9875 @ 0xb0... <4>tuner'
2-0060: tuner type not set
[ 3949.329104] not found
[ 3949.329114] bttv1: i2c: checking for TDA7432 @ 0x8a... not found
[ 3949.332159] bttv1: registered device video1
[ 3949.333385] bttv1: registered device vbi1
[ 3949.346064] bt878: AUDIO driver version 0.0.0 loaded

I know that it worked under linux, maybe i am missing something? I spent a lot
of time googling but i couldn't find anything interesting.


Regards,
Andrea

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
