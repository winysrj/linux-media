Return-path: <linux-media-owner@vger.kernel.org>
Received: from resqmta-po-04v.sys.comcast.net ([96.114.154.163]:54380 "EHLO
	resqmta-po-04v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756418AbcGHW33 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 8 Jul 2016 18:29:29 -0400
From: Shuah Khan <shuahkh@osg.samsung.com>
To: kyungmin.park@samsung.com, k.debski@samsung.com,
	jtp.park@samsung.com, mchehab@kernel.org, javier@osg.samsung.com
Cc: Shuah Khan <shuahkh@osg.samsung.com>,
	linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org, luisbg@osg.samsung.com
Subject: [PATCH] media: s5p-mfc fix invalid memory access from s5p_mfc_release()
Date: Fri,  8 Jul 2016 16:29:25 -0600
Message-Id: <1468016965-10880-1-git-send-email-shuahkh@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

If s5p_mfc_release() runs after s5p_mfc_remove(), the former will access
invalid s5p_mfc_dev pointer saved in the s5p_mfc_ctx and runs into kernel
paging request errors.

Clear ctx dev pointer in s5p_mfc_remove() and change s5p_mfc_release() to
avoid work that requires ctx->dev.

odroid kernel: Unable to handle kernel paging request at virtual address
    f17c1104
odroid kernel: pgd = ebca4000
odroid kernel: [f17c1104] *pgd=6e23d811, *pte=00000000, *ppte=00000000
odroid kernel: Internal error: Oops: 807 [#1] PREEMPT SMP ARM
odroid kernel: Modules linked in: cpufreq_userspace cpufreq_powersave
    cpufreq_conservative s5p_mfc s5p_jpeg v4l2_mem2mem
    videobuf2_dma_contig videobuf2_memops videobuf2_v4l2 videobuf2_core
    v4l2_common videodev media
odroid kernel: Hardware name: SAMSUNG EXYNOS (Flattened Device Tree)
odroid kernel: task: c2241400 ti: e7018000 task.ti: e7018000
odroid kernel: PC is at s5p_mfc_reset+0x40/0x28c [s5p_mfc]
odroid kernel: LR is at s5p_mfc_reset+0x34/0x28c [s5p_mfc]
odroid kernel: pc : [<bf15bfbc>]    lr : [<bf15bfb0>] psr: 60010013
odroid kernel: [<bf15bfbc>] (s5p_mfc_reset [s5p_mfc]) from [<bf15c62c>]
    (s5p_mfc_deinit_hw+0x14/0x3c [s5p_mfc])
odroid kernel: [<bf15c62c>] (s5p_mfc_deinit_hw [s5p_mfc]) from [<bf155958>]
    (s5p_mfc_release+0xac/0x1c4 [s5p_mfc])
odroid kernel: [<bf155958>] (s5p_mfc_release [s5p_mfc]) from [<bf021344>]
    (v4l2_release+0x38/0x74 [videodev])
odroid kernel: [<bf021344>] (v4l2_release [videodev]) from [<c01e4274>]
    (__fput+0x80/0x1c8)
odroid kernel: [<c01e4274>] (__fput) from [<c0135c58>]
    (task_work_run+0x94/0xc8)
odroid kernel: [<c0135c58>] (task_work_run) from [<c010a9d4>]
    (do_work_pending+0x7c/0xa4)
odroid kernel: [<c010a9d4>] (do_work_pending) from [<c0107794>]
    (slow_work_pending+0xc/0x20)
odroid kernel: Code: eb3edacc e5953078 e3a06000 e2833c11 (e5836004)

Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
---
 drivers/media/platform/s5p-mfc/s5p_mfc.c | 72 ++++++++++++++++++++++----------
 1 file changed, 50 insertions(+), 22 deletions(-)

diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc.c b/drivers/media/platform/s5p-mfc/s5p_mfc.c
index f537b74..c96421f 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc.c
@@ -925,39 +925,50 @@ static int s5p_mfc_release(struct file *file)
 	struct s5p_mfc_ctx *ctx = fh_to_ctx(file->private_data);
 	struct s5p_mfc_dev *dev = ctx->dev;
 
+	/* if dev is null, do cleanup that doesn't need dev */
 	mfc_debug_enter();
-	mutex_lock(&dev->mfc_mutex);
+	if (dev)
+		mutex_lock(&dev->mfc_mutex);
 	s5p_mfc_clock_on();
 	vb2_queue_release(&ctx->vq_src);
 	vb2_queue_release(&ctx->vq_dst);
-	/* Mark context as idle */
-	clear_work_bit_irqsave(ctx);
-	/* If instance was initialised and not yet freed,
-	 * return instance and free resources */
-	if (ctx->state != MFCINST_FREE && ctx->state != MFCINST_INIT) {
-		mfc_debug(2, "Has to free instance\n");
-		s5p_mfc_close_mfc_inst(dev, ctx);
-	}
-	/* hardware locking scheme */
-	if (dev->curr_ctx == ctx->num)
-		clear_bit(0, &dev->hw_lock);
-	dev->num_inst--;
-	if (dev->num_inst == 0) {
-		mfc_debug(2, "Last instance\n");
-		s5p_mfc_deinit_hw(dev);
-		del_timer_sync(&dev->watchdog_timer);
-		if (s5p_mfc_power_off() < 0)
-			mfc_err("Power off failed\n");
+	if (dev) {
+		/* Mark context as idle */
+		clear_work_bit_irqsave(ctx);
+		/*
+		 * If instance was initialised and not yet freed,
+		 * return instance and free resources
+		*/
+		if (ctx->state != MFCINST_FREE && ctx->state != MFCINST_INIT) {
+			mfc_debug(2, "Has to free instance\n");
+			s5p_mfc_close_mfc_inst(dev, ctx);
+		}
+		/* hardware locking scheme */
+		if (dev->curr_ctx == ctx->num)
+			clear_bit(0, &dev->hw_lock);
+		dev->num_inst--;
+		if (dev->num_inst == 0) {
+			mfc_debug(2, "Last instance\n");
+			s5p_mfc_deinit_hw(dev);
+			del_timer_sync(&dev->watchdog_timer);
+			if (s5p_mfc_power_off() < 0)
+				mfc_err("Power off failed\n");
+		}
 	}
 	mfc_debug(2, "Shutting down clock\n");
 	s5p_mfc_clock_off();
-	dev->ctx[ctx->num] = NULL;
+	if (dev)
+		dev->ctx[ctx->num] = NULL;
 	s5p_mfc_dec_ctrls_delete(ctx);
 	v4l2_fh_del(&ctx->fh);
-	v4l2_fh_exit(&ctx->fh);
+	/* vdev is gone if dev is null */
+	if (dev)
+		v4l2_fh_exit(&ctx->fh);
 	kfree(ctx);
 	mfc_debug_leave();
-	mutex_unlock(&dev->mfc_mutex);
+	if (dev)
+		mutex_unlock(&dev->mfc_mutex);
+
 	return 0;
 }
 
@@ -1309,9 +1320,26 @@ err_res:
 static int s5p_mfc_remove(struct platform_device *pdev)
 {
 	struct s5p_mfc_dev *dev = platform_get_drvdata(pdev);
+	struct s5p_mfc_ctx *ctx;
+	int i;
 
 	v4l2_info(&dev->v4l2_dev, "Removing %s\n", pdev->name);
 
+	/*
+	 * Clear ctx dev pointer to avoid races between s5p_mfc_remove()
+	 * and s5p_mfc_release() and s5p_mfc_release() accessing ctx->dev
+	 * after s5p_mfc_remove() is run during unbind.
+	*/
+	mutex_lock(&dev->mfc_mutex);
+	for (i = 0; i < MFC_NUM_CONTEXTS; i++) {
+		ctx = dev->ctx[i];
+		if (!ctx)
+			continue;
+		/* clear ctx->dev */
+		ctx->dev = NULL;
+	}
+	mutex_unlock(&dev->mfc_mutex);
+
 	del_timer_sync(&dev->watchdog_timer);
 	flush_workqueue(dev->watchdog_workqueue);
 	destroy_workqueue(dev->watchdog_workqueue);
-- 
2.7.4

