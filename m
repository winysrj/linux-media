Return-path: <mchehab@pedra>
Received: from mailout-de.gmx.net ([213.165.64.22]:45184 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1751150Ab0I3WT5 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 30 Sep 2010 18:19:57 -0400
Date: Fri, 1 Oct 2010 00:19:53 +0200
From: Richard Atterer <atterer@debian.org>
To: linux-media@vger.kernel.org
Subject: bttv: No analogue sound output by TV card
Message-ID: <20100930221953.GA7062@arbonne.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

[Please CC me, I'm not on the list.]

Hi,

after switching from 2.6.34 to 2.6.36-rc5, the sound on my old Hauppauge 
analogue TV card has stopped working. Audio out from the TV card is 
connected to line-in of my motherboard (Gigabyte EG45M-DS2H) using the 
short cable that came with the TV card. Other audio sources (e.g. MP3 
player) are audible when connected to line-in. The TV picture is fine.

The log messages look really similar for the two kernels.

2.6.34 works:
kernel: bttv: driver version 0.9.18 loaded
kernel: bttv: using 8 buffers with 2080k (520 pages) each for capture
kernel: bttv: Bt8xx card found (0).
kernel: bttv0: Bt878 (rev 17) at 0000:03:01.0, irq: 19, latency: 32, mmio: 0xe3600000
kernel: bttv0: detected: Hauppauge WinTV [card=10], PCI subsystem ID is 0070:13eb
kernel: bttv0: using: Hauppauge (bt878) [card=10,autodetected]
kernel: IRQ 19/bttv0: IRQF_DISABLED is not guaranteed on shared IRQs
kernel: bttv0: gpio: en=00000000, out=00000000 in=00ffffdb [init]
kernel: bttv0: Hauppauge/Voodoo msp34xx: reset line init [5]
kernel: tveeprom 1-0050: Hauppauge model 44354, rev D147, serial# 1234567
kernel: tveeprom 1-0050: tuner model is LG TP18PSB01D (idx 47, type 28)
kernel: tveeprom 1-0050: TV standards PAL(B/G) (eeprom 0x04)
kernel: tveeprom 1-0050: audio processor is MSP3415 (idx 6)
kernel: tveeprom 1-0050: has radio
kernel: bttv0: Hauppauge eeprom indicates model#44354
kernel: bttv0: tuner type=28
kernel: msp3400 1-0040: MSP3415D-B3 found @ 0x80 (bt878 #0 [sw])
kernel: msp3400 1-0040: msp3400 supports nicam, mode is autodetect
kernel: tuner 1-0061: chip found @ 0xc2 (bt878 #0 [sw])
kernel: tuner-simple 1-0061: creating new instance
kernel: tuner-simple 1-0061: type set to 28 (LG PAL_BG+FM (TPI8PSB01D))
kernel: bttv0: registered device video0
kernel: bttv0: registered device vbi0
kernel: bttv0: registered device radio0
kernel: bttv0: PLL: 28636363 => 35468950 .
kernel: bttv0: PLL: 28636363 => 35468950 . ok
kernel:  ok

2.6.36-rc5 does not work:
kernel: bttv: driver version 0.9.18 loaded
kernel: bttv: using 8 buffers with 2080k (520 pages) each for capture
kernel: bttv: Bt8xx card found (0).
kernel: bttv0: Bt878 (rev 17) at 0000:03:01.0, irq: 19, latency: 32, mmio: 0xe3600000
kernel: bttv0: detected: Hauppauge WinTV [card=10], PCI subsystem ID is 0070:13eb
kernel: bttv0: using: Hauppauge (bt878) [card=10,autodetected]
kernel: bttv0: gpio: en=00000000, out=00000000 in=00ffffdb [init]
kernel: bttv0: Hauppauge/Voodoo msp34xx: reset line init [5]
kernel: tveeprom 1-0050: Hauppauge model 44354, rev D147, serial# 1234567
kernel: tveeprom 1-0050: tuner model is LG TP18PSB01D (idx 47, type 28)
kernel: tveeprom 1-0050: TV standards PAL(B/G) (eeprom 0x04)
kernel: tveeprom 1-0050: audio processor is MSP3415 (idx 6)
kernel: tveeprom 1-0050: has radio
kernel: bttv0: Hauppauge eeprom indicates model#44354
kernel: bttv0: tuner type=28
kernel: msp3400 1-0040: MSP3415D-B3 found @ 0x80 (bt878 #0 [sw])
kernel: msp3400 1-0040: msp3400 supports nicam, mode is autodetect
kernel: tuner 1-0061: chip found @ 0xc2 (bt878 #0 [sw])
kernel: tuner-simple 1-0061: creating new instance
kernel: tuner-simple 1-0061: type set to 28 (LG PAL_BG+FM (TPI8PSB01D))
kernel: bttv0: registered device video0
kernel: bttv0: registered device vbi0
kernel: bttv0: registered device radio0
kernel: bttv0: PLL: 28636363 => 35468950 . ok

The only real change is that the IRQF_DISABLED warning is gone.

Cheers,
  Richard

-- 
  __   ,
  | ) /|  Richard Atterer
  | \/ |  http://atterer.org

