Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp20.orange.fr ([80.12.242.27]:40827 "EHLO smtp20.orange.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751944AbZGDNQp (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 4 Jul 2009 09:16:45 -0400
Received: from me-wanadoo.net (localhost [127.0.0.1])
	by mwinf2011.orange.fr (SMTP Server) with ESMTP id F272520000A7
	for <linux-media@vger.kernel.org>; Sat,  4 Jul 2009 15:16:45 +0200 (CEST)
Received: from neptune.localwarp.net (ARennes-359-1-78-243.w86-199.abo.wanadoo.fr [86.199.237.243])
	by mwinf2011.orange.fr (SMTP Server) with ESMTP id 91C12200009F
	for <linux-media@vger.kernel.org>; Sat,  4 Jul 2009 15:16:45 +0200 (CEST)
Received: (from bruno@localhost)
	by neptune.localwarp.net (8.11.7/8.11.3) id n64DGiQ04366
	for linux-media@vger.kernel.org; Sat, 4 Jul 2009 15:16:44 +0200
Message-Id: <200907041316.n64DGiQ04366@neptune.localwarp.net>
Date: Sat, 4 Jul 2009 15:16:22 +0200 (CEST)
From: eric.paturage@orange.fr
Reply-To: eric.paturage@orange.fr
Subject: regression : saa7134  with Pinnacle PCTV 50i (analog) can not tune
 anymore
To: linux-media@vger.kernel.org
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

hello 

I had my  Pinnacle PCTV 50i analog tv card working quite well for several years
with linux . but since mid june it can not tune anymore when using the latest mercurial version 
of the v4l2 drivers . 
It is working fine up to the official V4l2 driver of 2.6.30 .


here is an example of /var/log/messages with official v4l2 drivers of 2.6.27.4 (working well) :

 saa7130/34: v4l2 driver version 0.2.14 loaded
 ACPI: PCI Interrupt Link [LNKA] enabled at IRQ 11
 saa7134 0000:00:0d.0: PCI INT A -> Link[LNKA] -> GSI 11 (level, low) -> IRQ 11
 saa7133[0]: found at 0000:00:0d.0, rev: 208, irq: 11, latency: 32, mmio: 0xed800000
 saa7133[0]: subsystem: 11bd:002e, board: Pinnacle PCTV 40i/50i/110i (saa7133) [card=77,autodetected]
 saa7133[0]: board init: gpio is 200c000
 saa7133[0]: i2c eeprom 00: bd 11 2e 00 54 20 1c 00 43 43 a9 1c 55 d2 b2 92
 saa7133[0]: i2c eeprom 10: ff e0 60 02 ff 20 ff ff ff ff ff ff ff ff ff ff
 saa7133[0]: i2c eeprom 20: 01 2c 01 02 02 01 04 30 98 ff 00 a0 ff 22 00 c2
 saa7133[0]: i2c eeprom 30: 96 ff 03 30 15 01 ff ff 0c 22 17 76 03 24 31 05
 saa7133[0]: i2c eeprom 40: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
 saa7133[0]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
 saa7133[0]: i2c eeprom 60: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff                  
 saa7133[0]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff                  
 saa7133[0]: i2c eeprom 80: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff                  
 saa7133[0]: i2c eeprom 90: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff                  
 saa7133[0]: i2c eeprom a0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff                  
 saa7133[0]: i2c eeprom b0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff                  
 i2c eeprom c0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff                  
 saa7133[0]: i2c eeprom d0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff                  
 saa7133[0]: i2c eeprom e0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff                  
 saa7133[0]: i2c eeprom f0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff                  
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
 tda829x 1-004b: setting tuner address to 61                                                 
 tda829x 1-004b: type set to tda8290+75a                                                     
 saa7133[0]: registered device video0 [v4l2]                                                 
 saa7133[0]: registered device vbi0                                                          
 saa7133[0]: registered device radio0 

--------------------------------------------------------------------------------------------

here is what happens  with the latest mercurial v4l2 driver (kernel 2.6.29.4) :
something is wrong with the tuner (module tda829x 1-004b does not get loaded ?).


[root@neptune v4l-dvb]# hg parent         
changeset:   12172:0bb569fba22a
tag:         tip
user:        Mauro Carvalho Chehab <mchehab@redhat.com>
date:        Fri Jul  3 15:36:18 2009 -0300
summary:     em28xx: Add autodetection code for Silvercrest 1.3 mpix




saa7130/34: v4l2 driver version 0.2.15 loaded
ACPI: PCI Interrupt Link [LNKA] enabled at IRQ 11
PCI: setting IRQ 11 as level-triggered
saa7134 0000:00:0d.0: PCI INT A -> Link[LNKA] -> GSI 11 (level, low) -> IRQ 11
saa7133[0]: found at 0000:00:0d.0, rev: 208, irq: 11, latency: 32, mmio: 0xed800
000
saa7133[0]: subsystem: 11bd:002e, board: Pinnacle PCTV 40i/50i/110i (saa7133) [c
ard=77,autodetected]
saa7133[0]: board init: gpio is 200e000
IRQ 11/saa7133[0]: IRQF_DISABLED is not guaranteed on shared IRQs
saa7133[0]: i2c eeprom 00: bd 11 2e 00 54 20 1c 00 43 43 a9 1c 55 d2 b2 92
saa7133[0]: i2c eeprom 10: ff e0 60 02 ff 20 ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 20: 01 2c 01 02 02 01 04 30 98 ff 00 a0 ff 22 00 c2
saa7133[0]: i2c eeprom 30: 96 ff 03 30 15 01 ff ff 0c 22 17 76 03 24 31 05
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
TUNER: Unable to find symbol tda829x_probe()
tuner 1-004b: chip found @ 0x96 (saa7133[0])
DVB: Unable to find symbol tda9887_attach()
saa7133[0]: registered device video0 [v4l2]
saa7133[0]: registered device vbi0
saa7133[0]: registered device radio0
saa7134 ALSA driver for DMA sound loaded
IRQ 11/saa7133[0]: IRQF_DISABLED is not guaranteed on shared IRQs
saa7133[0]/alsa: saa7133[0] at 0xed800000 irq 11 registered as card -1

Jul  2 09:12:43 neptune kernel: tuner 1-004b: Tuner has no way to set tv freq
Jul  2 09:19:14 neptune kernel: tuner 1-004b: Tuner has no way to set tv freq
Jul  2 09:20:16 neptune kernel: tuner 1-004b: Tuner has no way to set tv freq
Jul  2 09:20:26 neptune kernel: tuner 1-004b: Tuner has no way to set tv freq



any idea what is going on ? 

thanks 


