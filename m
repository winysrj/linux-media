Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f193.google.com ([209.85.128.193]:44878 "EHLO
        mail-wr0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752632AbeEOH74 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 15 May 2018 03:59:56 -0400
Received: by mail-wr0-f193.google.com with SMTP id y15-v6so14880996wrg.11
        for <linux-media@vger.kernel.org>; Tue, 15 May 2018 00:59:55 -0700 (PDT)
From: Stanimir Varbanov <stanimir.varbanov@linaro.org>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org,
        Vikash Garodia <vgarodia@codeaurora.org>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>
Subject: [PATCH v2 26/29] venus: move frame size calculations in common place
Date: Tue, 15 May 2018 10:58:56 +0300
Message-Id: <20180515075859.17217-27-stanimir.varbanov@linaro.org>
In-Reply-To: <20180515075859.17217-1-stanimir.varbanov@linaro.org>
References: <20180515075859.17217-1-stanimir.varbanov@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

move calculations of raw and compressed in a common helper
and make it identical for encoder and decoder.

Signed-off-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>
---
 drivers/media/platform/qcom/venus/helpers.c | 98 +++++++++++++++++++++++++++++
 drivers/media/platform/qcom/venus/helpers.h |  2 +
 drivers/media/platform/qcom/venus/vdec.c    | 54 ++++------------
 drivers/media/platform/qcom/venus/venc.c    | 56 ++++-------------
 4 files changed, 126 insertions(+), 84 deletions(-)

diff --git a/drivers/media/platform/qcom/venus/helpers.c b/drivers/media/platform/qcom/venus/helpers.c
index f0a0fca60c76..ed569705ecac 100644
--- a/drivers/media/platform/qcom/venus/helpers.c
+++ b/drivers/media/platform/qcom/venus/helpers.c
@@ -455,6 +455,104 @@ int venus_helper_get_bufreq(struct venus_inst *inst, u32 type,
 }
 EXPORT_SYMBOL_GPL(venus_helper_get_bufreq);
 
+static u32 get_framesize_raw_nv12(u32 width, u32 height)
+{
+	u32 y_stride, uv_stride, y_plane;
+	u32 y_sclines, uv_sclines, uv_plane;
+	u32 size;
+
+	y_stride = ALIGN(width, 128);
+	uv_stride = ALIGN(width, 128);
+	y_sclines = ALIGN(height, 32);
+	uv_sclines = ALIGN(((height + 1) >> 1), 16);
+
+	y_plane = y_stride * y_sclines;
+	uv_plane = uv_stride * uv_sclines + SZ_4K;
+	size = y_plane + uv_plane + SZ_8K;
+
+	return ALIGN(size, SZ_4K);
+}
+
+static u32 get_framesize_raw_nv12_ubwc(u32 width, u32 height)
+{
+	u32 y_meta_stride, y_meta_plane;
+	u32 y_stride, y_plane;
+	u32 uv_meta_stride, uv_meta_plane;
+	u32 uv_stride, uv_plane;
+	u32 extradata = SZ_16K;
+
+	y_meta_stride = ALIGN(DIV_ROUND_UP(width, 32), 64);
+	y_meta_plane = y_meta_stride * ALIGN(DIV_ROUND_UP(height, 8), 16);
+	y_meta_plane = ALIGN(y_meta_plane, SZ_4K);
+
+	y_stride = ALIGN(width, 128);
+	y_plane = ALIGN(y_stride * ALIGN(height, 32), SZ_4K);
+
+	uv_meta_stride = ALIGN(DIV_ROUND_UP(width / 2, 16), 64);
+	uv_meta_plane = uv_meta_stride * ALIGN(DIV_ROUND_UP(height / 2, 8), 16);
+	uv_meta_plane = ALIGN(uv_meta_plane, SZ_4K);
+
+	uv_stride = ALIGN(width, 128);
+	uv_plane = ALIGN(uv_stride * ALIGN(height / 2, 32), SZ_4K);
+
+	return ALIGN(y_meta_plane + y_plane + uv_meta_plane + uv_plane +
+		     max(extradata, y_stride * 48), SZ_4K);
+}
+
+u32 venus_helper_get_framesz_raw(u32 hfi_fmt, u32 width, u32 height)
+{
+	switch (hfi_fmt) {
+	case HFI_COLOR_FORMAT_NV12:
+	case HFI_COLOR_FORMAT_NV21:
+		return get_framesize_raw_nv12(width, height);
+	case HFI_COLOR_FORMAT_NV12_UBWC:
+		return get_framesize_raw_nv12_ubwc(width, height);
+	default:
+		return 0;
+	}
+}
+EXPORT_SYMBOL_GPL(venus_helper_get_framesz_raw);
+
+u32 venus_helper_get_framesz(u32 v4l2_fmt, u32 width, u32 height)
+{
+	u32 hfi_fmt, sz;
+	bool compressed;
+
+	switch (v4l2_fmt) {
+	case V4L2_PIX_FMT_MPEG:
+	case V4L2_PIX_FMT_H264:
+	case V4L2_PIX_FMT_H264_NO_SC:
+	case V4L2_PIX_FMT_H264_MVC:
+	case V4L2_PIX_FMT_H263:
+	case V4L2_PIX_FMT_MPEG1:
+	case V4L2_PIX_FMT_MPEG2:
+	case V4L2_PIX_FMT_MPEG4:
+	case V4L2_PIX_FMT_XVID:
+	case V4L2_PIX_FMT_VC1_ANNEX_G:
+	case V4L2_PIX_FMT_VC1_ANNEX_L:
+	case V4L2_PIX_FMT_VP8:
+	case V4L2_PIX_FMT_VP9:
+	case V4L2_PIX_FMT_HEVC:
+		compressed = true;
+		break;
+	default:
+		compressed = false;
+		break;
+	}
+
+	if (compressed) {
+		sz = ALIGN(height, 32) * ALIGN(width, 32) * 3 / 2 / 2;
+		return ALIGN(sz, SZ_4K);
+	}
+
+	hfi_fmt = to_hfi_raw_fmt(v4l2_fmt);
+	if (!hfi_fmt)
+		return 0;
+
+	return venus_helper_get_framesz_raw(hfi_fmt, width, height);
+}
+EXPORT_SYMBOL_GPL(venus_helper_get_framesz);
+
 int venus_helper_set_input_resolution(struct venus_inst *inst,
 				      unsigned int width, unsigned int height)
 {
diff --git a/drivers/media/platform/qcom/venus/helpers.h b/drivers/media/platform/qcom/venus/helpers.h
index 92be45894a69..92b167a47166 100644
--- a/drivers/media/platform/qcom/venus/helpers.h
+++ b/drivers/media/platform/qcom/venus/helpers.h
@@ -33,6 +33,8 @@ void venus_helper_m2m_device_run(void *priv);
 void venus_helper_m2m_job_abort(void *priv);
 int venus_helper_get_bufreq(struct venus_inst *inst, u32 type,
 			    struct hfi_buffer_requirements *req);
+u32 venus_helper_get_framesz_raw(u32 hfi_fmt, u32 width, u32 height);
+u32 venus_helper_get_framesz(u32 v4l2_fmt, u32 width, u32 height);
 int venus_helper_set_input_resolution(struct venus_inst *inst,
 				      unsigned int width, unsigned int height);
 int venus_helper_set_output_resolution(struct venus_inst *inst,
diff --git a/drivers/media/platform/qcom/venus/vdec.c b/drivers/media/platform/qcom/venus/vdec.c
index 3a699af0ab58..28db28fb5f21 100644
--- a/drivers/media/platform/qcom/venus/vdec.c
+++ b/drivers/media/platform/qcom/venus/vdec.c
@@ -29,29 +29,6 @@
 #include "helpers.h"
 #include "vdec.h"
 
-static u32 get_framesize_uncompressed(unsigned int plane, u32 width, u32 height)
-{
-	u32 y_stride, uv_stride, y_plane;
-	u32 y_sclines, uv_sclines, uv_plane;
-	u32 size;
-
-	y_stride = ALIGN(width, 128);
-	uv_stride = ALIGN(width, 128);
-	y_sclines = ALIGN(height, 32);
-	uv_sclines = ALIGN(((height + 1) >> 1), 16);
-
-	y_plane = y_stride * y_sclines;
-	uv_plane = uv_stride * uv_sclines + SZ_4K;
-	size = y_plane + uv_plane + SZ_8K;
-
-	return ALIGN(size, SZ_4K);
-}
-
-static u32 get_framesize_compressed(unsigned int width, unsigned int height)
-{
-	return ((width * height * 3 / 2) / 2) + 128;
-}
-
 /*
  * Three resons to keep MPLANE formats (despite that the number of planes
  * currently is one):
@@ -160,7 +137,6 @@ vdec_try_fmt_common(struct venus_inst *inst, struct v4l2_format *f)
 	struct v4l2_pix_format_mplane *pixmp = &f->fmt.pix_mp;
 	struct v4l2_plane_pix_format *pfmt = pixmp->plane_fmt;
 	const struct venus_format *fmt;
-	unsigned int p;
 
 	memset(pfmt[0].reserved, 0, sizeof(pfmt[0].reserved));
 	memset(pixmp->reserved, 0, sizeof(pixmp->reserved));
@@ -191,18 +167,14 @@ vdec_try_fmt_common(struct venus_inst *inst, struct v4l2_format *f)
 	pixmp->num_planes = fmt->num_planes;
 	pixmp->flags = 0;
 
-	if (f->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE) {
-		for (p = 0; p < pixmp->num_planes; p++) {
-			pfmt[p].sizeimage =
-				get_framesize_uncompressed(p, pixmp->width,
-							   pixmp->height);
-			pfmt[p].bytesperline = ALIGN(pixmp->width, 128);
-		}
-	} else {
-		pfmt[0].sizeimage = get_framesize_compressed(pixmp->width,
-							     pixmp->height);
+	pfmt[0].sizeimage = venus_helper_get_framesz(pixmp->pixelformat,
+						     pixmp->width,
+						     pixmp->height);
+
+	if (f->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE)
+		pfmt[0].bytesperline = ALIGN(pixmp->width, 128);
+	else
 		pfmt[0].bytesperline = 0;
-	}
 
 	return fmt;
 }
@@ -648,7 +620,7 @@ static int vdec_queue_setup(struct vb2_queue *q,
 			    unsigned int sizes[], struct device *alloc_devs[])
 {
 	struct venus_inst *inst = vb2_get_drv_priv(q);
-	unsigned int p, in_num, out_num;
+	unsigned int in_num, out_num;
 	int ret = 0;
 
 	if (*num_planes) {
@@ -678,7 +650,8 @@ static int vdec_queue_setup(struct vb2_queue *q,
 	switch (q->type) {
 	case V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE:
 		*num_planes = inst->fmt_out->num_planes;
-		sizes[0] = get_framesize_compressed(inst->out_width,
+		sizes[0] = venus_helper_get_framesz(inst->fmt_out->pixfmt,
+						    inst->out_width,
 						    inst->out_height);
 		inst->input_buf_size = sizes[0];
 		*num_buffers = max(*num_buffers, in_num);
@@ -687,10 +660,9 @@ static int vdec_queue_setup(struct vb2_queue *q,
 		break;
 	case V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE:
 		*num_planes = inst->fmt_cap->num_planes;
-
-		for (p = 0; p < *num_planes; p++)
-			sizes[p] = get_framesize_uncompressed(p, inst->width,
-							      inst->height);
+		sizes[0] = venus_helper_get_framesz(inst->fmt_cap->pixfmt,
+						    inst->width,
+						    inst->height);
 		inst->output_buf_size = sizes[0];
 		*num_buffers = max(*num_buffers, out_num);
 		inst->num_output_bufs = *num_buffers;
diff --git a/drivers/media/platform/qcom/venus/venc.c b/drivers/media/platform/qcom/venus/venc.c
index c9c40d1ce7c6..54f253b98b24 100644
--- a/drivers/media/platform/qcom/venus/venc.c
+++ b/drivers/media/platform/qcom/venus/venc.c
@@ -31,32 +31,6 @@
 
 #define NUM_B_FRAMES_MAX	4
 
-static u32 get_framesize_uncompressed(unsigned int plane, u32 width, u32 height)
-{
-	u32 y_stride, uv_stride, y_plane;
-	u32 y_sclines, uv_sclines, uv_plane;
-	u32 size;
-
-	y_stride = ALIGN(width, 128);
-	uv_stride = ALIGN(width, 128);
-	y_sclines = ALIGN(height, 32);
-	uv_sclines = ALIGN(((height + 1) >> 1), 16);
-
-	y_plane = y_stride * y_sclines;
-	uv_plane = uv_stride * uv_sclines + SZ_4K;
-	size = y_plane + uv_plane + SZ_8K;
-	size = ALIGN(size, SZ_4K);
-
-	return size;
-}
-
-static u32 get_framesize_compressed(u32 width, u32 height)
-{
-	u32 sz = ALIGN(height, 32) * ALIGN(width, 32) * 3 / 2 / 2;
-
-	return ALIGN(sz, SZ_4K);
-}
-
 /*
  * Three resons to keep MPLANE formats (despite that the number of planes
  * currently is one):
@@ -284,7 +258,6 @@ venc_try_fmt_common(struct venus_inst *inst, struct v4l2_format *f)
 	struct v4l2_pix_format_mplane *pixmp = &f->fmt.pix_mp;
 	struct v4l2_plane_pix_format *pfmt = pixmp->plane_fmt;
 	const struct venus_format *fmt;
-	unsigned int p;
 
 	memset(pfmt[0].reserved, 0, sizeof(pfmt[0].reserved));
 	memset(pixmp->reserved, 0, sizeof(pixmp->reserved));
@@ -318,19 +291,14 @@ venc_try_fmt_common(struct venus_inst *inst, struct v4l2_format *f)
 	pixmp->num_planes = fmt->num_planes;
 	pixmp->flags = 0;
 
-	if (f->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) {
-		for (p = 0; p < pixmp->num_planes; p++) {
-			pfmt[p].sizeimage =
-				get_framesize_uncompressed(p, pixmp->width,
-							   pixmp->height);
+	pfmt[0].sizeimage = venus_helper_get_framesz(pixmp->pixelformat,
+						     pixmp->width,
+						     pixmp->height);
 
-			pfmt[p].bytesperline = ALIGN(pixmp->width, 128);
-		}
-	} else {
-		pfmt[0].sizeimage = get_framesize_compressed(pixmp->width,
-							     pixmp->height);
+	if (f->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE)
+		pfmt[0].bytesperline = ALIGN(pixmp->width, 128);
+	else
 		pfmt[0].bytesperline = 0;
-	}
 
 	return fmt;
 }
@@ -845,7 +813,7 @@ static int venc_queue_setup(struct vb2_queue *q,
 			    unsigned int sizes[], struct device *alloc_devs[])
 {
 	struct venus_inst *inst = vb2_get_drv_priv(q);
-	unsigned int p, num, min = 4;
+	unsigned int num, min = 4;
 	int ret = 0;
 
 	if (*num_planes) {
@@ -880,16 +848,18 @@ static int venc_queue_setup(struct vb2_queue *q,
 		*num_buffers = max(*num_buffers, num);
 		inst->num_input_bufs = *num_buffers;
 
-		for (p = 0; p < *num_planes; ++p)
-			sizes[p] = get_framesize_uncompressed(p, inst->width,
-							      inst->height);
+		sizes[0] = venus_helper_get_framesz(inst->fmt_out->pixfmt,
+						    inst->width,
+						    inst->height);
 		inst->input_buf_size = sizes[0];
 		break;
 	case V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE:
 		*num_planes = inst->fmt_cap->num_planes;
 		*num_buffers = max(*num_buffers, min);
 		inst->num_output_bufs = *num_buffers;
-		sizes[0] = get_framesize_compressed(inst->width, inst->height);
+		sizes[0] = venus_helper_get_framesz(inst->fmt_cap->pixfmt,
+						    inst->width,
+						    inst->height);
 		inst->output_buf_size = sizes[0];
 		break;
 	default:
-- 
2.14.1
