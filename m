Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:51022 "EHLO
	lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755370AbbGTNAx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Jul 2015 09:00:53 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Philipp Zabel <p.zabel@pengutronix.de>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Subject: [PATCH 01/12] [media] coda: make NV12 format default
Date: Mon, 20 Jul 2015 14:59:27 +0200
Message-Id: <1437397178-5013-2-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1437397178-5013-1-git-send-email-hverkuil@xs4all.nl>
References: <1437397178-5013-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Philipp Zabel <p.zabel@pengutronix.de>

The chroma interleaved NV12 format has higher memory bandwidth efficiency
because the chroma planes can be read/written with longer burst lengths.
Use NV12 as default format if available and consistently sort it first.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
---
 drivers/media/platform/coda/coda-common.c | 28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/media/platform/coda/coda-common.c b/drivers/media/platform/coda/coda-common.c
index d62b828..04310cd 100644
--- a/drivers/media/platform/coda/coda-common.c
+++ b/drivers/media/platform/coda/coda-common.c
@@ -90,17 +90,17 @@ void coda_write_base(struct coda_ctx *ctx, struct coda_q_data *q_data,
 	u32 base_cb, base_cr;
 
 	switch (q_data->fourcc) {
-	case V4L2_PIX_FMT_YVU420:
-		/* Switch Cb and Cr for YVU420 format */
-		base_cr = base_y + q_data->bytesperline * q_data->height;
-		base_cb = base_cr + q_data->bytesperline * q_data->height / 4;
-		break;
-	case V4L2_PIX_FMT_YUV420:
 	case V4L2_PIX_FMT_NV12:
+	case V4L2_PIX_FMT_YUV420:
 	default:
 		base_cb = base_y + q_data->bytesperline * q_data->height;
 		base_cr = base_cb + q_data->bytesperline * q_data->height / 4;
 		break;
+	case V4L2_PIX_FMT_YVU420:
+		/* Switch Cb and Cr for YVU420 format */
+		base_cr = base_y + q_data->bytesperline * q_data->height;
+		base_cb = base_cr + q_data->bytesperline * q_data->height / 4;
+		break;
 	case V4L2_PIX_FMT_YUV422P:
 		base_cb = base_y + q_data->bytesperline * q_data->height;
 		base_cr = base_cb + q_data->bytesperline * q_data->height / 2;
@@ -156,9 +156,9 @@ static const struct coda_video_device coda_bit_encoder = {
 	.type = CODA_INST_ENCODER,
 	.ops = &coda_bit_encode_ops,
 	.src_formats = {
+		V4L2_PIX_FMT_NV12,
 		V4L2_PIX_FMT_YUV420,
 		V4L2_PIX_FMT_YVU420,
-		V4L2_PIX_FMT_NV12,
 	},
 	.dst_formats = {
 		V4L2_PIX_FMT_H264,
@@ -171,9 +171,9 @@ static const struct coda_video_device coda_bit_jpeg_encoder = {
 	.type = CODA_INST_ENCODER,
 	.ops = &coda_bit_encode_ops,
 	.src_formats = {
+		V4L2_PIX_FMT_NV12,
 		V4L2_PIX_FMT_YUV420,
 		V4L2_PIX_FMT_YVU420,
-		V4L2_PIX_FMT_NV12,
 		V4L2_PIX_FMT_YUV422P,
 	},
 	.dst_formats = {
@@ -190,9 +190,9 @@ static const struct coda_video_device coda_bit_decoder = {
 		V4L2_PIX_FMT_MPEG4,
 	},
 	.dst_formats = {
+		V4L2_PIX_FMT_NV12,
 		V4L2_PIX_FMT_YUV420,
 		V4L2_PIX_FMT_YVU420,
-		V4L2_PIX_FMT_NV12,
 	},
 };
 
@@ -204,9 +204,9 @@ static const struct coda_video_device coda_bit_jpeg_decoder = {
 		V4L2_PIX_FMT_JPEG,
 	},
 	.dst_formats = {
+		V4L2_PIX_FMT_NV12,
 		V4L2_PIX_FMT_YUV420,
 		V4L2_PIX_FMT_YVU420,
-		V4L2_PIX_FMT_NV12,
 		V4L2_PIX_FMT_YUV422P,
 	},
 };
@@ -234,9 +234,9 @@ static const struct coda_video_device *coda9_video_devices[] = {
 static u32 coda_format_normalize_yuv(u32 fourcc)
 {
 	switch (fourcc) {
+	case V4L2_PIX_FMT_NV12:
 	case V4L2_PIX_FMT_YUV420:
 	case V4L2_PIX_FMT_YVU420:
-	case V4L2_PIX_FMT_NV12:
 	case V4L2_PIX_FMT_YUV422P:
 		return V4L2_PIX_FMT_YUV420;
 	default:
@@ -448,9 +448,9 @@ static int coda_try_fmt(struct coda_ctx *ctx, const struct coda_codec *codec,
 			      S_ALIGN);
 
 	switch (f->fmt.pix.pixelformat) {
+	case V4L2_PIX_FMT_NV12:
 	case V4L2_PIX_FMT_YUV420:
 	case V4L2_PIX_FMT_YVU420:
-	case V4L2_PIX_FMT_NV12:
 		/*
 		 * Frame stride must be at least multiple of 8,
 		 * but multiple of 16 for h.264 or JPEG 4:2:x
@@ -1099,8 +1099,8 @@ static void set_default_params(struct coda_ctx *ctx)
 	ctx->params.framerate = 30;
 
 	/* Default formats for output and input queues */
-	ctx->q_data[V4L2_M2M_SRC].fourcc = ctx->codec->src_fourcc;
-	ctx->q_data[V4L2_M2M_DST].fourcc = ctx->codec->dst_fourcc;
+	ctx->q_data[V4L2_M2M_SRC].fourcc = ctx->cvd->src_formats[0];
+	ctx->q_data[V4L2_M2M_DST].fourcc = ctx->cvd->dst_formats[0];
 	ctx->q_data[V4L2_M2M_SRC].width = max_w;
 	ctx->q_data[V4L2_M2M_SRC].height = max_h;
 	ctx->q_data[V4L2_M2M_DST].width = max_w;
-- 
2.1.4

