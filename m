Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-iw0-f175.google.com ([209.85.223.175]:37457 "EHLO
	mail-iw0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751081Ab0CEBYv (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 4 Mar 2010 20:24:51 -0500
Received: by iwn5 with SMTP id 5so2301841iwn.1
        for <linux-media@vger.kernel.org>; Thu, 04 Mar 2010 17:24:50 -0800 (PST)
From: Antonio Larrosa <larrosa@kde.org>
To: linux-media@vger.kernel.org
Subject: [PATCH] em28xx: Support for Kworld VS-DVB-T 323UR
Date: Fri, 5 Mar 2010 02:19:48 +0100
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201003050219.48583.larrosa@kde.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

em28xx: Support for Kworld VS-DVB-T 323UR
 
From: Antonio Larrosa <larrosa@kde.org>
 
This patch adapts the changes submitted by Dainius Ridzevicius to the
linux-media mailing list on 8/14/09, to the current sources in order
to make the Kworld VS-DVB-T 323UR usb device work.

I also removed the "not validated" flag since I own the device and validated
that it works fine after the patch is applied.

Thanks to Devin Heitmueller for his guidance with the code.
 
Priority: normal
 
Signed-off-by: Antonio Larrosa <larrosa@kde.org>

diff -r 41c5482f2dac linux/drivers/media/video/em28xx/em28xx-cards.c
--- a/linux/drivers/media/video/em28xx/em28xx-cards.c	Thu Mar 04 02:49:46 2010 -0300
+++ b/linux/drivers/media/video/em28xx/em28xx-cards.c	Fri Mar 05 01:41:46 2010 +0100
@@ -1456,10 +1456,14 @@
 	},
 	[EM2882_BOARD_KWORLD_VS_DVBT] = {
 		.name         = "Kworld VS-DVB-T 323UR",
-		.valid        = EM28XX_BOARD_NOT_VALIDATED,
 		.tuner_type   = TUNER_XC2028,
 		.tuner_gpio   = default_tuner_gpio,
 		.decoder      = EM28XX_TVP5150,
+		.mts_firmware = 1,
+		.has_dvb      = 1,
+		.dvb_gpio     = kworld_330u_digital,
+		.xclk         = EM28XX_XCLK_FREQUENCY_12MHZ, /* NEC IR */
+		.ir_codes     = &ir_codes_kworld_315u_table,
 		.input        = { {
 			.type     = EM28XX_VMUX_TELEVISION,
 			.vmux     = TVP5150_COMPOSITE0,
@@ -2198,6 +2202,7 @@
 		break;
 	case EM2883_BOARD_KWORLD_HYBRID_330U:
 	case EM2882_BOARD_DIKOM_DK300:
+	case EM2882_BOARD_KWORLD_VS_DVBT:
 		ctl->demod = XC3028_FE_CHINA;
 		ctl->fname = XC2028_DEFAULT_FIRMWARE;
 		break;
diff -r 41c5482f2dac linux/drivers/media/video/em28xx/em28xx-dvb.c
--- a/linux/drivers/media/video/em28xx/em28xx-dvb.c	Thu Mar 04 02:49:46 2010 -0300
+++ b/linux/drivers/media/video/em28xx/em28xx-dvb.c	Fri Mar 05 01:41:46 2010 +0100
@@ -506,6 +506,7 @@
 	case EM2880_BOARD_TERRATEC_HYBRID_XS_FR:
 	case EM2881_BOARD_PINNACLE_HYBRID_PRO:
 	case EM2882_BOARD_DIKOM_DK300:
+	case EM2882_BOARD_KWORLD_VS_DVBT:
 		dvb->frontend = dvb_attach(zl10353_attach,
 					   &em28xx_zl10353_xc3028_no_i2c_gate,
 					   &dev->i2c_adap);
