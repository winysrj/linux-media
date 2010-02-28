Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f220.google.com ([209.85.219.220]:62912 "EHLO
	mail-ew0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031966Ab0B1UTa (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 28 Feb 2010 15:19:30 -0500
Received: by ewy20 with SMTP id 20so916935ewy.21
        for <linux-media@vger.kernel.org>; Sun, 28 Feb 2010 12:19:28 -0800 (PST)
Subject: [PATCH 1/2] New driver for MI2020 sensor with GL860 bridge
From: Olivier Lorin <olorin75@gmail.com>
To: V4L Mailing List <linux-media@vger.kernel.org>
Cc: Jean-Francois Moine <moinejf@free.fr>
Content-Type: text/plain
Date: Sun, 28 Feb 2010 21:19:25 +0100
Message-Id: <1267388365.1854.30.camel@miniol>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

gspca - gl860: updates to prepare the new driver for MI2020 sensor

From: Olivier Lorin <o.lorin@laposte.net>

- General changes for all drivers because of new MI2020 sensor driver :
  - add the light source control
  - control value changes only applied after an end of image
  - replace msleep with duration less than 5 ms by a busy loop
- Fix for an irrelevant OV9655 image resolution identifier name

Priority: normal

Signed-off-by: Olivier Lorin <o.lorin@laposte.net>

diff
-rupN ../o/linux/drivers/media/video/gspca/gl860/gl860.c ./linux/drivers/media/video/gspca/gl860/gl860.c
--- ../o/linux/drivers/media/video/gspca/gl860/gl860.c	2010-02-18
19:02:51.000000000 +0100
+++ ./linux/drivers/media/video/gspca/gl860/gl860.c	2010-02-28
15:04:52.000000000 +0100
@@ -63,7 +63,7 @@ static int sd_set_##thename(struct gspca
 \
 	sd->vcur.thename = val;\
 	if (gspca_dev->streaming)\
-		sd->dev_camera_settings(gspca_dev);\
+		sd->waitSet = 1;\
 	return 0;\
 } \
 static int sd_get_##thename(struct gspca_dev *gspca_dev, s32 *val)\
@@ -85,8 +85,10 @@ SD_SETGET(saturation)
 SD_SETGET(sharpness)
 SD_SETGET(whitebal)
 SD_SETGET(contrast)
+SD_SETGET(lightsource)
 
-#define GL860_NCTRLS 11
+#define GL860_NCTRLS 12
+#define V4L2_CID_LIGHT_SOURCE (V4L2_CID_PRIVATE_BASE + 0)
 
 /* control table */
 static struct ctrl sd_ctrls_mi1320[GL860_NCTRLS];
@@ -148,6 +150,8 @@ static int gl860_build_control_table(str
 		V4L2_CTRL_TYPE_INTEGER, "White Bal.", whitebal)
 	SET_MY_CTRL(V4L2_CID_BACKLIGHT_COMPENSATION,
 		V4L2_CTRL_TYPE_INTEGER, "Backlight" , backlight)
+	SET_MY_CTRL(V4L2_CID_LIGHT_SOURCE,
+		V4L2_CTRL_TYPE_INTEGER, "Light Source" , lightsource)
 
 	SET_MY_CTRL(V4L2_CID_HFLIP,
 		V4L2_CTRL_TYPE_BOOLEAN, "Mirror", mirror)
@@ -620,10 +624,7 @@ int gl860_RTx(struct gspca_dev *gspca_de
 	else if (len > 1 && r < len)
 		PDEBUG(D_ERR, "short ctrl transfer %d/%d", r, len);
 
-	if ((_MI2020_ || _MI2020b_ || _MI2020c_) && (val || index))
-		msleep(1);
-	if (_OV2640_)
-		msleep(1);
+	udelay(850);
 
 	return r;
 }
@@ -638,8 +639,10 @@ int fetch_validx(struct gspca_dev *gspca
 					tbl[n].idx, 0, NULL);
 		else if (tbl[n].val == 0xffff)
 			break;
-		else
+		else if (tbl[n].val > 5)
 			msleep(tbl[n].val);
+		else
+			mdelay(tbl[n].val);
 	}
 	return n;
 }
@@ -653,8 +656,10 @@ int keep_on_fetching_validx(struct gspca
 					0, NULL);
 		else if (tbl[n].val == 0xffff)
 			break;
-		else
+		else if (tbl[n].val > 5)
 			msleep(tbl[n].val);
+		else
+			mdelay(tbl[n].val);
 	}
 	return n;
 }
@@ -667,8 +672,10 @@ void fetch_idxdata(struct gspca_dev *gsp
 		if (memcmp(tbl[n].data, "\xff\xff\xff", 3) != 0)
 			ctrl_out(gspca_dev, 0x40, 3, 0x7a00, tbl[n].idx,
 					3, tbl[n].data);
-		else
+		else if (tbl[n].idx > 5)
 			msleep(tbl[n].idx);
+		else
+			mdelay(tbl[n].idx);
 	}
 }
 
diff
-rupN ../o/linux/drivers/media/video/gspca/gl860/gl860.h ./linux/drivers/media/video/gspca/gl860/gl860.h
--- ../o/linux/drivers/media/video/gspca/gl860/gl860.h	2010-02-18
19:02:51.000000000 +0100
+++ ./linux/drivers/media/video/gspca/gl860/gl860.h	2010-02-28
15:02:12.000000000 +0100
@@ -44,7 +44,7 @@
 #define IMAGE_640   0
 #define IMAGE_800   1
 #define IMAGE_1280  2
-#define IMAGE_1600 3
+#define IMAGE_1600  3
 
 struct sd_gl860 {
 	u16 backlight;
@@ -58,6 +58,7 @@ struct sd_gl860 {
 	u8  mirror;
 	u8  flip;
 	u8  AC50Hz;
+	u8  lightsource;
 };
 
 /* Specific webcam descriptor */
diff
-rupN ../o/linux/drivers/media/video/gspca/gl860/gl860-mi1320.c ./linux/drivers/media/video/gspca/gl860/gl860-mi1320.c
--- ../o/linux/drivers/media/video/gspca/gl860/gl860-mi1320.c	2010-02-18
19:02:51.000000000 +0100
+++ ./linux/drivers/media/video/gspca/gl860/gl860-mi1320.c	2010-02-28
15:01:20.000000000 +0100
@@ -206,6 +206,7 @@ void mi1320_init_settings(struct gspca_d
 	sd->vmax.hue        =  5 + 1;
 	sd->vmax.saturation =  8;
 	sd->vmax.whitebal   =  2;
+	sd->vmax.lightsource = 0;
 	sd->vmax.mirror     = 1;
 	sd->vmax.flip       = 1;
 	sd->vmax.AC50Hz     = 1;
diff
-rupN ../o/linux/drivers/media/video/gspca/gl860/gl860-mi2020.c ./linux/drivers/media/video/gspca/gl860/gl860-mi2020.c
--- ../o/linux/drivers/media/video/gspca/gl860/gl860-mi2020.c	2010-02-18
19:02:51.000000000 +0100
+++ ./linux/drivers/media/video/gspca/gl860/gl860-mi2020.c	2010-02-28
15:09:46.000000000 +0100
@@ -361,9 +361,10 @@ void mi2020_init_settings(struct gspca_d
 	sd->vmax.sharpness  =  40;
 	sd->vmax.contrast   =   3;
 	sd->vmax.gamma      =   2;
-	sd->vmax.hue        =   0 + 1; /* 200 */
-	sd->vmax.saturation =   0;     /* 100 */
-	sd->vmax.whitebal   =   0;     /* 100 */
+	sd->vmax.hue        =   0 + 1; /* 200, not done by hardware */
+	sd->vmax.saturation =   0;     /* 100, not done by hardware */
+	sd->vmax.whitebal   =   0;     /* 100, not done by hardware */
+	sd->vmax.lightsource =  0;
 	sd->vmax.mirror = 1;
 	sd->vmax.flip   = 1;
 	sd->vmax.AC50Hz = 1;
diff
-rupN ../o/linux/drivers/media/video/gspca/gl860/gl860-ov2640.c ./linux/drivers/media/video/gspca/gl860/gl860-ov2640.c
--- ../o/linux/drivers/media/video/gspca/gl860/gl860-ov2640.c	2010-02-18
19:02:51.000000000 +0100
+++ ./linux/drivers/media/video/gspca/gl860/gl860-ov2640.c	2010-02-28
15:01:20.000000000 +0100
@@ -203,6 +203,7 @@ void ov2640_init_settings(struct gspca_d
 	sd->vmax.hue        = 254 + 2;
 	sd->vmax.saturation = 255;
 	sd->vmax.whitebal   = 128;
+	sd->vmax.lightsource =  0;
 	sd->vmax.mirror     = 1;
 	sd->vmax.flip       = 1;
 	sd->vmax.AC50Hz     = 0;
diff
-rupN ../o/linux/drivers/media/video/gspca/gl860/gl860-ov9655.c ./linux/drivers/media/video/gspca/gl860/gl860-ov9655.c
--- ../o/linux/drivers/media/video/gspca/gl860/gl860-ov9655.c	2010-02-18
19:02:51.000000000 +0100
+++ ./linux/drivers/media/video/gspca/gl860/gl860-ov9655.c	2010-02-28
15:01:20.000000000 +0100
@@ -69,7 +69,7 @@ static u8 *tbl_640[] = {
 	"\xd0\x01\xd1\x08\xd2\xe0\xd3\x01" "\xd4\x10\xd5\x80"
 };
 
-static u8 *tbl_800[] = {
+static u8 *tbl_1280[] = {
 	"\x00\x40\x07\x6a\x06\xf3\x0d\x6a" "\x10\x10\xc1\x01"
 	,
 	"\x12\x80\x00\x00\x01\x98\x02\x80" "\x03\x12\x04\x01\x0b\x57\x0e\x61"
@@ -171,6 +171,7 @@ void ov9655_init_settings(struct gspca_d
 	sd->vmax.hue        =   0 + 1;
 	sd->vmax.saturation =   0;
 	sd->vmax.whitebal   =   0;
+	sd->vmax.lightsource =  0;
 	sd->vmax.mirror     = 0;
 	sd->vmax.flip       = 0;
 	sd->vmax.AC50Hz     = 0;
@@ -217,7 +218,7 @@ static int ov9655_init_post_alt(struct g
 
 	ctrl_out(gspca_dev, 0x40, 5, 0x0001, 0x0000, 0, NULL);
 
-	tbl = (reso == IMAGE_640) ? tbl_640 : tbl_800;
+	tbl = (reso == IMAGE_640) ? tbl_640 : tbl_1280;
 
 	ctrl_out(gspca_dev, 0x40, 3, 0x0000, 0x0200,
 			tbl_length[0], tbl[0]);


