Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr1.xs4all.nl ([194.109.24.21]:1794 "EHLO
	smtp-vbr1.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752284Ab3HVK1l (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 22 Aug 2013 06:27:41 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: marbugge@cisco.com, matrandg@cisco.com,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv3 PATCH 1/5] adv7604: set is_private only after successfully creating all controls
Date: Thu, 22 Aug 2013 12:27:26 +0200
Message-Id: <649dbb2a170c401618608d53b9c485396defb683.1377167031.git.hans.verkuil@cisco.com>
In-Reply-To: <1377167250-27589-1-git-send-email-hverkuil@xs4all.nl>
References: <1377167250-27589-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

is_private was set right after creating each control, but the control pointer
might be NULL in case of an error. Set it after all controls were successfully
created, since that guarantees that all control pointers are non-NULL.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/i2c/adv7604.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/media/i2c/adv7604.c b/drivers/media/i2c/adv7604.c
index 5b54ba1..fbfdd2f 100644
--- a/drivers/media/i2c/adv7604.c
+++ b/drivers/media/i2c/adv7604.c
@@ -2021,29 +2021,30 @@ static int adv7604_probe(struct i2c_client *client,
 	/* private controls */
 	state->detect_tx_5v_ctrl = v4l2_ctrl_new_std(hdl, NULL,
 			V4L2_CID_DV_RX_POWER_PRESENT, 0, 1, 0, 0);
-	state->detect_tx_5v_ctrl->is_private = true;
 	state->rgb_quantization_range_ctrl =
 		v4l2_ctrl_new_std_menu(hdl, &adv7604_ctrl_ops,
 			V4L2_CID_DV_RX_RGB_RANGE, V4L2_DV_RGB_RANGE_FULL,
 			0, V4L2_DV_RGB_RANGE_AUTO);
-	state->rgb_quantization_range_ctrl->is_private = true;
 
 	/* custom controls */
 	state->analog_sampling_phase_ctrl =
 		v4l2_ctrl_new_custom(hdl, &adv7604_ctrl_analog_sampling_phase, NULL);
-	state->analog_sampling_phase_ctrl->is_private = true;
 	state->free_run_color_manual_ctrl =
 		v4l2_ctrl_new_custom(hdl, &adv7604_ctrl_free_run_color_manual, NULL);
-	state->free_run_color_manual_ctrl->is_private = true;
 	state->free_run_color_ctrl =
 		v4l2_ctrl_new_custom(hdl, &adv7604_ctrl_free_run_color, NULL);
-	state->free_run_color_ctrl->is_private = true;
 
 	sd->ctrl_handler = hdl;
 	if (hdl->error) {
 		err = hdl->error;
 		goto err_hdl;
 	}
+	state->detect_tx_5v_ctrl->is_private = true;
+	state->rgb_quantization_range_ctrl->is_private = true;
+	state->analog_sampling_phase_ctrl->is_private = true;
+	state->free_run_color_manual_ctrl->is_private = true;
+	state->free_run_color_ctrl->is_private = true;
+
 	if (adv7604_s_detect_tx_5v_ctrl(sd)) {
 		err = -ENODEV;
 		goto err_hdl;
-- 
1.8.3.2

