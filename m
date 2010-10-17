Return-path: <mchehab@pedra>
Received: from relay02.digicable.hu ([92.249.128.188]:51280 "EHLO
	relay02.digicable.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750858Ab0JQLbI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 17 Oct 2010 07:31:08 -0400
Message-ID: <4CBAD917.80704@freemail.hu>
Date: Sun, 17 Oct 2010 13:08:07 +0200
From: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
MIME-Version: 1.0
To: Jean-Francois Moine <moinejf@free.fr>
CC: V4L Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 2/2] gspca_sonixj: add hardware horizontal flip support for
 hama AC-150
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

From: Márton Németh <nm127@freemail.hu>

The PO2030N sensor chip found in hama AC-150 webcam supports horizontal flipping
the image by hardware. Add support for this in the gspca_sonixj driver also.

Signed-off-by: Márton Németh <nm127@freemail.hu>
---
diff -upr c/drivers/media/video/gspca/sonixj.c d/drivers/media/video/gspca/sonixj.c
--- c/drivers/media/video/gspca/sonixj.c	2010-10-17 12:08:12.000000000 +0200
+++ d/drivers/media/video/gspca/sonixj.c	2010-10-17 12:28:41.000000000 +0200
@@ -46,6 +46,7 @@ struct sd {
 	u8 red;
 	u8 gamma;
 	u8 vflip;			/* ov7630/ov7648/po2030n only */
+	u8 hflip;			/* po2030n only */
 	u8 sharpness;
 	u8 infrared;			/* mt9v111 only */
 	u8 freq;			/* ov76xx only */
@@ -104,6 +105,8 @@ static int sd_setautogain(struct gspca_d
 static int sd_getautogain(struct gspca_dev *gspca_dev, __s32 *val);
 static int sd_setvflip(struct gspca_dev *gspca_dev, __s32 val);
 static int sd_getvflip(struct gspca_dev *gspca_dev, __s32 *val);
+static int sd_sethflip(struct gspca_dev *gspca_dev, __s32 val);
+static int sd_gethflip(struct gspca_dev *gspca_dev, __s32 *val);
 static int sd_setsharpness(struct gspca_dev *gspca_dev, __s32 val);
 static int sd_getsharpness(struct gspca_dev *gspca_dev, __s32 *val);
 static int sd_setinfrared(struct gspca_dev *gspca_dev, __s32 val);
@@ -235,7 +238,22 @@ static const struct ctrl sd_ctrls[] = {
 	    .set = sd_setvflip,
 	    .get = sd_getvflip,
 	},
-#define SHARPNESS_IDX 8
+#define HFLIP_IDX 8
+	{
+	    {
+		.id      = V4L2_CID_HFLIP,
+		.type    = V4L2_CTRL_TYPE_BOOLEAN,
+		.name    = "Hflip",
+		.minimum = 0,
+		.maximum = 1,
+		.step    = 1,
+#define HFLIP_DEF 0
+		.default_value = HFLIP_DEF,
+	    },
+	    .set = sd_sethflip,
+	    .get = sd_gethflip,
+	},
+#define SHARPNESS_IDX 9
 	{
 	    {
 		.id	 = V4L2_CID_SHARPNESS,
@@ -251,7 +269,7 @@ static const struct ctrl sd_ctrls[] = {
 	    .get = sd_getsharpness,
 	},
 /* mt9v111 only */
-#define INFRARED_IDX 9
+#define INFRARED_IDX 10
 	{
 	    {
 		.id      = V4L2_CID_INFRARED,
@@ -267,7 +285,7 @@ static const struct ctrl sd_ctrls[] = {
 	    .get = sd_getinfrared,
 	},
 /* ov7630/ov7648/ov7660 only */
-#define FREQ_IDX 10
+#define FREQ_IDX 11
 	{
 	    {
 		.id	 = V4L2_CID_POWER_LINE_FREQUENCY,
@@ -289,41 +307,52 @@ static const __u32 ctrl_dis[] = {
 [SENSOR_ADCM1700] =	(1 << AUTOGAIN_IDX) |
 			(1 << INFRARED_IDX) |
 			(1 << VFLIP_IDX) |
+			(1 << HFLIP_IDX) |
 			(1 << FREQ_IDX),

 [SENSOR_GC0307] =	(1 << INFRARED_IDX) |
 			(1 << VFLIP_IDX) |
+			(1 << HFLIP_IDX) |
 			(1 << FREQ_IDX),

 [SENSOR_HV7131R] =	(1 << INFRARED_IDX) |
+			(1 << HFLIP_IDX) |
 			(1 << FREQ_IDX),

 [SENSOR_MI0360] =	(1 << INFRARED_IDX) |
 			(1 << VFLIP_IDX) |
+			(1 << HFLIP_IDX) |
 			(1 << FREQ_IDX),

 [SENSOR_MO4000] =	(1 << INFRARED_IDX) |
 			(1 << VFLIP_IDX) |
+			(1 << HFLIP_IDX) |
 			(1 << FREQ_IDX),

 [SENSOR_MT9V111] =	(1 << VFLIP_IDX) |
+			(1 << HFLIP_IDX) |
 			(1 << FREQ_IDX),

 [SENSOR_OM6802] =	(1 << INFRARED_IDX) |
 			(1 << VFLIP_IDX) |
+			(1 << HFLIP_IDX) |
 			(1 << FREQ_IDX),

-[SENSOR_OV7630] =	(1 << INFRARED_IDX),
+[SENSOR_OV7630] =	(1 << INFRARED_IDX) |
+			(1 << HFLIP_IDX),

-[SENSOR_OV7648] =	(1 << INFRARED_IDX),
+[SENSOR_OV7648] =	(1 << INFRARED_IDX) |
+			(1 << HFLIP_IDX),

 [SENSOR_OV7660] =	(1 << AUTOGAIN_IDX) |
 			(1 << INFRARED_IDX) |
-			(1 << VFLIP_IDX),
+			(1 << VFLIP_IDX) |
+			(1 << HFLIP_IDX),

 [SENSOR_PO1030] =	(1 << AUTOGAIN_IDX) |
 			(1 << INFRARED_IDX) |
 			(1 << VFLIP_IDX) |
+			(1 << HFLIP_IDX) |
 			(1 << FREQ_IDX),

 [SENSOR_PO2030N] =	(1 << AUTOGAIN_IDX) |
@@ -332,11 +361,13 @@ static const __u32 ctrl_dis[] = {
 [SENSOR_SOI768] =	(1 << AUTOGAIN_IDX) |
 			(1 << INFRARED_IDX) |
 			(1 << VFLIP_IDX) |
+			(1 << HFLIP_IDX) |
 			(1 << FREQ_IDX),

 [SENSOR_SP80708] =	(1 << AUTOGAIN_IDX) |
 			(1 << INFRARED_IDX) |
 			(1 << VFLIP_IDX) |
+			(1 << HFLIP_IDX) |
 			(1 << FREQ_IDX),
 };

@@ -1800,6 +1831,7 @@ static int sd_config(struct gspca_dev *g
 	sd->autogain = AUTOGAIN_DEF;
 	sd->ag_cnt = -1;
 	sd->vflip = VFLIP_DEF;
+	sd->hflip = HFLIP_DEF;
 	switch (sd->sensor) {
 	case SENSOR_OM6802:
 		sd->sharpness = 0x10;
@@ -2136,7 +2168,7 @@ static void setautogain(struct gspca_dev
 }

 /* hv7131r/ov7630/ov7648/po2030n only */
-static void setvflip(struct sd *sd)
+static void sethvflip(struct sd *sd)
 {
 	u8 comn;

@@ -2167,6 +2199,8 @@ static void setvflip(struct sd *sd)
 		comn = 0x0A;
 		if (sd->vflip)
 			comn |= 0x40;
+		if (sd->hflip)
+			comn |= 0x80;
 		i2c_w1(&sd->gspca_dev, 0x1E, comn);
 		break;
 	default:
@@ -2551,7 +2585,7 @@ static int sd_start(struct gspca_dev *gs
 	reg_w1(gspca_dev, 0x17, reg17);
 	reg_w1(gspca_dev, 0x01, reg1);

-	setvflip(sd);
+	sethvflip(sd);
 	setbrightness(gspca_dev);
 	setcontrast(gspca_dev);
 	setcolors(gspca_dev);
@@ -2863,7 +2897,7 @@ static int sd_setvflip(struct gspca_dev

 	sd->vflip = val;
 	if (gspca_dev->streaming)
-		setvflip(sd);
+		sethvflip(sd);
 	return 0;
 }

@@ -2875,6 +2909,24 @@ static int sd_getvflip(struct gspca_dev
 	return 0;
 }

+static int sd_sethflip(struct gspca_dev *gspca_dev, __s32 val)
+{
+	struct sd *sd = (struct sd *) gspca_dev;
+
+	sd->hflip = val;
+	if (gspca_dev->streaming)
+		sethvflip(sd);
+	return 0;
+}
+
+static int sd_gethflip(struct gspca_dev *gspca_dev, __s32 *val)
+{
+	struct sd *sd = (struct sd *) gspca_dev;
+
+	*val = sd->hflip;
+	return 0;
+}
+
 static int sd_setinfrared(struct gspca_dev *gspca_dev, __s32 val)
 {
 	struct sd *sd = (struct sd *) gspca_dev;
