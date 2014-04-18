Return-path: <linux-media-owner@vger.kernel.org>
Received: from fallback2.mail.ru ([94.100.176.87]:46859 "EHLO
	fallback6.mail.ru" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750955AbaDRFLz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 18 Apr 2014 01:11:55 -0400
Received: from smtp35.i.mail.ru (smtp35.i.mail.ru [94.100.177.95])
	by fallback6.mail.ru (mPOP.Fallback_MX) with ESMTP id 2A76636F19B8
	for <linux-media@vger.kernel.org>; Fri, 18 Apr 2014 09:07:50 +0400 (MSK)
From: Alexander Shiyan <shc_work@mail.ru>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Alexander Shiyan <shc_work@mail.ru>
Subject: [PATCH] media: m2m-deinterlace: Convert to devm* API
Date: Fri, 18 Apr 2014 09:07:33 +0400
Message-Id: <1397797653-14717-1-git-send-email-shc_work@mail.ru>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Replace resource handling in the driver with managed device resource.

Signed-off-by: Alexander Shiyan <shc_work@mail.ru>
---
 drivers/media/platform/m2m-deinterlace.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/media/platform/m2m-deinterlace.c b/drivers/media/platform/m2m-deinterlace.c
index c21d14f..d36c507 100644
--- a/drivers/media/platform/m2m-deinterlace.c
+++ b/drivers/media/platform/m2m-deinterlace.c
@@ -1002,7 +1002,7 @@ static int deinterlace_probe(struct platform_device *pdev)
 	dma_cap_mask_t mask;
 	int ret = 0;
 
-	pcdev = kzalloc(sizeof *pcdev, GFP_KERNEL);
+	pcdev = devm_kzalloc(&pdev->dev, sizeof(*pcdev), GFP_KERNEL);
 	if (!pcdev)
 		return -ENOMEM;
 
@@ -1012,7 +1012,7 @@ static int deinterlace_probe(struct platform_device *pdev)
 	dma_cap_set(DMA_INTERLEAVE, mask);
 	pcdev->dma_chan = dma_request_channel(mask, NULL, pcdev);
 	if (!pcdev->dma_chan)
-		goto free_dev;
+		return -ENODEV;
 
 	if (!dma_has_cap(DMA_INTERLEAVE, pcdev->dma_chan->device->cap_mask)) {
 		v4l2_err(&pcdev->v4l2_dev, "DMA does not support INTERLEAVE\n");
@@ -1078,8 +1078,6 @@ unreg_dev:
 	v4l2_device_unregister(&pcdev->v4l2_dev);
 rel_dma:
 	dma_release_channel(pcdev->dma_chan);
-free_dev:
-	kfree(pcdev);
 
 	return ret;
 }
@@ -1094,7 +1092,6 @@ static int deinterlace_remove(struct platform_device *pdev)
 	v4l2_device_unregister(&pcdev->v4l2_dev);
 	vb2_dma_contig_cleanup_ctx(pcdev->alloc_ctx);
 	dma_release_channel(pcdev->dma_chan);
-	kfree(pcdev);
 
 	return 0;
 }
-- 
1.8.3.2

