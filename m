Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:48240 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754694Ab2BJMXv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 10 Feb 2012 07:23:51 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Received: from euspt2 ([210.118.77.13]) by mailout3.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0LZ60077FFRPL550@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 10 Feb 2012 12:23:49 +0000 (GMT)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LZ600ALPFRPW9@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 10 Feb 2012 12:23:49 +0000 (GMT)
Date: Fri, 10 Feb 2012 13:23:45 +0100
From: Kamil Debski <k.debski@samsung.com>
Subject: [PATCH] s5p-g2d: Added support for clk_prepare
To: linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, kyungmin.park@samsung.com,
	Kamil Debski <k.debski@samsung.com>
Message-id: <1328876626-6931-1-git-send-email-k.debski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Kamil Debski <k.debski@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
Reviewed-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
---
 drivers/media/video/s5p-g2d/g2d.c |   22 ++++++++++++++++++++--
 1 files changed, 20 insertions(+), 2 deletions(-)

diff --git a/drivers/media/video/s5p-g2d/g2d.c b/drivers/media/video/s5p-g2d/g2d.c
index febaa67..351080a 100644
--- a/drivers/media/video/s5p-g2d/g2d.c
+++ b/drivers/media/video/s5p-g2d/g2d.c
@@ -693,18 +693,30 @@ static int g2d_probe(struct platform_device *pdev)
 		goto unmap_regs;
 	}
 
+	ret = clk_prepare(dev->clk);
+	if (ret) {
+		dev_err(&pdev->dev, "failed to prepare g2d clock\n");
+		goto put_clk;
+	}
+
 	dev->gate = clk_get(&pdev->dev, "fimg2d");
 	if (IS_ERR_OR_NULL(dev->gate)) {
 		dev_err(&pdev->dev, "failed to get g2d clock gate\n");
 		ret = -ENXIO;
-		goto put_clk;
+		goto unprep_clk;
+	}
+
+	ret = clk_prepare(dev->gate);
+	if (ret) {
+		dev_err(&pdev->dev, "failed to prepare g2d clock gate\n");
+		goto put_clk_gate;
 	}
 
 	res = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
 	if (!res) {
 		dev_err(&pdev->dev, "failed to find IRQ\n");
 		ret = -ENXIO;
-		goto put_clk_gate;
+		goto unprep_clk_gate;
 	}
 
 	dev->irq = res->start;
@@ -764,8 +776,12 @@ alloc_ctx_cleanup:
 	vb2_dma_contig_cleanup_ctx(dev->alloc_ctx);
 rel_irq:
 	free_irq(dev->irq, dev);
+unprep_clk_gate:
+	clk_unprepare(dev->gate);
 put_clk_gate:
 	clk_put(dev->gate);
+unprep_clk:
+	clk_unprepare(dev->clk);
 put_clk:
 	clk_put(dev->clk);
 unmap_regs:
@@ -787,7 +803,9 @@ static int g2d_remove(struct platform_device *pdev)
 	v4l2_device_unregister(&dev->v4l2_dev);
 	vb2_dma_contig_cleanup_ctx(dev->alloc_ctx);
 	free_irq(dev->irq, dev);
+	clk_unprepare(dev->gate);
 	clk_put(dev->gate);
+	clk_unprepare(dev->clk);
 	clk_put(dev->clk);
 	iounmap(dev->regs);
 	release_resource(dev->res_regs);
-- 
1.7.0.4

