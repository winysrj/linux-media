Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n03JXbh2031145
	for <video4linux-list@redhat.com>; Sat, 3 Jan 2009 14:33:37 -0500
Received: from mail-in-02.arcor-online.net (mail-in-02.arcor-online.net
	[151.189.21.42])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id n03JXLLC009384
	for <video4linux-list@redhat.com>; Sat, 3 Jan 2009 14:33:21 -0500
From: hermann pitton <hermann-pitton@arcor.de>
To: brian_empson@yahoo.com
In-Reply-To: <49875.5941.qm@web55907.mail.re3.yahoo.com>
References: <49875.5941.qm@web55907.mail.re3.yahoo.com>
Content-Type: text/plain
Date: Sat, 03 Jan 2009 20:33:49 +0100
Message-Id: <1231011229.4523.9.camel@pc10.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com
Subject: Re: Sabrent TV-FM Tuner issue
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

Am Samstag, den 03.01.2009, 08:33 -0800 schrieb Brian Empson:
> Hello,
> 
> I have recently installed two Sabrent PCI TVFM tuners into my computer along with a Sabrent 5 channel sound card.  By changing the card=0 option to card=42 I was able to get the composite working perfectly and the tv tuner to display static.  However, I cannot receiver any channels at all with tvtime or mythtv or mplayer.  I cycled through all the tuner=XX numbers and nothing seemed to make a difference.  I did a tvtime-sanner scan and it picked up a ton of channels, but when I went to view them in tvtime all I got was static.  The dmesg output:
> 
> saa7130/34: v4l2 driver version 0.2.14 loaded
> saa7130[0]: found at 0000:02:01.0, rev: 1, irq: 22, latency: 32, mmio: 0xff9ffc00
> saa7130[0]: subsystem: 1131:0000, board: Sabrent SBT-TVFM (saa7130) [card=42,insmod option]
> saa7130[0]: board init: gpio is c04000
> saa7130[0]: Huh, no eeprom present (err=-5)?
> saa7130[0]: i2c scan: found device @ 0x86  [tda9887]
> saa7130[0]: i2c scan: found device @ 0xc0  [tuner (analog)]
> saa7130[0]: registered device video0 [v4l2]
> saa7130[0]: registered device vbi0
> saa7130[0]: registered device radio0
> saa7130[1]: found at 0000:02:02.0, rev: 1, irq: 17, latency: 32, mmio: 0xff9ff800
> saa7134:   card=10 -> Kworld/KuroutoShikou SAA7130-TVPCI
> saa7134:   card=42 -> Sabrent SBT-TVFM (saa7130)
> saa7130[1]: subsystem: 1131:0000, board: UNKNOWN/GENERIC [card=0,autodetected]
> saa7130[1]: board init: gpio is c04000
> saa7130[1]: Huh, no eeprom present (err=-5)?
> saa7130[1]: i2c scan: found device @ 0x86  [tda9887]
> saa7130[1]: i2c scan: found device @ 0xc0  [tuner (analog)]
> saa7130[1]: registered device video1 [v4l2]
> saa7130[1]: registered device vbi1
> 
> I passed i2c_scan=1 and card=42 as options to get the first card to be recognized.  The second card is autodetected for some reason.  I do not know why it doesn't set it to 42 like the first card.  Anyway, the channels are all static, even though the scan program can pick up signals, the tvtime program cannot seem to display any sort of picture.  The composite, on the other hand, works perfectly.  I have tried using mplayer to try different cable frequency plans and there was no difference.  This is really mind boogling to me because it should display SOMETHING, right?  There is a cable line attached to the first card's tuner port, the other card doesn't have anything connected.
> 
> Any help would be greatly appreciated, because at this point I do not know what to do...
> 
> -Brian
> 

cards without eeprom are always difficult to track for changes.

The tda9887 found seems to indicate the default tuner is wrong for you.

You might try "modprobe saa7134 card=42,42 tuner=43,43" if in NTSC M/N
regions or tuner=38,38 for PAL/SECAM.

Cheers,
Hermann


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
