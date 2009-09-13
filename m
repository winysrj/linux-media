Return-path: <linux-media-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.157]:29836 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752340AbZIMTbV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 13 Sep 2009 15:31:21 -0400
Received: by fg-out-1718.google.com with SMTP id 22so780860fge.1
        for <linux-media@vger.kernel.org>; Sun, 13 Sep 2009 12:31:24 -0700 (PDT)
Date: Sun, 13 Sep 2009 21:31:18 +0200
From: Uros Vampl <mobile.leecher@gmail.com>
To: linux-media@vger.kernel.org
Subject: Questions about Terratec Hybrid XS (em2882) [0ccd:005e]
Message-ID: <20090913193118.GA12659@zverina>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="vkogqOf2sHV7VnPd"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--vkogqOf2sHV7VnPd
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

Hello.

I have the Terratec Cinergy Hybrid T XS USB (em2882) - usb-id 0ccd:005e. 
It works with Marcus Rechberger's em28xx-new driver, but since that code 
is unmaintained now, I tested this device with v4l-dvb today.

The analog picture is there, but audio is very, very quiet, almost not 
there. Is there some way to increase the volume?

Second question, what would be required to get DVB working?

The final thing is not a question, it's actually something that works: 
the remote. It's the same one as comes with the other Hybrid XS 
(0ccd:0042), adding these two lines to the definition of this card in 
em28xx-cards.c makes it work:

		.ir_codes       = &ir_codes_terratec_cinergy_xs_table,
		.xclk           = EM28XX_XCLK_FREQUENCY_12MHZ,


Any pointers to solving my issues (analog audio, dvb) appreciated. I can 
test patches, I can give ssh access to my machine if it helps. There's 
even a Windows install on this machine, so USB sniffing of the Windows 
driver is possible, I just need instructions on what exactly to do.
Dmesg output for this device is attached.


Regards,
Uroš

--vkogqOf2sHV7VnPd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg.txt"

usb 1-4: new high speed USB device using ehci_hcd and address 6
usb 1-4: configuration #1 chosen from 1 choice
Linux video capture interface: v2.00
em28xx: New device TerraTec Electronic GmbH Cinergy Hybrid T USB XS (2882) @ 480 Mbps (0ccd:005e, interface 0, class 0)
em28xx #0: chip ID is em2882/em2883
em28xx #0: i2c eeprom 00: 1a eb 67 95 cd 0c 5e 00 d0 12 5c 03 9e 40 de 1c
em28xx #0: i2c eeprom 10: 6a 34 27 57 46 07 01 00 00 00 00 00 00 00 00 00
em28xx #0: i2c eeprom 20: 46 00 01 00 f0 10 31 00 b8 00 14 00 5b 1e 00 00
em28xx #0: i2c eeprom 30: 00 00 20 40 20 6e 02 20 10 01 00 00 00 00 00 00
em28xx #0: i2c eeprom 40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
em28xx #0: i2c eeprom 50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
em28xx #0: i2c eeprom 60: 00 00 00 00 00 00 00 00 00 00 34 03 54 00 65 00
em28xx #0: i2c eeprom 70: 72 00 72 00 61 00 54 00 65 00 63 00 20 00 45 00
em28xx #0: i2c eeprom 80: 6c 00 65 00 63 00 74 00 72 00 6f 00 6e 00 69 00
em28xx #0: i2c eeprom 90: 63 00 20 00 47 00 6d 00 62 00 48 00 00 00 40 03
em28xx #0: i2c eeprom a0: 43 00 69 00 6e 00 65 00 72 00 67 00 79 00 20 00
em28xx #0: i2c eeprom b0: 48 00 79 00 62 00 72 00 69 00 64 00 20 00 54 00
em28xx #0: i2c eeprom c0: 20 00 55 00 53 00 42 00 20 00 58 00 53 00 20 00
em28xx #0: i2c eeprom d0: 28 00 32 00 38 00 38 00 32 00 29 00 00 00 1c 03
em28xx #0: i2c eeprom e0: 30 00 36 00 30 00 39 00 30 00 32 00 30 00 31 00
em28xx #0: i2c eeprom f0: 33 00 38 00 34 00 33 00 00 00 00 00 00 00 00 00
em28xx #0: EEPROM ID= 0x9567eb1a, EEPROM hash = 0x7713bfbe
em28xx #0: EEPROM info:
em28xx #0:      AC97 audio (5 sample rates)
em28xx #0:      500mA max power
em28xx #0:      Table at 0x27, strings=0x409e, 0x1cde, 0x346a
em28xx #0: Identified as Terratec Hybrid XS (em2882) (card=55)
em28xx #0:

em28xx #0: The support for this board weren't valid yet.
em28xx #0: Please send a report of having this working
em28xx #0: not to V4L mailing list (and/or to other addresses)

tvp5150 4-005c: chip found @ 0xb8 (em28xx #0)
tuner 4-0061: chip found @ 0xc2 (em28xx #0)
xc2028 4-0061: creating new instance
xc2028 4-0061: type set to XCeive xc2028/xc3028 tuner
usb 1-4: firmware: requesting xc3028-v27.fw
xc2028 4-0061: Loading 80 firmware images from xc3028-v27.fw, type: xc2028 firmware, ver 2.7
xc2028 4-0061: Loading firmware for type=BASE (1), id 0000000000000000.
xc2028 4-0061: Loading firmware for type=(0), id 000000000000b700.
SCODE (20000000), id 000000000000b700:
xc2028 4-0061: Loading SCODE for type=MONO SCODE HAS_IF_4320 (60008000), id 0000000000008000.
em28xx #0: Config register raw data: 0xd0
em28xx #0: AC97 vendor ID = 0xffffffff
em28xx #0: AC97 features = 0x6a90
em28xx #0: Empia 202 AC97 audio processor detected
tvp5150 4-005c: tvp5150am1 detected.
em28xx #0: v4l2 driver version 0.1.2
em28xx #0: V4L2 device registered as /dev/video0 and /dev/vbi0
usbcore: registered new interface driver em28xx
em28xx driver loaded
em28xx-audio.c: probing for em28x1 non standard usbaudio
em28xx-audio.c: Copyright (C) 2006 Markus Rechberger
Em28xx: Initialized (Em28xx Audio Extension) extension
tvp5150 4-005c: tvp5150am1 detected.
xc2028 4-0061: Loading firmware for type=BASE F8MHZ (3), id 0000000000000000.
xc2028 4-0061: Loading firmware for type=(0), id 0000000100000007.
xc2028 4-0061: Loading SCODE for type=MONO SCODE HAS_IF_5320 (60008000), id 0000000f00000007.

--vkogqOf2sHV7VnPd--
