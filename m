Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:2342 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932420AbZLRTA3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 18 Dec 2009 14:00:29 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Stefan Tauner <stefan.tauner@gmx.at>
Subject: Re: missing audio in bttv
Date: Fri, 18 Dec 2009 19:59:37 +0100
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org
References: <200911261837.nAQIaxiA018083@mxdrop206.xs4all.nl> <200911262109.05003.hverkuil@xs4all.nl> <200912171908.nBHJ8JNB016390@mxdrop206.xs4all.nl>
In-Reply-To: <200912171908.nBHJ8JNB016390@mxdrop206.xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200912181959.37884.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Stefan,

I'm CC-ing both the bttv maintainer and the linux-media list.

On Thursday 17 December 2009 20:08:08 Stefan Tauner wrote:
> On Thu, 26 Nov 2009 21:09:04 +0100
> Hans Verkuil <hverkuil@xs4all.nl> wrote:
> 
> > You posted this to the wrong mailinglist. The old video4linux
> > mailinglist is obsolete and is replaced by the linux-media
> > mailinglist.
> 
> hello again!
> 
> sorry for the long delay, i had lots of stuff to do for university.
> 
> i read somewhere, that video4linux is still ok for user-oriented stuff.
> maybe it would be a good idea to close the old one completely.
> 
> > You wouldn't happen to have the dmesg lines from a 2.6.29 or older
> > kernel, would you? That would be very useful.
> > 
> > Can you also look at the card and either make a photo of it or write
> > down the names of the chips on the board? I need to know what audio
> > chip is actually on it.
> 
> i tried to mail to the new list (one time without subscribing, the 2nd
> time after), but it did not go through, no idea why :/
> 
> i shot some photos, but the part numbers etc are not really readable,
> i wrote them down though...
> conexant fusion 878a
> an analogue multiplexer hef4052bt
> a 256x8b i2c eeprom 24c02n
> there are no other ics outside the tuner casing
> 
> so the 878a is responsible for decoding the audio, right?

This is weird. For both kernels the messages report that there is no audio
chip. To my knowledge you need some chip in other to be able to get audio
from the tuner.

Mauro, do you know anything about this type of card? Basically Stefan reports
that it works for 2.6.29 but no longer with 2.6.31. I thought it might be the
subdev conversion, but based on these kernel logs I do not see anything
different between the kernels. Neither reports the presence of an audio chip.

> 
> 
> dmesg lines from ubuntu's 2.6.31-15-generic:
> [   42.137099] bttv: driver version 0.9.18 loaded
> [   42.137101] bttv: using 8 buffers with 2080k (520 pages) each for capture
> [   42.138569] bttv: Bt8xx card found (0).
> [   42.138582] bttv 0000:01:00.0: PCI INT A -> GSI 21 (level, low) -> IRQ 21
> [   42.138591] bttv0: Bt878 (rev 17) at 0000:01:00.0, irq: 21, latency: 32, mmio: 0xbe000000
> [   42.138623] bttv0: detected: Hauppauge WinTV [card=10], PCI subsystem ID is 0070:13eb
> [   42.138625] bttv0: using: Hauppauge (bt878) [card=10,autodetected]
> [   42.138627] IRQ 21/bttv0: IRQF_DISABLED is not guaranteed on shared IRQs
> [   42.138650] bttv0: gpio: en=00000000, out=00000000 in=00fffffb [init]
> [   42.141155] bttv0: Hauppauge/Voodoo msp34xx: reset line init [5]
> [   42.177379] tveeprom 6-0050: Hauppauge model 38104, rev B429, serial# 5055952
> [   42.177381] tveeprom 6-0050: tuner model is Temic 4006FH5 (idx 29, type 14)
> [   42.177383] tveeprom 6-0050: TV standards PAL(B/G) (eeprom 0x04)
> [   42.177385] tveeprom 6-0050: audio processor is None (idx 0)
> [   42.177387] tveeprom 6-0050: has no radio
> [   42.177388] bttv0: Hauppauge eeprom indicates model#38104
> [   42.177390] bttv0: tuner type=14
> [   43.239183] bttv0: audio absent, no audio device found!
> [   43.351690]   alloc irq_desc for 22 on node 0
> [   43.351693]   alloc kstat_irqs on node 0
> ...
> [   43.416300] tuner 6-0061: chip found @ 0xc2 (bt878 #0 [sw])
> ...
> [   44.141866] tuner-simple 6-0061: creating new instance
> [   44.141869] tuner-simple 6-0061: type set to 14 (Temic PAL_BG (4006FH5))
> [   44.142579] bttv0: registered device video0
> [   44.142596] bttv0: registered device vbi0
> [   44.142622] bttv0: PLL: 28636363 => 35468950 .. ok
> [   44.191396] Bt87x 0000:01:00.1: PCI INT A -> GSI 21 (level, low) -> IRQ 21
> [   44.191521] bt87x0: Using board 1, analog, digital (rate 32000 Hz)
> 
> 
> 2.6.29:
> im pretty sure it worked in the past with this kernel, but 2.6.29 does not work with my current
> intel graphics drivers(? trying to open the video device in vlc kills the xserver),
> so it would be a nuisance to test it out to be sure.

Stefan, you should be able to do something like 'cat /dev/video0 >/dev/null'.
All we need to know is if you have audio, and since the audio is looped to the
sound input, that should still work.

> [   19.593750] bttv: driver version 0.9.17 loaded
> [   19.593752] bttv: using 8 buffers with 2080k (520 pages) each for capture
> [   19.593808] bttv: Bt8xx card found (0).
> [   19.593817] bttv 0000:01:00.0: PCI INT A -> GSI 21 (level, low) -> IRQ 21
> [   19.593826] bttv0: Bt878 (rev 17) at 0000:01:00.0, irq: 21, latency: 32, mmio: 0xd0700000
> [   19.593844] bttv0: detected: Hauppauge WinTV [card=10], PCI subsystem ID is 0070:13eb
> [   19.593846] bttv0: using: Hauppauge (bt878) [card=10,autodetected]
> [   19.593847] IRQ 21/bttv0: IRQF_DISABLED is not guaranteed on shared IRQs
> [   19.593871] bttv0: gpio: en=00000000, out=00000000 in=00fffffb [init]
> [   19.596355] bttv0: Hauppauge/Voodoo msp34xx: reset line init [5]
> [   19.628999] tveeprom 1-0050: Hauppauge model 38104, rev B429, serial# 5055952
> [   19.629001] tveeprom 1-0050: tuner model is Temic 4006FH5 (idx 29, type 14)
> [   19.629003] tveeprom 1-0050: TV standards PAL(B/G) (eeprom 0x04)
> [   19.629005] tveeprom 1-0050: audio processor is None (idx 0)
> [   19.629006] tveeprom 1-0050: has no radio
> [   19.629007] bttv0: Hauppauge eeprom indicates model#38104
> [   19.629008] bttv0: tuner type=14
> [   19.629010] bttv0: i2c: checking for MSP34xx @ 0x80... not found
> [   19.630558] bttv0: i2c: checking for TDA9875 @ 0xb0... not found
> [   19.631186] bttv0: i2c: checking for TDA7432 @ 0x8a... not found
> [   19.657240] tuner' 1-0061: chip found @ 0xc2 (bt878 #0 [sw])
> ...
> [   20.528277] tuner-simple 1-0061: creating new instance
> [   20.528279] tuner-simple 1-0061: type set to 14 (Temic PAL_BG (4006FH5))
> [   20.538227] bttv0: registered device video0
> [   20.538265] bttv0: registered device vbi0
> [   20.538289] bttv0: PLL: 28636363 => 35468950 .. ok
> 
> 

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG
