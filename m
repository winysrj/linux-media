Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-out04.alice.it ([85.37.17.100]:2370 "EHLO
	smtp-out04.alice.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030784Ab0B0UZ6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 27 Feb 2010 15:25:58 -0500
From: Antonio Ospite <ospite@studenti.unina.it>
To: linux-media@vger.kernel.org
Cc: Mosalam Ebrahimi <m.ebrahimi@ieee.org>,
	Jean-Francois Moine <moinejf@free.fr>,
	Max Thrun <bear24rw@gmail.com>,
	Antonio Ospite <ospite@studenti.unina.it>
Subject: [PATCH 10/11] ov534: Add Powerline Frequency control
Date: Sat, 27 Feb 2010 21:20:27 +0100
Message-Id: <1267302028-7941-11-git-send-email-ospite@studenti.unina.it>
In-Reply-To: <1267302028-7941-1-git-send-email-ospite@studenti.unina.it>
References: <1267302028-7941-1-git-send-email-ospite@studenti.unina.it>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Mosalam Ebrahimi <m.ebrahimi@ieee.org>

Note that setting this options to 50Hz can reduce the framerate, so the
default is still 60Hz.

Signed-off-by: Mosalam Ebrahimi <m.ebrahimi@ieee.org>
Signed-off-by: Antonio Ospite <ospite@studenti.unina.it>
---
 linux/drivers/media/video/gspca/ov534.c |   71 +++++++++++++++++++++++++++++++-
 1 file changed, 70 insertions(+), 1 deletion(-)

Index: gspca/linux/drivers/media/video/gspca/ov534.c
===================================================================
--- gspca.orig/linux/drivers/media/video/gspca/ov534.c
+++ gspca/linux/drivers/media/video/gspca/ov534.c
@@ -66,7 +66,7 @@
 	s8 sharpness;
 	u8 hflip;
 	u8 vflip;
-
+	u8 freqfltr;
 };
 
 /* V4L2 controls supported by the driver */
@@ -90,6 +90,10 @@
 static int sd_getbrightness(struct gspca_dev *gspca_dev, __s32 *val);
 static int sd_setcontrast(struct gspca_dev *gspca_dev, __s32 val);
 static int sd_getcontrast(struct gspca_dev *gspca_dev, __s32 *val);
+static int sd_setfreqfltr(struct gspca_dev *gspca_dev, __s32 val);
+static int sd_getfreqfltr(struct gspca_dev *gspca_dev, __s32 *val);
+static int sd_querymenu(struct gspca_dev *gspca_dev,
+		struct v4l2_querymenu *menu);
 
 static const struct ctrl sd_ctrls[] = {
 {	/* 0 */
@@ -233,6 +237,20 @@
 	.set = sd_setvflip,
 	.get = sd_getvflip,
 },
+{	/* 10 */
+	{
+		.id      = V4L2_CID_POWER_LINE_FREQUENCY,
+		.type    = V4L2_CTRL_TYPE_MENU,
+		.name    = "Light Frequency Filter",
+		.minimum = 0,
+		.maximum = 1,
+		.step    = 1,
+#define FREQFLTR_DEF 1
+		.default_value = FREQFLTR_DEF,
+	},
+	.set = sd_setfreqfltr,
+	.get = sd_getfreqfltr,
+},
 };
 
 static const struct v4l2_pix_format ov772x_mode[] = {
@@ -779,6 +797,17 @@
 				sccb_reg_read(gspca_dev, 0x0c) & ~0x80);
 }
 
+static void setfreqfltr(struct gspca_dev *gspca_dev)
+{
+	struct sd *sd = (struct sd *) gspca_dev;
+
+	if (sd->freqfltr == 0)
+		sccb_reg_write(gspca_dev, 0x2b, 0x9e);
+	else
+		sccb_reg_write(gspca_dev, 0x2b, 0x00);
+}
+
+
 /* this function is called at probe time */
 static int sd_config(struct gspca_dev *gspca_dev,
 		     const struct usb_device_id *id)
@@ -812,6 +841,7 @@
 	sd->sharpness = SHARPNESS_DEF;
 	sd->hflip = HFLIP_DEF;
 	sd->vflip = VFLIP_DEF;
+	sd->freqfltr = FREQFLTR_DEF;
 
 	return 0;
 }
@@ -881,6 +911,7 @@
 	setsharpness(gspca_dev);
 	setvflip(gspca_dev);
 	sethflip(gspca_dev);
+	setfreqfltr(gspca_dev);
 
 	ov534_set_led(gspca_dev, 1);
 	ov534_reg_write(gspca_dev, 0xe0, 0x00);
@@ -1174,6 +1205,43 @@
 	return 0;
 }
 
+static int sd_setfreqfltr(struct gspca_dev *gspca_dev, __s32 val)
+{
+	struct sd *sd = (struct sd *) gspca_dev;
+
+	sd->freqfltr = val;
+	if (gspca_dev->streaming)
+		setfreqfltr(gspca_dev);
+	return 0;
+}
+
+static int sd_getfreqfltr(struct gspca_dev *gspca_dev, __s32 *val)
+{
+	struct sd *sd = (struct sd *) gspca_dev;
+
+	*val = sd->freqfltr;
+	return 0;
+}
+
+static int sd_querymenu(struct gspca_dev *gspca_dev,
+		struct v4l2_querymenu *menu)
+{
+	switch (menu->id) {
+	case V4L2_CID_POWER_LINE_FREQUENCY:
+		switch (menu->index) {
+		case 0:         /* V4L2_CID_POWER_LINE_FREQUENCY_50HZ */
+			strcpy((char *) menu->name, "50 Hz");
+			return 0;
+		case 1:         /* V4L2_CID_POWER_LINE_FREQUENCY_60HZ */
+			strcpy((char *) menu->name, "60 Hz");
+			return 0;
+		}
+		break;
+	}
+
+	return -EINVAL;
+}
+
 /* get stream parameters (framerate) */
 static int sd_get_streamparm(struct gspca_dev *gspca_dev,
 			     struct v4l2_streamparm *parm)
@@ -1225,6 +1293,7 @@
 	.start    = sd_start,
 	.stopN    = sd_stopN,
 	.pkt_scan = sd_pkt_scan,
+	.querymenu = sd_querymenu,
 	.get_streamparm = sd_get_streamparm,
 	.set_streamparm = sd_set_streamparm,
 };
