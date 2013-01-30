Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:55992 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753841Ab3A3M7r (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 30 Jan 2013 07:59:47 -0500
Received: from mailout-de.gmx.net ([10.1.76.28]) by mrigmx.server.lan
 (mrigmx001) with ESMTP (Nemesis) id 0LwCv2-1V4Cek2f1i-01816t for
 <linux-media@vger.kernel.org>; Wed, 30 Jan 2013 13:59:44 +0100
Message-ID: <5109193E.1030406@gmx.de>
Date: Wed, 30 Jan 2013 13:59:42 +0100
From: Ruwen <ts_tequila@gmx.de>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: em28xx: Terratec Cinergy T USB XS (USBID: 0ccd:0043) does not work
Content-Type: multipart/mixed;
 boundary="------------040007050103070108080004"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------040007050103070108080004
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi!

I tried to get my DVB-T-Stick working, but without success.

Errormessage:

	em28xx_dvb: This device does not support the extension

The linuxtv.org-wiki 
(http://linuxtv.org/wiki/index.php/Em28xx_devices#How_to_validate_my_vendor.2Fproduct_id_at_upstream_kernel.3F) 
pointed me to this mailing list in order to report working/not working.

My device:
Bus 004 Device 012: ID 0ccd:0043 TerraTec Electronic GmbH Cinergy T XS

I downloaded the firmware using this tutorial:
http://www.linuxtv.org/wiki/index.php/Xceive_XC3028/XC2028#How_to_Obtain_the_Firmware

For dmesg-Output after plugging in the stick, please see attachment.

After manually loading the module em28xx, the dmesg prints:

[  129.873882] em28xx_dvb: This device does not support the extension
[  129.873886] Em28xx: Initialized (Em28xx dvb Extension) extension

My kernel version:
Linux ruwen 3.7.5ruwenkernel #3 SMP Tue Jan 29 22:55:32 CET 2013 x86_64 
GNU/Linux

My stick is missing in the em28xx-dvb.c file. How can i find out which 
frontend is the right one? Or is there another solution?

Cheers
Ruwen

--------------040007050103070108080004
Content-Type: text/x-log;
 name="dmesg1.log"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="dmesg1.log"

[   64.550508] usb 4-1.2.3: new high-speed USB device number 12 using ehci_hcd
[   64.650128] usb 4-1.2.3: New USB device found, idVendor=0ccd, idProduct=0043
[   64.650132] usb 4-1.2.3: New USB device strings: Mfr=2, Product=1, SerialNumber=0
[   64.650141] usb 4-1.2.3: Product: Cinergy T USB XS
[   64.650143] usb 4-1.2.3: Manufacturer: TerraTec Electronic GmbH
[   64.676869] em28xx: New device TerraTec Electronic GmbH Cinergy T USB XS @ 480 Mbps (0ccd:0043, interface 0, class 0)
[   64.676872] em28xx: Video interface 0 found
[   64.676873] em28xx: DVB interface 0 found
[   64.676934] em28xx #0: chip ID is em2870
[   64.804925] em28xx #0: i2c eeprom 00: 1a eb 67 95 cd 0c 43 00 c0 12 81 00 6a 24 8e 34
[   64.804933] em28xx #0: i2c eeprom 10: 00 00 06 57 02 0c 00 00 00 00 00 00 00 00 00 00
[   64.804938] em28xx #0: i2c eeprom 20: 44 00 00 00 f0 10 01 00 00 00 00 00 5b 00 00 00
[   64.804944] em28xx #0: i2c eeprom 30: 00 00 20 40 20 80 02 20 01 01 00 00 6c d2 05 4a
[   64.804949] em28xx #0: i2c eeprom 40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[   64.804955] em28xx #0: i2c eeprom 50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[   64.804960] em28xx #0: i2c eeprom 60: 00 00 00 00 00 00 00 00 00 00 24 03 43 00 69 00
[   64.804965] em28xx #0: i2c eeprom 70: 6e 00 65 00 72 00 67 00 79 00 20 00 54 00 20 00
[   64.804971] em28xx #0: i2c eeprom 80: 55 00 53 00 42 00 20 00 58 00 53 00 00 00 34 03
[   64.804976] em28xx #0: i2c eeprom 90: 54 00 65 00 72 00 72 00 61 00 54 00 65 00 63 00
[   64.804982] em28xx #0: i2c eeprom a0: 20 00 45 00 6c 00 65 00 63 00 74 00 72 00 6f 00
[   64.804987] em28xx #0: i2c eeprom b0: 6e 00 69 00 63 00 20 00 47 00 6d 00 62 00 48 00
[   64.804993] em28xx #0: i2c eeprom c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[   64.804998] em28xx #0: i2c eeprom d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[   64.805003] em28xx #0: i2c eeprom e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[   64.805009] em28xx #0: i2c eeprom f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[   64.805016] em28xx #0: EEPROM ID= 0x9567eb1a, EEPROM hash = 0xc39927dc
[   64.805017] em28xx #0: EEPROM info:
[   64.805018] em28xx #0:	No audio on board.
[   64.805019] em28xx #0:	500mA max power
[   64.805021] em28xx #0:	Table at 0x06, strings=0x246a, 0x348e, 0x0000
[   64.805023] em28xx #0: Identified as Terratec Cinergy T XS (card=43)
[   64.805025] em28xx #0: 
[   64.805025] 
[   64.805027] em28xx #0: The support for this board weren't valid yet.
[   64.805028] em28xx #0: Please send a report of having this working
[   64.805029] em28xx #0: not to V4L mailing list (and/or to other addresses)
[   64.805029] 
[   64.814148] Chip ID is not zero. It is not a TEA5767
[   64.814154] tuner 7-0060: Tuner -1 found with type(s) Radio TV.
[   64.816870] xc2028 7-0060: creating new instance
[   64.816874] xc2028 7-0060: type set to XCeive xc2028/xc3028 tuner
[   64.816941] em28xx #0: v4l2 driver version 0.1.3
[   64.817388] xc2028 7-0060: Loading 80 firmware images from xc3028-v27.fw, type: xc2028 firmware, ver 2.7
[   64.821673] em28xx #0: V4L2 video device registered as video1
[   64.822820] usbcore: registered new interface driver em28xx


--------------040007050103070108080004--
