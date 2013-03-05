Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:46333 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751746Ab3CEKzh (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 5 Mar 2013 05:55:37 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	=?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: [PATCH 0/3] em28xx: add support for two buses on em2874 and upper
Date: Tue,  5 Mar 2013 07:55:25 -0300
Message-Id: <1362480928-20382-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The em2874 chips and upper have 2 buses. On all known devices, bus 0 is
currently used only by eeprom, and bus 1 for the rest. Add support to
register both buses.

Tested with 2 devices: HVR-950C (em2883 - 1 bus) and Terratec Cinergy HTC
(em2884 - 2 buses):

1) HVR-950C (1 bus only)

[ 7476.154903] em28xx: New device  WinTV HVR-980 @ 480 Mbps (2040:6513, interface 0, class 0)
[ 7476.163146] em28xx: Audio interface 0 found (Vendor Class)
[ 7476.168609] em28xx: Video interface 0 found: isoc
[ 7476.173293] em28xx: DVB interface 0 found: isoc
[ 7476.177946] em28xx: chip ID is em2882/3
[ 7476.319920] em2882/3 #0: i2c eeprom 00: 1a eb 67 95 40 20 13 65 d0 12 5c 03 82 1e 6a 18
[ 7476.328118] em2882/3 #0: i2c eeprom 10: 00 00 24 57 66 07 01 00 00 00 00 00 00 00 00 00
[ 7476.336468] em2882/3 #0: i2c eeprom 20: 46 00 01 00 f0 10 02 00 b8 00 00 00 5b 1c 00 00
[ 7476.344871] em2882/3 #0: i2c eeprom 30: 00 00 20 40 20 80 02 20 01 01 01 01 00 00 00 00
[ 7476.353269] em2882/3 #0: i2c eeprom 40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[ 7476.361615] em2882/3 #0: i2c eeprom 50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[ 7476.370070] em2882/3 #0: i2c eeprom 60: 00 00 00 00 00 00 00 00 00 00 18 03 34 00 30 00
[ 7476.378421] em2882/3 #0: i2c eeprom 70: 32 00 38 00 34 00 34 00 39 00 30 00 31 00 38 00
[ 7476.386633] em2882/3 #0: i2c eeprom 80: 00 00 1e 03 57 00 69 00 6e 00 54 00 56 00 20 00
[ 7476.394833] em2882/3 #0: i2c eeprom 90: 48 00 56 00 52 00 2d 00 39 00 38 00 30 00 00 00
[ 7476.402986] em2882/3 #0: i2c eeprom a0: 84 12 00 00 05 50 1a 7f d4 78 23 b1 fe d0 18 85
[ 7476.411167] em2882/3 #0: i2c eeprom b0: ff 00 00 00 04 84 0a 00 01 01 20 77 00 40 fa 40
[ 7476.419353] em2882/3 #0: i2c eeprom c0: 1d f0 74 02 01 00 01 79 4f 00 00 00 00 00 00 00
[ 7476.427497] em2882/3 #0: i2c eeprom d0: 84 12 00 00 05 50 1a 7f d4 78 23 b1 fe d0 18 85
[ 7476.435673] em2882/3 #0: i2c eeprom e0: ff 00 00 00 04 84 0a 00 01 01 20 77 00 40 fa 40
[ 7476.443878] em2882/3 #0: i2c eeprom f0: 1d f0 74 02 01 00 01 79 4f 00 00 00 00 00 00 00
[ 7476.452071] em2882/3 #0: EEPROM ID = 1a eb 67 95, EEPROM hash = 0x994b2bdd
[ 7476.458922] em2882/3 #0: EEPROM info:
[ 7476.462617] em2882/3 #0: 	No audio on board.
[ 7476.466872] em2882/3 #0: 	500mA max power
[ 7476.470867] em2882/3 #0: 	Table at offset 0x00, strings=0x0000, 0x0000, 0x0000
[ 7476.508416] em2882/3 #0: found i2c device @ 0xa0 on bus 0 [eeprom]
[ 7476.519284] em2882/3 #0: found i2c device @ 0xb8 on bus 0 [tvp5150a]
[ 7476.527531] em2882/3 #0: found i2c device @ 0xc2 on bus 0 [tuner (analog)]
[ 7476.545647] em2882/3 #0: Identified as Hauppauge WinTV HVR 950 (card=16)

2) Terratec Cinergy HTC (2 buses)

[ 7598.430202] em28xx: New device TERRATEC  Cinergy HTC Stick @ 480 Mbps (0ccd:00b2, interface 0, class 0)
[ 7598.439579] em28xx: Audio interface 0 found (Vendor Class)
[ 7598.445053] em28xx: Video interface 0 found: isoc
[ 7598.449745] em28xx: DVB interface 0 found: isoc
[ 7598.454428] em28xx: chip ID is em2884
[ 7598.517046] em2884 #0: i2c eeprom 0000: 26 00 00 00 02 0b 0f e5 f5 64 01 60 09 e5 f5 64
[ 7598.525292] em2884 #0: i2c eeprom 0010: 09 60 03 c2 c6 22 e5 f7 b4 03 13 e5 f6 b4 87 03
[ 7598.533649] em2884 #0: i2c eeprom 0020: 02 0a b9 e5 f6 b4 93 03 02 09 46 c2 c6 22 c2 c6
[ 7598.542086] em2884 #0: i2c eeprom 0030: 22 00 60 00 ef 70 08 85 3d 82 85 3c 83 93 ff ef
[ 7598.550422] em2884 #0: i2c eeprom 0040: 60 19 85 3d 82 85 3c 83 e4 93 12 07 a3 12 0a fe
[ 7598.558817] em2884 #0: i2c eeprom 0050: 05 3d e5 3d 70 02 05 3c 1f 80 e4 22 12 0b 06 02
[ 7598.567156] em2884 #0: i2c eeprom 0060: 07 e2 01 00 1a eb 67 95 cd 0c b2 00 f0 13 6b 03
[ 7598.575498] em2884 #0: i2c eeprom 0070: 9a 24 6a 1c 86 14 27 57 4e 16 29 00 60 00 00 00
[ 7598.583939] em2884 #0: i2c eeprom 0080: 02 00 00 00 5e 00 13 00 f0 10 44 82 82 00 00 00
[ 7598.592275] em2884 #0: i2c eeprom 0090: 5b 53 c0 00 00 00 20 40 20 80 02 20 01 01 00 00
[ 7598.600618] em2884 #0: i2c eeprom 00a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[ 7598.609058] em2884 #0: i2c eeprom 00b0: c6 40 00 00 81 00 00 00 00 00 00 00 00 c4 00 00
[ 7598.617373] em2884 #0: i2c eeprom 00c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 1c 03
[ 7598.625758] em2884 #0: i2c eeprom 00d0: 31 00 32 00 33 00 34 00 35 00 36 00 37 00 38 00
[ 7598.634123] em2884 #0: i2c eeprom 00e0: 39 00 41 00 42 00 43 00 44 00 14 03 54 00 45 00
[ 7598.642464] em2884 #0: i2c eeprom 00f0: 52 00 52 00 41 00 54 00 45 00 43 00 20 00 24 03
[ 7598.650900] em2884 #0: i2c eeprom 0100: ... (skipped)
[ 7598.655937] em2884 #0: EEPROM ID = 26 00 00 00, EEPROM hash = 0xfebadddc
[ 7598.662613] em2884 #0: EEPROM info:
[ 7598.666090] em2884 #0: 	microcode start address = 0x0004, boot configuration = 0x00
[ 7598.681080] em2884 #0: 	No audio on board.
[ 7598.685175] em2884 #0: 	500mA max power
[ 7598.689002] em2884 #0: 	Table at offset 0x00, strings=0x0000, 0x0000, 0x0000
[ 7598.696181] em2884 #0: 1 bytes requested from i2c device at 0x0, but 0 bytes received
	(lots of message similar to above - supressing them to shorten this email)
...
[ 7599.346459] em2884 #0: found i2c device @ 0xa0 on bus 0 [eeprom]
...
[ 7600.057963] em2884 #0: found i2c device @ 0x52 on bus 1 [drxk]
...
[ 7600.249717] em2884 #0: found i2c device @ 0x82 on bus 1 [???]
...
[ 7600.496836] em2884 #0: found i2c device @ 0xc0 on bus 1 [tuner (analog)]
...
[ 7600.760725] em2884 #0: Identified as Terratec Cinergy HTC Stick (card=82)

Mauro Carvalho Chehab (3):
  em28xx: Prepare to support 2 different I2C buses
  em28xx: Add a separate config dir for secondary bus
  em28xx: add support for registering multiple i2c buses

 drivers/media/usb/em28xx/em28xx-cards.c | 100 ++++++++++++++++++--------------
 drivers/media/usb/em28xx/em28xx-dvb.c   |  86 +++++++++++++--------------
 drivers/media/usb/em28xx/em28xx-i2c.c   |  93 +++++++++++++++++++----------
 drivers/media/usb/em28xx/em28xx-input.c |   5 +-
 drivers/media/usb/em28xx/em28xx.h       |  26 +++++++--
 5 files changed, 187 insertions(+), 123 deletions(-)

-- 
1.8.1.4

