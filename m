Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f227.google.com ([209.85.219.227]:39661 "EHLO
	mail-ew0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752952AbZJATeg (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 1 Oct 2009 15:34:36 -0400
Received: by ewy27 with SMTP id 27so607681ewy.40
        for <linux-media@vger.kernel.org>; Thu, 01 Oct 2009 12:34:39 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 1 Oct 2009 20:34:39 +0100
Message-ID: <b4619a970910011234l518a5197jc60c6d4896af7e77@mail.gmail.com>
Subject: Aver A700 : "frequency out of range"
From: Mikhail Ramendik <mr@ramendik.ru>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

I have:

- Debian Lenny (dual booted with Windows XP)
- Linux kernel 2.6.30 (from backports.org)
- An AverMedia DVB-S Pro A700 card (not hybrid)
- a satellite dish set to Astra 28.2E (in Ireland)

With Windows XP I can view TV all right.

With Linux, I tried tuning with me-tv and scan, in both cases using
files for Astra 28.2E. Both cause a similar failure - can not set
frequency. The most coherent messages are in dmesg:

[   96.950097] DVB: adapter 0 frontend 0 frequency 11709400 out of
range (950000..2150000)

(and lots of this - for every attempt to set the frequency).

Here are the lines from dmesg during boot up time, relevant for the card:

[   10.363711] Linux video capture interface: v2.00
[   10.413266] saa7130/34: v4l2 driver version 0.2.15 loaded
[   10.413333] saa7134 0000:00:0a.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
[   10.413344] saa7133[0]: found at 0000:00:0a.0, rev: 209, irq: 19,
latency: 32, mmio: 0xeb024000
[   10.413356] saa7133[0]: subsystem: 1461:a7a1, board: Avermedia
DVB-S Pro A700 [card=140,autodetected]
[   10.413388] saa7133[0]: board init: gpio is 202f600
[   10.413402] IRQ 19/saa7133[0]: IRQF_DISABLED is not guaranteed on shared IRQs
[   10.564525] saa7133[0]: i2c eeprom 00: 61 14 a1 a7 ff ff ff ff ff
ff ff ff ff ff ff ff
[   10.564547] saa7133[0]: i2c eeprom 10: ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff ff
[   10.564568] saa7133[0]: i2c eeprom 20: ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff ff
[   10.564588] saa7133[0]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff ff
[   10.564608] saa7133[0]: i2c eeprom 40: ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff ff
[   10.564627] saa7133[0]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff ff
[   10.564646] saa7133[0]: i2c eeprom 60: ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff ff
[   10.564665] saa7133[0]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff ff
[   10.564684] saa7133[0]: i2c eeprom 80: ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff ff
[   10.564703] saa7133[0]: i2c eeprom 90: ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff ff
[   10.564722] saa7133[0]: i2c eeprom a0: ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff ff
[   10.564741] saa7133[0]: i2c eeprom b0: ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff ff
[   10.564760] saa7133[0]: i2c eeprom c0: ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff ff
[   10.564780] saa7133[0]: i2c eeprom d0: ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff ff
[   10.564799] saa7133[0]: i2c eeprom e0: 00 01 81 b0 3e 3f ff ff ff
ff ff ff ff ff ff ff
[   10.564818] saa7133[0]: i2c eeprom f0: ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff ff
[   10.580356] saa7133[0]: registered device video0 [v4l2]
[   10.580400] saa7133[0]: registered device vbi0
[   10.791137] dvb_init() allocating 1 frontend
[   10.938187] Intel ICH 0000:00:02.7: PCI INT C -> GSI 18 (level,
low) -> IRQ 18
[   11.012527] zl10036_attach: tuner initialization (Zarlink ZL10036
addr=0x60) ok
[   11.012534] DVB: registering new adapter (saa7133[0])
[   11.012540] DVB: registering adapter 0 frontend 0 (Zarlink ZL10313 DVB-S)...
[   11.213808] saa7134 ALSA driver for DMA sound loaded
[   11.213825] IRQ 19/saa7133[0]: IRQF_DISABLED is not guaranteed on shared IRQs
[   11.213859] saa7133[0]/alsa: saa7133[0] at 0xeb024000 irq 19
registered as card -1

What do I need to do in orer to get the card to work under Linux?

(I can apply patches/build kernel or libraries if needed).

--
Yours, Mikhail Ramendik
