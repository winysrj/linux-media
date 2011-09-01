Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:37965 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932437Ab1IAPab (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 1 Sep 2011 11:30:31 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Date: Thu, 01 Sep 2011 17:30:05 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH 01/19 v4] s5p-fimc: Remove registration of video nodes from
 probe()
In-reply-to: <1314891023-14227-1-git-send-email-s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: mchehab@redhat.com, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, s.nawrocki@samsung.com,
	sw0312.kim@samsung.com, riverful.kim@samsung.com
Message-id: <1314891023-14227-2-git-send-email-s.nawrocki@samsung.com>
References: <1314891023-14227-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Do not register video nodes during FIMC device probe. Also make
fimc_register_m2m_device() public for use by the media device driver.
The video nodes are to be registered during the media device driver
initialization, altogether with the subdev devnodes. The video
capture nodes need to be registered as last ones when the remaining
pipeline elements are already initialized.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/video/s5p-fimc/fimc-capture.c |   14 +-----
 drivers/media/video/s5p-fimc/fimc-core.c    |   55 ++++++--------------------
 drivers/media/video/s5p-fimc/fimc-core.h    |    1 +
 3 files changed, 17 insertions(+), 53 deletions(-)

diff --git a/drivers/media/video/s5p-fimc/fimc-capture.c b/drivers/media/video/s5p-fimc/fimc-capture.c
index 19d398b..6efd952 100644
--- a/drivers/media/video/s5p-fimc/fimc-capture.c
+++ b/drivers/media/video/s5p-fimc/fimc-capture.c
@@ -905,19 +905,8 @@ int fimc_register_capture_device(struct fimc_dev *fimc)
 	if (ret)
 		goto err_ent;
 
-	ret = video_register_device(vfd, VFL_TYPE_GRABBER, -1);
-	if (ret) {
-		v4l2_err(v4l2_dev, "Failed to register video device\n");
-		goto err_vd_reg;
-	}
-
-	v4l2_info(v4l2_dev,
-		  "FIMC capture driver registered as /dev/video%d\n",
-		  vfd->num);
 	return 0;
 
-err_vd_reg:
-	media_entity_cleanup(&vfd->entity);
 err_ent:
 	video_device_release(vfd);
 err_v4l2_reg:
@@ -934,7 +923,10 @@ void fimc_unregister_capture_device(struct fimc_dev *fimc)
 
 	if (vfd) {
 		media_entity_cleanup(&vfd->entity);
+		/* Can also be called if video device was
+		   not registered */
 		video_unregister_device(vfd);
 	}
 	kfree(fimc->vid_cap.ctx);
+	fimc->vid_cap.ctx = NULL;
 }
diff --git a/drivers/media/video/s5p-fimc/fimc-core.c b/drivers/media/video/s5p-fimc/fimc-core.c
index fdc1d75..e042fdc 100644
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
@@ -1541,22 +1541,9 @@ static int fimc_register_m2m_device(struct fimc_dev *fimc)
 	}
 
 	ret = media_entity_init(&vfd->entity, 0, NULL, 0);
-	if (ret)
-		goto err_m2m_r3;
-
-	ret = video_register_device(vfd, VFL_TYPE_GRABBER, -1);
-	if (ret) {
-		v4l2_err(v4l2_dev,
-			 "%s(): failed to register video device\n", __func__);
-		goto err_m2m_r4;
-	}
-	v4l2_info(v4l2_dev,
-		  "FIMC m2m driver registered as /dev/video%d\n", vfd->num);
+	if (!ret)
+		return 0;
 
-	return 0;
-err_m2m_r4:
-	media_entity_cleanup(&vfd->entity);
-err_m2m_r3:
 	v4l2_m2m_release(fimc->m2m.m2m_dev);
 err_m2m_r2:
 	video_device_release(fimc->m2m.vfd);
@@ -1566,15 +1553,19 @@ err_m2m_r1:
 	return ret;
 }
 
-static void fimc_unregister_m2m_device(struct fimc_dev *fimc)
+void fimc_unregister_m2m_device(struct fimc_dev *fimc)
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
+		/* Can also be called if video device wasn't registered */
+		video_unregister_device(fimc->m2m.vfd);
+	}
 }
 
 static void fimc_clk_put(struct fimc_dev *fimc)
@@ -1739,27 +1730,11 @@ static int fimc_probe(struct platform_device *pdev)
 		goto err_pm;
 	}
 
-	ret = fimc_register_m2m_device(fimc);
-	if (ret)
-		goto err_alloc;
-
-	/* At least one camera sensor is required to register capture node */
-	if (cap_input_index >= 0) {
-		ret = fimc_register_capture_device(fimc);
-		if (ret)
-			goto err_m2m;
-	}
-
-	dev_dbg(&pdev->dev, "%s(): fimc-%d registered successfully\n",
-		__func__, fimc->id);
+	dev_dbg(&pdev->dev, "FIMC.%d registered successfully\n", fimc->id);
 
 	pm_runtime_put(&pdev->dev);
 	return 0;
 
-err_m2m:
-	fimc_unregister_m2m_device(fimc);
-err_alloc:
-	vb2_dma_contig_cleanup_ctx(fimc->alloc_ctx);
 err_pm:
 	pm_runtime_put(&pdev->dev);
 err_irq:
@@ -1773,7 +1748,6 @@ err_req_region:
 	kfree(fimc->regs_res);
 err_info:
 	kfree(fimc);
-
 	return ret;
 }
 
@@ -1862,9 +1836,6 @@ static int __devexit fimc_remove(struct platform_device *pdev)
 	fimc_runtime_suspend(&pdev->dev);
 	pm_runtime_set_suspended(&pdev->dev);
 
-	fimc_unregister_m2m_device(fimc);
-	fimc_unregister_capture_device(fimc);
-
 	vb2_dma_contig_cleanup_ctx(fimc->alloc_ctx);
 
 	clk_disable(fimc->clock[CLK_BUS]);
diff --git a/drivers/media/video/s5p-fimc/fimc-core.h b/drivers/media/video/s5p-fimc/fimc-core.h
index fc99824f..c8a2bab 100644
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
1.7.6

