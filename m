Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail02d.mail.t-online.hu ([84.2.42.7]:61905 "EHLO
	mail02d.mail.t-online.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751328AbZKAGRN (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 1 Nov 2009 01:17:13 -0500
Message-ID: <4AED27E7.5020706@freemail.hu>
Date: Sun, 01 Nov 2009 07:17:11 +0100
From: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
MIME-Version: 1.0
To: Jean-Francois Moine <moinejf@free.fr>,
	Hans de Goede <hdegoede@redhat.com>,
	V4L Mailing List <linux-media@vger.kernel.org>
CC: Thomas Kaiser <thomas@kaiser-linux.li>,
	Theodore Kilgore <kilgota@auburn.edu>,
	Kyle Guinn <elyk03@gmail.com>
Subject: Re: [PATCH 21/21] gspca pac7302/pac7311: remove prefixes
References: <4AECC590.4090607@freemail.hu>
In-Reply-To: <4AECC590.4090607@freemail.hu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Márton Németh <nm127@freemail.hu>

The pac7302_ and pac7311_ prefixes are no longer needed as these
functions are in separated files. The sensor information can also
be removed from the USB tables.

Signed-off-by: Márton Németh <nm127@freemail.hu>
Cc: Thomas Kaiser <thomas@kaiser-linux.li>
Cc: Theodore Kilgore <kilgota@auburn.edu>
Cc: Kyle Guinn <elyk03@gmail.com>
---
Patch rebased to the latest http://linuxtv.org/hg/v4l-dvb/ (rev 13254).
---
diff -uprN u/drivers/media/video/gspca/pac7302.c v/drivers/media/video/gspca/pac7302.c
--- u/drivers/media/video/gspca/pac7302.c	2009-11-01 07:00:04.000000000 +0100
+++ v/drivers/media/video/gspca/pac7302.c	2009-11-01 07:03:06.000000000 +0100
@@ -60,7 +60,7 @@ MODULE_DESCRIPTION("Pixart PAC7302");
 MODULE_LICENSE("GPL");

 /* specific webcam descriptor for pac7302 */
-struct pac7302_sd {
+struct sd {
 	struct gspca_dev gspca_dev;		/* !! must be the first item */

 	unsigned char brightness;
@@ -72,8 +72,6 @@ struct pac7302_sd {
 	__u8 hflip;
 	__u8 vflip;

-#define SENSOR_PAC7302 0
-
 	u8 sof_read;
 	u8 autogain_ignore_frames;

@@ -81,24 +79,24 @@ struct pac7302_sd {
 };

 /* V4L2 controls supported by the driver */
-static int pac7302_sd_setbrightness(struct gspca_dev *gspca_dev, __s32 val);
-static int pac7302_sd_getbrightness(struct gspca_dev *gspca_dev, __s32 *val);
-static int pac7302_sd_setcontrast(struct gspca_dev *gspca_dev, __s32 val);
-static int pac7302_sd_getcontrast(struct gspca_dev *gspca_dev, __s32 *val);
-static int pac7302_sd_setcolors(struct gspca_dev *gspca_dev, __s32 val);
-static int pac7302_sd_getcolors(struct gspca_dev *gspca_dev, __s32 *val);
-static int pac7302_sd_setautogain(struct gspca_dev *gspca_dev, __s32 val);
-static int pac7302_sd_getautogain(struct gspca_dev *gspca_dev, __s32 *val);
-static int pac7302_sd_sethflip(struct gspca_dev *gspca_dev, __s32 val);
-static int pac7302_sd_gethflip(struct gspca_dev *gspca_dev, __s32 *val);
-static int pac7302_sd_setvflip(struct gspca_dev *gspca_dev, __s32 val);
-static int pac7302_sd_getvflip(struct gspca_dev *gspca_dev, __s32 *val);
-static int pac7302_sd_setgain(struct gspca_dev *gspca_dev, __s32 val);
-static int pac7302_sd_getgain(struct gspca_dev *gspca_dev, __s32 *val);
-static int pac7302_sd_setexposure(struct gspca_dev *gspca_dev, __s32 val);
-static int pac7302_sd_getexposure(struct gspca_dev *gspca_dev, __s32 *val);
+static int sd_setbrightness(struct gspca_dev *gspca_dev, __s32 val);
+static int sd_getbrightness(struct gspca_dev *gspca_dev, __s32 *val);
+static int sd_setcontrast(struct gspca_dev *gspca_dev, __s32 val);
+static int sd_getcontrast(struct gspca_dev *gspca_dev, __s32 *val);
+static int sd_setcolors(struct gspca_dev *gspca_dev, __s32 val);
+static int sd_getcolors(struct gspca_dev *gspca_dev, __s32 *val);
+static int sd_setautogain(struct gspca_dev *gspca_dev, __s32 val);
+static int sd_getautogain(struct gspca_dev *gspca_dev, __s32 *val);
+static int sd_sethflip(struct gspca_dev *gspca_dev, __s32 val);
+static int sd_gethflip(struct gspca_dev *gspca_dev, __s32 *val);
+static int sd_setvflip(struct gspca_dev *gspca_dev, __s32 val);
+static int sd_getvflip(struct gspca_dev *gspca_dev, __s32 *val);
+static int sd_setgain(struct gspca_dev *gspca_dev, __s32 val);
+static int sd_getgain(struct gspca_dev *gspca_dev, __s32 *val);
+static int sd_setexposure(struct gspca_dev *gspca_dev, __s32 val);
+static int sd_getexposure(struct gspca_dev *gspca_dev, __s32 *val);

-static struct ctrl pac7302_sd_ctrls[] = {
+static struct ctrl sd_ctrls[] = {
 /* This control is pac7302 only */
 	{
 	    {
@@ -112,8 +110,8 @@ static struct ctrl pac7302_sd_ctrls[] =
 #define BRIGHTNESS_DEF 0x10
 		.default_value = BRIGHTNESS_DEF,
 	    },
-	    .set = pac7302_sd_setbrightness,
-	    .get = pac7302_sd_getbrightness,
+	    .set = sd_setbrightness,
+	    .get = sd_getbrightness,
 	},
 /* This control is for both the 7302 and the 7311 */
 	{
@@ -128,8 +126,8 @@ static struct ctrl pac7302_sd_ctrls[] =
 #define CONTRAST_DEF 127
 		.default_value = CONTRAST_DEF,
 	    },
-	    .set = pac7302_sd_setcontrast,
-	    .get = pac7302_sd_getcontrast,
+	    .set = sd_setcontrast,
+	    .get = sd_getcontrast,
 	},
 /* This control is pac7302 only */
 	{
@@ -144,8 +142,8 @@ static struct ctrl pac7302_sd_ctrls[] =
 #define COLOR_DEF 127
 		.default_value = COLOR_DEF,
 	    },
-	    .set = pac7302_sd_setcolors,
-	    .get = pac7302_sd_getcolors,
+	    .set = sd_setcolors,
+	    .get = sd_getcolors,
 	},
 /* All controls below are for both the 7302 and the 7311 */
 	{
@@ -161,8 +159,8 @@ static struct ctrl pac7302_sd_ctrls[] =
 #define GAIN_KNEE 255 /* Gain seems to cause little noise on the pac73xx */
 		.default_value = GAIN_DEF,
 	    },
-	    .set = pac7302_sd_setgain,
-	    .get = pac7302_sd_getgain,
+	    .set = sd_setgain,
+	    .get = sd_getgain,
 	},
 	{
 	    {
@@ -177,8 +175,8 @@ static struct ctrl pac7302_sd_ctrls[] =
 #define EXPOSURE_KNEE 50 /* 100 ms / 10 fps */
 		.default_value = EXPOSURE_DEF,
 	    },
-	    .set = pac7302_sd_setexposure,
-	    .get = pac7302_sd_getexposure,
+	    .set = sd_setexposure,
+	    .get = sd_getexposure,
 	},
 	{
 	    {
@@ -191,8 +189,8 @@ static struct ctrl pac7302_sd_ctrls[] =
 #define AUTOGAIN_DEF 1
 		.default_value = AUTOGAIN_DEF,
 	    },
-	    .set = pac7302_sd_setautogain,
-	    .get = pac7302_sd_getautogain,
+	    .set = sd_setautogain,
+	    .get = sd_getautogain,
 	},
 	{
 	    {
@@ -205,8 +203,8 @@ static struct ctrl pac7302_sd_ctrls[] =
 #define HFLIP_DEF 0
 		.default_value = HFLIP_DEF,
 	    },
-	    .set = pac7302_sd_sethflip,
-	    .get = pac7302_sd_gethflip,
+	    .set = sd_sethflip,
+	    .get = sd_gethflip,
 	},
 	{
 	    {
@@ -219,12 +217,12 @@ static struct ctrl pac7302_sd_ctrls[] =
 #define VFLIP_DEF 0
 		.default_value = VFLIP_DEF,
 	    },
-	    .set = pac7302_sd_setvflip,
-	    .get = pac7302_sd_getvflip,
+	    .set = sd_setvflip,
+	    .get = sd_getvflip,
 	},
 };

-static const struct v4l2_pix_format pac7302_vga_mode[] = {
+static const struct v4l2_pix_format vga_mode[] = {
 	{640, 480, V4L2_PIX_FMT_PJPG, V4L2_FIELD_NONE,
 		.bytesperline = 640,
 		.sizeimage = 640 * 480 * 3 / 8 + 590,
@@ -446,17 +444,17 @@ static void reg_w_var(struct gspca_dev *
 }

 /* this function is called at probe time for pac7302 */
-static int pac7302_sd_config(struct gspca_dev *gspca_dev,
+static int sd_config(struct gspca_dev *gspca_dev,
 			const struct usb_device_id *id)
 {
-	struct pac7302_sd *sd = (struct pac7302_sd *) gspca_dev;
+	struct sd *sd = (struct sd *) gspca_dev;
 	struct cam *cam;

 	cam = &gspca_dev->cam;

 	PDEBUG(D_CONF, "Find Sensor PAC7302");
-	cam->cam_mode = pac7302_vga_mode;	/* only 640x480 */
-	cam->nmodes = ARRAY_SIZE(pac7302_vga_mode);
+	cam->cam_mode = vga_mode;	/* only 640x480 */
+	cam->nmodes = ARRAY_SIZE(vga_mode);

 	sd->brightness = BRIGHTNESS_DEF;
 	sd->contrast = CONTRAST_DEF;
@@ -470,9 +468,9 @@ static int pac7302_sd_config(struct gspc
 }

 /* This function is used by pac7302 only */
-static void pac7302_setbrightcont(struct gspca_dev *gspca_dev)
+static void setbrightcont(struct gspca_dev *gspca_dev)
 {
-	struct pac7302_sd *sd = (struct pac7302_sd *) gspca_dev;
+	struct sd *sd = (struct sd *) gspca_dev;
 	int i, v;
 	static const __u8 max[10] =
 		{0x29, 0x33, 0x42, 0x5a, 0x6e, 0x80, 0x9f, 0xbb,
@@ -497,9 +495,9 @@ static void pac7302_setbrightcont(struct
 }

 /* This function is used by pac7302 only */
-static void pac7302_setcolors(struct gspca_dev *gspca_dev)
+static void setcolors(struct gspca_dev *gspca_dev)
 {
-	struct pac7302_sd *sd = (struct pac7302_sd *) gspca_dev;
+	struct sd *sd = (struct sd *) gspca_dev;
 	int i, v;
 	static const int a[9] =
 		{217, -212, 0, -101, 170, -67, -38, -315, 355};
@@ -518,9 +516,9 @@ static void pac7302_setcolors(struct gsp
 	PDEBUG(D_CONF|D_STREAM, "color: %i", sd->colors);
 }

-static void pac7302_setgain(struct gspca_dev *gspca_dev)
+static void setgain(struct gspca_dev *gspca_dev)
 {
-	struct pac7302_sd *sd = (struct pac7302_sd *) gspca_dev;
+	struct sd *sd = (struct sd *) gspca_dev;

 	reg_w(gspca_dev, 0xff, 0x03);		/* page 3 */
 	reg_w(gspca_dev, 0x10, sd->gain >> 3);
@@ -529,9 +527,9 @@ static void pac7302_setgain(struct gspca
 	reg_w(gspca_dev, 0x11, 0x01);
 }

-static void pac7302_setexposure(struct gspca_dev *gspca_dev)
+static void setexposure(struct gspca_dev *gspca_dev)
 {
-	struct pac7302_sd *sd = (struct pac7302_sd *) gspca_dev;
+	struct sd *sd = (struct sd *) gspca_dev;
 	__u8 reg;

 	/* register 2 of frame 3/4 contains the clock divider configuring the
@@ -554,9 +552,9 @@ static void pac7302_setexposure(struct g
 	reg_w(gspca_dev, 0x11, 0x01);
 }

-static void pac7302_sethvflip(struct gspca_dev *gspca_dev)
+static void sethvflip(struct gspca_dev *gspca_dev)
 {
-	struct pac7302_sd *sd = (struct pac7302_sd *) gspca_dev;
+	struct sd *sd = (struct sd *) gspca_dev;
 	__u8 data;

 	reg_w(gspca_dev, 0xff, 0x03);		/* page 3 */
@@ -567,27 +565,27 @@ static void pac7302_sethvflip(struct gsp
 }

 /* this function is called at probe and resume time for pac7302 */
-static int pac7302_sd_init(struct gspca_dev *gspca_dev)
+static int sd_init(struct gspca_dev *gspca_dev)
 {
 	reg_w_seq(gspca_dev, init_7302, sizeof init_7302);

 	return 0;
 }

-static int pac7302_sd_start(struct gspca_dev *gspca_dev)
+static int sd_start(struct gspca_dev *gspca_dev)
 {
-	struct pac7302_sd *sd = (struct pac7302_sd *) gspca_dev;
+	struct sd *sd = (struct sd *) gspca_dev;

 	sd->sof_read = 0;

 	reg_w_var(gspca_dev, start_7302,
 		page3_7302, sizeof(page3_7302),
 		NULL, 0);
-	pac7302_setbrightcont(gspca_dev);
-	pac7302_setcolors(gspca_dev);
-	pac7302_setgain(gspca_dev);
-	pac7302_setexposure(gspca_dev);
-	pac7302_sethvflip(gspca_dev);
+	setbrightcont(gspca_dev);
+	setcolors(gspca_dev);
+	setgain(gspca_dev);
+	setexposure(gspca_dev);
+	sethvflip(gspca_dev);

 	/* only resolution 640x480 is supported for pac7302 */

@@ -602,7 +600,7 @@ static int pac7302_sd_start(struct gspca
 	return 0;
 }

-static void pac7302_sd_stopN(struct gspca_dev *gspca_dev)
+static void sd_stopN(struct gspca_dev *gspca_dev)
 {
 	reg_w(gspca_dev, 0xff, 0x01);
 	reg_w(gspca_dev, 0x78, 0x00);
@@ -610,7 +608,7 @@ static void pac7302_sd_stopN(struct gspc
 }

 /* called on streamoff with alt 0 and on disconnect for pac7302 */
-static void pac7302_sd_stop0(struct gspca_dev *gspca_dev)
+static void sd_stop0(struct gspca_dev *gspca_dev)
 {
 	if (!gspca_dev->present)
 		return;
@@ -621,9 +619,9 @@ static void pac7302_sd_stop0(struct gspc
 /* Include pac common sof detection functions */
 #include "pac_common.h"

-static void pac7302_do_autogain(struct gspca_dev *gspca_dev)
+static void do_autogain(struct gspca_dev *gspca_dev)
 {
-	struct pac7302_sd *sd = (struct pac7302_sd *) gspca_dev;
+	struct sd *sd = (struct sd *) gspca_dev;
 	int avg_lum = atomic_read(&sd->avg_lum);
 	int desired_lum, deadzone;

@@ -698,12 +696,12 @@ static void pac_start_frame(struct gspca
 }

 /* this function is run at interrupt level */
-static void pac7302_sd_pkt_scan(struct gspca_dev *gspca_dev,
+static void sd_pkt_scan(struct gspca_dev *gspca_dev,
 			struct gspca_frame *frame,	/* target */
 			__u8 *data,			/* isoc packet */
 			int len)			/* iso packet length */
 {
-	struct pac7302_sd *sd = (struct pac7302_sd *) gspca_dev;
+	struct sd *sd = (struct sd *) gspca_dev;
 	unsigned char *sof;

 	sof = pac_find_sof(&sd->sof_read, data, len);
@@ -751,100 +749,100 @@ static void pac7302_sd_pkt_scan(struct g
 	gspca_frame_add(gspca_dev, INTER_PACKET, frame, data, len);
 }

-static int pac7302_sd_setbrightness(struct gspca_dev *gspca_dev, __s32 val)
+static int sd_setbrightness(struct gspca_dev *gspca_dev, __s32 val)
 {
-	struct pac7302_sd *sd = (struct pac7302_sd *) gspca_dev;
+	struct sd *sd = (struct sd *) gspca_dev;

 	sd->brightness = val;
 	if (gspca_dev->streaming)
-		pac7302_setbrightcont(gspca_dev);
+		setbrightcont(gspca_dev);
 	return 0;
 }

-static int pac7302_sd_getbrightness(struct gspca_dev *gspca_dev, __s32 *val)
+static int sd_getbrightness(struct gspca_dev *gspca_dev, __s32 *val)
 {
-	struct pac7302_sd *sd = (struct pac7302_sd *) gspca_dev;
+	struct sd *sd = (struct sd *) gspca_dev;

 	*val = sd->brightness;
 	return 0;
 }

-static int pac7302_sd_setcontrast(struct gspca_dev *gspca_dev, __s32 val)
+static int sd_setcontrast(struct gspca_dev *gspca_dev, __s32 val)
 {
-	struct pac7302_sd *sd = (struct pac7302_sd *) gspca_dev;
+	struct sd *sd = (struct sd *) gspca_dev;

 	sd->contrast = val;
 	if (gspca_dev->streaming) {
-		pac7302_setbrightcont(gspca_dev);
+		setbrightcont(gspca_dev);
 	}
 	return 0;
 }

-static int pac7302_sd_getcontrast(struct gspca_dev *gspca_dev, __s32 *val)
+static int sd_getcontrast(struct gspca_dev *gspca_dev, __s32 *val)
 {
-	struct pac7302_sd *sd = (struct pac7302_sd *) gspca_dev;
+	struct sd *sd = (struct sd *) gspca_dev;

 	*val = sd->contrast;
 	return 0;
 }

-static int pac7302_sd_setcolors(struct gspca_dev *gspca_dev, __s32 val)
+static int sd_setcolors(struct gspca_dev *gspca_dev, __s32 val)
 {
-	struct pac7302_sd *sd = (struct pac7302_sd *) gspca_dev;
+	struct sd *sd = (struct sd *) gspca_dev;

 	sd->colors = val;
 	if (gspca_dev->streaming)
-		pac7302_setcolors(gspca_dev);
+		setcolors(gspca_dev);
 	return 0;
 }

-static int pac7302_sd_getcolors(struct gspca_dev *gspca_dev, __s32 *val)
+static int sd_getcolors(struct gspca_dev *gspca_dev, __s32 *val)
 {
-	struct pac7302_sd *sd = (struct pac7302_sd *) gspca_dev;
+	struct sd *sd = (struct sd *) gspca_dev;

 	*val = sd->colors;
 	return 0;
 }

-static int pac7302_sd_setgain(struct gspca_dev *gspca_dev, __s32 val)
+static int sd_setgain(struct gspca_dev *gspca_dev, __s32 val)
 {
-	struct pac7302_sd *sd = (struct pac7302_sd *) gspca_dev;
+	struct sd *sd = (struct sd *) gspca_dev;

 	sd->gain = val;
 	if (gspca_dev->streaming)
-		pac7302_setgain(gspca_dev);
+		setgain(gspca_dev);
 	return 0;
 }

-static int pac7302_sd_getgain(struct gspca_dev *gspca_dev, __s32 *val)
+static int sd_getgain(struct gspca_dev *gspca_dev, __s32 *val)
 {
-	struct pac7302_sd *sd = (struct pac7302_sd *) gspca_dev;
+	struct sd *sd = (struct sd *) gspca_dev;

 	*val = sd->gain;
 	return 0;
 }

-static int pac7302_sd_setexposure(struct gspca_dev *gspca_dev, __s32 val)
+static int sd_setexposure(struct gspca_dev *gspca_dev, __s32 val)
 {
-	struct pac7302_sd *sd = (struct pac7302_sd *) gspca_dev;
+	struct sd *sd = (struct sd *) gspca_dev;

 	sd->exposure = val;
 	if (gspca_dev->streaming)
-		pac7302_setexposure(gspca_dev);
+		setexposure(gspca_dev);
 	return 0;
 }

-static int pac7302_sd_getexposure(struct gspca_dev *gspca_dev, __s32 *val)
+static int sd_getexposure(struct gspca_dev *gspca_dev, __s32 *val)
 {
-	struct pac7302_sd *sd = (struct pac7302_sd *) gspca_dev;
+	struct sd *sd = (struct sd *) gspca_dev;

 	*val = sd->exposure;
 	return 0;
 }

-static int pac7302_sd_setautogain(struct gspca_dev *gspca_dev, __s32 val)
+static int sd_setautogain(struct gspca_dev *gspca_dev, __s32 val)
 {
-	struct pac7302_sd *sd = (struct pac7302_sd *) gspca_dev;
+	struct sd *sd = (struct sd *) gspca_dev;

 	sd->autogain = val;
 	/* when switching to autogain set defaults to make sure
@@ -857,84 +855,84 @@ static int pac7302_sd_setautogain(struct
 		if (gspca_dev->streaming) {
 			sd->autogain_ignore_frames =
 				PAC_AUTOGAIN_IGNORE_FRAMES;
-			pac7302_setexposure(gspca_dev);
-			pac7302_setgain(gspca_dev);
+			setexposure(gspca_dev);
+			setgain(gspca_dev);
 		}
 	}

 	return 0;
 }

-static int pac7302_sd_getautogain(struct gspca_dev *gspca_dev, __s32 *val)
+static int sd_getautogain(struct gspca_dev *gspca_dev, __s32 *val)
 {
-	struct pac7302_sd *sd = (struct pac7302_sd *) gspca_dev;
+	struct sd *sd = (struct sd *) gspca_dev;

 	*val = sd->autogain;
 	return 0;
 }

-static int pac7302_sd_sethflip(struct gspca_dev *gspca_dev, __s32 val)
+static int sd_sethflip(struct gspca_dev *gspca_dev, __s32 val)
 {
-	struct pac7302_sd *sd = (struct pac7302_sd *) gspca_dev;
+	struct sd *sd = (struct sd *) gspca_dev;

 	sd->hflip = val;
 	if (gspca_dev->streaming)
-		pac7302_sethvflip(gspca_dev);
+		sethvflip(gspca_dev);
 	return 0;
 }

-static int pac7302_sd_gethflip(struct gspca_dev *gspca_dev, __s32 *val)
+static int sd_gethflip(struct gspca_dev *gspca_dev, __s32 *val)
 {
-	struct pac7302_sd *sd = (struct pac7302_sd *) gspca_dev;
+	struct sd *sd = (struct sd *) gspca_dev;

 	*val = sd->hflip;
 	return 0;
 }

-static int pac7302_sd_setvflip(struct gspca_dev *gspca_dev, __s32 val)
+static int sd_setvflip(struct gspca_dev *gspca_dev, __s32 val)
 {
-	struct pac7302_sd *sd = (struct pac7302_sd *) gspca_dev;
+	struct sd *sd = (struct sd *) gspca_dev;

 	sd->vflip = val;
 	if (gspca_dev->streaming)
-		pac7302_sethvflip(gspca_dev);
+		sethvflip(gspca_dev);
 	return 0;
 }

-static int pac7302_sd_getvflip(struct gspca_dev *gspca_dev, __s32 *val)
+static int sd_getvflip(struct gspca_dev *gspca_dev, __s32 *val)
 {
-	struct pac7302_sd *sd = (struct pac7302_sd *) gspca_dev;
+	struct sd *sd = (struct sd *) gspca_dev;

 	*val = sd->vflip;
 	return 0;
 }

 /* sub-driver description for pac7302 */
-static struct sd_desc pac7302_sd_desc = {
+static struct sd_desc sd_desc = {
 	.name = MODULE_NAME,
-	.ctrls = pac7302_sd_ctrls,
-	.nctrls = ARRAY_SIZE(pac7302_sd_ctrls),
-	.config = pac7302_sd_config,
-	.init = pac7302_sd_init,
-	.start = pac7302_sd_start,
-	.stopN = pac7302_sd_stopN,
-	.stop0 = pac7302_sd_stop0,
-	.pkt_scan = pac7302_sd_pkt_scan,
-	.dq_callback = pac7302_do_autogain,
+	.ctrls = sd_ctrls,
+	.nctrls = ARRAY_SIZE(sd_ctrls),
+	.config = sd_config,
+	.init = sd_init,
+	.start = sd_start,
+	.stopN = sd_stopN,
+	.stop0 = sd_stop0,
+	.pkt_scan = sd_pkt_scan,
+	.dq_callback = do_autogain,
 };

 /* -- module initialisation -- */
 static __devinitdata struct usb_device_id device_table[] = {
-	{USB_DEVICE(0x06f8, 0x3009), .driver_info = SENSOR_PAC7302},
-	{USB_DEVICE(0x093a, 0x2620), .driver_info = SENSOR_PAC7302},
-	{USB_DEVICE(0x093a, 0x2621), .driver_info = SENSOR_PAC7302},
-	{USB_DEVICE(0x093a, 0x2622), .driver_info = SENSOR_PAC7302},
-	{USB_DEVICE(0x093a, 0x2624), .driver_info = SENSOR_PAC7302},
-	{USB_DEVICE(0x093a, 0x2626), .driver_info = SENSOR_PAC7302},
-	{USB_DEVICE(0x093a, 0x2628), .driver_info = SENSOR_PAC7302},
-	{USB_DEVICE(0x093a, 0x2629), .driver_info = SENSOR_PAC7302},
-	{USB_DEVICE(0x093a, 0x262a), .driver_info = SENSOR_PAC7302},
-	{USB_DEVICE(0x093a, 0x262c), .driver_info = SENSOR_PAC7302},
+	{USB_DEVICE(0x06f8, 0x3009)},
+	{USB_DEVICE(0x093a, 0x2620)},
+	{USB_DEVICE(0x093a, 0x2621)},
+	{USB_DEVICE(0x093a, 0x2622)},
+	{USB_DEVICE(0x093a, 0x2624)},
+	{USB_DEVICE(0x093a, 0x2626)},
+	{USB_DEVICE(0x093a, 0x2628)},
+	{USB_DEVICE(0x093a, 0x2629)},
+	{USB_DEVICE(0x093a, 0x262a)},
+	{USB_DEVICE(0x093a, 0x262c)},
 	{}
 };
 MODULE_DEVICE_TABLE(usb, device_table);
@@ -943,8 +941,8 @@ MODULE_DEVICE_TABLE(usb, device_table);
 static int sd_probe(struct usb_interface *intf,
 			const struct usb_device_id *id)
 {
-	return gspca_dev_probe(intf, id, &pac7302_sd_desc,
-			sizeof(struct pac7302_sd), THIS_MODULE);
+	return gspca_dev_probe(intf, id, &sd_desc,
+			sizeof(struct sd), THIS_MODULE);
 }

 static struct usb_driver sd_driver = {
diff -uprN u/drivers/media/video/gspca/pac7311.c v/drivers/media/video/gspca/pac7311.c
--- u/drivers/media/video/gspca/pac7311.c	2009-11-01 07:00:21.000000000 +0100
+++ v/drivers/media/video/gspca/pac7311.c	2009-11-01 07:01:47.000000000 +0100
@@ -58,7 +58,7 @@ MODULE_DESCRIPTION("Pixart PAC7311");
 MODULE_LICENSE("GPL");

 /* specific webcam descriptor for pac7311 */
-struct pac7311_sd {
+struct sd {
 	struct gspca_dev gspca_dev;		/* !! must be the first item */

 	unsigned char contrast;
@@ -68,8 +68,6 @@ struct pac7311_sd {
 	__u8 hflip;
 	__u8 vflip;

-#define SENSOR_PAC7311 1
-
 	u8 sof_read;
 	u8 autogain_ignore_frames;

@@ -77,20 +75,20 @@ struct pac7311_sd {
 };

 /* V4L2 controls supported by the driver */
-static int pac7311_sd_setcontrast(struct gspca_dev *gspca_dev, __s32 val);
-static int pac7311_sd_getcontrast(struct gspca_dev *gspca_dev, __s32 *val);
-static int pac7311_sd_setautogain(struct gspca_dev *gspca_dev, __s32 val);
-static int pac7311_sd_getautogain(struct gspca_dev *gspca_dev, __s32 *val);
-static int pac7311_sd_sethflip(struct gspca_dev *gspca_dev, __s32 val);
-static int pac7311_sd_gethflip(struct gspca_dev *gspca_dev, __s32 *val);
-static int pac7311_sd_setvflip(struct gspca_dev *gspca_dev, __s32 val);
-static int pac7311_sd_getvflip(struct gspca_dev *gspca_dev, __s32 *val);
-static int pac7311_sd_setgain(struct gspca_dev *gspca_dev, __s32 val);
-static int pac7311_sd_getgain(struct gspca_dev *gspca_dev, __s32 *val);
-static int pac7311_sd_setexposure(struct gspca_dev *gspca_dev, __s32 val);
-static int pac7311_sd_getexposure(struct gspca_dev *gspca_dev, __s32 *val);
+static int sd_setcontrast(struct gspca_dev *gspca_dev, __s32 val);
+static int sd_getcontrast(struct gspca_dev *gspca_dev, __s32 *val);
+static int sd_setautogain(struct gspca_dev *gspca_dev, __s32 val);
+static int sd_getautogain(struct gspca_dev *gspca_dev, __s32 *val);
+static int sd_sethflip(struct gspca_dev *gspca_dev, __s32 val);
+static int sd_gethflip(struct gspca_dev *gspca_dev, __s32 *val);
+static int sd_setvflip(struct gspca_dev *gspca_dev, __s32 val);
+static int sd_getvflip(struct gspca_dev *gspca_dev, __s32 *val);
+static int sd_setgain(struct gspca_dev *gspca_dev, __s32 val);
+static int sd_getgain(struct gspca_dev *gspca_dev, __s32 *val);
+static int sd_setexposure(struct gspca_dev *gspca_dev, __s32 val);
+static int sd_getexposure(struct gspca_dev *gspca_dev, __s32 *val);

-static struct ctrl pac7311_sd_ctrls[] = {
+static struct ctrl sd_ctrls[] = {
 /* This control is for both the 7302 and the 7311 */
 	{
 	    {
@@ -104,8 +102,8 @@ static struct ctrl pac7311_sd_ctrls[] =
 #define CONTRAST_DEF 127
 		.default_value = CONTRAST_DEF,
 	    },
-	    .set = pac7311_sd_setcontrast,
-	    .get = pac7311_sd_getcontrast,
+	    .set = sd_setcontrast,
+	    .get = sd_getcontrast,
 	},
 /* All controls below are for both the 7302 and the 7311 */
 	{
@@ -121,8 +119,8 @@ static struct ctrl pac7311_sd_ctrls[] =
 #define GAIN_KNEE 255 /* Gain seems to cause little noise on the pac73xx */
 		.default_value = GAIN_DEF,
 	    },
-	    .set = pac7311_sd_setgain,
-	    .get = pac7311_sd_getgain,
+	    .set = sd_setgain,
+	    .get = sd_getgain,
 	},
 	{
 	    {
@@ -137,8 +135,8 @@ static struct ctrl pac7311_sd_ctrls[] =
 #define EXPOSURE_KNEE 50 /* 100 ms / 10 fps */
 		.default_value = EXPOSURE_DEF,
 	    },
-	    .set = pac7311_sd_setexposure,
-	    .get = pac7311_sd_getexposure,
+	    .set = sd_setexposure,
+	    .get = sd_getexposure,
 	},
 	{
 	    {
@@ -151,8 +149,8 @@ static struct ctrl pac7311_sd_ctrls[] =
 #define AUTOGAIN_DEF 1
 		.default_value = AUTOGAIN_DEF,
 	    },
-	    .set = pac7311_sd_setautogain,
-	    .get = pac7311_sd_getautogain,
+	    .set = sd_setautogain,
+	    .get = sd_getautogain,
 	},
 	{
 	    {
@@ -165,8 +163,8 @@ static struct ctrl pac7311_sd_ctrls[] =
 #define HFLIP_DEF 0
 		.default_value = HFLIP_DEF,
 	    },
-	    .set = pac7311_sd_sethflip,
-	    .get = pac7311_sd_gethflip,
+	    .set = sd_sethflip,
+	    .get = sd_gethflip,
 	},
 	{
 	    {
@@ -179,12 +177,12 @@ static struct ctrl pac7311_sd_ctrls[] =
 #define VFLIP_DEF 0
 		.default_value = VFLIP_DEF,
 	    },
-	    .set = pac7311_sd_setvflip,
-	    .get = pac7311_sd_getvflip,
+	    .set = sd_setvflip,
+	    .get = sd_getvflip,
 	},
 };

-static const struct v4l2_pix_format pac7311_vga_mode[] = {
+static const struct v4l2_pix_format vga_mode[] = {
 	{160, 120, V4L2_PIX_FMT_PJPG, V4L2_FIELD_NONE,
 		.bytesperline = 160,
 		.sizeimage = 160 * 120 * 3 / 8 + 590,
@@ -374,17 +372,17 @@ static void reg_w_var(struct gspca_dev *
 }

 /* this function is called at probe time for pac7311 */
-static int pac7311_sd_config(struct gspca_dev *gspca_dev,
+static int sd_config(struct gspca_dev *gspca_dev,
 			const struct usb_device_id *id)
 {
-	struct pac7311_sd *sd = (struct pac7311_sd *) gspca_dev;
+	struct sd *sd = (struct sd *) gspca_dev;
 	struct cam *cam;

 	cam = &gspca_dev->cam;

 	PDEBUG(D_CONF, "Find Sensor PAC7311");
-	cam->cam_mode = pac7311_vga_mode;
-	cam->nmodes = ARRAY_SIZE(pac7311_vga_mode);
+	cam->cam_mode = vga_mode;
+	cam->nmodes = ARRAY_SIZE(vga_mode);

 	sd->contrast = CONTRAST_DEF;
 	sd->gain = GAIN_DEF;
@@ -396,9 +394,9 @@ static int pac7311_sd_config(struct gspc
 }

 /* This function is used by pac7311 only */
-static void pac7311_setcontrast(struct gspca_dev *gspca_dev)
+static void setcontrast(struct gspca_dev *gspca_dev)
 {
-	struct pac7311_sd *sd = (struct pac7311_sd *) gspca_dev;
+	struct sd *sd = (struct sd *) gspca_dev;

 	reg_w(gspca_dev, 0xff, 0x04);
 	reg_w(gspca_dev, 0x10, sd->contrast >> 4);
@@ -406,9 +404,9 @@ static void pac7311_setcontrast(struct g
 	reg_w(gspca_dev, 0x11, 0x01);
 }

-static void pac7311_setgain(struct gspca_dev *gspca_dev)
+static void setgain(struct gspca_dev *gspca_dev)
 {
-	struct pac7311_sd *sd = (struct pac7311_sd *) gspca_dev;
+	struct sd *sd = (struct sd *) gspca_dev;
 	int gain = GAIN_MAX - sd->gain;

 	if (gain < 1)
@@ -423,9 +421,9 @@ static void pac7311_setgain(struct gspca
 	reg_w(gspca_dev, 0x11, 0x01);
 }

-static void pac7311_setexposure(struct gspca_dev *gspca_dev)
+static void setexposure(struct gspca_dev *gspca_dev)
 {
-	struct pac7311_sd *sd = (struct pac7311_sd *) gspca_dev;
+	struct sd *sd = (struct sd *) gspca_dev;
 	__u8 reg;

 	/* register 2 of frame 3/4 contains the clock divider configuring the
@@ -452,9 +450,9 @@ static void pac7311_setexposure(struct g
 	reg_w(gspca_dev, 0x11, 0x01);
 }

-static void pac7311_sethvflip(struct gspca_dev *gspca_dev)
+static void sethvflip(struct gspca_dev *gspca_dev)
 {
-	struct pac7311_sd *sd = (struct pac7311_sd *) gspca_dev;
+	struct sd *sd = (struct sd *) gspca_dev;
 	__u8 data;

 	reg_w(gspca_dev, 0xff, 0x04);		/* page 4 */
@@ -465,26 +463,26 @@ static void pac7311_sethvflip(struct gsp
 }

 /* this function is called at probe and resume time for pac7311 */
-static int pac7311_sd_init(struct gspca_dev *gspca_dev)
+static int sd_init(struct gspca_dev *gspca_dev)
 {
 	reg_w_seq(gspca_dev, init_7311, sizeof init_7311);

 	return 0;
 }

-static int pac7311_sd_start(struct gspca_dev *gspca_dev)
+static int sd_start(struct gspca_dev *gspca_dev)
 {
-	struct pac7311_sd *sd = (struct pac7311_sd *) gspca_dev;
+	struct sd *sd = (struct sd *) gspca_dev;

 	sd->sof_read = 0;

 	reg_w_var(gspca_dev, start_7311,
 		NULL, 0,
 		page4_7311, sizeof(page4_7311));
-	pac7311_setcontrast(gspca_dev);
-	pac7311_setgain(gspca_dev);
-	pac7311_setexposure(gspca_dev);
-	pac7311_sethvflip(gspca_dev);
+	setcontrast(gspca_dev);
+	setgain(gspca_dev);
+	setexposure(gspca_dev);
+	sethvflip(gspca_dev);

 	/* set correct resolution */
 	switch (gspca_dev->cam.cam_mode[(int) gspca_dev->curr_mode].priv) {
@@ -516,7 +514,7 @@ static int pac7311_sd_start(struct gspca
 	return 0;
 }

-static void pac7311_sd_stopN(struct gspca_dev *gspca_dev)
+static void sd_stopN(struct gspca_dev *gspca_dev)
 {
 	reg_w(gspca_dev, 0xff, 0x04);
 	reg_w(gspca_dev, 0x27, 0x80);
@@ -531,16 +529,16 @@ static void pac7311_sd_stopN(struct gspc
 }

 /* called on streamoff with alt 0 and on disconnect for 7311 */
-static void pac7311_sd_stop0(struct gspca_dev *gspca_dev)
+static void sd_stop0(struct gspca_dev *gspca_dev)
 {
 }

 /* Include pac common sof detection functions */
 #include "pac_common.h"

-static void pac7311_do_autogain(struct gspca_dev *gspca_dev)
+static void do_autogain(struct gspca_dev *gspca_dev)
 {
-	struct pac7311_sd *sd = (struct pac7311_sd *) gspca_dev;
+	struct sd *sd = (struct sd *) gspca_dev;
 	int avg_lum = atomic_read(&sd->avg_lum);
 	int desired_lum, deadzone;

@@ -606,12 +604,12 @@ static void pac_start_frame(struct gspca
 }

 /* this function is run at interrupt level */
-static void pac7311_sd_pkt_scan(struct gspca_dev *gspca_dev,
+static void sd_pkt_scan(struct gspca_dev *gspca_dev,
 			struct gspca_frame *frame,	/* target */
 			__u8 *data,			/* isoc packet */
 			int len)			/* iso packet length */
 {
-	struct pac7311_sd *sd = (struct pac7311_sd *) gspca_dev;
+	struct sd *sd = (struct sd *) gspca_dev;
 	unsigned char *sof;

 	sof = pac_find_sof(&sd->sof_read, data, len);
@@ -658,64 +656,64 @@ static void pac7311_sd_pkt_scan(struct g
 	gspca_frame_add(gspca_dev, INTER_PACKET, frame, data, len);
 }

-static int pac7311_sd_setcontrast(struct gspca_dev *gspca_dev, __s32 val)
+static int sd_setcontrast(struct gspca_dev *gspca_dev, __s32 val)
 {
-	struct pac7311_sd *sd = (struct pac7311_sd *) gspca_dev;
+	struct sd *sd = (struct sd *) gspca_dev;

 	sd->contrast = val;
 	if (gspca_dev->streaming) {
-		pac7311_setcontrast(gspca_dev);
+		setcontrast(gspca_dev);
 	}
 	return 0;
 }

-static int pac7311_sd_getcontrast(struct gspca_dev *gspca_dev, __s32 *val)
+static int sd_getcontrast(struct gspca_dev *gspca_dev, __s32 *val)
 {
-	struct pac7311_sd *sd = (struct pac7311_sd *) gspca_dev;
+	struct sd *sd = (struct sd *) gspca_dev;

 	*val = sd->contrast;
 	return 0;
 }

-static int pac7311_sd_setgain(struct gspca_dev *gspca_dev, __s32 val)
+static int sd_setgain(struct gspca_dev *gspca_dev, __s32 val)
 {
-	struct pac7311_sd *sd = (struct pac7311_sd *) gspca_dev;
+	struct sd *sd = (struct sd *) gspca_dev;

 	sd->gain = val;
 	if (gspca_dev->streaming)
-		pac7311_setgain(gspca_dev);
+		setgain(gspca_dev);
 	return 0;
 }

-static int pac7311_sd_getgain(struct gspca_dev *gspca_dev, __s32 *val)
+static int sd_getgain(struct gspca_dev *gspca_dev, __s32 *val)
 {
-	struct pac7311_sd *sd = (struct pac7311_sd *) gspca_dev;
+	struct sd *sd = (struct sd *) gspca_dev;

 	*val = sd->gain;
 	return 0;
 }

-static int pac7311_sd_setexposure(struct gspca_dev *gspca_dev, __s32 val)
+static int sd_setexposure(struct gspca_dev *gspca_dev, __s32 val)
 {
-	struct pac7311_sd *sd = (struct pac7311_sd *) gspca_dev;
+	struct sd *sd = (struct sd *) gspca_dev;

 	sd->exposure = val;
 	if (gspca_dev->streaming)
-		pac7311_setexposure(gspca_dev);
+		setexposure(gspca_dev);
 	return 0;
 }

-static int pac7311_sd_getexposure(struct gspca_dev *gspca_dev, __s32 *val)
+static int sd_getexposure(struct gspca_dev *gspca_dev, __s32 *val)
 {
-	struct pac7311_sd *sd = (struct pac7311_sd *) gspca_dev;
+	struct sd *sd = (struct sd *) gspca_dev;

 	*val = sd->exposure;
 	return 0;
 }

-static int pac7311_sd_setautogain(struct gspca_dev *gspca_dev, __s32 val)
+static int sd_setautogain(struct gspca_dev *gspca_dev, __s32 val)
 {
-	struct pac7311_sd *sd = (struct pac7311_sd *) gspca_dev;
+	struct sd *sd = (struct sd *) gspca_dev;

 	sd->autogain = val;
 	/* when switching to autogain set defaults to make sure
@@ -728,80 +726,80 @@ static int pac7311_sd_setautogain(struct
 		if (gspca_dev->streaming) {
 			sd->autogain_ignore_frames =
 				PAC_AUTOGAIN_IGNORE_FRAMES;
-			pac7311_setexposure(gspca_dev);
-			pac7311_setgain(gspca_dev);
+			setexposure(gspca_dev);
+			setgain(gspca_dev);
 		}
 	}

 	return 0;
 }

-static int pac7311_sd_getautogain(struct gspca_dev *gspca_dev, __s32 *val)
+static int sd_getautogain(struct gspca_dev *gspca_dev, __s32 *val)
 {
-	struct pac7311_sd *sd = (struct pac7311_sd *) gspca_dev;
+	struct sd *sd = (struct sd *) gspca_dev;

 	*val = sd->autogain;
 	return 0;
 }

-static int pac7311_sd_sethflip(struct gspca_dev *gspca_dev, __s32 val)
+static int sd_sethflip(struct gspca_dev *gspca_dev, __s32 val)
 {
-	struct pac7311_sd *sd = (struct pac7311_sd *) gspca_dev;
+	struct sd *sd = (struct sd *) gspca_dev;

 	sd->hflip = val;
 	if (gspca_dev->streaming)
-		pac7311_sethvflip(gspca_dev);
+		sethvflip(gspca_dev);
 	return 0;
 }

-static int pac7311_sd_gethflip(struct gspca_dev *gspca_dev, __s32 *val)
+static int sd_gethflip(struct gspca_dev *gspca_dev, __s32 *val)
 {
-	struct pac7311_sd *sd = (struct pac7311_sd *) gspca_dev;
+	struct sd *sd = (struct sd *) gspca_dev;

 	*val = sd->hflip;
 	return 0;
 }

-static int pac7311_sd_setvflip(struct gspca_dev *gspca_dev, __s32 val)
+static int sd_setvflip(struct gspca_dev *gspca_dev, __s32 val)
 {
-	struct pac7311_sd *sd = (struct pac7311_sd *) gspca_dev;
+	struct sd *sd = (struct sd *) gspca_dev;

 	sd->vflip = val;
 	if (gspca_dev->streaming)
-		pac7311_sethvflip(gspca_dev);
+		sethvflip(gspca_dev);
 	return 0;
 }

-static int pac7311_sd_getvflip(struct gspca_dev *gspca_dev, __s32 *val)
+static int sd_getvflip(struct gspca_dev *gspca_dev, __s32 *val)
 {
-	struct pac7311_sd *sd = (struct pac7311_sd *) gspca_dev;
+	struct sd *sd = (struct sd *) gspca_dev;

 	*val = sd->vflip;
 	return 0;
 }

 /* sub-driver description for pac7311 */
-static struct sd_desc pac7311_sd_desc = {
+static struct sd_desc sd_desc = {
 	.name = MODULE_NAME,
-	.ctrls = pac7311_sd_ctrls,
-	.nctrls = ARRAY_SIZE(pac7311_sd_ctrls),
-	.config = pac7311_sd_config,
-	.init = pac7311_sd_init,
-	.start = pac7311_sd_start,
-	.stopN = pac7311_sd_stopN,
-	.stop0 = pac7311_sd_stop0,
-	.pkt_scan = pac7311_sd_pkt_scan,
-	.dq_callback = pac7311_do_autogain,
+	.ctrls = sd_ctrls,
+	.nctrls = ARRAY_SIZE(sd_ctrls),
+	.config = sd_config,
+	.init = sd_init,
+	.start = sd_start,
+	.stopN = sd_stopN,
+	.stop0 = sd_stop0,
+	.pkt_scan = sd_pkt_scan,
+	.dq_callback = do_autogain,
 };

 /* -- module initialisation -- */
 static __devinitdata struct usb_device_id device_table[] = {
-	{USB_DEVICE(0x093a, 0x2600), .driver_info = SENSOR_PAC7311},
-	{USB_DEVICE(0x093a, 0x2601), .driver_info = SENSOR_PAC7311},
-	{USB_DEVICE(0x093a, 0x2603), .driver_info = SENSOR_PAC7311},
-	{USB_DEVICE(0x093a, 0x2608), .driver_info = SENSOR_PAC7311},
-	{USB_DEVICE(0x093a, 0x260e), .driver_info = SENSOR_PAC7311},
-	{USB_DEVICE(0x093a, 0x260f), .driver_info = SENSOR_PAC7311},
+	{USB_DEVICE(0x093a, 0x2600)},
+	{USB_DEVICE(0x093a, 0x2601)},
+	{USB_DEVICE(0x093a, 0x2603)},
+	{USB_DEVICE(0x093a, 0x2608)},
+	{USB_DEVICE(0x093a, 0x260e)},
+	{USB_DEVICE(0x093a, 0x260f)},
 	{}
 };
 MODULE_DEVICE_TABLE(usb, device_table);
@@ -810,8 +808,8 @@ MODULE_DEVICE_TABLE(usb, device_table);
 static int sd_probe(struct usb_interface *intf,
 			const struct usb_device_id *id)
 {
-	return gspca_dev_probe(intf, id, &pac7311_sd_desc,
-			sizeof(struct pac7311_sd), THIS_MODULE);
+	return gspca_dev_probe(intf, id, &sd_desc,
+			sizeof(struct sd), THIS_MODULE);
 }

 static struct usb_driver sd_driver = {
