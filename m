Return-path: <mchehab@gaivota>
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:1200 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752623Ab0LLRcJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 12 Dec 2010 12:32:09 -0500
Received: from localhost.localdomain (159.80-203-19.nextgentel.com [80.203.19.159])
	(authenticated bits=0)
	by smtp-vbr5.xs4all.nl (8.13.8/8.13.8) with ESMTP id oBCHW1MK002236
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Sun, 12 Dec 2010 18:32:07 +0100 (CET)
	(envelope-from hverkuil@xs4all.nl)
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: [RFC/PATCH 12/19] tvp5150: use the control framework
Date: Sun, 12 Dec 2010 18:31:54 +0100
Message-Id: <a5d1e071bb9fd200421c0e38682fcd8092179b65.1292174822.git.hverkuil@xs4all.nl>
In-Reply-To: <cover.1292174822.git.hverkuil@xs4all.nl>
References: <cover.1292174822.git.hverkuil@xs4all.nl>
In-Reply-To: <cover.1292174822.git.hverkuil@xs4all.nl>
References: <cover.1292174822.git.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
---
 drivers/media/video/tvp5150.c |  157 ++++++++++++-----------------------------
 1 files changed, 46 insertions(+), 111 deletions(-)

diff --git a/drivers/media/video/tvp5150.c b/drivers/media/video/tvp5150.c
index 5892766..959d690 100644
--- a/drivers/media/video/tvp5150.c
+++ b/drivers/media/video/tvp5150.c
@@ -12,6 +12,7 @@
 #include <media/v4l2-device.h>
 #include <media/tvp5150.h>
 #include <media/v4l2-chip-ident.h>
+#include <media/v4l2-ctrls.h>
 
 #include "tvp5150_reg.h"
 
@@ -24,58 +25,14 @@ static int debug;
 module_param(debug, int, 0);
 MODULE_PARM_DESC(debug, "Debug level (0-2)");
 
-/* supported controls */
-static struct v4l2_queryctrl tvp5150_qctrl[] = {
-	{
-		.id = V4L2_CID_BRIGHTNESS,
-		.type = V4L2_CTRL_TYPE_INTEGER,
-		.name = "Brightness",
-		.minimum = 0,
-		.maximum = 255,
-		.step = 1,
-		.default_value = 128,
-		.flags = 0,
-	}, {
-		.id = V4L2_CID_CONTRAST,
-		.type = V4L2_CTRL_TYPE_INTEGER,
-		.name = "Contrast",
-		.minimum = 0,
-		.maximum = 255,
-		.step = 0x1,
-		.default_value = 128,
-		.flags = 0,
-	}, {
-		 .id = V4L2_CID_SATURATION,
-		 .type = V4L2_CTRL_TYPE_INTEGER,
-		 .name = "Saturation",
-		 .minimum = 0,
-		 .maximum = 255,
-		 .step = 0x1,
-		 .default_value = 128,
-		 .flags = 0,
-	}, {
-		.id = V4L2_CID_HUE,
-		.type = V4L2_CTRL_TYPE_INTEGER,
-		.name = "Hue",
-		.minimum = -128,
-		.maximum = 127,
-		.step = 0x1,
-		.default_value = 0,
-		.flags = 0,
-	}
-};
-
 struct tvp5150 {
 	struct v4l2_subdev sd;
+	struct v4l2_ctrl_handler hdl;
 
 	v4l2_std_id norm;	/* Current set standard */
 	u32 input;
 	u32 output;
 	int enable;
-	int bright;
-	int contrast;
-	int hue;
-	int sat;
 };
 
 static inline struct tvp5150 *to_tvp5150(struct v4l2_subdev *sd)
@@ -83,6 +40,11 @@ static inline struct tvp5150 *to_tvp5150(struct v4l2_subdev *sd)
 	return container_of(sd, struct tvp5150, sd);
 }
 
+static inline struct v4l2_subdev *to_sd(struct v4l2_ctrl *ctrl)
+{
+	return &container_of(ctrl->handler, struct tvp5150, hdl)->sd;
+}
+
 static int tvp5150_read(struct v4l2_subdev *sd, unsigned char addr)
 {
 	struct i2c_client *c = v4l2_get_subdevdata(sd);
@@ -810,64 +772,28 @@ static int tvp5150_reset(struct v4l2_subdev *sd, u32 val)
 	tvp5150_write_inittab(sd, tvp5150_init_enable);
 
 	/* Initialize image preferences */
-	tvp5150_write(sd, TVP5150_BRIGHT_CTL, decoder->bright);
-	tvp5150_write(sd, TVP5150_CONTRAST_CTL, decoder->contrast);
-	tvp5150_write(sd, TVP5150_SATURATION_CTL, decoder->contrast);
-	tvp5150_write(sd, TVP5150_HUE_CTL, decoder->hue);
+	v4l2_ctrl_handler_setup(&decoder->hdl);
 
 	tvp5150_set_std(sd, decoder->norm);
 	return 0;
 };
 
-static int tvp5150_g_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl)
-{
-	v4l2_dbg(1, debug, sd, "g_ctrl called\n");
-
-	switch (ctrl->id) {
-	case V4L2_CID_BRIGHTNESS:
-		ctrl->value = tvp5150_read(sd, TVP5150_BRIGHT_CTL);
-		return 0;
-	case V4L2_CID_CONTRAST:
-		ctrl->value = tvp5150_read(sd, TVP5150_CONTRAST_CTL);
-		return 0;
-	case V4L2_CID_SATURATION:
-		ctrl->value = tvp5150_read(sd, TVP5150_SATURATION_CTL);
-		return 0;
-	case V4L2_CID_HUE:
-		ctrl->value = tvp5150_read(sd, TVP5150_HUE_CTL);
-		return 0;
-	}
-	return -EINVAL;
-}
-
-static int tvp5150_s_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl)
+static int tvp5150_s_ctrl(struct v4l2_ctrl *ctrl)
 {
-	u8 i, n;
-	n = ARRAY_SIZE(tvp5150_qctrl);
-
-	for (i = 0; i < n; i++) {
-		if (ctrl->id != tvp5150_qctrl[i].id)
-			continue;
-		if (ctrl->value < tvp5150_qctrl[i].minimum ||
-		    ctrl->value > tvp5150_qctrl[i].maximum)
-			return -ERANGE;
-		v4l2_dbg(1, debug, sd, "s_ctrl: id=%d, value=%d\n",
-					ctrl->id, ctrl->value);
-		break;
-	}
+	struct v4l2_subdev *sd = to_sd(ctrl);
 
 	switch (ctrl->id) {
 	case V4L2_CID_BRIGHTNESS:
-		tvp5150_write(sd, TVP5150_BRIGHT_CTL, ctrl->value);
+		tvp5150_write(sd, TVP5150_BRIGHT_CTL, ctrl->val);
 		return 0;
 	case V4L2_CID_CONTRAST:
-		tvp5150_write(sd, TVP5150_CONTRAST_CTL, ctrl->value);
+		tvp5150_write(sd, TVP5150_CONTRAST_CTL, ctrl->val);
 		return 0;
 	case V4L2_CID_SATURATION:
-		tvp5150_write(sd, TVP5150_SATURATION_CTL, ctrl->value);
+		tvp5150_write(sd, TVP5150_SATURATION_CTL, ctrl->val);
 		return 0;
 	case V4L2_CID_HUE:
-		tvp5150_write(sd, TVP5150_HUE_CTL, ctrl->value);
+		tvp5150_write(sd, TVP5150_HUE_CTL, ctrl->val);
 		return 0;
 	}
 	return -EINVAL;
@@ -995,29 +921,21 @@ static int tvp5150_g_tuner(struct v4l2_subdev *sd, struct v4l2_tuner *vt)
 	return 0;
 }
 
-static int tvp5150_queryctrl(struct v4l2_subdev *sd, struct v4l2_queryctrl *qc)
-{
-	int i;
-
-	v4l2_dbg(1, debug, sd, "queryctrl called\n");
-
-	for (i = 0; i < ARRAY_SIZE(tvp5150_qctrl); i++)
-		if (qc->id && qc->id == tvp5150_qctrl[i].id) {
-			memcpy(qc, &(tvp5150_qctrl[i]),
-			       sizeof(*qc));
-			return 0;
-		}
-
-	return -EINVAL;
-}
-
 /* ----------------------------------------------------------------------- */
 
+static const struct v4l2_ctrl_ops tvp5150_ctrl_ops = {
+	.s_ctrl = tvp5150_s_ctrl,
+};
+
 static const struct v4l2_subdev_core_ops tvp5150_core_ops = {
 	.log_status = tvp5150_log_status,
-	.g_ctrl = tvp5150_g_ctrl,
-	.s_ctrl = tvp5150_s_ctrl,
-	.queryctrl = tvp5150_queryctrl,
+	.g_ext_ctrls = v4l2_subdev_g_ext_ctrls,
+	.try_ext_ctrls = v4l2_subdev_try_ext_ctrls,
+	.s_ext_ctrls = v4l2_subdev_s_ext_ctrls,
+	.g_ctrl = v4l2_subdev_g_ctrl,
+	.s_ctrl = v4l2_subdev_s_ctrl,
+	.queryctrl = v4l2_subdev_queryctrl,
+	.querymenu = v4l2_subdev_querymenu,
 	.s_std = tvp5150_s_std,
 	.reset = tvp5150_reset,
 	.g_chip_ident = tvp5150_g_chip_ident,
@@ -1077,10 +995,25 @@ static int tvp5150_probe(struct i2c_client *c,
 	core->norm = V4L2_STD_ALL;	/* Default is autodetect */
 	core->input = TVP5150_COMPOSITE1;
 	core->enable = 1;
-	core->bright = 128;
-	core->contrast = 128;
-	core->hue = 0;
-	core->sat = 128;
+
+	v4l2_ctrl_handler_init(&core->hdl, 4);
+	v4l2_ctrl_new_std(&core->hdl, &tvp5150_ctrl_ops,
+			V4L2_CID_BRIGHTNESS, 0, 255, 1, 128);
+	v4l2_ctrl_new_std(&core->hdl, &tvp5150_ctrl_ops,
+			V4L2_CID_CONTRAST, 0, 255, 1, 128);
+	v4l2_ctrl_new_std(&core->hdl, &tvp5150_ctrl_ops,
+			V4L2_CID_SATURATION, 0, 255, 1, 128);
+	v4l2_ctrl_new_std(&core->hdl, &tvp5150_ctrl_ops,
+			V4L2_CID_HUE, -128, 127, 1, 0);
+	sd->ctrl_handler = &core->hdl;
+	if (core->hdl.error) {
+		int err = core->hdl.error;
+
+		v4l2_ctrl_handler_free(&core->hdl);
+		kfree(core);
+		return err;
+	}
+	v4l2_ctrl_handler_setup(&core->hdl);
 
 	if (debug > 1)
 		tvp5150_log_status(sd);
@@ -1090,12 +1023,14 @@ static int tvp5150_probe(struct i2c_client *c,
 static int tvp5150_remove(struct i2c_client *c)
 {
 	struct v4l2_subdev *sd = i2c_get_clientdata(c);
+	struct tvp5150 *decoder = to_tvp5150(sd);
 
 	v4l2_dbg(1, debug, sd,
 		"tvp5150.c: removing tvp5150 adapter on address 0x%x\n",
 		c->addr << 1);
 
 	v4l2_device_unregister_subdev(sd);
+	v4l2_ctrl_handler_free(&decoder->hdl);
 	kfree(to_tvp5150(sd));
 	return 0;
 }
-- 
1.7.0.4

