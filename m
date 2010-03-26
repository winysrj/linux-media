Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-12.arcor-online.net ([151.189.21.52]:43543 "EHLO
	mail-in-12.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753861Ab0CZXuc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 26 Mar 2010 19:50:32 -0400
Subject: Re: Avermedia AVerTV GO 007 FM composite input problem
From: hermann pitton <hermann-pitton@arcor.de>
To: Andras Barna <andras.barna@gmail.com>
Cc: linux-media@vger.kernel.org, Assaf Gillat <gillata@gmail.com>
In-Reply-To: <56dc2e761003260410t70ef8e39w6f45468ecf84ba40@mail.gmail.com>
References: <56dc2e761003260410t70ef8e39w6f45468ecf84ba40@mail.gmail.com>
Content-Type: text/plain
Date: Sat, 27 Mar 2010 00:47:10 +0100
Message-Id: <1269647230.5410.57.camel@pc07.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Hi,

Am Freitag, den 26.03.2010, 13:10 +0200 schrieb Andras Barna:
> hi i have a Avermedia AVerTV GO 007 FM card , the problem is that i
> get nothing from Composite, i tried different apps (mplayer, tvtime,
> etc) none works. ("television" input works)
> ideas?

looking it up from 2005 to now, Composite was never reported as tested,
only S-Video.

On the other hand, vmux=0 is what we regularly see on combined S-Video
and Composite inputs where you need an adapter for Composite over
S-Video. The card has no separate Composite-in connector.

Assuming you did not plug by mistake into the radio antenna input, then
you can also try with vmux 3, 2 and 4 for Composite in saa7134-cards.c.

You might have a look at the manual and/or windows driver, since this
information is not provided to us until now. (bttv-gallery/wiki/lists)

Does it come with any simple 4pin adapter or even with a breakout cable
with more pins and a dedicated yellow RCA input?

Cheers,
Hermann


> here're some infos
> 
> [    9.361212] saa7130/34: v4l2 driver version 0.2.15 loaded
> [    9.361631]   alloc irq_desc for 17 on node -1
> [    9.361635]   alloc kstat_irqs on node -1
> [    9.361648] saa7134 0000:00:09.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
> [    9.361768] saa7133[0]: found at 0000:00:09.0, rev: 208, irq: 17,
> latency: 32, mmio: 0xcfffc800
> [    9.361955] saa7133[0]: subsystem: 1461:f31f, board: Avermedia
> AVerTV GO 007 FM [card=57,autodetected]
> [    9.362198] saa7133[0]: board init: gpio is 80000
> [    9.362424] input: saa7134 IR (Avermedia AVerTV GO as
> /devices/pci0000:00/0000:00:09.0/input/input6
> [    9.362713] IRQ 17/saa7133[0]: IRQF_DISABLED is not guaranteed on shared IRQs
> [    9.501011] saa7133[0]: i2c eeprom 00: 61 14 1f f3 ff ff ff ff ff
> ff ff ff ff ff ff ff
> [    9.501838] saa7133[0]: i2c eeprom 10: ff ff ff ff ff ff ff ff ff
> ff ff ff ff ff ff ff
> [    9.502592] saa7133[0]: i2c eeprom 20: ff d2 fe ff ff ff ff ff ff
> ff ff ff ff ff ff ff
> [    9.503343] saa7133[0]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff
> ff ff ff ff ff ff ff
> [    9.504095] saa7133[0]: i2c eeprom 40: ff ff ff ff ff ff ff ff ff
> ff ff ff ff ff ff ff
> [    9.504842] saa7133[0]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff
> ff ff ff ff ff ff ff
> [    9.505593] saa7133[0]: i2c eeprom 60: ff ff ff ff ff ff ff ff ff
> ff ff ff ff ff ff ff
> [    9.506345] saa7133[0]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff
> ff ff ff ff ff ff ff
> [    9.507097] saa7133[0]: i2c eeprom 80: ff ff ff ff ff ff ff ff ff
> ff ff ff ff ff ff ff
> [    9.507846] saa7133[0]: i2c eeprom 90: ff ff ff ff ff ff ff ff ff
> ff ff ff ff ff ff ff
> [    9.508600] saa7133[0]: i2c eeprom a0: ff ff ff ff ff ff ff ff ff
> ff ff ff ff ff ff ff
> [    9.509354] saa7133[0]: i2c eeprom b0: ff ff ff ff ff ff ff ff ff
> ff ff ff ff ff ff ff
> [    9.510107] saa7133[0]: i2c eeprom c0: ff ff ff ff ff ff ff ff ff
> ff ff ff ff ff ff ff
> [    9.510920] saa7133[0]: i2c eeprom d0: ff ff ff ff ff ff ff ff ff
> ff ff ff ff ff ff ff
> [    9.511672] saa7133[0]: i2c eeprom e0: ff ff ff ff ff ff ff ff ff
> ff ff ff ff ff ff ff
> [    9.512423] saa7133[0]: i2c eeprom f0: ff ff ff ff ff ff ff ff ff
> ff ff ff ff ff ff ff
> [   10.780106] tuner 0-004b: chip found @ 0x96 (saa7133[0])
> [   10.815008] tda829x 0-004b: setting tuner address to 61
> [   11.349012] tda829x 0-004b: type set to tda8290+75
> [   14.869150] saa7133[0]: registered device video0 [v4l2]
> [   14.869305] saa7133[0]: registered device vbi0
> [   14.869447] saa7133[0]: registered device radio0
> [   14.968864] saa7134 ALSA driver for DMA sound loaded
> [   14.970728] IRQ 17/saa7133[0]: IRQF_DISABLED is not guaranteed on shared IRQs
> [   14.970892] saa7133[0]/alsa: saa7133[0] at 0xcfffc800 irq 17
> registered as card -1
> 
[snip]

