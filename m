Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:53114 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728101AbeI2S3G (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 29 Sep 2018 14:29:06 -0400
From: Srinu Gorle <sgorle@codeaurora.org>
To: stanimir.varbanov@linaro.org, hverkuil@xs4all.nl,
        mchehab@kernel.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        sgorle@codeaurora.org
Cc: acourbot@chromium.org, vgarodia@codeaurora.org
Subject: [PATCH v1 2/5] media: venus: dynamically configure codec type
Date: Sat, 29 Sep 2018 17:30:29 +0530
Message-Id: <1538222432-25894-3-git-send-email-sgorle@codeaurora.org>
In-Reply-To: <1538222432-25894-1-git-send-email-sgorle@codeaurora.org>
References: <1538222432-25894-1-git-send-email-sgorle@codeaurora.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

- currently video decoder instance is hardcoded to H.264 video format.
- this change enables video decoder dynamically configure to
  any supported video format.

Signed-off-by: Srinu Gorle <sgorle@codeaurora.org>
---
 drivers/media/platform/qcom/venus/helpers.c | 51 ++++++++++++++---------------
 drivers/media/platform/qcom/venus/helpers.h |  1 +
 drivers/media/platform/qcom/venus/vdec.c    |  2 ++
 3 files changed, 27 insertions(+), 27 deletions(-)

diff --git a/drivers/media/platform/qcom/venus/helpers.c b/drivers/media/platform/qcom/venus/helpers.c
index 822a853..c82dbac 100644
--- a/drivers/media/platform/qcom/venus/helpers.c
+++ b/drivers/media/platform/qcom/venus/helpers.c
@@ -36,47 +36,44 @@ struct intbuf {
 	unsigned long attrs;
 };
 
-bool venus_helper_check_codec(struct venus_inst *inst, u32 v4l2_pixfmt)
+u32 v4l2_venus_fmt(u32 pixfmt)
 {
-	struct venus_core *core = inst->core;
-	u32 session_type = inst->session_type;
-	u32 codec;
-
-	switch (v4l2_pixfmt) {
+	switch (pixfmt) {
 	case V4L2_PIX_FMT_H264:
-		codec = HFI_VIDEO_CODEC_H264;
-		break;
+	case V4L2_PIX_FMT_H264_NO_SC:
+		return HFI_VIDEO_CODEC_H264;
 	case V4L2_PIX_FMT_H263:
-		codec = HFI_VIDEO_CODEC_H263;
-		break;
+		return HFI_VIDEO_CODEC_H263;
 	case V4L2_PIX_FMT_MPEG1:
-		codec = HFI_VIDEO_CODEC_MPEG1;
-		break;
+		return HFI_VIDEO_CODEC_MPEG1;
 	case V4L2_PIX_FMT_MPEG2:
-		codec = HFI_VIDEO_CODEC_MPEG2;
-		break;
+		return HFI_VIDEO_CODEC_MPEG2;
 	case V4L2_PIX_FMT_MPEG4:
-		codec = HFI_VIDEO_CODEC_MPEG4;
-		break;
+		return HFI_VIDEO_CODEC_MPEG4;
 	case V4L2_PIX_FMT_VC1_ANNEX_G:
 	case V4L2_PIX_FMT_VC1_ANNEX_L:
-		codec = HFI_VIDEO_CODEC_VC1;
-		break;
+		return HFI_VIDEO_CODEC_VC1;
 	case V4L2_PIX_FMT_VP8:
-		codec = HFI_VIDEO_CODEC_VP8;
-		break;
+		return HFI_VIDEO_CODEC_VP8;
 	case V4L2_PIX_FMT_VP9:
-		codec = HFI_VIDEO_CODEC_VP9;
-		break;
+		return HFI_VIDEO_CODEC_VP9;
 	case V4L2_PIX_FMT_XVID:
-		codec = HFI_VIDEO_CODEC_DIVX;
-		break;
+		return HFI_VIDEO_CODEC_DIVX;
 	case V4L2_PIX_FMT_HEVC:
-		codec = HFI_VIDEO_CODEC_HEVC;
-		break;
+		return HFI_VIDEO_CODEC_HEVC;
 	default:
-		return false;
+		return 0;
 	}
+}
+EXPORT_SYMBOL_GPL(v4l2_venus_fmt);
+
+bool venus_helper_check_codec(struct venus_inst *inst, u32 v4l2_pixfmt)
+{
+	struct venus_core *core = inst->core;
+	u32 session_type = inst->session_type;
+	u32 codec;
+
+	codec = v4l2_venus_fmt(v4l2_pixfmt);
 
 	if (session_type == VIDC_SESSION_TYPE_ENC && core->enc_codecs & codec)
 		return true;
diff --git a/drivers/media/platform/qcom/venus/helpers.h b/drivers/media/platform/qcom/venus/helpers.h
index 3de0c44..725831d 100644
--- a/drivers/media/platform/qcom/venus/helpers.h
+++ b/drivers/media/platform/qcom/venus/helpers.h
@@ -19,6 +19,7 @@
 
 struct venus_inst;
 
+u32 v4l2_venus_fmt(u32 pixfmt);
 bool venus_helper_check_codec(struct venus_inst *inst, u32 v4l2_pixfmt);
 struct vb2_v4l2_buffer *venus_helper_find_buf(struct venus_inst *inst,
 					      unsigned int type, u32 idx);
diff --git a/drivers/media/platform/qcom/venus/vdec.c b/drivers/media/platform/qcom/venus/vdec.c
index 98675db..afe3b36 100644
--- a/drivers/media/platform/qcom/venus/vdec.c
+++ b/drivers/media/platform/qcom/venus/vdec.c
@@ -413,6 +413,8 @@ static int vdec_enum_framesizes(struct file *file, void *fh,
 				  V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE);
 		if (!fmt)
 			return -EINVAL;
+		inst->fmt_out = fmt;
+		inst->hfi_codec = v4l2_venus_fmt(fmt->pixfmt);
 	}
 
 	if (fsize->index)
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project
