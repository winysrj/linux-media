Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp1.kolej.mff.cuni.cz ([78.128.192.10]:52500 "EHLO
	smtp1.kolej.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751131Ab2D3HQj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 30 Apr 2012 03:16:39 -0400
Received: from daenerys.khirnov.net (zohar.kolej.mff.cuni.cz [78.128.198.199])
	by smtp1.kolej.mff.cuni.cz (8.14.4/8.14.4) with ESMTP id q3U6TDPT052710
	for <linux-media@vger.kernel.org>; Mon, 30 Apr 2012 08:29:14 +0200 (CEST)
	(envelope-from anton@khirnov.net)
Received: from daenerys.khirnov.net (localhost [127.0.0.1])
	by daenerys.khirnov.net (Postfix) with ESMTP id 2E9E61203B6
	for <linux-media@vger.kernel.org>; Mon, 30 Apr 2012 08:29:13 +0200 (CEST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Message-ID: <20120430062913.4214.261@daenerys.khirnov.net>
Date: Mon, 30 Apr 2012 08:29:13 +0200
To: linux-media@vger.kernel.org
From: anton@khirnov.net
Subject: Pinnacle PCTV IR trouble
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Hi,
I have a Pinnacle PCTV 310i PCI DVB-T card and I have some problems with
getting the IR remote working.

The card identifies itself as:
saa7130/34: v4l2 driver version 0, 2, 17 loaded
saa7133[0]: found at 0000:02:00.0, rev: 209, irq: 16, latency: 32, mmio: 0xfe600000
saa7133[0]: subsystem: 11bd:002f, board: Pinnacle PCTV 310i [card=101,autodetected]
saa7133[0]: board init: gpio is 600e000
saa7133[0]: i2c eeprom 00: bd 11 2f 00 54 20 1c 00 43 43 a9 1c 55 d2 b2 92
saa7133[0]: i2c eeprom 10: ff e0 60 06 ff 20 ff ff 00 30 8d 36 74 54 ff ff
saa7133[0]: i2c eeprom 20: 01 2c 01 23 23 01 04 30 98 ff 00 e7 ff 21 00 c2
saa7133[0]: i2c eeprom 30: 96 10 03 32 15 20 ff 15 0e 6c a3 eb 04 e6 48 c6
saa7133[0]: i2c eeprom 40: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
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
i2c-core: driver [tuner] using legacy suspend method
i2c-core: driver [tuner] using legacy resume method
tuner 12-004b: Tuner -1 found with type(s) Radio TV.
tda829x 12-004b: setting tuner address to 61
tda829x 12-004b: type set to tda8290+75a
saa7133[0]: registered device video0 [v4l2]
saa7133[0]: registered device vbi0
saa7133[0]: registered device radio0
dvb_init() allocating 1 frontend
DVB: registering new adapter (saa7133[0])
DVB: registering adapter 0 frontend 0 (Philips TDA10046H DVB-T)...
tda1004x: setting up plls for 48MHz sampling clock
tda1004x: found firmware revision 20 -- ok
saa7134 ALSA driver for DMA sound loaded
saa7133[0]/alsa: saa7133[0] at 0xfe600000 irq 16 registered as card -1

The first problem is that with current 3.4.0-rc4 kernel the IR input
device is not recognized with
ir-kbd-i2c: : Unsupported device at address 0x47
I've found a Debian bug [1], which describes a similar problem. It has a
patch attached which fixes this. I have no idea if it's correct, but
it'd be nice to get it upstream if it is.

With the patch applied, the IR device is detected as

Registered IR keymap rc-pinnacle-color
input: i2c IR (Pinnacle PCTV) as /devices/virtual/rc/rc1/input17
rc1: i2c IR (Pinnacle PCTV) as /devices/virtual/rc/rc1
ir-kbd-i2c: i2c IR (Pinnacle PCTV) detected at i2c-12/12-0047/ir0 [saa7133[0]]

However, pressing a button on a remote results (with i2c_debug=1) in the
following messages

saa7133[0]: i2c xfer: < 8f ERROR: NO_DEVICE
i2c IR (Pinnacle PCTV)/ir: read error
saa7133[0]: i2c xfer: < 8f ERROR: NO_DEVICE
i2c IR (Pinnacle PCTV)/ir: read error
saa7133[0]: i2c xfer: < 8f ERROR: NO_DEVICE
i2c IR (Pinnacle PCTV)/ir: read error

and LIRC doesn't read anything. catting the event device spits out some
data after a few minutes, but i don't know if it's garbage or what. It's
not usable in any case

I'd much appreciate any help with this.

[1] http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=617488

-- 
Anton Khirnov
