Return-path: <linux-media-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.24]:42107 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754286AbZHUT1Z (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 21 Aug 2009 15:27:25 -0400
Received: by ey-out-2122.google.com with SMTP id 22so250262eye.37
        for <linux-media@vger.kernel.org>; Fri, 21 Aug 2009 12:27:26 -0700 (PDT)
MIME-Version: 1.0
Date: Fri, 21 Aug 2009 21:27:25 +0200
Message-ID: <54b126f90908211227k78cfeebbqcee4da4958743a3b@mail.gmail.com>
Subject: detection of Empire Media Pen Dual TV
From: Giuseppe Bagnato <baggius@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As of latest v4l-dvb trunk installed, detection of Pen Dual TV isn't correct:

Aug 21 20:26:55 box [ 2534.584239] usb 2-1: new high speed USB device
using ehci_hcd and address 7
Aug 21 20:26:55 box [ 2534.701630] usb 2-1: New USB device found,
idVendor=eb1a, idProduct=e310
Aug 21 20:26:55 box [ 2534.701635] usb 2-1: New USB device strings:
Mfr=0, Product=1, SerialNumber=0
Aug 21 20:26:55 box [ 2534.701639] usb 2-1: Product: USB 2881 Device
Aug 21 20:26:55 box [ 2534.702254] usb 2-1: configuration #1 chosen
from 1 choice
Aug 21 20:26:55 box [ 2534.720606] em28xx: New device USB 2881 Device
@ 480 Mbps (eb1a:e310, interface 0, class 0)
Aug 21 20:26:55 box [ 2534.720712] em28xx #0: chip ID is em2882/em2883
Aug 21 20:26:55 box [ 2534.849865] em28xx #0: i2c eeprom 00: 1a eb 67
95 1a eb 10 e3 d0 12 5c 03 6a 22 00 00
Aug 21 20:26:55 box [ 2534.849872] em28xx #0: i2c eeprom 10: 00 00 04
57 4e 07 00 00 00 00 00 00 00 00 00 00
Aug 21 20:26:55 box [ 2534.849878] em28xx #0: i2c eeprom 20: 46 00 01
00 f0 10 01 00 00 00 00 00 5b 1e 00 00
Aug 21 20:26:55 box [ 2534.849884] em28xx #0: i2c eeprom 30: 00 00 20
40 20 80 02 20 01 01 00 00 00 00 00 00
Aug 21 20:26:55 box [ 2534.849889] em28xx #0: i2c eeprom 40: 00 00 00
00 00 00 00 00 00 00 00 00 00 00 00 00
Aug 21 20:26:55 box [ 2534.849895] em28xx #0: i2c eeprom 50: 00 00 00
00 00 00 00 00 00 00 00 00 00 00 00 00
Aug 21 20:26:55 box [ 2534.849901] em28xx #0: i2c eeprom 60: 00 00 00
00 00 00 00 00 00 00 22 03 55 00 53 00
Aug 21 20:26:55 box [ 2534.849906] em28xx #0: i2c eeprom 70: 42 00 20
00 32 00 38 00 38 00 31 00 20 00 44 00
Aug 21 20:26:55 box [ 2534.849912] em28xx #0: i2c eeprom 80: 65 00 76
00 69 00 63 00 65 00 00 00 00 00 00 00
Aug 21 20:26:55 box [ 2534.849918] em28xx #0: i2c eeprom 90: 00 00 00
00 00 00 00 00 00 00 00 00 00 00 00 00
Aug 21 20:26:55 box [ 2534.849923] em28xx #0: i2c eeprom a0: 00 00 00
00 00 00 00 00 00 00 00 00 00 00 00 00
Aug 21 20:26:55 box [ 2534.849929] em28xx #0: i2c eeprom b0: 00 00 00
00 00 00 00 00 00 00 00 00 00 00 00 00
Aug 21 20:26:55 box [ 2534.849934] em28xx #0: i2c eeprom c0: 00 00 00
00 00 00 00 00 00 00 00 00 00 00 00 00
Aug 21 20:26:55 box [ 2534.849940] em28xx #0: i2c eeprom d0: 00 00 00
00 00 00 00 00 00 00 00 00 00 00 00 00
Aug 21 20:26:55 box [ 2534.849946] em28xx #0: i2c eeprom e0: 00 00 00
00 00 00 00 00 00 00 00 00 00 00 00 00
Aug 21 20:26:55 box [ 2534.849951] em28xx #0: i2c eeprom f0: 00 00 00
00 00 00 00 00 00 00 00 00 00 00 00 00
Aug 21 20:26:55 box [ 2534.849958] em28xx #0: EEPROM ID= 0x9567eb1a,
EEPROM hash = 0x166a0441
Aug 21 20:26:55 box [ 2534.849959] em28xx #0: EEPROM info:
Aug 21 20:26:55 box [ 2534.849960] em28xx #0:   AC97 audio (5 sample rates)
Aug 21 20:26:55 box [ 2534.849962] em28xx #0:   500mA max power
Aug 21 20:26:55 box [ 2534.849963] em28xx #0:   Table at 0x04,
strings=0x226a, 0x0000, 0x0000
Aug 21 20:26:55 box [ 2534.849965] em28xx #0: Identified as MSI
DigiVox A/D (card=49)
Aug 21 20:26:55 box [ 2534.849967] em28xx #0: Your board has no unique USB ID.
Aug 21 20:26:55 box [ 2534.849968] em28xx #0: A hint were successfully
done, based on eeprom hash.
Aug 21 20:26:55 box [ 2534.849970] em28xx #0: This method is not 100% failproof.
Aug 21 20:26:55 box [ 2534.849971] em28xx #0: If the board were
missdetected, please email this log to:
Aug 21 20:26:55 box [ 2534.849973] em28xx #0:   V4L Mailing List
<linux-media@vger.kernel.org>
Aug 21 20:26:55 box [ 2534.849974] em28xx #0: Board detected as Empire dual TV
Aug 21 20:26:55 box [ 2534.905501] tvp5150 4-005c: chip found @ 0xb8 (em28xx #0)
Aug 21 20:26:55 box [ 2534.910109] tuner 4-0061: chip found @ 0xc2 (em28xx #0)

The identified card still is a MSI DigiVox A/D (card=49), but as you can see at
        http://www.reghardware.co.uk/2006/06/07/review_kworld_310u/
and
        http://www.empiremedia.it/site/prodotto.asp?idprodotto=231
Empire Media Pen Dual TV is a Kworld 310U based usb pen
analogtv+dvbt+audio/video_in device.

You can check downloads on 2nd link to get drivers, info, layouts and
manual also.
