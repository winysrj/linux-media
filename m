Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f178.google.com ([209.85.218.178]:34224 "EHLO
	mail-bw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751573AbZCFLMc (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 6 Mar 2009 06:12:32 -0500
Received: by bwz26 with SMTP id 26so314976bwz.37
        for <linux-media@vger.kernel.org>; Fri, 06 Mar 2009 03:12:29 -0800 (PST)
MIME-Version: 1.0
Date: Fri, 6 Mar 2009 12:12:28 +0100
Message-ID: <7075858d0903060312o6c126685q4701b299eb544320@mail.gmail.com>
Subject: Lifeview FlyDVB Hybrid PCI (LR-306N): doesn't work anymore
From: Mario Chisari <mc-v4l@sganawa.org>
To: Linux Media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,
I own a Lifeview FlyDVB Hybrid LR-306N model; it is a PCI model, and
I've been happily using it with my Mythtv for a couple of years,
despite it was identified as a Cardbus model. About two months ago, I
have upgraded kernel, and since then DVB function doesn't work
anymore.

I've checked what's changed, and I've noticed /var/log/messages once
was something like:

Dec 28 14:07:02 mumonkan kernel: [   56.651901] saa7130/34: v4l2
driver version 0.2.14 loaded
Dec 28 14:07:02 mumonkan kernel: [   57.249000] saa7133[0]: found at
0000:00:09.0, rev: 208, irq: 19, latency: 32, mmio: 0xfebfe800
Dec 28 14:07:02 mumonkan kernel: [   57.249083] saa7133[0]:
subsystem:5168:3306, board: LifeView FlyDVB-T Hybrid Cardbus/MSI TV
@nywhere A/D NB [card=94,autodetected]
Dec 28 14:07:02 mumonkan kernel: [   57.249173] saa7133[0]: board
init: gpio is 210000
Dec 28 14:07:02 mumonkan kernel: [   57.381216] saa7133[0]: i2c eeprom
00: 68 51 06 33 54 20 1c 00 43 43 a9 1c 55 d2 b2 92
Dec 28 14:07:02 mumonkan kernel: [   57.382161] saa7133[0]: i2c eeprom
10: 00 00 62 08 ff 20 ff ff ff ff ff ff ff ff ff ff
Dec 28 14:07:02 mumonkan kernel: [   57.383096] saa7133[0]: i2c eeprom
20: 01 40 01 03 03 01 01 03 08 ff 01 16 ff ff ff ff
Dec 28 14:07:02 mumonkan kernel: [   57.384032] saa7133[0]: i2c eeprom
30: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
Dec 28 14:07:02 mumonkan kernel: [   57.384967] saa7133[0]: i2c eeprom
40: ff 21 00 c2 96 10 05 01 01 16 32 15 ff ff ff ff
Dec 28 14:07:02 mumonkan kernel: [   57.385911] saa7133[0]: i2c eeprom
50: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
Dec 28 14:07:02 mumonkan kernel: [   57.386848] saa7133[0]: i2c eeprom
60: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
Dec 28 14:07:02 mumonkan kernel: [   57.387783] saa7133[0]: i2c eeprom
70: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
Dec 28 14:07:02 mumonkan kernel: [   57.400815] saa7133[0]: registered
device video0 [v4l2]
Dec 28 14:07:02 mumonkan kernel: [   57.400995] saa7133[0]: registered
device vbi0
Dec 28 14:07:02 mumonkan kernel: [   57.401173] saa7133[0]: registered
device radio0
Dec 28 14:07:02 mumonkan kernel: [  129.568135] DVB: registering new
adapter (saa7133[0])
Dec 28 14:07:02 mumonkan kernel: [  129.568234] DVB: registering
frontend 0 (Philips TDA10046H DVB-T)...
Dec 28 14:07:02 mumonkan kernel: [  129.638878] tda1004x: setting up
plls for 48MHz sampling clock
Dec 28 14:07:02 mumonkan kernel: [  131.632829] tda1004x: found
firmware revision 29 -- ok

Now it goes like this:

Feb 13 22:53:06 mumonkan [    7.138352] saa7130/34: v4l2 driver
version 0.2.14 loaded
Feb 13 22:53:06 mumonkan [    8.089793] saa7134 0000:00:09.0: PCI INT
A -> GSI 17 (level, low) -> IRQ 17
Feb 13 22:53:06 mumonkan [    8.089800] saa7133[0]: found at
0000:00:09.0, rev: 208, irq: 17, latency: 32, mmio: 0xfebfe800
Feb 13 22:53:06 mumonkan [    8.089808] saa7133[0]: subsystem:
5168:3306, board: LifeView FlyDVB-T Hybrid Cardbus/MSI TV @nywhere A/D
NB [card=94,autodetected]
Feb 13 22:53:06 mumonkan [    8.089827] saa7133[0]: board init: gpio is 210000
Feb 13 22:53:06 mumonkan [    8.240008] saa7133[0]: i2c eeprom 00: 68
51 06 33 54 20 1c 00 43 43 a9 1c 55 d2 b2 92
Feb 13 22:53:06 mumonkan [    8.240019] saa7133[0]: i2c eeprom 10: 00
00 62 08 ff 20 ff ff ff ff ff ff ff ff ff ff
Feb 13 22:53:06 mumonkan [    8.240027] saa7133[0]: i2c eeprom 20: 01
40 01 03 03 01 01 03 08 ff 01 16 ff ff ff ff
Feb 13 22:53:06 mumonkan [    8.240036] saa7133[0]: i2c eeprom 30: ff
ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
Feb 13 22:53:06 mumonkan [    8.240044] saa7133[0]: i2c eeprom 40: ff
21 00 c2 96 10 05 01 01 16 32 15 ff ff ff ff
Feb 13 22:53:06 mumonkan [    8.240052] saa7133[0]: i2c eeprom 50: ff
ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
Feb 13 22:53:06 mumonkan [    8.240060] saa7133[0]: i2c eeprom 60: ff
ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
Feb 13 22:53:06 mumonkan [    8.240068] saa7133[0]: i2c eeprom 70: ff
ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
Feb 13 22:53:06 mumonkan [    8.240076] saa7133[0]: i2c eeprom 80: ff
ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
Feb 13 22:53:06 mumonkan [    8.240084] saa7133[0]: i2c eeprom 90: ff
ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
Feb 13 22:53:06 mumonkan [    8.240092] saa7133[0]: i2c eeprom a0: ff
ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
Feb 13 22:53:06 mumonkan [    8.240100] saa7133[0]: i2c eeprom b0: ff
ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
Feb 13 22:53:06 mumonkan [    8.240108] saa7133[0]: i2c eeprom c0: ff
ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
Feb 13 22:53:06 mumonkan [    8.240116] saa7133[0]: i2c eeprom d0: ff
ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
Feb 13 22:53:06 mumonkan [    8.240124] saa7133[0]: i2c eeprom e0: ff
ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
Feb 13 22:53:06 mumonkan [    8.240132] saa7133[0]: i2c eeprom f0: ff
ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
Feb 13 22:53:06 mumonkan [    8.352063] tuner' 0-004b: chip found @
0x96 (saa7133[0])
Feb 13 22:53:06 mumonkan [    8.440007] tda829x 0-004b: setting tuner
address to 61
Feb 13 22:53:06 mumonkan [    8.508506] tda829x 0-004b: type set to tda8290+75a
Feb 13 22:53:06 mumonkan [   12.341578] saa7133[0]: registered device
video0 [v4l2]
Feb 13 22:53:06 mumonkan [   12.341611] saa7133[0]: registered device vbi0
Feb 13 22:53:06 mumonkan [   12.341634] saa7133[0]: registered device radio0
Feb 13 22:53:06 mumonkan [   12.840571] DVB: registering new adapter
(saa7133[0])
Feb 13 22:53:06 mumonkan [   12.840578] DVB: registering frontend 0
(Philips TDA10046H DVB-T)...
Feb 13 22:53:06 mumonkan [   12.912507] tda1004x: setting up plls for
48MHz sampling clock
Feb 13 22:53:06 mumonkan [   15.156506] tda1004x: timeout waiting for DSP ready
Feb 13 22:53:06 mumonkan [   15.196504] tda1004x: found firmware
revision 0 -- invalid
Feb 13 22:53:06 mumonkan [   15.196507] tda1004x: trying to boot from eeprom
Feb 13 22:53:06 mumonkan [   17.524007] tda1004x: timeout waiting for DSP ready
Feb 13 22:53:06 mumonkan [   17.564005] tda1004x: found firmware
revision 0 -- invalid
Feb 13 22:53:06 mumonkan [   17.564007] tda1004x: waiting for firmware upload...
Feb 13 22:53:06 mumonkan [   17.564011] firmware: requesting dvb-fe-tda10046.fw
Feb 13 22:53:06 mumonkan [   30.084007] tda1004x: found firmware
revision 20 -- ok

If I understand correctly, the main difference is that now tda1004x
module seems to be unable to recognize already present firmware rev 29
(failing to start/un-reset device?). So it tries to load a new
firmware, rev 20; maybe because of this, maybe because of an incorrect
resetting procedure, anyway it doesn't work on my board: if I try to
tune any station with tzap, I sometimes get FE_HAS_LOCK, sometimes I
don't, but as I try to display video with mplayer I always get no
video/audio (actually most of the times mplayer doesn't even show a
window).
Actually, this is what happens since mid-february or so, after most
recent changes to saa7134 module. Before that, the board was almost
non-working, but behaviour was far less consistent. Usually tda1004x
module, after trying loading firmware several times, gave up.
Sometimes it started with firmware ver 20, and very rarely it was even
usable, but frequently the board went stuck when changing channel, and
stopped tuning anything anymore.
Another oddity is that now analog TV consistently works with tvtime
after the first channel change; that was not the case before. Just for
record, it still doesn't work with mythtv (no tune while scanning),
but this is a no wonder... However, no analog, no DVB-T, so no media
center...

I've tried going back in time, pulling from mercurial old versions
trying to determine which patch had broken things, but I wasn't unable
to compile older (than 8848?) versions with my current kernel, so I
had to give up.
So... what's changed in the driver over the last year that stopped it
working? It was OK with kernel 2.6.24.

Thanks.
