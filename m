Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.9]:60177 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751480AbZJWSYU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 23 Oct 2009 14:24:20 -0400
Subject: TV card working with kernel 2.6.28 not working with kernel 2.6.31
From: Norman Jonas <vger.kernel.org@devport.codepilot.net>
To: LMML <linux-media@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 23 Oct 2009 20:24:22 +0200
Message-ID: <1256322262.3448.7.camel@desktop>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I am an Ubuntu user. Since I switched to the new Karmic release with the
new kernel my TV card stopped working. Even explicitly setting the tuner
doesnt seem to work. Setting the options explicitly with saa7134
i2c_scan=1 card=49 tuner=5 and tuner no_autodetect=5 addr=0xc6 / 0x63
and any combination doesnt help so I am out of options. The relevant
parts of dmesg are

dmesg kernel 2.6.28 :

[   57.673251] saa7134 0000:05:00.0: PCI INT A -> GSI 16 (level, low) ->
IRQ 16
[   57.673257] saa7134[0]: found at 0000:05:00.0, rev: 1, irq: 16,
latency: 64, mmio: 0xfebffc00
[   57.673262] saa7134[0]: subsystem: 185b:c200, board: Compro VideoMate
Gold+ Pal [card=49,autodetected]
[   57.673300] saa7134[0]: board init: gpio is cc003f
[   57.673355] input: saa7134 IR (Compro VideoMate Go
as /devices/pci0000:00/0000:00:1e.0/0000:05:00.0/input/input7
[   57.844008] saa7134[0]: i2c eeprom 00: 5b 18 00 c2 ff ff ff ff ff ff
ff ff ff ff ff ff
[   57.844019] saa7134[0]: i2c eeprom 10: ff ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff
[   57.844029] saa7134[0]: i2c eeprom 20: ff ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff
[   57.844038] saa7134[0]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff
[   57.844047] saa7134[0]: i2c eeprom 40: ff ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff
[   57.844056] saa7134[0]: i2c eeprom 50: ff ff ff ff ff ff 01 01 ff 00
ff 00 07 34 02 cb
[   57.844065] saa7134[0]: i2c eeprom 60: ff ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff
[   57.844074] saa7134[0]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff
[   57.844083] saa7134[0]: i2c eeprom 80: ff ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff
[   57.844093] saa7134[0]: i2c eeprom 90: ff ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff
[   57.844102] saa7134[0]: i2c eeprom a0: ff ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff
[   57.844111] saa7134[0]: i2c eeprom b0: ff ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff
[   57.844125] saa7134[0]: i2c eeprom c0: ff ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff
[   57.844132] saa7134[0]: i2c eeprom d0: ff ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff
[   57.844139] saa7134[0]: i2c eeprom e0: ff ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff
[   57.844146] saa7134[0]: i2c eeprom f0: ff ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff
[   57.956579] tuner' 1-0060: chip found @ 0xc0 (saa7134[0])
[   57.956646] tea5767 1-0060: type set to Philips TEA5767HN FM Radio
[   57.972009] tuner' 1-0063: chip found @ 0xc6 (saa7134[0])
[   57.984510] tuner' 1-0068: chip found @ 0xd0 (saa7134[0])
[   58.033510] tuner-simple 1-0063: creating new instance
[   58.033514] tuner-simple 1-0063: type set to 5 (Philips PAL_BG
(FI1216 and compatibles))
[   58.040154] saa7134[0]: registered device video0 [v4l2]
[   58.040194] saa7134[0]: registered device vbi0
[   58.040229] saa7134[0]: registered device radio0
[   58.208104] saa7134 ALSA driver for DMA sound loaded
[   58.208126] saa7134[0]/alsa: saa7134[0] at 0xfebffc00 irq 16
registered as card -2

dmesg kernel 2.6.31

[   10.894197] Linux video capture interface: v2.00
[   11.064157] saa7130/34: v4l2 driver version 0.2.15 loaded
[   11.064246] saa7134 0000:05:00.0: PCI INT A -> GSI 16 (level, low) ->
IRQ 16
[   11.064251] saa7134[0]: found at 0000:05:00.0, rev: 1, irq: 16,
latency: 64, mmio: 0xfebffc00
[   11.064257] saa7134[0]: subsystem: 185b:c200, board: Compro VideoMate
Gold+ Pal [card=49,insmod option]
[   11.064268] saa7134[0]: board init: gpio is cc003f
[   11.064323] input: saa7134 IR (Compro VideoMate Go
as /devices/pci0000:00/0000:00:1e.0/0000:05:00.0/input/input5
[   11.064358] IRQ 16/saa7134[0]: IRQF_DISABLED is not guaranteed on
shared IRQs
[   11.068283] saa7146: register extension 'budget_ci dvb'.
[   11.250009] saa7134[0]: i2c eeprom 00: 5b 18 00 c2 ff ff ff ff ff ff
ff ff ff ff ff ff
[   11.250019] saa7134[0]: i2c eeprom 10: ff ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff
[   11.250028] saa7134[0]: i2c eeprom 20: ff ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff
[   11.250037] saa7134[0]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff
[   11.250046] saa7134[0]: i2c eeprom 40: ff ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff
[   11.250054] saa7134[0]: i2c eeprom 50: ff ff ff ff ff ff 01 01 ff 00
ff 00 07 34 02 cb
[   11.250063] saa7134[0]: i2c eeprom 60: ff ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff
[   11.250072] saa7134[0]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff
[   11.250081] saa7134[0]: i2c eeprom 80: ff ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff
[   11.250090] saa7134[0]: i2c eeprom 90: ff ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff
[   11.250098] saa7134[0]: i2c eeprom a0: ff ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff
[   11.250107] saa7134[0]: i2c eeprom b0: ff ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff
[   11.250116] saa7134[0]: i2c eeprom c0: ff ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff
[   11.250129] saa7134[0]: i2c eeprom d0: ff ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff
[   11.250136] saa7134[0]: i2c eeprom e0: ff ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff
[   11.250143] saa7134[0]: i2c eeprom f0: ff ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff
[   11.280006] saa7134[0]: i2c scan: found device @ 0xa0  [eeprom]
[   11.300007] saa7134[0]: i2c scan: found device @ 0xc0  [tuner
(analog)]
[   11.320008] saa7134[0]: i2c scan: found device @ 0xc6  [???]
[   11.340008] saa7134[0]: i2c scan: found device @ 0xd0  [???]
[   11.343937] i2c-adapter i2c-0: Invalid 7-bit address 0x7a
[   11.460045] tuner 0-0060: chip found @ 0xc0 (saa7134[0])
[   11.640028] tuner-simple 0-0060: creating new instance
[   11.640032] tuner-simple 0-0060: type set to 5 (Philips PAL_BG
(FI1216 and compatibles))
[   11.660150] saa7134[0]: registered device video0 [v4l2]
[   11.660169] saa7134[0]: registered device vbi0
[   11.660190] saa7134[0]: registered device radio0
[   11.660430] budget_ci dvb 0000:05:05.0: PCI INT A -> GSI 21 (level,
low) -> IRQ 21
[   11.660452] IRQ 21/: IRQF_DISABLED is not guaranteed on shared IRQs
[   11.660460] saa7146: found saa7146 @ mem ffffc90010a02800 (revision
1, irq 21) (0x13c2,0x101a).
[   11.660464] saa7146 (0): dma buffer size 192512
[   11.660467] DVB: registering new adapter (TT-Budget C-1501 PCI)
[   11.720915] adapter has MAC addr = 00:d0:5c:c6:5d:42
[   11.721151] input: Budget-CI dvb ir receiver saa7146 (0)
as /devices/pci0000:00/0000:00:1e.0/0000:05:05.0/input/input6
[   11.721312] budget_ci: CI interface initialised
[   11.803063] DVB: registering adapter 0 frontend 0 (Philips TDA10023
DVB-C)...
[   12.075129] ip6_tables: (C) 2000-2006 Netfilter Core Team
[   12.294664] saa7134 ALSA driver for DMA sound loaded
[   12.294674] IRQ 16/saa7134[0]: IRQF_DISABLED is not guaranteed on
shared IRQs
[   12.294693] saa7134[0]/alsa: saa7134[0] at 0xfebffc00 irq 16
registered as card -2

The main difference between old kernel

[   57.972009] tuner' 1-0063: chip found @ 0xc6 (saa7134[0])

and new kernel

[   11.320008] saa7134[0]: i2c scan: found device @ 0xc6  [???]

seems to be that the tuner isnt detected as such anymore and thus no
tuner-simple is created for it... I read about some changes to v4l2 /
saa7134 code which disabled a previous workaround, maybe this workaround
is needed on my tv card ?

Any help would be much appreciated !

Norman

