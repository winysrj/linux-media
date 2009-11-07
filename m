Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail02a.mail.t-online.hu ([84.2.40.7]:55574 "EHLO
	mail02a.mail.t-online.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750996AbZKGUpQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 7 Nov 2009 15:45:16 -0500
Message-ID: <4AF5DC5D.8050809@freemail.hu>
Date: Sat, 07 Nov 2009 21:45:17 +0100
From: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
MIME-Version: 1.0
To: Jean-Francois Moine <moinejf@free.fr>,
	V4L Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH] gspca pac7302: add edge detect control
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Márton Németh <nm127@freemail.hu>

Add edge detect control to pac7302 driver. When this control is turned
on the camera image is switched to black and white and the edges are
visualized. Bit 2 on page 0, register 0x55 controls this mode on
Labtec Webcam 2200 (USB ID 093a:2626).

Signed-off-by: Márton Németh <nm127@freemail.hu>
---
diff -upr b/linux/drivers/media/video/gspca/pac7302.c c/linux/drivers/media/video/gspca/pac7302.c
--- b/linux/drivers/media/video/gspca/pac7302.c	2009-11-07 21:25:15.000000000 +0100
+++ c/linux/drivers/media/video/gspca/pac7302.c	2009-11-07 22:38:32.000000000 +0100
@@ -56,6 +56,7 @@
    -----+------------+---------------------------------------------------
     0   | 0x0f..0x20 | setcolors()
     0   | 0xa2..0xab | setbrightcont()
+    0   | 0x55       | setedgedetect()
     0   | 0xc5       | setredbalance()
     0   | 0xc6       | setwhitebalance()
     0   | 0xc7       | setbluebalance()
@@ -89,6 +90,7 @@ struct sd {
 	unsigned char autogain;
 	__u8 hflip;
 	__u8 vflip;
+	unsigned char edge_detect;

 	u8 sof_read;
 	u8 autogain_ignore_frames;
@@ -119,6 +121,11 @@ static int sd_setgain(struct gspca_dev *
 static int sd_getgain(struct gspca_dev *gspca_dev, __s32 *val);
 static int sd_setexposure(struct gspca_dev *gspca_dev, __s32 val);
 static int sd_getexposure(struct gspca_dev *gspca_dev, __s32 *val);
+static int sd_setedgedetect(struct gspca_dev *gspca_dev, __s32 val);
+static int sd_getedgedetect(struct gspca_dev *gspca_dev, __s32 *val);
+
+#define V4L2_CID_PRIVATE_EDGE_DETECT (V4L2_CID_PRIVATE_BASE+0)
+

 static struct ctrl sd_ctrls[] = {
 /* This control is pac7302 only */
@@ -286,6 +293,21 @@ static struct ctrl sd_ctrls[] = {
 	    .set = sd_setvflip,
 	    .get = sd_getvflip,
 	},
+	{
+	    {
+		.id      = V4L2_CID_PRIVATE_EDGE_DETECT,
+		.type    = V4L2_CTRL_TYPE_BOOLEAN,
+		.name    = "Edge Detect",
+		.minimum = 0,
+		.maximum = 1,
+		.step    = 1,
+#define EDGE_DETECT_DEF 0
+		.default_value = EDGE_DETECT_DEF,
+	    },
+	    .set = sd_setedgedetect,
+	    .get = sd_getedgedetect,
+	},
+
 };

 static const struct v4l2_pix_format vga_mode[] = {
@@ -572,6 +594,7 @@ static int sd_config(struct gspca_dev *g
 	sd->autogain = AUTOGAIN_DEF;
 	sd->hflip = HFLIP_DEF;
 	sd->vflip = VFLIP_DEF;
+	sd->edge_detect = EDGE_DETECT_DEF;
 	return 0;
 }

@@ -740,6 +763,23 @@ static int sethvflip(struct gspca_dev *g
 	return ret;
 }

+static int setedgedetect(struct gspca_dev *gspca_dev)
+{
+	struct sd *sd = (struct sd *) gspca_dev;
+	int ret;
+	__u8 data;
+
+	ret = reg_w(gspca_dev, 0xff, 0x00);	/* page 0 */
+	data = sd->edge_detect ? 0x04 : 0x00;
+	if (0 <= ret)
+		ret = reg_w(gspca_dev, 0x55, data);
+
+	if (0 <= ret)
+		ret = reg_w(gspca_dev, 0xdc, 0x01);
+
+	return ret;
+}
+
 /* this function is called at probe and resume time for pac7302 */
 static int sd_init(struct gspca_dev *gspca_dev)
 {
@@ -772,6 +812,8 @@ static int sd_start(struct gspca_dev *gs
 		setexposure(gspca_dev);
 	if (0 <= ret)
 		sethvflip(gspca_dev);
+	if (0 <= ret)
+		ret = setedgedetect(gspca_dev);

 	/* only resolution 640x480 is supported for pac7302 */

@@ -1164,6 +1206,24 @@ static int sd_getvflip(struct gspca_dev
 	return 0;
 }

+static int sd_setedgedetect(struct gspca_dev *gspca_dev, __s32 val)
+{
+	struct sd *sd = (struct sd *) gspca_dev;
+
+	sd->edge_detect = val;
+	if (gspca_dev->streaming)
+		setedgedetect(gspca_dev);
+	return 0;
+}
+
+static int sd_getedgedetect(struct gspca_dev *gspca_dev, __s32 *val)
+{
+	struct sd *sd = (struct sd *) gspca_dev;
+
+	*val = sd->edge_detect;
+	return 0;
+}
+
 /* sub-driver description for pac7302 */
 static struct sd_desc sd_desc = {
 	.name = MODULE_NAME,
