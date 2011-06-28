Return-path: <mchehab@pedra>
Received: from mail-fx0-f52.google.com ([209.85.161.52]:53731 "EHLO
	mail-fx0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752927Ab1F1ToR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 28 Jun 2011 15:44:17 -0400
Received: by fxd18 with SMTP id 18so539379fxd.11
        for <linux-media@vger.kernel.org>; Tue, 28 Jun 2011 12:44:16 -0700 (PDT)
Subject: Genius TVGo C03 TV Card not recognised
From: Thomas Spigel <thomas.spigel@gmail.com>
To: V4L Mailing List <linux-media@vger.kernel.org>
Date: Tue, 28 Jun 2011 21:44:13 +0200
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-ID: <1309290255.9324.9.camel@asshole>
Mime-Version: 1.0
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hello, 
The em28xx module can't recognise my tvcard on my linux ubuntu 11.04.
Here is the dmesg log. Please tell me if there's any way to run this
card on my system. If not, i would like to help you to include it in
your modules.

CARD: Genius TVGo C03 hybrid tvcard
DMESG LOG:
[13291.629753] em28xx: New device @ 480 Mbps (eb1a:2883, interface 0,
class 0)
[13291.629853] em28xx #0: chip ID is em2882/em2883
[13291.712108] em28xx #0: i2c eeprom 00: 1a eb 67 95 58 04 16 40 d0 12
5c 00 6a 12 00 00
[13291.712119] em28xx #0: i2c eeprom 10: 00 00 04 57 4e 07 01 00 00 00
00 00 00 00 00 00
[13291.712129] em28xx #0: i2c eeprom 20: 46 00 01 00 f0 10 01 00 00 00
00 00 5b 1e 00 00
[13291.712139] em28xx #0: i2c eeprom 30: 00 00 20 40 20 80 02 20 10 01
00 00 00 00 00 00
[13291.712148] em28xx #0: i2c eeprom 40: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[13291.712158] em28xx #0: i2c eeprom 50: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[13291.712167] em28xx #0: i2c eeprom 60: 00 00 00 00 00 00 00 00 00 00
12 03 54 00 56 00
[13291.712177] em28xx #0: i2c eeprom 70: 47 00 6f 00 20 00 43 00 30 00
33 00 20 00 44 00
[13291.712186] em28xx #0: i2c eeprom 80: 65 00 76 00 69 00 63 00 65 00
00 00 00 00 00 00
[13291.712196] em28xx #0: i2c eeprom 90: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[13291.712205] em28xx #0: i2c eeprom a0: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[13291.712214] em28xx #0: i2c eeprom b0: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[13291.712224] em28xx #0: i2c eeprom c0: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[13291.712233] em28xx #0: i2c eeprom d0: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[13291.712242] em28xx #0: i2c eeprom e0: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[13291.712252] em28xx #0: i2c eeprom f0: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[13291.712262] em28xx #0: EEPROM ID= 0x9567eb1a, EEPROM hash =
0xbf6800e1
[13291.712264] em28xx #0: EEPROM info:
[13291.712266] em28xx #0:	AC97 audio (5 sample rates)
[13291.712267] em28xx #0:	500mA max power
[13291.712269] em28xx #0:	Table at 0x04, strings=0x126a, 0x0000, 0x0000
[13291.744483] em28xx #0: found i2c device @ 0xa0 [eeprom]
[13291.749105] em28xx #0: found i2c device @ 0xb8 [tvp5150a]
[13291.750977] em28xx #0: found i2c device @ 0xc2 [tuner (analog)]
[13291.762357] em28xx #0: Your board has no unique USB ID and thus need
a hint to be detected. 
[13291.762362] em28xx #0: You may try to use card=<n> insmod option to
workaround that.
[13291.762364] em28xx #0: Please send an email with this log to:
[13291.762366] em28xx #0: 	V4L Mailing List
<linux-media@vger.kernel.org>
[13291.762368] em28xx #0: Board eeprom hash is 0xbf6800e1
[13291.762370] em28xx #0: Board i2c devicelist hash is 0x27e10080


