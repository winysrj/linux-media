Return-path: <linux-media-owner@vger.kernel.org>
Received: from [195.7.61.12] ([195.7.61.12]:44976 "EHLO killala.koala.ie"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752700AbZBKJx7 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Feb 2009 04:53:59 -0500
Received: from [127.0.0.1] (killala.koala.ie [195.7.61.12])
	(authenticated bits=0)
	by killala.koala.ie (8.14.0/8.13.7) with ESMTP id n1B9bqhG016561
	for <linux-media@vger.kernel.org>; Wed, 11 Feb 2009 09:37:52 GMT
Message-ID: <49929D6D.1000507@koala.ie>
Date: Wed, 11 Feb 2009 09:42:05 +0000
From: Simon Kenyon <simon@koala.ie>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: failure of Cinergy Hybrid T USB XS on amd64
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

does anyone know what is going on here?

i know the device works because i can use it on my eee 900 running gentoo

however i get a failure to load the driver (hg pull as of yesterday) on 
two different linux boxes. they are both running gentoo on an amd64

uname -a gives:

Linux newyork 2.6.27-gentoo-r8 #1 SMP PREEMPT Wed Feb 11 00:10:13 GMT 
2009 x86_64 AMD Athlon(tm) 64 X2 Dual Core Processor 6000+ AuthenticAMD 
GNU/Linux

and this is the output from the driver load:

usb 2-1: new high speed USB device using ehci_hcd and address 4
usb 2-1: configuration #1 chosen from 1 choice
em28xx: New device TerraTec Electronic GmbH Cinergy Hybrid T USB XS @ 
480 Mbps (0ccd:0042, interface 0, class 0)
em28xx #0: Identified as Terratec Hybrid XS (card=11)
em28xx #0: chip ID is em2882/em2883
tvp5150' 2-005c: chip found @ 0xb8 (em28xx #0)
tuner' 2-0061: chip found @ 0xc2 (em28xx #0)
em28xx #0: i2c eeprom 00: 1a eb 67 95 cd 0c 42 00 50 12 5c 03 6a 32 9c 34
em28xx #0: i2c eeprom 10: 00 00 06 57 46 07 00 00 00 00 00 00 00 00 00 00
em28xx #0: i2c eeprom 20: 46 00 01 00 f0 10 31 00 b8 00 14 00 5b 00 00 00
em28xx #0: i2c eeprom 30: 00 00 20 40 20 6e 02 20 10 01 00 00 00 00 00 00
em28xx #0: i2c eeprom 40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
em28xx #0: i2c eeprom 50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
em28xx #0: i2c eeprom 60: 00 00 00 00 00 00 00 00 00 00 32 03 43 00 69 00
em28xx #0: i2c eeprom 70: 6e 00 65 00 72 00 67 00 79 00 20 00 48 00 79 00
em28xx #0: i2c eeprom 80: 62 00 72 00 69 00 64 00 20 00 54 00 20 00 55 00
em28xx #0: i2c eeprom 90: 53 00 42 00 20 00 58 00 53 00 00 00 34 03 54 00
em28xx #0: i2c eeprom a0: 65 00 72 00 72 00 61 00 54 00 65 00 63 00 20 00
em28xx #0: i2c eeprom b0: 45 00 6c 00 65 00 63 00 74 00 72 00 6f 00 6e 00
em28xx #0: i2c eeprom c0: 69 00 63 00 20 00 47 00 6d 00 62 00 48 00 00 00
em28xx #0: i2c eeprom d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
em28xx #0: i2c eeprom e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
em28xx #0: i2c eeprom f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
em28xx #0: EEPROM ID= 0x9567eb1a, EEPROM hash = 0x41d0bf96
em28xx #0: EEPROM info:
em28xx #0:      AC97 audio (5 sample rates)
em28xx #0:      500mA max power
em28xx #0:      Table at 0x06, strings=0x326a, 0x349c, 0x0000
xc2028 2-0061: creating new instance
xc2028 2-0061: type set to XCeive xc2028/xc3028 tuner
firmware: requesting xc3028-v27.fw
xc2028 2-0061: Loading 80 firmware images from xc3028-v27.fw, type: 
xc2028 firmware, ver 2.7
xc2028 2-0061: Loading firmware for type=BASE (1), id 0000000000000000.
xc2028 2-0061: Loading firmware for type=(0), id 000000000000b700.
SCODE (20000000), id 000000000000b700:
xc2028 2-0061: Loading SCODE for type=MONO SCODE HAS_IF_4320 (60008000), 
id 0000000000008000.
em28xx #0: Config register raw data: 0x50
em28xx #0: AC97 vendor ID = 0x83847652
em28xx #0: AC97 features = 0x6a90
em28xx #0: Sigmatel audio processor detected(stac 9752)
tvp5150' 2-005c: tvp5150am1 detected.
em28xx #0: v4l2 driver version 0.1.1
em28xx #0: V4L2 device registered as /dev/video1 and /dev/vbi1
zl10353_read_register: readreg error (reg=127, ret==-19)
em28xx #0/2: dvb frontend not attached. Can't attach xc3028

