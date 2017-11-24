Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:39878 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752770AbdKXJeI (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 24 Nov 2017 04:34:08 -0500
Received: by mail-wm0-f68.google.com with SMTP id x63so21141839wmf.4
        for <linux-media@vger.kernel.org>; Fri, 24 Nov 2017 01:34:07 -0800 (PST)
From: Loic Poulain <loic.poulain@linaro.org>
To: stanimir.varbanov@linaro.org, mchehab@kernel.org
Cc: linux-media@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        Loic Poulain <loic.poulain@linaro.org>
Subject: [PATCH 2/2] media: venus: venc: Apply inloop deblocking filter
Date: Fri, 24 Nov 2017 10:34:02 +0100
Message-Id: <1511516042-11415-2-git-send-email-loic.poulain@linaro.org>
In-Reply-To: <1511516042-11415-1-git-send-email-loic.poulain@linaro.org>
References: <1511516042-11415-1-git-send-email-loic.poulain@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Deblocking filter allows to reduce blocking artifacts and improve
visual quality. This is configurable via the V4L2 API but eventually
not applied to the encoder.

Note that alpha and beta deblocking values are 32-bit signed (-6;+6).

Signed-off-by: Loic Poulain <loic.poulain@linaro.org>
---
 drivers/media/platform/qcom/venus/core.h       |  4 ++--
 drivers/media/platform/qcom/venus/hfi_helper.h |  4 ++--
 drivers/media/platform/qcom/venus/venc.c       | 22 ++++++++++++++++++++++
 3 files changed, 26 insertions(+), 4 deletions(-)

diff --git a/drivers/media/platform/qcom/venus/core.h b/drivers/media/platform/qcom/venus/core.h
index cba092b..4833af7 100644
--- a/drivers/media/platform/qcom/venus/core.h
+++ b/drivers/media/platform/qcom/venus/core.h
@@ -144,8 +144,8 @@ struct venc_controls {
 	u32 h264_min_qp;
 	u32 h264_max_qp;
 	u32 h264_loop_filter_mode;
-	u32 h264_loop_filter_alpha;
-	u32 h264_loop_filter_beta;
+	s32 h264_loop_filter_alpha;
+	s32 h264_loop_filter_beta;
 
 	u32 vp8_min_qp;
 	u32 vp8_max_qp;
diff --git a/drivers/media/platform/qcom/venus/hfi_helper.h b/drivers/media/platform/qcom/venus/hfi_helper.h
index 8d282db..55d8eb2 100644
--- a/drivers/media/platform/qcom/venus/hfi_helper.h
+++ b/drivers/media/platform/qcom/venus/hfi_helper.h
@@ -585,8 +585,8 @@ struct hfi_enable {
 
 struct hfi_h264_db_control {
 	u32 mode;
-	u32 slice_alpha_offset;
-	u32 slice_beta_offset;
+	s32 slice_alpha_offset;
+	s32 slice_beta_offset;
 };
 
 #define HFI_H264_ENTROPY_CAVLC			0x1
diff --git a/drivers/media/platform/qcom/venus/venc.c b/drivers/media/platform/qcom/venus/venc.c
index d5d824e..1e79f49 100644
--- a/drivers/media/platform/qcom/venus/venc.c
+++ b/drivers/media/platform/qcom/venus/venc.c
@@ -234,6 +234,16 @@ static int venc_v4l2_to_hfi(int id, int value)
 		case 3:
 			return HFI_VPX_PROFILE_VERSION_3;
 		}
+	case V4L2_CID_MPEG_VIDEO_H264_LOOP_FILTER_MODE:
+		switch (value) {
+		case V4L2_MPEG_VIDEO_H264_LOOP_FILTER_MODE_ENABLED:
+		default:
+			return HFI_H264_DB_MODE_ALL_BOUNDARY;
+		case V4L2_MPEG_VIDEO_H264_LOOP_FILTER_MODE_DISABLED:
+			return HFI_H264_DB_MODE_DISABLE;
+		case V4L2_MPEG_VIDEO_H264_LOOP_FILTER_MODE_DISABLED_AT_SLICE_BOUNDARY:
+			return HFI_H264_DB_MODE_SKIP_SLICE_BOUNDARY;
+		}
 	}
 
 	return 0;
@@ -642,6 +652,7 @@ static int venc_set_properties(struct venus_inst *inst)
 	if (inst->fmt_cap->pixfmt == V4L2_PIX_FMT_H264) {
 		struct hfi_h264_vui_timing_info info;
 		struct hfi_h264_entropy_control entropy;
+		struct hfi_h264_db_control deblock;
 
 		ptype = HFI_PROPERTY_PARAM_VENC_H264_VUI_TIMING_INFO;
 		info.enable = 1;
@@ -661,6 +672,17 @@ static int venc_set_properties(struct venus_inst *inst)
 		ret = hfi_session_set_property(inst, ptype, &entropy);
 		if (ret)
 			return ret;
+
+		ptype = HFI_PROPERTY_PARAM_VENC_H264_DEBLOCK_CONTROL;
+		deblock.mode = venc_v4l2_to_hfi(
+				      V4L2_CID_MPEG_VIDEO_H264_LOOP_FILTER_MODE,
+				      ctr->h264_loop_filter_mode);
+		deblock.slice_alpha_offset = ctr->h264_loop_filter_alpha;
+		deblock.slice_beta_offset = ctr->h264_loop_filter_beta;
+
+		ret = hfi_session_set_property(inst, ptype, &deblock);
+		if (ret)
+			return ret;
 	}
 
 	ptype = HFI_PROPERTY_CONFIG_VENC_IDR_PERIOD;
-- 
2.7.4
