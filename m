Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail01a.mail.t-online.hu ([84.2.40.6]:62155 "EHLO
	mail01a.mail.t-online.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933371AbZJaXPo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 31 Oct 2009 19:15:44 -0400
Message-ID: <4AECC51D.40409@freemail.hu>
Date: Sun, 01 Nov 2009 00:15:41 +0100
From: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
MIME-Version: 1.0
To: Jean-Francois Moine <moinejf@free.fr>,
	Hans de Goede <hdegoede@redhat.com>,
	V4L Mailing List <linux-media@vger.kernel.org>
CC: Thomas Kaiser <thomas@kaiser-linux.li>,
	Theodore Kilgore <kilgota@auburn.edu>,
	Kyle Guinn <elyk03@gmail.com>
Subject: [PATCH 13/21] gspca pac7302/pac7311: separate gain/autogain control
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Márton Németh <nm127@freemail.hu>

Separate the gain and autogain controls. Remove the run-time
decision for PAC7302 and PAC7311 sensors.

Signed-off-by: Márton Németh <nm127@freemail.hu>
Cc: Thomas Kaiser <thomas@kaiser-linux.li>
Cc: Theodore Kilgore <kilgota@auburn.edu>
Cc: Kyle Guinn <elyk03@gmail.com>
---
diff -uprN m/drivers/media/video/gspca/pac7311.c n/drivers/media/video/gspca/pac7311.c
--- m/drivers/media/video/gspca/pac7311.c	2009-10-31 07:29:51.000000000 +0100
+++ n/drivers/media/video/gspca/pac7311.c	2009-10-31 07:38:45.000000000 +0100
@@ -89,8 +89,10 @@ static int pac7302_sd_getcontrast(struct
 static int pac7311_sd_getcontrast(struct gspca_dev *gspca_dev, __s32 *val);
 static int pac7302_sd_setcolors(struct gspca_dev *gspca_dev, __s32 val);
 static int pac7302_sd_getcolors(struct gspca_dev *gspca_dev, __s32 *val);
-static int sd_setautogain(struct gspca_dev *gspca_dev, __s32 val);
-static int sd_getautogain(struct gspca_dev *gspca_dev, __s32 *val);
+static int pac7302_sd_setautogain(struct gspca_dev *gspca_dev, __s32 val);
+static int pac7311_sd_setautogain(struct gspca_dev *gspca_dev, __s32 val);
+static int pac7302_sd_getautogain(struct gspca_dev *gspca_dev, __s32 *val);
+static int pac7311_sd_getautogain(struct gspca_dev *gspca_dev, __s32 *val);
 static int pac7302_sd_sethflip(struct gspca_dev *gspca_dev, __s32 val);
 static int pac7311_sd_sethflip(struct gspca_dev *gspca_dev, __s32 val);
 static int pac7302_sd_gethflip(struct gspca_dev *gspca_dev, __s32 *val);
@@ -99,8 +101,10 @@ static int pac7302_sd_setvflip(struct gs
 static int pac7311_sd_setvflip(struct gspca_dev *gspca_dev, __s32 val);
 static int pac7302_sd_getvflip(struct gspca_dev *gspca_dev, __s32 *val);
 static int pac7311_sd_getvflip(struct gspca_dev *gspca_dev, __s32 *val);
-static int sd_setgain(struct gspca_dev *gspca_dev, __s32 val);
-static int sd_getgain(struct gspca_dev *gspca_dev, __s32 *val);
+static int pac7302_sd_setgain(struct gspca_dev *gspca_dev, __s32 val);
+static int pac7311_sd_setgain(struct gspca_dev *gspca_dev, __s32 val);
+static int pac7302_sd_getgain(struct gspca_dev *gspca_dev, __s32 *val);
+static int pac7311_sd_getgain(struct gspca_dev *gspca_dev, __s32 *val);
 static int sd_setexposure(struct gspca_dev *gspca_dev, __s32 val);
 static int sd_getexposure(struct gspca_dev *gspca_dev, __s32 *val);

@@ -167,8 +171,8 @@ static struct ctrl pac7302_sd_ctrls[] =
 #define GAIN_KNEE 255 /* Gain seems to cause little noise on the pac73xx */
 		.default_value = GAIN_DEF,
 	    },
-	    .set = sd_setgain,
-	    .get = sd_getgain,
+	    .set = pac7302_sd_setgain,
+	    .get = pac7302_sd_getgain,
 	},
 	{
 	    {
@@ -197,8 +201,8 @@ static struct ctrl pac7302_sd_ctrls[] =
 #define AUTOGAIN_DEF 1
 		.default_value = AUTOGAIN_DEF,
 	    },
-	    .set = sd_setautogain,
-	    .get = sd_getautogain,
+	    .set = pac7302_sd_setautogain,
+	    .get = pac7302_sd_getautogain,
 	},
 	{
 	    {
@@ -261,8 +265,8 @@ static struct ctrl pac7311_sd_ctrls[] =
 #define GAIN_KNEE 255 /* Gain seems to cause little noise on the pac73xx */
 		.default_value = GAIN_DEF,
 	    },
-	    .set = sd_setgain,
-	    .get = sd_getgain,
+	    .set = pac7311_sd_setgain,
+	    .get = pac7311_sd_getgain,
 	},
 	{
 	    {
@@ -291,8 +295,8 @@ static struct ctrl pac7311_sd_ctrls[] =
 #define AUTOGAIN_DEF 1
 		.default_value = AUTOGAIN_DEF,
 	    },
-	    .set = sd_setautogain,
-	    .get = sd_getautogain,
+	    .set = pac7311_sd_setautogain,
+	    .get = pac7311_sd_getautogain,
 	},
 	{
 	    {
@@ -717,23 +721,30 @@ static void pac7302_setcolors(struct gsp
 	PDEBUG(D_CONF|D_STREAM, "color: %i", sd->colors);
 }

-static void setgain(struct gspca_dev *gspca_dev)
+static void pac7302_setgain(struct gspca_dev *gspca_dev)
 {
 	struct sd *sd = (struct sd *) gspca_dev;

-	if (sd->sensor == SENSOR_PAC7302) {
-		reg_w(gspca_dev, 0xff, 0x03);		/* page 3 */
-		reg_w(gspca_dev, 0x10, sd->gain >> 3);
-	} else {
-		int gain = GAIN_MAX - sd->gain;
-		if (gain < 1)
-			gain = 1;
-		else if (gain > 245)
-			gain = 245;
-		reg_w(gspca_dev, 0xff, 0x04);		/* page 4 */
-		reg_w(gspca_dev, 0x0e, 0x00);
-		reg_w(gspca_dev, 0x0f, gain);
-	}
+	reg_w(gspca_dev, 0xff, 0x03);		/* page 3 */
+	reg_w(gspca_dev, 0x10, sd->gain >> 3);
+
+	/* load registers to sensor (Bit 0, auto clear) */
+	reg_w(gspca_dev, 0x11, 0x01);
+}
+
+static void pac7311_setgain(struct gspca_dev *gspca_dev)
+{
+	struct sd *sd = (struct sd *) gspca_dev;
+	int gain = GAIN_MAX - sd->gain;
+
+	if (gain < 1)
+		gain = 1;
+	else if (gain > 245)
+		gain = 245;
+	reg_w(gspca_dev, 0xff, 0x04);		/* page 4 */
+	reg_w(gspca_dev, 0x0e, 0x00);
+	reg_w(gspca_dev, 0x0f, gain);
+
 	/* load registers to sensor (Bit 0, auto clear) */
 	reg_w(gspca_dev, 0x11, 0x01);
 }
@@ -824,7 +835,7 @@ static int pac7302_sd_start(struct gspca
 	reg_w_var(gspca_dev, start_7302);
 	pac7302_setbrightcont(gspca_dev);
 	pac7302_setcolors(gspca_dev);
-	setgain(gspca_dev);
+	pac7302_setgain(gspca_dev);
 	setexposure(gspca_dev);
 	pac7302_sethvflip(gspca_dev);

@@ -849,7 +860,7 @@ static int pac7311_sd_start(struct gspca

 	reg_w_var(gspca_dev, start_7311);
 	pac7311_setcontrast(gspca_dev);
-	setgain(gspca_dev);
+	pac7311_setgain(gspca_dev);
 	setexposure(gspca_dev);
 	pac7311_sethvflip(gspca_dev);

@@ -1197,17 +1208,35 @@ static int pac7302_sd_getcolors(struct g
 	return 0;
 }

-static int sd_setgain(struct gspca_dev *gspca_dev, __s32 val)
+static int pac7302_sd_setgain(struct gspca_dev *gspca_dev, __s32 val)
 {
 	struct sd *sd = (struct sd *) gspca_dev;

 	sd->gain = val;
 	if (gspca_dev->streaming)
-		setgain(gspca_dev);
+		pac7302_setgain(gspca_dev);
 	return 0;
 }

-static int sd_getgain(struct gspca_dev *gspca_dev, __s32 *val)
+static int pac7311_sd_setgain(struct gspca_dev *gspca_dev, __s32 val)
+{
+	struct sd *sd = (struct sd *) gspca_dev;
+
+	sd->gain = val;
+	if (gspca_dev->streaming)
+		pac7311_setgain(gspca_dev);
+	return 0;
+}
+
+static int pac7302_sd_getgain(struct gspca_dev *gspca_dev, __s32 *val)
+{
+	struct sd *sd = (struct sd *) gspca_dev;
+
+	*val = sd->gain;
+	return 0;
+}
+
+static int pac7311_sd_getgain(struct gspca_dev *gspca_dev, __s32 *val)
 {
 	struct sd *sd = (struct sd *) gspca_dev;

@@ -1233,7 +1262,7 @@ static int sd_getexposure(struct gspca_d
 	return 0;
 }

-static int sd_setautogain(struct gspca_dev *gspca_dev, __s32 val)
+static int pac7302_sd_setautogain(struct gspca_dev *gspca_dev, __s32 val)
 {
 	struct sd *sd = (struct sd *) gspca_dev;

@@ -1249,14 +1278,45 @@ static int sd_setautogain(struct gspca_d
 			sd->autogain_ignore_frames =
 				PAC_AUTOGAIN_IGNORE_FRAMES;
 			setexposure(gspca_dev);
-			setgain(gspca_dev);
+			pac7302_setgain(gspca_dev);
 		}
 	}

 	return 0;
 }

-static int sd_getautogain(struct gspca_dev *gspca_dev, __s32 *val)
+static int pac7311_sd_setautogain(struct gspca_dev *gspca_dev, __s32 val)
+{
+	struct sd *sd = (struct sd *) gspca_dev;
+
+	sd->autogain = val;
+	/* when switching to autogain set defaults to make sure
+	   we are on a valid point of the autogain gain /
+	   exposure knee graph, and give this change time to
+	   take effect before doing autogain. */
+	if (sd->autogain) {
+		sd->exposure = EXPOSURE_DEF;
+		sd->gain = GAIN_DEF;
+		if (gspca_dev->streaming) {
+			sd->autogain_ignore_frames =
+				PAC_AUTOGAIN_IGNORE_FRAMES;
+			setexposure(gspca_dev);
+			pac7311_setgain(gspca_dev);
+		}
+	}
+
+	return 0;
+}
+
+static int pac7302_sd_getautogain(struct gspca_dev *gspca_dev, __s32 *val)
+{
+	struct sd *sd = (struct sd *) gspca_dev;
+
+	*val = sd->autogain;
+	return 0;
+}
+
+static int pac7311_sd_getautogain(struct gspca_dev *gspca_dev, __s32 *val)
 {
 	struct sd *sd = (struct sd *) gspca_dev;

