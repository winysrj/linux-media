Return-path: <mchehab@pedra>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:41974 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757746Ab1FJShG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 10 Jun 2011 14:37:06 -0400
Date: Fri, 10 Jun 2011 20:36:42 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH/RFC 01/19] s5p-fimc: Add support for runtime PM in the
 mem-to-mem driver
In-reply-to: <1307731020-7100-1-git-send-email-s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: hans.verkuil@cisco.com, laurent.pinchart@ideasonboard.com,
	m.szyprowski@samsung.com, kyungmin.park@samsung.com,
	s.nawrocki@samsung.com, sw0312.kim@samsung.com,
	riverful.kim@samsung.com
Message-id: <1307731020-7100-2-git-send-email-s.nawrocki@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <1307731020-7100-1-git-send-email-s.nawrocki@samsung.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Only the FIMC entity memory-to-memory operation is fully covered,
for the camera capture suspend/resume only stubs are provided.
It's all what is needed to enable the driver on EXYNOS4 series with
power domain driver enabled. Camera capture pipeline suspend/resume
is covered by a separate patch.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/video/s5p-fimc/fimc-capture.c |   20 +++
 drivers/media/video/s5p-fimc/fimc-core.c    |  237 +++++++++++++++++++--------
 drivers/media/video/s5p-fimc/fimc-core.h    |   16 ++-
 drivers/media/video/s5p-fimc/fimc-reg.c     |    2 +-
 4 files changed, 197 insertions(+), 78 deletions(-)

diff --git a/drivers/media/video/s5p-fimc/fimc-capture.c b/drivers/media/video/s5p-fimc/fimc-capture.c
index 81b4a82..9432ea8 100644
--- a/drivers/media/video/s5p-fimc/fimc-capture.c
+++ b/drivers/media/video/s5p-fimc/fimc-capture.c
@@ -18,6 +18,7 @@
 #include <linux/interrupt.h>
 #include <linux/device.h>
 #include <linux/platform_device.h>
+#include <linux/pm_runtime.h>
 #include <linux/list.h>
 #include <linux/slab.h>
 #include <linux/clk.h>
@@ -197,6 +198,18 @@ static int fimc_stop_capture(struct fimc_dev *fimc)
 	return 0;
 }
 
+int fimc_capture_suspend(struct fimc_dev *fimc)
+{
+	/* TODO: */
+	return -EBUSY;
+}
+
+int fimc_capture_resume(struct fimc_dev *fimc)
+{
+	/* TODO: */
+	return 0;
+}
+
 static int start_streaming(struct vb2_queue *q)
 {
 	struct fimc_ctx *ctx = q->drv_priv;
@@ -382,9 +395,14 @@ static int fimc_capture_open(struct file *file)
 	if (fimc_m2m_active(fimc))
 		return -EBUSY;
 
+	ret = pm_runtime_get_sync(&fimc->pdev->dev);
+	if (ret)
+		return ret;
+
 	if (++fimc->vid_cap.refcnt == 1) {
 		ret = fimc_isp_subdev_init(fimc, 0);
 		if (ret) {
+			pm_runtime_put_sync(&fimc->pdev->dev);
 			fimc->vid_cap.refcnt--;
 			return -EIO;
 		}
@@ -412,6 +430,8 @@ static int fimc_capture_close(struct file *file)
 		fimc_subdev_unregister(fimc);
 	}
 
+	pm_runtime_put_sync(&fimc->pdev->dev);
+
 	return 0;
 }
 
diff --git a/drivers/media/video/s5p-fimc/fimc-core.c b/drivers/media/video/s5p-fimc/fimc-core.c
index bdf19ad..4540280 100644
--- a/drivers/media/video/s5p-fimc/fimc-core.c
+++ b/drivers/media/video/s5p-fimc/fimc-core.c
@@ -19,6 +19,7 @@
 #include <linux/interrupt.h>
 #include <linux/device.h>
 #include <linux/platform_device.h>
+#include <linux/pm_runtime.h>
 #include <linux/list.h>
 #include <linux/io.h>
 #include <linux/slab.h>
@@ -302,7 +303,6 @@ int fimc_set_scaler_info(struct fimc_ctx *ctx)
 static void fimc_m2m_job_finish(struct fimc_ctx *ctx, int vb_state)
 {
 	struct vb2_buffer *src_vb, *dst_vb;
-	struct fimc_dev *fimc = ctx->fimc_dev;
 
 	if (!ctx || !ctx->m2m_ctx)
 		return;
@@ -313,43 +313,41 @@ static void fimc_m2m_job_finish(struct fimc_ctx *ctx, int vb_state)
 	if (src_vb && dst_vb) {
 		v4l2_m2m_buf_done(src_vb, vb_state);
 		v4l2_m2m_buf_done(dst_vb, vb_state);
-		v4l2_m2m_job_finish(fimc->m2m.m2m_dev, ctx->m2m_ctx);
+		v4l2_m2m_job_finish(ctx->fimc_dev->m2m.m2m_dev,
+				    ctx->m2m_ctx);
 	}
 }
 
 /* Complete the transaction which has been scheduled for execution. */
-static void fimc_m2m_shutdown(struct fimc_ctx *ctx)
+static int fimc_m2m_shutdown(struct fimc_ctx *ctx)
 {
 	struct fimc_dev *fimc = ctx->fimc_dev;
 	int ret;
 
 	if (!fimc_m2m_pending(fimc))
-		return;
+		return 0;
 
 	fimc_ctx_state_lock_set(FIMC_CTX_SHUT, ctx);
 
 	ret = wait_event_timeout(fimc->irq_queue,
 			   !fimc_ctx_state_is_set(FIMC_CTX_SHUT, ctx),
 			   FIMC_SHUTDOWN_TIMEOUT);
-	/*
-	 * In case of a timeout the buffers are not released in the interrupt
-	 * handler so return them here with the error flag set, if there are
-	 * any on the queue.
-	 */
-	if (ret == 0)
-		fimc_m2m_job_finish(ctx, VB2_BUF_STATE_ERROR);
+
+	return ret == 0 ? -ETIMEDOUT : ret;
 }
 
 static int stop_streaming(struct vb2_queue *q)
 {
 	struct fimc_ctx *ctx = q->drv_priv;
+	int ret;
 
-	fimc_m2m_shutdown(ctx);
-
+	ret = fimc_m2m_shutdown(ctx);
+	if (ret == -ETIMEDOUT)
+		fimc_m2m_job_finish(ctx, VB2_BUF_STATE_ERROR);
 	return 0;
 }
 
-static void fimc_capture_irq_handler(struct fimc_dev *fimc)
+void fimc_capture_irq_handler(struct fimc_dev *fimc)
 {
 	struct fimc_vid_cap *cap = &fimc->vid_cap;
 	struct fimc_vid_buffer *v_buf;
@@ -404,7 +402,7 @@ static void fimc_capture_irq_handler(struct fimc_dev *fimc)
 	    fimc_hw_get_frame_index(fimc), cap->active_buf_cnt);
 }
 
-static irqreturn_t fimc_isr(int irq, void *priv)
+static irqreturn_t fimc_irq_handler(int irq, void *priv)
 {
 	struct fimc_dev *fimc = priv;
 	struct fimc_vid_cap *cap = &fimc->vid_cap;
@@ -412,10 +410,20 @@ static irqreturn_t fimc_isr(int irq, void *priv)
 
 	fimc_hw_clear_irq(fimc);
 
+	spin_lock(&fimc->slock);
+
 	if (test_and_clear_bit(ST_M2M_PEND, &fimc->state)) {
+		if (test_and_clear_bit(ST_M2M_SUSPENDING, &fimc->state)) {
+			set_bit(ST_M2M_SUSPENDED, &fimc->state);
+			wake_up(&fimc->irq_queue);
+			goto out;
+		}
 		ctx = v4l2_m2m_get_curr_priv(fimc->m2m.m2m_dev);
 		if (ctx != NULL) {
+			spin_unlock(&fimc->slock);
 			fimc_m2m_job_finish(ctx, VB2_BUF_STATE_DONE);
+			pm_runtime_mark_last_busy(&fimc->pdev->dev);
+			pm_runtime_put_autosuspend(&fimc->pdev->dev);
 
 			spin_lock(&ctx->slock);
 			if (ctx->state & FIMC_CTX_SHUT) {
@@ -424,21 +432,18 @@ static irqreturn_t fimc_isr(int irq, void *priv)
 			}
 			spin_unlock(&ctx->slock);
 		}
-
 		return IRQ_HANDLED;
-	}
-
-	spin_lock(&fimc->slock);
-
-	if (test_bit(ST_CAPT_PEND, &fimc->state)) {
-		fimc_capture_irq_handler(fimc);
+	} else {
+		if (test_bit(ST_CAPT_PEND, &fimc->state)) {
+			fimc_capture_irq_handler(fimc);
 
-		if (cap->active_buf_cnt == 1) {
-			fimc_deactivate_capture(fimc);
-			clear_bit(ST_CAPT_STREAM, &fimc->state);
+			if (cap->active_buf_cnt == 1) {
+				fimc_deactivate_capture(fimc);
+				clear_bit(ST_CAPT_STREAM, &fimc->state);
+			}
 		}
 	}
-
+out:
 	spin_unlock(&fimc->slock);
 	return IRQ_HANDLED;
 }
@@ -636,10 +641,15 @@ static void fimc_dma_run(void *priv)
 		return;
 
 	fimc = ctx->fimc_dev;
-
-	spin_lock_irqsave(&ctx->slock, flags);
+	ret = pm_runtime_get_sync(&fimc->pdev->dev);
+	if (ret < 0) {
+		fimc_m2m_job_finish(fimc->m2m.ctx, VB2_BUF_STATE_ERROR);
+		return;
+	}
+	spin_lock_irqsave(&fimc->slock, flags);
 	set_bit(ST_M2M_PEND, &fimc->state);
 
+	spin_lock(&ctx->slock);
 	ctx->state |= (FIMC_SRC_ADDR | FIMC_DST_ADDR);
 	ret = fimc_prepare_config(ctx, ctx->state);
 	if (ret)
@@ -650,8 +660,6 @@ static void fimc_dma_run(void *priv)
 		ctx->state |= FIMC_PARAMS;
 		fimc->m2m.ctx = ctx;
 	}
-
-	spin_lock(&fimc->slock);
 	fimc_hw_set_input_addr(fimc, &ctx->s_frame.paddr);
 
 	if (ctx->state & FIMC_PARAMS) {
@@ -681,10 +689,9 @@ static void fimc_dma_run(void *priv)
 	ctx->state &= (FIMC_CTX_M2M | FIMC_CTX_CAP |
 		       FIMC_SRC_FMT | FIMC_DST_FMT);
 	fimc_hw_activate_input_dma(fimc, true);
-	spin_unlock(&fimc->slock);
-
 dma_unlock:
-	spin_unlock_irqrestore(&ctx->slock, flags);
+	spin_unlock(&ctx->slock);
+	spin_unlock_irqrestore(&fimc->slock, flags);
 }
 
 static void fimc_job_abort(void *priv)
@@ -875,7 +882,6 @@ int fimc_vidioc_try_fmt_mplane(struct file *file, void *priv,
 	u32 max_width, mod_x, mod_y, mask;
 	int i, is_output = 0;
 
-
 	if (f->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) {
 		if (fimc_ctx_state_is_set(FIMC_CTX_CAP, ctx))
 			return -EINVAL;
@@ -1410,9 +1416,6 @@ static int fimc_m2m_open(struct file *file)
 	if (fimc->vid_cap.refcnt > 0)
 		return -EBUSY;
 
-	fimc->m2m.refcnt++;
-	set_bit(ST_OUTDMA_RUN, &fimc->state);
-
 	ctx = kzalloc(sizeof *ctx, GFP_KERNEL);
 	if (!ctx)
 		return -ENOMEM;
@@ -1436,6 +1439,9 @@ static int fimc_m2m_open(struct file *file)
 		return err;
 	}
 
+	if (fimc->m2m.refcnt++ == 0)
+		set_bit(ST_M2M_RUN, &fimc->state);
+
 	return 0;
 }
 
@@ -1448,10 +1454,10 @@ static int fimc_m2m_release(struct file *file)
 		task_pid_nr(current), fimc->state, fimc->m2m.refcnt);
 
 	v4l2_m2m_ctx_release(ctx->m2m_ctx);
-	kfree(ctx);
-	if (--fimc->m2m.refcnt <= 0)
-		clear_bit(ST_OUTDMA_RUN, &fimc->state);
 
+	if (--fimc->m2m.refcnt <= 0)
+		clear_bit(ST_M2M_RUN, &fimc->state);
+	kfree(ctx);
 	return 0;
 }
 
@@ -1553,7 +1559,7 @@ err_m2m_r1:
 	return ret;
 }
 
-static void fimc_unregister_m2m_device(struct fimc_dev *fimc)
+void fimc_unregister_m2m_device(struct fimc_dev *fimc)
 {
 	if (fimc) {
 		v4l2_m2m_release(fimc->m2m.m2m_dev);
@@ -1563,14 +1569,12 @@ static void fimc_unregister_m2m_device(struct fimc_dev *fimc)
 	}
 }
 
-static void fimc_clk_release(struct fimc_dev *fimc)
+static void fimc_clk_put(struct fimc_dev *fimc)
 {
 	int i;
 	for (i = 0; i < fimc->num_clocks; i++) {
-		if (fimc->clock[i]) {
-			clk_disable(fimc->clock[i]);
+		if (fimc->clock[i])
 			clk_put(fimc->clock[i]);
-		}
 	}
 }
 
@@ -1579,15 +1583,13 @@ static int fimc_clk_get(struct fimc_dev *fimc)
 	int i;
 	for (i = 0; i < fimc->num_clocks; i++) {
 		fimc->clock[i] = clk_get(&fimc->pdev->dev, fimc_clocks[i]);
-
-		if (!IS_ERR_OR_NULL(fimc->clock[i])) {
-			clk_enable(fimc->clock[i]);
+		if (!IS_ERR_OR_NULL(fimc->clock[i]))
 			continue;
-		}
 		dev_err(&fimc->pdev->dev, "failed to get fimc clock: %s\n",
 			fimc_clocks[i]);
 		return -ENXIO;
 	}
+
 	return 0;
 }
 
@@ -1616,11 +1618,13 @@ static int fimc_probe(struct platform_device *pdev)
 		return -ENOMEM;
 
 	fimc->id = pdev->id;
+
 	fimc->variant = drv_data->variant[fimc->id];
 	fimc->pdev = pdev;
 	pdata = pdev->dev.platform_data;
 	fimc->pdata = pdata;
-	fimc->state = ST_IDLE;
+
+	set_bit(ST_LPM, &fimc->state);
 
 	init_waitqueue_head(&fimc->irq_queue);
 	spin_lock_init(&fimc->slock);
@@ -1657,27 +1661,33 @@ static int fimc_probe(struct platform_device *pdev)
 		fimc->num_clocks++;
 	}
 
-	ret = fimc_clk_get(fimc);
-	if (ret)
-		goto err_regs_unmap;
-	clk_set_rate(fimc->clock[CLK_BUS], drv_data->lclk_frequency);
-
 	res = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
 	if (!res) {
 		dev_err(&pdev->dev, "failed to get IRQ resource\n");
 		ret = -ENXIO;
-		goto err_clk;
+		goto err_regs_unmap;
 	}
 	fimc->irq = res->start;
 
-	fimc_hw_reset(fimc);
+	ret = fimc_clk_get(fimc);
+	if (ret)
+		goto err_regs_unmap;
+	clk_set_rate(fimc->clock[CLK_BUS], drv_data->lclk_frequency);
+	clk_enable(fimc->clock[CLK_BUS]);
 
-	ret = request_irq(fimc->irq, fimc_isr, 0, pdev->name, fimc);
+	platform_set_drvdata(pdev, fimc);
+
+	ret = request_irq(fimc->irq, fimc_irq_handler, 0, pdev->name, fimc);
 	if (ret) {
 		dev_err(&pdev->dev, "failed to install irq (%d)\n", ret);
 		goto err_clk;
 	}
 
+	pm_runtime_use_autosuspend(&pdev->dev);
+	pm_runtime_set_autosuspend_delay(&pdev->dev, 100);
+	pm_runtime_enable(&pdev->dev);
+	pm_runtime_get_sync(&fimc->pdev->dev);
+
 	/* Initialize contiguous memory allocator */
 	fimc->alloc_ctx = vb2_dma_contig_init_ctx(&fimc->pdev->dev);
 	if (IS_ERR(fimc->alloc_ctx)) {
@@ -1694,18 +1704,12 @@ static int fimc_probe(struct platform_device *pdev)
 		ret = fimc_register_capture_device(fimc);
 		if (ret)
 			goto err_m2m;
-		clk_disable(fimc->clock[CLK_CAM]);
 	}
-	/*
-	 * Exclude the additional output DMA address registers by masking
-	 * them out on HW revisions that provide extended capabilites.
-	 */
-	if (fimc->variant->out_buf_count > 4)
-		fimc_hw_set_dma_seq(fimc, 0xF);
 
 	dev_dbg(&pdev->dev, "%s(): fimc-%d registered successfully\n",
 		__func__, fimc->id);
 
+	pm_runtime_put_sync(&fimc->pdev->dev);
 	return 0;
 
 err_m2m:
@@ -1713,7 +1717,7 @@ err_m2m:
 err_irq:
 	free_irq(fimc->irq, fimc);
 err_clk:
-	fimc_clk_release(fimc);
+	fimc_clk_put(fimc);
 err_regs_unmap:
 	iounmap(fimc->regs);
 err_req_region:
@@ -1725,21 +1729,85 @@ err_info:
 	return ret;
 }
 
-static int __devexit fimc_remove(struct platform_device *pdev)
+static int fimc_resume(struct device *dev)
 {
-	struct fimc_dev *fimc =
-		(struct fimc_dev *)platform_get_drvdata(pdev);
+	struct platform_device *pdev = to_platform_device(dev);
+	struct fimc_dev *fimc =	platform_get_drvdata(pdev);
+	unsigned long flags;
+
+	dbg("fimc%d: state: 0x%lx", fimc->id, fimc->state);
+
+	if (!test_and_clear_bit(ST_LPM, &fimc->state))
+		return 0;
+	clk_enable(fimc->clock[CLK_GATE]);
 
-	free_irq(fimc->irq, fimc);
 	fimc_hw_reset(fimc);
+	if (fimc->variant->out_buf_count > 4)
+		fimc_hw_set_dma_seq(fimc, 0xF);
+
+	if (fimc_capture_in_use(fimc)) {
+		fimc_capture_resume(fimc);
+		return 0;
+	}
+
+	if (!fimc_m2m_active(fimc))
+		return 0;
+
+	/* Need to fully setup hardware in first run. */
+	spin_lock_irqsave(&fimc->slock, flags);
+	fimc->m2m.ctx = NULL;
+	spin_unlock_irqrestore(&fimc->slock, flags);
+
+	if (test_and_clear_bit(ST_M2M_SUSPENDED, &fimc->state))
+		fimc_m2m_job_finish(fimc->m2m.ctx,
+				    VB2_BUF_STATE_ERROR);
+	return 0;
+}
+
+static int fimc_suspend(struct device *dev)
+{
+	struct platform_device *pdev = to_platform_device(dev);
+	struct fimc_dev *fimc =	platform_get_drvdata(pdev);
+
+	if (test_and_set_bit(ST_LPM, &fimc->state))
+		return 0;
+
+	if (fimc_m2m_pending(fimc)) {
+		clear_bit(ST_M2M_SUSPENDED, &fimc->state);
+		set_bit(ST_M2M_SUSPENDING, &fimc->state);
+		wait_event_timeout(fimc->irq_queue,
+				   test_bit(ST_M2M_SUSPENDED, &fimc->state),
+				   FIMC_SHUTDOWN_TIMEOUT);
+		clear_bit(ST_M2M_SUSPENDING, &fimc->state);
+	}
+
+	if (fimc_capture_in_use(fimc)) {
+		int ret = fimc_capture_suspend(fimc);
+		if (ret)
+			return ret;
+	}
+	clk_disable(fimc->clock[CLK_GATE]);
+
+	dbg("fimc%d: state: 0x%lx", fimc->id, fimc->state);
+	return 0;
+}
+
+static int __devexit fimc_remove(struct platform_device *pdev)
+{
+	struct fimc_dev *fimc = platform_get_drvdata(pdev);
+
+	pm_runtime_disable(&pdev->dev);
+	fimc_suspend(&pdev->dev);
+	pm_runtime_set_suspended(&pdev->dev);
 
 	fimc_unregister_m2m_device(fimc);
 	fimc_unregister_capture_device(fimc);
 
-	fimc_clk_release(fimc);
-
 	vb2_dma_contig_cleanup_ctx(fimc->alloc_ctx);
 
+	clk_disable(fimc->clock[CLK_BUS]);
+	fimc_clk_put(fimc);
+	free_irq(fimc->irq, fimc);
 	iounmap(fimc->regs);
 	release_resource(fimc->regs_res);
 	kfree(fimc->regs_res);
@@ -1908,6 +1976,30 @@ static struct platform_device_id fimc_driver_ids[] = {
 };
 MODULE_DEVICE_TABLE(platform, fimc_driver_ids);
 
+#ifdef CONFIG_PM_SLEEP
+static int fimc_pm_suspend(struct device *dev)
+{
+	return fimc_suspend(dev);
+}
+
+static int fimc_pm_resume(struct device *dev)
+{
+	int ret = fimc_resume(dev);
+
+	if (!ret) {
+		pm_runtime_disable(dev);
+		ret = pm_runtime_set_active(dev);
+		pm_runtime_enable(dev);
+	}
+	return ret;
+}
+#endif
+
+static const struct dev_pm_ops fimc_pm_ops = {
+	SET_SYSTEM_SLEEP_PM_OPS(fimc_pm_suspend, fimc_pm_resume)
+	SET_RUNTIME_PM_OPS(fimc_suspend, fimc_resume, NULL)
+};
+
 static struct platform_driver fimc_driver = {
 	.probe		= fimc_probe,
 	.remove	= __devexit_p(fimc_remove),
@@ -1915,6 +2007,7 @@ static struct platform_driver fimc_driver = {
 	.driver = {
 		.name	= MODULE_NAME,
 		.owner	= THIS_MODULE,
+		.pm     = &fimc_pm_ops,
 	}
 };
 
diff --git a/drivers/media/video/s5p-fimc/fimc-core.h b/drivers/media/video/s5p-fimc/fimc-core.h
index 1f70772..21dfcac 100644
--- a/drivers/media/video/s5p-fimc/fimc-core.h
+++ b/drivers/media/video/s5p-fimc/fimc-core.h
@@ -48,22 +48,26 @@ enum {
 };
 
 enum fimc_dev_flags {
-	/* for m2m node */
-	ST_IDLE,
-	ST_OUTDMA_RUN,
+	ST_LPM,
+	/* m2m node */
+	ST_M2M_RUN,
 	ST_M2M_PEND,
-	/* for capture node */
+	ST_M2M_SUSPENDING,
+	ST_M2M_SUSPENDED,
+	/* capture node */
 	ST_CAPT_PEND,
 	ST_CAPT_RUN,
 	ST_CAPT_STREAM,
 	ST_CAPT_SHUT,
+	ST_CAPT_INUSE,
 };
 
-#define fimc_m2m_active(dev) test_bit(ST_OUTDMA_RUN, &(dev)->state)
+#define fimc_m2m_active(dev) test_bit(ST_M2M_RUN, &(dev)->state)
 #define fimc_m2m_pending(dev) test_bit(ST_M2M_PEND, &(dev)->state)
 
 #define fimc_capture_running(dev) test_bit(ST_CAPT_RUN, &(dev)->state)
 #define fimc_capture_pending(dev) test_bit(ST_CAPT_PEND, &(dev)->state)
+#define fimc_capture_in_use(dev) test_bit(ST_CAPT_INUSE, &(dev)->state)
 
 enum fimc_datapath {
 	FIMC_CAMERA,
@@ -644,6 +648,8 @@ void fimc_unregister_capture_device(struct fimc_dev *fimc);
 int fimc_sensor_sd_init(struct fimc_dev *fimc, int index);
 int fimc_vid_cap_buf_queue(struct fimc_dev *fimc,
 			     struct fimc_vid_buffer *fimc_vb);
+int fimc_capture_suspend(struct fimc_dev *fimc);
+int fimc_capture_resume(struct fimc_dev *fimc);
 
 /* Locking: the caller holds fimc->slock */
 static inline void fimc_activate_capture(struct fimc_ctx *ctx)
diff --git a/drivers/media/video/s5p-fimc/fimc-reg.c b/drivers/media/video/s5p-fimc/fimc-reg.c
index 4893b2d..938dadf 100644
--- a/drivers/media/video/s5p-fimc/fimc-reg.c
+++ b/drivers/media/video/s5p-fimc/fimc-reg.c
@@ -30,7 +30,7 @@ void fimc_hw_reset(struct fimc_dev *dev)
 	cfg = readl(dev->regs + S5P_CIGCTRL);
 	cfg |= (S5P_CIGCTRL_SWRST | S5P_CIGCTRL_IRQ_LEVEL);
 	writel(cfg, dev->regs + S5P_CIGCTRL);
-	udelay(1000);
+	udelay(10);
 
 	cfg = readl(dev->regs + S5P_CIGCTRL);
 	cfg &= ~S5P_CIGCTRL_SWRST;
-- 
1.7.5.4

