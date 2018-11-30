Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm1-f65.google.com ([209.85.128.65]:51455 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726650AbeLAEoH (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 30 Nov 2018 23:44:07 -0500
Received: by mail-wm1-f65.google.com with SMTP id s14so6655349wmh.1
        for <linux-media@vger.kernel.org>; Fri, 30 Nov 2018 09:34:05 -0800 (PST)
From: Kelvin Lawson <klawson@lisden.com>
To: linux-media@vger.kernel.org
Cc: Kelvin Lawson <klawson@lisden.com>
Subject: [PATCH] media: venus: Add support for H265 controls required by gstreamer V4L2 H265 module
Date: Fri, 30 Nov 2018 17:31:00 +0000
Message-Id: <1543599060-3776-1-git-send-email-klawson@lisden.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add support for V4L2_CID_MPEG_VIDEO_HEVC_PROFILE and
V4L2_CID_MPEG_VIDEO_HEVC_LEVEL controls required by gstreamer V4L2 H265
encoder module.

Signed-off-by: Kelvin Lawson <klawson@lisden.com>
---
 drivers/media/platform/qcom/venus/venc_ctrls.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/drivers/media/platform/qcom/venus/venc_ctrls.c b/drivers/media/platform/qcom/venus/venc_ctrls.c
index 45910172..ad1a4d8 100644
--- a/drivers/media/platform/qcom/venus/venc_ctrls.c
+++ b/drivers/media/platform/qcom/venus/venc_ctrls.c
@@ -101,6 +101,9 @@ static int venc_op_s_ctrl(struct v4l2_ctrl *ctrl)
 	case V4L2_CID_MPEG_VIDEO_H264_PROFILE:
 		ctr->profile.h264 = ctrl->val;
 		break;
+	case V4L2_CID_MPEG_VIDEO_HEVC_PROFILE:
+		ctr->profile.hevc = ctrl->val;
+		break;
 	case V4L2_CID_MPEG_VIDEO_VP8_PROFILE:
 		ctr->profile.vpx = ctrl->val;
 		break;
@@ -110,6 +113,9 @@ static int venc_op_s_ctrl(struct v4l2_ctrl *ctrl)
 	case V4L2_CID_MPEG_VIDEO_H264_LEVEL:
 		ctr->level.h264 = ctrl->val;
 		break;
+	case V4L2_CID_MPEG_VIDEO_HEVC_LEVEL:
+		ctr->level.hevc = ctrl->val;
+		break;
 	case V4L2_CID_MPEG_VIDEO_H264_I_FRAME_QP:
 		ctr->h264_i_qp = ctrl->val;
 		break;
@@ -217,6 +223,19 @@ int venc_ctrl_init(struct venus_inst *inst)
 		0, V4L2_MPEG_VIDEO_MPEG4_LEVEL_0);
 
 	v4l2_ctrl_new_std_menu(&inst->ctrl_handler, &venc_ctrl_ops,
+		V4L2_CID_MPEG_VIDEO_HEVC_PROFILE,
+		V4L2_MPEG_VIDEO_HEVC_PROFILE_MAIN_10,
+		~((1 << V4L2_MPEG_VIDEO_HEVC_PROFILE_MAIN) |
+		  (1 << V4L2_MPEG_VIDEO_HEVC_PROFILE_MAIN_STILL_PICTURE) |
+		  (1 << V4L2_MPEG_VIDEO_HEVC_PROFILE_MAIN_10)),
+		V4L2_MPEG_VIDEO_HEVC_PROFILE_MAIN);
+
+	v4l2_ctrl_new_std_menu(&inst->ctrl_handler, &venc_ctrl_ops,
+		V4L2_CID_MPEG_VIDEO_HEVC_LEVEL,
+		V4L2_MPEG_VIDEO_HEVC_LEVEL_6_2,
+		0, V4L2_MPEG_VIDEO_HEVC_LEVEL_1);
+
+	v4l2_ctrl_new_std_menu(&inst->ctrl_handler, &venc_ctrl_ops,
 		V4L2_CID_MPEG_VIDEO_H264_PROFILE,
 		V4L2_MPEG_VIDEO_H264_PROFILE_MULTIVIEW_HIGH,
 		~((1 << V4L2_MPEG_VIDEO_H264_PROFILE_BASELINE) |
-- 
2.7.4
