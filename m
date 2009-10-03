Return-path: <linux-media-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.25]:58494 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753630AbZJCWCR (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 3 Oct 2009 18:02:17 -0400
Received: by ey-out-2122.google.com with SMTP id 4so223338eyf.5
        for <linux-media@vger.kernel.org>; Sat, 03 Oct 2009 15:01:07 -0700 (PDT)
Subject: [PATCH 3/3] gspca_gl860/Fixed format : improvement of the driver
 for OV2640 sensor
From: Olivier Lorin <olorin75@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain
Date: Sun, 04 Oct 2009 00:01:04 +0200
Message-Id: <1254607264.24873.45.camel@miniol>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

gspca_gl860: improvement of the driver for OV2640 sensor

From: Olivier Lorin <o.lorin@laposte.net>

- simplified initialization sequence
- add flip/mirror support for OV2640
- fix for backlight value range
- fix for red-blue inversion hue mode with V4L1 applications

diff -rupN ../gspca-msrc2/linux/drivers/media/video/gspca/gl860/gl860.h ./linux/drivers/media/video/gspca/gl860/gl860.h
--- ../gspca-msrc2/linux/drivers/media/video/gspca/gl860/gl860.h	2009-09-24 23:16:10.000000000 +0200
+++ ./linux/drivers/media/video/gspca/gl860/gl860.h	2009-09-24 23:55:32.000000000 +0200
@@ -23,7 +23,7 @@
 #include "gspca.h"
 
 #define MODULE_NAME "gspca_gl860"
-#define DRIVER_VERSION "0.9d11"
+#define DRIVER_VERSION "0.9e"
 
 #define ctrl_in  gl860_RTx
 #define ctrl_out gl860_RTx
diff -rupN ../gspca-msrc2/linux/drivers/media/video/gspca/gl860/gl860-ov2640.c ./linux/drivers/media/video/gspca/gl860/gl860-ov2640.c
--- ../gspca-msrc2/linux/drivers/media/video/gspca/gl860/gl860-ov2640.c	2009-09-24 23:34:57.000000000 +0200
+++ ./linux/drivers/media/video/gspca/gl860/gl860-ov2640.c	2009-09-30 00:40:49.000000000 +0200
@@ -107,36 +107,6 @@ static struct validx tbl_sensor_settings
 	{0x6001, 0x00ff}, {0x6038, 0x000c},
 	{10, 0xffff},
 	{0x6000, 0x0011},
-	/* backlight=31/64 */
-	{0x6001, 0x00ff}, {0x603e, 0x0024}, {0x6034, 0x0025},
-	/* bright=0/256 */
-	{0x6000, 0x00ff}, {0x6009, 0x007c}, {0x6000, 0x007d},
-	/* wbal=64/128 */
-	{0x6000, 0x00ff}, {0x6003, 0x007c}, {0x6040, 0x007d},
-	/* cntr=0/256 */
-	{0x6000, 0x00ff}, {0x6007, 0x007c}, {0x6000, 0x007d},
-	/* sat=128/256 */
-	{0x6000, 0x00ff}, {0x6001, 0x007c}, {0x6080, 0x007d},
-	/* sharpness=0/32 */
-	{0x6000, 0x00ff}, {0x6001, 0x0092}, {0x60c0, 0x0093},
-	/* hue=0/256 */
-	{0x6000, 0x00ff}, {0x6002, 0x007c}, {0x6000, 0x007d},
-	/* gam=32/64 */
-	{0x6000, 0x00ff}, {0x6008, 0x007c}, {0x6020, 0x007d},
-	/* image right up */
-	{0xffff, 0xffff},
-	{15, 0xffff},
-	{0x6001, 0x00ff}, {0x6000, 0x8004},
-	{0xffff, 0xffff},
-	{0x60a8, 0x0004},
-	{15, 0xffff},
-	{0x6001, 0x00ff}, {0x6000, 0x8004},
-	{0xffff, 0xffff},
-	{0x60f8, 0x0004},
-	/* image right up */
-	{0xffff, 0xffff},
-	/* backlight=31/64 */
-	{0x6001, 0x00ff}, {0x603e, 0x0024}, {0x6034, 0x0025},
 };
 
 static struct validx tbl_640[] = {
@@ -222,17 +192,19 @@ void ov2640_init_settings(struct gspca_d
 	sd->vcur.hue        =   0;
 	sd->vcur.saturation = 128;
 	sd->vcur.whitebal   =  64;
+	sd->vcur.mirror     =   0;
+	sd->vcur.flip       =   0;
 
 	sd->vmax.backlight  =  64;
 	sd->vmax.brightness = 255;
 	sd->vmax.sharpness  =  31;
 	sd->vmax.contrast   = 255;
 	sd->vmax.gamma      =  64;
-	sd->vmax.hue        = 255 + 1;
+	sd->vmax.hue        = 254 + 2;
 	sd->vmax.saturation = 255;
 	sd->vmax.whitebal   = 128;
-	sd->vmax.mirror     = 0;
-	sd->vmax.flip       = 0;
+	sd->vmax.mirror     = 1;
+	sd->vmax.flip       = 1;
 	sd->vmax.AC50Hz     = 0;
 
 	sd->dev_camera_settings = ov2640_camera_settings;
@@ -284,6 +256,8 @@ static int ov2640_init_pre_alt(struct gs
 	sd->vold.gamma    = -1;
 	sd->vold.hue      = -1;
 	sd->vold.whitebal = -1;
+	sd->vold.mirror = -1;
+	sd->vold.flip   = -1;
 
 	ov2640_init_post_alt(gspca_dev);
 
@@ -346,18 +320,6 @@ static int ov2640_init_post_alt(struct g
 
 	fetch_validx(gspca_dev, tbl_sensor_settings_common2,
 			ARRAY_SIZE(tbl_sensor_settings_common2));
-	ctrl_in(gspca_dev, 0xc0, 2, 0x0000, 0x0000, 1, c50);
-	keep_on_fetching_validx(gspca_dev, tbl_sensor_settings_common2,
-				ARRAY_SIZE(tbl_sensor_settings_common2), n);
-	ctrl_in(gspca_dev, 0xc0, 2, 0x6000, 0x8004, 1, c28);
-	keep_on_fetching_validx(gspca_dev, tbl_sensor_settings_common2,
-				ARRAY_SIZE(tbl_sensor_settings_common2), n);
-	ctrl_in(gspca_dev, 0xc0, 2, 0x6000, 0x8004, 1, ca8);
-	keep_on_fetching_validx(gspca_dev, tbl_sensor_settings_common2,
-				ARRAY_SIZE(tbl_sensor_settings_common2), n);
-	ctrl_in(gspca_dev, 0xc0, 2, 0x0000, 0x0000, 1, c50);
-	keep_on_fetching_validx(gspca_dev, tbl_sensor_settings_common2,
-				ARRAY_SIZE(tbl_sensor_settings_common2), n);
 
 	ov2640_camera_settings(gspca_dev);
 
@@ -394,6 +356,8 @@ static int ov2640_camera_settings(struct
 	s32 sat    = sd->vcur.saturation;
 	s32 hue    = sd->vcur.hue;
 	s32 wbal   = sd->vcur.whitebal;
+	s32 mirror = (((sd->vcur.mirror > 0) ^ sd->mirrorMask) == 0);
+	s32 flip   = (((sd->vcur.flip   > 0) ^ sd->mirrorMask) == 0);
 
 	if (backlight != sd->vold.backlight) {
 		/* No sd->vold.backlight=backlight; (to be done again later) */
@@ -402,9 +366,9 @@ static int ov2640_camera_settings(struct
 
 		ctrl_out(gspca_dev, 0x40, 1, 0x6001                 , 0x00ff,
 				0, NULL);
-		ctrl_out(gspca_dev, 0x40, 1, 0x601f + backlight     , 0x0024,
+		ctrl_out(gspca_dev, 0x40, 1, 0x601e + backlight     , 0x0024,
 				0, NULL);
-		ctrl_out(gspca_dev, 0x40, 1, 0x601f + backlight - 10, 0x0025,
+		ctrl_out(gspca_dev, 0x40, 1, 0x601e + backlight - 10, 0x0025,
 				0, NULL);
 	}
 
@@ -467,7 +431,7 @@ static int ov2640_camera_settings(struct
 		ctrl_out(gspca_dev, 0x40, 1, 0x6002     , 0x007c, 0, NULL);
 		ctrl_out(gspca_dev, 0x40, 1, 0x6000 + hue * (hue < 255), 0x007d,
 				0, NULL);
-		if (hue >= sd->vmax.hue)
+		if (hue >= 255)
 			sd->swapRB = 1;
 		else
 			sd->swapRB = 0;
@@ -483,14 +447,33 @@ static int ov2640_camera_settings(struct
 		ctrl_out(gspca_dev, 0x40, 1, 0x6000 + gam, 0x007d, 0, NULL);
 	}
 
+	if (mirror != sd->vold.mirror || flip != sd->vold.flip) {
+		sd->vold.mirror = mirror;
+		sd->vold.flip   = flip;
+
+		mirror = 0x80 * mirror;
+		ctrl_out(gspca_dev, 0x40, 1, 0x6001, 0x00ff, 0, NULL);
+		ctrl_out(gspca_dev, 0x40, 1, 0x6000, 0x8004, 0, NULL);
+		ctrl_in(gspca_dev, 0xc0, 2, 0x6000, 0x8004, 1, &c28);
+		ctrl_out(gspca_dev, 0x40, 1, 0x6028 + mirror, 0x0004, 0, NULL);
+
+		flip = 0x50 * flip + mirror;
+		ctrl_out(gspca_dev, 0x40, 1, 0x6001, 0x00ff, 0, NULL);
+		ctrl_out(gspca_dev, 0x40, 1, 0x6000, 0x8004, 0, NULL);
+		ctrl_in(gspca_dev, 0xc0, 2, 0x6000, 0x8004, 1, &ca8);
+		ctrl_out(gspca_dev, 0x40, 1, 0x6028 + flip, 0x0004, 0, NULL);
+
+		ctrl_in(gspca_dev, 0xc0, 2, 0x0000, 0x0000, 1, &c50);
+	}
+
 	if (backlight != sd->vold.backlight) {
 		sd->vold.backlight = backlight;
 
 		ctrl_out(gspca_dev, 0x40, 1, 0x6001                 , 0x00ff,
 				0, NULL);
-		ctrl_out(gspca_dev, 0x40, 1, 0x601f + backlight     , 0x0024,
+		ctrl_out(gspca_dev, 0x40, 1, 0x601e + backlight     , 0x0024,
 				0, NULL);
-		ctrl_out(gspca_dev, 0x40, 1, 0x601f + backlight - 10, 0x0025,
+		ctrl_out(gspca_dev, 0x40, 1, 0x601e + backlight - 10, 0x0025,
 				0, NULL);
 	}
 


