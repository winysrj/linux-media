Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp205.alice.it ([82.57.200.101]:36372 "EHLO smtp205.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754397Ab2EPVmz (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 16 May 2012 17:42:55 -0400
From: Antonio Ospite <ospite@studenti.unina.it>
To: linux-media@vger.kernel.org
Cc: Antonio Ospite <ospite@studenti.unina.it>,
	Hans de Goede <hdegoede@redhat.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Jean-Francois Moine <moinejf@free.fr>
Subject: [PATCH 3/3] gspca_ov534: Convert to the control framework
Date: Wed, 16 May 2012 23:42:46 +0200
Message-Id: <1337204566-2212-4-git-send-email-ospite@studenti.unina.it>
In-Reply-To: <1337204566-2212-1-git-send-email-ospite@studenti.unina.it>
References: <1337204566-2212-1-git-send-email-ospite@studenti.unina.it>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Antonio Ospite <ospite@studenti.unina.it>
---
 drivers/media/video/gspca/ov534.c |  569 +++++++++++++++++--------------------
 1 file changed, 267 insertions(+), 302 deletions(-)

diff --git a/drivers/media/video/gspca/ov534.c b/drivers/media/video/gspca/ov534.c
index c16bd1b..9f0f93c 100644
--- a/drivers/media/video/gspca/ov534.c
+++ b/drivers/media/video/gspca/ov534.c
@@ -35,6 +35,7 @@
 #include "gspca.h"
 
 #include <linux/fixp-arith.h>
+#include <media/v4l2-ctrls.h>
 
 #define OV534_REG_ADDRESS	0xf1	/* sensor address */
 #define OV534_REG_SUBADDR	0xf2
@@ -53,29 +54,28 @@ MODULE_AUTHOR("Antonio Ospite <ospite@studenti.unina.it>");
 MODULE_DESCRIPTION("GSPCA/OV534 USB Camera Driver");
 MODULE_LICENSE("GPL");
 
-/* controls */
-enum e_ctrl {
-	HUE,
-	SATURATION,
-	BRIGHTNESS,
-	CONTRAST,
-	GAIN,
-	EXPOSURE,
-	AGC,
-	AWB,
-	AEC,
-	SHARPNESS,
-	HFLIP,
-	VFLIP,
-	LIGHTFREQ,
-	NCTRLS		/* number of controls */
-};
-
 /* specific webcam descriptor */
 struct sd {
 	struct gspca_dev gspca_dev;	/* !! must be the first item */
 
-	struct gspca_ctrl ctrls[NCTRLS];
+	struct v4l2_ctrl_handler ctrl_handler;
+	struct v4l2_ctrl *hue;
+	struct v4l2_ctrl *saturation;
+	struct v4l2_ctrl *brightness;
+	struct v4l2_ctrl *contrast;
+	struct { /* gain control cluster */
+		struct v4l2_ctrl *autogain;
+		struct v4l2_ctrl *gain;
+	};
+	struct v4l2_ctrl *autowhitebalance;
+	struct { /* exposure control cluster */
+		struct v4l2_ctrl *autoexposure;
+		struct v4l2_ctrl *exposure;
+	};
+	struct v4l2_ctrl *sharpness;
+	struct v4l2_ctrl *hflip;
+	struct v4l2_ctrl *vflip;
+	struct v4l2_ctrl *plfreq;
 
 	__u32 last_pts;
 	u16 last_fid;
@@ -89,181 +89,9 @@ enum sensors {
 	NSENSORS
 };
 
-/* V4L2 controls supported by the driver */
-static void sethue(struct gspca_dev *gspca_dev);
-static void setsaturation(struct gspca_dev *gspca_dev);
-static void setbrightness(struct gspca_dev *gspca_dev);
-static void setcontrast(struct gspca_dev *gspca_dev);
-static void setgain(struct gspca_dev *gspca_dev);
-static void setexposure(struct gspca_dev *gspca_dev);
-static void setagc(struct gspca_dev *gspca_dev);
-static void setawb(struct gspca_dev *gspca_dev);
-static void setaec(struct gspca_dev *gspca_dev);
-static void setsharpness(struct gspca_dev *gspca_dev);
-static void sethvflip(struct gspca_dev *gspca_dev);
-static void setlightfreq(struct gspca_dev *gspca_dev);
-
 static int sd_start(struct gspca_dev *gspca_dev);
 static void sd_stopN(struct gspca_dev *gspca_dev);
 
-static const struct ctrl sd_ctrls[] = {
-[HUE] = {
-		{
-			.id      = V4L2_CID_HUE,
-			.type    = V4L2_CTRL_TYPE_INTEGER,
-			.name    = "Hue",
-			.minimum = -90,
-			.maximum = 90,
-			.step    = 1,
-			.default_value = 0,
-		},
-		.set_control = sethue
-	},
-[SATURATION] = {
-		{
-			.id      = V4L2_CID_SATURATION,
-			.type    = V4L2_CTRL_TYPE_INTEGER,
-			.name    = "Saturation",
-			.minimum = 0,
-			.maximum = 255,
-			.step    = 1,
-			.default_value = 64,
-		},
-		.set_control = setsaturation
-	},
-[BRIGHTNESS] = {
-		{
-			.id      = V4L2_CID_BRIGHTNESS,
-			.type    = V4L2_CTRL_TYPE_INTEGER,
-			.name    = "Brightness",
-			.minimum = 0,
-			.maximum = 255,
-			.step    = 1,
-			.default_value = 0,
-		},
-		.set_control = setbrightness
-	},
-[CONTRAST] = {
-		{
-			.id      = V4L2_CID_CONTRAST,
-			.type    = V4L2_CTRL_TYPE_INTEGER,
-			.name    = "Contrast",
-			.minimum = 0,
-			.maximum = 255,
-			.step    = 1,
-			.default_value = 32,
-		},
-		.set_control = setcontrast
-	},
-[GAIN] = {
-		{
-			.id      = V4L2_CID_GAIN,
-			.type    = V4L2_CTRL_TYPE_INTEGER,
-			.name    = "Main Gain",
-			.minimum = 0,
-			.maximum = 63,
-			.step    = 1,
-			.default_value = 20,
-		},
-		.set_control = setgain
-	},
-[EXPOSURE] = {
-		{
-			.id      = V4L2_CID_EXPOSURE,
-			.type    = V4L2_CTRL_TYPE_INTEGER,
-			.name    = "Exposure",
-			.minimum = 0,
-			.maximum = 255,
-			.step    = 1,
-			.default_value = 120,
-		},
-		.set_control = setexposure
-	},
-[AGC] = {
-		{
-			.id      = V4L2_CID_AUTOGAIN,
-			.type    = V4L2_CTRL_TYPE_BOOLEAN,
-			.name    = "Auto Gain",
-			.minimum = 0,
-			.maximum = 1,
-			.step    = 1,
-			.default_value = 1,
-		},
-		.set_control = setagc
-	},
-[AWB] = {
-		{
-			.id      = V4L2_CID_AUTO_WHITE_BALANCE,
-			.type    = V4L2_CTRL_TYPE_BOOLEAN,
-			.name    = "Auto White Balance",
-			.minimum = 0,
-			.maximum = 1,
-			.step    = 1,
-			.default_value = 1,
-		},
-		.set_control = setawb
-	},
-[AEC] = {
-		{
-			.id      = V4L2_CID_EXPOSURE_AUTO,
-			.type    = V4L2_CTRL_TYPE_BOOLEAN,
-			.name    = "Auto Exposure",
-			.minimum = 0,
-			.maximum = 1,
-			.step    = 1,
-			.default_value = 1,
-		},
-		.set_control = setaec
-	},
-[SHARPNESS] = {
-		{
-			.id      = V4L2_CID_SHARPNESS,
-			.type    = V4L2_CTRL_TYPE_INTEGER,
-			.name    = "Sharpness",
-			.minimum = 0,
-			.maximum = 63,
-			.step    = 1,
-			.default_value = 0,
-		},
-		.set_control = setsharpness
-	},
-[HFLIP] = {
-		{
-			.id      = V4L2_CID_HFLIP,
-			.type    = V4L2_CTRL_TYPE_BOOLEAN,
-			.name    = "HFlip",
-			.minimum = 0,
-			.maximum = 1,
-			.step    = 1,
-			.default_value = 0,
-		},
-		.set_control = sethvflip
-	},
-[VFLIP] = {
-		{
-			.id      = V4L2_CID_VFLIP,
-			.type    = V4L2_CTRL_TYPE_BOOLEAN,
-			.name    = "VFlip",
-			.minimum = 0,
-			.maximum = 1,
-			.step    = 1,
-			.default_value = 0,
-		},
-		.set_control = sethvflip
-	},
-[LIGHTFREQ] = {
-		{
-			.id      = V4L2_CID_POWER_LINE_FREQUENCY,
-			.type    = V4L2_CTRL_TYPE_MENU,
-			.name    = "Light Frequency Filter",
-			.minimum = 0,
-			.maximum = 1,
-			.step    = 1,
-			.default_value = 0,
-		},
-		.set_control = setlightfreq
-	},
-};
 
 static const struct v4l2_pix_format ov772x_mode[] = {
 	{320, 240, V4L2_PIX_FMT_YUYV, V4L2_FIELD_NONE,
@@ -971,12 +799,10 @@ static void set_frame_rate(struct gspca_dev *gspca_dev)
 	PDEBUG(D_PROBE, "frame_rate: %d", r->fps);
 }
 
-static void sethue(struct gspca_dev *gspca_dev)
+static void sethue(struct gspca_dev *gspca_dev, s32 val)
 {
 	struct sd *sd = (struct sd *) gspca_dev;
-	int val;
 
-	val = sd->ctrls[HUE].val;
 	if (sd->sensor == SENSOR_OV767x) {
 		/* TBD */
 	} else {
@@ -1013,12 +839,10 @@ static void sethue(struct gspca_dev *gspca_dev)
 	}
 }
 
-static void setsaturation(struct gspca_dev *gspca_dev)
+static void setsaturation(struct gspca_dev *gspca_dev, s32 val)
 {
 	struct sd *sd = (struct sd *) gspca_dev;
-	int val;
 
-	val = sd->ctrls[SATURATION].val;
 	if (sd->sensor == SENSOR_OV767x) {
 		int i;
 		static u8 color_tb[][6] = {
@@ -1039,12 +863,10 @@ static void setsaturation(struct gspca_dev *gspca_dev)
 	}
 }
 
-static void setbrightness(struct gspca_dev *gspca_dev)
+static void setbrightness(struct gspca_dev *gspca_dev, s32 val)
 {
 	struct sd *sd = (struct sd *) gspca_dev;
-	int val;
 
-	val = sd->ctrls[BRIGHTNESS].val;
 	if (sd->sensor == SENSOR_OV767x) {
 		if (val < 0)
 			val = 0x80 - val;
@@ -1054,27 +876,18 @@ static void setbrightness(struct gspca_dev *gspca_dev)
 	}
 }
 
-static void setcontrast(struct gspca_dev *gspca_dev)
+static void setcontrast(struct gspca_dev *gspca_dev, s32 val)
 {
 	struct sd *sd = (struct sd *) gspca_dev;
-	u8 val;
 
-	val = sd->ctrls[CONTRAST].val;
 	if (sd->sensor == SENSOR_OV767x)
 		sccb_reg_write(gspca_dev, 0x56, val);	/* contras */
 	else
 		sccb_reg_write(gspca_dev, 0x9c, val);
 }
 
-static void setgain(struct gspca_dev *gspca_dev)
+static void setgain(struct gspca_dev *gspca_dev, s32 val)
 {
-	struct sd *sd = (struct sd *) gspca_dev;
-	u8 val;
-
-	if (sd->ctrls[AGC].val)
-		return;
-
-	val = sd->ctrls[GAIN].val;
 	switch (val & 0x30) {
 	case 0x00:
 		val &= 0x0f;
@@ -1096,15 +909,15 @@ static void setgain(struct gspca_dev *gspca_dev)
 	sccb_reg_write(gspca_dev, 0x00, val);
 }
 
-static void setexposure(struct gspca_dev *gspca_dev)
+static s32 getgain(struct gspca_dev *gspca_dev)
 {
-	struct sd *sd = (struct sd *) gspca_dev;
-	u8 val;
+	return sccb_reg_read(gspca_dev, 0x00);
+}
 
-	if (sd->ctrls[AEC].val)
-		return;
+static void setexposure(struct gspca_dev *gspca_dev, s32 val)
+{
+	struct sd *sd = (struct sd *) gspca_dev;
 
-	val = sd->ctrls[EXPOSURE].val;
 	if (sd->sensor == SENSOR_OV767x) {
 
 		/* set only aec[9:2] */
@@ -1122,11 +935,23 @@ static void setexposure(struct gspca_dev *gspca_dev)
 	}
 }
 
-static void setagc(struct gspca_dev *gspca_dev)
+static s32 getexposure(struct gspca_dev *gspca_dev)
 {
 	struct sd *sd = (struct sd *) gspca_dev;
 
-	if (sd->ctrls[AGC].val) {
+	if (sd->sensor == SENSOR_OV767x) {
+		/* get only aec[9:2] */
+		return sccb_reg_read(gspca_dev, 0x10);	/* aech */
+	} else {
+		u8 hi = sccb_reg_read(gspca_dev, 0x08);
+		u8 lo = sccb_reg_read(gspca_dev, 0x10);
+		return (hi << 8 | lo) >> 1;
+	}
+}
+
+static void setagc(struct gspca_dev *gspca_dev, s32 val)
+{
+	if (val) {
 		sccb_reg_write(gspca_dev, 0x13,
 				sccb_reg_read(gspca_dev, 0x13) | 0x04);
 		sccb_reg_write(gspca_dev, 0x64,
@@ -1136,16 +961,14 @@ static void setagc(struct gspca_dev *gspca_dev)
 				sccb_reg_read(gspca_dev, 0x13) & ~0x04);
 		sccb_reg_write(gspca_dev, 0x64,
 				sccb_reg_read(gspca_dev, 0x64) & ~0x03);
-
-		setgain(gspca_dev);
 	}
 }
 
-static void setawb(struct gspca_dev *gspca_dev)
+static void setawb(struct gspca_dev *gspca_dev, s32 val)
 {
 	struct sd *sd = (struct sd *) gspca_dev;
 
-	if (sd->ctrls[AWB].val) {
+	if (val) {
 		sccb_reg_write(gspca_dev, 0x13,
 				sccb_reg_read(gspca_dev, 0x13) | 0x02);
 		if (sd->sensor == SENSOR_OV772x)
@@ -1160,7 +983,7 @@ static void setawb(struct gspca_dev *gspca_dev)
 	}
 }
 
-static void setaec(struct gspca_dev *gspca_dev)
+static void setaec(struct gspca_dev *gspca_dev, s32 val)
 {
 	struct sd *sd = (struct sd *) gspca_dev;
 	u8 data;
@@ -1168,31 +991,25 @@ static void setaec(struct gspca_dev *gspca_dev)
 	data = sd->sensor == SENSOR_OV767x ?
 			0x05 :		/* agc + aec */
 			0x01;		/* agc */
-	if (sd->ctrls[AEC].val)
+	switch (val) {
+	case V4L2_EXPOSURE_AUTO:
 		sccb_reg_write(gspca_dev, 0x13,
 				sccb_reg_read(gspca_dev, 0x13) | data);
-	else {
+		break;
+	case V4L2_EXPOSURE_MANUAL:
 		sccb_reg_write(gspca_dev, 0x13,
 				sccb_reg_read(gspca_dev, 0x13) & ~data);
-		if (sd->sensor == SENSOR_OV767x)
-			sd->ctrls[EXPOSURE].val =
-				sccb_reg_read(gspca_dev, 10);	/* aech */
-		else
-			setexposure(gspca_dev);
+		break;
 	}
 }
 
-static void setsharpness(struct gspca_dev *gspca_dev)
+static void setsharpness(struct gspca_dev *gspca_dev, s32 val)
 {
-	struct sd *sd = (struct sd *) gspca_dev;
-	u8 val;
-
-	val = sd->ctrls[SHARPNESS].val;
 	sccb_reg_write(gspca_dev, 0x91, val);	/* Auto de-noise threshold */
 	sccb_reg_write(gspca_dev, 0x8e, val);	/* De-noise threshold */
 }
 
-static void sethvflip(struct gspca_dev *gspca_dev)
+static void sethvflip(struct gspca_dev *gspca_dev, s32 hflip, s32 vflip)
 {
 	struct sd *sd = (struct sd *) gspca_dev;
 	u8 val;
@@ -1200,28 +1017,27 @@ static void sethvflip(struct gspca_dev *gspca_dev)
 	if (sd->sensor == SENSOR_OV767x) {
 		val = sccb_reg_read(gspca_dev, 0x1e);	/* mvfp */
 		val &= ~0x30;
-		if (sd->ctrls[HFLIP].val)
+		if (hflip)
 			val |= 0x20;
-		if (sd->ctrls[VFLIP].val)
+		if (vflip)
 			val |= 0x10;
 		sccb_reg_write(gspca_dev, 0x1e, val);
 	} else {
 		val = sccb_reg_read(gspca_dev, 0x0c);
 		val &= ~0xc0;
-		if (sd->ctrls[HFLIP].val == 0)
+		if (hflip == 0)
 			val |= 0x40;
-		if (sd->ctrls[VFLIP].val == 0)
+		if (vflip == 0)
 			val |= 0x80;
 		sccb_reg_write(gspca_dev, 0x0c, val);
 	}
 }
 
-static void setlightfreq(struct gspca_dev *gspca_dev)
+static void setlightfreq(struct gspca_dev *gspca_dev, s32 val)
 {
 	struct sd *sd = (struct sd *) gspca_dev;
-	u8 val;
 
-	val = sd->ctrls[LIGHTFREQ].val ? 0x9e : 0x00;
+	val = val ? 0x9e : 0x00;
 	if (sd->sensor == SENSOR_OV767x) {
 		sccb_reg_write(gspca_dev, 0x2a, 0x00);
 		if (val)
@@ -1240,8 +1056,6 @@ static int sd_config(struct gspca_dev *gspca_dev,
 
 	cam = &gspca_dev->cam;
 
-	cam->ctrls = sd->ctrls;
-
 	cam->cam_mode = ov772x_mode;
 	cam->nmodes = ARRAY_SIZE(ov772x_mode);
 
@@ -1250,6 +1064,195 @@ static int sd_config(struct gspca_dev *gspca_dev,
 	return 0;
 }
 
+static int ov534_g_volatile_ctrl(struct v4l2_ctrl *ctrl)
+{
+	struct sd *sd = container_of(ctrl->handler, struct sd, ctrl_handler);
+	struct gspca_dev *gspca_dev = &sd->gspca_dev;
+
+	switch (ctrl->id) {
+	case V4L2_CID_AUTOGAIN:
+		gspca_dev->usb_err = 0;
+		if (ctrl->val && sd->gain && gspca_dev->streaming)
+			sd->gain->val = getgain(gspca_dev);
+		return gspca_dev->usb_err;
+
+	case V4L2_CID_EXPOSURE_AUTO:
+		gspca_dev->usb_err = 0;
+		if (ctrl->val == V4L2_EXPOSURE_AUTO && sd->exposure &&
+		    gspca_dev->streaming)
+			sd->exposure->val = getexposure(gspca_dev);
+		return gspca_dev->usb_err;
+	}
+	return -EINVAL;
+}
+
+static int ov534_s_ctrl(struct v4l2_ctrl *ctrl)
+{
+	struct sd *sd = container_of(ctrl->handler, struct sd, ctrl_handler);
+	struct gspca_dev *gspca_dev = &sd->gspca_dev;
+
+	gspca_dev->usb_err = 0;
+	if (!gspca_dev->streaming)
+		return 0;
+
+	switch (ctrl->id) {
+	case V4L2_CID_HUE:
+		sethue(gspca_dev, ctrl->val);
+		break;
+	case V4L2_CID_SATURATION:
+		setsaturation(gspca_dev, ctrl->val);
+		break;
+	case V4L2_CID_BRIGHTNESS:
+		setbrightness(gspca_dev, ctrl->val);
+		break;
+	case V4L2_CID_CONTRAST:
+		setcontrast(gspca_dev, ctrl->val);
+		break;
+	case V4L2_CID_AUTOGAIN:
+	/* case V4L2_CID_GAIN: */
+		setagc(gspca_dev, ctrl->val);
+		if (!gspca_dev->usb_err && !ctrl->val && sd->gain)
+			setgain(gspca_dev, sd->gain->val);
+		break;
+	case V4L2_CID_AUTO_WHITE_BALANCE:
+		setawb(gspca_dev, ctrl->val);
+		break;
+	case V4L2_CID_EXPOSURE_AUTO:
+	/* case V4L2_CID_EXPOSURE: */
+		setaec(gspca_dev, ctrl->val);
+		if (!gspca_dev->usb_err && ctrl->val == V4L2_EXPOSURE_MANUAL &&
+		    sd->exposure)
+			setexposure(gspca_dev, sd->exposure->val);
+		break;
+	case V4L2_CID_SHARPNESS:
+		setsharpness(gspca_dev, ctrl->val);
+		break;
+	case V4L2_CID_HFLIP:
+		sethvflip(gspca_dev, ctrl->val, sd->vflip->val);
+		break;
+	case V4L2_CID_VFLIP:
+		sethvflip(gspca_dev, sd->hflip->val, ctrl->val);
+		break;
+	case V4L2_CID_POWER_LINE_FREQUENCY:
+		setlightfreq(gspca_dev, ctrl->val);
+		break;
+	}
+	return gspca_dev->usb_err;
+}
+
+static const struct v4l2_ctrl_ops ov534_ctrl_ops = {
+	.g_volatile_ctrl = ov534_g_volatile_ctrl,
+	.s_ctrl = ov534_s_ctrl,
+};
+
+static int sd_init_controls(struct gspca_dev *gspca_dev)
+{
+	struct sd *sd = (struct sd *) gspca_dev;
+	struct v4l2_ctrl_handler *hdl = &sd->ctrl_handler;
+	/* parameters with different values between the supported sensors */
+	int saturation_min;
+	int saturation_max;
+	int saturation_def;
+	int brightness_min;
+	int brightness_max;
+	int brightness_def;
+	int contrast_max;
+	int contrast_def;
+	int exposure_min;
+	int exposure_max;
+	int exposure_def;
+	int hflip_def;
+
+	if (sd->sensor == SENSOR_OV767x) {
+		saturation_min = 0,
+		saturation_max = 6,
+		saturation_def = 3,
+		brightness_min = -127;
+		brightness_max = 127;
+		brightness_def = 0;
+		contrast_max = 0x80;
+		contrast_def = 0x40;
+		exposure_min = 0x08;
+		exposure_max = 0x60;
+		exposure_def = 0x13;
+		hflip_def = 1;
+	} else {
+		saturation_min = 0,
+		saturation_max = 255,
+		saturation_def = 64,
+		brightness_min = 0;
+		brightness_max = 255;
+		brightness_def = 0;
+		contrast_max = 255;
+		contrast_def = 32;
+		exposure_min = 0;
+		exposure_max = 255;
+		exposure_def = 120;
+		hflip_def = 0;
+	}
+
+	gspca_dev->vdev.ctrl_handler = hdl;
+
+	v4l2_ctrl_handler_init(hdl, 13);
+
+	if (sd->sensor == SENSOR_OV772x)
+		sd->hue = v4l2_ctrl_new_std(hdl, &ov534_ctrl_ops,
+				V4L2_CID_HUE, -90, 90, 1, 0);
+
+	sd->saturation = v4l2_ctrl_new_std(hdl, &ov534_ctrl_ops,
+			V4L2_CID_SATURATION, saturation_min, saturation_max, 1,
+			saturation_def);
+	sd->brightness = v4l2_ctrl_new_std(hdl, &ov534_ctrl_ops,
+			V4L2_CID_BRIGHTNESS, brightness_min, brightness_max, 1,
+			brightness_def);
+	sd->contrast = v4l2_ctrl_new_std(hdl, &ov534_ctrl_ops,
+			V4L2_CID_CONTRAST, 0, contrast_max, 1, contrast_def);
+
+	if (sd->sensor == SENSOR_OV772x) {
+		sd->autogain = v4l2_ctrl_new_std(hdl, &ov534_ctrl_ops,
+				V4L2_CID_AUTOGAIN, 0, 1, 1, 1);
+		sd->gain = v4l2_ctrl_new_std(hdl, &ov534_ctrl_ops,
+				V4L2_CID_GAIN, 0, 63, 1, 20);
+	}
+
+	sd->autoexposure = v4l2_ctrl_new_std_menu(hdl, &ov534_ctrl_ops,
+			V4L2_CID_EXPOSURE_AUTO,
+			V4L2_EXPOSURE_MANUAL, 0,
+			V4L2_EXPOSURE_AUTO);
+	sd->exposure = v4l2_ctrl_new_std(hdl, &ov534_ctrl_ops,
+			V4L2_CID_EXPOSURE, exposure_min, exposure_max, 1,
+			exposure_def);
+
+	sd->autowhitebalance = v4l2_ctrl_new_std(hdl, &ov534_ctrl_ops,
+			V4L2_CID_AUTO_WHITE_BALANCE, 0, 1, 1, 1);
+
+	if (sd->sensor == SENSOR_OV772x)
+		sd->sharpness = v4l2_ctrl_new_std(hdl, &ov534_ctrl_ops,
+				V4L2_CID_SHARPNESS, 0, 63, 1, 0);
+
+	sd->hflip = v4l2_ctrl_new_std(hdl, &ov534_ctrl_ops,
+			V4L2_CID_HFLIP, 0, 1, 1, hflip_def);
+	sd->vflip = v4l2_ctrl_new_std(hdl, &ov534_ctrl_ops,
+			V4L2_CID_VFLIP, 0, 1, 1, 0);
+	sd->plfreq = v4l2_ctrl_new_std_menu(hdl, &ov534_ctrl_ops,
+			V4L2_CID_POWER_LINE_FREQUENCY,
+			V4L2_CID_POWER_LINE_FREQUENCY_50HZ, 0,
+			V4L2_CID_POWER_LINE_FREQUENCY_DISABLED);
+
+	if (hdl->error) {
+		pr_err("Could not initialize controls\n");
+		return hdl->error;
+	}
+
+	if (sd->sensor == SENSOR_OV772x)
+		v4l2_ctrl_auto_cluster(2, &sd->autogain, 0, true);
+
+	v4l2_ctrl_auto_cluster(2, &sd->autoexposure, V4L2_EXPOSURE_MANUAL,
+			       true);
+
+	return 0;
+}
+
 /* this function is called at probe and resume time */
 static int sd_init(struct gspca_dev *gspca_dev)
 {
@@ -1285,24 +1288,6 @@ static int sd_init(struct gspca_dev *gspca_dev)
 
 	if ((sensor_id & 0xfff0) == 0x7670) {
 		sd->sensor = SENSOR_OV767x;
-		gspca_dev->ctrl_dis = (1 << HUE) |
-					(1 << GAIN) |
-					(1 << AGC) |
-					(1 << SHARPNESS);	/* auto */
-		sd->ctrls[SATURATION].min = 0,
-		sd->ctrls[SATURATION].max = 6,
-		sd->ctrls[SATURATION].def = 3,
-		sd->ctrls[BRIGHTNESS].min = -127;
-		sd->ctrls[BRIGHTNESS].max = 127;
-		sd->ctrls[BRIGHTNESS].def = 0;
-		sd->ctrls[CONTRAST].max = 0x80;
-		sd->ctrls[CONTRAST].def = 0x40;
-		sd->ctrls[EXPOSURE].min = 0x08;
-		sd->ctrls[EXPOSURE].max = 0x60;
-		sd->ctrls[EXPOSURE].def = 0x13;
-		sd->ctrls[SHARPNESS].max = 9;
-		sd->ctrls[SHARPNESS].def = 4;
-		sd->ctrls[HFLIP].def = 1;
 		gspca_dev->cam.cam_mode = ov767x_mode;
 		gspca_dev->cam.nmodes = ARRAY_SIZE(ov767x_mode);
 	} else {
@@ -1365,22 +1350,23 @@ static int sd_start(struct gspca_dev *gspca_dev)
 
 	set_frame_rate(gspca_dev);
 
-	if (!(gspca_dev->ctrl_dis & (1 << HUE)))
-		sethue(gspca_dev);
-	setsaturation(gspca_dev);
-	if (!(gspca_dev->ctrl_dis & (1 << AGC)))
-		setagc(gspca_dev);
-	setawb(gspca_dev);
-	setaec(gspca_dev);
-	if (!(gspca_dev->ctrl_dis & (1 << GAIN)))
-		setgain(gspca_dev);
-	setexposure(gspca_dev);
-	setbrightness(gspca_dev);
-	setcontrast(gspca_dev);
-	if (!(gspca_dev->ctrl_dis & (1 << SHARPNESS)))
-		setsharpness(gspca_dev);
-	sethvflip(gspca_dev);
-	setlightfreq(gspca_dev);
+	if (sd->hue)
+		sethue(gspca_dev, v4l2_ctrl_g_ctrl(sd->hue));
+	setsaturation(gspca_dev, v4l2_ctrl_g_ctrl(sd->saturation));
+	if (sd->autogain)
+		setagc(gspca_dev, v4l2_ctrl_g_ctrl(sd->autogain));
+	setawb(gspca_dev, v4l2_ctrl_g_ctrl(sd->autowhitebalance));
+	setaec(gspca_dev, v4l2_ctrl_g_ctrl(sd->autoexposure));
+	if (sd->gain)
+		setgain(gspca_dev, v4l2_ctrl_g_ctrl(sd->gain));
+	setexposure(gspca_dev, v4l2_ctrl_g_ctrl(sd->exposure));
+	setbrightness(gspca_dev, v4l2_ctrl_g_ctrl(sd->brightness));
+	setcontrast(gspca_dev, v4l2_ctrl_g_ctrl(sd->contrast));
+	if (sd->sharpness)
+		setsharpness(gspca_dev, v4l2_ctrl_g_ctrl(sd->sharpness));
+	sethvflip(gspca_dev, v4l2_ctrl_g_ctrl(sd->hflip),
+		  v4l2_ctrl_g_ctrl(sd->vflip));
+	setlightfreq(gspca_dev, v4l2_ctrl_g_ctrl(sd->plfreq));
 
 	ov534_set_led(gspca_dev, 1);
 	ov534_reg_write(gspca_dev, 0xe0, 0x00);
@@ -1482,25 +1468,6 @@ scan_next:
 	} while (remaining_len > 0);
 }
 
-static int sd_querymenu(struct gspca_dev *gspca_dev,
-		struct v4l2_querymenu *menu)
-{
-	switch (menu->id) {
-	case V4L2_CID_POWER_LINE_FREQUENCY:
-		switch (menu->index) {
-		case 0:         /* V4L2_CID_POWER_LINE_FREQUENCY_DISABLED */
-			strcpy((char *) menu->name, "Disabled");
-			return 0;
-		case 1:         /* V4L2_CID_POWER_LINE_FREQUENCY_50HZ */
-			strcpy((char *) menu->name, "50 Hz");
-			return 0;
-		}
-		break;
-	}
-
-	return -EINVAL;
-}
-
 /* get stream parameters (framerate) */
 static void sd_get_streamparm(struct gspca_dev *gspca_dev,
 			     struct v4l2_streamparm *parm)
@@ -1535,14 +1502,12 @@ static void sd_set_streamparm(struct gspca_dev *gspca_dev,
 /* sub-driver description */
 static const struct sd_desc sd_desc = {
 	.name     = MODULE_NAME,
-	.ctrls    = sd_ctrls,
-	.nctrls   = ARRAY_SIZE(sd_ctrls),
 	.config   = sd_config,
 	.init     = sd_init,
+	.init_controls = sd_init_controls,
 	.start    = sd_start,
 	.stopN    = sd_stopN,
 	.pkt_scan = sd_pkt_scan,
-	.querymenu = sd_querymenu,
 	.get_streamparm = sd_get_streamparm,
 	.set_streamparm = sd_set_streamparm,
 };
-- 
1.7.10

