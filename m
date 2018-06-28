Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([85.220.165.71]:48165 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753493AbeF1K6M (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 28 Jun 2018 06:58:12 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: kernel@pengutronix.de
Subject: [PATCH 3/3] media: coda: use encoder crop rectangle to set visible width and height
Date: Thu, 28 Jun 2018 12:57:54 +0200
Message-Id: <20180628105754.24363-3-p.zabel@pengutronix.de>
In-Reply-To: <20180628105754.24363-1-p.zabel@pengutronix.de>
References: <20180628105754.24363-1-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Allow to set a crop rectangle on the encoder output queue to set the
visible resolution as required by the V4L2 codec API.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/platform/coda/coda-bit.c    | 24 ++++++------
 drivers/media/platform/coda/coda-common.c | 45 ++++++++++++++++++++---
 2 files changed, 52 insertions(+), 17 deletions(-)

diff --git a/drivers/media/platform/coda/coda-bit.c b/drivers/media/platform/coda/coda-bit.c
index 86e618c10221..5381e67ca09e 100644
--- a/drivers/media/platform/coda/coda-bit.c
+++ b/drivers/media/platform/coda/coda-bit.c
@@ -397,10 +397,10 @@ static int coda_alloc_framebuffers(struct coda_ctx *ctx,
 	    ctx->codec->dst_fourcc == V4L2_PIX_FMT_H264 ||
 	    ctx->codec->src_fourcc == V4L2_PIX_FMT_MPEG4 ||
 	    ctx->codec->dst_fourcc == V4L2_PIX_FMT_MPEG4)
-		ysize = round_up(q_data->width, 16) *
-			round_up(q_data->height, 16);
+		ysize = round_up(q_data->rect.width, 16) *
+			round_up(q_data->rect.height, 16);
 	else
-		ysize = round_up(q_data->width, 8) * q_data->height;
+		ysize = round_up(q_data->rect.width, 8) * q_data->rect.height;
 
 	if (ctx->tiled_map_type == GDI_TILED_FRAME_MB_RASTER_MAP)
 		ycbcr_size = round_up(ysize, 4096) + ysize / 2;
@@ -496,8 +496,8 @@ static int coda_alloc_context_buffers(struct coda_ctx *ctx,
 
 	if (!ctx->slicebuf.vaddr && q_data->fourcc == V4L2_PIX_FMT_H264) {
 		/* worst case slice size */
-		size = (DIV_ROUND_UP(q_data->width, 16) *
-			DIV_ROUND_UP(q_data->height, 16)) * 3200 / 8 + 512;
+		size = (DIV_ROUND_UP(q_data->rect.width, 16) *
+			DIV_ROUND_UP(q_data->rect.height, 16)) * 3200 / 8 + 512;
 		ret = coda_alloc_context_buf(ctx, &ctx->slicebuf, size,
 					     "slicebuf");
 		if (ret < 0)
@@ -629,7 +629,7 @@ static void coda_setup_iram(struct coda_ctx *ctx)
 		struct coda_q_data *q_data_src;
 
 		q_data_src = get_q_data(ctx, V4L2_BUF_TYPE_VIDEO_OUTPUT);
-		mb_width = DIV_ROUND_UP(q_data_src->width, 16);
+		mb_width = DIV_ROUND_UP(q_data_src->rect.width, 16);
 		w128 = mb_width * 128;
 		w64 = mb_width * 64;
 
@@ -925,25 +925,25 @@ static int coda_start_encoding(struct coda_ctx *ctx)
 	value = 0;
 	switch (dev->devtype->product) {
 	case CODA_DX6:
-		value = (q_data_src->width & CODADX6_PICWIDTH_MASK)
+		value = (q_data_src->rect.width & CODADX6_PICWIDTH_MASK)
 			<< CODADX6_PICWIDTH_OFFSET;
-		value |= (q_data_src->height & CODADX6_PICHEIGHT_MASK)
+		value |= (q_data_src->rect.height & CODADX6_PICHEIGHT_MASK)
 			 << CODA_PICHEIGHT_OFFSET;
 		break;
 	case CODA_HX4:
 	case CODA_7541:
 		if (dst_fourcc == V4L2_PIX_FMT_H264) {
-			value = (round_up(q_data_src->width, 16) &
+			value = (round_up(q_data_src->rect.width, 16) &
 				 CODA7_PICWIDTH_MASK) << CODA7_PICWIDTH_OFFSET;
-			value |= (round_up(q_data_src->height, 16) &
+			value |= (round_up(q_data_src->rect.height, 16) &
 				 CODA7_PICHEIGHT_MASK) << CODA_PICHEIGHT_OFFSET;
 			break;
 		}
 		/* fallthrough */
 	case CODA_960:
-		value = (q_data_src->width & CODA7_PICWIDTH_MASK)
+		value = (q_data_src->rect.width & CODA7_PICWIDTH_MASK)
 			<< CODA7_PICWIDTH_OFFSET;
-		value |= (q_data_src->height & CODA7_PICHEIGHT_MASK)
+		value |= (q_data_src->rect.height & CODA7_PICHEIGHT_MASK)
 			 << CODA_PICHEIGHT_OFFSET;
 	}
 	coda_write(dev, value, CODA_CMD_ENC_SEQ_SRC_SIZE);
diff --git a/drivers/media/platform/coda/coda-common.c b/drivers/media/platform/coda/coda-common.c
index c7631e117dd3..e58042e78189 100644
--- a/drivers/media/platform/coda/coda-common.c
+++ b/drivers/media/platform/coda/coda-common.c
@@ -935,6 +935,40 @@ static int coda_g_selection(struct file *file, void *fh,
 	return 0;
 }
 
+static int coda_s_selection(struct file *file, void *fh,
+			    struct v4l2_selection *s)
+{
+	struct coda_ctx *ctx = fh_to_ctx(fh);
+	struct coda_q_data *q_data;
+
+	if (ctx->inst_type == CODA_INST_ENCODER &&
+	    s->type == V4L2_BUF_TYPE_VIDEO_OUTPUT &&
+	    s->target == V4L2_SEL_TGT_CROP) {
+		q_data = get_q_data(ctx, s->type);
+		if (!q_data)
+			return -EINVAL;
+
+		s->r.left = 0;
+		s->r.top = 0;
+		s->r.width = clamp(s->r.width, 2U, q_data->width);
+		s->r.height = clamp(s->r.height, 2U, q_data->height);
+
+		if (s->flags & V4L2_SEL_FLAG_LE) {
+			s->r.width = round_up(s->r.width, 2);
+			s->r.height = round_up(s->r.height, 2);
+		} else {
+			s->r.width = round_down(s->r.width, 2);
+			s->r.height = round_down(s->r.height, 2);
+		}
+
+		q_data->rect = s->r;
+
+		return 0;
+	}
+
+	return coda_g_selection(file, fh, s);
+}
+
 static int coda_try_encoder_cmd(struct file *file, void *fh,
 				struct v4l2_encoder_cmd *ec)
 {
@@ -1148,6 +1182,7 @@ static const struct v4l2_ioctl_ops coda_ioctl_ops = {
 	.vidioc_streamoff	= v4l2_m2m_ioctl_streamoff,
 
 	.vidioc_g_selection	= coda_g_selection,
+	.vidioc_s_selection	= coda_s_selection,
 
 	.vidioc_try_encoder_cmd	= coda_try_encoder_cmd,
 	.vidioc_encoder_cmd	= coda_encoder_cmd,
@@ -1538,12 +1573,12 @@ static int coda_start_streaming(struct vb2_queue *q, unsigned int count)
 		goto out;
 
 	q_data_dst = get_q_data(ctx, V4L2_BUF_TYPE_VIDEO_CAPTURE);
-	if ((q_data_src->width != q_data_dst->width &&
-	     round_up(q_data_src->width, 16) != q_data_dst->width) ||
-	    (q_data_src->height != q_data_dst->height &&
-	     round_up(q_data_src->height, 16) != q_data_dst->height)) {
+	if ((q_data_src->rect.width != q_data_dst->width &&
+	     round_up(q_data_src->rect.width, 16) != q_data_dst->width) ||
+	    (q_data_src->rect.height != q_data_dst->height &&
+	     round_up(q_data_src->rect.height, 16) != q_data_dst->height)) {
 		v4l2_err(v4l2_dev, "can't convert %dx%d to %dx%d\n",
-			 q_data_src->width, q_data_src->height,
+			 q_data_src->rect.width, q_data_src->rect.height,
 			 q_data_dst->width, q_data_dst->height);
 		ret = -EINVAL;
 		goto err;
-- 
2.17.1
