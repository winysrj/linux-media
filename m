Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:53501 "EHLO
	lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932139AbcA0NFQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 27 Jan 2016 08:05:16 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCHv2 3/5] adv7604: add support to for the content type control.
Date: Wed, 27 Jan 2016 14:05:01 +0100
Message-Id: <1453899903-17790-4-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1453899903-17790-1-git-send-email-hverkuil@xs4all.nl>
References: <1453899903-17790-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

This receiver now supports reading the IT content type of the incoming
video.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/i2c/adv7604.c | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/drivers/media/i2c/adv7604.c b/drivers/media/i2c/adv7604.c
index f8dd750..249fe14 100644
--- a/drivers/media/i2c/adv7604.c
+++ b/drivers/media/i2c/adv7604.c
@@ -1216,6 +1216,20 @@ static int adv76xx_s_ctrl(struct v4l2_ctrl *ctrl)
 	return -EINVAL;
 }
 
+static int adv76xx_g_volatile_ctrl(struct v4l2_ctrl *ctrl)
+{
+	struct v4l2_subdev *sd =
+		&container_of(ctrl->handler, struct adv76xx_state, hdl)->sd;
+
+	if (ctrl->id == V4L2_CID_DV_RX_CONTENT_TYPE) {
+		ctrl->val = V4L2_DV_CONTENT_TYPE_NO_ITC;
+		if ((io_read(sd, 0x60) & 1) && (infoframe_read(sd, 0x03) & 0x80))
+			ctrl->val = (infoframe_read(sd, 0x05) >> 4) & 3;
+		return 0;
+	}
+	return -EINVAL;
+}
+
 /* ----------------------------------------------------------------------- */
 
 static inline bool no_power(struct v4l2_subdev *sd)
@@ -2381,6 +2395,7 @@ static int adv76xx_subscribe_event(struct v4l2_subdev *sd,
 
 static const struct v4l2_ctrl_ops adv76xx_ctrl_ops = {
 	.s_ctrl = adv76xx_s_ctrl,
+	.g_volatile_ctrl = adv76xx_g_volatile_ctrl,
 };
 
 static const struct v4l2_subdev_core_ops adv76xx_core_ops = {
@@ -3010,6 +3025,7 @@ static int adv76xx_probe(struct i2c_client *client,
 		V4L2_DV_BT_CEA_640X480P59_94;
 	struct adv76xx_state *state;
 	struct v4l2_ctrl_handler *hdl;
+	struct v4l2_ctrl *ctrl;
 	struct v4l2_subdev *sd;
 	unsigned int i;
 	unsigned int val, val2;
@@ -3141,6 +3157,11 @@ static int adv76xx_probe(struct i2c_client *client,
 			V4L2_CID_SATURATION, 0, 255, 1, 128);
 	v4l2_ctrl_new_std(hdl, &adv76xx_ctrl_ops,
 			V4L2_CID_HUE, 0, 128, 1, 0);
+	ctrl = v4l2_ctrl_new_std_menu(hdl, &adv76xx_ctrl_ops,
+			V4L2_CID_DV_RX_CONTENT_TYPE, V4L2_DV_CONTENT_TYPE_NO_ITC,
+			0, V4L2_DV_CONTENT_TYPE_NO_ITC);
+	if (ctrl)
+		ctrl->flags |= V4L2_CTRL_FLAG_VOLATILE;
 
 	/* private controls */
 	state->detect_tx_5v_ctrl = v4l2_ctrl_new_std(hdl, NULL,
-- 
2.7.0.rc3

