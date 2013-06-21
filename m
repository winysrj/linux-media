Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:35555 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161504Ab3FUHzk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 21 Jun 2013 03:55:40 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Kamil Debski <k.debski@samsung.com>,
	Javier Martin <javier.martin@vista-silicon.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	=?UTF-8?q?Ga=C3=ABtan=20Carlier?= <gcembed@gmail.com>,
	Wei Yongjun <weiyj.lk@gmail.com>,
	Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH v2 5/8] [media] coda: add bitstream ringbuffer handling for decoder
Date: Fri, 21 Jun 2013 09:55:31 +0200
Message-Id: <1371801334-22324-6-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1371801334-22324-1-git-send-email-p.zabel@pengutronix.de>
References: <1371801334-22324-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add a bitstream ringbuffer using kfifo. Queued source buffers are to be copied
into the bitstream ringbuffer immediately and marked as done, if possible.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/platform/coda.c | 134 +++++++++++++++++++++++++++++++++++++++++-
 drivers/media/platform/coda.h |   3 +
 2 files changed, 134 insertions(+), 3 deletions(-)

diff --git a/drivers/media/platform/coda.c b/drivers/media/platform/coda.c
index 28ee3f7..1f3bd43 100644
--- a/drivers/media/platform/coda.c
+++ b/drivers/media/platform/coda.c
@@ -18,6 +18,7 @@
 #include <linux/interrupt.h>
 #include <linux/io.h>
 #include <linux/irq.h>
+#include <linux/kfifo.h>
 #include <linux/module.h>
 #include <linux/of_device.h>
 #include <linux/platform_device.h>
@@ -182,6 +183,7 @@ struct coda_ctx {
 	int				streamon_out;
 	int				streamon_cap;
 	u32				isequence;
+	u32				qsequence;
 	struct coda_q_data		q_data[2];
 	enum coda_inst_type		inst_type;
 	struct coda_codec		*codec;
@@ -193,6 +195,9 @@ struct coda_ctx {
 	int				gopcounter;
 	char				vpu_header[3][64];
 	int				vpu_header_size[3];
+	struct kfifo			bitstream_fifo;
+	struct mutex			bitstream_mutex;
+	struct coda_aux_buf		bitstream;
 	struct coda_aux_buf		parabuf;
 	struct coda_aux_buf		internal_frames[CODA_MAX_FRAMEBUFFERS];
 	struct coda_aux_buf		workbuf;
@@ -200,6 +205,7 @@ struct coda_ctx {
 	int				idx;
 	int				reg_idx;
 	struct coda_iram_info		iram_info;
+	u32				bit_stream_param;
 };
 
 static const u8 coda_filler_nal[14] = { 0x00, 0x00, 0x00, 0x01, 0x0c, 0xff,
@@ -249,6 +255,8 @@ static void coda_command_async(struct coda_ctx *ctx, int cmd)
 
 	if (dev->devtype->product == CODA_7541) {
 		/* Restore context related registers to CODA */
+		coda_write(dev, ctx->bit_stream_param,
+				CODA_REG_BIT_BIT_STREAM_PARAM);
 		coda_write(dev, ctx->workbuf.paddr, CODA_REG_BIT_WORK_BUF_ADDR);
 	}
 
@@ -683,6 +691,105 @@ static const struct v4l2_ioctl_ops coda_ioctl_ops = {
 	.vidioc_streamoff	= vidioc_streamoff,
 };
 
+static inline int coda_get_bitstream_payload(struct coda_ctx *ctx)
+{
+	return kfifo_len(&ctx->bitstream_fifo);
+}
+
+static void coda_kfifo_sync_from_device(struct coda_ctx *ctx)
+{
+	struct __kfifo *kfifo = &ctx->bitstream_fifo.kfifo;
+	struct coda_dev *dev = ctx->dev;
+	u32 rd_ptr;
+
+	rd_ptr = coda_read(dev, CODA_REG_BIT_RD_PTR(ctx->reg_idx));
+	kfifo->out = (kfifo->in & ~kfifo->mask) |
+		      (rd_ptr - ctx->bitstream.paddr);
+	if (kfifo->out > kfifo->in)
+		kfifo->out -= kfifo->mask + 1;
+}
+
+static void coda_kfifo_sync_to_device_full(struct coda_ctx *ctx)
+{
+	struct __kfifo *kfifo = &ctx->bitstream_fifo.kfifo;
+	struct coda_dev *dev = ctx->dev;
+	u32 rd_ptr, wr_ptr;
+
+	rd_ptr = ctx->bitstream.paddr + (kfifo->out & kfifo->mask);
+	coda_write(dev, rd_ptr, CODA_REG_BIT_RD_PTR(ctx->reg_idx));
+	wr_ptr = ctx->bitstream.paddr + (kfifo->in & kfifo->mask);
+	coda_write(dev, wr_ptr, CODA_REG_BIT_WR_PTR(ctx->reg_idx));
+}
+
+static void coda_kfifo_sync_to_device_write(struct coda_ctx *ctx)
+{
+	struct __kfifo *kfifo = &ctx->bitstream_fifo.kfifo;
+	struct coda_dev *dev = ctx->dev;
+	u32 wr_ptr;
+
+	wr_ptr = ctx->bitstream.paddr + (kfifo->in & kfifo->mask);
+	coda_write(dev, wr_ptr, CODA_REG_BIT_WR_PTR(ctx->reg_idx));
+}
+
+static int coda_bitstream_queue(struct coda_ctx *ctx, struct vb2_buffer *src_buf)
+{
+	u32 src_size = vb2_get_plane_payload(src_buf, 0);
+	u32 n;
+
+	n = kfifo_in(&ctx->bitstream_fifo, vb2_plane_vaddr(src_buf, 0), src_size);
+	if (n < src_size)
+		return -ENOSPC;
+
+	dma_sync_single_for_device(&ctx->dev->plat_dev->dev, ctx->bitstream.paddr,
+				   ctx->bitstream.size, DMA_TO_DEVICE);
+
+	ctx->qsequence++;
+
+	return 0;
+}
+
+static bool coda_bitstream_try_queue(struct coda_ctx *ctx,
+				     struct vb2_buffer *src_buf)
+{
+	int ret;
+
+	if (coda_get_bitstream_payload(ctx) +
+	    vb2_get_plane_payload(src_buf, 0) + 512 >= ctx->bitstream.size)
+		return false;
+
+	if (vb2_plane_vaddr(src_buf, 0) == NULL) {
+		v4l2_err(&ctx->dev->v4l2_dev, "trying to queue empty buffer\n");
+		return true;
+	}
+
+	ret = coda_bitstream_queue(ctx, src_buf);
+	if (ret < 0) {
+		v4l2_err(&ctx->dev->v4l2_dev, "bitstream buffer overflow\n");
+		return false;
+	}
+	/* Sync read pointer to device */
+	if (ctx == v4l2_m2m_get_curr_priv(ctx->dev->m2m_dev))
+		coda_kfifo_sync_to_device_write(ctx);
+
+	return true;
+}
+
+static void coda_fill_bitstream(struct coda_ctx *ctx)
+{
+	struct vb2_buffer *src_buf;
+
+	while (v4l2_m2m_num_src_bufs_ready(ctx->m2m_ctx) > 0) {
+		src_buf = v4l2_m2m_next_src_buf(ctx->m2m_ctx);
+
+		if (coda_bitstream_try_queue(ctx, src_buf)) {
+			src_buf = v4l2_m2m_src_buf_remove(ctx->m2m_ctx);
+			v4l2_m2m_buf_done(src_buf, VB2_BUF_STATE_DONE);
+		} else {
+			break;
+		}
+	}
+}
+
 /*
  * Mem-to-mem operations.
  */
@@ -833,15 +940,22 @@ static int coda_job_ready(void *m2m_priv)
 
 	/*
 	 * For both 'P' and 'key' frame cases 1 picture
-	 * and 1 frame are needed.
+	 * and 1 frame are needed. In the decoder case,
+	 * the compressed frame can be in the bitstream.
 	 */
-	if (!v4l2_m2m_num_src_bufs_ready(ctx->m2m_ctx) ||
-		!v4l2_m2m_num_dst_bufs_ready(ctx->m2m_ctx)) {
+	if (!v4l2_m2m_num_src_bufs_ready(ctx->m2m_ctx) &&
+	    ctx->inst_type != CODA_INST_DECODER) {
 		v4l2_dbg(1, coda_debug, &ctx->dev->v4l2_dev,
 			 "not ready: not enough video buffers.\n");
 		return 0;
 	}
 
+	if (!v4l2_m2m_num_dst_bufs_ready(ctx->m2m_ctx)) {
+		v4l2_dbg(1, coda_debug, &ctx->dev->v4l2_dev,
+			 "not ready: not enough video capture buffers.\n");
+		return 0;
+	}
+
 	if (ctx->aborting) {
 		v4l2_dbg(1, coda_debug, &ctx->dev->v4l2_dev,
 			 "not ready: aborting\n");
@@ -1776,6 +1890,18 @@ static int coda_open(struct file *file)
 		goto err;
 	}
 
+	ctx->bitstream.size = CODA_MAX_FRAME_SIZE;
+	ctx->bitstream.vaddr = dma_alloc_writecombine(&dev->plat_dev->dev,
+			ctx->bitstream.size, &ctx->bitstream.paddr, GFP_KERNEL);
+	if (!ctx->bitstream.vaddr) {
+		v4l2_err(&dev->v4l2_dev, "failed to allocate bitstream ringbuffer");
+		ret = -ENOMEM;
+		goto err;
+	}
+	kfifo_init(&ctx->bitstream_fifo,
+		ctx->bitstream.vaddr, ctx->bitstream.size);
+	mutex_init(&ctx->bitstream_mutex);
+
 	coda_lock(ctx);
 	list_add(&ctx->list, &dev->instances);
 	coda_unlock(ctx);
@@ -1807,6 +1933,8 @@ static int coda_release(struct file *file)
 	list_del(&ctx->list);
 	coda_unlock(ctx);
 
+	dma_free_writecombine(&dev->plat_dev->dev, ctx->bitstream.size,
+		ctx->bitstream.vaddr, ctx->bitstream.paddr);
 	coda_free_context_buffers(ctx);
 	if (ctx->dev->devtype->product == CODA_DX6)
 		coda_free_aux_buf(dev, &ctx->workbuf);
diff --git a/drivers/media/platform/coda.h b/drivers/media/platform/coda.h
index b2b5b1d..140eea5 100644
--- a/drivers/media/platform/coda.h
+++ b/drivers/media/platform/coda.h
@@ -43,6 +43,9 @@
 #define		CODA_STREAM_ENDIAN_SELECT	(1 << 0)
 #define CODA_REG_BIT_FRAME_MEM_CTRL		0x110
 #define		CODA_IMAGE_ENDIAN_SELECT	(1 << 0)
+#define CODA_REG_BIT_BIT_STREAM_PARAM		0x114
+#define		CODA_BIT_STREAM_END_FLAG	(1 << 2)
+#define		CODA_BIT_DEC_SEQ_INIT_ESCAPE	(1 << 0)
 #define CODA_REG_BIT_TEMP_BUF_ADDR		0x118
 #define CODA_REG_BIT_RD_PTR(x)			(0x120 + 8 * (x))
 #define CODA_REG_BIT_WR_PTR(x)			(0x124 + 8 * (x))
-- 
1.8.3.1

