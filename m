Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr16.xs4all.nl ([194.109.24.36]:3466 "EHLO
	smtp-vbr16.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754624Ab0DZHeQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 26 Apr 2010 03:34:16 -0400
Message-Id: <69ead14035d429e3910725d23d72d6071ee7ba84.1272267137.git.hverkuil@xs4all.nl>
In-Reply-To: <cover.1272267136.git.hverkuil@xs4all.nl>
References: <cover.1272267136.git.hverkuil@xs4all.nl>
From: Hans Verkuil <hverkuil@xs4all.nl>
Date: Mon, 26 Apr 2010 09:34:14 +0200
Subject: [PATCH 12/15] [RFC] cs53l32a: convert to new control framework.
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
---
 drivers/media/video/cs53l32a.c |  107 +++++++++++++++++++++++++--------------
 1 files changed, 68 insertions(+), 39 deletions(-)

diff --git a/drivers/media/video/cs53l32a.c b/drivers/media/video/cs53l32a.c
index 80bca8d..c405d05 100644
--- a/drivers/media/video/cs53l32a.c
+++ b/drivers/media/video/cs53l32a.c
@@ -25,10 +25,10 @@
 #include <linux/ioctl.h>
 #include <asm/uaccess.h>
 #include <linux/i2c.h>
-#include <linux/i2c-id.h>
 #include <linux/videodev2.h>
 #include <media/v4l2-device.h>
 #include <media/v4l2-chip-ident.h>
+#include <media/v4l2-ctrls.h>
 #include <media/v4l2-i2c-drv.h>
 
 MODULE_DESCRIPTION("i2c device driver for cs53l32a Audio ADC");
@@ -42,6 +42,21 @@ module_param(debug, bool, 0644);
 MODULE_PARM_DESC(debug, "Debugging messages, 0=Off (default), 1=On");
 
 
+struct cs53l32a_state {
+	struct v4l2_subdev sd;
+	struct v4l2_ctrl_handler hdl;
+};
+
+static inline struct cs53l32a_state *to_state(struct v4l2_subdev *sd)
+{
+	return container_of(sd, struct cs53l32a_state, sd);
+}
+
+static inline struct v4l2_subdev *to_sd(struct v4l2_ctrl *ctrl)
+{
+	return &container_of(ctrl->handler, struct cs53l32a_state, hdl)->sd;
+}
+
 /* ----------------------------------------------------------------------- */
 
 static int cs53l32a_write(struct v4l2_subdev *sd, u8 reg, u8 value)
@@ -73,31 +88,20 @@ static int cs53l32a_s_routing(struct v4l2_subdev *sd,
 	return 0;
 }
 
-static int cs53l32a_g_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl)
+static int cs53l32a_s_ctrl(struct v4l2_ctrl *ctrl)
 {
-	if (ctrl->id == V4L2_CID_AUDIO_MUTE) {
-		ctrl->value = (cs53l32a_read(sd, 0x03) & 0xc0) != 0;
-		return 0;
-	}
-	if (ctrl->id != V4L2_CID_AUDIO_VOLUME)
-		return -EINVAL;
-	ctrl->value = (s8)cs53l32a_read(sd, 0x04);
-	return 0;
-}
+	struct v4l2_subdev *sd = to_sd(ctrl);
 
-static int cs53l32a_s_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl)
-{
-	if (ctrl->id == V4L2_CID_AUDIO_MUTE) {
-		cs53l32a_write(sd, 0x03, ctrl->value ? 0xf0 : 0x30);
+	switch (ctrl->id) {
+	case V4L2_CID_AUDIO_MUTE:
+		cs53l32a_write(sd, 0x03, ctrl->val ? 0xf0 : 0x30);
+		return 0;
+	case V4L2_CID_AUDIO_VOLUME:
+		cs53l32a_write(sd, 0x04, (u8)ctrl->val);
+		cs53l32a_write(sd, 0x05, (u8)ctrl->val);
 		return 0;
 	}
-	if (ctrl->id != V4L2_CID_AUDIO_VOLUME)
-		return -EINVAL;
-	if (ctrl->value > 12 || ctrl->value < -96)
-		return -EINVAL;
-	cs53l32a_write(sd, 0x04, (u8) ctrl->value);
-	cs53l32a_write(sd, 0x05, (u8) ctrl->value);
-	return 0;
+	return -EINVAL;
 }
 
 static int cs53l32a_g_chip_ident(struct v4l2_subdev *sd, struct v4l2_dbg_chip_ident *chip)
@@ -110,23 +114,30 @@ static int cs53l32a_g_chip_ident(struct v4l2_subdev *sd, struct v4l2_dbg_chip_id
 
 static int cs53l32a_log_status(struct v4l2_subdev *sd)
 {
+	struct cs53l32a_state *state = to_state(sd);
 	u8 v = cs53l32a_read(sd, 0x01);
-	u8 m = cs53l32a_read(sd, 0x03);
-	s8 vol = cs53l32a_read(sd, 0x04);
 
-	v4l2_info(sd, "Input:  %d%s\n", (v >> 4) & 3,
-			(m & 0xC0) ? " (muted)" : "");
-	v4l2_info(sd, "Volume: %d dB\n", vol);
+	v4l2_info(sd, "Input:  %d\n", (v >> 4) & 3);
+	v4l2_ctrl_handler_log_status(&state->hdl, sd->name);
 	return 0;
 }
 
 /* ----------------------------------------------------------------------- */
 
+static const struct v4l2_ctrl_ops cs53l32a_ctrl_ops = {
+	.s_ctrl = cs53l32a_s_ctrl,
+};
+
 static const struct v4l2_subdev_core_ops cs53l32a_core_ops = {
 	.log_status = cs53l32a_log_status,
 	.g_chip_ident = cs53l32a_g_chip_ident,
-	.g_ctrl = cs53l32a_g_ctrl,
-	.s_ctrl = cs53l32a_s_ctrl,
+	.g_ext_ctrls = v4l2_sd_g_ext_ctrls,
+	.try_ext_ctrls = v4l2_sd_try_ext_ctrls,
+	.s_ext_ctrls = v4l2_sd_s_ext_ctrls,
+	.g_ctrl = v4l2_sd_g_ctrl,
+	.s_ctrl = v4l2_sd_s_ctrl,
+	.queryctrl = v4l2_sd_queryctrl,
+	.querymenu = v4l2_sd_querymenu,
 };
 
 static const struct v4l2_subdev_audio_ops cs53l32a_audio_ops = {
@@ -150,6 +161,7 @@ static const struct v4l2_subdev_ops cs53l32a_ops = {
 static int cs53l32a_probe(struct i2c_client *client,
 			  const struct i2c_device_id *id)
 {
+	struct cs53l32a_state *state;
 	struct v4l2_subdev *sd;
 	int i;
 
@@ -163,9 +175,10 @@ static int cs53l32a_probe(struct i2c_client *client,
 	v4l_info(client, "chip found @ 0x%x (%s)\n",
 			client->addr << 1, client->adapter->name);
 
-	sd = kmalloc(sizeof(struct v4l2_subdev), GFP_KERNEL);
-	if (sd == NULL)
+	state = kzalloc(sizeof(struct cs53l32a_state), GFP_KERNEL);
+	if (state == NULL)
 		return -ENOMEM;
+	sd = &state->sd;
 	v4l2_i2c_subdev_init(sd, client, &cs53l32a_ops);
 
 	for (i = 1; i <= 7; i++) {
@@ -174,15 +187,29 @@ static int cs53l32a_probe(struct i2c_client *client,
 		v4l2_dbg(1, debug, sd, "Read Reg %d %02x\n", i, v);
 	}
 
+	v4l2_ctrl_handler_init(&state->hdl, 2);
+	v4l2_ctrl_new_std(&state->hdl, &cs53l32a_ctrl_ops,
+			V4L2_CID_AUDIO_VOLUME, -96, 12, 1, 0);
+	v4l2_ctrl_new_std(&state->hdl, &cs53l32a_ctrl_ops,
+			V4L2_CID_AUDIO_MUTE, 0, 1, 1, 0);
+	sd->ctrl_handler = &state->hdl;
+	if (state->hdl.error) {
+		int err = state->hdl.error;
+
+		v4l2_ctrl_handler_free(&state->hdl);
+		kfree(state);
+		return err;
+	}
+
 	/* Set cs53l32a internal register for Adaptec 2010/2410 setup */
 
-	cs53l32a_write(sd, 0x01, (u8) 0x21);
-	cs53l32a_write(sd, 0x02, (u8) 0x29);
-	cs53l32a_write(sd, 0x03, (u8) 0x30);
-	cs53l32a_write(sd, 0x04, (u8) 0x00);
-	cs53l32a_write(sd, 0x05, (u8) 0x00);
-	cs53l32a_write(sd, 0x06, (u8) 0x00);
-	cs53l32a_write(sd, 0x07, (u8) 0x00);
+	cs53l32a_write(sd, 0x01, 0x21);
+	cs53l32a_write(sd, 0x02, 0x29);
+	cs53l32a_write(sd, 0x03, 0x30);
+	cs53l32a_write(sd, 0x04, 0x00);
+	cs53l32a_write(sd, 0x05, 0x00);
+	cs53l32a_write(sd, 0x06, 0x00);
+	cs53l32a_write(sd, 0x07, 0x00);
 
 	/* Display results, should be 0x21,0x29,0x30,0x00,0x00,0x00,0x00 */
 
@@ -197,9 +224,11 @@ static int cs53l32a_probe(struct i2c_client *client,
 static int cs53l32a_remove(struct i2c_client *client)
 {
 	struct v4l2_subdev *sd = i2c_get_clientdata(client);
+	struct cs53l32a_state *state = to_state(sd);
 
 	v4l2_device_unregister_subdev(sd);
-	kfree(sd);
+	v4l2_ctrl_handler_free(&state->hdl);
+	kfree(state);
 	return 0;
 }
 
-- 
1.6.4.2

