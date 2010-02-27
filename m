Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-out30.alice.it ([85.33.2.30]:1625 "EHLO
	smtp-out30.alice.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030811Ab0B0Ubu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 27 Feb 2010 15:31:50 -0500
From: Antonio Ospite <ospite@studenti.unina.it>
To: linux-media@vger.kernel.org
Cc: Max Thrun <bear24rw@gmail.com>,
	Jean-Francois Moine <moinejf@free.fr>,
	Antonio Ospite <ospite@studenti.unina.it>
Subject: [PATCH 04/11] ov534: Add Auto Exposure
Date: Sat, 27 Feb 2010 21:20:21 +0100
Message-Id: <1267302028-7941-5-git-send-email-ospite@studenti.unina.it>
In-Reply-To: <1267302028-7941-1-git-send-email-ospite@studenti.unina.it>
References: <1267302028-7941-1-git-send-email-ospite@studenti.unina.it>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Max Thrun <bear24rw@gmail.com>

This also makes manual exposure actually work: it never worked before
because AEC was always enabled.

Signed-off-by: Max Thrun <bear24rw@gmail.com>
Signed-off-by: Antonio Ospite <ospite@studenti.unina.it>
---
 linux/drivers/media/video/gspca/ov534.c |   55 ++++++++++++++++++++++++++++++--
 1 file changed, 53 insertions(+), 2 deletions(-)

Index: gspca/linux/drivers/media/video/gspca/ov534.c
===================================================================
--- gspca.orig/linux/drivers/media/video/gspca/ov534.c
+++ gspca/linux/drivers/media/video/gspca/ov534.c
@@ -62,6 +62,7 @@
 	u8 exposure;
 	u8 agc;
 	u8 awb;
+	u8 aec;
 	s8 sharpness;
 	u8 hflip;
 	u8 vflip;
@@ -83,6 +84,8 @@
 static int sd_getvflip(struct gspca_dev *gspca_dev, __s32 *val);
 static int sd_setawb(struct gspca_dev *gspca_dev, __s32 val);
 static int sd_getawb(struct gspca_dev *gspca_dev, __s32 *val);
+static int sd_setaec(struct gspca_dev *gspca_dev, __s32 val);
+static int sd_getaec(struct gspca_dev *gspca_dev, __s32 *val);
 static int sd_setbrightness(struct gspca_dev *gspca_dev, __s32 val);
 static int sd_getbrightness(struct gspca_dev *gspca_dev, __s32 *val);
 static int sd_setcontrast(struct gspca_dev *gspca_dev, __s32 val);
@@ -176,6 +179,20 @@
     },
     {							/* 6 */
 	{
+		.id      = V4L2_CID_EXPOSURE_AUTO,
+		.type    = V4L2_CTRL_TYPE_BOOLEAN,
+		.name    = "Auto Exposure",
+		.minimum = 0,
+		.maximum = 1,
+		.step    = 1,
+#define AEC_DEF 1
+		.default_value = AEC_DEF,
+	},
+	.set = sd_setaec,
+	.get = sd_getaec,
+    },
+    {							/* 7 */
+	{
 	    .id      = V4L2_CID_SHARPNESS,
 	    .type    = V4L2_CTRL_TYPE_INTEGER,
 	    .name    = "Sharpness",
@@ -188,7 +205,7 @@
 	.set = sd_setsharpness,
 	.get = sd_getsharpness,
     },
-    {							/* 7 */
+    {							/* 8 */
 	{
 	    .id      = V4L2_CID_HFLIP,
 	    .type    = V4L2_CTRL_TYPE_BOOLEAN,
@@ -202,7 +219,7 @@
 	.set = sd_sethflip,
 	.get = sd_gethflip,
     },
-    {							/* 8 */
+    {							/* 9 */
 	{
 	    .id      = V4L2_CID_VFLIP,
 	    .type    = V4L2_CTRL_TYPE_BOOLEAN,
@@ -703,6 +720,20 @@
 		sccb_reg_write(gspca_dev, 0x63, 0xaa);	/* AWB off */
 }
 
+static void setaec(struct gspca_dev *gspca_dev)
+{
+	struct sd *sd = (struct sd *) gspca_dev;
+
+	if (sd->aec)
+		sccb_reg_write(gspca_dev, 0x13,
+				sccb_reg_read(gspca_dev, 0x13) | 0x01);
+	else {
+		sccb_reg_write(gspca_dev, 0x13,
+				sccb_reg_read(gspca_dev, 0x13) & ~0x01);
+		setexposure(gspca_dev);
+	}
+}
+
 static void setsharpness(struct gspca_dev *gspca_dev)
 {
 	struct sd *sd = (struct sd *) gspca_dev;
@@ -768,6 +799,7 @@
 #if AWB_DEF != 0
 	sd->awb = AWB_DEF
 #endif
+	sd->aec = AEC_DEF;
 #if SHARPNESS_DEF != 0
 	sd->sharpness = SHARPNESS_DEF;
 #endif
@@ -838,6 +870,7 @@
 
 	setagc(gspca_dev);
 	setawb(gspca_dev);
+	setaec(gspca_dev);
 	setgain(gspca_dev);
 	setexposure(gspca_dev);
 	setbrightness(gspca_dev);
@@ -1066,6 +1099,24 @@
 	return 0;
 }
 
+static int sd_setaec(struct gspca_dev *gspca_dev, __s32 val)
+{
+	struct sd *sd = (struct sd *) gspca_dev;
+
+	sd->aec = val;
+	if (gspca_dev->streaming)
+		setaec(gspca_dev);
+	return 0;
+}
+
+static int sd_getaec(struct gspca_dev *gspca_dev, __s32 *val)
+{
+	struct sd *sd = (struct sd *) gspca_dev;
+
+	*val = sd->aec;
+	return 0;
+}
+
 static int sd_setsharpness(struct gspca_dev *gspca_dev, __s32 val)
 {
 	struct sd *sd = (struct sd *) gspca_dev;
