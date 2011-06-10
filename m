Return-path: <mchehab@pedra>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:58899 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758014Ab1FJShH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 10 Jun 2011 14:37:07 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Date: Fri, 10 Jun 2011 20:36:44 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH/RFC 03/19] s5p-fimc: Remove registration of video nodes from
 probe()
In-reply-to: <1307731020-7100-1-git-send-email-s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: hans.verkuil@cisco.com, laurent.pinchart@ideasonboard.com,
	m.szyprowski@samsung.com, kyungmin.park@samsung.com,
	s.nawrocki@samsung.com, sw0312.kim@samsung.com,
	riverful.kim@samsung.com
Message-id: <1307731020-7100-4-git-send-email-s.nawrocki@samsung.com>
References: <1307731020-7100-1-git-send-email-s.nawrocki@samsung.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Do not register video nodes during FIMC device probe. Also make
fimc_register_m2m_device() public for use by the media device driver.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/video/s5p-fimc/fimc-core.c |   18 +-----------------
 drivers/media/video/s5p-fimc/fimc-core.h |    1 +
 2 files changed, 2 insertions(+), 17 deletions(-)

diff --git a/drivers/media/video/s5p-fimc/fimc-core.c b/drivers/media/video/s5p-fimc/fimc-core.c
index ad15d46..b464da5 100644
--- a/drivers/media/video/s5p-fimc/fimc-core.c
+++ b/drivers/media/video/s5p-fimc/fimc-core.c
@@ -1491,7 +1491,7 @@ static struct v4l2_m2m_ops m2m_ops = {
 	.job_abort	= fimc_job_abort,
 };
 
-static int fimc_register_m2m_device(struct fimc_dev *fimc)
+int fimc_register_m2m_device(struct fimc_dev *fimc)
 {
 	struct video_device *vfd;
 	struct platform_device *pdev;
@@ -1700,25 +1700,12 @@ static int fimc_probe(struct platform_device *pdev)
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
 
 	pm_runtime_put_sync(&fimc->pdev->dev);
 	return 0;
 
-err_m2m:
-	fimc_unregister_m2m_device(fimc);
 err_irq:
 	free_irq(fimc->irq, fimc);
 err_clk:
@@ -1805,9 +1792,6 @@ static int __devexit fimc_remove(struct platform_device *pdev)
 	fimc_suspend(&pdev->dev);
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

