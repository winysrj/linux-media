Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:38249 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752257AbdKXJeF (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 24 Nov 2017 04:34:05 -0500
Received: by mail-wm0-f67.google.com with SMTP id 128so21175531wmo.3
        for <linux-media@vger.kernel.org>; Fri, 24 Nov 2017 01:34:05 -0800 (PST)
From: Loic Poulain <loic.poulain@linaro.org>
To: stanimir.varbanov@linaro.org, mchehab@kernel.org
Cc: linux-media@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        Loic Poulain <loic.poulain@linaro.org>
Subject: [PATCH 1/2] media: venus: venc: configure entropy mode
Date: Fri, 24 Nov 2017 10:34:01 +0100
Message-Id: <1511516042-11415-1-git-send-email-loic.poulain@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

H264 entropy mode can be selected via V4L2 API but is eventually not
applied. Configure encoder with selected mode, CALVC (def) or CABAC.

Note that hw/firmware also expects a CABAC model configuration which
currently doesn't have existing V4L2 API control. For now, use model_0
which seems always supported and so the default one.

Signed-off-by: Loic Poulain <loic.poulain@linaro.org>
---
 drivers/media/platform/qcom/venus/venc.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/media/platform/qcom/venus/venc.c b/drivers/media/platform/qcom/venus/venc.c
index 6f123a3..d5d824e 100644
--- a/drivers/media/platform/qcom/venus/venc.c
+++ b/drivers/media/platform/qcom/venus/venc.c
@@ -641,6 +641,7 @@ static int venc_set_properties(struct venus_inst *inst)
 
 	if (inst->fmt_cap->pixfmt == V4L2_PIX_FMT_H264) {
 		struct hfi_h264_vui_timing_info info;
+		struct hfi_h264_entropy_control entropy;
 
 		ptype = HFI_PROPERTY_PARAM_VENC_H264_VUI_TIMING_INFO;
 		info.enable = 1;
@@ -650,6 +651,16 @@ static int venc_set_properties(struct venus_inst *inst)
 		ret = hfi_session_set_property(inst, ptype, &info);
 		if (ret)
 			return ret;
+
+		ptype = HFI_PROPERTY_PARAM_VENC_H264_ENTROPY_CONTROL;
+		entropy.entropy_mode = venc_v4l2_to_hfi(
+					  V4L2_CID_MPEG_VIDEO_H264_ENTROPY_MODE,
+					  ctr->h264_entropy_mode);
+		entropy.cabac_model = HFI_H264_CABAC_MODEL_0;
+
+		ret = hfi_session_set_property(inst, ptype, &entropy);
+		if (ret)
+			return ret;
 	}
 
 	ptype = HFI_PROPERTY_CONFIG_VENC_IDR_PERIOD;
-- 
2.7.4
