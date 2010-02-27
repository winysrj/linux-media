Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-out26.alice.it ([85.33.2.26]:1198 "EHLO
	smtp-out26.alice.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030802Ab0B0UbL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 27 Feb 2010 15:31:11 -0500
From: Antonio Ospite <ospite@studenti.unina.it>
To: linux-media@vger.kernel.org
Cc: Antonio Ospite <ospite@studenti.unina.it>,
	Jean-Francois Moine <moinejf@free.fr>,
	Max Thrun <bear24rw@gmail.com>
Subject: [PATCH 02/11] ov534: Remove hue control
Date: Sat, 27 Feb 2010 21:20:19 +0100
Message-Id: <1267302028-7941-3-git-send-email-ospite@studenti.unina.it>
In-Reply-To: <1267302028-7941-1-git-send-email-ospite@studenti.unina.it>
References: <1267302028-7941-1-git-send-email-ospite@studenti.unina.it>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hue control doesn't work and the sensor datasheet is not clear about how
to set hue properly.

Signed-off-by: Antonio Ospite <ospite@studenti.unina.it>
---
 linux/drivers/media/video/gspca/ov534.c |   54 ++------------------------------
 1 file changed, 5 insertions(+), 49 deletions(-)

Index: gspca/linux/drivers/media/video/gspca/ov534.c
===================================================================
--- gspca.orig/linux/drivers/media/video/gspca/ov534.c
+++ gspca/linux/drivers/media/video/gspca/ov534.c
@@ -60,7 +60,6 @@
 	u8 contrast;
 	u8 gain;
 	u8 exposure;
-	u8 hue;
 	u8 autogain;
 	u8 awb;
 	s8 sharpness;
@@ -82,8 +81,6 @@
 static int sd_gethflip(struct gspca_dev *gspca_dev, __s32 *val);
 static int sd_setvflip(struct gspca_dev *gspca_dev, __s32 val);
 static int sd_getvflip(struct gspca_dev *gspca_dev, __s32 *val);
-static int sd_sethue(struct gspca_dev *gspca_dev, __s32 val);
-static int sd_gethue(struct gspca_dev *gspca_dev, __s32 *val);
 static int sd_setawb(struct gspca_dev *gspca_dev, __s32 val);
 static int sd_getawb(struct gspca_dev *gspca_dev, __s32 *val);
 static int sd_setbrightness(struct gspca_dev *gspca_dev, __s32 val);
@@ -150,20 +147,6 @@
     },
     {							/* 4 */
 	{
-		.id      = V4L2_CID_HUE,
-		.type    = V4L2_CTRL_TYPE_INTEGER,
-		.name    = "Hue",
-		.minimum = 0,
-		.maximum = 255,
-		.step    = 1,
-#define HUE_DEF 143
-		.default_value = HUE_DEF,
-	},
-	.set = sd_sethue,
-	.get = sd_gethue,
-    },
-    {							/* 5 */
-	{
 	    .id      = V4L2_CID_AUTOGAIN,
 	    .type    = V4L2_CTRL_TYPE_BOOLEAN,
 	    .name    = "Autogain",
@@ -176,8 +159,8 @@
 	.set = sd_setautogain,
 	.get = sd_getautogain,
     },
-#define AWB_IDX 6
-    {							/* 6 */
+#define AWB_IDX 5
+    {							/* 5 */
 	{
 		.id      = V4L2_CID_AUTO_WHITE_BALANCE,
 		.type    = V4L2_CTRL_TYPE_BOOLEAN,
@@ -191,7 +174,7 @@
 	.set = sd_setawb,
 	.get = sd_getawb,
     },
-    {							/* 7 */
+    {							/* 6 */
 	{
 	    .id      = V4L2_CID_SHARPNESS,
 	    .type    = V4L2_CTRL_TYPE_INTEGER,
@@ -205,7 +188,7 @@
 	.set = sd_setsharpness,
 	.get = sd_getsharpness,
     },
-    {							/* 8 */
+    {							/* 7 */
 	{
 	    .id      = V4L2_CID_HFLIP,
 	    .type    = V4L2_CTRL_TYPE_BOOLEAN,
@@ -219,7 +202,7 @@
 	.set = sd_sethflip,
 	.get = sd_gethflip,
     },
-    {							/* 9 */
+    {							/* 8 */
 	{
 	    .id      = V4L2_CID_VFLIP,
 	    .type    = V4L2_CTRL_TYPE_BOOLEAN,
@@ -688,13 +671,6 @@
 	sccb_reg_write(gspca_dev, 0x10, val << 1);
 }
 
-static void sethue(struct gspca_dev *gspca_dev)
-{
-	struct sd *sd = (struct sd *) gspca_dev;
-
-	sccb_reg_write(gspca_dev, 0x01, sd->hue);
-}
-
 static void setautogain(struct gspca_dev *gspca_dev)
 {
 	struct sd *sd = (struct sd *) gspca_dev;
@@ -777,7 +753,6 @@
 	sd->contrast = CONTRAST_DEF;
 	sd->gain = GAIN_DEF;
 	sd->exposure = EXPO_DEF;
-	sd->hue = HUE_DEF;
 #if AUTOGAIN_DEF != 0
 	sd->autogain = AUTOGAIN_DEF;
 #else
@@ -857,7 +832,6 @@
 	setautogain(gspca_dev);
 	setawb(gspca_dev);
 	setgain(gspca_dev);
-	sethue(gspca_dev);
 	setexposure(gspca_dev);
 	setbrightness(gspca_dev);
 	setcontrast(gspca_dev);
@@ -1040,24 +1014,6 @@
 	return 0;
 }
 
-static int sd_sethue(struct gspca_dev *gspca_dev, __s32 val)
-{
-	struct sd *sd = (struct sd *) gspca_dev;
-
-	sd->hue = val;
-	if (gspca_dev->streaming)
-		sethue(gspca_dev);
-	return 0;
-}
-
-static int sd_gethue(struct gspca_dev *gspca_dev, __s32 *val)
-{
-	struct sd *sd = (struct sd *) gspca_dev;
-
-	*val = sd->hue;
-	return 0;
-}
-
 static int sd_setautogain(struct gspca_dev *gspca_dev, __s32 val)
 {
 	struct sd *sd = (struct sd *) gspca_dev;
