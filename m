Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vw0-f203.google.com ([209.85.212.203]:55347 "EHLO
	mail-vw0-f203.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754637AbZJHBkG (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 7 Oct 2009 21:40:06 -0400
Received: by vws41 with SMTP id 41so2948229vws.4
        for <linux-media@vger.kernel.org>; Wed, 07 Oct 2009 18:39:29 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 7 Oct 2009 21:39:29 -0400
Message-ID: <15cfa2a50910071839j58026d10we2ccbaeb26527abc@mail.gmail.com>
Subject: KWorld UB435-Q Support
From: Robert Cicconetti <grythumn@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Jarod Wilson wrote:
> With that caveat emptor, here's where the tree that should at least get you 95% of the way
> there with that stick resides:
>
> http://www.kernellabs.com/hg/~mkrufky/lgdt3304-3/

Okay... I built the tip of the archive linked above. It works with my
UB435-Q fairly well, built against 2.6.28-15-generic #52-Ubuntu SMP
x86_64. I've been able to stream QAM256 content for several hours
reliably. Mythfrontend works somewhat... it'll tune the initial
channel, but fails afterward. I suspect it is timing out while waiting
for the RF tracking filter calibration... it adds about 6 seconds to
every tuning operation.

[  812.465930] tda18271: performing RF tracking filter calibration
[  818.572446] tda18271: RF tracking filter calibration complete
[  818.953946] tda18271: performing RF tracking filter calibration
[  825.093211] tda18271: RF tracking filter calibration complete

Initialization:

[  217.319831] em28xx: New device USB 2870 Device @ 480 Mbps (1b80:a340, interfa
ce 0, class 0)
[  217.319842] em28xx #0: Identified as KWorld PlusTV 340U (ATSC) (card=71)
[  217.320062] em28xx #0: chip ID is em2870
[  217.448225] em28xx #0: i2c eeprom 00: 1a eb 67 95 80 1b 40 a3 c0 13
6b 10 6a 22 00 00
[  217.448244] em28xx #0: i2c eeprom 10: 00 00 04 57 00 0d 00 00 00 00
00 00 00 00 00 00
[  217.448260] em28xx #0: i2c eeprom 20: 44 00 00 00 f0 10 01 00 00 00
00 00 5b 1c c0 00
[  217.448275] em28xx #0: i2c eeprom 30: 00 00 20 40 20 80 02 20 01 01
00 00 00 00 00 00
[  217.448290] em28xx #0: i2c eeprom 40: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[  217.448304] em28xx #0: i2c eeprom 50: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[  217.448319] em28xx #0: i2c eeprom 60: 00 00 00 00 00 00 00 00 00 00
22 03 55 00 53 00
[  217.448333] em28xx #0: i2c eeprom 70: 42 00 20 00 32 00 38 00 37 00
30 00 20 00 44 00
[  217.448348] em28xx #0: i2c eeprom 80: 65 00 76 00 69 00 63 00 65 00
00 00 00 00 00 00
[  217.448362] em28xx #0: i2c eeprom 90: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[  217.448376] em28xx #0: i2c eeprom a0: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[  217.448390] em28xx #0: i2c eeprom b0: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[  217.448405] em28xx #0: i2c eeprom c0: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[  217.448419] em28xx #0: i2c eeprom d0: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[  217.448433] em28xx #0: i2c eeprom e0: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[  217.448447] em28xx #0: i2c eeprom f0: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[  217.448465] em28xx #0: EEPROM ID= 0x9567eb1a, EEPROM hash = 0x2888a312
[  217.448469] em28xx #0: EEPROM info:
[  217.448472] em28xx #0:       No audio on board.
[  217.448475] em28xx #0:       500mA max power
[  217.448479] em28xx #0:       Table at 0x04, strings=0x226a, 0x0000, 0x0000
[  217.448488] em28xx #0: v4l2 driver version 0.1.2
[  217.454853] em28xx #0: V4L2 device registered as /dev/video0 and /dev/vbi0
[  217.454889] usbcore: registered new interface driver em28xx
[  217.454895] em28xx driver loaded

Any suggestions? Further data needed?

Thanks!
R C
