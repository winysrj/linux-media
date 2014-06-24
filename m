Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:57612 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753331AbaFXO40 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 24 Jun 2014 10:56:26 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Kamil Debski <k.debski@samsung.com>,
	Fabio Estevam <fabio.estevam@freescale.com>,
	kernel@pengutronix.de, Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH v2 11/29] [media] coda: use ctx->fh.m2m_ctx instead of ctx->m2m_ctx
Date: Tue, 24 Jun 2014 16:55:53 +0200
Message-Id: <1403621771-11636-12-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1403621771-11636-1-git-send-email-p.zabel@pengutronix.de>
References: <1403621771-11636-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

v4l2_fh already contains a mem2mem context pointer. Use it.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/platform/coda.c | 66 +++++++++++++++++++++----------------------
 1 file changed, 32 insertions(+), 34 deletions(-)

diff --git a/drivers/media/platform/coda.c b/drivers/media/platform/coda.c
index 742187c..0a0b1ed 100644
--- a/drivers/media/platform/coda.c
+++ b/drivers/media/platform/coda.c
@@ -213,7 +213,6 @@ struct coda_ctx {
 	struct coda_codec		*codec;
 	enum v4l2_colorspace		colorspace;
 	struct coda_params		params;
-	struct v4l2_m2m_ctx		*m2m_ctx;
 	struct v4l2_ctrl_handler	ctrls;
 	struct v4l2_fh			fh;
 	int				gopcounter;
@@ -553,7 +552,7 @@ static int coda_enum_fmt_vid_cap(struct file *file, void *priv,
 	struct coda_q_data *q_data_src;
 
 	/* If the source format is already fixed, only list matching formats */
-	src_vq = v4l2_m2m_get_vq(ctx->m2m_ctx, V4L2_BUF_TYPE_VIDEO_OUTPUT);
+	src_vq = v4l2_m2m_get_vq(ctx->fh.m2m_ctx, V4L2_BUF_TYPE_VIDEO_OUTPUT);
 	if (vb2_is_streaming(src_vq)) {
 		q_data_src = get_q_data(ctx, V4L2_BUF_TYPE_VIDEO_OUTPUT);
 
@@ -667,7 +666,7 @@ static int coda_try_fmt_vid_cap(struct file *file, void *priv,
 	 * If the source format is already fixed, try to find a codec that
 	 * converts to the given destination format
 	 */
-	src_vq = v4l2_m2m_get_vq(ctx->m2m_ctx, V4L2_BUF_TYPE_VIDEO_OUTPUT);
+	src_vq = v4l2_m2m_get_vq(ctx->fh.m2m_ctx, V4L2_BUF_TYPE_VIDEO_OUTPUT);
 	if (vb2_is_streaming(src_vq)) {
 		struct coda_q_data *q_data_src;
 
@@ -721,7 +720,7 @@ static int coda_s_fmt(struct coda_ctx *ctx, struct v4l2_format *f)
 	struct coda_q_data *q_data;
 	struct vb2_queue *vq;
 
-	vq = v4l2_m2m_get_vq(ctx->m2m_ctx, f->type);
+	vq = v4l2_m2m_get_vq(ctx->fh.m2m_ctx, f->type);
 	if (!vq)
 		return -EINVAL;
 
@@ -785,7 +784,7 @@ static int coda_qbuf(struct file *file, void *priv,
 {
 	struct coda_ctx *ctx = fh_to_ctx(priv);
 
-	return v4l2_m2m_qbuf(file, ctx->m2m_ctx, buf);
+	return v4l2_m2m_qbuf(file, ctx->fh.m2m_ctx, buf);
 }
 
 static bool coda_buf_is_end_of_stream(struct coda_ctx *ctx,
@@ -793,7 +792,7 @@ static bool coda_buf_is_end_of_stream(struct coda_ctx *ctx,
 {
 	struct vb2_queue *src_vq;
 
-	src_vq = v4l2_m2m_get_vq(ctx->m2m_ctx, V4L2_BUF_TYPE_VIDEO_OUTPUT);
+	src_vq = v4l2_m2m_get_vq(ctx->fh.m2m_ctx, V4L2_BUF_TYPE_VIDEO_OUTPUT);
 
 	return ((ctx->bit_stream_param & CODA_BIT_STREAM_END_FLAG) &&
 		(buf->sequence == (ctx->qsequence - 1)));
@@ -805,7 +804,7 @@ static int coda_dqbuf(struct file *file, void *priv,
 	struct coda_ctx *ctx = fh_to_ctx(priv);
 	int ret;
 
-	ret = v4l2_m2m_dqbuf(file, ctx->m2m_ctx, buf);
+	ret = v4l2_m2m_dqbuf(file, ctx->fh.m2m_ctx, buf);
 
 	/* If this is the last capture buffer, emit an end-of-stream event */
 	if (buf->type == V4L2_BUF_TYPE_VIDEO_CAPTURE &&
@@ -1042,11 +1041,11 @@ static void coda_fill_bitstream(struct coda_ctx *ctx)
 {
 	struct vb2_buffer *src_buf;
 
-	while (v4l2_m2m_num_src_bufs_ready(ctx->m2m_ctx) > 0) {
-		src_buf = v4l2_m2m_next_src_buf(ctx->m2m_ctx);
+	while (v4l2_m2m_num_src_bufs_ready(ctx->fh.m2m_ctx) > 0) {
+		src_buf = v4l2_m2m_next_src_buf(ctx->fh.m2m_ctx);
 
 		if (coda_bitstream_try_queue(ctx, src_buf)) {
-			src_buf = v4l2_m2m_src_buf_remove(ctx->m2m_ctx);
+			src_buf = v4l2_m2m_src_buf_remove(ctx->fh.m2m_ctx);
 			v4l2_m2m_buf_done(src_buf, VB2_BUF_STATE_DONE);
 		} else {
 			break;
@@ -1086,7 +1085,7 @@ static int coda_prepare_decode(struct coda_ctx *ctx)
 	u32 stridey, height;
 	u32 picture_y, picture_cb, picture_cr;
 
-	dst_buf = v4l2_m2m_next_dst_buf(ctx->m2m_ctx);
+	dst_buf = v4l2_m2m_next_dst_buf(ctx->fh.m2m_ctx);
 	q_data_dst = get_q_data(ctx, V4L2_BUF_TYPE_VIDEO_CAPTURE);
 
 	if (ctx->params.rot_mode & CODA_ROT_90) {
@@ -1107,7 +1106,7 @@ static int coda_prepare_decode(struct coda_ctx *ctx)
 		v4l2_dbg(1, coda_debug, &dev->v4l2_dev,
 			 "bitstream payload: %d, skipping\n",
 			 coda_get_bitstream_payload(ctx));
-		v4l2_m2m_job_finish(ctx->dev->m2m_dev, ctx->m2m_ctx);
+		v4l2_m2m_job_finish(ctx->dev->m2m_dev, ctx->fh.m2m_ctx);
 		return -EAGAIN;
 	}
 
@@ -1116,7 +1115,7 @@ static int coda_prepare_decode(struct coda_ctx *ctx)
 		int ret = coda_start_decoding(ctx);
 		if (ret < 0) {
 			v4l2_err(&dev->v4l2_dev, "failed to start decoding\n");
-			v4l2_m2m_job_finish(ctx->dev->m2m_dev, ctx->m2m_ctx);
+			v4l2_m2m_job_finish(ctx->dev->m2m_dev, ctx->fh.m2m_ctx);
 			return -EAGAIN;
 		} else {
 			ctx->initialized = 1;
@@ -1189,8 +1188,8 @@ static void coda_prepare_encode(struct coda_ctx *ctx)
 	u32 pic_stream_buffer_addr, pic_stream_buffer_size;
 	u32 dst_fourcc;
 
-	src_buf = v4l2_m2m_next_src_buf(ctx->m2m_ctx);
-	dst_buf = v4l2_m2m_next_dst_buf(ctx->m2m_ctx);
+	src_buf = v4l2_m2m_next_src_buf(ctx->fh.m2m_ctx);
+	dst_buf = v4l2_m2m_next_dst_buf(ctx->fh.m2m_ctx);
 	q_data_src = get_q_data(ctx, V4L2_BUF_TYPE_VIDEO_OUTPUT);
 	q_data_dst = get_q_data(ctx, V4L2_BUF_TYPE_VIDEO_CAPTURE);
 	dst_fourcc = q_data_dst->fourcc;
@@ -1403,7 +1402,7 @@ static void coda_pic_run_work(struct work_struct *work)
 	mutex_unlock(&dev->coda_mutex);
 	mutex_unlock(&ctx->buffer_mutex);
 
-	v4l2_m2m_job_finish(ctx->dev->m2m_dev, ctx->m2m_ctx);
+	v4l2_m2m_job_finish(ctx->dev->m2m_dev, ctx->fh.m2m_ctx);
 }
 
 static int coda_job_ready(void *m2m_priv)
@@ -1415,14 +1414,14 @@ static int coda_job_ready(void *m2m_priv)
 	 * and 1 frame are needed. In the decoder case,
 	 * the compressed frame can be in the bitstream.
 	 */
-	if (!v4l2_m2m_num_src_bufs_ready(ctx->m2m_ctx) &&
+	if (!v4l2_m2m_num_src_bufs_ready(ctx->fh.m2m_ctx) &&
 	    ctx->inst_type != CODA_INST_DECODER) {
 		v4l2_dbg(1, coda_debug, &ctx->dev->v4l2_dev,
 			 "not ready: not enough video buffers.\n");
 		return 0;
 	}
 
-	if (!v4l2_m2m_num_dst_bufs_ready(ctx->m2m_ctx)) {
+	if (!v4l2_m2m_num_dst_bufs_ready(ctx->fh.m2m_ctx)) {
 		v4l2_dbg(1, coda_debug, &ctx->dev->v4l2_dev,
 			 "not ready: not enough video capture buffers.\n");
 		return 0;
@@ -1611,11 +1610,11 @@ static void coda_buf_queue(struct vb2_buffer *vb)
 			}
 		}
 		mutex_lock(&ctx->bitstream_mutex);
-		v4l2_m2m_buf_queue(ctx->m2m_ctx, vb);
+		v4l2_m2m_buf_queue(ctx->fh.m2m_ctx, vb);
 		coda_fill_bitstream(ctx);
 		mutex_unlock(&ctx->bitstream_mutex);
 	} else {
-		v4l2_m2m_buf_queue(ctx->m2m_ctx, vb);
+		v4l2_m2m_buf_queue(ctx->fh.m2m_ctx, vb);
 	}
 }
 
@@ -2210,7 +2209,7 @@ static int coda_start_streaming(struct vb2_queue *q, unsigned int count)
 
 	/* Allow decoder device_run with no new buffers queued */
 	if (ctx->inst_type == CODA_INST_DECODER)
-		v4l2_m2m_set_src_buffered(ctx->m2m_ctx, true);
+		v4l2_m2m_set_src_buffered(ctx->fh.m2m_ctx, true);
 
 	ctx->gopcounter = ctx->params.gop_size - 1;
 	q_data_dst = get_q_data(ctx, V4L2_BUF_TYPE_VIDEO_CAPTURE);
@@ -2258,7 +2257,7 @@ static int coda_start_encoding(struct coda_ctx *ctx)
 	q_data_dst = get_q_data(ctx, V4L2_BUF_TYPE_VIDEO_CAPTURE);
 	dst_fourcc = q_data_dst->fourcc;
 
-	buf = v4l2_m2m_next_dst_buf(ctx->m2m_ctx);
+	buf = v4l2_m2m_next_dst_buf(ctx->fh.m2m_ctx);
 	bitstream_buf = vb2_dma_contig_plane_dma_addr(buf, 0);
 	bitstream_size = q_data_dst->sizeimage;
 
@@ -2469,7 +2468,7 @@ static int coda_start_encoding(struct coda_ctx *ctx)
 	}
 
 	/* Save stream headers */
-	buf = v4l2_m2m_next_dst_buf(ctx->m2m_ctx);
+	buf = v4l2_m2m_next_dst_buf(ctx->fh.m2m_ctx);
 	switch (dst_fourcc) {
 	case V4L2_PIX_FMT_H264:
 		/*
@@ -2776,16 +2775,15 @@ static int coda_open(struct file *file)
 		goto err_clk_ahb;
 
 	set_default_params(ctx);
-	ctx->m2m_ctx = v4l2_m2m_ctx_init(dev->m2m_dev, ctx,
+	ctx->fh.m2m_ctx = v4l2_m2m_ctx_init(dev->m2m_dev, ctx,
 					 &coda_queue_init);
-	if (IS_ERR(ctx->m2m_ctx)) {
-		ret = PTR_ERR(ctx->m2m_ctx);
+	if (IS_ERR(ctx->fh.m2m_ctx)) {
+		ret = PTR_ERR(ctx->fh.m2m_ctx);
 
 		v4l2_err(&dev->v4l2_dev, "%s return error (%d)\n",
 			 __func__, ret);
 		goto err_ctx_init;
 	}
-	ctx->fh.m2m_ctx = ctx->m2m_ctx;
 
 	ret = coda_ctrls_setup(ctx);
 	if (ret) {
@@ -2831,7 +2829,7 @@ err_dma_writecombine:
 err_dma_alloc:
 	v4l2_ctrl_handler_free(&ctx->ctrls);
 err_ctrls_setup:
-	v4l2_m2m_ctx_release(ctx->m2m_ctx);
+	v4l2_m2m_ctx_release(ctx->fh.m2m_ctx);
 err_ctx_init:
 	clk_disable_unprepare(dev->clk_ahb);
 err_clk_ahb:
@@ -2854,7 +2852,7 @@ static int coda_release(struct file *file)
 		 ctx);
 
 	/* If this instance is running, call .job_abort and wait for it to end */
-	v4l2_m2m_ctx_release(ctx->m2m_ctx);
+	v4l2_m2m_ctx_release(ctx->fh.m2m_ctx);
 
 	/* In case the instance was not running, we still need to call SEQ_END */
 	if (ctx->initialized) {
@@ -2908,7 +2906,7 @@ static void coda_finish_decode(struct coda_ctx *ctx)
 	int success;
 	u32 val;
 
-	dst_buf = v4l2_m2m_next_dst_buf(ctx->m2m_ctx);
+	dst_buf = v4l2_m2m_next_dst_buf(ctx->fh.m2m_ctx);
 
 	/* Update kfifo out pointer from coda bitstream read pointer */
 	coda_kfifo_sync_from_device(ctx);
@@ -3048,7 +3046,7 @@ static void coda_finish_decode(struct coda_ctx *ctx)
 	/* If a frame was copied out, return it */
 	if (ctx->display_idx >= 0 &&
 	    ctx->display_idx < ctx->num_internal_frames) {
-		dst_buf = v4l2_m2m_dst_buf_remove(ctx->m2m_ctx);
+		dst_buf = v4l2_m2m_dst_buf_remove(ctx->fh.m2m_ctx);
 		dst_buf->v4l2_buf.sequence = ctx->osequence++;
 
 		dst_buf->v4l2_buf.flags &= ~(V4L2_BUF_FLAG_KEYFRAME |
@@ -3081,8 +3079,8 @@ static void coda_finish_encode(struct coda_ctx *ctx)
 	struct coda_dev *dev = ctx->dev;
 	u32 wr_ptr, start_ptr;
 
-	src_buf = v4l2_m2m_src_buf_remove(ctx->m2m_ctx);
-	dst_buf = v4l2_m2m_next_dst_buf(ctx->m2m_ctx);
+	src_buf = v4l2_m2m_src_buf_remove(ctx->fh.m2m_ctx);
+	dst_buf = v4l2_m2m_next_dst_buf(ctx->fh.m2m_ctx);
 
 	/* Get results from the coda */
 	start_ptr = coda_read(dev, CODA_CMD_ENC_PIC_BB_START);
@@ -3120,7 +3118,7 @@ static void coda_finish_encode(struct coda_ctx *ctx)
 
 	v4l2_m2m_buf_done(src_buf, VB2_BUF_STATE_DONE);
 
-	dst_buf = v4l2_m2m_dst_buf_remove(ctx->m2m_ctx);
+	dst_buf = v4l2_m2m_dst_buf_remove(ctx->fh.m2m_ctx);
 	v4l2_m2m_buf_done(dst_buf, VB2_BUF_STATE_DONE);
 
 	ctx->gopcounter--;
-- 
2.0.0

