Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:3865 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751350AbaIUOsu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 21 Sep 2014 10:48:50 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: pawel@osciak.com, Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFC PATCH 08/11] vivid: add test config store for the contrast control
Date: Sun, 21 Sep 2014 16:48:26 +0200
Message-Id: <1411310909-32825-9-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1411310909-32825-1-git-send-email-hverkuil@xs4all.nl>
References: <1411310909-32825-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/platform/vivid/vivid-ctrls.c   | 4 ++++
 drivers/media/platform/vivid/vivid-vid-cap.c | 1 +
 2 files changed, 5 insertions(+)

diff --git a/drivers/media/platform/vivid/vivid-ctrls.c b/drivers/media/platform/vivid/vivid-ctrls.c
index d5cbf00..42376a1 100644
--- a/drivers/media/platform/vivid/vivid-ctrls.c
+++ b/drivers/media/platform/vivid/vivid-ctrls.c
@@ -255,6 +255,9 @@ static int vivid_user_vid_s_ctrl(struct v4l2_ctrl *ctrl)
 {
 	struct vivid_dev *dev = container_of(ctrl->handler, struct vivid_dev, ctrl_hdl_user_vid);
 
+	if (ctrl->store)
+		return 0;
+
 	switch (ctrl->id) {
 	case V4L2_CID_BRIGHTNESS:
 		dev->input_brightness[dev->input] = ctrl->val - dev->input * 128;
@@ -1199,6 +1202,7 @@ int vivid_create_controls(struct vivid_dev *dev, bool show_ccs_cap,
 			dev->input_brightness[i] = 128;
 		dev->contrast = v4l2_ctrl_new_std(hdl_user_vid, &vivid_user_vid_ctrl_ops,
 			V4L2_CID_CONTRAST, 0, 255, 1, 128);
+		v4l2_ctrl_can_store(dev->contrast);
 		dev->saturation = v4l2_ctrl_new_std(hdl_user_vid, &vivid_user_vid_ctrl_ops,
 			V4L2_CID_SATURATION, 0, 255, 1, 128);
 		dev->hue = v4l2_ctrl_new_std(hdl_user_vid, &vivid_user_vid_ctrl_ops,
diff --git a/drivers/media/platform/vivid/vivid-vid-cap.c b/drivers/media/platform/vivid/vivid-vid-cap.c
index b016aed..95eda68 100644
--- a/drivers/media/platform/vivid/vivid-vid-cap.c
+++ b/drivers/media/platform/vivid/vivid-vid-cap.c
@@ -197,6 +197,7 @@ static int vid_cap_buf_prepare(struct vb2_buffer *vb)
 		vb2_set_plane_payload(vb, p, size);
 		vb->v4l2_planes[p].data_offset = dev->fmt_cap->data_offset[p];
 	}
+	v4l2_ctrl_apply_store(dev->vid_cap_dev.ctrl_handler, vb->v4l2_buf.config_store);
 
 	return 0;
 }
-- 
2.1.0

