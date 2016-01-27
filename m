Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:55758 "EHLO
	lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932368AbcA0NFS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 27 Jan 2016 08:05:18 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCHv2 5/5] adv7511: add support to for the content type control.
Date: Wed, 27 Jan 2016 14:05:03 +0100
Message-Id: <1453899903-17790-6-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1453899903-17790-1-git-send-email-hverkuil@xs4all.nl>
References: <1453899903-17790-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

This transmitter now supports configuring the IT content type of the incoming
video.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/i2c/adv7511.c | 22 ++++++++++++++++++++--
 1 file changed, 20 insertions(+), 2 deletions(-)

diff --git a/drivers/media/i2c/adv7511.c b/drivers/media/i2c/adv7511.c
index 471fd23..e0dcdb1 100644
--- a/drivers/media/i2c/adv7511.c
+++ b/drivers/media/i2c/adv7511.c
@@ -103,12 +103,14 @@ struct adv7511_state {
 	u32 ycbcr_enc;
 	u32 quantization;
 	u32 xfer_func;
+	u32 content_type;
 	/* controls */
 	struct v4l2_ctrl *hdmi_mode_ctrl;
 	struct v4l2_ctrl *hotplug_ctrl;
 	struct v4l2_ctrl *rx_sense_ctrl;
 	struct v4l2_ctrl *have_edid0_ctrl;
 	struct v4l2_ctrl *rgb_quantization_range_ctrl;
+	struct v4l2_ctrl *content_type_ctrl;
 	struct i2c_client *i2c_edid;
 	struct i2c_client *i2c_pktmem;
 	struct adv7511_state_edid edid;
@@ -400,6 +402,16 @@ static int adv7511_s_ctrl(struct v4l2_ctrl *ctrl)
 	}
 	if (state->rgb_quantization_range_ctrl == ctrl)
 		return adv7511_set_rgb_quantization_mode(sd, ctrl);
+	if (state->content_type_ctrl == ctrl) {
+		u8 itc, cn;
+
+		state->content_type = ctrl->val;
+		itc = state->content_type != V4L2_DV_CONTENT_TYPE_NO_ITC;
+		cn = itc ? state->content_type : V4L2_DV_CONTENT_TYPE_GRAPHICS;
+		adv7511_wr_and_or(sd, 0x57, 0x7f, itc << 7);
+		adv7511_wr_and_or(sd, 0x59, 0xcf, cn << 4);
+		return 0;
+	}
 
 	return -EINVAL;
 }
@@ -1002,6 +1014,8 @@ static int adv7511_set_fmt(struct v4l2_subdev *sd,
 	u8 y = HDMI_COLORSPACE_RGB;
 	u8 q = HDMI_QUANTIZATION_RANGE_DEFAULT;
 	u8 yq = HDMI_YCC_QUANTIZATION_RANGE_LIMITED;
+	u8 itc = state->content_type != V4L2_DV_CONTENT_TYPE_NO_ITC;
+	u8 cn = itc ? state->content_type : V4L2_DV_CONTENT_TYPE_GRAPHICS;
 
 	if (format->pad != 0)
 		return -EINVAL;
@@ -1115,8 +1129,8 @@ static int adv7511_set_fmt(struct v4l2_subdev *sd,
 	adv7511_wr_and_or(sd, 0x4a, 0xbf, 0);
 	adv7511_wr_and_or(sd, 0x55, 0x9f, y << 5);
 	adv7511_wr_and_or(sd, 0x56, 0x3f, c << 6);
-	adv7511_wr_and_or(sd, 0x57, 0x83, (ec << 4) | (q << 2));
-	adv7511_wr_and_or(sd, 0x59, 0x3f, yq << 6);
+	adv7511_wr_and_or(sd, 0x57, 0x83, (ec << 4) | (q << 2) | (itc << 7));
+	adv7511_wr_and_or(sd, 0x59, 0x0f, (yq << 6) | (cn << 4));
 	adv7511_wr_and_or(sd, 0x4a, 0xff, 1);
 
 	return 0;
@@ -1470,6 +1484,10 @@ static int adv7511_probe(struct i2c_client *client, const struct i2c_device_id *
 		v4l2_ctrl_new_std_menu(hdl, &adv7511_ctrl_ops,
 			V4L2_CID_DV_TX_RGB_RANGE, V4L2_DV_RGB_RANGE_FULL,
 			0, V4L2_DV_RGB_RANGE_AUTO);
+	state->content_type_ctrl =
+		v4l2_ctrl_new_std_menu(hdl, &adv7511_ctrl_ops,
+			V4L2_CID_DV_TX_CONTENT_TYPE, V4L2_DV_CONTENT_TYPE_NO_ITC,
+			0, V4L2_DV_CONTENT_TYPE_NO_ITC);
 	sd->ctrl_handler = hdl;
 	if (hdl->error) {
 		err = hdl->error;
-- 
2.7.0.rc3

