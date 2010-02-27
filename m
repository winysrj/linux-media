Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-out108.alice.it ([85.37.17.108]:3632 "EHLO
	smtp-out108.alice.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030784Ab0B0UbL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 27 Feb 2010 15:31:11 -0500
From: Antonio Ospite <ospite@studenti.unina.it>
To: linux-media@vger.kernel.org
Cc: Max Thrun <bear24rw@gmail.com>,
	Jean-Francois Moine <moinejf@free.fr>,
	Antonio Ospite <ospite@studenti.unina.it>
Subject: [PATCH 03/11] ov534: Fix autogain control, enable it by default
Date: Sat, 27 Feb 2010 21:20:20 +0100
Message-Id: <1267302028-7941-4-git-send-email-ospite@studenti.unina.it>
In-Reply-To: <1267302028-7941-1-git-send-email-ospite@studenti.unina.it>
References: <1267302028-7941-1-git-send-email-ospite@studenti.unina.it>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Max Thrun <bear24rw@gmail.com>

  * Use 'agc' instead of 'autogain' in the code so to align the naming
    as in AEC/AWB.
  * Tweak brightness and contrast default values.
  * Fix setting/resetting registers values for AGC.
  * Set actual gain back when disabling AGC.
  * Skip setting GAIN register when AGC is enabled.
  * Enable AGC by default.

Note that as Auto Gain Control is now enabled by default, if you are
using the driver for visual computing applications you might need to
disable it explicitly in your software.

Signed-off-by: Max Thrun <bear24rw@gmail.com>
Signed-off-by: Antonio Ospite <ospite@studenti.unina.it>
---
 linux/drivers/media/video/gspca/ov534.c |   53 ++++++++++++++++++--------------
 1 file changed, 30 insertions(+), 23 deletions(-)

Index: gspca/linux/drivers/media/video/gspca/ov534.c
===================================================================
--- gspca.orig/linux/drivers/media/video/gspca/ov534.c
+++ gspca/linux/drivers/media/video/gspca/ov534.c
@@ -60,7 +60,7 @@
 	u8 contrast;
 	u8 gain;
 	u8 exposure;
-	u8 autogain;
+	u8 agc;
 	u8 awb;
 	s8 sharpness;
 	u8 hflip;
@@ -73,8 +73,8 @@
 static int sd_getgain(struct gspca_dev *gspca_dev, __s32 *val);
 static int sd_setexposure(struct gspca_dev *gspca_dev, __s32 val);
 static int sd_getexposure(struct gspca_dev *gspca_dev, __s32 *val);
-static int sd_setautogain(struct gspca_dev *gspca_dev, __s32 val);
-static int sd_getautogain(struct gspca_dev *gspca_dev, __s32 *val);
+static int sd_setagc(struct gspca_dev *gspca_dev, __s32 val);
+static int sd_getagc(struct gspca_dev *gspca_dev, __s32 *val);
 static int sd_setsharpness(struct gspca_dev *gspca_dev, __s32 val);
 static int sd_getsharpness(struct gspca_dev *gspca_dev, __s32 *val);
 static int sd_sethflip(struct gspca_dev *gspca_dev, __s32 val);
@@ -97,7 +97,7 @@
 		.minimum = 0,
 		.maximum = 255,
 		.step    = 1,
-#define BRIGHTNESS_DEF 20
+#define BRIGHTNESS_DEF 0
 		.default_value = BRIGHTNESS_DEF,
 	},
 	.set = sd_setbrightness,
@@ -111,7 +111,7 @@
 		.minimum = 0,
 		.maximum = 255,
 		.step    = 1,
-#define CONTRAST_DEF 37
+#define CONTRAST_DEF 32
 		.default_value = CONTRAST_DEF,
 	},
 	.set = sd_setcontrast,
@@ -149,15 +149,15 @@
 	{
 	    .id      = V4L2_CID_AUTOGAIN,
 	    .type    = V4L2_CTRL_TYPE_BOOLEAN,
-	    .name    = "Autogain",
+	    .name    = "Auto Gain",
 	    .minimum = 0,
 	    .maximum = 1,
 	    .step    = 1,
-#define AUTOGAIN_DEF 0
-	    .default_value = AUTOGAIN_DEF,
+#define AGC_DEF 1
+	    .default_value = AGC_DEF,
 	},
-	.set = sd_setautogain,
-	.get = sd_getautogain,
+	.set = sd_setagc,
+	.get = sd_getagc,
     },
 #define AWB_IDX 5
     {							/* 5 */
@@ -639,6 +639,9 @@
 	struct sd *sd = (struct sd *) gspca_dev;
 	u8 val;
 
+	if (sd->agc)
+		return;
+
 	val = sd->gain;
 	switch (val & 0x30) {
 	case 0x00:
@@ -671,18 +674,22 @@
 	sccb_reg_write(gspca_dev, 0x10, val << 1);
 }
 
-static void setautogain(struct gspca_dev *gspca_dev)
+static void setagc(struct gspca_dev *gspca_dev)
 {
 	struct sd *sd = (struct sd *) gspca_dev;
 
-	if (sd->autogain) {
-		sccb_reg_write(gspca_dev, 0x13, 0xf7); /* AGC,AEC,AWB ON */
+	if (sd->agc) {
+		sccb_reg_write(gspca_dev, 0x13,
+				sccb_reg_read(gspca_dev, 0x13) | 0x04);
 		sccb_reg_write(gspca_dev, 0x64,
 				sccb_reg_read(gspca_dev, 0x64) | 0x03);
 	} else {
-		sccb_reg_write(gspca_dev, 0x13, 0xf0); /* AGC,AEC,AWB OFF */
+		sccb_reg_write(gspca_dev, 0x13,
+				sccb_reg_read(gspca_dev, 0x13) & ~0x04);
 		sccb_reg_write(gspca_dev, 0x64,
-				sccb_reg_read(gspca_dev, 0x64) & 0xfc);
+				sccb_reg_read(gspca_dev, 0x64) & ~0x03);
+
+		setgain(gspca_dev);
 	}
 }
 
@@ -753,8 +760,8 @@
 	sd->contrast = CONTRAST_DEF;
 	sd->gain = GAIN_DEF;
 	sd->exposure = EXPO_DEF;
-#if AUTOGAIN_DEF != 0
-	sd->autogain = AUTOGAIN_DEF;
+#if AGC_DEF != 0
+	sd->agc = AGC_DEF;
 #else
 	gspca_dev->ctrl_inac |= (1 << AWB_IDX);
 #endif
@@ -829,7 +836,7 @@
 	}
 	set_frame_rate(gspca_dev);
 
-	setautogain(gspca_dev);
+	setagc(gspca_dev);
 	setawb(gspca_dev);
 	setgain(gspca_dev);
 	setexposure(gspca_dev);
@@ -1014,11 +1021,11 @@
 	return 0;
 }
 
-static int sd_setautogain(struct gspca_dev *gspca_dev, __s32 val)
+static int sd_setagc(struct gspca_dev *gspca_dev, __s32 val)
 {
 	struct sd *sd = (struct sd *) gspca_dev;
 
-	sd->autogain = val;
+	sd->agc = val;
 
 	if (gspca_dev->streaming) {
 
@@ -1028,16 +1035,16 @@
 			gspca_dev->ctrl_inac &= ~(1 << AWB_IDX);
 		else
 			gspca_dev->ctrl_inac |= (1 << AWB_IDX);
-		setautogain(gspca_dev);
+		setagc(gspca_dev);
 	}
 	return 0;
 }
 
-static int sd_getautogain(struct gspca_dev *gspca_dev, __s32 *val)
+static int sd_getagc(struct gspca_dev *gspca_dev, __s32 *val)
 {
 	struct sd *sd = (struct sd *) gspca_dev;
 
-	*val = sd->autogain;
+	*val = sd->agc;
 	return 0;
 }
 
