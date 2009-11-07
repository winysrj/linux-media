Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail01a.mail.t-online.hu ([84.2.40.6]:60052 "EHLO
	mail01a.mail.t-online.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753460AbZKGXFr (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 7 Nov 2009 18:05:47 -0500
Message-ID: <4AF5FD4A.1070804@freemail.hu>
Date: Sun, 08 Nov 2009 00:05:46 +0100
From: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
MIME-Version: 1.0
To: Jean-Francois Moine <moinejf@free.fr>,
	V4L Mailing List <linux-media@vger.kernel.org>
CC: Thomas Kaiser <thomas@kaiser-linux.li>
Subject: [PATCH] gspca pac7302: add test pattern/overlay control
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Márton Németh <nm127@freemail.hu>

The Labtec Webcam 2200 (USB ID 093a:2626) device can produce some
diagnostic patterns instead of the sensor image. An overlay test
pattern also exsits which can be combined with the sensor image or
with any test patterns. Add controls to activate these test modes.

Signed-off-by: Márton Németh <nm127@freemail.hu>
Cc: Thomas Kaiser <thomas@kaiser-linux.li>
---
diff -upr c/linux/drivers/media/video/gspca/pac7302.c d/linux/drivers/media/video/gspca/pac7302.c
--- c/linux/drivers/media/video/gspca/pac7302.c	2009-11-07 22:38:32.000000000 +0100
+++ d/linux/drivers/media/video/gspca/pac7302.c	2009-11-08 00:55:38.000000000 +0100
@@ -27,6 +27,29 @@
    addresses is a - sign that register description is not valid for the
    matching IC.

+   Register page 0:
+
+   Address	Description
+   0x72/-	Different test patterns:
+		  bit 0..3:  0 -> image, test pattern off
+			     1 -> white
+			     2 -> black
+			     3 -> red
+			     4 -> green
+			     5 -> blue
+			     6 -> cyan
+			     7 -> magenta
+			     8 -> yellow
+			     9 -> color bars
+			    10 -> high resolution color pattern
+			    11 -> black to white gradient from top to bottom
+			    12 -> white to black gradient from left to right
+			    13 -> white to black gradient repeats from left to right
+			    14 -> dark gray (#111111)
+			    15 -> dark gray 2 (#111111)
+		  bit 4: overlay some diagnostic points over the image
+		  bit 5..7: no effect
+
    Register page 1:

    Address	Description
@@ -57,6 +80,7 @@
     0   | 0x0f..0x20 | setcolors()
     0   | 0xa2..0xab | setbrightcont()
     0   | 0x55       | setedgedetect()
+    0   | 0x72       | settestpattern()
     0   | 0xc5       | setredbalance()
     0   | 0xc6       | setwhitebalance()
     0   | 0xc7       | setbluebalance()
@@ -91,6 +115,8 @@ struct sd {
 	__u8 hflip;
 	__u8 vflip;
 	unsigned char edge_detect;
+	unsigned char test_pattern;
+	unsigned char test_overlay;

 	u8 sof_read;
 	u8 autogain_ignore_frames;
@@ -123,9 +149,14 @@ static int sd_setexposure(struct gspca_d
 static int sd_getexposure(struct gspca_dev *gspca_dev, __s32 *val);
 static int sd_setedgedetect(struct gspca_dev *gspca_dev, __s32 val);
 static int sd_getedgedetect(struct gspca_dev *gspca_dev, __s32 *val);
+static int sd_settestpattern(struct gspca_dev *gspca_dev, __s32 val);
+static int sd_gettestpattern(struct gspca_dev *gspca_dev, __s32 *val);
+static int sd_settestoverlay(struct gspca_dev *gspca_dev, __s32 val);
+static int sd_gettestoverlay(struct gspca_dev *gspca_dev, __s32 *val);

 #define V4L2_CID_PRIVATE_EDGE_DETECT (V4L2_CID_PRIVATE_BASE+0)
-
+#define V4L2_CID_PRIVATE_TEST_PATTERN (V4L2_CID_PRIVATE_BASE+1)
+#define V4L2_CID_PRIVATE_TEST_OVERLAY (V4L2_CID_PRIVATE_BASE+2)

 static struct ctrl sd_ctrls[] = {
 /* This control is pac7302 only */
@@ -307,6 +338,34 @@ static struct ctrl sd_ctrls[] = {
 	    .set = sd_setedgedetect,
 	    .get = sd_getedgedetect,
 	},
+	{
+	    {
+		.id      = V4L2_CID_PRIVATE_TEST_PATTERN,
+		.type    = V4L2_CTRL_TYPE_MENU,
+		.name    = "Test Pattern",
+		.minimum = 0,
+		.maximum = 15,
+		.step    = 1,
+#define TEST_PATTERN_DEF 0
+		.default_value = TEST_PATTERN_DEF,
+	    },
+	    .set = sd_settestpattern,
+	    .get = sd_gettestpattern,
+	},
+	{
+	    {
+		.id      = V4L2_CID_PRIVATE_TEST_OVERLAY,
+		.type    = V4L2_CTRL_TYPE_BOOLEAN,
+		.name    = "Test Overlay",
+		.minimum = 0,
+		.maximum = 1,
+		.step    = 1,
+#define TEST_OVERLAY_DEF 0
+		.default_value = TEST_OVERLAY_DEF,
+	    },
+	    .set = sd_settestoverlay,
+	    .get = sd_gettestoverlay,
+	},

 };

@@ -595,6 +654,9 @@ static int sd_config(struct gspca_dev *g
 	sd->hflip = HFLIP_DEF;
 	sd->vflip = VFLIP_DEF;
 	sd->edge_detect = EDGE_DETECT_DEF;
+	sd->test_pattern = TEST_PATTERN_DEF;
+	sd->test_overlay = TEST_OVERLAY_DEF;
+
 	return 0;
 }

@@ -780,6 +842,23 @@ static int setedgedetect(struct gspca_de
 	return ret;
 }

+static int settestpattern(struct gspca_dev *gspca_dev)
+{
+	struct sd *sd = (struct sd *) gspca_dev;
+	int ret;
+	__u8 data;
+
+	ret = reg_w(gspca_dev, 0xff, 0x00);	/* page 0 */
+	data = sd->test_pattern | (sd->test_overlay ? 0x10 : 0x00);
+	if (0 <= ret)
+		ret = reg_w(gspca_dev, 0x72, data);
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
@@ -814,6 +893,8 @@ static int sd_start(struct gspca_dev *gs
 		sethvflip(gspca_dev);
 	if (0 <= ret)
 		ret = setedgedetect(gspca_dev);
+	if (0 <= ret)
+		ret = settestpattern(gspca_dev);

 	/* only resolution 640x480 is supported for pac7302 */

@@ -1224,6 +1305,127 @@ static int sd_getedgedetect(struct gspca
 	return 0;
 }

+static int sd_settestpattern(struct gspca_dev *gspca_dev, __s32 val)
+{
+	struct sd *sd = (struct sd *) gspca_dev;
+	int ret = 0;
+
+	sd->test_pattern = val;
+	if (gspca_dev->streaming)
+		ret = settestpattern(gspca_dev);
+	if (0 <= ret)
+		ret = 0;
+	return ret;
+}
+
+static int sd_gettestpattern(struct gspca_dev *gspca_dev, __s32 *val)
+{
+	struct sd *sd = (struct sd *) gspca_dev;
+
+	*val = sd->test_pattern;
+	return 0;
+}
+
+static int sd_settestoverlay(struct gspca_dev *gspca_dev, __s32 val)
+{
+	struct sd *sd = (struct sd *) gspca_dev;
+	int ret = 0;
+
+	sd->test_overlay = val;
+	if (gspca_dev->streaming)
+		ret = settestpattern(gspca_dev);
+	if (0 <= ret)
+		ret = 0;
+	return ret;
+}
+
+static int sd_gettestoverlay(struct gspca_dev *gspca_dev, __s32 *val)
+{
+	struct sd *sd = (struct sd *) gspca_dev;
+
+	*val = sd->test_overlay;
+	return 0;
+}
+
+static int sd_querymenu(struct gspca_dev *gspca_dev,
+			struct v4l2_querymenu *menu)
+{
+	int ret = -EINVAL;
+
+	switch (menu->id) {
+	case V4L2_CID_PRIVATE_TEST_PATTERN :
+		switch (menu->index) {
+		case 0:
+			strcpy((char *) menu->name, "off");
+			ret = 0;
+			break;
+		case 1:
+			strcpy((char *) menu->name, "white");
+			ret = 0;
+			break;
+		case 2:
+			strcpy((char *) menu->name, "black");
+			ret = 0;
+			break;
+		case 3:
+			strcpy((char *) menu->name, "red");
+			ret = 0;
+			break;
+		case 4:
+			strcpy((char *) menu->name, "green");
+			ret = 0;
+			break;
+		case 5:
+			strcpy((char *) menu->name, "blue");
+			ret = 0;
+			break;
+		case 6:
+			strcpy((char *) menu->name, "cyan");
+			ret = 0;
+			break;
+		case 7:
+			strcpy((char *) menu->name, "magenta");
+			ret = 0;
+			break;
+		case 8:
+			strcpy((char *) menu->name, "yellow");
+			ret = 0;
+			break;
+		case 9:
+			strcpy((char *) menu->name, "color bars");
+			ret = 0;
+			break;
+		case 10:
+			strcpy((char *) menu->name, "high resolution color pattern");
+			ret = 0;
+			break;
+		case 11:
+			strcpy((char *) menu->name, "top-bottom gradient");
+			ret = 0;
+			break;
+		case 12:
+			strcpy((char *) menu->name, "left-right gradient");
+			ret = 0;
+			break;
+		case 13:
+			strcpy((char *) menu->name, "repeating left-right gradient");
+			ret = 0;
+			break;
+		case 14:
+			strcpy((char *) menu->name, "dark gray");
+			ret = 0;
+			break;
+		case 15:
+			strcpy((char *) menu->name, "dark gray 2");
+			ret = 0;
+			break;
+		}
+		break;
+	}
+	return ret;
+}
+
+
 /* sub-driver description for pac7302 */
 static struct sd_desc sd_desc = {
 	.name = MODULE_NAME,
@@ -1236,6 +1438,7 @@ static struct sd_desc sd_desc = {
 	.stop0 = sd_stop0,
 	.pkt_scan = sd_pkt_scan,
 	.dq_callback = do_autogain,
+	.querymenu = sd_querymenu,
 };

 /* -- module initialisation -- */
