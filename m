Return-path: <mchehab@gaivota>
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:2479 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753571Ab0LLRcI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 12 Dec 2010 12:32:08 -0500
Received: from localhost.localdomain (159.80-203-19.nextgentel.com [80.203.19.159])
	(authenticated bits=0)
	by smtp-vbr5.xs4all.nl (8.13.8/8.13.8) with ESMTP id oBCHW1MI002236
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Sun, 12 Dec 2010 18:32:06 +0100 (CET)
	(envelope-from hverkuil@xs4all.nl)
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: [RFC/PATCH 10/19] tlv320aic23b: use control framework
Date: Sun, 12 Dec 2010 18:31:52 +0100
Message-Id: <9e51eb65344636245392a06996eaa7d3c0eef0b5.1292174822.git.hverkuil@xs4all.nl>
In-Reply-To: <cover.1292174822.git.hverkuil@xs4all.nl>
References: <cover.1292174822.git.hverkuil@xs4all.nl>
In-Reply-To: <cover.1292174822.git.hverkuil@xs4all.nl>
References: <cover.1292174822.git.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
---
 drivers/media/video/tlv320aic23b.c |   74 +++++++++++++++++++++++-------------
 1 files changed, 47 insertions(+), 27 deletions(-)

diff --git a/drivers/media/video/tlv320aic23b.c b/drivers/media/video/tlv320aic23b.c
index dfc4dd7..286ec7e 100644
--- a/drivers/media/video/tlv320aic23b.c
+++ b/drivers/media/video/tlv320aic23b.c
@@ -31,6 +31,7 @@
 #include <linux/i2c.h>
 #include <linux/videodev2.h>
 #include <media/v4l2-device.h>
+#include <media/v4l2-ctrls.h>
 
 MODULE_DESCRIPTION("tlv320aic23b driver");
 MODULE_AUTHOR("Scott Alfter, Ulf Eklund, Hans Verkuil");
@@ -41,7 +42,7 @@ MODULE_LICENSE("GPL");
 
 struct tlv320aic23b_state {
 	struct v4l2_subdev sd;
-	u8 muted;
+	struct v4l2_ctrl_handler hdl;
 };
 
 static inline struct tlv320aic23b_state *to_state(struct v4l2_subdev *sd)
@@ -49,6 +50,11 @@ static inline struct tlv320aic23b_state *to_state(struct v4l2_subdev *sd)
 	return container_of(sd, struct tlv320aic23b_state, sd);
 }
 
+static inline struct v4l2_subdev *to_sd(struct v4l2_ctrl *ctrl)
+{
+	return &container_of(ctrl->handler, struct tlv320aic23b_state, hdl)->sd;
+}
+
 static int tlv320aic23b_write(struct v4l2_subdev *sd, int reg, u16 val)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
@@ -85,44 +91,44 @@ static int tlv320aic23b_s_clock_freq(struct v4l2_subdev *sd, u32 freq)
 	return 0;
 }
 
-static int tlv320aic23b_g_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl)
-{
-	struct tlv320aic23b_state *state = to_state(sd);
-
-	if (ctrl->id != V4L2_CID_AUDIO_MUTE)
-		return -EINVAL;
-	ctrl->value = state->muted;
-	return 0;
-}
-
-static int tlv320aic23b_s_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl)
+static int tlv320aic23b_s_ctrl(struct v4l2_ctrl *ctrl)
 {
-	struct tlv320aic23b_state *state = to_state(sd);
-
-	if (ctrl->id != V4L2_CID_AUDIO_MUTE)
-		return -EINVAL;
-	state->muted = ctrl->value;
-	tlv320aic23b_write(sd, 0, 0x180); /* mute both channels */
-	/* set gain on both channels to +3.0 dB */
-	if (!state->muted)
-		tlv320aic23b_write(sd, 0, 0x119);
-	return 0;
+	struct v4l2_subdev *sd = to_sd(ctrl);
+
+	switch (ctrl->id) {
+	case V4L2_CID_AUDIO_MUTE:
+		tlv320aic23b_write(sd, 0, 0x180); /* mute both channels */
+		/* set gain on both channels to +3.0 dB */
+		if (!ctrl->val)
+			tlv320aic23b_write(sd, 0, 0x119);
+		return 0;
+	}
+	return -EINVAL;
 }
 
 static int tlv320aic23b_log_status(struct v4l2_subdev *sd)
 {
 	struct tlv320aic23b_state *state = to_state(sd);
 
-	v4l2_info(sd, "Input: %s\n", state->muted ? "muted" : "active");
+	v4l2_ctrl_handler_log_status(&state->hdl, sd->name);
 	return 0;
 }
 
 /* ----------------------------------------------------------------------- */
 
+static const struct v4l2_ctrl_ops tlv320aic23b_ctrl_ops = {
+	.s_ctrl = tlv320aic23b_s_ctrl,
+};
+
 static const struct v4l2_subdev_core_ops tlv320aic23b_core_ops = {
 	.log_status = tlv320aic23b_log_status,
-	.g_ctrl = tlv320aic23b_g_ctrl,
-	.s_ctrl = tlv320aic23b_s_ctrl,
+	.g_ext_ctrls = v4l2_subdev_g_ext_ctrls,
+	.try_ext_ctrls = v4l2_subdev_try_ext_ctrls,
+	.s_ext_ctrls = v4l2_subdev_s_ext_ctrls,
+	.g_ctrl = v4l2_subdev_g_ctrl,
+	.s_ctrl = v4l2_subdev_s_ctrl,
+	.queryctrl = v4l2_subdev_queryctrl,
+	.querymenu = v4l2_subdev_querymenu,
 };
 
 static const struct v4l2_subdev_audio_ops tlv320aic23b_audio_ops = {
@@ -161,7 +167,6 @@ static int tlv320aic23b_probe(struct i2c_client *client,
 		return -ENOMEM;
 	sd = &state->sd;
 	v4l2_i2c_subdev_init(sd, client, &tlv320aic23b_ops);
-	state->muted = 0;
 
 	/* Initialize tlv320aic23b */
 
@@ -177,15 +182,30 @@ static int tlv320aic23b_probe(struct i2c_client *client,
 	tlv320aic23b_write(sd, 8, 0x000);
 	/* activate digital interface */
 	tlv320aic23b_write(sd, 9, 0x001);
+
+	v4l2_ctrl_handler_init(&state->hdl, 1);
+	v4l2_ctrl_new_std(&state->hdl, &tlv320aic23b_ctrl_ops,
+			V4L2_CID_AUDIO_MUTE, 0, 1, 1, 0);
+	sd->ctrl_handler = &state->hdl;
+	if (state->hdl.error) {
+		int err = state->hdl.error;
+
+		v4l2_ctrl_handler_free(&state->hdl);
+		kfree(state);
+		return err;
+	}
+	v4l2_ctrl_handler_setup(&state->hdl);
 	return 0;
 }
 
 static int tlv320aic23b_remove(struct i2c_client *client)
 {
 	struct v4l2_subdev *sd = i2c_get_clientdata(client);
+	struct tlv320aic23b_state *state = to_state(sd);
 
 	v4l2_device_unregister_subdev(sd);
-	kfree(to_state(sd));
+	v4l2_ctrl_handler_free(&state->hdl);
+	kfree(state);
 	return 0;
 }
 
-- 
1.7.0.4

