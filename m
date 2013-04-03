Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ie0-f182.google.com ([209.85.223.182]:42975 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761712Ab3DCJmL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 3 Apr 2013 05:42:11 -0400
Received: by mail-ie0-f182.google.com with SMTP id at1so1449274iec.27
        for <linux-media@vger.kernel.org>; Wed, 03 Apr 2013 02:42:11 -0700 (PDT)
MIME-Version: 1.0
From: =?UTF-8?B?TWljaGHDq2wgTGVmw6h2cmU=?= <lefevre00@gmail.com>
Date: Wed, 3 Apr 2013 11:41:51 +0200
Message-ID: <CA+aEtksFHFjxJLHDm6u8HHkkYqNtwTmkbPTTFTuvnhCWC5NXLQ@mail.gmail.com>
Subject: Driver for Cinergy Hybrid T USB XS FM
To: linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Following http://www.mail-archive.com/linux-media@vger.kernel.org/msg09960.html

Usb id : 0x0ccd:0x0072
I got a hand on such device and try to make it work under linux 3.5
tree yesterday.

However, it' s my first attempt at drivers coding.

Looks like we now have a mix em28xx/xc5000 with (extracted from em28xx-cards.c)

         [EM2884_BOARD_HAUPPAUGE_WINTV_HVR_930C] = {
                 .name         = "Hauppauge WinTV HVR 930C",
                 .has_dvb      = 1,
 #if 0 /* FIXME: Add analog support */
                 .tuner_type   = TUNER_XC5000,
                 .tuner_addr   = 0x41,
                 .dvb_gpio     = hauppauge_930c_digital,
                 .tuner_gpio   = hauppauge_930c_gpio,
 #else
                 .tuner_type   = TUNER_ABSENT,
 #endif
                 .ir_codes     = RC_MAP_HAUPPAUGE,
                 .def_i2c_bus  = 1,
                 .i2c_speed    = EM28XX_I2C_CLK_WAIT_ENABLE |
                                 EM28XX_I2C_FREQ_400_KHZ,
         },

Older em28xx-new found at
http://www.mathematik.uni-marburg.de/~kosslerj/em28xx-new/
use to support this usb stick.
It use cx25843 decoder.

I manage to load em28xx and other modules, but xc5000 firmware wouldnt load.
I can provide log if you want.

Michaël
