Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:41426 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753775Ab1H3PAq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 30 Aug 2011 11:00:46 -0400
Received: from euspt1 (mailout1.w1.samsung.com [210.118.77.11])
 by mailout1.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0LQQ0072YXP88C@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 30 Aug 2011 16:00:44 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LQQ00IK2XP7XH@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 30 Aug 2011 16:00:44 +0100 (BST)
Date: Tue, 30 Aug 2011 17:00:39 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH v4] s5p-fimc: Add runtime PM support in the mem-to-mem driver
To: linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, kyungmin.park@samsung.com,
	sw0312.kim@samsung.com, riverful.kim@samsung.com,
	s.nawrocki@samsung.com
Message-id: <1314716439-23642-1-git-send-email-s.nawrocki@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add runtime PM and system sleep support in the memory-to-memory driver.
This is required to enable the device operation on Exynos4 SoCs. This patch
prevents system boot failure when the driver is compiled in, as it now
tries to access its I/O memory without first enabling the corresponding
power domain.

The camera capture device suspend/resume is not fully covered,
the capture device is just powered on/off during the video node
open/close. However this enables it's normal operation on Exynos4 SoCs.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---

I'm resending this patch after few minor changes since v3:
 - added the driver dependency on PM_RUNTIME
 - corrected the error path in probe() 
 - s/*_in_use/_busy
 - edited the commit message

---
 drivers/media/video/Kconfig                 |    2 +-
 drivers/media/video/s5p-fimc/fimc-capture.c |   18 ++
 drivers/media/video/s5p-fimc/fimc-core.c    |  279 ++++++++++++++++++++-------
 drivers/media/video/s5p-fimc/fimc-core.h    |   16 +-
 drivers/media/video/s5p-fimc/fimc-reg.c     |    2 +-
 5 files changed, 237 insertions(+), 80 deletions(-)

diff --git a/drivers/media/video/Kconfig b/drivers/media/video/Kconfig
index f574dc0..14326d7 100644
--- a/drivers/media/video/Kconfig
+++ b/drivers/media/video/Kconfig
@@ -950,7 +950,7 @@ config VIDEO_MX2
 
 config  VIDEO_SAMSUNG_S5P_FIMC
 	tristate "Samsung S5P and EXYNOS4 camera host interface driver"
-	depends on VIDEO_DEV && VIDEO_V4L2 && PLAT_S5P
+	depends on VIDEO_V4L2 && PLAT_S5P && PM_RUNTIME
 	select VIDEOBUF2_DMA_CONTIG
 	select V4L2_MEM2MEM_DEV
 	---help---
diff --git a/drivers/media/video/s5p-fimc/fimc-capture.c b/drivers/media/video/s5p-fimc/fimc-capture.c
index 0d730e5..ea74e4b 100644
--- a/drivers/media/video/s5p-fimc/fimc-capture.c
+++ b/drivers/media/video/s5p-fimc/fimc-capture.c
@@ -17,6 +17,7 @@
 #include <linux/interrupt.h>
 #include <linux/device.h>
 #include <linux/platform_device.h>
+#include <linux/pm_runtime.h>
 #include <linux/list.h>
 #include <linux/slab.h>
 #include <linux/clk.h>
@@ -196,6 +197,16 @@ static int fimc_stop_capture(struct fimc_dev *fimc)
 	return 0;
 }
 
+int fimc_capture_suspend(struct fimc_dev *fimc)
+{
+	return -EBUSY;
+}
+
+int fimc_capture_resume(struct fimc_dev *fimc)
+{
+	return 0;
+}
+
 static int start_streaming(struct vb2_queue *q)
 {
 	struct fimc_ctx *ctx = q->drv_priv;
@@ -381,9 +392,14 @@ static int fimc_capture_open(struct file *file)
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
@@ -411,6 +427,8 @@ static int fimc_capture_close(struct file *file)
 		fimc_subdev_unregister(fimc);
 	}
 
+	pm_runtime_put_sync(&fimc->pdev->dev);
+
 	return 0;
 }
 
diff --git a/drivers/media/video/s5p-fimc/fimc-core.c b/drivers/media/video/s5p-fimc/fimc-core.c
index aa55066..7ca8091 100644
--- a/drivers/media/video/s5p-fimc/fimc-core.c
+++ b/drivers/media/video/s5p-fimc/fimc-core.c
@@ -18,6 +18,7 @@
 #include <linux/interrupt.h>
 #include <linux/device.h>
 #include <linux/platform_device.h>
+#include <linux/pm_runtime.h>
 #include <linux/list.h>
 #include <linux/io.h>
 #include <linux/slab.h>
@@ -301,7 +302,6 @@ int fimc_set_scaler_info(struct fimc_ctx *ctx)
 static void fimc_m2m_job_finish(struct fimc_ctx *ctx, int vb_state)
 {
 	struct vb2_buffer *src_vb, *dst_vb;
-	struct fimc_dev *fimc = ctx->fimc_dev;
 
 	if (!ctx || !ctx->m2m_ctx)
 		return;
@@ -312,39 +312,48 @@ static void fimc_m2m_job_finish(struct fimc_ctx *ctx, int vb_state)
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
+}
+
+static int start_streaming(struct vb2_queue *q)
+{
+	struct fimc_ctx *ctx = q->drv_priv;
+	int ret;
+
+	ret = pm_runtime_get_sync(&ctx->fimc_dev->pdev->dev);
+	return ret > 0 ? 0 : ret;
 }
 
 static int stop_streaming(struct vb2_queue *q)
 {
 	struct fimc_ctx *ctx = q->drv_priv;
+	int ret;
 
-	fimc_m2m_shutdown(ctx);
+	ret = fimc_m2m_shutdown(ctx);
+	if (ret == -ETIMEDOUT)
+		fimc_m2m_job_finish(ctx, VB2_BUF_STATE_ERROR);
 
+	pm_runtime_put(&ctx->fimc_dev->pdev->dev);
 	return 0;
 }
 
@@ -403,7 +412,7 @@ static void fimc_capture_irq_handler(struct fimc_dev *fimc)
 	    fimc_hw_get_frame_index(fimc), cap->active_buf_cnt);
 }
 
-static irqreturn_t fimc_isr(int irq, void *priv)
+static irqreturn_t fimc_irq_handler(int irq, void *priv)
 {
 	struct fimc_dev *fimc = priv;
 	struct fimc_vid_cap *cap = &fimc->vid_cap;
@@ -411,9 +420,17 @@ static irqreturn_t fimc_isr(int irq, void *priv)
 
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
 
 			spin_lock(&ctx->slock);
@@ -423,21 +440,18 @@ static irqreturn_t fimc_isr(int irq, void *priv)
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
@@ -635,10 +649,10 @@ static void fimc_dma_run(void *priv)
 		return;
 
 	fimc = ctx->fimc_dev;
-
-	spin_lock_irqsave(&ctx->slock, flags);
+	spin_lock_irqsave(&fimc->slock, flags);
 	set_bit(ST_M2M_PEND, &fimc->state);
 
+	spin_lock(&ctx->slock);
 	ctx->state |= (FIMC_SRC_ADDR | FIMC_DST_ADDR);
 	ret = fimc_prepare_config(ctx, ctx->state);
 	if (ret)
@@ -649,8 +663,6 @@ static void fimc_dma_run(void *priv)
 		ctx->state |= FIMC_PARAMS;
 		fimc->m2m.ctx = ctx;
 	}
-
-	spin_lock(&fimc->slock);
 	fimc_hw_set_input_addr(fimc, &ctx->s_frame.paddr);
 
 	if (ctx->state & FIMC_PARAMS) {
@@ -680,10 +692,9 @@ static void fimc_dma_run(void *priv)
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
@@ -762,6 +773,7 @@ static struct vb2_ops fimc_qops = {
 	.wait_prepare	 = fimc_unlock,
 	.wait_finish	 = fimc_lock,
 	.stop_streaming	 = stop_streaming,
+	.start_streaming = start_streaming,
 };
 
 static int fimc_m2m_querycap(struct file *file, void *priv,
@@ -873,7 +885,6 @@ int fimc_vidioc_try_fmt_mplane(struct file *file, void *priv,
 	u32 max_width, mod_x, mod_y, mask;
 	int i, is_output = 0;
 
-
 	if (f->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) {
 		if (fimc_ctx_state_is_set(FIMC_CTX_CAP, ctx))
 			return -EINVAL;
@@ -1408,9 +1419,6 @@ static int fimc_m2m_open(struct file *file)
 	if (fimc->vid_cap.refcnt > 0)
 		return -EBUSY;
 
-	fimc->m2m.refcnt++;
-	set_bit(ST_OUTDMA_RUN, &fimc->state);
-
 	ctx = kzalloc(sizeof *ctx, GFP_KERNEL);
 	if (!ctx)
 		return -ENOMEM;
@@ -1434,6 +1442,9 @@ static int fimc_m2m_open(struct file *file)
 		return err;
 	}
 
+	if (fimc->m2m.refcnt++ == 0)
+		set_bit(ST_M2M_RUN, &fimc->state);
+
 	return 0;
 }
 
@@ -1446,10 +1457,10 @@ static int fimc_m2m_release(struct file *file)
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
 
@@ -1561,14 +1572,12 @@ static void fimc_unregister_m2m_device(struct fimc_dev *fimc)
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
 
@@ -1577,15 +1586,50 @@ static int fimc_clk_get(struct fimc_dev *fimc)
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
+	return 0;
+}
+
+static int fimc_m2m_suspend(struct fimc_dev *fimc)
+{
+	unsigned long flags;
+	int timeout;
+
+	spin_lock_irqsave(&fimc->slock, flags);
+	if (!fimc_m2m_pending(fimc)) {
+		spin_unlock_irqrestore(&fimc->slock, flags);
+		return 0;
+	}
+	clear_bit(ST_M2M_SUSPENDED, &fimc->state);
+	set_bit(ST_M2M_SUSPENDING, &fimc->state);
+	spin_unlock_irqrestore(&fimc->slock, flags);
+
+	timeout = wait_event_timeout(fimc->irq_queue,
+			     test_bit(ST_M2M_SUSPENDED, &fimc->state),
+			     FIMC_SHUTDOWN_TIMEOUT);
+
+	clear_bit(ST_M2M_SUSPENDING, &fimc->state);
+	return timeout == 0 ? -EAGAIN : 0;
+}
+
+static int fimc_m2m_resume(struct fimc_dev *fimc)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&fimc->slock, flags);
+	/* Clear for full H/W setup in first run after resume */
+	fimc->m2m.ctx = NULL;
+	spin_unlock_irqrestore(&fimc->slock, flags);
+
+	if (test_and_clear_bit(ST_M2M_SUSPENDED, &fimc->state))
+		fimc_m2m_job_finish(fimc->m2m.ctx,
+				    VB2_BUF_STATE_ERROR);
 	return 0;
 }
 
@@ -1614,11 +1658,13 @@ static int fimc_probe(struct platform_device *pdev)
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
@@ -1655,63 +1701,66 @@ static int fimc_probe(struct platform_device *pdev)
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
+
+	platform_set_drvdata(pdev, fimc);
 
-	ret = request_irq(fimc->irq, fimc_isr, 0, pdev->name, fimc);
+	ret = request_irq(fimc->irq, fimc_irq_handler, 0, pdev->name, fimc);
 	if (ret) {
 		dev_err(&pdev->dev, "failed to install irq (%d)\n", ret);
 		goto err_clk;
 	}
 
+	pm_runtime_enable(&pdev->dev);
+	ret = pm_runtime_get_sync(&pdev->dev);
+	if (ret < 0)
+		goto err_irq;
 	/* Initialize contiguous memory allocator */
-	fimc->alloc_ctx = vb2_dma_contig_init_ctx(&fimc->pdev->dev);
+	fimc->alloc_ctx = vb2_dma_contig_init_ctx(&pdev->dev);
 	if (IS_ERR(fimc->alloc_ctx)) {
 		ret = PTR_ERR(fimc->alloc_ctx);
-		goto err_irq;
+		goto err_pm;
 	}
 
 	ret = fimc_register_m2m_device(fimc);
 	if (ret)
-		goto err_irq;
+		goto err_alloc;
 
 	/* At least one camera sensor is required to register capture node */
 	if (cap_input_index >= 0) {
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
 
+	pm_runtime_put(&pdev->dev);
 	return 0;
 
 err_m2m:
 	fimc_unregister_m2m_device(fimc);
+err_alloc:
+	vb2_dma_contig_cleanup_ctx(fimc->alloc_ctx);
+err_pm:
+	pm_runtime_put(&pdev->dev);
 err_irq:
 	free_irq(fimc->irq, fimc);
 err_clk:
-	fimc_clk_release(fimc);
+	fimc_clk_put(fimc);
 err_regs_unmap:
 	iounmap(fimc->regs);
 err_req_region:
@@ -1723,27 +1772,105 @@ err_info:
 	return ret;
 }
 
-static int __devexit fimc_remove(struct platform_device *pdev)
+static int fimc_runtime_resume(struct device *dev)
 {
-	struct fimc_dev *fimc =
-		(struct fimc_dev *)platform_get_drvdata(pdev);
+	struct fimc_dev *fimc =	dev_get_drvdata(dev);
 
-	free_irq(fimc->irq, fimc);
+	dbg("fimc%d: state: 0x%lx", fimc->id, fimc->state);
+
+	/* Enable clocks and perform basic initalization */
+	clk_enable(fimc->clock[CLK_GATE]);
 	fimc_hw_reset(fimc);
+	if (fimc->variant->out_buf_count > 4)
+		fimc_hw_set_dma_seq(fimc, 0xF);
+
+	/* Resume the capture or mem-to-mem device */
+	if (fimc_capture_busy(fimc))
+		return fimc_capture_resume(fimc);
+	else if (fimc_m2m_pending(fimc))
+		return fimc_m2m_resume(fimc);
+	return 0;
+}
+
+static int fimc_runtime_suspend(struct device *dev)
+{
+	struct fimc_dev *fimc =	dev_get_drvdata(dev);
+	int ret = 0;
+
+	if (fimc_capture_busy(fimc))
+		ret = fimc_capture_suspend(fimc);
+	else
+		ret = fimc_m2m_suspend(fimc);
+	if (!ret)
+		clk_disable(fimc->clock[CLK_GATE]);
+
+	dbg("fimc%d: state: 0x%lx", fimc->id, fimc->state);
+	return ret;
+}
+
+#ifdef CONFIG_PM_SLEEP
+static int fimc_resume(struct device *dev)
+{
+	struct fimc_dev *fimc =	dev_get_drvdata(dev);
+	unsigned long flags;
+
+	dbg("fimc%d: state: 0x%lx", fimc->id, fimc->state);
+
+	/* Do not resume if the device was idle before system suspend */
+	spin_lock_irqsave(&fimc->slock, flags);
+	if (!test_and_clear_bit(ST_LPM, &fimc->state) ||
+	    (!fimc_m2m_active(fimc) && !fimc_capture_busy(fimc))) {
+		spin_unlock_irqrestore(&fimc->slock, flags);
+		return 0;
+	}
+	fimc_hw_reset(fimc);
+	if (fimc->variant->out_buf_count > 4)
+		fimc_hw_set_dma_seq(fimc, 0xF);
+	spin_unlock_irqrestore(&fimc->slock, flags);
+
+	if (fimc_capture_busy(fimc))
+		return fimc_capture_resume(fimc);
+
+	return fimc_m2m_resume(fimc);
+}
+
+static int fimc_suspend(struct device *dev)
+{
+	struct fimc_dev *fimc =	dev_get_drvdata(dev);
+
+	dbg("fimc%d: state: 0x%lx", fimc->id, fimc->state);
+
+	if (test_and_set_bit(ST_LPM, &fimc->state))
+		return 0;
+	if (fimc_capture_busy(fimc))
+		return fimc_capture_suspend(fimc);
+
+	return fimc_m2m_suspend(fimc);
+}
+#endif /* CONFIG_PM_SLEEP */
+
+static int __devexit fimc_remove(struct platform_device *pdev)
+{
+	struct fimc_dev *fimc = platform_get_drvdata(pdev);
+
+	pm_runtime_disable(&pdev->dev);
+	fimc_runtime_suspend(&pdev->dev);
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
 	kfree(fimc);
 
-	dev_info(&pdev->dev, "%s driver unloaded\n", pdev->name);
+	dev_info(&pdev->dev, "driver unloaded\n");
 	return 0;
 }
 
@@ -1906,6 +2033,11 @@ static struct platform_device_id fimc_driver_ids[] = {
 };
 MODULE_DEVICE_TABLE(platform, fimc_driver_ids);
 
+static const struct dev_pm_ops fimc_pm_ops = {
+	SET_SYSTEM_SLEEP_PM_OPS(fimc_suspend, fimc_resume)
+	SET_RUNTIME_PM_OPS(fimc_runtime_suspend, fimc_runtime_resume, NULL)
+};
+
 static struct platform_driver fimc_driver = {
 	.probe		= fimc_probe,
 	.remove	= __devexit_p(fimc_remove),
@@ -1913,6 +2045,7 @@ static struct platform_driver fimc_driver = {
 	.driver = {
 		.name	= MODULE_NAME,
 		.owner	= THIS_MODULE,
+		.pm     = &fimc_pm_ops,
 	}
 };
 
diff --git a/drivers/media/video/s5p-fimc/fimc-core.h b/drivers/media/video/s5p-fimc/fimc-core.h
index 1f70772..e34cf3b 100644
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
+	ST_CAPT_BUSY,
 };
 
-#define fimc_m2m_active(dev) test_bit(ST_OUTDMA_RUN, &(dev)->state)
+#define fimc_m2m_active(dev) test_bit(ST_M2M_RUN, &(dev)->state)
 #define fimc_m2m_pending(dev) test_bit(ST_M2M_PEND, &(dev)->state)
 
 #define fimc_capture_running(dev) test_bit(ST_CAPT_RUN, &(dev)->state)
 #define fimc_capture_pending(dev) test_bit(ST_CAPT_PEND, &(dev)->state)
+#define fimc_capture_busy(dev) test_bit(ST_CAPT_BUSY, &(dev)->state)
 
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
1.7.6

