Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:3889 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754613Ab0DZHeI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 26 Apr 2010 03:34:08 -0400
Message-Id: <88ba10bf9f01b74411b49bf80782534271c53488.1272267137.git.hverkuil@xs4all.nl>
In-Reply-To: <cover.1272267136.git.hverkuil@xs4all.nl>
References: <cover.1272267136.git.hverkuil@xs4all.nl>
From: Hans Verkuil <hverkuil@xs4all.nl>
Date: Mon, 26 Apr 2010 09:33:56 +0200
Subject: [PATCH 09/15] [RFC] cx25840: convert to the new control framework
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
---
 drivers/media/video/cx25840/cx25840-audio.c |  144 +++-------------------
 drivers/media/video/cx25840/cx25840-core.c  |  178 ++++++++++-----------------
 drivers/media/video/cx25840/cx25840-core.h  |   15 ++-
 3 files changed, 91 insertions(+), 246 deletions(-)

diff --git a/drivers/media/video/cx25840/cx25840-audio.c b/drivers/media/video/cx25840/cx25840-audio.c
index 45608d5..6faad34 100644
--- a/drivers/media/video/cx25840/cx25840-audio.c
+++ b/drivers/media/video/cx25840/cx25840-audio.c
@@ -474,33 +474,10 @@ void cx25840_audio_set_path(struct i2c_client *client)
 		cx25840_and_or(client, 0x803, ~0x10, 0x10);
 }
 
-static int get_volume(struct i2c_client *client)
-{
-	struct cx25840_state *state = to_state(i2c_get_clientdata(client));
-	int vol;
-
-	if (state->unmute_volume >= 0)
-		return state->unmute_volume;
-
-	/* Volume runs +18dB to -96dB in 1/2dB steps
-	 * change to fit the msp3400 -114dB to +12dB range */
-
-	/* check PATH1_VOLUME */
-	vol = 228 - cx25840_read(client, 0x8d4);
-	vol = (vol / 2) + 23;
-	return vol << 9;
-}
-
 static void set_volume(struct i2c_client *client, int volume)
 {
-	struct cx25840_state *state = to_state(i2c_get_clientdata(client));
 	int vol;
 
-	if (state->unmute_volume >= 0) {
-		state->unmute_volume = volume;
-		return;
-	}
-
 	/* Convert the volume to msp3400 values (0-127) */
 	vol = volume >> 9;
 
@@ -517,52 +494,6 @@ static void set_volume(struct i2c_client *client, int volume)
 	cx25840_write(client, 0x8d4, 228 - (vol * 2));
 }
 
-static int get_bass(struct i2c_client *client)
-{
-	/* bass is 49 steps +12dB to -12dB */
-
-	/* check PATH1_EQ_BASS_VOL */
-	int bass = cx25840_read(client, 0x8d9) & 0x3f;
-	bass = (((48 - bass) * 0xffff) + 47) / 48;
-	return bass;
-}
-
-static void set_bass(struct i2c_client *client, int bass)
-{
-	/* PATH1_EQ_BASS_VOL */
-	cx25840_and_or(client, 0x8d9, ~0x3f, 48 - (bass * 48 / 0xffff));
-}
-
-static int get_treble(struct i2c_client *client)
-{
-	/* treble is 49 steps +12dB to -12dB */
-
-	/* check PATH1_EQ_TREBLE_VOL */
-	int treble = cx25840_read(client, 0x8db) & 0x3f;
-	treble = (((48 - treble) * 0xffff) + 47) / 48;
-	return treble;
-}
-
-static void set_treble(struct i2c_client *client, int treble)
-{
-	/* PATH1_EQ_TREBLE_VOL */
-	cx25840_and_or(client, 0x8db, ~0x3f, 48 - (treble * 48 / 0xffff));
-}
-
-static int get_balance(struct i2c_client *client)
-{
-	/* balance is 7 bit, 0 to -96dB */
-
-	/* check PATH1_BAL_LEVEL */
-	int balance = cx25840_read(client, 0x8d5) & 0x7f;
-	/* check PATH1_BAL_LEFT */
-	if ((cx25840_read(client, 0x8d5) & 0x80) == 0)
-		balance = 0x80 - balance;
-	else
-		balance = 0x80 + balance;
-	return balance << 8;
-}
-
 static void set_balance(struct i2c_client *client, int balance)
 {
 	int bal = balance >> 8;
@@ -579,31 +510,6 @@ static void set_balance(struct i2c_client *client, int balance)
 	}
 }
 
-static int get_mute(struct i2c_client *client)
-{
-	struct cx25840_state *state = to_state(i2c_get_clientdata(client));
-
-	return state->unmute_volume >= 0;
-}
-
-static void set_mute(struct i2c_client *client, int mute)
-{
-	struct cx25840_state *state = to_state(i2c_get_clientdata(client));
-
-	if (mute && state->unmute_volume == -1) {
-		int vol = get_volume(client);
-
-		set_volume(client, 0);
-		state->unmute_volume = vol;
-	}
-	else if (!mute && state->unmute_volume != -1) {
-		int vol = state->unmute_volume;
-
-		state->unmute_volume = -1;
-		set_volume(client, vol);
-	}
-}
-
 int cx25840_s_clock_freq(struct v4l2_subdev *sd, u32 freq)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
@@ -624,25 +530,31 @@ int cx25840_s_clock_freq(struct v4l2_subdev *sd, u32 freq)
 	return retval;
 }
 
-int cx25840_audio_g_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl)
+static int cx25840_audio_s_ctrl(struct v4l2_ctrl *ctrl)
 {
+	struct v4l2_subdev *sd = to_sd(ctrl);
+	struct cx25840_state *state = to_state(sd);
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
 
 	switch (ctrl->id) {
 	case V4L2_CID_AUDIO_VOLUME:
-		ctrl->value = get_volume(client);
+		if (state->mute->val)
+			set_volume(client, 0);
+		else
+			set_volume(client, state->volume->val);
 		break;
 	case V4L2_CID_AUDIO_BASS:
-		ctrl->value = get_bass(client);
+		/* PATH1_EQ_BASS_VOL */
+		cx25840_and_or(client, 0x8d9, ~0x3f,
+					48 - (ctrl->val * 48 / 0xffff));
 		break;
 	case V4L2_CID_AUDIO_TREBLE:
-		ctrl->value = get_treble(client);
+		/* PATH1_EQ_TREBLE_VOL */
+		cx25840_and_or(client, 0x8db, ~0x3f,
+					48 - (ctrl->val * 48 / 0xffff));
 		break;
 	case V4L2_CID_AUDIO_BALANCE:
-		ctrl->value = get_balance(client);
-		break;
-	case V4L2_CID_AUDIO_MUTE:
-		ctrl->value = get_mute(client);
+		set_balance(client, ctrl->val);
 		break;
 	default:
 		return -EINVAL;
@@ -650,28 +562,6 @@ int cx25840_audio_g_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl)
 	return 0;
 }
 
-int cx25840_audio_s_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl)
-{
-	struct i2c_client *client = v4l2_get_subdevdata(sd);
-
-	switch (ctrl->id) {
-	case V4L2_CID_AUDIO_VOLUME:
-		set_volume(client, ctrl->value);
-		break;
-	case V4L2_CID_AUDIO_BASS:
-		set_bass(client, ctrl->value);
-		break;
-	case V4L2_CID_AUDIO_TREBLE:
-		set_treble(client, ctrl->value);
-		break;
-	case V4L2_CID_AUDIO_BALANCE:
-		set_balance(client, ctrl->value);
-		break;
-	case V4L2_CID_AUDIO_MUTE:
-		set_mute(client, ctrl->value);
-		break;
-	default:
-		return -EINVAL;
-	}
-	return 0;
-}
+const struct v4l2_ctrl_ops cx25840_audio_ctrl_ops = {
+	.s_ctrl = cx25840_audio_s_ctrl,
+};
diff --git a/drivers/media/video/cx25840/cx25840-core.c b/drivers/media/video/cx25840/cx25840-core.c
index b8aa5d2..7caa4dc 100644
--- a/drivers/media/video/cx25840/cx25840-core.c
+++ b/drivers/media/video/cx25840/cx25840-core.c
@@ -909,94 +909,29 @@ static int set_v4lstd(struct i2c_client *client)
 
 /* ----------------------------------------------------------------------- */
 
-static int cx25840_s_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl)
+static int cx25840_s_ctrl(struct v4l2_ctrl *ctrl)
 {
-	struct cx25840_state *state = to_state(sd);
+	struct v4l2_subdev *sd = to_sd(ctrl);
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
 
 	switch (ctrl->id) {
 	case V4L2_CID_BRIGHTNESS:
-		if (ctrl->value < 0 || ctrl->value > 255) {
-			v4l_err(client, "invalid brightness setting %d\n",
-				    ctrl->value);
-			return -ERANGE;
-		}
-
-		cx25840_write(client, 0x414, ctrl->value - 128);
+		cx25840_write(client, 0x414, ctrl->val - 128);
 		break;
 
 	case V4L2_CID_CONTRAST:
-		if (ctrl->value < 0 || ctrl->value > 127) {
-			v4l_err(client, "invalid contrast setting %d\n",
-				    ctrl->value);
-			return -ERANGE;
-		}
-
-		cx25840_write(client, 0x415, ctrl->value << 1);
+		cx25840_write(client, 0x415, ctrl->val << 1);
 		break;
 
 	case V4L2_CID_SATURATION:
-		if (ctrl->value < 0 || ctrl->value > 127) {
-			v4l_err(client, "invalid saturation setting %d\n",
-				    ctrl->value);
-			return -ERANGE;
-		}
-
-		cx25840_write(client, 0x420, ctrl->value << 1);
-		cx25840_write(client, 0x421, ctrl->value << 1);
+		cx25840_write(client, 0x420, ctrl->val << 1);
+		cx25840_write(client, 0x421, ctrl->val << 1);
 		break;
 
 	case V4L2_CID_HUE:
-		if (ctrl->value < -128 || ctrl->value > 127) {
-			v4l_err(client, "invalid hue setting %d\n", ctrl->value);
-			return -ERANGE;
-		}
-
-		cx25840_write(client, 0x422, ctrl->value);
+		cx25840_write(client, 0x422, ctrl->val);
 		break;
 
-	case V4L2_CID_AUDIO_VOLUME:
-	case V4L2_CID_AUDIO_BASS:
-	case V4L2_CID_AUDIO_TREBLE:
-	case V4L2_CID_AUDIO_BALANCE:
-	case V4L2_CID_AUDIO_MUTE:
-		if (is_cx2583x(state))
-			return -EINVAL;
-		return cx25840_audio_s_ctrl(sd, ctrl);
-
-	default:
-		return -EINVAL;
-	}
-
-	return 0;
-}
-
-static int cx25840_g_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl)
-{
-	struct cx25840_state *state = to_state(sd);
-	struct i2c_client *client = v4l2_get_subdevdata(sd);
-
-	switch (ctrl->id) {
-	case V4L2_CID_BRIGHTNESS:
-		ctrl->value = (s8)cx25840_read(client, 0x414) + 128;
-		break;
-	case V4L2_CID_CONTRAST:
-		ctrl->value = cx25840_read(client, 0x415) >> 1;
-		break;
-	case V4L2_CID_SATURATION:
-		ctrl->value = cx25840_read(client, 0x420) >> 1;
-		break;
-	case V4L2_CID_HUE:
-		ctrl->value = (s8)cx25840_read(client, 0x422);
-		break;
-	case V4L2_CID_AUDIO_VOLUME:
-	case V4L2_CID_AUDIO_BASS:
-	case V4L2_CID_AUDIO_TREBLE:
-	case V4L2_CID_AUDIO_BALANCE:
-	case V4L2_CID_AUDIO_MUTE:
-		if (is_cx2583x(state))
-			return -EINVAL;
-		return cx25840_audio_g_ctrl(sd, ctrl);
 	default:
 		return -EINVAL;
 	}
@@ -1177,8 +1112,6 @@ static void log_audio_status(struct i2c_client *client)
 	default: p = "not defined";
 	}
 	v4l_info(client, "Detected audio standard:   %s\n", p);
-	v4l_info(client, "Audio muted:               %s\n",
-		    (state->unmute_volume >= 0) ? "yes" : "no");
 	v4l_info(client, "Audio microcontroller:     %s\n",
 		    (download_ctl & 0x10) ?
 				((mute_ctl & 0x2) ? "detecting" : "running") : "stopped");
@@ -1395,40 +1328,6 @@ static int cx25840_s_stream(struct v4l2_subdev *sd, int enable)
 	return 0;
 }
 
-static int cx25840_queryctrl(struct v4l2_subdev *sd, struct v4l2_queryctrl *qc)
-{
-	struct cx25840_state *state = to_state(sd);
-
-	switch (qc->id) {
-	case V4L2_CID_BRIGHTNESS:
-		return v4l2_ctrl_query_fill(qc, 0, 255, 1, 128);
-	case V4L2_CID_CONTRAST:
-	case V4L2_CID_SATURATION:
-		return v4l2_ctrl_query_fill(qc, 0, 127, 1, 64);
-	case V4L2_CID_HUE:
-		return v4l2_ctrl_query_fill(qc, -128, 127, 1, 0);
-	default:
-		break;
-	}
-	if (is_cx2583x(state))
-		return -EINVAL;
-
-	switch (qc->id) {
-	case V4L2_CID_AUDIO_VOLUME:
-		return v4l2_ctrl_query_fill(qc, 0, 65535,
-				65535 / 100, state->default_volume);
-	case V4L2_CID_AUDIO_MUTE:
-		return v4l2_ctrl_query_fill(qc, 0, 1, 1, 0);
-	case V4L2_CID_AUDIO_BALANCE:
-	case V4L2_CID_AUDIO_BASS:
-	case V4L2_CID_AUDIO_TREBLE:
-		return v4l2_ctrl_query_fill(qc, 0, 65535, 65535 / 100, 32768);
-	default:
-		return -EINVAL;
-	}
-	return -EINVAL;
-}
-
 static int cx25840_s_std(struct v4l2_subdev *sd, v4l2_std_id std)
 {
 	struct cx25840_state *state = to_state(sd);
@@ -1590,6 +1489,7 @@ static int cx25840_log_status(struct v4l2_subdev *sd)
 	log_video_status(client);
 	if (!is_cx2583x(state))
 		log_audio_status(client);
+	v4l2_ctrl_handler_log_status(&state->hdl, sd->name);
 	return 0;
 }
 
@@ -1609,13 +1509,21 @@ static int cx25840_s_config(struct v4l2_subdev *sd, int irq, void *platform_data
 
 /* ----------------------------------------------------------------------- */
 
+static const struct v4l2_ctrl_ops cx25840_ctrl_ops = {
+	.s_ctrl = cx25840_s_ctrl,
+};
+
 static const struct v4l2_subdev_core_ops cx25840_core_ops = {
 	.log_status = cx25840_log_status,
 	.s_config = cx25840_s_config,
 	.g_chip_ident = cx25840_g_chip_ident,
-	.g_ctrl = cx25840_g_ctrl,
-	.s_ctrl = cx25840_s_ctrl,
-	.queryctrl = cx25840_queryctrl,
+	.g_ctrl = v4l2_sd_g_ctrl,
+	.s_ctrl = v4l2_sd_s_ctrl,
+	.s_ext_ctrls = v4l2_sd_s_ext_ctrls,
+	.try_ext_ctrls = v4l2_sd_try_ext_ctrls,
+	.g_ext_ctrls = v4l2_sd_g_ext_ctrls,
+	.queryctrl = v4l2_sd_queryctrl,
+	.querymenu = v4l2_sd_querymenu,
 	.s_std = cx25840_s_std,
 	.reset = cx25840_reset,
 	.load_fw = cx25840_load_fw,
@@ -1698,6 +1606,7 @@ static int cx25840_probe(struct i2c_client *client,
 {
 	struct cx25840_state *state;
 	struct v4l2_subdev *sd;
+	int default_volume;
 	u32 id = V4L2_IDENT_NONE;
 	u16 device_id;
 
@@ -1741,6 +1650,7 @@ static int cx25840_probe(struct i2c_client *client,
 
 	sd = &state->sd;
 	v4l2_i2c_subdev_init(sd, client, &cx25840_ops);
+
 	switch (id) {
 	case V4L2_IDENT_CX23885_AV:
 		v4l_info(client, "cx23885 A/V decoder found @ 0x%x (%s)\n",
@@ -1785,12 +1695,48 @@ static int cx25840_probe(struct i2c_client *client,
 	state->audclk_freq = 48000;
 	state->pvr150_workaround = 0;
 	state->audmode = V4L2_TUNER_MODE_LANG1;
-	state->unmute_volume = -1;
-	state->default_volume = 228 - cx25840_read(client, 0x8d4);
-	state->default_volume = ((state->default_volume / 2) + 23) << 9;
 	state->vbi_line_offset = 8;
 	state->id = id;
 	state->rev = device_id;
+	v4l2_ctrl_handler_init(&state->hdl, 9);
+	v4l2_ctrl_new_std(&state->hdl, &cx25840_ctrl_ops,
+			V4L2_CID_BRIGHTNESS, 0, 255, 1, 128);
+	v4l2_ctrl_new_std(&state->hdl, &cx25840_ctrl_ops,
+			V4L2_CID_CONTRAST, 0, 127, 1, 64);
+	v4l2_ctrl_new_std(&state->hdl, &cx25840_ctrl_ops,
+			V4L2_CID_SATURATION, 0, 127, 1, 64);
+	v4l2_ctrl_new_std(&state->hdl, &cx25840_ctrl_ops,
+			V4L2_CID_HUE, -128, 127, 1, 0);
+	if (!is_cx2583x(state)) {
+		default_volume = 228 - cx25840_read(client, 0x8d4);
+		default_volume = ((default_volume / 2) + 23) << 9;
+
+		state->volume = v4l2_ctrl_new_std(&state->hdl,
+			&cx25840_audio_ctrl_ops, V4L2_CID_AUDIO_VOLUME,
+			0, 65335, 65535 / 100, default_volume);
+		state->mute = v4l2_ctrl_new_std(&state->hdl,
+			&cx25840_audio_ctrl_ops, V4L2_CID_AUDIO_MUTE,
+			0, 1, 1, 0);
+		v4l2_ctrl_new_std(&state->hdl, &cx25840_audio_ctrl_ops,
+			V4L2_CID_AUDIO_BALANCE,
+			0, 65535, 65535 / 100, 32768);
+		v4l2_ctrl_new_std(&state->hdl, &cx25840_audio_ctrl_ops,
+			V4L2_CID_AUDIO_BASS,
+			0, 65535, 65535 / 100, 32768);
+		v4l2_ctrl_new_std(&state->hdl, &cx25840_audio_ctrl_ops,
+			V4L2_CID_AUDIO_TREBLE,
+			0, 65535, 65535 / 100, 32768);
+	}
+	sd->ctrl_handler = &state->hdl;
+	if (state->hdl.error) {
+		int err = state->hdl.error;
+
+		v4l2_ctrl_handler_free(&state->hdl);
+		kfree(state);
+		return err;
+	}
+	v4l2_ctrl_cluster(2, &state->volume);
+	v4l2_ctrl_handler_setup(&state->hdl);
 
 	return 0;
 }
@@ -1798,9 +1744,11 @@ static int cx25840_probe(struct i2c_client *client,
 static int cx25840_remove(struct i2c_client *client)
 {
 	struct v4l2_subdev *sd = i2c_get_clientdata(client);
+	struct cx25840_state *state = to_state(sd);
 
 	v4l2_device_unregister_subdev(sd);
-	kfree(to_state(sd));
+	v4l2_ctrl_handler_free(&state->hdl);
+	kfree(state);
 	return 0;
 }
 
diff --git a/drivers/media/video/cx25840/cx25840-core.h b/drivers/media/video/cx25840/cx25840-core.h
index 50b7887..cc0b6dd 100644
--- a/drivers/media/video/cx25840/cx25840-core.h
+++ b/drivers/media/video/cx25840/cx25840-core.h
@@ -24,11 +24,15 @@
 #include <linux/videodev2.h>
 #include <media/v4l2-device.h>
 #include <media/v4l2-chip-ident.h>
+#include <media/v4l2-ctrls.h>
 #include <linux/i2c.h>
 
 struct cx25840_state {
 	struct i2c_client *c;
 	struct v4l2_subdev sd;
+	struct v4l2_ctrl_handler hdl;
+	struct v4l2_ctrl *volume;
+	struct v4l2_ctrl *mute;
 	int pvr150_workaround;
 	int radio;
 	v4l2_std_id std;
@@ -36,8 +40,6 @@ struct cx25840_state {
 	enum cx25840_audio_input aud_input;
 	u32 audclk_freq;
 	int audmode;
-	int unmute_volume; /* -1 if not muted */
-	int default_volume;
 	int vbi_line_offset;
 	u32 id;
 	u32 rev;
@@ -51,6 +53,11 @@ static inline struct cx25840_state *to_state(struct v4l2_subdev *sd)
 	return container_of(sd, struct cx25840_state, sd);
 }
 
+static inline struct v4l2_subdev *to_sd(struct v4l2_ctrl *ctrl)
+{
+	return &container_of(ctrl->handler, struct cx25840_state, hdl)->sd;
+}
+
 static inline bool is_cx2583x(struct cx25840_state *state)
 {
 	return state->id == V4L2_IDENT_CX25836 ||
@@ -86,8 +93,8 @@ int cx25840_loadfw(struct i2c_client *client);
 /* cx25850-audio.c                                                         */
 void cx25840_audio_set_path(struct i2c_client *client);
 int cx25840_s_clock_freq(struct v4l2_subdev *sd, u32 freq);
-int cx25840_audio_g_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl);
-int cx25840_audio_s_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl);
+
+extern const struct v4l2_ctrl_ops cx25840_audio_ctrl_ops;
 
 /* ----------------------------------------------------------------------- */
 /* cx25850-vbi.c                                                           */
-- 
1.6.4.2

