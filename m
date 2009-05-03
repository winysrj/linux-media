Return-path: <linux-media-owner@vger.kernel.org>
Received: from ch-smtp02.sth.basefarm.net ([80.76.149.213]:45551 "EHLO
	ch-smtp02.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752525AbZECH4Z (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 3 May 2009 03:56:25 -0400
To: linux-media@vger.kernel.org, video4linux-list@redhat.com,
	kraxel@bytesex.org
Subject: saa7134/2.6.26 regression, noisy output
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Date: Sun, 03 May 2009 09:56:08 +0200
From: Anders Eriksson <aeriksson@fastmail.fm>
Message-Id: <20090503075609.0A73B2C4152@tippex.mynet.homeunix.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Hi all,

I've got a
saa7133[0]: subsystem: 11bd:002f, board: Pinnacle PCTV 310i [card=101,autodetected]

In all kernels later than 2.6.25 there is a significant layer of noise added to
the video output. I've tried to bisect the problem, and it was introduced
somewhere between  1fe8736955515f5075bef05c366b2d145d29cd44 (good) and
99e09eac25f752b25f65392da7bd747b77040fea (bad). Unfortunately, all commits
between those two either don't compile, or oops in the v4l subsystem.

I've tried the latest 30-rc and the problem is still there. Any idea how to 
proceed for here? I can provide screenshots on request.

Here's the relevant chunk from demsg on 2.6.25:
Linux video capture interface: v2.00
saa7130/34: v4l2 driver version 0.2.14 loaded
saa7133[0]: found at 0000:03:06.0, rev: 209, irq: 21, latency: 64, mmio: 0xfdeff000
saa7133[0]: subsystem: 11bd:002f, board: Pinnacle PCTV 310i [card=101,autodetected]
saa7133[0]: board init: gpio is 600c000
saa7133[0]: i2c eeprom 00: bd 11 2f 00 54 20 1c 00 43 43 a9 1c 55 d2 b2 92
saa7133[0]: i2c eeprom 10: ff e0 60 06 ff 20 ff ff 00 30 8d 36 5b e2 ff ff
saa7133[0]: i2c eeprom 20: 01 2c 01 23 23 01 04 30 98 ff 00 e7 ff 21 00 c2
saa7133[0]: i2c eeprom 30: 96 10 03 32 15 20 ff 15 0e 6c a3 eb 04 50 de 7d
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
tuner' 1-004b: chip found @ 0x96 (saa7133[0])
tda8290 1-004b: setting tuner address to 61
tda8290 1-004b: type set to tda8290+75a
saa7133[0]: registered device video0 [v4l2]
saa7133[0]: registered device vbi0
saa7133[0]: registered device radio0
saa7134 ALSA driver for DMA sound loaded
saa7133[0]/alsa: saa7133[0] at 0xfdeff000 irq 21 registered as card -1
DVB: registering new adapter (saa7133[0])
DVB: registering frontend 0 (Philips TDA10046H DVB-T)...
tda1004x: setting up plls for 48MHz sampling clock
tda1004x: found firmware revision 20 -- ok

All help appreciated,
-Anders

