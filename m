Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:63623 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753141Ab0FMQNo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 13 Jun 2010 12:13:44 -0400
Received: by yxl31 with SMTP id 31so1057533yxl.19
        for <linux-media@vger.kernel.org>; Sun, 13 Jun 2010 09:13:43 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 14 Jun 2010 00:13:43 +0800
Message-ID: <AANLkTil_2Em3Q7IHpui30Vv35itUZOSerijSnJ-7eNfT@mail.gmail.com>
Subject: Compro VideoMate U3 [eb1a:2870] still not working in 2.6.32
From: Alica <alicaccs@seed.net.tw>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

My Compro VideoMate U3 DVB-T USB stick [eb1a:2870] does not work under
Debian squeeze (kernel 2.6.32). Below is the kernel message from
"modprobe em28xx":

> Jun 13 01:51:42 dvb kernel: [85382.931321] Linux video capture interface: v2.00
> Jun 13 01:51:42 dvb kernel: [85382.950628] em28xx: New device VideoMate U3 @ 480 Mbps (eb1a:2870, interface 0, class 0)
> Jun 13 01:51:42 dvb kernel: [85382.951393] em28xx #0: chip ID is em2870
> Jun 13 01:51:42 dvb kernel: [85383.029814] em28xx #0: i2c eeprom 00: 1a eb 67 95 1a eb 70 28 40 12 62 40 6a 1c 00 00
> Jun 13 01:51:42 dvb kernel: [85383.029868] em28xx #0: i2c eeprom 10: 00 00 04 57 0e 1d 00 00 00 00 00 00 00 00 00 00
> Jun 13 01:51:42 dvb kernel: [85383.029917] em28xx #0: i2c eeprom 20: 04 00 00 00 f0 10 01 00 00 00 00 00 5b 00 00 00
> Jun 13 01:51:42 dvb kernel: [85383.029965] em28xx #0: i2c eeprom 30: 00 00 20 40 20 80 02 20 01 01 00 00 00 00 00 00
> Jun 13 01:51:42 dvb kernel: [85383.030013] em28xx #0: i2c eeprom 40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> Jun 13 01:51:42 dvb kernel: [85383.030061] em28xx #0: i2c eeprom 50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> Jun 13 01:51:42 dvb kernel: [85383.030109] em28xx #0: i2c eeprom 60: 00 00 00 00 00 00 00 00 00 00 1c 03 56 00 69 00
> Jun 13 01:51:42 dvb kernel: [85383.030157] em28xx #0: i2c eeprom 70: 64 00 65 00 6f 00 4d 00 61 00 74 00 65 00 20 00
> Jun 13 01:51:42 dvb kernel: [85383.030205] em28xx #0: i2c eeprom 80: 55 00 33 00 00 00 63 00 65 00 00 00 00 00 00 00
> Jun 13 01:51:42 dvb kernel: [85383.030253] em28xx #0: i2c eeprom 90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> Jun 13 01:51:42 dvb kernel: [85383.030301] em28xx #0: i2c eeprom a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> Jun 13 01:51:42 dvb kernel: [85383.030349] em28xx #0: i2c eeprom b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> Jun 13 01:51:42 dvb kernel: [85383.030397] em28xx #0: i2c eeprom c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> Jun 13 01:51:42 dvb kernel: [85383.030445] em28xx #0: i2c eeprom d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> Jun 13 01:51:42 dvb kernel: [85383.030493] em28xx #0: i2c eeprom e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> Jun 13 01:51:42 dvb kernel: [85383.030541] em28xx #0: i2c eeprom f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> Jun 13 01:51:42 dvb kernel: [85383.030591] em28xx #0: EEPROM ID= 0x9567eb1a, EEPROM hash = 0xc9c50bc9
> Jun 13 01:51:42 dvb kernel: [85383.030611] em28xx #0: EEPROM info:
> Jun 13 01:51:42 dvb kernel: [85383.030627] em28xx #0:^INo audio on board.
> Jun 13 01:51:42 dvb kernel: [85383.030643] em28xx #0:^I500mA max power
> Jun 13 01:51:42 dvb kernel: [85383.030661] em28xx #0:^ITable at 0x04, strings=0x1c6a, 0x0000, 0x0000
> Jun 13 01:51:42 dvb kernel: [85383.031562] em28xx #0: Identified as Unknown EM2750/28xx video grabber (card=1)
> Jun 13 01:51:42 dvb kernel: [85383.053436] em28xx #0: found i2c device @ 0xa0 [eeprom]
> Jun 13 01:51:42 dvb kernel: [85383.058435] em28xx #0: found i2c device @ 0xc4 [tuner (analog)]
> Jun 13 01:51:42 dvb kernel: [85383.067576] em28xx #0: v4l2 driver version 0.1.2
> Jun 13 01:51:42 dvb kernel: [85383.077231] em28xx #0: V4L2 video device registered as /dev/video0
> Jun 13 01:51:42 dvb kernel: [85383.077302] usbcore: registered new interface driver em28xx
> Jun 13 01:51:42 dvb kernel: [85383.078147] em28xx driver loaded

Adding the card=46 module option (which is U3 listed as 185b:2870 in
CARDLIST.em28xx) also does not populate the dvb device. Any
suggestions?
