Return-path: <linux-media-owner@vger.kernel.org>
Received: from bucky.philpem.me.uk ([96.47.225.114]:47810 "EHLO
	bucky.philpem.me.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752054Ab3EZKbN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 26 May 2013 06:31:13 -0400
Received: from 188-222-201-97.zone13.bethere.co.uk ([188.222.201.97]:57845 helo=wolf.philpem.me.uk)
	by bucky.philpem.me.uk with esmtpsa (TLSv1:DHE-RSA-AES256-SHA:256)
	(Exim 4.80)
	(envelope-from <philpem@philpem.me.uk>)
	id 1UgXAc-0004ku-I7
	for linux-media@vger.kernel.org; Sun, 26 May 2013 10:23:19 +0100
Received: from [10.0.0.32] (cheetah.homenet.philpem.me.uk [10.0.0.32])
	by wolf.philpem.me.uk (Postfix) with ESMTPSA id 34A8D2C07D7
	for <linux-media@vger.kernel.org>; Sun, 26 May 2013 10:23:16 +0100 (BST)
Message-ID: <51A1D475.5000106@philpem.me.uk>
Date: Sun, 26 May 2013 10:23:01 +0100
From: Philip Pemberton <philpem@philpem.me.uk>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: EM28xx - new device ID - Ion "Video Forever" USB capture dongle
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi folks,

This is my first post here (I think?) and I'm going to make it an
informative one :)


TL/DR:
  Can someone please add this to the device ID list for the em28xx module?
    Ion "Video Forever" - USB ID EB1A:5124, Card Type 9.
  Confirmed as working with Xawtv and VLC, video source PAL composite
from a FLIR camera; S-video and audio untested as I have no suitable
source to hand.
  Test platform: Ubuntu 13.04 "Raring", kernel 3.8.0-21-generic
#32-Ubuntu SMP x86_64


The longer version:

I found this thing in a local Maplins under stock code A27KJ for the
princely sum of £29.99 on special offer. According to the box, it's a
"Video Forever VHS-to-Digital Video Converter" by ION (www.ionaudio.com).
Strangely they don't list it on their website, so perhaps it's a special
for Maplin?


lsusb says:

Bus 001 Device 084: ID eb1a:5124 eMPIA Technology, Inc.


The CD-ROM in the packet is apparently a driver set for an "ezcap"
device ("Ezcap Video Grabber"), the INF file suggests it's an EM2860
series chip. For a laugh, I did this:

sudo modprobe em28xx card=9
echo eb1a 5124 | sudo tee /sys/bus/usb/drivers/em28xx/new_id

Which has the effect of loading the EM28xx driver with cardtype forced
to 9 (which seems to be a generic EM2860-based device ID), then adding
the new device ID (temporarily) to the module.


Dmesg after doing this:

> [377328.118295] usb 1-1.4.3.5: new high-speed USB device number 94 using ehci-pci
> [377328.217158] usb 1-1.4.3.5: New USB device found, idVendor=eb1a, idProduct=5124
> [377328.217160] usb 1-1.4.3.5: New USB device strings: Mfr=0, Product=1, SerialNumber=2
> [377328.217162] usb 1-1.4.3.5: Product: USB VIDBOX FW Audio
> [377328.217163] usb 1-1.4.3.5: SerialNumber: USB2.0 VIDBOX FW
> [377328.217448] em28xx: New device  USB VIDBOX FW Audio @ 480 Mbps (eb1a:5124, interface 0, class 0)
> [377328.217450] em28xx: Video interface 0 found
> [377328.217451] em28xx: DVB interface 0 found
> [377328.217506] em28xx #0: chip ID is em2860
> [377328.344000] em28xx #0: i2c eeprom 00: 1a eb 67 95 1a eb 24 51 50 00 20 03 8c 28 6a 22
> [377328.344007] em28xx #0: i2c eeprom 10: 00 00 24 57 06 02 00 00 00 00 00 00 00 00 00 00
> [377328.344012] em28xx #0: i2c eeprom 20: 02 00 01 00 f0 10 01 00 00 00 00 00 5b 00 00 00
> [377328.344016] em28xx #0: i2c eeprom 30: 00 00 20 40 20 80 02 20 01 01 00 00 00 00 00 00
> [377328.344020] em28xx #0: i2c eeprom 40: 00 00 00 00 00 00 00 00 00 00 00 00 00 c4 00 00
> [377328.344025] em28xx #0: i2c eeprom 50: 00 a2 00 87 81 00 00 00 00 00 00 00 00 00 00 00
> [377328.344029] em28xx #0: i2c eeprom 60: 00 00 00 00 00 00 00 00 00 00 22 03 55 00 53 00
> [377328.344033] em28xx #0: i2c eeprom 70: 42 00 32 00 2e 00 30 00 20 00 56 00 49 00 44 00
> [377328.344038] em28xx #0: i2c eeprom 80: 42 00 4f 00 58 00 20 00 46 00 57 00 28 03 55 00
> [377328.344042] em28xx #0: i2c eeprom 90: 53 00 42 00 20 00 56 00 49 00 44 00 42 00 4f 00
> [377328.344047] em28xx #0: i2c eeprom a0: 58 00 20 00 46 00 57 00 20 00 41 00 75 00 64 00
> [377328.344051] em28xx #0: i2c eeprom b0: 69 00 6f 00 00 00 00 00 00 00 00 00 00 00 00 00
> [377328.344055] em28xx #0: i2c eeprom c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> [377328.344060] em28xx #0: i2c eeprom d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> [377328.344064] em28xx #0: i2c eeprom e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> [377328.344068] em28xx #0: i2c eeprom f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> [377328.344074] em28xx #0: EEPROM ID= 0x9567eb1a, EEPROM hash = 0x806f2156
> [377328.344075] em28xx #0: EEPROM info:
> [377328.344076] em28xx #0:	AC97 audio (5 sample rates)
> [377328.344076] em28xx #0:	500mA max power
> [377328.344078] em28xx #0:	Table at 0x24, strings=0x288c, 0x226a, 0x0000
> [377328.344080] em28xx #0: Identified as Pinnacle Dazzle DVC 90/100/101/107 / Kaiser Baas Video to DVD maker / Kworld DVD Maker 2 / Plextor ConvertX PX-AV100U (card=9)
> [377328.706041] saa7115 4-0025: saa7113 found (1f7113d0e100000) @ 0x4a (em28xx #0)
> [377329.472675] em28xx #0: Config register raw data: 0x50
> [377329.496532] em28xx #0: AC97 vendor ID = 0x83847652
> [377329.508515] em28xx #0: AC97 features = 0x6a90
> [377329.508517] em28xx #0: Sigmatel audio processor detected(stac 9752)
> [377329.967933] em28xx #0: v4l2 driver version 0.1.3
> [377330.990725] em28xx #0: V4L2 video device registered as video0
> [377330.990727] em28xx #0: V4L2 VBI device registered as vbi0


Fire up Xawtv or VLC, select the device, enjoy.

Thanks,
-- 
Phil.
philpem@philpem.me.uk
http://www.philpem.me.uk/
