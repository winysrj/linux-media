Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:49534 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755104Ab2CJPcw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 10 Mar 2012 10:32:52 -0500
Received: by dajr28 with SMTP id r28so2816460daj.19
        for <linux-media@vger.kernel.org>; Sat, 10 Mar 2012 07:32:52 -0800 (PST)
MIME-Version: 1.0
From: =?ISO-8859-2?Q?Pawe=B3_Jurkiewicz?= <pawelj84@gmail.com>
Date: Sat, 10 Mar 2012 16:32:32 +0100
Message-ID: <CAGXz8ET49KvjYSSmndwrcgbCtDCuBR0NwSBdx7arm5BRFE4b=w@mail.gmail.com>
Subject: em28xx, qt1010 i2c read failed, Kworld 355U
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi All,

   I don't know if this is a good place for this. I found some kind of
bug in em28xx for Kworld 355U, this is a lsusb line for my tuner:

Bus 001 Device 004: ID eb1a:e357 eMPIA Technology, Inc.

  The problem is with initializing the Quantek QT1010 tuner chip.
Kernel log prints message:

[   99.800535] qt1010 I2C read failed

Unfortunately tuner can't find any channels (on windows 7 it finds all
available).
I know that in Dec 2011 there was a patch that added support of this usb tuner.
I've used latest git drivers backported to Arch Linux stock kernel
(via AUR) and 3.3rc6.
I was trying to find what is wrong but my knowledge about drivers and
kernel modules is poor.
I think that i2c (or GPIO) address is wrong.

Cheers
Pawel

PS:
Here is a part of kernel log related with usb tuner, messge looks
similar in kernl 3.3rc6:

[   99.403415] usb 1-1: new high-speed USB device number 4 using ehci_hcd
[   99.542931] WARNING: You are using an experimental version of the
media stack.
[   99.542941]     As the driver is backported to an older kernel, it
doesn't offer
[   99.542948]     enough quality for its usage in production.
[   99.542954]     Use it with care.
[   99.542958] Latest git patches (needed if you report a bug to
linux-media@vger.kernel.org):
[   99.542965]     632fba4d012458fd5fedc678fb9b0f8bc59ceda2 [media]
cx25821: Add a card definition for No brand cards that have: subvendor
= 0x0000 subdevice = 0x0000
[   99.542976]     1b1301e67bbcad0649a8b3c6a944d2b2acddc411 [media]
Fix small DocBook typo
[   99.542984]     0f67a03ff6ada162ad7518d9092f72d830d3a887 [media]
media: tvp5150: support g_mbus_fmt callback
[   99.552576] IR NEC protocol handler initialized
[   99.557883] IR RC5(x) protocol handler initialized
[   99.568253] IR RC6 protocol handler initialized
[   99.571555] em28xx: New device USB 2870 Device @ 480 Mbps
(eb1a:e357, interface 0, class 0)
[   99.571571] em28xx: Video interface 0 found
[   99.571581] em28xx: DVB interface 0 found
[   99.571805] em28xx #0: chip ID is em2870
[   99.576229] IR JVC protocol handler initialized
[   99.581302] IR Sony protocol handler initialized
[   99.586067] IR MCE Keyboard/mouse protocol handler initialized
[   99.592333] lirc_dev: IR Remote Control driver registered, major 250
[   99.594696] IR LIRC bridge handler initialized
[   99.690544] em28xx #0: i2c eeprom 00: 1a eb 67 95 1a eb 57 e3 c0 12
62 40 6a 22 00 00
[   99.690584] em28xx #0: i2c eeprom 10: 00 00 04 57 6a 0d 00 00 60 00
00 00 02 00 00 00
[   99.690618] em28xx #0: i2c eeprom 20: 54 00 00 00 f0 10 01 00 00 00
00 00 5b 00 00 00
[   99.690651] em28xx #0: i2c eeprom 30: 00 00 20 40 20 80 02 20 01 01
00 00 00 00 00 00
[   99.690683] em28xx #0: i2c eeprom 40: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[   99.690716] em28xx #0: i2c eeprom 50: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[   99.690748] em28xx #0: i2c eeprom 60: 00 00 00 00 00 00 00 00 00 00
22 03 55 00 53 00
[   99.690780] em28xx #0: i2c eeprom 70: 42 00 20 00 32 00 38 00 37 00
30 00 20 00 44 00
[   99.690813] em28xx #0: i2c eeprom 80: 65 00 76 00 69 00 63 00 65 00
00 00 00 00 00 00
[   99.690846] em28xx #0: i2c eeprom 90: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[   99.690878] em28xx #0: i2c eeprom a0: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[   99.690910] em28xx #0: i2c eeprom b0: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[   99.690942] em28xx #0: i2c eeprom c0: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[   99.690974] em28xx #0: i2c eeprom d0: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[   99.691007] em28xx #0: i2c eeprom e0: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[   99.691039] em28xx #0: i2c eeprom f0: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[   99.691076] em28xx #0: EEPROM ID= 0x9567eb1a, EEPROM hash = 0x32317d02
[   99.691084] em28xx #0: EEPROM info:
[   99.691090] em28xx #0:    No audio on board.
[   99.691096] em28xx #0:    500mA max power
[   99.691105] em28xx #0:    Table at 0x04, strings=0x226a, 0x0000, 0x0000
[   99.692160] em28xx #0: Identified as Kworld 355 U DVB-T (card=42)
[   99.692169] em28xx #0:
[   99.692173]
[   99.692181] em28xx #0: The support for this board weren't valid yet.
[   99.692189] em28xx #0: Please send a report of having this working
[   99.692197] em28xx #0: not to V4L mailing list (and/or to other addresses)
[   99.692202]
[   99.692211] em28xx #0: v4l2 driver version 0.1.3
[   99.697951] em28xx #0: V4L2 video device registered as video1
[   99.700909] usbcore: registered new interface driver em28xx
[   99.717805] WARNING: You are using an experimental version of the
media stack.
[   99.717817]     As the driver is backported to an older kernel, it
doesn't offer
[   99.717825]     enough quality for its usage in production.
[   99.717832]     Use it with care.
[   99.717836] Latest git patches (needed if you report a bug to
linux-media@vger.kernel.org):
[   99.717844]     632fba4d012458fd5fedc678fb9b0f8bc59ceda2 [media]
cx25821: Add a card definition for No brand cards that have: subvendor
= 0x0000 subdevice = 0x0000
[   99.717856]     1b1301e67bbcad0649a8b3c6a944d2b2acddc411 [media]
Fix small DocBook typo
[   99.717863]     0f67a03ff6ada162ad7518d9092f72d830d3a887 [media]
media: tvp5150: support g_mbus_fmt callback
[   99.800535] qt1010 I2C read failed
[   99.800560] DVB: registering new adapter (em28xx #0)
[   99.800573] DVB: registering adapter 0 frontend 0 (Zarlink ZL10353 DVB-T)...
[   99.806869] em28xx #0: Successfully loaded em28xx-dvb
[   99.806886] Em28xx: Initialized (Em28xx dvb Extension) extension
