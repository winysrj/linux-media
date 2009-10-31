Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail02a.mail.t-online.hu ([84.2.40.7]:65512 "EHLO
	mail02a.mail.t-online.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933381AbZJaXQU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 31 Oct 2009 19:16:20 -0400
Message-ID: <4AECC543.3020106@freemail.hu>
Date: Sun, 01 Nov 2009 00:16:19 +0100
From: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
MIME-Version: 1.0
To: Jean-Francois Moine <moinejf@free.fr>,
	Hans de Goede <hdegoede@redhat.com>,
	V4L Mailing List <linux-media@vger.kernel.org>
CC: Thomas Kaiser <thomas@kaiser-linux.li>,
	Theodore Kilgore <kilgota@auburn.edu>,
	Kyle Guinn <elyk03@gmail.com>
Subject: [PATCH 16/21] gspca pac7302/pac7311: separate private sd
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Márton Németh <nm127@freemail.hu>

Separate the private struct sd where the sensor specific data is stored.
The sensor field is no longer needed because we use separate functions.
Brightness and color fields are not used in pac7311, so removed.

Signed-off-by: Márton Németh <nm127@freemail.hu>
Cc: Thomas Kaiser <thomas@kaiser-linux.li>
Cc: Theodore Kilgore <kilgota@auburn.edu>
Cc: Kyle Guinn <elyk03@gmail.com>
---
diff -uprN p/drivers/media/video/gspca/pac7311.c q/drivers/media/video/gspca/pac7311.c
--- p/drivers/media/video/gspca/pac7311.c	2009-10-31 08:22:45.000000000 +0100
+++ q/drivers/media/video/gspca/pac7311.c	2009-10-31 08:26:17.000000000 +0100
@@ -57,8 +57,8 @@ MODULE_AUTHOR("Thomas Kaiser thomas@kais
 MODULE_DESCRIPTION("Pixart PAC7311");
 MODULE_LICENSE("GPL");

-/* specific webcam descriptor */
-struct sd {
+/* specific webcam descriptor for pac7302 */
+struct pac7302_sd {
 	struct gspca_dev gspca_dev;		/* !! must be the first item */

 	unsigned char brightness;
@@ -70,7 +70,26 @@ struct sd {
 	__u8 hflip;
 	__u8 vflip;

-	__u8 sensor;
+#define SENSOR_PAC7302 0
+#define SENSOR_PAC7311 1
+
+	u8 sof_read;
+	u8 autogain_ignore_frames;
+
+	atomic_t avg_lum;
+};
+
+/* specific webcam descriptor for pac7311 */
+struct pac7311_sd {
+	struct gspca_dev gspca_dev;		/* !! must be the first item */
+
+	unsigned char contrast;
+	unsigned char gain;
+	unsigned char exposure;
+	unsigned char autogain;
+	__u8 hflip;
+	__u8 vflip;
+
 #define SENSOR_PAC7302 0
 #define SENSOR_PAC7311 1

@@ -617,12 +636,11 @@ static void reg_w_var(struct gspca_dev *
 static int pac7302_sd_config(struct gspca_dev *gspca_dev,
 			const struct usb_device_id *id)
 {
-	struct sd *sd = (struct sd *) gspca_dev;
+	struct pac7302_sd *sd = (struct pac7302_sd *) gspca_dev;
 	struct cam *cam;

 	cam = &gspca_dev->cam;

-	sd->sensor = id->driver_info;
 	PDEBUG(D_CONF, "Find Sensor PAC7302");
 	cam->cam_mode = &vga_mode[2];	/* only 640x480 */
 	cam->nmodes = 1;
@@ -642,19 +660,16 @@ static int pac7302_sd_config(struct gspc
 static int pac7311_sd_config(struct gspca_dev *gspca_dev,
 			const struct usb_device_id *id)
 {
-	struct sd *sd = (struct sd *) gspca_dev;
+	struct pac7311_sd *sd = (struct pac7311_sd *) gspca_dev;
 	struct cam *cam;

 	cam = &gspca_dev->cam;

-	sd->sensor = id->driver_info;
 	PDEBUG(D_CONF, "Find Sensor PAC7311");
 	cam->cam_mode = vga_mode;
 	cam->nmodes = ARRAY_SIZE(vga_mode);

-	sd->brightness = BRIGHTNESS_DEF;
 	sd->contrast = CONTRAST_DEF;
-	sd->colors = COLOR_DEF;
 	sd->gain = GAIN_DEF;
 	sd->exposure = EXPOSURE_DEF;
 	sd->autogain = AUTOGAIN_DEF;
@@ -666,7 +681,7 @@ static int pac7311_sd_config(struct gspc
 /* This function is used by pac7302 only */
 static void pac7302_setbrightcont(struct gspca_dev *gspca_dev)
 {
-	struct sd *sd = (struct sd *) gspca_dev;
+	struct pac7302_sd *sd = (struct pac7302_sd *) gspca_dev;
 	int i, v;
 	static const __u8 max[10] =
 		{0x29, 0x33, 0x42, 0x5a, 0x6e, 0x80, 0x9f, 0xbb,
@@ -693,7 +708,7 @@ static void pac7302_setbrightcont(struct
 /* This function is used by pac7311 only */
 static void pac7311_setcontrast(struct gspca_dev *gspca_dev)
 {
-	struct sd *sd = (struct sd *) gspca_dev;
+	struct pac7311_sd *sd = (struct pac7311_sd *) gspca_dev;

 	reg_w(gspca_dev, 0xff, 0x04);
 	reg_w(gspca_dev, 0x10, sd->contrast >> 4);
@@ -704,7 +719,7 @@ static void pac7311_setcontrast(struct g
 /* This function is used by pac7302 only */
 static void pac7302_setcolors(struct gspca_dev *gspca_dev)
 {
-	struct sd *sd = (struct sd *) gspca_dev;
+	struct pac7302_sd *sd = (struct pac7302_sd *) gspca_dev;
 	int i, v;
 	static const int a[9] =
 		{217, -212, 0, -101, 170, -67, -38, -315, 355};
@@ -725,7 +740,7 @@ static void pac7302_setcolors(struct gsp

 static void pac7302_setgain(struct gspca_dev *gspca_dev)
 {
-	struct sd *sd = (struct sd *) gspca_dev;
+	struct pac7302_sd *sd = (struct pac7302_sd *) gspca_dev;

 	reg_w(gspca_dev, 0xff, 0x03);		/* page 3 */
 	reg_w(gspca_dev, 0x10, sd->gain >> 3);
@@ -736,7 +751,7 @@ static void pac7302_setgain(struct gspca

 static void pac7311_setgain(struct gspca_dev *gspca_dev)
 {
-	struct sd *sd = (struct sd *) gspca_dev;
+	struct pac7311_sd *sd = (struct pac7311_sd *) gspca_dev;
 	int gain = GAIN_MAX - sd->gain;

 	if (gain < 1)
@@ -753,7 +768,7 @@ static void pac7311_setgain(struct gspca

 static void pac7302_setexposure(struct gspca_dev *gspca_dev)
 {
-	struct sd *sd = (struct sd *) gspca_dev;
+	struct pac7302_sd *sd = (struct pac7302_sd *) gspca_dev;
 	__u8 reg;

 	/* register 2 of frame 3/4 contains the clock divider configuring the
@@ -778,7 +793,7 @@ static void pac7302_setexposure(struct g

 static void pac7311_setexposure(struct gspca_dev *gspca_dev)
 {
-	struct sd *sd = (struct sd *) gspca_dev;
+	struct pac7311_sd *sd = (struct pac7311_sd *) gspca_dev;
 	__u8 reg;

 	/* register 2 of frame 3/4 contains the clock divider configuring the
@@ -807,7 +822,7 @@ static void pac7311_setexposure(struct g

 static void pac7302_sethvflip(struct gspca_dev *gspca_dev)
 {
-	struct sd *sd = (struct sd *) gspca_dev;
+	struct pac7302_sd *sd = (struct pac7302_sd *) gspca_dev;
 	__u8 data;

 	reg_w(gspca_dev, 0xff, 0x03);		/* page 3 */
@@ -819,7 +834,7 @@ static void pac7302_sethvflip(struct gsp

 static void pac7311_sethvflip(struct gspca_dev *gspca_dev)
 {
-	struct sd *sd = (struct sd *) gspca_dev;
+	struct pac7311_sd *sd = (struct pac7311_sd *) gspca_dev;
 	__u8 data;

 	reg_w(gspca_dev, 0xff, 0x04);		/* page 4 */
@@ -847,7 +862,7 @@ static int pac7311_sd_init(struct gspca_

 static int pac7302_sd_start(struct gspca_dev *gspca_dev)
 {
-	struct sd *sd = (struct sd *) gspca_dev;
+	struct pac7302_sd *sd = (struct pac7302_sd *) gspca_dev;

 	sd->sof_read = 0;

@@ -873,7 +888,7 @@ static int pac7302_sd_start(struct gspca

 static int pac7311_sd_start(struct gspca_dev *gspca_dev)
 {
-	struct sd *sd = (struct sd *) gspca_dev;
+	struct pac7311_sd *sd = (struct pac7311_sd *) gspca_dev;

 	sd->sof_read = 0;

@@ -953,7 +968,7 @@ static void pac7311_sd_stop0(struct gspc

 static void pac7302_do_autogain(struct gspca_dev *gspca_dev)
 {
-	struct sd *sd = (struct sd *) gspca_dev;
+	struct pac7302_sd *sd = (struct pac7302_sd *) gspca_dev;
 	int avg_lum = atomic_read(&sd->avg_lum);
 	int desired_lum, deadzone;

@@ -981,7 +996,7 @@ static void pac7302_do_autogain(struct g

 static void pac7311_do_autogain(struct gspca_dev *gspca_dev)
 {
-	struct sd *sd = (struct sd *) gspca_dev;
+	struct pac7311_sd *sd = (struct pac7311_sd *) gspca_dev;
 	int avg_lum = atomic_read(&sd->avg_lum);
 	int desired_lum, deadzone;

@@ -1032,7 +1047,7 @@ static void pac7302_sd_pkt_scan(struct g
 			__u8 *data,			/* isoc packet */
 			int len)			/* iso packet length */
 {
-	struct sd *sd = (struct sd *) gspca_dev;
+	struct pac7302_sd *sd = (struct pac7302_sd *) gspca_dev;
 	unsigned char *sof;

 	sof = pac_find_sof(&sd->sof_read, data, len);
@@ -1096,7 +1111,7 @@ static void pac7311_sd_pkt_scan(struct g
 			__u8 *data,			/* isoc packet */
 			int len)			/* iso packet length */
 {
-	struct sd *sd = (struct sd *) gspca_dev;
+	struct pac7311_sd *sd = (struct pac7311_sd *) gspca_dev;
 	unsigned char *sof;

 	sof = pac_find_sof(&sd->sof_read, data, len);
@@ -1155,7 +1170,7 @@ static void pac7311_sd_pkt_scan(struct g

 static int pac7302_sd_setbrightness(struct gspca_dev *gspca_dev, __s32 val)
 {
-	struct sd *sd = (struct sd *) gspca_dev;
+	struct pac7302_sd *sd = (struct pac7302_sd *) gspca_dev;

 	sd->brightness = val;
 	if (gspca_dev->streaming)
@@ -1165,7 +1180,7 @@ static int pac7302_sd_setbrightness(stru

 static int pac7302_sd_getbrightness(struct gspca_dev *gspca_dev, __s32 *val)
 {
-	struct sd *sd = (struct sd *) gspca_dev;
+	struct pac7302_sd *sd = (struct pac7302_sd *) gspca_dev;

 	*val = sd->brightness;
 	return 0;
@@ -1173,7 +1188,7 @@ static int pac7302_sd_getbrightness(stru

 static int pac7302_sd_setcontrast(struct gspca_dev *gspca_dev, __s32 val)
 {
-	struct sd *sd = (struct sd *) gspca_dev;
+	struct pac7302_sd *sd = (struct pac7302_sd *) gspca_dev;

 	sd->contrast = val;
 	if (gspca_dev->streaming) {
@@ -1184,7 +1199,7 @@ static int pac7302_sd_setcontrast(struct

 static int pac7311_sd_setcontrast(struct gspca_dev *gspca_dev, __s32 val)
 {
-	struct sd *sd = (struct sd *) gspca_dev;
+	struct pac7311_sd *sd = (struct pac7311_sd *) gspca_dev;

 	sd->contrast = val;
 	if (gspca_dev->streaming) {
@@ -1195,7 +1210,7 @@ static int pac7311_sd_setcontrast(struct

 static int pac7302_sd_getcontrast(struct gspca_dev *gspca_dev, __s32 *val)
 {
-	struct sd *sd = (struct sd *) gspca_dev;
+	struct pac7302_sd *sd = (struct pac7302_sd *) gspca_dev;

 	*val = sd->contrast;
 	return 0;
@@ -1203,7 +1218,7 @@ static int pac7302_sd_getcontrast(struct

 static int pac7311_sd_getcontrast(struct gspca_dev *gspca_dev, __s32 *val)
 {
-	struct sd *sd = (struct sd *) gspca_dev;
+	struct pac7311_sd *sd = (struct pac7311_sd *) gspca_dev;

 	*val = sd->contrast;
 	return 0;
@@ -1211,7 +1226,7 @@ static int pac7311_sd_getcontrast(struct

 static int pac7302_sd_setcolors(struct gspca_dev *gspca_dev, __s32 val)
 {
-	struct sd *sd = (struct sd *) gspca_dev;
+	struct pac7302_sd *sd = (struct pac7302_sd *) gspca_dev;

 	sd->colors = val;
 	if (gspca_dev->streaming)
@@ -1221,7 +1236,7 @@ static int pac7302_sd_setcolors(struct g

 static int pac7302_sd_getcolors(struct gspca_dev *gspca_dev, __s32 *val)
 {
-	struct sd *sd = (struct sd *) gspca_dev;
+	struct pac7302_sd *sd = (struct pac7302_sd *) gspca_dev;

 	*val = sd->colors;
 	return 0;
@@ -1229,7 +1244,7 @@ static int pac7302_sd_getcolors(struct g

 static int pac7302_sd_setgain(struct gspca_dev *gspca_dev, __s32 val)
 {
-	struct sd *sd = (struct sd *) gspca_dev;
+	struct pac7302_sd *sd = (struct pac7302_sd *) gspca_dev;

 	sd->gain = val;
 	if (gspca_dev->streaming)
@@ -1239,7 +1254,7 @@ static int pac7302_sd_setgain(struct gsp

 static int pac7311_sd_setgain(struct gspca_dev *gspca_dev, __s32 val)
 {
-	struct sd *sd = (struct sd *) gspca_dev;
+	struct pac7311_sd *sd = (struct pac7311_sd *) gspca_dev;

 	sd->gain = val;
 	if (gspca_dev->streaming)
@@ -1249,7 +1264,7 @@ static int pac7311_sd_setgain(struct gsp

 static int pac7302_sd_getgain(struct gspca_dev *gspca_dev, __s32 *val)
 {
-	struct sd *sd = (struct sd *) gspca_dev;
+	struct pac7302_sd *sd = (struct pac7302_sd *) gspca_dev;

 	*val = sd->gain;
 	return 0;
@@ -1257,7 +1272,7 @@ static int pac7302_sd_getgain(struct gsp

 static int pac7311_sd_getgain(struct gspca_dev *gspca_dev, __s32 *val)
 {
-	struct sd *sd = (struct sd *) gspca_dev;
+	struct pac7311_sd *sd = (struct pac7311_sd *) gspca_dev;

 	*val = sd->gain;
 	return 0;
@@ -1265,7 +1280,7 @@ static int pac7311_sd_getgain(struct gsp

 static int pac7302_sd_setexposure(struct gspca_dev *gspca_dev, __s32 val)
 {
-	struct sd *sd = (struct sd *) gspca_dev;
+	struct pac7302_sd *sd = (struct pac7302_sd *) gspca_dev;

 	sd->exposure = val;
 	if (gspca_dev->streaming)
@@ -1275,7 +1290,7 @@ static int pac7302_sd_setexposure(struct

 static int pac7311_sd_setexposure(struct gspca_dev *gspca_dev, __s32 val)
 {
-	struct sd *sd = (struct sd *) gspca_dev;
+	struct pac7311_sd *sd = (struct pac7311_sd *) gspca_dev;

 	sd->exposure = val;
 	if (gspca_dev->streaming)
@@ -1285,7 +1300,7 @@ static int pac7311_sd_setexposure(struct

 static int pac7302_sd_getexposure(struct gspca_dev *gspca_dev, __s32 *val)
 {
-	struct sd *sd = (struct sd *) gspca_dev;
+	struct pac7302_sd *sd = (struct pac7302_sd *) gspca_dev;

 	*val = sd->exposure;
 	return 0;
@@ -1293,7 +1308,7 @@ static int pac7302_sd_getexposure(struct

 static int pac7311_sd_getexposure(struct gspca_dev *gspca_dev, __s32 *val)
 {
-	struct sd *sd = (struct sd *) gspca_dev;
+	struct pac7311_sd *sd = (struct pac7311_sd *) gspca_dev;

 	*val = sd->exposure;
 	return 0;
@@ -1301,7 +1316,7 @@ static int pac7311_sd_getexposure(struct

 static int pac7302_sd_setautogain(struct gspca_dev *gspca_dev, __s32 val)
 {
-	struct sd *sd = (struct sd *) gspca_dev;
+	struct pac7302_sd *sd = (struct pac7302_sd *) gspca_dev;

 	sd->autogain = val;
 	/* when switching to autogain set defaults to make sure
@@ -1324,7 +1339,7 @@ static int pac7302_sd_setautogain(struct

 static int pac7311_sd_setautogain(struct gspca_dev *gspca_dev, __s32 val)
 {
-	struct sd *sd = (struct sd *) gspca_dev;
+	struct pac7311_sd *sd = (struct pac7311_sd *) gspca_dev;

 	sd->autogain = val;
 	/* when switching to autogain set defaults to make sure
@@ -1347,7 +1362,7 @@ static int pac7311_sd_setautogain(struct

 static int pac7302_sd_getautogain(struct gspca_dev *gspca_dev, __s32 *val)
 {
-	struct sd *sd = (struct sd *) gspca_dev;
+	struct pac7302_sd *sd = (struct pac7302_sd *) gspca_dev;

 	*val = sd->autogain;
 	return 0;
@@ -1355,7 +1370,7 @@ static int pac7302_sd_getautogain(struct

 static int pac7311_sd_getautogain(struct gspca_dev *gspca_dev, __s32 *val)
 {
-	struct sd *sd = (struct sd *) gspca_dev;
+	struct pac7311_sd *sd = (struct pac7311_sd *) gspca_dev;

 	*val = sd->autogain;
 	return 0;
@@ -1363,7 +1378,7 @@ static int pac7311_sd_getautogain(struct

 static int pac7302_sd_sethflip(struct gspca_dev *gspca_dev, __s32 val)
 {
-	struct sd *sd = (struct sd *) gspca_dev;
+	struct pac7302_sd *sd = (struct pac7302_sd *) gspca_dev;

 	sd->hflip = val;
 	if (gspca_dev->streaming)
@@ -1373,7 +1388,7 @@ static int pac7302_sd_sethflip(struct gs

 static int pac7311_sd_sethflip(struct gspca_dev *gspca_dev, __s32 val)
 {
-	struct sd *sd = (struct sd *) gspca_dev;
+	struct pac7311_sd *sd = (struct pac7311_sd *) gspca_dev;

 	sd->hflip = val;
 	if (gspca_dev->streaming)
@@ -1383,7 +1398,7 @@ static int pac7311_sd_sethflip(struct gs

 static int pac7302_sd_gethflip(struct gspca_dev *gspca_dev, __s32 *val)
 {
-	struct sd *sd = (struct sd *) gspca_dev;
+	struct pac7302_sd *sd = (struct pac7302_sd *) gspca_dev;

 	*val = sd->hflip;
 	return 0;
@@ -1391,7 +1406,7 @@ static int pac7302_sd_gethflip(struct gs

 static int pac7311_sd_gethflip(struct gspca_dev *gspca_dev, __s32 *val)
 {
-	struct sd *sd = (struct sd *) gspca_dev;
+	struct pac7311_sd *sd = (struct pac7311_sd *) gspca_dev;

 	*val = sd->hflip;
 	return 0;
@@ -1399,7 +1414,7 @@ static int pac7311_sd_gethflip(struct gs

 static int pac7302_sd_setvflip(struct gspca_dev *gspca_dev, __s32 val)
 {
-	struct sd *sd = (struct sd *) gspca_dev;
+	struct pac7302_sd *sd = (struct pac7302_sd *) gspca_dev;

 	sd->vflip = val;
 	if (gspca_dev->streaming)
@@ -1409,7 +1424,7 @@ static int pac7302_sd_setvflip(struct gs

 static int pac7311_sd_setvflip(struct gspca_dev *gspca_dev, __s32 val)
 {
-	struct sd *sd = (struct sd *) gspca_dev;
+	struct pac7311_sd *sd = (struct pac7311_sd *) gspca_dev;

 	sd->vflip = val;
 	if (gspca_dev->streaming)
@@ -1419,7 +1434,7 @@ static int pac7311_sd_setvflip(struct gs

 static int pac7302_sd_getvflip(struct gspca_dev *gspca_dev, __s32 *val)
 {
-	struct sd *sd = (struct sd *) gspca_dev;
+	struct pac7302_sd *sd = (struct pac7302_sd *) gspca_dev;

 	*val = sd->vflip;
 	return 0;
@@ -1427,7 +1442,7 @@ static int pac7302_sd_getvflip(struct gs

 static int pac7311_sd_getvflip(struct gspca_dev *gspca_dev, __s32 *val)
 {
-	struct sd *sd = (struct sd *) gspca_dev;
+	struct pac7311_sd *sd = (struct pac7311_sd *) gspca_dev;

 	*val = sd->vflip;
 	return 0;
@@ -1488,10 +1503,10 @@ static int sd_probe(struct usb_interface
 {
 	if (id->driver_info == SENSOR_PAC7302)
 		return gspca_dev_probe(intf, id, &pac7302_sd_desc,
-				sizeof(struct sd), THIS_MODULE);
+				sizeof(struct pac7302_sd), THIS_MODULE);
 	else
 		return gspca_dev_probe(intf, id, &pac7311_sd_desc,
-				sizeof(struct sd), THIS_MODULE);
+				sizeof(struct pac7311_sd), THIS_MODULE);
 }

 static struct usb_driver sd_driver = {
