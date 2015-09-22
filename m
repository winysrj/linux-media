Return-path: <linux-media-owner@vger.kernel.org>
Received: from bgl-iport-3.cisco.com ([72.163.197.27]:38895 "EHLO
	bgl-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757518AbbIVO1e (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Sep 2015 10:27:34 -0400
From: Prashant Laddha <prladdha@cisco.com>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Prashant Laddha <prladdha@cisco.com>
Subject: [RFC v2 3/4] vivid-capture: add control for reduced frame rate
Date: Tue, 22 Sep 2015 19:57:30 +0530
Message-Id: <1442932051-24972-4-git-send-email-prladdha@cisco.com>
In-Reply-To: <1442932051-24972-1-git-send-email-prladdha@cisco.com>
References: <1442932051-24972-1-git-send-email-prladdha@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

A boolean control Reduced Framerate is added to vivid controls for
controlling the reduced fps option for vivid capture from gui.

Cc: Hans Verkuil <hans.verkuil@cisco.com>
Signed-off-by: Prashant Laddha <prladdha@cisco.com>
---
 drivers/media/platform/vivid/vivid-core.h  |  1 +
 drivers/media/platform/vivid/vivid-ctrls.c | 15 +++++++++++++++
 2 files changed, 16 insertions(+)

diff --git a/drivers/media/platform/vivid/vivid-core.h b/drivers/media/platform/vivid/vivid-core.h
index c72349c..4a2c8b7 100644
--- a/drivers/media/platform/vivid/vivid-core.h
+++ b/drivers/media/platform/vivid/vivid-core.h
@@ -263,6 +263,7 @@ struct vivid_dev {
 	bool				vflip;
 	bool				vbi_cap_interlaced;
 	bool				loop_video;
+	bool				reduced_fps;
 
 	/* Framebuffer */
 	unsigned long			video_pbase;
diff --git a/drivers/media/platform/vivid/vivid-ctrls.c b/drivers/media/platform/vivid/vivid-ctrls.c
index 339c8b7..30d472a 100644
--- a/drivers/media/platform/vivid/vivid-ctrls.c
+++ b/drivers/media/platform/vivid/vivid-ctrls.c
@@ -78,6 +78,7 @@
 #define VIVID_CID_TIME_WRAP		(VIVID_CID_VIVID_BASE + 39)
 #define VIVID_CID_MAX_EDID_BLOCKS	(VIVID_CID_VIVID_BASE + 40)
 #define VIVID_CID_PERCENTAGE_FILL	(VIVID_CID_VIVID_BASE + 41)
+#define VIVID_CID_REDUCED_FPS		(VIVID_CID_VIVID_BASE + 42)
 
 #define VIVID_CID_STD_SIGNAL_MODE	(VIVID_CID_VIVID_BASE + 60)
 #define VIVID_CID_STANDARD		(VIVID_CID_VIVID_BASE + 61)
@@ -422,6 +423,10 @@ static int vivid_vid_cap_s_ctrl(struct v4l2_ctrl *ctrl)
 		dev->sensor_vflip = ctrl->val;
 		tpg_s_vflip(&dev->tpg, dev->sensor_vflip ^ dev->vflip);
 		break;
+	case VIVID_CID_REDUCED_FPS:
+		dev->reduced_fps = ctrl->val;
+		vivid_update_format_cap(dev, true);
+		break;
 	case VIVID_CID_HAS_CROP_CAP:
 		dev->has_crop_cap = ctrl->val;
 		vivid_update_format_cap(dev, true);
@@ -599,6 +604,15 @@ static const struct v4l2_ctrl_config vivid_ctrl_vflip = {
 	.step = 1,
 };
 
+static const struct v4l2_ctrl_config vivid_ctrl_reduced_fps = {
+	.ops = &vivid_vid_cap_ctrl_ops,
+	.id = VIVID_CID_REDUCED_FPS,
+	.name = "Reduced Framerate",
+	.type = V4L2_CTRL_TYPE_BOOLEAN,
+	.max = 1,
+	.step = 1,
+};
+
 static const struct v4l2_ctrl_config vivid_ctrl_has_crop_cap = {
 	.ops = &vivid_vid_cap_ctrl_ops,
 	.id = VIVID_CID_HAS_CROP_CAP,
@@ -1379,6 +1393,7 @@ int vivid_create_controls(struct vivid_dev *dev, bool show_ccs_cap,
 		v4l2_ctrl_new_custom(hdl_vid_cap, &vivid_ctrl_vflip, NULL);
 		v4l2_ctrl_new_custom(hdl_vid_cap, &vivid_ctrl_insert_sav, NULL);
 		v4l2_ctrl_new_custom(hdl_vid_cap, &vivid_ctrl_insert_eav, NULL);
+		v4l2_ctrl_new_custom(hdl_vid_cap, &vivid_ctrl_reduced_fps, NULL);
 		if (show_ccs_cap) {
 			dev->ctrl_has_crop_cap = v4l2_ctrl_new_custom(hdl_vid_cap,
 				&vivid_ctrl_has_crop_cap, NULL);
-- 
1.9.1

