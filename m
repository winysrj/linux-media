Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f176.google.com ([209.85.211.176]:37145 "EHLO
	mail-yw0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751395AbZLaM4J (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 31 Dec 2009 07:56:09 -0500
Received: by ywh6 with SMTP id 6so12850399ywh.4
        for <linux-media@vger.kernel.org>; Thu, 31 Dec 2009 04:56:08 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <21ce51250912310451k4f274ccej7846864cdae7d8b7@mail.gmail.com>
References: <21ce51250912310451k4f274ccej7846864cdae7d8b7@mail.gmail.com>
Date: Thu, 31 Dec 2009 13:56:08 +0100
Message-ID: <21ce51250912310456x45287dfeke12e625858bd900a@mail.gmail.com>
Subject: Re: em28xx: Not validated board + feature request [[0x2304:0x0226]]
From: Arnaud Boy <psykauze@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I've a card I'll buy few years ago but he didn't work fully.

em28xx's card name is [[Pinnacle Hybrid Pro (2)]], empia chipset is
330e (lsusb: "Bus 001 Device 002: ID 2304:0226 Pinnacle Systems, Inc.
[hex] PCTV 330e")

When I connect my card, i'll see this message:
[...]
[ 6102.988189] usb 1-1: new high speed USB device using ehci_hcd and address 3
[ 6103.130372] usb 1-1: New USB device found, idVendor=2304, idProduct=0226
[ 6103.130382] usb 1-1: New USB device strings: Mfr=3, Product=1, SerialNumber=2
[ 6103.130389] usb 1-1: Product: PCTV 330e
[ 6103.130394] usb 1-1: Manufacturer: Pinnacle Systems
[ 6103.130399] usb 1-1: SerialNumber: 061101027954
[ 6103.130588] usb 1-1: configuration #1 chosen from 1 choice
[ 6103.132620] em28xx: New device Pinnacle Systems PCTV 330e @ 480
Mbps (2304:0226, interface 0, class 0)
[ 6103.133675] em28xx #0: chip ID is em2882/em2883
[ 6103.309411] em28xx #0: i2c eeprom 00: 1a eb 67 95 04 23 26 02 d0 12
5c 03 8e 16 a4 1c
[ 6103.309433] em28xx #0: i2c eeprom 10: 6a 24 27 57 46 07 01 00 00 00
00 00 00 00 00 00
[ 6103.309451] em28xx #0: i2c eeprom 20: 46 00 01 00 f0 10 02 00 b8 00
00 00 5b e0 00 00
[ 6103.309468] em28xx #0: i2c eeprom 30: 00 00 20 40 20 6e 02 20 10 01
00 00 00 00 00 00
[ 6103.309484] em28xx #0: i2c eeprom 40: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[ 6103.309500] em28xx #0: i2c eeprom 50: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[ 6103.309516] em28xx #0: i2c eeprom 60: 00 00 00 00 00 00 00 00 00 00
24 03 50 00 69 00
[ 6103.309532] em28xx #0: i2c eeprom 70: 6e 00 6e 00 61 00 63 00 6c 00
65 00 20 00 53 00
[ 6103.309549] em28xx #0: i2c eeprom 80: 79 00 73 00 74 00 65 00 6d 00
73 00 00 00 16 03
[ 6103.309565] em28xx #0: i2c eeprom 90: 50 00 43 00 54 00 56 00 20 00
33 00 33 00 30 00
[ 6103.309581] em28xx #0: i2c eeprom a0: 65 00 00 00 1c 03 30 00 36 00
31 00 31 00 30 00
[ 6103.309597] em28xx #0: i2c eeprom b0: 31 00 30 00 32 00 37 00 39 00
35 00 34 00 00 00
[ 6103.309614] em28xx #0: i2c eeprom c0: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[ 6103.309629] em28xx #0: i2c eeprom d0: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[ 6103.309645] em28xx #0: i2c eeprom e0: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[ 6103.309661] em28xx #0: i2c eeprom f0: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[ 6103.309681] em28xx #0: EEPROM ID= 0x9567eb1a, EEPROM hash = 0xb0b3aebf
[ 6103.309686] em28xx #0: EEPROM info:
[ 6103.309689] em28xx #0:    AC97 audio (5 sample rates)
[ 6103.309693] em28xx #0:    500mA max power
[ 6103.309698] em28xx #0:    Table at 0x27, strings=0x168e, 0x1ca4, 0x246a
[ 6103.311331] em28xx #0: Identified as Pinnacle Hybrid Pro (2) (card=56)
[ 6103.311338] em28xx #0:
[ 6103.311341]
[ 6103.311346] em28xx #0: The support for this board weren't valid yet.
[ 6103.311351] em28xx #0: Please send a report of having this working
[ 6103.311355] em28xx #0: not to V4L mailing list (and/or to other addresses)
[ 6103.311358]
[ 6103.315206] tvp5150 1-005c: chip found @ 0xb8 (em28xx #0)
[ 6103.324057] tuner 1-0061: chip found @ 0xc2 (em28xx #0)
[ 6103.324234] xc2028 1-0061: creating new instance
[ 6103.324241] xc2028 1-0061: type set to XCeive xc2028/xc3028 tuner
[ 6103.324254] usb 1-1: firmware: requesting xc3028-v27.fw
[ 6103.334164] xc2028 1-0061: Loading 80 firmware images from
xc3028-v27.fw, type: xc2028 firmware, ver 2.7
[ 6103.381212] xc2028 1-0061: Loading firmware for type=BASE MTS (5),
id 0000000000000000.
[ 6104.420147] xc2028 1-0061: Loading firmware for type=MTS (4), id
000000000000b700.
[ 6104.436024] xc2028 1-0061: Loading SCODE for type=MTS LCD NOGD MONO
IF SCODE HAS_IF_4500 (6002b004), id 000000000000b700.
[ 6104.621338] em28xx #0: Config register raw data: 0xd0
[ 6104.622093] em28xx #0: AC97 vendor ID = 0xffffffff
[ 6104.622425] em28xx #0: AC97 features = 0x6a90
[ 6104.622432] em28xx #0: Empia 202 AC97 audio processor detected
[ 6104.750456] tvp5150 1-005c: tvp0050am1 detected.
[ 6104.862343] em28xx #0: v4l2 driver version 0.1.2
[ 6104.954104] em28xx #0: V4L2 video device registered as /dev/video1
[ 6104.954112] em28xx #0: V4L2 VBI device registered as /dev/vbi0
[ 6104.954119] em28xx-audio.c: probing for em28x1 non standard usbaudio
[ 6104.954123] em28xx-audio.c: Copyright (C) 2006 Markus Rechberger
[ 6105.096806] tvp5150 1-005c: tvp5150am1 detected.
[ 6105.386261] tvp5150 1-005c: tvp5150am1 detected.
[...]

Tests made:

     - Analog TV [Works]
     - Composite Acquisition [Works]
     - Analog Tune [Works]
     - Teletext [Not tested]
     - Sound Analog TV [I can't ear anything (but maybe it is a bug
from my system and not your driver)]

     - Sound Analog Jack [I can't ear anything (but maybe it is a bug
from my system and not from your driver)]
     - S-Video aquisition [Not tested]
     - DVB    [DVB not yet implemented in em28xx driver]


 Tested-by: psykauze <psykauze@gmail.com>

In source code of em28xx branch, we can see in "em28xx-cards.c" file
in [EM2882_BOARD_PINNACLE_HYBRID_PRO] structure :

[...]
#if 0 /* FIXME: add an entry at em28xx-dvb */
      .has_dvb      = 1,
      .dvb_gpio     = hauppauge_wintv_hvr_900_digital,
#endif
[...]

This card isn't referenced in "em2xx-dvb.c" file

Can you did working dvb on my card ?

Sincerely.

Psykauze
