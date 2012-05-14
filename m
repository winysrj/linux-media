Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:53932 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755235Ab2ENJnd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 14 May 2012 05:43:33 -0400
Received: by mail-pz0-f46.google.com with SMTP id y13so5696681dad.19
        for <linux-media@vger.kernel.org>; Mon, 14 May 2012 02:43:33 -0700 (PDT)
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-media@vger.kernel.org
Cc: mchehab@infradead.org, andrzej.p@samsung.com,
	sachin.kamat@linaro.org, patches@linaro.org
Subject: [PATCH] s5p-jpeg: Use devm_* functions in jpeg-core.c file
Date: Mon, 14 May 2012 15:03:34 +0530
Message-Id: <1336988014-27071-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

devm_* functions are used to replace kzalloc, request_mem_region, ioremap
and request_irq functions in probe call. With the usage of devm_* functions
explicit freeing and unmapping is not required.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/media/video/s5p-jpeg/jpeg-core.c |   58 +++++------------------------
 drivers/media/video/s5p-jpeg/jpeg-core.h |    2 -
 2 files changed, 10 insertions(+), 50 deletions(-)

diff --git a/drivers/media/video/s5p-jpeg/jpeg-core.c b/drivers/media/video/s5p-jpeg/jpeg-core.c
index 5a49c30..a83a7e3 100644
--- a/drivers/media/video/s5p-jpeg/jpeg-core.c
+++ b/drivers/media/video/s5p-jpeg/jpeg-core.c
@@ -1290,7 +1290,7 @@ static int s5p_jpeg_probe(struct platform_device *pdev)
 	int ret;
 
 	/* JPEG IP abstraction struct */
-	jpeg = kzalloc(sizeof(struct s5p_jpeg), GFP_KERNEL);
+	jpeg = devm_kzalloc(&pdev->dev, sizeof(struct s5p_jpeg), GFP_KERNEL);
 	if (!jpeg)
 		return -ENOMEM;
 
@@ -1300,43 +1300,25 @@ static int s5p_jpeg_probe(struct platform_device *pdev)
 
 	/* memory-mapped registers */
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!res) {
-		dev_err(&pdev->dev, "cannot find IO resource\n");
-		ret = -ENOENT;
-		goto jpeg_alloc_rollback;
-	}
-
-	jpeg->ioarea = request_mem_region(res->start, resource_size(res),
-					  pdev->name);
-	if (!jpeg->ioarea) {
-		dev_err(&pdev->dev, "cannot request IO\n");
-		ret = -ENXIO;
-		goto jpeg_alloc_rollback;
-	}
 
-	jpeg->regs = ioremap(res->start, resource_size(res));
-	if (!jpeg->regs) {
-		dev_err(&pdev->dev, "cannot map IO\n");
-		ret = -ENXIO;
-		goto mem_region_rollback;
+	jpeg->regs = devm_request_and_ioremap(&pdev->dev, res);
+	if (jpeg->regs == NULL) {
+		dev_err(&pdev->dev, "Failed to obtain io memory\n");
+		return -ENOENT;
 	}
 
-	dev_dbg(&pdev->dev, "registers %p (%p, %p)\n",
-		jpeg->regs, jpeg->ioarea, res);
-
 	/* interrupt service routine registration */
 	jpeg->irq = ret = platform_get_irq(pdev, 0);
 	if (ret < 0) {
 		dev_err(&pdev->dev, "cannot find IRQ\n");
-		goto ioremap_rollback;
+		return ret;
 	}
 
-	ret = request_irq(jpeg->irq, s5p_jpeg_irq, 0,
-			  dev_name(&pdev->dev), jpeg);
-
+	ret = devm_request_irq(&pdev->dev, jpeg->irq, s5p_jpeg_irq, 0,
+			dev_name(&pdev->dev), jpeg);
 	if (ret) {
 		dev_err(&pdev->dev, "cannot claim IRQ %d\n", jpeg->irq);
-		goto ioremap_rollback;
+		return ret;
 	}
 
 	/* clocks */
@@ -1344,7 +1326,7 @@ static int s5p_jpeg_probe(struct platform_device *pdev)
 	if (IS_ERR(jpeg->clk)) {
 		dev_err(&pdev->dev, "cannot get clock\n");
 		ret = PTR_ERR(jpeg->clk);
-		goto request_irq_rollback;
+		return ret;
 	}
 	dev_dbg(&pdev->dev, "clock source %p\n", jpeg->clk);
 	clk_enable(jpeg->clk);
@@ -1456,18 +1438,6 @@ clk_get_rollback:
 	clk_disable(jpeg->clk);
 	clk_put(jpeg->clk);
 
-request_irq_rollback:
-	free_irq(jpeg->irq, jpeg);
-
-ioremap_rollback:
-	iounmap(jpeg->regs);
-
-mem_region_rollback:
-	release_resource(jpeg->ioarea);
-	release_mem_region(jpeg->ioarea->start, resource_size(jpeg->ioarea));
-
-jpeg_alloc_rollback:
-	kfree(jpeg);
 	return ret;
 }
 
@@ -1488,14 +1458,6 @@ static int s5p_jpeg_remove(struct platform_device *pdev)
 	clk_disable(jpeg->clk);
 	clk_put(jpeg->clk);
 
-	free_irq(jpeg->irq, jpeg);
-
-	iounmap(jpeg->regs);
-
-	release_resource(jpeg->ioarea);
-	release_mem_region(jpeg->ioarea->start, resource_size(jpeg->ioarea));
-	kfree(jpeg);
-
 	return 0;
 }
 
diff --git a/drivers/media/video/s5p-jpeg/jpeg-core.h b/drivers/media/video/s5p-jpeg/jpeg-core.h
index 38d7367..9d0cd2b 100644
--- a/drivers/media/video/s5p-jpeg/jpeg-core.h
+++ b/drivers/media/video/s5p-jpeg/jpeg-core.h
@@ -54,7 +54,6 @@
  * @vfd_encoder:	video device node for encoder mem2mem mode
  * @vfd_decoder:	video device node for decoder mem2mem mode
  * @m2m_dev:		v4l2 mem2mem device data
- * @ioarea:		JPEG IP memory region
  * @regs:		JPEG IP registers mapping
  * @irq:		JPEG IP irq
  * @clk:		JPEG IP clock
@@ -70,7 +69,6 @@ struct s5p_jpeg {
 	struct video_device	*vfd_decoder;
 	struct v4l2_m2m_dev	*m2m_dev;
 
-	struct resource		*ioarea;
 	void __iomem		*regs;
 	unsigned int		irq;
 	struct clk		*clk;
-- 
1.7.4.1

