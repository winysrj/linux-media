Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail-in-14.arcor-online.net ([151.189.21.54])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <hermann-pitton@arcor.de>) id 1LGmhB-0001WF-GZ
	for linux-dvb@linuxtv.org; Sun, 28 Dec 2008 04:52:07 +0100
From: hermann pitton <hermann-pitton@arcor.de>
To: kmieciu <kmieciu@jabster.pl>
In-Reply-To: <49567A9E.8080700@jabster.pl>
References: <49567A9E.8080700@jabster.pl>
Date: Sun, 28 Dec 2008 04:52:10 +0100
Message-Id: <1230436330.2545.11.camel@pc10.localdom.local>
Mime-Version: 1.0
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Avermedia AVerTV GO 007 FM don't work with
	kernels	>= 2.6.27
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Hi,

Am Samstag, den 27.12.2008, 19:57 +0100 schrieb kmieciu:
> Hi
> 
> I have Avermedia AVerTV GO 007 FM PCI card (1461:f31d). Card works fine with kernel 2.6.24. There was tuner detection bug in kernels 2.6.25 and 2.6.26 which was fixed in 2.6.27 but my card still don't work with 2.6.27 and 2.6.28 kernels - no video and no audio. I load module saa7134 with card=57 tuner=54 options. I'm using tvtime.

there is also a patch for your card on the video4linux-list.

> Here goes dmesg for working and not working kernels and lspci:
> 
> Linux version 2.6.24-gentoo-r8 (root@kmieciu) (gcc version 4.2.4 (Gentoo 4.2.4 p1.0)) #1 SMP PREEMPT Thu Jun 19 19:42:04 CEST 2008
> Linux video capture interface: v2.00
> saa7130/34: v4l2 driver version 0.2.14 loaded
> ACPI: PCI Interrupt Link [LNK1] enabled at IRQ 11
> ACPI: PCI Interrupt 0000:01:08.0[A] -> Link [LNK1] -> GSI 11 (level, low) -> IRQ 11
> saa7133[0]: found at 0000:01:08.0, rev: 209, irq: 11, latency: 32, mmio: 0xfb000000
> saa7133[0]: subsystem: 1461:f31d, board: Avermedia AVerTV GO 007 FM [card=57,insmod option]
> saa7133[0]: board init: gpio is 807c8
> input: saa7134 IR (Avermedia AVerTV GO as /devices/pci0000:00/0000:00:06.0/0000:01:08.0/input/input2
> saa7133[0]: i2c eeprom 00: 61 14 1d f3 ff ff ff ff ff ff ff ff ff ff ff ff
> saa7133[0]: i2c eeprom 10: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> saa7133[0]: i2c eeprom 20: ff d2 fe ff ff ff ff ff ff ff ff ff ff ff ff ff
> saa7133[0]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> saa7133[0]: i2c eeprom 40: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> saa7133[0]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> saa7133[0]: i2c eeprom 60: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> saa7133[0]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> saa7133[0]: registered device video0 [v4l2]
> saa7133[0]: registered device vbi0
> saa7133[0]: registered device radio0
> saa7134 ALSA driver for DMA sound loaded
> saa7133[0]/alsa: saa7133[0] at 0xfb000000 irq 11 registered as card 1
> tuner 2-004b: chip found @ 0x96 (saa7133[0])
> tda8290 2-004b: setting tuner address to 61
> tuner 2-004b: type set to tda8290+75a
> tda8290 2-004b: setting tuner address to 61
> tuner 2-004b: type set to tda8290+75a
> 
> Linux version 2.6.28-gentoo (root@kmieciu) (gcc version 4.3.2 (Gentoo 4.3.2-r1 p1.3, pie-10.1.3) ) #1 SMP PREEMPT Sat Dec 27 17:08:17 CET 2008
> Linux video capture interface: v2.00
> saa7130/34: v4l2 driver version 0.2.14 loaded
> ACPI: PCI Interrupt Link [LNK1] enabled at IRQ 11
> saa7134 0000:01:08.0: PCI INT A -> Link[LNK1] -> GSI 11 (level, low) -> IRQ 11
> saa7133[0]: found at 0000:01:08.0, rev: 209, irq: 11, latency: 32, mmio: 0xfb000000
> saa7133[0]: subsystem: 1461:f31d, board: Avermedia AVerTV GO 007 FM [card=57,insmod option]
> saa7133[0]: board init: gpio is 807c8
> input: saa7134 IR (Avermedia AVerTV GO as /devices/pci0000:00/0000:00:06.0/0000:01:08.0/input/input3
> saa7133[0]: i2c eeprom 00: 61 14 1d f3 ff ff ff ff ff ff ff ff ff ff ff ff
> saa7133[0]: i2c eeprom 10: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> saa7133[0]: i2c eeprom 20: ff d2 fe ff ff ff ff ff ff ff ff ff ff ff ff ff
> saa7133[0]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> saa7133[0]: i2c eeprom 40: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
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
> DVB: Unable to find symbol tda827x_attach()
> tda829x 2-004b: type set to tda8290+75a
> saa7133[0]: registered device video0 [v4l2]
> saa7133[0]: registered device vbi0
> saa7133[0]: registered device radio0
> saa7134 ALSA driver for DMA sound loaded
> saa7133[0]/alsa: saa7133[0] at 0xfb000000 irq 11 registered as card 1
> 
> 01:08.0 Multimedia controller [0480]: Philips Semiconductors SAA7131/SAA7133/SAA7135 Video Broadcast Decoder [1131:7133] (rev d1)
> 	Subsystem: Avermedia Technologies Inc Device [1461:f31d]
> 	Flags: bus master, medium devsel, latency 32, IRQ 11
> 	Memory at fb000000 (32-bit, non-prefetchable) [size=2K]
> 	Capabilities: [40] Power Management version 2
> 	Kernel driver in use: saa7134
> 	Kernel modules: saa7134
> 
> With 2.6.24 kernel I load tuner module manually after saa7134 and saa7134_alsa. With 2.6.28 kernel tuner module is loaded automatically by saa7134 module.
> 

Out of some reason the tda827x module must be deselected within tuner
customization of your later kernels and you don't have it.

Make sure its build is enabled in the .config of the kernel.

You can also install current v4l-dvb from linuxtv.org to get it.

Cheers,
Hermann



_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
