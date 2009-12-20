Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f209.google.com ([209.85.219.209]:50892 "EHLO
	mail-ew0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755388AbZLTRHR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 20 Dec 2009 12:07:17 -0500
Received: by ewy1 with SMTP id 1so5500935ewy.28
        for <linux-media@vger.kernel.org>; Sun, 20 Dec 2009 09:07:15 -0800 (PST)
MIME-Version: 1.0
Date: Sun, 20 Dec 2009 17:07:14 +0000
Message-ID: <74fd948d0912200907j21fcc7b1qd2bfd2da00d4f72@mail.gmail.com>
Subject: Pinnacle PCTV Hybrid (2) dvb woes
From: Pedro Ribeiro <pedrib@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello all,

I'm having trouble setting up DVB for my Pinnacle PCTV Hybrid Stick
(2), AKA 330e.

I'm using the 2.6.32.2 kernel and everything appears to be fine when I
plug it in, dmesg below:

Dec 20 16:54:15 portatel kernel: [ 4680.702165] usb 1-1: new high
speed USB device using ehci_hcd and address 14
Dec 20 16:54:15 portatel kernel: [ 4680.824615] usb 1-1: New USB
device found, idVendor=2304, idProduct=0226
Dec 20 16:54:15 portatel kernel: [ 4680.824625] usb 1-1: New USB
device strings: Mfr=3, Product=1, SerialNumber=2
Dec 20 16:54:15 portatel kernel: [ 4680.824632] usb 1-1: Product: PCTV 330e
Dec 20 16:54:15 portatel kernel: [ 4680.824637] usb 1-1: Manufacturer:
Pinnacle Systems
Dec 20 16:54:15 portatel kernel: [ 4680.824643] usb 1-1: SerialNumber:
061101030186
Dec 20 16:54:15 portatel kernel: [ 4680.824838] usb 1-1: configuration
#1 chosen from 1 choice
Dec 20 16:54:15 portatel kernel: [ 4680.862751] Linux video capture
interface: v2.00
Dec 20 16:54:15 portatel kernel: [ 4680.870970] em28xx: New device
Pinnacle Systems PCTV 330e @ 480 Mbps (2304:0226, interface 0, class
0)
Dec 20 16:54:15 portatel kernel: [ 4680.871088] em28xx #0: chip ID is
em2882/em2883
Dec 20 16:54:15 portatel kernel: [ 4681.011240] em28xx #0: i2c eeprom
00: 1a eb 67 95 04 23 26 02 d0 12 5c 03 8e 16 a4 1c
Dec 20 16:54:15 portatel kernel: [ 4681.011270] em28xx #0: i2c eeprom
10: 6a 24 27 57 46 07 01 00 00 00 00 00 00 00 00 00
Dec 20 16:54:15 portatel kernel: [ 4681.011298] em28xx #0: i2c eeprom
20: 46 00 01 00 f0 10 02 00 b8 00 00 00 5b e0 00 00
Dec 20 16:54:15 portatel kernel: [ 4681.011326] em28xx #0: i2c eeprom
30: 00 00 20 40 20 6e 02 20 10 01 00 00 00 00 00 00
Dec 20 16:54:15 portatel kernel: [ 4681.011353] em28xx #0: i2c eeprom
40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
Dec 20 16:54:15 portatel kernel: [ 4681.011380] em28xx #0: i2c eeprom
50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
Dec 20 16:54:15 portatel kernel: [ 4681.011407] em28xx #0: i2c eeprom
60: 00 00 00 00 00 00 00 00 00 00 24 03 50 00 69 00
Dec 20 16:54:15 portatel kernel: [ 4681.011434] em28xx #0: i2c eeprom
70: 6e 00 6e 00 61 00 63 00 6c 00 65 00 20 00 53 00
Dec 20 16:54:15 portatel kernel: [ 4681.011462] em28xx #0: i2c eeprom
80: 79 00 73 00 74 00 65 00 6d 00 73 00 00 00 16 03
Dec 20 16:54:15 portatel kernel: [ 4681.011489] em28xx #0: i2c eeprom
90: 50 00 43 00 54 00 56 00 20 00 33 00 33 00 30 00
Dec 20 16:54:15 portatel kernel: [ 4681.011516] em28xx #0: i2c eeprom
a0: 65 00 00 00 1c 03 30 00 36 00 31 00 31 00 30 00
Dec 20 16:54:15 portatel kernel: [ 4681.011543] em28xx #0: i2c eeprom
b0: 31 00 30 00 33 00 30 00 31 00 38 00 36 00 00 00
Dec 20 16:54:15 portatel kernel: [ 4681.011570] em28xx #0: i2c eeprom
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
Dec 20 16:54:15 portatel kernel: [ 4681.011597] em28xx #0: i2c eeprom
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
Dec 20 16:54:15 portatel kernel: [ 4681.011624] em28xx #0: i2c eeprom
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
Dec 20 16:54:15 portatel kernel: [ 4681.011651] em28xx #0: i2c eeprom
f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
Dec 20 16:54:15 portatel kernel: [ 4681.011682] em28xx #0: EEPROM ID=
0x9567eb1a, EEPROM hash = 0x7ab3a4bf
Dec 20 16:54:15 portatel kernel: [ 4681.011687] em28xx #0: EEPROM info:
Dec 20 16:54:15 portatel kernel: [ 4681.011691] em28xx #0:	AC97 audio
(5 sample rates)
Dec 20 16:54:15 portatel kernel: [ 4681.011695] em28xx #0:	500mA max power
Dec 20 16:54:15 portatel kernel: [ 4681.011701] em28xx #0:	Table at
0x27, strings=0x168e, 0x1ca4, 0x246a
Dec 20 16:54:15 portatel kernel: [ 4681.013356] em28xx #0: Identified
as Pinnacle Hybrid Pro (2) (card=56)
Dec 20 16:54:15 portatel kernel: [ 4681.019413] tvp5150 1-005c: chip
found @ 0xb8 (em28xx #0)
Dec 20 16:54:15 portatel kernel: [ 4681.024750] tuner 1-0061: chip
found @ 0xc2 (em28xx #0)
Dec 20 16:54:15 portatel kernel: [ 4681.030121] xc2028 1-0061:
creating new instance
Dec 20 16:54:15 portatel kernel: [ 4681.030125] xc2028 1-0061: type
set to XCeive xc2028/xc3028 tuner
Dec 20 16:54:15 portatel kernel: [ 4681.030135] usb 1-1: firmware:
requesting xc3028-v27.fw
Dec 20 16:54:16 portatel kernel: [ 4681.109735] xc2028 1-0061: Loading
80 firmware images from xc3028-v27.fw, type: xc2028 firmware, ver 2.7
Dec 20 16:54:16 portatel kernel: [ 4681.143076] xc2028 1-0061: Loading
firmware for type=BASE MTS (5), id 0000000000000000.
Dec 20 16:54:16 portatel kernel: [ 4682.036873] xc2028 1-0061: Loading
firmware for type=MTS (4), id 000000000000b700.
Dec 20 16:54:17 portatel kernel: [ 4682.052517] xc2028 1-0061: Loading
SCODE for type=MTS LCD NOGD MONO IF SCODE HAS_IF_4500 (6002b004), id
000000000000b700.
Dec 20 16:54:17 portatel kernel: [ 4682.212252] em28xx #0: Config
register raw data: 0xd0
Dec 20 16:54:17 portatel kernel: [ 4682.212996] em28xx #0: AC97 vendor
ID = 0xffffffff
Dec 20 16:54:17 portatel kernel: [ 4682.213466] em28xx #0: AC97
features = 0x6a90
Dec 20 16:54:17 portatel kernel: [ 4682.213471] em28xx #0: Empia 202
AC97 audio processor detected
Dec 20 16:54:17 portatel kernel: [ 4682.302510] tvp5150 1-005c:
tvp5150am1 detected.
Dec 20 16:54:17 portatel kernel: [ 4682.393868] em28xx #0: v4l2 driver
version 0.1.2
Dec 20 16:54:17 portatel kernel: [ 4682.457547] em28xx #0: V4L2 video
device registered as /dev/video0
Dec 20 16:54:17 portatel kernel: [ 4682.457555] em28xx #0: V4L2 VBI
device registered as /dev/vbi0
Dec 20 16:54:17 portatel kernel: [ 4682.469106] usbcore: registered
new interface driver em28xx
Dec 20 16:54:17 portatel kernel: [ 4682.469115] em28xx driver loaded
Dec 20 16:54:17 portatel kernel: [ 4682.480843] em28xx-audio.c:
probing for em28x1 non standard usbaudio
Dec 20 16:54:17 portatel kernel: [ 4682.480846] em28xx-audio.c:
Copyright (C) 2006 Markus Rechberger
Dec 20 16:54:17 portatel kernel: [ 4682.482277] Em28xx: Initialized
(Em28xx Audio Extension) extension
Dec 20 16:54:17 portatel kernel: [ 4682.614483] tvp5150 1-005c:
tvp5150am1 detected.
Dec 20 16:54:17 portatel kernel: [ 4682.834451] tvp5150 1-005c:
tvp5150am1 detected


Analog TV works nicely. However, no /dev/dvb/ device is created.

If I modprobe em28xx-dvb manually, I get:

Dec 20 16:54:33 portatel kernel: [ 4698.654993] Em28xx: Initialized
(Em28xx dvb Extension) extension

But still no /dev/dvb/ device...

The card is quite old and listed as supported in both the wiki and in
CARDLIST.em28xx, so I'm assuming DVB-T also works.

Can anyone please give me a hint on what I'm doing wrong?

Thanks for the help,
Pedro
