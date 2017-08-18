Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f178.google.com ([209.85.128.178]:38057 "EHLO
        mail-wr0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753530AbdHROQy (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 18 Aug 2017 10:16:54 -0400
Received: by mail-wr0-f178.google.com with SMTP id 5so47465939wrz.5
        for <linux-media@vger.kernel.org>; Fri, 18 Aug 2017 07:16:54 -0700 (PDT)
From: Stanimir Varbanov <stanimir.varbanov@linaro.org>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>
Cc: Pawel Osciak <pawel@osciak.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>
Subject: [PATCH 5/7] media: venus: add helper to check supported codecs
Date: Fri, 18 Aug 2017 17:16:04 +0300
Message-Id: <20170818141606.4835-6-stanimir.varbanov@linaro.org>
In-Reply-To: <20170818141606.4835-1-stanimir.varbanov@linaro.org>
References: <20170818141606.4835-1-stanimir.varbanov@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Adds a helper function to runtime check supported encoder and
decoder codecs depending on venus version and platform.

Signed-off-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>
---
 drivers/media/platform/qcom/venus/helpers.c | 49 +++++++++++++++++++++++++++++
 drivers/media/platform/qcom/venus/helpers.h |  1 +
 2 files changed, 50 insertions(+)

diff --git a/drivers/media/platform/qcom/venus/helpers.c b/drivers/media/platform/qcom/venus/helpers.c
index 5f4434c0a8f1..b52410deeb4c 100644
--- a/drivers/media/platform/qcom/venus/helpers.c
+++ b/drivers/media/platform/qcom/venus/helpers.c
@@ -34,6 +34,55 @@ struct intbuf {
 	unsigned long attrs;
 };
 
+bool venus_helper_check_codec(struct venus_inst *inst, u32 v4l2_pixfmt)
+{
+	struct venus_core *core = inst->core;
+	u32 session_type = inst->session_type;
+	u32 codec;
+
+	switch (v4l2_pixfmt) {
+	case V4L2_PIX_FMT_H264:
+		codec = HFI_VIDEO_CODEC_H264;
+		break;
+	case V4L2_PIX_FMT_H263:
+		codec = HFI_VIDEO_CODEC_H263;
+		break;
+	case V4L2_PIX_FMT_MPEG1:
+		codec = HFI_VIDEO_CODEC_MPEG1;
+		break;
+	case V4L2_PIX_FMT_MPEG2:
+		codec = HFI_VIDEO_CODEC_MPEG2;
+		break;
+	case V4L2_PIX_FMT_MPEG4:
+		codec = HFI_VIDEO_CODEC_MPEG4;
+		break;
+	case V4L2_PIX_FMT_VC1_ANNEX_G:
+	case V4L2_PIX_FMT_VC1_ANNEX_L:
+		codec = HFI_VIDEO_CODEC_VC1;
+		break;
+	case V4L2_PIX_FMT_VP8:
+		codec = HFI_VIDEO_CODEC_VP8;
+		break;
+	case V4L2_PIX_FMT_VP9:
+		codec = HFI_VIDEO_CODEC_VP9;
+		break;
+	case V4L2_PIX_FMT_XVID:
+		codec = HFI_VIDEO_CODEC_DIVX;
+		break;
+	default:
+		return false;
+	}
+
+	if (session_type == VIDC_SESSION_TYPE_ENC && core->enc_codecs & codec)
+		return true;
+
+	if (session_type == VIDC_SESSION_TYPE_DEC && core->dec_codecs & codec)
+		return true;
+
+	return false;
+}
+EXPORT_SYMBOL_GPL(venus_helper_check_codec);
+
 static int intbufs_set_buffer(struct venus_inst *inst, u32 type)
 {
 	struct venus_core *core = inst->core;
diff --git a/drivers/media/platform/qcom/venus/helpers.h b/drivers/media/platform/qcom/venus/helpers.h
index 6a061b417a93..971392be5df5 100644
--- a/drivers/media/platform/qcom/venus/helpers.h
+++ b/drivers/media/platform/qcom/venus/helpers.h
@@ -19,6 +19,7 @@
 
 struct venus_inst;
 
+bool venus_helper_check_codec(struct venus_inst *inst, u32 v4l2_pixfmt);
 struct vb2_v4l2_buffer *venus_helper_find_buf(struct venus_inst *inst,
 					      unsigned int type, u32 idx);
 void venus_helper_buffers_done(struct venus_inst *inst,
-- 
2.11.0
