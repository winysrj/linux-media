Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:46114 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759441Ab3EWOnK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 23 May 2013 10:43:10 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Javier Martin <javier.martin@vista-silicon.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH 8/9] [media] coda: replace completion with mutex
Date: Thu, 23 May 2013 16:43:00 +0200
Message-Id: <1369320181-17933-9-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1369320181-17933-1-git-send-email-p.zabel@pengutronix.de>
References: <1369320181-17933-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Not only do we need to wait for job completion when we want to
call a command on the CODA in start/stop_streaming, we also need
to make sure that a new job doesn't start before the command
finished.
Use a mutex to lock the coda command handling. On timeout, the
device_run job must be marked as finished and the mutex released,
as otherwise coda_release will block.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/platform/coda.c | 66 +++++++++++++++++++++++--------------------
 1 file changed, 35 insertions(+), 31 deletions(-)

diff --git a/drivers/media/platform/coda.c b/drivers/media/platform/coda.c
index cd1ce70..f5d4144 100644
--- a/drivers/media/platform/coda.c
+++ b/drivers/media/platform/coda.c
@@ -137,12 +137,12 @@ struct coda_dev {
 
 	spinlock_t		irqlock;
 	struct mutex		dev_mutex;
+	struct mutex		coda_mutex;
 	struct v4l2_m2m_dev	*m2m_dev;
 	struct vb2_alloc_ctx	*alloc_ctx;
 	struct list_head	instances;
 	unsigned long		instance_mask;
 	struct delayed_work	timeout;
-	struct completion	done;
 };
 
 struct coda_params {
@@ -681,6 +681,8 @@ static void coda_device_run(void *m2m_priv)
 	u32 pic_stream_buffer_addr, pic_stream_buffer_size;
 	u32 dst_fourcc;
 
+	mutex_lock(&dev->coda_mutex);
+
 	src_buf = v4l2_m2m_next_src_buf(ctx->m2m_ctx);
 	dst_buf = v4l2_m2m_next_dst_buf(ctx->m2m_ctx);
 	q_data_src = get_q_data(ctx, V4L2_BUF_TYPE_VIDEO_OUTPUT);
@@ -801,7 +803,6 @@ static void coda_device_run(void *m2m_priv)
 	/* 1 second timeout in case CODA locks up */
 	schedule_delayed_work(&dev->timeout, HZ);
 
-	INIT_COMPLETION(dev->done);
 	coda_command_async(ctx, CODA_COMMAND_PIC_RUN);
 }
 
@@ -1081,10 +1082,6 @@ static int coda_start_streaming(struct vb2_queue *q, unsigned int count)
 			ctx->inst_type = CODA_INST_DECODER;
 	}
 
-	if (coda_isbusy(dev))
-		if (wait_for_completion_interruptible_timeout(&dev->done, HZ) <= 0)
-			return -EBUSY;
-
 	/* Don't start the coda unless both queues are on */
 	if (!(ctx->streamon_out & ctx->streamon_cap))
 		return 0;
@@ -1107,6 +1104,9 @@ static int coda_start_streaming(struct vb2_queue *q, unsigned int count)
 		v4l2_err(v4l2_dev, "coda is not initialized.\n");
 		return -EFAULT;
 	}
+
+	mutex_lock(&dev->coda_mutex);
+
 	coda_write(dev, ctx->parabuf.paddr, CODA_REG_BIT_PARA_BUF_ADDR);
 	coda_write(dev, bitstream_buf, CODA_REG_BIT_RD_PTR(ctx->idx));
 	coda_write(dev, bitstream_buf, CODA_REG_BIT_WR_PTR(ctx->idx));
@@ -1152,7 +1152,8 @@ static int coda_start_streaming(struct vb2_queue *q, unsigned int count)
 	default:
 		v4l2_err(v4l2_dev,
 			 "dst format (0x%08x) invalid.\n", dst_fourcc);
-		return -EINVAL;
+		ret = -EINVAL;
+		goto out;
 	}
 
 	switch (ctx->params.slice_mode) {
@@ -1215,17 +1216,23 @@ static int coda_start_streaming(struct vb2_queue *q, unsigned int count)
 		}
 	}
 
-	if (coda_command_sync(ctx, CODA_COMMAND_SEQ_INIT)) {
+	ret = coda_command_sync(ctx, CODA_COMMAND_SEQ_INIT);
+	if (ret < 0) {
 		v4l2_err(v4l2_dev, "CODA_COMMAND_SEQ_INIT timeout\n");
-		return -ETIMEDOUT;
+		goto out;
 	}
 
-	if (coda_read(dev, CODA_RET_ENC_SEQ_SUCCESS) == 0)
-		return -EFAULT;
+	if (coda_read(dev, CODA_RET_ENC_SEQ_SUCCESS) == 0) {
+		v4l2_err(v4l2_dev, "CODA_COMMAND_SEQ_INIT failed\n");
+		ret = -EFAULT;
+		goto out;
+	}
 
 	ret = coda_alloc_framebuffers(ctx, q_data_src, dst_fourcc);
-	if (ret < 0)
-		return ret;
+	if (ret < 0) {
+		v4l2_err(v4l2_dev, "failed to allocate framebuffers\n");
+		goto out;
+	}
 
 	coda_write(dev, ctx->num_internal_frames, CODA_CMD_SET_FRAME_BUF_NUM);
 	coda_write(dev, round_up(q_data_src->width, 8), CODA_CMD_SET_FRAME_BUF_STRIDE);
@@ -1237,9 +1244,10 @@ static int coda_start_streaming(struct vb2_queue *q, unsigned int count)
 		coda_write(dev, dev->iram_paddr + 68 * 1024, CODA7_CMD_SET_FRAME_AXI_IPACDC_ADDR);
 		coda_write(dev, 0x0, CODA7_CMD_SET_FRAME_AXI_OVL_ADDR);
 	}
-	if (coda_command_sync(ctx, CODA_COMMAND_SET_FRAME_BUF)) {
+	ret = coda_command_sync(ctx, CODA_COMMAND_SET_FRAME_BUF);
+	if (ret < 0) {
 		v4l2_err(v4l2_dev, "CODA_COMMAND_SET_FRAME_BUF timeout\n");
-		return -ETIMEDOUT;
+		goto out;
 	}
 
 	/* Save stream headers */
@@ -1305,6 +1313,7 @@ static int coda_start_streaming(struct vb2_queue *q, unsigned int count)
 	}
 
 out:
+	mutex_unlock(&dev->coda_mutex);
 	return ret;
 }
 
@@ -1327,15 +1336,9 @@ static int coda_stop_streaming(struct vb2_queue *q)
 	if (ctx->streamon_out || ctx->streamon_cap)
 		return 0;
 
-	if (coda_isbusy(dev)) {
-		if (wait_for_completion_interruptible_timeout(&dev->done, HZ) <= 0) {
-			v4l2_warn(&dev->v4l2_dev,
-				  "%s: timeout, sending SEQ_END anyway\n", __func__);
-		}
-	}
-
 	cancel_delayed_work(&dev->timeout);
 
+	mutex_lock(&dev->coda_mutex);
 	v4l2_dbg(1, coda_debug, &dev->v4l2_dev,
 		 "%s: sent command 'SEQ_END' to coda\n", __func__);
 	if (coda_command_sync(ctx, CODA_COMMAND_SEQ_END)) {
@@ -1343,6 +1346,7 @@ static int coda_stop_streaming(struct vb2_queue *q)
 			 "CODA_COMMAND_SEQ_END failed\n");
 		return -ETIMEDOUT;
 	}
+	mutex_unlock(&dev->coda_mutex);
 
 	coda_free_framebuffers(ctx);
 
@@ -1638,12 +1642,14 @@ static irqreturn_t coda_irq_handler(int irq, void *data)
 	ctx = v4l2_m2m_get_curr_priv(dev->m2m_dev);
 	if (ctx == NULL) {
 		v4l2_err(&dev->v4l2_dev, "Instance released before the end of transaction\n");
+		mutex_unlock(&dev->coda_mutex);
 		return IRQ_HANDLED;
 	}
 
 	if (ctx->aborting) {
 		v4l2_dbg(1, coda_debug, &ctx->dev->v4l2_dev,
 			 "task has been aborted\n");
+		mutex_unlock(&dev->coda_mutex);
 		return IRQ_HANDLED;
 	}
 
@@ -1653,8 +1659,6 @@ static irqreturn_t coda_irq_handler(int irq, void *data)
 		return IRQ_NONE;
 	}
 
-	complete(&dev->done);
-
 	src_buf = v4l2_m2m_src_buf_remove(ctx->m2m_ctx);
 	dst_buf = v4l2_m2m_dst_buf_remove(ctx->m2m_ctx);
 
@@ -1702,6 +1706,8 @@ static irqreturn_t coda_irq_handler(int irq, void *data)
 		(dst_buf->v4l2_buf.flags & V4L2_BUF_FLAG_KEYFRAME) ?
 		"KEYFRAME" : "PFRAME");
 
+	mutex_unlock(&dev->coda_mutex);
+
 	v4l2_m2m_job_finish(ctx->dev->m2m_dev, ctx->m2m_ctx);
 
 	return IRQ_HANDLED;
@@ -1713,11 +1719,6 @@ static void coda_timeout(struct work_struct *work)
 	struct coda_dev *dev = container_of(to_delayed_work(work),
 					    struct coda_dev, timeout);
 
-	if (completion_done(&dev->done))
-		return;
-
-	complete(&dev->done);
-
 	dev_err(&dev->plat_dev->dev, "CODA PIC_RUN timeout, stopping all streams\n");
 
 	mutex_lock(&dev->dev_mutex);
@@ -1726,6 +1727,10 @@ static void coda_timeout(struct work_struct *work)
 		v4l2_m2m_streamoff(NULL, ctx->m2m_ctx, V4L2_BUF_TYPE_VIDEO_CAPTURE);
 	}
 	mutex_unlock(&dev->dev_mutex);
+
+	mutex_unlock(&dev->coda_mutex);
+	ctx = v4l2_m2m_get_curr_priv(dev->m2m_dev);
+	v4l2_m2m_job_finish(ctx->dev->m2m_dev, ctx->m2m_ctx);
 }
 
 static u32 coda_supported_firmwares[] = {
@@ -2008,8 +2013,6 @@ static int coda_probe(struct platform_device *pdev)
 	spin_lock_init(&dev->irqlock);
 	INIT_LIST_HEAD(&dev->instances);
 	INIT_DELAYED_WORK(&dev->timeout, coda_timeout);
-	init_completion(&dev->done);
-	complete(&dev->done);
 
 	dev->plat_dev = pdev;
 	dev->clk_per = devm_clk_get(&pdev->dev, "per");
@@ -2063,6 +2066,7 @@ static int coda_probe(struct platform_device *pdev)
 		return ret;
 
 	mutex_init(&dev->dev_mutex);
+	mutex_init(&dev->coda_mutex);
 
 	pdev_id = of_id ? of_id->data : platform_get_device_id(pdev);
 
-- 
1.8.2.rc2

