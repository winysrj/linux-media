Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:42404 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755906AbcA2MML (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 29 Jan 2016 07:12:11 -0500
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 01/13] [media] em28xx: remove unused input types
Date: Fri, 29 Jan 2016 10:10:51 -0200
Message-Id: <40325dd5b16246e065931ac054a3ae05ff443149.1454067262.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1454067262.git.mchehab@osg.samsung.com>
References: <cover.1454067262.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1454067262.git.mchehab@osg.samsung.com>
References: <cover.1454067262.git.mchehab@osg.samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The em28xx driver have lots of different input types but
only 4 of such types are actually used. The others are bogus.

Remove them, in order to cleanup the driver.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
---
 drivers/media/usb/em28xx/em28xx-cards.c | 134 ++++++++++++++++----------------
 drivers/media/usb/em28xx/em28xx-video.c |  16 ++--
 drivers/media/usb/em28xx/em28xx.h       |   8 +-
 3 files changed, 73 insertions(+), 85 deletions(-)

diff --git a/drivers/media/usb/em28xx/em28xx-cards.c b/drivers/media/usb/em28xx/em28xx-cards.c
index a1b6ef5894a6..ab0fe0319991 100644
--- a/drivers/media/usb/em28xx/em28xx-cards.c
+++ b/drivers/media/usb/em28xx/em28xx-cards.c
@@ -570,7 +570,7 @@ struct em28xx_board em28xx_boards[] = {
 		.tuner_type    = TUNER_ABSENT,
 		.is_webcam     = 1,
 		.input         = { {
-			.type     = EM28XX_VMUX_COMPOSITE1,
+			.type     = EM28XX_VMUX_COMPOSITE,
 			.vmux     = 0,
 			.amux     = EM28XX_AMUX_VIDEO,
 			.gpio     = silvercrest_reg_seq,
@@ -583,7 +583,7 @@ struct em28xx_board em28xx_boards[] = {
 		.decoder      = EM28XX_SAA711X,
 		.tuner_type   = TUNER_ABSENT,
 		.input        = { {
-			.type     = EM28XX_VMUX_COMPOSITE1,
+			.type     = EM28XX_VMUX_COMPOSITE,
 			.vmux     = SAA7115_COMPOSITE0,
 			.amux     = EM28XX_AMUX_LINE_IN,
 		}, {
@@ -605,7 +605,7 @@ struct em28xx_board em28xx_boards[] = {
 		.tuner_type    = TUNER_ABSENT,
 		.is_webcam     = 1,
 		.input         = { {
-			.type     = EM28XX_VMUX_COMPOSITE1,
+			.type     = EM28XX_VMUX_COMPOSITE,
 			.vmux     = 0,
 			.amux     = EM28XX_AMUX_VIDEO,
 		} },
@@ -616,7 +616,7 @@ struct em28xx_board em28xx_boards[] = {
 		.tda9887_conf = TDA9887_PRESENT,
 		.decoder      = EM28XX_SAA711X,
 		.input        = { {
-			.type     = EM28XX_VMUX_COMPOSITE1,
+			.type     = EM28XX_VMUX_COMPOSITE,
 			.vmux     = SAA7115_COMPOSITE0,
 			.amux     = EM28XX_AMUX_LINE_IN,
 		}, {
@@ -635,7 +635,7 @@ struct em28xx_board em28xx_boards[] = {
 			.vmux     = SAA7115_COMPOSITE2,
 			.amux     = EM28XX_AMUX_LINE_IN,
 		}, {
-			.type     = EM28XX_VMUX_COMPOSITE1,
+			.type     = EM28XX_VMUX_COMPOSITE,
 			.vmux     = SAA7115_COMPOSITE0,
 			.amux     = EM28XX_AMUX_LINE_IN,
 		}, {
@@ -655,7 +655,7 @@ struct em28xx_board em28xx_boards[] = {
 			.vmux     = SAA7115_COMPOSITE2,
 			.amux     = EM28XX_AMUX_VIDEO,
 		}, {
-			.type     = EM28XX_VMUX_COMPOSITE1,
+			.type     = EM28XX_VMUX_COMPOSITE,
 			.vmux     = SAA7115_COMPOSITE0,
 			.amux     = EM28XX_AMUX_LINE_IN,
 		}, {
@@ -675,7 +675,7 @@ struct em28xx_board em28xx_boards[] = {
 			.vmux     = SAA7115_COMPOSITE2,
 			.amux     = EM28XX_AMUX_VIDEO,
 		}, {
-			.type     = EM28XX_VMUX_COMPOSITE1,
+			.type     = EM28XX_VMUX_COMPOSITE,
 			.vmux     = SAA7115_COMPOSITE0,
 			.amux     = EM28XX_AMUX_LINE_IN,
 		}, {
@@ -715,7 +715,7 @@ struct em28xx_board em28xx_boards[] = {
 			.vmux     = SAA7115_COMPOSITE2,
 			.amux     = EM28XX_AMUX_LINE_IN,
 		}, {
-			.type     = EM28XX_VMUX_COMPOSITE1,
+			.type     = EM28XX_VMUX_COMPOSITE,
 			.vmux     = SAA7115_COMPOSITE0,
 			.amux     = EM28XX_AMUX_LINE_IN,
 		}, {
@@ -735,7 +735,7 @@ struct em28xx_board em28xx_boards[] = {
 			.vmux     = SAA7115_COMPOSITE2,
 			.amux     = EM28XX_AMUX_LINE_IN,
 		}, {
-			.type     = EM28XX_VMUX_COMPOSITE1,
+			.type     = EM28XX_VMUX_COMPOSITE,
 			.vmux     = SAA7115_COMPOSITE0,
 			.amux     = EM28XX_AMUX_LINE_IN,
 		}, {
@@ -755,7 +755,7 @@ struct em28xx_board em28xx_boards[] = {
 			.vmux     = SAA7115_COMPOSITE2,
 			.amux     = EM28XX_AMUX_VIDEO,
 		}, {
-			.type     = EM28XX_VMUX_COMPOSITE1,
+			.type     = EM28XX_VMUX_COMPOSITE,
 			.vmux     = SAA7115_COMPOSITE0,
 			.amux     = EM28XX_AMUX_LINE_IN,
 		}, {
@@ -775,7 +775,7 @@ struct em28xx_board em28xx_boards[] = {
 			.vmux     = SAA7115_COMPOSITE1,
 			.amux     = EM28XX_AMUX_LINE_IN,
 		}, {
-			.type     = EM28XX_VMUX_COMPOSITE1,
+			.type     = EM28XX_VMUX_COMPOSITE,
 			.vmux     = SAA7115_COMPOSITE0,
 			.amux     = EM28XX_AMUX_LINE_IN,
 		}, {
@@ -800,7 +800,7 @@ struct em28xx_board em28xx_boards[] = {
 			.vmux     = SAA7115_COMPOSITE4,
 			.amux     = EM28XX_AMUX_AUX,
 		}, {
-			.type     = EM28XX_VMUX_COMPOSITE1,
+			.type     = EM28XX_VMUX_COMPOSITE,
 			.vmux     = SAA7115_COMPOSITE5,
 			.amux     = EM28XX_AMUX_LINE_IN,
 		}, {
@@ -819,7 +819,7 @@ struct em28xx_board em28xx_boards[] = {
 		.tuner_type   = TUNER_ABSENT,
 		.is_webcam    = 1,
 		.input        = { {
-			.type     = EM28XX_VMUX_COMPOSITE1,
+			.type     = EM28XX_VMUX_COMPOSITE,
 			.vmux     = 0,
 			.amux     = EM28XX_AMUX_VIDEO,
 		} },
@@ -829,7 +829,7 @@ struct em28xx_board em28xx_boards[] = {
 		.tuner_type   = TUNER_ABSENT,
 		.is_webcam    = 1,
 		.input        = { {
-			.type     = EM28XX_VMUX_COMPOSITE1,
+			.type     = EM28XX_VMUX_COMPOSITE,
 			.vmux     = 0,
 			.amux     = EM28XX_AMUX_VIDEO,
 			.gpio     = silvercrest_reg_seq,
@@ -848,7 +848,7 @@ struct em28xx_board em28xx_boards[] = {
 			.vmux     = SAA7115_COMPOSITE2,
 			.amux     = EM28XX_AMUX_LINE_IN,
 		}, {
-			.type     = EM28XX_VMUX_COMPOSITE1,
+			.type     = EM28XX_VMUX_COMPOSITE,
 			.vmux     = SAA7115_COMPOSITE0,
 			.amux     = EM28XX_AMUX_VIDEO,
 		}, {
@@ -863,7 +863,7 @@ struct em28xx_board em28xx_boards[] = {
 		.tuner_type   = TUNER_ABSENT,	/* Capture only device */
 		.decoder      = EM28XX_SAA711X,
 		.input        = { {
-			.type  = EM28XX_VMUX_COMPOSITE1,
+			.type  = EM28XX_VMUX_COMPOSITE,
 			.vmux  = SAA7115_COMPOSITE0,
 			.amux  = EM28XX_AMUX_LINE_IN,
 		}, {
@@ -879,7 +879,7 @@ struct em28xx_board em28xx_boards[] = {
 		.tuner_type   = TUNER_ABSENT,
 		.is_webcam    = 1,
 		.input        = { {
-			.type     = EM28XX_VMUX_COMPOSITE1,
+			.type     = EM28XX_VMUX_COMPOSITE,
 			.vmux     = 0,
 			.amux     = EM28XX_AMUX_VIDEO,
 		} },
@@ -889,7 +889,7 @@ struct em28xx_board em28xx_boards[] = {
 		.decoder      = EM28XX_SAA711X,
 		.tuner_type   = TUNER_ABSENT,	/* Capture only device */
 		.input        = { {
-			.type  = EM28XX_VMUX_COMPOSITE1,
+			.type  = EM28XX_VMUX_COMPOSITE,
 			.vmux  = SAA7115_COMPOSITE0,
 			.amux  = EM28XX_AMUX_LINE_IN,
 		}, {
@@ -909,7 +909,7 @@ struct em28xx_board em28xx_boards[] = {
 			.vmux     = SAA7115_COMPOSITE2,
 			.amux     = EM28XX_AMUX_VIDEO,
 		}, {
-			.type     = EM28XX_VMUX_COMPOSITE1,
+			.type     = EM28XX_VMUX_COMPOSITE,
 			.vmux     = SAA7115_COMPOSITE0,
 			.amux     = EM28XX_AMUX_LINE_IN,
 		}, {
@@ -930,7 +930,7 @@ struct em28xx_board em28xx_boards[] = {
 			.vmux     = SAA7115_COMPOSITE2,
 			.amux     = EM28XX_AMUX_VIDEO,
 		}, {
-			.type     = EM28XX_VMUX_COMPOSITE1,
+			.type     = EM28XX_VMUX_COMPOSITE,
 			.vmux     = SAA7115_COMPOSITE0,
 			.amux     = EM28XX_AMUX_LINE_IN,
 		}, {
@@ -952,7 +952,7 @@ struct em28xx_board em28xx_boards[] = {
 			.amux     = EM28XX_AMUX_VIDEO,
 			.gpio     = hauppauge_wintv_hvr_900_analog,
 		}, {
-			.type     = EM28XX_VMUX_COMPOSITE1,
+			.type     = EM28XX_VMUX_COMPOSITE,
 			.vmux     = TVP5150_COMPOSITE1,
 			.amux     = EM28XX_AMUX_LINE_IN,
 			.gpio     = hauppauge_wintv_hvr_900_analog,
@@ -974,7 +974,7 @@ struct em28xx_board em28xx_boards[] = {
 			.vmux     = TVP5150_COMPOSITE0,
 			.amux     = EM28XX_AMUX_VIDEO,
 		}, {
-			.type     = EM28XX_VMUX_COMPOSITE1,
+			.type     = EM28XX_VMUX_COMPOSITE,
 			.vmux     = TVP5150_COMPOSITE1,
 			.amux     = EM28XX_AMUX_LINE_IN,
 		}, {
@@ -992,7 +992,7 @@ struct em28xx_board em28xx_boards[] = {
 			.vmux     = TVP5150_COMPOSITE0,
 			.amux     = EM28XX_AMUX_VIDEO,
 		}, {
-			.type     = EM28XX_VMUX_COMPOSITE1,
+			.type     = EM28XX_VMUX_COMPOSITE,
 			.vmux     = TVP5150_COMPOSITE1,
 			.amux     = EM28XX_AMUX_LINE_IN,
 		}, {
@@ -1006,7 +1006,7 @@ struct em28xx_board em28xx_boards[] = {
 		.tuner_type    = TUNER_ABSENT,	/* Capture only device */
 		.decoder       = EM28XX_TVP5150,
 		.input         = { {
-			.type     = EM28XX_VMUX_COMPOSITE1,
+			.type     = EM28XX_VMUX_COMPOSITE,
 			.vmux     = TVP5150_COMPOSITE1,
 			.amux     = EM28XX_AMUX_LINE_IN,
 		}, {
@@ -1029,7 +1029,7 @@ struct em28xx_board em28xx_boards[] = {
 			.amux     = EM28XX_AMUX_LINE_IN,
 			.gpio     = pinnacle_hybrid_pro_analog,
 		}, {
-			.type     = EM28XX_VMUX_COMPOSITE1,
+			.type     = EM28XX_VMUX_COMPOSITE,
 			.vmux     = TVP5150_COMPOSITE1,
 			.amux     = EM28XX_AMUX_LINE_IN,
 			.gpio     = pinnacle_hybrid_pro_analog,
@@ -1100,7 +1100,7 @@ struct em28xx_board em28xx_boards[] = {
 			.amux     = EM28XX_AMUX_VIDEO,
 			.gpio     = terratec_cinergy_USB_XS_FR_analog,
 		}, {
-			.type     = EM28XX_VMUX_COMPOSITE1,
+			.type     = EM28XX_VMUX_COMPOSITE,
 			.vmux     = TVP5150_COMPOSITE1,
 			.amux     = EM28XX_AMUX_LINE_IN,
 			.gpio     = terratec_cinergy_USB_XS_FR_analog,
@@ -1186,7 +1186,7 @@ struct em28xx_board em28xx_boards[] = {
 			.amux     = EM28XX_AMUX_VIDEO,
 			.gpio     = hauppauge_wintv_hvr_900_analog,
 		}, {
-			.type     = EM28XX_VMUX_COMPOSITE1,
+			.type     = EM28XX_VMUX_COMPOSITE,
 			.vmux     = TVP5150_COMPOSITE1,
 			.amux     = EM28XX_AMUX_LINE_IN,
 			.gpio     = hauppauge_wintv_hvr_900_analog,
@@ -1213,7 +1213,7 @@ struct em28xx_board em28xx_boards[] = {
 			.amux     = EM28XX_AMUX_VIDEO,
 			.gpio     = hauppauge_wintv_hvr_900_analog,
 		}, {
-			.type     = EM28XX_VMUX_COMPOSITE1,
+			.type     = EM28XX_VMUX_COMPOSITE,
 			.vmux     = TVP5150_COMPOSITE1,
 			.amux     = EM28XX_AMUX_LINE_IN,
 			.gpio     = hauppauge_wintv_hvr_900_analog,
@@ -1239,7 +1239,7 @@ struct em28xx_board em28xx_boards[] = {
 			.amux     = EM28XX_AMUX_VIDEO,
 			.gpio     = hauppauge_wintv_hvr_900_analog,
 		}, {
-			.type     = EM28XX_VMUX_COMPOSITE1,
+			.type     = EM28XX_VMUX_COMPOSITE,
 			.vmux     = TVP5150_COMPOSITE1,
 			.amux     = EM28XX_AMUX_LINE_IN,
 			.gpio     = hauppauge_wintv_hvr_900_analog,
@@ -1265,7 +1265,7 @@ struct em28xx_board em28xx_boards[] = {
 			.amux     = EM28XX_AMUX_VIDEO,
 			.gpio     = hauppauge_wintv_hvr_900_analog,
 		}, {
-			.type     = EM28XX_VMUX_COMPOSITE1,
+			.type     = EM28XX_VMUX_COMPOSITE,
 			.vmux     = TVP5150_COMPOSITE1,
 			.amux     = EM28XX_AMUX_LINE_IN,
 			.gpio     = hauppauge_wintv_hvr_900_analog,
@@ -1291,7 +1291,7 @@ struct em28xx_board em28xx_boards[] = {
 			.amux     = EM28XX_AMUX_VIDEO,
 			.gpio     = hauppauge_wintv_hvr_900_analog,
 		}, {
-			.type     = EM28XX_VMUX_COMPOSITE1,
+			.type     = EM28XX_VMUX_COMPOSITE,
 			.vmux     = TVP5150_COMPOSITE1,
 			.amux     = EM28XX_AMUX_LINE_IN,
 			.gpio     = hauppauge_wintv_hvr_900_analog,
@@ -1317,7 +1317,7 @@ struct em28xx_board em28xx_boards[] = {
 			.amux     = EM28XX_AMUX_VIDEO,
 			.gpio     = hauppauge_wintv_hvr_900_analog,
 		}, {
-			.type     = EM28XX_VMUX_COMPOSITE1,
+			.type     = EM28XX_VMUX_COMPOSITE,
 			.vmux     = TVP5150_COMPOSITE1,
 			.amux     = EM28XX_AMUX_LINE_IN,
 			.gpio     = hauppauge_wintv_hvr_900_analog,
@@ -1343,7 +1343,7 @@ struct em28xx_board em28xx_boards[] = {
 			.amux     = EM28XX_AMUX_VIDEO,
 			.gpio     = default_analog,
 		}, {
-			.type     = EM28XX_VMUX_COMPOSITE1,
+			.type     = EM28XX_VMUX_COMPOSITE,
 			.vmux     = TVP5150_COMPOSITE1,
 			.amux     = EM28XX_AMUX_LINE_IN,
 			.gpio     = default_analog,
@@ -1368,7 +1368,7 @@ struct em28xx_board em28xx_boards[] = {
 			.amux     = EM28XX_AMUX_VIDEO,
 			.gpio     = hauppauge_wintv_hvr_900_analog,
 		}, {
-			.type     = EM28XX_VMUX_COMPOSITE1,
+			.type     = EM28XX_VMUX_COMPOSITE,
 			.vmux     = TVP5150_COMPOSITE1,
 			.amux     = EM28XX_AMUX_LINE_IN,
 			.gpio     = hauppauge_wintv_hvr_900_analog,
@@ -1392,7 +1392,7 @@ struct em28xx_board em28xx_boards[] = {
 			.vmux      = SAA7115_COMPOSITE4,
 			.amux      = EM28XX_AMUX_VIDEO,
 		}, {
-			.type      = EM28XX_VMUX_COMPOSITE1,
+			.type      = EM28XX_VMUX_COMPOSITE,
 			.vmux      = SAA7115_COMPOSITE0,
 			.amux      = EM28XX_AMUX_LINE_IN,
 		}, {
@@ -1413,7 +1413,7 @@ struct em28xx_board em28xx_boards[] = {
 			.vmux     = SAA7115_COMPOSITE2,
 			.amux     = EM28XX_AMUX_VIDEO,
 		}, {
-			.type     = EM28XX_VMUX_COMPOSITE1,
+			.type     = EM28XX_VMUX_COMPOSITE,
 			.vmux     = SAA7115_COMPOSITE0,
 			.amux     = EM28XX_AMUX_LINE_IN,
 		}, {
@@ -1428,7 +1428,7 @@ struct em28xx_board em28xx_boards[] = {
 		.decoder    = EM28XX_SAA711X,
 		.tuner_type = TUNER_ABSENT, /* capture only board */
 		.input      = { {
-			.type     = EM28XX_VMUX_COMPOSITE1,
+			.type     = EM28XX_VMUX_COMPOSITE,
 			.vmux     = SAA7115_COMPOSITE0,
 			.amux     = EM28XX_AMUX_LINE_IN,
 		}, {
@@ -1443,7 +1443,7 @@ struct em28xx_board em28xx_boards[] = {
 		.tuner_type   = TUNER_ABSENT,	/* Capture-only board */
 		.decoder      = EM28XX_SAA711X,
 		.input        = { {
-			.type     = EM28XX_VMUX_COMPOSITE1,
+			.type     = EM28XX_VMUX_COMPOSITE,
 			.vmux     = SAA7115_COMPOSITE0,
 			.amux     = EM28XX_AMUX_LINE_IN,
 			.gpio     = vc211a_enable,
@@ -1465,7 +1465,7 @@ struct em28xx_board em28xx_boards[] = {
 			.vmux     = SAA7115_COMPOSITE2,
 			.amux     = EM28XX_AMUX_VIDEO,
 		}, {
-			.type     = EM28XX_VMUX_COMPOSITE1,
+			.type     = EM28XX_VMUX_COMPOSITE,
 			.vmux     = SAA7115_COMPOSITE0,
 			.amux     = EM28XX_AMUX_LINE_IN,
 		}, {
@@ -1485,7 +1485,7 @@ struct em28xx_board em28xx_boards[] = {
 			.vmux     = SAA7115_COMPOSITE2,
 			.amux     = EM28XX_AMUX_VIDEO,
 		}, {
-			.type     = EM28XX_VMUX_COMPOSITE1,
+			.type     = EM28XX_VMUX_COMPOSITE,
 			.vmux     = SAA7115_COMPOSITE0,
 			.amux     = EM28XX_AMUX_LINE_IN,
 		}, {
@@ -1500,7 +1500,7 @@ struct em28xx_board em28xx_boards[] = {
 		.tuner_type   = TUNER_ABSENT, /* capture only board */
 		.decoder      = EM28XX_SAA711X,
 		.input        = { {
-			.type     = EM28XX_VMUX_COMPOSITE1,
+			.type     = EM28XX_VMUX_COMPOSITE,
 			.vmux     = SAA7115_COMPOSITE0,
 			.amux     = EM28XX_AMUX_LINE_IN,
 		}, {
@@ -1520,7 +1520,7 @@ struct em28xx_board em28xx_boards[] = {
 			.vmux     = SAA7115_COMPOSITE2,
 			.amux     = EM28XX_AMUX_VIDEO,
 		}, {
-			.type     = EM28XX_VMUX_COMPOSITE1,
+			.type     = EM28XX_VMUX_COMPOSITE,
 			.vmux     = SAA7115_COMPOSITE0,
 			.amux     = EM28XX_AMUX_LINE_IN,
 		}, {
@@ -1541,7 +1541,7 @@ struct em28xx_board em28xx_boards[] = {
 			.aout     = EM28XX_AOUT_MONO |	/* I2S */
 				    EM28XX_AOUT_MASTER,	/* Line out pin */
 		}, {
-			.type     = EM28XX_VMUX_COMPOSITE1,
+			.type     = EM28XX_VMUX_COMPOSITE,
 			.vmux     = SAA7115_COMPOSITE0,
 			.amux     = EM28XX_AMUX_LINE_IN,
 		}, {
@@ -1563,7 +1563,7 @@ struct em28xx_board em28xx_boards[] = {
 			.aout     = EM28XX_AOUT_MONO |	/* I2S */
 				    EM28XX_AOUT_MASTER,	/* Line out pin */
 		}, {
-			.type     = EM28XX_VMUX_COMPOSITE1,
+			.type     = EM28XX_VMUX_COMPOSITE,
 			.vmux     = SAA7115_COMPOSITE0,
 			.amux     = EM28XX_AMUX_LINE_IN,
 		}, {
@@ -1581,7 +1581,7 @@ struct em28xx_board em28xx_boards[] = {
 			.type     = EM28XX_VMUX_SVIDEO,
 			.vmux     = SAA7115_SVIDEO3,
 		}, {
-			.type     = EM28XX_VMUX_COMPOSITE1,
+			.type     = EM28XX_VMUX_COMPOSITE,
 			.vmux     = SAA7115_COMPOSITE0,
 		} },
 	},
@@ -1610,7 +1610,7 @@ struct em28xx_board em28xx_boards[] = {
 			.amux     = EM28XX_AMUX_VIDEO,
 			.gpio     = em2880_msi_digivox_ad_analog,
 		}, {
-			.type     = EM28XX_VMUX_COMPOSITE1,
+			.type     = EM28XX_VMUX_COMPOSITE,
 			.vmux     = TVP5150_COMPOSITE1,
 			.amux     = EM28XX_AMUX_LINE_IN,
 			.gpio     = em2880_msi_digivox_ad_analog,
@@ -1633,7 +1633,7 @@ struct em28xx_board em28xx_boards[] = {
 			.amux     = EM28XX_AMUX_VIDEO,
 			.gpio     = em2880_msi_digivox_ad_analog,
 		}, {
-			.type     = EM28XX_VMUX_COMPOSITE1,
+			.type     = EM28XX_VMUX_COMPOSITE,
 			.vmux     = TVP5150_COMPOSITE1,
 			.amux     = EM28XX_AMUX_LINE_IN,
 			.gpio     = em2880_msi_digivox_ad_analog,
@@ -1654,7 +1654,7 @@ struct em28xx_board em28xx_boards[] = {
 			.vmux     = TVP5150_COMPOSITE0,
 			.amux     = EM28XX_AMUX_VIDEO,
 		}, {
-			.type     = EM28XX_VMUX_COMPOSITE1,
+			.type     = EM28XX_VMUX_COMPOSITE,
 			.vmux     = TVP5150_COMPOSITE1,
 			.amux     = EM28XX_AMUX_LINE_IN,
 		}, {
@@ -1677,7 +1677,7 @@ struct em28xx_board em28xx_boards[] = {
 			.amux     = EM28XX_AMUX_VIDEO,
 			.gpio     = default_analog,
 		}, {
-			.type     = EM28XX_VMUX_COMPOSITE1,
+			.type     = EM28XX_VMUX_COMPOSITE,
 			.vmux     = TVP5150_COMPOSITE1,
 			.amux     = EM28XX_AMUX_LINE_IN,
 			.gpio     = default_analog,
@@ -1708,7 +1708,7 @@ struct em28xx_board em28xx_boards[] = {
 			.gpio = em2882_kworld_315u_analog,
 			.aout = EM28XX_AOUT_PCM_IN | EM28XX_AOUT_PCM_STEREO,
 		}, {
-			.type = EM28XX_VMUX_COMPOSITE1,
+			.type = EM28XX_VMUX_COMPOSITE,
 			.vmux = SAA7115_COMPOSITE0,
 			.amux = EM28XX_AMUX_LINE_IN,
 			.gpio = em2882_kworld_315u_analog1,
@@ -1735,7 +1735,7 @@ struct em28xx_board em28xx_boards[] = {
 			.amux = EM28XX_AMUX_VIDEO,
 			.gpio = default_analog,
 		}, {
-			.type = EM28XX_VMUX_COMPOSITE1,
+			.type = EM28XX_VMUX_COMPOSITE,
 			.vmux = TVP5150_COMPOSITE1,
 			.amux = EM28XX_AMUX_LINE_IN,
 			.gpio = default_analog,
@@ -1758,7 +1758,7 @@ struct em28xx_board em28xx_boards[] = {
 			.amux     = EM28XX_AMUX_VIDEO,
 			.gpio     = default_analog,
 		}, {
-			.type     = EM28XX_VMUX_COMPOSITE1,
+			.type     = EM28XX_VMUX_COMPOSITE,
 			.vmux     = TVP5150_COMPOSITE1,
 			.amux     = EM28XX_AMUX_LINE_IN,
 			.gpio     = default_analog,
@@ -1782,7 +1782,7 @@ struct em28xx_board em28xx_boards[] = {
 			.amux     = EM28XX_AMUX_VIDEO,
 			.gpio     = pinnacle_hybrid_pro_analog,
 		}, {
-			.type     = EM28XX_VMUX_COMPOSITE1,
+			.type     = EM28XX_VMUX_COMPOSITE,
 			.vmux     = TVP5150_COMPOSITE1,
 			.amux     = EM28XX_AMUX_LINE_IN,
 			.gpio     = pinnacle_hybrid_pro_analog,
@@ -1808,7 +1808,7 @@ struct em28xx_board em28xx_boards[] = {
 			.amux     = EM28XX_AMUX_VIDEO,
 			.gpio     = hauppauge_wintv_hvr_900_analog,
 		}, {
-			.type     = EM28XX_VMUX_COMPOSITE1,
+			.type     = EM28XX_VMUX_COMPOSITE,
 			.vmux     = TVP5150_COMPOSITE1,
 			.amux     = EM28XX_AMUX_LINE_IN,
 			.gpio     = hauppauge_wintv_hvr_900_analog,
@@ -1834,7 +1834,7 @@ struct em28xx_board em28xx_boards[] = {
 			.vmux     = TVP5150_COMPOSITE0,
 			.amux     = EM28XX_AMUX_VIDEO,
 		}, {
-			.type     = EM28XX_VMUX_COMPOSITE1,
+			.type     = EM28XX_VMUX_COMPOSITE,
 			.vmux     = TVP5150_COMPOSITE1,
 			.amux     = EM28XX_AMUX_LINE_IN,
 		}, {
@@ -1859,7 +1859,7 @@ struct em28xx_board em28xx_boards[] = {
 			.amux     = EM28XX_AMUX_VIDEO,
 			.gpio     = hauppauge_wintv_hvr_900_analog,
 		}, {
-			.type     = EM28XX_VMUX_COMPOSITE1,
+			.type     = EM28XX_VMUX_COMPOSITE,
 			.vmux     = TVP5150_COMPOSITE1,
 			.amux     = EM28XX_AMUX_LINE_IN,
 			.gpio     = hauppauge_wintv_hvr_900_analog,
@@ -1904,7 +1904,7 @@ struct em28xx_board em28xx_boards[] = {
 			.gpio     = kworld_330u_analog,
 			.aout     = EM28XX_AOUT_PCM_IN | EM28XX_AOUT_PCM_STEREO,
 		}, {
-			.type     = EM28XX_VMUX_COMPOSITE1,
+			.type     = EM28XX_VMUX_COMPOSITE,
 			.vmux     = TVP5150_COMPOSITE1,
 			.amux     = EM28XX_AMUX_LINE_IN,
 			.gpio     = kworld_330u_analog,
@@ -1951,7 +1951,7 @@ struct em28xx_board em28xx_boards[] = {
 			.amux     = EM28XX_AMUX_VIDEO,
 
 		}, {
-			.type     = EM28XX_VMUX_COMPOSITE1,
+			.type     = EM28XX_VMUX_COMPOSITE,
 			.vmux     = TVP5150_COMPOSITE1,
 			.amux     = EM28XX_AMUX_LINE_IN,
 		}, {
@@ -1970,7 +1970,7 @@ struct em28xx_board em28xx_boards[] = {
 		.tuner_type   = TUNER_ABSENT,
 		.decoder      = EM28XX_SAA711X,
 		.input           = { {
-			.type     = EM28XX_VMUX_COMPOSITE1,
+			.type     = EM28XX_VMUX_COMPOSITE,
 			.vmux     = SAA7115_COMPOSITE0,
 			.amux     = EM28XX_AMUX_LINE_IN,
 		}, {
@@ -1990,7 +1990,7 @@ struct em28xx_board em28xx_boards[] = {
 			.vmux     = TVP5150_COMPOSITE0,
 			.amux     = EM28XX_AMUX_VIDEO,
 		}, { /* Composite has not been tested yet */
-			.type     = EM28XX_VMUX_COMPOSITE1,
+			.type     = EM28XX_VMUX_COMPOSITE,
 			.vmux     = TVP5150_COMPOSITE1,
 			.amux     = EM28XX_AMUX_VIDEO,
 		}, { /* S-video has not been tested yet */
@@ -2006,7 +2006,7 @@ struct em28xx_board em28xx_boards[] = {
 		.decoder         = EM28XX_SAA711X,
 		.xclk            = EM28XX_XCLK_FREQUENCY_12MHZ,
 		.input           = { {
-			.type     = EM28XX_VMUX_COMPOSITE1,
+			.type     = EM28XX_VMUX_COMPOSITE,
 			.vmux     = SAA7115_COMPOSITE0,
 			.amux     = EM28XX_AMUX_LINE_IN,
 		}, {
@@ -2023,7 +2023,7 @@ struct em28xx_board em28xx_boards[] = {
 		.xclk            = EM28XX_XCLK_FREQUENCY_12MHZ,
 		.mute_gpio       = terratec_av350_mute_gpio,
 		.input           = { {
-			.type     = EM28XX_VMUX_COMPOSITE1,
+			.type     = EM28XX_VMUX_COMPOSITE,
 			.vmux     = TVP5150_COMPOSITE1,
 			.amux     = EM28XX_AUDIO_SRC_LINE,
 			.gpio     = terratec_av350_unmute_gpio,
@@ -2041,7 +2041,7 @@ struct em28xx_board em28xx_boards[] = {
 		.decoder      = EM28XX_SAA711X,
 		.tuner_type   = TUNER_ABSENT,   /* Capture only device */
 		.input        = { {
-			.type  = EM28XX_VMUX_COMPOSITE1,
+			.type  = EM28XX_VMUX_COMPOSITE,
 			.vmux  = SAA7115_COMPOSITE0,
 			.amux  = EM28XX_AMUX_LINE_IN,
 		}, {
@@ -2067,7 +2067,7 @@ struct em28xx_board em28xx_boards[] = {
 			.amux     = EM28XX_AMUX_VIDEO,
 			.gpio     = evga_indtube_analog,
 		}, {
-			.type     = EM28XX_VMUX_COMPOSITE1,
+			.type     = EM28XX_VMUX_COMPOSITE,
 			.vmux     = TVP5150_COMPOSITE1,
 			.amux     = EM28XX_AMUX_LINE_IN,
 			.gpio     = evga_indtube_analog,
@@ -2125,7 +2125,7 @@ struct em28xx_board em28xx_boards[] = {
 		.tuner_type          = TUNER_ABSENT,
 		.decoder             = EM28XX_SAA711X,
 		.input               = { {
-			.type     = EM28XX_VMUX_COMPOSITE1,
+			.type     = EM28XX_VMUX_COMPOSITE,
 			.vmux     = SAA7115_COMPOSITE0,
 			.amux     = EM28XX_AMUX_LINE_IN,
 		}, {
@@ -2238,7 +2238,7 @@ struct em28xx_board em28xx_boards[] = {
 		.tuner_type   = TUNER_ABSENT,
 		.is_webcam    = 1,
 		.input        = { {
-			.type     = EM28XX_VMUX_COMPOSITE1,
+			.type     = EM28XX_VMUX_COMPOSITE,
 			.amux     = EM28XX_AMUX_VIDEO,
 			.gpio     = speedlink_vad_laplace_reg_seq,
 		} },
@@ -2272,7 +2272,7 @@ struct em28xx_board em28xx_boards[] = {
 		.tuner_type    = TUNER_ABSENT,	/* Capture only device */
 		.decoder       = EM28XX_TVP5150,
 		.input         = { {
-			.type     = EM28XX_VMUX_COMPOSITE1,
+			.type     = EM28XX_VMUX_COMPOSITE,
 			.vmux     = TVP5150_COMPOSITE1,
 			.amux     = EM28XX_AMUX_LINE_IN,
 		}, {
diff --git a/drivers/media/usb/em28xx/em28xx-video.c b/drivers/media/usb/em28xx/em28xx-video.c
index 6a015e8e8655..52428b4cce5f 100644
--- a/drivers/media/usb/em28xx/em28xx-video.c
+++ b/drivers/media/usb/em28xx/em28xx-video.c
@@ -1442,16 +1442,11 @@ static int vidioc_s_parm(struct file *file, void *priv,
 					  0, video, s_parm, p);
 }
 
-static const char *iname[] = {
-	[EM28XX_VMUX_COMPOSITE1] = "Composite1",
-	[EM28XX_VMUX_COMPOSITE2] = "Composite2",
-	[EM28XX_VMUX_COMPOSITE3] = "Composite3",
-	[EM28XX_VMUX_COMPOSITE4] = "Composite4",
-	[EM28XX_VMUX_SVIDEO]     = "S-Video",
+static const char * const iname[] = {
+	[EM28XX_VMUX_COMPOSITE]	 = "Composite",
+	[EM28XX_VMUX_SVIDEO]	 = "S-Video",
 	[EM28XX_VMUX_TELEVISION] = "Television",
-	[EM28XX_VMUX_CABLE]      = "Cable TV",
-	[EM28XX_VMUX_DVB]        = "DVB",
-	[EM28XX_VMUX_DEBUG]      = "for debug only",
+	[EM28XX_RADIO]		 = "Radio",
 };
 
 static int vidioc_enum_input(struct file *file, void *priv,
@@ -1471,8 +1466,7 @@ static int vidioc_enum_input(struct file *file, void *priv,
 
 	strcpy(i->name, iname[INPUT(n)->type]);
 
-	if ((EM28XX_VMUX_TELEVISION == INPUT(n)->type) ||
-	    (EM28XX_VMUX_CABLE == INPUT(n)->type))
+	if ((EM28XX_VMUX_TELEVISION == INPUT(n)->type))
 		i->type = V4L2_INPUT_TYPE_TUNER;
 
 	i->std = dev->v4l2->vdev.tvnorms;
diff --git a/drivers/media/usb/em28xx/em28xx.h b/drivers/media/usb/em28xx/em28xx.h
index 8ff066c977d9..b23bf6a64011 100644
--- a/drivers/media/usb/em28xx/em28xx.h
+++ b/drivers/media/usb/em28xx/em28xx.h
@@ -291,15 +291,9 @@ struct em28xx_dmaqueue {
 
 #define MAX_EM28XX_INPUT 4
 enum enum28xx_itype {
-	EM28XX_VMUX_COMPOSITE1 = 1,
-	EM28XX_VMUX_COMPOSITE2,
-	EM28XX_VMUX_COMPOSITE3,
-	EM28XX_VMUX_COMPOSITE4,
+	EM28XX_VMUX_COMPOSITE = 1,
 	EM28XX_VMUX_SVIDEO,
 	EM28XX_VMUX_TELEVISION,
-	EM28XX_VMUX_CABLE,
-	EM28XX_VMUX_DVB,
-	EM28XX_VMUX_DEBUG,
 	EM28XX_RADIO,
 };
 
-- 
2.5.0


