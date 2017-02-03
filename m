Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:31424 "EHLO
        mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752949AbdBCOFf (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 3 Feb 2017 09:05:35 -0500
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Andrzej Hajda <a.hajda@samsung.com>,
        Krzysztof Kozlowski <krzk@kernel.org>
Subject: [PATCH] media: s5p-mfc: Fix initialization of internal structures
Date: Fri, 03 Feb 2017 15:05:18 +0100
Message-id: <1486130718-25998-1-git-send-email-m.szyprowski@samsung.com>
References: <CGME20170203140530eucas1p17e9d0bbb29da881bae025e8e3bc7cbbb@eucas1p1.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Initialize members of the internal device and context structures as early
as possible to avoid access to uninitialized objects on initialization
failures. If loading firmware or creating of the hardware instance fails,
driver will access device or context queue in error handling path, which
might not be initialized yet, what causes kernel panic. Fix this by moving
initialization of all static members as early as possible.

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
---
 drivers/media/platform/s5p-mfc/s5p_mfc.c | 17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc.c b/drivers/media/platform/s5p-mfc/s5p_mfc.c
index bb0a5887c9a9..05fe82be6584 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc.c
@@ -764,6 +764,7 @@ static int s5p_mfc_open(struct file *file)
 		ret = -ENOMEM;
 		goto err_alloc;
 	}
+	init_waitqueue_head(&ctx->queue);
 	v4l2_fh_init(&ctx->fh, vdev);
 	file->private_data = &ctx->fh;
 	v4l2_fh_add(&ctx->fh);
@@ -899,7 +900,6 @@ static int s5p_mfc_open(struct file *file)
 		mfc_err("Failed to initialize videobuf2 queue(output)\n");
 		goto err_queue_init;
 	}
-	init_waitqueue_head(&ctx->queue);
 	mutex_unlock(&dev->mfc_mutex);
 	mfc_debug_leave();
 	return ret;
@@ -1218,6 +1218,13 @@ static int s5p_mfc_probe(struct platform_device *pdev)
 	vb2_dma_contig_set_max_seg_size(dev->mem_dev_r, DMA_BIT_MASK(32));
 
 	mutex_init(&dev->mfc_mutex);
+	init_waitqueue_head(&dev->queue);
+	dev->hw_lock = 0;
+	INIT_WORK(&dev->watchdog_work, s5p_mfc_watchdog_worker);
+	atomic_set(&dev->watchdog_cnt, 0);
+	init_timer(&dev->watchdog_timer);
+	dev->watchdog_timer.data = (unsigned long)dev;
+	dev->watchdog_timer.function = s5p_mfc_watchdog;
 
 	ret = s5p_mfc_alloc_firmware(dev);
 	if (ret)
@@ -1226,7 +1233,6 @@ static int s5p_mfc_probe(struct platform_device *pdev)
 	ret = v4l2_device_register(&pdev->dev, &dev->v4l2_dev);
 	if (ret)
 		goto err_v4l2_dev_reg;
-	init_waitqueue_head(&dev->queue);
 
 	/* decoder */
 	vfd = video_device_alloc();
@@ -1263,13 +1269,6 @@ static int s5p_mfc_probe(struct platform_device *pdev)
 	video_set_drvdata(vfd, dev);
 	platform_set_drvdata(pdev, dev);
 
-	dev->hw_lock = 0;
-	INIT_WORK(&dev->watchdog_work, s5p_mfc_watchdog_worker);
-	atomic_set(&dev->watchdog_cnt, 0);
-	init_timer(&dev->watchdog_timer);
-	dev->watchdog_timer.data = (unsigned long)dev;
-	dev->watchdog_timer.function = s5p_mfc_watchdog;
-
 	/* Initialize HW ops and commands based on MFC version */
 	s5p_mfc_init_hw_ops(dev);
 	s5p_mfc_init_hw_cmds(dev);
-- 
1.9.1

