Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:34089 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752788AbaJBRIy (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 2 Oct 2014 13:08:54 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Kamil Debski <k.debski@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	linux-media@vger.kernel.org, kernel@pengutronix.de,
	Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH v2 10/10] [media] coda: allow userspace to set compressed buffer size in a certain range
Date: Thu,  2 Oct 2014 19:08:35 +0200
Message-Id: <1412269715-28388-11-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1412269715-28388-1-git-send-email-p.zabel@pengutronix.de>
References: <1412269715-28388-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

For small frame sizes, allocating 1 MiB per compressed buffer is a waste of
space. On the other hand, incompressible 1080p data can produce JPEGs larger
than 1 MiB at higher quality settings. Allow userspace to set the compressed
buffer size and clamp the value to a sensible range.
Also set the initial sizeimage to a value inside the range allowed by try_fmt.
While at it, reduce the default image size to a maximum of 1920*1088 (otherwise
JPEG will default to 8k*8k and 96 MiB buffers).

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/platform/coda/coda-bit.c    |  4 ++--
 drivers/media/platform/coda/coda-common.c | 25 +++++++++++++++++--------
 2 files changed, 19 insertions(+), 10 deletions(-)

diff --git a/drivers/media/platform/coda/coda-bit.c b/drivers/media/platform/coda/coda-bit.c
index 2a6810e..0c67cfd 100644
--- a/drivers/media/platform/coda/coda-bit.c
+++ b/drivers/media/platform/coda/coda-bit.c
@@ -1129,7 +1129,7 @@ static int coda_prepare_encode(struct coda_ctx *ctx)
 			ctx->vpu_header_size[0] +
 			ctx->vpu_header_size[1] +
 			ctx->vpu_header_size[2];
-		pic_stream_buffer_size = CODA_MAX_FRAME_SIZE -
+		pic_stream_buffer_size = q_data_dst->sizeimage -
 			ctx->vpu_header_size[0] -
 			ctx->vpu_header_size[1] -
 			ctx->vpu_header_size[2];
@@ -1143,7 +1143,7 @@ static int coda_prepare_encode(struct coda_ctx *ctx)
 	} else {
 		pic_stream_buffer_addr =
 			vb2_dma_contig_plane_dma_addr(dst_buf, 0);
-		pic_stream_buffer_size = CODA_MAX_FRAME_SIZE;
+		pic_stream_buffer_size = q_data_dst->sizeimage;
 	}
 
 	if (src_buf->v4l2_buf.flags & V4L2_BUF_FLAG_KEYFRAME) {
diff --git a/drivers/media/platform/coda/coda-common.c b/drivers/media/platform/coda/coda-common.c
index 6eaf88e..151e45b 100644
--- a/drivers/media/platform/coda/coda-common.c
+++ b/drivers/media/platform/coda/coda-common.c
@@ -513,7 +513,15 @@ static int coda_try_fmt(struct coda_ctx *ctx, const struct coda_codec *codec,
 	case V4L2_PIX_FMT_H264:
 	case V4L2_PIX_FMT_MPEG4:
 		f->fmt.pix.bytesperline = 0;
-		f->fmt.pix.sizeimage = CODA_MAX_FRAME_SIZE;
+		/*
+		 * This is a rough estimate for sensible compressed buffer
+		 * sizes (between 1 and 16 bits per pixel). This could be
+		 * improved by better format specific worst case estimates.
+		 */
+		f->fmt.pix.sizeimage = round_up(clamp(f->fmt.pix.sizeimage,
+				f->fmt.pix.width * f->fmt.pix.height / 8,
+				f->fmt.pix.width * f->fmt.pix.height * 2),
+				PAGE_SIZE);
 		break;
 	default:
 		BUG();
@@ -1015,12 +1023,13 @@ static void coda_set_tiled_map_type(struct coda_ctx *ctx, int tiled_map_type)
 
 static void set_default_params(struct coda_ctx *ctx)
 {
-	int max_w, max_h;
+	unsigned int max_w, max_h, size;
 
 	ctx->codec = coda_find_codec(ctx->dev, ctx->cvd->src_formats[0],
 				     ctx->cvd->dst_formats[0]);
-	max_w = ctx->codec->max_w;
-	max_h = ctx->codec->max_h;
+	max_w = min(ctx->codec->max_w, 1920U);
+	max_h = min(ctx->codec->max_h, 1088U);
+	size = max_w * max_h * 3 / 2;
 
 	ctx->params.codec_mode = ctx->codec->mode;
 	ctx->colorspace = V4L2_COLORSPACE_REC709;
@@ -1035,14 +1044,14 @@ static void set_default_params(struct coda_ctx *ctx)
 	ctx->q_data[V4L2_M2M_DST].height = max_h;
 	if (ctx->codec->src_fourcc == V4L2_PIX_FMT_YUV420) {
 		ctx->q_data[V4L2_M2M_SRC].bytesperline = max_w;
-		ctx->q_data[V4L2_M2M_SRC].sizeimage = (max_w * max_h * 3) / 2;
+		ctx->q_data[V4L2_M2M_SRC].sizeimage = size;
 		ctx->q_data[V4L2_M2M_DST].bytesperline = 0;
-		ctx->q_data[V4L2_M2M_DST].sizeimage = CODA_MAX_FRAME_SIZE;
+		ctx->q_data[V4L2_M2M_DST].sizeimage = round_up(size, PAGE_SIZE);
 	} else {
 		ctx->q_data[V4L2_M2M_SRC].bytesperline = 0;
-		ctx->q_data[V4L2_M2M_SRC].sizeimage = CODA_MAX_FRAME_SIZE;
+		ctx->q_data[V4L2_M2M_SRC].sizeimage = round_up(size, PAGE_SIZE);
 		ctx->q_data[V4L2_M2M_DST].bytesperline = max_w;
-		ctx->q_data[V4L2_M2M_DST].sizeimage = (max_w * max_h * 3) / 2;
+		ctx->q_data[V4L2_M2M_DST].sizeimage = size;
 	}
 	ctx->q_data[V4L2_M2M_SRC].rect.width = max_w;
 	ctx->q_data[V4L2_M2M_SRC].rect.height = max_h;
-- 
2.1.0

