Return-path: <linux-media-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.25]:28760 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751771AbZHYJWr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 25 Aug 2009 05:22:47 -0400
Received: by ey-out-2122.google.com with SMTP id 22so776008eye.37
        for <linux-media@vger.kernel.org>; Tue, 25 Aug 2009 02:22:47 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 25 Aug 2009 13:22:47 +0400
Message-ID: <b6837d750908250222q98f34adgb80ff36d91c421b5@mail.gmail.com>
Subject: Prolems with RoverMedia Tv Link Pro(LifeView FlyVIDEO3000) and recent
	kernels
From: =?KOI8-R?B?5dfHxc7JyiDgxMnO?= <eugene.yudin@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi, Sorry my bad english. I have tv-tuner card RoverMedia TV Link Pro FM.
Help me, please.

This card is a clone of LifeView FlyVIDEO3000 with Philips FMD1216ME
MK3 Hybrid Tuner(card=2 and tuner=63).
All work greatly before upgrating to kernel 2.6.30. My tvtime don't
showing any channels. Look like module saa7134 ignore tuner setting.
Radio also don't working. Later I'm build latest v4l-dvb driver from
hg, but i have similar results.

For now my distrubutive is Arch Linux. At the past i used ubuntu and i
have similar problems with kernel 2.6.30.

A'm loading module as:
[eugene@arch ~]$ sudo modprobe saa7134 tuner=63 card=2 alsa=0 secam=dk

My system:
[eugene@arch ~]$ uname -a
Linux arch 2.6.30-ARCH #1 SMP PREEMPT Mon Aug 17 18:04:53 CEST 2009
i686 AMD Athlon(tm) XP 2800+ AuthenticAMD GNU/Linux

My dmesg:
[eugene@arch ~]$ dmesg | grep saa
saa7130/34: v4l2 driver version 0.2.15 loaded
saa7134[0]: found at 0000:01:07.0, rev: 1, irq: 19, latency: 32, mmio:
0xea000000
saa7134[0]: subsystem: 19d1:0138, board: LifeView FlyVIDEO3000
[card=2,insmod option]
saa7134[0]: board init: gpio is 39000
saa7134[0]: there are different flyvideo cards with different tuners
saa7134[0]: out there, you might have to use the tuner=<nr> insmod
saa7134[0]: option to override the default value.
input: saa7134 IR (LifeView FlyVIDEO30 as
/devices/pci0000:00/0000:00:08.0/0000:01:07.0/input/input7
IRQ 19/saa7134[0]: IRQF_DISABLED is not guaranteed on shared IRQs
saa7134[0]: i2c eeprom 00: d1 19 38 01 10 28 ff ff ff ff ff ff ff ff ff ff
saa7134[0]: i2c eeprom 10: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7134[0]: i2c eeprom 20: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7134[0]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7134[0]: i2c eeprom 40: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7134[0]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7134[0]: i2c eeprom 60: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7134[0]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7134[0]: i2c eeprom 80: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7134[0]: i2c eeprom 90: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7134[0]: i2c eeprom a0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7134[0]: i2c eeprom b0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7134[0]: i2c eeprom c0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7134[0]: i2c eeprom d0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7134[0]: i2c eeprom e0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7134[0]: i2c eeprom f0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
tuner 2-0043: chip found @ 0x86 (saa7134[0])
saa7134[0]: registered device video0 [v4l2]
saa7134[0]: registered device vbi0
saa7134[0]: registered device radio0

[eugene@arch ~]$ lspci
01:07.0 Multimedia controller: Philips Semiconductors
SAA7134/SAA7135HL Video Broadcast Decoder (rev 01)

Similar situations are listed at at
http://linuxforum.ru/index.php?showtopic=94769 at russian language.

With Best regards, Eugene
