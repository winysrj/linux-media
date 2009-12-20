Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f209.google.com ([209.85.219.209]:62786 "EHLO
	mail-ew0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755115AbZLTNNh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 20 Dec 2009 08:13:37 -0500
Received: by ewy1 with SMTP id 1so5335046ewy.28
        for <linux-media@vger.kernel.org>; Sun, 20 Dec 2009 05:13:35 -0800 (PST)
From: Antonio Marcos =?utf-8?q?L=C3=B3pez_Alonso?=
	<amlopezalonso@gmail.com>
Reply-To: amlopezalonso@gmail.com
To: linux-media@vger.kernel.org
Subject: Re: How to make a Zaapa LR301AP DVB-T card work
Date: Sun, 20 Dec 2009 13:13:31 +0000
References: <200912191400.37814.amlopezalonso@gmail.com> <1261252417.3220.3.camel@pc07.localdom.local>
In-Reply-To: <1261252417.3220.3.camel@pc07.localdom.local>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <200912201313.31384.amlopezalonso@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


> 
> please try with "card=86".
> 
> If everything is fine, we add it to auto detection.
> 
> Cheers,
> Hermann
> 

Did it so and the card (TDA10046 chip ) is now detected by MythTV (have to say 
previous setup was not detected by Kaffeine because MythTV backend was 
running). However scanning process did not find any channel and I'm sure 
previous cards have worked doing so.

New "dmesg|grep saa" output:
*********************************
[    8.840823] saa7130/34: v4l2 driver version 0.2.15 loaded
[    8.841237] saa7134 0000:00:0c.0: PCI INT A -> Link[LNKB] -> GSI 11 (level, 
low) -> IRQ 11
[    8.841244] saa7134[0]: found at 0000:00:0c.0, rev: 1, irq: 11, latency: 
64, mmio: 0xdffffc00
[    8.841251] saa7134[0]: subsystem: 4e42:0301, board: LifeView FlyDVB-T / 
Genius VideoWonder DVB-T [card=86,insmod option]
[    8.841272] saa7134[0]: board init: gpio is 10000
[    8.841369] input: saa7134 IR (LifeView FlyDVB-T / as 
/devices/pci0000:00/0000:00:0c.0/input/input5
[    8.841411] IRQ 11/saa7134[0]: IRQF_DISABLED is not guaranteed on shared 
IRQs
[    8.992137] saa7134[0]: i2c eeprom 00: 42 4e 01 03 54 20 1c 00 43 43 a9 1c 
55 d2 b2 92
[    8.992147] saa7134[0]: i2c eeprom 10: 00 ff 86 0f ff 20 ff ff ff ff ff ff 
ff ff ff ff
[    8.992155] saa7134[0]: i2c eeprom 20: 01 40 01 03 03 01 01 03 08 ff 01 e2 
ff ff ff ff
[    8.992163] saa7134[0]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff ff ff ff 
ff ff ff ff
[    8.992170] saa7134[0]: i2c eeprom 40: ff 1b 00 c0 ff 10 01 00 ff ff ff ff 
ff ff ff ff
[    8.992177] saa7134[0]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff ff ff ff 
ff ff ff ff
[    8.992185] saa7134[0]: i2c eeprom 60: ff ff ff ff ff ff ff ff ff ff ff ff 
ff ff ff ff
[    8.992192] saa7134[0]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff ff ff ff 
ff ff ff ff
[    8.992199] saa7134[0]: i2c eeprom 80: ff ff ff ff ff ff ff ff ff ff ff ff 
ff ff ff ff
[    8.992207] saa7134[0]: i2c eeprom 90: ff ff ff ff ff ff ff ff ff ff ff ff 
ff ff ff ff
[    8.992214] saa7134[0]: i2c eeprom a0: ff ff ff ff ff ff ff ff ff ff ff ff 
ff ff ff ff
[    8.992221] saa7134[0]: i2c eeprom b0: ff ff ff ff ff ff ff ff ff ff ff ff 
ff ff ff ff
[    8.992229] saa7134[0]: i2c eeprom c0: ff ff ff ff ff ff ff ff ff ff ff ff 
ff ff ff ff
[    8.992236] saa7134[0]: i2c eeprom d0: ff ff ff ff ff ff ff ff ff ff ff ff 
ff ff ff ff
[    8.992243] saa7134[0]: i2c eeprom e0: ff ff ff ff ff ff ff ff ff ff ff ff 
ff ff ff ff
[    8.992250] saa7134[0]: i2c eeprom f0: ff ff ff ff ff ff ff ff ff ff ff ff 
ff ff ff ff
[    8.992393] saa7134[0]: registered device video0 [v4l2]
[    8.992418] saa7134[0]: registered device vbi0
[    9.533985] DVB: registering new adapter (saa7134[0])
[   10.279639] saa7134 ALSA driver for DMA sound loaded
[   10.279652] IRQ 11/saa7134[0]: IRQF_DISABLED is not guaranteed on shared 
IRQs
[   10.279679] saa7134[0]/alsa: saa7134[0] at 0xdffffc00 irq 11 registered as 
card -1

Cheers
Antonio

