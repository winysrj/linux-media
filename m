Return-path: <linux-media-owner@vger.kernel.org>
Received: from alexa-out-blr-01.qualcomm.com ([103.229.18.197]:4626 "EHLO
        alexa-out-blr-01.qualcomm.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726285AbeJXWVA (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 24 Oct 2018 18:21:00 -0400
From: Malathi Gottam <mgottam@codeaurora.org>
To: stanimir.varbanov@linaro.org, hverkuil@xs4all.nl,
        mchehab@kernel.org
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, acourbot@chromium.org,
        vgarodia@codeaurora.org, mgottam@codeaurora.org
Subject: [PATCH v2] media: venus: add support for key frame
Date: Wed, 24 Oct 2018 19:22:42 +0530
Message-Id: <1540389162-30358-1-git-send-email-mgottam@codeaurora.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When client requests for a keyframe, set the property
to hardware to generate the sync frame.

Signed-off-by: Malathi Gottam <mgottam@codeaurora.org>
---
 drivers/media/platform/qcom/venus/venc_ctrls.c | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/qcom/venus/venc_ctrls.c b/drivers/media/platform/qcom/venus/venc_ctrls.c
index 45910172..6c2655d 100644
--- a/drivers/media/platform/qcom/venus/venc_ctrls.c
+++ b/drivers/media/platform/qcom/venus/venc_ctrls.c
@@ -79,8 +79,10 @@ static int venc_op_s_ctrl(struct v4l2_ctrl *ctrl)
 {
 	struct venus_inst *inst = ctrl_to_inst(ctrl);
 	struct venc_controls *ctr = &inst->controls.enc;
+	struct hfi_enable en = { .enable = 1 };
 	u32 bframes;
 	int ret;
+	u32 ptype;
 
 	switch (ctrl->id) {
 	case V4L2_CID_MPEG_VIDEO_BITRATE_MODE:
@@ -173,6 +175,15 @@ static int venc_op_s_ctrl(struct v4l2_ctrl *ctrl)
 
 		ctr->num_b_frames = bframes;
 		break;
+	case V4L2_CID_MPEG_VIDEO_FORCE_KEY_FRAME:
+		if (inst->streamon_out && inst->streamon_cap) {
+			ptype = HFI_PROPERTY_CONFIG_VENC_REQUEST_SYNC_FRAME;
+			ret = hfi_session_set_property(inst, ptype, &en);
+
+			if (ret)
+				return ret;
+		}
+		break;
 	default:
 		return -EINVAL;
 	}
@@ -188,7 +199,7 @@ int venc_ctrl_init(struct venus_inst *inst)
 {
 	int ret;
 
-	ret = v4l2_ctrl_handler_init(&inst->ctrl_handler, 27);
+	ret = v4l2_ctrl_handler_init(&inst->ctrl_handler, 28);
 	if (ret)
 		return ret;
 
@@ -309,6 +320,9 @@ int venc_ctrl_init(struct venus_inst *inst)
 	v4l2_ctrl_new_std(&inst->ctrl_handler, &venc_ctrl_ops,
 		V4L2_CID_MPEG_VIDEO_H264_I_PERIOD, 0, (1 << 16) - 1, 1, 0);
 
+	v4l2_ctrl_new_std(&inst->ctrl_handler, &venc_ctrl_ops,
+			  V4L2_CID_MPEG_VIDEO_FORCE_KEY_FRAME, 0, 0, 0, 0);
+
 	ret = inst->ctrl_handler.error;
 	if (ret)
 		goto err;
-- 
1.9.1
