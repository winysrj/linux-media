Return-path: <mchehab@pedra>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:50448 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753935Ab1BTPNU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 20 Feb 2011 10:13:20 -0500
Received: by wwa36 with SMTP id 36so5310495wwa.1
        for <linux-media@vger.kernel.org>; Sun, 20 Feb 2011 07:13:19 -0800 (PST)
MIME-Version: 1.0
Date: Sun, 20 Feb 2011 20:43:18 +0530
Message-ID: <AANLkTikNESFqYNT7Gu2vE4yMeDhCCSu0BkeRhEmVbR3y@mail.gmail.com>
Subject: utv 330 : gadmei USB 2860 Device : No Audio
From: Pranjal Pandey <pranjal8128@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

I am trying to use UTV 330 tv tuner card to watch tv on my laptop. I
am using Ubuntu 10.10 with 2.6.35 kernel. To play the tv i use

tvtime -d /dev/video1

Tvtime plays the video properly but there is no audio.

The output of dmesg is ::::
[   93.500070] usb 2-1: new high speed USB device using ehci_hcd and address 4
[   93.675250] em28xx: New device gadmei USB 2860 Device @ 480 Mbps
(eb1a:2860, interface 0, class 0)
[   93.675570] em28xx #0: chip ID is em2860
[   93.838407] em28xx #0: i2c eeprom 00: 1a eb 67 95 1a eb 60 28 c0 00
13 03 7a 22 6a 10
[   93.838418] em28xx #0: i2c eeprom 10: 00 00 06 57 4e 03 00 00 00 00
00 00 00 00 00 00
[   93.838427] em28xx #0: i2c eeprom 20: 06 00 00 02 f0 10 01 00 4a 00
00 00 5b 00 00 00
[   93.838436] em28xx #0: i2c eeprom 30: 00 00 20 40 20 80 02 20 01 01
02 01 00 00 00 00
[   93.838445] em28xx #0: i2c eeprom 40: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[   93.838454] em28xx #0: i2c eeprom 50: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[   93.838463] em28xx #0: i2c eeprom 60: 00 00 00 00 00 00 00 00 00 00
10 03 67 00 61 00
[   93.838471] em28xx #0: i2c eeprom 70: 64 00 6d 00 65 00 69 00 00 00
22 03 55 00 53 00
[   93.838480] em28xx #0: i2c eeprom 80: 42 00 20 00 32 00 38 00 36 00
30 00 20 00 44 00
[   93.838489] em28xx #0: i2c eeprom 90: 65 00 76 00 69 00 63 00 65 00
00 00 00 00 00 00
[   93.838498] em28xx #0: i2c eeprom a0: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[   93.838506] em28xx #0: i2c eeprom b0: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[   93.838515] em28xx #0: i2c eeprom c0: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[   93.838524] em28xx #0: i2c eeprom d0: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[   93.838533] em28xx #0: i2c eeprom e0: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[   93.838541] em28xx #0: i2c eeprom f0: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[   93.838551] em28xx #0: EEPROM ID= 0x9567eb1a, EEPROM hash = 0xaed2249a
[   93.838553] em28xx #0: EEPROM info:
[   93.838554] em28xx #0: No audio on board.
[   93.838556] em28xx #0: 500mA max power
[   93.838558] em28xx #0: Table at 0x06, strings=0x227a, 0x106a, 0x0000
[   93.850527] em28xx #0: Identified as Unknown EM2750/28xx video
grabber (card=1)
[   93.864755] em28xx #0: found i2c device @ 0x4a [saa7113h]
[   93.880884] em28xx #0: found i2c device @ 0xa0 [eeprom]
[   93.886882] em28xx #0: found i2c device @ 0xc0 [tuner (analog)]
[   93.898489] em28xx #0: Your board has no unique USB ID.
[   93.898492] em28xx #0: A hint were successfully done, based on i2c
devicelist hash.
[   93.898495] em28xx #0: This method is not 100% failproof.
[   93.898497] em28xx #0: If the board were missdetected, please email
this log to:
[   93.898499] em28xx #0:  V4L Mailing List  <linux-media@vger.kernel.org>
[   93.898501] em28xx #0: Board detected as Gadmei UTV330+
[   94.490583] saa7115 0-0025: saa7113 found (1f7113d0e100000) @ 0x4a
(em28xx #0)
[   95.677856] All bytes are equal. It is not a TEA5767
[   95.678014] tuner 0-0060: chip found @ 0xc0 (em28xx #0)
[   95.678616] tuner-simple 0-0060: creating new instance
[   95.678623] tuner-simple 0-0060: type set to 69 (Tena TNF 5335 and
similar models)
[   95.730047] Registered IR keymap rc-gadmei-rm008z
[   95.730198] input: em28xx IR (em28xx #0) as
/devices/pci0000:00/0000:00:1d.7/usb2/2-1/rc/rc0/input15
[   95.730304] rc0: em28xx IR (em28xx #0) as
/devices/pci0000:00/0000:00:1d.7/usb2/2-1/rc/rc0
[   95.750213] em28xx #0: Config register raw data: 0xc0
[   95.830063] em28xx #0: v4l2 driver version 0.1.2
[   96.650253] em28xx #0: V4L2 video device registered as video1
[   96.650258] em28xx #0: V4L2 VBI device registered as vbi0
[   96.650297] usbcore: registered new interface driver em28xx
[   96.650301] em28xx driver loaded

I have a lineout in the device. I have tried connecting earphone to
the lineout but there is no audio (seems like there is no signal). I
also used following with no improvements:
arecord -D hw:0,0 -c 2 -f S16_LE | aplay

>From the dmesg output i can see a few things wrongly detected. First
it says that there is no audio on board but the device has a lineout
and hence some codec (on board audio). The second thing is   that the
board i detected as "Gadmei UTV330+" and not as "Gadmei UTV330".

The output of lsusb is:
Bus 002 Device 004: ID eb1a:2860 eMPIA Technology, Inc.

I checked the driver files. In em28xx-cards.c "Gadmei UTV330+"
corresponds to "EM2861_BOARD_GADMEI_UTV330PLUS" but from lsusb i know
that the device is em2860 and not em2861.

I have also checked the device in windows and it works fine. Does
anyone has any clue whats wrong here. Any suggestions ? Has anyone
successfully used this card in linux ?

Thanks
Pranjal
