Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr2.xs4all.nl ([194.109.24.22]:4832 "EHLO
	smtp-vbr2.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757367Ab0E2Oow (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 29 May 2010 10:44:52 -0400
Message-Id: <37d17eb36bdd20acaeb81f53845095190bd96a6d.1275143672.git.hverkuil@xs4all.nl>
In-Reply-To: <cover.1275143672.git.hverkuil@xs4all.nl>
References: <cover.1275143672.git.hverkuil@xs4all.nl>
From: Hans Verkuil <hverkuil@xs4all.nl>
Date: Sat, 29 May 2010 16:46:42 +0200
Subject: [PATCH 11/15] [RFCv4] wm8775: convert to the new control framework
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
---
 drivers/media/video/wm8775.c |   79 ++++++++++++++++++++++++++---------------
 1 files changed, 50 insertions(+), 29 deletions(-)

diff --git a/drivers/media/video/wm8775.c b/drivers/media/video/wm8775.c
index f1f261a..09a9663 100644
--- a/drivers/media/video/wm8775.c
+++ b/drivers/media/video/wm8775.c
@@ -34,6 +34,7 @@
 #include <linux/videodev2.h>
 #include <media/v4l2-device.h>
 #include <media/v4l2-chip-ident.h>
+#include <media/v4l2-ctrls.h>
 #include <media/v4l2-i2c-drv.h>
 
 MODULE_DESCRIPTION("wm8775 driver");
@@ -52,8 +53,9 @@ enum {
 
 struct wm8775_state {
 	struct v4l2_subdev sd;
+	struct v4l2_ctrl_handler hdl;
+	struct v4l2_ctrl *mute;
 	u8 input;		/* Last selected input (0-0xf) */
-	u8 muted;
 };
 
 static inline struct wm8775_state *to_state(struct v4l2_subdev *sd)
@@ -61,6 +63,11 @@ static inline struct wm8775_state *to_state(struct v4l2_subdev *sd)
 	return container_of(sd, struct wm8775_state, sd);
 }
 
+static inline struct v4l2_subdev *to_sd(struct v4l2_ctrl *ctrl)
+{
+	return &container_of(ctrl->handler, struct wm8775_state, hdl)->sd;
+}
+
 static int wm8775_write(struct v4l2_subdev *sd, int reg, u16 val)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
@@ -94,7 +101,7 @@ static int wm8775_s_routing(struct v4l2_subdev *sd,
 		return -EINVAL;
 	}
 	state->input = input;
-	if (state->muted)
+	if (!v4l2_ctrl_g_ctrl(state->mute))
 		return 0;
 	wm8775_write(sd, R21, 0x0c0);
 	wm8775_write(sd, R14, 0x1d4);
@@ -103,29 +110,21 @@ static int wm8775_s_routing(struct v4l2_subdev *sd,
 	return 0;
 }
 
-static int wm8775_g_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl)
+static int wm8775_s_ctrl(struct v4l2_ctrl *ctrl)
 {
+	struct v4l2_subdev *sd = to_sd(ctrl);
 	struct wm8775_state *state = to_state(sd);
 
-	if (ctrl->id != V4L2_CID_AUDIO_MUTE)
-		return -EINVAL;
-	ctrl->value = state->muted;
-	return 0;
-}
-
-static int wm8775_s_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl)
-{
-	struct wm8775_state *state = to_state(sd);
-
-	if (ctrl->id != V4L2_CID_AUDIO_MUTE)
-		return -EINVAL;
-	state->muted = ctrl->value;
-	wm8775_write(sd, R21, 0x0c0);
-	wm8775_write(sd, R14, 0x1d4);
-	wm8775_write(sd, R15, 0x1d4);
-	if (!state->muted)
-		wm8775_write(sd, R21, 0x100 + state->input);
-	return 0;
+	switch (ctrl->id) {
+	case V4L2_CID_AUDIO_MUTE:
+		wm8775_write(sd, R21, 0x0c0);
+		wm8775_write(sd, R14, 0x1d4);
+		wm8775_write(sd, R15, 0x1d4);
+		if (!ctrl->val)
+			wm8775_write(sd, R21, 0x100 + state->input);
+		return 0;
+	}
+	return -EINVAL;
 }
 
 static int wm8775_g_chip_ident(struct v4l2_subdev *sd, struct v4l2_dbg_chip_ident *chip)
@@ -139,8 +138,8 @@ static int wm8775_log_status(struct v4l2_subdev *sd)
 {
 	struct wm8775_state *state = to_state(sd);
 
-	v4l2_info(sd, "Input: %d%s\n", state->input,
-			state->muted ? " (muted)" : "");
+	v4l2_info(sd, "Input: %d\n", state->input);
+	v4l2_ctrl_handler_log_status(&state->hdl, sd->name);
 	return 0;
 }
 
@@ -161,11 +160,20 @@ static int wm8775_s_frequency(struct v4l2_subdev *sd, struct v4l2_frequency *fre
 
 /* ----------------------------------------------------------------------- */
 
+static const struct v4l2_ctrl_ops wm8775_ctrl_ops = {
+	.s_ctrl = wm8775_s_ctrl,
+};
+
 static const struct v4l2_subdev_core_ops wm8775_core_ops = {
 	.log_status = wm8775_log_status,
 	.g_chip_ident = wm8775_g_chip_ident,
-	.g_ctrl = wm8775_g_ctrl,
-	.s_ctrl = wm8775_s_ctrl,
+	.g_ext_ctrls = v4l2_subdev_g_ext_ctrls,
+	.try_ext_ctrls = v4l2_subdev_try_ext_ctrls,
+	.s_ext_ctrls = v4l2_subdev_s_ext_ctrls,
+	.g_ctrl = v4l2_subdev_g_ctrl,
+	.s_ctrl = v4l2_subdev_s_ctrl,
+	.queryctrl = v4l2_subdev_queryctrl,
+	.querymenu = v4l2_subdev_querymenu,
 };
 
 static const struct v4l2_subdev_tuner_ops wm8775_tuner_ops = {
@@ -204,13 +212,24 @@ static int wm8775_probe(struct i2c_client *client,
 	v4l_info(client, "chip found @ 0x%02x (%s)\n",
 			client->addr << 1, client->adapter->name);
 
-	state = kmalloc(sizeof(struct wm8775_state), GFP_KERNEL);
+	state = kzalloc(sizeof(struct wm8775_state), GFP_KERNEL);
 	if (state == NULL)
 		return -ENOMEM;
 	sd = &state->sd;
 	v4l2_i2c_subdev_init(sd, client, &wm8775_ops);
 	state->input = 2;
-	state->muted = 0;
+
+	v4l2_ctrl_handler_init(&state->hdl, 1);
+	state->mute = v4l2_ctrl_new_std(&state->hdl, &wm8775_ctrl_ops,
+			V4L2_CID_AUDIO_MUTE, 0, 1, 1, 0);
+	sd->ctrl_handler = &state->hdl;
+	if (state->hdl.error) {
+		int err = state->hdl.error;
+
+		v4l2_ctrl_handler_free(&state->hdl);
+		kfree(state);
+		return err;
+	}
 
 	/* Initialize wm8775 */
 
@@ -247,9 +266,11 @@ static int wm8775_probe(struct i2c_client *client,
 static int wm8775_remove(struct i2c_client *client)
 {
 	struct v4l2_subdev *sd = i2c_get_clientdata(client);
+	struct wm8775_state *state = to_state(sd);
 
 	v4l2_device_unregister_subdev(sd);
-	kfree(to_state(sd));
+	v4l2_ctrl_handler_free(&state->hdl);
+	kfree(state);
 	return 0;
 }
 
-- 
1.6.4.2

