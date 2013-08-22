Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:1226 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752316Ab3HVK1m (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 22 Aug 2013 06:27:42 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: marbugge@cisco.com, matrandg@cisco.com,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv3 PATCH 2/5] ad9389b: set is_private only after successfully creating all controls
Date: Thu, 22 Aug 2013 12:27:27 +0200
Message-Id: <51abd61e57d6a0b2c756dac3c3a96c5638a1d041.1377167031.git.hans.verkuil@cisco.com>
In-Reply-To: <1377167250-27589-1-git-send-email-hverkuil@xs4all.nl>
References: <1377167250-27589-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <649dbb2a170c401618608d53b9c485396defb683.1377167031.git.hans.verkuil@cisco.com>
References: <649dbb2a170c401618608d53b9c485396defb683.1377167031.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

is_private was set right after creating each control, but the control pointer
might be NULL in case of an error. Set it after all controls were successfully
created, since that guarantees that all control pointers are non-NULL.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/i2c/ad9389b.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/media/i2c/ad9389b.c b/drivers/media/i2c/ad9389b.c
index 8369786..bb0c99d 100644
--- a/drivers/media/i2c/ad9389b.c
+++ b/drivers/media/i2c/ad9389b.c
@@ -1109,27 +1109,27 @@ static int ad9389b_probe(struct i2c_client *client, const struct i2c_device_id *
 	state->hdmi_mode_ctrl = v4l2_ctrl_new_std_menu(hdl, &ad9389b_ctrl_ops,
 			V4L2_CID_DV_TX_MODE, V4L2_DV_TX_MODE_HDMI,
 			0, V4L2_DV_TX_MODE_DVI_D);
-	state->hdmi_mode_ctrl->is_private = true;
 	state->hotplug_ctrl = v4l2_ctrl_new_std(hdl, NULL,
 			V4L2_CID_DV_TX_HOTPLUG, 0, 1, 0, 0);
-	state->hotplug_ctrl->is_private = true;
 	state->rx_sense_ctrl = v4l2_ctrl_new_std(hdl, NULL,
 			V4L2_CID_DV_TX_RXSENSE, 0, 1, 0, 0);
-	state->rx_sense_ctrl->is_private = true;
 	state->have_edid0_ctrl = v4l2_ctrl_new_std(hdl, NULL,
 			V4L2_CID_DV_TX_EDID_PRESENT, 0, 1, 0, 0);
-	state->have_edid0_ctrl->is_private = true;
 	state->rgb_quantization_range_ctrl =
 		v4l2_ctrl_new_std_menu(hdl, &ad9389b_ctrl_ops,
 			V4L2_CID_DV_TX_RGB_RANGE, V4L2_DV_RGB_RANGE_FULL,
 			0, V4L2_DV_RGB_RANGE_AUTO);
-	state->rgb_quantization_range_ctrl->is_private = true;
 	sd->ctrl_handler = hdl;
 	if (hdl->error) {
 		err = hdl->error;
 
 		goto err_hdl;
 	}
+	state->hdmi_mode_ctrl->is_private = true;
+	state->hotplug_ctrl->is_private = true;
+	state->rx_sense_ctrl->is_private = true;
+	state->have_edid0_ctrl->is_private = true;
+	state->rgb_quantization_range_ctrl->is_private = true;
 
 	state->pad.flags = MEDIA_PAD_FL_SINK;
 	err = media_entity_init(&sd->entity, 1, &state->pad, 0);
-- 
1.8.3.2

