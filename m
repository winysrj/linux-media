Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr2.xs4all.nl ([194.109.24.22]:4944 "EHLO
	smtp-vbr2.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751219Ab0EPNTx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 16 May 2010 09:19:53 -0400
Message-Id: <4f389779af1144a6b39a8b393c6cbe6302b3c389.1274015085.git.hverkuil@xs4all.nl>
In-Reply-To: <cover.1274015084.git.hverkuil@xs4all.nl>
References: <cover.1274015084.git.hverkuil@xs4all.nl>
From: Hans Verkuil <hverkuil@xs4all.nl>
Date: Sun, 16 May 2010 15:21:21 +0200
Subject: [PATCH 07/15] [RFCv2] saa717x: convert to the new control framework
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
---
 drivers/media/video/saa717x.c |  323 ++++++++++------------------------------
 1 files changed, 81 insertions(+), 242 deletions(-)

diff --git a/drivers/media/video/saa717x.c b/drivers/media/video/saa717x.c
index 6818df5..d551411 100644
--- a/drivers/media/video/saa717x.c
+++ b/drivers/media/video/saa717x.c
@@ -37,6 +37,7 @@
 #include <linux/videodev2.h>
 #include <linux/i2c.h>
 #include <media/v4l2-device.h>
+#include <media/v4l2-ctrls.h>
 #include <media/v4l2-i2c-drv.h>
 
 MODULE_DESCRIPTION("Philips SAA717x audio/video decoder driver");
@@ -54,14 +55,11 @@ MODULE_PARM_DESC(debug, "Debug level (0-1)");
 
 struct saa717x_state {
 	struct v4l2_subdev sd;
+	struct v4l2_ctrl_handler hdl;
 	v4l2_std_id std;
 	int input;
 	int enable;
 	int radio;
-	int bright;
-	int contrast;
-	int hue;
-	int sat;
 	int playback;
 	int audio;
 	int tuner_audio_mode;
@@ -80,6 +78,11 @@ static inline struct saa717x_state *to_state(struct v4l2_subdev *sd)
 	return container_of(sd, struct saa717x_state, sd);
 }
 
+static inline struct v4l2_subdev *to_sd(struct v4l2_ctrl *ctrl)
+{
+	return &container_of(ctrl->handler, struct saa717x_state, hdl)->sd;
+}
+
 /* ----------------------------------------------------------------------- */
 
 /* for audio mode */
@@ -773,29 +776,6 @@ static void set_audio_mode(struct v4l2_subdev *sd, int audio_mode)
 	saa717x_write(sd, 0x470, reg_set_audio_template[audio_mode][1]);
 }
 
-/* write regs to video output level (bright,contrast,hue,sat) */
-static void set_video_output_level_regs(struct v4l2_subdev *sd,
-		struct saa717x_state *decoder)
-{
-	/* brightness ffh (bright) - 80h (ITU level) - 00h (dark) */
-	saa717x_write(sd, 0x10a, decoder->bright);
-
-	/* contrast 7fh (max: 1.984) - 44h (ITU) - 40h (1.0) -
-	   0h (luminance off) 40: i2c dump
-	   c0h (-1.0 inverse chrominance)
-	   80h (-2.0 inverse chrominance) */
-	saa717x_write(sd, 0x10b, decoder->contrast);
-
-	/* saturation? 7fh(max)-40h(ITU)-0h(color off)
-	   c0h (-1.0 inverse chrominance)
-	   80h (-2.0 inverse chrominance) */
-	saa717x_write(sd, 0x10c, decoder->sat);
-
-	/* color hue (phase) control
-	   7fh (+178.6) - 0h (0 normal) - 80h (-180.0) */
-	saa717x_write(sd, 0x10d, decoder->hue);
-}
-
 /* write regs to set audio volume, bass and treble */
 static int set_audio_regs(struct v4l2_subdev *sd,
 		struct saa717x_state *decoder)
@@ -828,9 +808,9 @@ static int set_audio_regs(struct v4l2_subdev *sd,
 
 	saa717x_write(sd, 0x480, val);
 
-	/* bass and treble; go to another function */
 	/* set bass and treble */
-	val = decoder->audio_main_bass | (decoder->audio_main_treble << 8);
+	val = decoder->audio_main_bass & 0x1f;
+	val |= (decoder->audio_main_treble & 0x1f) << 5;
 	saa717x_write(sd, 0x488, val);
 	return 0;
 }
@@ -892,218 +872,55 @@ static void set_v_scale(struct v4l2_subdev *sd, int task, int yscale)
 	saa717x_write(sd, 0x71 + task_shift, yscale >> 8);
 }
 
-static int saa717x_s_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl)
-{
-	struct saa717x_state *state = to_state(sd);
-
-	switch (ctrl->id) {
-	case V4L2_CID_BRIGHTNESS:
-		if (ctrl->value < 0 || ctrl->value > 255) {
-			v4l2_err(sd, "invalid brightness setting %d\n", ctrl->value);
-			return -ERANGE;
-		}
-
-		state->bright = ctrl->value;
-		v4l2_dbg(1, debug, sd, "bright:%d\n", state->bright);
-		saa717x_write(sd, 0x10a, state->bright);
-		break;
-
-	case V4L2_CID_CONTRAST:
-		if (ctrl->value < 0 || ctrl->value > 127) {
-			v4l2_err(sd, "invalid contrast setting %d\n", ctrl->value);
-			return -ERANGE;
-		}
-
-		state->contrast = ctrl->value;
-		v4l2_dbg(1, debug, sd, "contrast:%d\n", state->contrast);
-		saa717x_write(sd, 0x10b, state->contrast);
-		break;
-
-	case V4L2_CID_SATURATION:
-		if (ctrl->value < 0 || ctrl->value > 127) {
-			v4l2_err(sd, "invalid saturation setting %d\n", ctrl->value);
-			return -ERANGE;
-		}
-
-		state->sat = ctrl->value;
-		v4l2_dbg(1, debug, sd, "sat:%d\n", state->sat);
-		saa717x_write(sd, 0x10c, state->sat);
-		break;
-
-	case V4L2_CID_HUE:
-		if (ctrl->value < -128 || ctrl->value > 127) {
-			v4l2_err(sd, "invalid hue setting %d\n", ctrl->value);
-			return -ERANGE;
-		}
-
-		state->hue = ctrl->value;
-		v4l2_dbg(1, debug, sd, "hue:%d\n", state->hue);
-		saa717x_write(sd, 0x10d, state->hue);
-		break;
-
-	case V4L2_CID_AUDIO_MUTE:
-		state->audio_main_mute = ctrl->value;
-		set_audio_regs(sd, state);
-		break;
-
-	case V4L2_CID_AUDIO_VOLUME:
-		state->audio_main_volume = ctrl->value;
-		set_audio_regs(sd, state);
-		break;
-
-	case V4L2_CID_AUDIO_BALANCE:
-		state->audio_main_balance = ctrl->value;
-		set_audio_regs(sd, state);
-		break;
-
-	case V4L2_CID_AUDIO_TREBLE:
-		state->audio_main_treble = ctrl->value;
-		set_audio_regs(sd, state);
-		break;
-
-	case V4L2_CID_AUDIO_BASS:
-		state->audio_main_bass = ctrl->value;
-		set_audio_regs(sd, state);
-		break;
-
-	default:
-		return -EINVAL;
-	}
-
-	return 0;
-}
-
-static int saa717x_g_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl)
+static int saa717x_s_ctrl(struct v4l2_ctrl *ctrl)
 {
+	struct v4l2_subdev *sd = to_sd(ctrl);
 	struct saa717x_state *state = to_state(sd);
 
 	switch (ctrl->id) {
 	case V4L2_CID_BRIGHTNESS:
-		ctrl->value = state->bright;
-		break;
+		saa717x_write(sd, 0x10a, ctrl->val);
+		return 0;
 
 	case V4L2_CID_CONTRAST:
-		ctrl->value = state->contrast;
-		break;
+		saa717x_write(sd, 0x10b, ctrl->val);
+		return 0;
 
 	case V4L2_CID_SATURATION:
-		ctrl->value = state->sat;
-		break;
+		saa717x_write(sd, 0x10c, ctrl->val);
+		return 0;
 
 	case V4L2_CID_HUE:
-		ctrl->value = state->hue;
-		break;
+		saa717x_write(sd, 0x10d, ctrl->val);
+		return 0;
 
 	case V4L2_CID_AUDIO_MUTE:
-		ctrl->value = state->audio_main_mute;
+		state->audio_main_mute = ctrl->val;
 		break;
 
 	case V4L2_CID_AUDIO_VOLUME:
-		ctrl->value = state->audio_main_volume;
+		state->audio_main_volume = ctrl->val;
 		break;
 
 	case V4L2_CID_AUDIO_BALANCE:
-		ctrl->value = state->audio_main_balance;
+		state->audio_main_balance = ctrl->val;
 		break;
 
 	case V4L2_CID_AUDIO_TREBLE:
-		ctrl->value = state->audio_main_treble;
+		state->audio_main_treble = ctrl->val;
 		break;
 
 	case V4L2_CID_AUDIO_BASS:
-		ctrl->value = state->audio_main_bass;
+		state->audio_main_bass = ctrl->val;
 		break;
 
 	default:
-		return -EINVAL;
+		return 0;
 	}
-
+	set_audio_regs(sd, state);
 	return 0;
 }
 
-static struct v4l2_queryctrl saa717x_qctrl[] = {
-	{
-		.id            = V4L2_CID_BRIGHTNESS,
-		.type          = V4L2_CTRL_TYPE_INTEGER,
-		.name          = "Brightness",
-		.minimum       = 0,
-		.maximum       = 255,
-		.step          = 1,
-		.default_value = 128,
-		.flags         = 0,
-	}, {
-		.id            = V4L2_CID_CONTRAST,
-		.type          = V4L2_CTRL_TYPE_INTEGER,
-		.name          = "Contrast",
-		.minimum       = 0,
-		.maximum       = 255,
-		.step          = 1,
-		.default_value = 64,
-		.flags         = 0,
-	}, {
-		.id            = V4L2_CID_SATURATION,
-		.type          = V4L2_CTRL_TYPE_INTEGER,
-		.name          = "Saturation",
-		.minimum       = 0,
-		.maximum       = 255,
-		.step          = 1,
-		.default_value = 64,
-		.flags         = 0,
-	}, {
-		.id            = V4L2_CID_HUE,
-		.type          = V4L2_CTRL_TYPE_INTEGER,
-		.name          = "Hue",
-		.minimum       = -128,
-		.maximum       = 127,
-		.step          = 1,
-		.default_value = 0,
-		.flags 	       = 0,
-	}, {
-		.id            = V4L2_CID_AUDIO_VOLUME,
-		.type          = V4L2_CTRL_TYPE_INTEGER,
-		.name          = "Volume",
-		.minimum       = 0,
-		.maximum       = 65535,
-		.step          = 65535 / 100,
-		.default_value = 58880,
-		.flags         = 0,
-	}, {
-		.id            = V4L2_CID_AUDIO_BALANCE,
-		.type          = V4L2_CTRL_TYPE_INTEGER,
-		.name          = "Balance",
-		.minimum       = 0,
-		.maximum       = 65535,
-		.step          = 65535 / 100,
-		.default_value = 32768,
-		.flags         = 0,
-	}, {
-		.id            = V4L2_CID_AUDIO_MUTE,
-		.type          = V4L2_CTRL_TYPE_BOOLEAN,
-		.name          = "Mute",
-		.minimum       = 0,
-		.maximum       = 1,
-		.step          = 1,
-		.default_value = 1,
-		.flags         = 0,
-	}, {
-		.id            = V4L2_CID_AUDIO_BASS,
-		.type          = V4L2_CTRL_TYPE_INTEGER,
-		.name          = "Bass",
-		.minimum       = 0,
-		.maximum       = 65535,
-		.step          = 65535 / 100,
-		.default_value = 32768,
-	}, {
-		.id            = V4L2_CID_AUDIO_TREBLE,
-		.type          = V4L2_CTRL_TYPE_INTEGER,
-		.name          = "Treble",
-		.minimum       = 0,
-		.maximum       = 65535,
-		.step          = 65535 / 100,
-		.default_value = 32768,
-	},
-};
-
 static int saa717x_s_video_routing(struct v4l2_subdev *sd,
 				   u32 input, u32 output, u32 config)
 {
@@ -1157,18 +974,6 @@ static int saa717x_s_video_routing(struct v4l2_subdev *sd,
 	return 0;
 }
 
-static int saa717x_queryctrl(struct v4l2_subdev *sd, struct v4l2_queryctrl *qc)
-{
-	int i;
-
-	for (i = 0; i < ARRAY_SIZE(saa717x_qctrl); i++)
-		if (qc->id && qc->id == saa717x_qctrl[i].id) {
-			memcpy(qc, &saa717x_qctrl[i], sizeof(*qc));
-			return 0;
-		}
-	return -EINVAL;
-}
-
 #ifdef CONFIG_VIDEO_ADV_DEBUG
 static int saa717x_g_register(struct v4l2_subdev *sd, struct v4l2_dbg_register *reg)
 {
@@ -1381,17 +1186,34 @@ static int saa717x_g_tuner(struct v4l2_subdev *sd, struct v4l2_tuner *vt)
 	return 0;
 }
 
+static int saa717x_log_status(struct v4l2_subdev *sd)
+{
+	struct saa717x_state *state = to_state(sd);
+
+	v4l2_ctrl_handler_log_status(&state->hdl, sd->name);
+	return 0;
+}
+
 /* ----------------------------------------------------------------------- */
 
+static const struct v4l2_ctrl_ops saa717x_ctrl_ops = {
+	.s_ctrl = saa717x_s_ctrl,
+};
+
 static const struct v4l2_subdev_core_ops saa717x_core_ops = {
 #ifdef CONFIG_VIDEO_ADV_DEBUG
 	.g_register = saa717x_g_register,
 	.s_register = saa717x_s_register,
 #endif
-	.queryctrl = saa717x_queryctrl,
-	.g_ctrl = saa717x_g_ctrl,
-	.s_ctrl = saa717x_s_ctrl,
 	.s_std = saa717x_s_std,
+	.g_ext_ctrls = v4l2_subdev_g_ext_ctrls,
+	.try_ext_ctrls = v4l2_subdev_try_ext_ctrls,
+	.s_ext_ctrls = v4l2_subdev_s_ext_ctrls,
+	.g_ctrl = v4l2_subdev_g_ctrl,
+	.s_ctrl = v4l2_subdev_s_ctrl,
+	.queryctrl = v4l2_subdev_queryctrl,
+	.querymenu = v4l2_subdev_querymenu,
+	.log_status = saa717x_log_status,
 };
 
 static const struct v4l2_subdev_tuner_ops saa717x_tuner_ops = {
@@ -1427,6 +1249,7 @@ static int saa717x_probe(struct i2c_client *client,
 			 const struct i2c_device_id *did)
 {
 	struct saa717x_state *decoder;
+	struct v4l2_ctrl_handler *hdl;
 	struct v4l2_subdev *sd;
 	u8 id = 0;
 	char *p = "";
@@ -1462,16 +1285,41 @@ static int saa717x_probe(struct i2c_client *client,
 		p = "saa7171";
 	v4l2_info(sd, "%s found @ 0x%x (%s)\n", p,
 			client->addr << 1, client->adapter->name);
+
+	hdl = &decoder->hdl;
+	v4l2_ctrl_handler_init(hdl, 9);
+	/* add in ascending ID order */
+	v4l2_ctrl_new_std(hdl, &saa717x_ctrl_ops,
+			V4L2_CID_BRIGHTNESS, 0, 255, 1, 128);
+	v4l2_ctrl_new_std(hdl, &saa717x_ctrl_ops,
+			V4L2_CID_CONTRAST, 0, 255, 1, 68);
+	v4l2_ctrl_new_std(hdl, &saa717x_ctrl_ops,
+			V4L2_CID_SATURATION, 0, 255, 1, 64);
+	v4l2_ctrl_new_std(hdl, &saa717x_ctrl_ops,
+			V4L2_CID_HUE, -128, 127, 1, 0);
+	v4l2_ctrl_new_std(hdl, &saa717x_ctrl_ops,
+			V4L2_CID_AUDIO_VOLUME, 0, 65535, 65535 / 100, 42000);
+	v4l2_ctrl_new_std(hdl, &saa717x_ctrl_ops,
+			V4L2_CID_AUDIO_BALANCE, 0, 65535, 65535 / 100, 32768);
+	v4l2_ctrl_new_std(hdl, &saa717x_ctrl_ops,
+			V4L2_CID_AUDIO_BASS, -16, 15, 1, 0);
+	v4l2_ctrl_new_std(hdl, &saa717x_ctrl_ops,
+			V4L2_CID_AUDIO_TREBLE, -16, 15, 1, 0);
+	v4l2_ctrl_new_std(hdl, &saa717x_ctrl_ops,
+			V4L2_CID_AUDIO_MUTE, 0, 1, 1, 0);
+	sd->ctrl_handler = hdl;
+	if (hdl->error) {
+		int err = hdl->error;
+
+		v4l2_ctrl_handler_free(hdl);
+		kfree(decoder);
+		return err;
+	}
+
 	decoder->std = V4L2_STD_NTSC;
 	decoder->input = -1;
 	decoder->enable = 1;
 
-	/* tune these parameters */
-	decoder->bright = 0x80;
-	decoder->contrast = 0x44;
-	decoder->sat = 0x40;
-	decoder->hue = 0x00;
-
 	/* FIXME!! */
 	decoder->playback = 0;	/* initially capture mode used */
 	decoder->audio = 1; /* DECODER_AUDIO_48_KHZ */
@@ -1482,23 +1330,13 @@ static int saa717x_probe(struct i2c_client *client,
 	/* set volume, bass and treble */
 	decoder->audio_main_vol_l = 6;
 	decoder->audio_main_vol_r = 6;
-	decoder->audio_main_bass = 0;
-	decoder->audio_main_treble = 0;
-	decoder->audio_main_mute = 0;
-	decoder->audio_main_balance = 32768;
-	/* normalize (24 to -40 (not -84) -> 65535 to 0) */
-	decoder->audio_main_volume =
-		(decoder->audio_main_vol_r + 41) * 65535 / (24 - (-40));
 
 	v4l2_dbg(1, debug, sd, "writing init values\n");
 
 	/* FIXME!! */
 	saa717x_write_regs(sd, reg_init_initialize);
-	set_video_output_level_regs(sd, decoder);
-	/* set bass,treble to 0db 20041101 K.Ohta */
-	decoder->audio_main_bass = 0;
-	decoder->audio_main_treble = 0;
-	set_audio_regs(sd, decoder);
+
+	v4l2_ctrl_handler_setup(hdl);
 
 	set_current_state(TASK_INTERRUPTIBLE);
 	schedule_timeout(2*HZ);
@@ -1510,6 +1348,7 @@ static int saa717x_remove(struct i2c_client *client)
 	struct v4l2_subdev *sd = i2c_get_clientdata(client);
 
 	v4l2_device_unregister_subdev(sd);
+	v4l2_ctrl_handler_free(sd->ctrl_handler);
 	kfree(to_state(sd));
 	return 0;
 }
-- 
1.6.4.2

