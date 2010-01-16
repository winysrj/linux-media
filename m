Return-path: <linux-media-owner@vger.kernel.org>
Received: from averell.mail.tiscali.it ([213.205.33.55]:52073 "EHLO
	averell.mail.tiscali.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758511Ab0APBPv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 15 Jan 2010 20:15:51 -0500
Received: from [192.168.0.60] (78.14.33.201) by averell.mail.tiscali.it (8.0.022)
        id 4B4CA237001ED8E5 for linux-media@vger.kernel.org; Sat, 16 Jan 2010 02:15:49 +0100
Message-ID: <4B51132A.1000606@gmail.com>
Date: Sat, 16 Jan 2010 02:15:22 +0100
From: "Andrea.Amorosi76@gmail.com" <Andrea.Amorosi76@gmail.com>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: How can I add IR remote to this new device (DIKOM DK300)?
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi to all,
I'm trying to use my Dikom DK300, my old notebook and an external 
monitor to create a media centre (I'm mostly interested in TV and TV 
recording).

The problem is that, even if I have managed to have the device working 
with the following patch, I can't still use the IR remote control 
shipped with it.
Can you give me some suggestion in order to have also the remote 
controller working? Otherwise is it easier to buy another remote with a 
dedicated receiver?

Moreover, since the digital demodulator remains activated when the tuner 
is switched from digital to analogue mode or when kaffeine (which 
actually I'm using to see digital tv) is closed, I wonder if someone can 
explain me how to verify the gpio settings using the usbsnoop (which 
I've done some times ago under win XP) to solve the issue.
If it is not possible, is there any way to deactivate the usb port and 
reactivate it when the device is in needed?

Meantime this it the patch that fixes the Dikom DK300 hybrid USB card 
which is recognized as a Kworld VS-DVB-T 323UR (card=54).

The patch adds digital TV and solves analogue TV audio bad quality issue.
Moreover it removes the composite and s-video analogue inputs which are 
not present on the board.

Not working: remote controller

Signed-off-by: Andrea Amorosi <Andrea.Amorosi76@gmail.com>

diff -r 59e746a1c5d1 linux/drivers/media/video/em28xx/em28xx-cards.c
--- a/linux/drivers/media/video/em28xx/em28xx-cards.c	Wed Dec 30 09:10:33 2009 -0200
+++ b/linux/drivers/media/video/em28xx/em28xx-cards.c	Tue Jan 12 21:58:30 2010 +0100
@@ -1447,19 +1447,25 @@
 		.tuner_type   = TUNER_XC2028,
 		.tuner_gpio   = default_tuner_gpio,
 		.decoder      = EM28XX_TVP5150,
+		.mts_firmware = 1,
+		.has_dvb      = 1,
+		.dvb_gpio     = kworld_330u_digital,
 		.input        = { {
 			.type     = EM28XX_VMUX_TELEVISION,
 			.vmux     = TVP5150_COMPOSITE0,
 			.amux     = EM28XX_AMUX_VIDEO,
-		}, {
+			.gpio     = default_analog,
+		},/* {
 			.type     = EM28XX_VMUX_COMPOSITE1,
 			.vmux     = TVP5150_COMPOSITE1,
 			.amux     = EM28XX_AMUX_LINE_IN,
+			.gpio     = kworld_330u_analog,
 		}, {
 			.type     = EM28XX_VMUX_SVIDEO,
 			.vmux     = TVP5150_SVIDEO,
 			.amux     = EM28XX_AMUX_LINE_IN,
-		} },
+			.gpio     = kworld_330u_analog,
+		} */},
 	},
 	[EM2882_BOARD_TERRATEC_HYBRID_XS] = {
 		.name         = "Terratec Hybrid XS (em2882)",
@@ -2168,6 +2174,7 @@
 		ctl->demod = XC3028_FE_DEFAULT;
 		break;
 	case EM2883_BOARD_KWORLD_HYBRID_330U:
+	case EM2882_BOARD_KWORLD_VS_DVBT:
 		ctl->demod = XC3028_FE_CHINA;
 		ctl->fname = XC2028_DEFAULT_FIRMWARE;
 		break;
diff -r 59e746a1c5d1 linux/drivers/media/video/em28xx/em28xx-dvb.c
--- a/linux/drivers/media/video/em28xx/em28xx-dvb.c	Wed Dec 30 09:10:33 2009 -0200
+++ b/linux/drivers/media/video/em28xx/em28xx-dvb.c	Tue Jan 12 21:58:30 2010 +0100
@@ -504,6 +504,7 @@
 		break;
 	case EM2880_BOARD_TERRATEC_HYBRID_XS:
 	case EM2881_BOARD_PINNACLE_HYBRID_PRO:
+	case EM2882_BOARD_KWORLD_VS_DVBT:
 		dvb->frontend = dvb_attach(zl10353_attach,
 					   &em28xx_zl10353_xc3028_no_i2c_gate,
 					   &dev->i2c_adap);


