Return-path: <mchehab@gaivota>
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:4231 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752623Ab0LLRcG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 12 Dec 2010 12:32:06 -0500
Received: from localhost.localdomain (159.80-203-19.nextgentel.com [80.203.19.159])
	(authenticated bits=0)
	by smtp-vbr5.xs4all.nl (8.13.8/8.13.8) with ESMTP id oBCHW1M9002236
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Sun, 12 Dec 2010 18:32:02 +0100 (CET)
	(envelope-from hverkuil@xs4all.nl)
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: [RFC/PATCH 01/19] cs5345: use the control framework
Date: Sun, 12 Dec 2010 18:31:43 +0100
Message-Id: <5632349bb82d4b46f36b813c3dd68e33a7976228.1292174822.git.hverkuil@xs4all.nl>
In-Reply-To: <cover.1292174822.git.hverkuil@xs4all.nl>
References: <cover.1292174822.git.hverkuil@xs4all.nl>
In-Reply-To: <cover.1292174822.git.hverkuil@xs4all.nl>
References: <cover.1292174822.git.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
---
 drivers/media/video/cs5345.c |   87 ++++++++++++++++++++++++++++-------------
 1 files changed, 59 insertions(+), 28 deletions(-)

diff --git a/drivers/media/video/cs5345.c b/drivers/media/video/cs5345.c
index 9358fe7..5909f25 100644
--- a/drivers/media/video/cs5345.c
+++ b/drivers/media/video/cs5345.c
@@ -25,6 +25,7 @@
 #include <linux/slab.h>
 #include <media/v4l2-device.h>
 #include <media/v4l2-chip-ident.h>
+#include <media/v4l2-ctrls.h>
 
 MODULE_DESCRIPTION("i2c device driver for cs5345 Audio ADC");
 MODULE_AUTHOR("Hans Verkuil");
@@ -36,6 +37,20 @@ module_param(debug, bool, 0644);
 
 MODULE_PARM_DESC(debug, "Debugging messages, 0=Off (default), 1=On");
 
+struct cs5345_state {
+	struct v4l2_subdev sd;
+	struct v4l2_ctrl_handler hdl;
+};
+
+static inline struct cs5345_state *to_state(struct v4l2_subdev *sd)
+{
+	return container_of(sd, struct cs5345_state, sd);
+}
+
+static inline struct v4l2_subdev *to_sd(struct v4l2_ctrl *ctrl)
+{
+	return &container_of(ctrl->handler, struct cs5345_state, hdl)->sd;
+}
 
 /* ----------------------------------------------------------------------- */
 
@@ -65,33 +80,20 @@ static int cs5345_s_routing(struct v4l2_subdev *sd,
 	return 0;
 }
 
-static int cs5345_g_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl)
+static int cs5345_s_ctrl(struct v4l2_ctrl *ctrl)
 {
-	if (ctrl->id == V4L2_CID_AUDIO_MUTE) {
-		ctrl->value = (cs5345_read(sd, 0x04) & 0x08) != 0;
-		return 0;
-	}
-	if (ctrl->id != V4L2_CID_AUDIO_VOLUME)
-		return -EINVAL;
-	ctrl->value = cs5345_read(sd, 0x07) & 0x3f;
-	if (ctrl->value >= 32)
-		ctrl->value = ctrl->value - 64;
-	return 0;
-}
+	struct v4l2_subdev *sd = to_sd(ctrl);
 
-static int cs5345_s_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl)
-{
-	if (ctrl->id == V4L2_CID_AUDIO_MUTE) {
-		cs5345_write(sd, 0x04, ctrl->value ? 0x80 : 0);
+	switch (ctrl->id) {
+	case V4L2_CID_AUDIO_MUTE:
+		cs5345_write(sd, 0x04, ctrl->val ? 0x80 : 0);
+		return 0;
+	case V4L2_CID_AUDIO_VOLUME:
+		cs5345_write(sd, 0x07, ((u8)ctrl->val) & 0x3f);
+		cs5345_write(sd, 0x08, ((u8)ctrl->val) & 0x3f);
 		return 0;
 	}
-	if (ctrl->id != V4L2_CID_AUDIO_VOLUME)
-		return -EINVAL;
-	if (ctrl->value > 24 || ctrl->value < -24)
-		return -EINVAL;
-	cs5345_write(sd, 0x07, ((u8)ctrl->value) & 0x3f);
-	cs5345_write(sd, 0x08, ((u8)ctrl->value) & 0x3f);
-	return 0;
+	return -EINVAL;
 }
 
 #ifdef CONFIG_VIDEO_ADV_DEBUG
@@ -144,11 +146,20 @@ static int cs5345_log_status(struct v4l2_subdev *sd)
 
 /* ----------------------------------------------------------------------- */
 
+static const struct v4l2_ctrl_ops cs5345_ctrl_ops = {
+	.s_ctrl = cs5345_s_ctrl,
+};
+
 static const struct v4l2_subdev_core_ops cs5345_core_ops = {
 	.log_status = cs5345_log_status,
 	.g_chip_ident = cs5345_g_chip_ident,
-	.g_ctrl = cs5345_g_ctrl,
-	.s_ctrl = cs5345_s_ctrl,
+	.g_ext_ctrls = v4l2_subdev_g_ext_ctrls,
+	.try_ext_ctrls = v4l2_subdev_try_ext_ctrls,
+	.s_ext_ctrls = v4l2_subdev_s_ext_ctrls,
+	.g_ctrl = v4l2_subdev_g_ctrl,
+	.s_ctrl = v4l2_subdev_s_ctrl,
+	.queryctrl = v4l2_subdev_queryctrl,
+	.querymenu = v4l2_subdev_querymenu,
 #ifdef CONFIG_VIDEO_ADV_DEBUG
 	.g_register = cs5345_g_register,
 	.s_register = cs5345_s_register,
@@ -169,6 +180,7 @@ static const struct v4l2_subdev_ops cs5345_ops = {
 static int cs5345_probe(struct i2c_client *client,
 			const struct i2c_device_id *id)
 {
+	struct cs5345_state *state;
 	struct v4l2_subdev *sd;
 
 	/* Check if the adapter supports the needed features */
@@ -178,11 +190,28 @@ static int cs5345_probe(struct i2c_client *client,
 	v4l_info(client, "chip found @ 0x%x (%s)\n",
 			client->addr << 1, client->adapter->name);
 
-	sd = kzalloc(sizeof(struct v4l2_subdev), GFP_KERNEL);
-	if (sd == NULL)
+	state = kzalloc(sizeof(struct cs5345_state), GFP_KERNEL);
+	if (state == NULL)
 		return -ENOMEM;
+	sd = &state->sd;
 	v4l2_i2c_subdev_init(sd, client, &cs5345_ops);
 
+	v4l2_ctrl_handler_init(&state->hdl, 2);
+	v4l2_ctrl_new_std(&state->hdl, &cs5345_ctrl_ops,
+			V4L2_CID_AUDIO_MUTE, 0, 1, 1, 0);
+	v4l2_ctrl_new_std(&state->hdl, &cs5345_ctrl_ops,
+			V4L2_CID_AUDIO_VOLUME, -24, 24, 1, 0);
+	sd->ctrl_handler = &state->hdl;
+	if (state->hdl.error) {
+		int err = state->hdl.error;
+
+		v4l2_ctrl_handler_free(&state->hdl);
+		kfree(state);
+		return err;
+	}
+	/* set volume/mute */
+	v4l2_ctrl_handler_setup(&state->hdl);
+
 	cs5345_write(sd, 0x02, 0x00);
 	cs5345_write(sd, 0x04, 0x01);
 	cs5345_write(sd, 0x09, 0x01);
@@ -194,9 +223,11 @@ static int cs5345_probe(struct i2c_client *client,
 static int cs5345_remove(struct i2c_client *client)
 {
 	struct v4l2_subdev *sd = i2c_get_clientdata(client);
+	struct cs5345_state *state = to_state(sd);
 
 	v4l2_device_unregister_subdev(sd);
-	kfree(sd);
+	v4l2_ctrl_handler_free(&state->hdl);
+	kfree(state);
 	return 0;
 }
 
-- 
1.7.0.4

