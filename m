Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:51487 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752854AbaGKJg4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Jul 2014 05:36:56 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Kamil Debski <k.debski@samsung.com>,
	Fabio Estevam <fabio.estevam@freescale.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	kernel@pengutronix.de, Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH v3 09/32] [media] coda: add workqueue to serialize hardware commands
Date: Fri, 11 Jul 2014 11:36:20 +0200
Message-Id: <1405071403-1859-10-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1405071403-1859-1-git-send-email-p.zabel@pengutronix.de>
References: <1405071403-1859-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Using the coda_mutex lock to serialize hardware access would cause
"INFO: possible circular locking dependency detected" lockdep warnings.
Since the possible locking paths are hard to follow, serialize hardware
access with a single workqueue thread. Ultimately the workqueue could
be converted to only do register setup and readout for per-command work
items.
Using the initialized context property, SEQ_END is only queued in
coda_release when needed.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/platform/coda.c | 162 +++++++++++++++++++-----------------------
 1 file changed, 74 insertions(+), 88 deletions(-)

diff --git a/drivers/media/platform/coda.c b/drivers/media/platform/coda.c
index 204abb7..6e327e1 100644
--- a/drivers/media/platform/coda.c
+++ b/drivers/media/platform/coda.c
@@ -147,11 +147,11 @@ struct coda_dev {
 	spinlock_t		irqlock;
 	struct mutex		dev_mutex;
 	struct mutex		coda_mutex;
+	struct workqueue_struct	*workqueue;
 	struct v4l2_m2m_dev	*m2m_dev;
 	struct vb2_alloc_ctx	*alloc_ctx;
 	struct list_head	instances;
 	unsigned long		instance_mask;
-	struct delayed_work	timeout;
 };
 
 struct coda_params {
@@ -198,7 +198,9 @@ struct coda_ctx {
 	struct coda_dev			*dev;
 	struct mutex			buffer_mutex;
 	struct list_head		list;
-	struct work_struct		skip_run;
+	struct work_struct		pic_run_work;
+	struct work_struct		seq_end_work;
+	struct completion		completion;
 	int				aborting;
 	int				initialized;
 	int				streamon_out;
@@ -1009,13 +1011,6 @@ static const struct v4l2_ioctl_ops coda_ioctl_ops = {
 
 static int coda_start_decoding(struct coda_ctx *ctx);
 
-static void coda_skip_run(struct work_struct *work)
-{
-	struct coda_ctx *ctx = container_of(work, struct coda_ctx, skip_run);
-
-	v4l2_m2m_job_finish(ctx->dev->m2m_dev, ctx->m2m_ctx);
-}
-
 static inline int coda_get_bitstream_payload(struct coda_ctx *ctx)
 {
 	return kfifo_len(&ctx->bitstream_fifo);
@@ -1170,7 +1165,7 @@ static int coda_prepare_decode(struct coda_ctx *ctx)
 		v4l2_dbg(1, coda_debug, &dev->v4l2_dev,
 			 "bitstream payload: %d, skipping\n",
 			 coda_get_bitstream_payload(ctx));
-		schedule_work(&ctx->skip_run);
+		v4l2_m2m_job_finish(ctx->dev->m2m_dev, ctx->m2m_ctx);
 		return -EAGAIN;
 	}
 
@@ -1179,7 +1174,7 @@ static int coda_prepare_decode(struct coda_ctx *ctx)
 		int ret = coda_start_decoding(ctx);
 		if (ret < 0) {
 			v4l2_err(&dev->v4l2_dev, "failed to start decoding\n");
-			schedule_work(&ctx->skip_run);
+			v4l2_m2m_job_finish(ctx->dev->m2m_dev, ctx->m2m_ctx);
 			return -EAGAIN;
 		} else {
 			ctx->initialized = 1;
@@ -1387,24 +1382,48 @@ static void coda_device_run(void *m2m_priv)
 {
 	struct coda_ctx *ctx = m2m_priv;
 	struct coda_dev *dev = ctx->dev;
-	int ret;
+
+	queue_work(dev->workqueue, &ctx->pic_run_work);
+}
+
+static void coda_free_framebuffers(struct coda_ctx *ctx);
+static void coda_free_context_buffers(struct coda_ctx *ctx);
+
+static void coda_seq_end_work(struct work_struct *work)
+{
+	struct coda_ctx *ctx = container_of(work, struct coda_ctx, seq_end_work);
+	struct coda_dev *dev = ctx->dev;
 
 	mutex_lock(&ctx->buffer_mutex);
+	mutex_lock(&dev->coda_mutex);
 
-	/*
-	 * If streamoff dequeued all buffers before we could get the lock,
-	 * just bail out immediately.
-	 */
-	if ((!v4l2_m2m_num_src_bufs_ready(ctx->m2m_ctx) &&
-	    ctx->inst_type != CODA_INST_DECODER) ||
-		!v4l2_m2m_num_dst_bufs_ready(ctx->m2m_ctx)) {
-		v4l2_dbg(1, coda_debug, &dev->v4l2_dev,
-			"%d: device_run without buffers\n", ctx->idx);
-		mutex_unlock(&ctx->buffer_mutex);
-		schedule_work(&ctx->skip_run);
-		return;
+	v4l2_dbg(1, coda_debug, &dev->v4l2_dev,
+		 "%d: %s: sent command 'SEQ_END' to coda\n", ctx->idx, __func__);
+	if (coda_command_sync(ctx, CODA_COMMAND_SEQ_END)) {
+		v4l2_err(&dev->v4l2_dev,
+			 "CODA_COMMAND_SEQ_END failed\n");
 	}
 
+	kfifo_init(&ctx->bitstream_fifo,
+		ctx->bitstream.vaddr, ctx->bitstream.size);
+
+	coda_free_framebuffers(ctx);
+	coda_free_context_buffers(ctx);
+
+	mutex_unlock(&dev->coda_mutex);
+	mutex_unlock(&ctx->buffer_mutex);
+}
+
+static void coda_finish_decode(struct coda_ctx *ctx);
+static void coda_finish_encode(struct coda_ctx *ctx);
+
+static void coda_pic_run_work(struct work_struct *work)
+{
+	struct coda_ctx *ctx = container_of(work, struct coda_ctx, pic_run_work);
+	struct coda_dev *dev = ctx->dev;
+	int ret;
+
+	mutex_lock(&ctx->buffer_mutex);
 	mutex_lock(&dev->coda_mutex);
 
 	if (ctx->inst_type == CODA_INST_DECODER) {
@@ -1423,12 +1442,26 @@ static void coda_device_run(void *m2m_priv)
 		coda_write(dev, ctx->iram_info.axi_sram_use,
 				CODA7_REG_BIT_AXI_SRAM_USE);
 
-	/* 1 second timeout in case CODA locks up */
-	schedule_delayed_work(&dev->timeout, HZ);
-
 	if (ctx->inst_type == CODA_INST_DECODER)
 		coda_kfifo_sync_to_device_full(ctx);
 	coda_command_async(ctx, CODA_COMMAND_PIC_RUN);
+
+	if (!wait_for_completion_timeout(&ctx->completion, msecs_to_jiffies(1000))) {
+		dev_err(&dev->plat_dev->dev, "CODA PIC_RUN timeout\n");
+	} else if (!ctx->aborting) {
+		if (ctx->inst_type == CODA_INST_DECODER)
+			coda_finish_decode(ctx);
+		else
+			coda_finish_encode(ctx);
+	}
+
+	if (ctx->aborting || (!ctx->streamon_cap && !ctx->streamon_out))
+		queue_work(dev->workqueue, &ctx->seq_end_work);
+
+	mutex_unlock(&dev->coda_mutex);
+	mutex_unlock(&ctx->buffer_mutex);
+
+	v4l2_m2m_job_finish(ctx->dev->m2m_dev, ctx->m2m_ctx);
 }
 
 static int coda_job_ready(void *m2m_priv)
@@ -2788,7 +2821,9 @@ static int coda_open(struct file *file)
 	}
 	set_bit(idx, &dev->instance_mask);
 
-	INIT_WORK(&ctx->skip_run, coda_skip_run);
+	init_completion(&ctx->completion);
+	INIT_WORK(&ctx->pic_run_work, coda_pic_run_work);
+	INIT_WORK(&ctx->seq_end_work, coda_seq_end_work);
 	v4l2_fh_init(&ctx->fh, video_devdata(file));
 	file->private_data = &ctx->fh;
 	v4l2_fh_add(&ctx->fh);
@@ -2891,16 +2926,10 @@ static int coda_release(struct file *file)
 	v4l2_m2m_ctx_release(ctx->m2m_ctx);
 
 	/* In case the instance was not running, we still need to call SEQ_END */
-	mutex_lock(&dev->coda_mutex);
-	v4l2_dbg(1, coda_debug, &dev->v4l2_dev,
-		 "%s: sent command 'SEQ_END' to coda\n", __func__);
-	if (coda_command_sync(ctx, CODA_COMMAND_SEQ_END)) {
-		v4l2_err(&dev->v4l2_dev,
-			 "CODA_COMMAND_SEQ_END failed\n");
-		mutex_unlock(&dev->coda_mutex);
-		return -ETIMEDOUT;
+	if (ctx->initialized) {
+		queue_work(dev->workqueue, &ctx->seq_end_work);
+		flush_work(&ctx->seq_end_work);
 	}
-	mutex_unlock(&dev->coda_mutex);
 
 	coda_free_framebuffers(ctx);
 
@@ -3198,8 +3227,6 @@ static irqreturn_t coda_irq_handler(int irq, void *data)
 	struct coda_dev *dev = data;
 	struct coda_ctx *ctx;
 
-	cancel_delayed_work(&dev->timeout);
-
 	/* read status register to attend the IRQ */
 	coda_read(dev, CODA_REG_BIT_INT_STATUS);
 	coda_write(dev, CODA_REG_BIT_INT_CLEAR_SET,
@@ -3215,7 +3242,6 @@ static irqreturn_t coda_irq_handler(int irq, void *data)
 	if (ctx->aborting) {
 		v4l2_dbg(1, coda_debug, &ctx->dev->v4l2_dev,
 			 "task has been aborted\n");
-		goto out;
 	}
 
 	if (coda_isbusy(ctx->dev)) {
@@ -3224,57 +3250,11 @@ static irqreturn_t coda_irq_handler(int irq, void *data)
 		return IRQ_NONE;
 	}
 
-	if (ctx->inst_type == CODA_INST_DECODER)
-		coda_finish_decode(ctx);
-	else
-		coda_finish_encode(ctx);
-
-out:
-	if (ctx->aborting || (!ctx->streamon_cap && !ctx->streamon_out)) {
-		v4l2_dbg(1, coda_debug, &dev->v4l2_dev,
-			 "%s: sent command 'SEQ_END' to coda\n", __func__);
-		if (coda_command_sync(ctx, CODA_COMMAND_SEQ_END)) {
-			v4l2_err(&dev->v4l2_dev,
-				 "CODA_COMMAND_SEQ_END failed\n");
-		}
-
-		kfifo_init(&ctx->bitstream_fifo,
-			ctx->bitstream.vaddr, ctx->bitstream.size);
-
-		coda_free_framebuffers(ctx);
-		coda_free_context_buffers(ctx);
-	}
-
-	mutex_unlock(&dev->coda_mutex);
-	mutex_unlock(&ctx->buffer_mutex);
-
-	v4l2_m2m_job_finish(ctx->dev->m2m_dev, ctx->m2m_ctx);
+	complete(&ctx->completion);
 
 	return IRQ_HANDLED;
 }
 
-static void coda_timeout(struct work_struct *work)
-{
-	struct coda_ctx *ctx;
-	struct coda_dev *dev = container_of(to_delayed_work(work),
-					    struct coda_dev, timeout);
-
-	dev_err(&dev->plat_dev->dev, "CODA PIC_RUN timeout, stopping all streams\n");
-
-	mutex_lock(&dev->dev_mutex);
-	list_for_each_entry(ctx, &dev->instances, list) {
-		if (mutex_is_locked(&ctx->buffer_mutex))
-			mutex_unlock(&ctx->buffer_mutex);
-		v4l2_m2m_streamoff(NULL, ctx->m2m_ctx, V4L2_BUF_TYPE_VIDEO_OUTPUT);
-		v4l2_m2m_streamoff(NULL, ctx->m2m_ctx, V4L2_BUF_TYPE_VIDEO_CAPTURE);
-	}
-	mutex_unlock(&dev->dev_mutex);
-
-	mutex_unlock(&dev->coda_mutex);
-	ctx = v4l2_m2m_get_curr_priv(dev->m2m_dev);
-	v4l2_m2m_job_finish(ctx->dev->m2m_dev, ctx->m2m_ctx);
-}
-
 static u32 coda_supported_firmwares[] = {
 	CODA_FIRMWARE_VERNUM(CODA_DX6, 2, 2, 5),
 	CODA_FIRMWARE_VERNUM(CODA_7541, 1, 4, 50),
@@ -3578,7 +3558,6 @@ static int coda_probe(struct platform_device *pdev)
 
 	spin_lock_init(&dev->irqlock);
 	INIT_LIST_HEAD(&dev->instances);
-	INIT_DELAYED_WORK(&dev->timeout, coda_timeout);
 
 	dev->plat_dev = pdev;
 	dev->clk_per = devm_clk_get(&pdev->dev, "per");
@@ -3685,6 +3664,12 @@ static int coda_probe(struct platform_device *pdev)
 		return -ENOMEM;
 	}
 
+	dev->workqueue = alloc_workqueue("coda", WQ_UNBOUND | WQ_MEM_RECLAIM, 1);
+	if (!dev->workqueue) {
+		dev_err(&pdev->dev, "unable to alloc workqueue\n");
+		return -ENOMEM;
+	}
+
 	platform_set_drvdata(pdev, dev);
 
 	return coda_firmware_request(dev);
@@ -3700,6 +3685,7 @@ static int coda_remove(struct platform_device *pdev)
 	if (dev->alloc_ctx)
 		vb2_dma_contig_cleanup_ctx(dev->alloc_ctx);
 	v4l2_device_unregister(&dev->v4l2_dev);
+	destroy_workqueue(dev->workqueue);
 	if (dev->iram.vaddr)
 		gen_pool_free(dev->iram_pool, (unsigned long)dev->iram.vaddr,
 			      dev->iram.size);
-- 
2.0.0

