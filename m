Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:60821 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755666AbbAWQvk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 23 Jan 2015 11:51:40 -0500
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Kamil Debski <k.debski@samsung.com>
Cc: linux-media@vger.kernel.org, Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH 15/21] [media] coda: add coda_estimate_sizeimage and use it in set_defaults
Date: Fri, 23 Jan 2015 17:51:29 +0100
Message-Id: <1422031895-7740-16-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1422031895-7740-1-git-send-email-p.zabel@pengutronix.de>
References: <1422031895-7740-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Call coda_estimate_sizeimage from both try_fmt and set_defaults to
avoid this v4l2-compliance warning on the h.264 decoder video device:

    G_FMT:     1920x1088, 32315559, 1, 1920, 1048576, 3, 0, 0, feedcafe
    TRY/S_FMT: 1920x1088, 32315559, 1, 1920, 3133440, 3, 0, 0, feedcafe
    fail: v4l2-test-formats.cpp(948): Video Capture: S_FMT(G_FMT) != G_FMT

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/platform/coda/coda-common.c | 38 +++++++++++++++++++------------
 1 file changed, 23 insertions(+), 15 deletions(-)

diff --git a/drivers/media/platform/coda/coda-common.c b/drivers/media/platform/coda/coda-common.c
index 6ea7e0a..f7fc355 100644
--- a/drivers/media/platform/coda/coda-common.c
+++ b/drivers/media/platform/coda/coda-common.c
@@ -468,6 +468,18 @@ static int coda_try_pixelformat(struct coda_ctx *ctx, struct v4l2_format *f)
 	return 0;
 }
 
+static unsigned int coda_estimate_sizeimage(struct coda_ctx *ctx, u32 sizeimage,
+					    u32 width, u32 height)
+{
+	/*
+	 * This is a rough estimate for sensible compressed buffer
+	 * sizes (between 1 and 16 bits per pixel). This could be
+	 * improved by better format specific worst case estimates.
+	 */
+	return round_up(clamp(sizeimage, width * height / 8,
+					 width * height * 2), PAGE_SIZE);
+}
+
 static int coda_try_fmt(struct coda_ctx *ctx, const struct coda_codec *codec,
 			struct v4l2_format *f)
 {
@@ -513,15 +525,10 @@ static int coda_try_fmt(struct coda_ctx *ctx, const struct coda_codec *codec,
 	case V4L2_PIX_FMT_H264:
 	case V4L2_PIX_FMT_MPEG4:
 		f->fmt.pix.bytesperline = 0;
-		/*
-		 * This is a rough estimate for sensible compressed buffer
-		 * sizes (between 1 and 16 bits per pixel). This could be
-		 * improved by better format specific worst case estimates.
-		 */
-		f->fmt.pix.sizeimage = round_up(clamp(f->fmt.pix.sizeimage,
-				f->fmt.pix.width * f->fmt.pix.height / 8,
-				f->fmt.pix.width * f->fmt.pix.height * 2),
-				PAGE_SIZE);
+		f->fmt.pix.sizeimage = coda_estimate_sizeimage(ctx,
+							f->fmt.pix.sizeimage,
+							f->fmt.pix.width,
+							f->fmt.pix.height);
 		break;
 	default:
 		BUG();
@@ -1056,13 +1063,14 @@ static void coda_set_tiled_map_type(struct coda_ctx *ctx, int tiled_map_type)
 
 static void set_default_params(struct coda_ctx *ctx)
 {
-	unsigned int max_w, max_h, size;
+	unsigned int max_w, max_h, usize, csize;
 
 	ctx->codec = coda_find_codec(ctx->dev, ctx->cvd->src_formats[0],
 				     ctx->cvd->dst_formats[0]);
 	max_w = min(ctx->codec->max_w, 1920U);
 	max_h = min(ctx->codec->max_h, 1088U);
-	size = max_w * max_h * 3 / 2;
+	usize = max_w * max_h * 3 / 2;
+	csize = coda_estimate_sizeimage(ctx, usize, max_w, max_h);
 
 	ctx->params.codec_mode = ctx->codec->mode;
 	ctx->colorspace = V4L2_COLORSPACE_REC709;
@@ -1077,14 +1085,14 @@ static void set_default_params(struct coda_ctx *ctx)
 	ctx->q_data[V4L2_M2M_DST].height = max_h;
 	if (ctx->codec->src_fourcc == V4L2_PIX_FMT_YUV420) {
 		ctx->q_data[V4L2_M2M_SRC].bytesperline = max_w;
-		ctx->q_data[V4L2_M2M_SRC].sizeimage = size;
+		ctx->q_data[V4L2_M2M_SRC].sizeimage = usize;
 		ctx->q_data[V4L2_M2M_DST].bytesperline = 0;
-		ctx->q_data[V4L2_M2M_DST].sizeimage = round_up(size, PAGE_SIZE);
+		ctx->q_data[V4L2_M2M_DST].sizeimage = csize;
 	} else {
 		ctx->q_data[V4L2_M2M_SRC].bytesperline = 0;
-		ctx->q_data[V4L2_M2M_SRC].sizeimage = round_up(size, PAGE_SIZE);
+		ctx->q_data[V4L2_M2M_SRC].sizeimage = csize;
 		ctx->q_data[V4L2_M2M_DST].bytesperline = max_w;
-		ctx->q_data[V4L2_M2M_DST].sizeimage = size;
+		ctx->q_data[V4L2_M2M_DST].sizeimage = usize;
 	}
 	ctx->q_data[V4L2_M2M_SRC].rect.width = max_w;
 	ctx->q_data[V4L2_M2M_SRC].rect.height = max_h;
-- 
2.1.4

