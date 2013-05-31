Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr19.xs4all.nl ([194.109.24.39]:2347 "EHLO
	smtp-vbr19.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752358Ab3EaKDH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 31 May 2013 06:03:07 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	=?UTF-8?q?Richard=20R=C3=B6jfors?= <richard.rojfors@pelagicore.com>
Subject: [PATCH 01/21] saa7706h: convert to the control framework.
Date: Fri, 31 May 2013 12:02:21 +0200
Message-Id: <1369994561-25236-2-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1369994561-25236-1-git-send-email-hverkuil@xs4all.nl>
References: <1369994561-25236-1-git-send-email-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Richard Röjfors <richard.rojfors@pelagicore.com>
---
 drivers/media/radio/saa7706h.c |   58 +++++++++++++++++++++-------------------
 1 file changed, 30 insertions(+), 28 deletions(-)

diff --git a/drivers/media/radio/saa7706h.c b/drivers/media/radio/saa7706h.c
index 06c06cc..1f09844 100644
--- a/drivers/media/radio/saa7706h.c
+++ b/drivers/media/radio/saa7706h.c
@@ -26,6 +26,7 @@
 #include <linux/slab.h>
 #include <media/v4l2-device.h>
 #include <media/v4l2-chip-ident.h>
+#include <media/v4l2-ctrls.h>
 
 #define DRIVER_NAME "saa7706h"
 
@@ -127,6 +128,7 @@
 
 struct saa7706h_state {
 	struct v4l2_subdev sd;
+	struct v4l2_ctrl_handler hdl;
 	unsigned muted;
 };
 
@@ -317,34 +319,16 @@ static int saa7706h_mute(struct v4l2_subdev *sd)
 	return err;
 }
 
-static int saa7706h_queryctrl(struct v4l2_subdev *sd, struct v4l2_queryctrl *qc)
+static int saa7706h_s_ctrl(struct v4l2_ctrl *ctrl)
 {
-	switch (qc->id) {
-	case V4L2_CID_AUDIO_MUTE:
-		return v4l2_ctrl_query_fill(qc, 0, 1, 1, 1);
-	}
-	return -EINVAL;
-}
-
-static int saa7706h_g_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl)
-{
-	struct saa7706h_state *state = to_state(sd);
-
-	switch (ctrl->id) {
-	case V4L2_CID_AUDIO_MUTE:
-		ctrl->value = state->muted;
-		return 0;
-	}
-	return -EINVAL;
-}
+	struct saa7706h_state *state =
+		container_of(ctrl->handler, struct saa7706h_state, hdl);
 
-static int saa7706h_s_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl)
-{
 	switch (ctrl->id) {
 	case V4L2_CID_AUDIO_MUTE:
-		if (ctrl->value)
-			return saa7706h_mute(sd);
-		return saa7706h_unmute(sd);
+		if (ctrl->val)
+			return saa7706h_mute(&state->sd);
+		return saa7706h_unmute(&state->sd);
 	}
 	return -EINVAL;
 }
@@ -357,11 +341,19 @@ static int saa7706h_g_chip_ident(struct v4l2_subdev *sd,
 	return v4l2_chip_ident_i2c_client(client, chip, V4L2_IDENT_SAA7706H, 0);
 }
 
+static const struct v4l2_ctrl_ops saa7706h_ctrl_ops = {
+	.s_ctrl = saa7706h_s_ctrl,
+};
+
 static const struct v4l2_subdev_core_ops saa7706h_core_ops = {
 	.g_chip_ident = saa7706h_g_chip_ident,
-	.queryctrl = saa7706h_queryctrl,
-	.g_ctrl = saa7706h_g_ctrl,
-	.s_ctrl = saa7706h_s_ctrl,
+	.g_ext_ctrls = v4l2_subdev_g_ext_ctrls,
+	.try_ext_ctrls = v4l2_subdev_try_ext_ctrls,
+	.s_ext_ctrls = v4l2_subdev_s_ext_ctrls,
+	.g_ctrl = v4l2_subdev_g_ctrl,
+	.s_ctrl = v4l2_subdev_s_ctrl,
+	.queryctrl = v4l2_subdev_queryctrl,
+	.querymenu = v4l2_subdev_querymenu,
 };
 
 static const struct v4l2_subdev_ops saa7706h_ops = {
@@ -393,13 +385,20 @@ static int saa7706h_probe(struct i2c_client *client,
 	sd = &state->sd;
 	v4l2_i2c_subdev_init(sd, client, &saa7706h_ops);
 
+	v4l2_ctrl_handler_init(&state->hdl, 4);
+	v4l2_ctrl_new_std(&state->hdl, &saa7706h_ctrl_ops,
+			V4L2_CID_AUDIO_MUTE, 0, 1, 1, 1);
+	sd->ctrl_handler = &state->hdl;
+	err = state->hdl.error;
+	if (err)
+		goto err;
+
 	/* check the rom versions */
 	err = saa7706h_get_reg16(sd, SAA7706H_DSP1_ROM_VER);
 	if (err < 0)
 		goto err;
 	if (err != SUPPORTED_DSP1_ROM_VER)
 		v4l2_warn(sd, "Unknown DSP1 ROM code version: 0x%x\n", err);
-
 	state->muted = 1;
 
 	/* startup in a muted state */
@@ -411,6 +410,7 @@ static int saa7706h_probe(struct i2c_client *client,
 
 err:
 	v4l2_device_unregister_subdev(sd);
+	v4l2_ctrl_handler_free(&state->hdl);
 	kfree(to_state(sd));
 
 	printk(KERN_ERR DRIVER_NAME ": Failed to probe: %d\n", err);
@@ -421,9 +421,11 @@ err:
 static int saa7706h_remove(struct i2c_client *client)
 {
 	struct v4l2_subdev *sd = i2c_get_clientdata(client);
+	struct saa7706h_state *state = to_state(sd);
 
 	saa7706h_mute(sd);
 	v4l2_device_unregister_subdev(sd);
+	v4l2_ctrl_handler_free(&state->hdl);
 	kfree(to_state(sd));
 	return 0;
 }
-- 
1.7.10.4

