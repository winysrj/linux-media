Return-path: <linux-media-owner@vger.kernel.org>
Received: from impaqm1.telefonica.net ([213.4.138.1]:58142 "EHLO
	IMPaqm1.telefonica.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752186Ab0CSVLY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 19 Mar 2010 17:11:24 -0400
From: "Inet" <inet_swor@telefonica.net>
To: <linux-media@vger.kernel.org>
Subject: Help with Conceptronic CHVIDEOCR 1b80: e34e
Date: Fri, 19 Mar 2010 22:05:32 +0100
Message-ID: <!&!AAAAAAAAAAAYAAAAAAAAAC8QqRo14epHl0GiWaz2tEzCgAAAEAAAAIwzmdNRGmdBo5vY9QinTY8BAAAAAA==@telefonica.net>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Language: es
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello. I recently purchased a CHVIDEOCR conceptronic device, but is not
detected in opensuse 11.2 after having compiled and installed the latest
v4l-dvb. 

The vendor and product ID is 1b80:e34e.

I tried to make it work with the em28xx module with ID card 9 (not fully
recognized) and 19 (system hangs). This is the dmesg output with card = 19.

#modprobe em28xx card=19 i2c_scan=0
#echo 1b80 e34e > /sys/bus/usb/drivers/em28xx/new_id

[25994.968035] usb 1-6: new high speed USB device using ehci_hcd and address
2                 
[25995.085408] usb 1-6: New USB device found, idVendor=1b80, idProduct=e34e

[25995.085421] usb 1-6: New USB device strings: Mfr=0, Product=1,
SerialNumber=0               
[25995.085428] usb 1-6: Product: USB 2863 Device

[25995.085545] usb 1-6: configuration #1 chosen from 1 choice

[26024.365635] usbcore: registered new interface driver em28xx

[26024.365649] em28xx driver loaded

[26033.874447] em28xx: New device USB 2863 Device @ 480 Mbps (1b80:e34e,
interface 0, class 0) 
[26033.874608] em28xx #0: chip ID is em2860

[26033.973167] em28xx #0: i2c eeprom 00: 1a eb 67 95 80 1b 4e e3 50 00 20 03
6a 20 00 00       
[26033.973189] em28xx #0: i2c eeprom 10: 00 00 04 57 06 02 00 00 00 00 00 00
00 00 00 00       
[26033.973207] em28xx #0: i2c eeprom 20: 02 00 01 00 f0 00 01 00 00 00 00 00
5b 00 00 00       
[26033.973224] em28xx #0: i2c eeprom 30: 00 00 20 40 20 80 02 20 01 01 02 01
00 00 00 00       
[26033.973241] em28xx #0: i2c eeprom 40: 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00       
[26033.973258] em28xx #0: i2c eeprom 50: 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00       
[26033.973274] em28xx #0: i2c eeprom 60: 00 00 00 00 00 00 00 00 00 00 20 03
55 00 53 00       
[26033.973291] em28xx #0: i2c eeprom 70: 42 00 20 00 32 00 38 00 36 00 33 00
20 00 44 00       
[26033.973307] em28xx #0: i2c eeprom 80: 65 00 76 00 69 00 63 00 65 00 00 00
00 00 00 00       
[26033.973324] em28xx #0: i2c eeprom 90: 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00       
[26033.973340] em28xx #0: i2c eeprom a0: 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00       
[26033.973357] em28xx #0: i2c eeprom b0: 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00       
[26033.973373] em28xx #0: i2c eeprom c0: 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00       
[26033.973390] em28xx #0: i2c eeprom d0: 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00       
[26033.973406] em28xx #0: i2c eeprom e0: 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00       
[26033.973422] em28xx #0: i2c eeprom f0: 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00       
[26033.973440] em28xx #0: EEPROM ID= 0x9567eb1a, EEPROM hash = 0x559a2440

[26033.973446] em28xx #0: EEPROM info:
[26033.973451] em28xx #0:       AC97 audio (5 sample rates)
[26033.973456] em28xx #0:       500mA max power
[26033.973462] em28xx #0:       Table at 0x04, strings=0x206a, 0x0000,
0x0000
[26033.974539] em28xx #0: Identified as EM2860/SAA711X Reference Design
(card=19)
[26033.974549] em28xx #0: Registering snapshot button...
[26033.974609] input: em28xx snapshot button as
/devices/pci0000:00/0000:00:1a.7/usb1/1-6/input/input7
[26034.209521] saa7115 4-0025: saa7113 found (1f7113d0e100000) @ 0x4a
(em28xx #0)
[26034.581286] em28xx #0: Config register raw data: 0x50
[26034.595147] em28xx #0: AC97 vendor ID = 0xffffffff
[26034.601396] em28xx #0: AC97 features = 0x6a90
[26034.601404] em28xx #0: Empia 202 AC97 audio processor detected
[26034.848010] em28xx #0: v4l2 driver version 0.1.2
[26035.320116] em28xx #0: V4L2 video device registered as video1
[26035.320127] em28xx #0: V4L2 VBI device registered as vbi1
[26035.376728] em28xx-audio.c: probing for em28x1 non standard usbaudio
[26035.376740] em28xx-audio.c: Copyright (C) 2006 Markus Rechberger
[26035.377123] Em28xx: Initialized (Em28xx Audio Extension) extension

 I opened the device and these are its components: 

- usb video capture EM2862
- Single chip dual channel AC'97 EMP202
- NXP SAA7113H decoder.


 Can you help me? Thanks

