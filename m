Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:2307 "EHLO
	smtp-vbr4.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753498Ab2EFM2q (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 6 May 2012 08:28:46 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans de Goede <hdegoede@redhat.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv2 PATCH 14/17] gspca-zc3xx: convert to the control framework.
Date: Sun,  6 May 2012 14:28:28 +0200
Message-Id: <fe9af0b4cb46fe83b36a7572f04d88052e50c832.1336305565.git.hans.verkuil@cisco.com>
In-Reply-To: <1336307311-10227-1-git-send-email-hverkuil@xs4all.nl>
References: <1336307311-10227-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <a5a075c580858f4484be5c4cfadd195492858505.1336305565.git.hans.verkuil@cisco.com>
References: <a5a075c580858f4484be5c4cfadd195492858505.1336305565.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The initial version was done by HV, corrections were made by HdG, and some
final small changes again by HV.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 drivers/media/video/gspca/zc3xx.c |  441 +++++++++++++++----------------------
 1 file changed, 172 insertions(+), 269 deletions(-)

diff --git a/drivers/media/video/gspca/zc3xx.c b/drivers/media/video/gspca/zc3xx.c
index a8282b8..86d6d66 100644
--- a/drivers/media/video/gspca/zc3xx.c
+++ b/drivers/media/video/gspca/zc3xx.c
@@ -22,6 +22,7 @@
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
 #include <linux/input.h>
+#include <media/v4l2-ctrls.h>
 #include "gspca.h"
 #include "jpeg.h"
 
@@ -35,26 +36,23 @@ static int force_sensor = -1;
 #define REG08_DEF 3		/* default JPEG compression (75%) */
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
@@ -94,114 +92,6 @@ enum sensors {
 	SENSOR_MAX
 };
 
-/* V4L2 controls supported by the driver */
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
-		.minimum = 50,
-		.maximum = 87,
-		.step    = 1,
-		.default_value = 75,
-	    },
-	    .set = sd_setquality
-	},
-};
-
 static const struct v4l2_pix_format vga_mode[] = {
 	{320, 240, V4L2_PIX_FMT_JPEG, V4L2_FIELD_NONE,
 		.bytesperline = 320,
@@ -5821,10 +5711,8 @@ static void setmatrix(struct gspca_dev *gspca_dev)
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
@@ -5832,19 +5720,18 @@ static void setsharpness(struct gspca_dev *gspca_dev)
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
@@ -5867,10 +5754,10 @@ static void setcontrast(struct gspca_dev *gspca_dev)
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
@@ -5897,25 +5784,15 @@ static void setcontrast(struct gspca_dev *gspca_dev)
 		reg_w(gspca_dev, gr[i], 0x0130 + i);	/* gradient */
 }
 
-static void getexposure(struct gspca_dev *gspca_dev)
+static s32 getexposure(struct gspca_dev *gspca_dev)
 {
-	struct sd *sd = (struct sd *) gspca_dev;
-
-	if (sd->sensor != SENSOR_HV7131R)
-		return;
-	sd->ctrls[EXPOSURE].val = (i2c_read(gspca_dev, 0x25) << 9)
+	return (i2c_read(gspca_dev, 0x25) << 9)
 		| (i2c_read(gspca_dev, 0x26) << 1)
 		| (i2c_read(gspca_dev, 0x27) >> 7);
 }
 
-static void setexposure(struct gspca_dev *gspca_dev)
+static void setexposure(struct gspca_dev *gspca_dev, s32 val)
 {
-	struct sd *sd = (struct sd *) gspca_dev;
-	int val;
-
-	if (sd->sensor != SENSOR_HV7131R)
-		return;
-	val = sd->ctrls[EXPOSURE].val;
 	i2c_write(gspca_dev, 0x25, val >> 9, 0x00);
 	i2c_write(gspca_dev, 0x26, val >> 1, 0x00);
 	i2c_write(gspca_dev, 0x27, val << 7, 0x00);
@@ -5934,7 +5811,7 @@ static void setquality(struct gspca_dev *gspca_dev)
  *	60Hz, for American lighting
  *	0 = No Fliker (for outdoore usage)
  */
-static void setlightfreq(struct gspca_dev *gspca_dev)
+static void setlightfreq(struct gspca_dev *gspca_dev, s32 val)
 {
 	struct sd *sd = (struct sd *) gspca_dev;
 	int i, mode;
@@ -6018,7 +5895,7 @@ static void setlightfreq(struct gspca_dev *gspca_dev)
 		 tas5130c_60HZ, tas5130c_60HZScale},
 	};
 
-	i = sd->ctrls[LIGHTFREQ].val * 2;
+	i = val * 2;
 	mode = gspca_dev->cam.cam_mode[gspca_dev->curr_mode].priv;
 	if (mode)
 		i++;			/* 320x240 */
@@ -6028,14 +5905,14 @@ static void setlightfreq(struct gspca_dev *gspca_dev)
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
@@ -6047,16 +5924,9 @@ static void setlightfreq(struct gspca_dev *gspca_dev)
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
 
 /*
@@ -6078,7 +5948,7 @@ static void transfer_update(struct work_struct *work)
 		msleep(100);
 
 		mutex_lock(&gspca_dev->usb_lock);
-		if (!gspca_dev->present || !gspca_dev->streaming)
+		if (gspca_dev->frozen || !gspca_dev->present || !gspca_dev->streaming)
 			goto err;
 
 		/* Bit 0 of register 11 indicates FIFO overflow */
@@ -6449,7 +6319,6 @@ static int sd_config(struct gspca_dev *gspca_dev,
 	/* define some sensors from the vendor/product */
 	sd->sensor = id->driver_info;
 
-	gspca_dev->cam.ctrls = sd->ctrls;
 	sd->reg08 = REG08_DEF;
 
 	INIT_WORK(&sd->work, transfer_update);
@@ -6457,12 +6326,85 @@ static int sd_config(struct gspca_dev *gspca_dev,
 	return 0;
 }
 
-/* this function is called at probe and resume time */
-static int sd_init(struct gspca_dev *gspca_dev)
+static int zcxx_g_volatile_ctrl(struct v4l2_ctrl *ctrl)
 {
-	struct sd *sd = (struct sd *) gspca_dev;
-	struct cam *cam;
-	int sensor;
+	struct sd *sd = container_of(ctrl->handler, struct sd, ctrl_handler);
+	struct gspca_dev *gspca_dev = &sd->gspca_dev;
+
+	switch (ctrl->id) {
+	case V4L2_CID_AUTOGAIN:
+		gspca_dev->usb_err = 0;
+		if (ctrl->val && sd->exposure && gspca_dev->streaming)
+			sd->exposure->val = getexposure(gspca_dev);
+		return gspca_dev->usb_err;
+	}
+	return -EINVAL;
+}
+
+static int zcxx_s_ctrl(struct v4l2_ctrl *ctrl)
+{
+	struct sd *sd = container_of(ctrl->handler, struct sd, ctrl_handler);
+	struct gspca_dev *gspca_dev = &sd->gspca_dev;
+	int i, qual;
+
+	gspca_dev->usb_err = 0;
+
+	if (ctrl->id == V4L2_CID_JPEG_COMPRESSION_QUALITY) {
+		qual = sd->reg08 >> 1;
+
+		for (i = 0; i < ARRAY_SIZE(jpeg_qual); i++) {
+			if (ctrl->val <= jpeg_qual[i])
+				break;
+		}
+		if (i > 0 && i == qual && ctrl->val < jpeg_qual[i])
+			i--;
+
+		/* With high quality settings we need max bandwidth */
+		if (i >= 2 && gspca_dev->streaming &&
+		    !gspca_dev->cam.needs_full_bandwidth)
+			return -EBUSY;
+
+		sd->reg08 = (i << 1) | 1;
+		ctrl->val = jpeg_qual[i];
+	}
+
+	if (!gspca_dev->streaming)
+		return 0;
+
+	switch (ctrl->id) {
+	/* gamma/brightness/contrast cluster */
+	case V4L2_CID_GAMMA:
+		setcontrast(gspca_dev, sd->gamma->val,
+				sd->brightness->val, sd->contrast->val);
+		break;
+	/* autogain/exposure cluster */
+	case V4L2_CID_AUTOGAIN:
+		setautogain(gspca_dev, ctrl->val);
+		if (!gspca_dev->usb_err && !ctrl->val && sd->exposure)
+			setexposure(gspca_dev, sd->exposure->val);
+		break;
+	case V4L2_CID_POWER_LINE_FREQUENCY:
+		setlightfreq(gspca_dev, ctrl->val);
+		break;
+	case V4L2_CID_SHARPNESS:
+		setsharpness(gspca_dev, ctrl->val);
+		break;
+	case V4L2_CID_JPEG_COMPRESSION_QUALITY:
+		setquality(gspca_dev);
+		break;
+	}
+	return gspca_dev->usb_err;
+}
+
+static const struct v4l2_ctrl_ops zcxx_ctrl_ops = {
+	.g_volatile_ctrl = zcxx_g_volatile_ctrl,
+	.s_ctrl = zcxx_s_ctrl,
+};
+
+static int sd_init_controls(struct gspca_dev *gspca_dev)
+{
+	struct sd *sd = (struct sd *)gspca_dev;
+	struct v4l2_ctrl_handler *hdl = &sd->ctrl_handler;
 	static const u8 gamma[SENSOR_MAX] = {
 		[SENSOR_ADCM2700] =	4,
 		[SENSOR_CS2102] =	4,
@@ -6484,6 +6426,48 @@ static int sd_init(struct gspca_dev *gspca_dev)
 		[SENSOR_PO2030] =	4,
 		[SENSOR_TAS5130C] =	3,
 	};
+
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
+	if (sd->sensor != SENSOR_OV7630C)
+		sd->plfreq = v4l2_ctrl_new_std_menu(hdl, &zcxx_ctrl_ops,
+			V4L2_CID_POWER_LINE_FREQUENCY,
+			V4L2_CID_POWER_LINE_FREQUENCY_60HZ, 0,
+			V4L2_CID_POWER_LINE_FREQUENCY_DISABLED);
+	sd->sharpness = v4l2_ctrl_new_std(hdl, &zcxx_ctrl_ops,
+			V4L2_CID_SHARPNESS, 0, 3, 1,
+			sd->sensor == SENSOR_PO2030 ? 0 : 2);
+	sd->jpegqual = v4l2_ctrl_new_std(hdl, &zcxx_ctrl_ops,
+			V4L2_CID_JPEG_COMPRESSION_QUALITY,
+			jpeg_qual[0], jpeg_qual[ARRAY_SIZE(jpeg_qual) - 1], 1,
+			jpeg_qual[REG08_DEF >> 1]);
+	if (hdl->error) {
+		pr_err("Could not initialize controls\n");
+		return hdl->error;
+	}
+	v4l2_ctrl_cluster(3, &sd->gamma);
+	if (sd->sensor == SENSOR_HV7131R)
+		v4l2_ctrl_auto_cluster(2, &sd->autogain, 0, true);
+	return 0;
+}
+
+/* this function is called at probe and resume time */
+static int sd_init(struct gspca_dev *gspca_dev)
+{
+	struct sd *sd = (struct sd *) gspca_dev;
+	struct cam *cam;
+	int sensor;
 	static const u8 mode_tb[SENSOR_MAX] = {
 		[SENSOR_ADCM2700] =	2,
 		[SENSOR_CS2102] =	1,
@@ -6613,7 +6597,6 @@ static int sd_init(struct gspca_dev *gspca_dev)
 		case 0x2030:
 			PDEBUG(D_PROBE, "Find Sensor PO2030");
 			sd->sensor = SENSOR_PO2030;
-			sd->ctrls[SHARPNESS].def = 0;	/* from win traces */
 			break;
 		case 0x7620:
 			PDEBUG(D_PROBE, "Find Sensor OV7620");
@@ -6655,26 +6638,6 @@ static int sd_init(struct gspca_dev *gspca_dev)
 		break;
 	}
 
-	sd->ctrls[GAMMA].def = gamma[sd->sensor];
-	sd->ctrls[QUALITY].def = jpeg_qual[sd->reg08 >> 1];
-	sd->ctrls[QUALITY].min = jpeg_qual[0];
-	sd->ctrls[QUALITY].max = jpeg_qual[ARRAY_SIZE(jpeg_qual) - 1];
-
-	switch (sd->sensor) {
-	case SENSOR_HV7131R:
-		break;
-	case SENSOR_OV7630C:
-		gspca_dev->ctrl_dis = (1 << LIGHTFREQ) | (1 << EXPOSURE);
-		break;
-	default:
-		gspca_dev->ctrl_dis = (1 << EXPOSURE);
-		break;
-	}
-#if AUTOGAIN_DEF
-	if (sd->ctrls[AUTOGAIN].val)
-		gspca_dev->ctrl_inac = (1 << EXPOSURE);
-#endif
-
 	/* switch off the led */
 	reg_w(gspca_dev, 0x01, 0x0000);
 	return gspca_dev->usb_err;
@@ -6791,7 +6754,7 @@ static int sd_start(struct gspca_dev *gspca_dev)
 		reg_w(gspca_dev, 0x03, 0x0008);
 		break;
 	}
-	setsharpness(gspca_dev);
+	setsharpness(gspca_dev, v4l2_ctrl_g_ctrl(sd->sharpness));
 
 	/* set the gamma tables when not set */
 	switch (sd->sensor) {
@@ -6800,7 +6763,9 @@ static int sd_start(struct gspca_dev *gspca_dev)
 	case SENSOR_OV7630C:
 		break;
 	default:
-		setcontrast(gspca_dev);
+		setcontrast(gspca_dev, v4l2_ctrl_g_ctrl(sd->gamma),
+				v4l2_ctrl_g_ctrl(sd->brightness),
+				v4l2_ctrl_g_ctrl(sd->contrast));
 		break;
 	}
 	setmatrix(gspca_dev);			/* one more time? */
@@ -6814,7 +6779,8 @@ static int sd_start(struct gspca_dev *gspca_dev)
 	setquality(gspca_dev);
 	/* Start with BRC disabled, transfer_update will enable it if needed */
 	reg_w(gspca_dev, 0x00, 0x0007);
-	setlightfreq(gspca_dev);
+	if (sd->plfreq)
+		setlightfreq(gspca_dev, v4l2_ctrl_g_ctrl(sd->plfreq));
 
 	switch (sd->sensor) {
 	case SENSOR_ADCM2700:
@@ -6825,7 +6791,7 @@ static int sd_start(struct gspca_dev *gspca_dev)
 		reg_w(gspca_dev, 0x40, 0x0117);
 		break;
 	case SENSOR_HV7131R:
-		setexposure(gspca_dev);
+		setexposure(gspca_dev, v4l2_ctrl_g_ctrl(sd->exposure));
 		reg_w(gspca_dev, 0x00, ZC3XX_R1A7_CALCGLOBALMEAN);
 		break;
 	case SENSOR_GC0305:
@@ -6849,7 +6815,7 @@ static int sd_start(struct gspca_dev *gspca_dev)
 		break;
 	}
 
-	setautogain(gspca_dev);
+	setautogain(gspca_dev, v4l2_ctrl_g_ctrl(sd->autogain));
 
 	if (gspca_dev->usb_err < 0)
 		return gspca_dev->usb_err;
@@ -6910,79 +6876,17 @@ static void sd_pkt_scan(struct gspca_dev *gspca_dev,
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
-	int i, qual = sd->reg08 >> 1;
-
-	for (i = 0; i < ARRAY_SIZE(jpeg_qual); i++) {
-		if (val <= jpeg_qual[i])
-			break;
-	}
-	if (i > 0
-	 && i == qual
-	 && val < jpeg_qual[i])
-		i--;
-
-	/* With high quality settings we need max bandwidth */
-	if (i >= 2 && gspca_dev->streaming &&
-	    !gspca_dev->cam.needs_full_bandwidth)
-		return -EBUSY;
-
-	sd->reg08 = (i << 1) | 1;
-	sd->ctrls[QUALITY].val = jpeg_qual[i];
-
-	if (gspca_dev->streaming)
-		setquality(gspca_dev);
-	return gspca_dev->usb_err;
-}
-
 static int sd_set_jcomp(struct gspca_dev *gspca_dev,
 			struct v4l2_jpegcompression *jcomp)
 {
 	struct sd *sd = (struct sd *) gspca_dev;
+	int ret;
 
-	sd_setquality(gspca_dev, jcomp->quality);
-	jcomp->quality = sd->ctrls[QUALITY].val;
-	return gspca_dev->usb_err;
+	ret = v4l2_ctrl_s_ctrl(sd->jpegqual, jcomp->quality);
+	if (ret)
+		return ret;
+	jcomp->quality = v4l2_ctrl_g_ctrl(sd->jpegqual);
+	return 0;
 }
 
 static int sd_get_jcomp(struct gspca_dev *gspca_dev,
@@ -6991,7 +6895,7 @@ static int sd_get_jcomp(struct gspca_dev *gspca_dev,
 	struct sd *sd = (struct sd *) gspca_dev;
 
 	memset(jcomp, 0, sizeof *jcomp);
-	jcomp->quality = sd->ctrls[QUALITY].val;
+	jcomp->quality = v4l2_ctrl_g_ctrl(sd->jpegqual);
 	jcomp->jpeg_markers = V4L2_JPEG_MARKER_DHT
 			| V4L2_JPEG_MARKER_DQT;
 	return 0;
@@ -7015,15 +6919,13 @@ static int sd_int_pkt_scan(struct gspca_dev *gspca_dev,
 
 static const struct sd_desc sd_desc = {
 	.name = KBUILD_MODNAME,
-	.ctrls = sd_ctrls,
-	.nctrls = ARRAY_SIZE(sd_ctrls),
 	.config = sd_config,
 	.init = sd_init,
+	.init_controls = sd_init_controls,
 	.isoc_init = sd_pre_start,
 	.start = sd_start,
 	.stop0 = sd_stop0,
 	.pkt_scan = sd_pkt_scan,
-	.querymenu = sd_querymenu,
 	.get_jcomp = sd_get_jcomp,
 	.set_jcomp = sd_set_jcomp,
 #if defined(CONFIG_INPUT) || defined(CONFIG_INPUT_MODULE)
@@ -7107,6 +7009,7 @@ static struct usb_driver sd_driver = {
 #ifdef CONFIG_PM
 	.suspend = gspca_suspend,
 	.resume = gspca_resume,
+	.reset_resume = gspca_resume,
 #endif
 };
 
-- 
1.7.10

