Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail02a.mail.t-online.hu ([84.2.40.7]:62720 "EHLO
	mail02a.mail.t-online.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751761AbZKGM3V (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 7 Nov 2009 07:29:21 -0500
Message-ID: <4AF56822.8020307@freemail.hu>
Date: Sat, 07 Nov 2009 13:29:22 +0100
From: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
MIME-Version: 1.0
To: Jean-Francois Moine <moinejf@free.fr>,
	V4L Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH] gspca pac7302: add red and blue balance control
References: <4AF55BE8.2090608@freemail.hu> <4AF566CD.4060308@freemail.hu>
In-Reply-To: <4AF566CD.4060308@freemail.hu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Márton Németh <nm127@freemail.hu>

Add the red and blue balance control to the pac7302 driver. The valid
values for these controls are 0..3 (lower two bits) which was identified
by trial and error on Labtec Webcam 2200 (USB ID 093a:2626). The upper
6 bits are ignored on page 0, registers 0xc5 and 0xc7 by the camera.

Signed-off-by: Márton Németh <nm127@freemail.hu>
---
Patch description corrected, debug message in setbluebalance() corrected.
---
diff -upr b/linux/drivers/media/video/gspca/pac7302.c d/linux/drivers/media/video/gspca/pac7302.c
--- b/linux/drivers/media/video/gspca/pac7302.c	2009-11-07 09:08:16.000000000 +0100
+++ d/linux/drivers/media/video/gspca/pac7302.c	2009-11-07 12:27:15.000000000 +0100
@@ -49,6 +49,20 @@
    -/0x27	Seems to toggle various gains on / off, Setting bit 7 seems to
 		completely disable the analog amplification block. Set to 0x68
 		for max gain, 0x14 for minimal gain.
+
+   The registers are accessed in the following functions:
+
+   Page | Register   | Function
+   -----+------------+---------------------------------------------------
+    0   | 0x0f..0x20 | setcolors()
+    0   | 0xa2..0xab | setbrightcont()
+    0   | 0xc5       | setredbalance()
+    0   | 0xc7       | setbluebalance()
+    0   | 0xdc       | setbrightcont(), setcolors()
+    3   | 0x02       | setexposure()
+    3   | 0x10       | setgain()
+    3   | 0x11       | setcolors(), setgain(), setexposure(), sethvflip()
+    3   | 0x21       | sethvflip()
 */

 #define MODULE_NAME "pac7302"
@@ -66,6 +80,8 @@ struct sd {
 	unsigned char brightness;
 	unsigned char contrast;
 	unsigned char colors;
+	unsigned char red_balance;
+	unsigned char blue_balance;
 	unsigned char gain;
 	unsigned char exposure;
 	unsigned char autogain;
@@ -85,6 +101,10 @@ static int sd_setcontrast(struct gspca_d
 static int sd_getcontrast(struct gspca_dev *gspca_dev, __s32 *val);
 static int sd_setcolors(struct gspca_dev *gspca_dev, __s32 val);
 static int sd_getcolors(struct gspca_dev *gspca_dev, __s32 *val);
+static int sd_setredbalance(struct gspca_dev *gspca_dev, __s32 val);
+static int sd_getredbalance(struct gspca_dev *gspca_dev, __s32 *val);
+static int sd_setbluebalance(struct gspca_dev *gspca_dev, __s32 val);
+static int sd_getbluebalance(struct gspca_dev *gspca_dev, __s32 *val);
 static int sd_setautogain(struct gspca_dev *gspca_dev, __s32 val);
 static int sd_getautogain(struct gspca_dev *gspca_dev, __s32 *val);
 static int sd_sethflip(struct gspca_dev *gspca_dev, __s32 val);
@@ -145,6 +165,34 @@ static struct ctrl sd_ctrls[] = {
 	    .set = sd_setcolors,
 	    .get = sd_getcolors,
 	},
+	{
+	    {
+		.id      = V4L2_CID_RED_BALANCE,
+		.type    = V4L2_CTRL_TYPE_INTEGER,
+		.name    = "Red",
+		.minimum = 0,
+		.maximum = 3,
+		.step    = 1,
+#define REDBALANCE_DEF 1
+		.default_value = REDBALANCE_DEF,
+	    },
+	    .set = sd_setredbalance,
+	    .get = sd_getredbalance,
+	},
+	{
+	    {
+		.id      = V4L2_CID_BLUE_BALANCE,
+		.type    = V4L2_CTRL_TYPE_INTEGER,
+		.name    = "Blue",
+		.minimum = 0,
+		.maximum = 3,
+		.step    = 1,
+#define BLUEBALANCE_DEF 1
+		.default_value = BLUEBALANCE_DEF,
+	    },
+	    .set = sd_setbluebalance,
+	    .get = sd_getbluebalance,
+	},
 /* All controls below are for both the 7302 and the 7311 */
 	{
 	    {
@@ -498,6 +546,8 @@ static int sd_config(struct gspca_dev *g
 	sd->brightness = BRIGHTNESS_DEF;
 	sd->contrast = CONTRAST_DEF;
 	sd->colors = COLOR_DEF;
+	sd->red_balance = REDBALANCE_DEF;
+	sd->blue_balance = BLUEBALANCE_DEF;
 	sd->gain = GAIN_DEF;
 	sd->exposure = EXPOSURE_DEF;
 	sd->autogain = AUTOGAIN_DEF;
@@ -566,6 +616,36 @@ static int setcolors(struct gspca_dev *g
 	return ret;
 }

+static int setredbalance(struct gspca_dev *gspca_dev)
+{
+	struct sd *sd = (struct sd *) gspca_dev;
+	int ret;
+
+	ret = reg_w(gspca_dev, 0xff, 0x00);	/* page 0 */
+	if (0 <= ret)
+		ret = reg_w(gspca_dev, 0xc5, sd->red_balance);
+
+	if (0 <= ret)
+		ret = reg_w(gspca_dev, 0xdc, 0x01);
+	PDEBUG(D_CONF|D_STREAM, "red_balance: %i", sd->red_balance);
+	return ret;
+}
+
+static int setbluebalance(struct gspca_dev *gspca_dev)
+{
+	struct sd *sd = (struct sd *) gspca_dev;
+	int ret;
+
+	ret = reg_w(gspca_dev, 0xff, 0x00);	/* page 0 */
+	if (0 <= ret)
+		ret = reg_w(gspca_dev, 0xc7, sd->blue_balance);
+
+	if (0 <= ret)
+		ret = reg_w(gspca_dev, 0xdc, 0x01);
+	PDEBUG(D_CONF|D_STREAM, "blue_balance: %i", sd->blue_balance);
+	return ret;
+}
+
 static int setgain(struct gspca_dev *gspca_dev)
 {
 	struct sd *sd = (struct sd *) gspca_dev;
@@ -647,6 +727,10 @@ static int sd_start(struct gspca_dev *gs
 	if (0 <= ret)
 		ret = setcolors(gspca_dev);
 	if (0 <= ret)
+		ret = setredbalance(gspca_dev);
+	if (0 <= ret)
+		ret = setbluebalance(gspca_dev);
+	if (0 <= ret)
 		setgain(gspca_dev);
 	if (0 <= ret)
 		setexposure(gspca_dev);
@@ -878,6 +962,48 @@ static int sd_getcolors(struct gspca_dev
 	return 0;
 }

+static int sd_setredbalance(struct gspca_dev *gspca_dev, __s32 val)
+{
+	struct sd *sd = (struct sd *) gspca_dev;
+	int ret = 0;
+
+	sd->red_balance = val;
+	if (gspca_dev->streaming)
+		ret = setredbalance(gspca_dev);
+	if (0 <= ret)
+		ret = 0;
+	return ret;
+}
+
+static int sd_getredbalance(struct gspca_dev *gspca_dev, __s32 *val)
+{
+	struct sd *sd = (struct sd *) gspca_dev;
+
+	*val = sd->red_balance;
+	return 0;
+}
+
+static int sd_setbluebalance(struct gspca_dev *gspca_dev, __s32 val)
+{
+	struct sd *sd = (struct sd *) gspca_dev;
+	int ret = 0;
+
+	sd->blue_balance = val;
+	if (gspca_dev->streaming)
+		ret = setbluebalance(gspca_dev);
+	if (0 <= ret)
+		ret = 0;
+	return ret;
+}
+
+static int sd_getbluebalance(struct gspca_dev *gspca_dev, __s32 *val)
+{
+	struct sd *sd = (struct sd *) gspca_dev;
+
+	*val = sd->blue_balance;
+	return 0;
+}
+
 static int sd_setgain(struct gspca_dev *gspca_dev, __s32 val)
 {
 	struct sd *sd = (struct sd *) gspca_dev;

