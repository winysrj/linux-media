Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-out108.alice.it ([85.37.17.108]:3632 "EHLO
	smtp-out108.alice.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030798Ab0B0UbK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 27 Feb 2010 15:31:10 -0500
From: Antonio Ospite <ospite@studenti.unina.it>
To: linux-media@vger.kernel.org
Cc: Antonio Ospite <ospite@studenti.unina.it>,
	Jean-Francois Moine <moinejf@free.fr>,
	Max Thrun <bear24rw@gmail.com>
Subject: [PATCH 09/11] ov534: Cosmetics: fix indentation and hex digits
Date: Sat, 27 Feb 2010 21:20:26 +0100
Message-Id: <1267302028-7941-10-git-send-email-ospite@studenti.unina.it>
In-Reply-To: <1267302028-7941-1-git-send-email-ospite@studenti.unina.it>
References: <1267302028-7941-1-git-send-email-ospite@studenti.unina.it>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


  * Indent with tabs, not with spaces.
  * Less indentation for controls index comments.
  * Use lowercase hex digits.

Signed-off-by: Antonio Ospite <ospite@studenti.unina.it>
---
 linux/drivers/media/video/gspca/ov534.c |  128 ++++++++++++++++----------------
 1 file changed, 64 insertions(+), 64 deletions(-)

Index: gspca/linux/drivers/media/video/gspca/ov534.c
===================================================================
--- gspca.orig/linux/drivers/media/video/gspca/ov534.c
+++ gspca/linux/drivers/media/video/gspca/ov534.c
@@ -92,7 +92,7 @@
 static int sd_getcontrast(struct gspca_dev *gspca_dev, __s32 *val);
 
 static const struct ctrl sd_ctrls[] = {
-    {							/* 0 */
+{	/* 0 */
 	{
 		.id      = V4L2_CID_BRIGHTNESS,
 		.type    = V4L2_CTRL_TYPE_INTEGER,
@@ -105,8 +105,8 @@
 	},
 	.set = sd_setbrightness,
 	.get = sd_getbrightness,
-    },
-    {							/* 1 */
+},
+{	/* 1 */
 	{
 		.id      = V4L2_CID_CONTRAST,
 		.type    = V4L2_CTRL_TYPE_INTEGER,
@@ -119,51 +119,51 @@
 	},
 	.set = sd_setcontrast,
 	.get = sd_getcontrast,
-    },
-    {							/* 2 */
+},
+{	/* 2 */
 	{
-	    .id      = V4L2_CID_GAIN,
-	    .type    = V4L2_CTRL_TYPE_INTEGER,
-	    .name    = "Main Gain",
-	    .minimum = 0,
-	    .maximum = 63,
-	    .step    = 1,
+		.id      = V4L2_CID_GAIN,
+		.type    = V4L2_CTRL_TYPE_INTEGER,
+		.name    = "Main Gain",
+		.minimum = 0,
+		.maximum = 63,
+		.step    = 1,
 #define GAIN_DEF 20
-	    .default_value = GAIN_DEF,
+		.default_value = GAIN_DEF,
 	},
 	.set = sd_setgain,
 	.get = sd_getgain,
-    },
-    {							/* 3 */
+},
+{	/* 3 */
 	{
-	    .id      = V4L2_CID_EXPOSURE,
-	    .type    = V4L2_CTRL_TYPE_INTEGER,
-	    .name    = "Exposure",
-	    .minimum = 0,
-	    .maximum = 506,
-	    .step    = 1,
+		.id      = V4L2_CID_EXPOSURE,
+		.type    = V4L2_CTRL_TYPE_INTEGER,
+		.name    = "Exposure",
+		.minimum = 0,
+		.maximum = 506,
+		.step    = 1,
 #define EXPO_DEF 120
-	    .default_value = EXPO_DEF,
+		.default_value = EXPO_DEF,
 	},
 	.set = sd_setexposure,
 	.get = sd_getexposure,
-    },
-    {							/* 4 */
+},
+{	/* 4 */
 	{
-	    .id      = V4L2_CID_AUTOGAIN,
-	    .type    = V4L2_CTRL_TYPE_BOOLEAN,
-	    .name    = "Auto Gain",
-	    .minimum = 0,
-	    .maximum = 1,
-	    .step    = 1,
+		.id      = V4L2_CID_AUTOGAIN,
+		.type    = V4L2_CTRL_TYPE_BOOLEAN,
+		.name    = "Auto Gain",
+		.minimum = 0,
+		.maximum = 1,
+		.step    = 1,
 #define AGC_DEF 1
-	    .default_value = AGC_DEF,
+		.default_value = AGC_DEF,
 	},
 	.set = sd_setagc,
 	.get = sd_getagc,
-    },
+},
 #define AWB_IDX 5
-    {							/* 5 */
+{	/* 5 */
 	{
 		.id      = V4L2_CID_AUTO_WHITE_BALANCE,
 		.type    = V4L2_CTRL_TYPE_BOOLEAN,
@@ -176,8 +176,8 @@
 	},
 	.set = sd_setawb,
 	.get = sd_getawb,
-    },
-    {							/* 6 */
+},
+{	/* 6 */
 	{
 		.id      = V4L2_CID_EXPOSURE_AUTO,
 		.type    = V4L2_CTRL_TYPE_BOOLEAN,
@@ -190,49 +190,49 @@
 	},
 	.set = sd_setaec,
 	.get = sd_getaec,
-    },
-    {							/* 7 */
+},
+{	/* 7 */
 	{
-	    .id      = V4L2_CID_SHARPNESS,
-	    .type    = V4L2_CTRL_TYPE_INTEGER,
-	    .name    = "Sharpness",
-	    .minimum = 0,
-	    .maximum = 63,
-	    .step    = 1,
+		.id      = V4L2_CID_SHARPNESS,
+		.type    = V4L2_CTRL_TYPE_INTEGER,
+		.name    = "Sharpness",
+		.minimum = 0,
+		.maximum = 63,
+		.step    = 1,
 #define SHARPNESS_DEF 0
-	    .default_value = SHARPNESS_DEF,
+		.default_value = SHARPNESS_DEF,
 	},
 	.set = sd_setsharpness,
 	.get = sd_getsharpness,
-    },
-    {							/* 8 */
+},
+{	/* 8 */
 	{
-	    .id      = V4L2_CID_HFLIP,
-	    .type    = V4L2_CTRL_TYPE_BOOLEAN,
-	    .name    = "HFlip",
-	    .minimum = 0,
-	    .maximum = 1,
-	    .step    = 1,
+		.id      = V4L2_CID_HFLIP,
+		.type    = V4L2_CTRL_TYPE_BOOLEAN,
+		.name    = "HFlip",
+		.minimum = 0,
+		.maximum = 1,
+		.step    = 1,
 #define HFLIP_DEF 0
-	    .default_value = HFLIP_DEF,
+		.default_value = HFLIP_DEF,
 	},
 	.set = sd_sethflip,
 	.get = sd_gethflip,
-    },
-    {							/* 9 */
+},
+{	/* 9 */
 	{
-	    .id      = V4L2_CID_VFLIP,
-	    .type    = V4L2_CTRL_TYPE_BOOLEAN,
-	    .name    = "VFlip",
-	    .minimum = 0,
-	    .maximum = 1,
-	    .step    = 1,
+		.id      = V4L2_CID_VFLIP,
+		.type    = V4L2_CTRL_TYPE_BOOLEAN,
+		.name    = "VFlip",
+		.minimum = 0,
+		.maximum = 1,
+		.step    = 1,
 #define VFLIP_DEF 0
-	    .default_value = VFLIP_DEF,
+		.default_value = VFLIP_DEF,
 	},
 	.set = sd_setvflip,
 	.get = sd_getvflip,
-    },
+},
 };
 
 static const struct v4l2_pix_format ov772x_mode[] = {
@@ -641,14 +641,14 @@
 {
 	struct sd *sd = (struct sd *) gspca_dev;
 
-	sccb_reg_write(gspca_dev, 0x9B, sd->brightness);
+	sccb_reg_write(gspca_dev, 0x9b, sd->brightness);
 }
 
 static void setcontrast(struct gspca_dev *gspca_dev)
 {
 	struct sd *sd = (struct sd *) gspca_dev;
 
-	sccb_reg_write(gspca_dev, 0x9C, sd->contrast);
+	sccb_reg_write(gspca_dev, 0x9c, sd->contrast);
 }
 
 static void setgain(struct gspca_dev *gspca_dev)
