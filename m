Return-path: <linux-media-owner@vger.kernel.org>
Received: from vbox10718.hkn.net ([213.9.107.18]:38315 "EHLO
	mail.pab-software.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S937264Ab0CPBGX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Mar 2010 21:06:23 -0400
Received: from [192.168.2.100] (unknown [188.108.18.30])
	(using SSLv3 with cipher DHE-RSA-CAMELLIA256-SHA (256/256 bits))
	(No client certificate requested)
	by mail.pab-software.de (Postfix) with ESMTPSA id 4DC104097162
	for <linux-media@vger.kernel.org>; Tue, 16 Mar 2010 01:57:11 +0100 (CET)
Subject: Terratec Cinergy Hybrid T USB XS (no audio)
From: Philippe Bourdin <richel@AngieBecker.ch>
To: linux-media@vger.kernel.org
Content-Type: multipart/mixed; boundary="=-GAuT+JaEgy3C9hOSUBea"
Date: Tue, 16 Mar 2010 01:57:10 +0100
Message-ID: <1268701030.2510.26.camel@andromeda>
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-GAuT+JaEgy3C9hOSUBea
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit


	Hello all,

after a long installation orgy (tried basically everything I could find
on this subject) I now would like to ask the experts: how to get audio?
(I'm on ubuntu Karmic.)

I have the USB TV card: "Terratec Cinergy Hybrid T USB XS"
USB-ID is: "0ccd:0042"
It seems that there are different combinations of chips on those cards,
but I can not really confirm this (just what it seems from the fora).

I got the card "working" on ubuntu Karmic by downloading the firmware:
$ ls -la /lib/firmware/xc3028-v27.fw 
-rw-r--r-- 1 root root 66220   /lib/firmware/xc3028-v27.fw

Then I installed the latest v4l-drivers.
(Btw. I had to remove everything with "firedtv" to get it compiling!)

I now get an image and can select channels, but no matter what I try,
just I get no audio out of the card, which seems to have digital audio.
(I tried to modprobe em28xx_alsa as well.)

I have found this im my dmesg:
[   10.825415] tvp5150 0-005c: *** unknown tvp7e81 chip detected.
(Please find a more complete log attached.)

I'm curious, if card=11 is correct, I was expecting something like
card=55, since the card seems to have a em2882/em2883 chip...?
I tried to force this and got a slightly different dmesg output...


EDIT:
Just now, I got it working for the first time ever, by saying:
> padsp sox -r 48000 -c 2 -t alsa hw:1,0 -t alsa hw:0,0
Would be nice, if the card would work ooTB = without this trick.

Anyways, thanks for your help,

	Philippe Bourdin.


--=-GAuT+JaEgy3C9hOSUBea
Content-Disposition: attachment; filename="dmesg.txt"
Content-Type: text/plain; name="dmesg.txt"; charset="UTF-8"
Content-Transfer-Encoding: 7bit

[  154.814750] Linux video capture interface: v2.00
[  154.827676] usbcore: registered new interface driver em28xx
[  154.827679] em28xx driver loaded
[  154.830958] Em28xx: Initialized (Em28xx Audio Extension) extension
[  162.272248] usb 1-2.3: new high speed USB device using ehci_hcd and address 5
[  162.373468] usb 1-2.3: configuration #1 chosen from 1 choice
[  162.373765] em28xx: New device TerraTec Electronic GmbH Cinergy Hybrid T USB XS @ 480 Mbps (0ccd:0042, interface 0, class 0)
[  162.373866] em28xx #0: chip ID is em2882/em2883
[  162.531857] em28xx #0: i2c eeprom 00: 1a eb 67 95 cd 0c 42 00 50 12 5c 03 6a 32 9c 34
[  162.531887] em28xx #0: i2c eeprom 10: 00 00 06 57 46 07 00 00 00 00 00 00 00 00 00 00
[  162.531914] em28xx #0: i2c eeprom 20: 46 00 01 00 f0 10 31 00 b8 00 14 00 5b 00 00 00
[  162.531941] em28xx #0: i2c eeprom 30: 00 00 20 40 20 6e 02 20 10 01 00 00 00 00 00 00
[  162.531967] em28xx #0: i2c eeprom 40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[  162.531993] em28xx #0: i2c eeprom 50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[  162.532019] em28xx #0: i2c eeprom 60: 00 00 00 00 00 00 00 00 00 00 32 03 43 00 69 00
[  162.532045] em28xx #0: i2c eeprom 70: 6e 00 65 00 72 00 67 00 79 00 20 00 48 00 79 00
[  162.532072] em28xx #0: i2c eeprom 80: 62 00 72 00 69 00 64 00 20 00 54 00 20 00 55 00
[  162.532099] em28xx #0: i2c eeprom 90: 53 00 42 00 20 00 58 00 53 00 00 00 34 03 54 00
[  162.532126] em28xx #0: i2c eeprom a0: 65 00 72 00 72 00 61 00 54 00 65 00 63 00 20 00
[  162.532152] em28xx #0: i2c eeprom b0: 45 00 6c 00 65 00 63 00 74 00 72 00 6f 00 6e 00
[  162.532178] em28xx #0: i2c eeprom c0: 69 00 63 00 20 00 47 00 6d 00 62 00 48 00 00 00
[  162.532205] em28xx #0: i2c eeprom d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[  162.532231] em28xx #0: i2c eeprom e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[  162.532257] em28xx #0: i2c eeprom f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[  162.532287] em28xx #0: EEPROM ID= 0x9567eb1a, EEPROM hash = 0x41d0bf96
[  162.532292] em28xx #0: EEPROM info:
[  162.532296] em28xx #0:	AC97 audio (5 sample rates)
[  162.532300] em28xx #0:	500mA max power
[  162.532305] em28xx #0:	Table at 0x06, strings=0x326a, 0x349c, 0x0000
[  162.533474] em28xx #0: Identified as Terratec Hybrid XS (card=11)
[  162.538981] tvp5150 3-005c: chip found @ 0xb8 (em28xx #0)
[  162.549297] tuner 3-0061: chip found @ 0xc2 (em28xx #0)
[  162.556977] xc2028 3-0061: creating new instance
[  162.556980] xc2028 3-0061: type set to XCeive xc2028/xc3028 tuner
[  162.556986] usb 1-2.3: firmware: requesting xc3028-v27.fw
[  162.563124] xc2028 3-0061: Loading 80 firmware images from xc3028-v27.fw, type: xc2028 firmware, ver 2.7
[  162.609071] xc2028 3-0061: Loading firmware for type=BASE (1), id 0000000000000000.
[  163.525729] xc2028 3-0061: Loading firmware for type=(0), id 000000000000b700.
[  163.541101] SCODE (20000000), id 000000000000b700:
[  163.541114] xc2028 3-0061: Loading SCODE for type=MONO SCODE HAS_IF_4320 (60008000), id 0000000000008000.
[  163.664578] input: em28xx IR (em28xx #0) as /devices/pci0000:00/0000:00:1a.7/usb1/1-2/1-2.3/input/input11
[  163.664706] Creating IR device irrcv0
[  163.664796] em28xx #0: Config register raw data: 0x50
[  163.669790] em28xx #0: AC97 vendor ID = 0xffffffff
[  163.670158] em28xx #0: AC97 features = 0x6a90
[  163.670163] em28xx #0: Empia 202 AC97 audio processor detected
[  163.789605] tvp5150 3-005c: tvp5150am1 detected.
[  163.885034] em28xx #0: v4l2 driver version 0.1.2
[  163.955476] em28xx #0: V4L2 video device registered as video0
[  163.955482] em28xx #0: V4L2 VBI device registered as vbi0
[  163.956173] em28xx audio device (0ccd:0042): interface 1, class 1
[  163.956257] em28xx audio device (0ccd:0042): interface 2, class 1
[  163.987596] usbcore: registered new interface driver snd-usb-audio
[  164.056337] tvp5150 3-005c: i2c i/o error: rc == -19 (should be 1)
[  164.060206] xc2028 3-0061: attaching existing instance
[  164.060209] xc2028 3-0061: type set to XCeive xc2028/xc3028 tuner
[  164.060211] em28xx #0: em28xx #0/2: xc3028 attached
[  164.060213] DVB: registering new adapter (em28xx #0)
[  164.060216] DVB: registering adapter 0 frontend 0 (Zarlink ZL10353 DVB-T)...
[  164.060474] em28xx #0: Successfully loaded em28xx-dvb
[  164.060477] Em28xx: Initialized (Em28xx dvb Extension) extension
[  164.072475] tvp5150 3-005c: i2c i/o error: rc == -19 (should be 1)
[  164.088504] tvp5150 3-005c: i2c i/o error: rc == -19 (should be 1)
[  164.104385] tvp5150 3-005c: i2c i/o error: rc == -19 (should be 1)
[  164.104392] tvp5150 3-005c: *** unknown tvp7e00 chip detected.
[  164.104398] tvp5150 3-005c: *** Rom ver is 0.131
[  164.160420] tvp5150 3-005c: i2c i/o error: rc == -19 (should be 1)
[  164.180429] tvp5150 3-005c: i2c i/o error: rc == -19 (should be 1)
[  164.292612] tvp5150 3-005c: tvp5150am1 detected.

--=-GAuT+JaEgy3C9hOSUBea
Content-Disposition: attachment; filename="dmesg_card-55.txt"
Content-Type: text/plain; name="dmesg_card-55.txt"; charset="UTF-8"
Content-Transfer-Encoding: 7bit

[ 1049.737188] usb 1-2.3: USB disconnect, address 6
[ 1049.737365] em28xx #0: disconnecting em28xx #0 video
[ 1049.737372] em28xx #0: V4L2 device vbi0 deregistered
[ 1049.737490] em28xx #0: V4L2 device video0 deregistered
[ 1060.098165] Em28xx: Removed (Em28xx Audio Extension) extension
[ 1061.641872] usbcore: deregistering interface driver em28xx
[ 1071.104146] usbcore: registered new interface driver em28xx
[ 1071.104154] em28xx driver loaded
[ 1074.268233] Em28xx: Initialized (Em28xx Audio Extension) extension
[ 1080.400211] usb 1-2.3: new high speed USB device using ehci_hcd and address 7
[ 1080.501375] usb 1-2.3: configuration #1 chosen from 1 choice
[ 1080.501675] em28xx: New device TerraTec Electronic GmbH Cinergy Hybrid T USB XS @ 480 Mbps (0ccd:0042, interface 0, class 0)
[ 1080.501776] em28xx #0: chip ID is em2882/em2883
[ 1080.676072] em28xx #0: i2c eeprom 00: 1a eb 67 95 cd 0c 42 00 50 12 5c 03 6a 32 9c 34
[ 1080.676102] em28xx #0: i2c eeprom 10: 00 00 06 57 46 07 00 00 00 00 00 00 00 00 00 00
[ 1080.676129] em28xx #0: i2c eeprom 20: 46 00 01 00 f0 10 31 00 b8 00 14 00 5b 00 00 00
[ 1080.676155] em28xx #0: i2c eeprom 30: 00 00 20 40 20 6e 02 20 10 01 00 00 00 00 00 00
[ 1080.676182] em28xx #0: i2c eeprom 40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[ 1080.676208] em28xx #0: i2c eeprom 50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[ 1080.676234] em28xx #0: i2c eeprom 60: 00 00 00 00 00 00 00 00 00 00 32 03 43 00 69 00
[ 1080.676261] em28xx #0: i2c eeprom 70: 6e 00 65 00 72 00 67 00 79 00 20 00 48 00 79 00
[ 1080.676287] em28xx #0: i2c eeprom 80: 62 00 72 00 69 00 64 00 20 00 54 00 20 00 55 00
[ 1080.676313] em28xx #0: i2c eeprom 90: 53 00 42 00 20 00 58 00 53 00 00 00 34 03 54 00
[ 1080.676340] em28xx #0: i2c eeprom a0: 65 00 72 00 72 00 61 00 54 00 65 00 63 00 20 00
[ 1080.676367] em28xx #0: i2c eeprom b0: 45 00 6c 00 65 00 63 00 74 00 72 00 6f 00 6e 00
[ 1080.676393] em28xx #0: i2c eeprom c0: 69 00 63 00 20 00 47 00 6d 00 62 00 48 00 00 00
[ 1080.676420] em28xx #0: i2c eeprom d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[ 1080.676446] em28xx #0: i2c eeprom e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[ 1080.676472] em28xx #0: i2c eeprom f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[ 1080.676501] em28xx #0: EEPROM ID= 0x9567eb1a, EEPROM hash = 0x41d0bf96
[ 1080.676506] em28xx #0: EEPROM info:
[ 1080.676510] em28xx #0:	AC97 audio (5 sample rates)
[ 1080.676514] em28xx #0:	500mA max power
[ 1080.676520] em28xx #0:	Table at 0x06, strings=0x326a, 0x349c, 0x0000
[ 1080.685679] em28xx #0: Identified as Terratec Hybrid XS (em2882) (card=55)
[ 1080.691111] tvp5150 3-005c: chip found @ 0xb8 (em28xx #0)
[ 1080.696875] tuner 3-0061: chip found @ 0xc2 (em28xx #0)
[ 1080.697075] xc2028 3-0061: creating new instance
[ 1080.697082] xc2028 3-0061: type set to XCeive xc2028/xc3028 tuner
[ 1080.697095] usb 1-2.3: firmware: requesting xc3028-v27.fw
[ 1080.705439] xc2028 3-0061: Loading 80 firmware images from xc3028-v27.fw, type: xc2028 firmware, ver 2.7
[ 1080.756063] xc2028 3-0061: Loading firmware for type=BASE MTS (5), id 0000000000000000.
[ 1081.658822] xc2028 3-0061: Loading firmware for type=MTS (4), id 000000000000b700.
[ 1081.673956] xc2028 3-0061: Loading SCODE for type=MTS LCD NOGD MONO IF SCODE HAS_IF_4500 (6002b004), id 000000000000b700.
[ 1081.796598] input: em28xx IR (em28xx #0) as /devices/pci0000:00/0000:00:1a.7/usb1/1-2/1-2.3/input/input12
[ 1081.796726] Creating IR device irrcv0
[ 1081.796815] em28xx #0: Config register raw data: 0x50
[ 1081.799175] em28xx #0: AC97 vendor ID = 0xffffffff
[ 1081.799554] em28xx #0: AC97 features = 0x6a90
[ 1081.799559] em28xx #0: Empia 202 AC97 audio processor detected
[ 1081.929542] tvp5150 3-005c: tvp5150am1 detected.
[ 1082.025943] em28xx #0: v4l2 driver version 0.1.2
[ 1082.111495] em28xx #0: V4L2 video device registered as video0
[ 1082.111502] em28xx #0: V4L2 VBI device registered as vbi0
[ 1082.207614] xc2028 3-0061: attaching existing instance
[ 1082.207617] xc2028 3-0061: type set to XCeive xc2028/xc3028 tuner
[ 1082.207619] em28xx #0: em28xx #0/2: xc3028 attached
[ 1082.207622] DVB: registering new adapter (em28xx #0)
[ 1082.207625] DVB: registering adapter 0 frontend 0 (Zarlink ZL10353 DVB-T)...
[ 1082.207872] em28xx #0: Successfully loaded em28xx-dvb
[ 1082.207874] Em28xx: Initialized (Em28xx dvb Extension) extension
[ 1082.224909] tvp5150 3-005c: i2c i/o error: rc == -19 (should be 1)
[ 1082.241424] tvp5150 3-005c: i2c i/o error: rc == -19 (should be 1)
[ 1082.260433] tvp5150 3-005c: i2c i/o error: rc == -19 (should be 1)
[ 1082.276434] tvp5150 3-005c: i2c i/o error: rc == -19 (should be 1)
[ 1082.276440] tvp5150 3-005c: *** unknown tvp0081 chip detected.
[ 1082.276446] tvp5150 3-005c: *** Rom ver is 130.131
[ 1082.332457] tvp5150 3-005c: i2c i/o error: rc == -19 (should be 1)
[ 1082.352442] tvp5150 3-005c: i2c i/o error: rc == -19 (should be 1)


--=-GAuT+JaEgy3C9hOSUBea--

