Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr9.xs4all.nl ([194.109.24.29]:4898 "EHLO
	smtp-vbr9.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753391Ab2EFM2q (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 6 May 2012 08:28:46 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans de Goede <hdegoede@redhat.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv2 PATCH 16/17] gspca-stv06xx: convert to the control framework.
Date: Sun,  6 May 2012 14:28:30 +0200
Message-Id: <2781dfdaf90dcca2338e6610ea8f18bcbbf2c4f6.1336305565.git.hans.verkuil@cisco.com>
In-Reply-To: <1336307311-10227-1-git-send-email-hverkuil@xs4all.nl>
References: <1336307311-10227-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <a5a075c580858f4484be5c4cfadd195492858505.1336305565.git.hans.verkuil@cisco.com>
References: <a5a075c580858f4484be5c4cfadd195492858505.1336305565.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/video/gspca/stv06xx/stv06xx.c        |   24 +-
 drivers/media/video/gspca/stv06xx/stv06xx.h        |    4 +
 drivers/media/video/gspca/stv06xx/stv06xx_hdcs.c   |  140 ++------
 drivers/media/video/gspca/stv06xx/stv06xx_hdcs.h   |    7 +-
 drivers/media/video/gspca/stv06xx/stv06xx_pb0100.c |  357 ++++++--------------
 drivers/media/video/gspca/stv06xx/stv06xx_pb0100.h |   12 +-
 drivers/media/video/gspca/stv06xx/stv06xx_sensor.h |    4 +-
 drivers/media/video/gspca/stv06xx/stv06xx_st6422.c |  234 ++++---------
 drivers/media/video/gspca/stv06xx/stv06xx_st6422.h |    4 +-
 drivers/media/video/gspca/stv06xx/stv06xx_vv6410.c |  197 +++--------
 drivers/media/video/gspca/stv06xx/stv06xx_vv6410.h |    8 +-
 11 files changed, 282 insertions(+), 709 deletions(-)

diff --git a/drivers/media/video/gspca/stv06xx/stv06xx.c b/drivers/media/video/gspca/stv06xx/stv06xx.c
index 91d99b4..ecac7d0 100644
--- a/drivers/media/video/gspca/stv06xx/stv06xx.c
+++ b/drivers/media/video/gspca/stv06xx/stv06xx.c
@@ -261,6 +261,23 @@ static int stv06xx_init(struct gspca_dev *gspca_dev)
 	return (err < 0) ? err : 0;
 }
 
+/* this function is called at probe time */
+static int stv06xx_init_controls(struct gspca_dev *gspca_dev)
+{
+	struct sd *sd = (struct sd *) gspca_dev;
+	int err;
+
+	PDEBUG(D_PROBE, "Initializing controls");
+
+	err = sd->sensor->init_controls(sd);
+	if (err) {
+		v4l2_ctrl_handler_free(&sd->ctrl_handler);
+		return err;
+	}
+	gspca_dev->vdev.ctrl_handler = &sd->ctrl_handler;
+	return 0;
+}
+
 /* Start the camera */
 static int stv06xx_start(struct gspca_dev *gspca_dev)
 {
@@ -512,6 +529,7 @@ static const struct sd_desc sd_desc = {
 	.name = MODULE_NAME,
 	.config = stv06xx_config,
 	.init = stv06xx_init,
+	.init_controls = stv06xx_init_controls,
 	.start = stv06xx_start,
 	.stopN = stv06xx_stopN,
 	.pkt_scan = stv06xx_pkt_scan,
@@ -594,11 +612,12 @@ static void sd_disconnect(struct usb_interface *intf)
 {
 	struct gspca_dev *gspca_dev = usb_get_intfdata(intf);
 	struct sd *sd = (struct sd *) gspca_dev;
+	void *priv = sd->sensor_priv;
 	PDEBUG(D_PROBE, "Disconnecting the stv06xx device");
 
-	if (sd->sensor->disconnect)
-		sd->sensor->disconnect(sd);
+	sd->sensor = NULL;
 	gspca_disconnect(intf);
+	kfree(priv);
 }
 
 static struct usb_driver sd_driver = {
@@ -609,6 +628,7 @@ static struct usb_driver sd_driver = {
 #ifdef CONFIG_PM
 	.suspend = gspca_suspend,
 	.resume = gspca_resume,
+	.reset_resume = gspca_resume,
 #endif
 };
 
diff --git a/drivers/media/video/gspca/stv06xx/stv06xx.h b/drivers/media/video/gspca/stv06xx/stv06xx.h
index d270a59..e04c862 100644
--- a/drivers/media/video/gspca/stv06xx/stv06xx.h
+++ b/drivers/media/video/gspca/stv06xx/stv06xx.h
@@ -31,6 +31,7 @@
 #define STV06XX_H_
 
 #include <linux/slab.h>
+#include <media/v4l2-ctrls.h>
 #include "gspca.h"
 
 #define MODULE_NAME "STV06xx"
@@ -89,6 +90,9 @@ struct sd {
 	/* A pointer to the currently connected sensor */
 	const struct stv06xx_sensor *sensor;
 
+	/* Control handler */
+	struct v4l2_ctrl_handler ctrl_handler;
+
 	/* A pointer to the sd_desc struct */
 	struct sd_desc desc;
 
diff --git a/drivers/media/video/gspca/stv06xx/stv06xx_hdcs.c b/drivers/media/video/gspca/stv06xx/stv06xx_hdcs.c
index a8698b7..b124ee7 100644
--- a/drivers/media/video/gspca/stv06xx/stv06xx_hdcs.c
+++ b/drivers/media/video/gspca/stv06xx/stv06xx_hdcs.c
@@ -32,36 +32,6 @@
 
 #include "stv06xx_hdcs.h"
 
-static const struct ctrl hdcs1x00_ctrl[] = {
-	{
-		{
-			.id		= V4L2_CID_EXPOSURE,
-			.type		= V4L2_CTRL_TYPE_INTEGER,
-			.name		= "exposure",
-			.minimum	= 0x00,
-			.maximum	= 0xff,
-			.step		= 0x1,
-			.default_value	= HDCS_DEFAULT_EXPOSURE,
-			.flags		= V4L2_CTRL_FLAG_SLIDER
-		},
-		.set = hdcs_set_exposure,
-		.get = hdcs_get_exposure
-	}, {
-		{
-			.id		= V4L2_CID_GAIN,
-			.type		= V4L2_CTRL_TYPE_INTEGER,
-			.name		= "gain",
-			.minimum	= 0x00,
-			.maximum	= 0xff,
-			.step		= 0x1,
-			.default_value	= HDCS_DEFAULT_GAIN,
-			.flags		= V4L2_CTRL_FLAG_SLIDER
-		},
-		.set = hdcs_set_gain,
-		.get = hdcs_get_gain
-	}
-};
-
 static struct v4l2_pix_format hdcs1x00_mode[] = {
 	{
 		HDCS_1X00_DEF_WIDTH,
@@ -76,36 +46,6 @@ static struct v4l2_pix_format hdcs1x00_mode[] = {
 	}
 };
 
-static const struct ctrl hdcs1020_ctrl[] = {
-	{
-		{
-			.id		= V4L2_CID_EXPOSURE,
-			.type		= V4L2_CTRL_TYPE_INTEGER,
-			.name		= "exposure",
-			.minimum	= 0x00,
-			.maximum	= 0xffff,
-			.step		= 0x1,
-			.default_value	= HDCS_DEFAULT_EXPOSURE,
-			.flags		= V4L2_CTRL_FLAG_SLIDER
-		},
-		.set = hdcs_set_exposure,
-		.get = hdcs_get_exposure
-	}, {
-		{
-			.id		= V4L2_CID_GAIN,
-			.type		= V4L2_CTRL_TYPE_INTEGER,
-			.name		= "gain",
-			.minimum	= 0x00,
-			.maximum	= 0xff,
-			.step		= 0x1,
-			.default_value	= HDCS_DEFAULT_GAIN,
-			.flags		= V4L2_CTRL_FLAG_SLIDER
-		},
-		.set = hdcs_set_gain,
-		.get = hdcs_get_gain
-	}
-};
-
 static struct v4l2_pix_format hdcs1020_mode[] = {
 	{
 		HDCS_1020_DEF_WIDTH,
@@ -150,7 +90,6 @@ struct hdcs {
 	} exp;
 
 	int psmp;
-	u8 exp_cache, gain_cache;
 };
 
 static int hdcs_reg_write_seq(struct sd *sd, u8 reg, u8 *vals, u8 len)
@@ -232,16 +171,6 @@ static int hdcs_reset(struct sd *sd)
 	return err;
 }
 
-static int hdcs_get_exposure(struct gspca_dev *gspca_dev, __s32 *val)
-{
-	struct sd *sd = (struct sd *) gspca_dev;
-	struct hdcs *hdcs = sd->sensor_priv;
-
-	*val = hdcs->exp_cache;
-
-	return 0;
-}
-
 static int hdcs_set_exposure(struct gspca_dev *gspca_dev, __s32 val)
 {
 	struct sd *sd = (struct sd *) gspca_dev;
@@ -261,7 +190,6 @@ static int hdcs_set_exposure(struct gspca_dev *gspca_dev, __s32 val)
 	u8 exp[14];
 
 	val &= 0xff;
-	hdcs->exp_cache = val;
 
 	cycles = val * HDCS_CLK_FREQ_MHZ * 257;
 
@@ -336,12 +264,9 @@ static int hdcs_set_exposure(struct gspca_dev *gspca_dev, __s32 val)
 
 static int hdcs_set_gains(struct sd *sd, u8 g)
 {
-	struct hdcs *hdcs = sd->sensor_priv;
 	int err;
 	u8 gains[4];
 
-	hdcs->gain_cache = g;
-
 	/* the voltage gain Av = (1 + 19 * val / 127) * (1 + bit7) */
 	if (g > 127)
 		g = 0x80 | (g / 2);
@@ -352,17 +277,7 @@ static int hdcs_set_gains(struct sd *sd, u8 g)
 	gains[3] = g;
 
 	err = hdcs_reg_write_seq(sd, HDCS_ERECPGA, gains, 4);
-		return err;
-}
-
-static int hdcs_get_gain(struct gspca_dev *gspca_dev, __s32 *val)
-{
-	struct sd *sd = (struct sd *) gspca_dev;
-	struct hdcs *hdcs = sd->sensor_priv;
-
-	*val = hdcs->gain_cache;
-
-	return 0;
+	return err;
 }
 
 static int hdcs_set_gain(struct gspca_dev *gspca_dev, __s32 val)
@@ -420,6 +335,38 @@ static int hdcs_set_size(struct sd *sd,
 	return err;
 }
 
+static int hdcs_s_ctrl(struct v4l2_ctrl *ctrl)
+{
+	struct sd *sd = container_of(ctrl->handler, struct sd, ctrl_handler);
+	int err = -EINVAL;
+
+	switch (ctrl->id) {
+	case V4L2_CID_GAIN:
+		err = hdcs_set_gain(&sd->gspca_dev, ctrl->val);
+		break;
+	case V4L2_CID_EXPOSURE:
+		err = hdcs_set_exposure(&sd->gspca_dev, ctrl->val);
+		break;
+	}
+	return err;
+}
+
+static const struct v4l2_ctrl_ops hdcs_ctrl_ops = {
+	.s_ctrl = hdcs_s_ctrl,
+};
+
+static int hdcs_init_controls(struct sd *sd)
+{
+	struct v4l2_ctrl_handler *hdl = &sd->ctrl_handler;
+
+	v4l2_ctrl_handler_init(hdl, 2);
+	v4l2_ctrl_new_std(hdl, &hdcs_ctrl_ops,
+			V4L2_CID_EXPOSURE, 0, 0xff, 1, HDCS_DEFAULT_EXPOSURE);
+	v4l2_ctrl_new_std(hdl, &hdcs_ctrl_ops,
+			V4L2_CID_GAIN, 0, 0xff, 1, HDCS_DEFAULT_GAIN);
+	return hdl->error;
+}
+
 static int hdcs_probe_1x00(struct sd *sd)
 {
 	struct hdcs *hdcs;
@@ -434,8 +381,6 @@ static int hdcs_probe_1x00(struct sd *sd)
 
 	sd->gspca_dev.cam.cam_mode = hdcs1x00_mode;
 	sd->gspca_dev.cam.nmodes = ARRAY_SIZE(hdcs1x00_mode);
-	sd->desc.ctrls = hdcs1x00_ctrl;
-	sd->desc.nctrls = ARRAY_SIZE(hdcs1x00_ctrl);
 
 	hdcs = kmalloc(sizeof(struct hdcs), GFP_KERNEL);
 	if (!hdcs)
@@ -493,8 +438,6 @@ static int hdcs_probe_1020(struct sd *sd)
 
 	sd->gspca_dev.cam.cam_mode = hdcs1020_mode;
 	sd->gspca_dev.cam.nmodes = ARRAY_SIZE(hdcs1020_mode);
-	sd->desc.ctrls = hdcs1020_ctrl;
-	sd->desc.nctrls = ARRAY_SIZE(hdcs1020_ctrl);
 
 	hdcs = kmalloc(sizeof(struct hdcs), GFP_KERNEL);
 	if (!hdcs)
@@ -537,12 +480,6 @@ static int hdcs_stop(struct sd *sd)
 	return hdcs_set_state(sd, HDCS_STATE_SLEEP);
 }
 
-static void hdcs_disconnect(struct sd *sd)
-{
-	PDEBUG(D_PROBE, "Disconnecting the sensor");
-	kfree(sd->sensor_priv);
-}
-
 static int hdcs_init(struct sd *sd)
 {
 	struct hdcs *hdcs = sd->sensor_priv;
@@ -587,16 +524,7 @@ static int hdcs_init(struct sd *sd)
 	if (err < 0)
 		return err;
 
-	err = hdcs_set_gains(sd, HDCS_DEFAULT_GAIN);
-	if (err < 0)
-		return err;
-
-	err = hdcs_set_size(sd, hdcs->array.width, hdcs->array.height);
-	if (err < 0)
-		return err;
-
-	err = hdcs_set_exposure(&sd->gspca_dev, HDCS_DEFAULT_EXPOSURE);
-	return err;
+	return hdcs_set_size(sd, hdcs->array.width, hdcs->array.height);
 }
 
 static int hdcs_dump(struct sd *sd)
diff --git a/drivers/media/video/gspca/stv06xx/stv06xx_hdcs.h b/drivers/media/video/gspca/stv06xx/stv06xx_hdcs.h
index a14a84a..1ba9158 100644
--- a/drivers/media/video/gspca/stv06xx/stv06xx_hdcs.h
+++ b/drivers/media/video/gspca/stv06xx/stv06xx_hdcs.h
@@ -131,14 +131,12 @@ static int hdcs_probe_1x00(struct sd *sd);
 static int hdcs_probe_1020(struct sd *sd);
 static int hdcs_start(struct sd *sd);
 static int hdcs_init(struct sd *sd);
+static int hdcs_init_controls(struct sd *sd);
 static int hdcs_stop(struct sd *sd);
 static int hdcs_dump(struct sd *sd);
-static void hdcs_disconnect(struct sd *sd);
 
-static int hdcs_get_exposure(struct gspca_dev *gspca_dev, __s32 *val);
 static int hdcs_set_exposure(struct gspca_dev *gspca_dev, __s32 val);
 static int hdcs_set_gain(struct gspca_dev *gspca_dev, __s32 val);
-static int hdcs_get_gain(struct gspca_dev *gspca_dev, __s32 *val);
 
 const struct stv06xx_sensor stv06xx_sensor_hdcs1x00 = {
 	.name = "HP HDCS-1000/1100",
@@ -152,10 +150,10 @@ const struct stv06xx_sensor stv06xx_sensor_hdcs1x00 = {
 	.max_packet_size = { 847 },
 
 	.init = hdcs_init,
+	.init_controls = hdcs_init_controls,
 	.probe = hdcs_probe_1x00,
 	.start = hdcs_start,
 	.stop = hdcs_stop,
-	.disconnect = hdcs_disconnect,
 	.dump = hdcs_dump,
 };
 
@@ -171,6 +169,7 @@ const struct stv06xx_sensor stv06xx_sensor_hdcs1020 = {
 	.max_packet_size = { 847 },
 
 	.init = hdcs_init,
+	.init_controls = hdcs_init_controls,
 	.probe = hdcs_probe_1020,
 	.start = hdcs_start,
 	.stop = hdcs_stop,
diff --git a/drivers/media/video/gspca/stv06xx/stv06xx_pb0100.c b/drivers/media/video/gspca/stv06xx/stv06xx_pb0100.c
index 26f14fc..c03b13e 100644
--- a/drivers/media/video/gspca/stv06xx/stv06xx_pb0100.c
+++ b/drivers/media/video/gspca/stv06xx/stv06xx_pb0100.c
@@ -48,105 +48,16 @@
 
 #include "stv06xx_pb0100.h"
 
-static const struct ctrl pb0100_ctrl[] = {
-#define GAIN_IDX 0
-	{
-		{
-			.id		= V4L2_CID_GAIN,
-			.type		= V4L2_CTRL_TYPE_INTEGER,
-			.name		= "Gain",
-			.minimum	= 0,
-			.maximum	= 255,
-			.step		= 1,
-			.default_value  = 128
-		},
-		.set = pb0100_set_gain,
-		.get = pb0100_get_gain
-	},
-#define RED_BALANCE_IDX 1
-	{
-		{
-			.id		= V4L2_CID_RED_BALANCE,
-			.type		= V4L2_CTRL_TYPE_INTEGER,
-			.name		= "Red Balance",
-			.minimum	= -255,
-			.maximum	= 255,
-			.step		= 1,
-			.default_value  = 0
-		},
-		.set = pb0100_set_red_balance,
-		.get = pb0100_get_red_balance
-	},
-#define BLUE_BALANCE_IDX 2
-	{
-		{
-			.id		= V4L2_CID_BLUE_BALANCE,
-			.type		= V4L2_CTRL_TYPE_INTEGER,
-			.name		= "Blue Balance",
-			.minimum	= -255,
-			.maximum	= 255,
-			.step		= 1,
-			.default_value  = 0
-		},
-		.set = pb0100_set_blue_balance,
-		.get = pb0100_get_blue_balance
-	},
-#define EXPOSURE_IDX 3
-	{
-		{
-			.id		= V4L2_CID_EXPOSURE,
-			.type		= V4L2_CTRL_TYPE_INTEGER,
-			.name		= "Exposure",
-			.minimum	= 0,
-			.maximum	= 511,
-			.step		= 1,
-			.default_value  = 12
-		},
-		.set = pb0100_set_exposure,
-		.get = pb0100_get_exposure
-	},
-#define AUTOGAIN_IDX 4
-	{
-		{
-			.id		= V4L2_CID_AUTOGAIN,
-			.type		= V4L2_CTRL_TYPE_BOOLEAN,
-			.name		= "Automatic Gain and Exposure",
-			.minimum	= 0,
-			.maximum	= 1,
-			.step		= 1,
-			.default_value  = 1
-		},
-		.set = pb0100_set_autogain,
-		.get = pb0100_get_autogain
-	},
-#define AUTOGAIN_TARGET_IDX 5
-	{
-		{
-			.id		= V4L2_CTRL_CLASS_USER + 0x1000,
-			.type		= V4L2_CTRL_TYPE_INTEGER,
-			.name		= "Automatic Gain Target",
-			.minimum	= 0,
-			.maximum	= 255,
-			.step		= 1,
-			.default_value  = 128
-		},
-		.set = pb0100_set_autogain_target,
-		.get = pb0100_get_autogain_target
-	},
-#define NATURAL_IDX 6
-	{
-		{
-			.id		= V4L2_CTRL_CLASS_USER + 0x1001,
-			.type		= V4L2_CTRL_TYPE_BOOLEAN,
-			.name		= "Natural Light Source",
-			.minimum	= 0,
-			.maximum	= 1,
-			.step		= 1,
-			.default_value  = 1
-		},
-		.set = pb0100_set_natural,
-		.get = pb0100_get_natural
-	}
+struct pb0100_ctrls {
+	struct { /* one big happy control cluster... */
+		struct v4l2_ctrl *autogain;
+		struct v4l2_ctrl *gain;
+		struct v4l2_ctrl *exposure;
+		struct v4l2_ctrl *red;
+		struct v4l2_ctrl *blue;
+		struct v4l2_ctrl *natural;
+	};
+	struct v4l2_ctrl *target;
 };
 
 static struct v4l2_pix_format pb0100_mode[] = {
@@ -174,38 +85,102 @@ static struct v4l2_pix_format pb0100_mode[] = {
 	}
 };
 
+static int pb0100_s_ctrl(struct v4l2_ctrl *ctrl)
+{
+	struct sd *sd = container_of(ctrl->handler, struct sd, ctrl_handler);
+	struct pb0100_ctrls *ctrls = sd->sensor_priv;
+	int err = -EINVAL;
+
+	switch (ctrl->id) {
+	case V4L2_CID_AUTOGAIN:
+		err = pb0100_set_autogain(&sd->gspca_dev, ctrl->val);
+		if (err)
+			break;
+		if (ctrl->val)
+			break;
+		err = pb0100_set_gain(&sd->gspca_dev, ctrls->gain->val);
+		if (err)
+			break;
+		err = pb0100_set_exposure(&sd->gspca_dev, ctrls->exposure->val);
+		break;
+	case V4L2_CTRL_CLASS_USER + 0x1001:
+		err = pb0100_set_autogain_target(&sd->gspca_dev, ctrl->val);
+		break;
+	}
+	return err;
+}
+
+static const struct v4l2_ctrl_ops pb0100_ctrl_ops = {
+	.s_ctrl = pb0100_s_ctrl,
+};
+
+static int pb0100_init_controls(struct sd *sd)
+{
+	struct v4l2_ctrl_handler *hdl = &sd->ctrl_handler;
+	struct pb0100_ctrls *ctrls;
+	static const struct v4l2_ctrl_config autogain_target = {
+		.ops = &pb0100_ctrl_ops,
+		.id = V4L2_CTRL_CLASS_USER + 0x1000,
+		.type = V4L2_CTRL_TYPE_INTEGER,
+		.name = "Automatic Gain Target",
+		.max = 255,
+		.step = 1,
+		.def = 128,
+	};
+	static const struct v4l2_ctrl_config natural_light = {
+		.ops = &pb0100_ctrl_ops,
+		.id = V4L2_CTRL_CLASS_USER + 0x1001,
+		.type = V4L2_CTRL_TYPE_BOOLEAN,
+		.name = "Natural Light Source",
+		.max = 1,
+		.step = 1,
+		.def = 1,
+	};
+
+	ctrls = kzalloc(sizeof(*ctrls), GFP_KERNEL);
+	if (!ctrls)
+		return -ENOMEM;
+
+	v4l2_ctrl_handler_init(hdl, 6);
+	ctrls->autogain = v4l2_ctrl_new_std(hdl, &pb0100_ctrl_ops,
+			V4L2_CID_AUTOGAIN, 0, 1, 1, 1);
+	ctrls->exposure = v4l2_ctrl_new_std(hdl, &pb0100_ctrl_ops,
+			V4L2_CID_EXPOSURE, 0, 511, 1, 12);
+	ctrls->gain = v4l2_ctrl_new_std(hdl, &pb0100_ctrl_ops,
+			V4L2_CID_GAIN, 0, 255, 1, 128);
+	ctrls->red = v4l2_ctrl_new_std(hdl, &pb0100_ctrl_ops,
+			V4L2_CID_RED_BALANCE, -255, 255, 1, 0);
+	ctrls->blue = v4l2_ctrl_new_std(hdl, &pb0100_ctrl_ops,
+			V4L2_CID_BLUE_BALANCE, -255, 255, 1, 0);
+	ctrls->natural = v4l2_ctrl_new_custom(hdl, &natural_light, NULL);
+	ctrls->target = v4l2_ctrl_new_custom(hdl, &autogain_target, NULL);
+	if (hdl->error) {
+		kfree(ctrls);
+		return hdl->error;
+	}
+	sd->sensor_priv = ctrls;
+	v4l2_ctrl_auto_cluster(5, &ctrls->autogain, 0, false);
+	return 0;
+}
+
 static int pb0100_probe(struct sd *sd)
 {
 	u16 sensor;
-	int i, err;
-	s32 *sensor_settings;
+	int err;
 
 	err = stv06xx_read_sensor(sd, PB_IDENT, &sensor);
 
 	if (err < 0)
 		return -ENODEV;
+	if ((sensor >> 8) != 0x64)
+		return -ENODEV;
 
-	if ((sensor >> 8) == 0x64) {
-		sensor_settings = kmalloc(
-				ARRAY_SIZE(pb0100_ctrl) * sizeof(s32),
-				GFP_KERNEL);
-		if (!sensor_settings)
-			return -ENOMEM;
-
-		pr_info("Photobit pb0100 sensor detected\n");
-
-		sd->gspca_dev.cam.cam_mode = pb0100_mode;
-		sd->gspca_dev.cam.nmodes = ARRAY_SIZE(pb0100_mode);
-		sd->desc.ctrls = pb0100_ctrl;
-		sd->desc.nctrls = ARRAY_SIZE(pb0100_ctrl);
-		for (i = 0; i < sd->desc.nctrls; i++)
-			sensor_settings[i] = pb0100_ctrl[i].qctrl.default_value;
-		sd->sensor_priv = sensor_settings;
+	pr_info("Photobit pb0100 sensor detected\n");
 
-		return 0;
-	}
+	sd->gspca_dev.cam.cam_mode = pb0100_mode;
+	sd->gspca_dev.cam.nmodes = ARRAY_SIZE(pb0100_mode);
 
-	return -ENODEV;
+	return 0;
 }
 
 static int pb0100_start(struct sd *sd)
@@ -214,7 +189,6 @@ static int pb0100_start(struct sd *sd)
 	struct usb_host_interface *alt;
 	struct usb_interface *intf;
 	struct cam *cam = &sd->gspca_dev.cam;
-	s32 *sensor_settings = sd->sensor_priv;
 	u32 mode = cam->cam_mode[sd->gspca_dev.curr_mode].priv;
 
 	intf = usb_ifnum_to_if(sd->gspca_dev.dev, sd->gspca_dev.iface);
@@ -255,13 +229,6 @@ static int pb0100_start(struct sd *sd)
 		stv06xx_write_bridge(sd, STV_SCAN_RATE, 0x20);
 	}
 
-	/* set_gain also sets red and blue balance */
-	pb0100_set_gain(&sd->gspca_dev, sensor_settings[GAIN_IDX]);
-	pb0100_set_exposure(&sd->gspca_dev, sensor_settings[EXPOSURE_IDX]);
-	pb0100_set_autogain_target(&sd->gspca_dev,
-				   sensor_settings[AUTOGAIN_TARGET_IDX]);
-	pb0100_set_autogain(&sd->gspca_dev, sensor_settings[AUTOGAIN_IDX]);
-
 	err = stv06xx_write_sensor(sd, PB_CONTROL, BIT(5)|BIT(3)|BIT(1));
 	PDEBUG(D_STREAM, "Started stream, status: %d", err);
 
@@ -285,12 +252,6 @@ out:
 	return (err < 0) ? err : 0;
 }
 
-static void pb0100_disconnect(struct sd *sd)
-{
-	sd->sensor = NULL;
-	kfree(sd->sensor_priv);
-}
-
 /* FIXME: Sort the init commands out and put them into tables,
 	  this is only for getting the camera to work */
 /* FIXME: No error handling for now,
@@ -362,62 +323,32 @@ static int pb0100_dump(struct sd *sd)
 	return 0;
 }
 
-static int pb0100_get_gain(struct gspca_dev *gspca_dev, __s32 *val)
-{
-	struct sd *sd = (struct sd *) gspca_dev;
-	s32 *sensor_settings = sd->sensor_priv;
-
-	*val = sensor_settings[GAIN_IDX];
-
-	return 0;
-}
-
 static int pb0100_set_gain(struct gspca_dev *gspca_dev, __s32 val)
 {
 	int err;
 	struct sd *sd = (struct sd *) gspca_dev;
-	s32 *sensor_settings = sd->sensor_priv;
+	struct pb0100_ctrls *ctrls = sd->sensor_priv;
 
-	if (sensor_settings[AUTOGAIN_IDX])
-		return -EBUSY;
-
-	sensor_settings[GAIN_IDX] = val;
 	err = stv06xx_write_sensor(sd, PB_G1GAIN, val);
 	if (!err)
 		err = stv06xx_write_sensor(sd, PB_G2GAIN, val);
 	PDEBUG(D_V4L2, "Set green gain to %d, status: %d", val, err);
 
 	if (!err)
-		err = pb0100_set_red_balance(gspca_dev,
-					     sensor_settings[RED_BALANCE_IDX]);
+		err = pb0100_set_red_balance(gspca_dev, ctrls->red->val);
 	if (!err)
-		err = pb0100_set_blue_balance(gspca_dev,
-					    sensor_settings[BLUE_BALANCE_IDX]);
+		err = pb0100_set_blue_balance(gspca_dev, ctrls->blue->val);
 
 	return err;
 }
 
-static int pb0100_get_red_balance(struct gspca_dev *gspca_dev, __s32 *val)
-{
-	struct sd *sd = (struct sd *) gspca_dev;
-	s32 *sensor_settings = sd->sensor_priv;
-
-	*val = sensor_settings[RED_BALANCE_IDX];
-
-	return 0;
-}
-
 static int pb0100_set_red_balance(struct gspca_dev *gspca_dev, __s32 val)
 {
 	int err;
 	struct sd *sd = (struct sd *) gspca_dev;
-	s32 *sensor_settings = sd->sensor_priv;
+	struct pb0100_ctrls *ctrls = sd->sensor_priv;
 
-	if (sensor_settings[AUTOGAIN_IDX])
-		return -EBUSY;
-
-	sensor_settings[RED_BALANCE_IDX] = val;
-	val += sensor_settings[GAIN_IDX];
+	val += ctrls->gain->val;
 	if (val < 0)
 		val = 0;
 	else if (val > 255)
@@ -429,27 +360,13 @@ static int pb0100_set_red_balance(struct gspca_dev *gspca_dev, __s32 val)
 	return err;
 }
 
-static int pb0100_get_blue_balance(struct gspca_dev *gspca_dev, __s32 *val)
-{
-	struct sd *sd = (struct sd *) gspca_dev;
-	s32 *sensor_settings = sd->sensor_priv;
-
-	*val = sensor_settings[BLUE_BALANCE_IDX];
-
-	return 0;
-}
-
 static int pb0100_set_blue_balance(struct gspca_dev *gspca_dev, __s32 val)
 {
 	int err;
 	struct sd *sd = (struct sd *) gspca_dev;
-	s32 *sensor_settings = sd->sensor_priv;
+	struct pb0100_ctrls *ctrls = sd->sensor_priv;
 
-	if (sensor_settings[AUTOGAIN_IDX])
-		return -EBUSY;
-
-	sensor_settings[BLUE_BALANCE_IDX] = val;
-	val += sensor_settings[GAIN_IDX];
+	val += ctrls->gain->val;
 	if (val < 0)
 		val = 0;
 	else if (val > 255)
@@ -461,51 +378,25 @@ static int pb0100_set_blue_balance(struct gspca_dev *gspca_dev, __s32 val)
 	return err;
 }
 
-static int pb0100_get_exposure(struct gspca_dev *gspca_dev, __s32 *val)
-{
-	struct sd *sd = (struct sd *) gspca_dev;
-	s32 *sensor_settings = sd->sensor_priv;
-
-	*val = sensor_settings[EXPOSURE_IDX];
-
-	return 0;
-}
-
 static int pb0100_set_exposure(struct gspca_dev *gspca_dev, __s32 val)
 {
-	int err;
 	struct sd *sd = (struct sd *) gspca_dev;
-	s32 *sensor_settings = sd->sensor_priv;
-
-	if (sensor_settings[AUTOGAIN_IDX])
-		return -EBUSY;
+	int err;
 
-	sensor_settings[EXPOSURE_IDX] = val;
 	err = stv06xx_write_sensor(sd, PB_RINTTIME, val);
 	PDEBUG(D_V4L2, "Set exposure to %d, status: %d", val, err);
 
 	return err;
 }
 
-static int pb0100_get_autogain(struct gspca_dev *gspca_dev, __s32 *val)
-{
-	struct sd *sd = (struct sd *) gspca_dev;
-	s32 *sensor_settings = sd->sensor_priv;
-
-	*val = sensor_settings[AUTOGAIN_IDX];
-
-	return 0;
-}
-
 static int pb0100_set_autogain(struct gspca_dev *gspca_dev, __s32 val)
 {
 	int err;
 	struct sd *sd = (struct sd *) gspca_dev;
-	s32 *sensor_settings = sd->sensor_priv;
+	struct pb0100_ctrls *ctrls = sd->sensor_priv;
 
-	sensor_settings[AUTOGAIN_IDX] = val;
-	if (sensor_settings[AUTOGAIN_IDX]) {
-		if (sensor_settings[NATURAL_IDX])
+	if (val) {
+		if (ctrls->natural->val)
 			val = BIT(6)|BIT(4)|BIT(0);
 		else
 			val = BIT(4)|BIT(0);
@@ -514,29 +405,15 @@ static int pb0100_set_autogain(struct gspca_dev *gspca_dev, __s32 val)
 
 	err = stv06xx_write_sensor(sd, PB_EXPGAIN, val);
 	PDEBUG(D_V4L2, "Set autogain to %d (natural: %d), status: %d",
-	       sensor_settings[AUTOGAIN_IDX], sensor_settings[NATURAL_IDX],
-	       err);
+	       val, ctrls->natural->val, err);
 
 	return err;
 }
 
-static int pb0100_get_autogain_target(struct gspca_dev *gspca_dev, __s32 *val)
-{
-	struct sd *sd = (struct sd *) gspca_dev;
-	s32 *sensor_settings = sd->sensor_priv;
-
-	*val = sensor_settings[AUTOGAIN_TARGET_IDX];
-
-	return 0;
-}
-
 static int pb0100_set_autogain_target(struct gspca_dev *gspca_dev, __s32 val)
 {
 	int err, totalpixels, brightpixels, darkpixels;
 	struct sd *sd = (struct sd *) gspca_dev;
-	s32 *sensor_settings = sd->sensor_priv;
-
-	sensor_settings[AUTOGAIN_TARGET_IDX] = val;
 
 	/* Number of pixels counted by the sensor when subsampling the pixels.
 	 * Slightly larger than the real value to avoid oscillation */
@@ -553,23 +430,3 @@ static int pb0100_set_autogain_target(struct gspca_dev *gspca_dev, __s32 val)
 
 	return err;
 }
-
-static int pb0100_get_natural(struct gspca_dev *gspca_dev, __s32 *val)
-{
-	struct sd *sd = (struct sd *) gspca_dev;
-	s32 *sensor_settings = sd->sensor_priv;
-
-	*val = sensor_settings[NATURAL_IDX];
-
-	return 0;
-}
-
-static int pb0100_set_natural(struct gspca_dev *gspca_dev, __s32 val)
-{
-	struct sd *sd = (struct sd *) gspca_dev;
-	s32 *sensor_settings = sd->sensor_priv;
-
-	sensor_settings[NATURAL_IDX] = val;
-
-	return pb0100_set_autogain(gspca_dev, sensor_settings[AUTOGAIN_IDX]);
-}
diff --git a/drivers/media/video/gspca/stv06xx/stv06xx_pb0100.h b/drivers/media/video/gspca/stv06xx/stv06xx_pb0100.h
index 757de24..5071e53 100644
--- a/drivers/media/video/gspca/stv06xx/stv06xx_pb0100.h
+++ b/drivers/media/video/gspca/stv06xx/stv06xx_pb0100.h
@@ -112,25 +112,17 @@
 static int pb0100_probe(struct sd *sd);
 static int pb0100_start(struct sd *sd);
 static int pb0100_init(struct sd *sd);
+static int pb0100_init_controls(struct sd *sd);
 static int pb0100_stop(struct sd *sd);
 static int pb0100_dump(struct sd *sd);
-static void pb0100_disconnect(struct sd *sd);
 
 /* V4L2 controls supported by the driver */
-static int pb0100_get_gain(struct gspca_dev *gspca_dev, __s32 *val);
 static int pb0100_set_gain(struct gspca_dev *gspca_dev, __s32 val);
-static int pb0100_get_red_balance(struct gspca_dev *gspca_dev, __s32 *val);
 static int pb0100_set_red_balance(struct gspca_dev *gspca_dev, __s32 val);
-static int pb0100_get_blue_balance(struct gspca_dev *gspca_dev, __s32 *val);
 static int pb0100_set_blue_balance(struct gspca_dev *gspca_dev, __s32 val);
-static int pb0100_get_exposure(struct gspca_dev *gspca_dev, __s32 *val);
 static int pb0100_set_exposure(struct gspca_dev *gspca_dev, __s32 val);
-static int pb0100_get_autogain(struct gspca_dev *gspca_dev, __s32 *val);
 static int pb0100_set_autogain(struct gspca_dev *gspca_dev, __s32 val);
-static int pb0100_get_autogain_target(struct gspca_dev *gspca_dev, __s32 *val);
 static int pb0100_set_autogain_target(struct gspca_dev *gspca_dev, __s32 val);
-static int pb0100_get_natural(struct gspca_dev *gspca_dev, __s32 *val);
-static int pb0100_set_natural(struct gspca_dev *gspca_dev, __s32 val);
 
 const struct stv06xx_sensor stv06xx_sensor_pb0100 = {
 	.name = "PB-0100",
@@ -142,11 +134,11 @@ const struct stv06xx_sensor stv06xx_sensor_pb0100 = {
 	.max_packet_size = { 847, 923 },
 
 	.init = pb0100_init,
+	.init_controls = pb0100_init_controls,
 	.probe = pb0100_probe,
 	.start = pb0100_start,
 	.stop = pb0100_stop,
 	.dump = pb0100_dump,
-	.disconnect = pb0100_disconnect,
 };
 
 #endif
diff --git a/drivers/media/video/gspca/stv06xx/stv06xx_sensor.h b/drivers/media/video/gspca/stv06xx/stv06xx_sensor.h
index fb229d8..3a498c2 100644
--- a/drivers/media/video/gspca/stv06xx/stv06xx_sensor.h
+++ b/drivers/media/video/gspca/stv06xx/stv06xx_sensor.h
@@ -63,8 +63,8 @@ struct stv06xx_sensor {
 	/* Performs a initialization sequence */
 	int (*init)(struct sd *sd);
 
-	/* Executed at device disconnect */
-	void (*disconnect)(struct sd *sd);
+	/* Initializes the controls */
+	int (*init_controls)(struct sd *sd);
 
 	/* Reads a sensor register */
 	int (*read_sensor)(struct sd *sd, const u8 address,
diff --git a/drivers/media/video/gspca/stv06xx/stv06xx_st6422.c b/drivers/media/video/gspca/stv06xx/stv06xx_st6422.c
index 9940e03..bbfe821 100644
--- a/drivers/media/video/gspca/stv06xx/stv06xx_st6422.c
+++ b/drivers/media/video/gspca/stv06xx/stv06xx_st6422.c
@@ -30,20 +30,6 @@
 
 #include "stv06xx_st6422.h"
 
-/* controls */
-enum e_ctrl {
-	BRIGHTNESS,
-	CONTRAST,
-	GAIN,
-	EXPOSURE,
-	NCTRLS		/* number of controls */
-};
-
-/* sensor settings */
-struct st6422_settings {
-	struct gspca_ctrl ctrls[NCTRLS];
-};
-
 static struct v4l2_pix_format st6422_mode[] = {
 	/* Note we actually get 124 lines of data, of which we skip the 4st
 	   4 as they are garbage */
@@ -74,83 +60,68 @@ static struct v4l2_pix_format st6422_mode[] = {
 };
 
 /* V4L2 controls supported by the driver */
-static void st6422_set_brightness(struct gspca_dev *gspca_dev);
-static void st6422_set_contrast(struct gspca_dev *gspca_dev);
-static void st6422_set_gain(struct gspca_dev *gspca_dev);
-static void st6422_set_exposure(struct gspca_dev *gspca_dev);
-
-static const struct ctrl st6422_ctrl[NCTRLS] = {
-[BRIGHTNESS] = {
-		{
-			.id		= V4L2_CID_BRIGHTNESS,
-			.type		= V4L2_CTRL_TYPE_INTEGER,
-			.name		= "Brightness",
-			.minimum	= 0,
-			.maximum	= 31,
-			.step		= 1,
-			.default_value  = 3
-		},
-		.set_control = st6422_set_brightness
-	},
-[CONTRAST] = {
-		{
-			.id		= V4L2_CID_CONTRAST,
-			.type		= V4L2_CTRL_TYPE_INTEGER,
-			.name		= "Contrast",
-			.minimum	= 0,
-			.maximum	= 15,
-			.step		= 1,
-			.default_value  = 11
-		},
-		.set_control = st6422_set_contrast
-	},
-[GAIN] = {
-		{
-			.id		= V4L2_CID_GAIN,
-			.type		= V4L2_CTRL_TYPE_INTEGER,
-			.name		= "Gain",
-			.minimum	= 0,
-			.maximum	= 255,
-			.step		= 1,
-			.default_value  = 64
-		},
-		.set_control = st6422_set_gain
-	},
-[EXPOSURE] = {
-		{
-			.id		= V4L2_CID_EXPOSURE,
-			.type		= V4L2_CTRL_TYPE_INTEGER,
-			.name		= "Exposure",
-			.minimum	= 0,
-#define EXPOSURE_MAX 1023
-			.maximum	= EXPOSURE_MAX,
-			.step		= 1,
-			.default_value  = 256
-		},
-		.set_control = st6422_set_exposure
-	},
+static int setbrightness(struct sd *sd, s32 val);
+static int setcontrast(struct sd *sd, s32 val);
+static int setgain(struct sd *sd, u8 gain);
+static int setexposure(struct sd *sd, s16 expo);
+
+static int st6422_s_ctrl(struct v4l2_ctrl *ctrl)
+{
+	struct sd *sd = container_of(ctrl->handler, struct sd, ctrl_handler);
+	int err = -EINVAL;
+
+	switch (ctrl->id) {
+	case V4L2_CID_BRIGHTNESS:
+		err = setbrightness(sd, ctrl->val);
+		break;
+	case V4L2_CID_CONTRAST:
+		err = setcontrast(sd, ctrl->val);
+		break;
+	case V4L2_CID_GAIN:
+		err = setgain(sd, ctrl->val);
+		break;
+	case V4L2_CID_EXPOSURE:
+		err = setexposure(sd, ctrl->val);
+		break;
+	}
+
+	/* commit settings */
+	if (err >= 0)
+		err = stv06xx_write_bridge(sd, 0x143f, 0x01);
+	sd->gspca_dev.usb_err = err;
+	return err;
+}
+
+static const struct v4l2_ctrl_ops st6422_ctrl_ops = {
+	.s_ctrl = st6422_s_ctrl,
 };
 
-static int st6422_probe(struct sd *sd)
+static int st6422_init_controls(struct sd *sd)
 {
-	struct st6422_settings *sensor_settings;
+	struct v4l2_ctrl_handler *hdl = &sd->ctrl_handler;
+
+	v4l2_ctrl_handler_init(hdl, 4);
+	v4l2_ctrl_new_std(hdl, &st6422_ctrl_ops,
+			V4L2_CID_BRIGHTNESS, 0, 31, 1, 3);
+	v4l2_ctrl_new_std(hdl, &st6422_ctrl_ops,
+			V4L2_CID_CONTRAST, 0, 15, 1, 11);
+	v4l2_ctrl_new_std(hdl, &st6422_ctrl_ops,
+			V4L2_CID_EXPOSURE, 0, 1023, 1, 256);
+	v4l2_ctrl_new_std(hdl, &st6422_ctrl_ops,
+			V4L2_CID_GAIN, 0, 255, 1, 64);
+
+	return hdl->error;
+}
 
+static int st6422_probe(struct sd *sd)
+{
 	if (sd->bridge != BRIDGE_ST6422)
 		return -ENODEV;
 
 	pr_info("st6422 sensor detected\n");
 
-	sensor_settings = kmalloc(sizeof *sensor_settings, GFP_KERNEL);
-	if (!sensor_settings)
-		return -ENOMEM;
-
 	sd->gspca_dev.cam.cam_mode = st6422_mode;
 	sd->gspca_dev.cam.nmodes = ARRAY_SIZE(st6422_mode);
-	sd->gspca_dev.cam.ctrls = sensor_settings->ctrls;
-	sd->desc.ctrls = st6422_ctrl;
-	sd->desc.nctrls = ARRAY_SIZE(st6422_ctrl);
-	sd->sensor_priv = sensor_settings;
-
 	return 0;
 }
 
@@ -239,38 +210,22 @@ static int st6422_init(struct sd *sd)
 	return err;
 }
 
-static void st6422_disconnect(struct sd *sd)
-{
-	sd->sensor = NULL;
-	kfree(sd->sensor_priv);
-}
-
-static int setbrightness(struct sd *sd)
+static int setbrightness(struct sd *sd, s32 val)
 {
-	struct st6422_settings *sensor_settings = sd->sensor_priv;
-
 	/* val goes from 0 -> 31 */
-	return stv06xx_write_bridge(sd, 0x1432,
-			sensor_settings->ctrls[BRIGHTNESS].val);
+	return stv06xx_write_bridge(sd, 0x1432, val);
 }
 
-static int setcontrast(struct sd *sd)
+static int setcontrast(struct sd *sd, s32 val)
 {
-	struct st6422_settings *sensor_settings = sd->sensor_priv;
-
 	/* Val goes from 0 -> 15 */
-	return stv06xx_write_bridge(sd, 0x143a,
-			sensor_settings->ctrls[CONTRAST].val | 0xf0);
+	return stv06xx_write_bridge(sd, 0x143a, val | 0xf0);
 }
 
-static int setgain(struct sd *sd)
+static int setgain(struct sd *sd, u8 gain)
 {
-	struct st6422_settings *sensor_settings = sd->sensor_priv;
-	u8 gain;
 	int err;
 
-	gain = sensor_settings->ctrls[GAIN].val;
-
 	/* Set red, green, blue, gain */
 	err = stv06xx_write_bridge(sd, 0x0509, gain);
 	if (err < 0)
@@ -292,13 +247,10 @@ static int setgain(struct sd *sd)
 	return stv06xx_write_bridge(sd, 0x050d, 0x01);
 }
 
-static int setexposure(struct sd *sd)
+static int setexposure(struct sd *sd, s16 expo)
 {
-	struct st6422_settings *sensor_settings = sd->sensor_priv;
-	u16 expo;
 	int err;
 
-	expo = sensor_settings->ctrls[EXPOSURE].val;
 	err = stv06xx_write_bridge(sd, 0x143d, expo & 0xff);
 	if (err < 0)
 		return err;
@@ -318,22 +270,6 @@ static int st6422_start(struct sd *sd)
 	if (err < 0)
 		return err;
 
-	err = setbrightness(sd);
-	if (err < 0)
-		return err;
-
-	err = setcontrast(sd);
-	if (err < 0)
-		return err;
-
-	err = setexposure(sd);
-	if (err < 0)
-		return err;
-
-	err = setgain(sd);
-	if (err < 0)
-		return err;
-
 	/* commit settings */
 	err = stv06xx_write_bridge(sd, 0x143f, 0x01);
 	return (err < 0) ? err : 0;
@@ -345,59 +281,3 @@ static int st6422_stop(struct sd *sd)
 
 	return 0;
 }
-
-static void st6422_set_brightness(struct gspca_dev *gspca_dev)
-{
-	int err;
-	struct sd *sd = (struct sd *) gspca_dev;
-
-	err = setbrightness(sd);
-
-	/* commit settings */
-	if (err >= 0)
-		err = stv06xx_write_bridge(sd, 0x143f, 0x01);
-
-	gspca_dev->usb_err = err;
-}
-
-static void st6422_set_contrast(struct gspca_dev *gspca_dev)
-{
-	int err;
-	struct sd *sd = (struct sd *) gspca_dev;
-
-	err = setcontrast(sd);
-
-	/* commit settings */
-	if (err >= 0)
-		err = stv06xx_write_bridge(sd, 0x143f, 0x01);
-
-	gspca_dev->usb_err = err;
-}
-
-static void st6422_set_gain(struct gspca_dev *gspca_dev)
-{
-	int err;
-	struct sd *sd = (struct sd *) gspca_dev;
-
-	err = setgain(sd);
-
-	/* commit settings */
-	if (err >= 0)
-		err = stv06xx_write_bridge(sd, 0x143f, 0x01);
-
-	gspca_dev->usb_err = err;
-}
-
-static void st6422_set_exposure(struct gspca_dev *gspca_dev)
-{
-	int err;
-	struct sd *sd = (struct sd *) gspca_dev;
-
-	err = setexposure(sd);
-
-	/* commit settings */
-	if (err >= 0)
-		err = stv06xx_write_bridge(sd, 0x143f, 0x01);
-
-	gspca_dev->usb_err = err;
-}
diff --git a/drivers/media/video/gspca/stv06xx/stv06xx_st6422.h b/drivers/media/video/gspca/stv06xx/stv06xx_st6422.h
index d7498e0..8f20fbf 100644
--- a/drivers/media/video/gspca/stv06xx/stv06xx_st6422.h
+++ b/drivers/media/video/gspca/stv06xx/stv06xx_st6422.h
@@ -34,8 +34,8 @@
 static int st6422_probe(struct sd *sd);
 static int st6422_start(struct sd *sd);
 static int st6422_init(struct sd *sd);
+static int st6422_init_controls(struct sd *sd);
 static int st6422_stop(struct sd *sd);
-static void st6422_disconnect(struct sd *sd);
 
 const struct stv06xx_sensor stv06xx_sensor_st6422 = {
 	.name = "ST6422",
@@ -43,10 +43,10 @@ const struct stv06xx_sensor stv06xx_sensor_st6422 = {
 	.min_packet_size = { 300, 847 },
 	.max_packet_size = { 300, 847 },
 	.init = st6422_init,
+	.init_controls = st6422_init_controls,
 	.probe = st6422_probe,
 	.start = st6422_start,
 	.stop = st6422_stop,
-	.disconnect = st6422_disconnect,
 };
 
 #endif
diff --git a/drivers/media/video/gspca/stv06xx/stv06xx_vv6410.c b/drivers/media/video/gspca/stv06xx/stv06xx_vv6410.c
index a5c69d9..1b7a68a 100644
--- a/drivers/media/video/gspca/stv06xx/stv06xx_vv6410.c
+++ b/drivers/media/video/gspca/stv06xx/stv06xx_vv6410.c
@@ -44,130 +44,82 @@ static struct v4l2_pix_format vv6410_mode[] = {
 	}
 };
 
-static const struct ctrl vv6410_ctrl[] = {
-#define HFLIP_IDX 0
-	{
-		{
-			.id		= V4L2_CID_HFLIP,
-			.type		= V4L2_CTRL_TYPE_BOOLEAN,
-			.name		= "horizontal flip",
-			.minimum	= 0,
-			.maximum	= 1,
-			.step		= 1,
-			.default_value	= 0
-		},
-		.set = vv6410_set_hflip,
-		.get = vv6410_get_hflip
-	},
-#define VFLIP_IDX 1
-	{
-		{
-			.id		= V4L2_CID_VFLIP,
-			.type		= V4L2_CTRL_TYPE_BOOLEAN,
-			.name		= "vertical flip",
-			.minimum	= 0,
-			.maximum	= 1,
-			.step		= 1,
-			.default_value	= 0
-		},
-		.set = vv6410_set_vflip,
-		.get = vv6410_get_vflip
-	},
-#define GAIN_IDX 2
-	{
-		{
-			.id		= V4L2_CID_GAIN,
-			.type		= V4L2_CTRL_TYPE_INTEGER,
-			.name		= "analog gain",
-			.minimum	= 0,
-			.maximum	= 15,
-			.step		= 1,
-			.default_value  = 10
-		},
-		.set = vv6410_set_analog_gain,
-		.get = vv6410_get_analog_gain
-	},
-#define EXPOSURE_IDX 3
-	{
-		{
-			.id		= V4L2_CID_EXPOSURE,
-			.type		= V4L2_CTRL_TYPE_INTEGER,
-			.name		= "exposure",
-			.minimum	= 0,
-			.maximum	= 32768,
-			.step		= 1,
-			.default_value  = 20000
-		},
-		.set = vv6410_set_exposure,
-		.get = vv6410_get_exposure
+static int vv6410_s_ctrl(struct v4l2_ctrl *ctrl)
+{
+	struct sd *sd = container_of(ctrl->handler, struct sd, ctrl_handler);
+	int err = -EINVAL;
+
+	switch (ctrl->id) {
+	case V4L2_CID_HFLIP:
+		err = vv6410_set_hflip(&sd->gspca_dev, ctrl->val);
+		break;
+	case V4L2_CID_VFLIP:
+		err = vv6410_set_vflip(&sd->gspca_dev, ctrl->val);
+		break;
+	case V4L2_CID_GAIN:
+		err = vv6410_set_analog_gain(&sd->gspca_dev, ctrl->val);
+		break;
+	case V4L2_CID_EXPOSURE:
+		err = vv6410_set_exposure(&sd->gspca_dev, ctrl->val);
+		break;
 	}
-	};
+	return err;
+}
+
+static const struct v4l2_ctrl_ops vv6410_ctrl_ops = {
+	.s_ctrl = vv6410_s_ctrl,
+};
 
 static int vv6410_probe(struct sd *sd)
 {
 	u16 data;
-	int err, i;
-	s32 *sensor_settings;
+	int err;
 
 	err = stv06xx_read_sensor(sd, VV6410_DEVICEH, &data);
 	if (err < 0)
 		return -ENODEV;
 
-	if (data == 0x19) {
-		pr_info("vv6410 sensor detected\n");
+	if (data != 0x19)
+		return -ENODEV;
 
-		sensor_settings = kmalloc(ARRAY_SIZE(vv6410_ctrl) * sizeof(s32),
-					  GFP_KERNEL);
-		if (!sensor_settings)
-			return -ENOMEM;
+	pr_info("vv6410 sensor detected\n");
 
-		sd->gspca_dev.cam.cam_mode = vv6410_mode;
-		sd->gspca_dev.cam.nmodes = ARRAY_SIZE(vv6410_mode);
-		sd->desc.ctrls = vv6410_ctrl;
-		sd->desc.nctrls = ARRAY_SIZE(vv6410_ctrl);
+	sd->gspca_dev.cam.cam_mode = vv6410_mode;
+	sd->gspca_dev.cam.nmodes = ARRAY_SIZE(vv6410_mode);
+	return 0;
+}
 
-		for (i = 0; i < sd->desc.nctrls; i++)
-			sensor_settings[i] = vv6410_ctrl[i].qctrl.default_value;
-		sd->sensor_priv = sensor_settings;
-		return 0;
-	}
-	return -ENODEV;
+static int vv6410_init_controls(struct sd *sd)
+{
+	struct v4l2_ctrl_handler *hdl = &sd->ctrl_handler;
+
+	v4l2_ctrl_handler_init(hdl, 4);
+	v4l2_ctrl_new_std(hdl, &vv6410_ctrl_ops,
+			V4L2_CID_HFLIP, 0, 1, 1, 0);
+	v4l2_ctrl_new_std(hdl, &vv6410_ctrl_ops,
+			V4L2_CID_VFLIP, 0, 1, 1, 0);
+	v4l2_ctrl_new_std(hdl, &vv6410_ctrl_ops,
+			V4L2_CID_EXPOSURE, 0, 32768, 1, 20000);
+	v4l2_ctrl_new_std(hdl, &vv6410_ctrl_ops,
+			V4L2_CID_GAIN, 0, 15, 1, 10);
+	return hdl->error;
 }
 
 static int vv6410_init(struct sd *sd)
 {
 	int err = 0, i;
-	s32 *sensor_settings = sd->sensor_priv;
 
-	for (i = 0; i < ARRAY_SIZE(stv_bridge_init); i++) {
+	for (i = 0; i < ARRAY_SIZE(stv_bridge_init); i++)
 		stv06xx_write_bridge(sd, stv_bridge_init[i].addr, stv_bridge_init[i].data);
-	}
 
 	if (err < 0)
 		return err;
 
 	err = stv06xx_write_sensor_bytes(sd, (u8 *) vv6410_sensor_init,
 					 ARRAY_SIZE(vv6410_sensor_init));
-	if (err < 0)
-		return err;
-
-	err = vv6410_set_exposure(&sd->gspca_dev,
-				   sensor_settings[EXPOSURE_IDX]);
-	if (err < 0)
-		return err;
-
-	err = vv6410_set_analog_gain(&sd->gspca_dev,
-				      sensor_settings[GAIN_IDX]);
-
 	return (err < 0) ? err : 0;
 }
 
-static void vv6410_disconnect(struct sd *sd)
-{
-	sd->sensor = NULL;
-	kfree(sd->sensor_priv);
-}
-
 static int vv6410_start(struct sd *sd)
 {
 	int err;
@@ -233,25 +185,12 @@ static int vv6410_dump(struct sd *sd)
 	return (err < 0) ? err : 0;
 }
 
-static int vv6410_get_hflip(struct gspca_dev *gspca_dev, __s32 *val)
-{
-	struct sd *sd = (struct sd *) gspca_dev;
-	s32 *sensor_settings = sd->sensor_priv;
-
-	*val = sensor_settings[HFLIP_IDX];
-	PDEBUG(D_V4L2, "Read horizontal flip %d", *val);
-
-	return 0;
-}
-
 static int vv6410_set_hflip(struct gspca_dev *gspca_dev, __s32 val)
 {
 	int err;
 	u16 i2c_data;
 	struct sd *sd = (struct sd *) gspca_dev;
-	s32 *sensor_settings = sd->sensor_priv;
 
-	sensor_settings[HFLIP_IDX] = val;
 	err = stv06xx_read_sensor(sd, VV6410_DATAFORMAT, &i2c_data);
 	if (err < 0)
 		return err;
@@ -267,25 +206,12 @@ static int vv6410_set_hflip(struct gspca_dev *gspca_dev, __s32 val)
 	return (err < 0) ? err : 0;
 }
 
-static int vv6410_get_vflip(struct gspca_dev *gspca_dev, __s32 *val)
-{
-	struct sd *sd = (struct sd *) gspca_dev;
-	s32 *sensor_settings = sd->sensor_priv;
-
-	*val = sensor_settings[VFLIP_IDX];
-	PDEBUG(D_V4L2, "Read vertical flip %d", *val);
-
-	return 0;
-}
-
 static int vv6410_set_vflip(struct gspca_dev *gspca_dev, __s32 val)
 {
 	int err;
 	u16 i2c_data;
 	struct sd *sd = (struct sd *) gspca_dev;
-	s32 *sensor_settings = sd->sensor_priv;
 
-	sensor_settings[VFLIP_IDX] = val;
 	err = stv06xx_read_sensor(sd, VV6410_DATAFORMAT, &i2c_data);
 	if (err < 0)
 		return err;
@@ -301,52 +227,23 @@ static int vv6410_set_vflip(struct gspca_dev *gspca_dev, __s32 val)
 	return (err < 0) ? err : 0;
 }
 
-static int vv6410_get_analog_gain(struct gspca_dev *gspca_dev, __s32 *val)
-{
-	struct sd *sd = (struct sd *) gspca_dev;
-	s32 *sensor_settings = sd->sensor_priv;
-
-	*val = sensor_settings[GAIN_IDX];
-
-	PDEBUG(D_V4L2, "Read analog gain %d", *val);
-
-	return 0;
-}
-
 static int vv6410_set_analog_gain(struct gspca_dev *gspca_dev, __s32 val)
 {
 	int err;
 	struct sd *sd = (struct sd *) gspca_dev;
-	s32 *sensor_settings = sd->sensor_priv;
 
-	sensor_settings[GAIN_IDX] = val;
 	PDEBUG(D_V4L2, "Set analog gain to %d", val);
 	err = stv06xx_write_sensor(sd, VV6410_ANALOGGAIN, 0xf0 | (val & 0xf));
 
 	return (err < 0) ? err : 0;
 }
 
-static int vv6410_get_exposure(struct gspca_dev *gspca_dev, __s32 *val)
-{
-	struct sd *sd = (struct sd *) gspca_dev;
-	s32 *sensor_settings = sd->sensor_priv;
-
-	*val = sensor_settings[EXPOSURE_IDX];
-
-	PDEBUG(D_V4L2, "Read exposure %d", *val);
-
-	return 0;
-}
-
 static int vv6410_set_exposure(struct gspca_dev *gspca_dev, __s32 val)
 {
 	int err;
 	struct sd *sd = (struct sd *) gspca_dev;
-	s32 *sensor_settings = sd->sensor_priv;
 	unsigned int fine, coarse;
 
-	sensor_settings[EXPOSURE_IDX] = val;
-
 	val = (val * val >> 14) + val / 4;
 
 	fine = val % VV6410_CIF_LINELENGTH;
diff --git a/drivers/media/video/gspca/stv06xx/stv06xx_vv6410.h b/drivers/media/video/gspca/stv06xx/stv06xx_vv6410.h
index a25b887..53e67b4 100644
--- a/drivers/media/video/gspca/stv06xx/stv06xx_vv6410.h
+++ b/drivers/media/video/gspca/stv06xx/stv06xx_vv6410.h
@@ -178,18 +178,14 @@
 static int vv6410_probe(struct sd *sd);
 static int vv6410_start(struct sd *sd);
 static int vv6410_init(struct sd *sd);
+static int vv6410_init_controls(struct sd *sd);
 static int vv6410_stop(struct sd *sd);
 static int vv6410_dump(struct sd *sd);
-static void vv6410_disconnect(struct sd *sd);
 
 /* V4L2 controls supported by the driver */
-static int vv6410_get_hflip(struct gspca_dev *gspca_dev, __s32 *val);
 static int vv6410_set_hflip(struct gspca_dev *gspca_dev, __s32 val);
-static int vv6410_get_vflip(struct gspca_dev *gspca_dev, __s32 *val);
 static int vv6410_set_vflip(struct gspca_dev *gspca_dev, __s32 val);
-static int vv6410_get_analog_gain(struct gspca_dev *gspca_dev, __s32 *val);
 static int vv6410_set_analog_gain(struct gspca_dev *gspca_dev, __s32 val);
-static int vv6410_get_exposure(struct gspca_dev *gspca_dev, __s32 *val);
 static int vv6410_set_exposure(struct gspca_dev *gspca_dev, __s32 val);
 
 const struct stv06xx_sensor stv06xx_sensor_vv6410 = {
@@ -202,11 +198,11 @@ const struct stv06xx_sensor stv06xx_sensor_vv6410 = {
 	.min_packet_size = { 1023 },
 	.max_packet_size = { 1023 },
 	.init = vv6410_init,
+	.init_controls = vv6410_init_controls,
 	.probe = vv6410_probe,
 	.start = vv6410_start,
 	.stop = vv6410_stop,
 	.dump = vv6410_dump,
-	.disconnect = vv6410_disconnect,
 };
 
 /* If NULL, only single value to write, stored in len */
-- 
1.7.10

