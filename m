Return-path: <linux-media-owner@vger.kernel.org>
Received: from trinity.develer.com ([89.97.188.34]:46928 "EHLO
	trinity.develer.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751675AbZCBWlo (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 2 Mar 2009 17:41:44 -0500
Message-ID: <49AC5F13.7010208@codewiz.org>
Date: Mon, 02 Mar 2009 23:34:59 +0100
From: Bernie Innocenti <bernie@codewiz.org>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Analog TV sound on Cinergy Hybrid T XS
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Ciao,

I don't seem to be getting sound working with tvtime.

I've been trying with v4l code from 2.6.27.15, 2.6.29.rc6 and from
hg head.

devinheitmuller on #v4l suggested me to pipe the sound out from
the alsa device with

  arecord -D hw:1,0 -c 2 -r 48000 -f S16_LE | aplay -

This was made a lot harder by the bloody pulseaudio, but eventually
I think I've got the right channel.

If I dump the recorded data with xxd, all I see is a fainth amount of
noise ranging from 1 to -2 (0xFEFF LE).  There might be some kind of
analog mux, or a gain control?

The AC97 codec seems to be a Sigmatel STAC 9752.  There's no special
casing in the em28xx code for it.


dmesg output follows:

usbcore: registered new interface driver snd-usb-audio
usb 2-4: USB disconnect, address 4
usb 2-4: new high speed USB device using ehci_hcd and address 5
usb 2-4: configuration #1 chosen from 1 choice
usb 2-4: New USB device found, idVendor=0ccd, idProduct=0042
usb 2-4: New USB device strings: Mfr=2, Product=1, SerialNumber=0
usb 2-4: Product: Cinergy Hybrid T USB XS
usb 2-4: Manufacturer: TerraTec Electronic GmbH
em28xx: New device TerraTec Electronic GmbH Cinergy Hybrid T USB XS @ 480 Mbps (0ccd:0042, interface 0, class 0)
em28xx #0: Identified as Terratec Hybrid XS (card=11)
em28xx #0: chip ID is em2882/em2883
em28xx #0: i2c eeprom 00: 1a eb 67 95 cd 0c 42 00 50 12 5c 03 6a 32 9c 34
em28xx #0: i2c eeprom 10: 00 00 06 57 46 07 00 00 00 00 00 00 00 00 00 00
em28xx #0: i2c eeprom 20: 46 00 01 00 f0 10 31 00 b8 00 14 00 5b 00 00 00
em28xx #0: i2c eeprom 30: 00 00 20 40 20 6e 02 20 10 01 00 00 00 00 00 00
em28xx #0: i2c eeprom 40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
em28xx #0: i2c eeprom 50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
em28xx #0: i2c eeprom 60: 00 00 00 00 00 00 00 00 00 00 32 03 43 00 69 00
em28xx #0: i2c eeprom 70: 6e 00 65 00 72 00 67 00 79 00 20 00 48 00 79 00
em28xx #0: i2c eeprom 80: 62 00 72 00 69 00 64 00 20 00 54 00 20 00 55 00
em28xx #0: i2c eeprom 90: 53 00 42 00 20 00 58 00 53 00 00 00 34 03 54 00
em28xx #0: i2c eeprom a0: 65 00 72 00 72 00 61 00 54 00 65 00 63 00 20 00
em28xx #0: i2c eeprom b0: 45 00 6c 00 65 00 63 00 74 00 72 00 6f 00 6e 00
em28xx #0: i2c eeprom c0: 69 00 63 00 20 00 47 00 6d 00 62 00 48 00 00 00
em28xx #0: i2c eeprom d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
em28xx #0: i2c eeprom e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
em28xx #0: i2c eeprom f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
em28xx #0: EEPROM ID= 0x9567eb1a, EEPROM hash = 0x41d0bf96
em28xx #0: EEPROM info:
em28xx #0:	AC97 audio (5 sample rates)
em28xx #0:	500mA max power
em28xx #0:	Table at 0x06, strings=0x326a, 0x349c, 0x0000
tvp5150\' 1-005c: chip found @ 0xb8 (em28xx #0)
tuner\' 1-0061: chip found @ 0xc2 (em28xx #0)
xc2028 1-0061: creating new instance
xc2028 1-0061: type set to XCeive xc2028/xc3028 tuner
firmware: requesting xc3028-v27.fw
xc2028 1-0061: Loading 80 firmware images from xc3028-v27.fw, type: xc2028 firmware, ver 2.7
xc2028 1-0061: Loading firmware for type=BASE (1), id 0000000000000000.
xc2028 1-0061: Loading firmware for type=(0), id 000000000000b700.
SCODE (20000000), id 000000000000b700:
xc2028 1-0061: Loading SCODE for type=MONO SCODE HAS_IF_4320 (60008000), id 0000000000008000.
em28xx #0: Config register raw data: 0x50
em28xx #0: AC97 vendor ID = 0x83847652
em28xx #0: AC97 features = 0x6a90
em28xx #0: Sigmatel audio processor detected(stac 9752)
tvp5150\' 1-005c: tvp5150am1 detected.
em28xx #0: v4l2 driver version 0.1.1
em28xx #0: V4L2 device registered as /dev/video0 and /dev/vbi0
usbcore: registered new interface driver em28xx
em28xx driver loaded
zl10353_read_register: readreg error (reg=127, ret==-19)
em28xx #0/2: dvb frontend not attached. Can\'t attach xc3028
Em28xx: Initialized (Em28xx dvb Extension) extension
tvp5150\' 1-005c: tvp5150am1 detected.
xc2028 1-0061: Loading firmware for type=BASE F8MHZ (3), id 0000000000000000.
(0), id 00000000000000ff:
xc2028 1-0061: Loading firmware for type=(0), id 0000000100000007.
SCODE (20000000), id 0000000100000007:
xc2028 1-0061: Loading SCODE for type=MONO SCODE HAS_IF_5320 (60008000), id 0000000800000007.
xc2028 1-0061: Loading firmware for type=(0), id 0000000000000010.
xc2028 1-0061: Loading SCODE for type=MONO SCODE HAS_IF_6000 (60008000), id 0000000000000010.
(0), id 00000000000000ff:
xc2028 1-0061: Loading firmware for type=(0), id 0000000100000007.
SCODE (20000000), id 0000000100000007:
xc2028 1-0061: Loading SCODE for type=MONO SCODE HAS_IF_5320 (60008000), id 0000000800000007.
xc2028 1-0061: Loading firmware for type=(0), id 00000003000000e0.
xc2028 1-0061: Loading SCODE for type=SCODE HAS_IF_6600 (60000000), id 00000003000000e0.
xc2028 1-0061: Loading firmware for type=(0), id 0000000000000010.
xc2028 1-0061: Loading SCODE for type=MONO SCODE HAS_IF_6000 (60008000), id 0000000000000010.
tvp5150\' 1-005c: tvp5150am1 detected.
(0), id 00000000000000ff:
xc2028 1-0061: Loading firmware for type=(0), id 0000000100000007.
SCODE (20000000), id 0000000100000007:

-- 
   // Bernie Innocenti - http://www.codewiz.org/
 \X/  Sugar Labs       - http://www.sugarlabs.org/
