Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:40948 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752375AbbGIKKg (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 9 Jul 2015 06:10:36 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Kamil Debski <kamil@wypas.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-media@vger.kernel.org, kernel@pengutronix.de,
	Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH 10/10] [media] coda: rework meta counting and add separate lock
Date: Thu,  9 Jul 2015 12:10:21 +0200
Message-Id: <1436436621-12291-10-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1436436621-12291-1-git-send-email-p.zabel@pengutronix.de>
References: <1436436621-12291-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Keep count of number of buffer meta structures in the list and use
a separate spinlock for operations on this counted list instead
of reusing the bitstream mutex in some places and none at all in
others.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/platform/coda/coda-bit.c    | 16 ++++++++++++++--
 drivers/media/platform/coda/coda-common.c | 21 +++++++++------------
 drivers/media/platform/coda/coda.h        |  2 ++
 3 files changed, 25 insertions(+), 14 deletions(-)

diff --git a/drivers/media/platform/coda/coda-bit.c b/drivers/media/platform/coda/coda-bit.c
index 226ce4a..25910cc 100644
--- a/drivers/media/platform/coda/coda-bit.c
+++ b/drivers/media/platform/coda/coda-bit.c
@@ -226,6 +226,7 @@ void coda_fill_bitstream(struct coda_ctx *ctx, bool streaming)
 {
 	struct vb2_buffer *src_buf;
 	struct coda_buffer_meta *meta;
+	unsigned long flags;
 	u32 start;
 
 	if (ctx->bit_stream_param & CODA_BIT_STREAM_END_FLAG)
@@ -274,8 +275,13 @@ void coda_fill_bitstream(struct coda_ctx *ctx, bool streaming)
 				meta->start = start;
 				meta->end = ctx->bitstream_fifo.kfifo.in &
 					    ctx->bitstream_fifo.kfifo.mask;
+				spin_lock_irqsave(&ctx->buffer_meta_lock,
+						  flags);
 				list_add_tail(&meta->list,
 					      &ctx->buffer_meta_list);
+				ctx->num_metas++;
+				spin_unlock_irqrestore(&ctx->buffer_meta_lock,
+						       flags);
 
 				trace_coda_bit_queue(ctx, src_buf, meta);
 			}
@@ -1665,6 +1671,7 @@ static int coda_prepare_decode(struct coda_ctx *ctx)
 	struct coda_dev *dev = ctx->dev;
 	struct coda_q_data *q_data_dst;
 	struct coda_buffer_meta *meta;
+	unsigned long flags;
 	u32 reg_addr, reg_stride;
 
 	dst_buf = v4l2_m2m_next_dst_buf(ctx->fh.m2m_ctx);
@@ -1743,6 +1750,7 @@ static int coda_prepare_decode(struct coda_ctx *ctx)
 		coda_write(dev, ctx->iram_info.axi_sram_use,
 				CODA7_REG_BIT_AXI_SRAM_USE);
 
+	spin_lock_irqsave(&ctx->buffer_meta_lock, flags);
 	meta = list_first_entry_or_null(&ctx->buffer_meta_list,
 					struct coda_buffer_meta, list);
 
@@ -1762,6 +1770,7 @@ static int coda_prepare_decode(struct coda_ctx *ctx)
 			kfifo_in(&ctx->bitstream_fifo, buf, pad);
 		}
 	}
+	spin_unlock_irqrestore(&ctx->buffer_meta_lock, flags);
 
 	coda_kfifo_sync_to_device_full(ctx);
 
@@ -1783,6 +1792,7 @@ static void coda_finish_decode(struct coda_ctx *ctx)
 	struct vb2_buffer *dst_buf;
 	struct coda_buffer_meta *meta;
 	unsigned long payload;
+	unsigned long flags;
 	int width, height;
 	int decoded_idx;
 	int display_idx;
@@ -1908,11 +1918,13 @@ static void coda_finish_decode(struct coda_ctx *ctx)
 	} else {
 		val = coda_read(dev, CODA_RET_DEC_PIC_FRAME_NUM) - 1;
 		val -= ctx->sequence_offset;
-		mutex_lock(&ctx->bitstream_mutex);
+		spin_lock_irqsave(&ctx->buffer_meta_lock, flags);
 		if (!list_empty(&ctx->buffer_meta_list)) {
 			meta = list_first_entry(&ctx->buffer_meta_list,
 					      struct coda_buffer_meta, list);
 			list_del(&meta->list);
+			ctx->num_metas--;
+			spin_unlock_irqrestore(&ctx->buffer_meta_lock, flags);
 			/*
 			 * Clamp counters to 16 bits for comparison, as the HW
 			 * counter rolls over at this point for h.264. This
@@ -1929,13 +1941,13 @@ static void coda_finish_decode(struct coda_ctx *ctx)
 			ctx->frame_metas[decoded_idx] = *meta;
 			kfree(meta);
 		} else {
+			spin_unlock_irqrestore(&ctx->buffer_meta_lock, flags);
 			v4l2_err(&dev->v4l2_dev, "empty timestamp list!\n");
 			memset(&ctx->frame_metas[decoded_idx], 0,
 			       sizeof(struct coda_buffer_meta));
 			ctx->frame_metas[decoded_idx].sequence = val;
 			ctx->sequence_offset++;
 		}
-		mutex_unlock(&ctx->bitstream_mutex);
 
 		trace_coda_dec_pic_done(ctx, &ctx->frame_metas[decoded_idx]);
 
diff --git a/drivers/media/platform/coda/coda-common.c b/drivers/media/platform/coda/coda-common.c
index 267fda7..367b6ba 100644
--- a/drivers/media/platform/coda/coda-common.c
+++ b/drivers/media/platform/coda/coda-common.c
@@ -908,9 +908,9 @@ static int coda_job_ready(void *m2m_priv)
 	}
 
 	if (ctx->inst_type == CODA_INST_DECODER && ctx->use_bit) {
-		struct list_head *meta;
-		bool stream_end;
-		int num_metas;
+		bool stream_end = ctx->bit_stream_param &
+				  CODA_BIT_STREAM_END_FLAG;
+		int num_metas = ctx->num_metas;
 
 		if (ctx->hold && !src_bufs) {
 			v4l2_dbg(1, coda_debug, &ctx->dev->v4l2_dev,
@@ -919,13 +919,6 @@ static int coda_job_ready(void *m2m_priv)
 			return 0;
 		}
 
-		stream_end = ctx->bit_stream_param &
-			     CODA_BIT_STREAM_END_FLAG;
-
-		num_metas = 0;
-		list_for_each(meta, &ctx->buffer_meta_list)
-			num_metas++;
-
 		if (!stream_end && (num_metas + src_bufs) < 2) {
 			v4l2_dbg(1, coda_debug, &ctx->dev->v4l2_dev,
 				 "%d: not ready: need 2 buffers available (%d, %d)\n",
@@ -951,6 +944,7 @@ static int coda_job_ready(void *m2m_priv)
 
 	v4l2_dbg(1, coda_debug, &ctx->dev->v4l2_dev,
 			"job ready\n");
+
 	return 1;
 }
 
@@ -1267,6 +1261,7 @@ static void coda_stop_streaming(struct vb2_queue *q)
 	struct coda_ctx *ctx = vb2_get_drv_priv(q);
 	struct coda_dev *dev = ctx->dev;
 	struct vb2_buffer *buf;
+	unsigned long flags;
 	bool stop;
 
 	stop = ctx->streamon_out && ctx->streamon_cap;
@@ -1301,14 +1296,15 @@ static void coda_stop_streaming(struct vb2_queue *q)
 			queue_work(dev->workqueue, &ctx->seq_end_work);
 			flush_work(&ctx->seq_end_work);
 		}
-		mutex_lock(&ctx->bitstream_mutex);
+		spin_lock_irqsave(&ctx->buffer_meta_lock, flags);
 		while (!list_empty(&ctx->buffer_meta_list)) {
 			meta = list_first_entry(&ctx->buffer_meta_list,
 						struct coda_buffer_meta, list);
 			list_del(&meta->list);
 			kfree(meta);
 		}
-		mutex_unlock(&ctx->bitstream_mutex);
+		ctx->num_metas = 0;
+		spin_unlock_irqrestore(&ctx->buffer_meta_lock, flags);
 		kfifo_init(&ctx->bitstream_fifo,
 			ctx->bitstream.vaddr, ctx->bitstream.size);
 		ctx->runcounter = 0;
@@ -1661,6 +1657,7 @@ static int coda_open(struct file *file)
 	mutex_init(&ctx->bitstream_mutex);
 	mutex_init(&ctx->buffer_mutex);
 	INIT_LIST_HEAD(&ctx->buffer_meta_list);
+	spin_lock_init(&ctx->buffer_meta_lock);
 
 	coda_lock(ctx);
 	list_add(&ctx->list, &dev->instances);
diff --git a/drivers/media/platform/coda/coda.h b/drivers/media/platform/coda/coda.h
index 8e0af22..a3d70cc 100644
--- a/drivers/media/platform/coda/coda.h
+++ b/drivers/media/platform/coda/coda.h
@@ -227,6 +227,8 @@ struct coda_ctx {
 	struct coda_buffer_meta		frame_metas[CODA_MAX_FRAMEBUFFERS];
 	u32				frame_errors[CODA_MAX_FRAMEBUFFERS];
 	struct list_head		buffer_meta_list;
+	spinlock_t			buffer_meta_lock;
+	int				num_metas;
 	struct coda_aux_buf		workbuf;
 	int				num_internal_frames;
 	int				idx;
-- 
2.1.4

