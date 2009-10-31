Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail02a.mail.t-online.hu ([84.2.40.7]:55302 "EHLO
	mail02a.mail.t-online.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933373AbZJaXP6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 31 Oct 2009 19:15:58 -0400
Message-ID: <4AECC52D.9050401@freemail.hu>
Date: Sun, 01 Nov 2009 00:15:57 +0100
From: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
MIME-Version: 1.0
To: Jean-Francois Moine <moinejf@free.fr>,
	Hans de Goede <hdegoede@redhat.com>,
	V4L Mailing List <linux-media@vger.kernel.org>
CC: Thomas Kaiser <thomas@kaiser-linux.li>,
	Theodore Kilgore <kilgota@auburn.edu>,
	Kyle Guinn <elyk03@gmail.com>
Subject: [PATCH 14/21] gspca pac7302/pac7311: separate exposure
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Márton Németh <nm127@freemail.hu>

Separate the exposure control. Remove the run-time
decision for PAC7302 and PAC7311 sensors.

Signed-off-by: Márton Németh <nm127@freemail.hu>
Cc: Thomas Kaiser <thomas@kaiser-linux.li>
Cc: Theodore Kilgore <kilgota@auburn.edu>
Cc: Kyle Guinn <elyk03@gmail.com>
---
diff -uprN n/drivers/media/video/gspca/pac7311.c o/drivers/media/video/gspca/pac7311.c
--- n/drivers/media/video/gspca/pac7311.c	2009-10-31 07:38:45.000000000 +0100
+++ o/drivers/media/video/gspca/pac7311.c	2009-10-31 07:45:27.000000000 +0100
@@ -105,8 +105,10 @@ static int pac7302_sd_setgain(struct gsp
 static int pac7311_sd_setgain(struct gspca_dev *gspca_dev, __s32 val);
 static int pac7302_sd_getgain(struct gspca_dev *gspca_dev, __s32 *val);
 static int pac7311_sd_getgain(struct gspca_dev *gspca_dev, __s32 *val);
-static int sd_setexposure(struct gspca_dev *gspca_dev, __s32 val);
-static int sd_getexposure(struct gspca_dev *gspca_dev, __s32 *val);
+static int pac7302_sd_setexposure(struct gspca_dev *gspca_dev, __s32 val);
+static int pac7311_sd_setexposure(struct gspca_dev *gspca_dev, __s32 val);
+static int pac7302_sd_getexposure(struct gspca_dev *gspca_dev, __s32 *val);
+static int pac7311_sd_getexposure(struct gspca_dev *gspca_dev, __s32 *val);

 static struct ctrl pac7302_sd_ctrls[] = {
 /* This control is pac7302 only */
@@ -187,8 +189,8 @@ static struct ctrl pac7302_sd_ctrls[] =
 #define EXPOSURE_KNEE 50 /* 100 ms / 10 fps */
 		.default_value = EXPOSURE_DEF,
 	    },
-	    .set = sd_setexposure,
-	    .get = sd_getexposure,
+	    .set = pac7302_sd_setexposure,
+	    .get = pac7302_sd_getexposure,
 	},
 	{
 	    {
@@ -281,8 +283,8 @@ static struct ctrl pac7311_sd_ctrls[] =
 #define EXPOSURE_KNEE 50 /* 100 ms / 10 fps */
 		.default_value = EXPOSURE_DEF,
 	    },
-	    .set = sd_setexposure,
-	    .get = sd_getexposure,
+	    .set = pac7311_sd_setexposure,
+	    .get = pac7311_sd_getexposure,
 	},
 	{
 	    {
@@ -749,7 +751,7 @@ static void pac7311_setgain(struct gspca
 	reg_w(gspca_dev, 0x11, 0x01);
 }

-static void setexposure(struct gspca_dev *gspca_dev)
+static void pac7302_setexposure(struct gspca_dev *gspca_dev)
 {
 	struct sd *sd = (struct sd *) gspca_dev;
 	__u8 reg;
@@ -763,25 +765,42 @@ static void setexposure(struct gspca_dev
 	else if (reg > 63)
 		reg = 63;

-	if (sd->sensor == SENSOR_PAC7302) {
-		/* On the pac7302 reg2 MUST be a multiple of 3, so round it to
-		   the nearest multiple of 3, except when between 6 and 12? */
-		if (reg < 6 || reg > 12)
-			reg = ((reg + 1) / 3) * 3;
-		reg_w(gspca_dev, 0xff, 0x03);		/* page 3 */
-		reg_w(gspca_dev, 0x02, reg);
-	} else {
-		reg_w(gspca_dev, 0xff, 0x04);		/* page 4 */
-		reg_w(gspca_dev, 0x02, reg);
-		/* Page 1 register 8 must always be 0x08 except when not in
-		   640x480 mode and Page3/4 reg 2 <= 3 then it must be 9 */
-		reg_w(gspca_dev, 0xff, 0x01);
-		if (gspca_dev->cam.cam_mode[(int)gspca_dev->curr_mode].priv &&
-				reg <= 3)
-			reg_w(gspca_dev, 0x08, 0x09);
-		else
-			reg_w(gspca_dev, 0x08, 0x08);
-	}
+	/* On the pac7302 reg2 MUST be a multiple of 3, so round it to
+	   the nearest multiple of 3, except when between 6 and 12? */
+	if (reg < 6 || reg > 12)
+		reg = ((reg + 1) / 3) * 3;
+	reg_w(gspca_dev, 0xff, 0x03);		/* page 3 */
+	reg_w(gspca_dev, 0x02, reg);
+
+	/* load registers to sensor (Bit 0, auto clear) */
+	reg_w(gspca_dev, 0x11, 0x01);
+}
+
+static void pac7311_setexposure(struct gspca_dev *gspca_dev)
+{
+	struct sd *sd = (struct sd *) gspca_dev;
+	__u8 reg;
+
+	/* register 2 of frame 3/4 contains the clock divider configuring the
+	   no fps according to the formula: 60 / reg. sd->exposure is the
+	   desired exposure time in ms. */
+	reg = 120 * sd->exposure / 1000;
+	if (reg < 2)
+		reg = 2;
+	else if (reg > 63)
+		reg = 63;
+
+	reg_w(gspca_dev, 0xff, 0x04);		/* page 4 */
+	reg_w(gspca_dev, 0x02, reg);
+	/* Page 1 register 8 must always be 0x08 except when not in
+	   640x480 mode and Page3/4 reg 2 <= 3 then it must be 9 */
+	reg_w(gspca_dev, 0xff, 0x01);
+	if (gspca_dev->cam.cam_mode[(int)gspca_dev->curr_mode].priv &&
+			reg <= 3)
+		reg_w(gspca_dev, 0x08, 0x09);
+	else
+		reg_w(gspca_dev, 0x08, 0x08);
+
 	/* load registers to sensor (Bit 0, auto clear) */
 	reg_w(gspca_dev, 0x11, 0x01);
 }
@@ -836,7 +855,7 @@ static int pac7302_sd_start(struct gspca
 	pac7302_setbrightcont(gspca_dev);
 	pac7302_setcolors(gspca_dev);
 	pac7302_setgain(gspca_dev);
-	setexposure(gspca_dev);
+	pac7302_setexposure(gspca_dev);
 	pac7302_sethvflip(gspca_dev);

 	/* only resolution 640x480 is supported for pac7302 */
@@ -861,7 +880,7 @@ static int pac7311_sd_start(struct gspca
 	reg_w_var(gspca_dev, start_7311);
 	pac7311_setcontrast(gspca_dev);
 	pac7311_setgain(gspca_dev);
-	setexposure(gspca_dev);
+	pac7311_setexposure(gspca_dev);
 	pac7311_sethvflip(gspca_dev);

 	/* set correct resolution */
@@ -1244,17 +1263,35 @@ static int pac7311_sd_getgain(struct gsp
 	return 0;
 }

-static int sd_setexposure(struct gspca_dev *gspca_dev, __s32 val)
+static int pac7302_sd_setexposure(struct gspca_dev *gspca_dev, __s32 val)
+{
+	struct sd *sd = (struct sd *) gspca_dev;
+
+	sd->exposure = val;
+	if (gspca_dev->streaming)
+		pac7302_setexposure(gspca_dev);
+	return 0;
+}
+
+static int pac7311_sd_setexposure(struct gspca_dev *gspca_dev, __s32 val)
 {
 	struct sd *sd = (struct sd *) gspca_dev;

 	sd->exposure = val;
 	if (gspca_dev->streaming)
-		setexposure(gspca_dev);
+		pac7311_setexposure(gspca_dev);
+	return 0;
+}
+
+static int pac7302_sd_getexposure(struct gspca_dev *gspca_dev, __s32 *val)
+{
+	struct sd *sd = (struct sd *) gspca_dev;
+
+	*val = sd->exposure;
 	return 0;
 }

-static int sd_getexposure(struct gspca_dev *gspca_dev, __s32 *val)
+static int pac7311_sd_getexposure(struct gspca_dev *gspca_dev, __s32 *val)
 {
 	struct sd *sd = (struct sd *) gspca_dev;

@@ -1277,7 +1314,7 @@ static int pac7302_sd_setautogain(struct
 		if (gspca_dev->streaming) {
 			sd->autogain_ignore_frames =
 				PAC_AUTOGAIN_IGNORE_FRAMES;
-			setexposure(gspca_dev);
+			pac7302_setexposure(gspca_dev);
 			pac7302_setgain(gspca_dev);
 		}
 	}
@@ -1300,7 +1337,7 @@ static int pac7311_sd_setautogain(struct
 		if (gspca_dev->streaming) {
 			sd->autogain_ignore_frames =
 				PAC_AUTOGAIN_IGNORE_FRAMES;
-			setexposure(gspca_dev);
+			pac7311_setexposure(gspca_dev);
 			pac7311_setgain(gspca_dev);
 		}
 	}

