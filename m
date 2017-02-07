Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f169.google.com ([209.85.128.169]:35075 "EHLO
        mail-wr0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932224AbdBGNLN (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 7 Feb 2017 08:11:13 -0500
Received: by mail-wr0-f169.google.com with SMTP id 89so39219498wrr.2
        for <linux-media@vger.kernel.org>; Tue, 07 Feb 2017 05:11:12 -0800 (PST)
From: Stanimir Varbanov <stanimir.varbanov@linaro.org>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>
Cc: Andy Gross <andy.gross@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>
Subject: [PATCH v6 6/9] media: venus: venc: add video encoder files
Date: Tue,  7 Feb 2017 15:10:21 +0200
Message-Id: <1486473024-21705-7-git-send-email-stanimir.varbanov@linaro.org>
In-Reply-To: <1486473024-21705-1-git-send-email-stanimir.varbanov@linaro.org>
References: <1486473024-21705-1-git-send-email-stanimir.varbanov@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This adds encoder part of the driver plus encoder controls.

Signed-off-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>
---
 drivers/media/platform/qcom/venus/venc.c       | 1231 ++++++++++++++++++++++++
 drivers/media/platform/qcom/venus/venc.h       |   23 +
 drivers/media/platform/qcom/venus/venc_ctrls.c |  258 +++++
 3 files changed, 1512 insertions(+)
 create mode 100644 drivers/media/platform/qcom/venus/venc.c
 create mode 100644 drivers/media/platform/qcom/venus/venc.h
 create mode 100644 drivers/media/platform/qcom/venus/venc_ctrls.c

diff --git a/drivers/media/platform/qcom/venus/venc.c b/drivers/media/platform/qcom/venus/venc.c
new file mode 100644
index 000000000000..dddfc3554953
--- /dev/null
+++ b/drivers/media/platform/qcom/venus/venc.c
@@ -0,0 +1,1231 @@
+/*
+ * Copyright (c) 2012-2016, The Linux Foundation. All rights reserved.
+ * Copyright (C) 2017 Linaro Ltd.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ */
+#include <linux/clk.h>
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <linux/pm_runtime.h>
+#include <linux/slab.h>
+#include <media/v4l2-mem2mem.h>
+#include <media/videobuf2-dma-sg.h>
+#include <media/v4l2-ioctl.h>
+#include <media/v4l2-event.h>
+#include <media/v4l2-ctrls.h>
+
+#include "hfi_venus_io.h"
+#include "core.h"
+#include "helpers.h"
+#include "venc.h"
+
+#define NUM_B_FRAMES_MAX	4
+
+static u32 get_framesize_uncompressed(unsigned int plane, u32 width, u32 height)
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
+	size = ALIGN(size, SZ_4K);
+
+	return size;
+}
+
+static u32 get_framesize_compressed(u32 width, u32 height)
+{
+	u32 sz = ALIGN(height, 32) * ALIGN(width, 32) * 3 / 2 / 2;
+
+	return ALIGN(sz, SZ_4K);
+}
+
+static const struct venus_format venc_formats[] = {
+	{
+		.pixfmt = V4L2_PIX_FMT_NV12,
+		.num_planes = 1,
+		.type = V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE,
+	}, {
+		.pixfmt = V4L2_PIX_FMT_MPEG4,
+		.num_planes = 1,
+		.type = V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE,
+	}, {
+		.pixfmt = V4L2_PIX_FMT_H263,
+		.num_planes = 1,
+		.type = V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE,
+	}, {
+		.pixfmt = V4L2_PIX_FMT_H264,
+		.num_planes = 1,
+		.type = V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE,
+	}, {
+		.pixfmt = V4L2_PIX_FMT_VP8,
+		.num_planes = 1,
+		.type = V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE,
+	},
+};
+
+static const struct venus_format *find_format(u32 pixfmt, int type)
+{
+	const struct venus_format *fmt = venc_formats;
+	unsigned int size = ARRAY_SIZE(venc_formats);
+	unsigned int i;
+
+	for (i = 0; i < size; i++) {
+		if (fmt[i].pixfmt == pixfmt)
+			break;
+	}
+
+	if (i == size || fmt[i].type != type)
+		return NULL;
+
+	return &fmt[i];
+}
+
+static const struct venus_format *find_format_by_index(int index, int type)
+{
+	const struct venus_format *fmt = venc_formats;
+	unsigned int size = ARRAY_SIZE(venc_formats);
+	int i, k = 0;
+
+	if (index < 0 || index > size)
+		return NULL;
+
+	for (i = 0; i < size; i++) {
+		if (fmt[i].type != type)
+			continue;
+		if (k == index)
+			break;
+		k++;
+	}
+
+	if (i == size)
+		return NULL;
+
+	return &fmt[i];
+}
+
+static int venc_v4l2_to_hfi(int id, int value)
+{
+	switch (id) {
+	case V4L2_CID_MPEG_VIDEO_MPEG4_LEVEL:
+		switch (value) {
+		case V4L2_MPEG_VIDEO_MPEG4_LEVEL_0:
+		default:
+			return HFI_MPEG4_LEVEL_0;
+		case V4L2_MPEG_VIDEO_MPEG4_LEVEL_0B:
+			return HFI_MPEG4_LEVEL_0b;
+		case V4L2_MPEG_VIDEO_MPEG4_LEVEL_1:
+			return HFI_MPEG4_LEVEL_1;
+		case V4L2_MPEG_VIDEO_MPEG4_LEVEL_2:
+			return HFI_MPEG4_LEVEL_2;
+		case V4L2_MPEG_VIDEO_MPEG4_LEVEL_3:
+			return HFI_MPEG4_LEVEL_3;
+		case V4L2_MPEG_VIDEO_MPEG4_LEVEL_4:
+			return HFI_MPEG4_LEVEL_4;
+		case V4L2_MPEG_VIDEO_MPEG4_LEVEL_5:
+			return HFI_MPEG4_LEVEL_5;
+		}
+	case V4L2_CID_MPEG_VIDEO_MPEG4_PROFILE:
+		switch (value) {
+		case V4L2_MPEG_VIDEO_MPEG4_PROFILE_SIMPLE:
+		default:
+			return HFI_MPEG4_PROFILE_SIMPLE;
+		case V4L2_MPEG_VIDEO_MPEG4_PROFILE_ADVANCED_SIMPLE:
+			return HFI_MPEG4_PROFILE_ADVANCEDSIMPLE;
+		}
+	case V4L2_CID_MPEG_VIDEO_H264_PROFILE:
+		switch (value) {
+		case V4L2_MPEG_VIDEO_H264_PROFILE_BASELINE:
+			return HFI_H264_PROFILE_BASELINE;
+		case V4L2_MPEG_VIDEO_H264_PROFILE_CONSTRAINED_BASELINE:
+			return HFI_H264_PROFILE_CONSTRAINED_BASE;
+		case V4L2_MPEG_VIDEO_H264_PROFILE_MAIN:
+			return HFI_H264_PROFILE_MAIN;
+		case V4L2_MPEG_VIDEO_H264_PROFILE_HIGH:
+		default:
+			return HFI_H264_PROFILE_HIGH;
+		}
+	case V4L2_CID_MPEG_VIDEO_H264_LEVEL:
+		switch (value) {
+		case V4L2_MPEG_VIDEO_H264_LEVEL_1_0:
+			return HFI_H264_LEVEL_1;
+		case V4L2_MPEG_VIDEO_H264_LEVEL_1B:
+			return HFI_H264_LEVEL_1b;
+		case V4L2_MPEG_VIDEO_H264_LEVEL_1_1:
+			return HFI_H264_LEVEL_11;
+		case V4L2_MPEG_VIDEO_H264_LEVEL_1_2:
+			return HFI_H264_LEVEL_12;
+		case V4L2_MPEG_VIDEO_H264_LEVEL_1_3:
+			return HFI_H264_LEVEL_13;
+		case V4L2_MPEG_VIDEO_H264_LEVEL_2_0:
+			return HFI_H264_LEVEL_2;
+		case V4L2_MPEG_VIDEO_H264_LEVEL_2_1:
+			return HFI_H264_LEVEL_21;
+		case V4L2_MPEG_VIDEO_H264_LEVEL_2_2:
+			return HFI_H264_LEVEL_22;
+		case V4L2_MPEG_VIDEO_H264_LEVEL_3_0:
+			return HFI_H264_LEVEL_3;
+		case V4L2_MPEG_VIDEO_H264_LEVEL_3_1:
+			return HFI_H264_LEVEL_31;
+		case V4L2_MPEG_VIDEO_H264_LEVEL_3_2:
+			return HFI_H264_LEVEL_32;
+		case V4L2_MPEG_VIDEO_H264_LEVEL_4_0:
+			return HFI_H264_LEVEL_4;
+		case V4L2_MPEG_VIDEO_H264_LEVEL_4_1:
+			return HFI_H264_LEVEL_41;
+		case V4L2_MPEG_VIDEO_H264_LEVEL_4_2:
+			return HFI_H264_LEVEL_42;
+		case V4L2_MPEG_VIDEO_H264_LEVEL_5_0:
+		default:
+			return HFI_H264_LEVEL_5;
+		case V4L2_MPEG_VIDEO_H264_LEVEL_5_1:
+			return HFI_H264_LEVEL_51;
+		}
+	case V4L2_CID_MPEG_VIDEO_H264_ENTROPY_MODE:
+		switch (value) {
+		case V4L2_MPEG_VIDEO_H264_ENTROPY_MODE_CAVLC:
+		default:
+			return HFI_H264_ENTROPY_CAVLC;
+		case V4L2_MPEG_VIDEO_H264_ENTROPY_MODE_CABAC:
+			return HFI_H264_ENTROPY_CABAC;
+		}
+	case V4L2_CID_MPEG_VIDEO_VPX_PROFILE:
+		switch (value) {
+		case 0:
+		default:
+			return HFI_VPX_PROFILE_VERSION_0;
+		case 1:
+			return HFI_VPX_PROFILE_VERSION_1;
+		case 2:
+			return HFI_VPX_PROFILE_VERSION_2;
+		case 3:
+			return HFI_VPX_PROFILE_VERSION_3;
+		}
+	}
+
+	return 0;
+}
+
+static int
+venc_querycap(struct file *file, void *fh, struct v4l2_capability *cap)
+{
+	strlcpy(cap->driver, "qcom-venus", sizeof(cap->driver));
+	strlcpy(cap->card, "Qualcomm Venus video encoder", sizeof(cap->card));
+	strlcpy(cap->bus_info, "platform:qcom-venus", sizeof(cap->bus_info));
+
+	return 0;
+}
+
+static int venc_enum_fmt(struct file *file, void *fh, struct v4l2_fmtdesc *f)
+{
+	const struct venus_format *fmt;
+
+	fmt = find_format_by_index(f->index, f->type);
+
+	memset(f->reserved, 0, sizeof(f->reserved));
+
+	if (!fmt)
+		return -EINVAL;
+
+	f->pixelformat = fmt->pixfmt;
+
+	return 0;
+}
+
+static const struct venus_format *
+venc_try_fmt_common(struct venus_inst *inst, struct v4l2_format *f)
+{
+	struct v4l2_pix_format_mplane *pixmp = &f->fmt.pix_mp;
+	struct v4l2_plane_pix_format *pfmt = pixmp->plane_fmt;
+	const struct venus_format *fmt;
+	unsigned int p;
+
+	memset(pfmt[0].reserved, 0, sizeof(pfmt[0].reserved));
+	memset(pixmp->reserved, 0, sizeof(pixmp->reserved));
+
+	fmt = find_format(pixmp->pixelformat, f->type);
+	if (!fmt) {
+		if (f->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE)
+			pixmp->pixelformat = V4L2_PIX_FMT_H264;
+		else if (f->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE)
+			pixmp->pixelformat = V4L2_PIX_FMT_NV12;
+		else
+			return NULL;
+		fmt = find_format(pixmp->pixelformat, f->type);
+		pixmp->width = 1280;
+		pixmp->height = 720;
+	}
+
+	pixmp->width = clamp(pixmp->width, inst->cap_width.min,
+			     inst->cap_width.max);
+	pixmp->height = clamp(pixmp->height, inst->cap_height.min,
+			      inst->cap_height.max);
+
+	pixmp->height = ALIGN(pixmp->height, 32);
+
+	if (pixmp->field == V4L2_FIELD_ANY)
+		pixmp->field = V4L2_FIELD_NONE;
+	pixmp->num_planes = fmt->num_planes;
+	pixmp->flags = 0;
+
+	if (f->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) {
+		for (p = 0; p < pixmp->num_planes; p++) {
+			pfmt[p].sizeimage =
+				get_framesize_uncompressed(p, pixmp->width,
+							   pixmp->height);
+
+			pfmt[p].bytesperline = ALIGN(pixmp->width, 128);
+		}
+	} else {
+		pfmt[0].sizeimage = get_framesize_compressed(pixmp->width,
+							     pixmp->height);
+		pfmt[0].bytesperline = 0;
+	}
+
+	return fmt;
+}
+
+static int venc_try_fmt(struct file *file, void *fh, struct v4l2_format *f)
+{
+	struct venus_inst *inst = to_inst(file);
+
+	venc_try_fmt_common(inst, f);
+
+	return 0;
+}
+
+static int venc_s_fmt(struct file *file, void *fh, struct v4l2_format *f)
+{
+	struct venus_inst *inst = to_inst(file);
+	struct v4l2_pix_format_mplane *pixmp = &f->fmt.pix_mp;
+	struct v4l2_pix_format_mplane orig_pixmp;
+	const struct venus_format *fmt;
+	struct v4l2_format format;
+	u32 pixfmt_out = 0, pixfmt_cap = 0;
+
+	orig_pixmp = *pixmp;
+
+	fmt = venc_try_fmt_common(inst, f);
+	if (!fmt)
+		return -EINVAL;
+
+	if (f->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) {
+		pixfmt_out = pixmp->pixelformat;
+		pixfmt_cap = inst->fmt_cap->pixfmt;
+	} else if (f->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE) {
+		pixfmt_cap = pixmp->pixelformat;
+		pixfmt_out = inst->fmt_out->pixfmt;
+	}
+
+	memset(&format, 0, sizeof(format));
+
+	format.type = V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE;
+	format.fmt.pix_mp.pixelformat = pixfmt_out;
+	format.fmt.pix_mp.width = orig_pixmp.width;
+	format.fmt.pix_mp.height = orig_pixmp.height;
+	venc_try_fmt_common(inst, &format);
+
+	if (f->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) {
+		inst->out_width = format.fmt.pix_mp.width;
+		inst->out_height = format.fmt.pix_mp.height;
+		inst->colorspace = pixmp->colorspace;
+		inst->ycbcr_enc = pixmp->ycbcr_enc;
+		inst->quantization = pixmp->quantization;
+		inst->xfer_func = pixmp->xfer_func;
+	}
+
+	memset(&format, 0, sizeof(format));
+
+	format.type = V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE;
+	format.fmt.pix_mp.pixelformat = pixfmt_cap;
+	format.fmt.pix_mp.width = orig_pixmp.width;
+	format.fmt.pix_mp.height = orig_pixmp.height;
+	venc_try_fmt_common(inst, &format);
+
+	inst->width = format.fmt.pix_mp.width;
+	inst->height = format.fmt.pix_mp.height;
+
+	if (f->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE)
+		inst->fmt_out = fmt;
+	else if (f->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE)
+		inst->fmt_cap = fmt;
+
+	return 0;
+}
+
+static int venc_g_fmt(struct file *file, void *fh, struct v4l2_format *f)
+{
+	struct v4l2_pix_format_mplane *pixmp = &f->fmt.pix_mp;
+	struct venus_inst *inst = to_inst(file);
+	const struct venus_format *fmt;
+
+	if (f->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE)
+		fmt = inst->fmt_cap;
+	else if (f->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE)
+		fmt = inst->fmt_out;
+	else
+		return -EINVAL;
+
+	pixmp->pixelformat = fmt->pixfmt;
+
+	if (f->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE) {
+		pixmp->width = inst->width;
+		pixmp->height = inst->height;
+		pixmp->colorspace = inst->colorspace;
+		pixmp->ycbcr_enc = inst->ycbcr_enc;
+		pixmp->quantization = inst->quantization;
+		pixmp->xfer_func = inst->xfer_func;
+	} else if (f->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) {
+		pixmp->width = inst->out_width;
+		pixmp->height = inst->out_height;
+	}
+
+	venc_try_fmt_common(inst, f);
+
+	return 0;
+}
+
+static int
+venc_g_selection(struct file *file, void *fh, struct v4l2_selection *s)
+{
+	struct venus_inst *inst = to_inst(file);
+
+	if (s->type != V4L2_BUF_TYPE_VIDEO_OUTPUT)
+		return -EINVAL;
+
+	switch (s->target) {
+	case V4L2_SEL_TGT_CROP_DEFAULT:
+	case V4L2_SEL_TGT_CROP_BOUNDS:
+		s->r.width = inst->width;
+		s->r.height = inst->height;
+		break;
+	case V4L2_SEL_TGT_CROP:
+		s->r.width = inst->out_width;
+		s->r.height = inst->out_height;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	s->r.top = 0;
+	s->r.left = 0;
+
+	return 0;
+}
+
+static int
+venc_s_selection(struct file *file, void *fh, struct v4l2_selection *s)
+{
+	struct venus_inst *inst = to_inst(file);
+
+	if (s->type != V4L2_BUF_TYPE_VIDEO_OUTPUT)
+		return -EINVAL;
+
+	switch (s->target) {
+	case V4L2_SEL_TGT_CROP:
+		if (s->r.width != inst->out_width ||
+		    s->r.height != inst->out_height ||
+		    s->r.top != 0 || s->r.left != 0)
+			return -EINVAL;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int venc_s_parm(struct file *file, void *fh, struct v4l2_streamparm *a)
+{
+	struct venus_inst *inst = to_inst(file);
+	struct v4l2_outputparm *out = &a->parm.output;
+	struct v4l2_fract *timeperframe = &out->timeperframe;
+	u64 us_per_frame, fps;
+
+	if (a->type != V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE &&
+	    a->type != V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE)
+		return -EINVAL;
+
+	memset(out->reserved, 0, sizeof(out->reserved));
+
+	if (!timeperframe->denominator)
+		timeperframe->denominator = inst->timeperframe.denominator;
+	if (!timeperframe->numerator)
+		timeperframe->numerator = inst->timeperframe.numerator;
+
+	out->capability = V4L2_CAP_TIMEPERFRAME;
+
+	us_per_frame = timeperframe->numerator * (u64)USEC_PER_SEC;
+	do_div(us_per_frame, timeperframe->denominator);
+
+	if (!us_per_frame)
+		return -EINVAL;
+
+	fps = (u64)USEC_PER_SEC;
+	do_div(fps, us_per_frame);
+
+	inst->timeperframe = *timeperframe;
+	inst->fps = fps;
+
+	return 0;
+}
+
+static int venc_g_parm(struct file *file, void *fh, struct v4l2_streamparm *a)
+{
+	struct venus_inst *inst = to_inst(file);
+
+	if (a->type != V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE &&
+	    a->type != V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE)
+		return -EINVAL;
+
+	a->parm.output.capability |= V4L2_CAP_TIMEPERFRAME;
+	a->parm.output.timeperframe = inst->timeperframe;
+
+	return 0;
+}
+
+static int venc_enum_framesizes(struct file *file, void *fh,
+				struct v4l2_frmsizeenum *fsize)
+{
+	struct venus_inst *inst = to_inst(file);
+	const struct venus_format *fmt;
+
+	fsize->type = V4L2_FRMSIZE_TYPE_STEPWISE;
+
+	fmt = find_format(fsize->pixel_format,
+			  V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE);
+	if (!fmt) {
+		fmt = find_format(fsize->pixel_format,
+				  V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE);
+		if (!fmt)
+			return -EINVAL;
+	}
+
+	if (fsize->index)
+		return -EINVAL;
+
+	fsize->stepwise.min_width = inst->cap_width.min;
+	fsize->stepwise.max_width = inst->cap_width.max;
+	fsize->stepwise.step_width = inst->cap_width.step_size;
+	fsize->stepwise.min_height = inst->cap_height.min;
+	fsize->stepwise.max_height = inst->cap_height.max;
+	fsize->stepwise.step_height = inst->cap_height.step_size;
+
+	return 0;
+}
+
+static int venc_enum_frameintervals(struct file *file, void *fh,
+				    struct v4l2_frmivalenum *fival)
+{
+	struct venus_inst *inst = to_inst(file);
+	const struct venus_format *fmt;
+
+	fival->type = V4L2_FRMIVAL_TYPE_STEPWISE;
+
+	fmt = find_format(fival->pixel_format,
+			  V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE);
+	if (!fmt) {
+		fmt = find_format(fival->pixel_format,
+				  V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE);
+		if (!fmt)
+			return -EINVAL;
+	}
+
+	if (fival->index)
+		return -EINVAL;
+
+	if (!fival->width || !fival->height)
+		return -EINVAL;
+
+	if (fival->width > inst->cap_width.max ||
+	    fival->width < inst->cap_width.min ||
+	    fival->height > inst->cap_height.max ||
+	    fival->height < inst->cap_height.min)
+		return -EINVAL;
+
+	fival->stepwise.min.numerator = 1;
+	fival->stepwise.min.denominator = inst->cap_framerate.max;
+	fival->stepwise.max.numerator = 1;
+	fival->stepwise.max.denominator = inst->cap_framerate.min;
+	fival->stepwise.step.numerator = 1;
+	fival->stepwise.step.denominator = inst->cap_framerate.max;
+
+	return 0;
+}
+
+static const struct v4l2_ioctl_ops venc_ioctl_ops = {
+	.vidioc_querycap = venc_querycap,
+	.vidioc_enum_fmt_vid_cap_mplane = venc_enum_fmt,
+	.vidioc_enum_fmt_vid_out_mplane = venc_enum_fmt,
+	.vidioc_s_fmt_vid_cap_mplane = venc_s_fmt,
+	.vidioc_s_fmt_vid_out_mplane = venc_s_fmt,
+	.vidioc_g_fmt_vid_cap_mplane = venc_g_fmt,
+	.vidioc_g_fmt_vid_out_mplane = venc_g_fmt,
+	.vidioc_try_fmt_vid_cap_mplane = venc_try_fmt,
+	.vidioc_try_fmt_vid_out_mplane = venc_try_fmt,
+	.vidioc_g_selection = venc_g_selection,
+	.vidioc_s_selection = venc_s_selection,
+	.vidioc_reqbufs = v4l2_m2m_ioctl_reqbufs,
+	.vidioc_querybuf = v4l2_m2m_ioctl_querybuf,
+	.vidioc_create_bufs = v4l2_m2m_ioctl_create_bufs,
+	.vidioc_prepare_buf = v4l2_m2m_ioctl_prepare_buf,
+	.vidioc_qbuf = v4l2_m2m_ioctl_qbuf,
+	.vidioc_expbuf = v4l2_m2m_ioctl_expbuf,
+	.vidioc_dqbuf = v4l2_m2m_ioctl_dqbuf,
+	.vidioc_streamon = v4l2_m2m_ioctl_streamon,
+	.vidioc_streamoff = v4l2_m2m_ioctl_streamoff,
+	.vidioc_s_parm = venc_s_parm,
+	.vidioc_g_parm = venc_g_parm,
+	.vidioc_enum_framesizes = venc_enum_framesizes,
+	.vidioc_enum_frameintervals = venc_enum_frameintervals,
+	.vidioc_subscribe_event = v4l2_ctrl_subscribe_event,
+	.vidioc_unsubscribe_event = v4l2_event_unsubscribe,
+};
+
+static int venc_set_properties(struct venus_inst *inst)
+{
+	struct venc_controls *ctr = &inst->controls.enc;
+	struct hfi_intra_period intra_period;
+	struct hfi_profile_level pl;
+	struct hfi_framerate frate;
+	struct hfi_bitrate brate;
+	struct hfi_idr_period idrp;
+	u32 ptype, rate_control, bitrate, profile = 0, level = 0;
+	int ret;
+
+	ptype = HFI_PROPERTY_CONFIG_FRAME_RATE;
+	frate.buffer_type = HFI_BUFFER_OUTPUT;
+	frate.framerate = inst->fps * (1 << 16);
+
+	ret = hfi_session_set_property(inst, ptype, &frate);
+	if (ret)
+		return ret;
+
+	if (inst->fmt_cap->pixfmt == V4L2_PIX_FMT_H264) {
+		struct hfi_h264_vui_timing_info info;
+
+		ptype = HFI_PROPERTY_PARAM_VENC_H264_VUI_TIMING_INFO;
+		info.enable = 1;
+		info.fixed_framerate = 1;
+		info.time_scale = NSEC_PER_SEC;
+
+		ret = hfi_session_set_property(inst, ptype, &info);
+		if (ret)
+			return ret;
+	}
+
+	ptype = HFI_PROPERTY_CONFIG_VENC_IDR_PERIOD;
+	idrp.idr_period = ctr->gop_size;
+	ret = hfi_session_set_property(inst, ptype, &idrp);
+	if (ret)
+		return ret;
+
+	if (ctr->num_b_frames) {
+		u32 max_num_b_frames = NUM_B_FRAMES_MAX;
+
+		ptype = HFI_PROPERTY_PARAM_VENC_MAX_NUM_B_FRAMES;
+		ret = hfi_session_set_property(inst, ptype, &max_num_b_frames);
+		if (ret)
+			return ret;
+	}
+
+	/* intra_period = pframes + bframes + 1 */
+	if (!ctr->num_p_frames)
+		ctr->num_p_frames = 2 * 15 - 1,
+
+	ptype = HFI_PROPERTY_CONFIG_VENC_INTRA_PERIOD;
+	intra_period.pframes = ctr->num_p_frames;
+	intra_period.bframes = ctr->num_b_frames;
+
+	ret = hfi_session_set_property(inst, ptype, &intra_period);
+	if (ret)
+		return ret;
+
+	if (ctr->bitrate_mode == V4L2_MPEG_VIDEO_BITRATE_MODE_VBR)
+		rate_control = HFI_RATE_CONTROL_VBR_CFR;
+	else
+		rate_control = HFI_RATE_CONTROL_CBR_CFR;
+
+	ptype = HFI_PROPERTY_PARAM_VENC_RATE_CONTROL;
+	ret = hfi_session_set_property(inst, ptype, &rate_control);
+	if (ret)
+		return ret;
+
+	if (!ctr->bitrate)
+		bitrate = 64000;
+	else
+		bitrate = ctr->bitrate;
+
+	ptype = HFI_PROPERTY_CONFIG_VENC_TARGET_BITRATE;
+	brate.bitrate = bitrate;
+	brate.layer_id = 0;
+
+	ret = hfi_session_set_property(inst, ptype, &brate);
+	if (ret)
+		return ret;
+
+	if (!ctr->bitrate_peak)
+		bitrate *= 2;
+	else
+		bitrate = ctr->bitrate_peak;
+
+	ptype = HFI_PROPERTY_CONFIG_VENC_MAX_BITRATE;
+	brate.bitrate = bitrate;
+	brate.layer_id = 0;
+
+	ret = hfi_session_set_property(inst, ptype, &brate);
+	if (ret)
+		return ret;
+
+	if (inst->fmt_cap->pixfmt == V4L2_PIX_FMT_H264) {
+		profile = venc_v4l2_to_hfi(V4L2_CID_MPEG_VIDEO_H264_PROFILE,
+					   ctr->profile);
+		level = venc_v4l2_to_hfi(V4L2_CID_MPEG_VIDEO_H264_LEVEL,
+					 ctr->level);
+	} else if (inst->fmt_cap->pixfmt == V4L2_PIX_FMT_VP8) {
+		profile = venc_v4l2_to_hfi(V4L2_CID_MPEG_VIDEO_VPX_PROFILE,
+					   ctr->profile);
+		level = 0;
+	} else if (inst->fmt_cap->pixfmt == V4L2_PIX_FMT_MPEG4) {
+		profile = venc_v4l2_to_hfi(V4L2_CID_MPEG_VIDEO_MPEG4_PROFILE,
+					   ctr->profile);
+		level = venc_v4l2_to_hfi(V4L2_CID_MPEG_VIDEO_MPEG4_LEVEL,
+					 ctr->level);
+	} else if (inst->fmt_cap->pixfmt == V4L2_PIX_FMT_H263) {
+		profile = 0;
+		level = 0;
+	}
+
+	ptype = HFI_PROPERTY_PARAM_PROFILE_LEVEL_CURRENT;
+	pl.profile = profile;
+	pl.level = level;
+
+	ret = hfi_session_set_property(inst, ptype, &pl);
+	if (ret)
+		return ret;
+
+	return 0;
+}
+
+static int venc_init_session(struct venus_inst *inst)
+{
+	int ret;
+
+	ret = hfi_session_init(inst, inst->fmt_cap->pixfmt);
+	if (ret)
+		return ret;
+
+	ret = helper_set_input_resolution(inst, inst->out_width,
+					  inst->out_height);
+	if (ret)
+		goto deinit;
+
+	ret = helper_set_output_resolution(inst, inst->width, inst->height);
+	if (ret)
+		goto deinit;
+
+	ret = helper_set_color_format(inst, inst->fmt_out->pixfmt);
+	if (ret)
+		goto deinit;
+
+	return 0;
+deinit:
+	hfi_session_deinit(inst);
+	return ret;
+}
+
+static int venc_out_num_buffers(struct venus_inst *inst, unsigned int *num)
+{
+	struct hfi_buffer_requirements bufreq;
+	int ret;
+
+	ret = venc_init_session(inst);
+	if (ret)
+		return ret;
+
+	ret = helper_get_bufreq(inst, HFI_BUFFER_INPUT, &bufreq);
+
+	*num = bufreq.count_actual;
+
+	hfi_session_deinit(inst);
+
+	return ret;
+}
+
+static int venc_queue_setup(struct vb2_queue *q,
+			    unsigned int *num_buffers, unsigned int *num_planes,
+			    unsigned int sizes[], struct device *alloc_devs[])
+{
+	struct venus_inst *inst = vb2_get_drv_priv(q);
+	unsigned int p, num, min = 4;
+	int ret = 0;
+
+	switch (q->type) {
+	case V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE:
+		*num_planes = inst->fmt_out->num_planes;
+
+		ret = venc_out_num_buffers(inst, &num);
+		if (ret)
+			break;
+
+		num = max(num, min);
+		*num_buffers = max(*num_buffers, num);
+		inst->num_input_bufs = *num_buffers;
+
+		for (p = 0; p < *num_planes; ++p)
+			sizes[p] = get_framesize_uncompressed(p, inst->width,
+							      inst->height);
+		break;
+	case V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE:
+		*num_planes = inst->fmt_cap->num_planes;
+		*num_buffers = max(*num_buffers, min);
+		inst->num_output_bufs = *num_buffers;
+		sizes[0] = get_framesize_compressed(inst->width, inst->height);
+		break;
+	default:
+		ret = -EINVAL;
+		break;
+	}
+
+	return ret;
+}
+
+static int venc_verify_conf(struct venus_inst *inst)
+{
+	struct hfi_buffer_requirements bufreq;
+	int ret;
+
+	if (!inst->num_input_bufs || !inst->num_output_bufs)
+		return -EINVAL;
+
+	ret = helper_get_bufreq(inst, HFI_BUFFER_OUTPUT, &bufreq);
+	if (ret)
+		return ret;
+
+	if (inst->num_output_bufs < bufreq.count_actual ||
+	    inst->num_output_bufs < bufreq.count_min)
+		return -EINVAL;
+
+	ret = helper_get_bufreq(inst, HFI_BUFFER_INPUT, &bufreq);
+	if (ret)
+		return ret;
+
+	if (inst->num_input_bufs < bufreq.count_actual ||
+	    inst->num_input_bufs < bufreq.count_min)
+		return -EINVAL;
+
+	return 0;
+}
+
+static int venc_start_streaming(struct vb2_queue *q, unsigned int count)
+{
+	struct venus_inst *inst = vb2_get_drv_priv(q);
+	int ret;
+
+	mutex_lock(&inst->lock);
+
+	if (q->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE)
+		inst->streamon_out = 1;
+	else
+		inst->streamon_cap = 1;
+
+	if (!(inst->streamon_out & inst->streamon_cap)) {
+		mutex_unlock(&inst->lock);
+		return 0;
+	}
+
+	inst->sequence = 0;
+
+	ret = venc_init_session(inst);
+	if (ret)
+		goto bufs_done;
+
+	ret = venc_set_properties(inst);
+	if (ret)
+		goto deinit_sess;
+
+	ret = venc_verify_conf(inst);
+	if (ret)
+		goto deinit_sess;
+
+	ret = helper_set_num_bufs(inst, inst->num_input_bufs,
+				  inst->num_output_bufs);
+	if (ret)
+		goto deinit_sess;
+
+	ret = helper_vb2_start_streaming(inst);
+	if (ret)
+		goto deinit_sess;
+
+	mutex_unlock(&inst->lock);
+
+	return 0;
+
+deinit_sess:
+	hfi_session_deinit(inst);
+bufs_done:
+	helper_buffers_done(inst, VB2_BUF_STATE_QUEUED);
+	if (q->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE)
+		inst->streamon_out = 0;
+	else
+		inst->streamon_cap = 0;
+	mutex_unlock(&inst->lock);
+	return ret;
+}
+
+static const struct vb2_ops venc_vb2_ops = {
+	.queue_setup = venc_queue_setup,
+	.buf_init = helper_vb2_buf_init,
+	.buf_prepare = helper_vb2_buf_prepare,
+	.start_streaming = venc_start_streaming,
+	.stop_streaming = helper_vb2_stop_streaming,
+	.buf_queue = helper_vb2_buf_queue,
+};
+
+static void venc_buf_done(struct venus_inst *inst, unsigned int buf_type,
+			  u32 tag, u32 bytesused, u32 data_offset, u32 flags,
+			  u64 timestamp_us)
+{
+	struct vb2_v4l2_buffer *vbuf;
+	struct vb2_buffer *vb;
+	unsigned int type;
+
+	if (buf_type == HFI_BUFFER_INPUT)
+		type = V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE;
+	else
+		type = V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE;
+
+	vbuf = helper_find_buf(inst, type, tag);
+	if (!vbuf)
+		return;
+
+	vb = &vbuf->vb2_buf;
+	vb->planes[0].bytesused = bytesused;
+	vb->planes[0].data_offset = data_offset;
+
+	vbuf->flags = flags;
+
+	if (type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE) {
+		vb->timestamp = timestamp_us * NSEC_PER_USEC;
+		vbuf->sequence = inst->sequence++;
+	}
+
+	v4l2_m2m_buf_done(vbuf, VB2_BUF_STATE_DONE);
+}
+
+static void venc_event_notify(struct venus_inst *inst, u32 event,
+			      struct hfi_event_data *data)
+{
+	struct device *dev = inst->core->dev_enc;
+
+	if (event == EVT_SESSION_ERROR) {
+		inst->session_error = true;
+		dev_err(dev, "enc: event session error %x\n", inst->error);
+	}
+}
+
+static const struct hfi_inst_ops venc_hfi_ops = {
+	.buf_done = venc_buf_done,
+	.event_notify = venc_event_notify,
+};
+
+static const struct v4l2_m2m_ops venc_m2m_ops = {
+	.device_run = helper_m2m_device_run,
+	.job_abort = helper_m2m_job_abort,
+};
+
+static int m2m_queue_init(void *priv, struct vb2_queue *src_vq,
+			  struct vb2_queue *dst_vq)
+{
+	struct venus_inst *inst = priv;
+	int ret;
+
+	src_vq->type = V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE;
+	src_vq->io_modes = VB2_MMAP | VB2_DMABUF;
+	src_vq->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_COPY;
+	src_vq->ops = &venc_vb2_ops;
+	src_vq->mem_ops = &vb2_dma_sg_memops;
+	src_vq->drv_priv = inst;
+	src_vq->buf_struct_size = sizeof(struct venus_buffer);
+	src_vq->allow_zero_bytesused = 1;
+	src_vq->min_buffers_needed = 1;
+	src_vq->dev = inst->core->dev;
+	ret = vb2_queue_init(src_vq);
+	if (ret)
+		return ret;
+
+	dst_vq->type = V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE;
+	dst_vq->io_modes = VB2_MMAP | VB2_DMABUF;
+	dst_vq->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_COPY;
+	dst_vq->ops = &venc_vb2_ops;
+	dst_vq->mem_ops = &vb2_dma_sg_memops;
+	dst_vq->drv_priv = inst;
+	dst_vq->buf_struct_size = sizeof(struct venus_buffer);
+	dst_vq->allow_zero_bytesused = 1;
+	dst_vq->min_buffers_needed = 1;
+	dst_vq->dev = inst->core->dev;
+	ret = vb2_queue_init(dst_vq);
+	if (ret) {
+		vb2_queue_release(src_vq);
+		return ret;
+	}
+
+	return 0;
+}
+
+static void venc_inst_init(struct venus_inst *inst)
+{
+	inst->fmt_cap = &venc_formats[2];
+	inst->fmt_out = &venc_formats[0];
+	inst->width = 1280;
+	inst->height = ALIGN(720, 32);
+	inst->fps = 15;
+	inst->timeperframe.numerator = 1;
+	inst->timeperframe.denominator = 15;
+
+	inst->cap_width.min = 64;
+	inst->cap_width.max = 1920;
+	inst->cap_width.step_size = 1;
+	inst->cap_height.min = 64;
+	inst->cap_height.max = ALIGN(1080, 32);
+	inst->cap_height.step_size = 1;
+	inst->cap_framerate.min = 1;
+	inst->cap_framerate.max = 30;
+	inst->cap_framerate.step_size = 1;
+	inst->cap_mbs_per_frame.min = 16;
+	inst->cap_mbs_per_frame.max = 8160;
+}
+
+static int venc_open(struct file *file)
+{
+	struct venus_core *core = video_drvdata(file);
+	struct venus_inst *inst;
+	int ret;
+
+	inst = kzalloc(sizeof(*inst), GFP_KERNEL);
+	if (!inst)
+		return -ENOMEM;
+
+	INIT_LIST_HEAD(&inst->registeredbufs);
+	INIT_LIST_HEAD(&inst->internalbufs);
+	INIT_LIST_HEAD(&inst->list);
+	mutex_init(&inst->lock);
+
+	inst->core = core;
+	inst->session_type = VIDC_SESSION_TYPE_ENC;
+
+	ret = pm_runtime_get_sync(core->dev_enc);
+	if (ret < 0)
+		goto err_free_inst;
+
+	ret = venc_ctrl_init(inst);
+	if (ret)
+		goto err_put_sync;
+
+	ret = hfi_session_create(inst, &venc_hfi_ops);
+	if (ret)
+		goto err_ctrl_deinit;
+
+	venc_inst_init(inst);
+
+	/*
+	 * create m2m device for every instance, the m2m context scheduling
+	 * is made by firmware side so we do not need to care about.
+	 */
+	inst->m2m_dev = v4l2_m2m_init(&venc_m2m_ops);
+	if (IS_ERR(inst->m2m_dev)) {
+		ret = PTR_ERR(inst->m2m_dev);
+		goto err_session_destroy;
+	}
+
+	inst->m2m_ctx = v4l2_m2m_ctx_init(inst->m2m_dev, inst, m2m_queue_init);
+	if (IS_ERR(inst->m2m_ctx)) {
+		ret = PTR_ERR(inst->m2m_ctx);
+		goto err_m2m_release;
+	}
+
+	v4l2_fh_init(&inst->fh, core->vdev_enc);
+
+	inst->fh.ctrl_handler = &inst->ctrl_handler;
+	v4l2_fh_add(&inst->fh);
+	inst->fh.m2m_ctx = inst->m2m_ctx;
+	file->private_data = &inst->fh;
+
+	return 0;
+
+err_m2m_release:
+	v4l2_m2m_release(inst->m2m_dev);
+err_session_destroy:
+	hfi_session_destroy(inst);
+err_ctrl_deinit:
+	venc_ctrl_deinit(inst);
+err_put_sync:
+	pm_runtime_put_sync(core->dev_enc);
+err_free_inst:
+	kfree(inst);
+	return ret;
+}
+
+static int venc_close(struct file *file)
+{
+	struct venus_inst *inst = to_inst(file);
+
+	v4l2_m2m_ctx_release(inst->m2m_ctx);
+	v4l2_m2m_release(inst->m2m_dev);
+	venc_ctrl_deinit(inst);
+	hfi_session_destroy(inst);
+	mutex_destroy(&inst->lock);
+	v4l2_fh_del(&inst->fh);
+	v4l2_fh_exit(&inst->fh);
+	kfree(inst);
+
+	pm_runtime_put_sync(inst->core->dev_enc);
+
+	return 0;
+}
+
+static const struct v4l2_file_operations venc_fops = {
+	.owner = THIS_MODULE,
+	.open = venc_open,
+	.release = venc_close,
+	.unlocked_ioctl = video_ioctl2,
+	.poll = v4l2_m2m_fop_poll,
+	.mmap = v4l2_m2m_fop_mmap,
+#ifdef CONFIG_COMPAT
+	.compat_ioctl32 = v4l2_compat_ioctl32,
+#endif
+};
+
+static int venc_probe(struct platform_device *pdev)
+{
+	struct device *dev = &pdev->dev;
+	struct video_device *vdev;
+	struct venus_core *core;
+	int ret;
+
+	if (!dev->parent)
+		return -EPROBE_DEFER;
+
+	core = dev_get_drvdata(dev->parent);
+	if (!core)
+		return -EPROBE_DEFER;
+
+	if (core->res->hfi_version == HFI_VERSION_3XX) {
+		core->core1_clk = devm_clk_get(dev, "core");
+		if (IS_ERR(core->core1_clk))
+			return PTR_ERR(core->core1_clk);
+	}
+
+	platform_set_drvdata(pdev, core);
+
+	vdev = video_device_alloc();
+	if (!vdev)
+		return -ENOMEM;
+
+	vdev->release = video_device_release;
+	vdev->fops = &venc_fops;
+	vdev->ioctl_ops = &venc_ioctl_ops;
+	vdev->vfl_dir = VFL_DIR_M2M;
+	vdev->v4l2_dev = &core->v4l2_dev;
+	vdev->device_caps = V4L2_CAP_VIDEO_M2M_MPLANE | V4L2_CAP_STREAMING;
+
+	ret = video_register_device(vdev, VFL_TYPE_GRABBER, -1);
+	if (ret)
+		goto err_vdev_release;
+
+	core->vdev_enc = vdev;
+	core->dev_enc = dev;
+
+	video_set_drvdata(vdev, core);
+	pm_runtime_enable(dev);
+
+	return 0;
+
+err_vdev_release:
+	video_device_release(vdev);
+	return ret;
+}
+
+static int venc_remove(struct platform_device *pdev)
+{
+	struct venus_core *core = dev_get_drvdata(pdev->dev.parent);
+
+	video_unregister_device(core->vdev_enc);
+	pm_runtime_disable(core->dev_enc);
+
+	return 0;
+}
+
+#ifdef CONFIG_PM
+static int venc_runtime_suspend(struct device *dev)
+{
+	struct venus_core *core = dev_get_drvdata(dev);
+
+	if (core->res->hfi_version == HFI_VERSION_LEGACY)
+		return 0;
+
+	writel(0, core->base + WRAPPER_VENC_VCODEC_POWER_CONTROL);
+	clk_disable_unprepare(core->core1_clk);
+	writel(1, core->base + WRAPPER_VENC_VCODEC_POWER_CONTROL);
+
+	return 0;
+}
+
+static int venc_runtime_resume(struct device *dev)
+{
+	struct venus_core *core = dev_get_drvdata(dev);
+	int ret;
+
+	if (core->res->hfi_version == HFI_VERSION_LEGACY)
+		return 0;
+
+	writel(0, core->base + WRAPPER_VENC_VCODEC_POWER_CONTROL);
+	ret = clk_prepare_enable(core->core1_clk);
+	writel(1, core->base + WRAPPER_VENC_VCODEC_POWER_CONTROL);
+
+	return ret;
+}
+#endif
+
+static const struct dev_pm_ops venc_pm_ops = {
+	SET_SYSTEM_SLEEP_PM_OPS(pm_runtime_force_suspend,
+				pm_runtime_force_resume)
+	SET_RUNTIME_PM_OPS(venc_runtime_suspend, venc_runtime_resume, NULL)
+};
+
+static const struct of_device_id venc_dt_match[] = {
+	{ .compatible = "venus-encoder" },
+	{ }
+};
+MODULE_DEVICE_TABLE(of, venc_dt_match);
+
+static struct platform_driver qcom_venus_enc_driver = {
+	.probe = venc_probe,
+	.remove = venc_remove,
+	.driver = {
+		.name = "qcom-venus-encoder",
+		.of_match_table = venc_dt_match,
+		.pm = &venc_pm_ops,
+	},
+};
+module_platform_driver(qcom_venus_enc_driver);
+
+MODULE_ALIAS("platform:qcom-venus-encoder");
+MODULE_DESCRIPTION("Qualcomm Venus video encoder driver");
+MODULE_LICENSE("GPL v2");
diff --git a/drivers/media/platform/qcom/venus/venc.h b/drivers/media/platform/qcom/venus/venc.h
new file mode 100644
index 000000000000..9daca669f307
--- /dev/null
+++ b/drivers/media/platform/qcom/venus/venc.h
@@ -0,0 +1,23 @@
+/*
+ * Copyright (c) 2012-2016, The Linux Foundation. All rights reserved.
+ * Copyright (C) 2017 Linaro Ltd.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ */
+#ifndef __VENUS_VENC_H__
+#define __VENUS_VENC_H__
+
+struct venus_inst;
+
+int venc_ctrl_init(struct venus_inst *inst);
+void venc_ctrl_deinit(struct venus_inst *inst);
+
+#endif
diff --git a/drivers/media/platform/qcom/venus/venc_ctrls.c b/drivers/media/platform/qcom/venus/venc_ctrls.c
new file mode 100644
index 000000000000..0d2eecea7edb
--- /dev/null
+++ b/drivers/media/platform/qcom/venus/venc_ctrls.c
@@ -0,0 +1,258 @@
+/*
+ * Copyright (c) 2012-2016, The Linux Foundation. All rights reserved.
+ * Copyright (C) 2017 Linaro Ltd.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ */
+#include <linux/types.h>
+#include <media/v4l2-ctrls.h>
+
+#include "core.h"
+
+#define BITRATE_MIN		32000
+#define BITRATE_MAX		160000000
+#define BITRATE_DEFAULT		1000000
+#define BITRATE_DEFAULT_PEAK	(BITRATE_DEFAULT * 2)
+#define BITRATE_STEP		100
+#define SLICE_BYTE_SIZE_MAX	1024
+#define SLICE_BYTE_SIZE_MIN	1024
+#define SLICE_MB_SIZE_MAX	300
+#define INTRA_REFRESH_MBS_MAX	300
+#define AT_SLICE_BOUNDARY	\
+	V4L2_MPEG_VIDEO_H264_LOOP_FILTER_MODE_DISABLED_AT_SLICE_BOUNDARY
+
+static int venc_op_s_ctrl(struct v4l2_ctrl *ctrl)
+{
+	struct venus_inst *inst = ctrl_to_inst(ctrl);
+	struct venc_controls *ctr = &inst->controls.enc;
+
+	switch (ctrl->id) {
+	case V4L2_CID_MPEG_VIDEO_BITRATE_MODE:
+		ctr->bitrate_mode = ctrl->val;
+		break;
+	case V4L2_CID_MPEG_VIDEO_BITRATE:
+		ctr->bitrate = ctrl->val;
+		break;
+	case V4L2_CID_MPEG_VIDEO_BITRATE_PEAK:
+		ctr->bitrate_peak = ctrl->val;
+		break;
+	case V4L2_CID_MPEG_VIDEO_H264_ENTROPY_MODE:
+		ctr->h264_entropy_mode = ctrl->val;
+		break;
+	case V4L2_CID_MPEG_VIDEO_MPEG4_PROFILE:
+	case V4L2_CID_MPEG_VIDEO_H264_PROFILE:
+	case V4L2_CID_MPEG_VIDEO_VPX_PROFILE:
+		ctr->profile = ctrl->val;
+		break;
+	case V4L2_CID_MPEG_VIDEO_MPEG4_LEVEL:
+	case V4L2_CID_MPEG_VIDEO_H264_LEVEL:
+		ctr->level = ctrl->val;
+		break;
+	case V4L2_CID_MPEG_VIDEO_H264_I_FRAME_QP:
+		ctr->h264_i_qp = ctrl->val;
+		break;
+	case V4L2_CID_MPEG_VIDEO_H264_P_FRAME_QP:
+		ctr->h264_p_qp = ctrl->val;
+		break;
+	case V4L2_CID_MPEG_VIDEO_H264_B_FRAME_QP:
+		ctr->h264_b_qp = ctrl->val;
+		break;
+	case V4L2_CID_MPEG_VIDEO_H264_MIN_QP:
+		ctr->h264_min_qp = ctrl->val;
+		break;
+	case V4L2_CID_MPEG_VIDEO_H264_MAX_QP:
+		ctr->h264_max_qp = ctrl->val;
+		break;
+	case V4L2_CID_MPEG_VIDEO_MULTI_SLICE_MODE:
+		ctr->multi_slice_mode = ctrl->val;
+		break;
+	case V4L2_CID_MPEG_VIDEO_MULTI_SLICE_MAX_BYTES:
+		ctr->multi_slice_max_bytes = ctrl->val;
+		break;
+	case V4L2_CID_MPEG_VIDEO_MULTI_SLICE_MAX_MB:
+		ctr->multi_slice_max_mb = ctrl->val;
+		break;
+	case V4L2_CID_MPEG_VIDEO_H264_LOOP_FILTER_ALPHA:
+		ctr->h264_loop_filter_alpha = ctrl->val;
+		break;
+	case V4L2_CID_MPEG_VIDEO_H264_LOOP_FILTER_BETA:
+		ctr->h264_loop_filter_beta = ctrl->val;
+		break;
+	case V4L2_CID_MPEG_VIDEO_H264_LOOP_FILTER_MODE:
+		ctr->h264_loop_filter_mode = ctrl->val;
+		break;
+	case V4L2_CID_MPEG_VIDEO_HEADER_MODE:
+		ctr->header_mode = ctrl->val;
+		break;
+	case V4L2_CID_MPEG_VIDEO_CYCLIC_INTRA_REFRESH_MB:
+		break;
+	case V4L2_CID_MPEG_VIDEO_GOP_SIZE:
+		ctr->gop_size = ctrl->val;
+		break;
+	case V4L2_CID_MPEG_VIDEO_H264_I_PERIOD:
+		ctr->h264_i_period = ctrl->val;
+		break;
+	case V4L2_CID_MPEG_VIDEO_VPX_MIN_QP:
+		ctr->vp8_min_qp = ctrl->val;
+		break;
+	case V4L2_CID_MPEG_VIDEO_VPX_MAX_QP:
+		ctr->vp8_max_qp = ctrl->val;
+		break;
+	case V4L2_CID_MPEG_VIDEO_B_FRAMES:
+		ctr->num_b_frames = ctrl->val;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static const struct v4l2_ctrl_ops venc_ctrl_ops = {
+	.s_ctrl = venc_op_s_ctrl,
+};
+
+int venc_ctrl_init(struct venus_inst *inst)
+{
+	int ret;
+
+	ret = v4l2_ctrl_handler_init(&inst->ctrl_handler, 27);
+	if (ret)
+		return ret;
+
+	v4l2_ctrl_new_std_menu(&inst->ctrl_handler, &venc_ctrl_ops,
+		V4L2_CID_MPEG_VIDEO_BITRATE_MODE,
+		V4L2_MPEG_VIDEO_BITRATE_MODE_CBR,
+		~((1 << V4L2_MPEG_VIDEO_BITRATE_MODE_VBR) |
+		  (1 << V4L2_MPEG_VIDEO_BITRATE_MODE_CBR)),
+		V4L2_MPEG_VIDEO_BITRATE_MODE_VBR);
+
+	v4l2_ctrl_new_std_menu(&inst->ctrl_handler, &venc_ctrl_ops,
+		V4L2_CID_MPEG_VIDEO_H264_ENTROPY_MODE,
+		V4L2_MPEG_VIDEO_H264_ENTROPY_MODE_CABAC,
+		0, V4L2_MPEG_VIDEO_H264_ENTROPY_MODE_CAVLC);
+
+	v4l2_ctrl_new_std_menu(&inst->ctrl_handler, &venc_ctrl_ops,
+		V4L2_CID_MPEG_VIDEO_MPEG4_PROFILE,
+		V4L2_MPEG_VIDEO_MPEG4_PROFILE_ADVANCED_CODING_EFFICIENCY,
+		~((1 << V4L2_MPEG_VIDEO_MPEG4_PROFILE_SIMPLE) |
+		  (1 << V4L2_MPEG_VIDEO_MPEG4_PROFILE_ADVANCED_SIMPLE)),
+		V4L2_MPEG_VIDEO_MPEG4_PROFILE_SIMPLE);
+
+	v4l2_ctrl_new_std_menu(&inst->ctrl_handler, &venc_ctrl_ops,
+		V4L2_CID_MPEG_VIDEO_MPEG4_LEVEL,
+		V4L2_MPEG_VIDEO_MPEG4_LEVEL_5,
+		0, V4L2_MPEG_VIDEO_MPEG4_LEVEL_0);
+
+	v4l2_ctrl_new_std_menu(&inst->ctrl_handler, &venc_ctrl_ops,
+		V4L2_CID_MPEG_VIDEO_H264_PROFILE,
+		V4L2_MPEG_VIDEO_H264_PROFILE_MULTIVIEW_HIGH,
+		~((1 << V4L2_MPEG_VIDEO_H264_PROFILE_BASELINE) |
+		  (1 << V4L2_MPEG_VIDEO_H264_PROFILE_CONSTRAINED_BASELINE) |
+		  (1 << V4L2_MPEG_VIDEO_H264_PROFILE_MAIN) |
+		  (1 << V4L2_MPEG_VIDEO_H264_PROFILE_HIGH) |
+		  (1 << V4L2_MPEG_VIDEO_H264_PROFILE_STEREO_HIGH) |
+		  (1 << V4L2_MPEG_VIDEO_H264_PROFILE_MULTIVIEW_HIGH)),
+		V4L2_MPEG_VIDEO_H264_PROFILE_HIGH);
+
+	v4l2_ctrl_new_std_menu(&inst->ctrl_handler, &venc_ctrl_ops,
+		V4L2_CID_MPEG_VIDEO_H264_LEVEL,
+		V4L2_MPEG_VIDEO_H264_LEVEL_5_1,
+		0, V4L2_MPEG_VIDEO_H264_LEVEL_1_0);
+
+	v4l2_ctrl_new_std_menu(&inst->ctrl_handler, &venc_ctrl_ops,
+		V4L2_CID_MPEG_VIDEO_H264_LOOP_FILTER_MODE,
+		AT_SLICE_BOUNDARY,
+		0, V4L2_MPEG_VIDEO_H264_LOOP_FILTER_MODE_DISABLED);
+
+	v4l2_ctrl_new_std_menu(&inst->ctrl_handler, &venc_ctrl_ops,
+		V4L2_CID_MPEG_VIDEO_HEADER_MODE,
+		V4L2_MPEG_VIDEO_HEADER_MODE_JOINED_WITH_1ST_FRAME,
+		1 << V4L2_MPEG_VIDEO_HEADER_MODE_JOINED_WITH_1ST_FRAME,
+		V4L2_MPEG_VIDEO_HEADER_MODE_SEPARATE);
+
+	v4l2_ctrl_new_std_menu(&inst->ctrl_handler, &venc_ctrl_ops,
+		V4L2_CID_MPEG_VIDEO_MULTI_SLICE_MODE,
+		V4L2_MPEG_VIDEO_MULTI_SICE_MODE_MAX_BYTES,
+		0, V4L2_MPEG_VIDEO_MULTI_SLICE_MODE_SINGLE);
+
+	v4l2_ctrl_new_std(&inst->ctrl_handler, &venc_ctrl_ops,
+		V4L2_CID_MPEG_VIDEO_BITRATE, BITRATE_MIN, BITRATE_MAX,
+		BITRATE_STEP, BITRATE_DEFAULT);
+
+	v4l2_ctrl_new_std(&inst->ctrl_handler, &venc_ctrl_ops,
+		V4L2_CID_MPEG_VIDEO_BITRATE_PEAK, BITRATE_MIN, BITRATE_MAX,
+		BITRATE_STEP, BITRATE_DEFAULT_PEAK);
+
+	v4l2_ctrl_new_std(&inst->ctrl_handler, &venc_ctrl_ops,
+		V4L2_CID_MPEG_VIDEO_VPX_PROFILE, 0, 3, 1, 0);
+
+	v4l2_ctrl_new_std(&inst->ctrl_handler, &venc_ctrl_ops,
+		V4L2_CID_MPEG_VIDEO_H264_I_FRAME_QP, 1, 51, 1, 26);
+
+	v4l2_ctrl_new_std(&inst->ctrl_handler, &venc_ctrl_ops,
+		V4L2_CID_MPEG_VIDEO_H264_P_FRAME_QP, 1, 51, 1, 28);
+
+	v4l2_ctrl_new_std(&inst->ctrl_handler, &venc_ctrl_ops,
+		V4L2_CID_MPEG_VIDEO_H264_B_FRAME_QP, 1, 51, 1, 30);
+
+	v4l2_ctrl_new_std(&inst->ctrl_handler, &venc_ctrl_ops,
+		V4L2_CID_MPEG_VIDEO_H264_MIN_QP, 1, 51, 1, 1);
+
+	v4l2_ctrl_new_std(&inst->ctrl_handler, &venc_ctrl_ops,
+		V4L2_CID_MPEG_VIDEO_H264_MAX_QP, 1, 51, 1, 51);
+
+	v4l2_ctrl_new_std(&inst->ctrl_handler, &venc_ctrl_ops,
+		V4L2_CID_MPEG_VIDEO_MULTI_SLICE_MAX_BYTES, SLICE_BYTE_SIZE_MIN,
+		SLICE_BYTE_SIZE_MAX, 1, SLICE_BYTE_SIZE_MIN);
+
+	v4l2_ctrl_new_std(&inst->ctrl_handler, &venc_ctrl_ops,
+		V4L2_CID_MPEG_VIDEO_MULTI_SLICE_MAX_MB, 1,
+		SLICE_MB_SIZE_MAX, 1, 1);
+
+	v4l2_ctrl_new_std(&inst->ctrl_handler, &venc_ctrl_ops,
+		V4L2_CID_MPEG_VIDEO_H264_LOOP_FILTER_ALPHA, -6, 6, 1, 0);
+
+	v4l2_ctrl_new_std(&inst->ctrl_handler, &venc_ctrl_ops,
+		V4L2_CID_MPEG_VIDEO_H264_LOOP_FILTER_BETA, -6, 6, 1, 0);
+
+	v4l2_ctrl_new_std(&inst->ctrl_handler, &venc_ctrl_ops,
+		V4L2_CID_MPEG_VIDEO_CYCLIC_INTRA_REFRESH_MB,
+		0, INTRA_REFRESH_MBS_MAX, 1, 0);
+
+	v4l2_ctrl_new_std(&inst->ctrl_handler, &venc_ctrl_ops,
+		V4L2_CID_MPEG_VIDEO_GOP_SIZE, 0, (1 << 16) - 1, 1, 12);
+
+	v4l2_ctrl_new_std(&inst->ctrl_handler, &venc_ctrl_ops,
+		V4L2_CID_MPEG_VIDEO_VPX_MIN_QP, 1, 128, 1, 1);
+
+	v4l2_ctrl_new_std(&inst->ctrl_handler, &venc_ctrl_ops,
+		V4L2_CID_MPEG_VIDEO_VPX_MAX_QP, 1, 128, 1, 128);
+
+	v4l2_ctrl_new_std(&inst->ctrl_handler, &venc_ctrl_ops,
+		V4L2_CID_MPEG_VIDEO_B_FRAMES, 0, 4, 1, 0);
+
+	v4l2_ctrl_new_std(&inst->ctrl_handler, &venc_ctrl_ops,
+		V4L2_CID_MPEG_VIDEO_H264_I_PERIOD, 0, (1 << 16) - 1, 1, 0);
+
+	ret = inst->ctrl_handler.error;
+	if (ret) {
+		v4l2_ctrl_handler_free(&inst->ctrl_handler);
+		return ret;
+	}
+
+	return 0;
+}
+
+void venc_ctrl_deinit(struct venus_inst *inst)
+{
+	v4l2_ctrl_handler_free(&inst->ctrl_handler);
+}
-- 
2.7.4

