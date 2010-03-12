Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yx0-f200.google.com ([209.85.210.200]:61277 "EHLO
	mail-yx0-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932850Ab0CLNbZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Mar 2010 08:31:25 -0500
Received: by yxe38 with SMTP id 38so540219yxe.22
        for <linux-media@vger.kernel.org>; Fri, 12 Mar 2010 05:31:25 -0800 (PST)
MIME-Version: 1.0
Date: Fri, 12 Mar 2010 14:26:08 +0100
Message-ID: <21ce51251003120526n5b87cf3bofa9125448a7e78b6@mail.gmail.com>
Subject: "xc2028 1-0061: error: bandwidth not supported." If anyone could help
	me ?
From: Arnaud Boy <psykauze@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I have 2 differents dongle but the same errors appairs because there's
the same tuner system. I'll use this dongles for dvb-t reception.

The driver i'm using is the mercurial revision "82c3b0033929 tip"

Maybe I forget something, please anyone should help me.

When I'll try to see a dvb-t channel with the card 1 (PCTV 330e) i'll
get this error.
==========================================================
[12687.577100] xc2028 1-0061: error: bandwidth not supported.
[12687.636069] xc2028 1-0061: Loading firmware for type=BASE MTS (5),
id 0000000000000000.
[12688.768071] xc2028 1-0061: Loading firmware for type=BASE MTS (5),
id 0000000000000000.

With the card 2 (USB 2881 Video) I've the same errors
=======================================
[12888.431519] xc2028 1-0061: error: bandwidth not supported.
[12888.488512] xc2028 1-0061: Loading firmware for type=BASE (1), id
0000000000000000.
[12889.589077] xc2028 1-0061: Loading firmware for type=BASE (1), id
0000000000000000.


Card 1 dmesg
==========
[12308.004121] usb 1-1: new high speed USB device using ehci_hcd and address 11
[12308.145714] usb 1-1: New USB device found, idVendor=2304, idProduct=0226
[12308.145725] usb 1-1: New USB device strings: Mfr=3, Product=1, SerialNumber=2
[12308.145733] usb 1-1: Product: PCTV 330e
[12308.145739] usb 1-1: Manufacturer: Pinnacle Systems
[12308.145744] usb 1-1: SerialNumber: 061101027954
[12308.145960] usb 1-1: configuration #1 chosen from 1 choice
[12308.147777] em28xx: New device Pinnacle Systems PCTV 330e @ 480
Mbps (2304:0226, interface 0, class 0)
[12308.148053] em28xx #0: chip ID is em2882/em2883
[12308.324566] em28xx #0: i2c eeprom 00: 1a eb 67 95 04 23 26 02 d0 12
5c 03 8e 16 a4 1c
[12308.324589] em28xx #0: i2c eeprom 10: 6a 24 27 57 46 07 01 00 00 00
00 00 00 00 00 00
[12308.324610] em28xx #0: i2c eeprom 20: 46 00 01 00 f0 10 02 00 b8 00
00 00 5b e0 00 00
[12308.324629] em28xx #0: i2c eeprom 30: 00 00 20 40 20 6e 02 20 10 01
00 00 00 00 00 00
[12308.324647] em28xx #0: i2c eeprom 40: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[12308.324665] em28xx #0: i2c eeprom 50: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[12308.324683] em28xx #0: i2c eeprom 60: 00 00 00 00 00 00 00 00 00 00
24 03 50 00 69 00
[12308.324701] em28xx #0: i2c eeprom 70: 6e 00 6e 00 61 00 63 00 6c 00
65 00 20 00 53 00
[12308.324719] em28xx #0: i2c eeprom 80: 79 00 73 00 74 00 65 00 6d 00
73 00 00 00 16 03
[12308.324737] em28xx #0: i2c eeprom 90: 50 00 43 00 54 00 56 00 20 00
33 00 33 00 30 00
[12308.324755] em28xx #0: i2c eeprom a0: 65 00 00 00 1c 03 30 00 36 00
31 00 31 00 30 00
[12308.324773] em28xx #0: i2c eeprom b0: 31 00 30 00 32 00 37 00 39 00
35 00 34 00 00 00
[12308.324791] em28xx #0: i2c eeprom c0: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[12308.324809] em28xx #0: i2c eeprom d0: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[12308.324827] em28xx #0: i2c eeprom e0: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[12308.324845] em28xx #0: i2c eeprom f0: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[12308.324867] em28xx #0: EEPROM ID= 0x9567eb1a, EEPROM hash = 0xb0b3aebf
[12308.324873] em28xx #0: EEPROM info:
[12308.324877] em28xx #0:	AC97 audio (5 sample rates)
[12308.324882] em28xx #0:	500mA max power
[12308.324888] em28xx #0:	Table at 0x27, strings=0x168e, 0x1ca4, 0x246a
[12308.326783] em28xx #0: Identified as Pinnacle Hybrid Pro (330e) (card=56)
[12308.330650] tvp5150 1-005c: chip found @ 0xb8 (em28xx #0)
[12308.336375] tuner 1-0061: chip found @ 0xc2 (em28xx #0)
[12308.336536] xc2028 1-0061: creating new instance
[12308.336543] xc2028 1-0061: type set to XCeive xc2028/xc3028 tuner
[12308.336558] usb 1-1: firmware: requesting xc3028-v27.fw
[12308.346584] xc2028 1-0061: Loading 80 firmware images from
xc3028-v27.fw, type: xc2028 firmware, ver 2.7
[12308.392088] xc2028 1-0061: Loading firmware for type=BASE MTS (5),
id 0000000000000000.
[12309.399125] xc2028 1-0061: Loading firmware for type=MTS (4), id
000000000000b700.
[12309.415115] xc2028 1-0061: Loading SCODE for type=MTS LCD NOGD MONO
IF SCODE HAS_IF_4500 (6002b004), id 000000000000b700.
[12309.540632] input: em28xx IR (em28xx #0) as
/devices/pci0000:00/0000:00:12.2/usb1/1-1/input/input22
[12309.540781] Creating IR device irrcv0
[12309.541715] em28xx #0: Config register raw data: 0xd0
[12309.542565] em28xx #0: AC97 vendor ID = 0xffffffff
[12309.542933] em28xx #0: AC97 features = 0x6a90
[12309.542941] em28xx #0: Empia 202 AC97 audio processor detected
[12309.673039] tvp5150 1-005c: tvp5150am1 detected.
[12309.777174] em28xx #0: v4l2 driver version 0.1.2
[12309.863427] em28xx #0: V4L2 video device registered as video1
[12309.863432] em28xx #0: V4L2 VBI device registered as vbi0
[12309.863435] em28xx-audio.c: probing for em28x1 non standard usbaudio
[12309.863438] em28xx-audio.c: Copyright (C) 2006 Markus Rechberger
[12309.915259] xc2028 1-0061: attaching existing instance
[12309.915264] xc2028 1-0061: type set to XCeive xc2028/xc3028 tuner
[12309.915267] em28xx #0: em28xx #0/2: xc3028 attached
[12309.915270] DVB: registering new adapter (em28xx #0)
[12309.915275] DVB: registering adapter 0 frontend 0 (Micronas DRXD DVB-T)...
[12309.915651] em28xx #0: Successfully loaded em28xx-dvb
[12310.056713] tvp5150 1-005c: tvp5150am1 detected.
[12310.301034] tvp5150 1-005c: tvp5150am1 detected.

Card 2 dmesg
==========
[12194.852107] usb 1-1: new high speed USB device using ehci_hcd and address 10
[12194.988014] usb 1-1: New USB device found, idVendor=eb1a, idProduct=2881
[12194.988025] usb 1-1: New USB device strings: Mfr=0, Product=1, SerialNumber=0
[12194.988033] usb 1-1: Product: USB 2881 Video
[12194.988242] usb 1-1: configuration #1 chosen from 1 choice
[12194.990396] em28xx: New device USB 2881 Video @ 480 Mbps
(eb1a:2881, interface 0, class 0)
[12194.991134] em28xx #0: chip ID is em2882/em2883
[12195.072989] em28xx #0: i2c eeprom 00: 1a eb 67 95 1a eb 81 28 58 12
5c 00 6a 20 6a 00
[12195.073002] em28xx #0: i2c eeprom 10: 00 00 04 57 64 57 00 00 60 f4
00 00 02 02 00 00
[12195.073014] em28xx #0: i2c eeprom 20: 56 00 01 00 00 00 02 00 b8 00
00 00 5b 1e 00 00
[12195.073025] em28xx #0: i2c eeprom 30: 00 00 20 40 20 80 02 20 10 02
00 00 00 00 00 00
[12195.073035] em28xx #0: i2c eeprom 40: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[12195.073045] em28xx #0: i2c eeprom 50: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[12195.073056] em28xx #0: i2c eeprom 60: 00 00 00 00 00 00 00 00 00 00
20 03 55 00 53 00
[12195.073066] em28xx #0: i2c eeprom 70: 42 00 20 00 32 00 38 00 38 00
31 00 20 00 56 00
[12195.073076] em28xx #0: i2c eeprom 80: 69 00 64 00 65 00 6f 00 00 00
00 00 00 00 00 00
[12195.073086] em28xx #0: i2c eeprom 90: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[12195.073097] em28xx #0: i2c eeprom a0: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[12195.073107] em28xx #0: i2c eeprom b0: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[12195.073117] em28xx #0: i2c eeprom c0: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[12195.073127] em28xx #0: i2c eeprom d0: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[12195.073137] em28xx #0: i2c eeprom e0: 5a 00 55 aa 79 55 54 03 00 17
98 01 00 00 00 00
[12195.073148] em28xx #0: i2c eeprom f0: 0c 00 00 01 00 00 00 00 00 00
00 00 00 00 00 00
[12195.073160] em28xx #0: EEPROM ID= 0x9567eb1a, EEPROM hash = 0xb8846b20
[12195.073164] em28xx #0: EEPROM info:
[12195.073166] em28xx #0:	AC97 audio (5 sample rates)
[12195.073169] em28xx #0:	USB Remote wakeup capable
[12195.073171] em28xx #0:	500mA max power
[12195.073175] em28xx #0:	Table at 0x04, strings=0x206a, 0x006a, 0x0000
[12195.074987] em28xx #0: Identified as Unknown EM2750/28xx video
grabber (card=1)
[12195.074993] em28xx #0: Your board has no unique USB ID.
[12195.074998] em28xx #0: A hint were successfully done, based on eeprom hash.
[12195.075001] em28xx #0: This method is not 100% failproof.
[12195.075005] em28xx #0: If the board were missdetected, please email
this log to:
[12195.075008] em28xx #0: 	V4L Mailing List  <linux-media@vger.kernel.org>
[12195.075012] em28xx #0: Board detected as Pinnacle Hybrid Pro
[12195.153274] tvp5150 1-005c: chip found @ 0xb8 (em28xx #0)
[12195.158756] tuner 1-0061: chip found @ 0xc2 (em28xx #0)
[12195.158914] xc2028 1-0061: creating new instance
[12195.158922] xc2028 1-0061: type set to XCeive xc2028/xc3028 tuner
[12195.158936] usb 1-1: firmware: requesting xc3028-v27.fw
[12195.167042] xc2028 1-0061: Loading 80 firmware images from
xc3028-v27.fw, type: xc2028 firmware, ver 2.7
[12195.224041] xc2028 1-0061: Loading firmware for type=BASE (1), id
0000000000000000.
[12196.237538] xc2028 1-0061: Loading firmware for type=(0), id
000000000000b700.
[12196.253132] SCODE (20000000), id 000000000000b700:
[12196.253147] xc2028 1-0061: Loading SCODE for type=MONO SCODE
HAS_IF_4320 (60008000), id 0000000000008000.
[12196.376244] em28xx #0: Config register raw data: 0x58
[12196.376986] em28xx #0: AC97 vendor ID = 0x83847652
[12196.377459] em28xx #0: AC97 features = 0x6a90
[12196.377467] em28xx #0: Sigmatel audio processor detected(stac 9752)
[12196.504782] tvp5150 1-005c: tvp5150am1 detected.
[12196.617467] em28xx #0: v4l2 driver version 0.1.2
[12196.699890] em28xx #0: V4L2 video device registered as video1
[12196.699899] em28xx #0: V4L2 VBI device registered as vbi0
[12196.842672] xc2028 1-0061: attaching existing instance
[12196.842682] xc2028 1-0061: type set to XCeive xc2028/xc3028 tuner
[12196.842689] em28xx #0: em28xx #0/2: xc3028 attached
[12196.842696] DVB: registering new adapter (em28xx #0)
[12196.842705] DVB: registering adapter 0 frontend 0 (Zarlink ZL10353 DVB-T)...
[12196.843419] em28xx #0: Successfully loaded em28xx-dvb
[12196.844421] em28xx audio device (eb1a:2881): interface 1, class 1
[12196.970244] tvp5150 1-005c: tvp5150am1 detected.

Sincerely.
