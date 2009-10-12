Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-out.neti.ee ([194.126.126.34]:59465 "EHLO smtp-out.neti.ee"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758002AbZJLTlA (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 12 Oct 2009 15:41:00 -0400
Received: from smtp-out.neti.ee (relay215.estpak.ee [88.196.174.215])
	by Bounce1.estpak.ee (Postfix) with ESMTP id 87370EE4B
	for <linux-media@vger.kernel.org>; Mon, 12 Oct 2009 22:27:04 +0300 (EEST)
Received: from localhost (localhost [127.0.0.1])
	by relay215.estpak.ee (Postfix) with ESMTP id D5D66296E68E
	for <linux-media@vger.kernel.org>; Mon, 12 Oct 2009 22:23:08 +0300 (EEST)
Received: from smtp-out.neti.ee ([127.0.0.1])
	by localhost (relay215.estpak.ee [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 5ZHNUOrf-DEW for <linux-media@vger.kernel.org>;
	Mon, 12 Oct 2009 22:23:05 +0300 (EEST)
Received: from Relayhost1.neti.ee (relayhost1.estpak.ee [88.196.174.141])
	by relay215.estpak.ee (Postfix) with ESMTP id 7E4C8296E5B2
	for <linux-media@vger.kernel.org>; Mon, 12 Oct 2009 22:23:05 +0300 (EEST)
Message-ID: <4AD3821C.5050306@proekspert.ee>
Date: Mon, 12 Oct 2009 22:23:08 +0300
From: Lauri Laanmets <lauri.laanmets@proekspert.ee>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: DVB support for MSI DigiVox A/D II and KWorld 320U
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello

I have KWorld 320U USB DVT-T Hybrid and trying to get DVB part working. 
The code from mcentral worked pretty well but as it is closed down now I 
would like to contribute to linux-media and enable and validate the 
hardware support for this device.

I have:

Linux 2.6.28-15-generic x86_64 GNU/Linux
Bus 001 Device 002: ID eb1a:e320 eMPIA Technology, Inc.

This device has the same id with "MSI DigiVox A/D II" but I guess it 
shouldn't matter because it appears to be exactly the same thing just 
with the different brand label with Zarlink ZL10353 DVB-T on both boards.

I have downloaded the code from v4l-dvb and commented out the "#if 0" 
around the device dvb definition ( em28xx-cards.c ), also added it to 
frontend registration ( em28xx-dvb.c) the same as KWorld 310 - just a 
normal Zarlink attach function.

The trouble is that I get an error:

zl10353_read_register: readreg error (reg=127, ret==-19)

and I cannot understand why. I have the mcentral code still lying around 
and comparing those codes doesn't seem to have any difference. Maybe 
there still is a magic bit somewhere to set?

Otherwise the device is recognized correctly:

[   34.704863] em28xx #0: chip ID is em2882/em2883
[   34.863889] em28xx #0: i2c eeprom 00: 1a eb 67 95 1a eb 20 e3 d0 12 
5c 00 6a 22 00 00
[   34.863898] em28xx #0: i2c eeprom 10: 00 00 04 57 4e 07 00 00 00 00 
00 00 00 00 00 00
[   34.863906] em28xx #0: i2c eeprom 20: 46 00 01 00 f0 10 01 00 00 00 
00 00 5b 1e 00 00
[   34.863913] em28xx #0: i2c eeprom 30: 00 00 20 40 20 80 02 20 01 01 
00 00 00 00 00 00
[   34.863920] em28xx #0: i2c eeprom 40: 00 00 00 00 00 00 00 00 00 00 
00 00 00 00 00 00
[   34.863927] em28xx #0: i2c eeprom 50: 00 00 00 00 00 00 00 00 00 00 
00 00 00 00 00 00
[   34.863933] em28xx #0: i2c eeprom 60: 00 00 00 00 00 00 00 00 00 00 
22 03 55 00 53 00
[   34.863940] em28xx #0: i2c eeprom 70: 42 00 20 00 32 00 38 00 38 00 
31 00 20 00 44 00
[   34.863947] em28xx #0: i2c eeprom 80: 65 00 76 00 69 00 63 00 65 00 
00 00 00 00 00 00
[   34.863954] em28xx #0: i2c eeprom 90: 00 00 00 00 00 00 00 00 00 00 
00 00 00 00 00 00
[   34.863960] em28xx #0: i2c eeprom a0: 00 00 00 00 00 00 00 00 00 00 
00 00 00 00 00 00
[   34.863967] em28xx #0: i2c eeprom b0: 00 00 00 00 00 00 00 00 00 00 
00 00 00 00 00 00
[   34.863974] em28xx #0: i2c eeprom c0: 00 00 00 00 00 00 00 00 00 00 
00 00 00 00 00 00
[   34.863981] em28xx #0: i2c eeprom d0: 00 00 00 00 00 00 00 00 00 00 
00 00 00 00 00 00
[   34.863987] em28xx #0: i2c eeprom e0: 00 00 00 00 00 00 00 00 00 00 
00 00 00 00 00 00
[   34.863994] em28xx #0: i2c eeprom f0: 00 00 00 00 00 00 00 00 00 00 
00 00 00 00 00 00
[   34.864002] em28xx #0: EEPROM ID= 0x9567eb1a, EEPROM hash = 0x74913442
[   34.864004] em28xx #0: EEPROM info:
[   34.864005] em28xx #0:       AC97 audio (5 sample rates)
[   34.864007] em28xx #0:       500mA max power
[   34.864009] em28xx #0:       Table at 0x04, strings=0x226a, 0x0000, 
0x0000
[   34.864012] em28xx #0: Identified as MSI DigiVox A/D II (card=50)

Regards
Lauri




