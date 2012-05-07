Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:47080 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754999Ab2EGTUi (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 7 May 2012 15:20:38 -0400
From: Hans de Goede <hdegoede@redhat.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: hverkuil@xs4all.nl, Hans de Goede <hdegoede@redhat.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 10/23] gspca_zc3xx: Fix JPEG quality setting code
Date: Mon,  7 May 2012 21:01:21 +0200
Message-Id: <1336417294-4566-11-git-send-email-hdegoede@redhat.com>
In-Reply-To: <1336417294-4566-1-git-send-email-hdegoede@redhat.com>
References: <1336417294-4566-1-git-send-email-hdegoede@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The current code is using bits 0-1 of register 8 of the zc3xx controller
to set the JPEG quality, but the correct bits are bits 1-2. Bit 0 selects
between truncation or rounding in the quantization phase of the compression,
since rounding generally gives better results it should thus always be 1.

This patch also corrects the quality percentages which belong to the 4
different settings.

Last this patch removes the different reg 8 defaults depending on the sensor
type. Some of them where going for a default quality setting of 50%, which
generally is not necessary in any way and results in poor image quality.
75% is a good default to use for all scenarios.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/video/gspca/zc3xx.c |   64 +++++++++++++------------------------
 1 file changed, 22 insertions(+), 42 deletions(-)

diff --git a/drivers/media/video/gspca/zc3xx.c b/drivers/media/video/gspca/zc3xx.c
index c7c9d11..f770676 100644
--- a/drivers/media/video/gspca/zc3xx.c
+++ b/drivers/media/video/gspca/zc3xx.c
@@ -32,7 +32,7 @@ MODULE_LICENSE("GPL");
 
 static int force_sensor = -1;
 
-#define REG08_DEF 3		/* default JPEG compression (70%) */
+#define REG08_DEF 3		/* default JPEG compression (75%) */
 #include "zc3xx-reg.h"
 
 /* controls */
@@ -193,10 +193,10 @@ static const struct ctrl sd_ctrls[NCTRLS] = {
 		.id	 = V4L2_CID_JPEG_COMPRESSION_QUALITY,
 		.type    = V4L2_CTRL_TYPE_INTEGER,
 		.name    = "Compression Quality",
-		.minimum = 40,
-		.maximum = 70,
+		.minimum = 50,
+		.maximum = 94,
 		.step    = 1,
-		.default_value = 70	/* updated in sd_init() */
+		.default_value = 75,
 	    },
 	    .set = sd_setquality
 	},
@@ -241,8 +241,8 @@ static const struct v4l2_pix_format sif_mode[] = {
 		.priv = 0},
 };
 
-/* bridge reg08 -> JPEG quality conversion table */
-static u8 jpeg_qual[] = {40, 50, 60, 70, /*80*/};
+/* bridge reg08 bits 1-2 -> JPEG quality conversion table */
+static u8 jpeg_qual[] = {50, 75, 87, 94};
 
 /* usb exchanges */
 struct usb_action {
@@ -5923,7 +5923,7 @@ static void setquality(struct gspca_dev *gspca_dev)
 	struct sd *sd = (struct sd *) gspca_dev;
 	s8 reg07;
 
-	jpeg_set_qual(sd->jpeg_hdr, jpeg_qual[sd->reg08]);
+	jpeg_set_qual(sd->jpeg_hdr, jpeg_qual[sd->reg08 >> 1]);
 
 	reg07 = 0;
 	switch (sd->sensor) {
@@ -6079,11 +6079,12 @@ static void transfer_update(struct work_struct *work)
 	struct sd *sd = container_of(work, struct sd, work);
 	struct gspca_dev *gspca_dev = &sd->gspca_dev;
 	int change, good;
-	u8 reg07, reg11;
+	u8 reg07, qual, reg11;
 
 	/* synchronize with the main driver and initialize the registers */
 	mutex_lock(&gspca_dev->usb_lock);
 	reg07 = 0;					/* max */
+	qual = sd->reg08 >> 1;
 	reg_w(gspca_dev, reg07, 0x0007);
 	reg_w(gspca_dev, sd->reg08, ZC3XX_R008_CLOCKSETTING);
 	mutex_unlock(&gspca_dev->usb_lock);
@@ -6108,9 +6109,9 @@ static void transfer_update(struct work_struct *work)
 			case 0:				/* max */
 				reg07 = sd->sensor == SENSOR_HV7131R
 						? 0x30 : 0x32;
-				if (sd->reg08 != 0) {
+				if (qual != 0) {
 					change = 3;
-					sd->reg08--;
+					qual--;
 				}
 				break;
 			case 0x32:
@@ -6143,10 +6144,10 @@ static void transfer_update(struct work_struct *work)
 					}
 				}
 			} else {			/* reg07 max */
-				if (sd->reg08 < sizeof jpeg_qual - 1) {
+				if (qual < sizeof jpeg_qual - 1) {
 					good++;
 					if (good > 10) {
-						sd->reg08++;
+						qual++;
 						change = 2;
 					}
 				}
@@ -6161,15 +6162,16 @@ static void transfer_update(struct work_struct *work)
 					goto err;
 			}
 			if (change & 2) {
+				sd->reg08 = (qual << 1) | 1;
 				reg_w(gspca_dev, sd->reg08,
 						ZC3XX_R008_CLOCKSETTING);
 				if (gspca_dev->usb_err < 0
 				 || !gspca_dev->present
 				 || !gspca_dev->streaming)
 					goto err;
-				sd->ctrls[QUALITY].val = jpeg_qual[sd->reg08];
+				sd->ctrls[QUALITY].val = jpeg_qual[qual];
 				jpeg_set_qual(sd->jpeg_hdr,
-						jpeg_qual[sd->reg08]);
+						jpeg_qual[qual]);
 			}
 		}
 		mutex_unlock(&gspca_dev->usb_lock);
@@ -6561,27 +6563,6 @@ static int sd_init(struct gspca_dev *gspca_dev)
 		[SENSOR_PO2030] =	1,
 		[SENSOR_TAS5130C] =	1,
 	};
-	static const u8 reg08_tb[SENSOR_MAX] = {
-		[SENSOR_ADCM2700] =	1,
-		[SENSOR_CS2102] =	3,
-		[SENSOR_CS2102K] =	3,
-		[SENSOR_GC0303] =	2,
-		[SENSOR_GC0305] =	3,
-		[SENSOR_HDCS2020] =	1,
-		[SENSOR_HV7131B] =	3,
-		[SENSOR_HV7131R] =	3,
-		[SENSOR_ICM105A] =	3,
-		[SENSOR_MC501CB] =	3,
-		[SENSOR_MT9V111_1] =	3,
-		[SENSOR_MT9V111_3] =	3,
-		[SENSOR_OV7620] =	1,
-		[SENSOR_OV7630C] =	3,
-		[SENSOR_PAS106] =	3,
-		[SENSOR_PAS202B] =	3,
-		[SENSOR_PB0330] =	3,
-		[SENSOR_PO2030] =	2,
-		[SENSOR_TAS5130C] =	3,
-	};
 
 	sensor = zcxx_probeSensor(gspca_dev);
 	if (sensor >= 0)
@@ -6733,8 +6714,7 @@ static int sd_init(struct gspca_dev *gspca_dev)
 	}
 
 	sd->ctrls[GAMMA].def = gamma[sd->sensor];
-	sd->reg08 = reg08_tb[sd->sensor];
-	sd->ctrls[QUALITY].def = jpeg_qual[sd->reg08];
+	sd->ctrls[QUALITY].def = jpeg_qual[sd->reg08 >> 1];
 	sd->ctrls[QUALITY].min = jpeg_qual[0];
 	sd->ctrls[QUALITY].max = jpeg_qual[ARRAY_SIZE(jpeg_qual) - 1];
 
@@ -7029,17 +7009,17 @@ static int sd_querymenu(struct gspca_dev *gspca_dev,
 static int sd_setquality(struct gspca_dev *gspca_dev, __s32 val)
 {
 	struct sd *sd = (struct sd *) gspca_dev;
-	int i;
+	int i, qual = sd->reg08 >> 1;
 
-	for (i = 0; i < ARRAY_SIZE(jpeg_qual) - 1; i++) {
+	for (i = 0; i < ARRAY_SIZE(jpeg_qual); i++) {
 		if (val <= jpeg_qual[i])
 			break;
 	}
 	if (i > 0
-	 && i == sd->reg08
-	 && val < jpeg_qual[sd->reg08])
+	 && i == qual
+	 && val < jpeg_qual[i])
 		i--;
-	sd->reg08 = i;
+	sd->reg08 = (i << 1) | 1;
 	sd->ctrls[QUALITY].val = jpeg_qual[i];
 	if (gspca_dev->streaming)
 		setquality(gspca_dev);
-- 
1.7.10

