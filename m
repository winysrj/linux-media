Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-13.arcor-online.net ([151.189.21.53]:46172 "EHLO
	mail-in-13.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755546AbZDDAuF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 3 Apr 2009 20:50:05 -0400
Subject: Re: Kernel 2.6.29 breaks DVB-T ASUSTeK Tiger LNA Hybrid Capture
	Device
From: hermann pitton <hermann-pitton@arcor.de>
To: Ralph <ramsoft@virgilio.it>
Cc: linux-media@vger.kernel.org
In-Reply-To: <loom.20090403T201901-786@post.gmane.org>
References: <loom.20090403T201901-786@post.gmane.org>
Content-Type: text/plain
Date: Sat, 04 Apr 2009 02:45:12 +0200
Message-Id: <1238805912.3498.18.camel@pc07.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Ralph,

Am Freitag, den 03.04.2009, 20:49 +0000 schrieb Ralph:
> ASUSTeK Tiger LNA Hybrid Capture Device PCI - Analog/DVB-T card
> Multimedia controller: Philips Semiconductors SAA7131/SAA7133/SAA7135 Video
> Broadcast Decoder (rev d1)
> 
> Works perfectly with kernel 2.6.28.4 (or older).
> Recently, I have switched to 2.6.29 (same .config as 2.6.28.4) and now, at
> boot
> time, I get the message:
> 
> IRQ 18/saa7133[0]: IRQF_DISABLED is not guaranteed on shared IRQs
> 
> Signal strength is very low and Kaffeine is unable to tune in any channel.
> Same problem with kernel 2.6.29.1
> 
> -------------------------------------
> 
> Messages from /var/log/dmesg
> 
> saa7134 0000:03:0a.0: PCI INT A -> Link[APC3] -> GSI 18 (level, low) -> \
>  IRQ 18
> saa7133[0]: found at 0000:03:0a.0, rev: 209, irq: 18, latency: 32, mmio: \
> 0xfdefe000
> saa7133[0]: subsystem: 1043:4871, board: ASUS P7131 4871 \
> [card=111,autodetected]
> saa7133[0]: board init: gpio is 0
> IRQ 18/saa7133[0]: IRQF_DISABLED is not guaranteed on shared IRQs
> saa7133[0]: i2c eeprom 00: 43 10 71 48 54 20 1c 00 43 43 a9 1c 55 d2 b2 92
> saa7133[0]: i2c eeprom 10: ff ff ff 0f ff 20 ff ff ff ff ff ff ff ff ff ff
> saa7133[0]: i2c eeprom 20: 01 40 01 02 03 00 01 03 08 ff 00 cf ff ff ff ff
> saa7133[0]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> saa7133[0]: i2c eeprom 40: ff 21 00 c2 96 10 03 22 15 50 ff ff ff ff ff ff
> saa7133[0]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> saa7133[0]: i2c eeprom 60: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> saa7133[0]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> saa7133[0]: i2c eeprom 80: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> saa7133[0]: i2c eeprom 90: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> saa7133[0]: i2c eeprom a0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> saa7133[0]: i2c eeprom b0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> saa7133[0]: i2c eeprom c0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> saa7133[0]: i2c eeprom d0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> saa7133[0]: i2c eeprom e0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> saa7133[0]: i2c eeprom f0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> tuner' 2-004b: chip found @ 0x96 (saa7133[0])
> tda829x 2-004b: setting tuner address to 61
> tda829x 2-004b: type set to tda8290+75a
> saa7133[0]: registered device video0 [v4l2]
> saa7133[0]: registered device vbi0
> dvb_init() allocating 1 frontend
> DVB: registering new adapter (saa7133[0])
> DVB: registering adapter 0 frontend -32769 (Philips TDA10046H DVB-T)...
> tda1004x: setting up plls for 48MHz sampling clock
> tda1004x: timeout waiting for DSP ready
> tda1004x: found firmware revision 0 -- invalid
> tda1004x: trying to boot from eeprom
> tda1004x: timeout waiting for DSP ready
> tda1004x: found firmware revision 0 -- invalid
> tda1004x: waiting for firmware upload...
> saa7134 0000:03:0a.0: firmware: requesting dvb-fe-tda10046.fw
> tda1004x: found firmware revision 29 -- ok
> saa7134 ALSA driver for DMA sound loaded
> IRQ 18/saa7133[0]: IRQF_DISABLED is not guaranteed on shared IRQs
> saa7133[0]/alsa: saa7133[0] at 0xfdefe000 irq 18 registered as card -1
> 

thanks for your report, as announced previously, I unfortunately did not
have time to run with latest always ... (guess why ...)

The driver always worked with shared IRQs, if not, it was always a
limitation of certain hardware or mostly in some combination with binary
only drivers.

If the above should be the case in general now, and not only caused by
some blacklist, no print out in that direction, the driver is pretty
broken again.

I for sure don't have all for last months, but that
"IRQF_DISABLED is not guaranteed on shared IRQs" for sure does not come
from us here.

Cheers,
Hermann







