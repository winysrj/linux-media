Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud3.xs4all.net ([194.109.24.30]:41208 "EHLO
	lb3-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752749AbcDVND6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 22 Apr 2016 09:03:58 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 5/6] media/i2c/adv*: make controls inheritable instead of private
Date: Fri, 22 Apr 2016 15:03:41 +0200
Message-Id: <1461330222-34096-6-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1461330222-34096-1-git-send-email-hverkuil@xs4all.nl>
References: <1461330222-34096-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Marking these controls as private seemed a good idea at one time,
but in practice it makes no sense. So drop this.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/i2c/ad9389b.c | 8 --------
 drivers/media/i2c/adv7511.c | 6 ------
 drivers/media/i2c/adv7604.c | 8 --------
 drivers/media/i2c/adv7842.c | 6 ------
 4 files changed, 28 deletions(-)

diff --git a/drivers/media/i2c/ad9389b.c b/drivers/media/i2c/ad9389b.c
index 788967d..0462f46 100644
--- a/drivers/media/i2c/ad9389b.c
+++ b/drivers/media/i2c/ad9389b.c
@@ -1130,8 +1130,6 @@ static int ad9389b_probe(struct i2c_client *client, const struct i2c_device_id *
 	hdl = &state->hdl;
 	v4l2_ctrl_handler_init(hdl, 5);
 
-	/* private controls */
-
 	state->hdmi_mode_ctrl = v4l2_ctrl_new_std_menu(hdl, &ad9389b_ctrl_ops,
 			V4L2_CID_DV_TX_MODE, V4L2_DV_TX_MODE_HDMI,
 			0, V4L2_DV_TX_MODE_DVI_D);
@@ -1151,12 +1149,6 @@ static int ad9389b_probe(struct i2c_client *client, const struct i2c_device_id *
 
 		goto err_hdl;
 	}
-	state->hdmi_mode_ctrl->is_private = true;
-	state->hotplug_ctrl->is_private = true;
-	state->rx_sense_ctrl->is_private = true;
-	state->have_edid0_ctrl->is_private = true;
-	state->rgb_quantization_range_ctrl->is_private = true;
-
 	state->pad.flags = MEDIA_PAD_FL_SINK;
 	err = media_entity_pads_init(&sd->entity, 1, &state->pad);
 	if (err)
diff --git a/drivers/media/i2c/adv7511.c b/drivers/media/i2c/adv7511.c
index bd822f0..39271c3 100644
--- a/drivers/media/i2c/adv7511.c
+++ b/drivers/media/i2c/adv7511.c
@@ -1502,12 +1502,6 @@ static int adv7511_probe(struct i2c_client *client, const struct i2c_device_id *
 		err = hdl->error;
 		goto err_hdl;
 	}
-	state->hdmi_mode_ctrl->is_private = true;
-	state->hotplug_ctrl->is_private = true;
-	state->rx_sense_ctrl->is_private = true;
-	state->have_edid0_ctrl->is_private = true;
-	state->rgb_quantization_range_ctrl->is_private = true;
-
 	state->pad.flags = MEDIA_PAD_FL_SINK;
 	err = media_entity_pads_init(&sd->entity, 1, &state->pad);
 	if (err)
diff --git a/drivers/media/i2c/adv7604.c b/drivers/media/i2c/adv7604.c
index 41a1bfc..beb2841 100644
--- a/drivers/media/i2c/adv7604.c
+++ b/drivers/media/i2c/adv7604.c
@@ -3141,7 +3141,6 @@ static int adv76xx_probe(struct i2c_client *client,
 	if (ctrl)
 		ctrl->flags |= V4L2_CTRL_FLAG_VOLATILE;
 
-	/* private controls */
 	state->detect_tx_5v_ctrl = v4l2_ctrl_new_std(hdl, NULL,
 			V4L2_CID_DV_RX_POWER_PRESENT, 0,
 			(1 << state->info->num_dv_ports) - 1, 0, 0);
@@ -3164,13 +3163,6 @@ static int adv76xx_probe(struct i2c_client *client,
 		err = hdl->error;
 		goto err_hdl;
 	}
-	state->detect_tx_5v_ctrl->is_private = true;
-	state->rgb_quantization_range_ctrl->is_private = true;
-	if (adv76xx_has_afe(state))
-		state->analog_sampling_phase_ctrl->is_private = true;
-	state->free_run_color_manual_ctrl->is_private = true;
-	state->free_run_color_ctrl->is_private = true;
-
 	if (adv76xx_s_detect_tx_5v_ctrl(sd)) {
 		err = -ENODEV;
 		goto err_hdl;
diff --git a/drivers/media/i2c/adv7842.c b/drivers/media/i2c/adv7842.c
index 7ccb85d..ecaacb0 100644
--- a/drivers/media/i2c/adv7842.c
+++ b/drivers/media/i2c/adv7842.c
@@ -3300,12 +3300,6 @@ static int adv7842_probe(struct i2c_client *client,
 		err = hdl->error;
 		goto err_hdl;
 	}
-	state->detect_tx_5v_ctrl->is_private = true;
-	state->rgb_quantization_range_ctrl->is_private = true;
-	state->analog_sampling_phase_ctrl->is_private = true;
-	state->free_run_color_ctrl_manual->is_private = true;
-	state->free_run_color_ctrl->is_private = true;
-
 	if (adv7842_s_detect_tx_5v_ctrl(sd)) {
 		err = -ENODEV;
 		goto err_hdl;
-- 
2.8.0.rc3

