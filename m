Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp2b.orange.fr ([80.12.242.144]:64829 "EHLO smtp2b.orange.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750999Ab0BRVGQ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 18 Feb 2010 16:06:16 -0500
Received: from me-wanadoo.net (localhost [127.0.0.1])
	by mwinf2b29.orange.fr (SMTP Server) with ESMTP id 9FC8B7000139
	for <linux-media@vger.kernel.org>; Thu, 18 Feb 2010 22:06:09 +0100 (CET)
Received: from me-wanadoo.net (localhost [127.0.0.1])
	by mwinf2b29.orange.fr (SMTP Server) with ESMTP id 903D07002366
	for <linux-media@vger.kernel.org>; Thu, 18 Feb 2010 22:06:09 +0100 (CET)
Received: from [192.168.0.1] (AVelizy-151-1-71-97.w81-249.abo.wanadoo.fr [81.249.125.97])
	by mwinf2b29.orange.fr (SMTP Server) with ESMTP id 67F9F7000139
	for <linux-media@vger.kernel.org>; Thu, 18 Feb 2010 22:06:09 +0100 (CET)
Message-ID: <4B7DABD8.4000006@orange.fr>
Date: Thu, 18 Feb 2010 22:06:32 +0100
From: Catimimi <catimimi@orange.fr>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: [patch] em28xx : Terratec Cinergy Hybrid T USB XS FR is working.
Content-Type: multipart/mixed;
 boundary="------------090009080206020603000608"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------090009080206020603000608
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit

Hi,

I succed in running Cinergy Hybrid T USB XS FR in both modes.
I enclose the patch against v4l-dvb-14021dfc00f3

Regards.
Michel.


--------------090009080206020603000608
Content-Type: text/x-patch;
 name="Cinergy_Hybrid_T_USB_XS_FR.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="Cinergy_Hybrid_T_USB_XS_FR.patch"

diff -ru v4l-dvb-14021dfc00f3-orig/linux/drivers/media/video/em28xx/em28xx-cards.c v4l-dvb-14021dfc00f3-mod/linux/drivers/media/video/em28xx/em28xx-cards.c
--- v4l-dvb-14021dfc00f3-orig/linux/drivers/media/video/em28xx/em28xx-cards.c	2010-02-12 02:11:30.000000000 +0100
+++ v4l-dvb-14021dfc00f3-mod/linux/drivers/media/video/em28xx/em28xx-cards.c	2010-02-18 21:52:43.000000000 +0100
@@ -774,15 +774,12 @@
 
 	[EM2880_BOARD_TERRATEC_HYBRID_XS_FR] = {
 		.name         = "Terratec Hybrid XS Secam",
-		.valid        = EM28XX_BOARD_NOT_VALIDATED,
 		.has_msp34xx  = 1,
 		.tuner_type   = TUNER_XC2028,
 		.tuner_gpio   = default_tuner_gpio,
 		.decoder      = EM28XX_TVP5150,
-#if 0 /* FIXME: add an entry at em28xx-dvb */
 		.has_dvb      = 1,
 		.dvb_gpio     = default_digital,
-#endif
 		.input        = { {
 			.type     = EM28XX_VMUX_TELEVISION,
 			.vmux     = TVP5150_COMPOSITE0,
diff -ru v4l-dvb-14021dfc00f3-orig/linux/drivers/media/video/em28xx/em28xx-dvb.c v4l-dvb-14021dfc00f3-mod/linux/drivers/media/video/em28xx/em28xx-dvb.c
--- v4l-dvb-14021dfc00f3-orig/linux/drivers/media/video/em28xx/em28xx-dvb.c	2010-02-12 02:11:30.000000000 +0100
+++ v4l-dvb-14021dfc00f3-mod/linux/drivers/media/video/em28xx/em28xx-dvb.c	2010-02-15 21:45:30.000000000 +0100
@@ -503,6 +503,7 @@
 		}
 		break;
 	case EM2880_BOARD_TERRATEC_HYBRID_XS:
+	case EM2880_BOARD_TERRATEC_HYBRID_XS_FR:
 	case EM2881_BOARD_PINNACLE_HYBRID_PRO:
 	case EM2882_BOARD_DIKOM_DK300:
 		dvb->frontend = dvb_attach(zl10353_attach,

--------------090009080206020603000608--


