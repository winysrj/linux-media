Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp20.orange.fr ([80.12.242.26]:17853 "EHLO smtp20.orange.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753867Ab0CCIBT (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 3 Mar 2010 03:01:19 -0500
Received: from me-wanadoo.net (localhost [127.0.0.1])
	by mwinf2018.orange.fr (SMTP Server) with ESMTP id 02EDE2000746
	for <linux-media@vger.kernel.org>; Wed,  3 Mar 2010 09:01:18 +0100 (CET)
Received: from me-wanadoo.net (localhost [127.0.0.1])
	by mwinf2018.orange.fr (SMTP Server) with ESMTP id E8E282000754
	for <linux-media@vger.kernel.org>; Wed,  3 Mar 2010 09:01:17 +0100 (CET)
Received: from [192.168.0.1] (AVelizy-151-1-89-231.w86-205.abo.wanadoo.fr [86.205.127.231])
	by mwinf2018.orange.fr (SMTP Server) with ESMTP id A0E682000746
	for <linux-media@vger.kernel.org>; Wed,  3 Mar 2010 09:01:17 +0100 (CET)
Message-ID: <4B8E1770.4000006@orange.fr>
Date: Wed, 03 Mar 2010 09:01:52 +0100
From: Catimimi <catimimi@orange.fr>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: [patch] em28xx : Terratec Cinergy Hybrid T USB XS FR is now really
 working.
Content-Type: multipart/mixed;
 boundary="------------040400070101060609090307"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------040400070101060609090307
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

As I told you earlier, my previous patch was not working with a 64 bits kernel.
So forget it.


I now succed in running Cinergy Hybrid T USB XS FR with 32 and 64bits kernels.
One problem remains, because of msp3400 driver, I don't have sound in analog mode.
I'am still working on that problem.

I enclose the patch against v4l-dvb-14021dfc00f3

Regards.
Michel.



--------------040400070101060609090307
Content-Type: text/plain;
 name="terratec_cinergy_hybrid_usb_xs_fr.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="terratec_cinergy_hybrid_usb_xs_fr.patch"

diff -ru v4l-dvb-14021dfc00f3-orig/linux/drivers/media/video/em28xx/em28xx-cards.c v4l-dvb-14021dfc00f3-new/linux/drivers/media/video/em28xx/em28xx-cards.c
--- v4l-dvb-14021dfc00f3-orig/linux/drivers/media/video/em28xx/em28xx-cards.c	2010-02-12 02:11:30.000000000 +0100
+++ v4l-dvb-14021dfc00f3-new/linux/drivers/media/video/em28xx/em28xx-cards.c	2010-02-25 16:52:07.000000000 +0100
@@ -183,6 +183,18 @@
 	{	-1,		-1,	-1,		-1},
 };
 
+static struct em28xx_reg_seq terratec_cinergy_USB_XS_analog[] = {
+	{EM28XX_R08_GPIO,	0x6d,	~EM_GPIO_4,	10},
+	{EM2880_R04_GPO,	0x00,	0xff,		10},
+	{ -1,			-1,	-1,		-1},
+};
+
+static struct em28xx_reg_seq terratec_cinergy_USB_XS_digital[] = {
+	{EM28XX_R08_GPIO,	0x6e,	~EM_GPIO_4,	10},
+	{EM2880_R04_GPO,	0x08,	0xff,		10},
+	{ -1,			-1,	-1,		-1},
+};
+
 /* eb1a:2868 Reddo DVB-C USB TV Box
    GPIO4 - CU1216L NIM
    Other GPIOs seems to be don't care. */
@@ -774,30 +786,27 @@
 
 	[EM2880_BOARD_TERRATEC_HYBRID_XS_FR] = {
 		.name         = "Terratec Hybrid XS Secam",
-		.valid        = EM28XX_BOARD_NOT_VALIDATED,
 		.has_msp34xx  = 1,
 		.tuner_type   = TUNER_XC2028,
 		.tuner_gpio   = default_tuner_gpio,
 		.decoder      = EM28XX_TVP5150,
-#if 0 /* FIXME: add an entry at em28xx-dvb */
 		.has_dvb      = 1,
-		.dvb_gpio     = default_digital,
-#endif
+		.dvb_gpio     = terratec_cinergy_USB_XS_digital,
 		.input        = { {
 			.type     = EM28XX_VMUX_TELEVISION,
 			.vmux     = TVP5150_COMPOSITE0,
 			.amux     = EM28XX_AMUX_VIDEO,
-			.gpio     = default_analog,
+			.gpio     = terratec_cinergy_USB_XS_analog,
 		}, {
 			.type     = EM28XX_VMUX_COMPOSITE1,
 			.vmux     = TVP5150_COMPOSITE1,
 			.amux     = EM28XX_AMUX_LINE_IN,
-			.gpio     = default_analog,
+			.gpio     = terratec_cinergy_USB_XS_analog,
 		}, {
 			.type     = EM28XX_VMUX_SVIDEO,
 			.vmux     = TVP5150_SVIDEO,
 			.amux     = EM28XX_AMUX_LINE_IN,
-			.gpio     = default_analog,
+			.gpio     = terratec_cinergy_USB_XS_analog,
 		} },
 	},
 	[EM2880_BOARD_HAUPPAUGE_WINTV_HVR_900] = {
@@ -2181,6 +2190,7 @@
 		ctl->demod = XC3028_FE_ZARLINK456;
 		break;
 	case EM2880_BOARD_TERRATEC_HYBRID_XS:
+	case EM2880_BOARD_TERRATEC_HYBRID_XS_FR:
 	case EM2881_BOARD_PINNACLE_HYBRID_PRO:
 		ctl->demod = XC3028_FE_ZARLINK456;
 		break;
diff -ru v4l-dvb-14021dfc00f3-orig/linux/drivers/media/video/em28xx/em28xx-dvb.c v4l-dvb-14021dfc00f3-new/linux/drivers/media/video/em28xx/em28xx-dvb.c
--- v4l-dvb-14021dfc00f3-orig/linux/drivers/media/video/em28xx/em28xx-dvb.c	2010-02-12 02:11:30.000000000 +0100
+++ v4l-dvb-14021dfc00f3-new/linux/drivers/media/video/em28xx/em28xx-dvb.c	2010-02-25 16:46:35.000000000 +0100
@@ -503,6 +503,7 @@
 		}
 		break;
 	case EM2880_BOARD_TERRATEC_HYBRID_XS:
+	case EM2880_BOARD_TERRATEC_HYBRID_XS_FR:
 	case EM2881_BOARD_PINNACLE_HYBRID_PRO:
 	case EM2882_BOARD_DIKOM_DK300:
 		dvb->frontend = dvb_attach(zl10353_attach,

--------------040400070101060609090307--


