Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-out.m-online.net ([212.18.0.9]:51084 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754625AbZBXPfV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 24 Feb 2009 10:35:21 -0500
Message-Id: <20090224153515.143143335@gentoo.org>
Date: Tue, 24 Feb 2009 16:35:16 +0100
From: Matthias Schwarzott <zzam@gentoo.org>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Matthias Schwarzott <zzam@gentoo.org>
Subject: [patch 2/2] saa7134: add DVB support for Avermedia A700 cards
References: <20090224153514.090816655@gentoo.org>
Content-Disposition: inline; filename=avertv_A700_dvb_part.diff
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add DVB support for Avermedia DVB-S Pro and
Avermedia DVB-S Hybrid+FM card both labled A700.

They use zl10313 demod (driver mt312) and zl10036 tuner.

Signed-off-by: Matthias Schwarzott <zzam@gentoo.org>

Index: v4l-dvb/linux/drivers/media/video/saa7134/Kconfig
===================================================================
--- v4l-dvb.orig/linux/drivers/media/video/saa7134/Kconfig
+++ v4l-dvb/linux/drivers/media/video/saa7134/Kconfig
@@ -37,6 +37,8 @@ config VIDEO_SAA7134_DVB
 	select DVB_ISL6421 if !DVB_FE_CUSTOMISE
 	select MEDIA_TUNER_TDA827X if !MEDIA_TUNER_CUSTOMIZE
 	select MEDIA_TUNER_SIMPLE if !MEDIA_TUNER_CUSTOMIZE
+ 	select DVB_ZL10036 if !DVB_FE_CUSTOMISE
+ 	select DVB_MT312 if !DVB_FE_CUSTOMISE
 	---help---
 	  This adds support for DVB cards based on the
 	  Philips saa7134 chip.
Index: v4l-dvb/linux/drivers/media/video/saa7134/saa7134-cards.c
===================================================================
--- v4l-dvb.orig/linux/drivers/media/video/saa7134/saa7134-cards.c
+++ v4l-dvb/linux/drivers/media/video/saa7134/saa7134-cards.c
@@ -4460,8 +4460,7 @@ struct saa7134_board saa7134_boards[] = 
 		.radio_type     = UNSET,
 		.tuner_addr     = ADDR_UNSET,
 		.radio_addr     = ADDR_UNSET,
-		/* no DVB support for now */
-		/* .mpeg           = SAA7134_MPEG_DVB, */
+		.mpeg           = SAA7134_MPEG_DVB,
 		.inputs         = { {
 			.name = name_comp,
 			.vmux = 1,
@@ -4480,8 +4479,7 @@ struct saa7134_board saa7134_boards[] = 
 		.radio_type     = UNSET,
 		.tuner_addr     = ADDR_UNSET,
 		.radio_addr     = ADDR_UNSET,
-		/* no DVB support for now */
-		/* .mpeg           = SAA7134_MPEG_DVB, */
+		.mpeg           = SAA7134_MPEG_DVB,
 		.inputs         = { {
 			.name = name_comp,
 			.vmux = 1,
@@ -6187,15 +6185,15 @@ int saa7134_board_init1(struct saa7134_d
 		saa_andorl(SAA7134_GPIO_GPMODE0 >> 2,   0x8c040007, 0x8c040007);
 		saa_andorl(SAA7134_GPIO_GPSTATUS0 >> 2, 0x0c0007cd, 0x0c0007cd);
 		break;
-	case SAA7134_BOARD_AVERMEDIA_A700_PRO:
 	case SAA7134_BOARD_AVERMEDIA_A700_HYBRID:
-		/* write windows gpio values */
-		saa_andorl(SAA7134_GPIO_GPMODE0 >> 2,   0x80040100, 0x80040100);
-		saa_andorl(SAA7134_GPIO_GPSTATUS0 >> 2, 0x80040100, 0x00040100);
 		printk("%s: %s: hybrid analog/dvb card\n"
-		       "%s: Sorry, only analog s-video and composite input "
+		       "%s: Sorry, of the analog inputs, only analog s-video and composite "
 		       "are supported for now.\n",
 			dev->name, card(dev).name, dev->name);
+	case SAA7134_BOARD_AVERMEDIA_A700_PRO:
+		/* write windows gpio values */
+		saa_andorl(SAA7134_GPIO_GPMODE0 >> 2,   0x80040100, 0x80040100);
+		saa_andorl(SAA7134_GPIO_GPSTATUS0 >> 2, 0x80040100, 0x00040100);
 		break;
 	}
 	return 0;
Index: v4l-dvb/linux/drivers/media/video/saa7134/saa7134-dvb.c
===================================================================
--- v4l-dvb.orig/linux/drivers/media/video/saa7134/saa7134-dvb.c
+++ v4l-dvb/linux/drivers/media/video/saa7134/saa7134-dvb.c
@@ -51,6 +51,9 @@
 
 #include "zl10353.h"
 
+#include "zl10036.h"
+#include "mt312.h"
+
 MODULE_AUTHOR("Gerd Knorr <kraxel@bytesex.org> [SuSE Labs]");
 MODULE_LICENSE("GPL");
 
@@ -949,6 +952,17 @@ static struct nxt200x_config kworldatsc1
 	.demod_address    = 0x0a,
 };
 
+/* ------------------------------------------------------------------ */
+
+static struct mt312_config avertv_a700_mt312 = {
+	.demod_address = 0x0e,
+	.voltage_inverted = 1,
+};
+
+static struct zl10036_config avertv_a700_tuner = {
+	.tuner_address = 0x60,
+};
+
 /* ==================================================================
  * Core code
  */
@@ -1379,6 +1393,19 @@ static int dvb_init(struct saa7134_dev *
 				   TUNER_PHILIPS_FMD1216ME_MK3);
 		}
 		break;
+	case SAA7134_BOARD_AVERMEDIA_A700_PRO:
+	case SAA7134_BOARD_AVERMEDIA_A700_HYBRID:
+		/* Zarlink ZL10313 */
+		fe0->dvb.frontend = dvb_attach(mt312_attach,
+			&avertv_a700_mt312, &dev->i2c_adap);
+		if (fe0->dvb.frontend) {
+			if (dvb_attach(zl10036_attach, fe0->dvb.frontend,
+					&avertv_a700_tuner, &dev->i2c_adap) == NULL) {
+				wprintk("%s: No zl10036 found!\n",
+					__FUNCTION__);
+			}
+		}
+		break;
 	default:
 		wprintk("Huh? unknown DVB card?\n");
 		break;

