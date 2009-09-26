Return-path: <linux-media-owner@vger.kernel.org>
Received: from web24712.mail.ird.yahoo.com ([212.82.104.185]:25880 "HELO
	web24712.mail.ird.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751030AbZIZMCp convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 26 Sep 2009 08:02:45 -0400
Message-ID: <462146.41730.qm@web24712.mail.ird.yahoo.com>
Date: Sat, 26 Sep 2009 11:56:08 +0000 (GMT)
From: Alistair Thomas <astavale@yahoo.co.uk>
Subject: No sound on Pinnacle PCTV Studio/Rave card - fixed with tda9887 and tuner module settings
To: linux-media@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Each time I update Fedora I lose these settings:

options tda9887 qss=0
options tuner pal=i

Who would be able to include these settings automatically within these modules?

Thanks for any help

Alistair Thomas

PCI card details from dmesg:

bttv: driver version 0.9.18 loaded
bttv: using 8 buffers with 2080k (520 pages) each for capture
bttv: Bt8xx card found (0).
ACPI: PCI Interrupt Link [APC3] enabled at IRQ 18
bttv 0000:01:06.0: PCI INT A -> Link[APC3] -> GSI 18 (level, high) -> IRQ 18
bttv0: Bt878 (rev 17) at 0000:01:06.0, irq: 18, latency: 32, mmio: 0xc2000000
bttv0: detected: Pinnacle PCTV [card=39], PCI subsystem ID is 11bd:0012
bttv0: using: Pinnacle PCTV Studio/Rave [card=39,autodetected]
IRQ 18/bttv0: IRQF_DISABLED is not guaranteed on shared IRQs
bttv0: gpio: en=00000000, out=00000000 in=00ffffff [init]
bttv0: i2c: checking for MSP34xx @ 0x80... not found
bttv0: pinnacle/mt: id=1 info="PAL / mono" radio=no
bttv0: tuner type=33
intel8x0_measure_ac97_clock: measured 53024 usecs (2576 samples)
intel8x0: clocking to 47425
usbcore: registered new interface driver snd-usb-audio
firewire_core: created device fw0: GUID 00301b301baf5073, S400
tuner 2-0043: chip found @ 0x86 (bt878 #0 [sw])
tda9887 2-0043: creating new instance
tda9887 2-0043: tda988[5/6/7] found
Chip ID is not zero. It is not a TEA5767
tuner 2-0060: chip found @ 0xc0 (bt878 #0 [sw])
mt20xx 2-0060: microtune: companycode=3cbf part=42 rev=22
mt20xx 2-0060: microtune MT2050 found, OK
bttv0: audio absent, no audio device found!
bttv0: registered device video0
bttv0: registered device vbi0
bttv0: PLL: 28636363 => 35468950 .. ok


      
