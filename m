Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp20.orange.fr ([80.12.242.26]:33273 "EHLO smtp20.orange.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752197Ab0BNRSI (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 14 Feb 2010 12:18:08 -0500
Received: from me-wanadoo.net (localhost [127.0.0.1])
	by mwinf2016.orange.fr (SMTP Server) with ESMTP id 2234E2000A90
	for <linux-media@vger.kernel.org>; Sun, 14 Feb 2010 18:18:04 +0100 (CET)
Received: from me-wanadoo.net (localhost [127.0.0.1])
	by mwinf2016.orange.fr (SMTP Server) with ESMTP id 0F7AF2000A99
	for <linux-media@vger.kernel.org>; Sun, 14 Feb 2010 18:18:04 +0100 (CET)
Received: from [192.168.0.1] (AVelizy-151-1-22-57.w82-124.abo.wanadoo.fr [82.124.116.57])
	by mwinf2016.orange.fr (SMTP Server) with ESMTP id AB9042000A90
	for <linux-media@vger.kernel.org>; Sun, 14 Feb 2010 18:18:01 +0100 (CET)
Message-ID: <4B78305F.8060500@libertysurf.fr>
Date: Sun, 14 Feb 2010 18:18:23 +0100
From: Catimimi <catimimi@libertysurf.fr>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: em28xx and Terratex Cinergy Hybrid T USB XS 0ccd,004c
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

If it can help to validate this unit, you'll find below the result od 
dmesg whenit is plugged in :

[   86.977094] usb 2-1: new high speed USB device using ehci_hcd and 
address 3
[   87.129594] usb 2-1: New USB device found, idVendor=0ccd, idProduct=004c
[   87.129614] usb 2-1: New USB device strings: Mfr=2, Product=1, 
SerialNumber=0
[   87.129627] usb 2-1: Product: Cinergy Hybrid T USB XS FR
[   87.129637] usb 2-1: Manufacturer: TerraTec Electronic GmbH
[   87.129824] usb 2-1: configuration #1 chosen from 1 choice
[   87.313123] em28xx: New device TerraTec Electronic GmbH Cinergy 
Hybrid T USB XS FR @ 480 Mbps (0ccd:004c, interface 0, class 0)
[   87.326274] em28xx #0: chip ID is em2882/em2883
[   87.485970] em28xx #0: i2c eeprom 00: 1a eb 67 95 cd 0c 4c 00 60 12 
5c 03 6a 38 a2 34
[   87.485993] em28xx #0: i2c eeprom 10: 00 00 06 57 46 07 00 00 00 00 
00 00 00 00 00 00
[   87.486011] em28xx #0: i2c eeprom 20: 4e 00 10 00 f0 10 31 88 b8 00 
14 00 5b 1e 00 00
[   87.486029] em28xx #0: i2c eeprom 30: 00 00 20 40 20 6e 02 20 10 01 
00 00 00 00 00 00
[   87.486047] em28xx #0: i2c eeprom 40: 00 00 00 00 00 00 00 00 00 00 
00 00 00 00 00 00
[   87.486064] em28xx #0: i2c eeprom 50: 00 00 00 00 00 00 00 00 00 00 
00 00 00 00 00 00
[   87.486082] em28xx #0: i2c eeprom 60: 00 00 00 00 00 00 00 00 00 00 
38 03 43 00 69 00
[   87.486100] em28xx #0: i2c eeprom 70: 6e 00 65 00 72 00 67 00 79 00 
20 00 48 00 79 00
[   87.486118] em28xx #0: i2c eeprom 80: 62 00 72 00 69 00 64 00 20 00 
54 00 20 00 55 00
[   87.486135] em28xx #0: i2c eeprom 90: 53 00 42 00 20 00 58 00 53 00 
20 00 46 00 52 00
[   87.486153] em28xx #0: i2c eeprom a0: 00 00 34 03 54 00 65 00 72 00 
72 00 61 00 54 00
[   87.486170] em28xx #0: i2c eeprom b0: 65 00 63 00 20 00 45 00 6c 00 
65 00 63 00 74 00
[   87.486188] em28xx #0: i2c eeprom c0: 72 00 6f 00 6e 00 69 00 63 00 
20 00 47 00 6d 00
[   87.486206] em28xx #0: i2c eeprom d0: 62 00 48 00 00 00 00 00 00 00 
00 00 00 00 00 00
[   87.486223] em28xx #0: i2c eeprom e0: 00 00 00 00 00 00 00 00 00 00 
00 00 00 00 00 00
[   87.486241] em28xx #0: i2c eeprom f0: 00 00 00 00 00 00 00 00 00 00 
00 00 00 00 00 00
[   87.486260] em28xx #0: EEPROM ID= 0x9567eb1a, EEPROM hash = 0xfea8f21d
[   87.486266] em28xx #0: EEPROM info:
[   87.486271] em28xx #0:    I2S audio, sample rate=32k
[   87.486276] em28xx #0:    500mA max power
[   87.486281] em28xx #0:    Table at 0x06, strings=0x386a, 0x34a2, 0x0000
[   87.486970] em28xx #0: Identified as Terratec Hybrid XS Secam (card=51)
[   87.486983] em28xx #0:
[   87.486984]
[   87.486990] em28xx #0: The support for this board weren't valid yet.
[   87.486996] em28xx #0: Please send a report of having this working
[   87.487002] em28xx #0: not to V4L mailing list (and/or to other 
addresses)
[   87.487004]
[   87.507721] msp3400 0-0044: MSP3415G-B8 found @ 0x88 (em28xx #0)
[   87.507737] msp3400 0-0044: msp3400 supports nicam and radio, mode is 
autodetect and autoselect
[   87.521848] tvp5150 0-005c: chip found @ 0xb8 (em28xx #0)
[   87.540508] tuner 0-0061: chip found @ 0xc2 (em28xx #0)
[   87.573389] xc2028 0-0061: creating new instance
[   87.573400] xc2028 0-0061: type set to XCeive xc2028/xc3028 tuner
[   87.573413] usb 2-1: firmware: requesting xc3028-v27.fw
[   87.636660] xc2028 0-0061: Loading 80 firmware images from 
xc3028-v27.fw, type: xc2028 firmware, ver 2.7
[   87.685063] xc2028 0-0061: Loading firmware for type=BASE (1), id 
0000000000000000.
[   88.690351] xc2028 0-0061: Loading firmware for type=(0), id 
000000000000b700.
[   88.705224] SCODE (20000000), id 000000000000b700:
[   88.705235] xc2028 0-0061: Loading SCODE for type=MONO SCODE 
HAS_IF_4320 (60008000), id 0000000000008000.
[   88.888098] em28xx #0: Config register raw data: 0x60
[   88.888111] em28xx #0: I2S Audio (3 sample rates)
[   88.888116] em28xx #0: No AC97 audio processor
[   89.001959] tvp5150 0-005c: tvp5150am1 detected.
[   89.116049] em28xx #0: v4l2 driver version 0.1.2
[   89.132359] tvp5150 0-005c: i2c i/o error: rc == -19 (should be 1)
[   89.135958] msp3400 0-0044: I/O error #0 (read 0x10/0x30)
[   89.144720] msp3400 0-0044: I/O error #1 (read 0x10/0x30)
[   89.156582] msp3400 0-0044: I/O error #2 (read 0x10/0x30)
[   89.168058] msp3400 0-0044: resetting chip, sound will go off.
[   89.169227] msp3400 0-0044: chip reset failed
[   89.170704] msp3400 0-0044: chip reset failed
[   89.214685] em28xx #0: V4L2 device registered as /dev/video1 and 
/dev/vbi0
[   89.242829] usbcore: registered new interface driver snd-usb-audio
[   89.242843] usbcore: registered new interface driver em28xx
[   89.242854] em28xx driver loaded
[   89.353470] tvp5150 0-005c: tvp5150am1 detected.
[   89.673467] tvp5150 0-005c: tvp5150am1 detected.

There is an error with tvp5150 and with msp3400.
The following Modules are loaded :

em28xx
msp3400
tvp5150
tuner_xc3028
snd_rawmidi
snd_usb_lib
snd_usb_audio

I run openSUSE 11.2 with the very last kernel 2.6.31.12-0.1

Ready to make test.
Regards
Michel.



