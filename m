Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([85.220.165.71]:59845 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729929AbeKFApj (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 5 Nov 2018 19:45:39 -0500
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>, kernel@pengutronix.de
Subject: [PATCH 07/15] media: coda: don't disable IRQs across buffer meta handling
Date: Mon,  5 Nov 2018 16:25:05 +0100
Message-Id: <20181105152513.26345-7-p.zabel@pengutronix.de>
In-Reply-To: <20181105152513.26345-1-p.zabel@pengutronix.de>
References: <20181105152513.26345-1-p.zabel@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Lucas Stach <l.stach@pengutronix.de>

The CODA driver uses threaded IRQs only, so there is nothing happening
in hardirq context that could interfere with the buffer meta handling.

Signed-off-by: Lucas Stach <l.stach@pengutronix.de>
---
 drivers/media/platform/coda/coda-bit.c    | 19 +++++++------------
 drivers/media/platform/coda/coda-common.c |  5 ++---
 2 files changed, 9 insertions(+), 15 deletions(-)

diff --git a/drivers/media/platform/coda/coda-bit.c b/drivers/media/platform/coda/coda-bit.c
index ee9d2a402ccd..348b17140715 100644
--- a/drivers/media/platform/coda/coda-bit.c
+++ b/drivers/media/platform/coda/coda-bit.c
@@ -253,7 +253,6 @@ void coda_fill_bitstream(struct coda_ctx *ctx, struct list_head *buffer_list)
 {
 	struct vb2_v4l2_buffer *src_buf;
 	struct coda_buffer_meta *meta;
-	unsigned long flags;
 	u32 start;
 
 	if (ctx->bit_stream_param & CODA_BIT_STREAM_END_FLAG)
@@ -332,13 +331,11 @@ void coda_fill_bitstream(struct coda_ctx *ctx, struct list_head *buffer_list)
 				meta->timestamp = src_buf->vb2_buf.timestamp;
 				meta->start = start;
 				meta->end = ctx->bitstream_fifo.kfifo.in;
-				spin_lock_irqsave(&ctx->buffer_meta_lock,
-						  flags);
+				spin_lock(&ctx->buffer_meta_lock);
 				list_add_tail(&meta->list,
 					      &ctx->buffer_meta_list);
 				ctx->num_metas++;
-				spin_unlock_irqrestore(&ctx->buffer_meta_lock,
-						       flags);
+				spin_unlock(&ctx->buffer_meta_lock);
 
 				trace_coda_bit_queue(ctx, src_buf, meta);
 			}
@@ -1894,7 +1891,6 @@ static int coda_prepare_decode(struct coda_ctx *ctx)
 	struct coda_dev *dev = ctx->dev;
 	struct coda_q_data *q_data_dst;
 	struct coda_buffer_meta *meta;
-	unsigned long flags;
 	u32 rot_mode = 0;
 	u32 reg_addr, reg_stride;
 
@@ -1988,7 +1984,7 @@ static int coda_prepare_decode(struct coda_ctx *ctx)
 		coda_write(dev, ctx->iram_info.axi_sram_use,
 				CODA7_REG_BIT_AXI_SRAM_USE);
 
-	spin_lock_irqsave(&ctx->buffer_meta_lock, flags);
+	spin_lock(&ctx->buffer_meta_lock);
 	meta = list_first_entry_or_null(&ctx->buffer_meta_list,
 					struct coda_buffer_meta, list);
 
@@ -2007,7 +2003,7 @@ static int coda_prepare_decode(struct coda_ctx *ctx)
 			kfifo_in(&ctx->bitstream_fifo, buf, pad);
 		}
 	}
-	spin_unlock_irqrestore(&ctx->buffer_meta_lock, flags);
+	spin_unlock(&ctx->buffer_meta_lock);
 
 	coda_kfifo_sync_to_device_full(ctx);
 
@@ -2029,7 +2025,6 @@ static void coda_finish_decode(struct coda_ctx *ctx)
 	struct vb2_v4l2_buffer *dst_buf;
 	struct coda_buffer_meta *meta;
 	unsigned long payload;
-	unsigned long flags;
 	int width, height;
 	int decoded_idx;
 	int display_idx;
@@ -2161,13 +2156,13 @@ static void coda_finish_decode(struct coda_ctx *ctx)
 	} else {
 		val = coda_read(dev, CODA_RET_DEC_PIC_FRAME_NUM) - 1;
 		val -= ctx->sequence_offset;
-		spin_lock_irqsave(&ctx->buffer_meta_lock, flags);
+		spin_lock(&ctx->buffer_meta_lock);
 		if (!list_empty(&ctx->buffer_meta_list)) {
 			meta = list_first_entry(&ctx->buffer_meta_list,
 					      struct coda_buffer_meta, list);
 			list_del(&meta->list);
 			ctx->num_metas--;
-			spin_unlock_irqrestore(&ctx->buffer_meta_lock, flags);
+			spin_unlock(&ctx->buffer_meta_lock);
 			/*
 			 * Clamp counters to 16 bits for comparison, as the HW
 			 * counter rolls over at this point for h.264. This
@@ -2184,7 +2179,7 @@ static void coda_finish_decode(struct coda_ctx *ctx)
 			ctx->frame_metas[decoded_idx] = *meta;
 			kfree(meta);
 		} else {
-			spin_unlock_irqrestore(&ctx->buffer_meta_lock, flags);
+			spin_unlock(&ctx->buffer_meta_lock);
 			v4l2_err(&dev->v4l2_dev, "empty timestamp list!\n");
 			memset(&ctx->frame_metas[decoded_idx], 0,
 			       sizeof(struct coda_buffer_meta));
diff --git a/drivers/media/platform/coda/coda-common.c b/drivers/media/platform/coda/coda-common.c
index 54b7344231c0..60b866160094 100644
--- a/drivers/media/platform/coda/coda-common.c
+++ b/drivers/media/platform/coda/coda-common.c
@@ -1689,7 +1689,6 @@ static void coda_stop_streaming(struct vb2_queue *q)
 	struct coda_ctx *ctx = vb2_get_drv_priv(q);
 	struct coda_dev *dev = ctx->dev;
 	struct vb2_v4l2_buffer *buf;
-	unsigned long flags;
 	bool stop;
 
 	stop = ctx->streamon_out && ctx->streamon_cap;
@@ -1724,7 +1723,7 @@ static void coda_stop_streaming(struct vb2_queue *q)
 			queue_work(dev->workqueue, &ctx->seq_end_work);
 			flush_work(&ctx->seq_end_work);
 		}
-		spin_lock_irqsave(&ctx->buffer_meta_lock, flags);
+		spin_lock(&ctx->buffer_meta_lock);
 		while (!list_empty(&ctx->buffer_meta_list)) {
 			meta = list_first_entry(&ctx->buffer_meta_list,
 						struct coda_buffer_meta, list);
@@ -1732,7 +1731,7 @@ static void coda_stop_streaming(struct vb2_queue *q)
 			kfree(meta);
 		}
 		ctx->num_metas = 0;
-		spin_unlock_irqrestore(&ctx->buffer_meta_lock, flags);
+		spin_unlock(&ctx->buffer_meta_lock);
 		kfifo_init(&ctx->bitstream_fifo,
 			ctx->bitstream.vaddr, ctx->bitstream.size);
 		ctx->runcounter = 0;
-- 
2.19.1
