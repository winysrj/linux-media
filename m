Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:62012 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751994Ab3JHIhT (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 8 Oct 2013 04:37:19 -0400
MIME-Version: 1.0
Message-ID: <trinity-623ffc78-64ca-42cb-a0a4-08df812feb4a-1381221437598@msvc021>
From: dezifit@gmx.de
To: linux-media@vger.kernel.org
Subject: em28xx: regression - Hauppauge 65018
Content-Type: multipart/mixed;
 boundary=knika-e2455309-c4e6-4306-8258-0bb03873af01
Date: Tue, 8 Oct 2013 10:37:17 +0200 (CEST)
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--knika-e2455309-c4e6-4306-8258-0bb03873af01
Content-Type: text/plain; charset=UTF-8

Hello,

analog TV of WinTV HVR-900 R2 did work at least until 2.6.35 (yesterday
tested again) and now audio access fails with USB freezes in 3.11.2, see
attached logs, both refering to the very same device.

I already wrote about the USB freeze, which occurs on any access of the
alsa capture card provided by em28xx_alsa.

Any hints about the cause of this regression? I am willing to perform any
suggested code modification or test and would provide more information
if needed.

All feedback welcome.

Regards,
Dieter
--knika-e2455309-c4e6-4306-8258-0bb03873af01
Content-Type: application/octet-stream
Content-Disposition: attachment; filename=syslog-current

Oct  5 10:07:10 dezifit kernel: [38693.651508] usb 3-9: new high-speed USB device number 11 using xhci_hcd
Oct  5 10:07:10 dezifit mtp-probe: checking bus 3, device 11: "/sys/devices/pci0000:00/0000:00:14.0/usb3/3-9"
Oct  5 10:07:10 dezifit mtp-probe: bus: 3, device: 11 was not an MTP device
Oct  5 10:07:10 dezifit kernel: [38693.711072] Linux video capture interface: v2.00
Oct  5 10:07:10 dezifit kernel: [38693.713087] em28xx: New device  WinTV HVR-900 @ 480 Mbps (2040:6502, interface 0, class 0)
Oct  5 10:07:10 dezifit kernel: [38693.713088] em28xx: Audio interface 0 found (Vendor Class)
Oct  5 10:07:10 dezifit kernel: [38693.713089] em28xx: Video interface 0 found: isoc
Oct  5 10:07:10 dezifit kernel: [38693.713090] em28xx: DVB interface 0 found: isoc
Oct  5 10:07:10 dezifit kernel: [38693.713119] em28xx: chip ID is em2882/3
Oct  5 10:07:11 dezifit kernel: [38693.881149] em2882/3 #0: i2c eeprom 00: 1a eb 67 95 40 20 02 65 d0 12 5c 03 82 1e 6a 18
Oct  5 10:07:11 dezifit kernel: [38693.881155] em2882/3 #0: i2c eeprom 10: 00 00 24 57 66 07 01 00 00 00 00 00 00 00 00 00
Oct  5 10:07:11 dezifit kernel: [38693.881161] em2882/3 #0: i2c eeprom 20: 46 00 01 00 f0 10 02 00 b8 00 00 00 5b e0 00 00
Oct  5 10:07:11 dezifit kernel: [38693.881166] em2882/3 #0: i2c eeprom 30: 00 00 20 40 20 6e 02 20 10 01 01 01 00 00 00 00
Oct  5 10:07:11 dezifit kernel: [38693.881171] em2882/3 #0: i2c eeprom 40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
Oct  5 10:07:11 dezifit kernel: [38693.881176] em2882/3 #0: i2c eeprom 50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
Oct  5 10:07:11 dezifit kernel: [38693.881181] em2882/3 #0: i2c eeprom 60: 00 00 00 00 00 00 00 00 00 00 18 03 34 00 30 00
Oct  5 10:07:11 dezifit kernel: [38693.881186] em2882/3 #0: i2c eeprom 70: 32 00 37 00 36 00 36 00 39 00 35 00 38 00 38 00
Oct  5 10:07:11 dezifit kernel: [38693.881191] em2882/3 #0: i2c eeprom 80: 00 00 1e 03 57 00 69 00 6e 00 54 00 56 00 20 00
Oct  5 10:07:11 dezifit kernel: [38693.881196] em2882/3 #0: i2c eeprom 90: 48 00 56 00 52 00 2d 00 39 00 30 00 30 00 00 00
Oct  5 10:07:11 dezifit kernel: [38693.881201] em2882/3 #0: i2c eeprom a0: 84 12 00 00 05 50 1a 7f d4 78 23 fa fd d0 28 89
Oct  5 10:07:11 dezifit kernel: [38693.881206] em2882/3 #0: i2c eeprom b0: ff 00 00 00 04 84 0a 00 01 01 20 77 00 40 54 5c
Oct  5 10:07:11 dezifit kernel: [38693.881211] em2882/3 #0: i2c eeprom c0: 11 f0 74 02 01 00 01 79 89 00 00 00 00 00 00 00
Oct  5 10:07:11 dezifit kernel: [38693.881216] em2882/3 #0: i2c eeprom d0: 84 12 00 00 05 50 1a 7f d4 78 23 fa fd d0 28 89
Oct  5 10:07:11 dezifit kernel: [38693.881221] em2882/3 #0: i2c eeprom e0: ff 00 00 00 04 84 0a 00 01 01 20 77 00 40 54 5c
Oct  5 10:07:11 dezifit kernel: [38693.881226] em2882/3 #0: i2c eeprom f0: 11 f0 74 02 01 00 01 79 89 00 00 00 00 00 00 00
Oct  5 10:07:11 dezifit kernel: [38693.881232] em2882/3 #0: EEPROM ID = 1a eb 67 95, EEPROM hash = 0x6dff3add
Oct  5 10:07:11 dezifit kernel: [38693.881234] em2882/3 #0: EEPROM info:
Oct  5 10:07:11 dezifit kernel: [38693.881234] em2882/3 #0: 	AC97 audio (5 sample rates)
Oct  5 10:07:11 dezifit kernel: [38693.881235] em2882/3 #0: 	500mA max power
Oct  5 10:07:11 dezifit kernel: [38693.881236] em2882/3 #0: 	Table at offset 0x24, strings=0x1e82, 0x186a, 0x0000
Oct  5 10:07:11 dezifit kernel: [38693.881238] em2882/3 #0: Identified as Hauppauge WinTV HVR 900 (R2) (card=18)
Oct  5 10:07:11 dezifit kernel: [38693.882088] tveeprom 9-0050: Hauppauge model 65018, rev B2C0, serial# 1137748
Oct  5 10:07:11 dezifit kernel: [38693.882090] tveeprom 9-0050: tuner model is Xceive XC3028 (idx 120, type 71)
Oct  5 10:07:11 dezifit kernel: [38693.882091] tveeprom 9-0050: TV standards PAL(B/G) PAL(I) PAL(D/D1/K) ATSC/DVB Digital (eeprom 0xd4)
Oct  5 10:07:11 dezifit kernel: [38693.882093] tveeprom 9-0050: audio processor is None (idx 0)
Oct  5 10:07:11 dezifit kernel: [38693.882094] tveeprom 9-0050: has radio
Oct  5 10:07:11 dezifit kernel: [38693.948109] tvp5150 9-005c: chip found @ 0xb8 (em2882/3 #0)
Oct  5 10:07:11 dezifit kernel: [38693.948117] tvp5150 9-005c: tvp5150am1 detected.
Oct  5 10:07:11 dezifit kernel: [38693.971880] tuner 9-0061: Tuner -1 found with type(s) Radio TV.
Oct  5 10:07:11 dezifit kernel: [38693.975175] xc2028 9-0061: creating new instance
Oct  5 10:07:11 dezifit kernel: [38693.975183] xc2028 9-0061: type set to XCeive xc2028/xc3028 tuner
Oct  5 10:07:11 dezifit kernel: [38693.975369] em2882/3 #0: Config register raw data: 0xd0
Oct  5 10:07:11 dezifit kernel: [38693.975602] em2882/3 #0: AC97 vendor ID = 0x4f39ffff
Oct  5 10:07:11 dezifit kernel: [38693.975794] em2882/3 #0: AC97 features = 0x6a90
Oct  5 10:07:11 dezifit kernel: [38693.975800] em2882/3 #0: Unknown AC97 audio processor detected!
Oct  5 10:07:11 dezifit kernel: [38693.975898] xc2028 9-0061: Loading 80 firmware images from xc3028-v27.fw, type: xc2028 firmware, ver 2.7
Oct  5 10:07:11 dezifit kernel: [38694.124644] em2882/3 #0: v4l2 driver version 0.2.0
Oct  5 10:07:11 dezifit kernel: [38694.171872] xc2028 9-0061: Loading firmware for type=BASE F8MHZ MTS (7), id 0000000000000000.
Oct  5 10:07:12 dezifit kernel: [38695.086017] MTS (4), id 00000000000000ff:
Oct  5 10:07:12 dezifit kernel: [38695.086029] xc2028 9-0061: Loading firmware for type=MTS (4), id 0000000100000007.
Oct  5 10:07:12 dezifit kernel: [38695.418759] em2882/3 #0: V4L2 video device registered as video0
Oct  5 10:07:12 dezifit kernel: [38695.418767] em2882/3 #0: V4L2 VBI device registered as vbi0
Oct  5 10:07:12 dezifit kernel: [38695.419267] em2882/3 #0: analog set to isoc mode.
Oct  5 10:07:12 dezifit kernel: [38695.419270] em2882/3 #0: dvb set to isoc mode.
Oct  5 10:07:12 dezifit kernel: [38695.419541] usbcore: registered new interface driver em28xx
Oct  5 10:07:12 dezifit kernel: [38695.424291] em28xx-audio.c: probing for em28xx Audio Vendor Class
Oct  5 10:07:12 dezifit kernel: [38695.424298] em28xx-audio.c: Copyright (C) 2006 Markus Rechberger
Oct  5 10:07:12 dezifit kernel: [38695.424302] em28xx-audio.c: Copyright (C) 2007-2011 Mauro Carvalho Chehab
Oct  5 10:07:12 dezifit kernel: [38695.425879] Em28xx: Initialized (Em28xx Audio Extension) extension
Oct  5 10:07:12 dezifit kernel: [38695.456893] Registered IR keymap rc-hauppauge
Oct  5 10:07:12 dezifit kernel: [38695.456968] input: em28xx IR (em2882/3 #0) as /devices/pci0000:00/0000:00:14.0/usb3/3-9/rc/rc0/input24
Oct  5 10:07:12 dezifit kernel: [38695.457035] rc0: em28xx IR (em2882/3 #0) as /devices/pci0000:00/0000:00:14.0/usb3/3-9/rc/rc0
Oct  5 10:07:12 dezifit kernel: [38695.457149] Em28xx: Initialized (Em28xx Input Extension) extension
Oct  5 10:07:12 dezifit kernel: [38695.554260] xc2028 9-0061: Error on line 1293: -19
Oct  5 10:07:12 dezifit kernel: [38695.606852] tvp5150 9-005c: i2c i/o error: rc == -19 (should be 2)
Oct  5 10:07:12 dezifit kernel: [38695.774411] xc2028 9-0061: Error on line 1293: -19
Oct  5 10:07:13 dezifit rtkit-daemon[2590]: Successfully made thread 28186 of process 2587 (n/a) owned by '1000' RT at priority 5.
Oct  5 10:07:13 dezifit rtkit-daemon[2590]: Supervising 9 threads of 3 processes of 1 users.


--knika-e2455309-c4e6-4306-8258-0bb03873af01
Content-Type: application/octet-stream
Content-Disposition: attachment; filename=syslog-2.6.35

Oct  7 19:50:24 localhost kernel: [ 5161.312276] usb 1-2: new high speed USB device using ehci_hcd and address 2
Oct  7 19:50:24 localhost kernel: [ 5161.449864] usb 1-2: configuration #1 chosen from 1 choice
Oct  7 19:50:24 localhost kernel: [ 5161.710155] Linux video capture interface: v2.00
Oct  7 19:50:24 localhost kernel: [ 5161.759574] em28xx: New device WinTV HVR-900 @ 480 Mbps (2040:6502, interface 0, class 0)
Oct  7 19:50:24 localhost kernel: [ 5161.759676] em28xx #0: chip ID is em2882/em2883
Oct  7 19:50:24 localhost kernel: [ 5161.937042] em28xx #0: i2c eeprom 00: 1a eb 67 95 40 20 02 65 d0 12 5c 03 82 1e 6a 18
Oct  7 19:50:24 localhost kernel: [ 5161.937078] em28xx #0: i2c eeprom 10: 00 00 24 57 66 07 01 00 00 00 00 00 00 00 00 00
Oct  7 19:50:24 localhost kernel: [ 5161.937110] em28xx #0: i2c eeprom 20: 46 00 01 00 f0 10 02 00 b8 00 00 00 5b e0 00 00
Oct  7 19:50:24 localhost kernel: [ 5161.937141] em28xx #0: i2c eeprom 30: 00 00 20 40 20 6e 02 20 10 01 01 01 00 00 00 00
Oct  7 19:50:24 localhost kernel: [ 5161.937173] em28xx #0: i2c eeprom 40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
Oct  7 19:50:24 localhost kernel: [ 5161.937204] em28xx #0: i2c eeprom 50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
Oct  7 19:50:24 localhost kernel: [ 5161.937235] em28xx #0: i2c eeprom 60: 00 00 00 00 00 00 00 00 00 00 18 03 34 00 30 00
Oct  7 19:50:24 localhost kernel: [ 5161.937266] em28xx #0: i2c eeprom 70: 32 00 37 00 36 00 36 00 39 00 35 00 38 00 38 00
Oct  7 19:50:24 localhost kernel: [ 5161.937298] em28xx #0: i2c eeprom 80: 00 00 1e 03 57 00 69 00 6e 00 54 00 56 00 20 00
Oct  7 19:50:24 localhost kernel: [ 5161.937329] em28xx #0: i2c eeprom 90: 48 00 56 00 52 00 2d 00 39 00 30 00 30 00 00 00
Oct  7 19:50:24 localhost kernel: [ 5161.937360] em28xx #0: i2c eeprom a0: 84 12 00 00 05 50 1a 7f d4 78 23 fa fd d0 28 89
Oct  7 19:50:24 localhost kernel: [ 5161.937392] em28xx #0: i2c eeprom b0: ff 00 00 00 04 84 0a 00 01 01 20 77 00 40 54 5c
Oct  7 19:50:24 localhost kernel: [ 5161.937424] em28xx #0: i2c eeprom c0: 11 f0 74 02 01 00 01 79 89 00 00 00 00 00 00 00
Oct  7 19:50:24 localhost kernel: [ 5161.937455] em28xx #0: i2c eeprom d0: 84 12 00 00 05 50 1a 7f d4 78 23 fa fd d0 28 89
Oct  7 19:50:24 localhost kernel: [ 5161.937487] em28xx #0: i2c eeprom e0: ff 00 00 00 04 84 0a 00 01 01 20 77 00 40 54 5c
Oct  7 19:50:24 localhost kernel: [ 5161.937518] em28xx #0: i2c eeprom f0: 11 f0 74 02 01 00 01 79 89 00 00 00 00 00 00 00
Oct  7 19:50:24 localhost kernel: [ 5161.937555] em28xx #0: EEPROM ID= 0x9567eb1a, EEPROM hash = 0x6dff3add
Oct  7 19:50:24 localhost kernel: [ 5161.937562] em28xx #0: EEPROM info:
Oct  7 19:50:24 localhost kernel: [ 5161.937567] em28xx #0:	AC97 audio (5 sample rates)
Oct  7 19:50:24 localhost kernel: [ 5161.937573] em28xx #0:	500mA max power
Oct  7 19:50:24 localhost kernel: [ 5161.937581] em28xx #0:	Table at 0x24, strings=0x1e82, 0x186a, 0x0000
Oct  7 19:50:24 localhost kernel: [ 5161.938273] em28xx #0: Identified as Hauppauge WinTV HVR 900 (R2) (card=18)
Oct  7 19:50:24 localhost kernel: [ 5161.957804] tveeprom 1-0050: Hauppauge model 65018, rev B2C0, serial# 1137748
Oct  7 19:50:24 localhost kernel: [ 5161.957809] tveeprom 1-0050: tuner model is Xceive XC3028 (idx 120, type 71)
Oct  7 19:50:24 localhost kernel: [ 5161.957814] tveeprom 1-0050: TV standards PAL(B/G) PAL(I) PAL(D/D1/K) ATSC/DVB Digital (eeprom 0xd4)
Oct  7 19:50:24 localhost kernel: [ 5161.957818] tveeprom 1-0050: audio processor is None (idx 0)
Oct  7 19:50:24 localhost kernel: [ 5161.957821] tveeprom 1-0050: has radio
Oct  7 19:50:24 localhost kernel: [ 5161.966473] tvp5150 1-005c: chip found @ 0xb8 (em28xx #0)
Oct  7 19:50:24 localhost kernel: [ 5161.997352] tuner 1-0061: chip found @ 0xc2 (em28xx #0)
Oct  7 19:50:24 localhost kernel: [ 5162.033151] xc2028 1-0061: creating new instance
Oct  7 19:50:24 localhost kernel: [ 5162.033159] xc2028 1-0061: type set to XCeive xc2028/xc3028 tuner
Oct  7 19:50:24 localhost kernel: [ 5162.033176] usb 1-2: firmware: requesting xc3028-v27.fw
Oct  7 19:50:24 localhost kernel: [ 5162.108766] xc2028 1-0061: Error: firmware xc3028-v27.fw not found.
Oct  7 19:50:24 localhost kernel: [ 5162.108974] input: em28xx IR (em28xx #0) as /devices/pci0000:00/0000:00:1d.7/usb1/1-2/input/input8
Oct  7 19:50:24 localhost kernel: [ 5162.110477] em28xx #0: Config register raw data: 0xd0
Oct  7 19:50:24 localhost kernel: [ 5162.113628] em28xx #0: AC97 vendor ID = 0xffffffff
Oct  7 19:50:24 localhost kernel: [ 5162.113991] em28xx #0: AC97 features = 0x6a90
Oct  7 19:50:24 localhost kernel: [ 5162.113998] em28xx #0: Empia 202 AC97 audio processor detected
Oct  7 19:50:25 localhost kernel: [ 5162.252479] tvp5150 1-005c: tvp5150am1 detected.
Oct  7 19:50:25 localhost kernel: [ 5162.364815] em28xx #0: v4l2 driver version 0.1.2
Oct  7 19:50:25 localhost kernel: [ 5162.451526] em28xx #0: V4L2 video device registered as /dev/video0
Oct  7 19:50:25 localhost kernel: [ 5162.451535] em28xx #0: V4L2 VBI device registered as /dev/vbi0
Oct  7 19:50:25 localhost kernel: [ 5162.468101] usbcore: registered new interface driver em28xx
Oct  7 19:50:25 localhost kernel: [ 5162.468111] em28xx driver loaded
Oct  7 19:50:25 localhost kernel: [ 5162.562435] em28xx-audio.c: probing for em28x1 non standard usbaudio
Oct  7 19:50:25 localhost kernel: [ 5162.562445] em28xx-audio.c: Copyright (C) 2006 Markus Rechberger
Oct  7 19:50:25 localhost kernel: [ 5162.576736] Em28xx: Initialized (Em28xx Audio Extension) extension
Oct  7 19:50:25 localhost kernel: [ 5162.608650] tvp5150 1-005c: tvp5150am1 detected.
Oct  7 19:50:25 localhost kernel: [ 5162.908472] tvp5150 1-005c: tvp5150am1 detected.


--knika-e2455309-c4e6-4306-8258-0bb03873af01--
