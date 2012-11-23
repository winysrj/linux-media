Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:64565 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754105Ab2KWL5L (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 23 Nov 2012 06:57:11 -0500
Received: by mail-pa0-f46.google.com with SMTP id bh2so3502852pad.19
        for <linux-media@vger.kernel.org>; Fri, 23 Nov 2012 03:57:11 -0800 (PST)
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-media@vger.kernel.org
Cc: s.nawrocki@samsung.com, sachin.kamat@linaro.org,
	patches@linaro.org, Kamil Debski <k.debski@samsung.com>
Subject: [PATCH 4/6] [media] s5p-g2d: Use devm_clk_get APIs.
Date: Fri, 23 Nov 2012 17:20:41 +0530
Message-Id: <1353671443-2978-5-git-send-email-sachin.kamat@linaro.org>
In-Reply-To: <1353671443-2978-1-git-send-email-sachin.kamat@linaro.org>
References: <1353671443-2978-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

devm_clk_get() is device managed function and makes error handling
and exit code a bit simpler.

Cc: Kamil Debski <k.debski@samsung.com>
Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/media/platform/s5p-g2d/g2d.c |   14 ++++----------
 1 files changed, 4 insertions(+), 10 deletions(-)

diff --git a/drivers/media/platform/s5p-g2d/g2d.c b/drivers/media/platform/s5p-g2d/g2d.c
index 1bfbc32..77819d3 100644
--- a/drivers/media/platform/s5p-g2d/g2d.c
+++ b/drivers/media/platform/s5p-g2d/g2d.c
@@ -714,7 +714,7 @@ static int g2d_probe(struct platform_device *pdev)
 			return -ENOENT;
 	}
 
-	dev->clk = clk_get(&pdev->dev, "sclk_fimg2d");
+	dev->clk = devm_clk_get(&pdev->dev, "sclk_fimg2d");
 	if (IS_ERR_OR_NULL(dev->clk)) {
 		dev_err(&pdev->dev, "failed to get g2d clock\n");
 		return -ENXIO;
@@ -726,7 +726,7 @@ static int g2d_probe(struct platform_device *pdev)
 		goto put_clk;
 	}
 
-	dev->gate = clk_get(&pdev->dev, "fimg2d");
+	dev->gate = devm_clk_get(&pdev->dev, "fimg2d");
 	if (IS_ERR_OR_NULL(dev->gate)) {
 		dev_err(&pdev->dev, "failed to get g2d clock gate\n");
 		ret = -ENXIO;
@@ -736,7 +736,7 @@ static int g2d_probe(struct platform_device *pdev)
 	ret = clk_prepare(dev->gate);
 	if (ret) {
 		dev_err(&pdev->dev, "failed to prepare g2d clock gate\n");
-		goto put_clk_gate;
+		goto unprep_clk;
 	}
 
 	res = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
@@ -752,7 +752,7 @@ static int g2d_probe(struct platform_device *pdev)
 						0, pdev->name, dev);
 	if (ret) {
 		dev_err(&pdev->dev, "failed to install IRQ\n");
-		goto put_clk_gate;
+		goto unprep_clk;
 	}
 
 	dev->alloc_ctx = vb2_dma_contig_init_ctx(&pdev->dev);
@@ -804,13 +804,9 @@ alloc_ctx_cleanup:
 	vb2_dma_contig_cleanup_ctx(dev->alloc_ctx);
 unprep_clk_gate:
 	clk_unprepare(dev->gate);
-put_clk_gate:
-	clk_put(dev->gate);
 unprep_clk:
 	clk_unprepare(dev->clk);
 put_clk:
-	clk_put(dev->clk);
-
 	return ret;
 }
 
@@ -824,9 +820,7 @@ static int g2d_remove(struct platform_device *pdev)
 	v4l2_device_unregister(&dev->v4l2_dev);
 	vb2_dma_contig_cleanup_ctx(dev->alloc_ctx);
 	clk_unprepare(dev->gate);
-	clk_put(dev->gate);
 	clk_unprepare(dev->clk);
-	clk_put(dev->clk);
 	return 0;
 }
 
-- 
1.7.4.1

