Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:41034 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758875Ab0GPTnt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 16 Jul 2010 15:43:49 -0400
Received: by eya25 with SMTP id 25so642855eya.19
        for <linux-media@vger.kernel.org>; Fri, 16 Jul 2010 12:43:46 -0700 (PDT)
MIME-Version: 1.0
Date: Sat, 17 Jul 2010 01:13:45 +0530
Message-ID: <AANLkTil1gC0Zs-dZYO2rIgmnKIPpSdW79wncEvL9evxh@mail.gmail.com>
Subject: em28xx: new board id [0b1a:50a3]
From: Jeevas V <jeevas.v@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

With these changes the driver is failing when it tries to load the
xceive firmware complaining about some registers.

Please help me in getting this working and direct me.

After making the changes how can I install/insert  the em28xx module
alone so that I don't have to install the complete driver set?

By the way I am testing on Ubuntu Lucid 64-bit



Hi,

Recently I got a new Analog card  UTV 380 from Gadmei

I dismantled it and got the list of components in it.

    *  Empia EM2860 (USB video bridge)
    * Empia EMP202 (AC'97 audio processor)
    * NXP/Philips SAA7113 (video decoder)
    * Xceive XC2028ACQ (Analog chip tuner)
    * 24C04 (EEPROM)
    * HCF4052 (4-channel Analog multiplexer)

I have documented the same in the wiki:
http://www.linuxtv.org/wiki/index.php/Gadmei_USB_TVBox_UTV380

I tried adding support for the card using the v4l-dvb  source. Here is
what I did.

em28xx.h
=====================================================================
#define EM2860_BOARD_GADMEI_UTV380          76

em28xx-cards.c
=======================================================================
[EM2860_BOARD_GADMEI_UTV380] = {
		.name         = "Gadmei UTV380",
		.valid        = EM28XX_BOARD_NOT_VALIDATED,
		.tuner_type   = TUNER_XC2028,
		.decoder      = EM28XX_SAA711X,
		.input        = { {
			.type     = EM28XX_VMUX_TELEVISION,
			.vmux     = SAA7115_COMPOSITE2,
			.amux     = EM28XX_AMUX_VIDEO,
		}, {
			.type     = EM28XX_VMUX_COMPOSITE1,
			.vmux     = SAA7115_COMPOSITE0,
			.amux     = EM28XX_AMUX_LINE_IN,
		},
		},
	},

---------------------------
---------------------
-----------------
	{ USB_DEVICE(0xeb1a, 0x50a3),
			.driver_info = EM2860_BOARD_GADMEI_UTV380 },

====================================================================


After this I built and installed the driver. Then I extracted and
copied the xceive firmware(xc3028-v27.fw) from
 http://www.steventoth.net/linux/xc5000/HVR-12x0-14x0-17x0_1_25_25271_WHQL.zip
to /lib/firmware/



With these changes the driver is failing when it tries to load the
xceive firmware complaining about some registers.

Please help me in getting this working and direct me.

After making the changes how can I install/insert  the em28xx module
alone so that I don't have to install the complete driver set?

By the way I am testing on Ubuntu Lucid 64-bit




-- 
Thanks and Regards
Jeevas
