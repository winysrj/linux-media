Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr8.xs4all.nl ([194.109.24.28]:4820 "EHLO
	smtp-vbr8.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754060Ab2D1PKN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 28 Apr 2012 11:10:13 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans de Goede <hdegoede@redhat.com>,
	Jean-Francois Moine <moinejf@free.fr>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv1 PATCH 2/7] zc3xx: convert to the control framework.
Date: Sat, 28 Apr 2012 17:09:51 +0200
Message-Id: <f5a41eed0541dfa132750639ff0df9c22b9f157c.1335625085.git.hans.verkuil@cisco.com>
In-Reply-To: <1335625796-9429-1-git-send-email-hverkuil@xs4all.nl>
References: <1335625796-9429-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <ea7e986dc0fa18da12c22048e9187e9933191d3d.1335625085.git.hans.verkuil@cisco.com>
References: <ea7e986dc0fa18da12c22048e9187e9933191d3d.1335625085.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/video/gspca/zc3xx.c |  451 +++++++++++++++----------------------
 1 file changed, 182 insertions(+), 269 deletions(-)

diff --git a/drivers/media/video/gspca/zc3xx.c b/drivers/media/video/gspca/zc3xx.c
index 7d9a4f1..e7b7599 100644
--- a/drivers/media/video/gspca/zc3xx.c
+++ b/drivers/media/video/gspca/zc3xx.c
@@ -22,6 +22,7 @@
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
 #include <linux/input.h>
+#include <media/v4l2-ctrls.h>
 #include "gspca.h"
 #include "jpeg.h"
 
@@ -35,26 +36,23 @@ static int force_sensor = -1;
 #define REG08_DEF 3		/* default JPEG compression (70%) */
 #include "zc3xx-reg.h"
 
-/* controls */
-enum e_ctrl {
-	BRIGHTNESS,
-	CONTRAST,
-	EXPOSURE,
-	GAMMA,
-	AUTOGAIN,
-	LIGHTFREQ,
-	SHARPNESS,
-	QUALITY,
-	NCTRLS		/* number of controls */
-};
-
-#define AUTOGAIN_DEF 1
-
 /* specific webcam descriptor */
 struct sd {
 	struct gspca_dev gspca_dev;	/* !! must be the first item */
 
-	struct gspca_ctrl ctrls[NCTRLS];
+	struct v4l2_ctrl_handler ctrl_handler;
+	struct { /* gamma/brightness/contrast control cluster */
+		struct v4l2_ctrl *gamma;
+		struct v4l2_ctrl *brightness;
+		struct v4l2_ctrl *contrast;
+	};
+	struct { /* autogain/exposure control cluster */
+		struct v4l2_ctrl *autogain;
+		struct v4l2_ctrl *exposure;
+	};
+	struct v4l2_ctrl *plfreq;
+	struct v4l2_ctrl *sharpness;
+	struct v4l2_ctrl *jpegqual;
 
 	struct work_struct work;
 	struct workqueue_struct *work_thread;
@@ -95,112 +93,6 @@ enum sensors {
 };
 
 /* V4L2 controls supported by the driver */
-static void setcontrast(struct gspca_dev *gspca_dev);
-static void setexposure(struct gspca_dev *gspca_dev);
-static int sd_setautogain(struct gspca_dev *gspca_dev, __s32 val);
-static void setlightfreq(struct gspca_dev *gspca_dev);
-static void setsharpness(struct gspca_dev *gspca_dev);
-static int sd_setquality(struct gspca_dev *gspca_dev, __s32 val);
-
-static const struct ctrl sd_ctrls[NCTRLS] = {
-[BRIGHTNESS] = {
-	    {
-		.id      = V4L2_CID_BRIGHTNESS,
-		.type    = V4L2_CTRL_TYPE_INTEGER,
-		.name    = "Brightness",
-		.minimum = 0,
-		.maximum = 255,
-		.step    = 1,
-		.default_value = 128,
-	    },
-	    .set_control = setcontrast
-	},
-[CONTRAST] = {
-	    {
-		.id      = V4L2_CID_CONTRAST,
-		.type    = V4L2_CTRL_TYPE_INTEGER,
-		.name    = "Contrast",
-		.minimum = 0,
-		.maximum = 255,
-		.step    = 1,
-		.default_value = 128,
-	    },
-	    .set_control = setcontrast
-	},
-[EXPOSURE] = {
-	    {
-		.id      = V4L2_CID_EXPOSURE,
-		.type    = V4L2_CTRL_TYPE_INTEGER,
-		.name    = "Exposure",
-		.minimum = 0x30d,
-		.maximum	= 0x493e,
-		.step		= 1,
-		.default_value  = 0x927
-	    },
-	    .set_control = setexposure
-	},
-[GAMMA] = {
-	    {
-		.id      = V4L2_CID_GAMMA,
-		.type    = V4L2_CTRL_TYPE_INTEGER,
-		.name    = "Gamma",
-		.minimum = 1,
-		.maximum = 6,
-		.step    = 1,
-		.default_value = 4,
-	    },
-	    .set_control = setcontrast
-	},
-[AUTOGAIN] = {
-	    {
-		.id      = V4L2_CID_AUTOGAIN,
-		.type    = V4L2_CTRL_TYPE_BOOLEAN,
-		.name    = "Auto Gain",
-		.minimum = 0,
-		.maximum = 1,
-		.step    = 1,
-		.default_value = AUTOGAIN_DEF,
-		.flags   = V4L2_CTRL_FLAG_UPDATE
-	    },
-	    .set = sd_setautogain
-	},
-[LIGHTFREQ] = {
-	    {
-		.id	 = V4L2_CID_POWER_LINE_FREQUENCY,
-		.type    = V4L2_CTRL_TYPE_MENU,
-		.name    = "Light frequency filter",
-		.minimum = 0,
-		.maximum = 2,	/* 0: 0, 1: 50Hz, 2:60Hz */
-		.step    = 1,
-		.default_value = 0,
-	    },
-	    .set_control = setlightfreq
-	},
-[SHARPNESS] = {
-	    {
-		.id	 = V4L2_CID_SHARPNESS,
-		.type    = V4L2_CTRL_TYPE_INTEGER,
-		.name    = "Sharpness",
-		.minimum = 0,
-		.maximum = 3,
-		.step    = 1,
-		.default_value = 2,
-	    },
-	    .set_control = setsharpness
-	},
-[QUALITY] = {
-	    {
-		.id	 = V4L2_CID_JPEG_COMPRESSION_QUALITY,
-		.type    = V4L2_CTRL_TYPE_INTEGER,
-		.name    = "Compression Quality",
-		.minimum = 40,
-		.maximum = 70,
-		.step    = 1,
-		.default_value = 70	/* updated in sd_init() */
-	    },
-	    .set = sd_setquality
-	},
-};
 
 static const struct v4l2_pix_format vga_mode[] = {
 	{320, 240, V4L2_PIX_FMT_JPEG, V4L2_FIELD_NONE,
@@ -5818,10 +5710,8 @@ static void setmatrix(struct gspca_dev *gspca_dev)
 		reg_w(gspca_dev, matrix[i], 0x010a + i);
 }
 
-static void setsharpness(struct gspca_dev *gspca_dev)
+static void setsharpness(struct gspca_dev *gspca_dev, s32 val)
 {
-	struct sd *sd = (struct sd *) gspca_dev;
-	int sharpness;
 	static const u8 sharpness_tb[][2] = {
 		{0x02, 0x03},
 		{0x04, 0x07},
@@ -5829,19 +5719,18 @@ static void setsharpness(struct gspca_dev *gspca_dev)
 		{0x10, 0x1e}
 	};
 
-	sharpness = sd->ctrls[SHARPNESS].val;
-	reg_w(gspca_dev, sharpness_tb[sharpness][0], 0x01c6);
+	reg_w(gspca_dev, sharpness_tb[val][0], 0x01c6);
 	reg_r(gspca_dev, 0x01c8);
 	reg_r(gspca_dev, 0x01c9);
 	reg_r(gspca_dev, 0x01ca);
-	reg_w(gspca_dev, sharpness_tb[sharpness][1], 0x01cb);
+	reg_w(gspca_dev, sharpness_tb[val][1], 0x01cb);
 }
 
-static void setcontrast(struct gspca_dev *gspca_dev)
+static void setcontrast(struct gspca_dev *gspca_dev,
+		s32 gamma, s32 brightness, s32 contrast)
 {
-	struct sd *sd = (struct sd *) gspca_dev;
 	const u8 *Tgamma;
-	int g, i, brightness, contrast, adj, gp1, gp2;
+	int g, i, adj, gp1, gp2;
 	u8 gr[16];
 	static const u8 delta_b[16] =		/* delta for brightness */
 		{0x50, 0x38, 0x2d, 0x28, 0x24, 0x21, 0x1e, 0x1d,
@@ -5864,10 +5753,10 @@ static void setcontrast(struct gspca_dev *gspca_dev)
 		 0xe0, 0xeb, 0xf4, 0xff, 0xff, 0xff, 0xff, 0xff},
 	};
 
-	Tgamma = gamma_tb[sd->ctrls[GAMMA].val - 1];
+	Tgamma = gamma_tb[gamma - 1];
 
-	contrast = ((int) sd->ctrls[CONTRAST].val - 128); /* -128 / 127 */
-	brightness = ((int) sd->ctrls[BRIGHTNESS].val - 128); /* -128 / 92 */
+	contrast -= 128; /* -128 / 127 */
+	brightness -= 128; /* -128 / 92 */
 	adj = 0;
 	gp1 = gp2 = 0;
 	for (i = 0; i < 16; i++) {
@@ -5894,25 +5783,23 @@ static void setcontrast(struct gspca_dev *gspca_dev)
 		reg_w(gspca_dev, gr[i], 0x0130 + i);	/* gradient */
 }
 
-static void getexposure(struct gspca_dev *gspca_dev)
+static s32 getexposure(struct gspca_dev *gspca_dev)
 {
 	struct sd *sd = (struct sd *) gspca_dev;
 
 	if (sd->sensor != SENSOR_HV7131R)
-		return;
-	sd->ctrls[EXPOSURE].val = (i2c_read(gspca_dev, 0x25) << 9)
+		return 0;
+	return (i2c_read(gspca_dev, 0x25) << 9)
 		| (i2c_read(gspca_dev, 0x26) << 1)
 		| (i2c_read(gspca_dev, 0x27) >> 7);
 }
 
-static void setexposure(struct gspca_dev *gspca_dev)
+static void setexposure(struct gspca_dev *gspca_dev, s32 val)
 {
 	struct sd *sd = (struct sd *) gspca_dev;
-	int val;
 
 	if (sd->sensor != SENSOR_HV7131R)
 		return;
-	val = sd->ctrls[EXPOSURE].val;
 	i2c_write(gspca_dev, 0x25, val >> 9, 0x00);
 	i2c_write(gspca_dev, 0x26, val >> 1, 0x00);
 	i2c_write(gspca_dev, 0x27, val << 7, 0x00);
@@ -5943,7 +5830,7 @@ static void setquality(struct gspca_dev *gspca_dev)
  *	60Hz, for American lighting
  *	0 = No Fliker (for outdoore usage)
  */
-static void setlightfreq(struct gspca_dev *gspca_dev)
+static void setlightfreq(struct gspca_dev *gspca_dev, s32 val)
 {
 	struct sd *sd = (struct sd *) gspca_dev;
 	int i, mode;
@@ -6027,7 +5914,7 @@ static void setlightfreq(struct gspca_dev *gspca_dev)
 		 tas5130c_60HZ, tas5130c_60HZScale},
 	};
 
-	i = sd->ctrls[LIGHTFREQ].val * 2;
+	i = val * 2;
 	mode = gspca_dev->cam.cam_mode[gspca_dev->curr_mode].priv;
 	if (mode)
 		i++;			/* 320x240 */
@@ -6037,14 +5924,14 @@ static void setlightfreq(struct gspca_dev *gspca_dev)
 	usb_exchange(gspca_dev, zc3_freq);
 	switch (sd->sensor) {
 	case SENSOR_GC0305:
-		if (mode				/* if 320x240 */
-		    && sd->ctrls[LIGHTFREQ].val == 1)	/* and 50Hz */
+		if (mode		/* if 320x240 */
+		    && val == 1)	/* and 50Hz */
 			reg_w(gspca_dev, 0x85, 0x018d);
 					/* win: 0x80, 0x018d */
 		break;
 	case SENSOR_OV7620:
-		if (!mode) {				/* if 640x480 */
-			if (sd->ctrls[LIGHTFREQ].val != 0) /* and filter */
+		if (!mode) {		/* if 640x480 */
+			if (val != 0)	/* and filter */
 				reg_w(gspca_dev, 0x40, 0x0002);
 			else
 				reg_w(gspca_dev, 0x44, 0x0002);
@@ -6056,16 +5943,9 @@ static void setlightfreq(struct gspca_dev *gspca_dev)
 	}
 }
 
-static void setautogain(struct gspca_dev *gspca_dev)
+static void setautogain(struct gspca_dev *gspca_dev, s32 val)
 {
-	struct sd *sd = (struct sd *) gspca_dev;
-	u8 autoval;
-
-	if (sd->ctrls[AUTOGAIN].val)
-		autoval = 0x42;
-	else
-		autoval = 0x02;
-	reg_w(gspca_dev, autoval, 0x0180);
+	reg_w(gspca_dev, val ? 0x42 : 0x02, 0x0180);
 }
 
 /* update the transfer parameters */
@@ -6165,7 +6045,6 @@ static void transfer_update(struct work_struct *work)
 				 || !gspca_dev->present
 				 || !gspca_dev->streaming)
 					goto err;
-				sd->ctrls[QUALITY].val = jpeg_qual[sd->reg08];
 				jpeg_set_qual(sd->jpeg_hdr,
 						jpeg_qual[sd->reg08]);
 			}
@@ -6503,7 +6382,6 @@ static int sd_config(struct gspca_dev *gspca_dev,
 	/* define some sensors from the vendor/product */
 	sd->sensor = id->driver_info;
 
-	gspca_dev->cam.ctrls = sd->ctrls;
 	sd->reg08 = REG08_DEF;
 
 	INIT_WORK(&sd->work, transfer_update);
@@ -6511,10 +6389,117 @@ static int sd_config(struct gspca_dev *gspca_dev,
 	return 0;
 }
 
+static int sd_setautogain(struct gspca_dev *gspca_dev, s32 val)
+{
+	if (!gspca_dev->streaming)
+		return 0;
+	setautogain(gspca_dev, val);
+
+	return gspca_dev->usb_err;
+}
+
+static int sd_setquality(struct gspca_dev *gspca_dev, s32 val)
+{
+	struct sd *sd = (struct sd *) gspca_dev;
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(jpeg_qual) - 1; i++) {
+		if (val <= jpeg_qual[i])
+			break;
+	}
+	sd->reg08 = i;
+	if (!gspca_dev->streaming)
+		return 0;
+	jpeg_set_qual(sd->jpeg_hdr, val);
+	return gspca_dev->usb_err;
+}
+
+static int sd_set_jcomp(struct gspca_dev *gspca_dev,
+			struct v4l2_jpegcompression *jcomp)
+{
+	struct sd *sd = (struct sd *) gspca_dev;
+
+	if (sd->jpegqual) {
+		v4l2_ctrl_s_ctrl(sd->jpegqual, jcomp->quality);
+		jcomp->quality = v4l2_ctrl_g_ctrl(sd->jpegqual);
+		return gspca_dev->usb_err;
+	}
+	jcomp->quality = jpeg_qual[sd->reg08];
+	return 0;
+}
+
+static int sd_get_jcomp(struct gspca_dev *gspca_dev,
+			struct v4l2_jpegcompression *jcomp)
+{
+	struct sd *sd = (struct sd *) gspca_dev;
+
+	memset(jcomp, 0, sizeof *jcomp);
+	jcomp->quality = jpeg_qual[sd->reg08];
+	jcomp->jpeg_markers = V4L2_JPEG_MARKER_DHT
+			| V4L2_JPEG_MARKER_DQT;
+	return 0;
+}
+
+static int zcxx_g_volatile_ctrl(struct v4l2_ctrl *ctrl)
+{
+	struct sd *sd = container_of(ctrl->handler, struct sd, ctrl_handler);
+
+	switch (ctrl->id) {
+	case V4L2_CID_AUTOGAIN:
+		if (ctrl->val && sd->exposure && sd->gspca_dev.streaming)
+			sd->exposure->val = getexposure(&sd->gspca_dev);
+		break;
+	}
+	return 0;
+}
+
+static int zcxx_s_ctrl(struct v4l2_ctrl *ctrl)
+{
+	struct sd *sd = container_of(ctrl->handler, struct sd, ctrl_handler);
+	int ret;
+	int i;
+
+	switch (ctrl->id) {
+	/* gamma/brightness/contrast cluster */
+	case V4L2_CID_GAMMA:
+		setcontrast(&sd->gspca_dev, sd->gamma->val,
+				sd->brightness->val, sd->contrast->val);
+		return 0;
+	/* autogain/exposure cluster */
+	case V4L2_CID_AUTOGAIN:
+		ret = sd_setautogain(&sd->gspca_dev, ctrl->val);
+		if (!ret && !ctrl->val && sd->exposure)
+			setexposure(&sd->gspca_dev, sd->exposure->val);
+		return ret;
+	case V4L2_CID_POWER_LINE_FREQUENCY:
+		setlightfreq(&sd->gspca_dev, ctrl->val);
+		return 0;
+	case V4L2_CID_SHARPNESS:
+		setsharpness(&sd->gspca_dev, ctrl->val);
+		return 0;
+	case V4L2_CID_JPEG_COMPRESSION_QUALITY:
+		for (i = 0; i < ARRAY_SIZE(jpeg_qual) - 1; i++) {
+			if (ctrl->val <= jpeg_qual[i])
+				break;
+		}
+		if (i > 0 && i == sd->reg08 && ctrl->val < jpeg_qual[sd->reg08])
+			i--;
+		ctrl->val = jpeg_qual[i];
+		return sd_setquality(&sd->gspca_dev, ctrl->val);
+	}
+	return -EINVAL;
+}
+
+static const struct v4l2_ctrl_ops zcxx_ctrl_ops = {
+	.g_volatile_ctrl = zcxx_g_volatile_ctrl,
+	.s_ctrl = zcxx_s_ctrl,
+};
+
 /* this function is called at probe and resume time */
 static int sd_init(struct gspca_dev *gspca_dev)
 {
 	struct sd *sd = (struct sd *) gspca_dev;
+	struct v4l2_ctrl_handler *hdl = &sd->ctrl_handler;
 	struct cam *cam;
 	int sensor;
 	static const u8 gamma[SENSOR_MAX] = {
@@ -6688,7 +6673,6 @@ static int sd_init(struct gspca_dev *gspca_dev)
 		case 0x2030:
 			PDEBUG(D_PROBE, "Find Sensor PO2030");
 			sd->sensor = SENSOR_PO2030;
-			sd->ctrls[SHARPNESS].def = 0;	/* from win traces */
 			break;
 		case 0x7620:
 			PDEBUG(D_PROBE, "Find Sensor OV7620");
@@ -6730,30 +6714,40 @@ static int sd_init(struct gspca_dev *gspca_dev)
 		break;
 	}
 
-	sd->ctrls[GAMMA].def = gamma[sd->sensor];
-	sd->reg08 = reg08_tb[sd->sensor];
-	sd->ctrls[QUALITY].def = jpeg_qual[sd->reg08];
-	sd->ctrls[QUALITY].min = jpeg_qual[0];
-	sd->ctrls[QUALITY].max = jpeg_qual[ARRAY_SIZE(jpeg_qual) - 1];
-
-	switch (sd->sensor) {
-	case SENSOR_HV7131R:
-		gspca_dev->ctrl_dis = (1 << QUALITY);
-		break;
-	case SENSOR_OV7630C:
-		gspca_dev->ctrl_dis = (1 << LIGHTFREQ) | (1 << EXPOSURE);
-		break;
-	case SENSOR_PAS202B:
-		gspca_dev->ctrl_dis = (1 << QUALITY) | (1 << EXPOSURE);
-		break;
-	default:
-		gspca_dev->ctrl_dis = (1 << EXPOSURE);
-		break;
+	gspca_dev->vdev.ctrl_handler = hdl;
+	v4l2_ctrl_handler_init(hdl, 8);
+	sd->brightness = v4l2_ctrl_new_std(hdl, &zcxx_ctrl_ops,
+			V4L2_CID_BRIGHTNESS, 0, 255, 1, 128);
+	sd->contrast = v4l2_ctrl_new_std(hdl, &zcxx_ctrl_ops,
+			V4L2_CID_CONTRAST, 0, 255, 1, 128);
+	sd->gamma = v4l2_ctrl_new_std(hdl, &zcxx_ctrl_ops,
+			V4L2_CID_GAMMA, 1, 6, 1, gamma[sd->sensor]);
+	if (sd->sensor == SENSOR_HV7131R)
+		sd->exposure = v4l2_ctrl_new_std(hdl, &zcxx_ctrl_ops,
+			V4L2_CID_EXPOSURE, 0x30d, 0x493e, 1, 0x927);
+	sd->autogain = v4l2_ctrl_new_std(hdl, &zcxx_ctrl_ops,
+			V4L2_CID_AUTOGAIN, 0, 1, 1, 1);
+	if (sd->sensor != SENSOR_OV7630C && sd->sensor != SENSOR_PAS202B)
+		sd->plfreq = v4l2_ctrl_new_std_menu(hdl, &zcxx_ctrl_ops,
+			V4L2_CID_POWER_LINE_FREQUENCY,
+			V4L2_CID_POWER_LINE_FREQUENCY_60HZ, 0,
+			V4L2_CID_POWER_LINE_FREQUENCY_DISABLED);
+	sd->sharpness = v4l2_ctrl_new_std(hdl, &zcxx_ctrl_ops,
+			V4L2_CID_SHARPNESS, 0, 3, 1,
+			sd->sensor == SENSOR_PO2030 ? 0 : 2);
+	if (sd->sensor != SENSOR_HV7131R && sd->sensor != SENSOR_PAS202B)
+		sd->jpegqual = v4l2_ctrl_new_std(hdl, &zcxx_ctrl_ops,
+			V4L2_CID_JPEG_COMPRESSION_QUALITY,
+			jpeg_qual[0], jpeg_qual[ARRAY_SIZE(jpeg_qual) - 1], 1,
+			jpeg_qual[sd->reg08]);
+	if (hdl->error) {
+		pr_err("Could not initialize controls\n");
+		return hdl->error;
 	}
-#if AUTOGAIN_DEF
-	if (sd->ctrls[AUTOGAIN].val)
-		gspca_dev->ctrl_inac = (1 << EXPOSURE);
-#endif
+	v4l2_ctrl_cluster(3, &sd->gamma);
+	if (sd->sensor == SENSOR_HV7131R)
+		v4l2_ctrl_auto_cluster(2, &sd->autogain, 0, true);
+	sd->reg08 = reg08_tb[sd->sensor];
 
 	/* switch off the led */
 	reg_w(gspca_dev, 0x01, 0x0000);
@@ -6864,7 +6858,7 @@ static int sd_start(struct gspca_dev *gspca_dev)
 		reg_w(gspca_dev, 0x03, 0x0008);
 		break;
 	}
-	setsharpness(gspca_dev);
+	setsharpness(gspca_dev, v4l2_ctrl_g_ctrl(sd->sharpness));
 
 	/* set the gamma tables when not set */
 	switch (sd->sensor) {
@@ -6873,7 +6867,9 @@ static int sd_start(struct gspca_dev *gspca_dev)
 	case SENSOR_OV7630C:
 		break;
 	default:
-		setcontrast(gspca_dev);
+		setcontrast(&sd->gspca_dev, v4l2_ctrl_g_ctrl(sd->gamma),
+				v4l2_ctrl_g_ctrl(sd->brightness),
+				v4l2_ctrl_g_ctrl(sd->contrast));
 		break;
 	}
 	setmatrix(gspca_dev);			/* one more time? */
@@ -6886,7 +6882,7 @@ static int sd_start(struct gspca_dev *gspca_dev)
 	}
 	setquality(gspca_dev);
 	jpeg_set_qual(sd->jpeg_hdr, jpeg_qual[sd->reg08]);
-	setlightfreq(gspca_dev);
+	setlightfreq(gspca_dev, v4l2_ctrl_g_ctrl(sd->plfreq));
 
 	switch (sd->sensor) {
 	case SENSOR_ADCM2700:
@@ -6897,7 +6893,7 @@ static int sd_start(struct gspca_dev *gspca_dev)
 		reg_w(gspca_dev, 0x40, 0x0117);
 		break;
 	case SENSOR_HV7131R:
-		setexposure(gspca_dev);
+		setexposure(gspca_dev, v4l2_ctrl_g_ctrl(sd->exposure));
 		reg_w(gspca_dev, 0x00, ZC3XX_R1A7_CALCGLOBALMEAN);
 		break;
 	case SENSOR_GC0305:
@@ -6921,7 +6917,7 @@ static int sd_start(struct gspca_dev *gspca_dev)
 		break;
 	}
 
-	setautogain(gspca_dev);
+	setautogain(gspca_dev, v4l2_ctrl_g_ctrl(sd->autogain));
 
 	/* start the transfer update thread if needed */
 	if (gspca_dev->usb_err >= 0) {
@@ -6987,86 +6983,6 @@ static void sd_pkt_scan(struct gspca_dev *gspca_dev,
 	gspca_frame_add(gspca_dev, INTER_PACKET, data, len);
 }
 
-static int sd_setautogain(struct gspca_dev *gspca_dev, __s32 val)
-{
-	struct sd *sd = (struct sd *) gspca_dev;
-
-	sd->ctrls[AUTOGAIN].val = val;
-	if (val) {
-		gspca_dev->ctrl_inac |= (1 << EXPOSURE);
-	} else {
-		gspca_dev->ctrl_inac &= ~(1 << EXPOSURE);
-		if (gspca_dev->streaming)
-			getexposure(gspca_dev);
-	}
-	if (gspca_dev->streaming)
-		setautogain(gspca_dev);
-	return gspca_dev->usb_err;
-}
-
-static int sd_querymenu(struct gspca_dev *gspca_dev,
-			struct v4l2_querymenu *menu)
-{
-	switch (menu->id) {
-	case V4L2_CID_POWER_LINE_FREQUENCY:
-		switch (menu->index) {
-		case 0:		/* V4L2_CID_POWER_LINE_FREQUENCY_DISABLED */
-			strcpy((char *) menu->name, "NoFliker");
-			return 0;
-		case 1:		/* V4L2_CID_POWER_LINE_FREQUENCY_50HZ */
-			strcpy((char *) menu->name, "50 Hz");
-			return 0;
-		case 2:		/* V4L2_CID_POWER_LINE_FREQUENCY_60HZ */
-			strcpy((char *) menu->name, "60 Hz");
-			return 0;
-		}
-		break;
-	}
-	return -EINVAL;
-}
-
-static int sd_setquality(struct gspca_dev *gspca_dev, __s32 val)
-{
-	struct sd *sd = (struct sd *) gspca_dev;
-	int i;
-
-	for (i = 0; i < ARRAY_SIZE(jpeg_qual) - 1; i++) {
-		if (val <= jpeg_qual[i])
-			break;
-	}
-	if (i > 0
-	 && i == sd->reg08
-	 && val < jpeg_qual[sd->reg08])
-		i--;
-	sd->reg08 = i;
-	sd->ctrls[QUALITY].val = jpeg_qual[i];
-	if (gspca_dev->streaming)
-		jpeg_set_qual(sd->jpeg_hdr, sd->ctrls[QUALITY].val);
-	return gspca_dev->usb_err;
-}
-
-static int sd_set_jcomp(struct gspca_dev *gspca_dev,
-			struct v4l2_jpegcompression *jcomp)
-{
-	struct sd *sd = (struct sd *) gspca_dev;
-
-	sd_setquality(gspca_dev, jcomp->quality);
-	jcomp->quality = sd->ctrls[QUALITY].val;
-	return gspca_dev->usb_err;
-}
-
-static int sd_get_jcomp(struct gspca_dev *gspca_dev,
-			struct v4l2_jpegcompression *jcomp)
-{
-	struct sd *sd = (struct sd *) gspca_dev;
-
-	memset(jcomp, 0, sizeof *jcomp);
-	jcomp->quality = sd->ctrls[QUALITY].val;
-	jcomp->jpeg_markers = V4L2_JPEG_MARKER_DHT
-			| V4L2_JPEG_MARKER_DQT;
-	return 0;
-}
-
 #if defined(CONFIG_INPUT) || defined(CONFIG_INPUT_MODULE)
 static int sd_int_pkt_scan(struct gspca_dev *gspca_dev,
 			u8 *data,		/* interrupt packet data */
@@ -7085,14 +7001,11 @@ static int sd_int_pkt_scan(struct gspca_dev *gspca_dev,
 
 static const struct sd_desc sd_desc = {
 	.name = KBUILD_MODNAME,
-	.ctrls = sd_ctrls,
-	.nctrls = ARRAY_SIZE(sd_ctrls),
 	.config = sd_config,
 	.init = sd_init,
 	.start = sd_start,
 	.stop0 = sd_stop0,
 	.pkt_scan = sd_pkt_scan,
-	.querymenu = sd_querymenu,
 	.get_jcomp = sd_get_jcomp,
 	.set_jcomp = sd_set_jcomp,
 #if defined(CONFIG_INPUT) || defined(CONFIG_INPUT_MODULE)
-- 
1.7.10

