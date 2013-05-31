Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr6.xs4all.nl ([194.109.24.26]:3475 "EHLO
	smtp-vbr6.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752395Ab3EaKDH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 31 May 2013 06:03:07 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 03/21] saa6752hs: convert to the control framework.
Date: Fri, 31 May 2013 12:02:23 +0200
Message-Id: <1369994561-25236-4-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1369994561-25236-1-git-send-email-hverkuil@xs4all.nl>
References: <1369994561-25236-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/pci/saa7134/saa6752hs.c |  457 +++++++++------------------------
 1 file changed, 122 insertions(+), 335 deletions(-)

diff --git a/drivers/media/pci/saa7134/saa6752hs.c b/drivers/media/pci/saa7134/saa6752hs.c
index f147b05..5813ce8 100644
--- a/drivers/media/pci/saa7134/saa6752hs.c
+++ b/drivers/media/pci/saa7134/saa6752hs.c
@@ -34,6 +34,7 @@
 #include <linux/types.h>
 #include <linux/videodev2.h>
 #include <media/v4l2-device.h>
+#include <media/v4l2-ctrls.h>
 #include <media/v4l2-common.h>
 #include <media/v4l2-chip-ident.h>
 #include <linux/init.h>
@@ -92,6 +93,12 @@ static const struct v4l2_format v4l2_format_table[] =
 
 struct saa6752hs_state {
 	struct v4l2_subdev            sd;
+	struct v4l2_ctrl_handler      hdl;
+	struct { /* video bitrate mode control cluster */
+		struct v4l2_ctrl *video_bitrate_mode;
+		struct v4l2_ctrl *video_bitrate;
+		struct v4l2_ctrl *video_bitrate_peak;
+	};
 	int 			      chip;
 	u32 			      revision;
 	int 			      has_ac3;
@@ -362,316 +369,72 @@ static int saa6752hs_set_bitrate(struct i2c_client *client,
 	return 0;
 }
 
-
-static int get_ctrl(int has_ac3, struct saa6752hs_mpeg_params *params,
-		struct v4l2_ext_control *ctrl)
+static int saa6752hs_try_ctrl(struct v4l2_ctrl *ctrl)
 {
+	struct saa6752hs_state *h =
+		container_of(ctrl->handler, struct saa6752hs_state, hdl);
+
 	switch (ctrl->id) {
-	case V4L2_CID_MPEG_STREAM_TYPE:
-		ctrl->value = V4L2_MPEG_STREAM_TYPE_MPEG2_TS;
-		break;
-	case V4L2_CID_MPEG_STREAM_PID_PMT:
-		ctrl->value = params->ts_pid_pmt;
-		break;
-	case V4L2_CID_MPEG_STREAM_PID_AUDIO:
-		ctrl->value = params->ts_pid_audio;
-		break;
-	case V4L2_CID_MPEG_STREAM_PID_VIDEO:
-		ctrl->value = params->ts_pid_video;
-		break;
-	case V4L2_CID_MPEG_STREAM_PID_PCR:
-		ctrl->value = params->ts_pid_pcr;
-		break;
-	case V4L2_CID_MPEG_AUDIO_ENCODING:
-		ctrl->value = params->au_encoding;
-		break;
-	case V4L2_CID_MPEG_AUDIO_L2_BITRATE:
-		ctrl->value = params->au_l2_bitrate;
-		break;
-	case V4L2_CID_MPEG_AUDIO_AC3_BITRATE:
-		if (!has_ac3)
-			return -EINVAL;
-		ctrl->value = params->au_ac3_bitrate;
-		break;
-	case V4L2_CID_MPEG_AUDIO_SAMPLING_FREQ:
-		ctrl->value = V4L2_MPEG_AUDIO_SAMPLING_FREQ_48000;
-		break;
-	case V4L2_CID_MPEG_VIDEO_ENCODING:
-		ctrl->value = V4L2_MPEG_VIDEO_ENCODING_MPEG_2;
-		break;
-	case V4L2_CID_MPEG_VIDEO_ASPECT:
-		ctrl->value = params->vi_aspect;
-		break;
-	case V4L2_CID_MPEG_VIDEO_BITRATE:
-		ctrl->value = params->vi_bitrate * 1000;
-		break;
-	case V4L2_CID_MPEG_VIDEO_BITRATE_PEAK:
-		ctrl->value = params->vi_bitrate_peak * 1000;
-		break;
 	case V4L2_CID_MPEG_VIDEO_BITRATE_MODE:
-		ctrl->value = params->vi_bitrate_mode;
+		/* peak bitrate shall be >= normal bitrate */
+		if (ctrl->val == V4L2_MPEG_VIDEO_BITRATE_MODE_VBR &&
+		    h->video_bitrate_peak->val < h->video_bitrate->val)
+			h->video_bitrate_peak->val = h->video_bitrate->val;
 		break;
-	default:
-		return -EINVAL;
 	}
 	return 0;
 }
 
-static int handle_ctrl(int has_ac3, struct saa6752hs_mpeg_params *params,
-		struct v4l2_ext_control *ctrl, int set)
+static int saa6752hs_s_ctrl(struct v4l2_ctrl *ctrl)
 {
-	int old = 0, new;
+	struct saa6752hs_state *h =
+		container_of(ctrl->handler, struct saa6752hs_state, hdl);
+	struct saa6752hs_mpeg_params *params = &h->params;
 
-	new = ctrl->value;
 	switch (ctrl->id) {
 	case V4L2_CID_MPEG_STREAM_TYPE:
-		old = V4L2_MPEG_STREAM_TYPE_MPEG2_TS;
-		if (set && new != old)
-			return -ERANGE;
-		new = old;
 		break;
 	case V4L2_CID_MPEG_STREAM_PID_PMT:
-		old = params->ts_pid_pmt;
-		if (set && new > MPEG_PID_MAX)
-			return -ERANGE;
-		if (new > MPEG_PID_MAX)
-			new = MPEG_PID_MAX;
-		params->ts_pid_pmt = new;
+		params->ts_pid_pmt = ctrl->val;
 		break;
 	case V4L2_CID_MPEG_STREAM_PID_AUDIO:
-		old = params->ts_pid_audio;
-		if (set && new > MPEG_PID_MAX)
-			return -ERANGE;
-		if (new > MPEG_PID_MAX)
-			new = MPEG_PID_MAX;
-		params->ts_pid_audio = new;
+		params->ts_pid_audio = ctrl->val;
 		break;
 	case V4L2_CID_MPEG_STREAM_PID_VIDEO:
-		old = params->ts_pid_video;
-		if (set && new > MPEG_PID_MAX)
-			return -ERANGE;
-		if (new > MPEG_PID_MAX)
-			new = MPEG_PID_MAX;
-		params->ts_pid_video = new;
+		params->ts_pid_video = ctrl->val;
 		break;
 	case V4L2_CID_MPEG_STREAM_PID_PCR:
-		old = params->ts_pid_pcr;
-		if (set && new > MPEG_PID_MAX)
-			return -ERANGE;
-		if (new > MPEG_PID_MAX)
-			new = MPEG_PID_MAX;
-		params->ts_pid_pcr = new;
+		params->ts_pid_pcr = ctrl->val;
 		break;
 	case V4L2_CID_MPEG_AUDIO_ENCODING:
-		old = params->au_encoding;
-		if (set && new != V4L2_MPEG_AUDIO_ENCODING_LAYER_2 &&
-		    (!has_ac3 || new != V4L2_MPEG_AUDIO_ENCODING_AC3))
-			return -ERANGE;
-		params->au_encoding = new;
+		params->au_encoding = ctrl->val;
 		break;
 	case V4L2_CID_MPEG_AUDIO_L2_BITRATE:
-		old = params->au_l2_bitrate;
-		if (set && new != V4L2_MPEG_AUDIO_L2_BITRATE_256K &&
-			   new != V4L2_MPEG_AUDIO_L2_BITRATE_384K)
-			return -ERANGE;
-		if (new <= V4L2_MPEG_AUDIO_L2_BITRATE_256K)
-			new = V4L2_MPEG_AUDIO_L2_BITRATE_256K;
-		else
-			new = V4L2_MPEG_AUDIO_L2_BITRATE_384K;
-		params->au_l2_bitrate = new;
+		params->au_l2_bitrate = ctrl->val;
 		break;
 	case V4L2_CID_MPEG_AUDIO_AC3_BITRATE:
-		if (!has_ac3)
-			return -EINVAL;
-		old = params->au_ac3_bitrate;
-		if (set && new != V4L2_MPEG_AUDIO_AC3_BITRATE_256K &&
-			   new != V4L2_MPEG_AUDIO_AC3_BITRATE_384K)
-			return -ERANGE;
-		if (new <= V4L2_MPEG_AUDIO_AC3_BITRATE_256K)
-			new = V4L2_MPEG_AUDIO_AC3_BITRATE_256K;
-		else
-			new = V4L2_MPEG_AUDIO_AC3_BITRATE_384K;
-		params->au_ac3_bitrate = new;
+		params->au_ac3_bitrate = ctrl->val;
 		break;
 	case V4L2_CID_MPEG_AUDIO_SAMPLING_FREQ:
-		old = V4L2_MPEG_AUDIO_SAMPLING_FREQ_48000;
-		if (set && new != old)
-			return -ERANGE;
-		new = old;
 		break;
 	case V4L2_CID_MPEG_VIDEO_ENCODING:
-		old = V4L2_MPEG_VIDEO_ENCODING_MPEG_2;
-		if (set && new != old)
-			return -ERANGE;
-		new = old;
 		break;
 	case V4L2_CID_MPEG_VIDEO_ASPECT:
-		old = params->vi_aspect;
-		if (set && new != V4L2_MPEG_VIDEO_ASPECT_16x9 &&
-			   new != V4L2_MPEG_VIDEO_ASPECT_4x3)
-			return -ERANGE;
-		if (new != V4L2_MPEG_VIDEO_ASPECT_16x9)
-			new = V4L2_MPEG_VIDEO_ASPECT_4x3;
-		params->vi_aspect = new;
-		break;
-	case V4L2_CID_MPEG_VIDEO_BITRATE:
-		old = params->vi_bitrate * 1000;
-		new = 1000 * (new / 1000);
-		if (set && new > MPEG_VIDEO_TARGET_BITRATE_MAX * 1000)
-			return -ERANGE;
-		if (new > MPEG_VIDEO_TARGET_BITRATE_MAX * 1000)
-			new = MPEG_VIDEO_TARGET_BITRATE_MAX * 1000;
-		params->vi_bitrate = new / 1000;
-		break;
-	case V4L2_CID_MPEG_VIDEO_BITRATE_PEAK:
-		old = params->vi_bitrate_peak * 1000;
-		new = 1000 * (new / 1000);
-		if (set && new > MPEG_VIDEO_TARGET_BITRATE_MAX * 1000)
-			return -ERANGE;
-		if (new > MPEG_VIDEO_TARGET_BITRATE_MAX * 1000)
-			new = MPEG_VIDEO_TARGET_BITRATE_MAX * 1000;
-		params->vi_bitrate_peak = new / 1000;
+		params->vi_aspect = ctrl->val;
 		break;
 	case V4L2_CID_MPEG_VIDEO_BITRATE_MODE:
-		old = params->vi_bitrate_mode;
-		params->vi_bitrate_mode = new;
+		params->vi_bitrate_mode = ctrl->val;
+		params->vi_bitrate = h->video_bitrate->val / 1000;
+		params->vi_bitrate_peak = h->video_bitrate_peak->val / 1000;
+		v4l2_ctrl_activate(h->video_bitrate_peak,
+				ctrl->val == V4L2_MPEG_VIDEO_BITRATE_MODE_VBR);
 		break;
 	default:
 		return -EINVAL;
 	}
-	ctrl->value = new;
 	return 0;
 }
 
-
-static int saa6752hs_queryctrl(struct v4l2_subdev *sd, struct v4l2_queryctrl *qctrl)
-{
-	struct saa6752hs_state *h = to_state(sd);
-	struct saa6752hs_mpeg_params *params = &h->params;
-	int err;
-
-	switch (qctrl->id) {
-	case V4L2_CID_MPEG_AUDIO_ENCODING:
-		return v4l2_ctrl_query_fill(qctrl,
-				V4L2_MPEG_AUDIO_ENCODING_LAYER_2,
-				h->has_ac3 ? V4L2_MPEG_AUDIO_ENCODING_AC3 :
-					V4L2_MPEG_AUDIO_ENCODING_LAYER_2,
-				1, V4L2_MPEG_AUDIO_ENCODING_LAYER_2);
-
-	case V4L2_CID_MPEG_AUDIO_L2_BITRATE:
-		return v4l2_ctrl_query_fill(qctrl,
-				V4L2_MPEG_AUDIO_L2_BITRATE_256K,
-				V4L2_MPEG_AUDIO_L2_BITRATE_384K, 1,
-				V4L2_MPEG_AUDIO_L2_BITRATE_256K);
-
-	case V4L2_CID_MPEG_AUDIO_AC3_BITRATE:
-		if (!h->has_ac3)
-			return -EINVAL;
-		return v4l2_ctrl_query_fill(qctrl,
-				V4L2_MPEG_AUDIO_AC3_BITRATE_256K,
-				V4L2_MPEG_AUDIO_AC3_BITRATE_384K, 1,
-				V4L2_MPEG_AUDIO_AC3_BITRATE_256K);
-
-	case V4L2_CID_MPEG_AUDIO_SAMPLING_FREQ:
-		return v4l2_ctrl_query_fill(qctrl,
-				V4L2_MPEG_AUDIO_SAMPLING_FREQ_48000,
-				V4L2_MPEG_AUDIO_SAMPLING_FREQ_48000, 1,
-				V4L2_MPEG_AUDIO_SAMPLING_FREQ_48000);
-
-	case V4L2_CID_MPEG_VIDEO_ENCODING:
-		return v4l2_ctrl_query_fill(qctrl,
-				V4L2_MPEG_VIDEO_ENCODING_MPEG_2,
-				V4L2_MPEG_VIDEO_ENCODING_MPEG_2, 1,
-				V4L2_MPEG_VIDEO_ENCODING_MPEG_2);
-
-	case V4L2_CID_MPEG_VIDEO_ASPECT:
-		return v4l2_ctrl_query_fill(qctrl,
-				V4L2_MPEG_VIDEO_ASPECT_4x3,
-				V4L2_MPEG_VIDEO_ASPECT_16x9, 1,
-				V4L2_MPEG_VIDEO_ASPECT_4x3);
-
-	case V4L2_CID_MPEG_VIDEO_BITRATE_PEAK:
-		err = v4l2_ctrl_query_fill(qctrl, 0, 27000000, 1, 8000000);
-		if (err == 0 &&
-		    params->vi_bitrate_mode ==
-				V4L2_MPEG_VIDEO_BITRATE_MODE_CBR)
-			qctrl->flags |= V4L2_CTRL_FLAG_INACTIVE;
-		return err;
-
-	case V4L2_CID_MPEG_STREAM_TYPE:
-		return v4l2_ctrl_query_fill(qctrl,
-				V4L2_MPEG_STREAM_TYPE_MPEG2_TS,
-				V4L2_MPEG_STREAM_TYPE_MPEG2_TS, 1,
-				V4L2_MPEG_STREAM_TYPE_MPEG2_TS);
-
-	case V4L2_CID_MPEG_VIDEO_BITRATE_MODE:
-		return v4l2_ctrl_query_fill(qctrl,
-				V4L2_MPEG_VIDEO_BITRATE_MODE_VBR,
-				V4L2_MPEG_VIDEO_BITRATE_MODE_CBR, 1,
-				V4L2_MPEG_VIDEO_BITRATE_MODE_VBR);
-	case V4L2_CID_MPEG_VIDEO_BITRATE:
-		return v4l2_ctrl_query_fill(qctrl, 0, 27000000, 1, 6000000);
-	case V4L2_CID_MPEG_STREAM_PID_PMT:
-		return v4l2_ctrl_query_fill(qctrl, 0, (1 << 14) - 1, 1, 16);
-	case V4L2_CID_MPEG_STREAM_PID_AUDIO:
-		return v4l2_ctrl_query_fill(qctrl, 0, (1 << 14) - 1, 1, 260);
-	case V4L2_CID_MPEG_STREAM_PID_VIDEO:
-		return v4l2_ctrl_query_fill(qctrl, 0, (1 << 14) - 1, 1, 256);
-	case V4L2_CID_MPEG_STREAM_PID_PCR:
-		return v4l2_ctrl_query_fill(qctrl, 0, (1 << 14) - 1, 1, 259);
-
-	default:
-		break;
-	}
-	return -EINVAL;
-}
-
-static int saa6752hs_querymenu(struct v4l2_subdev *sd, struct v4l2_querymenu *qmenu)
-{
-	static const u32 mpeg_audio_encoding[] = {
-		V4L2_MPEG_AUDIO_ENCODING_LAYER_2,
-		V4L2_CTRL_MENU_IDS_END
-	};
-	static const u32 mpeg_audio_ac3_encoding[] = {
-		V4L2_MPEG_AUDIO_ENCODING_LAYER_2,
-		V4L2_MPEG_AUDIO_ENCODING_AC3,
-		V4L2_CTRL_MENU_IDS_END
-	};
-	static u32 mpeg_audio_l2_bitrate[] = {
-		V4L2_MPEG_AUDIO_L2_BITRATE_256K,
-		V4L2_MPEG_AUDIO_L2_BITRATE_384K,
-		V4L2_CTRL_MENU_IDS_END
-	};
-	static u32 mpeg_audio_ac3_bitrate[] = {
-		V4L2_MPEG_AUDIO_AC3_BITRATE_256K,
-		V4L2_MPEG_AUDIO_AC3_BITRATE_384K,
-		V4L2_CTRL_MENU_IDS_END
-	};
-	struct saa6752hs_state *h = to_state(sd);
-	struct v4l2_queryctrl qctrl;
-	int err;
-
-	qctrl.id = qmenu->id;
-	err = saa6752hs_queryctrl(sd, &qctrl);
-	if (err)
-		return err;
-	switch (qmenu->id) {
-	case V4L2_CID_MPEG_AUDIO_L2_BITRATE:
-		return v4l2_ctrl_query_menu_valid_items(qmenu,
-				mpeg_audio_l2_bitrate);
-	case V4L2_CID_MPEG_AUDIO_AC3_BITRATE:
-		if (!h->has_ac3)
-			return -EINVAL;
-		return v4l2_ctrl_query_menu_valid_items(qmenu,
-				mpeg_audio_ac3_bitrate);
-	case V4L2_CID_MPEG_AUDIO_ENCODING:
-		return v4l2_ctrl_query_menu_valid_items(qmenu,
-			h->has_ac3 ? mpeg_audio_ac3_encoding :
-				mpeg_audio_encoding);
-	}
-	return v4l2_ctrl_query_menu(qmenu, &qctrl, NULL);
-}
-
 static int saa6752hs_init(struct v4l2_subdev *sd, u32 leading_null_bytes)
 {
 	unsigned char buf[9], buf2[4];
@@ -793,58 +556,6 @@ static int saa6752hs_init(struct v4l2_subdev *sd, u32 leading_null_bytes)
 	return 0;
 }
 
-static int saa6752hs_do_ext_ctrls(struct v4l2_subdev *sd, struct v4l2_ext_controls *ctrls, int set)
-{
-	struct saa6752hs_state *h = to_state(sd);
-	struct saa6752hs_mpeg_params params;
-	int i;
-
-	if (ctrls->ctrl_class != V4L2_CTRL_CLASS_MPEG)
-		return -EINVAL;
-
-	params = h->params;
-	for (i = 0; i < ctrls->count; i++) {
-		int err = handle_ctrl(h->has_ac3, &params, ctrls->controls + i, set);
-
-		if (err) {
-			ctrls->error_idx = i;
-			return err;
-		}
-	}
-	if (set)
-		h->params = params;
-	return 0;
-}
-
-static int saa6752hs_s_ext_ctrls(struct v4l2_subdev *sd, struct v4l2_ext_controls *ctrls)
-{
-	return saa6752hs_do_ext_ctrls(sd, ctrls, 1);
-}
-
-static int saa6752hs_try_ext_ctrls(struct v4l2_subdev *sd, struct v4l2_ext_controls *ctrls)
-{
-	return saa6752hs_do_ext_ctrls(sd, ctrls, 0);
-}
-
-static int saa6752hs_g_ext_ctrls(struct v4l2_subdev *sd, struct v4l2_ext_controls *ctrls)
-{
-	struct saa6752hs_state *h = to_state(sd);
-	int i;
-
-	if (ctrls->ctrl_class != V4L2_CTRL_CLASS_MPEG)
-		return -EINVAL;
-
-	for (i = 0; i < ctrls->count; i++) {
-		int err = get_ctrl(h->has_ac3, &h->params, ctrls->controls + i);
-
-		if (err) {
-			ctrls->error_idx = i;
-			return err;
-		}
-	}
-	return 0;
-}
-
 static int saa6752hs_g_mbus_fmt(struct v4l2_subdev *sd, struct v4l2_mbus_framefmt *f)
 {
 	struct saa6752hs_state *h = to_state(sd);
@@ -925,14 +636,21 @@ static int saa6752hs_g_chip_ident(struct v4l2_subdev *sd, struct v4l2_dbg_chip_i
 
 /* ----------------------------------------------------------------------- */
 
+static const struct v4l2_ctrl_ops saa6752hs_ctrl_ops = {
+	.try_ctrl = saa6752hs_try_ctrl,
+	.s_ctrl = saa6752hs_s_ctrl,
+};
+
 static const struct v4l2_subdev_core_ops saa6752hs_core_ops = {
 	.g_chip_ident = saa6752hs_g_chip_ident,
 	.init = saa6752hs_init,
-	.queryctrl = saa6752hs_queryctrl,
-	.querymenu = saa6752hs_querymenu,
-	.g_ext_ctrls = saa6752hs_g_ext_ctrls,
-	.s_ext_ctrls = saa6752hs_s_ext_ctrls,
-	.try_ext_ctrls = saa6752hs_try_ext_ctrls,
+	.g_ext_ctrls = v4l2_subdev_g_ext_ctrls,
+	.try_ext_ctrls = v4l2_subdev_try_ext_ctrls,
+	.s_ext_ctrls = v4l2_subdev_s_ext_ctrls,
+	.g_ctrl = v4l2_subdev_g_ctrl,
+	.s_ctrl = v4l2_subdev_s_ctrl,
+	.queryctrl = v4l2_subdev_queryctrl,
+	.querymenu = v4l2_subdev_querymenu,
 	.s_std = saa6752hs_s_std,
 };
 
@@ -951,6 +669,7 @@ static int saa6752hs_probe(struct i2c_client *client,
 {
 	struct saa6752hs_state *h = kzalloc(sizeof(*h), GFP_KERNEL);
 	struct v4l2_subdev *sd;
+	struct v4l2_ctrl_handler *hdl;
 	u8 addr = 0x13;
 	u8 data[12];
 
@@ -969,9 +688,84 @@ static int saa6752hs_probe(struct i2c_client *client,
 	if (h->revision == 0x0206) {
 		h->chip = V4L2_IDENT_SAA6752HS_AC3;
 		h->has_ac3 = 1;
-		v4l_info(client, "support AC-3\n");
+		v4l_info(client, "supports AC-3\n");
 	}
 	h->params = param_defaults;
+
+	hdl = &h->hdl;
+	v4l2_ctrl_handler_init(hdl, 14);
+	v4l2_ctrl_new_std_menu(hdl, &saa6752hs_ctrl_ops,
+		V4L2_CID_MPEG_AUDIO_ENCODING,
+		h->has_ac3 ? V4L2_MPEG_AUDIO_ENCODING_AC3 :
+			V4L2_MPEG_AUDIO_ENCODING_LAYER_2,
+		0x0d, V4L2_MPEG_AUDIO_ENCODING_LAYER_2);
+
+	v4l2_ctrl_new_std_menu(hdl, &saa6752hs_ctrl_ops,
+		V4L2_CID_MPEG_AUDIO_L2_BITRATE,
+		V4L2_MPEG_AUDIO_L2_BITRATE_384K,
+		~((1 << V4L2_MPEG_AUDIO_L2_BITRATE_256K) |
+		  (1 << V4L2_MPEG_AUDIO_L2_BITRATE_384K)),
+		V4L2_MPEG_AUDIO_L2_BITRATE_256K);
+
+	if (h->has_ac3)
+		v4l2_ctrl_new_std_menu(hdl, &saa6752hs_ctrl_ops,
+			V4L2_CID_MPEG_AUDIO_AC3_BITRATE,
+			V4L2_MPEG_AUDIO_AC3_BITRATE_384K,
+			~((1 << V4L2_MPEG_AUDIO_AC3_BITRATE_256K) |
+			  (1 << V4L2_MPEG_AUDIO_AC3_BITRATE_384K)),
+			V4L2_MPEG_AUDIO_AC3_BITRATE_256K);
+
+	v4l2_ctrl_new_std_menu(hdl, &saa6752hs_ctrl_ops,
+		V4L2_CID_MPEG_AUDIO_SAMPLING_FREQ,
+		V4L2_MPEG_AUDIO_SAMPLING_FREQ_48000,
+		~(1 << V4L2_MPEG_AUDIO_SAMPLING_FREQ_48000),
+		V4L2_MPEG_AUDIO_SAMPLING_FREQ_48000);
+
+	v4l2_ctrl_new_std_menu(hdl, &saa6752hs_ctrl_ops,
+		V4L2_CID_MPEG_VIDEO_ENCODING,
+		V4L2_MPEG_VIDEO_ENCODING_MPEG_2,
+		~(1 << V4L2_MPEG_VIDEO_ENCODING_MPEG_2),
+		V4L2_MPEG_VIDEO_ENCODING_MPEG_2);
+
+	v4l2_ctrl_new_std_menu(hdl, &saa6752hs_ctrl_ops,
+		V4L2_CID_MPEG_VIDEO_ASPECT,
+		V4L2_MPEG_VIDEO_ASPECT_16x9, 0x01,
+		V4L2_MPEG_VIDEO_ASPECT_4x3);
+
+	h->video_bitrate_peak = v4l2_ctrl_new_std(hdl, &saa6752hs_ctrl_ops,
+		V4L2_CID_MPEG_VIDEO_BITRATE_PEAK,
+		1000000, 27000000, 1000, 8000000);
+
+	v4l2_ctrl_new_std_menu(hdl, &saa6752hs_ctrl_ops,
+		V4L2_CID_MPEG_STREAM_TYPE,
+		V4L2_MPEG_STREAM_TYPE_MPEG2_TS,
+		~(1 << V4L2_MPEG_STREAM_TYPE_MPEG2_TS),
+		V4L2_MPEG_STREAM_TYPE_MPEG2_TS);
+
+	h->video_bitrate_mode = v4l2_ctrl_new_std_menu(hdl, &saa6752hs_ctrl_ops,
+		V4L2_CID_MPEG_VIDEO_BITRATE_MODE,
+		V4L2_MPEG_VIDEO_BITRATE_MODE_CBR, 0,
+		V4L2_MPEG_VIDEO_BITRATE_MODE_VBR);
+	h->video_bitrate = v4l2_ctrl_new_std(hdl, &saa6752hs_ctrl_ops,
+		V4L2_CID_MPEG_VIDEO_BITRATE, 1000000, 27000000, 1000, 6000000);
+	v4l2_ctrl_new_std(hdl, &saa6752hs_ctrl_ops,
+		V4L2_CID_MPEG_STREAM_PID_PMT, 0, (1 << 14) - 1, 1, 16);
+	v4l2_ctrl_new_std(hdl, &saa6752hs_ctrl_ops,
+		V4L2_CID_MPEG_STREAM_PID_AUDIO, 0, (1 << 14) - 1, 1, 260);
+	v4l2_ctrl_new_std(hdl, &saa6752hs_ctrl_ops,
+		V4L2_CID_MPEG_STREAM_PID_VIDEO, 0, (1 << 14) - 1, 1, 256);
+	v4l2_ctrl_new_std(hdl, &saa6752hs_ctrl_ops,
+		V4L2_CID_MPEG_STREAM_PID_PCR, 0, (1 << 14) - 1, 1, 259);
+	sd->ctrl_handler = hdl;
+	if (hdl->error) {
+		int err = hdl->error;
+
+		v4l2_ctrl_handler_free(hdl);
+		kfree(h);
+		return err;
+	}
+	v4l2_ctrl_cluster(3, &h->video_bitrate_mode);
+	v4l2_ctrl_handler_setup(hdl);
 	h->standard = 0; /* Assume 625 input lines */
 	return 0;
 }
@@ -981,6 +775,7 @@ static int saa6752hs_remove(struct i2c_client *client)
 	struct v4l2_subdev *sd = i2c_get_clientdata(client);
 
 	v4l2_device_unregister_subdev(sd);
+	v4l2_ctrl_handler_free(&to_state(sd)->hdl);
 	kfree(to_state(sd));
 	return 0;
 }
@@ -1002,11 +797,3 @@ static struct i2c_driver saa6752hs_driver = {
 };
 
 module_i2c_driver(saa6752hs_driver);
-
-/*
- * Overrides for Emacs so that we follow Linus's tabbing style.
- * ---------------------------------------------------------------------------
- * Local variables:
- * c-basic-offset: 8
- * End:
- */
-- 
1.7.10.4

