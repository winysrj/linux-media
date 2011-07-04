Return-path: <mchehab@pedra>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:9888 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758292Ab1GDRzm (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Jul 2011 13:55:42 -0400
Date: Mon, 04 Jul 2011 19:54:54 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH v3 03/19] s5p-fimc: Remove registration of video nodes from
 probe()
In-reply-to: <1309802110-16682-1-git-send-email-s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: m.szyprowski@samsung.com, kyungmin.park@samsung.com,
	s.nawrocki@samsung.com, sw0312.kim@samsung.com,
	riverful.kim@samsung.com
Message-id: <1309802110-16682-4-git-send-email-s.nawrocki@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <1309802110-16682-1-git-send-email-s.nawrocki@samsung.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Do not register video nodes during FIMC device probe. Also make
fimc_register_m2m_device() public for use by the media device driver.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/video/s5p-fimc/fimc-capture.c |    1 +
 drivers/media/video/s5p-fimc/fimc-core.c    |   30 +++++++-------------------
 drivers/media/video/s5p-fimc/fimc-core.h    |    1 +
 3 files changed, 10 insertions(+), 22 deletions(-)

diff --git a/drivers/media/video/s5p-fimc/fimc-capture.c b/drivers/media/video/s5p-fimc/fimc-capture.c
index c9be15c..a806e48 100644
--- a/drivers/media/video/s5p-fimc/fimc-capture.c
+++ b/drivers/media/video/s5p-fimc/fimc-capture.c
@@ -922,4 +922,5 @@ void fimc_unregister_capture_device(struct fimc_dev *fimc)
 		video_unregister_device(vfd);
 	}
 	kfree(fimc->vid_cap.ctx);
+	fimc->vid_cap.ctx = NULL;
 }
diff --git a/drivers/media/video/s5p-fimc/fimc-core.c b/drivers/media/video/s5p-fimc/fimc-core.c
index c97494d..36a8d63 100644
--- a/drivers/media/video/s5p-fimc/fimc-core.c
+++ b/drivers/media/video/s5p-fimc/fimc-core.c
@@ -1494,7 +1494,7 @@ static struct v4l2_m2m_ops m2m_ops = {
 	.job_abort	= fimc_job_abort,
 };
 
-static int fimc_register_m2m_device(struct fimc_dev *fimc)
+int fimc_register_m2m_device(struct fimc_dev *fimc)
 {
 	struct video_device *vfd;
 	struct platform_device *pdev;
@@ -1568,13 +1568,16 @@ err_m2m_r1:
 
 void fimc_unregister_m2m_device(struct fimc_dev *fimc)
 {
-	if (fimc == NULL)
+	if (!fimc)
 		return;
 
-	v4l2_m2m_release(fimc->m2m.m2m_dev);
+	if (fimc->m2m.m2m_dev)
+		v4l2_m2m_release(fimc->m2m.m2m_dev);
 	v4l2_device_unregister(&fimc->m2m.v4l2_dev);
-	media_entity_cleanup(&fimc->m2m.vfd->entity);
-	video_unregister_device(fimc->m2m.vfd);
+	if (fimc->m2m.vfd) {
+		media_entity_cleanup(&fimc->m2m.vfd->entity);
+		video_unregister_device(fimc->m2m.vfd);
+	}
 }
 
 static void fimc_clk_put(struct fimc_dev *fimc)
@@ -1739,25 +1742,12 @@ static int fimc_probe(struct platform_device *pdev)
 		goto err_irq;
 	}
 
-	ret = fimc_register_m2m_device(fimc);
-	if (ret)
-		goto err_irq;
-
-	/* At least one camera sensor is required to register capture node */
-	if (cap_input_index >= 0) {
-		ret = fimc_register_capture_device(fimc);
-		if (ret)
-			goto err_m2m;
-	}
-
 	dev_dbg(&pdev->dev, "%s(): fimc-%d registered successfully\n",
 		__func__, fimc->id);
 
 	pm_runtime_put(&fimc->pdev->dev);
 	return 0;
 
-err_m2m:
-	fimc_unregister_m2m_device(fimc);
 err_irq:
 	free_irq(fimc->irq, fimc);
 err_clk:
@@ -1769,7 +1759,6 @@ err_req_region:
 	kfree(fimc->regs_res);
 err_info:
 	kfree(fimc);
-
 	return ret;
 }
 
@@ -1858,9 +1847,6 @@ static int __devexit fimc_remove(struct platform_device *pdev)
 	fimc_runtime_suspend(&pdev->dev);
 	pm_runtime_set_suspended(&pdev->dev);
 
-	fimc_unregister_m2m_device(fimc);
-	fimc_unregister_capture_device(fimc);
-
 	vb2_dma_contig_cleanup_ctx(fimc->alloc_ctx);
 
 	clk_disable(fimc->clock[CLK_BUS]);
diff --git a/drivers/media/video/s5p-fimc/fimc-core.h b/drivers/media/video/s5p-fimc/fimc-core.h
index 55c1410..c088dac 100644
--- a/drivers/media/video/s5p-fimc/fimc-core.h
+++ b/drivers/media/video/s5p-fimc/fimc-core.h
@@ -644,6 +644,7 @@ int fimc_set_scaler_info(struct fimc_ctx *ctx);
 int fimc_prepare_config(struct fimc_ctx *ctx, u32 flags);
 int fimc_prepare_addr(struct fimc_ctx *ctx, struct vb2_buffer *vb,
 		      struct fimc_frame *frame, struct fimc_addr *paddr);
+int fimc_register_m2m_device(struct fimc_dev *fimc);
 
 /* -----------------------------------------------------*/
 /* fimc-capture.c					*/
-- 
1.7.5.4

