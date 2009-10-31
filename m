Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail02a.mail.t-online.hu ([84.2.40.7]:56689 "EHLO
	mail02a.mail.t-online.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933367AbZJaXPE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 31 Oct 2009 19:15:04 -0400
Message-ID: <4AECC4F5.4040705@freemail.hu>
Date: Sun, 01 Nov 2009 00:15:01 +0100
From: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
MIME-Version: 1.0
To: Jean-Francois Moine <moinejf@free.fr>,
	Hans de Goede <hdegoede@redhat.com>,
	V4L Mailing List <linux-media@vger.kernel.org>
CC: Thomas Kaiser <thomas@kaiser-linux.li>,
	Theodore Kilgore <kilgota@auburn.edu>,
	Kyle Guinn <elyk03@gmail.com>
Subject: [PATCH 10/21] gspca pac7302/pac7311: separate brightness and color
 controls
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Márton Németh <nm127@freemail.hu>

Separate the controls for PAC7302 and for PAC7311. Separate the brightness
and color controls. The ctrl_dis setting is no longer necessary because the
brightness and saturation controls are only listed among PAC7302 controls.

Signed-off-by: Márton Németh <nm127@freemail.hu>
Cc: Thomas Kaiser <thomas@kaiser-linux.li>
Cc: Theodore Kilgore <kilgota@auburn.edu>
Cc: Kyle Guinn <elyk03@gmail.com>
---
diff -uprN j/drivers/media/video/gspca/pac7311.c k/drivers/media/video/gspca/pac7311.c
--- j/drivers/media/video/gspca/pac7311.c	2009-10-30 18:00:55.000000000 +0100
+++ k/drivers/media/video/gspca/pac7311.c	2009-10-31 07:13:44.000000000 +0100
@@ -81,12 +81,12 @@ struct sd {
 };

 /* V4L2 controls supported by the driver */
-static int sd_setbrightness(struct gspca_dev *gspca_dev, __s32 val);
-static int sd_getbrightness(struct gspca_dev *gspca_dev, __s32 *val);
+static int pac7302_sd_setbrightness(struct gspca_dev *gspca_dev, __s32 val);
+static int pac7302_sd_getbrightness(struct gspca_dev *gspca_dev, __s32 *val);
 static int sd_setcontrast(struct gspca_dev *gspca_dev, __s32 val);
 static int sd_getcontrast(struct gspca_dev *gspca_dev, __s32 *val);
-static int sd_setcolors(struct gspca_dev *gspca_dev, __s32 val);
-static int sd_getcolors(struct gspca_dev *gspca_dev, __s32 *val);
+static int pac7302_sd_setcolors(struct gspca_dev *gspca_dev, __s32 val);
+static int pac7302_sd_getcolors(struct gspca_dev *gspca_dev, __s32 *val);
 static int sd_setautogain(struct gspca_dev *gspca_dev, __s32 val);
 static int sd_getautogain(struct gspca_dev *gspca_dev, __s32 *val);
 static int sd_sethflip(struct gspca_dev *gspca_dev, __s32 val);
@@ -98,9 +98,8 @@ static int sd_getgain(struct gspca_dev *
 static int sd_setexposure(struct gspca_dev *gspca_dev, __s32 val);
 static int sd_getexposure(struct gspca_dev *gspca_dev, __s32 *val);

-static struct ctrl sd_ctrls[] = {
+static struct ctrl pac7302_sd_ctrls[] = {
 /* This control is pac7302 only */
-#define BRIGHTNESS_IDX 0
 	{
 	    {
 		.id      = V4L2_CID_BRIGHTNESS,
@@ -113,8 +112,8 @@ static struct ctrl sd_ctrls[] = {
 #define BRIGHTNESS_DEF 0x10
 		.default_value = BRIGHTNESS_DEF,
 	    },
-	    .set = sd_setbrightness,
-	    .get = sd_getbrightness,
+	    .set = pac7302_sd_setbrightness,
+	    .get = pac7302_sd_getbrightness,
 	},
 /* This control is for both the 7302 and the 7311 */
 	{
@@ -133,7 +132,6 @@ static struct ctrl sd_ctrls[] = {
 	    .get = sd_getcontrast,
 	},
 /* This control is pac7302 only */
-#define SATURATION_IDX 2
 	{
 	    {
 		.id      = V4L2_CID_SATURATION,
@@ -146,8 +144,102 @@ static struct ctrl sd_ctrls[] = {
 #define COLOR_DEF 127
 		.default_value = COLOR_DEF,
 	    },
-	    .set = sd_setcolors,
-	    .get = sd_getcolors,
+	    .set = pac7302_sd_setcolors,
+	    .get = pac7302_sd_getcolors,
+	},
+/* All controls below are for both the 7302 and the 7311 */
+	{
+	    {
+		.id      = V4L2_CID_GAIN,
+		.type    = V4L2_CTRL_TYPE_INTEGER,
+		.name    = "Gain",
+		.minimum = 0,
+#define GAIN_MAX 255
+		.maximum = GAIN_MAX,
+		.step    = 1,
+#define GAIN_DEF 127
+#define GAIN_KNEE 255 /* Gain seems to cause little noise on the pac73xx */
+		.default_value = GAIN_DEF,
+	    },
+	    .set = sd_setgain,
+	    .get = sd_getgain,
+	},
+	{
+	    {
+		.id      = V4L2_CID_EXPOSURE,
+		.type    = V4L2_CTRL_TYPE_INTEGER,
+		.name    = "Exposure",
+		.minimum = 0,
+#define EXPOSURE_MAX 255
+		.maximum = EXPOSURE_MAX,
+		.step    = 1,
+#define EXPOSURE_DEF  16 /*  32 ms / 30 fps */
+#define EXPOSURE_KNEE 50 /* 100 ms / 10 fps */
+		.default_value = EXPOSURE_DEF,
+	    },
+	    .set = sd_setexposure,
+	    .get = sd_getexposure,
+	},
+	{
+	    {
+		.id      = V4L2_CID_AUTOGAIN,
+		.type    = V4L2_CTRL_TYPE_BOOLEAN,
+		.name    = "Auto Gain",
+		.minimum = 0,
+		.maximum = 1,
+		.step    = 1,
+#define AUTOGAIN_DEF 1
+		.default_value = AUTOGAIN_DEF,
+	    },
+	    .set = sd_setautogain,
+	    .get = sd_getautogain,
+	},
+	{
+	    {
+		.id      = V4L2_CID_HFLIP,
+		.type    = V4L2_CTRL_TYPE_BOOLEAN,
+		.name    = "Mirror",
+		.minimum = 0,
+		.maximum = 1,
+		.step    = 1,
+#define HFLIP_DEF 0
+		.default_value = HFLIP_DEF,
+	    },
+	    .set = sd_sethflip,
+	    .get = sd_gethflip,
+	},
+	{
+	    {
+		.id      = V4L2_CID_VFLIP,
+		.type    = V4L2_CTRL_TYPE_BOOLEAN,
+		.name    = "Vflip",
+		.minimum = 0,
+		.maximum = 1,
+		.step    = 1,
+#define VFLIP_DEF 0
+		.default_value = VFLIP_DEF,
+	    },
+	    .set = sd_setvflip,
+	    .get = sd_getvflip,
+	},
+};
+
+static struct ctrl pac7311_sd_ctrls[] = {
+/* This control is for both the 7302 and the 7311 */
+	{
+	    {
+		.id      = V4L2_CID_CONTRAST,
+		.type    = V4L2_CTRL_TYPE_INTEGER,
+		.name    = "Contrast",
+		.minimum = 0,
+#define CONTRAST_MAX 255
+		.maximum = CONTRAST_MAX,
+		.step    = 1,
+#define CONTRAST_DEF 127
+		.default_value = CONTRAST_DEF,
+	    },
+	    .set = sd_setcontrast,
+	    .get = sd_getcontrast,
 	},
 /* All controls below are for both the 7302 and the 7311 */
 	{
@@ -547,8 +639,6 @@ static int pac7311_sd_config(struct gspc
 	PDEBUG(D_CONF, "Find Sensor PAC7311");
 	cam->cam_mode = vga_mode;
 	cam->nmodes = ARRAY_SIZE(vga_mode);
-	gspca_dev->ctrl_dis = (1 << BRIGHTNESS_IDX)
-			| (1 << SATURATION_IDX);

 	sd->brightness = BRIGHTNESS_DEF;
 	sd->contrast = CONTRAST_DEF;
@@ -1022,7 +1112,7 @@ static void pac7311_sd_pkt_scan(struct g
 	gspca_frame_add(gspca_dev, INTER_PACKET, frame, data, len);
 }

-static int sd_setbrightness(struct gspca_dev *gspca_dev, __s32 val)
+static int pac7302_sd_setbrightness(struct gspca_dev *gspca_dev, __s32 val)
 {
 	struct sd *sd = (struct sd *) gspca_dev;

@@ -1032,7 +1122,7 @@ static int sd_setbrightness(struct gspca
 	return 0;
 }

-static int sd_getbrightness(struct gspca_dev *gspca_dev, __s32 *val)
+static int pac7302_sd_getbrightness(struct gspca_dev *gspca_dev, __s32 *val)
 {
 	struct sd *sd = (struct sd *) gspca_dev;

@@ -1062,7 +1152,7 @@ static int sd_getcontrast(struct gspca_d
 	return 0;
 }

-static int sd_setcolors(struct gspca_dev *gspca_dev, __s32 val)
+static int pac7302_sd_setcolors(struct gspca_dev *gspca_dev, __s32 val)
 {
 	struct sd *sd = (struct sd *) gspca_dev;

@@ -1072,7 +1162,7 @@ static int sd_setcolors(struct gspca_dev
 	return 0;
 }

-static int sd_getcolors(struct gspca_dev *gspca_dev, __s32 *val)
+static int pac7302_sd_getcolors(struct gspca_dev *gspca_dev, __s32 *val)
 {
 	struct sd *sd = (struct sd *) gspca_dev;

@@ -1186,8 +1276,8 @@ static int sd_getvflip(struct gspca_dev
 /* sub-driver description for pac7302 */
 static struct sd_desc pac7302_sd_desc = {
 	.name = MODULE_NAME,
-	.ctrls = sd_ctrls,
-	.nctrls = ARRAY_SIZE(sd_ctrls),
+	.ctrls = pac7302_sd_ctrls,
+	.nctrls = ARRAY_SIZE(pac7302_sd_ctrls),
 	.config = pac7302_sd_config,
 	.init = pac7302_sd_init,
 	.start = pac7302_sd_start,
@@ -1200,8 +1290,8 @@ static struct sd_desc pac7302_sd_desc =
 /* sub-driver description for pac7311 */
 static struct sd_desc pac7311_sd_desc = {
 	.name = MODULE_NAME,
-	.ctrls = sd_ctrls,
-	.nctrls = ARRAY_SIZE(sd_ctrls),
+	.ctrls = pac7311_sd_ctrls,
+	.nctrls = ARRAY_SIZE(pac7311_sd_ctrls),
 	.config = pac7311_sd_config,
 	.init = pac7311_sd_init,
 	.start = pac7311_sd_start,
