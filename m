Return-path: <linux-media-owner@vger.kernel.org>
Received: from nskntqsrv03p.mx.bigpond.com ([61.9.168.237]:25739 "EHLO
	nskntqsrv03p.mx.bigpond.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750918AbZG1Jb4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 28 Jul 2009 05:31:56 -0400
Received: from nskntotgx02p.mx.bigpond.com ([203.51.96.144])
          by nskntmtas04p.mx.bigpond.com with ESMTP
          id <20090728083133.OVEB1821.nskntmtas04p.mx.bigpond.com@nskntotgx02p.mx.bigpond.com>
          for <linux-media@vger.kernel.org>;
          Tue, 28 Jul 2009 08:31:33 +0000
Received: from TACO ([203.51.96.144]) by nskntotgx02p.mx.bigpond.com
          with ESMTP
          id <20090728083132.SSFR4023.nskntotgx02p.mx.bigpond.com@TACO>
          for <linux-media@vger.kernel.org>;
          Tue, 28 Jul 2009 08:31:32 +0000
From: "Lee Rowlands" <leerowlands@rowlands-bcs.com>
To: <linux-media@vger.kernel.org>
Subject: KWorld Plus TV 380UR DVB-T USB
Date: Tue, 28 Jul 2009 18:31:29 +1000
Message-ID: <007001ca0f5d$cfb63340$6f2299c0$@com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Content-Language: en-au
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi All
I'm trying to determine if the KWorld Plus TV 380UR DVB-T USB is supported.
I've done a comprehensive search of the net and the mailing lists and tried
about everything.
I can get the v4l drivers to register the device at /dev/video1 and
/dev/vbi0 but can't get the dvb at /dev/dvb etc

I'm using FC8 with kernel as follows:
#uname - a
#Linux localhost.localdomain 2.6.26.8-57.fc8 #1 SMP Thu Dec 18 19:19:45 EST
2008 i686 i686 i386 GNU/Linux

Here's what I've done to date:

*When I first plugged in the device I got the following from dmesg
usb 1-1: New USB device found, idVendor=eb1a, idProduct=e359
usb 1-1: New USB device strings: Mfr=0, Product=1, SerialNumber=0
usb 1-1: Product: USB 2870 Device

*lsusb gave
Bus 001 Device 005: ID eb1a:e359 eMPIA Technology, Inc.

*Googling this vendor and product id got me on to the v4l-dvb wiki

*Downloaded, compiled and installed v4l-dvb

*Determined that this is a em28xx device

*On reboot was able to load the drivers using modprobe

*Plugging in device gave same dmesg output (nothing new)

*After finding an obscure Estonian reference to changing
v4l-dvb/linux/drivers/media/video/em28xx/em28xx-cards.c to include reference
to eb1a:e359 as a KWORLD_355U, made the required change to em28xx-cards.c
then did a make rminstall, make distclean and recompiled the drivers.

*After reboot and then reinserting the device got the following dmesg output

usb 1-1: new high speed USB device using ehci_hcd and address 4
usb 1-1: configuration #1 chosen from 1 choice
em28xx: New device USB 2870 Device @ 480 Mbps (eb1a:e359, interface 0, class
0)
em28xx #0: Identified as Kworld 355 U DVB-T (card=42)
em28xx #0: chip ID is em2870
em28xx #0: i2c eeprom 00: 1a eb 67 95 1a eb 59 e3 c0 12 62 40 6a 22 00 00
em28xx #0: i2c eeprom 10: 00 00 04 57 60 0d 00 00 60 00 00 00 02 00 00 00
em28xx #0: i2c eeprom 20: 54 00 00 00 f0 10 01 00 00 00 00 00 5b 00 00 00
em28xx #0: i2c eeprom 30: 00 00 20 40 20 80 02 20 01 01 00 00 00 00 00 00
em28xx #0: i2c eeprom 40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
em28xx #0: i2c eeprom 50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
em28xx #0: i2c eeprom 60: 00 00 00 00 00 00 00 00 00 00 22 03 55 00 53 00
em28xx #0: i2c eeprom 70: 42 00 20 00 32 00 38 00 37 00 30 00 20 00 44 00
em28xx #0: i2c eeprom 80: 65 00 76 00 69 00 63 00 65 00 00 00 00 00 00 00
em28xx #0: i2c eeprom 90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
em28xx #0: i2c eeprom a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
em28xx #0: i2c eeprom b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
em28xx #0: i2c eeprom c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
em28xx #0: i2c eeprom d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
em28xx #0: i2c eeprom e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
em28xx #0: i2c eeprom f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
em28xx #0: EEPROM ID= 0x9567eb1a, EEPROM hash = 0xa4317302
em28xx #0: EEPROM info:
em28xx #0:      No audio on board.
em28xx #0:      500mA max power
em28xx #0:      Table at 0x04, strings=0x226a, 0x0000, 0x0000
em28xx #0:

em28xx #0: The support for this board weren't valid yet.
em28xx #0: Please send a report of having this working
em28xx #0: not to V4L mailing list (and/or to other addresses)

tuner 0-0062: chip found @ 0xc4 (em28xx #0)
tuner 0-0062: tuner type not set
em28xx #0: v4l2 driver version 0.1.2
em28xx #0: V4L2 device registered as /dev/video1 and /dev/vbi0

*This results in the device nodes /dev/video1 and /dev/vbi0 being created
but stops short of giving me /dev/dvb/adapter etc

Any advice or help you can provide is greatly appreciated.
I can provide Windows drivers from the install disk if required.
Thanks in advance


larowlan
Contact at rowlands dash bcs dot com

