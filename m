Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f179.google.com ([209.85.128.179]:37605 "EHLO
        mail-wr0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753543AbdHROQ5 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 18 Aug 2017 10:16:57 -0400
Received: by mail-wr0-f179.google.com with SMTP id z91so62924013wrc.4
        for <linux-media@vger.kernel.org>; Fri, 18 Aug 2017 07:16:56 -0700 (PDT)
From: Stanimir Varbanov <stanimir.varbanov@linaro.org>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>
Cc: Pawel Osciak <pawel@osciak.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>
Subject: [PATCH 6/7] media: venus: use helper function to check supported codecs
Date: Fri, 18 Aug 2017 17:16:05 +0300
Message-Id: <20170818141606.4835-7-stanimir.varbanov@linaro.org>
In-Reply-To: <20170818141606.4835-1-stanimir.varbanov@linaro.org>
References: <20170818141606.4835-1-stanimir.varbanov@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Use the helper function in decoder and encoder find_format
to runtime check supported codecs.

Signed-off-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>
---
 drivers/media/platform/qcom/venus/vdec.c | 24 +++++++++++++++++-------
 drivers/media/platform/qcom/venus/venc.c | 28 +++++++++++++++++++---------
 2 files changed, 36 insertions(+), 16 deletions(-)

diff --git a/drivers/media/platform/qcom/venus/vdec.c b/drivers/media/platform/qcom/venus/vdec.c
index 32a1feb2fe6a..da611a5eb670 100644
--- a/drivers/media/platform/qcom/venus/vdec.c
+++ b/drivers/media/platform/qcom/venus/vdec.c
@@ -102,7 +102,8 @@ static const struct venus_format vdec_formats[] = {
 	},
 };
 
-static const struct venus_format *find_format(u32 pixfmt, u32 type)
+static const struct venus_format *
+find_format(struct venus_inst *inst, u32 pixfmt, u32 type)
 {
 	const struct venus_format *fmt = vdec_formats;
 	unsigned int size = ARRAY_SIZE(vdec_formats);
@@ -116,11 +117,15 @@ static const struct venus_format *find_format(u32 pixfmt, u32 type)
 	if (i == size || fmt[i].type != type)
 		return NULL;
 
+	if (type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE &&
+	    !venus_helper_check_codec(inst, fmt[i].pixfmt))
+		return NULL;
+
 	return &fmt[i];
 }
 
 static const struct venus_format *
-find_format_by_index(unsigned int index, u32 type)
+find_format_by_index(struct venus_inst *inst, unsigned int index, u32 type)
 {
 	const struct venus_format *fmt = vdec_formats;
 	unsigned int size = ARRAY_SIZE(vdec_formats);
@@ -140,6 +145,10 @@ find_format_by_index(unsigned int index, u32 type)
 	if (i == size)
 		return NULL;
 
+	if (type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE &&
+	    !venus_helper_check_codec(inst, fmt[i].pixfmt))
+		return NULL;
+
 	return &fmt[i];
 }
 
@@ -154,7 +163,7 @@ vdec_try_fmt_common(struct venus_inst *inst, struct v4l2_format *f)
 	memset(pfmt[0].reserved, 0, sizeof(pfmt[0].reserved));
 	memset(pixmp->reserved, 0, sizeof(pixmp->reserved));
 
-	fmt = find_format(pixmp->pixelformat, f->type);
+	fmt = find_format(inst, pixmp->pixelformat, f->type);
 	if (!fmt) {
 		if (f->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE)
 			pixmp->pixelformat = V4L2_PIX_FMT_NV12;
@@ -162,7 +171,7 @@ vdec_try_fmt_common(struct venus_inst *inst, struct v4l2_format *f)
 			pixmp->pixelformat = V4L2_PIX_FMT_H264;
 		else
 			return NULL;
-		fmt = find_format(pixmp->pixelformat, f->type);
+		fmt = find_format(inst, pixmp->pixelformat, f->type);
 		pixmp->width = 1280;
 		pixmp->height = 720;
 	}
@@ -364,11 +373,12 @@ vdec_querycap(struct file *file, void *fh, struct v4l2_capability *cap)
 
 static int vdec_enum_fmt(struct file *file, void *fh, struct v4l2_fmtdesc *f)
 {
+	struct venus_inst *inst = to_inst(file);
 	const struct venus_format *fmt;
 
 	memset(f->reserved, 0, sizeof(f->reserved));
 
-	fmt = find_format_by_index(f->index, f->type);
+	fmt = find_format_by_index(inst, f->index, f->type);
 	if (!fmt)
 		return -EINVAL;
 
@@ -417,10 +427,10 @@ static int vdec_enum_framesizes(struct file *file, void *fh,
 	struct venus_inst *inst = to_inst(file);
 	const struct venus_format *fmt;
 
-	fmt = find_format(fsize->pixel_format,
+	fmt = find_format(inst, fsize->pixel_format,
 			  V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE);
 	if (!fmt) {
-		fmt = find_format(fsize->pixel_format,
+		fmt = find_format(inst, fsize->pixel_format,
 				  V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE);
 		if (!fmt)
 			return -EINVAL;
diff --git a/drivers/media/platform/qcom/venus/venc.c b/drivers/media/platform/qcom/venus/venc.c
index bcb50d39f88a..9f459024aa07 100644
--- a/drivers/media/platform/qcom/venus/venc.c
+++ b/drivers/media/platform/qcom/venus/venc.c
@@ -91,7 +91,8 @@ static const struct venus_format venc_formats[] = {
 	},
 };
 
-static const struct venus_format *find_format(u32 pixfmt, u32 type)
+static const struct venus_format *
+find_format(struct venus_inst *inst, u32 pixfmt, u32 type)
 {
 	const struct venus_format *fmt = venc_formats;
 	unsigned int size = ARRAY_SIZE(venc_formats);
@@ -105,11 +106,15 @@ static const struct venus_format *find_format(u32 pixfmt, u32 type)
 	if (i == size || fmt[i].type != type)
 		return NULL;
 
+	if (type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE &&
+	    !venus_helper_check_codec(inst, fmt[i].pixfmt))
+		return NULL;
+
 	return &fmt[i];
 }
 
 static const struct venus_format *
-find_format_by_index(unsigned int index, u32 type)
+find_format_by_index(struct venus_inst *inst, unsigned int index, u32 type)
 {
 	const struct venus_format *fmt = venc_formats;
 	unsigned int size = ARRAY_SIZE(venc_formats);
@@ -129,6 +134,10 @@ find_format_by_index(unsigned int index, u32 type)
 	if (i == size)
 		return NULL;
 
+	if (type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE &&
+	    !venus_helper_check_codec(inst, fmt[i].pixfmt))
+		return NULL;
+
 	return &fmt[i];
 }
 
@@ -246,9 +255,10 @@ venc_querycap(struct file *file, void *fh, struct v4l2_capability *cap)
 
 static int venc_enum_fmt(struct file *file, void *fh, struct v4l2_fmtdesc *f)
 {
+	struct venus_inst *inst = to_inst(file);
 	const struct venus_format *fmt;
 
-	fmt = find_format_by_index(f->index, f->type);
+	fmt = find_format_by_index(inst, f->index, f->type);
 
 	memset(f->reserved, 0, sizeof(f->reserved));
 
@@ -271,7 +281,7 @@ venc_try_fmt_common(struct venus_inst *inst, struct v4l2_format *f)
 	memset(pfmt[0].reserved, 0, sizeof(pfmt[0].reserved));
 	memset(pixmp->reserved, 0, sizeof(pixmp->reserved));
 
-	fmt = find_format(pixmp->pixelformat, f->type);
+	fmt = find_format(inst, pixmp->pixelformat, f->type);
 	if (!fmt) {
 		if (f->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE)
 			pixmp->pixelformat = V4L2_PIX_FMT_H264;
@@ -279,7 +289,7 @@ venc_try_fmt_common(struct venus_inst *inst, struct v4l2_format *f)
 			pixmp->pixelformat = V4L2_PIX_FMT_NV12;
 		else
 			return NULL;
-		fmt = find_format(pixmp->pixelformat, f->type);
+		fmt = find_format(inst, pixmp->pixelformat, f->type);
 		pixmp->width = 1280;
 		pixmp->height = 720;
 	}
@@ -524,10 +534,10 @@ static int venc_enum_framesizes(struct file *file, void *fh,
 
 	fsize->type = V4L2_FRMSIZE_TYPE_STEPWISE;
 
-	fmt = find_format(fsize->pixel_format,
+	fmt = find_format(inst, fsize->pixel_format,
 			  V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE);
 	if (!fmt) {
-		fmt = find_format(fsize->pixel_format,
+		fmt = find_format(inst, fsize->pixel_format,
 				  V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE);
 		if (!fmt)
 			return -EINVAL;
@@ -554,10 +564,10 @@ static int venc_enum_frameintervals(struct file *file, void *fh,
 
 	fival->type = V4L2_FRMIVAL_TYPE_STEPWISE;
 
-	fmt = find_format(fival->pixel_format,
+	fmt = find_format(inst, fival->pixel_format,
 			  V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE);
 	if (!fmt) {
-		fmt = find_format(fival->pixel_format,
+		fmt = find_format(inst, fival->pixel_format,
 				  V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE);
 		if (!fmt)
 			return -EINVAL;
-- 
2.11.0
