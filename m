Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay01.digicable.hu ([92.249.128.189]:56583 "EHLO
	relay01.digicable.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755143Ab0BXGwR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 24 Feb 2010 01:52:17 -0500
Message-ID: <4B84CC9E.4030600@freemail.hu>
Date: Wed, 24 Feb 2010 07:52:14 +0100
From: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
MIME-Version: 1.0
To: Jean-Francois Moine <moinejf@free.fr>
CC: V4L Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 1/2] gspca pac7302: add LED control
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Márton Németh <nm127@freemail.hu>

On Labtec Webcam 2200 there is a feedback LED which can be controlled
independent from the streaming. The feedback LED can be used from
user space application to show for example detected motion or to
distinguish between the preview and "on-air" state of the video stream.

The default value of the LED control is "Auto" which keeps the previous
behaviour: LED is off when the stream is off, LED is on if the stream is
on.

Signed-off-by: Márton Németh <nm127@freemail.hu>
---
diff -r 4f102b2f7ac1 linux/drivers/media/video/gspca/pac7302.c
--- a/linux/drivers/media/video/gspca/pac7302.c	Thu Jan 28 20:35:40 2010 +0100
+++ b/linux/drivers/media/video/gspca/pac7302.c	Mon Feb 08 20:46:53 2010 +0100
@@ -6,6 +6,7 @@
  *
  * Separated from Pixart PAC7311 library by Márton Németh
  * Camera button input handling by Márton Németh <nm127@freemail.hu>
+ * LED control by Márton Németh <nm127@freemail.hu>
  * Copyright (C) 2009-2010 Márton Németh <nm127@freemail.hu>
  *
  * This program is free software; you can redistribute it and/or modify
@@ -62,6 +63,7 @@
     0   | 0xc6       | setwhitebalance()
     0   | 0xc7       | setbluebalance()
     0   | 0xdc       | setbrightcont(), setcolors()
+    1   | 0x78       | set_streaming_led()
     3   | 0x02       | setexposure()
     3   | 0x10       | setgain()
     3   | 0x11       | setcolors(), setgain(), setexposure(), sethvflip()
@@ -78,6 +80,11 @@
 MODULE_DESCRIPTION("Pixart PAC7302");
 MODULE_LICENSE("GPL");

+#define PAC7302_CID_LED (V4L2_CID_PRIVATE_BASE + 0)
+#define LED_AUTO	0
+#define LED_ON		1
+#define LED_OFF		2
+
 /* specific webcam descriptor for pac7302 */
 struct sd {
 	struct gspca_dev gspca_dev;		/* !! must be the first item */
@@ -91,6 +98,7 @@
 	unsigned char gain;
 	unsigned char exposure;
 	unsigned char autogain;
+	unsigned char led;
 	__u8 hflip;
 	__u8 vflip;
 	u8 flags;
@@ -126,6 +134,8 @@
 static int sd_getgain(struct gspca_dev *gspca_dev, __s32 *val);
 static int sd_setexposure(struct gspca_dev *gspca_dev, __s32 val);
 static int sd_getexposure(struct gspca_dev *gspca_dev, __s32 *val);
+static int sd_setled(struct gspca_dev *gspca_dev, __s32 val);
+static int sd_getled(struct gspca_dev *gspca_dev, __s32 *val);

 static const struct ctrl sd_ctrls[] = {
 /* This control is pac7302 only */
@@ -293,6 +303,20 @@
 	    .set = sd_setvflip,
 	    .get = sd_getvflip,
 	},
+	{
+	    {
+		.id      = PAC7302_CID_LED,
+		.type    = V4L2_CTRL_TYPE_MENU,
+		.name    = "LED",
+		.minimum = 0,
+		.maximum = 2,	/* 0: Auto, 1: On, 2: Off */
+		.step    = 1,
+#define LED_DEF 0
+		.default_value = LED_DEF,
+	    },
+	    .set = sd_setled,
+	    .get = sd_getled,
+	},
 };

 static const struct v4l2_pix_format vga_mode[] = {
@@ -572,6 +596,7 @@
 	sd->gain = GAIN_DEF;
 	sd->exposure = EXPOSURE_DEF;
 	sd->autogain = AUTOGAIN_DEF;
+	sd->led = LED_DEF;
 	sd->hflip = HFLIP_DEF;
 	sd->vflip = VFLIP_DEF;
 	sd->flags = id->driver_info;
@@ -716,6 +741,36 @@
 	reg_w(gspca_dev, 0x11, 0x01);
 }

+static void set_streaming_led(struct gspca_dev *gspca_dev, u8 streaming)
+{
+	struct sd *sd = (struct sd *) gspca_dev;
+	u8 data = 0;
+
+	switch (sd->led) {
+	case LED_AUTO:
+		if (streaming)
+			data = 0x01;
+		else
+			data = 0x40;
+		break;
+	case LED_ON:
+		if (streaming)
+			data = 0x01;
+		else
+			data = 0x00;
+		break;
+	case LED_OFF:
+		if (streaming)
+			data = 0x41;
+		else
+			data = 0x40;
+		break;
+	}
+
+	reg_w(gspca_dev, 0xff, 0x01);
+	reg_w(gspca_dev, 0x78, data);
+}
+
 /* this function is called at probe and resume time for pac7302 */
 static int sd_init(struct gspca_dev *gspca_dev)
 {
@@ -747,18 +802,15 @@
 	atomic_set(&sd->avg_lum, -1);

 	/* start stream */
-	reg_w(gspca_dev, 0xff, 0x01);
-	reg_w(gspca_dev, 0x78, 0x01);
+	set_streaming_led(gspca_dev, 1);

 	return gspca_dev->usb_err;
 }

 static void sd_stopN(struct gspca_dev *gspca_dev)
 {
-
 	/* stop stream */
-	reg_w(gspca_dev, 0xff, 0x01);
-	reg_w(gspca_dev, 0x78, 0x00);
+	set_streaming_led(gspca_dev, 0);
 }

 /* called on streamoff with alt 0 and on disconnect for pac7302 */
@@ -766,8 +818,7 @@
 {
 	if (!gspca_dev->present)
 		return;
-	reg_w(gspca_dev, 0xff, 0x01);
-	reg_w(gspca_dev, 0x78, 0x40);
+	set_streaming_led(gspca_dev, 0);
 }

 /* Include pac common sof detection functions */
@@ -1121,6 +1172,44 @@
 	return 0;
 }

+static int sd_setled(struct gspca_dev *gspca_dev, __s32 val)
+{
+	struct sd *sd = (struct sd *) gspca_dev;
+
+	sd->led = val;
+	set_streaming_led(gspca_dev, gspca_dev->streaming);
+	return gspca_dev->usb_err;
+}
+
+static int sd_getled(struct gspca_dev *gspca_dev, __s32 *val)
+{
+	struct sd *sd = (struct sd *) gspca_dev;
+
+	*val = sd->led;
+	return 0;
+}
+
+static int sd_querymenu(struct gspca_dev *gspca_dev,
+			struct v4l2_querymenu *menu)
+{
+	switch (menu->id) {
+	case PAC7302_CID_LED:
+		switch (menu->index) {
+		case LED_AUTO:
+			strcpy((char *)menu->name, "Auto");
+			return 0;
+		case LED_OFF:
+			strcpy((char *)menu->name, "Off");
+			return 0;
+		case LED_ON:
+			strcpy((char *)menu->name, "On");
+			return 0;
+		}
+		break;
+	}
+	return -EINVAL;
+}
+
 #ifdef CONFIG_VIDEO_ADV_DEBUG
 static int sd_dbg_s_register(struct gspca_dev *gspca_dev,
 			struct v4l2_dbg_register *reg)
@@ -1210,6 +1299,7 @@
 	.stop0 = sd_stop0,
 	.pkt_scan = sd_pkt_scan,
 	.dq_callback = do_autogain,
+	.querymenu = sd_querymenu,
 #ifdef CONFIG_VIDEO_ADV_DEBUG
 	.set_register = sd_dbg_s_register,
 	.get_chip_ident = sd_chip_ident,
