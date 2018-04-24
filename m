Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:55599 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933026AbeDXMpi (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 24 Apr 2018 08:45:38 -0400
Received: by mail-wm0-f67.google.com with SMTP id a8so695476wmg.5
        for <linux-media@vger.kernel.org>; Tue, 24 Apr 2018 05:45:38 -0700 (PDT)
From: Stanimir Varbanov <stanimir.varbanov@linaro.org>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org,
        Vikash Garodia <vgarodia@codeaurora.org>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>
Subject: [PATCH 28/28] venus: add HEVC codec support
Date: Tue, 24 Apr 2018 15:44:36 +0300
Message-Id: <20180424124436.26955-29-stanimir.varbanov@linaro.org>
In-Reply-To: <20180424124436.26955-1-stanimir.varbanov@linaro.org>
References: <20180424124436.26955-1-stanimir.varbanov@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This add HEVC codec support for venus versions 3xx and 4xx.

Signed-off-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>
---
 drivers/media/platform/qcom/venus/helpers.c | 3 +++
 drivers/media/platform/qcom/venus/hfi.c     | 2 ++
 drivers/media/platform/qcom/venus/vdec.c    | 4 ++++
 drivers/media/platform/qcom/venus/venc.c    | 4 ++++
 4 files changed, 13 insertions(+)

diff --git a/drivers/media/platform/qcom/venus/helpers.c b/drivers/media/platform/qcom/venus/helpers.c
index 87dcf9973e6f..fecadba039cf 100644
--- a/drivers/media/platform/qcom/venus/helpers.c
+++ b/drivers/media/platform/qcom/venus/helpers.c
@@ -71,6 +71,9 @@ bool venus_helper_check_codec(struct venus_inst *inst, u32 v4l2_pixfmt)
 	case V4L2_PIX_FMT_XVID:
 		codec = HFI_VIDEO_CODEC_DIVX;
 		break;
+	case V4L2_PIX_FMT_HEVC:
+		codec = HFI_VIDEO_CODEC_HEVC;
+		break;
 	default:
 		return false;
 	}
diff --git a/drivers/media/platform/qcom/venus/hfi.c b/drivers/media/platform/qcom/venus/hfi.c
index 94ca27b0bb99..24207829982f 100644
--- a/drivers/media/platform/qcom/venus/hfi.c
+++ b/drivers/media/platform/qcom/venus/hfi.c
@@ -49,6 +49,8 @@ static u32 to_codec_type(u32 pixfmt)
 		return HFI_VIDEO_CODEC_VP9;
 	case V4L2_PIX_FMT_XVID:
 		return HFI_VIDEO_CODEC_DIVX;
+	case V4L2_PIX_FMT_HEVC:
+		return HFI_VIDEO_CODEC_HEVC;
 	default:
 		return 0;
 	}
diff --git a/drivers/media/platform/qcom/venus/vdec.c b/drivers/media/platform/qcom/venus/vdec.c
index 7deee104ac56..a114f421edad 100644
--- a/drivers/media/platform/qcom/venus/vdec.c
+++ b/drivers/media/platform/qcom/venus/vdec.c
@@ -77,6 +77,10 @@ static const struct venus_format vdec_formats[] = {
 		.pixfmt = V4L2_PIX_FMT_XVID,
 		.num_planes = 1,
 		.type = V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE,
+	}, {
+		.pixfmt = V4L2_PIX_FMT_HEVC,
+		.num_planes = 1,
+		.type = V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE,
 	},
 };
 
diff --git a/drivers/media/platform/qcom/venus/venc.c b/drivers/media/platform/qcom/venus/venc.c
index a703bce78abc..fdb76b69786f 100644
--- a/drivers/media/platform/qcom/venus/venc.c
+++ b/drivers/media/platform/qcom/venus/venc.c
@@ -59,6 +59,10 @@ static const struct venus_format venc_formats[] = {
 		.pixfmt = V4L2_PIX_FMT_VP8,
 		.num_planes = 1,
 		.type = V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE,
+	}, {
+		.pixfmt = V4L2_PIX_FMT_HEVC,
+		.num_planes = 1,
+		.type = V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE,
 	},
 };
 
-- 
2.14.1
