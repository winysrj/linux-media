Return-path: <linux-media-owner@vger.kernel.org>
Received: from web25405.mail.ukl.yahoo.com ([217.12.10.139]:45584 "HELO
	web25405.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S933494AbZJHUJo convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 8 Oct 2009 16:09:44 -0400
Message-ID: <813517.84815.qm@web25405.mail.ukl.yahoo.com>
Date: Thu, 8 Oct 2009 20:02:22 +0000 (GMT)
From: fabio tirapelle <ftirapelle@yahoo.it>
Subject: Haupp. HVR-1100 problem and DVB-T card
To: linux-media@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi

I have installed mythtv on this configuration:
Asus M3N78-VM GF8200 RGVSM
AMD Ath64 X2LV 3100BOX6000+ 1MB
Haupp. WinTV HVR-1100 -t/a PCI
TechniSat SkyStar 2 DVB-S PCI
nVidia GeForce 8200
Ubuntu 8.10 - Linux htpc 2.6.27-11-generic 

Two questions

1) But the Haupp. WinTV will not be found even if I have followed
http://www.linuxtv.org/wiki/index.php/Hauppauge_WinTV-HVR-1110 
http://ubuntuforums.org/showthread.php?t=623126&page=2 (#12)

Output of dmesg

[   13.062214] ACPI: PCI Interrupt Link [LNKA] enabled at IRQ 17
[   13.062223] b2c2_flexcop_pci 0000:01:06.0: PCI INT A -> Link[LNKA] -> GSI 17 (level, low) -> IRQ 17
[   13.076654] DVB: registering new adapter (FlexCop Digital TV device)
[   13.078432] b2c2-flexcop: MAC address = 00:d0:d7:0d:30:88
[   13.078664] b2c2-flexcop: i2c master_xfer failed
[   13.078893] b2c2-flexcop: i2c master_xfer failed
[   13.078895] CX24123: cx24123_i2c_readreg: reg=0x0 (error=-121)
[   13.078897] CX24123: wrong demod revision: 87
[   13.101063] saa7130/34: v4l2 driver version 0.2.14 loaded
[   13.360642] b2c2-flexcop: found 'ST STV0299 DVB-S' .
[   13.360647] DVB: registering frontend 0 (ST STV0299 DVB-S)...
[   13.360768] b2c2-flexcop: initialization of 'Sky2PC/SkyStar 2 DVB-S' at the 'PCI' bus controlled by a 'FlexCopIIb' complete
[   13.363507] ACPI: PCI Interrupt Link [LNKB] enabled at IRQ 16
[   13.363517] saa7134 0000:01:07.0: PCI INT A -> Link[LNKB] -> GSI 16 (level, low) -> IRQ 16
[   13.363523] saa7133[0]: found at 0000:01:07.0, rev: 255, irq: 16, latency: 255, mmio: 0x0
[   13.363528] saa7133[0]: subsystem: ffff:ffff, board: UNKNOWN/GENERIC [card=0,autodetected]
[   13.363531] saa7133[0]: can't get MMIO memory @ 0x0
[   13.363538] saa7134: probe of 0000:01:07.0 failed with error -16
[   13.393682] saa7134 ALSA driver for DMA sound loaded
[   13.393685] saa7134 ALSA: no saa7134 cards found

ouput lspci
01:06.0 Network controller: Techsan Electronics Co Ltd B2C2 FlexCopII DVB chip / Technisat SkyStar2 DVB card (rev 02)
01:07.0 Multimedia controller: Philips Semiconductors SAA7131/SAA7133/SAA7135 Video Broadcast Decoder (rev d1)

2) What kind of DVB-T card will you suggest for my configuration instead of "Hauppage WinTv"?

Thanks for help 


      
