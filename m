Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-06.arcor-online.net ([151.189.21.46]:33692 "EHLO
	mail-in-06.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756929AbZKMUYO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 13 Nov 2009 15:24:14 -0500
Subject: Re: Tuner drivers
From: hermann pitton <hermann-pitton@arcor.de>
To: rulet1@meta.ua
Cc: linux-media@vger.kernel.org
In-Reply-To: <36685.95.133.109.178.1258107794.metamail@webmail.meta.ua>
References: <1258058273.8348.14.camel@pc07.localdom.local>
	 <49907.95.132.6.235.1258066094.metamail@webmail.meta.ua>
	 <1258073462.8348.35.camel@pc07.localdom.local>
	 <36685.95.133.109.178.1258107794.metamail@webmail.meta.ua>
Content-Type: text/plain
Date: Fri, 13 Nov 2009 21:24:30 +0100
Message-Id: <1258143870.3242.31.camel@pc07.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi!

Am Freitag, den 13.11.2009, 12:23 +0200 schrieb rulet1@meta.ua:
> Here is dmesg of analog (only analog, with FM-tuner) AverMedia Super 007
> when tvtime is running:

[snip]

> [   11.549190] Linux video capture interface: v2.00
> [   12.409456] saa7130/34: v4l2 driver version 0.2.15 loaded
> [   12.409531] saa7134 0000:04:02.0: PCI INT A -> GSI 18 (level, low) ->
> IRQ 18
> [   12.409543] saa7133[0]: found at 0000:04:02.0, rev: 209, irq: 18,
> latency: 64, mmio: 0xfebff800
> [   12.409554] saa7133[0]: subsystem: 1461:f11d, board: Avermedia PCI pure
> analog (M135A) [card=149,autodetected]
> [   12.409579] saa7133[0]: board init: gpio is 40000
> [   12.409691] input: saa7134 IR (Avermedia PCI pure  as
> /devices/pci0000:00/0000:00:1e.0/0000:04:02.0/input/input6
> [   12.409773] IRQ 18/saa7133[0]: IRQF_DISABLED is not guaranteed on
> shared IRQs
> [   12.560015] saa7133[0]: i2c eeprom 00: 61 14 1d f1 54 20 1c 00 43 43 a9
> 1c 55 d2 b2 92
> [   12.560034] saa7133[0]: i2c eeprom 10: ff ff ff ff ff 20 ff ff ff ff ff
> ff ff ff ff ff
> [   12.560050] saa7133[0]: i2c eeprom 20: 01 40 01 32 32 01 01 43 88 ff 00
> 56 ff ff ff ff
> [   12.560066] saa7133[0]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff ff ff
> ff ff ff ff ff
> [   12.560082] saa7133[0]: i2c eeprom 40: ff 22 00 c0 96 ff 03 30 15 00 ff
> ff ff ff ff ff
> [   12.560098] saa7133[0]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff ff ff
> ff ff ff ff ff
> [   12.560117] saa7133[0]: i2c eeprom 60: ff ff ff ff ff ff ff ff ff ff ff
> ff ff ff ff ff
> [   12.560130] saa7133[0]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff ff ff
> ff ff ff ff ff
> [   12.560144] saa7133[0]: i2c eeprom 80: ff ff ff ff ff ff ff ff ff ff ff
> ff ff ff ff ff
> [   12.560158] saa7133[0]: i2c eeprom 90: ff ff ff ff ff ff ff ff ff ff ff
> ff ff ff ff ff
> [   12.560171] saa7133[0]: i2c eeprom a0: ff ff ff ff ff ff ff ff ff ff ff
> ff ff ff ff ff
> [   12.560185] saa7133[0]: i2c eeprom b0: ff ff ff ff ff ff ff ff ff ff ff
> ff ff ff ff ff
> [   12.560199] saa7133[0]: i2c eeprom c0: ff ff ff ff ff ff ff ff ff ff ff
> ff ff ff ff ff
> [   12.560212] saa7133[0]: i2c eeprom d0: ff ff ff ff ff ff ff ff ff ff ff
> ff ff ff ff ff
> [   12.560226] saa7133[0]: i2c eeprom e0: ff ff ff ff ff ff ff ff ff ff ff
> ff ff ff ff ff
> [   12.560240] saa7133[0]: i2c eeprom f0: ff ff ff ff ff ff ff ff ff ff ff
> ff ff ff ff ff
> [   12.560256] i2c-adapter i2c-0: Invalid 7-bit address 0x7a
> [   13.316153] tuner 0-004b: chip found @ 0x96 (saa7133[0])
> [   13.400020] tda829x 0-004b: setting tuner address to 60
> [   13.596016] tda829x 0-004b: type set to tda8290+75a
[...]
> [   17.540609] saa7133[0]: registered device video0 [v4l2]
> [   17.540656] saa7133[0]: registered device vbi0
> [   17.540703] saa7133[0]: registered device radio0
> [   17.541109] CA0106 0000:04:01.0: PCI INT A -> GSI 17 (level, low) ->
> IRQ 17
> [   17.541161] snd-ca0106: Model 1013 Rev 00000000 Serial 10131102
> [   17.640654] saa7134 ALSA driver for DMA sound loaded
> [   17.640672] IRQ 18/saa7133[0]: IRQF_DISABLED is not guaranteed on
> shared IRQs
> [   17.640717] saa7133[0]/alsa: saa7133[0] at 0xfebff800 irq 18 registered
> as card -2

That one came in over Mauro and he added the NEC gpio remote support.

http://linuxtv.org/hg/v4l-dvb/rev/fa0de4f2637a

If you are in Russia, you likely have to use "options saa7134 secam=DK"
or modprobe the driver with that. Please read the output of "modinfo
saa7134".

Enable audio_debug=1 for saa7134.

echo 1 > /sys/module/saa7134/parameters/audio_debug

If you switch the TV app to SECAM it should start to detect the DK audio
carriers. Please report if this should still fail, since I can't test it
myself. You see it in dmesg.

Also I can see in the Avermedia user manual that it has only analog
audio in but no out.

You are forced to use saa7134-alsa dma sound.

Hope this helps.

Cheers,
Hermann


