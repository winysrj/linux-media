Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-out108.alice.it ([85.37.17.108]:3632 "EHLO
	smtp-out108.alice.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030784Ab0B0UbJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 27 Feb 2010 15:31:09 -0500
From: Antonio Ospite <ospite@studenti.unina.it>
To: linux-media@vger.kernel.org
Cc: Max Thrun <bear24rw@gmail.com>,
	Jean-Francois Moine <moinejf@free.fr>,
	Antonio Ospite <ospite@studenti.unina.it>
Subject: [PATCH 01/11] ov534: Remove ambiguous controls
Date: Sat, 27 Feb 2010 21:20:18 +0100
Message-Id: <1267302028-7941-2-git-send-email-ospite@studenti.unina.it>
In-Reply-To: <1267302028-7941-1-git-send-email-ospite@studenti.unina.it>
References: <1267302028-7941-1-git-send-email-ospite@studenti.unina.it>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Max Thrun <bear24rw@gmail.com>

Remove Blue/Red Channel Target Value, they are meant for Black Level
Calibration but it is not completely clear how to use them.

Signed-off-by: Max Thrun <bear24rw@gmail.com>
Signed-off-by: Antonio Ospite <ospite@studenti.unina.it>
---
 linux/drivers/media/video/gspca/ov534.c |  100 +-------------------------------
 1 file changed, 6 insertions(+), 94 deletions(-)

Index: gspca/linux/drivers/media/video/gspca/ov534.c
===================================================================
--- gspca.orig/linux/drivers/media/video/gspca/ov534.c
+++ gspca/linux/drivers/media/video/gspca/ov534.c
@@ -60,8 +60,6 @@
 	u8 contrast;
 	u8 gain;
 	u8 exposure;
-	u8 redblc;
-	u8 blueblc;
 	u8 hue;
 	u8 autogain;
 	u8 awb;
@@ -76,10 +74,6 @@
 static int sd_getgain(struct gspca_dev *gspca_dev, __s32 *val);
 static int sd_setexposure(struct gspca_dev *gspca_dev, __s32 val);
 static int sd_getexposure(struct gspca_dev *gspca_dev, __s32 *val);
-static int sd_setredblc(struct gspca_dev *gspca_dev, __s32 val);
-static int sd_getredblc(struct gspca_dev *gspca_dev, __s32 *val);
-static int sd_setblueblc(struct gspca_dev *gspca_dev, __s32 val);
-static int sd_getblueblc(struct gspca_dev *gspca_dev, __s32 *val);
 static int sd_setautogain(struct gspca_dev *gspca_dev, __s32 val);
 static int sd_getautogain(struct gspca_dev *gspca_dev, __s32 *val);
 static int sd_setsharpness(struct gspca_dev *gspca_dev, __s32 val);
@@ -156,34 +150,6 @@
     },
     {							/* 4 */
 	{
-	    .id      = V4L2_CID_RED_BALANCE,
-	    .type    = V4L2_CTRL_TYPE_INTEGER,
-	    .name    = "Red Balance",
-	    .minimum = 0,
-	    .maximum = 255,
-	    .step    = 1,
-#define RED_BALANCE_DEF 128
-	    .default_value = RED_BALANCE_DEF,
-	},
-	.set = sd_setredblc,
-	.get = sd_getredblc,
-    },
-    {							/* 5 */
-	{
-	    .id      = V4L2_CID_BLUE_BALANCE,
-	    .type    = V4L2_CTRL_TYPE_INTEGER,
-	    .name    = "Blue Balance",
-	    .minimum = 0,
-	    .maximum = 255,
-	    .step    = 1,
-#define BLUE_BALANCE_DEF 128
-	    .default_value = BLUE_BALANCE_DEF,
-	},
-	.set = sd_setblueblc,
-	.get = sd_getblueblc,
-    },
-    {							/* 6 */
-	{
 		.id      = V4L2_CID_HUE,
 		.type    = V4L2_CTRL_TYPE_INTEGER,
 		.name    = "Hue",
@@ -196,7 +162,7 @@
 	.set = sd_sethue,
 	.get = sd_gethue,
     },
-    {							/* 7 */
+    {							/* 5 */
 	{
 	    .id      = V4L2_CID_AUTOGAIN,
 	    .type    = V4L2_CTRL_TYPE_BOOLEAN,
@@ -210,8 +176,8 @@
 	.set = sd_setautogain,
 	.get = sd_getautogain,
     },
-#define AWB_IDX 8
-    {							/* 8 */
+#define AWB_IDX 6
+    {							/* 6 */
 	{
 		.id      = V4L2_CID_AUTO_WHITE_BALANCE,
 		.type    = V4L2_CTRL_TYPE_BOOLEAN,
@@ -225,7 +191,7 @@
 	.set = sd_setawb,
 	.get = sd_getawb,
     },
-    {							/* 9 */
+    {							/* 7 */
 	{
 	    .id      = V4L2_CID_SHARPNESS,
 	    .type    = V4L2_CTRL_TYPE_INTEGER,
@@ -239,7 +205,7 @@
 	.set = sd_setsharpness,
 	.get = sd_getsharpness,
     },
-    {							/* 10 */
+    {							/* 8 */
 	{
 	    .id      = V4L2_CID_HFLIP,
 	    .type    = V4L2_CTRL_TYPE_BOOLEAN,
@@ -253,7 +219,7 @@
 	.set = sd_sethflip,
 	.get = sd_gethflip,
     },
-    {							/* 11 */
+    {							/* 9 */
 	{
 	    .id      = V4L2_CID_VFLIP,
 	    .type    = V4L2_CTRL_TYPE_BOOLEAN,
@@ -722,20 +688,6 @@
 	sccb_reg_write(gspca_dev, 0x10, val << 1);
 }
 
-static void setredblc(struct gspca_dev *gspca_dev)
-{
-	struct sd *sd = (struct sd *) gspca_dev;
-
-	sccb_reg_write(gspca_dev, 0x43, sd->redblc);
-}
-
-static void setblueblc(struct gspca_dev *gspca_dev)
-{
-	struct sd *sd = (struct sd *) gspca_dev;
-
-	sccb_reg_write(gspca_dev, 0x42, sd->blueblc);
-}
-
 static void sethue(struct gspca_dev *gspca_dev)
 {
 	struct sd *sd = (struct sd *) gspca_dev;
@@ -825,8 +777,6 @@
 	sd->contrast = CONTRAST_DEF;
 	sd->gain = GAIN_DEF;
 	sd->exposure = EXPO_DEF;
-	sd->redblc = RED_BALANCE_DEF;
-	sd->blueblc = BLUE_BALANCE_DEF;
 	sd->hue = HUE_DEF;
 #if AUTOGAIN_DEF != 0
 	sd->autogain = AUTOGAIN_DEF;
@@ -907,8 +857,6 @@
 	setautogain(gspca_dev);
 	setawb(gspca_dev);
 	setgain(gspca_dev);
-	setredblc(gspca_dev);
-	setblueblc(gspca_dev);
 	sethue(gspca_dev);
 	setexposure(gspca_dev);
 	setbrightness(gspca_dev);
@@ -1092,42 +1040,6 @@
 	return 0;
 }
 
-static int sd_setredblc(struct gspca_dev *gspca_dev, __s32 val)
-{
-	struct sd *sd = (struct sd *) gspca_dev;
-
-	sd->redblc = val;
-	if (gspca_dev->streaming)
-		setredblc(gspca_dev);
-	return 0;
-}
-
-static int sd_getredblc(struct gspca_dev *gspca_dev, __s32 *val)
-{
-	struct sd *sd = (struct sd *) gspca_dev;
-
-	*val = sd->redblc;
-	return 0;
-}
-
-static int sd_setblueblc(struct gspca_dev *gspca_dev, __s32 val)
-{
-	struct sd *sd = (struct sd *) gspca_dev;
-
-	sd->blueblc = val;
-	if (gspca_dev->streaming)
-		setblueblc(gspca_dev);
-	return 0;
-}
-
-static int sd_getblueblc(struct gspca_dev *gspca_dev, __s32 *val)
-{
-	struct sd *sd = (struct sd *) gspca_dev;
-
-	*val = sd->blueblc;
-	return 0;
-}
-
 static int sd_sethue(struct gspca_dev *gspca_dev, __s32 val)
 {
 	struct sd *sd = (struct sd *) gspca_dev;
