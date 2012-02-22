Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout-de.gmx.net ([213.165.64.23]:48620 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752501Ab2BVNVX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 22 Feb 2012 08:21:23 -0500
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by dino.fritz.box (Postfix) with ESMTPS id 663F3D612A8
	for <linux-media@vger.kernel.org>; Wed, 22 Feb 2012 14:21:11 +0100 (CET)
Message-ID: <4F44EBC6.504@gmx.net>
Date: Wed, 22 Feb 2012 14:21:10 +0100
From: "C. Hemsing" <C.Hemsing@gmx.net>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: saa7134 card, Creatix CTX953/CTX941
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

To the maintainer of the saa7134 modules, especially the Creatix 953 driver:

I have a Creatix CTX941 (minipci) hybrid card.

I contacted the vendor Creatix and according to their information the
CTX941 board is virtually the same as the CTX953.

When loading the board as card 134 (CTX953), the following kernel 
messages are being generated:

saa7134 0000:06:06.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
saa7133[0]: found at 0000:06:06.0, rev: 209, irq: 20, latency: 181, 
mmio: 0xb0007000
saa7133[0]: subsystem: 16be:0009, board: Medion/Creatix CTX953 Hybrid 
[card=134,insmod option]
saa7133[0]: board init: gpio is 0
IRQ 20/saa7133[0]: IRQF_DISABLED is not guaranteed on shared IRQs
saa7133[0]: i2c eeprom 00: be 16 09 00 54 20 1c 00 43 43 a9 1c 55 d2 b2 92
saa7133[0]: i2c eeprom 10: 00 ff 86 0f ff 20 ff 00 01 50 32 79 01 3c ca 50
saa7133[0]: i2c eeprom 20: 01 40 01 02 02 03 01 00 06 ff 00 25 02 51 96 2b
saa7133[0]: i2c eeprom 30: a7 58 7a 1f 03 8e 84 5e da 7a 04 b3 05 87 b2 3c
saa7133[0]: i2c eeprom 40: ff 21 00 c2 96 10 03 22 15 10 fd 79 44 9f c2 8f
saa7133[0]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 60: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 80: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 90: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom a0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom b0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom c0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom d0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom e0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom f0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
i2c i2c-0: Invalid 7-bit address 0x7a
tuner 0-004b: chip found @ 0x96 (saa7133[0])
tda829x 0-004b: setting tuner address to 61
tda829x 0-004b: type set to tda8290+75a
saa7133[0]: registered device video0 [v4l2]
saa7133[0]: registered device vbi0
saa7134 ALSA driver for DMA sound loaded
IRQ 20/saa7133[0]: IRQF_DISABLED is not guaranteed on shared IRQs
saa7133[0]/alsa: saa7133[0] at 0xb0007000 irq 20 registered as card -2
dvb_init() allocating 1 frontend
DVB: registering new adapter (saa7133[0])
DVB: registering adapter 0 frontend 0 (Philips TDA10046H DVB-T)...
tda1004x: setting up plls for 48MHz sampling clock
tda1004x: found firmware revision 29 -- ok
tda827x_probe_version: could not read from tuner at addr: 0xc0

and consequently when I try to tuned to a dvb-t channel, the kernel emits:

tda1004x: setting up plls for 48MHz sampling clock
tda1004x: found firmware revision 29 -- ok
tda827x_probe_version: could not read from tuner at addr: 0xc0
tda827xo_set_params: could not write to tuner at addr: 0xc0
tda827xo_set_params: could not write to tuner at addr: 0xc0
tda827xo_set_params: could not write to tuner at addr: 0xc0
tda827x_probe_version: could not read from tuner at addr: 0xc0

As it seems tda827x cannot address the tuner registers.

1) Has the CTX953 ever been working (I've seen the
"could not read from tuner at addr: 0xc0"
elsewhere.
2) Is it working currently?
3) If yes to 1) and 2), what could be the difference to the CTX941 ?

Cheers,
Chris
