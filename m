Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr1.xs4all.nl ([194.109.24.21]:3695 "EHLO
	smtp-vbr1.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753938Ab2D1PKJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 28 Apr 2012 11:10:09 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans de Goede <hdegoede@redhat.com>,
	Jean-Francois Moine <moinejf@free.fr>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv1 PATCH 3/7] sn9c20x: convert to the control framework.
Date: Sat, 28 Apr 2012 17:09:52 +0200
Message-Id: <a53c8c3942f178195d8761a758448c3b7e5d7fc8.1335625085.git.hans.verkuil@cisco.com>
In-Reply-To: <1335625796-9429-1-git-send-email-hverkuil@xs4all.nl>
References: <1335625796-9429-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <ea7e986dc0fa18da12c22048e9187e9933191d3d.1335625085.git.hans.verkuil@cisco.com>
References: <ea7e986dc0fa18da12c22048e9187e9933191d3d.1335625085.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/video/gspca/sn9c20x.c |  481 ++++++++++++++---------------------
 1 file changed, 198 insertions(+), 283 deletions(-)

diff --git a/drivers/media/video/gspca/sn9c20x.c b/drivers/media/video/gspca/sn9c20x.c
index 7e71aa2..ed51556 100644
--- a/drivers/media/video/gspca/sn9c20x.c
+++ b/drivers/media/video/gspca/sn9c20x.c
@@ -28,6 +28,7 @@
 #include "jpeg.h"
 
 #include <media/v4l2-chip-ident.h>
+#include <media/v4l2-ctrls.h>
 #include <linux/dmi.h>
 
 MODULE_AUTHOR("Brian Johnson <brijohn@gmail.com>, "
@@ -66,28 +67,32 @@ MODULE_LICENSE("GPL");
 #define LED_REVERSE	0x2 /* some cameras unset gpio to turn on leds */
 #define FLIP_DETECT	0x4
 
-enum e_ctrl {
-	BRIGHTNESS,
-	CONTRAST,
-	SATURATION,
-	HUE,
-	GAMMA,
-	BLUE,
-	RED,
-	VFLIP,
-	HFLIP,
-	EXPOSURE,
-	GAIN,
-	AUTOGAIN,
-	QUALITY,
-	NCTRLS		/* number of controls */
-};
-
 /* specific webcam descriptor */
 struct sd {
 	struct gspca_dev gspca_dev;
 
-	struct gspca_ctrl ctrls[NCTRLS];
+	struct v4l2_ctrl_handler ctrl_handler;
+	struct { /* color control cluster */
+		struct v4l2_ctrl *brightness;
+		struct v4l2_ctrl *contrast;
+		struct v4l2_ctrl *saturation;
+		struct v4l2_ctrl *hue;
+	};
+	struct { /* blue/red balance control cluster */
+		struct v4l2_ctrl *blue;
+		struct v4l2_ctrl *red;
+	};
+	struct { /* h/vflip control cluster */
+		struct v4l2_ctrl *hflip;
+		struct v4l2_ctrl *vflip;
+	};
+	struct v4l2_ctrl *gamma;
+	struct { /* autogain and exposure or gain control cluster */
+		struct v4l2_ctrl *autogain;
+		struct v4l2_ctrl *exposure;
+		struct v4l2_ctrl *gain;
+	};
+	struct v4l2_ctrl *jpegqual;
 
 	struct work_struct work;
 	struct workqueue_struct *work_thread;
@@ -166,175 +171,6 @@ static const struct dmi_system_id flip_dmi_table[] = {
 	{}
 };
 
-static void set_cmatrix(struct gspca_dev *gspca_dev);
-static void set_gamma(struct gspca_dev *gspca_dev);
-static void set_redblue(struct gspca_dev *gspca_dev);
-static void set_hvflip(struct gspca_dev *gspca_dev);
-static void set_exposure(struct gspca_dev *gspca_dev);
-static void set_gain(struct gspca_dev *gspca_dev);
-static void set_quality(struct gspca_dev *gspca_dev);
-
-static const struct ctrl sd_ctrls[NCTRLS] = {
-[BRIGHTNESS] = {
-	    {
-		.id      = V4L2_CID_BRIGHTNESS,
-		.type    = V4L2_CTRL_TYPE_INTEGER,
-		.name    = "Brightness",
-		.minimum = 0,
-		.maximum = 0xff,
-		.step    = 1,
-		.default_value = 0x7f
-	    },
-	    .set_control = set_cmatrix
-	},
-[CONTRAST] = {
-	    {
-		.id      = V4L2_CID_CONTRAST,
-		.type    = V4L2_CTRL_TYPE_INTEGER,
-		.name    = "Contrast",
-		.minimum = 0,
-		.maximum = 0xff,
-		.step    = 1,
-		.default_value = 0x7f
-	    },
-	    .set_control = set_cmatrix
-	},
-[SATURATION] = {
-	    {
-		.id      = V4L2_CID_SATURATION,
-		.type    = V4L2_CTRL_TYPE_INTEGER,
-		.name    = "Saturation",
-		.minimum = 0,
-		.maximum = 0xff,
-		.step    = 1,
-		.default_value = 0x7f
-	    },
-	    .set_control = set_cmatrix
-	},
-[HUE] = {
-	    {
-		.id      = V4L2_CID_HUE,
-		.type    = V4L2_CTRL_TYPE_INTEGER,
-		.name    = "Hue",
-		.minimum = -180,
-		.maximum = 180,
-		.step    = 1,
-		.default_value = 0
-	    },
-	    .set_control = set_cmatrix
-	},
-[GAMMA] = {
-	    {
-		.id      = V4L2_CID_GAMMA,
-		.type    = V4L2_CTRL_TYPE_INTEGER,
-		.name    = "Gamma",
-		.minimum = 0,
-		.maximum = 0xff,
-		.step    = 1,
-		.default_value = 0x10
-	    },
-	    .set_control = set_gamma
-	},
-[BLUE] = {
-	    {
-		.id	 = V4L2_CID_BLUE_BALANCE,
-		.type	 = V4L2_CTRL_TYPE_INTEGER,
-		.name	 = "Blue Balance",
-		.minimum = 0,
-		.maximum = 0x7f,
-		.step	 = 1,
-		.default_value = 0x28
-	    },
-	    .set_control = set_redblue
-	},
-[RED] = {
-	    {
-		.id	 = V4L2_CID_RED_BALANCE,
-		.type	 = V4L2_CTRL_TYPE_INTEGER,
-		.name	 = "Red Balance",
-		.minimum = 0,
-		.maximum = 0x7f,
-		.step	 = 1,
-		.default_value = 0x28
-	    },
-	    .set_control = set_redblue
-	},
-[HFLIP] = {
-	    {
-		.id      = V4L2_CID_HFLIP,
-		.type    = V4L2_CTRL_TYPE_BOOLEAN,
-		.name    = "Horizontal Flip",
-		.minimum = 0,
-		.maximum = 1,
-		.step    = 1,
-		.default_value = 0,
-	    },
-	    .set_control = set_hvflip
-	},
-[VFLIP] = {
-	    {
-		.id      = V4L2_CID_VFLIP,
-		.type    = V4L2_CTRL_TYPE_BOOLEAN,
-		.name    = "Vertical Flip",
-		.minimum = 0,
-		.maximum = 1,
-		.step    = 1,
-		.default_value = 0,
-	    },
-	    .set_control = set_hvflip
-	},
-[EXPOSURE] = {
-	    {
-		.id      = V4L2_CID_EXPOSURE,
-		.type    = V4L2_CTRL_TYPE_INTEGER,
-		.name    = "Exposure",
-		.minimum = 0,
-		.maximum = 0x1780,
-		.step    = 1,
-		.default_value = 0x33,
-	    },
-	    .set_control = set_exposure
-	},
-[GAIN] = {
-	    {
-		.id      = V4L2_CID_GAIN,
-		.type    = V4L2_CTRL_TYPE_INTEGER,
-		.name    = "Gain",
-		.minimum = 0,
-		.maximum = 28,
-		.step    = 1,
-		.default_value = 0,
-	    },
-	    .set_control = set_gain
-	},
-[AUTOGAIN] = {
-	    {
-		.id      = V4L2_CID_AUTOGAIN,
-		.type    = V4L2_CTRL_TYPE_BOOLEAN,
-		.name    = "Auto Exposure",
-		.minimum = 0,
-		.maximum = 1,
-		.step    = 1,
-		.default_value = 1,
-	    },
-	},
-[QUALITY] = {
-	    {
-		.id      = V4L2_CID_JPEG_COMPRESSION_QUALITY,
-		.type    = V4L2_CTRL_TYPE_INTEGER,
-		.name    = "Compression Quality",
-#define QUALITY_MIN 50
-#define QUALITY_MAX 90
-#define QUALITY_DEF 80
-		.minimum = QUALITY_MIN,
-		.maximum = QUALITY_MAX,
-		.step    = 1,
-		.default_value = QUALITY_DEF,
-	    },
-	    .set_control = set_quality
-	},
-};
-
 static const struct v4l2_pix_format vga_mode[] = {
 	{160, 120, V4L2_PIX_FMT_JPEG, V4L2_FIELD_NONE,
 		.bytesperline = 160,
@@ -1294,8 +1130,6 @@ static void ov9655_init_sensor(struct gspca_dev *gspca_dev)
 	if (gspca_dev->usb_err < 0)
 		pr_err("OV9655 sensor initialization failed\n");
 
-	/* disable hflip and vflip */
-	gspca_dev->ctrl_dis = (1 << HFLIP) | (1 << VFLIP);
 	sd->hstart = 1;
 	sd->vstart = 2;
 }
@@ -1310,9 +1144,6 @@ static void soi968_init_sensor(struct gspca_dev *gspca_dev)
 	if (gspca_dev->usb_err < 0)
 		pr_err("SOI968 sensor initialization failed\n");
 
-	/* disable hflip and vflip */
-	gspca_dev->ctrl_dis = (1 << HFLIP) | (1 << VFLIP)
-				| (1 << EXPOSURE);
 	sd->hstart = 60;
 	sd->vstart = 11;
 }
@@ -1340,8 +1171,6 @@ static void ov7670_init_sensor(struct gspca_dev *gspca_dev)
 	if (gspca_dev->usb_err < 0)
 		pr_err("OV7670 sensor initialization failed\n");
 
-	/* disable hflip and vflip */
-	gspca_dev->ctrl_dis = (1 << HFLIP) | (1 << VFLIP);
 	sd->hstart = 0;
 	sd->vstart = 1;
 }
@@ -1378,9 +1207,6 @@ static void mt9v_init_sensor(struct gspca_dev *gspca_dev)
 			pr_err("MT9V111 sensor initialization failed\n");
 			return;
 		}
-		gspca_dev->ctrl_dis = (1 << EXPOSURE)
-					| (1 << AUTOGAIN)
-					| (1 << GAIN);
 		sd->hstart = 2;
 		sd->vstart = 2;
 		sd->sensor = SENSOR_MT9V111;
@@ -1422,8 +1248,6 @@ static void mt9m112_init_sensor(struct gspca_dev *gspca_dev)
 	if (gspca_dev->usb_err < 0)
 		pr_err("MT9M112 sensor initialization failed\n");
 
-	gspca_dev->ctrl_dis = (1 << EXPOSURE) | (1 << AUTOGAIN)
-				| (1 << GAIN);
 	sd->hstart = 0;
 	sd->vstart = 2;
 }
@@ -1436,8 +1260,6 @@ static void mt9m111_init_sensor(struct gspca_dev *gspca_dev)
 	if (gspca_dev->usb_err < 0)
 		pr_err("MT9M111 sensor initialization failed\n");
 
-	gspca_dev->ctrl_dis = (1 << EXPOSURE) | (1 << AUTOGAIN)
-				| (1 << GAIN);
 	sd->hstart = 0;
 	sd->vstart = 2;
 }
@@ -1470,8 +1292,6 @@ static void mt9m001_init_sensor(struct gspca_dev *gspca_dev)
 	if (gspca_dev->usb_err < 0)
 		pr_err("MT9M001 sensor initialization failed\n");
 
-	/* disable hflip and vflip */
-	gspca_dev->ctrl_dis = (1 << HFLIP) | (1 << VFLIP);
 	sd->hstart = 1;
 	sd->vstart = 1;
 }
@@ -1488,20 +1308,18 @@ static void hv7131r_init_sensor(struct gspca_dev *gspca_dev)
 	sd->vstart = 1;
 }
 
-static void set_cmatrix(struct gspca_dev *gspca_dev)
+static void set_cmatrix(struct gspca_dev *gspca_dev,
+		s32 brightness, s32 contrast, s32 satur, s32 hue)
 {
-	struct sd *sd = (struct sd *) gspca_dev;
-	int satur;
-	s32 hue_coord, hue_index = 180 + sd->ctrls[HUE].val;
+	s32 hue_coord, hue_index = 180 + hue;
 	u8 cmatrix[21];
 
 	memset(cmatrix, 0, sizeof cmatrix);
-	cmatrix[2] = (sd->ctrls[CONTRAST].val * 0x25 / 0x100) + 0x26;
+	cmatrix[2] = (contrast * 0x25 / 0x100) + 0x26;
 	cmatrix[0] = 0x13 + (cmatrix[2] - 0x26) * 0x13 / 0x25;
 	cmatrix[4] = 0x07 + (cmatrix[2] - 0x26) * 0x07 / 0x25;
-	cmatrix[18] = sd->ctrls[BRIGHTNESS].val - 0x80;
+	cmatrix[18] = brightness - 0x80;
 
-	satur = sd->ctrls[SATURATION].val;
 	hue_coord = (hsv_red_x[hue_index] * satur) >> 8;
 	cmatrix[6] = hue_coord;
 	cmatrix[7] = (hue_coord >> 8) & 0x0f;
@@ -1529,11 +1347,10 @@ static void set_cmatrix(struct gspca_dev *gspca_dev)
 	reg_w(gspca_dev, 0x10e1, cmatrix, 21);
 }
 
-static void set_gamma(struct gspca_dev *gspca_dev)
+static void set_gamma(struct gspca_dev *gspca_dev, s32 val)
 {
-	struct sd *sd = (struct sd *) gspca_dev;
 	u8 gamma[17];
-	u8 gval = sd->ctrls[GAMMA].val * 0xb8 / 0x100;
+	u8 gval = val * 0xb8 / 0x100;
 
 	gamma[0] = 0x0a;
 	gamma[1] = 0x13 + (gval * (0xcb - 0x13) / 0xb8);
@@ -1556,26 +1373,21 @@ static void set_gamma(struct gspca_dev *gspca_dev)
 	reg_w(gspca_dev, 0x1190, gamma, 17);
 }
 
-static void set_redblue(struct gspca_dev *gspca_dev)
+static void set_redblue(struct gspca_dev *gspca_dev, s32 blue, s32 red)
 {
-	struct sd *sd = (struct sd *) gspca_dev;
-
-	reg_w1(gspca_dev, 0x118c, sd->ctrls[RED].val);
-	reg_w1(gspca_dev, 0x118f, sd->ctrls[BLUE].val);
+	reg_w1(gspca_dev, 0x118c, red);
+	reg_w1(gspca_dev, 0x118f, blue);
 }
 
-static void set_hvflip(struct gspca_dev *gspca_dev)
+static void set_hvflip(struct gspca_dev *gspca_dev, s32 hflip, s32 vflip)
 {
-	u8 value, tslb, hflip, vflip;
+	u8 value, tslb;
 	u16 value2;
 	struct sd *sd = (struct sd *) gspca_dev;
 
 	if ((sd->flags & FLIP_DETECT) && dmi_check_system(flip_dmi_table)) {
-		hflip = !sd->ctrls[HFLIP].val;
-		vflip = !sd->ctrls[VFLIP].val;
-	} else {
-		hflip = sd->ctrls[HFLIP].val;
-		vflip = sd->ctrls[VFLIP].val;
+		hflip = !hflip;
+		vflip = !vflip;
 	}
 
 	switch (sd->sensor) {
@@ -1638,13 +1450,11 @@ static void set_hvflip(struct gspca_dev *gspca_dev)
 	}
 }
 
-static void set_exposure(struct gspca_dev *gspca_dev)
+static void set_exposure(struct gspca_dev *gspca_dev, s32 expo)
 {
 	struct sd *sd = (struct sd *) gspca_dev;
 	u8 exp[8] = {0x81, sd->i2c_addr, 0x00, 0x00, 0x00, 0x00, 0x00, 0x1e};
-	int expo;
 
-	expo = sd->ctrls[EXPOSURE].val;
 	switch (sd->sensor) {
 	case SENSOR_OV7660:
 	case SENSOR_OV7670:
@@ -1676,13 +1486,11 @@ static void set_exposure(struct gspca_dev *gspca_dev)
 	i2c_w(gspca_dev, exp);
 }
 
-static void set_gain(struct gspca_dev *gspca_dev)
+static void set_gain(struct gspca_dev *gspca_dev, s32 g)
 {
 	struct sd *sd = (struct sd *) gspca_dev;
 	u8 gain[8] = {0x81, sd->i2c_addr, 0x00, 0x00, 0x00, 0x00, 0x00, 0x1d};
-	int g;
 
-	g = sd->ctrls[GAIN].val;
 	switch (sd->sensor) {
 	case SENSOR_OV7660:
 	case SENSOR_OV7670:
@@ -1721,11 +1529,11 @@ static void set_gain(struct gspca_dev *gspca_dev)
 	i2c_w(gspca_dev, gain);
 }
 
-static void set_quality(struct gspca_dev *gspca_dev)
+static void set_quality(struct gspca_dev *gspca_dev, s32 val)
 {
 	struct sd *sd = (struct sd *) gspca_dev;
 
-	jpeg_set_qual(sd->jpeg_hdr, sd->ctrls[QUALITY].val);
+	jpeg_set_qual(sd->jpeg_hdr, val);
 	reg_w1(gspca_dev, 0x1061, 0x01);	/* stop transfer */
 	reg_w1(gspca_dev, 0x10e0, sd->fmt | 0x20); /* write QTAB */
 	reg_w(gspca_dev, 0x1100, &sd->jpeg_hdr[JPEG_QT0_OFFSET], 64);
@@ -1850,16 +1658,62 @@ static int sd_config(struct gspca_dev *gspca_dev,
 	sd->older_step = 0;
 	sd->exposure_step = 16;
 
-	gspca_dev->cam.ctrls = sd->ctrls;
-
 	INIT_WORK(&sd->work, qual_upd);
 
 	return 0;
 }
 
+static int sd_s_ctrl(struct v4l2_ctrl *ctrl)
+{
+	struct sd *sd = container_of(ctrl->handler, struct sd, ctrl_handler);
+
+	switch (ctrl->id) {
+	/* color control cluster */
+	case V4L2_CID_BRIGHTNESS:
+		set_cmatrix(&sd->gspca_dev, sd->brightness->val,
+			sd->contrast->val, sd->saturation->val, sd->hue->val);
+		return 0;
+	case V4L2_CID_GAMMA:
+		set_gamma(&sd->gspca_dev, ctrl->val);
+		return 0;
+	/* blue/red balance cluster */
+	case V4L2_CID_BLUE_BALANCE:
+		set_redblue(&sd->gspca_dev, sd->blue->val, sd->red->val);
+		return 0;
+	/* h/vflip cluster */
+	case V4L2_CID_HFLIP:
+		set_hvflip(&sd->gspca_dev, sd->hflip->val, sd->vflip->val);
+		return 0;
+	/* standalone exposure control */
+	case V4L2_CID_EXPOSURE:
+		set_exposure(&sd->gspca_dev, ctrl->val);
+		return 0;
+	/* standalone gain control */
+	case V4L2_CID_GAIN:
+		set_gain(&sd->gspca_dev, ctrl->val);
+		return 0;
+	/* autogain + exposure or gain control cluster */
+	case V4L2_CID_AUTOGAIN:
+		if (sd->sensor == SENSOR_SOI968)
+			set_gain(&sd->gspca_dev, sd->gain->val);
+		else
+			set_exposure(&sd->gspca_dev, sd->exposure->val);
+		return 0;
+	case V4L2_CID_JPEG_COMPRESSION_QUALITY:
+		set_quality(&sd->gspca_dev, ctrl->val);
+		return 0;
+	}
+	return -EINVAL;
+}
+
+static const struct v4l2_ctrl_ops sd_ctrl_ops = {
+	.s_ctrl = sd_s_ctrl,
+};
+
 static int sd_init(struct gspca_dev *gspca_dev)
 {
 	struct sd *sd = (struct sd *) gspca_dev;
+	struct v4l2_ctrl_handler *hdl = &sd->ctrl_handler;
 	int i;
 	u8 value;
 	u8 i2c_init[9] =
@@ -1949,8 +1803,67 @@ static int sd_init(struct gspca_dev *gspca_dev)
 		pr_err("Unsupported sensor\n");
 		gspca_dev->usb_err = -ENODEV;
 	}
+	if (gspca_dev->usb_err)
+		return gspca_dev->usb_err;
+	gspca_dev->vdev.ctrl_handler = hdl;
+	v4l2_ctrl_handler_init(hdl, 13);
+
+	sd->brightness = v4l2_ctrl_new_std(hdl, &sd_ctrl_ops,
+			V4L2_CID_BRIGHTNESS, 0, 255, 1, 127);
+	sd->contrast = v4l2_ctrl_new_std(hdl, &sd_ctrl_ops,
+			V4L2_CID_CONTRAST, 0, 255, 1, 127);
+	sd->saturation = v4l2_ctrl_new_std(hdl, &sd_ctrl_ops,
+			V4L2_CID_SATURATION, 0, 255, 1, 127);
+	sd->hue = v4l2_ctrl_new_std(hdl, &sd_ctrl_ops,
+			V4L2_CID_HUE, -180, 180, 1, 0);
+	v4l2_ctrl_cluster(4, &sd->brightness);
+
+	sd->gamma = v4l2_ctrl_new_std(hdl, &sd_ctrl_ops,
+			V4L2_CID_GAMMA, 0, 255, 1, 0x10);
+	sd->blue = v4l2_ctrl_new_std(hdl, &sd_ctrl_ops,
+			V4L2_CID_BLUE_BALANCE, 0, 127, 1, 0x28);
+	sd->red = v4l2_ctrl_new_std(hdl, &sd_ctrl_ops,
+			V4L2_CID_RED_BALANCE, 0, 127, 1, 0x28);
+	v4l2_ctrl_cluster(2, &sd->blue);
+
+	if (sd->sensor != SENSOR_OV9650 && sd->sensor != SENSOR_SOI968 &&
+	    sd->sensor != SENSOR_OV7670 && sd->sensor != SENSOR_MT9M001) {
+		sd->hflip = v4l2_ctrl_new_std(hdl, &sd_ctrl_ops,
+			V4L2_CID_HFLIP, 0, 1, 1, 0);
+		sd->vflip = v4l2_ctrl_new_std(hdl, &sd_ctrl_ops,
+			V4L2_CID_VFLIP, 0, 1, 1, 0);
+		v4l2_ctrl_cluster(2, &sd->hflip);
+	}
 
-	return gspca_dev->usb_err;
+	if (sd->sensor != SENSOR_SOI968 && sd->sensor != SENSOR_MT9VPRB &&
+	    sd->sensor != SENSOR_MT9M112 && sd->sensor != SENSOR_MT9M111)
+		sd->exposure = v4l2_ctrl_new_std(hdl, &sd_ctrl_ops,
+			V4L2_CID_EXPOSURE, 0, 0x1780, 1, 0x33);
+
+	if (sd->sensor != SENSOR_MT9VPRB && sd->sensor != SENSOR_MT9M112 &&
+	    sd->sensor != SENSOR_MT9M111) {
+		sd->gain = v4l2_ctrl_new_std(hdl, &sd_ctrl_ops,
+			V4L2_CID_GAIN, 0, 28, 1, 0);
+		sd->autogain = v4l2_ctrl_new_std(hdl, &sd_ctrl_ops,
+			V4L2_CID_AUTOGAIN, 0, 1, 1, 1);
+		if (sd->sensor == SENSOR_SOI968)
+			/* this sensor doesn't have the exposure control and
+			   autogain is clustered with gain instead. This works
+			   because sd->exposure == NULL. */
+			v4l2_ctrl_auto_cluster(3, &sd->autogain, 0, false);
+		else
+			/* Otherwise autogain is clustered with exposure. */
+			v4l2_ctrl_auto_cluster(2, &sd->autogain, 0, false);
+	}
+
+	sd->jpegqual = v4l2_ctrl_new_std(hdl, &sd_ctrl_ops,
+			V4L2_CID_JPEG_COMPRESSION_QUALITY, 50, 90, 1, 80);
+	if (hdl->error) {
+		pr_err("Could not initialize controls\n");
+		return hdl->error;
+	}
+
+	return 0;
 }
 
 static void configure_sensor_output(struct gspca_dev *gspca_dev, int mode)
@@ -2067,7 +1980,7 @@ static int sd_start(struct gspca_dev *gspca_dev)
 
 	jpeg_define(sd->jpeg_hdr, height, width,
 			0x21);
-	jpeg_set_qual(sd->jpeg_hdr, sd->ctrls[QUALITY].val);
+	jpeg_set_qual(sd->jpeg_hdr, v4l2_ctrl_g_ctrl(sd->jpegqual));
 
 	if (mode & MODE_RAW)
 		fmt = 0x2d;
@@ -2104,12 +2017,17 @@ static int sd_start(struct gspca_dev *gspca_dev)
 	reg_w1(gspca_dev, 0x1189, scale);
 	reg_w1(gspca_dev, 0x10e0, fmt);
 
-	set_cmatrix(gspca_dev);
-	set_gamma(gspca_dev);
-	set_redblue(gspca_dev);
-	set_gain(gspca_dev);
-	set_exposure(gspca_dev);
-	set_hvflip(gspca_dev);
+	set_cmatrix(gspca_dev, v4l2_ctrl_g_ctrl(sd->brightness),
+			v4l2_ctrl_g_ctrl(sd->contrast),
+			v4l2_ctrl_g_ctrl(sd->saturation),
+			v4l2_ctrl_g_ctrl(sd->hue));
+	set_gamma(gspca_dev, v4l2_ctrl_g_ctrl(sd->gamma));
+	set_redblue(gspca_dev, v4l2_ctrl_g_ctrl(sd->blue),
+			v4l2_ctrl_g_ctrl(sd->red));
+	set_gain(gspca_dev, v4l2_ctrl_g_ctrl(sd->gain));
+	set_exposure(gspca_dev, v4l2_ctrl_g_ctrl(sd->exposure));
+	set_hvflip(gspca_dev, v4l2_ctrl_g_ctrl(sd->hflip),
+			v4l2_ctrl_g_ctrl(sd->vflip));
 
 	reg_w1(gspca_dev, 0x1007, 0x20);
 	reg_w1(gspca_dev, 0x1061, 0x03);
@@ -2148,6 +2066,9 @@ static void sd_stop0(struct gspca_dev *gspca_dev)
 static void do_autoexposure(struct gspca_dev *gspca_dev, u16 avg_lum)
 {
 	struct sd *sd = (struct sd *) gspca_dev;
+	s32 cur_exp = v4l2_ctrl_g_ctrl(sd->exposure);
+	s32 max = sd->exposure->maximum - sd->exposure_step;
+	s32 min = sd->exposure->minimum + sd->exposure_step;
 	s16 new_exp;
 
 	/*
@@ -2156,16 +2077,15 @@ static void do_autoexposure(struct gspca_dev *gspca_dev, u16 avg_lum)
 	 * and exposure steps
 	 */
 	if (avg_lum < MIN_AVG_LUM) {
-		if (sd->ctrls[EXPOSURE].val > 0x1770)
+		if (cur_exp > max)
 			return;
 
-		new_exp = sd->ctrls[EXPOSURE].val + sd->exposure_step;
-		if (new_exp > 0x1770)
-			new_exp = 0x1770;
-		if (new_exp < 0x10)
-			new_exp = 0x10;
-		sd->ctrls[EXPOSURE].val = new_exp;
-		set_exposure(gspca_dev);
+		new_exp = cur_exp + sd->exposure_step;
+		if (new_exp > max)
+			new_exp = max;
+		if (new_exp < min)
+			new_exp = min;
+		v4l2_ctrl_s_ctrl(sd->exposure, new_exp);
 
 		sd->older_step = sd->old_step;
 		sd->old_step = 1;
@@ -2176,15 +2096,14 @@ static void do_autoexposure(struct gspca_dev *gspca_dev, u16 avg_lum)
 			sd->exposure_step += 2;
 	}
 	if (avg_lum > MAX_AVG_LUM) {
-		if (sd->ctrls[EXPOSURE].val < 0x10)
+		if (cur_exp < min)
 			return;
-		new_exp = sd->ctrls[EXPOSURE].val - sd->exposure_step;
-		if (new_exp > 0x1700)
-			new_exp = 0x1770;
-		if (new_exp < 0x10)
-			new_exp = 0x10;
-		sd->ctrls[EXPOSURE].val = new_exp;
-		set_exposure(gspca_dev);
+		new_exp = cur_exp - sd->exposure_step;
+		if (new_exp > max)
+			new_exp = max;
+		if (new_exp < min)
+			new_exp = min;
+		v4l2_ctrl_s_ctrl(sd->exposure, new_exp);
 		sd->older_step = sd->old_step;
 		sd->old_step = 0;
 
@@ -2198,19 +2117,12 @@ static void do_autoexposure(struct gspca_dev *gspca_dev, u16 avg_lum)
 static void do_autogain(struct gspca_dev *gspca_dev, u16 avg_lum)
 {
 	struct sd *sd = (struct sd *) gspca_dev;
+	s32 cur_gain = v4l2_ctrl_g_ctrl(sd->gain);
 
-	if (avg_lum < MIN_AVG_LUM) {
-		if (sd->ctrls[GAIN].val + 1 <= 28) {
-			sd->ctrls[GAIN].val++;
-			set_gain(gspca_dev);
-		}
-	}
-	if (avg_lum > MAX_AVG_LUM) {
-		if (sd->ctrls[GAIN].val > 0) {
-			sd->ctrls[GAIN].val--;
-			set_gain(gspca_dev);
-		}
-	}
+	if (avg_lum < MIN_AVG_LUM && cur_gain < sd->gain->maximum)
+		v4l2_ctrl_s_ctrl(sd->gain, cur_gain + 1);
+	if (avg_lum > MAX_AVG_LUM && cur_gain > sd->gain->minimum)
+		v4l2_ctrl_s_ctrl(sd->gain, cur_gain - 1);
 }
 
 static void sd_dqcallback(struct gspca_dev *gspca_dev)
@@ -2218,7 +2130,7 @@ static void sd_dqcallback(struct gspca_dev *gspca_dev)
 	struct sd *sd = (struct sd *) gspca_dev;
 	int avg_lum;
 
-	if (!sd->ctrls[AUTOGAIN].val)
+	if (!v4l2_ctrl_g_ctrl(sd->autogain))
 		return;
 
 	avg_lum = atomic_read(&sd->avg_lum);
@@ -2234,10 +2146,11 @@ static void qual_upd(struct work_struct *work)
 {
 	struct sd *sd = container_of(work, struct sd, work);
 	struct gspca_dev *gspca_dev = &sd->gspca_dev;
+	s32 qual = v4l2_ctrl_g_ctrl(sd->jpegqual);
 
 	mutex_lock(&gspca_dev->usb_lock);
-	PDEBUG(D_STREAM, "qual_upd %d%%", sd->ctrls[QUALITY].val);
-	set_quality(gspca_dev);
+	PDEBUG(D_STREAM, "qual_upd %d%%", qual);
+	set_quality(gspca_dev, qual);
 	mutex_unlock(&gspca_dev->usb_lock);
 }
 
@@ -2286,14 +2199,18 @@ static void transfer_check(struct gspca_dev *gspca_dev,
 	if (new_qual != 0) {
 		sd->nchg += new_qual;
 		if (sd->nchg < -6 || sd->nchg >= 12) {
+			/* Note: we are in interrupt context, so we can't
+			   use v4l2_ctrl_g/s_ctrl here. Access the value
+			   directly instead. */
+			s32 curqual = sd->jpegqual->cur.val;
 			sd->nchg = 0;
-			new_qual += sd->ctrls[QUALITY].val;
-			if (new_qual < QUALITY_MIN)
-				new_qual = QUALITY_MIN;
-			else if (new_qual > QUALITY_MAX)
-				new_qual = QUALITY_MAX;
-			if (new_qual != sd->ctrls[QUALITY].val) {
-				sd->ctrls[QUALITY].val = new_qual;
+			new_qual += curqual;
+			if (new_qual < sd->jpegqual->minimum)
+				new_qual = sd->jpegqual->minimum;
+			else if (new_qual > sd->jpegqual->maximum)
+				new_qual = sd->jpegqual->maximum;
+			if (new_qual != curqual) {
+				sd->jpegqual->cur.val = new_qual;
 				queue_work(sd->work_thread, &sd->work);
 			}
 		}
@@ -2373,8 +2290,6 @@ static void sd_pkt_scan(struct gspca_dev *gspca_dev,
 /* sub-driver description */
 static const struct sd_desc sd_desc = {
 	.name = KBUILD_MODNAME,
-	.ctrls = sd_ctrls,
-	.nctrls = ARRAY_SIZE(sd_ctrls),
 	.config = sd_config,
 	.init = sd_init,
 	.isoc_init = sd_isoc_init,
-- 
1.7.10

