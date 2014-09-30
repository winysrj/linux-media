Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:45518 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751182AbaI3J5h (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 30 Sep 2014 05:57:37 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Kamil Debski <k.debski@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	linux-media@vger.kernel.org, kernel@pengutronix.de,
	Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH 07/10] [media] coda: store bitstream buffer position with buffer metadata
Date: Tue, 30 Sep 2014 11:57:08 +0200
Message-Id: <1412071031-32016-8-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1412071031-32016-1-git-send-email-p.zabel@pengutronix.de>
References: <1412071031-32016-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Storing the buffer position in the bitstream with the buffer metadata
allows to later use that information to drop metadata for skipped buffers
and to determine whether bitstream padding has to be applied.

This patch also renames struct coda_timestamp to struct coda_buffer_meta
to make clear that it contains more than only the buffer timestamp.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/platform/coda/coda-bit.c    | 53 ++++++++++++++++++-------------
 drivers/media/platform/coda/coda-common.c | 14 ++++----
 drivers/media/platform/coda/coda.h        |  8 +++--
 3 files changed, 43 insertions(+), 32 deletions(-)

diff --git a/drivers/media/platform/coda/coda-bit.c b/drivers/media/platform/coda/coda-bit.c
index 931248d..d1ecda5 100644
--- a/drivers/media/platform/coda/coda-bit.c
+++ b/drivers/media/platform/coda/coda-bit.c
@@ -217,11 +217,16 @@ static bool coda_bitstream_try_queue(struct coda_ctx *ctx,
 void coda_fill_bitstream(struct coda_ctx *ctx)
 {
 	struct vb2_buffer *src_buf;
-	struct coda_timestamp *ts;
+	struct coda_buffer_meta *meta;
+	u32 start;
 
 	while (v4l2_m2m_num_src_bufs_ready(ctx->fh.m2m_ctx) > 0) {
 		src_buf = v4l2_m2m_next_src_buf(ctx->fh.m2m_ctx);
 
+		/* Buffer start position */
+		start = ctx->bitstream_fifo.kfifo.in &
+			ctx->bitstream_fifo.kfifo.mask;
+
 		if (coda_bitstream_try_queue(ctx, src_buf)) {
 			/*
 			 * Source buffer is queued in the bitstream ringbuffer;
@@ -229,12 +234,16 @@ void coda_fill_bitstream(struct coda_ctx *ctx)
 			 */
 			src_buf = v4l2_m2m_src_buf_remove(ctx->fh.m2m_ctx);
 
-			ts = kmalloc(sizeof(*ts), GFP_KERNEL);
-			if (ts) {
-				ts->sequence = src_buf->v4l2_buf.sequence;
-				ts->timecode = src_buf->v4l2_buf.timecode;
-				ts->timestamp = src_buf->v4l2_buf.timestamp;
-				list_add_tail(&ts->list, &ctx->timestamp_list);
+			meta = kmalloc(sizeof(*meta), GFP_KERNEL);
+			if (meta) {
+				meta->sequence = src_buf->v4l2_buf.sequence;
+				meta->timecode = src_buf->v4l2_buf.timecode;
+				meta->timestamp = src_buf->v4l2_buf.timestamp;
+				meta->start = start;
+				meta->end = ctx->bitstream_fifo.kfifo.in &
+					    ctx->bitstream_fifo.kfifo.mask;
+				list_add_tail(&meta->list,
+					      &ctx->buffer_meta_list);
 			}
 
 			v4l2_m2m_buf_done(src_buf, VB2_BUF_STATE_DONE);
@@ -1629,7 +1638,7 @@ static void coda_finish_decode(struct coda_ctx *ctx)
 	struct coda_q_data *q_data_src;
 	struct coda_q_data *q_data_dst;
 	struct vb2_buffer *dst_buf;
-	struct coda_timestamp *ts;
+	struct coda_buffer_meta *meta;
 	unsigned long payload;
 	int width, height;
 	int decoded_idx;
@@ -1757,23 +1766,23 @@ static void coda_finish_decode(struct coda_ctx *ctx)
 		val = coda_read(dev, CODA_RET_DEC_PIC_FRAME_NUM) - 1;
 		val -= ctx->sequence_offset;
 		mutex_lock(&ctx->bitstream_mutex);
-		if (!list_empty(&ctx->timestamp_list)) {
-			ts = list_first_entry(&ctx->timestamp_list,
-					      struct coda_timestamp, list);
-			list_del(&ts->list);
-			if (val != (ts->sequence & 0xffff)) {
+		if (!list_empty(&ctx->buffer_meta_list)) {
+			meta = list_first_entry(&ctx->buffer_meta_list,
+					      struct coda_buffer_meta, list);
+			list_del(&meta->list);
+			if (val != (meta->sequence & 0xffff)) {
 				v4l2_err(&dev->v4l2_dev,
 					 "sequence number mismatch (%d(%d) != %d)\n",
 					 val, ctx->sequence_offset,
-					 ts->sequence);
+					 meta->sequence);
 			}
-			ctx->frame_timestamps[decoded_idx] = *ts;
-			kfree(ts);
+			ctx->frame_metas[decoded_idx] = *meta;
+			kfree(meta);
 		} else {
 			v4l2_err(&dev->v4l2_dev, "empty timestamp list!\n");
-			memset(&ctx->frame_timestamps[decoded_idx], 0,
-			       sizeof(struct coda_timestamp));
-			ctx->frame_timestamps[decoded_idx].sequence = val;
+			memset(&ctx->frame_metas[decoded_idx], 0,
+			       sizeof(struct coda_buffer_meta));
+			ctx->frame_metas[decoded_idx].sequence = val;
 		}
 		mutex_unlock(&ctx->bitstream_mutex);
 
@@ -1812,9 +1821,9 @@ static void coda_finish_decode(struct coda_ctx *ctx)
 					     V4L2_BUF_FLAG_PFRAME |
 					     V4L2_BUF_FLAG_BFRAME);
 		dst_buf->v4l2_buf.flags |= ctx->frame_types[ctx->display_idx];
-		ts = &ctx->frame_timestamps[ctx->display_idx];
-		dst_buf->v4l2_buf.timecode = ts->timecode;
-		dst_buf->v4l2_buf.timestamp = ts->timestamp;
+		meta = &ctx->frame_metas[ctx->display_idx];
+		dst_buf->v4l2_buf.timecode = meta->timecode;
+		dst_buf->v4l2_buf.timestamp = meta->timestamp;
 
 		switch (q_data_dst->fourcc) {
 		case V4L2_PIX_FMT_YUV420:
diff --git a/drivers/media/platform/coda/coda-common.c b/drivers/media/platform/coda/coda-common.c
index 53304d5..53791d4 100644
--- a/drivers/media/platform/coda/coda-common.c
+++ b/drivers/media/platform/coda/coda-common.c
@@ -1295,14 +1295,14 @@ static void coda_stop_streaming(struct vb2_queue *q)
 	}
 
 	if (!ctx->streamon_out && !ctx->streamon_cap) {
-		struct coda_timestamp *ts;
+		struct coda_buffer_meta *meta;
 
 		mutex_lock(&ctx->bitstream_mutex);
-		while (!list_empty(&ctx->timestamp_list)) {
-			ts = list_first_entry(&ctx->timestamp_list,
-					      struct coda_timestamp, list);
-			list_del(&ts->list);
-			kfree(ts);
+		while (!list_empty(&ctx->buffer_meta_list)) {
+			meta = list_first_entry(&ctx->buffer_meta_list,
+						struct coda_buffer_meta, list);
+			list_del(&meta->list);
+			kfree(meta);
 		}
 		mutex_unlock(&ctx->bitstream_mutex);
 		kfifo_init(&ctx->bitstream_fifo,
@@ -1664,7 +1664,7 @@ static int coda_open(struct file *file)
 		ctx->bitstream.vaddr, ctx->bitstream.size);
 	mutex_init(&ctx->bitstream_mutex);
 	mutex_init(&ctx->buffer_mutex);
-	INIT_LIST_HEAD(&ctx->timestamp_list);
+	INIT_LIST_HEAD(&ctx->buffer_meta_list);
 
 	coda_lock(ctx);
 	list_add(&ctx->list, &dev->instances);
diff --git a/drivers/media/platform/coda/coda.h b/drivers/media/platform/coda/coda.h
index c14dee8..8dd81a7 100644
--- a/drivers/media/platform/coda/coda.h
+++ b/drivers/media/platform/coda/coda.h
@@ -130,11 +130,13 @@ struct coda_params {
 	u32			slice_max_mb;
 };
 
-struct coda_timestamp {
+struct coda_buffer_meta {
 	struct list_head	list;
 	u32			sequence;
 	struct v4l2_timecode	timecode;
 	struct timeval		timestamp;
+	u32			start;
+	u32			end;
 };
 
 /* Per-queue, driver-specific private data */
@@ -220,9 +222,9 @@ struct coda_ctx {
 	struct coda_aux_buf		slicebuf;
 	struct coda_aux_buf		internal_frames[CODA_MAX_FRAMEBUFFERS];
 	u32				frame_types[CODA_MAX_FRAMEBUFFERS];
-	struct coda_timestamp		frame_timestamps[CODA_MAX_FRAMEBUFFERS];
+	struct coda_buffer_meta		frame_metas[CODA_MAX_FRAMEBUFFERS];
 	u32				frame_errors[CODA_MAX_FRAMEBUFFERS];
-	struct list_head		timestamp_list;
+	struct list_head		buffer_meta_list;
 	struct coda_aux_buf		workbuf;
 	int				num_internal_frames;
 	int				idx;
-- 
2.1.0

