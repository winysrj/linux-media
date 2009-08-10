Return-path: <linux-media-owner@vger.kernel.org>
Received: from mp1-smtp-5.eutelia.it ([62.94.10.165]:57380 "EHLO
	smtp.eutelia.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753453AbZHJW2H (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Aug 2009 18:28:07 -0400
Received: from [192.168.1.170] (ip-173-192.sn3.eutelia.it [213.136.173.192])
	by smtp.eutelia.it (Eutelia) with ESMTP id 57AFF1039C8
	for <linux-media@vger.kernel.org>; Tue, 11 Aug 2009 00:28:06 +0200 (CEST)
Message-ID: <4A809EE7.10009@email.it>
Date: Tue, 11 Aug 2009 00:27:51 +0200
From: xwang1976@email.it
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: New device: Dikom DK-300 (maybe Kworld 323U rebranded)
References: <4A79EC82.4050902@email.it>
In-Reply-To: <4A79EC82.4050902@email.it>
Content-Type: multipart/mixed;
 boundary="------------040509070109020600060800"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------040509070109020600060800
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

Hi,
my brother has brought a Dikom DK-300 usb hybrid tv receiver.
He will use it under windows, but I've tried it with the latest v4l-dvb 
driver and I've discovered that it works well as analog tv (video and 
audio work using the sox command to send audio from /dev/dsp1 to /dev/dsp).
The digital tv doesn't work (in kaffeine the digital tv icon is not 
present).
I post the dmesg obtained connecting the device.
If you want I can test for the next 10 days.
Thank you,
Xwang

--------------040509070109020600060800
Content-Type: text/plain;
 name="dmesg_dikom-dk300.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="dmesg_dikom-dk300.txt"

[51167.096148] usb 2-3: new high speed USB device using ehci_hcd and address 6                              
[51167.231698] usb 2-3: configuration #1 chosen from 1 choice                                               
[51167.231862] em28xx: New device USB 2883 Device @ 480 Mbps (eb1a:e323, interface 0, class 0)              
[51167.231871] em28xx #0: Identified as Kworld VS-DVB-T 323UR (card=54)                                     
[51167.232984] em28xx #0: chip ID is em2882/em2883                                                          
[51167.364546] em28xx #0: i2c eeprom 00: 1a eb 67 95 1a eb 23 e3 d0 12 5c 00 6a 22 00 00                    
[51167.364553] em28xx #0: i2c eeprom 10: 00 00 04 57 4e 07 01 00 00 00 00 00 00 00 00 00                    
[51167.364560] em28xx #0: i2c eeprom 20: 46 00 01 00 f0 10 01 00 00 00 00 00 5b 1e 00 00                    
[51167.364566] em28xx #0: i2c eeprom 30: 00 00 20 40 20 80 02 20 01 01 00 00 00 00 00 00                    
[51167.364573] em28xx #0: i2c eeprom 40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[51167.364579] em28xx #0: i2c eeprom 50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[51167.364585] em28xx #0: i2c eeprom 60: 00 00 00 00 00 00 00 00 00 00 22 03 55 00 53 00
[51167.364591] em28xx #0: i2c eeprom 70: 42 00 20 00 32 00 38 00 38 00 33 00 20 00 44 00
[51167.364597] em28xx #0: i2c eeprom 80: 65 00 76 00 69 00 63 00 65 00 00 00 00 00 00 00
[51167.364603] em28xx #0: i2c eeprom 90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[51167.364610] em28xx #0: i2c eeprom a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[51167.364616] em28xx #0: i2c eeprom b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[51167.364622] em28xx #0: i2c eeprom c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[51167.364628] em28xx #0: i2c eeprom d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[51167.364634] em28xx #0: i2c eeprom e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[51167.364640] em28xx #0: i2c eeprom f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[51167.364647] em28xx #0: EEPROM ID= 0x9567eb1a, EEPROM hash = 0x4e913442
[51167.364649] em28xx #0: EEPROM info:
[51167.364650] em28xx #0:       AC97 audio (5 sample rates)
[51167.364651] em28xx #0:       500mA max power
[51167.364652] em28xx #0:       Table at 0x04, strings=0x226a, 0x0000, 0x0000
[51167.364654] em28xx #0:
[51167.364654]
[51167.364656] em28xx #0: The support for this board weren't valid yet.
[51167.364658] em28xx #0: Please send a report of having this working
[51167.364659] em28xx #0: not to V4L mailing list (and/or to other addresses)
[51167.364659]
[51167.367451] tvp5150 6-005c: chip found @ 0xb8 (em28xx #0)
[51167.371212] tuner 6-0061: chip found @ 0xc2 (em28xx #0)
[51167.371280] xc2028 6-0061: creating new instance
[51167.371282] xc2028 6-0061: type set to XCeive xc2028/xc3028 tuner
[51167.371287] usb 2-3: firmware: requesting xc3028-v27.fw
[51167.374856] xc2028 6-0061: Loading 80 firmware images from xc3028-v27.fw, type: xc2028 firmware, ver 2.7
[51167.420061] xc2028 6-0061: Loading firmware for type=BASE (1), id 0000000000000000.
[51168.329819] xc2028 6-0061: Loading firmware for type=(0), id 000000000000b700.
[51168.352574] SCODE (20000000), id 000000000000b700:
[51168.352584] xc2028 6-0061: Loading SCODE for type=MONO SCODE HAS_IF_4320 (60008000), id 0000000000008000.
[51168.541315] em28xx #0: Config register raw data: 0xd0
[51168.542051] em28xx #0: AC97 vendor ID = 0xffffffff
[51168.542433] em28xx #0: AC97 features = 0x6a90
[51168.542438] em28xx #0: Empia 202 AC97 audio processor detected
[51168.641549] tvp5150 6-005c: tvp5150am1 detected.
[51168.740935] em28xx #0: v4l2 driver version 0.1.2
[51168.895090] em28xx #0: V4L2 device registered as /dev/video1 and /dev/vbi0
[51168.895097] em28xx-audio.c: probing for em28x1 non standard usbaudio
[51168.895101] em28xx-audio.c: Copyright (C) 2006 Markus Rechberger
[51169.112537] tvp5150 6-005c: tvp5150am1 detected. 

--------------040509070109020600060800--
