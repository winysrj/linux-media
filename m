Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr1-f67.google.com ([209.85.221.67]:34478 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726393AbeK3LPB (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 30 Nov 2018 06:15:01 -0500
Received: by mail-wr1-f67.google.com with SMTP id j2so3638519wrw.1
        for <linux-media@vger.kernel.org>; Thu, 29 Nov 2018 16:07:42 -0800 (PST)
From: Kelvin Lawson <klawson@lisden.com>
To: linux-media@vger.kernel.org, stanimir.varbanov@linaro.org
Cc: Kelvin Lawson <klawson@lisden.com>
Subject: [PATCH v2] media: venus: Support V4L2 QP parameters in Venus encoder
Date: Fri, 30 Nov 2018 00:07:28 +0000
Message-Id: <1543536448-16442-1-git-send-email-klawson@lisden.com>
In-Reply-To: <96b0d248-8719-e637-63f7-3468948f1c78@linaro.org>
References: <96b0d248-8719-e637-63f7-3468948f1c78@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Support V4L2 QP parameters in Venus encoder:
 * V4L2_CID_MPEG_VIDEO_H264_I_FRAME_QP
 * V4L2_CID_MPEG_VIDEO_H264_B_FRAME_QP
 * V4L2_CID_MPEG_VIDEO_H264_MIN_QP
 * V4L2_CID_MPEG_VIDEO_H264_MAX_QP

Signed-off-by: Kelvin Lawson <klawson@lisden.com>
---
 drivers/media/platform/qcom/venus/venc.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/drivers/media/platform/qcom/venus/venc.c b/drivers/media/platform/qcom/venus/venc.c
index 41249d1..15deba7 100644
--- a/drivers/media/platform/qcom/venus/venc.c
+++ b/drivers/media/platform/qcom/venus/venc.c
@@ -651,6 +651,8 @@ static int venc_set_properties(struct venus_inst *inst)
 	struct hfi_framerate frate;
 	struct hfi_bitrate brate;
 	struct hfi_idr_period idrp;
+	struct hfi_quantization quant;
+	struct hfi_quantization_range quant_range;
 	u32 ptype, rate_control, bitrate, profile = 0, level = 0;
 	int ret;
 
@@ -770,6 +772,23 @@ static int venc_set_properties(struct venus_inst *inst)
 	if (ret)
 		return ret;
 
+	ptype = HFI_PROPERTY_PARAM_VENC_SESSION_QP;
+	quant.qp_i = ctr->h264_i_qp;
+	quant.qp_p = ctr->h264_p_qp;
+	quant.qp_b = ctr->h264_b_qp;
+	quant.layer_id = 0;
+	ret = hfi_session_set_property(inst, ptype, &quant);
+	if (ret)
+		return ret;
+
+	ptype = HFI_PROPERTY_PARAM_VENC_SESSION_QP_RANGE;
+	quant_range.min_qp = ctr->h264_min_qp;
+	quant_range.max_qp = ctr->h264_max_qp;
+	quant_range.layer_id = 0;
+	ret = hfi_session_set_property(inst, ptype, &quant_range);
+	if (ret)
+		return ret;
+
 	if (inst->fmt_cap->pixfmt == V4L2_PIX_FMT_H264) {
 		profile = venc_v4l2_to_hfi(V4L2_CID_MPEG_VIDEO_H264_PROFILE,
 					   ctr->profile.h264);
-- 
2.7.4
