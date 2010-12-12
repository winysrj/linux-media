Return-path: <mchehab@gaivota>
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:4248 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753596Ab0LLRcJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 12 Dec 2010 12:32:09 -0500
Received: from localhost.localdomain (159.80-203-19.nextgentel.com [80.203.19.159])
	(authenticated bits=0)
	by smtp-vbr5.xs4all.nl (8.13.8/8.13.8) with ESMTP id oBCHW1MM002236
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Sun, 12 Dec 2010 18:32:08 +0100 (CET)
	(envelope-from hverkuil@xs4all.nl)
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: [RFC/PATCH 14/19] tvp7002: use control framework
Date: Sun, 12 Dec 2010 18:31:56 +0100
Message-Id: <df3adf0622d8f56a20988c6a826256231f0cce38.1292174822.git.hverkuil@xs4all.nl>
In-Reply-To: <cover.1292174822.git.hverkuil@xs4all.nl>
References: <cover.1292174822.git.hverkuil@xs4all.nl>
In-Reply-To: <cover.1292174822.git.hverkuil@xs4all.nl>
References: <cover.1292174822.git.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
---
 drivers/media/video/tvp7002.c |  117 +++++++++++++++--------------------------
 1 files changed, 43 insertions(+), 74 deletions(-)

diff --git a/drivers/media/video/tvp7002.c b/drivers/media/video/tvp7002.c
index e63b40f..2c4a6fd 100644
--- a/drivers/media/video/tvp7002.c
+++ b/drivers/media/video/tvp7002.c
@@ -32,6 +32,7 @@
 #include <media/v4l2-device.h>
 #include <media/v4l2-chip-ident.h>
 #include <media/v4l2-common.h>
+#include <media/v4l2-ctrls.h>
 #include "tvp7002_reg.h"
 
 MODULE_DESCRIPTION("TI TVP7002 Video and Graphics Digitizer driver");
@@ -421,13 +422,13 @@ static const struct tvp7002_preset_definition tvp7002_presets[] = {
 /* Device definition */
 struct tvp7002 {
 	struct v4l2_subdev sd;
+	struct v4l2_ctrl_handler hdl;
 	const struct tvp7002_config *pdata;
 
 	int ver;
 	int streaming;
 
 	const struct tvp7002_preset_definition *current_preset;
-	u8 gain;
 };
 
 /*
@@ -441,6 +442,11 @@ static inline struct tvp7002 *to_tvp7002(struct v4l2_subdev *sd)
 	return container_of(sd, struct tvp7002, sd);
 }
 
+static inline struct v4l2_subdev *to_sd(struct v4l2_ctrl *ctrl)
+{
+	return &container_of(ctrl->handler, struct tvp7002, hdl)->sd;
+}
+
 /*
  * tvp7002_read - Read a value from a register in an TVP7002
  * @sd: ptr to v4l2_subdev struct
@@ -606,78 +612,25 @@ static int tvp7002_s_dv_preset(struct v4l2_subdev *sd,
 }
 
 /*
- * tvp7002_g_ctrl() - Get a control
- * @sd: ptr to v4l2_subdev struct
- * @ctrl: ptr to v4l2_control struct
- *
- * Get a control for a TVP7002 decoder device.
- * Returns zero when successful or -EINVAL if register access fails.
- */
-static int tvp7002_g_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl)
-{
-	struct tvp7002 *device = to_tvp7002(sd);
-
-	switch (ctrl->id) {
-	case V4L2_CID_GAIN:
-		ctrl->value = device->gain;
-		return 0;
-	default:
-		return -EINVAL;
-	}
-}
-
-/*
  * tvp7002_s_ctrl() - Set a control
- * @sd: ptr to v4l2_subdev struct
- * @ctrl: ptr to v4l2_control struct
+ * @ctrl: ptr to v4l2_ctrl struct
  *
  * Set a control in TVP7002 decoder device.
  * Returns zero when successful or -EINVAL if register access fails.
  */
-static int tvp7002_s_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl)
+static int tvp7002_s_ctrl(struct v4l2_ctrl *ctrl)
 {
-	struct tvp7002 *device = to_tvp7002(sd);
+	struct v4l2_subdev *sd = to_sd(ctrl);
 	int error = 0;
 
 	switch (ctrl->id) {
 	case V4L2_CID_GAIN:
-		tvp7002_write_err(sd, TVP7002_R_FINE_GAIN,
-						ctrl->value & 0xff, &error);
-		tvp7002_write_err(sd, TVP7002_G_FINE_GAIN,
-						ctrl->value & 0xff, &error);
-		tvp7002_write_err(sd, TVP7002_B_FINE_GAIN,
-						ctrl->value & 0xff, &error);
-
-		if (error < 0)
-			return error;
-
-		/* Set only after knowing there is no error */
-		device->gain = ctrl->value & 0xff;
-		return 0;
-	default:
-		return -EINVAL;
-	}
-}
-
-/*
- * tvp7002_queryctrl() - Query a control
- * @sd: ptr to v4l2_subdev struct
- * @qc: ptr to v4l2_queryctrl struct
- *
- * Query a control of a TVP7002 decoder device.
- * Returns zero when successful or -EINVAL if register read fails.
- */
-static int tvp7002_queryctrl(struct v4l2_subdev *sd, struct v4l2_queryctrl *qc)
-{
-	switch (qc->id) {
-	case V4L2_CID_GAIN:
-		/*
-		 * Gain is supported [0-255, default=0, step=1]
-		 */
-		return v4l2_ctrl_query_fill(qc, 0, 255, 1, 0);
-	default:
-		return -EINVAL;
+		tvp7002_write_err(sd, TVP7002_R_FINE_GAIN, ctrl->val, &error);
+		tvp7002_write_err(sd, TVP7002_G_FINE_GAIN, ctrl->val, &error);
+		tvp7002_write_err(sd, TVP7002_B_FINE_GAIN, ctrl->val, &error);
+		return error;
 	}
+	return -EINVAL;
 }
 
 /*
@@ -924,7 +877,7 @@ static int tvp7002_log_status(struct v4l2_subdev *sd)
 					device->streaming ? "yes" : "no");
 
 	/* Print the current value of the gain control */
-	v4l2_info(sd, "Gain: %u\n", device->gain);
+	v4l2_ctrl_handler_log_status(&device->hdl, sd->name);
 
 	return 0;
 }
@@ -946,13 +899,21 @@ static int tvp7002_enum_dv_presets(struct v4l2_subdev *sd,
 	return v4l_fill_dv_preset_info(tvp7002_presets[preset->index].preset, preset);
 }
 
+static const struct v4l2_ctrl_ops tvp7002_ctrl_ops = {
+	.s_ctrl = tvp7002_s_ctrl,
+};
+
 /* V4L2 core operation handlers */
 static const struct v4l2_subdev_core_ops tvp7002_core_ops = {
 	.g_chip_ident = tvp7002_g_chip_ident,
 	.log_status = tvp7002_log_status,
-	.g_ctrl = tvp7002_g_ctrl,
-	.s_ctrl = tvp7002_s_ctrl,
-	.queryctrl = tvp7002_queryctrl,
+	.g_ext_ctrls = v4l2_subdev_g_ext_ctrls,
+	.try_ext_ctrls = v4l2_subdev_try_ext_ctrls,
+	.s_ext_ctrls = v4l2_subdev_s_ext_ctrls,
+	.g_ctrl = v4l2_subdev_g_ctrl,
+	.s_ctrl = v4l2_subdev_s_ctrl,
+	.queryctrl = v4l2_subdev_queryctrl,
+	.querymenu = v4l2_subdev_querymenu,
 #ifdef CONFIG_VIDEO_ADV_DEBUG
 	.g_register = tvp7002_g_register,
 	.s_register = tvp7002_s_register,
@@ -977,12 +938,6 @@ static const struct v4l2_subdev_ops tvp7002_ops = {
 	.video = &tvp7002_video_ops,
 };
 
-static struct tvp7002 tvp7002_dev = {
-	.streaming = 0,
-	.current_preset = tvp7002_presets,
-	.gain = 0,
-};
-
 /*
  * tvp7002_probe - Probe a TVP7002 device
  * @c: ptr to i2c_client struct
@@ -1013,14 +968,14 @@ static int tvp7002_probe(struct i2c_client *c, const struct i2c_device_id *id)
 		return -ENODEV;
 	}
 
-	device = kmalloc(sizeof(struct tvp7002), GFP_KERNEL);
+	device = kzalloc(sizeof(struct tvp7002), GFP_KERNEL);
 
 	if (!device)
 		return -ENOMEM;
 
-	*device = tvp7002_dev;
 	sd = &device->sd;
 	device->pdata = c->dev.platform_data;
+	device->current_preset = tvp7002_presets;
 
 	/* Tell v4l2 the device is ready */
 	v4l2_i2c_subdev_init(sd, c, &tvp7002_ops);
@@ -1060,6 +1015,19 @@ static int tvp7002_probe(struct i2c_client *c, const struct i2c_device_id *id)
 	preset.preset = device->current_preset->preset;
 	error = tvp7002_s_dv_preset(sd, &preset);
 
+	v4l2_ctrl_handler_init(&device->hdl, 1);
+	v4l2_ctrl_new_std(&device->hdl, &tvp7002_ctrl_ops,
+			V4L2_CID_GAIN, 0, 255, 1, 0);
+	sd->ctrl_handler = &device->hdl;
+	if (device->hdl.error) {
+		int err = device->hdl.error;
+
+		v4l2_ctrl_handler_free(&device->hdl);
+		kfree(device);
+		return err;
+	}
+	v4l2_ctrl_handler_setup(&device->hdl);
+
 found_error:
 	if (error < 0)
 		kfree(device);
@@ -1083,6 +1051,7 @@ static int tvp7002_remove(struct i2c_client *c)
 				"on address 0x%x\n", c->addr);
 
 	v4l2_device_unregister_subdev(sd);
+	v4l2_ctrl_handler_free(&device->hdl);
 	kfree(device);
 	return 0;
 }
-- 
1.7.0.4

