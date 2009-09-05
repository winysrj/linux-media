Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f217.google.com ([209.85.220.217]:46641 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751622AbZIEShM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 5 Sep 2009 14:37:12 -0400
Received: by fxm17 with SMTP id 17so1282193fxm.37
        for <linux-media@vger.kernel.org>; Sat, 05 Sep 2009 11:37:13 -0700 (PDT)
MIME-Version: 1.0
Date: Sat, 5 Sep 2009 20:37:13 +0200
Message-ID: <ef96b78e0909051137w188ef6ddw75f8c595e4498f0@mail.gmail.com>
Subject: Hauppauge HVR 1110 : recognized but doesn't work
From: Morvan Le Meut <mlemeut@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

( new subject from my previous ec168 mail )

2009/9/4 hermann pitton <hermann-pitton@arcor.de>
>
>
> Without knowing the kernel version on your mythbuntu I can't tell
> anything.
>
> For what I know so far, all HVR 1110 variants should be supported with
> recent v4l-dvb code.
>
> We run into some maintenance trouble, because we don't know on which of
> those are additional LNAs, maybe even different types of LNAs.
>
> Currently it looks like that we have some Pinnacle 310i devices broken
> in favour to have in detail unknown HVR 1110 boards working with LNA
> support.
>
> It would be much better to escape from such and not to add more and more
> unclear hardware on it.
>
> For broken Pinnacle LNA devices are patches to test available to get
> them back, others still do work unchanged, also to enable antenna
> voltage for those in need of it is possible.
>
> You should try your HVR 1110 variant with recent code and report again
> with details from dmesg for it, if it still should fail.
>
> Cheers,
> Hermann
>
i managed to get a hold of that card (well 200km to install another tv
card, but bough the wrong one so i'm trying that one again.) :
uname -a
Linux pvr 2.6.28-11-generic #42-Ubuntu SMP Fri Apr 17 01:57:59 UTC
2009 i686 GNU/Linux

dmesg ( at least what is relevant ) :
[    5.711223] saa7134 0000:01:09.0: PCI INT A -> Link[LNKB] -> GSI 18
(level, l     ow) -> IRQ 18
[    5.711228] saa7133[0]: found at 0000:01:09.0, rev: 209, irq: 18,
latency: 64     , mmio: 0xddeff800
[    5.711234] saa7133[0]: subsystem: 0070:6707, board: Hauppauge
WinTV-HVR1120      DVB-T/Hybrid [card=156,autodetected]
[    5.711278] saa7133[0]: board init: gpio is 40000
[    5.753843] cx88/0: cx2388x v4l2 driver version 0.0.7 loaded
[    5.756179] cx88/2: cx2388x MPEG-TS Driver Manager version 0.0.7 loaded
[    5.809164] psmouse serio1: ID: 00 00 64ACPI: PCI Interrupt Link
[LAZA] enabl     ed at IRQ 20
[    5.816518] HDA Intel 0000:00:05.0: PCI INT B -> Link[LAZA] -> GSI
20 (level,      low) -> IRQ 20
[    5.816587] HDA Intel 0000:00:05.0: setting latency timer to 64
[    5.877483] usb 1-4: reset high speed USB device using ehci_hcd and address 3
[    5.884015] saa7133[0]: i2c eeprom 00: 70 00 07 67 54 20 1c 00 43
43 a9 1c 55      d2 b2 92
[    5.884021] saa7133[0]: i2c eeprom 10: ff ff ff 0e ff 20 ff ff ff
ff ff ff ff      ff ff ff
[    5.884026] saa7133[0]: i2c eeprom 20: 01 40 01 32 32 01 01 33 88
ff 00 b0 ff      ff ff ff
[    5.884031] saa7133[0]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff
ff ff ff ff      ff ff ff
[    5.884037] saa7133[0]: i2c eeprom 40: ff 35 00 c0 96 10 06 32 97
04 00 20 00      ff ff ff
[    5.884042] saa7133[0]: i2c eeprom 50: ff 00 00 00 00 00 00 00 00
00 00 00 00      00 00 00
[    5.884047] saa7133[0]: i2c eeprom 60: 00 00 00 00 00 00 00 00 00
00 00 00 00      00 00 00
[    5.884052] saa7133[0]: i2c eeprom 70: 00 00 00 00 00 00 00 00 00
00 00 00 00      00 00 00
[    5.884056] saa7133[0]: i2c eeprom 80: 84 09 00 04 20 77 00 40 5c
05 5f f0 73      05 29 00
[    5.884062] saa7133[0]: i2c eeprom 90: 84 08 00 06 89 06 01 00 95
29 8d 72 07      70 73 09
[    5.884067] saa7133[0]: i2c eeprom a0: 23 5f 73 0a f4 9b 72 0b 2f
72 0e 01 72      0f 01 72
[    5.884072] saa7133[0]: i2c eeprom b0: 10 01 72 11 ff 73 13 a2 69
79 29 00 00      00 00 00
[    5.884078] saa7133[0]: i2c eeprom c0: 00 00 00 00 00 00 00 00 00
00 00 00 00      00 00 00
[    5.884083] saa7133[0]: i2c eeprom d0: 00 00 00 00 00 00 00 00 00
00 00 00 00      00 00 00
[    5.884088] saa7133[0]: i2c eeprom e0: 00 00 00 00 00 00 00 00 00
00 00 00 00      00 00 00
[    5.884093] saa7133[0]: i2c eeprom f0: 00 00 00 00 00 00 00 00 00
00 00 00 00      00 00 00
[    5.884101] tveeprom 2-0050: Hauppauge model 67209, rev C2F5, serial# 6227292
[    5.884103] tveeprom 2-0050: MAC address is 00-0D-FE-5F-05-5C
[    5.884105] tveeprom 2-0050: tuner model is NXP 18271C2 (idx 155, type 54)
[    5.884107] tveeprom 2-0050: TV standards PAL(B/G) PAL(I)
SECAM(L/L') PAL(D/D     1/K) ATSC/DVB Digital (eeprom 0xf4)
[    5.884109] tveeprom 2-0050: audio processor is SAA7131 (idx 41)
[    5.884110] tveeprom 2-0050: decoder processor is SAA7131 (idx 35)
[    5.884112] tveeprom 2-0050: has radio, has IR receiver, has no IR
transmitte     r
[    5.884114] saa7133[0]: hauppauge eeprom: model=67209
[    5.956082] tuner 2-004b: chip found @ 0x96 (saa7133[0])
[    6.009348] phy0: Selected rate control algorithm 'pid'
[    6.036025] tda829x 2-004b: setting tuner address to 60
[    6.083703] tda18271 2-0060: creating new instance
[    6.132022] TDA18271HD/C2 detected @ 2-0060
[    6.236015] hda_codec: Unknown model for ALC883, trying auto-probe
from BIOS.     ..
[    7.464017] tda18271: performing RF tracking filter calibration
[   25.668014] tda18271: RF tracking filter calibration complete
[   25.724014] tda829x 2-004b: type set to tda8290+18271
[   30.700128] saa7133[0]: registered device video0 [v4l2]
[   30.700168] saa7133[0]: registered device vbi0
[   30.700202] saa7133[0]: registered device radio0
[   30.729129] saa7134 ALSA driver for DMA sound loaded
[   30.729154] saa7133[0]/alsa: saa7133[0] at 0xddeff800 irq 18
registered as ca     rd -2
[   30.765270] dvb_init() allocating 1 frontend
[   30.901676] tda829x 2-004b: type set to tda8290
[   30.916100] tda18271 2-0060: attaching existing instance
[   30.916105] DVB: registering new adapter (saa7133[0])
[   30.916108] DVB: registering adapter 0 frontend 0 (NXP TDA10048HN DVB-T)...
[   31.185908] Adding 995988k swap on /dev/sda5.  Priority:-1
extents:1 across:9     95988k
[   31.244019] tda10048_firmware_upload: waiting for firmware upload
(dvb-fe-tda     10048-1.0.fw)...
[   31.244024] saa7134 0000:01:09.0: firmware: requesting dvb-fe-tda10048-1.0.fw
[   31.354316] tda10048_firmware_upload: firmware read 24878 bytes.
[   31.354319] tda10048_firmware_upload: firmware uploading
[   44.044019] tda18271_write_regs: ERROR: i2c_transfer returned: -5
[   44.044023] tda18271c2_rf_tracking_filters_correction: error -5 on line 244

got the firmware from http://steventoth.net/linux/hvr1200/

using the latest code from linuxtv ( which autodetect the card as an HVR1120 )
seems the problem is firmware uploading ... wrong file ?
on the card PCB i got :
 670000-038 LF
the DVB part read
hauppauge 1110
dvb-t
67209 LF rev c2F5
and the chip read Saa7131e/03/G
