Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr1.xs4all.nl ([194.109.24.21]:3922 "EHLO
	smtp-vbr1.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754507Ab3CKVBE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Mar 2013 17:01:04 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Devin Heitmueller <dheitmueller@kernellabs.com>,
	Steven Toth <stoth@kernellabs.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEW PATCH 01/15] au8522_decoder: convert to the control framework.
Date: Mon, 11 Mar 2013 22:00:32 +0100
Message-Id: <0e2409cf677013b9cad1ba4aee17fe434dae7146.1363035203.git.hans.verkuil@cisco.com>
In-Reply-To: <1363035646-25244-1-git-send-email-hverkuil@xs4all.nl>
References: <1363035646-25244-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/dvb-frontends/au8522_decoder.c |  130 +++++++++-----------------
 drivers/media/dvb-frontends/au8522_priv.h    |    6 +-
 2 files changed, 46 insertions(+), 90 deletions(-)

diff --git a/drivers/media/dvb-frontends/au8522_decoder.c b/drivers/media/dvb-frontends/au8522_decoder.c
index 5243ba6..be2c802 100644
--- a/drivers/media/dvb-frontends/au8522_decoder.c
+++ b/drivers/media/dvb-frontends/au8522_decoder.c
@@ -229,15 +229,11 @@ static void setup_decoder_defaults(struct au8522_state *state, u8 input_mode)
 	/* Provide reasonable defaults for picture tuning values */
 	au8522_writereg(state, AU8522_TVDEC_SHARPNESSREG009H, 0x07);
 	au8522_writereg(state, AU8522_TVDEC_BRIGHTNESS_REG00AH, 0xed);
-	state->brightness = 0xed - 128;
 	au8522_writereg(state, AU8522_TVDEC_CONTRAST_REG00BH, 0x79);
-	state->contrast = 0x79;
 	au8522_writereg(state, AU8522_TVDEC_SATURATION_CB_REG00CH, 0x80);
 	au8522_writereg(state, AU8522_TVDEC_SATURATION_CR_REG00DH, 0x80);
-	state->saturation = 0x80;
 	au8522_writereg(state, AU8522_TVDEC_HUE_H_REG00EH, 0x00);
 	au8522_writereg(state, AU8522_TVDEC_HUE_L_REG00FH, 0x00);
-	state->hue = 0x00;
 
 	/* Other decoder registers */
 	au8522_writereg(state, AU8522_TVDEC_INT_MASK_REG010H, 0x00);
@@ -489,75 +485,32 @@ static void set_audio_input(struct au8522_state *state, int aud_input)
 
 /* ----------------------------------------------------------------------- */
 
-static int au8522_s_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl)
+static int au8522_s_ctrl(struct v4l2_ctrl *ctrl)
 {
-	struct au8522_state *state = to_state(sd);
+	struct au8522_state *state =
+		container_of(ctrl->handler, struct au8522_state, hdl);
 
 	switch (ctrl->id) {
 	case V4L2_CID_BRIGHTNESS:
-		state->brightness = ctrl->value;
 		au8522_writereg(state, AU8522_TVDEC_BRIGHTNESS_REG00AH,
-				ctrl->value - 128);
+				ctrl->val - 128);
 		break;
 	case V4L2_CID_CONTRAST:
-		state->contrast = ctrl->value;
 		au8522_writereg(state, AU8522_TVDEC_CONTRAST_REG00BH,
-				ctrl->value);
+				ctrl->val);
 		break;
 	case V4L2_CID_SATURATION:
-		state->saturation = ctrl->value;
 		au8522_writereg(state, AU8522_TVDEC_SATURATION_CB_REG00CH,
-				ctrl->value);
+				ctrl->val);
 		au8522_writereg(state, AU8522_TVDEC_SATURATION_CR_REG00DH,
-				ctrl->value);
+				ctrl->val);
 		break;
 	case V4L2_CID_HUE:
-		state->hue = ctrl->value;
 		au8522_writereg(state, AU8522_TVDEC_HUE_H_REG00EH,
-				ctrl->value >> 8);
+				ctrl->val >> 8);
 		au8522_writereg(state, AU8522_TVDEC_HUE_L_REG00FH,
-				ctrl->value & 0xFF);
-		break;
-	case V4L2_CID_AUDIO_VOLUME:
-	case V4L2_CID_AUDIO_BASS:
-	case V4L2_CID_AUDIO_TREBLE:
-	case V4L2_CID_AUDIO_BALANCE:
-	case V4L2_CID_AUDIO_MUTE:
-		/* Not yet implemented */
-	default:
-		return -EINVAL;
-	}
-
-	return 0;
-}
-
-static int au8522_g_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl)
-{
-	struct au8522_state *state = to_state(sd);
-
-	/* Note that we are using values cached in the state structure instead
-	   of reading the registers due to issues with i2c reads not working
-	   properly/consistently yet on the HVR-950q */
-
-	switch (ctrl->id) {
-	case V4L2_CID_BRIGHTNESS:
-		ctrl->value = state->brightness;
-		break;
-	case V4L2_CID_CONTRAST:
-		ctrl->value = state->contrast;
-		break;
-	case V4L2_CID_SATURATION:
-		ctrl->value = state->saturation;
-		break;
-	case V4L2_CID_HUE:
-		ctrl->value = state->hue;
+				ctrl->val & 0xFF);
 		break;
-	case V4L2_CID_AUDIO_VOLUME:
-	case V4L2_CID_AUDIO_BASS:
-	case V4L2_CID_AUDIO_TREBLE:
-	case V4L2_CID_AUDIO_BALANCE:
-	case V4L2_CID_AUDIO_MUTE:
-		/* Not yet supported */
 	default:
 		return -EINVAL;
 	}
@@ -616,26 +569,6 @@ static int au8522_s_stream(struct v4l2_subdev *sd, int enable)
 	return 0;
 }
 
-static int au8522_queryctrl(struct v4l2_subdev *sd, struct v4l2_queryctrl *qc)
-{
-	switch (qc->id) {
-	case V4L2_CID_CONTRAST:
-		return v4l2_ctrl_query_fill(qc, 0, 255, 1,
-					    AU8522_TVDEC_CONTRAST_REG00BH_CVBS);
-	case V4L2_CID_BRIGHTNESS:
-		return v4l2_ctrl_query_fill(qc, 0, 255, 1, 109);
-	case V4L2_CID_SATURATION:
-		return v4l2_ctrl_query_fill(qc, 0, 255, 1, 128);
-	case V4L2_CID_HUE:
-		return v4l2_ctrl_query_fill(qc, -32768, 32768, 1, 0);
-	default:
-		break;
-	}
-
-	qc->type = 0;
-	return -EINVAL;
-}
-
 static int au8522_reset(struct v4l2_subdev *sd, u32 val)
 {
 	struct au8522_state *state = to_state(sd);
@@ -712,20 +645,18 @@ static int au8522_g_chip_ident(struct v4l2_subdev *sd,
 	return v4l2_chip_ident_i2c_client(client, chip, state->id, state->rev);
 }
 
-static int au8522_log_status(struct v4l2_subdev *sd)
-{
-	/* FIXME: Add some status info here */
-	return 0;
-}
-
 /* ----------------------------------------------------------------------- */
 
 static const struct v4l2_subdev_core_ops au8522_core_ops = {
-	.log_status = au8522_log_status,
+	.log_status = v4l2_ctrl_subdev_log_status,
+	.g_ext_ctrls = v4l2_subdev_g_ext_ctrls,
+	.try_ext_ctrls = v4l2_subdev_try_ext_ctrls,
+	.s_ext_ctrls = v4l2_subdev_s_ext_ctrls,
+	.g_ctrl = v4l2_subdev_g_ctrl,
+	.s_ctrl = v4l2_subdev_s_ctrl,
+	.queryctrl = v4l2_subdev_queryctrl,
+	.querymenu = v4l2_subdev_querymenu,
 	.g_chip_ident = au8522_g_chip_ident,
-	.g_ctrl = au8522_g_ctrl,
-	.s_ctrl = au8522_s_ctrl,
-	.queryctrl = au8522_queryctrl,
 	.reset = au8522_reset,
 #ifdef CONFIG_VIDEO_ADV_DEBUG
 	.g_register = au8522_g_register,
@@ -753,12 +684,17 @@ static const struct v4l2_subdev_ops au8522_ops = {
 	.video = &au8522_video_ops,
 };
 
+static const struct v4l2_ctrl_ops au8522_ctrl_ops = {
+	.s_ctrl = au8522_s_ctrl,
+};
+
 /* ----------------------------------------------------------------------- */
 
 static int au8522_probe(struct i2c_client *client,
 			const struct i2c_device_id *did)
 {
 	struct au8522_state *state;
+	struct v4l2_ctrl_handler *hdl;
 	struct v4l2_subdev *sd;
 	int instance;
 	struct au8522_config *demod_config;
@@ -799,6 +735,27 @@ static int au8522_probe(struct i2c_client *client,
 	sd = &state->sd;
 	v4l2_i2c_subdev_init(sd, client, &au8522_ops);
 
+	hdl = &state->hdl;
+	v4l2_ctrl_handler_init(hdl, 4);
+	v4l2_ctrl_new_std(hdl, &au8522_ctrl_ops,
+			V4L2_CID_BRIGHTNESS, 0, 255, 1, 109);
+	v4l2_ctrl_new_std(hdl, &au8522_ctrl_ops,
+			V4L2_CID_CONTRAST, 0, 255, 1,
+			AU8522_TVDEC_CONTRAST_REG00BH_CVBS);
+	v4l2_ctrl_new_std(hdl, &au8522_ctrl_ops,
+			V4L2_CID_SATURATION, 0, 255, 1, 128);
+	v4l2_ctrl_new_std(hdl, &au8522_ctrl_ops,
+			V4L2_CID_HUE, -32768, 32767, 1, 0);
+	sd->ctrl_handler = hdl;
+	if (hdl->error) {
+		int err = hdl->error;
+
+		v4l2_ctrl_handler_free(hdl);
+		kfree(demod_config);
+		kfree(state);
+		return err;
+	}
+
 	state->c = client;
 	state->vid_input = AU8522_COMPOSITE_CH1;
 	state->aud_input = AU8522_AUDIO_NONE;
@@ -815,6 +772,7 @@ static int au8522_remove(struct i2c_client *client)
 {
 	struct v4l2_subdev *sd = i2c_get_clientdata(client);
 	v4l2_device_unregister_subdev(sd);
+	v4l2_ctrl_handler_free(sd->ctrl_handler);
 	au8522_release_state(to_state(sd));
 	return 0;
 }
diff --git a/drivers/media/dvb-frontends/au8522_priv.h b/drivers/media/dvb-frontends/au8522_priv.h
index 0529699..aa0f16d 100644
--- a/drivers/media/dvb-frontends/au8522_priv.h
+++ b/drivers/media/dvb-frontends/au8522_priv.h
@@ -29,6 +29,7 @@
 #include <linux/delay.h>
 #include <linux/videodev2.h>
 #include <media/v4l2-device.h>
+#include <media/v4l2-ctrls.h>
 #include <linux/i2c.h>
 #include "dvb_frontend.h"
 #include "au8522.h"
@@ -65,10 +66,7 @@ struct au8522_state {
 	int aud_input;
 	u32 id;
 	u32 rev;
-	u8 brightness;
-	u8 contrast;
-	u8 saturation;
-	s16 hue;
+	struct v4l2_ctrl_handler hdl;
 };
 
 /* These are routines shared by both the VSB/QAM demodulator and the analog
-- 
1.7.10.4

