Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.188]:53057 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752540AbZIBWis (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 2 Sep 2009 18:38:48 -0400
Message-ID: <4A9EF3F0.60902@c-m-w.me.uk>
Date: Wed, 02 Sep 2009 23:38:40 +0100
From: C Western <l@c-m-w.me.uk>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: em28xx: new board id [1b80:e304]
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This device "Kworld DVD Maker 2" is a USB video capture device (no tuner)

see: <http://www.maplin.co.uk/Module.aspx?ModuleNo=225632>

It is not recognized by the latest em28xx driver, but if I edit
em28xx-cards.c to duplicate the entry for the device
0x1b80:0xe302 (EM2820_BOARD_PINNACLE_DVC_90) it seems to do basic video
capture OK. I have not tested the audio input.

The kernel logs look like this on plugging in:

usb 1-3: new high speed USB device using ehci_hcd and address 9
usb 1-3: New USB device found, idVendor=1b80, idProduct=e304
usb 1-3: New USB device strings: Mfr=0, Product=1, SerialNumber=0
usb 1-3: Product: USB 2861 Device
em28xx: New device USB 2861 Device @ 480 Mbps (1b80:e304, interface 0, 
class 0)
em28xx #0: chip ID is em2882/em2883
em28xx #0: i2c eeprom 00: 1a eb 67 95 80 1b 04 e3 50 00 20 03 6a 22 00 00
em28xx #0: i2c eeprom 10: 00 00 04 57 06 02 00 00 00 00 00 00 00 00 00 00
em28xx #0: i2c eeprom 20: 02 00 01 00 f0 00 01 00 00 00 00 00 5b 00 00 00
em28xx #0: i2c eeprom 30: 00 00 20 40 20 80 02 20 01 01 02 01 00 00 00 00
em28xx #0: i2c eeprom 40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
em28xx #0: i2c eeprom 50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
em28xx #0: i2c eeprom 60: 00 00 00 00 00 00 00 00 00 00 22 03 55 00 53 00
em28xx #0: i2c eeprom 70: 42 00 20 00 32 00 38 00 36 00 31 00 20 00 44 00
em28xx #0: i2c eeprom 80: 65 00 76 00 69 00 63 00 65 00 00 00 00 00 00 00
em28xx #0: i2c eeprom 90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
em28xx #0: i2c eeprom a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
em28xx #0: i2c eeprom b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
em28xx #0: i2c eeprom c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
em28xx #0: i2c eeprom d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
em28xx #0: i2c eeprom e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
em28xx #0: i2c eeprom f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
em28xx #0: EEPROM ID= 0x9567eb1a, EEPROM hash = 0x459c6e40
em28xx #0: EEPROM info:
em28xx #0:    AC97 audio (5 sample rates)
em28xx #0:    500mA max power
em28xx #0:    Table at 0x04, strings=0x226a, 0x0000, 0x0000
em28xx #0: Identified as Pinnacle Dazzle DVC 90/100/101/107 / Kaiser 
Baas Video to DVD maker (card=9)
saa7115 3-0025: saa7113 found (1f7113d0e100000) @ 0x4a (em28xx #0)
em28xx #0: Config register raw data: 0x50
em28xx #0: AC97 vendor ID = 0x83847650
em28xx #0: AC97 features = 0x6a90
em28xx #0: Sigmatel audio processor detected(stac 9750)
em28xx #0: v4l2 driver version 0.1.2
em28xx #0: V4L2 device registered as /dev/video0 and /dev/vbi0


