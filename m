Return-path: <linux-media-owner@vger.kernel.org>
Received: from alexa-out-blr-02.qualcomm.com ([103.229.18.198]:17695 "EHLO
        alexa-out-blr.qualcomm.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726104AbeKBVuZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 2 Nov 2018 17:50:25 -0400
From: Malathi Gottam <mgottam@codeaurora.org>
To: stanimir.varbanov@linaro.org, hverkuil@xs4all.nl,
        mchehab@kernel.org
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, acourbot@chromium.org,
        vgarodia@codeaurora.org, mgottam@codeaurora.org
Subject: [PATCH v2] media: venus: dynamic handling of bitrate
Date: Fri,  2 Nov 2018 18:11:16 +0530
Message-Id: <1541162476-20770-1-git-send-email-mgottam@codeaurora.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Any request for a change in bitrate after both planes
are streamed on is handled by setting the target bitrate
property to hardware.

Signed-off-by: Malathi Gottam <mgottam@codeaurora.org>
---
 drivers/media/platform/qcom/venus/venc_ctrls.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/drivers/media/platform/qcom/venus/venc_ctrls.c b/drivers/media/platform/qcom/venus/venc_ctrls.c
index 45910172..f90a34e 100644
--- a/drivers/media/platform/qcom/venus/venc_ctrls.c
+++ b/drivers/media/platform/qcom/venus/venc_ctrls.c
@@ -79,7 +79,9 @@ static int venc_op_s_ctrl(struct v4l2_ctrl *ctrl)
 {
 	struct venus_inst *inst = ctrl_to_inst(ctrl);
 	struct venc_controls *ctr = &inst->controls.enc;
+	struct hfi_bitrate brate;
 	u32 bframes;
+	u32 ptype;
 	int ret;
 
 	switch (ctrl->id) {
@@ -88,6 +90,19 @@ static int venc_op_s_ctrl(struct v4l2_ctrl *ctrl)
 		break;
 	case V4L2_CID_MPEG_VIDEO_BITRATE:
 		ctr->bitrate = ctrl->val;
+		mutex_lock(&inst->lock);
+		if (inst->streamon_out && inst->streamon_cap) {
+			ptype = HFI_PROPERTY_CONFIG_VENC_TARGET_BITRATE;
+			brate.bitrate = ctr->bitrate;
+			brate.layer_id = 0;
+
+			ret = hfi_session_set_property(inst, ptype, &brate);
+			if (ret) {
+				mutex_unlock(&inst->lock);
+				return ret;
+			}
+		}
+		mutex_unlock(&inst->lock);
 		break;
 	case V4L2_CID_MPEG_VIDEO_BITRATE_PEAK:
 		ctr->bitrate_peak = ctrl->val;
-- 
1.9.1
