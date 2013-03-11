Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr7.xs4all.nl ([194.109.24.27]:3098 "EHLO
	smtp-vbr7.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754137Ab3CKLq7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Mar 2013 07:46:59 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Volokh Konstantin <volokh84@gmail.com>,
	Pete Eberlein <pete@sensoray.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEW PATCH 26/42] s2250: convert to the control framework.
Date: Mon, 11 Mar 2013 12:46:04 +0100
Message-Id: <e7cf4535dce5a419efb0847a6455ac66d2575ddf.1363000605.git.hans.verkuil@cisco.com>
In-Reply-To: <1363002380-19825-1-git-send-email-hverkuil@xs4all.nl>
References: <1363002380-19825-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <38bc3cc42d0c021432afd29c2c1e22cf380b06e0.1363000605.git.hans.verkuil@cisco.com>
References: <38bc3cc42d0c021432afd29c2c1e22cf380b06e0.1363000605.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/staging/media/go7007/s2250-board.c |  149 +++++++++-------------------
 1 file changed, 46 insertions(+), 103 deletions(-)

diff --git a/drivers/staging/media/go7007/s2250-board.c b/drivers/staging/media/go7007/s2250-board.c
index 2266e1b..5899513 100644
--- a/drivers/staging/media/go7007/s2250-board.c
+++ b/drivers/staging/media/go7007/s2250-board.c
@@ -116,6 +116,7 @@ static u16 vid_regs_fp_pal[] = {
 
 struct s2250 {
 	struct v4l2_subdev sd;
+	struct v4l2_ctrl_handler hdl;
 	v4l2_std_id std;
 	int input;
 	int brightness;
@@ -370,110 +371,36 @@ static int s2250_s_std(struct v4l2_subdev *sd, v4l2_std_id norm)
 	return 0;
 }
 
-static int s2250_queryctrl(struct v4l2_subdev *sd, struct v4l2_queryctrl *query)
+static int s2250_s_ctrl(struct v4l2_ctrl *ctrl)
 {
-	switch (query->id) {
-	case V4L2_CID_BRIGHTNESS:
-		return v4l2_ctrl_query_fill(query, 0, 100, 1, 50);
-	case V4L2_CID_CONTRAST:
-		return v4l2_ctrl_query_fill(query, 0, 100, 1, 50);
-	case V4L2_CID_SATURATION:
-		return v4l2_ctrl_query_fill(query, 0, 100, 1, 50);
-	case V4L2_CID_HUE:
-		return v4l2_ctrl_query_fill(query, -50, 50, 1, 0);
-	default:
-		return -EINVAL;
-	}
-	return 0;
-}
-
-static int s2250_s_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl)
-{
-	struct s2250 *state = to_state(sd);
-	struct i2c_client *client = v4l2_get_subdevdata(sd);
-	int value1;
+	struct s2250 *state = container_of(ctrl->handler, struct s2250, hdl);
+	struct i2c_client *client = v4l2_get_subdevdata(&state->sd);
 	u16 oldvalue;
 
 	switch (ctrl->id) {
 	case V4L2_CID_BRIGHTNESS:
-		if (ctrl->value > 100)
-			state->brightness = 100;
-		else if (ctrl->value < 0)
-			state->brightness = 0;
-		else
-			state->brightness = ctrl->value;
-		value1 = (state->brightness - 50) * 255 / 100;
 		read_reg_fp(client, VPX322_ADDR_BRIGHTNESS0, &oldvalue);
 		write_reg_fp(client, VPX322_ADDR_BRIGHTNESS0,
-			     value1 | (oldvalue & ~0xff));
+			     ctrl->val | (oldvalue & ~0xff));
 		read_reg_fp(client, VPX322_ADDR_BRIGHTNESS1, &oldvalue);
 		write_reg_fp(client, VPX322_ADDR_BRIGHTNESS1,
-			     value1 | (oldvalue & ~0xff));
+			     ctrl->val | (oldvalue & ~0xff));
 		write_reg_fp(client, 0x140, 0x60);
 		break;
 	case V4L2_CID_CONTRAST:
-		if (ctrl->value > 100)
-			state->contrast = 100;
-		else if (ctrl->value < 0)
-			state->contrast = 0;
-		else
-			state->contrast = ctrl->value;
-		value1 = state->contrast * 0x40 / 100;
-		if (value1 > 0x3f)
-			value1 = 0x3f; /* max */
 		read_reg_fp(client, VPX322_ADDR_CONTRAST0, &oldvalue);
 		write_reg_fp(client, VPX322_ADDR_CONTRAST0,
-			     value1 | (oldvalue & ~0x3f));
+			     ctrl->val | (oldvalue & ~0x3f));
 		read_reg_fp(client, VPX322_ADDR_CONTRAST1, &oldvalue);
 		write_reg_fp(client, VPX322_ADDR_CONTRAST1,
-			     value1 | (oldvalue & ~0x3f));
+			     ctrl->val | (oldvalue & ~0x3f));
 		write_reg_fp(client, 0x140, 0x60);
 		break;
 	case V4L2_CID_SATURATION:
-		if (ctrl->value > 100)
-			state->saturation = 100;
-		else if (ctrl->value < 0)
-			state->saturation = 0;
-		else
-			state->saturation = ctrl->value;
-		value1 = state->saturation * 4140 / 100;
-		if (value1 > 4094)
-			value1 = 4094;
-		write_reg_fp(client, VPX322_ADDR_SAT, value1);
-		break;
-	case V4L2_CID_HUE:
-		if (ctrl->value > 50)
-			state->hue = 50;
-		else if (ctrl->value < -50)
-			state->hue = -50;
-		else
-			state->hue = ctrl->value;
-		/* clamp the hue range */
-		value1 = state->hue * 280 / 50;
-		write_reg_fp(client, VPX322_ADDR_HUE, value1);
-		break;
-	default:
-		return -EINVAL;
-	}
-	return 0;
-}
-
-static int s2250_g_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl)
-{
-	struct s2250 *state = to_state(sd);
-
-	switch (ctrl->id) {
-	case V4L2_CID_BRIGHTNESS:
-		ctrl->value = state->brightness;
-		break;
-	case V4L2_CID_CONTRAST:
-		ctrl->value = state->contrast;
-		break;
-	case V4L2_CID_SATURATION:
-		ctrl->value = state->saturation;
+		write_reg_fp(client, VPX322_ADDR_SAT, ctrl->val);
 		break;
 	case V4L2_CID_HUE:
-		ctrl->value = state->hue;
+		write_reg_fp(client, VPX322_ADDR_HUE, ctrl->val);
 		break;
 	default:
 		return -EINVAL;
@@ -531,24 +458,21 @@ static int s2250_log_status(struct v4l2_subdev *sd)
 	v4l2_info(sd, "Input: %s\n", state->input == 0 ? "Composite" :
 					state->input == 1 ? "S-video" :
 					"error");
-	v4l2_info(sd, "Brightness: %d\n", state->brightness);
-	v4l2_info(sd, "Contrast: %d\n", state->contrast);
-	v4l2_info(sd, "Saturation: %d\n", state->saturation);
-	v4l2_info(sd, "Hue: %d\n", state->hue);
 	v4l2_info(sd, "Audio input: %s\n", state->audio_input == 0 ? "Line In" :
 					state->audio_input == 1 ? "Mic" :
 					state->audio_input == 2 ? "Mic Boost" :
 					"error");
-	return 0;
+	return v4l2_ctrl_subdev_log_status(sd);
 }
 
 /* --------------------------------------------------------------------------*/
 
+static const struct v4l2_ctrl_ops s2250_ctrl_ops = {
+	.s_ctrl = s2250_s_ctrl,
+};
+
 static const struct v4l2_subdev_core_ops s2250_core_ops = {
 	.log_status = s2250_log_status,
-	.g_ctrl = s2250_g_ctrl,
-	.s_ctrl = s2250_s_ctrl,
-	.queryctrl = s2250_queryctrl,
 	.s_std = s2250_s_std,
 };
 
@@ -596,6 +520,24 @@ static int s2250_probe(struct i2c_client *client,
 	v4l2_info(sd, "initializing %s at address 0x%x on %s\n",
 	       "Sensoray 2250/2251", client->addr, client->adapter->name);
 
+	v4l2_ctrl_handler_init(&state->hdl, 4);
+	v4l2_ctrl_new_std(&state->hdl, &s2250_ctrl_ops,
+		V4L2_CID_BRIGHTNESS, -128, 127, 1, 0);
+	v4l2_ctrl_new_std(&state->hdl, &s2250_ctrl_ops,
+		V4L2_CID_CONTRAST, 0, 0x3f, 1, 0x32);
+	v4l2_ctrl_new_std(&state->hdl, &s2250_ctrl_ops,
+		V4L2_CID_SATURATION, 0, 4094, 1, 2070);
+	v4l2_ctrl_new_std(&state->hdl, &s2250_ctrl_ops,
+		V4L2_CID_HUE, -512, 511, 1, 0);
+	sd->ctrl_handler = &state->hdl;
+	if (state->hdl.error) {
+		int err = state->hdl.error;
+
+		v4l2_ctrl_handler_free(&state->hdl);
+		kfree(state);
+		return err;
+	}
+
 	state->std = V4L2_STD_NTSC;
 	state->brightness = 50;
 	state->contrast = 50;
@@ -606,22 +548,16 @@ static int s2250_probe(struct i2c_client *client,
 	/* initialize the audio */
 	if (write_regs(audio, aud_regs) < 0) {
 		dev_err(&client->dev, "error initializing audio\n");
-		i2c_unregister_device(audio);
-		kfree(state);
-		return 0;
+		goto fail;
 	}
 
 	if (write_regs(client, vid_regs) < 0) {
 		dev_err(&client->dev, "error initializing decoder\n");
-		i2c_unregister_device(audio);
-		kfree(state);
-		return 0;
+		goto fail;
 	}
 	if (write_regs_fp(client, vid_regs_fp) < 0) {
 		dev_err(&client->dev, "error initializing decoder\n");
-		i2c_unregister_device(audio);
-		kfree(state);
-		return 0;
+		goto fail;
 	}
 	/* set default channel */
 	/* composite */
@@ -657,14 +593,21 @@ static int s2250_probe(struct i2c_client *client,
 
 	v4l2_info(sd, "initialized successfully\n");
 	return 0;
+
+fail:
+	i2c_unregister_device(audio);
+	v4l2_ctrl_handler_free(&state->hdl);
+	kfree(state);
+	return -EIO;
 }
 
 static int s2250_remove(struct i2c_client *client)
 {
-	struct v4l2_subdev *sd = i2c_get_clientdata(client);
+	struct s2250 *state = to_state(i2c_get_clientdata(client));
 
-	v4l2_device_unregister_subdev(sd);
-	kfree(to_state(sd));
+	v4l2_device_unregister_subdev(&state->sd);
+	v4l2_ctrl_handler_free(&state->hdl);
+	kfree(state);
 	return 0;
 }
 
-- 
1.7.10.4

