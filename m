Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:54915 "EHLO
	lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932571AbcA0Nb6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 27 Jan 2016 08:31:58 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCHv3 4/5] adv7842: add support to for the content type control.
Date: Wed, 27 Jan 2016 14:31:42 +0100
Message-Id: <1453901503-35473-5-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1453901503-35473-1-git-send-email-hverkuil@xs4all.nl>
References: <1453901503-35473-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

This receiver now supports reading the IT content type of the incoming
video.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/i2c/adv7842.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/drivers/media/i2c/adv7842.c b/drivers/media/i2c/adv7842.c
index 5fbb788..7ccb85d 100644
--- a/drivers/media/i2c/adv7842.c
+++ b/drivers/media/i2c/adv7842.c
@@ -1359,6 +1359,19 @@ static int adv7842_s_ctrl(struct v4l2_ctrl *ctrl)
 	return -EINVAL;
 }
 
+static int adv7842_g_volatile_ctrl(struct v4l2_ctrl *ctrl)
+{
+	struct v4l2_subdev *sd = to_sd(ctrl);
+
+	if (ctrl->id == V4L2_CID_DV_RX_IT_CONTENT_TYPE) {
+		ctrl->val = V4L2_DV_IT_CONTENT_TYPE_NO_ITC;
+		if ((io_read(sd, 0x60) & 1) && (infoframe_read(sd, 0x03) & 0x80))
+			ctrl->val = (infoframe_read(sd, 0x05) >> 4) & 3;
+		return 0;
+	}
+	return -EINVAL;
+}
+
 static inline bool no_power(struct v4l2_subdev *sd)
 {
 	return io_read(sd, 0x0c) & 0x24;
@@ -3022,6 +3035,7 @@ static int adv7842_subscribe_event(struct v4l2_subdev *sd,
 
 static const struct v4l2_ctrl_ops adv7842_ctrl_ops = {
 	.s_ctrl = adv7842_s_ctrl,
+	.g_volatile_ctrl = adv7842_g_volatile_ctrl,
 };
 
 static const struct v4l2_subdev_core_ops adv7842_core_ops = {
@@ -3196,6 +3210,7 @@ static int adv7842_probe(struct i2c_client *client,
 		V4L2_DV_BT_CEA_640X480P59_94;
 	struct adv7842_platform_data *pdata = client->dev.platform_data;
 	struct v4l2_ctrl_handler *hdl;
+	struct v4l2_ctrl *ctrl;
 	struct v4l2_subdev *sd;
 	u16 rev;
 	int err;
@@ -3261,6 +3276,11 @@ static int adv7842_probe(struct i2c_client *client,
 			  V4L2_CID_SATURATION, 0, 255, 1, 128);
 	v4l2_ctrl_new_std(hdl, &adv7842_ctrl_ops,
 			  V4L2_CID_HUE, 0, 128, 1, 0);
+	ctrl = v4l2_ctrl_new_std_menu(hdl, &adv7842_ctrl_ops,
+			V4L2_CID_DV_RX_IT_CONTENT_TYPE, V4L2_DV_IT_CONTENT_TYPE_NO_ITC,
+			0, V4L2_DV_IT_CONTENT_TYPE_NO_ITC);
+	if (ctrl)
+		ctrl->flags |= V4L2_CTRL_FLAG_VOLATILE;
 
 	/* custom controls */
 	state->detect_tx_5v_ctrl = v4l2_ctrl_new_std(hdl, NULL,
-- 
2.7.0.rc3

