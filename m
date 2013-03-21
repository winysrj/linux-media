Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr14.xs4all.nl ([194.109.24.34]:2037 "EHLO
	smtp-vbr14.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757551Ab3CUIdw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 21 Mar 2013 04:33:52 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: em28xx: commit aab3125c43d8fecc7134e5f1e729fabf4dd196da broke HVR 900
Date: Thu, 21 Mar 2013 09:33:41 +0100
Cc: "linux-media" <linux-media@vger.kernel.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201303210933.41537.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I tried to use my HVR 900 stick today and discovered that it no longer worked.
I traced it to commit aab3125c43d8fecc7134e5f1e729fabf4dd196da: "em28xx: add
support for registering multiple i2c buses".

The kernel messages for when it fails are:

Mar 21 09:26:54 telek kernel: [ 1393.446606] em28xx: New device  WinTV HVR-900 @ 480 Mbps (2040:6502, interface 0, class 0)
Mar 21 09:26:54 telek kernel: [ 1393.446610] em28xx: Audio interface 0 found (Vendor Class)
Mar 21 09:26:54 telek kernel: [ 1393.446611] em28xx: Video interface 0 found: isoc
Mar 21 09:26:54 telek kernel: [ 1393.446612] em28xx: DVB interface 0 found: isoc
Mar 21 09:26:54 telek kernel: [ 1393.446979] em28xx: chip ID is em2882/3
Mar 21 09:26:54 telek kernel: [ 1393.587885] em2882/3 #0: i2c eeprom 00: 1a eb 67 95 40 20 02 65 d0 12 5c 03 82 1e 6a 18
Mar 21 09:26:54 telek kernel: [ 1393.587896] em2882/3 #0: i2c eeprom 10: 00 00 24 57 66 07 01 00 00 00 00 00 00 00 00 00
Mar 21 09:26:54 telek kernel: [ 1393.587905] em2882/3 #0: i2c eeprom 20: 46 00 01 00 f0 10 02 00 b8 00 00 00 5b e0 00 00
Mar 21 09:26:54 telek kernel: [ 1393.587913] em2882/3 #0: i2c eeprom 30: 00 00 20 40 20 6e 02 20 10 01 01 01 00 00 00 00
Mar 21 09:26:54 telek kernel: [ 1393.587921] em2882/3 #0: i2c eeprom 40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
Mar 21 09:26:54 telek kernel: [ 1393.587929] em2882/3 #0: i2c eeprom 50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
Mar 21 09:26:54 telek kernel: [ 1393.587937] em2882/3 #0: i2c eeprom 60: 00 00 00 00 00 00 00 00 00 00 18 03 34 00 30 00
Mar 21 09:26:54 telek kernel: [ 1393.587946] em2882/3 #0: i2c eeprom 70: 32 00 37 00 36 00 37 00 38 00 36 00 33 00 39 00
Mar 21 09:26:54 telek kernel: [ 1393.587954] em2882/3 #0: i2c eeprom 80: 00 00 1e 03 57 00 69 00 6e 00 54 00 56 00 20 00
Mar 21 09:26:54 telek kernel: [ 1393.587962] em2882/3 #0: i2c eeprom 90: 48 00 56 00 52 00 2d 00 39 00 30 00 30 00 00 00
Mar 21 09:26:54 telek kernel: [ 1393.587970] em2882/3 #0: i2c eeprom a0: 84 12 00 00 05 50 1a 7f d4 78 23 fa fd d0 28 89
Mar 21 09:26:54 telek kernel: [ 1393.587979] em2882/3 #0: i2c eeprom b0: ff 00 00 00 04 84 0a 00 01 01 20 77 00 40 af 7f
Mar 21 09:26:54 telek kernel: [ 1393.587987] em2882/3 #0: i2c eeprom c0: 11 f0 74 02 01 00 01 79 0b 00 00 00 00 00 00 00
Mar 21 09:26:54 telek kernel: [ 1393.587995] em2882/3 #0: i2c eeprom d0: 84 12 00 00 05 50 1a 7f d4 78 23 fa fd d0 28 89
Mar 21 09:26:54 telek kernel: [ 1393.588011] em2882/3 #0: i2c eeprom e0: ff 00 00 00 04 84 0a 00 01 01 20 77 00 40 af 7f
Mar 21 09:26:54 telek kernel: [ 1393.588020] em2882/3 #0: i2c eeprom f0: 11 f0 74 02 01 00 01 79 0b 00 00 00 00 00 00 00
Mar 21 09:26:54 telek kernel: [ 1393.588029] em2882/3 #0: EEPROM ID = 1a eb 67 95, EEPROM hash = 0x323f39dd
Mar 21 09:26:54 telek kernel: [ 1393.588031] em2882/3 #0: EEPROM info:
Mar 21 09:26:54 telek kernel: [ 1393.588032] em2882/3 #0:       No audio on board.
Mar 21 09:26:54 telek kernel: [ 1393.588033] em2882/3 #0:       500mA max power
Mar 21 09:26:54 telek kernel: [ 1393.588034] em2882/3 #0:       Table at offset 0x00, strings=0x0000, 0x0000, 0x0000
Mar 21 09:26:54 telek kernel: [ 1393.588036] em2882/3 #0: Identified as Hauppauge WinTV HVR 900 (R2) (card=18)
Mar 21 09:26:54 telek kernel: [ 1393.591653] tveeprom 12-0050: Hauppauge model 65018, rev B2C0, serial# 1146799
Mar 21 09:26:54 telek kernel: [ 1393.591655] tveeprom 12-0050: tuner model is Xceive XC3028 (idx 120, type 71)
Mar 21 09:26:54 telek kernel: [ 1393.591657] tveeprom 12-0050: TV standards PAL(B/G) PAL(I) PAL(D/D1/K) ATSC/DVB Digital (eeprom 0xd4)
Mar 21 09:26:54 telek kernel: [ 1393.591658] tveeprom 12-0050: audio processor is None (idx 0)
Mar 21 09:26:54 telek kernel: [ 1393.591659] tveeprom 12-0050: has radio
Mar 21 09:26:54 telek kernel: [ 1393.646629] tvp5150 12-005c: chip found @ 0xb8 (em2882/3 #0)
Mar 21 09:26:54 telek kernel: [ 1393.646632] tvp5150 12-005c: tvp5150am1 detected.
Mar 21 09:26:54 telek kernel: [ 1393.677877] tuner 12-0061: Tuner -1 found with type(s) Radio TV.
Mar 21 09:26:54 telek kernel: [ 1393.683854] xc2028 12-0061: creating new instance
Mar 21 09:26:54 telek kernel: [ 1393.683858] xc2028 12-0061: type set to XCeive xc2028/xc3028 tuner
Mar 21 09:26:54 telek kernel: [ 1393.684170] xc2028 12-0061: Loading 97 firmware images from xc3028-v27.fw, type: xc2028 firmware, ver 2.7
Mar 21 09:26:54 telek kernel: [ 1393.685287] em2882/3 #0: Config register raw data: 0xd0
Mar 21 09:26:54 telek kernel: [ 1393.686766] em2882/3 #0: AC97 vendor ID = 0xffffffff
Mar 21 09:26:54 telek kernel: [ 1393.687823] em2882/3 #0: AC97 features = 0x6a90
Mar 21 09:26:54 telek kernel: [ 1393.687826] em2882/3 #0: Empia 202 AC97 audio processor detected
Mar 21 09:26:54 telek kernel: [ 1393.882147] em2882/3 #0: v4l2 driver version 0.2.0
Mar 21 09:26:54 telek kernel: [ 1393.882772] xc2028 12-0061: Loading firmware for type=BASE F8MHZ MTS (7), id 0000000000000000.
Mar 21 09:26:56 telek kernel: [ 1395.953247] MTS (4), id 00000000000000ff:
Mar 21 09:26:56 telek kernel: [ 1395.953262] xc2028 12-0061: Loading firmware for type=MTS (4), id 0000000100000007.
Mar 21 09:26:57 telek kernel: [ 1396.308931] em2882/3 #0: V4L2 video device registered as video0
Mar 21 09:26:57 telek kernel: [ 1396.308935] em2882/3 #0: V4L2 VBI device registered as vbi0
Mar 21 09:26:57 telek kernel: [ 1396.310318] em2882/3 #0: analog set to isoc mode.
Mar 21 09:26:57 telek kernel: [ 1396.310320] em2882/3 #0: dvb set to isoc mode.
Mar 21 09:26:57 telek kernel: [ 1396.311485] usbcore: registered new interface driver em28xx
Mar 21 09:26:57 telek kernel: [ 1396.317648] em28xx-audio.c: probing for em28xx Audio Vendor Class
Mar 21 09:26:57 telek kernel: [ 1396.317651] em28xx-audio.c: Copyright (C) 2006 Markus Rechberger
Mar 21 09:26:57 telek kernel: [ 1396.317652] em28xx-audio.c: Copyright (C) 2007-2011 Mauro Carvalho Chehab
Mar 21 09:26:57 telek kernel: [ 1396.328976] Em28xx: Initialized (Em28xx Audio Extension) extension
Mar 21 09:26:57 telek kernel: [ 1396.542517] xc2028 12-0061: attaching existing instance
Mar 21 09:26:57 telek kernel: [ 1396.542521] xc2028 12-0061: type set to XCeive xc2028/xc3028 tuner
Mar 21 09:26:57 telek kernel: [ 1396.542523] em2882/3 #0: em2882/3 #0/2: xc3028 attached
Mar 21 09:26:57 telek kernel: [ 1396.542525] DVB: registering new adapter (em2882/3 #0)
Mar 21 09:26:57 telek kernel: [ 1396.542548] usb 5-2: DVB: registering adapter 0 frontend 0 (Micronas DRXD DVB-T)...
Mar 21 09:26:57 telek kernel: [ 1396.546126] em2882/3 #0: Successfully loaded em28xx-dvb
Mar 21 09:26:57 telek kernel: [ 1396.546131] Em28xx: Initialized (Em28xx dvb Extension) extension
Mar 21 09:26:57 telek kernel: [ 1396.547833] xc2028 12-0061: Error on line 1293: -19
Mar 21 09:26:57 telek kernel: [ 1396.592046] Registered IR keymap rc-hauppauge
Mar 21 09:26:57 telek kernel: [ 1396.594254] input: em28xx IR (em2882/3 #0) as /devices/pci0000:00/0000:00:1c.2/0000:07:00.0/usb5/5-2/rc/rc0/input27
Mar 21 09:26:57 telek kernel: [ 1396.595200] rc0: em28xx IR (em2882/3 #0) as /devices/pci0000:00/0000:00:1c.2/0000:07:00.0/usb5/5-2/rc/rc0
Mar 21 09:26:57 telek kernel: [ 1396.595594] Em28xx: Initialized (Em28xx Input Extension) extension
Mar 21 09:26:59 telek kernel: [ 1398.314392] xc2028 12-0061: i2c input error: rc = -19 (should be 2)
Mar 21 09:26:59 telek kernel: [ 1398.316642] xc2028 12-0061: i2c input error: rc = -19 (should be 2)
Mar 21 09:26:59 telek kernel: [ 1398.336509] xc2028 12-0061: i2c input error: rc = -19 (should be 2)
Mar 21 09:26:59 telek kernel: [ 1398.337631] xc2028 12-0061: i2c input error: rc = -19 (should be 2)
Mar 21 09:27:02 telek kernel: [ 1401.460224] xc2028 12-0061: Loading firmware for type=BASE F8MHZ MTS (7), id 0000000000000000.
Mar 21 09:27:02 telek kernel: [ 1401.461603] xc2028 12-0061: i2c output error: rc = -19 (should be 64)
Mar 21 09:27:02 telek kernel: [ 1401.461612] xc2028 12-0061: -19 returned from send
Mar 21 09:27:02 telek kernel: [ 1401.461617] xc2028 12-0061: Error -22 while loading base firmware
Mar 21 09:27:02 telek kernel: [ 1401.512052] xc2028 12-0061: Loading firmware for type=BASE F8MHZ MTS (7), id 0000000000000000.
Mar 21 09:27:02 telek kernel: [ 1401.512639] xc2028 12-0061: i2c output error: rc = -19 (should be 64)
Mar 21 09:27:02 telek kernel: [ 1401.512642] xc2028 12-0061: -19 returned from send
Mar 21 09:27:02 telek kernel: [ 1401.512643] xc2028 12-0061: Error -22 while loading base firmware
Mar 21 09:27:02 telek kernel: [ 1401.563027] xc2028 12-0061: Loading firmware for type=BASE F8MHZ MTS (7), id 0000000000000000.
Mar 21 09:27:02 telek kernel: [ 1401.563587] xc2028 12-0061: i2c output error: rc = -19 (should be 64)
Mar 21 09:27:02 telek kernel: [ 1401.563590] xc2028 12-0061: -19 returned from send
Mar 21 09:27:02 telek kernel: [ 1401.563592] xc2028 12-0061: Error -22 while loading base firmware
Mar 21 09:27:02 telek kernel: [ 1401.614035] xc2028 12-0061: Loading firmware for type=BASE F8MHZ MTS (7), id 0000000000000000.
Mar 21 09:27:02 telek kernel: [ 1401.614599] xc2028 12-0061: i2c output error: rc = -19 (should be 64)
Mar 21 09:27:02 telek kernel: [ 1401.614602] xc2028 12-0061: -19 returned from send
Mar 21 09:27:02 telek kernel: [ 1401.614603] xc2028 12-0061: Error -22 while loading base firmware
Mar 21 09:27:02 telek kernel: [ 1401.665047] xc2028 12-0061: Loading firmware for type=BASE F8MHZ MTS (7), id 0000000000000000.
Mar 21 09:27:02 telek kernel: [ 1401.665608] xc2028 12-0061: i2c output error: rc = -19 (should be 64)
Mar 21 09:27:02 telek kernel: [ 1401.665610] xc2028 12-0061: -19 returned from send
Mar 21 09:27:02 telek kernel: [ 1401.665612] xc2028 12-0061: Error -22 while loading base firmware
Mar 21 09:27:02 telek kernel: [ 1401.716048] xc2028 12-0061: Loading firmware for type=BASE F8MHZ MTS (7), id 0000000000000000.
Mar 21 09:27:02 telek kernel: [ 1401.716580] xc2028 12-0061: i2c output error: rc = -19 (should be 64)
Mar 21 09:27:02 telek kernel: [ 1401.716583] xc2028 12-0061: -19 returned from send
Mar 21 09:27:02 telek kernel: [ 1401.716584] xc2028 12-0061: Error -22 while loading base firmware
Mar 21 09:27:02 telek kernel: [ 1401.767050] xc2028 12-0061: Loading firmware for type=BASE F8MHZ MTS (7), id 0000000000000000.
Mar 21 09:27:02 telek kernel: [ 1401.767659] xc2028 12-0061: i2c output error: rc = -19 (should be 64)
Mar 21 09:27:02 telek kernel: [ 1401.767662] xc2028 12-0061: -19 returned from send
Mar 21 09:27:02 telek kernel: [ 1401.767664] xc2028 12-0061: Error -22 while loading base firmware
Mar 21 09:27:02 telek kernel: [ 1401.818018] xc2028 12-0061: Loading firmware for type=BASE F8MHZ MTS (7), id 0000000000000000.
Mar 21 09:27:02 telek kernel: [ 1401.818523] xc2028 12-0061: i2c output error: rc = -19 (should be 64)
Mar 21 09:27:02 telek kernel: [ 1401.818525] xc2028 12-0061: -19 returned from send
Mar 21 09:27:02 telek kernel: [ 1401.818527] xc2028 12-0061: Error -22 while loading base firmware
Mar 21 09:27:02 telek kernel: [ 1401.869048] xc2028 12-0061: Loading firmware for type=BASE F8MHZ MTS (7), id 0000000000000000.
Mar 21 09:27:02 telek kernel: [ 1401.869625] xc2028 12-0061: i2c output error: rc = -19 (should be 64)
Mar 21 09:27:02 telek kernel: [ 1401.869628] xc2028 12-0061: -19 returned from send
Mar 21 09:27:02 telek kernel: [ 1401.869629] xc2028 12-0061: Error -22 while loading base firmware
Mar 21 09:27:06 telek kernel: [ 1405.202225] xc2028 12-0061: Error on line 1293: -19

And this is how it should look like:

Mar 21 09:24:49 telek kernel: [ 1268.313138] em28xx: New device  WinTV HVR-900 @ 480 Mbps (2040:6502, interface 0, class 0)
Mar 21 09:24:49 telek kernel: [ 1268.313141] em28xx: Audio interface 0 found (Vendor Class)
Mar 21 09:24:49 telek kernel: [ 1268.313143] em28xx: Video interface 0 found: isoc
Mar 21 09:24:49 telek kernel: [ 1268.313144] em28xx: DVB interface 0 found: isoc
Mar 21 09:24:49 telek kernel: [ 1268.313483] em28xx: chip ID is em2882/3
Mar 21 09:24:49 telek kernel: [ 1268.451504] em2882/3 #0: i2c eeprom 00: 1a eb 67 95 40 20 02 65 d0 12 5c 03 82 1e 6a 18
Mar 21 09:24:49 telek kernel: [ 1268.451515] em2882/3 #0: i2c eeprom 10: 00 00 24 57 66 07 01 00 00 00 00 00 00 00 00 00
Mar 21 09:24:49 telek kernel: [ 1268.451523] em2882/3 #0: i2c eeprom 20: 46 00 01 00 f0 10 02 00 b8 00 00 00 5b e0 00 00
Mar 21 09:24:49 telek kernel: [ 1268.451531] em2882/3 #0: i2c eeprom 30: 00 00 20 40 20 6e 02 20 10 01 01 01 00 00 00 00
Mar 21 09:24:49 telek kernel: [ 1268.451539] em2882/3 #0: i2c eeprom 40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
Mar 21 09:24:49 telek kernel: [ 1268.451547] em2882/3 #0: i2c eeprom 50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
Mar 21 09:24:49 telek kernel: [ 1268.451556] em2882/3 #0: i2c eeprom 60: 00 00 00 00 00 00 00 00 00 00 18 03 34 00 30 00
Mar 21 09:24:49 telek kernel: [ 1268.451564] em2882/3 #0: i2c eeprom 70: 32 00 37 00 36 00 37 00 38 00 36 00 33 00 39 00
Mar 21 09:24:49 telek kernel: [ 1268.451572] em2882/3 #0: i2c eeprom 80: 00 00 1e 03 57 00 69 00 6e 00 54 00 56 00 20 00
Mar 21 09:24:49 telek kernel: [ 1268.451580] em2882/3 #0: i2c eeprom 90: 48 00 56 00 52 00 2d 00 39 00 30 00 30 00 00 00
Mar 21 09:24:49 telek kernel: [ 1268.451588] em2882/3 #0: i2c eeprom a0: 84 12 00 00 05 50 1a 7f d4 78 23 fa fd d0 28 89
Mar 21 09:24:49 telek kernel: [ 1268.451596] em2882/3 #0: i2c eeprom b0: ff 00 00 00 04 84 0a 00 01 01 20 77 00 40 af 7f
Mar 21 09:24:49 telek kernel: [ 1268.451605] em2882/3 #0: i2c eeprom c0: 11 f0 74 02 01 00 01 79 0b 00 00 00 00 00 00 00
Mar 21 09:24:49 telek kernel: [ 1268.451613] em2882/3 #0: i2c eeprom d0: 84 12 00 00 05 50 1a 7f d4 78 23 fa fd d0 28 89
Mar 21 09:24:49 telek kernel: [ 1268.451621] em2882/3 #0: i2c eeprom e0: ff 00 00 00 04 84 0a 00 01 01 20 77 00 40 af 7f
Mar 21 09:24:49 telek kernel: [ 1268.451629] em2882/3 #0: i2c eeprom f0: 11 f0 74 02 01 00 01 79 0b 00 00 00 00 00 00 00
Mar 21 09:24:49 telek kernel: [ 1268.451638] em2882/3 #0: EEPROM ID = 1a eb 67 95, EEPROM hash = 0x323f39dd
Mar 21 09:24:49 telek kernel: [ 1268.451640] em2882/3 #0: EEPROM info:
Mar 21 09:24:49 telek kernel: [ 1268.451641] em2882/3 #0:       No audio on board.
Mar 21 09:24:49 telek kernel: [ 1268.451642] em2882/3 #0:       500mA max power
Mar 21 09:24:49 telek kernel: [ 1268.451644] em2882/3 #0:       Table at offset 0x00, strings=0x0000, 0x0000, 0x0000
Mar 21 09:24:49 telek kernel: [ 1268.451645] em2882/3 #0: Identified as Hauppauge WinTV HVR 900 (R2) (card=18)
Mar 21 09:24:49 telek kernel: [ 1268.455336] tveeprom 12-0050: Hauppauge model 65018, rev B2C0, serial# 1146799
Mar 21 09:24:49 telek kernel: [ 1268.455338] tveeprom 12-0050: tuner model is Xceive XC3028 (idx 120, type 71)
Mar 21 09:24:49 telek kernel: [ 1268.455340] tveeprom 12-0050: TV standards PAL(B/G) PAL(I) PAL(D/D1/K) ATSC/DVB Digital (eeprom 0xd4)
Mar 21 09:24:49 telek kernel: [ 1268.455342] tveeprom 12-0050: audio processor is None (idx 0)
Mar 21 09:24:49 telek kernel: [ 1268.455343] tveeprom 12-0050: has radio
Mar 21 09:24:49 telek kernel: [ 1268.511612] tvp5150 12-005c: chip found @ 0xb8 (em2882/3 #0)
Mar 21 09:24:49 telek kernel: [ 1268.511616] tvp5150 12-005c: tvp5150am1 detected.
Mar 21 09:24:49 telek kernel: [ 1268.543048] tuner 12-0061: Tuner -1 found with type(s) Radio TV.
Mar 21 09:24:49 telek kernel: [ 1268.550908] xc2028 12-0061: creating new instance
Mar 21 09:24:49 telek kernel: [ 1268.550911] xc2028 12-0061: type set to XCeive xc2028/xc3028 tuner
Mar 21 09:24:49 telek kernel: [ 1268.551206] xc2028 12-0061: Loading 97 firmware images from xc3028-v27.fw, type: xc2028 firmware, ver 2.7
Mar 21 09:24:49 telek kernel: [ 1268.552265] em2882/3 #0: Config register raw data: 0xd0
Mar 21 09:24:49 telek kernel: [ 1268.553675] em2882/3 #0: AC97 vendor ID = 0xffffffff
Mar 21 09:24:49 telek kernel: [ 1268.554349] em2882/3 #0: AC97 features = 0x6a90
Mar 21 09:24:49 telek kernel: [ 1268.554351] em2882/3 #0: Empia 202 AC97 audio processor detected
Mar 21 09:24:49 telek kernel: [ 1268.739185] em2882/3 #0: v4l2 driver version 0.2.0
Mar 21 09:24:49 telek kernel: [ 1268.773016] xc2028 12-0061: Loading firmware for type=BASE F8MHZ MTS (7), id 0000000000000000.
Mar 21 09:24:51 telek kernel: [ 1270.903855] MTS (4), id 00000000000000ff:
Mar 21 09:24:51 telek kernel: [ 1270.903870] xc2028 12-0061: Loading firmware for type=MTS (4), id 0000000100000007.
Mar 21 09:24:52 telek kernel: [ 1271.252677] em2882/3 #0: V4L2 video device registered as video0
Mar 21 09:24:52 telek kernel: [ 1271.252681] em2882/3 #0: V4L2 VBI device registered as vbi0
Mar 21 09:24:52 telek kernel: [ 1271.253425] em2882/3 #0: analog set to isoc mode.
Mar 21 09:24:52 telek kernel: [ 1271.253427] em2882/3 #0: dvb set to isoc mode.
Mar 21 09:24:52 telek kernel: [ 1271.254699] usbcore: registered new interface driver em28xx
Mar 21 09:24:52 telek kernel: [ 1271.260336] em28xx-audio.c: probing for em28xx Audio Vendor Class
Mar 21 09:24:52 telek kernel: [ 1271.260339] em28xx-audio.c: Copyright (C) 2006 Markus Rechberger
Mar 21 09:24:52 telek kernel: [ 1271.260340] em28xx-audio.c: Copyright (C) 2007-2011 Mauro Carvalho Chehab
Mar 21 09:24:52 telek kernel: [ 1271.263753] xc2028 12-0061: Error on line 1293: -19
Mar 21 09:24:52 telek kernel: [ 1271.267562] Em28xx: Initialized (Em28xx Audio Extension) extension
Mar 21 09:24:52 telek kernel: [ 1271.337649] xc2028 12-0061: attaching existing instance
Mar 21 09:24:52 telek kernel: [ 1271.337653] xc2028 12-0061: type set to XCeive xc2028/xc3028 tuner
Mar 21 09:24:52 telek kernel: [ 1271.337654] em2882/3 #0: em2882/3 #0/2: xc3028 attached
Mar 21 09:24:52 telek kernel: [ 1271.337657] DVB: registering new adapter (em2882/3 #0)
Mar 21 09:24:52 telek kernel: [ 1271.337676] usb 5-2: DVB: registering adapter 0 frontend 0 (Micronas DRXD DVB-T)...
Mar 21 09:24:52 telek kernel: [ 1271.341549] em2882/3 #0: Successfully loaded em28xx-dvb
Mar 21 09:24:52 telek kernel: [ 1271.341553] Em28xx: Initialized (Em28xx dvb Extension) extension
Mar 21 09:24:52 telek kernel: [ 1271.384073] Registered IR keymap rc-hauppauge
Mar 21 09:24:52 telek kernel: [ 1271.385939] input: em28xx IR (em2882/3 #0) as /devices/pci0000:00/0000:00:1c.2/0000:07:00.0/usb5/5-2/rc/rc0/input26
Mar 21 09:24:52 telek kernel: [ 1271.386941] rc0: em28xx IR (em2882/3 #0) as /devices/pci0000:00/0000:00:1c.2/0000:07:00.0/usb5/5-2/rc/rc0
Mar 21 09:24:52 telek kernel: [ 1271.387303] Em28xx: Initialized (Em28xx Input Extension) extension
Mar 21 09:24:54 telek kernel: [ 1273.974437] xc2028 12-0061: i2c input error: rc = -19 (should be 2)
Mar 21 09:24:54 telek kernel: [ 1273.975531] xc2028 12-0061: i2c input error: rc = -19 (should be 2)
Mar 21 09:24:54 telek kernel: [ 1273.997453] xc2028 12-0061: i2c input error: rc = -19 (should be 2)
Mar 21 09:24:54 telek kernel: [ 1273.998584] xc2028 12-0061: i2c input error: rc = -19 (should be 2)
Mar 21 09:24:59 telek kernel: [ 1278.657044] xc2028 12-0061: Loading firmware for type=BASE F8MHZ MTS (7), id 0000000000000000.
Mar 21 09:25:01 telek kernel: [ 1280.764698] MTS (4), id 00000000000000ff:
Mar 21 09:25:01 telek kernel: [ 1280.764713] xc2028 12-0061: Loading firmware for type=MTS (4), id 0000000100000007.


(Note: I've omitted irrelevant call stack traces due to a WARN_ON in vb2_queue)

Regards,

	Hans
