Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:3253 "EHLO
	smtp-vbr4.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754541Ab0DZHeR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 26 Apr 2010 03:34:17 -0400
Message-Id: <926b98a50fd52e1a18c1d0470824600b21928d18.1272267137.git.hverkuil@xs4all.nl>
In-Reply-To: <cover.1272267136.git.hverkuil@xs4all.nl>
References: <cover.1272267136.git.hverkuil@xs4all.nl>
From: Hans Verkuil <hverkuil@xs4all.nl>
Date: Mon, 26 Apr 2010 09:34:15 +0200
Subject: [PATCH 13/15] [RFC] wm8739: convert to the new control framework
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
---
 drivers/media/video/wm8739.c |  176 ++++++++++++++----------------------------
 1 files changed, 59 insertions(+), 117 deletions(-)

diff --git a/drivers/media/video/wm8739.c b/drivers/media/video/wm8739.c
index b572ce2..fe77086 100644
--- a/drivers/media/video/wm8739.c
+++ b/drivers/media/video/wm8739.c
@@ -26,11 +26,11 @@
 #include <linux/ioctl.h>
 #include <asm/uaccess.h>
 #include <linux/i2c.h>
-#include <linux/i2c-id.h>
 #include <linux/videodev2.h>
 #include <media/v4l2-device.h>
 #include <media/v4l2-chip-ident.h>
 #include <media/v4l2-i2c-drv.h>
+#include <media/v4l2-ctrls.h>
 
 MODULE_DESCRIPTION("wm8739 driver");
 MODULE_AUTHOR("T. Adachi, Hans Verkuil");
@@ -53,12 +53,11 @@ enum {
 
 struct wm8739_state {
 	struct v4l2_subdev sd;
+	struct v4l2_ctrl_handler hdl;
+	struct v4l2_ctrl *volume;
+	struct v4l2_ctrl *mute;
+	struct v4l2_ctrl *balance;
 	u32 clock_freq;
-	u8 muted;
-	u16 volume;
-	u16 balance;
-	u8 vol_l; 		/* +12dB to -34.5dB 1.5dB step (5bit) def:0dB */
-	u8 vol_r; 		/* +12dB to -34.5dB 1.5dB step (5bit) def:0dB */
 };
 
 static inline struct wm8739_state *to_state(struct v4l2_subdev *sd)
@@ -66,6 +65,11 @@ static inline struct wm8739_state *to_state(struct v4l2_subdev *sd)
 	return container_of(sd, struct wm8739_state, sd);
 }
 
+static inline struct v4l2_subdev *to_sd(struct v4l2_ctrl *ctrl)
+{
+	return &container_of(ctrl->handler, struct wm8739_state, hdl)->sd;
+}
+
 /* ------------------------------------------------------------------------ */
 
 static int wm8739_write(struct v4l2_subdev *sd, int reg, u16 val)
@@ -88,58 +92,17 @@ static int wm8739_write(struct v4l2_subdev *sd, int reg, u16 val)
 	return -1;
 }
 
-/* write regs to set audio volume etc */
-static void wm8739_set_audio(struct v4l2_subdev *sd)
-{
-	struct wm8739_state *state = to_state(sd);
-	u16 mute = state->muted ? 0x80 : 0;
-
-	/* Volume setting: bits 0-4, 0x1f = 12 dB, 0x00 = -34.5 dB
-	 * Default setting: 0x17 = 0 dB
-	 */
-	wm8739_write(sd, R0, (state->vol_l & 0x1f) | mute);
-	wm8739_write(sd, R1, (state->vol_r & 0x1f) | mute);
-}
-
-static int wm8739_g_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl)
-{
-	struct wm8739_state *state = to_state(sd);
-
-	switch (ctrl->id) {
-	case V4L2_CID_AUDIO_MUTE:
-		ctrl->value = state->muted;
-		break;
-
-	case V4L2_CID_AUDIO_VOLUME:
-		ctrl->value = state->volume;
-		break;
-
-	case V4L2_CID_AUDIO_BALANCE:
-		ctrl->value = state->balance;
-		break;
-
-	default:
-		return -EINVAL;
-	}
-	return 0;
-}
-
-static int wm8739_s_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl)
+static int wm8739_s_ctrl(struct v4l2_ctrl *ctrl)
 {
+	struct v4l2_subdev *sd = to_sd(ctrl);
 	struct wm8739_state *state = to_state(sd);
 	unsigned int work_l, work_r;
+	u8 vol_l; 	/* +12dB to -34.5dB 1.5dB step (5bit) def:0dB */
+	u8 vol_r; 	/* +12dB to -34.5dB 1.5dB step (5bit) def:0dB */
+	u16 mute;
 
 	switch (ctrl->id) {
-	case V4L2_CID_AUDIO_MUTE:
-		state->muted = ctrl->value;
-		break;
-
 	case V4L2_CID_AUDIO_VOLUME:
-		state->volume = ctrl->value;
-		break;
-
-	case V4L2_CID_AUDIO_BALANCE:
-		state->balance = ctrl->value;
 		break;
 
 	default:
@@ -147,52 +110,25 @@ static int wm8739_s_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl)
 	}
 
 	/* normalize ( 65535 to 0 -> 31 to 0 (12dB to -34.5dB) ) */
-	work_l = (min(65536 - state->balance, 32768) * state->volume) / 32768;
-	work_r = (min(state->balance, (u16)32768) * state->volume) / 32768;
+	work_l = (min(65536 - state->balance->val, 32768) * state->volume->val) / 32768;
+	work_r = (min(state->balance->val, 32768) * state->volume->val) / 32768;
 
-	state->vol_l = (long)work_l * 31 / 65535;
-	state->vol_r = (long)work_r * 31 / 65535;
+	vol_l = (long)work_l * 31 / 65535;
+	vol_r = (long)work_r * 31 / 65535;
 
 	/* set audio volume etc. */
-	wm8739_set_audio(sd);
+	mute = state->mute->val ? 0x80 : 0;
+
+	/* Volume setting: bits 0-4, 0x1f = 12 dB, 0x00 = -34.5 dB
+	 * Default setting: 0x17 = 0 dB
+	 */
+	wm8739_write(sd, R0, (vol_l & 0x1f) | mute);
+	wm8739_write(sd, R1, (vol_r & 0x1f) | mute);
 	return 0;
 }
 
 /* ------------------------------------------------------------------------ */
 
-static struct v4l2_queryctrl wm8739_qctrl[] = {
-	{
-		.id            = V4L2_CID_AUDIO_VOLUME,
-		.name          = "Volume",
-		.minimum       = 0,
-		.maximum       = 65535,
-		.step          = 65535/100,
-		.default_value = 58880,
-		.flags         = 0,
-		.type          = V4L2_CTRL_TYPE_INTEGER,
-	}, {
-		.id            = V4L2_CID_AUDIO_MUTE,
-		.name          = "Mute",
-		.minimum       = 0,
-		.maximum       = 1,
-		.step          = 1,
-		.default_value = 1,
-		.flags         = 0,
-		.type          = V4L2_CTRL_TYPE_BOOLEAN,
-	}, {
-		.id            = V4L2_CID_AUDIO_BALANCE,
-		.name          = "Balance",
-		.minimum       = 0,
-		.maximum       = 65535,
-		.step          = 65535/100,
-		.default_value = 32768,
-		.flags         = 0,
-		.type          = V4L2_CTRL_TYPE_INTEGER,
-	}
-};
-
-/* ------------------------------------------------------------------------ */
-
 static int wm8739_s_clock_freq(struct v4l2_subdev *sd, u32 audiofreq)
 {
 	struct wm8739_state *state = to_state(sd);
@@ -221,18 +157,6 @@ static int wm8739_s_clock_freq(struct v4l2_subdev *sd, u32 audiofreq)
 	return 0;
 }
 
-static int wm8739_queryctrl(struct v4l2_subdev *sd, struct v4l2_queryctrl *qc)
-{
-	int i;
-
-	for (i = 0; i < ARRAY_SIZE(wm8739_qctrl); i++)
-		if (qc->id && qc->id == wm8739_qctrl[i].id) {
-			memcpy(qc, &wm8739_qctrl[i], sizeof(*qc));
-			return 0;
-		}
-	return -EINVAL;
-}
-
 static int wm8739_g_chip_ident(struct v4l2_subdev *sd, struct v4l2_dbg_chip_ident *chip)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
@@ -245,21 +169,26 @@ static int wm8739_log_status(struct v4l2_subdev *sd)
 	struct wm8739_state *state = to_state(sd);
 
 	v4l2_info(sd, "Frequency: %u Hz\n", state->clock_freq);
-	v4l2_info(sd, "Volume L:  %02x%s\n", state->vol_l & 0x1f,
-			state->muted ? " (muted)" : "");
-	v4l2_info(sd, "Volume R:  %02x%s\n", state->vol_r & 0x1f,
-			state->muted ? " (muted)" : "");
+	v4l2_ctrl_handler_log_status(&state->hdl, sd->name);
 	return 0;
 }
 
 /* ----------------------------------------------------------------------- */
 
+static const struct v4l2_ctrl_ops wm8739_ctrl_ops = {
+	.s_ctrl = wm8739_s_ctrl,
+};
+
 static const struct v4l2_subdev_core_ops wm8739_core_ops = {
 	.log_status = wm8739_log_status,
 	.g_chip_ident = wm8739_g_chip_ident,
-	.queryctrl = wm8739_queryctrl,
-	.g_ctrl = wm8739_g_ctrl,
-	.s_ctrl = wm8739_s_ctrl,
+	.g_ext_ctrls = v4l2_sd_g_ext_ctrls,
+	.try_ext_ctrls = v4l2_sd_try_ext_ctrls,
+	.s_ext_ctrls = v4l2_sd_s_ext_ctrls,
+	.g_ctrl = v4l2_sd_g_ctrl,
+	.s_ctrl = v4l2_sd_s_ctrl,
+	.queryctrl = v4l2_sd_queryctrl,
+	.querymenu = v4l2_sd_querymenu,
 };
 
 static const struct v4l2_subdev_audio_ops wm8739_audio_ops = {
@@ -288,17 +217,28 @@ static int wm8739_probe(struct i2c_client *client,
 	v4l_info(client, "chip found @ 0x%x (%s)\n",
 			client->addr << 1, client->adapter->name);
 
-	state = kmalloc(sizeof(struct wm8739_state), GFP_KERNEL);
+	state = kzalloc(sizeof(struct wm8739_state), GFP_KERNEL);
 	if (state == NULL)
 		return -ENOMEM;
 	sd = &state->sd;
 	v4l2_i2c_subdev_init(sd, client, &wm8739_ops);
-	state->vol_l = 0x17; /* 0dB */
-	state->vol_r = 0x17; /* 0dB */
-	state->muted = 0;
-	state->balance = 32768;
-	/* normalize (12dB(31) to -34.5dB(0) [0dB(23)] -> 65535 to 0) */
-	state->volume = ((long)state->vol_l + 1) * 65535 / 31;
+	v4l2_ctrl_handler_init(&state->hdl, 2);
+	state->volume = v4l2_ctrl_new_std(&state->hdl, &wm8739_ctrl_ops,
+			V4L2_CID_AUDIO_VOLUME, 0, 65535, 65535 / 100, 50736);
+	state->mute = v4l2_ctrl_new_std(&state->hdl, &wm8739_ctrl_ops,
+			V4L2_CID_AUDIO_MUTE, 0, 1, 1, 0);
+	state->balance = v4l2_ctrl_new_std(&state->hdl, &wm8739_ctrl_ops,
+			V4L2_CID_AUDIO_BALANCE, 0, 65535, 65535 / 100, 32768);
+	sd->ctrl_handler = &state->hdl;
+	if (state->hdl.error) {
+		int err = state->hdl.error;
+
+		v4l2_ctrl_handler_free(&state->hdl);
+		kfree(state);
+		return err;
+	}
+	v4l2_ctrl_cluster(3, &state->volume);
+
 	state->clock_freq = 48000;
 
 	/* Initialize wm8739 */
@@ -317,15 +257,17 @@ static int wm8739_probe(struct i2c_client *client,
 	/* activate */
 	wm8739_write(sd, R9, 0x001);
 	/* set volume/mute */
-	wm8739_set_audio(sd);
+	v4l2_ctrl_handler_setup(&state->hdl);
 	return 0;
 }
 
 static int wm8739_remove(struct i2c_client *client)
 {
 	struct v4l2_subdev *sd = i2c_get_clientdata(client);
+	struct wm8739_state *state = to_state(sd);
 
 	v4l2_device_unregister_subdev(sd);
+	v4l2_ctrl_handler_free(&state->hdl);
 	kfree(to_state(sd));
 	return 0;
 }
-- 
1.6.4.2

