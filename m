Return-path: <mchehab@pedra>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:33285 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756442Ab0HPWpr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Aug 2010 18:45:47 -0400
Received: by wyb32 with SMTP id 32so6235668wyb.19
        for <linux-media@vger.kernel.org>; Mon, 16 Aug 2010 15:45:46 -0700 (PDT)
Message-ID: <4C69BF98.5040402@gmail.com>
Date: Tue, 17 Aug 2010 00:45:44 +0200
From: Alberto Segura <asgsb09@gmail.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: strange way to make my dvb device works...
Content-Type: multipart/mixed;
 boundary="------------030406030404080709040700"
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

This is a multi-part message in MIME format.
--------------030406030404080709040700
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

  Hello,

I use a Bestbuy easy-tv hybrid pro usb dongle as my dvb-t device based 
on em28xx for watching tv. I got the latest code from v4l-dvb hg 
repository recently (thx Douglas) and works perfectly under 2.6.35 
custom kernel with firmware xc3028-v27 extracted with the perl script as 
wiki said. But I have an issue to report...

This device isn't recognized automatically and dmesg suggests my to 
choose one card. Curiously, I have to write this commands (as one user 
recommends) to make it work correctly:

* sudo rmmod em28xx
* sudo modprobe em28xx card=10
* sudo rmmod em28xx-dvb
*sudo rmmod em28xx
*sudo modprobe em28xx card=11

Maybe there's something to fix this!

Thanks and congratulations!

Alberto.

P.D. I attach em28xx dmesg report for card 11 as text file.

--------------030406030404080709040700
Content-Type: text/plain;
 name="my_dmesg_card11.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="my_dmesg_card11.txt"


[  316.934137] em28xx: New device USB 2881 Video @ 480 Mbps (eb1a:2881, interface 0, class 0)
[  316.934244] em28xx #0: chip ID is em2882/em2883
[  317.118340] em28xx #0: i2c eeprom 00: 1a eb 67 95 1a eb 81 28 58 12 5c 00 6a 20 6a 00
[  317.118353] em28xx #0: i2c eeprom 10: 00 00 04 57 64 57 00 00 60 f4 00 00 02 02 00 00
[  317.118364] em28xx #0: i2c eeprom 20: 56 00 01 00 00 00 01 00 b8 00 00 00 5b 1e 00 00
[  317.118376] em28xx #0: i2c eeprom 30: 00 00 20 40 20 80 02 20 10 02 00 00 00 00 00 00
[  317.118387] em28xx #0: i2c eeprom 40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[  317.118398] em28xx #0: i2c eeprom 50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[  317.118409] em28xx #0: i2c eeprom 60: 00 00 00 00 00 00 00 00 00 00 20 03 55 00 53 00
[  317.118420] em28xx #0: i2c eeprom 70: 42 00 20 00 32 00 38 00 38 00 31 00 20 00 56 00
[  317.118431] em28xx #0: i2c eeprom 80: 69 00 64 00 65 00 6f 00 00 00 00 00 00 00 00 00
[  317.118442] em28xx #0: i2c eeprom 90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[  317.118453] em28xx #0: i2c eeprom a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[  317.118464] em28xx #0: i2c eeprom b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[  317.118475] em28xx #0: i2c eeprom c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[  317.118486] em28xx #0: i2c eeprom d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[  317.118497] em28xx #0: i2c eeprom e0: 5a 00 55 aa b2 60 58 03 00 17 fc 01 00 00 00 00
[  317.118508] em28xx #0: i2c eeprom f0: 02 00 00 01 00 00 00 00 00 00 00 00 00 00 00 00
[  317.118521] em28xx #0: EEPROM ID= 0x9567eb1a, EEPROM hash = 0x09910020
[  317.118523] em28xx #0: EEPROM info:
[  317.118525] em28xx #0:	AC97 audio (5 sample rates)
[  317.118527] em28xx #0:	USB Remote wakeup capable
[  317.118529] em28xx #0:	500mA max power
[  317.118532] em28xx #0:	Table at 0x04, strings=0x206a, 0x006a, 0x0000
[  317.119582] em28xx #0: Identified as Terratec Hybrid XS (card=11)
[  317.121532] tvp5150 3-005c: chip found @ 0xb8 (em28xx #0)
[  317.126250] tuner 3-0061: chip found @ 0xc2 (em28xx #0)
[  317.126356] xc2028 3-0061: creating new instance
[  317.126359] xc2028 3-0061: type set to XCeive xc2028/xc3028 tuner
[  317.128316] xc2028 3-0061: Loading 80 firmware images from xc3028-v27.fw, type: xc2028 firmware, ver 2.7
[  317.181276] xc2028 3-0061: Loading firmware for type=BASE (1), id 0000000000000000.
[  318.090946] xc2028 3-0061: Loading firmware for type=(0), id 000000000000b700.
[  318.104572] SCODE (20000000), id 000000000000b700:
[  318.104577] xc2028 3-0061: Loading SCODE for type=MONO SCODE HAS_IF_4320 (60008000), id 0000000000008000.
[  318.231522] Registered IR keymap rc-terratec-cinergy-xs
[  318.231627] input: em28xx IR (em28xx #0) as /devices/pci0000:00/0000:00:1d.7/usb2/2-5/rc/rc0/input8
[  318.231690] rc0: em28xx IR (em28xx #0) as /devices/pci0000:00/0000:00:1d.7/usb2/2-5/rc/rc0
[  318.232208] em28xx #0: Config register raw data: 0x58
[  318.233011] em28xx #0: AC97 vendor ID = 0xffffffff
[  318.233390] em28xx #0: AC97 features = 0x6a90
[  318.233393] em28xx #0: Empia 202 AC97 audio processor detected
[  318.371715] tvp5150 3-005c: tvp5150am1 detected.
[  318.472132] em28xx #0: v4l2 driver version 0.1.2
[  318.558532] em28xx #0: V4L2 video device registered as video1
[  318.558536] em28xx #0: V4L2 VBI device registered as vbi0
[  318.559173] usbcore: registered new interface driver em28xx
[  318.559176] em28xx driver loaded
[  318.681738] tvp5150 3-005c: tvp5150am1 detected.
[  318.822150] xc2028 3-0061: attaching existing instance
[  318.822154] xc2028 3-0061: type set to XCeive xc2028/xc3028 tuner
[  318.822157] em28xx #0: em28xx #0/2: xc3028 attached
[  318.822160] DVB: registering new adapter (em28xx #0)
[  318.822164] DVB: registering adapter 0 frontend 0 (Zarlink ZL10353 DVB-T)...
[  318.822541] em28xx #0: Successfully loaded em28xx-dvb
[  318.822547] Em28xx: Initialized (Em28xx dvb Extension) extension
[  318.941749] tvp5150 3-005c: tvp5150am1 detected.


--------------030406030404080709040700--
