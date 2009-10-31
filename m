Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail02a.mail.t-online.hu ([84.2.40.7]:60360 "EHLO
	mail02a.mail.t-online.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933353AbZJaXPd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 31 Oct 2009 19:15:33 -0400
Message-ID: <4AECC513.20208@freemail.hu>
Date: Sun, 01 Nov 2009 00:15:31 +0100
From: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
MIME-Version: 1.0
To: Jean-Francois Moine <moinejf@free.fr>,
	Hans de Goede <hdegoede@redhat.com>,
	V4L Mailing List <linux-media@vger.kernel.org>
CC: Thomas Kaiser <thomas@kaiser-linux.li>,
	Theodore Kilgore <kilgota@auburn.edu>,
	Kyle Guinn <elyk03@gmail.com>
Subject: [PATCH 12/21] gspca pac7302/pac7311: separate hvflip
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Márton Németh <nm127@freemail.hu>

Separate the horizontal and vertical flip control. Remove the run-time
decision for PAC7302 and PAC7311 sensors.

Signed-off-by: Márton Németh <nm127@freemail.hu>
Cc: Thomas Kaiser <thomas@kaiser-linux.li>
Cc: Theodore Kilgore <kilgota@auburn.edu>
Cc: Kyle Guinn <elyk03@gmail.com>
---
diff -uprN l/drivers/media/video/gspca/pac7311.c m/drivers/media/video/gspca/pac7311.c
--- l/drivers/media/video/gspca/pac7311.c	2009-10-31 07:21:22.000000000 +0100
+++ m/drivers/media/video/gspca/pac7311.c	2009-10-31 07:29:51.000000000 +0100
@@ -91,10 +91,14 @@ static int pac7302_sd_setcolors(struct g
 static int pac7302_sd_getcolors(struct gspca_dev *gspca_dev, __s32 *val);
 static int sd_setautogain(struct gspca_dev *gspca_dev, __s32 val);
 static int sd_getautogain(struct gspca_dev *gspca_dev, __s32 *val);
-static int sd_sethflip(struct gspca_dev *gspca_dev, __s32 val);
-static int sd_gethflip(struct gspca_dev *gspca_dev, __s32 *val);
-static int sd_setvflip(struct gspca_dev *gspca_dev, __s32 val);
-static int sd_getvflip(struct gspca_dev *gspca_dev, __s32 *val);
+static int pac7302_sd_sethflip(struct gspca_dev *gspca_dev, __s32 val);
+static int pac7311_sd_sethflip(struct gspca_dev *gspca_dev, __s32 val);
+static int pac7302_sd_gethflip(struct gspca_dev *gspca_dev, __s32 *val);
+static int pac7311_sd_gethflip(struct gspca_dev *gspca_dev, __s32 *val);
+static int pac7302_sd_setvflip(struct gspca_dev *gspca_dev, __s32 val);
+static int pac7311_sd_setvflip(struct gspca_dev *gspca_dev, __s32 val);
+static int pac7302_sd_getvflip(struct gspca_dev *gspca_dev, __s32 *val);
+static int pac7311_sd_getvflip(struct gspca_dev *gspca_dev, __s32 *val);
 static int sd_setgain(struct gspca_dev *gspca_dev, __s32 val);
 static int sd_getgain(struct gspca_dev *gspca_dev, __s32 *val);
 static int sd_setexposure(struct gspca_dev *gspca_dev, __s32 val);
@@ -207,8 +211,8 @@ static struct ctrl pac7302_sd_ctrls[] =
 #define HFLIP_DEF 0
 		.default_value = HFLIP_DEF,
 	    },
-	    .set = sd_sethflip,
-	    .get = sd_gethflip,
+	    .set = pac7302_sd_sethflip,
+	    .get = pac7302_sd_gethflip,
 	},
 	{
 	    {
@@ -221,8 +225,8 @@ static struct ctrl pac7302_sd_ctrls[] =
 #define VFLIP_DEF 0
 		.default_value = VFLIP_DEF,
 	    },
-	    .set = sd_setvflip,
-	    .get = sd_getvflip,
+	    .set = pac7302_sd_setvflip,
+	    .get = pac7302_sd_getvflip,
 	},
 };

@@ -301,8 +305,8 @@ static struct ctrl pac7311_sd_ctrls[] =
 #define HFLIP_DEF 0
 		.default_value = HFLIP_DEF,
 	    },
-	    .set = sd_sethflip,
-	    .get = sd_gethflip,
+	    .set = pac7311_sd_sethflip,
+	    .get = pac7311_sd_gethflip,
 	},
 	{
 	    {
@@ -315,8 +319,8 @@ static struct ctrl pac7311_sd_ctrls[] =
 #define VFLIP_DEF 0
 		.default_value = VFLIP_DEF,
 	    },
-	    .set = sd_setvflip,
-	    .get = sd_getvflip,
+	    .set = pac7311_sd_setvflip,
+	    .get = pac7311_sd_getvflip,
 	},
 };

@@ -771,20 +775,25 @@ static void setexposure(struct gspca_dev
 	reg_w(gspca_dev, 0x11, 0x01);
 }

-static void sethvflip(struct gspca_dev *gspca_dev)
+static void pac7302_sethvflip(struct gspca_dev *gspca_dev)
 {
 	struct sd *sd = (struct sd *) gspca_dev;
 	__u8 data;

-	if (sd->sensor == SENSOR_PAC7302) {
-		reg_w(gspca_dev, 0xff, 0x03);		/* page 3 */
-		data = (sd->hflip ? 0x08 : 0x00)
-			| (sd->vflip ? 0x04 : 0x00);
-	} else {
-		reg_w(gspca_dev, 0xff, 0x04);		/* page 4 */
-		data = (sd->hflip ? 0x04 : 0x00)
-			| (sd->vflip ? 0x08 : 0x00);
-	}
+	reg_w(gspca_dev, 0xff, 0x03);		/* page 3 */
+	data = (sd->hflip ? 0x08 : 0x00) | (sd->vflip ? 0x04 : 0x00);
+	reg_w(gspca_dev, 0x21, data);
+	/* load registers to sensor (Bit 0, auto clear) */
+	reg_w(gspca_dev, 0x11, 0x01);
+}
+
+static void pac7311_sethvflip(struct gspca_dev *gspca_dev)
+{
+	struct sd *sd = (struct sd *) gspca_dev;
+	__u8 data;
+
+	reg_w(gspca_dev, 0xff, 0x04);		/* page 4 */
+	data = (sd->hflip ? 0x04 : 0x00) | (sd->vflip ? 0x08 : 0x00);
 	reg_w(gspca_dev, 0x21, data);
 	/* load registers to sensor (Bit 0, auto clear) */
 	reg_w(gspca_dev, 0x11, 0x01);
@@ -817,7 +826,7 @@ static int pac7302_sd_start(struct gspca
 	pac7302_setcolors(gspca_dev);
 	setgain(gspca_dev);
 	setexposure(gspca_dev);
-	sethvflip(gspca_dev);
+	pac7302_sethvflip(gspca_dev);

 	/* only resolution 640x480 is supported for pac7302 */

@@ -842,7 +851,7 @@ static int pac7311_sd_start(struct gspca
 	pac7311_setcontrast(gspca_dev);
 	setgain(gspca_dev);
 	setexposure(gspca_dev);
-	sethvflip(gspca_dev);
+	pac7311_sethvflip(gspca_dev);

 	/* set correct resolution */
 	switch (gspca_dev->cam.cam_mode[(int) gspca_dev->curr_mode].priv) {
@@ -1255,17 +1264,27 @@ static int sd_getautogain(struct gspca_d
 	return 0;
 }

-static int sd_sethflip(struct gspca_dev *gspca_dev, __s32 val)
+static int pac7302_sd_sethflip(struct gspca_dev *gspca_dev, __s32 val)
+{
+	struct sd *sd = (struct sd *) gspca_dev;
+
+	sd->hflip = val;
+	if (gspca_dev->streaming)
+		pac7302_sethvflip(gspca_dev);
+	return 0;
+}
+
+static int pac7311_sd_sethflip(struct gspca_dev *gspca_dev, __s32 val)
 {
 	struct sd *sd = (struct sd *) gspca_dev;

 	sd->hflip = val;
 	if (gspca_dev->streaming)
-		sethvflip(gspca_dev);
+		pac7311_sethvflip(gspca_dev);
 	return 0;
 }

-static int sd_gethflip(struct gspca_dev *gspca_dev, __s32 *val)
+static int pac7302_sd_gethflip(struct gspca_dev *gspca_dev, __s32 *val)
 {
 	struct sd *sd = (struct sd *) gspca_dev;

@@ -1273,17 +1292,43 @@ static int sd_gethflip(struct gspca_dev
 	return 0;
 }

-static int sd_setvflip(struct gspca_dev *gspca_dev, __s32 val)
+static int pac7311_sd_gethflip(struct gspca_dev *gspca_dev, __s32 *val)
+{
+	struct sd *sd = (struct sd *) gspca_dev;
+
+	*val = sd->hflip;
+	return 0;
+}
+
+static int pac7302_sd_setvflip(struct gspca_dev *gspca_dev, __s32 val)
+{
+	struct sd *sd = (struct sd *) gspca_dev;
+
+	sd->vflip = val;
+	if (gspca_dev->streaming)
+		pac7302_sethvflip(gspca_dev);
+	return 0;
+}
+
+static int pac7311_sd_setvflip(struct gspca_dev *gspca_dev, __s32 val)
 {
 	struct sd *sd = (struct sd *) gspca_dev;

 	sd->vflip = val;
 	if (gspca_dev->streaming)
-		sethvflip(gspca_dev);
+		pac7311_sethvflip(gspca_dev);
+	return 0;
+}
+
+static int pac7302_sd_getvflip(struct gspca_dev *gspca_dev, __s32 *val)
+{
+	struct sd *sd = (struct sd *) gspca_dev;
+
+	*val = sd->vflip;
 	return 0;
 }

-static int sd_getvflip(struct gspca_dev *gspca_dev, __s32 *val)
+static int pac7311_sd_getvflip(struct gspca_dev *gspca_dev, __s32 *val)
 {
 	struct sd *sd = (struct sd *) gspca_dev;

