Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f45.google.com ([74.125.83.45]:38289 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754706AbaA1PNN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 28 Jan 2014 10:13:13 -0500
Received: by mail-ee0-f45.google.com with SMTP id b15so299511eek.4
        for <linux-media@vger.kernel.org>; Tue, 28 Jan 2014 07:13:12 -0800 (PST)
Subject: Hm, seems I got me a "msg08693 (2009)" situation, smelly (hot)
 dvb-t electronics
From: mjs <mjstork@gmail.com>
Reply-To: mjstork@gmail.com
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 28 Jan 2014 16:13:20 +0100
Message-ID: <1390922000.2211.57.camel@fujitsu>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

I'm trying to get a :zolid dvb-t stick to work but at this stage I got
the alarming smell, "tuning failed" and "tuning status == 0x04"
(500 to 1000 Khz beside the wanted frequency the tuning status shows: ==
0x06)

Debug zl10353 and tuner-xc2028 (using a scan) shows me no info which I
could use to tackle this problem (see below)

For sure I could use info about gpio settings (in respect to the
hardware) what they control, the desired value and correct sequence

Tips and/or directions how to tackle this problem are welcome

Greatings,
    Marcel Stork (netherlands)


Hardware:
xc3028L, wjce6353, tvp5150 and em2882

dmesg:
[  463.120045] usb 1-3: new high speed USB device using ehci_hcd and
address 3
[  463.257112] usb 1-3: New USB device found, idVendor=eb1a,
idProduct=2883
[  463.257123] usb 1-3: New USB device strings: Mfr=0, Product=1,
SerialNumber=2
[  463.257132] usb 1-3: Product: USB 2883 Device
[  463.257139] usb 1-3: SerialNumber: 200804
[  463.258956] usb 1-3: configuration #1 chosen from 1 choice
[  463.259217] em28xx: New device USB 2883 Device @ 480 Mbps (eb1a:2883,
interface 0, class 0)
[  463.259357] em28xx #0: chip ID is em2882/em2883
[  463.412859] em28xx #0: i2c eeprom 00: 1a eb 67 95 1a eb 83 28 d0 12
65 00 6a 22 8c 10
[  463.412893] em28xx #0: i2c eeprom 10: 00 00 24 57 4e 37 01 00 60 00
00 00 02 00 00 00
[  463.412923] em28xx #0: i2c eeprom 20: 5e 00 01 00 f0 10 01 00 b8 00
00 00 5b 1e 00 00
[  463.412953] em28xx #0: i2c eeprom 30: 00 00 20 40 20 6e 04 20 01 01
00 00 00 00 00 00
[  463.412983] em28xx #0: i2c eeprom 40: 00 00 00 00 00 00 00 00 00 00
00 00 d3 c4 00 00
[  463.413013] em28xx #0: i2c eeprom 50: 00 a2 b2 87 81 80 00 00 00 00
00 00 00 00 00 00
[  463.413043] em28xx #0: i2c eeprom 60: 00 00 00 00 00 00 00 00 00 00
22 03 55 00 53 00
[  463.413073] em28xx #0: i2c eeprom 70: 42 00 20 00 32 00 38 00 38 00
33 00 20 00 44 00
[  463.413102] em28xx #0: i2c eeprom 80: 65 00 76 00 69 00 63 00 65 00
00 00 10 03 32 00
[  463.413132] em28xx #0: i2c eeprom 90: 30 00 30 00 38 00 30 00 34 00
00 00 00 00 00 00
[  463.413162] em28xx #0: i2c eeprom a0: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[  463.413192] em28xx #0: i2c eeprom b0: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[  463.413221] em28xx #0: i2c eeprom c0: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[  463.413250] em28xx #0: i2c eeprom d0: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[  463.413280] em28xx #0: i2c eeprom e0: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[  463.413309] em28xx #0: i2c eeprom f0: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[  463.413344] em28xx #0: EEPROM ID= 0x9567eb1a, EEPROM hash =
0x85dd871e
[  463.413352] em28xx #0: EEPROM info:
[  463.413357] em28xx #0: AC97 audio (5 sample rates)
[  463.413364] em28xx #0: 500mA max power
[  463.413371] em28xx #0: Table at 0x24, strings=0x226a, 0x108c, 0x0000
[  463.414106] em28xx #0: Identified as :ZOLID Hybrid TV Stick (card=74)
[  463.419807] tvp5150 3-005c: chip found @ 0xb8 (em28xx #0)
[  463.425429] tuner 3-0061: chip found @ 0xc2 (em28xx #0)
[  463.425708] xc2028: Xcv2028/3028 init called!
[  463.425717] xc2028 3-0061: creating new instance
[  463.425725] xc2028 3-0061: type set to XCeive xc2028/xc3028 tuner
[  463.425736] xc2028 3-0061: xc2028_set_config called
[  463.425747] xc2028 3-0061: xc2028_set_analog_freq called
[  463.425757] xc2028 3-0061: generic_set_freq called
[  463.425765] xc2028 3-0061: should set frequency 567250 kHz
[  463.425773] xc2028 3-0061: check_firmware called
[  463.425781] xc2028 3-0061: load_all_firmwares called
[  463.425789] xc2028 3-0061: Reading firmware xc3028L-v36.fw
[  463.425799] usb 1-3: firmware: requesting xc3028L-v36.fw
[  463.433292] xc2028 3-0061: Loading 81 firmware images from
xc3028L-v36.fw, type: xc2028 firmware, ver 3.6
[  463.433319] xc2028 3-0061: Reading firmware type BASE F8MHZ (3), id
0, size=9144.
[  463.433357] xc2028 3-0061: Reading firmware type BASE F8MHZ MTS (7),
id 0, size=9030.
[  463.433395] xc2028 3-0061: Reading firmware type BASE FM (401), id 0,
size=9054.
[  463.433433] xc2028 3-0061: Reading firmware type BASE FM INPUT1
(c01), id 0, size=9068.
[  463.433463] xc2028 3-0061: Reading firmware type BASE (1), id 0,
size=9132.
[  463.433498] xc2028 3-0061: Reading firmware type BASE MTS (5), id 0,
size=9006.
[  463.433517] xc2028 3-0061: Reading firmware type (0), id 7, size=161.
[  463.433530] xc2028 3-0061: Reading firmware type MTS (4), id 7,
size=169.
[  463.433544] xc2028 3-0061: Reading firmware type (0), id 7, size=161.
[  463.433556] xc2028 3-0061: Reading firmware type MTS (4), id 7,
size=169.
[  463.433569] xc2028 3-0061: Reading firmware type (0), id 7, size=161.
[  463.433581] xc2028 3-0061: Reading firmware type MTS (4), id 7,
size=169.
[  463.433594] xc2028 3-0061: Reading firmware type (0), id 7, size=161.
[  463.433606] xc2028 3-0061: Reading firmware type MTS (4), id 7,
size=169.
[  463.433619] xc2028 3-0061: Reading firmware type (0), id e0,
size=161.
[  463.433631] xc2028 3-0061: Reading firmware type MTS (4), id e0,
size=169.
[  463.433644] xc2028 3-0061: Reading firmware type (0), id e0,
size=161.
[  463.433656] xc2028 3-0061: Reading firmware type MTS (4), id e0,
size=169.
[  463.433669] xc2028 3-0061: Reading firmware type (0), id 200000,
size=161.
[  463.433682] xc2028 3-0061: Reading firmware type MTS (4), id 200000,
size=169.
[  463.433695] xc2028 3-0061: Reading firmware type (0), id 4000000,
size=161.
[  463.433708] xc2028 3-0061: Reading firmware type MTS (4), id 4000000,
size=169.
[  463.433722] xc2028 3-0061: Reading firmware type D2633 DTV6 ATSC
(10030), id 0, size=149.
[  463.433739] xc2028 3-0061: Reading firmware type D2620 DTV6 QAM (68),
id 0, size=149.
[  463.433755] xc2028 3-0061: Reading firmware type D2633 DTV6 QAM (70),
id 0, size=149.
[  463.433771] xc2028 3-0061: Reading firmware type D2620 DTV7 (88), id
0, size=149.
[  463.433786] xc2028 3-0061: Reading firmware type D2633 DTV7 (90), id
0, size=149.
[  463.433801] xc2028 3-0061: Reading firmware type D2620 DTV78 (108),
id 0, size=149.
[  463.433816] xc2028 3-0061: Reading firmware type D2633 DTV78 (110),
id 0, size=149.
[  463.433831] xc2028 3-0061: Reading firmware type D2620 DTV8 (208), id
0, size=149.
[  463.433846] xc2028 3-0061: Reading firmware type D2633 DTV8 (210), id
0, size=149.
[  463.433860] xc2028 3-0061: Reading firmware type FM (400), id 0,
size=135.
[  463.433874] xc2028 3-0061: Reading firmware type (0), id 10,
size=161.
[  463.433886] xc2028 3-0061: Reading firmware type MTS (4), id 10,
size=169.
[  463.433899] xc2028 3-0061: Reading firmware type (0), id 400000,
size=161.
[  463.433912] xc2028 3-0061: Reading firmware type (0), id 800000,
size=161.
[  463.433924] xc2028 3-0061: Reading firmware type (0), id 8000,
size=161.
[  463.433936] xc2028 3-0061: Reading firmware type LCD (1000), id 8000,
size=161.
[  463.433950] xc2028 3-0061: Reading firmware type LCD NOGD (3000), id
8000, size=161.
[  463.433965] xc2028 3-0061: Reading firmware type MTS (4), id 8000,
size=169.
[  463.433978] xc2028 3-0061: Reading firmware type (0), id b700,
size=161.
[  463.433990] xc2028 3-0061: Reading firmware type LCD (1000), id b700,
size=161.
[  463.434004] xc2028 3-0061: Reading firmware type LCD NOGD (3000), id
b700, size=161.
[  463.434019] xc2028 3-0061: Reading firmware type (0), id 2000,
size=161.
[  463.434031] xc2028 3-0061: Reading firmware type MTS (4), id b700,
size=169.
[  463.434044] xc2028 3-0061: Reading firmware type MTS LCD (1004), id
b700, size=169.
[  463.434059] xc2028 3-0061: Reading firmware type MTS LCD NOGD (3004),
id b700, size=169.
[  463.434075] xc2028 3-0061: Reading firmware type SCODE HAS_IF_3280
(60000000), id 0, size=192.
[  463.434092] xc2028 3-0061: Reading firmware type SCODE HAS_IF_3300
(60000000), id 0, size=192.
[  463.434108] xc2028 3-0061: Reading firmware type SCODE HAS_IF_3440
(60000000), id 0, size=192.
[  463.434124] xc2028 3-0061: Reading firmware type SCODE HAS_IF_3460
(60000000), id 0, size=192.
[  463.434140] xc2028 3-0061: Reading firmware type DTV6 ATSC OREN36
SCODE HAS_IF_3800 (60210020), id 0, size=192.
[  463.434160] xc2028 3-0061: Reading firmware type SCODE HAS_IF_4000
(60000000), id 0, size=192.
[  463.434176] xc2028 3-0061: Reading firmware type DTV6 ATSC TOYOTA388
SCODE HAS_IF_4080 (60410020), id 0, size=192.
[  463.434197] xc2028 3-0061: Reading firmware type SCODE HAS_IF_4200
(60000000), id 0, size=192.
[  463.434213] xc2028 3-0061: Reading firmware type MONO SCODE
HAS_IF_4320 (60008000), id 8000, size=192.
[  463.434231] xc2028 3-0061: Reading firmware type SCODE HAS_IF_4450
(60000000), id 0, size=192.
[  463.434247] xc2028 3-0061: Reading firmware type MTS LCD NOGD MONO IF
SCODE HAS_IF_4500 (6002b004), id b700, size=192.
[  463.434270] xc2028 3-0061: Reading firmware type DTV78 DTV8
ZARLINK456 SCODE HAS_IF_4560 (62000300), id 0, size=192.
[  463.434290] xc2028 3-0061: Reading firmware type LCD NOGD IF SCODE
HAS_IF_4600 (60023000), id 8000, size=192.
[  463.434310] xc2028 3-0061: Reading firmware type DTV6 QAM DTV7
ZARLINK456 SCODE HAS_IF_4760 (620000e0), id 0, size=192.
[  463.434332] xc2028 3-0061: Reading firmware type SCODE HAS_IF_4940
(60000000), id 0, size=192.
[  463.434348] xc2028 3-0061: Reading firmware type DTV78 DTV8 DIBCOM52
SCODE HAS_IF_5200 (61000300), id 0, size=192.
[  463.434369] xc2028 3-0061: Reading firmware type SCODE HAS_IF_5260
(60000000), id 0, size=192.
[  463.434385] xc2028 3-0061: Reading firmware type MONO SCODE
HAS_IF_5320 (60008000), id 7, size=192.
[  463.434403] xc2028 3-0061: Reading firmware type DTV7 DTV8 DIBCOM52
CHINA SCODE HAS_IF_5400 (65000280), id 0, size=192.
[  463.434424] xc2028 3-0061: Reading firmware type DTV6 ATSC OREN538
SCODE HAS_IF_5580 (60110020), id 0, size=192.
[  463.434445] xc2028 3-0061: Reading firmware type SCODE HAS_IF_5640
(60000000), id 7, size=192.
[  463.434461] xc2028 3-0061: Reading firmware type SCODE HAS_IF_5740
(60000000), id 7, size=192.
[  463.434477] xc2028 3-0061: Reading firmware type SCODE HAS_IF_5900
(60000000), id 0, size=192.
[  463.434493] xc2028 3-0061: Reading firmware type MONO SCODE
HAS_IF_6000 (60008000), id 4c000f0, size=192.
[  463.434511] xc2028 3-0061: Reading firmware type DTV6 QAM ATSC LG60
F6MHZ SCODE HAS_IF_6200 (68050060), id 0, size=192.
[  463.434536] xc2028 3-0061: Reading firmware type SCODE HAS_IF_6240
(60000000), id 10, size=192.
[  463.434552] xc2028 3-0061: Reading firmware type MONO SCODE
HAS_IF_6320 (60008000), id 200000, size=192.
[  463.434570] xc2028 3-0061: Reading firmware type SCODE HAS_IF_6340
(60000000), id 200000, size=192.
[  463.434586] xc2028 3-0061: Reading firmware type MONO SCODE
HAS_IF_6500 (60008000), id 40000e0, size=192.
[  463.434604] xc2028 3-0061: Reading firmware type DTV6 ATSC ATI638
SCODE HAS_IF_6580 (60090020), id 0, size=192.
[  463.434624] xc2028 3-0061: Reading firmware type SCODE HAS_IF_6600
(60000000), id e0, size=192.
[  463.434641] xc2028 3-0061: Reading firmware type MONO SCODE
HAS_IF_6680 (60008000), id e0, size=192.
[  463.434658] xc2028 3-0061: Reading firmware type DTV6 ATSC TOYOTA794
SCODE HAS_IF_8140 (60810020), id 0, size=192.
[  463.434678] xc2028 3-0061: Reading firmware type SCODE HAS_IF_8200
(60000000), id 0, size=192.
[  463.434713] xc2028 3-0061: Firmware files loaded.
[  463.434721] xc2028 3-0061: checking firmware, user requested type=MTS
(4), id 000000000000b700, scode_tbl (0), scode_nr 0
[  463.480033] xc2028 3-0061: load_firmware called
[  463.480043] xc2028 3-0061: seek_firmware called, want type=BASE MTS
(5), id 0000000000000000.
[  463.480059] xc2028 3-0061: Found firmware for type=BASE MTS (5), id
0000000000000000.
[  463.480073] xc2028 3-0061: Loading firmware for type=BASE MTS (5), id
0000000000000000.
[  464.389269] xc2028 3-0061: Load init1 firmware, if exists
[  464.389280] xc2028 3-0061: load_firmware called
[  464.389288] xc2028 3-0061: seek_firmware called, want type=BASE INIT1
MTS (4005), id 0000000000000000.
[  464.389308] xc2028 3-0061: Can't find firmware for type=BASE INIT1
MTS (4005), id 0000000000000000.
[  464.389324] xc2028 3-0061: load_firmware called
[  464.389332] xc2028 3-0061: seek_firmware called, want type=BASE INIT1
MTS (4005), id 0000000000000000.
[  464.389349] xc2028 3-0061: Can't find firmware for type=BASE INIT1
MTS (4005), id 0000000000000000.
[  464.389365] xc2028 3-0061: load_firmware called
[  464.389373] xc2028 3-0061: seek_firmware called, want type=MTS (4),
id 000000000000b700.
[  464.389387] xc2028 3-0061: Found firmware for type=MTS (4), id
000000000000b700.
[  464.389399] xc2028 3-0061: Loading firmware for type=MTS (4), id
000000000000b700.
[  464.404519] xc2028 3-0061: Trying to load scode 0
[  464.404528] xc2028 3-0061: load_scode called
[  464.404536] xc2028 3-0061: seek_firmware called, want type=MTS SCODE
(20000004), id 000000000000b700.
[  464.404552] xc2028 3-0061: Found firmware for type=MTS SCODE
(20000004), id 000000000000b700.
[  464.404567] xc2028 3-0061: Loading SCODE for type=MTS LCD NOGD MONO
IF SCODE HAS_IF_4500 (6002b004), id 000000000000b700.
[  464.436032] xc2028 3-0061: xc2028_get_reg 0004 called
[  464.436890] xc2028 3-0061: xc2028_get_reg 0008 called
[  464.437765] xc2028 3-0061: Device is Xceive 3028 version 2.0,
firmware version 3.6
[  464.588035] xc2028 3-0061: divisor= 00 00 8d d0 (freq=567.250)
[  464.588146] em28xx #0: Config register raw data: 0xd0
[  464.588893] em28xx #0: AC97 vendor ID = 0xffffffff
[  464.589267] em28xx #0: AC97 features = 0x6a90
[  464.589274] em28xx #0: Empia 202 AC97 audio processor detected
[  464.700527] tvp5150 3-005c: tvp5150am1 detected.
[  464.796906] em28xx #0: v4l2 driver version 0.1.2
[  464.867709] em28xx #0: V4L2 video device registered as /dev/video0
[  464.867717] em28xx #0: V4L2 VBI device registered as /dev/vbi0
[  464.867725] em28xx-audio.c: probing for em28x1 non standard usbaudio
[  464.867731] em28xx-audio.c: Copyright (C) 2006 Markus Rechberger
[  465.017164] xc2028: Xcv2028/3028 init called!
[  465.017175] xc2028 3-0061: attaching existing instance
[  465.017184] xc2028 3-0061: type set to XCeive xc2028/xc3028 tuner
[  465.017192] em28xx #0/2: xc3028 attached
[  465.017199] DVB: registering new adapter (em28xx #0)
[  465.017213] DVB: registering adapter 0 frontend 0 (Zarlink ZL10353
DVB-T)...
[  465.018451] Successfully loaded em28xx-dvb
[  465.018463] xc2028 3-0061: Putting xc2028/3028 into poweroff mode.

Start scan single local in use frequentie (546 Mc)

[  474.744116] 00: 00 00 48 00 00 00 00 60 00 00 00 00 00 00 00 00
[  474.754099] 10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[  474.764229] 20: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[  474.774224] 30: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[  474.784354] 40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[  474.794474] 50: 0c 44 46 15 0f 00 00 00 00 00 48 00 75 0d 0d 0d
[  474.804480] 60: 00 4d 0a 0f 0f 0f 0f c2 00 00 80 00 00 00 00 00
[  474.814475] 70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 14
[  474.824481] 80: 14 14 14 14 14 14 14 14 14 14 14 14 14 14 14 14
[  474.834476] 90: 14 14 14 14 14 14 14 14 14 14 14 14 14 14 14 14
[  474.844482] a0: 14 14 14 14 14 14 14 14 14 14 14 14 14 14 14 14
[  474.854477] b0: 14 14 14 14 14 14 14 14 14 14 14 14 14 14 14 14
[  474.864482] c0: 14 14 14 14 14 14 14 14 14 14 14 14 14 14 14 14
[  474.874477] d0: 14 14 14 14 14 14 14 14 14 14 10 40 20 03 46 34
[  474.884483] e0: 47 1c 00 00 00 30 00 40 10 00 00 80 00 00 00 00
[  474.894478] f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[  474.906975] 00: 00 00 00 00 00 00 00 00 00 00 20 00 80 00 00 31
[  474.916979] 10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 40
[  474.927104] 20: 80 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[  474.937105] 30: 00 00 06 3c 00 00 00 00 00 00 00 00 00 00 00 00
[  474.947230] 40: 00 10 7f 00 00 00 00 00 00 00 00 00 00 00 00 00
[  474.957355] 50: 03 44 46 15 0f 00 31 62 00 00 48 00 75 0d 43 11
[  474.967480] 60: 00 4d 0a 0f 36 67 e5 c2 00 00 80 00 cd 7e 40 80
[  474.978142] 70: 00 00 00 00 00 00 00 10 00 00 00 00 29 18 46 14
[  474.990857] 80: 18 09 64 52 f1 03 3b 00 20 43 12 2b 31 7d 40 00
[  475.000982] 90: 00 00 ff 00 00 3f 00 2f f5 21 00 00 a0 a5 42 14
[  475.011107] a0: 6c 15 54 43 32 22 99 41 90 b3 50 61 60 00 00 00
[  475.021108] b0: 00 80 20 80 80 55 62 07 0a c8 ff 46 24 a3 00 14
[  475.031108] c0: 8d 48 30 00 93 93 10 00 00 28 44 24 73 54 14 61
[  475.041108] d0: 10 00 18 00 20 00 ff 7a 80 14 10 40 20 03 46 34
[  475.051108] e0: 47 1c 00 00 00 30 00 40 10 00 00 80 00 00 00 00
[  475.061109] f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ff ff
[  475.108491] zl10353: zl10353_calc_nominal_rate: bw 8, adc_clock
450560 => 0x67e5
[  475.109237] zl10353: zl10353_calc_input_freq: if2 361667, ife 88893,
adc_clock 450560 => -12930 / 0xcd7e
[  475.111110] xc2028 3-0061: xc2028_set_params called
[  475.111120] xc2028 3-0061: generic_set_freq called
[  475.111128] xc2028 3-0061: should set frequency 546000 kHz
[  475.111136] xc2028 3-0061: check_firmware called
[  475.111144] xc2028 3-0061: checking firmware, user requested
type=F8MHZ MTS D2620 DTV8 (20e), id 0000000000000000, scode_tbl (0),
scode_nr 0
[  475.168034] xc2028 3-0061: load_firmware called
[  475.168044] xc2028 3-0061: seek_firmware called, want type=BASE F8MHZ
MTS D2620 DTV8 (20f), id 0000000000000000.
[  475.168066] xc2028 3-0061: Found firmware for type=BASE F8MHZ MTS
(7), id 0000000000000000.
[  475.168081] xc2028 3-0061: Loading firmware for type=BASE F8MHZ MTS
(7), id 0000000000000000.
[  476.089273] xc2028 3-0061: Load init1 firmware, if exists
[  476.089283] xc2028 3-0061: load_firmware called
[  476.089291] xc2028 3-0061: seek_firmware called, want type=BASE INIT1
F8MHZ MTS D2620 DTV8 (420f), id 0000000000000000.
[  476.089315] xc2028 3-0061: Can't find firmware for type=BASE INIT1
F8MHZ MTS (4007), id 0000000000000000.
[  476.089332] xc2028 3-0061: load_firmware called
[  476.089340] xc2028 3-0061: seek_firmware called, want type=BASE INIT1
MTS D2620 DTV8 (420d), id 0000000000000000.
[  476.089360] xc2028 3-0061: Can't find firmware for type=BASE INIT1
MTS (4005), id 0000000000000000.
[  476.089376] xc2028 3-0061: load_firmware called
[  476.089383] xc2028 3-0061: seek_firmware called, want type=F8MHZ MTS
D2620 DTV8 (20e), id 0000000000000000.
[  476.089401] xc2028 3-0061: Found firmware for type=D2620 DTV8 (208),
id 0000000000000000.
[  476.089414] xc2028 3-0061: Loading firmware for type=D2620 DTV8
(208), id 0000000000000000.
[  476.102022] xc2028 3-0061: Trying to load scode 0
[  476.102031] xc2028 3-0061: load_scode called
[  476.102039] xc2028 3-0061: seek_firmware called, want type=F8MHZ MTS
D2620 DTV8 SCODE (2000020e), id 0000000000000000.
[  476.102061] xc2028 3-0061: Can't find firmware for type=MTS SCODE
(20000004), id 0000000000000000.
[  476.102077] xc2028 3-0061: xc2028_get_reg 0004 called
[  476.102893] xc2028 3-0061: xc2028_get_reg 0008 called
[  476.103769] xc2028 3-0061: Device is Xceive 3028 version 2.0,
firmware version 3.6
[  476.240037] xc2028 3-0061: divisor= 00 00 87 d0 (freq=546.000)
[  477.245187] zl10353: zl10353_calc_nominal_rate: bw 8, adc_clock
450560 => 0x67e5
[  477.245931] zl10353: zl10353_calc_input_freq: if2 361667, ife 88893,
adc_clock 450560 => -12930 / 0xcd7e
[  477.247805] xc2028 3-0061: xc2028_set_params called
[  477.247814] xc2028 3-0061: generic_set_freq called
[  477.247823] xc2028 3-0061: should set frequency 546000 kHz
[  477.247831] xc2028 3-0061: check_firmware called
[  477.247839] xc2028 3-0061: checking firmware, user requested
type=F8MHZ MTS D2620 DTV8 (20e), id 0000000000000000, scode_tbl (0),
scode_nr 0
[  477.247864] xc2028 3-0061: BASE firmware not changed.
[  477.247871] xc2028 3-0061: Std-specific firmware already loaded.
[  477.247879] xc2028 3-0061: SCODE firmware already loaded.
[  477.247888] xc2028 3-0061: xc2028_get_reg 0004 called
[  477.249559] xc2028 3-0061: xc2028_get_reg 0008 called
[  477.250431] xc2028 3-0061: Device is Xceive 3028 version 2.0,
firmware version 3.6
[  477.384037] xc2028 3-0061: divisor= 00 00 87 d0 (freq=546.000)
[  478.198468] zl10353: zl10353_calc_nominal_rate: bw 8, adc_clock
450560 => 0x67e5
[  478.199212] zl10353: zl10353_calc_input_freq: if2 361667, ife 88893,
adc_clock 450560 => -12930 / 0xcd7e
[  478.201092] xc2028 3-0061: xc2028_set_params called
[  478.201102] xc2028 3-0061: generic_set_freq called
[  478.201111] xc2028 3-0061: should set frequency 546000 kHz
[  478.201119] xc2028 3-0061: check_firmware called
[  478.201127] xc2028 3-0061: checking firmware, user requested
type=F8MHZ MTS D2620 DTV8 (20e), id 0000000000000000, scode_tbl (0),
scode_nr 0
[  478.201152] xc2028 3-0061: BASE firmware not changed.
[  478.201159] xc2028 3-0061: Std-specific firmware already loaded.
[  478.201167] xc2028 3-0061: SCODE firmware already loaded.
[  478.201176] xc2028 3-0061: xc2028_get_reg 0004 called
[  478.202086] xc2028 3-0061: xc2028_get_reg 0008 called
[  478.202962] xc2028 3-0061: Device is Xceive 3028 version 2.0,
firmware version 3.6
[  478.336037] xc2028 3-0061: divisor= 00 00 87 d0 (freq=546.000)
[  479.341256] zl10353: zl10353_calc_nominal_rate: bw 8, adc_clock
450560 => 0x67e5
[  479.341999] zl10353: zl10353_calc_input_freq: if2 361667, ife 88893,
adc_clock 450560 => -12930 / 0xcd7e
[  479.343872] xc2028 3-0061: xc2028_set_params called
[  479.343881] xc2028 3-0061: generic_set_freq called
[  479.343890] xc2028 3-0061: should set frequency 546000 kHz
[  479.343898] xc2028 3-0061: check_firmware called
[  479.343906] xc2028 3-0061: checking firmware, user requested
type=F8MHZ MTS D2620 DTV8 (20e), id 0000000000000000, scode_tbl (0),
scode_nr 0
[  479.343930] xc2028 3-0061: BASE firmware not changed.
[  479.343938] xc2028 3-0061: Std-specific firmware already loaded.
[  479.343946] xc2028 3-0061: SCODE firmware already loaded.
[  479.343954] xc2028 3-0061: xc2028_get_reg 0004 called
[  479.345504] xc2028 3-0061: xc2028_get_reg 0008 called
[  479.346374] xc2028 3-0061: Device is Xceive 3028 version 2.0,
firmware version 3.6
[  479.480035] xc2028 3-0061: divisor= 00 00 87 d0 (freq=546.000)
[  480.480423] xc2028 3-0061: Putting xc2028/3028 into poweroff mode. 

