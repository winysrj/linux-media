Return-path: <linux-media-owner@vger.kernel.org>
Received: from dzilna.latnet.lv ([92.240.66.75]:52431 "EHLO dzilna.latnet.lv"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751455AbZK0VCN (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 27 Nov 2009 16:02:13 -0500
Received: from localhost (localhost [127.0.0.1])
	by dzilna.latnet.lv (Postfix) with ESMTP id 3FD26B3C60
	for <linux-media@vger.kernel.org>; Fri, 27 Nov 2009 22:52:22 +0200 (EET)
Received: from dzilna.latnet.lv ([127.0.0.1])
	by localhost (dzilna.latnet.lv [127.0.0.1]) (amavisd-new, port 11141)
	with ESMTP id dZyJjuUguBaf for <linux-media@vger.kernel.org>;
	Fri, 27 Nov 2009 22:52:19 +0200 (EET)
Received: from localhost (clients.latnet.lv [92.240.64.12])
	by dzilna.latnet.lv (Postfix) with ESMTP id BFEFDB3C12
	for <linux-media@vger.kernel.org>; Fri, 27 Nov 2009 22:52:19 +0200 (EET)
Message-ID: <1259355139.4b103c03ac1a3@online.sigmanet.lv>
Date: Fri, 27 Nov 2009 22:52:19 +0200
From: agris@eetserviss.lv
To: linux-media@vger.kernel.org
Subject: KWorld 380U, qt1010, em28xx
MIME-Version: 1.0
Content-Type: text/plain; charset=windows-1257
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I'm into problem with KWorld 380U (e1ba:e359) usb stick.

As I see in http://linuxtv.org/hg/v4l-dvb/, there is still no support for my
dvb-t stick, but there should be support for Kworld 355U, so in em28xx-cards.c
I have changed in line 1729 '(0xeb1a, 0xe355)' to '(0xeb1a, 0xe359)', compiled,
installed and loaded new modules.

After plugging in dvb-t usb stick, dmesg shows:
Nov 27 22:48:24 dtv kernel: usb 1-7: new high speed USB device using
ehci_hcd and address 9
Nov 27 22:48:24 dtv kernel: usb 1-7: New USB device found, idVendor=eb1a,
idProduct=e359
Nov 27 22:48:24 dtv kernel: usb 1-7: New USB device strings: Mfr=0,
Product=1, SerialNumber=0
Nov 27 22:48:24 dtv kernel: usb 1-7: Product: USB 2870 Device
Nov 27 22:48:24 dtv kernel: usb 1-7: configuration #1 chosen from 1 choice
Nov 27 22:48:24 dtv kernel: em28xx #0: chip ID is em2870
Nov 27 22:48:24 dtv kernel: em28xx #0: i2c eeprom 00: 1a eb 67 95 1a eb 59
e3 c0 12 62 40 6a 22 00 00
Nov 27 22:48:24 dtv kernel: em28xx #0: i2c eeprom 10: 00 00 04 57 60 0d 00
00 60 00 00 00 02 00 00 00
Nov 27 22:48:24 dtv kernel: em28xx #0: i2c eeprom 20: 54 00 00 00 f0 10 01
00 00 00 00 00 5b 00 00 00
Nov 27 22:48:24 dtv kernel: em28xx #0: i2c eeprom 30: 00 00 20 40 20 80 02
20 01 01 00 00 00 00 00 00
Nov 27 22:48:24 dtv kernel: em28xx #0: i2c eeprom 40: 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00 00
Nov 27 22:48:24 dtv kernel: em28xx #0: i2c eeprom 50: 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00 00
Nov 27 22:48:24 dtv kernel: em28xx #0: i2c eeprom 60: 00 00 00 00 00 00 00
00 00 00 22 03 55 00 53 00
Nov 27 22:48:24 dtv kernel: em28xx #0: i2c eeprom 70: 42 00 20 00 32 00 38
00 37 00 30 00 20 00 44 00
Nov 27 22:48:24 dtv kernel: em28xx #0: i2c eeprom 80: 65 00 76 00 69 00 63
00 65 00 00 00 00 00 00 00
Nov 27 22:48:24 dtv kernel: em28xx #0: i2c eeprom 90: 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00 00
Nov 27 22:48:24 dtv kernel: em28xx #0: i2c eeprom a0: 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00 00
Nov 27 22:48:24 dtv kernel: em28xx #0: i2c eeprom b0: 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00 00
Nov 27 22:48:24 dtv kernel: em28xx #0: i2c eeprom c0: 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00 00
Nov 27 22:48:24 dtv kernel: em28xx #0: i2c eeprom d0: 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00 00
Nov 27 22:48:24 dtv kernel: em28xx #0: i2c eeprom e0: 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00 00
Nov 27 22:48:24 dtv kernel: em28xx #0: i2c eeprom f0: 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00 00
Nov 27 22:48:24 dtv kernel: em28xx #0: EEPROM ID= 0x9567eb1a, EEPROM hash =
0xa4317302
Nov 27 22:48:24 dtv kernel: em28xx #0: EEPROM info:
Nov 27 22:48:24 dtv kernel: em28xx #0:^INo audio on board.
Nov 27 22:48:24 dtv kernel: em28xx #0:^I500mA max power
Nov 27 22:48:24 dtv kernel: em28xx #0:^ITable at 0x04, strings=0x226a,
0x0000, 0x0000
Nov 27 22:48:24 dtv kernel: em28xx #0: Identified as Kworld 355 U DVB-T
(card=42)
Nov 27 22:48:24 dtv kernel: tuner 4-0062: chip found @ 0xc4 (em28xx #0)
Nov 27 22:48:24 dtv kernel: em28xx #0: v4l2 driver version 0.1.2
Nov 27 22:48:24 dtv kernel: em28xx #0: V4L2 video device registered as
/dev/video0


And still, no dvb devices made. Where did I go wrong and how to find the way to
solution of this problem?



Agris

