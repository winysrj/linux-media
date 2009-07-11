Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-03.arcor-online.net ([151.189.21.43]:50365 "EHLO
	mail-in-03.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757396AbZGKAl7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 10 Jul 2009 20:41:59 -0400
Subject: Re: regression : saa7134  with Pinnacle PCTV 50i (analog) can not
	tune anymore
From: hermann pitton <hermann-pitton@arcor.de>
To: eric.paturage@orange.fr, Jean Delvare <khali@linux-fr.org>
Cc: linux-media@vger.kernel.org
In-Reply-To: <200907100551.n6A5p9i03931@neptune.localwarp.net>
References: <200907100551.n6A5p9i03931@neptune.localwarp.net>
Content-Type: text/plain
Date: Sat, 11 Jul 2009 02:40:56 +0200
Message-Id: <1247272856.3159.14.camel@pc07.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

[snip]
> >> > 
> >> 
> >> H Hermann 
> >> 
> >> thanks for your suggestion .
> >> No  improvement with changing the quirk to 0xfd , 
> >> I still get the same error messages : 
> >> i2c-adapter i2c-1: Invalid 7-bit address 0x7a
> >> saa7133[0]: i2c xfer: < 8e >
> >> input: i2c IR (Pinnacle PCTV) as /class/input/input4
> >> ir-kbd-i2c: i2c IR (Pinnacle PCTV) detected at i2c-1/1-0047/ir0 [saa7133[0]]
> >> saa7133[0]: i2c xfer: < 8f ERROR: ARB_LOST
> >> saa7133[0]: i2c xfer: < 84 ERROR: NO_DEVICE
> >> saa7133[0]: i2c xfer: < 86 ERROR: ARB_LOST
> >> saa7133[0]: i2c xfer: < 94 ERROR: NO_DEVICE
> >> saa7133[0]: i2c xfer: < 96 ERROR: ARB_LOST
> >> saa7133[0]: i2c xfer: < c0 ERROR: NO_DEVICE
> >> saa7133[0]: i2c xfer: < c2 ERROR: NO_DEVICE
> >> saa7133[0]: i2c xfer: < c4 ERROR: NO_DEVICE
> >> saa7133[0]: i2c xfer: < c6 ERROR: NO_DEVICE
> >> saa7133[0]: i2c xfer: < c8 ERROR: NO_DEVICE      
> >> 
> >> 
> >> Regards 
> >> 
> > 
> > Hi Eric,
> > 
> > thanks for your time and testing.
> > 
> > Before we need to start with v4l-dvb bisecting.
> > 
> > There have only been a few changes for the saa7134 driver since what
> > Mauro did send for 2.6.30.
> > 
> > Mostly for ir-kbd-i2c and for your remote was no tester found.
> > 
> > All i2c errors seem to start from the remote and that i2c remote stuff I
> > don't have and can't fake.
> > 
> > Did you try with options saa7134 disable_ir=1 already too?
> > 
> > Cheers,
> > Hermann
> > 
> > 
> 
> Hi Hermann 
> 
> I  tried this morning with the option disable_ir=1 (mercurial from 7/7/2009)
> there is some progress :
> 
> case 1 : modprobe saa7134 
> the tuner does not load any submodule 
> message Jul 10 06:49:04 neptune kernel: TUNER: Unable to find symbol tda829x_probe()
> Jul 10 06:49:05 neptune kernel: DVB: Unable to find symbol tda9887_attach()
> Jul 10 06:51:21 neptune kernel: TUNER: Unable to find symbol tda829x_probe()
> Jul 10 06:51:21 neptune kernel: DVB: Unable to find symbol tda9887_attach()
> Jul 10 06:55:01 neptune kernel: TUNER: Unable to find symbol tda829x_probe()
> 
> message" neptune kernel: tuner 1-004b: Tuner has no way to set tv freq
> equency " in /var/log/message 
> 
> no pic with xawtv 
> xdtv hangs badly 
> 
> tried with quirk at both values (0xfe and 0xfd )
> 
> ----------------------------------------------------------------------------------------
> 
> case 2 :  modprobe saa7134  with having before manualy preloaded  tda827x and tda8290
> xawtv give a picture after maybe 10 sec  , it is very very slow to tune (about 6 or 7 sec ) .
> xdtv hangs completely  , no picture , no channel change (time out and try reset). 
> 
> tried with quirk at both values (0xfe and 0xfd )
> 
> Jul 10 07:29:16 neptune kernel: tuner 1-004b: chip found @ 0x96 (saa7133[0])
> Jul 10 07:29:16 neptune kernel: tda829x 1-004b: setting tuner address to 61
> Jul 10 07:29:16 neptune kernel: tda829x 1-004b: type set to tda8290+75a
> Jul 10 07:29:19 neptune kernel: saa7133[0]: registered device video0 [v4l2]
> Jul 10 07:29:19 neptune kernel: saa7133[0]: registered device vbi0
> Jul 10 07:29:19 neptune kernel: saa7133[0]: registered device radio0
> Jul 10 07:29:19 neptune kernel: saa7134 ALSA driver for DMA sound loaded
> Jul 10 07:29:19 neptune kernel: IRQ 11/saa7133[0]: IRQF_DISABLED is not guarante
> ed on shared IRQs
> Jul 10 07:29:19 neptune kernel: saa7133[0]/alsa: saa7133[0] at 0xed800000 irq 11
>  registered as card -1
> Jul 10 07:29:52 neptune kernel: 
> Jul 10 07:29:52 neptune kernel:  01 20 >
> Jul 10 07:30:02 neptune kernel: 
> Jul 10 07:30:57 neptune last message repeated 23 times
> Jul 10 07:31:19 neptune last message repeated 29 times
> Jul 10 07:34:40 neptune kernel: INFO: task xdtv:3912 blocked for more than 120 s
> econds.
> 
> 
> I can provide  more detailed dmesg , if needed . 
> 
> regards 
> 

Hi,

so it seems we can forget about Mike's i2c quirk change and need to look
at Jean's ir-kbd-i2c changes next without having a tester.

There seems to be some read/write address mess.

I can only suggest to follow what is printed with i2c_debug=1 on
changing a channel with the remote disabled and compare to what I have.

Something more in between?

Also, if on previously flaky attempts the tuner initialization sequence
should have been disturbed, only a cold boot can improve that.

It seems I have to report from Marathon here again and i don't like it
at all ... ;)

Cheers,
Hermann






