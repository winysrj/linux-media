Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from lo.gmane.org ([80.91.229.12])
	by mail.linuxtv.org with esmtp (Exim 4.69)
	(envelope-from <gldd-linux-dvb@m.gmane.org>) id 1MnpkI-0002qG-22
	for linux-dvb@linuxtv.org; Wed, 16 Sep 2009 10:20:10 +0200
Received: from list by lo.gmane.org with local (Exim 4.50) id 1MnpkC-0004PN-2S
	for linux-dvb@linuxtv.org; Wed, 16 Sep 2009 10:20:04 +0200
Received: from astdenis-106-1-94-248.w90-43.abo.wanadoo.fr ([90.43.78.248])
	by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
	id 1AlnuQ-0007hv-00
	for <linux-dvb@linuxtv.org>; Wed, 16 Sep 2009 10:20:04 +0200
Received: from not0read0765 by astdenis-106-1-94-248.w90-43.abo.wanadoo.fr
	with local (Gmexim 0.1 (Debian)) id 1AlnuQ-0007hv-00
	for <linux-dvb@linuxtv.org>; Wed, 16 Sep 2009 10:20:04 +0200
To: linux-dvb@linuxtv.org
From: Olive <not0read0765@yopmail.com>
Date: Wed, 16 Sep 2009 12:16:51 +0400
Message-ID: <20090916121651.53f286e6@pcolivier.chezmoi.net>
Mime-Version: 1.0
Subject: [linux-dvb] Pinnacle 330e
Reply-To: linux-media@vger.kernel.org
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/options/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Hello,

I own a TV card advertised as "Pinnacle Hybrid stick solo". After
installing the xc3028-v27.fw firmware; I can watch analog TV with the
em28xx module. The problem is with the digital TV. The devices /dev/dvb*
are not created. I have also tried an em28xx-new module that we find on
the net (and a patch to make it work on 2.6.30) but it does not work
either (and moreover; with this last driver, the analog part does not
work correctly with SECAM). As anyone succeeded to have the digital
part of this stick work? Here below I put the relevant part of dmesg.
After modprobing em28xx-dvb I got the supplementary line from the dmesg
output (but still no /dev/dvb* devices).

Em28xx: Initialized (Em28xx dvb Extension) extension

Olive


usb 1-1: new high speed USB device using ehci_hcd and address 8
usb 1-1: configuration #1 chosen from 1 choice
em28xx: New device Pinnacle Systems PCTV 330e @ 480 Mbps (2304:0226,
interface 0, class 0) em28xx #0: Identified as Pinnacle Hybrid Pro (2)
(card=56) em28xx #0: chip ID is em2882/em2883
em28xx #0: i2c eeprom 00: 1a eb 67 95 04 23 26 02 d0 12 5c 03 8e 16 a4
1c em28xx #0: i2c eeprom 10: 6a 24 27 57 46 07 01 00 00 00 00 00 00 00
00 00 em28xx #0: i2c eeprom 20: 46 00 01 00 f0 10 02 00 b8 00 00 00 5b
e0 00 00 em28xx #0: i2c eeprom 30: 00 00 20 40 20 6e 02 20 10 01 00 00
00 00 00 00 em28xx #0: i2c eeprom 40: 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 em28xx #0: i2c eeprom 50: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00 em28xx #0: i2c eeprom 60: 00 00 00 00 00 00 00 00 00
00 24 03 50 00 69 00 em28xx #0: i2c eeprom 70: 6e 00 6e 00 61 00 63 00
6c 00 65 00 20 00 53 00 em28xx #0: i2c eeprom 80: 79 00 73 00 74 00 65
00 6d 00 73 00 00 00 16 03 em28xx #0: i2c eeprom 90: 50 00 43 00 54 00
56 00 20 00 33 00 33 00 30 00 em28xx #0: i2c eeprom a0: 65 00 00 00 1c
03 30 00 38 00 30 00 33 00 30 00 em28xx #0: i2c eeprom b0: 31 00 32 00
37 00 36 00 36 00 39 00 32 00 00 00 em28xx #0: i2c eeprom c0: 00 00 00
00 00 00 00 00 00 00 00 00 00 00 00 00 em28xx #0: i2c eeprom d0: 00 00
00 00 00 00 00 00 00 00 00 00 00 00 00 00 em28xx #0: i2c eeprom e0: 00
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 em28xx #0: i2c eeprom f0:
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 em28xx #0: EEPROM ID=
0x9567eb1a, EEPROM hash = 0x0db3a0bf em28xx #0: EEPROM info:
em28xx #0:	AC97 audio (5 sample rates)
em28xx #0:	500mA max power
em28xx #0:	Table at 0x27, strings=0x168e, 0x1ca4, 0x246a
em28xx #0: 

em28xx #0: The support for this board weren't valid yet.
em28xx #0: Please send a report of having this working
em28xx #0: not to V4L mailing list (and/or to other addresses)

tvp5150 1-005c: chip found @ 0xb8 (em28xx #0)
tuner 1-0061: chip found @ 0xc2 (em28xx #0)
xc2028 1-0061: creating new instance
xc2028 1-0061: type set to XCeive xc2028/xc3028 tuner
i2c-adapter i2c-1: firmware: requesting xc3028-v27.fw
xc2028 1-0061: Loading 80 firmware images from xc3028-v27.fw, type:
xc2028 firmware, ver 2.7 xc2028 1-0061: Loading firmware for type=BASE
MTS (5), id 0000000000000000. xc2028 1-0061: Loading firmware for
type=MTS (4), id 000000000000b700. xc2028 1-0061: Loading SCODE for
type=MTS LCD NOGD MONO IF SCODE HAS_IF_4500 (6002b004), id
000000000000b700. em28xx #0: Config register raw data: 0xd0 em28xx #0:
AC97 vendor ID = 0xffffffff em28xx #0: AC97 features = 0x6a90
em28xx #0: Empia 202 AC97 audio processor detected
tvp5150 1-005c: tvp5150am1 detected.
em28xx #0: v4l2 driver version 0.1.2
em28xx #0: V4L2 device registered as /dev/video0 and /dev/vbi0
em28xx-audio.c: probing for em28x1 non standard usbaudio
em28xx-audio.c: Copyright (C) 2006 Markus Rechberger
tvp5150 1-005c: tvp5150am1 detected.



_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
