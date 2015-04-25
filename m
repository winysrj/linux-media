Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:46806 "EHLO
	lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933521AbbDYPng (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 25 Apr 2015 11:43:36 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 08/12] dt3155v4l: correctly start and stop streaming
Date: Sat, 25 Apr 2015 17:42:47 +0200
Message-Id: <1429976571-34872-9-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1429976571-34872-1-git-send-email-hverkuil@xs4all.nl>
References: <1429976571-34872-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Don't start streaming when a buffer is queued, instead implement the
start_streaming op and do it there, leaving it up to the vb2 framework
to call start_streaming when enough buffers have been queued.

And don't stop streaming from within the interrupt routine, instead do
that in stop_streaming.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/staging/media/dt3155v4l/dt3155v4l.c | 124 +++++++++++++++-------------
 drivers/staging/media/dt3155v4l/dt3155v4l.h |   4 +-
 2 files changed, 67 insertions(+), 61 deletions(-)

diff --git a/drivers/staging/media/dt3155v4l/dt3155v4l.c b/drivers/staging/media/dt3155v4l/dt3155v4l.c
index 0162c62..0ce7523 100644
--- a/drivers/staging/media/dt3155v4l/dt3155v4l.c
+++ b/drivers/staging/media/dt3155v4l/dt3155v4l.c
@@ -168,32 +168,6 @@ static int wait_i2c_reg(void __iomem *addr)
 	return 0;
 }
 
-static int dt3155_start_acq(struct dt3155_priv *pd)
-{
-	struct vb2_buffer *vb = pd->curr_buf;
-	dma_addr_t dma_addr;
-
-	dma_addr = vb2_dma_contig_plane_dma_addr(vb, 0);
-	iowrite32(dma_addr, pd->regs + EVEN_DMA_START);
-	iowrite32(dma_addr + img_width, pd->regs + ODD_DMA_START);
-	iowrite32(img_width, pd->regs + EVEN_DMA_STRIDE);
-	iowrite32(img_width, pd->regs + ODD_DMA_STRIDE);
-	/* enable interrupts, clear all irq flags */
-	iowrite32(FLD_START_EN | FLD_END_ODD_EN | FLD_START |
-			FLD_END_EVEN | FLD_END_ODD, pd->regs + INT_CSR);
-	iowrite32(FIFO_EN | SRST | FLD_CRPT_ODD | FLD_CRPT_EVEN |
-		  FLD_DN_ODD | FLD_DN_EVEN | CAP_CONT_EVEN | CAP_CONT_ODD,
-							pd->regs + CSR1);
-	wait_i2c_reg(pd->regs);
-	write_i2c_reg(pd->regs, CONFIG, pd->config);
-	write_i2c_reg(pd->regs, EVEN_CSR, CSR_ERROR | CSR_DONE);
-	write_i2c_reg(pd->regs, ODD_CSR, CSR_ERROR | CSR_DONE);
-
-	/*  start the board  */
-	write_i2c_reg(pd->regs, CSR2, pd->csr2 | BUSY_EVEN | BUSY_ODD);
-	return 0; /* success  */
-}
-
 static int
 dt3155_queue_setup(struct vb2_queue *vq, const struct v4l2_format *fmt,
 		unsigned int *nbuffers, unsigned int *num_planes,
@@ -219,36 +193,79 @@ static int dt3155_buf_prepare(struct vb2_buffer *vb)
 	return 0;
 }
 
+static int dt3155_start_streaming(struct vb2_queue *q, unsigned count)
+{
+	struct dt3155_priv *pd = vb2_get_drv_priv(q);
+	struct vb2_buffer *vb = pd->curr_buf;
+	dma_addr_t dma_addr;
+
+	pd->sequence = 0;
+	dma_addr = vb2_dma_contig_plane_dma_addr(vb, 0);
+	iowrite32(dma_addr, pd->regs + EVEN_DMA_START);
+	iowrite32(dma_addr + img_width, pd->regs + ODD_DMA_START);
+	iowrite32(img_width, pd->regs + EVEN_DMA_STRIDE);
+	iowrite32(img_width, pd->regs + ODD_DMA_STRIDE);
+	/* enable interrupts, clear all irq flags */
+	iowrite32(FLD_START_EN | FLD_END_ODD_EN | FLD_START |
+			FLD_END_EVEN | FLD_END_ODD, pd->regs + INT_CSR);
+	iowrite32(FIFO_EN | SRST | FLD_CRPT_ODD | FLD_CRPT_EVEN |
+		  FLD_DN_ODD | FLD_DN_EVEN | CAP_CONT_EVEN | CAP_CONT_ODD,
+							pd->regs + CSR1);
+	wait_i2c_reg(pd->regs);
+	write_i2c_reg(pd->regs, CONFIG, pd->config);
+	write_i2c_reg(pd->regs, EVEN_CSR, CSR_ERROR | CSR_DONE);
+	write_i2c_reg(pd->regs, ODD_CSR, CSR_ERROR | CSR_DONE);
+
+	/*  start the board  */
+	write_i2c_reg(pd->regs, CSR2, pd->csr2 | BUSY_EVEN | BUSY_ODD);
+	return 0;
+}
+
 static void dt3155_stop_streaming(struct vb2_queue *q)
 {
 	struct dt3155_priv *pd = vb2_get_drv_priv(q);
 	struct vb2_buffer *vb;
 
 	spin_lock_irq(&pd->lock);
+	/* stop the board */
+	write_i2c_reg_nowait(pd->regs, CSR2, pd->csr2);
+	iowrite32(FIFO_EN | SRST | FLD_CRPT_ODD | FLD_CRPT_EVEN |
+		  FLD_DN_ODD | FLD_DN_EVEN, pd->regs + CSR1);
+	/* disable interrupts, clear all irq flags */
+	iowrite32(FLD_START | FLD_END_EVEN | FLD_END_ODD, pd->regs + INT_CSR);
+	spin_unlock_irq(&pd->lock);
+
+	/*
+	 * It is not clear whether the DMA stops at once or whether it
+	 * will finish the current frame or field first. To be on the
+	 * safe side we wait a bit.
+	 */
+	msleep(45);
+
+	spin_lock_irq(&pd->lock);
+	if (pd->curr_buf) {
+		vb2_buffer_done(pd->curr_buf, VB2_BUF_STATE_ERROR);
+		pd->curr_buf = NULL;
+	}
+
 	while (!list_empty(&pd->dmaq)) {
 		vb = list_first_entry(&pd->dmaq, typeof(*vb), done_entry);
 		list_del(&vb->done_entry);
 		vb2_buffer_done(vb, VB2_BUF_STATE_ERROR);
 	}
 	spin_unlock_irq(&pd->lock);
-	msleep(45); /* irq hendler will stop the hardware */
-	/* disable all irqs, clear all irq flags */
-	iowrite32(FLD_START | FLD_END_EVEN | FLD_END_ODD,
-					pd->regs + INT_CSR);
 }
 
 static void dt3155_buf_queue(struct vb2_buffer *vb)
 {
 	struct dt3155_priv *pd = vb2_get_drv_priv(vb->vb2_queue);
 
-	/*  pd->q->streaming = 1 when dt3155_buf_queue() is invoked  */
+	/*  pd->vidq.streaming = 1 when dt3155_buf_queue() is invoked  */
 	spin_lock_irq(&pd->lock);
 	if (pd->curr_buf)
 		list_add_tail(&vb->done_entry, &pd->dmaq);
-	else {
+	else
 		pd->curr_buf = vb;
-		dt3155_start_acq(pd);
-	}
 	spin_unlock_irq(&pd->lock);
 }
 
@@ -257,6 +274,7 @@ static const struct vb2_ops q_ops = {
 	.wait_prepare = vb2_ops_wait_prepare,
 	.wait_finish = vb2_ops_wait_finish,
 	.buf_prepare = dt3155_buf_prepare,
+	.start_streaming = dt3155_start_streaming,
 	.stop_streaming = dt3155_stop_streaming,
 	.buf_queue = dt3155_buf_queue,
 };
@@ -274,7 +292,6 @@ static irqreturn_t dt3155_irq_handler_even(int irq, void *dev_id)
 	if ((tmp & FLD_START) && !(tmp & FLD_END_ODD)) {
 		iowrite32(FLD_START_EN | FLD_END_ODD_EN | FLD_START,
 							ipd->regs + INT_CSR);
-		ipd->field_count++;
 		return IRQ_HANDLED; /* start of field irq */
 	}
 	tmp = ioread32(ipd->regs + CSR1) & (FLD_CRPT_EVEN | FLD_CRPT_ODD);
@@ -287,39 +304,28 @@ static irqreturn_t dt3155_irq_handler_even(int irq, void *dev_id)
 	}
 
 	spin_lock(&ipd->lock);
-	if (ipd->curr_buf) {
+	if (ipd->curr_buf && !list_empty(&ipd->dmaq)) {
 		v4l2_get_timestamp(&ipd->curr_buf->v4l2_buf.timestamp);
-		ipd->curr_buf->v4l2_buf.sequence = (ipd->field_count) >> 1;
+		ipd->curr_buf->v4l2_buf.sequence = ipd->sequence++;
+		ipd->curr_buf->v4l2_buf.field = V4L2_FIELD_NONE;
 		vb2_buffer_done(ipd->curr_buf, VB2_BUF_STATE_DONE);
+
+		ivb = list_first_entry(&ipd->dmaq, typeof(*ivb), done_entry);
+		list_del(&ivb->done_entry);
+		ipd->curr_buf = ivb;
+		dma_addr = vb2_dma_contig_plane_dma_addr(ivb, 0);
+		iowrite32(dma_addr, ipd->regs + EVEN_DMA_START);
+		iowrite32(dma_addr + img_width, ipd->regs + ODD_DMA_START);
+		iowrite32(img_width, ipd->regs + EVEN_DMA_STRIDE);
+		iowrite32(img_width, ipd->regs + ODD_DMA_STRIDE);
+		mmiowb();
 	}
 
-	if (!ipd->vidq.streaming || list_empty(&ipd->dmaq))
-		goto stop_dma;
-	ivb = list_first_entry(&ipd->dmaq, typeof(*ivb), done_entry);
-	list_del(&ivb->done_entry);
-	ipd->curr_buf = ivb;
-	dma_addr = vb2_dma_contig_plane_dma_addr(ivb, 0);
-	iowrite32(dma_addr, ipd->regs + EVEN_DMA_START);
-	iowrite32(dma_addr + img_width, ipd->regs + ODD_DMA_START);
-	iowrite32(img_width, ipd->regs + EVEN_DMA_STRIDE);
-	iowrite32(img_width, ipd->regs + ODD_DMA_STRIDE);
-	mmiowb();
 	/* enable interrupts, clear all irq flags */
 	iowrite32(FLD_START_EN | FLD_END_ODD_EN | FLD_START |
 			FLD_END_EVEN | FLD_END_ODD, ipd->regs + INT_CSR);
 	spin_unlock(&ipd->lock);
 	return IRQ_HANDLED;
-
-stop_dma:
-	ipd->curr_buf = NULL;
-	/* stop the board */
-	write_i2c_reg_nowait(ipd->regs, CSR2, ipd->csr2);
-	iowrite32(FIFO_EN | SRST | FLD_CRPT_ODD | FLD_CRPT_EVEN |
-		  FLD_DN_ODD | FLD_DN_EVEN, ipd->regs + CSR1);
-	/* disable interrupts, clear all irq flags */
-	iowrite32(FLD_START | FLD_END_EVEN | FLD_END_ODD, ipd->regs + INT_CSR);
-	spin_unlock(&ipd->lock);
-	return IRQ_HANDLED;
 }
 
 static const struct v4l2_file_operations dt3155_fops = {
diff --git a/drivers/staging/media/dt3155v4l/dt3155v4l.h b/drivers/staging/media/dt3155v4l/dt3155v4l.h
index 11a8146..acecf83 100644
--- a/drivers/staging/media/dt3155v4l/dt3155v4l.h
+++ b/drivers/staging/media/dt3155v4l/dt3155v4l.h
@@ -171,7 +171,7 @@
  * @mux:		mutex to protect the instance
  * @dmaq		queue for dma buffers
  * @lock		spinlock for dma queue
- * @field_count		fields counter
+ * @sequence		frame counter
  * @stats:		statistics structure
  * @regs:		local copy of mmio base register
  * @csr2:		local copy of csr2 register
@@ -187,7 +187,7 @@ struct dt3155_priv {
 	struct mutex mux;
 	struct list_head dmaq;
 	spinlock_t lock;
-	unsigned int field_count;
+	unsigned int sequence;
 	void __iomem *regs;
 	u8 csr2, config;
 };
-- 
2.1.4

