Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f193.google.com ([209.85.128.193]:35197 "EHLO
        mail-wr0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752560AbeEOH77 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 15 May 2018 03:59:59 -0400
Received: by mail-wr0-f193.google.com with SMTP id i14-v6so14910979wre.2
        for <linux-media@vger.kernel.org>; Tue, 15 May 2018 00:59:59 -0700 (PDT)
From: Stanimir Varbanov <stanimir.varbanov@linaro.org>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org,
        Vikash Garodia <vgarodia@codeaurora.org>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>
Subject: [PATCH v2 29/29] venus: add HEVC codec support
Date: Tue, 15 May 2018 10:58:59 +0300
Message-Id: <20180515075859.17217-30-stanimir.varbanov@linaro.org>
In-Reply-To: <20180515075859.17217-1-stanimir.varbanov@linaro.org>
References: <20180515075859.17217-1-stanimir.varbanov@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This add HEVC codec support for venus versions 3xx and 4xx.

Signed-off-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>
---
 drivers/media/platform/qcom/venus/core.h    |  2 ++
 drivers/media/platform/qcom/venus/helpers.c |  3 ++
 drivers/media/platform/qcom/venus/hfi.c     |  2 ++
 drivers/media/platform/qcom/venus/vdec.c    |  4 +++
 drivers/media/platform/qcom/venus/venc.c    | 49 +++++++++++++++++++++++++++++
 5 files changed, 60 insertions(+)

diff --git a/drivers/media/platform/qcom/venus/core.h b/drivers/media/platform/qcom/venus/core.h
index 85e66e2dd672..2a956d1b9bd1 100644
--- a/drivers/media/platform/qcom/venus/core.h
+++ b/drivers/media/platform/qcom/venus/core.h
@@ -185,10 +185,12 @@ struct venc_controls {
 		u32 mpeg4;
 		u32 h264;
 		u32 vpx;
+		u32 hevc;
 	} profile;
 	struct {
 		u32 mpeg4;
 		u32 h264;
+		u32 hevc;
 	} level;
 };
 
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
index d2d082009686..d2ffd9bd44de 100644
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
index a703bce78abc..50a04cb1cc22 100644
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
 
@@ -220,6 +224,46 @@ static int venc_v4l2_to_hfi(int id, int value)
 		case V4L2_MPEG_VIDEO_H264_LOOP_FILTER_MODE_DISABLED_AT_SLICE_BOUNDARY:
 			return HFI_H264_DB_MODE_SKIP_SLICE_BOUNDARY;
 		}
+	case V4L2_CID_MPEG_VIDEO_HEVC_PROFILE:
+		switch (value) {
+		case V4L2_MPEG_VIDEO_HEVC_PROFILE_MAIN:
+		default:
+			return HFI_HEVC_PROFILE_MAIN;
+		case V4L2_MPEG_VIDEO_HEVC_PROFILE_MAIN_STILL_PICTURE:
+			return HFI_HEVC_PROFILE_MAIN_STILL_PIC;
+		case V4L2_MPEG_VIDEO_HEVC_PROFILE_MAIN_10:
+			return HFI_HEVC_PROFILE_MAIN10;
+		}
+	case V4L2_CID_MPEG_VIDEO_HEVC_LEVEL:
+		switch (value) {
+		case V4L2_MPEG_VIDEO_HEVC_LEVEL_1:
+		default:
+			return HFI_HEVC_LEVEL_1;
+		case V4L2_MPEG_VIDEO_HEVC_LEVEL_2:
+			return HFI_HEVC_LEVEL_2;
+		case V4L2_MPEG_VIDEO_HEVC_LEVEL_2_1:
+			return HFI_HEVC_LEVEL_21;
+		case V4L2_MPEG_VIDEO_HEVC_LEVEL_3:
+			return HFI_HEVC_LEVEL_3;
+		case V4L2_MPEG_VIDEO_HEVC_LEVEL_3_1:
+			return HFI_HEVC_LEVEL_31;
+		case V4L2_MPEG_VIDEO_HEVC_LEVEL_4:
+			return HFI_HEVC_LEVEL_4;
+		case V4L2_MPEG_VIDEO_HEVC_LEVEL_4_1:
+			return HFI_HEVC_LEVEL_41;
+		case V4L2_MPEG_VIDEO_HEVC_LEVEL_5:
+			return HFI_HEVC_LEVEL_5;
+		case V4L2_MPEG_VIDEO_HEVC_LEVEL_5_1:
+			return HFI_HEVC_LEVEL_51;
+		case V4L2_MPEG_VIDEO_HEVC_LEVEL_5_2:
+			return HFI_HEVC_LEVEL_52;
+		case V4L2_MPEG_VIDEO_HEVC_LEVEL_6:
+			return HFI_HEVC_LEVEL_6;
+		case V4L2_MPEG_VIDEO_HEVC_LEVEL_6_1:
+			return HFI_HEVC_LEVEL_61;
+		case V4L2_MPEG_VIDEO_HEVC_LEVEL_6_2:
+			return HFI_HEVC_LEVEL_62;
+		}
 	}
 
 	return 0;
@@ -744,6 +788,11 @@ static int venc_set_properties(struct venus_inst *inst)
 	} else if (inst->fmt_cap->pixfmt == V4L2_PIX_FMT_H263) {
 		profile = 0;
 		level = 0;
+	} else if (inst->fmt_cap->pixfmt == V4L2_PIX_FMT_HEVC) {
+		profile = venc_v4l2_to_hfi(V4L2_CID_MPEG_VIDEO_HEVC_PROFILE,
+					   ctr->profile.hevc);
+		level = venc_v4l2_to_hfi(V4L2_CID_MPEG_VIDEO_HEVC_LEVEL,
+					 ctr->level.hevc);
 	}
 
 	ptype = HFI_PROPERTY_PARAM_PROFILE_LEVEL_CURRENT;
-- 
2.14.1
