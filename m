Return-path: <mchehab@gaivota>
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:1411 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751861Ab0LLRcG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 12 Dec 2010 12:32:06 -0500
Received: from localhost.localdomain (159.80-203-19.nextgentel.com [80.203.19.159])
	(authenticated bits=0)
	by smtp-vbr5.xs4all.nl (8.13.8/8.13.8) with ESMTP id oBCHW1MC002236
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Sun, 12 Dec 2010 18:32:04 +0100 (CET)
	(envelope-from hverkuil@xs4all.nl)
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: [RFC/PATCH 04/19] adv7343: use control framework
Date: Sun, 12 Dec 2010 18:31:46 +0100
Message-Id: <786bdf2f0a717f7d7575586a1255b76f2b0a7c7d.1292174822.git.hverkuil@xs4all.nl>
In-Reply-To: <cover.1292174822.git.hverkuil@xs4all.nl>
References: <cover.1292174822.git.hverkuil@xs4all.nl>
In-Reply-To: <cover.1292174822.git.hverkuil@xs4all.nl>
References: <cover.1292174822.git.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Also fixed a memory leak in the probe function if an error occurred.
The gain control range was also fixed (a proper range from -64 to 64).

Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
---
 drivers/media/video/adv7343.c      |  167 +++++++++++++-----------------------
 drivers/media/video/adv7343_regs.h |    8 +--
 2 files changed, 63 insertions(+), 112 deletions(-)

diff --git a/drivers/media/video/adv7343.c b/drivers/media/video/adv7343.c
index 41b2930..021fab2 100644
--- a/drivers/media/video/adv7343.c
+++ b/drivers/media/video/adv7343.c
@@ -29,6 +29,7 @@
 #include <media/adv7343.h>
 #include <media/v4l2-device.h>
 #include <media/v4l2-chip-ident.h>
+#include <media/v4l2-ctrls.h>
 
 #include "adv7343_regs.h"
 
@@ -41,15 +42,13 @@ MODULE_PARM_DESC(debug, "Debug level 0-1");
 
 struct adv7343_state {
 	struct v4l2_subdev sd;
+	struct v4l2_ctrl_handler hdl;
 	u8 reg00;
 	u8 reg01;
 	u8 reg02;
 	u8 reg35;
 	u8 reg80;
 	u8 reg82;
-	int bright;
-	int hue;
-	int gain;
 	u32 output;
 	v4l2_std_id std;
 };
@@ -59,6 +58,11 @@ static inline struct adv7343_state *to_state(struct v4l2_subdev *sd)
 	return container_of(sd, struct adv7343_state, sd);
 }
 
+static inline struct v4l2_subdev *to_sd(struct v4l2_ctrl *ctrl)
+{
+	return &container_of(ctrl->handler, struct adv7343_state, hdl)->sd;
+}
+
 static inline int adv7343_write(struct v4l2_subdev *sd, u8 reg, u8 value)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
@@ -268,111 +272,22 @@ static int adv7343_log_status(struct v4l2_subdev *sd)
 	return 0;
 }
 
-static int adv7343_queryctrl(struct v4l2_subdev *sd, struct v4l2_queryctrl *qc)
-{
-	switch (qc->id) {
-	case V4L2_CID_BRIGHTNESS:
-		return v4l2_ctrl_query_fill(qc, ADV7343_BRIGHTNESS_MIN,
-						ADV7343_BRIGHTNESS_MAX, 1,
-						ADV7343_BRIGHTNESS_DEF);
-	case V4L2_CID_HUE:
-		return v4l2_ctrl_query_fill(qc, ADV7343_HUE_MIN,
-						ADV7343_HUE_MAX, 1 ,
-						ADV7343_HUE_DEF);
-	case V4L2_CID_GAIN:
-		return v4l2_ctrl_query_fill(qc, ADV7343_GAIN_MIN,
-						ADV7343_GAIN_MAX, 1,
-						ADV7343_GAIN_DEF);
-	default:
-		break;
-	}
-
-	return 0;
-}
-
-static int adv7343_s_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl)
-{
-	struct adv7343_state *state = to_state(sd);
-	int err = 0;
-
-	switch (ctrl->id) {
-	case V4L2_CID_BRIGHTNESS:
-		if (ctrl->value < ADV7343_BRIGHTNESS_MIN ||
-					ctrl->value > ADV7343_BRIGHTNESS_MAX) {
-			v4l2_dbg(1, debug, sd,
-					"invalid brightness settings %d\n",
-								ctrl->value);
-			return -ERANGE;
-		}
-
-		state->bright = ctrl->value;
-		err = adv7343_write(sd, ADV7343_SD_BRIGHTNESS_WSS,
-					state->bright);
-		break;
-
-	case V4L2_CID_HUE:
-		if (ctrl->value < ADV7343_HUE_MIN ||
-					ctrl->value > ADV7343_HUE_MAX) {
-			v4l2_dbg(1, debug, sd, "invalid hue settings %d\n",
-								ctrl->value);
-			return -ERANGE;
-		}
-
-		state->hue = ctrl->value;
-		err = adv7343_write(sd, ADV7343_SD_HUE_REG, state->hue);
-		break;
-
-	case V4L2_CID_GAIN:
-		if (ctrl->value < ADV7343_GAIN_MIN ||
-					ctrl->value > ADV7343_GAIN_MAX) {
-			v4l2_dbg(1, debug, sd, "invalid gain settings %d\n",
-								ctrl->value);
-			return -ERANGE;
-		}
-
-		if ((ctrl->value > POSITIVE_GAIN_MAX) &&
-			(ctrl->value < NEGATIVE_GAIN_MIN)) {
-			v4l2_dbg(1, debug, sd,
-				"gain settings not within the specified range\n");
-			return -ERANGE;
-		}
-
-		state->gain = ctrl->value;
-		err = adv7343_write(sd, ADV7343_DAC2_OUTPUT_LEVEL, state->gain);
-		break;
-
-	default:
-		return -EINVAL;
-	}
-
-	if (err < 0)
-		v4l2_err(sd, "Failed to set the encoder controls\n");
-
-	return err;
-}
-
-static int adv7343_g_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl)
+static int adv7343_s_ctrl(struct v4l2_ctrl *ctrl)
 {
-	struct adv7343_state *state = to_state(sd);
+	struct v4l2_subdev *sd = to_sd(ctrl);
 
 	switch (ctrl->id) {
 	case V4L2_CID_BRIGHTNESS:
-		ctrl->value = state->bright;
-		break;
+		return adv7343_write(sd, ADV7343_SD_BRIGHTNESS_WSS,
+					ctrl->val);
 
 	case V4L2_CID_HUE:
-		ctrl->value = state->hue;
-		break;
+		return adv7343_write(sd, ADV7343_SD_HUE_REG, ctrl->val);
 
 	case V4L2_CID_GAIN:
-		ctrl->value = state->gain;
-		break;
-
-	default:
-		return -EINVAL;
+		return adv7343_write(sd, ADV7343_DAC2_OUTPUT_LEVEL, ctrl->val);
 	}
-
-	return 0;
+	return -EINVAL;
 }
 
 static int adv7343_g_chip_ident(struct v4l2_subdev *sd,
@@ -383,12 +298,20 @@ static int adv7343_g_chip_ident(struct v4l2_subdev *sd,
 	return v4l2_chip_ident_i2c_client(client, chip, V4L2_IDENT_ADV7343, 0);
 }
 
+static const struct v4l2_ctrl_ops adv7343_ctrl_ops = {
+	.s_ctrl = adv7343_s_ctrl,
+};
+
 static const struct v4l2_subdev_core_ops adv7343_core_ops = {
-	.log_status	= adv7343_log_status,
-	.g_chip_ident	= adv7343_g_chip_ident,
-	.g_ctrl		= adv7343_g_ctrl,
-	.s_ctrl		= adv7343_s_ctrl,
-	.queryctrl	= adv7343_queryctrl,
+	.log_status = adv7343_log_status,
+	.g_chip_ident = adv7343_g_chip_ident,
+	.g_ext_ctrls = v4l2_subdev_g_ext_ctrls,
+	.try_ext_ctrls = v4l2_subdev_try_ext_ctrls,
+	.s_ext_ctrls = v4l2_subdev_s_ext_ctrls,
+	.g_ctrl = v4l2_subdev_g_ctrl,
+	.s_ctrl = v4l2_subdev_s_ctrl,
+	.queryctrl = v4l2_subdev_queryctrl,
+	.querymenu = v4l2_subdev_querymenu,
 };
 
 static int adv7343_s_std_output(struct v4l2_subdev *sd, v4l2_std_id std)
@@ -468,6 +391,7 @@ static int adv7343_probe(struct i2c_client *client,
 				const struct i2c_device_id *id)
 {
 	struct adv7343_state *state;
+	int err;
 
 	if (!i2c_check_functionality(client->adapter, I2C_FUNC_SMBUS_BYTE_DATA))
 		return -ENODEV;
@@ -490,15 +414,46 @@ static int adv7343_probe(struct i2c_client *client,
 	state->std = V4L2_STD_NTSC;
 
 	v4l2_i2c_subdev_init(&state->sd, client, &adv7343_ops);
-	return adv7343_initialize(&state->sd);
+
+	v4l2_ctrl_handler_init(&state->hdl, 2);
+	v4l2_ctrl_new_std(&state->hdl, &adv7343_ctrl_ops,
+			V4L2_CID_BRIGHTNESS, ADV7343_BRIGHTNESS_MIN,
+					     ADV7343_BRIGHTNESS_MAX, 1,
+					     ADV7343_BRIGHTNESS_DEF);
+	v4l2_ctrl_new_std(&state->hdl, &adv7343_ctrl_ops,
+			V4L2_CID_HUE, ADV7343_HUE_MIN,
+				      ADV7343_HUE_MAX, 1,
+				      ADV7343_HUE_DEF);
+	v4l2_ctrl_new_std(&state->hdl, &adv7343_ctrl_ops,
+			V4L2_CID_GAIN, ADV7343_GAIN_MIN,
+				       ADV7343_GAIN_MAX, 1,
+				       ADV7343_GAIN_DEF);
+	state->sd.ctrl_handler = &state->hdl;
+	if (state->hdl.error) {
+		int err = state->hdl.error;
+
+		v4l2_ctrl_handler_free(&state->hdl);
+		kfree(state);
+		return err;
+	}
+	v4l2_ctrl_handler_setup(&state->hdl);
+
+	err = adv7343_initialize(&state->sd);
+	if (err) {
+		v4l2_ctrl_handler_free(&state->hdl);
+		kfree(state);
+	}
+	return err;
 }
 
 static int adv7343_remove(struct i2c_client *client)
 {
 	struct v4l2_subdev *sd = i2c_get_clientdata(client);
+	struct adv7343_state *state = to_state(sd);
 
 	v4l2_device_unregister_subdev(sd);
-	kfree(to_state(sd));
+	v4l2_ctrl_handler_free(&state->hdl);
+	kfree(state);
 
 	return 0;
 }
diff --git a/drivers/media/video/adv7343_regs.h b/drivers/media/video/adv7343_regs.h
index 3431045..4466067 100644
--- a/drivers/media/video/adv7343_regs.h
+++ b/drivers/media/video/adv7343_regs.h
@@ -102,10 +102,6 @@ struct adv7343_std_info {
 
 /* Bit masks for DAC output levels */
 #define DAC_OUTPUT_LEVEL_MASK		(0xFF)
-#define POSITIVE_GAIN_MAX		(0x40)
-#define POSITIVE_GAIN_MIN		(0x00)
-#define NEGATIVE_GAIN_MAX		(0xFF)
-#define NEGATIVE_GAIN_MIN		(0xC0)
 
 /* Bit masks for soft reset register */
 #define SOFT_RESET			(0x02)
@@ -178,8 +174,8 @@ struct adv7343_std_info {
 #define ADV7343_HUE_MAX		(255)
 #define ADV7343_HUE_MIN		(0)
 #define ADV7343_HUE_DEF		(127)
-#define ADV7343_GAIN_MAX	(255)
-#define ADV7343_GAIN_MIN	(0)
+#define ADV7343_GAIN_MAX	(64)
+#define ADV7343_GAIN_MIN	(-64)
 #define ADV7343_GAIN_DEF	(0)
 
 #endif
-- 
1.7.0.4

