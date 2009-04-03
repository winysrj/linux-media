Return-path: <linux-media-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.229.2]:58418 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753017AbZDCVPG (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 3 Apr 2009 17:15:06 -0400
Received: from root by ciao.gmane.org with local (Exim 4.43)
	id 1Lpqj8-0003ol-P8
	for linux-media@vger.kernel.org; Fri, 03 Apr 2009 21:15:02 +0000
Received: from host113-62-dynamic.33-79-r.retail.telecomitalia.it ([79.33.62.113])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Fri, 03 Apr 2009 21:15:02 +0000
Received: from ramsoft by host113-62-dynamic.33-79-r.retail.telecomitalia.it with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Fri, 03 Apr 2009 21:15:02 +0000
To: linux-media@vger.kernel.org
From: Ralph <ramsoft@virgilio.it>
Subject: Kernel 2.6.29 breaks DVB-T ASUSTeK Tiger LNA Hybrid Capture Device
Date: Fri, 3 Apr 2009 20:49:20 +0000 (UTC)
Message-ID: <loom.20090403T201901-786@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

ASUSTeK Tiger LNA Hybrid Capture Device PCI - Analog/DVB-T card
Multimedia controller: Philips Semiconductors SAA7131/SAA7133/SAA7135 Video
Broadcast Decoder (rev d1)

Works perfectly with kernel 2.6.28.4 (or older).
Recently, I have switched to 2.6.29 (same .config as 2.6.28.4) and now, at
boot
time, I get the message:

IRQ 18/saa7133[0]: IRQF_DISABLED is not guaranteed on shared IRQs

Signal strength is very low and Kaffeine is unable to tune in any channel.
Same problem with kernel 2.6.29.1

-------------------------------------

Messages from /var/log/dmesg

saa7134 0000:03:0a.0: PCI INT A -> Link[APC3] -> GSI 18 (level, low) -> \
 IRQ 18
saa7133[0]: found at 0000:03:0a.0, rev: 209, irq: 18, latency: 32, mmio: \
0xfdefe000
saa7133[0]: subsystem: 1043:4871, board: ASUS P7131 4871 \
[card=111,autodetected]
saa7133[0]: board init: gpio is 0
IRQ 18/saa7133[0]: IRQF_DISABLED is not guaranteed on shared IRQs
saa7133[0]: i2c eeprom 00: 43 10 71 48 54 20 1c 00 43 43 a9 1c 55 d2 b2 92
saa7133[0]: i2c eeprom 10: ff ff ff 0f ff 20 ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 20: 01 40 01 02 03 00 01 03 08 ff 00 cf ff ff ff ff
saa7133[0]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 40: ff 21 00 c2 96 10 03 22 15 50 ff ff ff ff ff ff
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
tuner' 2-004b: chip found @ 0x96 (saa7133[0])
tda829x 2-004b: setting tuner address to 61
tda829x 2-004b: type set to tda8290+75a
saa7133[0]: registered device video0 [v4l2]
saa7133[0]: registered device vbi0
dvb_init() allocating 1 frontend
DVB: registering new adapter (saa7133[0])
DVB: registering adapter 0 frontend -32769 (Philips TDA10046H DVB-T)...
tda1004x: setting up plls for 48MHz sampling clock
tda1004x: timeout waiting for DSP ready
tda1004x: found firmware revision 0 -- invalid
tda1004x: trying to boot from eeprom
tda1004x: timeout waiting for DSP ready
tda1004x: found firmware revision 0 -- invalid
tda1004x: waiting for firmware upload...
saa7134 0000:03:0a.0: firmware: requesting dvb-fe-tda10046.fw
tda1004x: found firmware revision 29 -- ok
saa7134 ALSA driver for DMA sound loaded
IRQ 18/saa7133[0]: IRQF_DISABLED is not guaranteed on shared IRQs
saa7133[0]/alsa: saa7133[0] at 0xfdefe000 irq 18 registered as card -1

--------------------------------------------


