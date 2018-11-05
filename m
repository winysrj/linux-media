Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([85.220.165.71]:48973 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730110AbeKFApk (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 5 Nov 2018 19:45:40 -0500
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>, kernel@pengutronix.de
Subject: [PATCH 14/15] media: coda: normalise debug output
Date: Mon,  5 Nov 2018 16:25:12 +0100
Message-Id: <20181105152513.26345-14-p.zabel@pengutronix.de>
In-Reply-To: <20181105152513.26345-1-p.zabel@pengutronix.de>
References: <20181105152513.26345-1-p.zabel@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Consistently add the context index to debug output, which otherwise is
impossible to make sense of when two contexts are running concurrently.
For this purpose, add a convenience macro coda_dbg(). Use the function
name with the coda_ prefix stripped as keyword where applicable, and
consistently use vid-out and vid-cap names for the queues. Add sequence
counters to the decoder job finished message and correctly indicate B
frames. Add a start streaming message to complement the stop streaming
message and a start encoding message to complement the existing start
decoding message.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/platform/coda/coda-bit.c    | 55 +++++++---------
 drivers/media/platform/coda/coda-common.c | 79 ++++++++++-------------
 drivers/media/platform/coda/coda.h        |  7 ++
 3 files changed, 65 insertions(+), 76 deletions(-)

diff --git a/drivers/media/platform/coda/coda-bit.c b/drivers/media/platform/coda/coda-bit.c
index 53f1a83e72a9..f2c0aa261c9b 100644
--- a/drivers/media/platform/coda/coda-bit.c
+++ b/drivers/media/platform/coda/coda-bit.c
@@ -725,8 +725,7 @@ static void coda_setup_iram(struct coda_ctx *ctx)
 
 out:
 	if (!(iram_info->axi_sram_use & CODA7_USE_HOST_IP_ENABLE))
-		v4l2_dbg(1, coda_debug, &ctx->dev->v4l2_dev,
-			 "IRAM smaller than needed\n");
+		coda_dbg(1, ctx, "IRAM smaller than needed\n");
 
 	if (dev->devtype->product == CODA_HX4 ||
 	    dev->devtype->product == CODA_7541) {
@@ -1213,6 +1212,12 @@ static int coda_start_encoding(struct coda_ctx *ctx)
 		goto out;
 	}
 
+	coda_dbg(1, ctx, "start encoding %dx%d %4.4s->%4.4s @ %d/%d Hz\n",
+		 q_data_src->rect.width, q_data_src->rect.height,
+		 (char *)&ctx->codec->src_fourcc, (char *)&dst_fourcc,
+		 ctx->params.framerate & 0xffff,
+		 (ctx->params.framerate >> 16) + 1);
+
 	/* Save stream headers */
 	buf = v4l2_m2m_next_dst_buf(ctx->fh.m2m_ctx);
 	switch (dst_fourcc) {
@@ -1474,8 +1479,7 @@ static void coda_finish_encode(struct coda_ctx *ctx)
 		vb2_set_plane_payload(&dst_buf->vb2_buf, 0, wr_ptr - start_ptr);
 	}
 
-	v4l2_dbg(1, coda_debug, &ctx->dev->v4l2_dev, "frame size = %u\n",
-		 wr_ptr - start_ptr);
+	coda_dbg(1, ctx, "frame size = %u\n", wr_ptr - start_ptr);
 
 	coda_read(dev, CODA_RET_ENC_PIC_SLICE_NUM);
 	coda_read(dev, CODA_RET_ENC_PIC_FLAG);
@@ -1504,11 +1508,9 @@ static void coda_finish_encode(struct coda_ctx *ctx)
 	if (ctx->gopcounter < 0)
 		ctx->gopcounter = ctx->params.gop_size - 1;
 
-	v4l2_dbg(1, coda_debug, &dev->v4l2_dev,
-		"job finished: encoding frame (%d) (%s)\n",
-		dst_buf->sequence,
-		(dst_buf->flags & V4L2_BUF_FLAG_KEYFRAME) ?
-		"KEYFRAME" : "PFRAME");
+	coda_dbg(1, ctx, "job finished: encoded %c frame (%d)\n",
+		 (dst_buf->flags & V4L2_BUF_FLAG_KEYFRAME) ? 'I' : 'P',
+		 dst_buf->sequence);
 }
 
 static void coda_seq_end_work(struct work_struct *work)
@@ -1522,9 +1524,7 @@ static void coda_seq_end_work(struct work_struct *work)
 	if (ctx->initialized == 0)
 		goto out;
 
-	v4l2_dbg(1, coda_debug, &dev->v4l2_dev,
-		 "%d: %s: sent command 'SEQ_END' to coda\n", ctx->idx,
-		 __func__);
+	coda_dbg(1, ctx, "%s: sent command 'SEQ_END' to coda\n", __func__);
 	if (coda_command_sync(ctx, CODA_COMMAND_SEQ_END)) {
 		v4l2_err(&dev->v4l2_dev,
 			 "CODA_COMMAND_SEQ_END failed\n");
@@ -1667,8 +1667,7 @@ static int __coda_start_decoding(struct coda_ctx *ctx)
 	u32 val;
 	int ret;
 
-	v4l2_dbg(1, coda_debug, &dev->v4l2_dev,
-		 "Video Data Order Adapter: %s\n",
+	coda_dbg(1, ctx, "Video Data Order Adapter: %s\n",
 		 ctx->use_vdoa ? "Enabled" : "Disabled");
 
 	/* Start decoding */
@@ -1772,8 +1771,7 @@ static int __coda_start_decoding(struct coda_ctx *ctx)
 	width = round_up(width, 16);
 	height = round_up(height, 16);
 
-	v4l2_dbg(1, coda_debug, &dev->v4l2_dev, "%s instance %d now: %dx%d\n",
-		 __func__, ctx->idx, width, height);
+	coda_dbg(1, ctx, "start decoding: %dx%d\n", width, height);
 
 	ctx->num_internal_frames = coda_read(dev, CODA_RET_DEC_SEQ_FRAME_NEED);
 	/*
@@ -1904,8 +1902,7 @@ static int coda_prepare_decode(struct coda_ctx *ctx)
 
 	if (coda_get_bitstream_payload(ctx) < 512 &&
 	    (!(ctx->bit_stream_param & CODA_BIT_STREAM_END_FLAG))) {
-		v4l2_dbg(1, coda_debug, &dev->v4l2_dev,
-			 "bitstream payload: %d, skipping\n",
+		coda_dbg(1, ctx, "bitstream payload: %d, skipping\n",
 			 coda_get_bitstream_payload(ctx));
 		v4l2_m2m_job_finish(ctx->dev->m2m_dev, ctx->fh.m2m_ctx);
 		return -EAGAIN;
@@ -2109,8 +2106,7 @@ static void coda_finish_decode(struct coda_ctx *ctx)
 		val = coda_read(dev, CODA_RET_DEC_PIC_OPTION);
 		if (val == 0) {
 			/* not enough bitstream data */
-			v4l2_dbg(1, coda_debug, &dev->v4l2_dev,
-				 "prescan failed: %d\n", val);
+			coda_dbg(1, ctx, "prescan failed: %d\n", val);
 			ctx->hold = true;
 			return;
 		}
@@ -2252,14 +2248,13 @@ static void coda_finish_decode(struct coda_ctx *ctx)
 		else
 			coda_m2m_buf_done(ctx, dst_buf, VB2_BUF_STATE_DONE);
 
-		v4l2_dbg(1, coda_debug, &dev->v4l2_dev,
-			"job finished: decoding frame (%d) (%s)\n",
-			dst_buf->sequence,
-			(dst_buf->flags & V4L2_BUF_FLAG_KEYFRAME) ?
-			"KEYFRAME" : "PFRAME");
+		coda_dbg(1, ctx, "job finished: decoded %c frame (%u/%u)\n",
+			 (dst_buf->flags & V4L2_BUF_FLAG_KEYFRAME) ? 'I' :
+			 ((dst_buf->flags & V4L2_BUF_FLAG_PFRAME) ? 'P' : 'B'),
+			 dst_buf->sequence, ctx->qsequence);
 	} else {
-		v4l2_dbg(1, coda_debug, &dev->v4l2_dev,
-			"job finished: no frame decoded\n");
+		coda_dbg(1, ctx, "job finished: no frame decoded (%u/%u)\n",
+			 ctx->osequence, ctx->qsequence);
 	}
 
 	/* The rotator will copy the current display frame next time */
@@ -2328,13 +2323,11 @@ irqreturn_t coda_irq_handler(int irq, void *data)
 	trace_coda_bit_done(ctx);
 
 	if (ctx->aborting) {
-		v4l2_dbg(1, coda_debug, &ctx->dev->v4l2_dev,
-			 "task has been aborted\n");
+		coda_dbg(1, ctx, "task has been aborted\n");
 	}
 
 	if (coda_isbusy(ctx->dev)) {
-		v4l2_dbg(1, coda_debug, &ctx->dev->v4l2_dev,
-			 "coda is still busy!!!!\n");
+		coda_dbg(1, ctx, "coda is still busy!!!!\n");
 		return IRQ_NONE;
 	}
 
diff --git a/drivers/media/platform/coda/coda-common.c b/drivers/media/platform/coda/coda-common.c
index b3d73965614a..2a0e0d04c67a 100644
--- a/drivers/media/platform/coda/coda-common.c
+++ b/drivers/media/platform/coda/coda-common.c
@@ -750,11 +750,10 @@ static int coda_s_fmt(struct coda_ctx *ctx, struct v4l2_format *f,
 	else
 		ctx->use_vdoa = false;
 
-	v4l2_dbg(1, coda_debug, &ctx->dev->v4l2_dev,
-		"Setting format for type %d, wxh: %dx%d, fmt: %4.4s %c\n",
-		f->type, q_data->width, q_data->height,
-		(char *)&q_data->fourcc,
-		(ctx->tiled_map_type == GDI_LINEAR_FRAME_MAP) ? 'L' : 'T');
+	coda_dbg(1, ctx, "Setting %s format, wxh: %dx%d, fmt: %4.4s %c\n",
+		 v4l2_type_names[f->type], q_data->width, q_data->height,
+		 (char *)&q_data->fourcc,
+		 (ctx->tiled_map_type == GDI_LINEAR_FRAME_MAP) ? 'L' : 'T');
 
 	return 0;
 }
@@ -1300,14 +1299,12 @@ static int coda_job_ready(void *m2m_priv)
 	 * the compressed frame can be in the bitstream.
 	 */
 	if (!src_bufs && ctx->inst_type != CODA_INST_DECODER) {
-		v4l2_dbg(1, coda_debug, &ctx->dev->v4l2_dev,
-			 "not ready: not enough video buffers.\n");
+		coda_dbg(1, ctx, "not ready: not enough vid-out buffers.\n");
 		return 0;
 	}
 
 	if (!v4l2_m2m_num_dst_bufs_ready(ctx->fh.m2m_ctx)) {
-		v4l2_dbg(1, coda_debug, &ctx->dev->v4l2_dev,
-			 "not ready: not enough video capture buffers.\n");
+		coda_dbg(1, ctx, "not ready: not enough vid-cap buffers.\n");
 		return 0;
 	}
 
@@ -1320,24 +1317,23 @@ static int coda_job_ready(void *m2m_priv)
 
 		count = hweight32(ctx->frm_dis_flg);
 		if (ctx->use_vdoa && count >= (ctx->num_internal_frames - 1)) {
-			v4l2_dbg(1, coda_debug, &ctx->dev->v4l2_dev,
-				 "%d: not ready: all internal buffers in use: %d/%d (0x%x)",
-				 ctx->idx, count, ctx->num_internal_frames,
+			coda_dbg(1, ctx,
+				 "not ready: all internal buffers in use: %d/%d (0x%x)",
+				 count, ctx->num_internal_frames,
 				 ctx->frm_dis_flg);
 			return 0;
 		}
 
 		if (ctx->hold && !src_bufs) {
-			v4l2_dbg(1, coda_debug, &ctx->dev->v4l2_dev,
-				 "%d: not ready: on hold for more buffers.\n",
-				 ctx->idx);
+			coda_dbg(1, ctx,
+				 "not ready: on hold for more buffers.\n");
 			return 0;
 		}
 
 		if (!stream_end && (num_metas + src_bufs) < 2) {
-			v4l2_dbg(1, coda_debug, &ctx->dev->v4l2_dev,
-				 "%d: not ready: need 2 buffers available (queue:%d + bitstream:%d)\n",
-				 ctx->idx, num_metas, src_bufs);
+			coda_dbg(1, ctx,
+				 "not ready: need 2 buffers available (queue:%d + bitstream:%d)\n",
+				 num_metas, src_bufs);
 			return 0;
 		}
 
@@ -1345,7 +1341,7 @@ static int coda_job_ready(void *m2m_priv)
 					struct coda_buffer_meta, list);
 		if (!coda_bitstream_can_fetch_past(ctx, meta->end) &&
 		    !stream_end) {
-			v4l2_dbg(1, coda_debug, &ctx->dev->v4l2_dev,
+			coda_dbg(1, ctx,
 				 "not ready: not enough bitstream data to read past %u (%u)\n",
 				 meta->end, ctx->bitstream_fifo.kfifo.in);
 			return 0;
@@ -1353,13 +1349,11 @@ static int coda_job_ready(void *m2m_priv)
 	}
 
 	if (ctx->aborting) {
-		v4l2_dbg(1, coda_debug, &ctx->dev->v4l2_dev,
-			 "not ready: aborting\n");
+		coda_dbg(1, ctx, "not ready: aborting\n");
 		return 0;
 	}
 
-	v4l2_dbg(1, coda_debug, &ctx->dev->v4l2_dev,
-			"job ready\n");
+	coda_dbg(1, ctx, "job ready\n");
 
 	return 1;
 }
@@ -1370,8 +1364,7 @@ static void coda_job_abort(void *priv)
 
 	ctx->aborting = 1;
 
-	v4l2_dbg(1, coda_debug, &ctx->dev->v4l2_dev,
-		 "Aborting task\n");
+	coda_dbg(1, ctx, "job abort\n");
 }
 
 static const struct v4l2_m2m_ops coda_m2m_ops = {
@@ -1448,8 +1441,8 @@ static int coda_queue_setup(struct vb2_queue *vq,
 	*nplanes = 1;
 	sizes[0] = size;
 
-	v4l2_dbg(1, coda_debug, &ctx->dev->v4l2_dev,
-		 "get %d buffer(s) of size %d each.\n", *nbuffers, size);
+	coda_dbg(1, ctx, "get %d buffer(s) of size %d each.\n", *nbuffers,
+		 size);
 
 	return 0;
 }
@@ -1514,8 +1507,7 @@ static void coda_update_h264_profile_ctrl(struct coda_ctx *ctx)
 
 	profile_names = v4l2_ctrl_get_menu(V4L2_CID_MPEG_VIDEO_H264_PROFILE);
 
-	v4l2_dbg(1, coda_debug, &ctx->dev->v4l2_dev, "Parsed H264 Profile: %s\n",
-		 profile_names[profile]);
+	coda_dbg(1, ctx, "Parsed H264 Profile: %s\n", profile_names[profile]);
 }
 
 static void coda_update_h264_level_ctrl(struct coda_ctx *ctx)
@@ -1534,8 +1526,7 @@ static void coda_update_h264_level_ctrl(struct coda_ctx *ctx)
 
 	level_names = v4l2_ctrl_get_menu(V4L2_CID_MPEG_VIDEO_H264_LEVEL);
 
-	v4l2_dbg(1, coda_debug, &ctx->dev->v4l2_dev, "Parsed H264 Level: %s\n",
-		 level_names[level]);
+	coda_dbg(1, ctx, "Parsed H264 Level: %s\n", level_names[level]);
 }
 
 static void coda_buf_queue(struct vb2_buffer *vb)
@@ -1640,6 +1631,8 @@ static int coda_start_streaming(struct vb2_queue *q, unsigned int count)
 	if (count < 1)
 		return -EINVAL;
 
+	coda_dbg(1, ctx, "start streaming %s\n", v4l2_type_names[q->type]);
+
 	INIT_LIST_HEAD(&list);
 
 	q_data_src = get_q_data(ctx, V4L2_BUF_TYPE_VIDEO_OUTPUT);
@@ -1736,9 +1729,9 @@ static void coda_stop_streaming(struct vb2_queue *q)
 
 	stop = ctx->streamon_out && ctx->streamon_cap;
 
+	coda_dbg(1, ctx, "stop streaming %s\n", v4l2_type_names[q->type]);
+
 	if (q->type == V4L2_BUF_TYPE_VIDEO_OUTPUT) {
-		v4l2_dbg(1, coda_debug, &dev->v4l2_dev,
-			 "%s: output\n", __func__);
 		ctx->streamon_out = 0;
 
 		coda_bit_stream_end_flag(ctx);
@@ -1748,8 +1741,6 @@ static void coda_stop_streaming(struct vb2_queue *q)
 		while ((buf = v4l2_m2m_src_buf_remove(ctx->fh.m2m_ctx)))
 			v4l2_m2m_buf_done(buf, VB2_BUF_STATE_ERROR);
 	} else {
-		v4l2_dbg(1, coda_debug, &dev->v4l2_dev,
-			 "%s: capture\n", __func__);
 		ctx->streamon_cap = 0;
 
 		ctx->osequence = 0;
@@ -1801,8 +1792,8 @@ static int coda_s_ctrl(struct v4l2_ctrl *ctrl)
 	struct coda_ctx *ctx =
 			container_of(ctrl->handler, struct coda_ctx, ctrls);
 
-	v4l2_dbg(1, coda_debug, &ctx->dev->v4l2_dev,
-		 "s_ctrl: id = %d, val = %d\n", ctrl->id, ctrl->val);
+	coda_dbg(1, ctx, "s_ctrl: id = 0x%x, name = \"%s\", val = %d\n",
+		 ctrl->id, ctrl->name, ctrl->val);
 
 	switch (ctrl->id) {
 	case V4L2_CID_HFLIP:
@@ -1893,9 +1884,8 @@ static int coda_s_ctrl(struct v4l2_ctrl *ctrl)
 		ctx->params.vbv_size = min(ctrl->val * 8192, 0x7fffffff);
 		break;
 	default:
-		v4l2_dbg(1, coda_debug, &ctx->dev->v4l2_dev,
-			"Invalid control, id=%d, val=%d\n",
-			ctrl->id, ctrl->val);
+		coda_dbg(1, ctx, "Invalid control, id=%d, val=%d\n",
+			 ctrl->id, ctrl->val);
 		return -EINVAL;
 	}
 
@@ -2191,6 +2181,9 @@ static int coda_open(struct file *file)
 	v4l2_fh_add(&ctx->fh);
 	ctx->dev = dev;
 	ctx->idx = idx;
+
+	coda_dbg(1, ctx, "open instance (%p)\n", ctx);
+
 	switch (dev->devtype->product) {
 	case CODA_960:
 		/*
@@ -2256,9 +2249,6 @@ static int coda_open(struct file *file)
 	INIT_LIST_HEAD(&ctx->buffer_meta_list);
 	spin_lock_init(&ctx->buffer_meta_lock);
 
-	v4l2_dbg(1, coda_debug, &dev->v4l2_dev, "Created instance %d (%p)\n",
-		 ctx->idx, ctx);
-
 	return 0;
 
 err_ctrls_setup:
@@ -2284,8 +2274,7 @@ static int coda_release(struct file *file)
 	struct coda_dev *dev = video_drvdata(file);
 	struct coda_ctx *ctx = fh_to_ctx(file->private_data);
 
-	v4l2_dbg(1, coda_debug, &dev->v4l2_dev, "Releasing instance %p\n",
-		 ctx);
+	coda_dbg(1, ctx, "release instance (%p)\n", ctx);
 
 	if (ctx->inst_type == CODA_INST_DECODER && ctx->use_bit)
 		coda_bit_stream_end_flag(ctx);
diff --git a/drivers/media/platform/coda/coda.h b/drivers/media/platform/coda/coda.h
index aaa90c3d9a16..2533e902da30 100644
--- a/drivers/media/platform/coda/coda.h
+++ b/drivers/media/platform/coda/coda.h
@@ -251,6 +251,13 @@ struct coda_ctx {
 
 extern int coda_debug;
 
+#define coda_dbg(level, ctx, fmt, arg...)				\
+	do {								\
+		if (coda_debug >= (level))				\
+			v4l2_dbg((level), coda_debug, &(ctx)->dev->v4l2_dev, \
+			 "%u: " fmt, (ctx)->idx, ##arg);		\
+	} while (0)
+
 void coda_write(struct coda_dev *dev, u32 data, u32 reg);
 unsigned int coda_read(struct coda_dev *dev, u32 reg);
 void coda_write_base(struct coda_ctx *ctx, struct coda_q_data *q_data,
-- 
2.19.1
