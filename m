Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:35560 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161506Ab3FUHzk (ORCPT
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
Subject: [PATCH v2 7/8] [media] coda: split encoder specific parts out of device_run and irq_handler
Date: Fri, 21 Jun 2013 09:55:33 +0200
Message-Id: <1371801334-22324-8-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1371801334-22324-1-git-send-email-p.zabel@pengutronix.de>
References: <1371801334-22324-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add coda_prepare_encode() and coda_finish_encode() functions. They are called
from coda_device_run() and coda_irq_handler(), respectively, before and after
the hardware picture run. This should make the following decoder support patch
easier to read, which will add the coda_prepare/finish_decode() equivalents.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/platform/coda.c | 82 +++++++++++++++++++++++++------------------
 1 file changed, 48 insertions(+), 34 deletions(-)

diff --git a/drivers/media/platform/coda.c b/drivers/media/platform/coda.c
index 856a93e..e8b3708 100644
--- a/drivers/media/platform/coda.c
+++ b/drivers/media/platform/coda.c
@@ -793,9 +793,8 @@ static void coda_fill_bitstream(struct coda_ctx *ctx)
 /*
  * Mem-to-mem operations.
  */
-static void coda_device_run(void *m2m_priv)
+static void coda_prepare_encode(struct coda_ctx *ctx)
 {
-	struct coda_ctx *ctx = m2m_priv;
 	struct coda_q_data *q_data_src, *q_data_dst;
 	struct vb2_buffer *src_buf, *dst_buf;
 	struct coda_dev *dev = ctx->dev;
@@ -805,8 +804,6 @@ static void coda_device_run(void *m2m_priv)
 	u32 pic_stream_buffer_addr, pic_stream_buffer_size;
 	u32 dst_fourcc;
 
-	mutex_lock(&dev->coda_mutex);
-
 	src_buf = v4l2_m2m_next_src_buf(ctx->m2m_ctx);
 	dst_buf = v4l2_m2m_next_dst_buf(ctx->m2m_ctx);
 	q_data_src = get_q_data(ctx, V4L2_BUF_TYPE_VIDEO_OUTPUT);
@@ -917,6 +914,16 @@ static void coda_device_run(void *m2m_priv)
 	coda_write(dev, pic_stream_buffer_addr, CODA_CMD_ENC_PIC_BB_START);
 	coda_write(dev, pic_stream_buffer_size / 1024,
 		   CODA_CMD_ENC_PIC_BB_SIZE);
+}
+
+static void coda_device_run(void *m2m_priv)
+{
+	struct coda_ctx *ctx = m2m_priv;
+	struct coda_dev *dev = ctx->dev;
+
+	mutex_lock(&dev->coda_mutex);
+
+	coda_prepare_encode(ctx);
 
 	if (dev->devtype->product == CODA_7541) {
 		coda_write(dev, CODA7_USE_BIT_ENABLE | CODA7_USE_HOST_BIT_ENABLE |
@@ -2025,39 +2032,11 @@ static const struct v4l2_file_operations coda_fops = {
 	.mmap		= coda_mmap,
 };
 
-static irqreturn_t coda_irq_handler(int irq, void *data)
+static void coda_encode_finish(struct coda_ctx *ctx)
 {
 	struct vb2_buffer *src_buf, *dst_buf;
-	struct coda_dev *dev = data;
+	struct coda_dev *dev = ctx->dev;
 	u32 wr_ptr, start_ptr;
-	struct coda_ctx *ctx;
-
-	cancel_delayed_work(&dev->timeout);
-
-	/* read status register to attend the IRQ */
-	coda_read(dev, CODA_REG_BIT_INT_STATUS);
-	coda_write(dev, CODA_REG_BIT_INT_CLEAR_SET,
-		      CODA_REG_BIT_INT_CLEAR);
-
-	ctx = v4l2_m2m_get_curr_priv(dev->m2m_dev);
-	if (ctx == NULL) {
-		v4l2_err(&dev->v4l2_dev, "Instance released before the end of transaction\n");
-		mutex_unlock(&dev->coda_mutex);
-		return IRQ_HANDLED;
-	}
-
-	if (ctx->aborting) {
-		v4l2_dbg(1, coda_debug, &ctx->dev->v4l2_dev,
-			 "task has been aborted\n");
-		mutex_unlock(&dev->coda_mutex);
-		return IRQ_HANDLED;
-	}
-
-	if (coda_isbusy(ctx->dev)) {
-		v4l2_dbg(1, coda_debug, &ctx->dev->v4l2_dev,
-			 "coda is still busy!!!!\n");
-		return IRQ_NONE;
-	}
 
 	src_buf = v4l2_m2m_src_buf_remove(ctx->m2m_ctx);
 	dst_buf = v4l2_m2m_dst_buf_remove(ctx->m2m_ctx);
@@ -2106,6 +2085,41 @@ static irqreturn_t coda_irq_handler(int irq, void *data)
 		dst_buf->v4l2_buf.sequence,
 		(dst_buf->v4l2_buf.flags & V4L2_BUF_FLAG_KEYFRAME) ?
 		"KEYFRAME" : "PFRAME");
+}
+
+static irqreturn_t coda_irq_handler(int irq, void *data)
+{
+	struct coda_dev *dev = data;
+	struct coda_ctx *ctx;
+
+	cancel_delayed_work(&dev->timeout);
+
+	/* read status register to attend the IRQ */
+	coda_read(dev, CODA_REG_BIT_INT_STATUS);
+	coda_write(dev, CODA_REG_BIT_INT_CLEAR_SET,
+		      CODA_REG_BIT_INT_CLEAR);
+
+	ctx = v4l2_m2m_get_curr_priv(dev->m2m_dev);
+	if (ctx == NULL) {
+		v4l2_err(&dev->v4l2_dev, "Instance released before the end of transaction\n");
+		mutex_unlock(&dev->coda_mutex);
+		return IRQ_HANDLED;
+	}
+
+	if (ctx->aborting) {
+		v4l2_dbg(1, coda_debug, &ctx->dev->v4l2_dev,
+			 "task has been aborted\n");
+		mutex_unlock(&dev->coda_mutex);
+		return IRQ_HANDLED;
+	}
+
+	if (coda_isbusy(ctx->dev)) {
+		v4l2_dbg(1, coda_debug, &ctx->dev->v4l2_dev,
+			 "coda is still busy!!!!\n");
+		return IRQ_NONE;
+	}
+
+	coda_encode_finish(ctx);
 
 	mutex_unlock(&dev->coda_mutex);
 
-- 
1.8.3.1

