Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-04.arcor-online.net ([151.189.21.44]:51282 "EHLO
	mail-in-04.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751626AbZDMU4H (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 13 Apr 2009 16:56:07 -0400
Subject: Re: Compro T750F...Huh? unknown DVB card?, frontend initialization
	failed
From: hermann pitton <hermann-pitton@arcor.de>
To: Andrew Reay <certain@tpg.com.au>
Cc: John Newbigin <jn@it.swin.edu.au>, linux-media@vger.kernel.org
In-Reply-To: <1239619576.6171.67.camel@desktop>
References: <1239419690.7179.15.camel@desktop>
	 <1239448124.3779.25.camel@pc07.localdom.local>
	 <1239619576.6171.67.camel@desktop>
Content-Type: text/plain
Date: Mon, 13 Apr 2009 22:50:02 +0200
Message-Id: <1239655802.15301.27.camel@pc07.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Andrew,

just a short reply for now.

Am Montag, den 13.04.2009, 20:46 +1000 schrieb Andrew Reay:
> Hi again Hermann,
> 
> Your instructions were clear and easy to follow...but still no joy.
> This time ending with;
> [   12.291399] saa7133[0]/dvb: Huh? unknown DVB card?
> [   12.291402] saa7133[0]/dvb: frontend initialization failed
> 
> I installed mercurial by;
> sudo apt-get install mercurial linux-headers-$(uname -r)
> build-essential
> 
> I deleted the existing v4l-dvb folder and got the latest one;
> hg clone http://linuxtv.org/hg/v4l-dvb
> 
> I changed to the newly created v4l-dvb folder;
> cd v4l-dvb
> 
> I edited the saa7134-cards.c file in the v4l-dvb folder tree,
> obscuring
> the card from the gpio remotes, as I am not worried about the remote
> functionality at this stage;
>         case SAA7134_BOARD_VIDEOMATE_DVBT_300:
>         case SAA7134_BOARD_VIDEOMATE_DVBT_200:
>         case SAA7134_BOARD_VIDEOMATE_DVBT_200A:
> /*      case SAA7134_BOARD_VIDEOMATE_T750:*/
> 
> I compiled the new modules from source;
> sudo make
> 
> I unloaded the old modules;
> sudo make rmmod
> 
> I deleted the media folder from 
> /lib/modules/2.6.28-11-generic/kernel/drivers
> 
> I installed the new kernel driver modules;
> sudo make install
> 
> and rebooted.
> 
> The attached text file are dmesg logs with xc3028-v27.fw not
> in /lib/firmware and present in /lib/firmware.
> 
> Thanks again, for your help.
> Andrew
> 
> 
> -----Original Message-----
> From: hermann pitton <hermann-pitton@arcor.de>
> To: Andrew Reay <certain@tpg.com.au>, John Newbigin
> <jn@it.swin.edu.au>
> Cc: linux-media@vger.kernel.org
> Subject: Re: Compro T750F not working yet...BUG: unable to handle
> kernel
> paging request at fffffff4
> Date: Sat, 11 Apr 2009 13:08:44 +0200
> Mailer: Evolution 2.12.3 (2.12.3-5.fc8) 
> 
> Hi Andrew,
> 
> the card has in saa7134-dvb.c still a "FIXME: does anyone know the
> demodulator on it" or something like that.
> 
> The oops is because the card is set in saa7134-cards.c as gpio remote.

[snip]

OK, that one is gone.

> 
> 
> 
> 
> 
> 
> einfaches
> Textdokument-Anlage (dmesg_dumps.txt)
> 
> [   11.458398] Linux video capture interface: v2.00
> [   11.548414] saa7130/34: v4l2 driver version 0.2.15 loaded
> [   11.548913] ACPI: PCI Interrupt Link [APC1] enabled at IRQ 16
> [   11.548926] saa7134 0000:04:08.0: PCI INT A -> Link[APC1] -> GSI 16
> (level, low) -> IRQ 16
> [   11.548932] saa7133[0]: found at 0000:04:08.0, rev: 209, irq: 16,
> latency: 32, mmio: 0xfdbfe000
> [   11.548938] saa7133[0]: subsystem: 185b:c900, board: Compro
> VideoMate T750 [card=139,autodetected]
> [   11.549120] saa7133[0]: board init: gpio is 84bf00
> [   11.685878] ACPI: PCI Interrupt Link [APC7] enabled at IRQ 16
> [   11.685885] nvidia 0000:00:05.0: PCI INT A -> Link[APC7] -> GSI 16
> (level, low) -> IRQ 16
> [   11.685891] nvidia 0000:00:05.0: setting latency timer to 64
> [   11.686255] NVRM: loading NVIDIA UNIX x86 Kernel Module  180.44
> Mon Mar 23 14:59:10 PST 2009
> [   11.712025] saa7133[0]: i2c eeprom 00: 5b 18 00 c9 54 20 1c 00 43
> 43 a9 1c 55 d2 b2 92
> [   11.712036] saa7133[0]: i2c eeprom 10: 00 ff 86 0f ff 20 ff ff ff
> ff ff ff ff ff ff ff
> [   11.712044] saa7133[0]: i2c eeprom 20: 01 40 01 02 02 01 03 01 08
> ff 00 87 ff ff ff ff
> [   11.712053] saa7133[0]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff
> ff ff ff ff ff ff ff
> [   11.712061] saa7133[0]: i2c eeprom 40: ff d7 00 c4 86 1e 05 ff 02
> c2 ff 01 c6 ff 05 ff
> [   11.712069] saa7133[0]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff
> ff ff ff ff ff ff cb
> [   11.712077] saa7133[0]: i2c eeprom 60: 35 ff ff ff ff ff ff ff ff
> ff ff ff ff ff ff ff
> [   11.712085] saa7133[0]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff
> ff ff ff ff ff ff ff
> [   11.712092] saa7133[0]: i2c eeprom 80: ff ff ff ff ff ff ff ff ff
> ff ff ff ff ff ff ff
> [   11.712100] saa7133[0]: i2c eeprom 90: ff ff ff ff ff ff ff ff ff
> ff ff ff ff ff ff ff
> [   11.712108] saa7133[0]: i2c eeprom a0: ff ff ff ff ff ff ff ff ff
> ff ff ff ff ff ff ff
> [   11.712116] saa7133[0]: i2c eeprom b0: ff ff ff ff ff ff ff ff ff
> ff ff ff ff ff ff ff
> [   11.712124] saa7133[0]: i2c eeprom c0: ff ff ff ff ff ff ff ff ff
> ff ff ff ff ff ff ff
> [   11.712132] saa7133[0]: i2c eeprom d0: ff ff ff ff ff ff ff ff ff
> ff ff ff ff ff ff ff
> [   11.712140] saa7133[0]: i2c eeprom e0: ff ff ff ff ff ff ff ff ff
> ff ff ff ff ff ff ff
> [   11.712148] saa7133[0]: i2c eeprom f0: ff ff ff ff ff ff ff ff ff
> ff ff ff ff ff ff ff
> [   11.754105] ACPI: PCI Interrupt Link [AAZA] enabled at IRQ 23
> [   11.754112] HDA Intel 0000:00:10.1: PCI INT B -> Link[AAZA] -> GSI
> 23 (level, low) -> IRQ 23
> [   11.754168] HDA Intel 0000:00:10.1: setting latency timer to 64
> [   11.780091] tuner 2-0062: chip found @ 0xc4 (saa7133[0])
> [   11.819521] xc2028 2-0062: creating new instance
> [   11.819525] xc2028 2-0062: type set to XCeive xc2028/xc3028 tuner
> [   11.819535] i2c-adapter i2c-2: firmware: requesting xc3028-v27.fw
> [   11.850254] xc2028 2-0062: Error: firmware xc3028-v27.fw not found.
> [   11.850262] i2c-adapter i2c-2: firmware: requesting xc3028-v27.fw
> [   11.853164] xc2028 2-0062: Error: firmware xc3028-v27.fw not found.
> [   11.855750] xc2028 2-0062: Error on line 1122: -5
> [   11.855880] saa7133[0]: registered device video0 [v4l2]
> [   11.855930] saa7133[0]: registered device vbi0
> [   11.856034] saa7133[0]: registered device radio0
> [   11.884383] saa7134 ALSA driver for DMA sound loaded
> [   11.884413] saa7133[0]/alsa: saa7133[0] at 0xfdbfe000 irq 16
> registered as card -2
> [   11.897719] psmouse serio1: ID: 10 00 64<6>dvb_init() allocating 1
> frontend
> [   12.066575] saa7133[0]/dvb: Huh? unknown DVB card?
> [   12.066578] saa7133[0]/dvb: frontend initialization failed
> 
> 
> THIS TIME WITH FIRMWARE
> 
> [   11.708340] Linux video capture interface: v2.00
> [   11.744461] synaptics was reset on resume, see
> synaptics_resume_reset if you have trouble on resume
> [   11.800357] saa7130/34: v4l2 driver version 0.2.15 loaded
> [   11.800866] ACPI: PCI Interrupt Link [APC1] enabled at IRQ 16
> [   11.800878] saa7134 0000:04:08.0: PCI INT A -> Link[APC1] -> GSI 16
> (level, low) -> IRQ 16
> [   11.800885] saa7133[0]: found at 0000:04:08.0, rev: 209, irq: 16,
> latency: 32, mmio: 0xfdbfe000
> [   11.800891] saa7133[0]: subsystem: 185b:c900, board: Compro
> VideoMate T750 [card=139,autodetected]
> [   11.801079] saa7133[0]: board init: gpio is 84bf00
> [   11.844805] ACPI: PCI Interrupt Link [APC7] enabled at IRQ 16
> [   11.844811] nvidia 0000:00:05.0: PCI INT A -> Link[APC7] -> GSI 16
> (level, low) -> IRQ 16
> [   11.844817] nvidia 0000:00:05.0: setting latency timer to 64
> [   11.845423] NVRM: loading NVIDIA UNIX x86 Kernel Module  180.44
> Mon Mar 23 14:59:10 PST 2009
> [   11.887343] ACPI: PCI Interrupt Link [AAZA] enabled at IRQ 23
> [   11.887350] HDA Intel 0000:00:10.1: PCI INT B -> Link[AAZA] -> GSI
> 23 (level, low) -> IRQ 23
> [   11.887395] HDA Intel 0000:00:10.1: setting latency timer to 64
> [   11.952021] saa7133[0]: i2c eeprom 00: 5b 18 00 c9 54 20 1c 00 43
> 43 a9 1c 55 d2 b2 92
> [   11.952031] saa7133[0]: i2c eeprom 10: 00 ff 86 0f ff 20 ff ff ff
> ff ff ff ff ff ff ff
> [   11.952039] saa7133[0]: i2c eeprom 20: 01 40 01 02 02 01 03 01 08
> ff 00 87 ff ff ff ff
> [   11.952047] saa7133[0]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff
> ff ff ff ff ff ff ff
> [   11.952056] saa7133[0]: i2c eeprom 40: ff d7 00 c4 86 1e 05 ff 02
> c2 ff 01 c6 ff 05 ff
> [   11.952064] saa7133[0]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff
> ff ff ff ff ff ff cb
> [   11.952071] saa7133[0]: i2c eeprom 60: 35 ff ff ff ff ff ff ff ff
> ff ff ff ff ff ff ff
> [   11.952080] saa7133[0]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff
> ff ff ff ff ff ff ff
> [   11.952088] saa7133[0]: i2c eeprom 80: ff ff ff ff ff ff ff ff ff
> ff ff ff ff ff ff ff
> [   11.952096] saa7133[0]: i2c eeprom 90: ff ff ff ff ff ff ff ff ff
> ff ff ff ff ff ff ff
> [   11.952104] saa7133[0]: i2c eeprom a0: ff ff ff ff ff ff ff ff ff
> ff ff ff ff ff ff ff
> [   11.952111] saa7133[0]: i2c eeprom b0: ff ff ff ff ff ff ff ff ff
> ff ff ff ff ff ff ff
> [   11.952119] saa7133[0]: i2c eeprom c0: ff ff ff ff ff ff ff ff ff
> ff ff ff ff ff ff ff
> [   11.952127] saa7133[0]: i2c eeprom d0: ff ff ff ff ff ff ff ff ff
> ff ff ff ff ff ff ff
> [   11.952135] saa7133[0]: i2c eeprom e0: ff ff ff ff ff ff ff ff ff
> ff ff ff ff ff ff ff
> [   11.952143] saa7133[0]: i2c eeprom f0: ff ff ff ff ff ff ff ff ff
> ff ff ff ff ff ff ff
> [   11.976127] tuner 2-0062: chip found @ 0xc4 (saa7133[0])
> [   12.018760] xc2028 2-0062: creating new instance
> [   12.018764] xc2028 2-0062: type set to XCeive xc2028/xc3028 tuner
> [   12.018772] i2c-adapter i2c-2: firmware: requesting xc3028-v27.fw
> [   12.085661] xc2028 2-0062: Loading 80 firmware images from
> xc3028-v27.fw, type: xc2028 firmware, ver 2.7
> [   12.085816] xc2028 2-0062: Loading firmware for type=BASE F8MHZ MTS
> (7), id 0000000000000000.
> [   12.086222] xc2028 2-0062: i2c output error: rc = -5 (should be 64)
> [   12.086224] xc2028 2-0062: -5 returned from send
> [   12.086228] xc2028 2-0062: Error -22 while loading base firmware
> [   12.140048] xc2028 2-0062: Loading firmware for type=BASE F8MHZ MTS
> (7), id 0000000000000000.
> [   12.140584] xc2028 2-0062: i2c output error: rc = -5 (should be 64)
> [   12.140586] xc2028 2-0062: -5 returned from send
> [   12.140588] xc2028 2-0062: Error -22 while loading base firmware
> [   12.140601] xc2028 2-0062: Loading firmware for type=BASE F8MHZ MTS
> (7), id 0000000000000000.
> [   12.141137] xc2028 2-0062: i2c output error: rc = -5 (should be 64)
> [   12.141139] xc2028 2-0062: -5 returned from send
> [   12.141142] xc2028 2-0062: Error -22 while loading base firmware
> [   12.196030] xc2028 2-0062: Loading firmware for type=BASE F8MHZ MTS
> (7), id 0000000000000000.
> [   12.196563] xc2028 2-0062: i2c output error: rc = -5 (should be 64)
> [   12.196565] xc2028 2-0062: -5 returned from send
> [   12.196568] xc2028 2-0062: Error -22 while loading base firmware
> [   12.196848] saa7133[0]: dsp access error
> [   12.197453] xc2028 2-0062: Error on line 1124: -5
> [   12.197513] saa7133[0]: registered device video0 [v4l2]
> [   12.197533] saa7133[0]: registered device vbi0
> [   12.197553] saa7133[0]: registered device radio0
> [   12.217537] saa7134 ALSA driver for DMA sound loaded
> [   12.217571] saa7133[0]/alsa: saa7133[0] at 0xfdbfe000 irq 16
> registered as card -2
> [   12.284485] psmouse serio1: ID: 10 00 64<6>dvb_init() allocating 1
> frontend
> [   12.291399] saa7133[0]/dvb: Huh? unknown DVB card?
> [   12.291402] saa7133[0]/dvb: frontend initialization failed

That the card ends up for DVB-T just here is also very clear.

Don't know, why John and Mauro, IIRC, did chose to let it run into that
last resort for not working DVB-T. It is not meant for that.

I consider it at least as bad style to push a card, without any DVB
support so far, into it and let the user wonder about the printouts.

If it has no DVB support yet, it should not be enabled as fake in the
card's entry in saa7134-cards.c.

Please wait a little until those who have dealt with it hopefully become
a little more active after Easter and tell what you can really expect.

Cheers,
Hermann




