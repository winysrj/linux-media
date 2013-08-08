Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.186]:56382 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934262Ab3HHO4Q (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 8 Aug 2013 10:56:16 -0400
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: linux-media@vger.kernel.org
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: [PATCH 2/6] V4L2: mx3_camera: convert to managed resource allocation
Date: Thu,  8 Aug 2013 16:52:33 +0200
Message-Id: <1375973557-23333-3-git-send-email-g.liakhovetski@gmx.de>
In-Reply-To: <1375973557-23333-1-git-send-email-g.liakhovetski@gmx.de>
References: <1375973557-23333-1-git-send-email-g.liakhovetski@gmx.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Use devm_* resource allocators to simplify the driver's probe and clean up
paths.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 drivers/media/platform/soc_camera/mx3_camera.c |   47 +++++-------------------
 1 files changed, 10 insertions(+), 37 deletions(-)

diff --git a/drivers/media/platform/soc_camera/mx3_camera.c b/drivers/media/platform/soc_camera/mx3_camera.c
index 1047e3e..e526096 100644
--- a/drivers/media/platform/soc_camera/mx3_camera.c
+++ b/drivers/media/platform/soc_camera/mx3_camera.c
@@ -1151,23 +1151,19 @@ static int mx3_camera_probe(struct platform_device *pdev)
 	struct soc_camera_host *soc_host;
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!res) {
-		err = -ENODEV;
-		goto egetres;
-	}
+	base = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(base))
+		return PTR_ERR(base);
 
-	mx3_cam = vzalloc(sizeof(*mx3_cam));
+	mx3_cam = devm_kzalloc(&pdev->dev, sizeof(*mx3_cam), GFP_KERNEL);
 	if (!mx3_cam) {
 		dev_err(&pdev->dev, "Could not allocate mx3 camera object\n");
-		err = -ENOMEM;
-		goto ealloc;
+		return -ENOMEM;
 	}
 
-	mx3_cam->clk = clk_get(&pdev->dev, NULL);
-	if (IS_ERR(mx3_cam->clk)) {
-		err = PTR_ERR(mx3_cam->clk);
-		goto eclkget;
-	}
+	mx3_cam->clk = devm_clk_get(&pdev->dev, NULL);
+	if (IS_ERR(mx3_cam->clk))
+		return PTR_ERR(mx3_cam->clk);
 
 	mx3_cam->pdata = pdev->dev.platform_data;
 	mx3_cam->platform_flags = mx3_cam->pdata->flags;
@@ -1201,13 +1197,6 @@ static int mx3_camera_probe(struct platform_device *pdev)
 	INIT_LIST_HEAD(&mx3_cam->capture);
 	spin_lock_init(&mx3_cam->lock);
 
-	base = ioremap(res->start, resource_size(res));
-	if (!base) {
-		pr_err("Couldn't map %x@%x\n", resource_size(res), res->start);
-		err = -ENOMEM;
-		goto eioremap;
-	}
-
 	mx3_cam->base	= base;
 
 	soc_host		= &mx3_cam->soc_host;
@@ -1218,10 +1207,8 @@ static int mx3_camera_probe(struct platform_device *pdev)
 	soc_host->nr		= pdev->id;
 
 	mx3_cam->alloc_ctx = vb2_dma_contig_init_ctx(&pdev->dev);
-	if (IS_ERR(mx3_cam->alloc_ctx)) {
-		err = PTR_ERR(mx3_cam->alloc_ctx);
-		goto eallocctx;
-	}
+	if (IS_ERR(mx3_cam->alloc_ctx))
+		return PTR_ERR(mx3_cam->alloc_ctx);
 
 	err = soc_camera_host_register(soc_host);
 	if (err)
@@ -1234,14 +1221,6 @@ static int mx3_camera_probe(struct platform_device *pdev)
 
 ecamhostreg:
 	vb2_dma_contig_cleanup_ctx(mx3_cam->alloc_ctx);
-eallocctx:
-	iounmap(base);
-eioremap:
-	clk_put(mx3_cam->clk);
-eclkget:
-	vfree(mx3_cam);
-ealloc:
-egetres:
 	return err;
 }
 
@@ -1251,12 +1230,8 @@ static int mx3_camera_remove(struct platform_device *pdev)
 	struct mx3_camera_dev *mx3_cam = container_of(soc_host,
 					struct mx3_camera_dev, soc_host);
 
-	clk_put(mx3_cam->clk);
-
 	soc_camera_host_unregister(soc_host);
 
-	iounmap(mx3_cam->base);
-
 	/*
 	 * The channel has either not been allocated,
 	 * or should have been released
@@ -1266,8 +1241,6 @@ static int mx3_camera_remove(struct platform_device *pdev)
 
 	vb2_dma_contig_cleanup_ctx(mx3_cam->alloc_ctx);
 
-	vfree(mx3_cam);
-
 	dmaengine_put();
 
 	return 0;
-- 
1.7.2.5

