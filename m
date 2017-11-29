Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f195.google.com ([209.85.128.195]:43193 "EHLO
        mail-wr0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753433AbdK2NZx (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 29 Nov 2017 08:25:53 -0500
Received: by mail-wr0-f195.google.com with SMTP id z34so3377886wrz.10
        for <linux-media@vger.kernel.org>; Wed, 29 Nov 2017 05:25:52 -0800 (PST)
From: Stanimir Varbanov <stanimir.varbanov@linaro.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>
Subject: [PATCH 2/2] venus: venc: set correctly GOP size and number of B-frames
Date: Wed, 29 Nov 2017 15:25:22 +0200
Message-Id: <20171129132522.9140-2-stanimir.varbanov@linaro.org>
In-Reply-To: <20171129132522.9140-1-stanimir.varbanov@linaro.org>
References: <20171129132522.9140-1-stanimir.varbanov@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This change fixes the calculation of B-frames and GOP size by
adopt v4l2 controls with the firmware interface expectations.

Signed-off-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>
---
 drivers/media/platform/qcom/venus/venc.c       | 15 ++++---
 drivers/media/platform/qcom/venus/venc_ctrls.c | 60 +++++++++++++++++++++++++-
 2 files changed, 69 insertions(+), 6 deletions(-)

diff --git a/drivers/media/platform/qcom/venus/venc.c b/drivers/media/platform/qcom/venus/venc.c
index 36d31540c59d..e3a10a852cad 100644
--- a/drivers/media/platform/qcom/venus/venc.c
+++ b/drivers/media/platform/qcom/venus/venc.c
@@ -685,8 +685,13 @@ static int venc_set_properties(struct venus_inst *inst)
 			return ret;
 	}
 
+	/* IDR periodicity, n:
+	 * n = 0 - only the first I-frame is IDR frame
+	 * n = 1 - all I-frames will be IDR frames
+	 * n > 1 - every n-th I-frame will be IDR frame
+	 */
 	ptype = HFI_PROPERTY_CONFIG_VENC_IDR_PERIOD;
-	idrp.idr_period = ctr->gop_size;
+	idrp.idr_period = 0;
 	ret = hfi_session_set_property(inst, ptype, &idrp);
 	if (ret)
 		return ret;
@@ -700,10 +705,6 @@ static int venc_set_properties(struct venus_inst *inst)
 			return ret;
 	}
 
-	/* intra_period = pframes + bframes + 1 */
-	if (!ctr->num_p_frames)
-		ctr->num_p_frames = 2 * 15 - 1,
-
 	ptype = HFI_PROPERTY_CONFIG_VENC_INTRA_PERIOD;
 	intra_period.pframes = ctr->num_p_frames;
 	intra_period.bframes = ctr->num_b_frames;
@@ -800,6 +801,10 @@ static int venc_init_session(struct venus_inst *inst)
 	if (ret)
 		goto deinit;
 
+	ret = venc_set_properties(inst);
+	if (ret)
+		goto deinit;
+
 	return 0;
 deinit:
 	hfi_session_deinit(inst);
diff --git a/drivers/media/platform/qcom/venus/venc_ctrls.c b/drivers/media/platform/qcom/venus/venc_ctrls.c
index ab0fe51ff0f7..53130d4774d3 100644
--- a/drivers/media/platform/qcom/venus/venc_ctrls.c
+++ b/drivers/media/platform/qcom/venus/venc_ctrls.c
@@ -30,10 +30,58 @@
 #define AT_SLICE_BOUNDARY	\
 	V4L2_MPEG_VIDEO_H264_LOOP_FILTER_MODE_DISABLED_AT_SLICE_BOUNDARY
 
+static int venc_calc_bpframes(u32 gop_size, u32 conseq_b, u32 *bf, u32 *pf)
+{
+	uint32_t half = (gop_size - 1) >> 1;
+	uint32_t b, p, ratio;
+	bool found = false;
+
+	if (!gop_size)
+		return -EINVAL;
+
+	*bf = *pf = 0;
+
+	if (!conseq_b) {
+		*pf = gop_size -  1;
+		return 0;
+	}
+
+	b = p = half;
+
+	for (; b <= gop_size - 1; b++, p--) {
+		if (b % p)
+			continue;
+
+		ratio = b;
+		do_div(ratio, p);
+
+		if (ratio == conseq_b) {
+			found = true;
+			break;
+		}
+
+		if (ratio > conseq_b)
+			break;
+	}
+
+	if (found == false)
+		return -EINVAL;
+
+	if (b + p + 1 != gop_size)
+		return -EINVAL;
+
+	*bf = b;
+	*pf = p;
+
+	return 0;
+}
+
 static int venc_op_s_ctrl(struct v4l2_ctrl *ctrl)
 {
 	struct venus_inst *inst = ctrl_to_inst(ctrl);
 	struct venc_controls *ctr = &inst->controls.enc;
+	u32 bframes;
+	int ret;
 
 	switch (ctrl->id) {
 	case V4L2_CID_MPEG_VIDEO_BITRATE_MODE:
@@ -102,6 +150,11 @@ static int venc_op_s_ctrl(struct v4l2_ctrl *ctrl)
 	case V4L2_CID_MPEG_VIDEO_CYCLIC_INTRA_REFRESH_MB:
 		break;
 	case V4L2_CID_MPEG_VIDEO_GOP_SIZE:
+		ret = venc_calc_bpframes(ctrl->val, ctr->num_b_frames, &bframes,
+					 &ctr->num_p_frames);
+		if (ret)
+			return ret;
+
 		ctr->gop_size = ctrl->val;
 		break;
 	case V4L2_CID_MPEG_VIDEO_H264_I_PERIOD:
@@ -114,7 +167,12 @@ static int venc_op_s_ctrl(struct v4l2_ctrl *ctrl)
 		ctr->vp8_max_qp = ctrl->val;
 		break;
 	case V4L2_CID_MPEG_VIDEO_B_FRAMES:
-		ctr->num_b_frames = ctrl->val;
+		ret = venc_calc_bpframes(ctr->gop_size, ctrl->val, &bframes,
+					 &ctr->num_p_frames);
+		if (ret)
+			return ret;
+
+		ctr->num_b_frames = bframes;
 		break;
 	default:
 		return -EINVAL;
-- 
2.11.0
