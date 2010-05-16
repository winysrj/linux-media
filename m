Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:3778 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752031Ab0EPNTm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 16 May 2010 09:19:42 -0400
Message-Id: <822c021bce240d8f4d4eadfdf8b7b94586ede3cd.1274015085.git.hverkuil@xs4all.nl>
In-Reply-To: <cover.1274015084.git.hverkuil@xs4all.nl>
References: <cover.1274015084.git.hverkuil@xs4all.nl>
From: Hans Verkuil <hverkuil@xs4all.nl>
Date: Sun, 16 May 2010 15:21:14 +0200
Subject: [PATCH 06/15] [RFCv2] msp3400: convert to the new control framework
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
---
 drivers/media/video/msp3400-driver.c   |  248 +++++++++++--------------------
 drivers/media/video/msp3400-driver.h   |   16 ++-
 drivers/media/video/msp3400-kthreads.c |   16 +-
 3 files changed, 108 insertions(+), 172 deletions(-)

diff --git a/drivers/media/video/msp3400-driver.c b/drivers/media/video/msp3400-driver.c
index e9df3cb..0e41213 100644
--- a/drivers/media/video/msp3400-driver.c
+++ b/drivers/media/video/msp3400-driver.c
@@ -283,51 +283,6 @@ void msp_set_scart(struct i2c_client *client, int in, int out)
 		msp_write_dem(client, 0x40, state->i2s_mode);
 }
 
-void msp_set_audio(struct i2c_client *client)
-{
-	struct msp_state *state = to_state(i2c_get_clientdata(client));
-	int bal = 0, bass, treble, loudness;
-	int val = 0;
-	int reallymuted = state->muted | state->scan_in_progress;
-
-	if (!reallymuted)
-		val = (state->volume * 0x7f / 65535) << 8;
-
-	v4l_dbg(1, msp_debug, client, "mute=%s scanning=%s volume=%d\n",
-		state->muted ? "on" : "off",
-		state->scan_in_progress ? "yes" : "no",
-		state->volume);
-
-	msp_write_dsp(client, 0x0000, val);
-	msp_write_dsp(client, 0x0007, reallymuted ? 0x1 : (val | 0x1));
-	if (state->has_scart2_out_volume)
-		msp_write_dsp(client, 0x0040, reallymuted ? 0x1 : (val | 0x1));
-	if (state->has_headphones)
-		msp_write_dsp(client, 0x0006, val);
-	if (!state->has_sound_processing)
-		return;
-
-	if (val)
-		bal = (u8)((state->balance / 256) - 128);
-	bass = ((state->bass - 32768) * 0x60 / 65535) << 8;
-	treble = ((state->treble - 32768) * 0x60 / 65535) << 8;
-	loudness = state->loudness ? ((5 * 4) << 8) : 0;
-
-	v4l_dbg(1, msp_debug, client, "balance=%d bass=%d treble=%d loudness=%d\n",
-		state->balance, state->bass, state->treble, state->loudness);
-
-	msp_write_dsp(client, 0x0001, bal << 8);
-	msp_write_dsp(client, 0x0002, bass);
-	msp_write_dsp(client, 0x0003, treble);
-	msp_write_dsp(client, 0x0004, loudness);
-	if (!state->has_headphones)
-		return;
-	msp_write_dsp(client, 0x0030, bal << 8);
-	msp_write_dsp(client, 0x0031, bass);
-	msp_write_dsp(client, 0x0032, treble);
-	msp_write_dsp(client, 0x0033, loudness);
-}
-
 /* ------------------------------------------------------------------------ */
 
 static void msp_wake_thread(struct i2c_client *client)
@@ -363,98 +318,73 @@ int msp_sleep(struct msp_state *state, int timeout)
 
 /* ------------------------------------------------------------------------ */
 
-static int msp_g_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl)
+static int msp_s_ctrl(struct v4l2_ctrl *ctrl)
 {
-	struct msp_state *state = to_state(sd);
+	struct msp_state *state = ctrl_to_state(ctrl);
+	struct i2c_client *client = v4l2_get_subdevdata(&state->sd);
+	int val = ctrl->val;
 
 	switch (ctrl->id) {
-	case V4L2_CID_AUDIO_VOLUME:
-		ctrl->value = state->volume;
-		break;
-
-	case V4L2_CID_AUDIO_MUTE:
-		ctrl->value = state->muted;
-		break;
-
-	case V4L2_CID_AUDIO_BALANCE:
-		if (!state->has_sound_processing)
-			return -EINVAL;
-		ctrl->value = state->balance;
-		break;
-
-	case V4L2_CID_AUDIO_BASS:
-		if (!state->has_sound_processing)
-			return -EINVAL;
-		ctrl->value = state->bass;
+	case V4L2_CID_AUDIO_VOLUME: {
+		/* audio volume cluster */
+		int reallymuted = state->muted->val | state->scan_in_progress;
+
+		if (!reallymuted)
+			val = (val * 0x7f / 65535) << 8;
+
+		v4l_dbg(1, msp_debug, client, "mute=%s scanning=%s volume=%d\n",
+				state->muted->val ? "on" : "off",
+				state->scan_in_progress ? "yes" : "no",
+				state->volume->val);
+
+		msp_write_dsp(client, 0x0000, val);
+		msp_write_dsp(client, 0x0007, reallymuted ? 0x1 : (val | 0x1));
+		if (state->has_scart2_out_volume)
+			msp_write_dsp(client, 0x0040, reallymuted ? 0x1 : (val | 0x1));
+		if (state->has_headphones)
+			msp_write_dsp(client, 0x0006, val);
 		break;
-
-	case V4L2_CID_AUDIO_TREBLE:
-		if (!state->has_sound_processing)
-			return -EINVAL;
-		ctrl->value = state->treble;
-		break;
-
-	case V4L2_CID_AUDIO_LOUDNESS:
-		if (!state->has_sound_processing)
-			return -EINVAL;
-		ctrl->value = state->loudness;
-		break;
-
-	default:
-		return -EINVAL;
 	}
-	return 0;
-}
-
-static int msp_s_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl)
-{
-	struct msp_state *state = to_state(sd);
-	struct i2c_client *client = v4l2_get_subdevdata(sd);
-
-	switch (ctrl->id) {
-	case V4L2_CID_AUDIO_VOLUME:
-		state->volume = ctrl->value;
-		if (state->volume == 0)
-			state->balance = 32768;
-		break;
-
-	case V4L2_CID_AUDIO_MUTE:
-		if (ctrl->value < 0 || ctrl->value >= 2)
-			return -ERANGE;
-		state->muted = ctrl->value;
-		break;
 
 	case V4L2_CID_AUDIO_BASS:
-		if (!state->has_sound_processing)
-			return -EINVAL;
-		state->bass = ctrl->value;
+		val = ((val - 32768) * 0x60 / 65535) << 8;
+		msp_write_dsp(client, 0x0002, val);
+		if (state->has_headphones)
+			msp_write_dsp(client, 0x0031, val);
 		break;
 
 	case V4L2_CID_AUDIO_TREBLE:
-		if (!state->has_sound_processing)
-			return -EINVAL;
-		state->treble = ctrl->value;
+		val = ((val - 32768) * 0x60 / 65535) << 8;
+		msp_write_dsp(client, 0x0003, val);
+		if (state->has_headphones)
+			msp_write_dsp(client, 0x0032, val);
 		break;
 
 	case V4L2_CID_AUDIO_LOUDNESS:
-		if (!state->has_sound_processing)
-			return -EINVAL;
-		state->loudness = ctrl->value;
+		val = val ? ((5 * 4) << 8) : 0;
+		msp_write_dsp(client, 0x0004, val);
+		if (state->has_headphones)
+			msp_write_dsp(client, 0x0033, val);
 		break;
 
 	case V4L2_CID_AUDIO_BALANCE:
-		if (!state->has_sound_processing)
-			return -EINVAL;
-		state->balance = ctrl->value;
+		val = (u8)((val / 256) - 128);
+		msp_write_dsp(client, 0x0001, val << 8);
+		if (state->has_headphones)
+			msp_write_dsp(client, 0x0030, val << 8);
 		break;
 
 	default:
 		return -EINVAL;
 	}
-	msp_set_audio(client);
 	return 0;
 }
 
+void msp_update_volume(struct msp_state *state)
+{
+	v4l2_ctrl_s_ctrl(state->volume, v4l2_ctrl_g_ctrl(state->volume));
+}
+
 /* --- v4l2 ioctls --- */
 static int msp_s_radio(struct v4l2_subdev *sd)
 {
@@ -472,7 +402,7 @@ static int msp_s_radio(struct v4l2_subdev *sd)
 		msp3400c_set_mode(client, MSP_MODE_FM_RADIO);
 		msp3400c_set_carrier(client, MSP_CARRIER(10.7),
 				MSP_CARRIER(10.7));
-		msp_set_audio(client);
+		msp_update_volume(state);
 		break;
 	case OPMODE_AUTODETECT:
 	case OPMODE_AUTOSELECT:
@@ -592,33 +522,6 @@ static int msp_s_i2s_clock_freq(struct v4l2_subdev *sd, u32 freq)
 	return 0;
 }
 
-static int msp_queryctrl(struct v4l2_subdev *sd, struct v4l2_queryctrl *qc)
-{
-	struct msp_state *state = to_state(sd);
-
-	switch (qc->id) {
-	case V4L2_CID_AUDIO_VOLUME:
-		return v4l2_ctrl_query_fill(qc, 0, 65535, 65535 / 100, 58880);
-	case V4L2_CID_AUDIO_MUTE:
-		return v4l2_ctrl_query_fill(qc, 0, 1, 1, 0);
-	default:
-		break;
-	}
-	if (!state->has_sound_processing)
-		return -EINVAL;
-	switch (qc->id) {
-	case V4L2_CID_AUDIO_LOUDNESS:
-		return v4l2_ctrl_query_fill(qc, 0, 1, 1, 0);
-	case V4L2_CID_AUDIO_BALANCE:
-	case V4L2_CID_AUDIO_BASS:
-	case V4L2_CID_AUDIO_TREBLE:
-		return v4l2_ctrl_query_fill(qc, 0, 65535, 65535 / 100, 32768);
-	default:
-		return -EINVAL;
-	}
-	return 0;
-}
-
 static int msp_g_chip_ident(struct v4l2_subdev *sd, struct v4l2_dbg_chip_ident *chip)
 {
 	struct msp_state *state = to_state(sd);
@@ -633,19 +536,14 @@ static int msp_log_status(struct v4l2_subdev *sd)
 	struct msp_state *state = to_state(sd);
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
 	const char *p;
+	char prefix[V4L2_SUBDEV_NAME_SIZE + 20];
 
 	if (state->opmode == OPMODE_AUTOSELECT)
 		msp_detect_stereo(client);
 	v4l_info(client, "%s rev1 = 0x%04x rev2 = 0x%04x\n",
 			client->name, state->rev1, state->rev2);
-	v4l_info(client, "Audio:    volume %d%s\n",
-			state->volume, state->muted ? " (muted)" : "");
-	if (state->has_sound_processing) {
-		v4l_info(client, "Audio:    balance %d bass %d treble %d loudness %s\n",
-				state->balance, state->bass,
-				state->treble,
-				state->loudness ? "on" : "off");
-	}
+	snprintf(prefix, sizeof(prefix), "%s: Audio:    ", sd->name);
+	v4l2_ctrl_handler_log_status(&state->hdl, prefix);
 	switch (state->mode) {
 		case MSP_MODE_AM_DETECT: p = "AM (for carrier detect)"; break;
 		case MSP_MODE_FM_RADIO: p = "FM Radio"; break;
@@ -695,12 +593,20 @@ static int msp_resume(struct i2c_client *client)
 
 /* ----------------------------------------------------------------------- */
 
+static const struct v4l2_ctrl_ops msp_ctrl_ops = {
+	.s_ctrl = msp_s_ctrl,
+};
+
 static const struct v4l2_subdev_core_ops msp_core_ops = {
 	.log_status = msp_log_status,
 	.g_chip_ident = msp_g_chip_ident,
-	.g_ctrl = msp_g_ctrl,
-	.s_ctrl = msp_s_ctrl,
-	.queryctrl = msp_queryctrl,
+	.g_ext_ctrls = v4l2_subdev_g_ext_ctrls,
+	.try_ext_ctrls = v4l2_subdev_try_ext_ctrls,
+	.s_ext_ctrls = v4l2_subdev_s_ext_ctrls,
+	.g_ctrl = v4l2_subdev_g_ctrl,
+	.s_ctrl = v4l2_subdev_s_ctrl,
+	.queryctrl = v4l2_subdev_queryctrl,
+	.querymenu = v4l2_subdev_querymenu,
 	.s_std = msp_s_std,
 };
 
@@ -728,6 +634,7 @@ static int msp_probe(struct i2c_client *client, const struct i2c_device_id *id)
 {
 	struct msp_state *state;
 	struct v4l2_subdev *sd;
+	struct v4l2_ctrl_handler *hdl;
 	int (*thread_func)(void *data) = NULL;
 	int msp_hard;
 	int msp_family;
@@ -752,13 +659,7 @@ static int msp_probe(struct i2c_client *client, const struct i2c_device_id *id)
 
 	state->v4l2_std = V4L2_STD_NTSC;
 	state->audmode = V4L2_TUNER_MODE_STEREO;
-	state->volume = 58880;	/* 0db gain */
-	state->balance = 32768;	/* 0db gain */
-	state->bass = 32768;
-	state->treble = 32768;
-	state->loudness = 0;
 	state->input = -1;
-	state->muted = 0;
 	state->i2s_mode = 0;
 	init_waitqueue_head(&state->wq);
 	/* These are the reset input/output positions */
@@ -777,8 +678,6 @@ static int msp_probe(struct i2c_client *client, const struct i2c_device_id *id)
 		return -ENODEV;
 	}
 
-	msp_set_audio(client);
-
 	msp_family = ((state->rev1 >> 4) & 0x0f) + 3;
 	msp_product = (state->rev2 >> 8) & 0xff;
 	msp_prod_hi = msp_product / 10;
@@ -849,6 +748,34 @@ static int msp_probe(struct i2c_client *client, const struct i2c_device_id *id)
 			state->opmode = OPMODE_MANUAL;
 	}
 
+	hdl = &state->hdl;
+	v4l2_ctrl_handler_init(hdl, 6);
+	if (state->has_sound_processing) {
+		v4l2_ctrl_new_std(hdl, &msp_ctrl_ops,
+			V4L2_CID_AUDIO_BASS, 0, 65535, 65535 / 100, 32768);
+		v4l2_ctrl_new_std(hdl, &msp_ctrl_ops,
+			V4L2_CID_AUDIO_TREBLE, 0, 65535, 65535 / 100, 32768);
+		v4l2_ctrl_new_std(hdl, &msp_ctrl_ops,
+			V4L2_CID_AUDIO_LOUDNESS, 0, 1, 1, 0);
+	}
+	state->volume = v4l2_ctrl_new_std(hdl, &msp_ctrl_ops,
+			V4L2_CID_AUDIO_VOLUME, 0, 65535, 65535 / 100, 58880);
+	v4l2_ctrl_new_std(hdl, &msp_ctrl_ops,
+			V4L2_CID_AUDIO_BALANCE, 0, 65535, 65535 / 100, 32768);
+	state->muted = v4l2_ctrl_new_std(hdl, &msp_ctrl_ops,
+			V4L2_CID_AUDIO_MUTE, 0, 1, 1, 0);
+	sd->ctrl_handler = hdl;
+	if (hdl->error) {
+		int err = hdl->error;
+
+		v4l2_ctrl_handler_free(hdl);
+		kfree(state);
+		return err;
+	}
+
+	v4l2_ctrl_cluster(2, &state->volume);
+	v4l2_ctrl_handler_setup(hdl);
+
 	/* hello world :-) */
 	v4l_info(client, "MSP%d4%02d%c-%c%d found @ 0x%x (%s)\n",
 			msp_family, msp_product,
@@ -903,6 +830,7 @@ static int msp_remove(struct i2c_client *client)
 	}
 	msp_reset(client);
 
+	v4l2_ctrl_handler_free(&state->hdl);
 	kfree(state);
 	return 0;
 }
diff --git a/drivers/media/video/msp3400-driver.h b/drivers/media/video/msp3400-driver.h
index d6b3e6d..cba4559 100644
--- a/drivers/media/video/msp3400-driver.h
+++ b/drivers/media/video/msp3400-driver.h
@@ -6,6 +6,7 @@
 
 #include <media/msp3400.h>
 #include <media/v4l2-device.h>
+#include <media/v4l2-ctrls.h>
 
 /* ---------------------------------------------------------------------- */
 
@@ -51,6 +52,7 @@ extern int msp_stereo_thresh;
 
 struct msp_state {
 	struct v4l2_subdev sd;
+	struct v4l2_ctrl_handler hdl;
 	int rev1, rev2;
 	int ident;
 	u8 has_nicam;
@@ -87,9 +89,10 @@ struct msp_state {
 	int audmode;
 	int rxsubchans;
 
-	int volume, muted;
-	int balance, loudness;
-	int bass, treble;
+	/* volume cluster */
+	struct v4l2_ctrl *volume;
+	struct v4l2_ctrl *muted;
+
 	int scan_in_progress;
 
 	/* thread */
@@ -104,6 +107,11 @@ static inline struct msp_state *to_state(struct v4l2_subdev *sd)
 	return container_of(sd, struct msp_state, sd);
 }
 
+static inline struct msp_state *ctrl_to_state(struct v4l2_ctrl *ctrl)
+{
+	return container_of(ctrl->handler, struct msp_state, hdl);
+}
+
 /* msp3400-driver.c */
 int msp_write_dem(struct i2c_client *client, int addr, int val);
 int msp_write_dsp(struct i2c_client *client, int addr, int val);
@@ -111,7 +119,7 @@ int msp_read_dem(struct i2c_client *client, int addr);
 int msp_read_dsp(struct i2c_client *client, int addr);
 int msp_reset(struct i2c_client *client);
 void msp_set_scart(struct i2c_client *client, int in, int out);
-void msp_set_audio(struct i2c_client *client);
+void msp_update_volume(struct msp_state *state);
 int msp_sleep(struct msp_state *state, int timeout);
 
 /* msp3400-kthreads.c */
diff --git a/drivers/media/video/msp3400-kthreads.c b/drivers/media/video/msp3400-kthreads.c
index 168bca7..107d9c6 100644
--- a/drivers/media/video/msp3400-kthreads.c
+++ b/drivers/media/video/msp3400-kthreads.c
@@ -497,13 +497,13 @@ restart:
 			v4l_dbg(1, msp_debug, client,
 				"thread: no carrier scan\n");
 			state->scan_in_progress = 0;
-			msp_set_audio(client);
+			msp_update_volume(state);
 			continue;
 		}
 
 		/* mute audio */
 		state->scan_in_progress = 1;
-		msp_set_audio(client);
+		msp_update_volume(state);
 
 		msp3400c_set_mode(client, MSP_MODE_AM_DETECT);
 		val1 = val2 = 0;
@@ -635,7 +635,7 @@ no_second:
 		/* unmute */
 		state->scan_in_progress = 0;
 		msp3400c_set_audmode(client);
-		msp_set_audio(client);
+		msp_update_volume(state);
 
 		if (msp_debug)
 			msp3400c_print_mode(client);
@@ -680,13 +680,13 @@ restart:
 			v4l_dbg(1, msp_debug, client,
 				"thread: no carrier scan\n");
 			state->scan_in_progress = 0;
-			msp_set_audio(client);
+			msp_update_volume(state);
 			continue;
 		}
 
 		/* mute audio */
 		state->scan_in_progress = 1;
-		msp_set_audio(client);
+		msp_update_volume(state);
 
 		/* start autodetect. Note: autodetect is not supported for
 		   NTSC-M and radio, hence we force the standard in those
@@ -798,7 +798,7 @@ restart:
 		/* unmute */
 		msp3400c_set_audmode(client);
 		state->scan_in_progress = 0;
-		msp_set_audio(client);
+		msp_update_volume(state);
 
 		/* monitor tv audio mode, the first time don't wait
 		   so long to get a quick stereo/bilingual result */
@@ -975,7 +975,7 @@ restart:
 			v4l_dbg(1, msp_debug, client,
 				"thread: no carrier scan\n");
 			state->scan_in_progress = 0;
-			msp_set_audio(client);
+			msp_update_volume(state);
 			continue;
 		}
 
@@ -1021,7 +1021,7 @@ unmute:
 		}
 
 		/* unmute: dispatch sound to scart output, set scart volume */
-		msp_set_audio(client);
+		msp_update_volume(state);
 
 		/* restore ACB */
 		if (msp_write_dsp(client, 0x13, state->acb))
-- 
1.6.4.2

