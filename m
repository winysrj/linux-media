Return-path: <mchehab@gaivota>
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:4047 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753578Ab0LLRcI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 12 Dec 2010 12:32:08 -0500
Received: from localhost.localdomain (159.80-203-19.nextgentel.com [80.203.19.159])
	(authenticated bits=0)
	by smtp-vbr5.xs4all.nl (8.13.8/8.13.8) with ESMTP id oBCHW1MJ002236
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Sun, 12 Dec 2010 18:32:07 +0100 (CET)
	(envelope-from hverkuil@xs4all.nl)
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: [RFC/PATCH 11/19] tvp514x: use the control framework
Date: Sun, 12 Dec 2010 18:31:53 +0100
Message-Id: <4ea25fba8cc1207adfedd208548deefd6032fe83.1292174822.git.hverkuil@xs4all.nl>
In-Reply-To: <cover.1292174822.git.hverkuil@xs4all.nl>
References: <cover.1292174822.git.hverkuil@xs4all.nl>
In-Reply-To: <cover.1292174822.git.hverkuil@xs4all.nl>
References: <cover.1292174822.git.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
---
 drivers/media/video/tvp514x.c |  236 ++++++++++-------------------------------
 1 files changed, 57 insertions(+), 179 deletions(-)

diff --git a/drivers/media/video/tvp514x.c b/drivers/media/video/tvp514x.c
index 45bcf03..9b3e828 100644
--- a/drivers/media/video/tvp514x.c
+++ b/drivers/media/video/tvp514x.c
@@ -37,6 +37,7 @@
 #include <media/v4l2-common.h>
 #include <media/v4l2-mediabus.h>
 #include <media/v4l2-chip-ident.h>
+#include <media/v4l2-ctrls.h>
 #include <media/tvp514x.h>
 
 #include "tvp514x_regs.h"
@@ -97,6 +98,7 @@ static int tvp514x_s_stream(struct v4l2_subdev *sd, int enable);
  */
 struct tvp514x_decoder {
 	struct v4l2_subdev sd;
+	struct v4l2_ctrl_handler hdl;
 	struct tvp514x_reg tvp514x_regs[ARRAY_SIZE(tvp514x_reg_list_default)];
 	const struct tvp514x_platform_data *pdata;
 
@@ -238,6 +240,11 @@ static inline struct tvp514x_decoder *to_decoder(struct v4l2_subdev *sd)
 	return container_of(sd, struct tvp514x_decoder, sd);
 }
 
+static inline struct v4l2_subdev *to_sd(struct v4l2_ctrl *ctrl)
+{
+	return &container_of(ctrl->handler, struct tvp514x_decoder, hdl)->sd;
+}
+
 
 /**
  * tvp514x_read_reg() - Read a value from a register in an TVP5146/47.
@@ -719,213 +726,54 @@ static int tvp514x_s_routing(struct v4l2_subdev *sd,
 }
 
 /**
- * tvp514x_queryctrl() - V4L2 decoder interface handler for queryctrl
- * @sd: pointer to standard V4L2 sub-device structure
- * @qctrl: standard V4L2 v4l2_queryctrl structure
- *
- * If the requested control is supported, returns the control information.
- * Otherwise, returns -EINVAL if the control is not supported.
- */
-static int
-tvp514x_queryctrl(struct v4l2_subdev *sd, struct v4l2_queryctrl *qctrl)
-{
-	int err = -EINVAL;
-
-	if (qctrl == NULL)
-		return err;
-
-	switch (qctrl->id) {
-	case V4L2_CID_BRIGHTNESS:
-		/* Brightness supported is (0-255), */
-		err = v4l2_ctrl_query_fill(qctrl, 0, 255, 1, 128);
-		break;
-	case V4L2_CID_CONTRAST:
-	case V4L2_CID_SATURATION:
-		/**
-		 * Saturation and Contrast supported is -
-		 *	Contrast: 0 - 255 (Default - 128)
-		 *	Saturation: 0 - 255 (Default - 128)
-		 */
-		err = v4l2_ctrl_query_fill(qctrl, 0, 255, 1, 128);
-		break;
-	case V4L2_CID_HUE:
-		/* Hue Supported is -
-		 *	Hue - -180 - +180 (Default - 0, Step - +180)
-		 */
-		err = v4l2_ctrl_query_fill(qctrl, -180, 180, 180, 0);
-		break;
-	case V4L2_CID_AUTOGAIN:
-		/**
-		 * Auto Gain supported is -
-		 * 	0 - 1 (Default - 1)
-		 */
-		err = v4l2_ctrl_query_fill(qctrl, 0, 1, 1, 1);
-		break;
-	default:
-		v4l2_err(sd, "invalid control id %d\n", qctrl->id);
-		return err;
-	}
-
-	v4l2_dbg(1, debug, sd, "Query Control:%s: Min - %d, Max - %d, Def - %d\n",
-			qctrl->name, qctrl->minimum, qctrl->maximum,
-			qctrl->default_value);
-
-	return err;
-}
-
-/**
- * tvp514x_g_ctrl() - V4L2 decoder interface handler for g_ctrl
- * @sd: pointer to standard V4L2 sub-device structure
- * @ctrl: pointer to v4l2_control structure
- *
- * If the requested control is supported, returns the control's current
- * value from the decoder. Otherwise, returns -EINVAL if the control is not
- * supported.
- */
-static int
-tvp514x_g_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl)
-{
-	struct tvp514x_decoder *decoder = to_decoder(sd);
-
-	if (ctrl == NULL)
-		return -EINVAL;
-
-	switch (ctrl->id) {
-	case V4L2_CID_BRIGHTNESS:
-		ctrl->value = decoder->tvp514x_regs[REG_BRIGHTNESS].val;
-		break;
-	case V4L2_CID_CONTRAST:
-		ctrl->value = decoder->tvp514x_regs[REG_CONTRAST].val;
-		break;
-	case V4L2_CID_SATURATION:
-		ctrl->value = decoder->tvp514x_regs[REG_SATURATION].val;
-		break;
-	case V4L2_CID_HUE:
-		ctrl->value = decoder->tvp514x_regs[REG_HUE].val;
-		if (ctrl->value == 0x7F)
-			ctrl->value = 180;
-		else if (ctrl->value == 0x80)
-			ctrl->value = -180;
-		else
-			ctrl->value = 0;
-
-		break;
-	case V4L2_CID_AUTOGAIN:
-		ctrl->value = decoder->tvp514x_regs[REG_AFE_GAIN_CTRL].val;
-		if ((ctrl->value & 0x3) == 3)
-			ctrl->value = 1;
-		else
-			ctrl->value = 0;
-
-		break;
-	default:
-		v4l2_err(sd, "invalid control id %d\n", ctrl->id);
-		return -EINVAL;
-	}
-
-	v4l2_dbg(1, debug, sd, "Get Control: ID - %d - %d\n",
-			ctrl->id, ctrl->value);
-	return 0;
-}
-
-/**
  * tvp514x_s_ctrl() - V4L2 decoder interface handler for s_ctrl
- * @sd: pointer to standard V4L2 sub-device structure
- * @ctrl: pointer to v4l2_control structure
+ * @ctrl: pointer to v4l2_ctrl structure
  *
  * If the requested control is supported, sets the control's current
  * value in HW. Otherwise, returns -EINVAL if the control is not supported.
  */
-static int
-tvp514x_s_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl)
+static int tvp514x_s_ctrl(struct v4l2_ctrl *ctrl)
 {
+	struct v4l2_subdev *sd = to_sd(ctrl);
 	struct tvp514x_decoder *decoder = to_decoder(sd);
 	int err = -EINVAL, value;
 
-	if (ctrl == NULL)
-		return err;
-
-	value = ctrl->value;
+	value = ctrl->val;
 
 	switch (ctrl->id) {
 	case V4L2_CID_BRIGHTNESS:
-		if (ctrl->value < 0 || ctrl->value > 255) {
-			v4l2_err(sd, "invalid brightness setting %d\n",
-					ctrl->value);
-			return -ERANGE;
-		}
-		err = tvp514x_write_reg(sd, REG_BRIGHTNESS,
-				value);
-		if (err)
-			return err;
-
-		decoder->tvp514x_regs[REG_BRIGHTNESS].val = value;
+		err = tvp514x_write_reg(sd, REG_BRIGHTNESS, value);
+		if (!err)
+			decoder->tvp514x_regs[REG_BRIGHTNESS].val = value;
 		break;
 	case V4L2_CID_CONTRAST:
-		if (ctrl->value < 0 || ctrl->value > 255) {
-			v4l2_err(sd, "invalid contrast setting %d\n",
-					ctrl->value);
-			return -ERANGE;
-		}
 		err = tvp514x_write_reg(sd, REG_CONTRAST, value);
-		if (err)
-			return err;
-
-		decoder->tvp514x_regs[REG_CONTRAST].val = value;
+		if (!err)
+			decoder->tvp514x_regs[REG_CONTRAST].val = value;
 		break;
 	case V4L2_CID_SATURATION:
-		if (ctrl->value < 0 || ctrl->value > 255) {
-			v4l2_err(sd, "invalid saturation setting %d\n",
-					ctrl->value);
-			return -ERANGE;
-		}
 		err = tvp514x_write_reg(sd, REG_SATURATION, value);
-		if (err)
-			return err;
-
-		decoder->tvp514x_regs[REG_SATURATION].val = value;
+		if (!err)
+			decoder->tvp514x_regs[REG_SATURATION].val = value;
 		break;
 	case V4L2_CID_HUE:
 		if (value == 180)
 			value = 0x7F;
 		else if (value == -180)
 			value = 0x80;
-		else if (value == 0)
-			value = 0;
-		else {
-			v4l2_err(sd, "invalid hue setting %d\n", ctrl->value);
-			return -ERANGE;
-		}
 		err = tvp514x_write_reg(sd, REG_HUE, value);
-		if (err)
-			return err;
-
-		decoder->tvp514x_regs[REG_HUE].val = value;
+		if (!err)
+			decoder->tvp514x_regs[REG_HUE].val = value;
 		break;
 	case V4L2_CID_AUTOGAIN:
-		if (value == 1)
-			value = 0x0F;
-		else if (value == 0)
-			value = 0x0C;
-		else {
-			v4l2_err(sd, "invalid auto gain setting %d\n",
-					ctrl->value);
-			return -ERANGE;
-		}
-		err = tvp514x_write_reg(sd, REG_AFE_GAIN_CTRL, value);
-		if (err)
-			return err;
-
-		decoder->tvp514x_regs[REG_AFE_GAIN_CTRL].val = value;
+		err = tvp514x_write_reg(sd, REG_AFE_GAIN_CTRL, value ? 0x0f : 0x0c);
+		if (!err)
+			decoder->tvp514x_regs[REG_AFE_GAIN_CTRL].val = value;
 		break;
-	default:
-		v4l2_err(sd, "invalid control id %d\n", ctrl->id);
-		return err;
 	}
 
 	v4l2_dbg(1, debug, sd, "Set Control: ID - %d - %d\n",
-			ctrl->id, ctrl->value);
-
+			ctrl->id, ctrl->val);
 	return err;
 }
 
@@ -1104,10 +952,18 @@ static int tvp514x_s_stream(struct v4l2_subdev *sd, int enable)
 	return err;
 }
 
-static const struct v4l2_subdev_core_ops tvp514x_core_ops = {
-	.queryctrl = tvp514x_queryctrl,
-	.g_ctrl = tvp514x_g_ctrl,
+static const struct v4l2_ctrl_ops tvp514x_ctrl_ops = {
 	.s_ctrl = tvp514x_s_ctrl,
+};
+
+static const struct v4l2_subdev_core_ops tvp514x_core_ops = {
+	.g_ext_ctrls = v4l2_subdev_g_ext_ctrls,
+	.try_ext_ctrls = v4l2_subdev_try_ext_ctrls,
+	.s_ext_ctrls = v4l2_subdev_s_ext_ctrls,
+	.g_ctrl = v4l2_subdev_g_ctrl,
+	.s_ctrl = v4l2_subdev_s_ctrl,
+	.queryctrl = v4l2_subdev_queryctrl,
+	.querymenu = v4l2_subdev_querymenu,
 	.s_std = tvp514x_s_std,
 };
 
@@ -1190,6 +1046,27 @@ tvp514x_probe(struct i2c_client *client, const struct i2c_device_id *id)
 	sd = &decoder->sd;
 	v4l2_i2c_subdev_init(sd, client, &tvp514x_ops);
 
+	v4l2_ctrl_handler_init(&decoder->hdl, 5);
+	v4l2_ctrl_new_std(&decoder->hdl, &tvp514x_ctrl_ops,
+		V4L2_CID_BRIGHTNESS, 0, 255, 1, 128);
+	v4l2_ctrl_new_std(&decoder->hdl, &tvp514x_ctrl_ops,
+		V4L2_CID_CONTRAST, 0, 255, 1, 128);
+	v4l2_ctrl_new_std(&decoder->hdl, &tvp514x_ctrl_ops,
+		V4L2_CID_SATURATION, 0, 255, 1, 128);
+	v4l2_ctrl_new_std(&decoder->hdl, &tvp514x_ctrl_ops,
+		V4L2_CID_HUE, -180, 180, 180, 0);
+	v4l2_ctrl_new_std(&decoder->hdl, &tvp514x_ctrl_ops,
+		V4L2_CID_AUTOGAIN, 0, 1, 1, 1);
+	sd->ctrl_handler = &decoder->hdl;
+	if (decoder->hdl.error) {
+		int err = decoder->hdl.error;
+
+		v4l2_ctrl_handler_free(&decoder->hdl);
+		kfree(decoder);
+		return err;
+	}
+	v4l2_ctrl_handler_setup(&decoder->hdl);
+
 	v4l2_info(sd, "%s decoder driver registered !!\n", sd->name);
 
 	return 0;
@@ -1209,6 +1086,7 @@ static int tvp514x_remove(struct i2c_client *client)
 	struct tvp514x_decoder *decoder = to_decoder(sd);
 
 	v4l2_device_unregister_subdev(sd);
+	v4l2_ctrl_handler_free(&decoder->hdl);
 	kfree(decoder);
 	return 0;
 }
-- 
1.7.0.4

