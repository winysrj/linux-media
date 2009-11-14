Return-path: <linux-media-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.159]:29327 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752795AbZKNE5q (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 13 Nov 2009 23:57:46 -0500
Received: by fg-out-1718.google.com with SMTP id e12so1727366fga.1
        for <linux-media@vger.kernel.org>; Fri, 13 Nov 2009 20:57:50 -0800 (PST)
Message-ID: <4AFE38CD.9010909@gmail.com>
Date: Sat, 14 Nov 2009 05:57:49 +0100
From: viktor <viktor.vraniak@gmail.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: MSI DigiVox A/D II not working
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

hi

kernel 2.6.31.1
latest clone of mercurial v4l-dvb
but tuner not playing TV.
no /dev/dvb directory is created.

it worked for me with combination experimental source from mcentral.de
(now unavailable page)
and kernel 2.6.28

have you some hint for me how to run it on newer kernel?
regards

Viktor


>lsusb :
Bus 007 Device 003: ID eb1a:e320 eMPIA Technology, Inc.

>modrpobe em28xx

dmesg output:
[ 2049.298105] em28xx: New device USB 2881 Device @ 480 Mbps (eb1a:e320,
interface 0, class 0)
[ 2049.298273] em28xx #0: chip ID is em2882/em2883
[ 2049.427098] em28xx #0: i2c eeprom 00: 1a eb 67 95 1a eb 20 e3 d0 12
5c 00 6a 22 00 00
[ 2049.427105] em28xx #0: i2c eeprom 10: 00 00 04 57 4e 07 00 00 00 00
00 00 00 00 00 00
[ 2049.427110] em28xx #0: i2c eeprom 20: 46 00 01 00 f0 10 01 00 00 00
00 00 5b 1e 00 00
[ 2049.427116] em28xx #0: i2c eeprom 30: 00 00 20 40 20 80 02 20 01 01
00 00 00 00 00 00
[ 2049.427122] em28xx #0: i2c eeprom 40: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[ 2049.427134] em28xx #0: i2c eeprom 50: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[ 2049.427140] em28xx #0: i2c eeprom 60: 00 00 00 00 00 00 00 00 00 00
22 03 55 00 53 00
[ 2049.427146] em28xx #0: i2c eeprom 70: 42 00 20 00 32 00 38 00 38 00
31 00 20 00 44 00
[ 2049.427151] em28xx #0: i2c eeprom 80: 65 00 76 00 69 00 63 00 65 00
00 00 00 00 00 00
[ 2049.427157] em28xx #0: i2c eeprom 90: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[ 2049.427162] em28xx #0: i2c eeprom a0: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[ 2049.427168] em28xx #0: i2c eeprom b0: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[ 2049.427173] em28xx #0: i2c eeprom c0: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[ 2049.427179] em28xx #0: i2c eeprom d0: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[ 2049.427184] em28xx #0: i2c eeprom e0: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[ 2049.427190] em28xx #0: i2c eeprom f0: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[ 2049.427196] em28xx #0: EEPROM ID= 0x9567eb1a, EEPROM hash = 0x74913442
[ 2049.427198] em28xx #0: EEPROM info:
[ 2049.427199] em28xx #0:    AC97 audio (5 sample rates)
[ 2049.427200] em28xx #0:    500mA max power
[ 2049.427201] em28xx #0:    Table at 0x04, strings=0x226a, 0x0000, 0x0000
[ 2049.428479] em28xx #0: Identified as MSI DigiVox A/D II (card=50)
[ 2049.428481] em28xx #0:
[ 2049.428481]
[ 2049.428482] em28xx #0: The support for this board weren't valid yet.
[ 2049.428484] em28xx #0: Please send a report of having this working
[ 2049.428485] em28xx #0: not to V4L mailing list (and/or to other
addresses)
[ 2049.428486]
[ 2049.429743] tvp5150 1-005c: chip found @ 0xb8 (em28xx #0)
[ 2049.432735] tuner 1-0061: chip found @ 0xc2 (em28xx #0)
[ 2049.432798] xc2028 1-0061: creating new instance
[ 2049.432799] xc2028 1-0061: type set to XCeive xc2028/xc3028 tuner
[ 2049.432803] usb 7-2: firmware: requesting xc3028-v27.fw
[ 2049.435547] xc2028 1-0061: Loading 80 firmware images from
xc3028-v27.fw, type: xc2028 firmware, ver 2.7
[ 2049.468031] xc2028 1-0061: Loading firmware for type=BASE (1), id
0000000000000000.
[ 2050.909032] xc2028 1-0061: Loading firmware for type=(0), id
000000000000b700.
[ 2050.935144] SCODE (20000000), id 000000000000b700:
[ 2050.935147] xc2028 1-0061: Loading SCODE for type=MONO SCODE
HAS_IF_4320 (60008000), id 0000000000008000.
[ 2051.060103] em28xx #0: Config register raw data: 0xd0
[ 2051.060853] em28xx #0: AC97 vendor ID = 0xffffffff
[ 2051.061232] em28xx #0: AC97 features = 0x6a90
[ 2051.061234] em28xx #0: Empia 202 AC97 audio processor detected
[ 2051.139480] tvp5150 1-005c: tvp5150am1 detected.
[ 2051.228848] em28xx #0: v4l2 driver version 0.1.2
[ 2051.280439] em28xx #0: V4L2 video device registered as /dev/video0
[ 2051.280441] em28xx #0: V4L2 VBI device registered as /dev/vbi0
[ 2051.281146] em28xx video device (eb1a:e320): interface 1, class 255
found.
[ 2051.281147] em28xx This is an anciliary interface not used by the driver
[ 2051.281164] usbcore: registered new interface driver em28xx
[ 2051.281166] em28xx driver loaded
[ 2051.283560] em28xx-audio.c: probing for em28x1 non standard usbaudio
[ 2051.283561] em28xx-audio.c: Copyright (C) 2006 Markus Rechberger
[ 2051.283762] Em28xx: Initialized (Em28xx Audio Extension) extension
[ 2051.408473] tvp5150 1-005c: tvp5150am1 detected.


