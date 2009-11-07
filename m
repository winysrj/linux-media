Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail01a.mail.t-online.hu ([84.2.40.6]:51133 "EHLO
	mail01a.mail.t-online.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750887AbZKGTga (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 7 Nov 2009 14:36:30 -0500
Message-ID: <4AF5CC39.2000302@freemail.hu>
Date: Sat, 07 Nov 2009 20:36:25 +0100
From: =?ISO-8859-2?Q?N=E9meth_M=E1rton?= <nm127@freemail.hu>
MIME-Version: 1.0
To: Jean-Francois Moine <moinejf@free.fr>,
	V4L Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH] gspca pac7302: add white balance control
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Márton Németh <nm127@freemail.hu>

Add white balance control to pac7302 driver. All 8 bits seems to be
relevant on Labtec Webcam 2200 (USB ID 093a:2626). The control is
at page 0, register 0xc6.

Signed-off-by: Márton Németh <nm127@freemail.hu>
---
diff -upr a/linux/drivers/media/video/gspca/pac7302.c b/linux/drivers/media/video/gspca/pac7302.c
--- a/linux/drivers/media/video/gspca/pac7302.c	2009-11-07 13:29:00.000000000 +0100
+++ b/linux/drivers/media/video/gspca/pac7302.c	2009-11-07 21:25:15.000000000 +0100
@@ -57,6 +57,7 @@
     0   | 0x0f..0x20 | setcolors()
     0   | 0xa2..0xab | setbrightcont()
     0   | 0xc5       | setredbalance()
+    0   | 0xc6       | setwhitebalance()
     0   | 0xc7       | setbluebalance()
     0   | 0xdc       | setbrightcont(), setcolors()
     3   | 0x02       | setexposure()
@@ -80,6 +81,7 @@ struct sd {
 	unsigned char brightness;
 	unsigned char contrast;
 	unsigned char colors;
+	unsigned char white_balance;
 	unsigned char red_balance;
 	unsigned char blue_balance;
 	unsigned char gain;
@@ -101,6 +103,8 @@ static int sd_setcontrast(struct gspca_d
 static int sd_getcontrast(struct gspca_dev *gspca_dev, __s32 *val);
 static int sd_setcolors(struct gspca_dev *gspca_dev, __s32 val);
 static int sd_getcolors(struct gspca_dev *gspca_dev, __s32 *val);
+static int sd_setwhitebalance(struct gspca_dev *gspca_dev, __s32 val);
+static int sd_getwhitebalance(struct gspca_dev *gspca_dev, __s32 *val);
 static int sd_setredbalance(struct gspca_dev *gspca_dev, __s32 val);
 static int sd_getredbalance(struct gspca_dev *gspca_dev, __s32 *val);
 static int sd_setbluebalance(struct gspca_dev *gspca_dev, __s32 val);
@@ -167,6 +171,20 @@ static struct ctrl sd_ctrls[] = {
 	},
 	{
 	    {
+		.id      = V4L2_CID_WHITE_BALANCE_TEMPERATURE,
+		.type    = V4L2_CTRL_TYPE_INTEGER,
+		.name    = "White Balance",
+		.minimum = 0,
+		.maximum = 255,
+		.step    = 1,
+#define WHITEBALANCE_DEF 4
+		.default_value = WHITEBALANCE_DEF,
+	    },
+	    .set = sd_setwhitebalance,
+	    .get = sd_getwhitebalance,
+	},
+	{
+	    {
 		.id      = V4L2_CID_RED_BALANCE,
 		.type    = V4L2_CTRL_TYPE_INTEGER,
 		.name    = "Red",
@@ -546,6 +564,7 @@ static int sd_config(struct gspca_dev *g
 	sd->brightness = BRIGHTNESS_DEF;
 	sd->contrast = CONTRAST_DEF;
 	sd->colors = COLOR_DEF;
+	sd->white_balance = WHITEBALANCE_DEF;
 	sd->red_balance = REDBALANCE_DEF;
 	sd->blue_balance = BLUEBALANCE_DEF;
 	sd->gain = GAIN_DEF;
@@ -616,6 +635,21 @@ static int setcolors(struct gspca_dev *g
 	return ret;
 }

+static int setwhitebalance(struct gspca_dev *gspca_dev)
+{
+	struct sd *sd = (struct sd *) gspca_dev;
+	int ret;
+
+	ret = reg_w(gspca_dev, 0xff, 0x00);	/* page 0 */
+	if (0 <= ret)
+		ret = reg_w(gspca_dev, 0xc6, sd->white_balance);
+
+	if (0 <= ret)
+		ret = reg_w(gspca_dev, 0xdc, 0x01);
+	PDEBUG(D_CONF|D_STREAM, "white_balance: %i", sd->white_balance);
+	return ret;
+}
+
 static int setredbalance(struct gspca_dev *gspca_dev)
 {
 	struct sd *sd = (struct sd *) gspca_dev;
@@ -727,6 +761,8 @@ static int sd_start(struct gspca_dev *gs
 	if (0 <= ret)
 		ret = setcolors(gspca_dev);
 	if (0 <= ret)
+		ret = setwhitebalance(gspca_dev);
+	if (0 <= ret)
 		ret = setredbalance(gspca_dev);
 	if (0 <= ret)
 		ret = setbluebalance(gspca_dev);
@@ -962,6 +998,27 @@ static int sd_getcolors(struct gspca_dev
 	return 0;
 }

+static int sd_setwhitebalance(struct gspca_dev *gspca_dev, __s32 val)
+{
+	struct sd *sd = (struct sd *) gspca_dev;
+	int ret = 0;
+
+	sd->white_balance = val;
+	if (gspca_dev->streaming)
+		ret = setwhitebalance(gspca_dev);
+	if (0 <= ret)
+		ret = 0;
+	return ret;
+}
+
+static int sd_getwhitebalance(struct gspca_dev *gspca_dev, __s32 *val)
+{
+	struct sd *sd = (struct sd *) gspca_dev;
+
+	*val = sd->white_balance;
+	return 0;
+}
+
 static int sd_setredbalance(struct gspca_dev *gspca_dev, __s32 val)
 {
 	struct sd *sd = (struct sd *) gspca_dev;
