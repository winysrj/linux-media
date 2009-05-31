Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.velocitynet.com.au ([203.17.154.25]:42867 "EHLO
	m0.velocity.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753244AbZEaILN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 31 May 2009 04:11:13 -0400
Received: from webmail.velocity.net.au (unknown [203.17.154.9])
	by m0.velocity.net.au (Postfix) with ESMTP id 8642060370
	for <linux-media@vger.kernel.org>; Sun, 31 May 2009 18:11:13 +1000 (EST)
Message-ID: <49254.202.168.20.241.1243757473.squirrel@webmail.velocity.net.au>
Date: Sun, 31 May 2009 18:11:13 +1000 (EST)
Subject: RE: Leadtek Winfast DTV-1000S
From: paul10@planar.id.au
To: linux-media@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

OK, I've gone the next step and downloaded the hvr1200 firmware for the  
using this link: steventoth.net/linux/hvr1200

I'm still not getting tuning, it isn't clear whether this is due to the
firmware or the other errors in the log.  Again, my logs have messages
from all three cards, including the 7134-based Avermedia.  I'm extracting
the messages that look like they relate to the DTV1000S, I'm happy to post
either the full log or to unplug the other two cards.  If I need to do the
latter, that means I need to wait for a time where the box isn't supposed
to be recording something - as it is also my production box, and WAF is
currently quite high :-)

The dmesg logs are:
[   10.232789] saa7130/34: v4l2 driver version 0.2.15 loaded
[   10.241194] saa7134 0000:05:00.0: PCI INT A -> GSI 20 (level, low) ->
IRQ 20
[   10.249731] saa7130[0]: found at 0000:05:00.0, rev: 1, irq: 20,
latency: 32, mmio: 0xfc001000
[   10.258483] saa7130[0]: subsystem: 107d:6655, board: Hauppauge
WinTV-HVR1110r3 DVB-T/Hybrid [card=156,insmod option]
[   10.267477] saa7130[0]: board init: gpio is 122009
[   10.293131] cx88/0: cx2388x v4l2 driver version 0.0.7 loaded
[   10.302052] IRQ 20/saa7130[0]: IRQF_DISABLED is not guaranteed on
shared IRQs
[   10.312626] cx88/2: cx2388x MPEG-TS Driver Manager version 0.0.7 loaded
[   10.353716] cx2388x alsa driver version 0.0.7 loaded
[   10.400854] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 22 (level, low) ->
IRQ 22
[   10.410254] HDA Intel 0000:00:1b.0: setting latency timer to 64
[   10.464031] saa7130[0]: i2c eeprom 00: 7d 10 55 66 54 20 1c 00 43 43 a9
1c 55 d2 b2 92
[   10.473672] saa7130[0]: i2c eeprom 10: 00 ff 82 0e ff 20 ff ff ff ff ff
ff ff ff ff ff
[   10.483379] saa7130[0]: i2c eeprom 20: 01 40 01 01 01 ff 01 03 08 ff 00
8a ff ff ff ff
[   10.492999] saa7130[0]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff ff ff
ff ff ff ff ff
[   10.502537] saa7130[0]: i2c eeprom 40: ff 35 00 c0 00 10 03 02 ff 04 ff
ff ff ff ff ff
[   10.512026] saa7130[0]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff ff ff
ff ff ff ff ff
[   10.521514] saa7130[0]: i2c eeprom 60: ff ff ff ff ff ff ff ff ff ff ff
ff ff ff ff ff
[   10.530935] saa7130[0]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff ff ff
ff ff ff ff ff
[   10.540418] saa7130[0]: i2c eeprom 80: ff ff ff ff ff ff ff ff ff ff ff
ff ff ff ff ff
[   10.549677] saa7130[0]: i2c eeprom 90: ff ff ff ff ff ff ff ff ff ff ff
ff ff ff ff ff
[   10.558693] saa7130[0]: i2c eeprom a0: ff ff ff ff ff ff ff ff ff ff ff
ff ff ff ff ff
[   10.567617] saa7130[0]: i2c eeprom b0: ff ff ff ff ff ff ff ff ff ff ff
ff ff ff ff ff
[   10.567739] saa7130[0]: i2c eeprom c0: ff ff ff ff ff ff ff ff ff ff ff
ff ff ff ff ff
[   10.567746] saa7130[0]: i2c eeprom d0: ff ff ff ff ff ff ff ff ff ff ff
ff ff ff ff ff
[   10.567753] saa7130[0]: i2c eeprom e0: ff ff ff ff ff ff ff ff ff ff ff
ff ff ff ff ff
[   10.567758] saa7130[0]: i2c eeprom f0: ff ff ff ff ff ff ff ff ff ff ff
ff ff ff ff ff
[   10.567765] tveeprom 1-0050: Encountered bad packet header [ff].
Corrupt or not a Hauppauge eeprom.
[   10.567767] saa7130[0]: warning: unknown hauppauge model #0
[   10.567768] saa7130[0]: hauppauge eeprom: model=0
[   10.712041] Chip ID is not zero. It is not a TEA5767
[   10.720138] tuner 1-0060: chip found @ 0xc0 (saa7130[0])
[   10.768020] tda8290: no gate control were provided!
[   10.775900] tuner 1-0060: Tuner has no way to set tv freq
[   10.783718] tuner 1-0060: Tuner has no way to set tv freq
[   10.791567] saa7130[0]: registered device video0 [v4l2]
[   10.799359] saa7130[0]: registered device vbi0
[   10.807034] saa7130[0]: registered device radio0

<some stuff from another card (I think)>

[   12.273033] DVB: registering new adapter (saa7130[0])
[   12.281372] DVB: registering adapter 1 frontend 0 (NXP TDA10048HN
DVB-T)...
[   12.617026] tda10048_firmware_upload: waiting for firmware upload
(dvb-fe-tda10048-1.0.fw)...
[   12.617029] saa7134 0000:05:00.0: firmware: requesting
dvb-fe-tda10048-1.0.fw
[   12.694154] EXT3 FS on md21, internal journal
[   12.709531] tda10048_firmware_upload: firmware read 24878 bytes.
[   12.718281] tda10048_firmware_upload: firmware uploading

<some more stuff that doesn't look related>

[   16.820022] tda10048_firmware_upload: firmware uploaded
[   16.944017] dvb_init() allocating 1 frontend
[   17.005238] tuner-simple 3-0061: unable to probe Philips TD1316 Hybrid
Tuner, proceeding anyway.<6>tuner-simple 3-0061: creating new instance
[   17.013309] tuner-simple 3-0061: type set to 67 (Philips TD1316 Hybrid
Tuner)
[   17.021250] DVB: registering new adapter (saa7134[1])
[   17.029133] DVB: registering adapter 2 frontend 0 (Zarlink MT352 DVB-T)...

<I think those last two lines relate to the Avermedia, but not sure>


http://drivers.softpedia.com/get/TV-Tuner-Co/LEADTEK/Leadtek-WinFast-DTV1000S-XP-Driver-20070907-WHQL.shtml

