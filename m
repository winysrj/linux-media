Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f213.google.com ([209.85.220.213]:45054 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750841AbZLVPLw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Dec 2009 10:11:52 -0500
Received: by fxm5 with SMTP id 5so5980236fxm.28
        for <linux-media@vger.kernel.org>; Tue, 22 Dec 2009 07:11:50 -0800 (PST)
MIME-Version: 1.0
From: Valerio Bontempi <valerio.bontempi@gmail.com>
Date: Tue, 22 Dec 2009 16:11:30 +0100
Message-ID: <ad6681df0912220711p2666f0f5m84317a7bf0ffc137@mail.gmail.com>
Subject: em28xx driver - xc3028 tuner - readreg error
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

today, after I have just installed an update for v4l-lib and
v4l-lib-devel opensuse 11.2 packages, my v4l-dvb driver (compiled from
sources) does not work anymore
Just looking to dmesg output I find

[  806.721162] em28xx: New device TerraTec Electronic GmbH Cinergy T
USB XS @ 480 Mbps (0ccd:0043, interface 0, class 0)
[  806.721353] em28xx #0: chip ID is em2870
[  806.833068] em28xx #0: i2c eeprom 00: 1a eb 67 95 cd 0c 43 00 c0 12
5c 00 9e 24 6a 34
[  806.833096] em28xx #0: i2c eeprom 10: 00 00 06 57 02 0c 00 00 00 00
00 00 00 00 00 00
[  806.833117] em28xx #0: i2c eeprom 20: 44 00 00 00 f0 10 01 00 00 00
00 00 5b 00 00 00
[  806.833138] em28xx #0: i2c eeprom 30: 00 00 20 40 20 80 02 20 01 01
00 00 00 00 00 00
[  806.833158] em28xx #0: i2c eeprom 40: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[  806.833178] em28xx #0: i2c eeprom 50: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[  806.833198] em28xx #0: i2c eeprom 60: 00 00 00 00 00 00 00 00 00 00
34 03 54 00 65 00
[  806.833218] em28xx #0: i2c eeprom 70: 72 00 72 00 61 00 54 00 65 00
63 00 20 00 45 00
[  806.833238] em28xx #0: i2c eeprom 80: 6c 00 65 00 63 00 74 00 72 00
6f 00 6e 00 69 00
[  806.833258] em28xx #0: i2c eeprom 90: 63 00 20 00 47 00 6d 00 62 00
48 00 00 00 24 03
[  806.833279] em28xx #0: i2c eeprom a0: 43 00 69 00 6e 00 65 00 72 00
67 00 79 00 20 00
[  806.833299] em28xx #0: i2c eeprom b0: 54 00 20 00 55 00 53 00 42 00
20 00 58 00 53 00
[  806.833319] em28xx #0: i2c eeprom c0: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[  806.833339] em28xx #0: i2c eeprom d0: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[  806.833359] em28xx #0: i2c eeprom e0: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[  806.833379] em28xx #0: i2c eeprom f0: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[  806.833401] em28xx #0: EEPROM ID= 0x9567eb1a, EEPROM hash = 0xbfdf1b96
[  806.833409] em28xx #0: EEPROM info:
[  806.833414] em28xx #0:       No audio on board.
[  806.833419] em28xx #0:       500mA max power
[  806.833425] em28xx #0:       Table at 0x06, strings=0x249e, 0x346a, 0x0000
[  806.834138] em28xx #0: Identified as Terratec Cinergy T XS (card=43)
[  806.834289] em28xx #0:
[  806.834290]
[  806.834297] em28xx #0: The support for this board weren't valid yet.
[  806.834305] em28xx #0: Please send a report of having this working
[  806.834312] em28xx #0: not to V4L mailing list (and/or to other addresses)
[  806.834314]
[  806.842097] tuner 2-0061: chip found @ 0xc2 (em28xx #0)
[  806.842263] xc2028 2-0061: creating new instance
[  806.842271] xc2028 2-0061: type set to XCeive xc2028/xc3028 tuner
[  806.842288] usb 1-4: firmware: requesting xc3028-v27.fw
[  806.853287] xc2028 2-0061: Loading 80 firmware images from
xc3028-v27.fw, type: xc2028 firmware, ver 2.7
[  806.886020] xc2028 2-0061: Loading firmware for type=BASE (1), id
0000000000000000.
[  808.284017] xc2028 2-0061: Loading firmware for type=(0), id
000000000000b700.
[  808.310009] SCODE (20000000), id 000000000000b700:
[  808.310020] xc2028 2-0061: Loading SCODE for type=MONO SCODE
HAS_IF_4320 (60008000), id 0000000000008000.
[  808.433021] em28xx #0: v4l2 driver version 0.1.2
[  808.437908] em28xx #0: V4L2 video device registered as /dev/video1
[  808.441137] usbcore: registered new interface driver em28xx
[  808.441154] em28xx driver loaded
[  808.562319] zl10353_read_register: readreg error (reg=127, ret==-19)
[  808.562937] mt352_read_register: readreg error (reg=127, ret==-19)
[  808.563050] em28xx #0: /2: dvb frontend not attached. Can't attach xc3028
[  808.563061] Em28xx: Initialized (Em28xx dvb Extension) extension


Before the update, v4l-dvb driver worked fine, and now it doesn't work
even if I remove the updated packages.
Checking for kernel modules conflict, I found only the modules
installed by v4l-dvb sources.
#find /lib/modules/`uname -r` -name 'em28xx*' | xargs -i ls -l {}
totale 236
-rw-r--r-- 1 root root 21464 22 dic 16:03
/lib/modules/2.6.31.5-0.1-desktop/kernel/drivers/media/video/em28xx/em28xx-alsa.ko
-rw-r--r-- 1 root root 26176 22 dic 16:03
/lib/modules/2.6.31.5-0.1-desktop/kernel/drivers/media/video/em28xx/em28xx-dvb.ko
-rw-r--r-- 1 root root 184936 22 dic 16:03
/lib/modules/2.6.31.5-0.1-desktop/kernel/drivers/media/video/em28xx/em28xx.ko

Which could be the reason of readreg error?


Thanks and regars

Valerio
