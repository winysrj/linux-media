Return-path: <mchehab@gaivota>
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:2670 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752963Ab0LLRcH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 12 Dec 2010 12:32:07 -0500
Received: from localhost.localdomain (159.80-203-19.nextgentel.com [80.203.19.159])
	(authenticated bits=0)
	by smtp-vbr5.xs4all.nl (8.13.8/8.13.8) with ESMTP id oBCHW1MB002236
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Sun, 12 Dec 2010 18:32:03 +0100 (CET)
	(envelope-from hverkuil@xs4all.nl)
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: [RFC/PATCH 03/19] cx18: Use the control framework.
Date: Sun, 12 Dec 2010 18:31:45 +0100
Message-Id: <f58d44627f9a574161fee9d2aed92b98eaa4c882.1292174822.git.hverkuil@xs4all.nl>
In-Reply-To: <cover.1292174822.git.hverkuil@xs4all.nl>
References: <cover.1292174822.git.hverkuil@xs4all.nl>
In-Reply-To: <cover.1292174822.git.hverkuil@xs4all.nl>
References: <cover.1292174822.git.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
---
 drivers/media/video/cx18/cx18-av-audio.c |   92 ++---------
 drivers/media/video/cx18/cx18-av-core.c  |  162 ++++++-----------
 drivers/media/video/cx18/cx18-av-core.h  |   12 +-
 drivers/media/video/cx18/cx18-controls.c |  285 ++++--------------------------
 drivers/media/video/cx18/cx18-controls.h |    7 +-
 drivers/media/video/cx18/cx18-driver.c   |   30 ++--
 drivers/media/video/cx18/cx18-driver.h   |    2 +-
 drivers/media/video/cx18/cx18-fileops.c  |   32 +---
 drivers/media/video/cx18/cx18-ioctl.c    |   24 +--
 drivers/media/video/cx18/cx18-mailbox.c  |    5 +-
 drivers/media/video/cx18/cx18-mailbox.h  |    5 -
 drivers/media/video/cx18/cx18-streams.c  |   16 +-
 12 files changed, 160 insertions(+), 512 deletions(-)

diff --git a/drivers/media/video/cx18/cx18-av-audio.c b/drivers/media/video/cx18/cx18-av-audio.c
index 43d09a2..4a24ffb 100644
--- a/drivers/media/video/cx18/cx18-av-audio.c
+++ b/drivers/media/video/cx18/cx18-av-audio.c
@@ -342,17 +342,6 @@ void cx18_av_audio_set_path(struct cx18 *cx)
 	}
 }
 
-static int get_volume(struct cx18 *cx)
-{
-	/* Volume runs +18dB to -96dB in 1/2dB steps
-	 * change to fit the msp3400 -114dB to +12dB range */
-
-	/* check PATH1_VOLUME */
-	int vol = 228 - cx18_av_read(cx, 0x8d4);
-	vol = (vol / 2) + 23;
-	return vol << 9;
-}
-
 static void set_volume(struct cx18 *cx, int volume)
 {
 	/* First convert the volume to msp3400 values (0-127) */
@@ -369,52 +358,18 @@ static void set_volume(struct cx18 *cx, int volume)
 	cx18_av_write(cx, 0x8d4, 228 - (vol * 2));
 }
 
-static int get_bass(struct cx18 *cx)
-{
-	/* bass is 49 steps +12dB to -12dB */
-
-	/* check PATH1_EQ_BASS_VOL */
-	int bass = cx18_av_read(cx, 0x8d9) & 0x3f;
-	bass = (((48 - bass) * 0xffff) + 47) / 48;
-	return bass;
-}
-
 static void set_bass(struct cx18 *cx, int bass)
 {
 	/* PATH1_EQ_BASS_VOL */
 	cx18_av_and_or(cx, 0x8d9, ~0x3f, 48 - (bass * 48 / 0xffff));
 }
 
-static int get_treble(struct cx18 *cx)
-{
-	/* treble is 49 steps +12dB to -12dB */
-
-	/* check PATH1_EQ_TREBLE_VOL */
-	int treble = cx18_av_read(cx, 0x8db) & 0x3f;
-	treble = (((48 - treble) * 0xffff) + 47) / 48;
-	return treble;
-}
-
 static void set_treble(struct cx18 *cx, int treble)
 {
 	/* PATH1_EQ_TREBLE_VOL */
 	cx18_av_and_or(cx, 0x8db, ~0x3f, 48 - (treble * 48 / 0xffff));
 }
 
-static int get_balance(struct cx18 *cx)
-{
-	/* balance is 7 bit, 0 to -96dB */
-
-	/* check PATH1_BAL_LEVEL */
-	int balance = cx18_av_read(cx, 0x8d5) & 0x7f;
-	/* check PATH1_BAL_LEFT */
-	if ((cx18_av_read(cx, 0x8d5) & 0x80) == 0)
-		balance = 0x80 - balance;
-	else
-		balance = 0x80 + balance;
-	return balance << 8;
-}
-
 static void set_balance(struct cx18 *cx, int balance)
 {
 	int bal = balance >> 8;
@@ -431,12 +386,6 @@ static void set_balance(struct cx18 *cx, int balance)
 	}
 }
 
-static int get_mute(struct cx18 *cx)
-{
-	/* check SRC1_MUTE_EN */
-	return cx18_av_read(cx, 0x8d3) & 0x2 ? 1 : 0;
-}
-
 static void set_mute(struct cx18 *cx, int mute)
 {
 	struct cx18_av_state *state = &cx->av_state;
@@ -490,50 +439,33 @@ int cx18_av_s_clock_freq(struct v4l2_subdev *sd, u32 freq)
 	return retval;
 }
 
-int cx18_av_audio_g_ctrl(struct cx18 *cx, struct v4l2_control *ctrl)
+static int cx18_av_audio_s_ctrl(struct v4l2_ctrl *ctrl)
 {
-	switch (ctrl->id) {
-	case V4L2_CID_AUDIO_VOLUME:
-		ctrl->value = get_volume(cx);
-		break;
-	case V4L2_CID_AUDIO_BASS:
-		ctrl->value = get_bass(cx);
-		break;
-	case V4L2_CID_AUDIO_TREBLE:
-		ctrl->value = get_treble(cx);
-		break;
-	case V4L2_CID_AUDIO_BALANCE:
-		ctrl->value = get_balance(cx);
-		break;
-	case V4L2_CID_AUDIO_MUTE:
-		ctrl->value = get_mute(cx);
-		break;
-	default:
-		return -EINVAL;
-	}
-	return 0;
-}
+	struct v4l2_subdev *sd = to_sd(ctrl);
+	struct cx18 *cx = v4l2_get_subdevdata(sd);
 
-int cx18_av_audio_s_ctrl(struct cx18 *cx, struct v4l2_control *ctrl)
-{
 	switch (ctrl->id) {
 	case V4L2_CID_AUDIO_VOLUME:
-		set_volume(cx, ctrl->value);
+		set_volume(cx, ctrl->val);
 		break;
 	case V4L2_CID_AUDIO_BASS:
-		set_bass(cx, ctrl->value);
+		set_bass(cx, ctrl->val);
 		break;
 	case V4L2_CID_AUDIO_TREBLE:
-		set_treble(cx, ctrl->value);
+		set_treble(cx, ctrl->val);
 		break;
 	case V4L2_CID_AUDIO_BALANCE:
-		set_balance(cx, ctrl->value);
+		set_balance(cx, ctrl->val);
 		break;
 	case V4L2_CID_AUDIO_MUTE:
-		set_mute(cx, ctrl->value);
+		set_mute(cx, ctrl->val);
 		break;
 	default:
 		return -EINVAL;
 	}
 	return 0;
 }
+
+const struct v4l2_ctrl_ops cx18_av_audio_ctrl_ops = {
+	.s_ctrl = cx18_av_audio_s_ctrl,
+};
diff --git a/drivers/media/video/cx18/cx18-av-core.c b/drivers/media/video/cx18/cx18-av-core.c
index a41951c..e1f58f1 100644
--- a/drivers/media/video/cx18/cx18-av-core.c
+++ b/drivers/media/video/cx18/cx18-av-core.c
@@ -129,6 +129,7 @@ static void cx18_av_initialize(struct v4l2_subdev *sd)
 {
 	struct cx18_av_state *state = to_cx18_av_state(sd);
 	struct cx18 *cx = v4l2_get_subdevdata(sd);
+	int default_volume;
 	u32 v;
 
 	cx18_av_loadfw(cx);
@@ -247,8 +248,10 @@ static void cx18_av_initialize(struct v4l2_subdev *sd)
 /*      	CxDevWrReg(CXADEC_SRC_COMB_CFG, 0x6628021F); */
 /*    } */
 	cx18_av_write4(cx, CXADEC_SRC_COMB_CFG, 0x6628021F);
-	state->default_volume = 228 - cx18_av_read(cx, 0x8d4);
-	state->default_volume = ((state->default_volume / 2) + 23) << 9;
+	default_volume = 228 - cx18_av_read(cx, 0x8d4);
+	default_volume = ((default_volume / 2) + 23) << 9;
+	state->volume->cur.val = state->volume->default_value = default_volume;
+	v4l2_ctrl_handler_setup(&state->hdl);
 }
 
 static int cx18_av_reset(struct v4l2_subdev *sd, u32 val)
@@ -901,126 +904,35 @@ static int cx18_av_s_radio(struct v4l2_subdev *sd)
 	return 0;
 }
 
-static int cx18_av_s_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl)
+static int cx18_av_s_ctrl(struct v4l2_ctrl *ctrl)
 {
+	struct v4l2_subdev *sd = to_sd(ctrl);
 	struct cx18 *cx = v4l2_get_subdevdata(sd);
 
 	switch (ctrl->id) {
 	case V4L2_CID_BRIGHTNESS:
-		if (ctrl->value < 0 || ctrl->value > 255) {
-			CX18_ERR_DEV(sd, "invalid brightness setting %d\n",
-				     ctrl->value);
-			return -ERANGE;
-		}
-
-		cx18_av_write(cx, 0x414, ctrl->value - 128);
+		cx18_av_write(cx, 0x414, ctrl->val - 128);
 		break;
 
 	case V4L2_CID_CONTRAST:
-		if (ctrl->value < 0 || ctrl->value > 127) {
-			CX18_ERR_DEV(sd, "invalid contrast setting %d\n",
-				     ctrl->value);
-			return -ERANGE;
-		}
-
-		cx18_av_write(cx, 0x415, ctrl->value << 1);
+		cx18_av_write(cx, 0x415, ctrl->val << 1);
 		break;
 
 	case V4L2_CID_SATURATION:
-		if (ctrl->value < 0 || ctrl->value > 127) {
-			CX18_ERR_DEV(sd, "invalid saturation setting %d\n",
-				     ctrl->value);
-			return -ERANGE;
-		}
-
-		cx18_av_write(cx, 0x420, ctrl->value << 1);
-		cx18_av_write(cx, 0x421, ctrl->value << 1);
+		cx18_av_write(cx, 0x420, ctrl->val << 1);
+		cx18_av_write(cx, 0x421, ctrl->val << 1);
 		break;
 
 	case V4L2_CID_HUE:
-		if (ctrl->value < -128 || ctrl->value > 127) {
-			CX18_ERR_DEV(sd, "invalid hue setting %d\n",
-				     ctrl->value);
-			return -ERANGE;
-		}
-
-		cx18_av_write(cx, 0x422, ctrl->value);
+		cx18_av_write(cx, 0x422, ctrl->val);
 		break;
 
-	case V4L2_CID_AUDIO_VOLUME:
-	case V4L2_CID_AUDIO_BASS:
-	case V4L2_CID_AUDIO_TREBLE:
-	case V4L2_CID_AUDIO_BALANCE:
-	case V4L2_CID_AUDIO_MUTE:
-		return cx18_av_audio_s_ctrl(cx, ctrl);
-
 	default:
 		return -EINVAL;
 	}
 	return 0;
 }
 
-static int cx18_av_g_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl)
-{
-	struct cx18 *cx = v4l2_get_subdevdata(sd);
-
-	switch (ctrl->id) {
-	case V4L2_CID_BRIGHTNESS:
-		ctrl->value = (s8)cx18_av_read(cx, 0x414) + 128;
-		break;
-	case V4L2_CID_CONTRAST:
-		ctrl->value = cx18_av_read(cx, 0x415) >> 1;
-		break;
-	case V4L2_CID_SATURATION:
-		ctrl->value = cx18_av_read(cx, 0x420) >> 1;
-		break;
-	case V4L2_CID_HUE:
-		ctrl->value = (s8)cx18_av_read(cx, 0x422);
-		break;
-	case V4L2_CID_AUDIO_VOLUME:
-	case V4L2_CID_AUDIO_BASS:
-	case V4L2_CID_AUDIO_TREBLE:
-	case V4L2_CID_AUDIO_BALANCE:
-	case V4L2_CID_AUDIO_MUTE:
-		return cx18_av_audio_g_ctrl(cx, ctrl);
-	default:
-		return -EINVAL;
-	}
-	return 0;
-}
-
-static int cx18_av_queryctrl(struct v4l2_subdev *sd, struct v4l2_queryctrl *qc)
-{
-	struct cx18_av_state *state = to_cx18_av_state(sd);
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
-
-	switch (qc->id) {
-	case V4L2_CID_AUDIO_VOLUME:
-		return v4l2_ctrl_query_fill(qc, 0, 65535,
-			65535 / 100, state->default_volume);
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
 static int cx18_av_s_mbus_fmt(struct v4l2_subdev *sd, struct v4l2_mbus_framefmt *fmt)
 {
 	struct cx18_av_state *state = to_cx18_av_state(sd);
@@ -1356,14 +1268,22 @@ static int cx18_av_s_register(struct v4l2_subdev *sd,
 }
 #endif
 
+static const struct v4l2_ctrl_ops cx18_av_ctrl_ops = {
+	.s_ctrl = cx18_av_s_ctrl,
+};
+
 static const struct v4l2_subdev_core_ops cx18_av_general_ops = {
 	.g_chip_ident = cx18_av_g_chip_ident,
 	.log_status = cx18_av_log_status,
 	.load_fw = cx18_av_load_fw,
 	.reset = cx18_av_reset,
-	.queryctrl = cx18_av_queryctrl,
-	.g_ctrl = cx18_av_g_ctrl,
-	.s_ctrl = cx18_av_s_ctrl,
+	.g_ctrl = v4l2_subdev_g_ctrl,
+	.s_ctrl = v4l2_subdev_s_ctrl,
+	.s_ext_ctrls = v4l2_subdev_s_ext_ctrls,
+	.try_ext_ctrls = v4l2_subdev_try_ext_ctrls,
+	.g_ext_ctrls = v4l2_subdev_g_ext_ctrls,
+	.queryctrl = v4l2_subdev_queryctrl,
+	.querymenu = v4l2_subdev_querymenu,
 	.s_std = cx18_av_s_std,
 #ifdef CONFIG_VIDEO_ADV_DEBUG
 	.g_register = cx18_av_g_register,
@@ -1427,8 +1347,42 @@ int cx18_av_probe(struct cx18 *cx)
 	snprintf(sd->name, sizeof(sd->name),
 		 "%s %03x", cx->v4l2_dev.name, (state->rev >> 4));
 	sd->grp_id = CX18_HW_418_AV;
+	v4l2_ctrl_handler_init(&state->hdl, 9);
+	v4l2_ctrl_new_std(&state->hdl, &cx18_av_ctrl_ops,
+			V4L2_CID_BRIGHTNESS, 0, 255, 1, 128);
+	v4l2_ctrl_new_std(&state->hdl, &cx18_av_ctrl_ops,
+			V4L2_CID_CONTRAST, 0, 127, 1, 64);
+	v4l2_ctrl_new_std(&state->hdl, &cx18_av_ctrl_ops,
+			V4L2_CID_SATURATION, 0, 127, 1, 64);
+	v4l2_ctrl_new_std(&state->hdl, &cx18_av_ctrl_ops,
+			V4L2_CID_HUE, -128, 127, 1, 0);
+
+	state->volume = v4l2_ctrl_new_std(&state->hdl,
+			&cx18_av_audio_ctrl_ops, V4L2_CID_AUDIO_VOLUME,
+			0, 65335, 65535 / 100, 0);
+	v4l2_ctrl_new_std(&state->hdl,
+			&cx18_av_audio_ctrl_ops, V4L2_CID_AUDIO_MUTE,
+			0, 1, 1, 0);
+	v4l2_ctrl_new_std(&state->hdl, &cx18_av_audio_ctrl_ops,
+			V4L2_CID_AUDIO_BALANCE,
+			0, 65535, 65535 / 100, 32768);
+	v4l2_ctrl_new_std(&state->hdl, &cx18_av_audio_ctrl_ops,
+			V4L2_CID_AUDIO_BASS,
+			0, 65535, 65535 / 100, 32768);
+	v4l2_ctrl_new_std(&state->hdl, &cx18_av_audio_ctrl_ops,
+			V4L2_CID_AUDIO_TREBLE,
+			0, 65535, 65535 / 100, 32768);
+	sd->ctrl_handler = &state->hdl;
+	if (state->hdl.error) {
+		int err = state->hdl.error;
+
+		v4l2_ctrl_handler_free(&state->hdl);
+		return err;
+	}
 	err = v4l2_device_register_subdev(&cx->v4l2_dev, sd);
-	if (!err)
+	if (err)
+		v4l2_ctrl_handler_free(&state->hdl);
+	else
 		cx18_av_init(cx);
 	return err;
 }
diff --git a/drivers/media/video/cx18/cx18-av-core.h b/drivers/media/video/cx18/cx18-av-core.h
index 1956991..188c9c3 100644
--- a/drivers/media/video/cx18/cx18-av-core.h
+++ b/drivers/media/video/cx18/cx18-av-core.h
@@ -26,6 +26,7 @@
 #define _CX18_AV_CORE_H_
 
 #include <media/v4l2-device.h>
+#include <media/v4l2-ctrls.h>
 
 struct cx18;
 
@@ -95,13 +96,14 @@ enum cx18_av_audio_input {
 
 struct cx18_av_state {
 	struct v4l2_subdev sd;
+	struct v4l2_ctrl_handler hdl;
+	struct v4l2_ctrl *volume;
 	int radio;
 	v4l2_std_id std;
 	enum cx18_av_video_input vid_input;
 	enum cx18_av_audio_input aud_input;
 	u32 audclk_freq;
 	int audmode;
-	int default_volume;
 	u32 id;
 	u32 rev;
 	int is_initialized;
@@ -347,6 +349,11 @@ static inline struct cx18_av_state *to_cx18_av_state(struct v4l2_subdev *sd)
 	return container_of(sd, struct cx18_av_state, sd);
 }
 
+static inline struct v4l2_subdev *to_sd(struct v4l2_ctrl *ctrl)
+{
+	return &container_of(ctrl->handler, struct cx18_av_state, hdl)->sd;
+}
+
 /* ----------------------------------------------------------------------- */
 /* cx18_av-core.c 							   */
 int cx18_av_write(struct cx18 *cx, u16 addr, u8 value);
@@ -369,10 +376,9 @@ int cx18_av_loadfw(struct cx18 *cx);
 
 /* ----------------------------------------------------------------------- */
 /* cx18_av-audio.c                                                         */
-int cx18_av_audio_g_ctrl(struct cx18 *cx, struct v4l2_control *ctrl);
-int cx18_av_audio_s_ctrl(struct cx18 *cx, struct v4l2_control *ctrl);
 int cx18_av_s_clock_freq(struct v4l2_subdev *sd, u32 freq);
 void cx18_av_audio_set_path(struct cx18 *cx);
+extern const struct v4l2_ctrl_ops cx18_av_audio_ctrl_ops;
 
 /* ----------------------------------------------------------------------- */
 /* cx18_av-vbi.c                                                           */
diff --git a/drivers/media/video/cx18/cx18-controls.c b/drivers/media/video/cx18/cx18-controls.c
index 67043c7..282a3d2 100644
--- a/drivers/media/video/cx18/cx18-controls.c
+++ b/drivers/media/video/cx18/cx18-controls.c
@@ -30,152 +30,11 @@
 #include "cx18-mailbox.h"
 #include "cx18-controls.h"
 
-/* Must be sorted from low to high control ID! */
-static const u32 user_ctrls[] = {
-	V4L2_CID_USER_CLASS,
-	V4L2_CID_BRIGHTNESS,
-	V4L2_CID_CONTRAST,
-	V4L2_CID_SATURATION,
-	V4L2_CID_HUE,
-	V4L2_CID_AUDIO_VOLUME,
-	V4L2_CID_AUDIO_BALANCE,
-	V4L2_CID_AUDIO_BASS,
-	V4L2_CID_AUDIO_TREBLE,
-	V4L2_CID_AUDIO_MUTE,
-	V4L2_CID_AUDIO_LOUDNESS,
-	0
-};
-
-static const u32 *ctrl_classes[] = {
-	user_ctrls,
-	cx2341x_mpeg_ctrls,
-	NULL
-};
-
-int cx18_queryctrl(struct file *file, void *fh, struct v4l2_queryctrl *qctrl)
-{
-	struct cx18 *cx = ((struct cx18_open_id *)fh)->cx;
-	const char *name;
-
-	qctrl->id = v4l2_ctrl_next(ctrl_classes, qctrl->id);
-	if (qctrl->id == 0)
-		return -EINVAL;
-
-	switch (qctrl->id) {
-	/* Standard V4L2 controls */
-	case V4L2_CID_USER_CLASS:
-		return v4l2_ctrl_query_fill(qctrl, 0, 0, 0, 0);
-	case V4L2_CID_BRIGHTNESS:
-	case V4L2_CID_HUE:
-	case V4L2_CID_SATURATION:
-	case V4L2_CID_CONTRAST:
-		if (v4l2_subdev_call(cx->sd_av, core, queryctrl, qctrl))
-			qctrl->flags |= V4L2_CTRL_FLAG_DISABLED;
-		return 0;
-
-	case V4L2_CID_AUDIO_VOLUME:
-	case V4L2_CID_AUDIO_MUTE:
-	case V4L2_CID_AUDIO_BALANCE:
-	case V4L2_CID_AUDIO_BASS:
-	case V4L2_CID_AUDIO_TREBLE:
-	case V4L2_CID_AUDIO_LOUDNESS:
-		if (v4l2_subdev_call(cx->sd_av, core, queryctrl, qctrl))
-			qctrl->flags |= V4L2_CTRL_FLAG_DISABLED;
-		return 0;
-
-	default:
-		if (cx2341x_ctrl_query(&cx->params, qctrl))
-			qctrl->flags |= V4L2_CTRL_FLAG_DISABLED;
-		return 0;
-	}
-	strncpy(qctrl->name, name, sizeof(qctrl->name) - 1);
-	qctrl->name[sizeof(qctrl->name) - 1] = 0;
-	return 0;
-}
-
-int cx18_querymenu(struct file *file, void *fh, struct v4l2_querymenu *qmenu)
+static int cx18_s_stream_vbi_fmt(struct cx2341x_handler *cxhdl, u32 fmt)
 {
-	struct cx18 *cx = ((struct cx18_open_id *)fh)->cx;
-	struct v4l2_queryctrl qctrl;
-
-	qctrl.id = qmenu->id;
-	cx18_queryctrl(file, fh, &qctrl);
-	return v4l2_ctrl_query_menu(qmenu, &qctrl,
-			cx2341x_ctrl_get_menu(&cx->params, qmenu->id));
-}
-
-static int cx18_try_ctrl(struct file *file, void *fh,
-					struct v4l2_ext_control *vctrl)
-{
-	struct v4l2_queryctrl qctrl;
-	const char **menu_items = NULL;
-	int err;
-
-	qctrl.id = vctrl->id;
-	err = cx18_queryctrl(file, fh, &qctrl);
-	if (err)
-		return err;
-	if (qctrl.type == V4L2_CTRL_TYPE_MENU)
-		menu_items = v4l2_ctrl_get_menu(qctrl.id);
-	return v4l2_ctrl_check(vctrl, &qctrl, menu_items);
-}
-
-static int cx18_s_ctrl(struct cx18 *cx, struct v4l2_control *vctrl)
-{
-	switch (vctrl->id) {
-		/* Standard V4L2 controls */
-	case V4L2_CID_BRIGHTNESS:
-	case V4L2_CID_HUE:
-	case V4L2_CID_SATURATION:
-	case V4L2_CID_CONTRAST:
-		return v4l2_subdev_call(cx->sd_av, core, s_ctrl, vctrl);
-
-	case V4L2_CID_AUDIO_VOLUME:
-	case V4L2_CID_AUDIO_MUTE:
-	case V4L2_CID_AUDIO_BALANCE:
-	case V4L2_CID_AUDIO_BASS:
-	case V4L2_CID_AUDIO_TREBLE:
-	case V4L2_CID_AUDIO_LOUDNESS:
-		return v4l2_subdev_call(cx->sd_av, core, s_ctrl, vctrl);
-
-	default:
-		CX18_DEBUG_IOCTL("invalid control 0x%x\n", vctrl->id);
-		return -EINVAL;
-	}
-	return 0;
-}
-
-static int cx18_g_ctrl(struct cx18 *cx, struct v4l2_control *vctrl)
-{
-	switch (vctrl->id) {
-		/* Standard V4L2 controls */
-	case V4L2_CID_BRIGHTNESS:
-	case V4L2_CID_HUE:
-	case V4L2_CID_SATURATION:
-	case V4L2_CID_CONTRAST:
-		return v4l2_subdev_call(cx->sd_av, core, g_ctrl, vctrl);
-
-	case V4L2_CID_AUDIO_VOLUME:
-	case V4L2_CID_AUDIO_MUTE:
-	case V4L2_CID_AUDIO_BALANCE:
-	case V4L2_CID_AUDIO_BASS:
-	case V4L2_CID_AUDIO_TREBLE:
-	case V4L2_CID_AUDIO_LOUDNESS:
-		return v4l2_subdev_call(cx->sd_av, core, g_ctrl, vctrl);
+	struct cx18 *cx = container_of(cxhdl, struct cx18, cxhdl);
+	int type = cxhdl->stream_type->val;
 
-	default:
-		CX18_DEBUG_IOCTL("invalid control 0x%x\n", vctrl->id);
-		return -EINVAL;
-	}
-	return 0;
-}
-
-static int cx18_setup_vbi_fmt(struct cx18 *cx,
-			      enum v4l2_mpeg_stream_vbi_fmt fmt,
-			      enum v4l2_mpeg_stream_type type)
-{
-	if (!(cx->v4l2_cap & V4L2_CAP_SLICED_VBI_CAPTURE))
-		return -EINVAL;
 	if (atomic_read(&cx->ana_capturing) > 0)
 		return -EBUSY;
 
@@ -230,121 +89,43 @@ static int cx18_setup_vbi_fmt(struct cx18 *cx,
 	return 0;
 }
 
-int cx18_g_ext_ctrls(struct file *file, void *fh, struct v4l2_ext_controls *c)
+static int cx18_s_video_encoding(struct cx2341x_handler *cxhdl, u32 val)
 {
-	struct cx18 *cx = ((struct cx18_open_id *)fh)->cx;
-	struct v4l2_control ctrl;
-
-	if (c->ctrl_class == V4L2_CTRL_CLASS_USER) {
-		int i;
-		int err = 0;
-
-		for (i = 0; i < c->count; i++) {
-			ctrl.id = c->controls[i].id;
-			ctrl.value = c->controls[i].value;
-			err = cx18_g_ctrl(cx, &ctrl);
-			c->controls[i].value = ctrl.value;
-			if (err) {
-				c->error_idx = i;
-				break;
-			}
-		}
-		return err;
-	}
-	if (c->ctrl_class == V4L2_CTRL_CLASS_MPEG)
-		return cx2341x_ext_ctrls(&cx->params, 0, c, VIDIOC_G_EXT_CTRLS);
-	return -EINVAL;
+	struct cx18 *cx = container_of(cxhdl, struct cx18, cxhdl);
+	int is_mpeg1 = val == V4L2_MPEG_VIDEO_ENCODING_MPEG_1;
+	struct v4l2_mbus_framefmt fmt;
+
+	/* fix videodecoder resolution */
+	fmt.width = cxhdl->width / (is_mpeg1 ? 2 : 1);
+	fmt.height = cxhdl->height;
+	fmt.code = V4L2_MBUS_FMT_FIXED;
+	v4l2_subdev_call(cx->sd_av, video, s_mbus_fmt, &fmt);
+	return 0;
 }
 
-int cx18_s_ext_ctrls(struct file *file, void *fh, struct v4l2_ext_controls *c)
+static int cx18_s_audio_sampling_freq(struct cx2341x_handler *cxhdl, u32 idx)
 {
-	struct cx18_open_id *id = fh;
-	struct cx18 *cx = id->cx;
-	int ret;
-	struct v4l2_control ctrl;
-
-	ret = v4l2_prio_check(&cx->prio, id->prio);
-	if (ret)
-		return ret;
-
-	if (c->ctrl_class == V4L2_CTRL_CLASS_USER) {
-		int i;
-		int err = 0;
-
-		for (i = 0; i < c->count; i++) {
-			ctrl.id = c->controls[i].id;
-			ctrl.value = c->controls[i].value;
-			err = cx18_s_ctrl(cx, &ctrl);
-			c->controls[i].value = ctrl.value;
-			if (err) {
-				c->error_idx = i;
-				break;
-			}
-		}
-		return err;
-	}
-	if (c->ctrl_class == V4L2_CTRL_CLASS_MPEG) {
-		static u32 freqs[3] = { 44100, 48000, 32000 };
-		struct cx18_api_func_private priv;
-		struct cx2341x_mpeg_params p = cx->params;
-		int err = cx2341x_ext_ctrls(&p, atomic_read(&cx->ana_capturing),
-						c, VIDIOC_S_EXT_CTRLS);
-		unsigned int idx;
-
-		if (err)
-			return err;
+	static const u32 freqs[3] = { 44100, 48000, 32000 };
+	struct cx18 *cx = container_of(cxhdl, struct cx18, cxhdl);
 
-		if (p.video_encoding != cx->params.video_encoding) {
-			int is_mpeg1 = p.video_encoding ==
-						V4L2_MPEG_VIDEO_ENCODING_MPEG_1;
-			struct v4l2_mbus_framefmt fmt;
-
-			/* fix videodecoder resolution */
-			fmt.width = cx->params.width / (is_mpeg1 ? 2 : 1);
-			fmt.height = cx->params.height;
-			fmt.code = V4L2_MBUS_FMT_FIXED;
-			v4l2_subdev_call(cx->sd_av, video, s_mbus_fmt, &fmt);
-		}
-		priv.cx = cx;
-		priv.s = &cx->streams[id->type];
-		err = cx2341x_update(&priv, cx18_api_func, &cx->params, &p);
-		if (!err &&
-		    (cx->params.stream_vbi_fmt != p.stream_vbi_fmt ||
-		     cx->params.stream_type != p.stream_type))
-			err = cx18_setup_vbi_fmt(cx, p.stream_vbi_fmt,
-						 p.stream_type);
-		cx->params = p;
-		cx->dualwatch_stereo_mode = p.audio_properties & 0x0300;
-		idx = p.audio_properties & 0x03;
-		/* The audio clock of the digitizer must match the codec sample
-		   rate otherwise you get some very strange effects. */
-		if (idx < ARRAY_SIZE(freqs))
-			cx18_call_all(cx, audio, s_clock_freq, freqs[idx]);
-		return err;
-	}
-	return -EINVAL;
+	/* The audio clock of the digitizer must match the codec sample
+	   rate otherwise you get some very strange effects. */
+	if (idx < ARRAY_SIZE(freqs))
+		cx18_call_all(cx, audio, s_clock_freq, freqs[idx]);
+	return 0;
 }
 
-int cx18_try_ext_ctrls(struct file *file, void *fh, struct v4l2_ext_controls *c)
+static int cx18_s_audio_mode(struct cx2341x_handler *cxhdl, u32 val)
 {
-	struct cx18 *cx = ((struct cx18_open_id *)fh)->cx;
+	struct cx18 *cx = container_of(cxhdl, struct cx18, cxhdl);
 
-	if (c->ctrl_class == V4L2_CTRL_CLASS_USER) {
-		int i;
-		int err = 0;
-
-		for (i = 0; i < c->count; i++) {
-			err = cx18_try_ctrl(file, fh, &c->controls[i]);
-			if (err) {
-				c->error_idx = i;
-				break;
-			}
-		}
-		return err;
-	}
-	if (c->ctrl_class == V4L2_CTRL_CLASS_MPEG)
-		return cx2341x_ext_ctrls(&cx->params,
-						atomic_read(&cx->ana_capturing),
-						c, VIDIOC_TRY_EXT_CTRLS);
-	return -EINVAL;
+	cx->dualwatch_stereo_mode = val;
+	return 0;
 }
+
+struct cx2341x_handler_ops cx18_cxhdl_ops = {
+	.s_audio_mode = cx18_s_audio_mode,
+	.s_audio_sampling_freq = cx18_s_audio_sampling_freq,
+	.s_video_encoding = cx18_s_video_encoding,
+	.s_stream_vbi_fmt = cx18_s_stream_vbi_fmt,
+};
diff --git a/drivers/media/video/cx18/cx18-controls.h b/drivers/media/video/cx18/cx18-controls.h
index e463237..cb5dfc7 100644
--- a/drivers/media/video/cx18/cx18-controls.h
+++ b/drivers/media/video/cx18/cx18-controls.h
@@ -21,9 +21,4 @@
  *  02111-1307  USA
  */
 
-int cx18_queryctrl(struct file *file, void *fh, struct v4l2_queryctrl *a);
-int cx18_g_ext_ctrls(struct file *file, void *fh, struct v4l2_ext_controls *a);
-int cx18_s_ext_ctrls(struct file *file, void *fh, struct v4l2_ext_controls *a);
-int cx18_try_ext_ctrls(struct file *file, void *fh,
-			struct v4l2_ext_controls *a);
-int cx18_querymenu(struct file *file, void *fh, struct v4l2_querymenu *a);
+extern struct cx2341x_handler_ops cx18_cxhdl_ops;
diff --git a/drivers/media/video/cx18/cx18-driver.c b/drivers/media/video/cx18/cx18-driver.c
index 98ac2e9..8ea7110 100644
--- a/drivers/media/video/cx18/cx18-driver.c
+++ b/drivers/media/video/cx18/cx18-driver.c
@@ -36,6 +36,7 @@
 #include "cx18-scb.h"
 #include "cx18-mailbox.h"
 #include "cx18-ioctl.h"
+#include "cx18-controls.h"
 #include "tuner-xc2028.h"
 
 #include <media/tveeprom.h>
@@ -720,15 +721,21 @@ static int __devinit cx18_init_struct1(struct cx18 *cx)
 	cx->open_id = 1;
 
 	/* Initial settings */
-	cx2341x_fill_defaults(&cx->params);
-	cx->temporal_strength = cx->params.video_temporal_filter;
-	cx->spatial_strength = cx->params.video_spatial_filter;
-	cx->filter_mode = cx->params.video_spatial_filter_mode |
-		(cx->params.video_temporal_filter_mode << 1) |
-		(cx->params.video_median_filter_type << 2);
-	cx->params.port = CX2341X_PORT_MEMORY;
-	cx->params.capabilities =
-				CX2341X_CAP_HAS_TS | CX2341X_CAP_HAS_SLICED_VBI;
+	cx->cxhdl.port = CX2341X_PORT_MEMORY;
+	cx->cxhdl.capabilities = CX2341X_CAP_HAS_TS | CX2341X_CAP_HAS_SLICED_VBI;
+	cx->cxhdl.ops = &cx18_cxhdl_ops;
+	cx->cxhdl.func = cx18_api_func;
+	ret = cx2341x_handler_init(&cx->cxhdl, 50);
+	if (ret)
+		return ret;
+	cx->v4l2_dev.ctrl_handler = &cx->cxhdl.hdl;
+
+	cx->temporal_strength = cx->cxhdl.video_temporal_filter->cur.val;
+	cx->spatial_strength = cx->cxhdl.video_spatial_filter->cur.val;
+	cx->filter_mode = cx->cxhdl.video_spatial_filter_mode->cur.val |
+		(cx->cxhdl.video_temporal_filter_mode->cur.val << 1) |
+		(cx->cxhdl.video_median_filter_type->cur.val << 2);
+
 	init_waitqueue_head(&cx->cap_w);
 	init_waitqueue_head(&cx->mb_apu_waitq);
 	init_waitqueue_head(&cx->mb_cpu_waitq);
@@ -1035,7 +1042,7 @@ static int __devinit cx18_probe(struct pci_dev *pci_dev,
 	else
 		cx->is_50hz = 1;
 
-	cx->params.video_gop_size = cx->is_60hz ? 15 : 12;
+	cx2341x_handler_set_50hz(&cx->cxhdl, !cx->is_60hz);
 
 	if (cx->options.radio > 0)
 		cx->v4l2_cap |= V4L2_CAP_RADIO;
@@ -1081,7 +1088,6 @@ static int __devinit cx18_probe(struct pci_dev *pci_dev,
 
 	/* Load cx18 submodules (cx18-alsa) */
 	request_modules(cx);
-
 	return 0;
 
 free_streams:
@@ -1264,6 +1270,8 @@ static void cx18_remove(struct pci_dev *pci_dev)
 		for (i = 0; i < CX18_VBI_FRAMES; i++)
 			kfree(cx->vbi.sliced_mpeg_data[i]);
 
+	v4l2_ctrl_handler_free(&cx->av_state.hdl);
+
 	CX18_INFO("Removed %s\n", cx->card_name);
 
 	v4l2_device_unregister(v4l2_dev);
diff --git a/drivers/media/video/cx18/cx18-driver.h b/drivers/media/video/cx18/cx18-driver.h
index cf4f20e..cbd2753 100644
--- a/drivers/media/video/cx18/cx18-driver.h
+++ b/drivers/media/video/cx18/cx18-driver.h
@@ -563,7 +563,7 @@ struct cx18 {
 	struct cx18_av_state av_state;
 
 	/* codec settings */
-	struct cx2341x_mpeg_params params;
+	struct cx2341x_handler cxhdl;
 	u32 filter_mode;
 	u32 temporal_strength;
 	u32 spatial_strength;
diff --git a/drivers/media/video/cx18/cx18-fileops.c b/drivers/media/video/cx18/cx18-fileops.c
index 9f23b90..98ef33e 100644
--- a/drivers/media/video/cx18/cx18-fileops.c
+++ b/drivers/media/video/cx18/cx18-fileops.c
@@ -160,13 +160,10 @@ EXPORT_SYMBOL(cx18_release_stream);
 static void cx18_dualwatch(struct cx18 *cx)
 {
 	struct v4l2_tuner vt;
-	u32 new_bitmap;
 	u32 new_stereo_mode;
-	const u32 stereo_mask = 0x0300;
 	const u32 dual = 0x0200;
-	u32 h;
 
-	new_stereo_mode = cx->params.audio_properties & stereo_mask;
+	new_stereo_mode = v4l2_ctrl_g_ctrl(cx->cxhdl.audio_mode);
 	memset(&vt, 0, sizeof(vt));
 	cx18_call_all(cx, tuner, g_tuner, &vt);
 	if (vt.audmode == V4L2_TUNER_MODE_LANG1_LANG2 &&
@@ -176,25 +173,10 @@ static void cx18_dualwatch(struct cx18 *cx)
 	if (new_stereo_mode == cx->dualwatch_stereo_mode)
 		return;
 
-	new_bitmap = new_stereo_mode
-			| (cx->params.audio_properties & ~stereo_mask);
-
-	CX18_DEBUG_INFO("dualwatch: change stereo flag from 0x%x to 0x%x. "
-			"new audio_bitmask=0x%ux\n",
-			cx->dualwatch_stereo_mode, new_stereo_mode, new_bitmap);
-
-	h = cx18_find_handle(cx);
-	if (h == CX18_INVALID_TASK_HANDLE) {
-		CX18_DEBUG_INFO("dualwatch: can't find valid task handle\n");
-		return;
-	}
-
-	if (cx18_vapi(cx,
-		      CX18_CPU_SET_AUDIO_PARAMETERS, 2, h, new_bitmap) == 0) {
-		cx->dualwatch_stereo_mode = new_stereo_mode;
-		return;
-	}
-	CX18_DEBUG_INFO("dualwatch: changing stereo flag failed\n");
+	CX18_DEBUG_INFO("dualwatch: change stereo flag from 0x%x to 0x%x.\n",
+			   cx->dualwatch_stereo_mode, new_stereo_mode);
+	if (v4l2_ctrl_s_ctrl(cx->cxhdl.audio_mode, new_stereo_mode))
+		CX18_DEBUG_INFO("dualwatch: changing stereo flag failed\n");
 }
 
 
@@ -724,8 +706,8 @@ int cx18_v4l2_close(struct file *filp)
 		if (atomic_read(&cx->ana_capturing) > 0) {
 			/* Undo video mute */
 			cx18_vapi(cx, CX18_CPU_SET_VIDEO_MUTE, 2, s->handle,
-				cx->params.video_mute |
-					(cx->params.video_mute_yuv << 8));
+			    (v4l2_ctrl_g_ctrl(cx->cxhdl.video_mute) |
+			    (v4l2_ctrl_g_ctrl(cx->cxhdl.video_mute_yuv) << 8)));
 		}
 		/* Done! Unmute and continue. */
 		cx18_unmute(cx);
diff --git a/drivers/media/video/cx18/cx18-ioctl.c b/drivers/media/video/cx18/cx18-ioctl.c
index 7150195..36b018c 100644
--- a/drivers/media/video/cx18/cx18-ioctl.c
+++ b/drivers/media/video/cx18/cx18-ioctl.c
@@ -152,8 +152,8 @@ static int cx18_g_fmt_vid_cap(struct file *file, void *fh,
 	struct cx18 *cx = id->cx;
 	struct v4l2_pix_format *pixfmt = &fmt->fmt.pix;
 
-	pixfmt->width = cx->params.width;
-	pixfmt->height = cx->params.height;
+	pixfmt->width = cx->cxhdl.width;
+	pixfmt->height = cx->cxhdl.height;
 	pixfmt->colorspace = V4L2_COLORSPACE_SMPTE170M;
 	pixfmt->field = V4L2_FIELD_INTERLACED;
 	pixfmt->priv = 0;
@@ -287,14 +287,14 @@ static int cx18_s_fmt_vid_cap(struct file *file, void *fh,
 	w = fmt->fmt.pix.width;
 	h = fmt->fmt.pix.height;
 
-	if (cx->params.width == w && cx->params.height == h)
+	if (cx->cxhdl.width == w && cx->cxhdl.height == h)
 		return 0;
 
 	if (atomic_read(&cx->ana_capturing) > 0)
 		return -EBUSY;
 
-	mbus_fmt.width = cx->params.width = w;
-	mbus_fmt.height = cx->params.height = h;
+	mbus_fmt.width = cx->cxhdl.width = w;
+	mbus_fmt.height = cx->cxhdl.height = h;
 	mbus_fmt.code = V4L2_MBUS_FMT_FIXED;
 	v4l2_subdev_call(cx->sd_av, video, s_mbus_fmt, &mbus_fmt);
 	return cx18_g_fmt_vid_cap(file, fh, fmt);
@@ -696,9 +696,10 @@ int cx18_s_std(struct file *file, void *fh, v4l2_std_id *std)
 
 	cx->std = *std;
 	cx->is_60hz = (*std & V4L2_STD_525_60) ? 1 : 0;
-	cx->params.is_50hz = cx->is_50hz = !cx->is_60hz;
-	cx->params.width = 720;
-	cx->params.height = cx->is_50hz ? 576 : 480;
+	cx->is_50hz = !cx->is_60hz;
+	cx2341x_handler_set_50hz(&cx->cxhdl, cx->is_50hz);
+	cx->cxhdl.width = 720;
+	cx->cxhdl.height = cx->is_50hz ? 576 : 480;
 	cx->vbi.count = cx->is_50hz ? 18 : 12;
 	cx->vbi.start[0] = cx->is_50hz ? 6 : 10;
 	cx->vbi.start[1] = cx->is_50hz ? 318 : 273;
@@ -1035,7 +1036,7 @@ static int cx18_log_status(struct file *file, void *fh)
 	mutex_unlock(&cx->gpio_lock);
 	CX18_INFO("Tuner: %s\n",
 		test_bit(CX18_F_I_RADIO_USER, &cx->i_flags) ?  "Radio" : "TV");
-	cx2341x_log_status(&cx->params, cx->v4l2_dev.name);
+	v4l2_ctrl_handler_log_status(&cx->cxhdl.hdl, cx->v4l2_dev.name);
 	CX18_INFO("Status flags: 0x%08lx\n", cx->i_flags);
 	for (i = 0; i < CX18_MAX_STREAMS; i++) {
 		struct cx18_stream *s = &cx->streams[i];
@@ -1136,11 +1137,6 @@ static const struct v4l2_ioctl_ops cx18_ioctl_ops = {
 	.vidioc_s_register              = cx18_s_register,
 #endif
 	.vidioc_default                 = cx18_default,
-	.vidioc_queryctrl               = cx18_queryctrl,
-	.vidioc_querymenu               = cx18_querymenu,
-	.vidioc_g_ext_ctrls             = cx18_g_ext_ctrls,
-	.vidioc_s_ext_ctrls             = cx18_s_ext_ctrls,
-	.vidioc_try_ext_ctrls           = cx18_try_ext_ctrls,
 };
 
 void cx18_set_funcs(struct video_device *vdev)
diff --git a/drivers/media/video/cx18/cx18-mailbox.c b/drivers/media/video/cx18/cx18-mailbox.c
index 956aa19..d366d65 100644
--- a/drivers/media/video/cx18/cx18-mailbox.c
+++ b/drivers/media/video/cx18/cx18-mailbox.c
@@ -716,9 +716,8 @@ static int cx18_set_filter_param(struct cx18_stream *s)
 int cx18_api_func(void *priv, u32 cmd, int in, int out,
 		u32 data[CX2341X_MBOX_MAX_DATA])
 {
-	struct cx18_api_func_private *api_priv = priv;
-	struct cx18 *cx = api_priv->cx;
-	struct cx18_stream *s = api_priv->s;
+	struct cx18_stream *s = priv;
+	struct cx18 *cx = s->cx;
 
 	switch (cmd) {
 	case CX2341X_ENC_SET_OUTPUT_PORT:
diff --git a/drivers/media/video/cx18/cx18-mailbox.h b/drivers/media/video/cx18/cx18-mailbox.h
index 077952f..05fe6bd 100644
--- a/drivers/media/video/cx18/cx18-mailbox.h
+++ b/drivers/media/video/cx18/cx18-mailbox.h
@@ -81,11 +81,6 @@ struct cx18_mailbox {
 
 struct cx18_stream;
 
-struct cx18_api_func_private {
-	struct cx18 *cx;
-	struct cx18_stream *s;
-};
-
 int cx18_api(struct cx18 *cx, u32 cmd, int args, u32 data[]);
 int cx18_vapi_result(struct cx18 *cx, u32 data[MAX_MB_ARGUMENTS], u32 cmd,
 		int args, ...);
diff --git a/drivers/media/video/cx18/cx18-streams.c b/drivers/media/video/cx18/cx18-streams.c
index 9045f1e..d0c923e 100644
--- a/drivers/media/video/cx18/cx18-streams.c
+++ b/drivers/media/video/cx18/cx18-streams.c
@@ -555,7 +555,7 @@ static void cx18_stream_configure_mdls(struct cx18_stream *s)
 		 * Set the MDL size to the exact size needed for one frame.
 		 * Use enough buffers per MDL to cover the MDL size
 		 */
-		s->mdl_size = 720 * s->cx->params.height * 3 / 2;
+		s->mdl_size = 720 * s->cx->cxhdl.height * 3 / 2;
 		s->bufs_per_mdl = s->mdl_size / s->buf_size;
 		if (s->mdl_size % s->buf_size)
 			s->bufs_per_mdl++;
@@ -590,7 +590,6 @@ int cx18_start_v4l2_encode_stream(struct cx18_stream *s)
 	u32 data[MAX_MB_ARGUMENTS];
 	struct cx18 *cx = s->cx;
 	int captype = 0;
-	struct cx18_api_func_private priv;
 	struct cx18_stream *s_idx;
 
 	if (!cx18_stream_enabled(s))
@@ -603,7 +602,7 @@ int cx18_start_v4l2_encode_stream(struct cx18_stream *s)
 		captype = CAPTURE_CHANNEL_TYPE_MPEG;
 		cx->mpg_data_received = cx->vbi_data_inserted = 0;
 		cx->dualwatch_jiffies = jiffies;
-		cx->dualwatch_stereo_mode = cx->params.audio_properties & 0x300;
+		cx->dualwatch_stereo_mode = v4l2_ctrl_g_ctrl(cx->cxhdl.audio_mode);
 		cx->search_pack_header = 0;
 		break;
 
@@ -693,21 +692,21 @@ int cx18_start_v4l2_encode_stream(struct cx18_stream *s)
 				 s->handle, cx18_stream_enabled(s_idx) ? 7 : 0);
 
 		/* Call out to the common CX2341x API setup for user controls */
-		priv.cx = cx;
-		priv.s = s;
-		cx2341x_update(&priv, cx18_api_func, NULL, &cx->params);
+		cx->cxhdl.priv = s;
+		cx2341x_handler_setup(&cx->cxhdl);
 
 		/*
 		 * When starting a capture and we're set for radio,
 		 * ensure the video is muted, despite the user control.
 		 */
-		if (!cx->params.video_mute &&
+		if (!cx->cxhdl.video_mute &&
 		    test_bit(CX18_F_I_RADIO_USER, &cx->i_flags))
 			cx18_vapi(cx, CX18_CPU_SET_VIDEO_MUTE, 2, s->handle,
-				  (cx->params.video_mute_yuv << 8) | 1);
+			  (v4l2_ctrl_g_ctrl(cx->cxhdl.video_mute_yuv) << 8) | 1);
 	}
 
 	if (atomic_read(&cx->tot_capturing) == 0) {
+		cx2341x_handler_set_busy(&cx->cxhdl, 1);
 		clear_bit(CX18_F_I_EOS, &cx->i_flags);
 		cx18_write_reg(cx, 7, CX18_DSP0_INTERRUPT_MASK);
 	}
@@ -809,6 +808,7 @@ int cx18_stop_v4l2_encode_stream(struct cx18_stream *s, int gop_end)
 	if (atomic_read(&cx->tot_capturing) > 0)
 		return 0;
 
+	cx2341x_handler_set_busy(&cx->cxhdl, 0);
 	cx18_write_reg(cx, 5, CX18_DSP0_INTERRUPT_MASK);
 	wake_up(&s->waitq);
 
-- 
1.7.0.4

