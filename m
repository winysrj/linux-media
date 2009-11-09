Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp01.udag.de ([89.31.137.29]:57771 "EHLO smtp01.udag.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751167AbZKIWPY (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 9 Nov 2009 17:15:24 -0500
Received: from localhost (oceanix.udag.de [89.31.137.27])
	by smtp01.udag.de (Postfix) with ESMTP id 34D829C44F
	for <linux-media@vger.kernel.org>; Mon,  9 Nov 2009 22:56:12 +0100 (CET)
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="ISO-8859-1"
MIME-Version: 1.0
From: "Sven Tischer" <Sven@tischers.net>
To: linux-media@vger.kernel.org
Subject: Problems with Terratec Hybrid USB XS
Message-Id: <20091109215613.34D829C44F@smtp01.udag.de>
Date: Mon,  9 Nov 2009 22:56:12 +0100 (CET)
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Hello,
i get this message while connecting my terratec Hybrid USB XS to Ubuntu 9.10

[    7.561527] usb 1-8: new high speed USB device using ehci_hcd and address 5
[    7.712973] usb 1-8: configuration #1 chosen from 1 choice
[    7.906708] em28xx: New device TerraTec Electronic GmbH Cinergy Hybrid T USB XS (2882) @ 480 Mbps (0ccd:005e, interface 0, class 0)
[    7.906904] em28xx #0: chip ID is em2882/em2883
[    7.968084] usb 2-1: new low speed USB device using uhci_hcd and address 2
[    8.158102] usb 2-1: configuration #1 chosen from 1 choice
[    8.278805] em28xx #0: i2c eeprom 00: 1a eb 67 95 cd 0c 5e 00 d0 12 5c 03 9e 40 de 1c
[    8.278841] em28xx #0: i2c eeprom 10: 6a 34 27 57 46 07 01 00 00 00 00 00 00 00 00 00
[    8.278875] em28xx #0: i2c eeprom 20: 46 00 01 00 f0 10 31 00 b8 00 14 00 5b 1e 00 00
[    8.278906] em28xx #0: i2c eeprom 30: 00 00 20 40 20 6e 02 20 10 01 00 00 00 00 00 00
[    8.278941] em28xx #0: i2c eeprom 40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[    8.278973] em28xx #0: i2c eeprom 50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[    8.279003] em28xx #0: i2c eeprom 60: 00 00 00 00 00 00 00 00 00 00 34 03 54 00 65 00
[    8.279036] em28xx #0: i2c eeprom 70: 72 00 72 00 61 00 54 00 65 00 63 00 20 00 45 00
[    8.279070] em28xx #0: i2c eeprom 80: 6c 00 65 00 63 00 74 00 72 00 6f 00 6e 00 69 00
[    8.279103] em28xx #0: i2c eeprom 90: 63 00 20 00 47 00 6d 00 62 00 48 00 00 00 40 03
[    8.279135] em28xx #0: i2c eeprom a0: 43 00 69 00 6e 00 65 00 72 00 67 00 79 00 20 00
[    8.279164] em28xx #0: i2c eeprom b0: 48 00 79 00 62 00 72 00 69 00 64 00 20 00 54 00
[    8.279193] em28xx #0: i2c eeprom c0: 20 00 55 00 53 00 42 00 20 00 58 00 53 00 20 00
[    8.279224] em28xx #0: i2c eeprom d0: 28 00 32 00 38 00 38 00 32 00 29 00 00 00 1c 03
[    8.279256] em28xx #0: i2c eeprom e0: 30 00 36 00 31 00 32 00 30 00 32 00 30 00 30 00
[    8.279288] em28xx #0: i2c eeprom f0: 34 00 38 00 32 00 34 00 00 00 00 00 00 00 00 00
[    8.279324] em28xx #0: EEPROM ID= 0x9567eb1a, EEPROM hash = 0x6513b2be
[    8.279331] em28xx #0: EEPROM info:
[    8.279337] em28xx #0:	AC97 audio (5 sample rates)
[    8.279343] em28xx #0:	500mA max power
[    8.279351] em28xx #0:	Table at 0x27, strings=0x409e, 0x1cde, 0x346a
[    8.293136] em28xx #0: Identified as Terratec Hybrid XS (em2882) (card=55)
[    8.293147] em28xx #0: 
[    8.293150] 
[    8.293158] em28xx #0: The support for this board weren't valid yet.
[    8.293166] em28xx #0: Please send a report of having this working
[    8.293174] em28xx #0: not to V4L mailing list (and/or to other addresses)
[    8.293178] 
[    8.367181] tvp5150 2-005c: chip found @ 0xb8 (em28xx #0)
[    8.409317] tuner 2-0061: chip found @ 0xc2 (em28xx #0)
[    8.548712] xc2028 2-0061: creating new instance
[    8.548721] xc2028 2-0061: type set to XCeive xc2028/xc3028 tuner
[    8.548739] usb 1-8: firmware: requesting xc3028-v27.fw
[    8.593615] usbcore: registered new interface driver hiddev
[    8.606545] input: USB Optical Mouse as /devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1:1.0/input/input9
[    8.606842] generic-usb 0003:0461:4D17.0001: input,hidraw0: USB HID v1.11 Mouse [USB Optical Mouse] on usb-0000:00:1d.0-1/input0
[    8.606899] usbcore: registered new interface driver usbhid
[    8.606911] usbhid: v2.6:USB HID core driver
[    8.613601] xc2028 2-0061: Loading 80 firmware images from xc3028-v27.fw, type: xc2028 firmware, ver 2.7
[    8.665571] xc2028 2-0061: Loading firmware for type=BASE (1), id 0000000000000000.

[   10.631931] xc2028 2-0061: Loading firmware for type=(0), id 000000000000b700.
[   10.648764] SCODE (20000000), id 000000000000b700:
[   10.648787] xc2028 2-0061: Loading SCODE for type=MONO SCODE HAS_IF_4320 (60008000), id 0000000000008000.
[   10.833110] em28xx #0: Config register raw data: 0xd0
[   10.833848] em28xx #0: AC97 vendor ID = 0xffffffff
[   10.834801] em28xx #0: AC97 features = 0x6a90
[   10.834810] em28xx #0: Empia 202 AC97 audio processor detected
[   10.972632] tvp5150 2-005c: tvp5150am1 detected.
[   11.095362] em28xx #0: v4l2 driver version 0.1.2
[   11.227453] em28xx #0: V4L2 device registered as /dev/video1 and /dev/vbi0
[   11.246162] usbcore: registered new interface driver em28xx
[   11.246175] em28xx driver loaded
[   11.268371] em28xx-audio.c: probing for em28x1 non standard usbaudio
[   11.268383] em28xx-audio.c: Copyright (C) 2006 Markus Rechberger
[   11.271206] Em28xx: Initialized (Em28xx Audio Extension) extension
[   11.482349] tvp5150 2-005c: tvp5150am1 detected.
[   12.173607] tvp5150 2-005c: tvp5150am1 detected.



can you please help me to get this stick running?
