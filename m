Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:57656 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753579AbaFXO43 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 24 Jun 2014 10:56:29 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Kamil Debski <k.debski@samsung.com>,
	Fabio Estevam <fabio.estevam@freescale.com>,
	kernel@pengutronix.de, Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH v2 20/29] [media] coda: add decoder timestamp queue
Date: Tue, 24 Jun 2014 16:56:02 +0200
Message-Id: <1403621771-11636-21-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1403621771-11636-1-git-send-email-p.zabel@pengutronix.de>
References: <1403621771-11636-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The coda driver advertises timestamp_type V4L2_BUF_FLAG_TIMESTAMP_COPY on
both queues, so we have to copy timestamps from input v4l2 buffers to the
corresponding destination v4l2 buffers. Since the h.264 decoder can reorder
frames, a timestamp queue is needed to keep track of and assign the correct
timestamp to destination buffers.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/platform/coda.c | 50 ++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 49 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/coda.c b/drivers/media/platform/coda.c
index 0f83166..a929bbd 100644
--- a/drivers/media/platform/coda.c
+++ b/drivers/media/platform/coda.c
@@ -201,6 +201,13 @@ struct gdi_tiled_map {
 #define GDI_LINEAR_FRAME_MAP 0
 };
 
+struct coda_timestamp {
+	struct list_head	list;
+	u32			sequence;
+	struct v4l2_timecode	timecode;
+	struct timeval		timestamp;
+};
+
 struct coda_ctx {
 	struct coda_dev			*dev;
 	struct mutex			buffer_mutex;
@@ -235,6 +242,8 @@ struct coda_ctx {
 	struct coda_aux_buf		slicebuf;
 	struct coda_aux_buf		internal_frames[CODA_MAX_FRAMEBUFFERS];
 	u32				frame_types[CODA_MAX_FRAMEBUFFERS];
+	struct coda_timestamp		frame_timestamps[CODA_MAX_FRAMEBUFFERS];
+	struct list_head		timestamp_list;
 	struct coda_aux_buf		workbuf;
 	int				num_internal_frames;
 	int				idx;
@@ -1013,7 +1022,7 @@ static int coda_bitstream_queue(struct coda_ctx *ctx, struct vb2_buffer *src_buf
 	dma_sync_single_for_device(&ctx->dev->plat_dev->dev, ctx->bitstream.paddr,
 				   ctx->bitstream.size, DMA_TO_DEVICE);
 
-	ctx->qsequence++;
+	src_buf->v4l2_buf.sequence = ctx->qsequence++;
 
 	return 0;
 }
@@ -1049,12 +1058,26 @@ static bool coda_bitstream_try_queue(struct coda_ctx *ctx,
 static void coda_fill_bitstream(struct coda_ctx *ctx)
 {
 	struct vb2_buffer *src_buf;
+	struct coda_timestamp *ts;
 
 	while (v4l2_m2m_num_src_bufs_ready(ctx->fh.m2m_ctx) > 0) {
 		src_buf = v4l2_m2m_next_src_buf(ctx->fh.m2m_ctx);
 
 		if (coda_bitstream_try_queue(ctx, src_buf)) {
+			/*
+			 * Source buffer is queued in the bitstream ringbuffer;
+			 * queue the timestamp and mark source buffer as done
+			 */
 			src_buf = v4l2_m2m_src_buf_remove(ctx->fh.m2m_ctx);
+
+			ts = kmalloc(sizeof(*ts), GFP_KERNEL);
+			if (ts) {
+				ts->sequence = src_buf->v4l2_buf.sequence;
+				ts->timecode = src_buf->v4l2_buf.timecode;
+				ts->timestamp = src_buf->v4l2_buf.timestamp;
+				list_add_tail(&ts->list, &ctx->timestamp_list);
+			}
+
 			v4l2_m2m_buf_done(src_buf, VB2_BUF_STATE_DONE);
 		} else {
 			break;
@@ -2599,6 +2622,14 @@ static void coda_stop_streaming(struct vb2_queue *q)
 	}
 
 	if (!ctx->streamon_out && !ctx->streamon_cap) {
+		struct coda_timestamp *ts;
+
+		while (!list_empty(&ctx->timestamp_list)) {
+			ts = list_first_entry(&ctx->timestamp_list,
+					      struct coda_timestamp, list);
+			list_del(&ts->list);
+			kfree(ts);
+		}
 		kfifo_init(&ctx->bitstream_fifo,
 			ctx->bitstream.vaddr, ctx->bitstream.size);
 		ctx->runcounter = 0;
@@ -2886,6 +2917,7 @@ static int coda_open(struct file *file)
 		ctx->bitstream.vaddr, ctx->bitstream.size);
 	mutex_init(&ctx->bitstream_mutex);
 	mutex_init(&ctx->buffer_mutex);
+	INIT_LIST_HEAD(&ctx->timestamp_list);
 
 	coda_lock(ctx);
 	list_add(&ctx->list, &dev->instances);
@@ -2977,6 +3009,7 @@ static void coda_finish_decode(struct coda_ctx *ctx)
 	struct coda_q_data *q_data_src;
 	struct coda_q_data *q_data_dst;
 	struct vb2_buffer *dst_buf;
+	struct coda_timestamp *ts;
 	int width, height;
 	int decoded_idx;
 	int display_idx;
@@ -3098,6 +3131,18 @@ static void coda_finish_decode(struct coda_ctx *ctx)
 		v4l2_err(&dev->v4l2_dev,
 			 "decoded frame index out of range: %d\n", decoded_idx);
 	} else {
+		ts = list_first_entry(&ctx->timestamp_list,
+				      struct coda_timestamp, list);
+		list_del(&ts->list);
+		val = coda_read(dev, CODA_RET_DEC_PIC_FRAME_NUM) - 1;
+		if (val != ts->sequence) {
+			v4l2_err(&dev->v4l2_dev,
+				 "sequence number mismatch (%d != %d)\n",
+				 val, ts->sequence);
+		}
+		ctx->frame_timestamps[decoded_idx] = *ts;
+		kfree(ts);
+
 		val = coda_read(dev, CODA_RET_DEC_PIC_TYPE) & 0x7;
 		if (val == 0)
 			ctx->frame_types[decoded_idx] = V4L2_BUF_FLAG_KEYFRAME;
@@ -3131,6 +3176,9 @@ static void coda_finish_decode(struct coda_ctx *ctx)
 					     V4L2_BUF_FLAG_PFRAME |
 					     V4L2_BUF_FLAG_BFRAME);
 		dst_buf->v4l2_buf.flags |= ctx->frame_types[ctx->display_idx];
+		ts = &ctx->frame_timestamps[ctx->display_idx];
+		dst_buf->v4l2_buf.timecode = ts->timecode;
+		dst_buf->v4l2_buf.timestamp = ts->timestamp;
 
 		vb2_set_plane_payload(dst_buf, 0, width * height * 3 / 2);
 
-- 
2.0.0

