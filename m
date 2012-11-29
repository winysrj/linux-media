Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.9]:53830 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751872Ab2K2JjD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 29 Nov 2012 04:39:03 -0500
Received: from 6a.grange (6a.grange [192.168.1.11])
	by axis700.grange (Postfix) with ESMTPS id AA6E340B99
	for <linux-media@vger.kernel.org>; Thu, 29 Nov 2012 10:39:00 +0100 (CET)
Received: from lyakh by 6a.grange with local (Exim 4.72)
	(envelope-from <g.liakhovetski@gmx.de>)
	id 1Te0aB-0006l6-Ff
	for linux-media@vger.kernel.org; Thu, 29 Nov 2012 10:38:59 +0100
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: linux-media@vger.kernel.org
Subject: [PATCH 1/2] media: sh_mobile_csi2: use managed memory and resource allocations
Date: Thu, 29 Nov 2012 10:38:58 +0100
Message-Id: <1354181939-25952-1-git-send-email-g.liakhovetski@gmx.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Use managed allocations to simplify error handling and clean up paths.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 drivers/media/platform/soc_camera/sh_mobile_csi2.c |   23 +++----------------
 1 files changed, 4 insertions(+), 19 deletions(-)

diff --git a/drivers/media/platform/soc_camera/sh_mobile_csi2.c b/drivers/media/platform/soc_camera/sh_mobile_csi2.c
index 0528650..c573be7 100644
--- a/drivers/media/platform/soc_camera/sh_mobile_csi2.c
+++ b/drivers/media/platform/soc_camera/sh_mobile_csi2.c
@@ -318,23 +318,16 @@ static __devinit int sh_csi2_probe(struct platform_device *pdev)
 		return -EINVAL;
 	}
 
-	priv = kzalloc(sizeof(struct sh_csi2), GFP_KERNEL);
+	priv = devm_kzalloc(&pdev->dev, sizeof(struct sh_csi2), GFP_KERNEL);
 	if (!priv)
 		return -ENOMEM;
 
 	priv->irq = irq;
 
-	if (!request_mem_region(res->start, resource_size(res), pdev->name)) {
-		dev_err(&pdev->dev, "CSI2 register region already claimed\n");
-		ret = -EBUSY;
-		goto ereqreg;
-	}
-
-	priv->base = ioremap(res->start, resource_size(res));
+	priv->base = devm_request_and_ioremap(&pdev->dev, res);
 	if (!priv->base) {
-		ret = -ENXIO;
 		dev_err(&pdev->dev, "Unable to ioremap CSI2 registers.\n");
-		goto eremap;
+		return -ENXIO;
 	}
 
 	priv->pdev = pdev;
@@ -357,11 +350,7 @@ static __devinit int sh_csi2_probe(struct platform_device *pdev)
 	return 0;
 
 esdreg:
-	iounmap(priv->base);
-eremap:
-	release_mem_region(res->start, resource_size(res));
-ereqreg:
-	kfree(priv);
+	platform_set_drvdata(pdev, NULL);
 
 	return ret;
 }
@@ -369,14 +358,10 @@ ereqreg:
 static __devexit int sh_csi2_remove(struct platform_device *pdev)
 {
 	struct sh_csi2 *priv = platform_get_drvdata(pdev);
-	struct resource *res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 
 	v4l2_device_unregister_subdev(&priv->subdev);
 	pm_runtime_disable(&pdev->dev);
-	iounmap(priv->base);
-	release_mem_region(res->start, resource_size(res));
 	platform_set_drvdata(pdev, NULL);
-	kfree(priv);
 
 	return 0;
 }
-- 
1.7.2.5

