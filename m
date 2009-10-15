Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (ext-mx10.extmail.prod.ext.phx2.redhat.com
	[10.5.110.14])
	by int-mx08.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id n9FNB3GB025217
	for <video4linux-list@redhat.com>; Thu, 15 Oct 2009 19:11:03 -0400
Received: from mail-in-07.arcor-online.net (mail-in-07.arcor-online.net
	[151.189.21.47])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id n9FNAmqp021801
	for <video4linux-list@redhat.com>; Thu, 15 Oct 2009 19:10:48 -0400
From: hermann pitton <hermann-pitton@arcor.de>
To: Michael =?ISO-8859-1?Q?Gr=FCtzmann?= <Avalone@web.de>
In-Reply-To: <1309046926@web.de>
References: <1309046926@web.de>
Content-Type: text/plain; charset=UTF-8
Date: Fri, 16 Oct 2009 01:06:14 +0200
Message-Id: <1255647974.3261.47.camel@pc07.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Cc: video4linux-list@redhat.com
Subject: Re: tuner type
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

Hi,

Am Donnerstag, den 15.10.2009, 22:16 +0200 schrieb Michael Grützmann:
> Dear to all,
> 
> I have an Medion 7134 card, so I use the saa7134 module with a 2.6.25 kernel (card=12). But I have a question. Which tuner type should I use? 
>  cat /var/log/boot.msg |grep saa
> <6>saa7130/34: v4l2 driver version 0.2.14 loaded
> <6>saa7134[0]: found at 0000:00:0b.0, rev: 1, irq: 18, latency: 32, mmio: 0xdffffc00
> <6>saa7134[0]: subsystem: 16be:0003, board: Medion 7134 [card=12,autodetected]
> <6>saa7134[0]: board init: gpio is 0
> <6>saa7134[0]: i2c eeprom 00: be 16 03 00 08 20 1c 55 43 43 a9 1c 55 43 43 a9
> <6>saa7134[0]: i2c eeprom 10: ff ff ff ff 15 00 0e 01 0c c0 08 00 00 00 00 00
> <6>saa7134[0]: i2c eeprom 20: 00 00 00 e3 ff ff ff ff ff ff ff ff ff ff ff ff
> <6>saa7134[0]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> <6>saa7134[0]: i2c eeprom 40: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> <6>saa7134[0]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> <6>saa7134[0]: i2c eeprom 60: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> <6>saa7134[0]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> <6>saa7134[0]: i2c eeprom 80: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> <6>saa7134[0]: i2c eeprom 90: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> <6>saa7134[0]: i2c eeprom a0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> <6>saa7134[0]: i2c eeprom b0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> <6>saa7134[0]: i2c eeprom c0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> <6>saa7134[0]: i2c eeprom d0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> <6>saa7134[0]: i2c eeprom e0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> <6>saa7134[0]: i2c eeprom f0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> <6>tuner' 2-0043: chip found @ 0x86 (saa7134[0])
> <6>tuner' 2-0060: chip found @ 0xc0 (saa7134[0])
> <6>saa7134[0] Tuner type is 38

that is the working eeprom detection of the tuner type.
But there have been breakages in between, you might have to force the
tuner type on 2.6.25. Card=12 means lots of different cards.
What CTX revision and version do you have?

> <6>saa7134[0]: registered device video0 [v4l2]
> <6>saa7134[0]: registered device vbi0
> <6>saa7134[0]: registered device radio0
> <3>saa7134[0]/dvb: frontend initialization failed

Hm, on that tuner is no DVB-T.

> It is not tuner=38. 
> On the card, there stands: 'tuner philips 3139 147 18201H#'.

I have on one of them exactly the same.
You should read on the second line "FM1216ME/I H-3".

The third line has Philips internal variations of the model.
SV20 0241 is common for cards with tuner=38, not the older tuner=5 and
not yet the FMD1216ME hybrid,tuner=63, with also DVB-T support. (notice
the "D" on FMD1216ME)

> There are two Ambient chips on it. One chip ctis0tp. If needed, I can write to you the full chip labelings. 
> Your help would be appreciated.
> ps. I'm a linux newbie (use it for 2 years). Maybe you could also tell me how to write the changes made manually to modules.d, so the changes aren't lost when rebooting.

Maybe try to create some /etc/modprobe.conf for them.

Cheers,
Hermann


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
