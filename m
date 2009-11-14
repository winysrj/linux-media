Return-path: <linux-media-owner@vger.kernel.org>
Received: from jack.mail.tiscali.it ([213.205.33.53]:49144 "EHLO
	jack.mail.tiscali.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753392AbZKNL2b (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 14 Nov 2009 06:28:31 -0500
Message-ID: <4AFE92ED.2060208@gmail.com>
Date: Sat, 14 Nov 2009 12:22:21 +0100
From: "Andrea.Amorosi76@gmail.com" <Andrea.Amorosi76@gmail.com>
MIME-Version: 1.0
To: "linux-media@vger.kernel.org >> Linux Media Mailing List"
	<linux-media@vger.kernel.org>,
	Devin Heitmueller <dheitmueller@kernellabs.com>
Subject: [PATCH] em28xx: fix for Dikom DK300 hybrid USB tuner (aka Kworld
 VS-DVB-T 323UR ) (digital mode)
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch fix the Dikom DK300 hybrid usb card which is recognized as a
Kworld VS-DVB-T 323UR (card=54) by the main driver, but with no tv
available in Kaffeine.
The patch solves the problem for the digital part of the tuner.
Analog tv has no audio (both video e audio devices are created but
mplayer complains with the following message:
Error reading audio: Input/output error).
Moreover the /dev/video sometime is not deleted when the device is
unplugged.

Signed-off-by: Andrea Amorosi <Andrea.Amorosi76@gmail.com>

diff -r aba823ecaea6 linux/drivers/media/video/em28xx/em28xx-cards.c
--- a/linux/drivers/media/video/em28xx/em28xx-cards.c	Thu Nov 12
12:21:05 2009 -0200
+++ b/linux/drivers/media/video/em28xx/em28xx-cards.c	Sat Nov 14
00:33:49 2009 +0100
@@ -1422,6 +1422,9 @@
  		.tuner_type   = TUNER_XC2028,
  		.tuner_gpio   = default_tuner_gpio,
  		.decoder      = EM28XX_TVP5150,
+                .mts_firmware = 1,
+                .has_dvb      = 1,
+                .dvb_gpio     = kworld_330u_digital,


  		.input        = { {
  			.type     = EM28XX_VMUX_TELEVISION,
  			.vmux     = TVP5150_COMPOSITE0,
@@ -2143,6 +2146,7 @@
  		ctl->demod = XC3028_FE_DEFAULT;
  		break;
  	case EM2883_BOARD_KWORLD_HYBRID_330U:
+	case EM2882_BOARD_KWORLD_VS_DVBT:
  		ctl->demod = XC3028_FE_CHINA;
  		ctl->fname = XC2028_DEFAULT_FIRMWARE;
  		break;
diff -r aba823ecaea6 linux/drivers/media/video/em28xx/em28xx-dvb.c
--- a/linux/drivers/media/video/em28xx/em28xx-dvb.c	Thu Nov 12 12:21:05
2009 -0200
+++ b/linux/drivers/media/video/em28xx/em28xx-dvb.c	Sat Nov 14 00:33:49
2009 +0100
@@ -504,6 +504,7 @@
  		break;
  	case EM2880_BOARD_TERRATEC_HYBRID_XS:
  	case EM2881_BOARD_PINNACLE_HYBRID_PRO:
+	case EM2882_BOARD_KWORLD_VS_DVBT:
  		dvb->frontend = dvb_attach(zl10353_attach,
  					   &em28xx_zl10353_xc3028_no_i2c_gate,
  					   &dev->i2c_adap);




