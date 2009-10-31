Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail01d.mail.t-online.hu ([84.2.42.6]:51400 "EHLO
	mail01d.mail.t-online.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933340AbZJaXNz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 31 Oct 2009 19:13:55 -0400
Message-ID: <4AECC4B4.8080401@freemail.hu>
Date: Sun, 01 Nov 2009 00:13:56 +0100
From: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
MIME-Version: 1.0
To: Jean-Francois Moine <moinejf@free.fr>,
	Hans de Goede <hdegoede@redhat.com>,
	V4L Mailing List <linux-media@vger.kernel.org>
CC: Thomas Kaiser <thomas@kaiser-linux.li>,
	Theodore Kilgore <kilgota@auburn.edu>,
	Kyle Guinn <elyk03@gmail.com>
Subject: [PATCH 04/21] gspca pac7302/pac7311: separate config
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Márton Németh <nm127@freemail.hu>

Separate the config function. Remove the run-time decision for
PAC7302 and PAC7311 sensors.

Signed-off-by: Márton Németh <nm127@freemail.hu>
Cc: Thomas Kaiser <thomas@kaiser-linux.li>
Cc: Theodore Kilgore <kilgota@auburn.edu>
Cc: Kyle Guinn <elyk03@gmail.com>
---
diff -uprN d/drivers/media/video/gspca/pac7311.c e/drivers/media/video/gspca/pac7311.c
--- d/drivers/media/video/gspca/pac7311.c	2009-10-30 17:15:51.000000000 +0100
+++ e/drivers/media/video/gspca/pac7311.c	2009-10-30 17:27:57.000000000 +0100
@@ -509,8 +509,8 @@ static void reg_w_var(struct gspca_dev *
 	/* not reached */
 }

-/* this function is called at probe time */
-static int sd_config(struct gspca_dev *gspca_dev,
+/* this function is called at probe time for pac7302 */
+static int pac7302_sd_config(struct gspca_dev *gspca_dev,
 			const struct usb_device_id *id)
 {
 	struct sd *sd = (struct sd *) gspca_dev;
@@ -519,17 +519,36 @@ static int sd_config(struct gspca_dev *g
 	cam = &gspca_dev->cam;

 	sd->sensor = id->driver_info;
-	if (sd->sensor == SENSOR_PAC7302) {
-		PDEBUG(D_CONF, "Find Sensor PAC7302");
-		cam->cam_mode = &vga_mode[2];	/* only 640x480 */
-		cam->nmodes = 1;
-	} else {
-		PDEBUG(D_CONF, "Find Sensor PAC7311");
-		cam->cam_mode = vga_mode;
-		cam->nmodes = ARRAY_SIZE(vga_mode);
-		gspca_dev->ctrl_dis = (1 << BRIGHTNESS_IDX)
-				| (1 << SATURATION_IDX);
-	}
+	PDEBUG(D_CONF, "Find Sensor PAC7302");
+	cam->cam_mode = &vga_mode[2];	/* only 640x480 */
+	cam->nmodes = 1;
+
+	sd->brightness = BRIGHTNESS_DEF;
+	sd->contrast = CONTRAST_DEF;
+	sd->colors = COLOR_DEF;
+	sd->gain = GAIN_DEF;
+	sd->exposure = EXPOSURE_DEF;
+	sd->autogain = AUTOGAIN_DEF;
+	sd->hflip = HFLIP_DEF;
+	sd->vflip = VFLIP_DEF;
+	return 0;
+}
+
+/* this function is called at probe time for pac7311 */
+static int pac7311_sd_config(struct gspca_dev *gspca_dev,
+			const struct usb_device_id *id)
+{
+	struct sd *sd = (struct sd *) gspca_dev;
+	struct cam *cam;
+
+	cam = &gspca_dev->cam;
+
+	sd->sensor = id->driver_info;
+	PDEBUG(D_CONF, "Find Sensor PAC7311");
+	cam->cam_mode = vga_mode;
+	cam->nmodes = ARRAY_SIZE(vga_mode);
+	gspca_dev->ctrl_dis = (1 << BRIGHTNESS_IDX)
+			| (1 << SATURATION_IDX);

 	sd->brightness = BRIGHTNESS_DEF;
 	sd->contrast = CONTRAST_DEF;
@@ -1136,7 +1155,7 @@ static struct sd_desc pac7302_sd_desc =
 	.name = MODULE_NAME,
 	.ctrls = sd_ctrls,
 	.nctrls = ARRAY_SIZE(sd_ctrls),
-	.config = sd_config,
+	.config = pac7302_sd_config,
 	.init = sd_init,
 	.start = sd_start,
 	.stopN = sd_stopN,
@@ -1150,7 +1169,7 @@ static struct sd_desc pac7311_sd_desc =
 	.name = MODULE_NAME,
 	.ctrls = sd_ctrls,
 	.nctrls = ARRAY_SIZE(sd_ctrls),
-	.config = sd_config,
+	.config = pac7311_sd_config,
 	.init = sd_init,
 	.start = sd_start,
 	.stopN = sd_stopN,
