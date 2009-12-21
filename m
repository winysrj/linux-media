Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-09.arcor-online.net ([151.189.21.49]:37835 "EHLO
	mail-in-09.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753309AbZLUU5I (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Dec 2009 15:57:08 -0500
Subject: Re: How to make a Zaapa LR301AP DVB-T card work
From: hermann pitton <hermann-pitton@arcor.de>
To: amlopezalonso@gmail.com
Cc: linux-media@vger.kernel.org
In-Reply-To: <200912201313.31384.amlopezalonso@gmail.com>
References: <200912191400.37814.amlopezalonso@gmail.com>
	 <1261252417.3220.3.camel@pc07.localdom.local>
	 <200912201313.31384.amlopezalonso@gmail.com>
Content-Type: text/plain; charset=UTF-8
Date: Mon, 21 Dec 2009 21:51:11 +0100
Message-Id: <1261428671.3208.10.camel@pc07.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Am Sonntag, den 20.12.2009, 13:13 +0000 schrieb Antonio Marcos López
Alonso: 
> > 
> > please try with "card=86".
> > 
> > If everything is fine, we add it to auto detection.
> > 
> > Cheers,
> > Hermann
> > 
> 
> Did it so and the card (TDA10046 chip ) is now detected by MythTV (have to say 
> previous setup was not detected by Kaffeine because MythTV backend was 
> running). However scanning process did not find any channel and I'm sure 
> previous cards have worked doing so.
> 
> New "dmesg|grep saa" output:
> *********************************
> [    8.840823] saa7130/34: v4l2 driver version 0.2.15 loaded
> [    8.841237] saa7134 0000:00:0c.0: PCI INT A -> Link[LNKB] -> GSI 11 (level, 
> low) -> IRQ 11
> [    8.841244] saa7134[0]: found at 0000:00:0c.0, rev: 1, irq: 11, latency: 
> 64, mmio: 0xdffffc00
> [    8.841251] saa7134[0]: subsystem: 4e42:0301, board: LifeView FlyDVB-T / 
> Genius VideoWonder DVB-T [card=86,insmod option]
> [    8.841272] saa7134[0]: board init: gpio is 10000
> [    8.841369] input: saa7134 IR (LifeView FlyDVB-T / as 
> /devices/pci0000:00/0000:00:0c.0/input/input5
> [    8.841411] IRQ 11/saa7134[0]: IRQF_DISABLED is not guaranteed on shared 
> IRQs
> [    8.992137] saa7134[0]: i2c eeprom 00: 42 4e 01 03 54 20 1c 00 43 43 a9 1c 
> 55 d2 b2 92
> [    8.992147] saa7134[0]: i2c eeprom 10: 00 ff 86 0f ff 20 ff ff ff ff ff ff 
> ff ff ff ff
> [    8.992155] saa7134[0]: i2c eeprom 20: 01 40 01 03 03 01 01 03 08 ff 01 e2 
> ff ff ff ff
> [    8.992163] saa7134[0]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff ff ff ff 
> ff ff ff ff
> [    8.992170] saa7134[0]: i2c eeprom 40: ff 1b 00 c0 ff 10 01 00 ff ff ff ff 
> ff ff ff ff
> [    8.992177] saa7134[0]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff ff ff ff 
> ff ff ff ff
> [    8.992185] saa7134[0]: i2c eeprom 60: ff ff ff ff ff ff ff ff ff ff ff ff 
> ff ff ff ff
> [    8.992192] saa7134[0]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff ff ff ff 
> ff ff ff ff
> [    8.992199] saa7134[0]: i2c eeprom 80: ff ff ff ff ff ff ff ff ff ff ff ff 
> ff ff ff ff
> [    8.992207] saa7134[0]: i2c eeprom 90: ff ff ff ff ff ff ff ff ff ff ff ff 
> ff ff ff ff
> [    8.992214] saa7134[0]: i2c eeprom a0: ff ff ff ff ff ff ff ff ff ff ff ff 
> ff ff ff ff
> [    8.992221] saa7134[0]: i2c eeprom b0: ff ff ff ff ff ff ff ff ff ff ff ff 
> ff ff ff ff
> [    8.992229] saa7134[0]: i2c eeprom c0: ff ff ff ff ff ff ff ff ff ff ff ff 
> ff ff ff ff
> [    8.992236] saa7134[0]: i2c eeprom d0: ff ff ff ff ff ff ff ff ff ff ff ff 
> ff ff ff ff
> [    8.992243] saa7134[0]: i2c eeprom e0: ff ff ff ff ff ff ff ff ff ff ff ff 
> ff ff ff ff
> [    8.992250] saa7134[0]: i2c eeprom f0: ff ff ff ff ff ff ff ff ff ff ff ff 
> ff ff ff ff
> [    8.992393] saa7134[0]: registered device video0 [v4l2]
> [    8.992418] saa7134[0]: registered device vbi0
> [    9.533985] DVB: registering new adapter (saa7134[0])
> [   10.279639] saa7134 ALSA driver for DMA sound loaded
> [   10.279652] IRQ 11/saa7134[0]: IRQF_DISABLED is not guaranteed on shared 
> IRQs
> [   10.279679] saa7134[0]/alsa: saa7134[0] at 0xdffffc00 irq 11 registered as 
> card -1
> 
> Cheers
> Antonio
> 

Antonio,

the report for tda10046 firmware loading is missing. Was that OK?

LR301 is a LifeView design. It is very common to see multiple other
subvendors for their cards, but they keep the original subdevice ID.
In this case 0x0301. The subvendor 0x4e42 is usually Typhoon/Anubis and
they are distributing clones of almost all LifeView cards.

Gpio init is the same like on the other known LR301 cards and eeprom
differs only for a few bytes, but not for tuner type, tuner and demod
address.

http://ubuntuforums.org/archive/index.php/t-328140.html

Since this design with a saa7134 chip and tda8274 DVB-T only tuner is very old,
I don't expect an additional Low Noise Amplifier on it.

We can't detect such LNAs and on newer cards they can cause problems, if
not configured correctly and might cause "scan" to fail.

If you mean above other card types did previously work for your card,
use them and report.

Sorry, I don't have better ideas for your card so far.

Cheers,
Hermann





