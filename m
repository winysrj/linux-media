Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail01a.mail.t-online.hu ([84.2.40.6]:51868 "EHLO
	mail01a.mail.t-online.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933343AbZJaXPX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 31 Oct 2009 19:15:23 -0400
Message-ID: <4AECC505.4040201@freemail.hu>
Date: Sun, 01 Nov 2009 00:15:17 +0100
From: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
MIME-Version: 1.0
To: Jean-Francois Moine <moinejf@free.fr>,
	Hans de Goede <hdegoede@redhat.com>,
	V4L Mailing List <linux-media@vger.kernel.org>
CC: Thomas Kaiser <thomas@kaiser-linux.li>,
	Theodore Kilgore <kilgota@auburn.edu>,
	Kyle Guinn <elyk03@gmail.com>
Subject: [PATCH 11/21] gspca pac7302/pac7311: separate contrast control
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Márton Németh <nm127@freemail.hu>

Separate the contrast control. Remove the run-time decision for
PAC7302 and PAC7311 sensors.

Signed-off-by: Márton Németh <nm127@freemail.hu>
Cc: Thomas Kaiser <thomas@kaiser-linux.li>
Cc: Theodore Kilgore <kilgota@auburn.edu>
Cc: Kyle Guinn <elyk03@gmail.com>
---
diff -uprN k/drivers/media/video/gspca/pac7311.c l/drivers/media/video/gspca/pac7311.c
--- k/drivers/media/video/gspca/pac7311.c	2009-10-31 07:13:44.000000000 +0100
+++ l/drivers/media/video/gspca/pac7311.c	2009-10-31 07:21:22.000000000 +0100
@@ -83,8 +83,10 @@ struct sd {
 /* V4L2 controls supported by the driver */
 static int pac7302_sd_setbrightness(struct gspca_dev *gspca_dev, __s32 val);
 static int pac7302_sd_getbrightness(struct gspca_dev *gspca_dev, __s32 *val);
-static int sd_setcontrast(struct gspca_dev *gspca_dev, __s32 val);
-static int sd_getcontrast(struct gspca_dev *gspca_dev, __s32 *val);
+static int pac7302_sd_setcontrast(struct gspca_dev *gspca_dev, __s32 val);
+static int pac7311_sd_setcontrast(struct gspca_dev *gspca_dev, __s32 val);
+static int pac7302_sd_getcontrast(struct gspca_dev *gspca_dev, __s32 *val);
+static int pac7311_sd_getcontrast(struct gspca_dev *gspca_dev, __s32 *val);
 static int pac7302_sd_setcolors(struct gspca_dev *gspca_dev, __s32 val);
 static int pac7302_sd_getcolors(struct gspca_dev *gspca_dev, __s32 *val);
 static int sd_setautogain(struct gspca_dev *gspca_dev, __s32 val);
@@ -128,8 +130,8 @@ static struct ctrl pac7302_sd_ctrls[] =
 #define CONTRAST_DEF 127
 		.default_value = CONTRAST_DEF,
 	    },
-	    .set = sd_setcontrast,
-	    .get = sd_getcontrast,
+	    .set = pac7302_sd_setcontrast,
+	    .get = pac7302_sd_getcontrast,
 	},
 /* This control is pac7302 only */
 	{
@@ -238,8 +240,8 @@ static struct ctrl pac7311_sd_ctrls[] =
 #define CONTRAST_DEF 127
 		.default_value = CONTRAST_DEF,
 	    },
-	    .set = sd_setcontrast,
-	    .get = sd_getcontrast,
+	    .set = pac7311_sd_setcontrast,
+	    .get = pac7311_sd_getcontrast,
 	},
 /* All controls below are for both the 7302 and the 7311 */
 	{
@@ -1130,21 +1132,37 @@ static int pac7302_sd_getbrightness(stru
 	return 0;
 }

-static int sd_setcontrast(struct gspca_dev *gspca_dev, __s32 val)
+static int pac7302_sd_setcontrast(struct gspca_dev *gspca_dev, __s32 val)
 {
 	struct sd *sd = (struct sd *) gspca_dev;

 	sd->contrast = val;
 	if (gspca_dev->streaming) {
-		if (sd->sensor == SENSOR_PAC7302)
-			pac7302_setbrightcont(gspca_dev);
-		else
-			pac7311_setcontrast(gspca_dev);
+		pac7302_setbrightcont(gspca_dev);
+	}
+	return 0;
+}
+
+static int pac7311_sd_setcontrast(struct gspca_dev *gspca_dev, __s32 val)
+{
+	struct sd *sd = (struct sd *) gspca_dev;
+
+	sd->contrast = val;
+	if (gspca_dev->streaming) {
+		pac7311_setcontrast(gspca_dev);
 	}
 	return 0;
 }

-static int sd_getcontrast(struct gspca_dev *gspca_dev, __s32 *val)
+static int pac7302_sd_getcontrast(struct gspca_dev *gspca_dev, __s32 *val)
+{
+	struct sd *sd = (struct sd *) gspca_dev;
+
+	*val = sd->contrast;
+	return 0;
+}
+
+static int pac7311_sd_getcontrast(struct gspca_dev *gspca_dev, __s32 *val)
 {
 	struct sd *sd = (struct sd *) gspca_dev;

