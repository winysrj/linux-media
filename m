Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail11.tpgi.com.au ([203.12.160.161]:35147 "EHLO
	mail11.tpgi.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750716AbZCNFOY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 14 Mar 2009 01:14:24 -0400
Received: from [10.1.1.2] (60-240-145-26.tpgi.com.au [60.240.145.26])
	(authenticated bits=0)
	by mail11.tpgi.com.au (envelope-from certain@tpg.com.au) (8.14.3/8.14.3) with ESMTP id n2E5EIiX017492
	for <linux-media@vger.kernel.org>; Sat, 14 Mar 2009 16:14:20 +1100
Subject: Compro T750F - frontend initialization failing
From: Andrew Reay <certain@tpg.com.au>
To: linux-media@vger.kernel.org
In-Reply-To: <49B982A5.7010103@august.de>
References: <49B982A5.7010103@august.de>
Content-Type: text/plain
Date: Sat, 14 Mar 2009 15:14:18 +1000
Message-Id: <1237007658.19797.0.camel@desktop>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Everyone,

I'm having trouble with getting the Compro Video T750F to work under
Ubuntu 8.10. I had the Compro T300 working great but this card is still
eluding me.

Any suggestions on how to proceed from here?

The dmesg is posted below.

Thanks,
Andrew

[ 13.317113] saa7130/34: v4l2 driver version 0.2.14 loaded
[ 13.317703] ACPI: PCI Interrupt Link [APC1] enabled at IRQ 16
[ 13.317709] saa7134 0000:04:08.0: PCI INT A -> Link[APC1] -> GSI 16
(level, low) -> IRQ 16
[ 13.317716] saa7133[0]: found at 0000:04:08.0, rev: 209, irq: 16,
latency: 32, mmio: 0xfdbfe000
[ 13.317723] saa7133[0]: subsystem: 185b:c900, board: Compro VideoMate
T750 [card=139,autodetected]
[ 13.317734] saa7133[0]: board init: gpio is 84bf00
[ 13.317746] saa7133[0]: Oops: IR config error [card=139]
[ 13.476035] saa7133[0]: i2c eeprom 00: 5b 18 00 c9 54 20 1c 00 43 43 a9
1c 55 d2 b2 92
[ 13.476046] saa7133[0]: i2c eeprom 10: 00 ff 86 0f ff 20 ff ff ff ff ff
ff ff ff ff ff
[ 13.476055] saa7133[0]: i2c eeprom 20: 01 40 01 02 02 01 03 01 08 ff 00
87 ff ff ff ff
[ 13.476064] saa7133[0]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff ff ff
ff ff ff ff ff
[ 13.476072] saa7133[0]: i2c eeprom 40: ff d7 00 c4 86 1e 05 ff 02 c2 ff
01 c6 ff 05 ff
[ 13.476081] saa7133[0]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff ff ff
ff ff ff ff cb
[ 13.476089] saa7133[0]: i2c eeprom 60: 35 ff ff ff ff ff ff ff ff ff ff
ff ff ff ff ff
[ 13.476098] saa7133[0]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff ff ff
ff ff ff ff ff
[ 13.476106] saa7133[0]: i2c eeprom 80: ff ff ff ff ff ff ff ff ff ff ff
ff ff ff ff ff
[ 13.476115] saa7133[0]: i2c eeprom 90: ff ff ff ff ff ff ff ff ff ff ff
ff ff ff ff ff
[ 13.476123] saa7133[0]: i2c eeprom a0: ff ff ff ff ff ff ff ff ff ff ff
ff ff ff ff ff
[ 13.476132] saa7133[0]: i2c eeprom b0: ff ff ff ff ff ff ff ff ff ff ff
ff ff ff ff ff
[ 13.476140] saa7133[0]: i2c eeprom c0: ff ff ff ff ff ff ff ff ff ff ff
ff ff ff ff ff
[ 13.476149] saa7133[0]: i2c eeprom d0: ff ff ff ff ff ff ff ff ff ff ff
ff ff ff ff ff
[ 13.476157] saa7133[0]: i2c eeprom e0: ff ff ff ff ff ff ff ff ff ff ff
ff ff ff ff ff
[ 13.476166] saa7133[0]: i2c eeprom f0: ff ff ff ff ff ff ff ff ff ff ff
ff ff ff ff ff
[ 13.508082] tuner 2-0062: chip found @ 0xc4 (saa7133[0])
[ 13.548912] xc2028 2-0062: creating new instance
[ 13.548916] xc2028 2-0062: type set to XCeive xc2028/xc3028 tuner
[ 13.548926] firmware: requesting xc3028-v27.fw
[ 13.999716] input: ImPS/2 Generic Wheel Mouse
as /devices/platform/i8042/serio1/input/input5
[ 14.055433] xc2028 2-0062: Loading 80 firmware images from
xc3028-v27.fw, type: xc2028 firmware, ver 2.7
[ 14.055534] xc2028 2-0062: Loading firmware for type=BASE F8MHZ MTS
(7), id 0000000000000000.
[ 14.055940] xc2028 2-0062: i2c output error: rc = -5 (should be 64)
[ 14.055943] xc2028 2-0062: -5 returned from send
[ 14.055947] xc2028 2-0062: Error -22 while loading base firmware
[ 14.108032] xc2028 2-0062: Loading firmware for type=BASE F8MHZ MTS
(7), id 0000000000000000.
[ 14.108570] xc2028 2-0062: i2c output error: rc = -5 (should be 64)
[ 14.108573] xc2028 2-0062: -5 returned from send
[ 14.108576] xc2028 2-0062: Error -22 while loading base firmware
[ 14.108589] xc2028 2-0062: Loading firmware for type=BASE F8MHZ MTS
(7), id 0000000000000000.
[ 14.109126] xc2028 2-0062: i2c output error: rc = -5 (should be 64)
[ 14.109128] xc2028 2-0062: -5 returned from send
[ 14.109131] xc2028 2-0062: Error -22 while loading base firmware
[ 14.165021] xc2028 2-0062: Loading firmware for type=BASE F8MHZ MTS
(7), id 0000000000000000.
[ 14.165555] xc2028 2-0062: i2c output error: rc = -5 (should be 64)
[ 14.165557] xc2028 2-0062: -5 returned from send
[ 14.165560] xc2028 2-0062: Error -22 while loading base firmware
[ 14.166394] xc2028 2-0062: Error on line 1124: -5
[ 14.173289] saa7133[0]: registered device video0 [v4l2]
[ 14.173451] saa7133[0]: registered device vbi0
[ 14.173507] saa7133[0]: registered device radio0
[ 14.174059] ACPI: PCI Interrupt Link [AAZA] enabled at IRQ 23
[ 14.174064] HDA Intel 0000:00:10.1: PCI INT B -> Link[AAZA] -> GSI 23
(level, low) -> IRQ 23
[ 14.174089] HDA Intel 0000:00:10.1: setting latency timer to 64
[ 14.196322] saa7134 ALSA driver for DMA sound loaded
[ 14.196353] saa7133[0]/alsa: saa7133[0] at 0xfdbfe000 irq 16 registered
as card -2
[ 14.337099] dvb_init() allocating 1 frontend
[ 14.337105] saa7133[0]/dvb: Huh? unknown DVB card?
[ 14.337108] saa7133[0]/dvb: frontend initialization failed

