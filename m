Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:55745 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1758731AbZDOMRo (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 15 Apr 2009 08:17:44 -0400
Date: Wed, 15 Apr 2009 14:17:49 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
cc: Robert Jarzmik <robert.jarzmik@free.fr>
Subject: [PATCH 2/5] soc-camera: host-driver cleanup
In-Reply-To: <Pine.LNX.4.64.0904151356480.4729@axis700.grange>
Message-ID: <Pine.LNX.4.64.0904151400490.4729@axis700.grange>
References: <Pine.LNX.4.64.0904151356480.4729@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Embed struct soc_camera_host in platform-specific per host instance objects
instead of allocating them statically in drivers, use platform_[gs]et_drvdata
consistently, use resource_size().

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 drivers/media/video/mx1_camera.c           |   21 ++++++++-----------
 drivers/media/video/mx3_camera.c           |    2 +-
 drivers/media/video/pxa_camera.c           |   29 ++++++++++++---------------
 drivers/media/video/sh_mobile_ceu_camera.c |    6 ++--
 4 files changed, 26 insertions(+), 32 deletions(-)

diff --git a/drivers/media/video/mx1_camera.c b/drivers/media/video/mx1_camera.c
index 86fab56..48dd984 100644
--- a/drivers/media/video/mx1_camera.c
+++ b/drivers/media/video/mx1_camera.c
@@ -102,6 +102,7 @@ struct mx1_buffer {
  * Interface. If anyone ever builds hardware to enable more than
  * one camera, they will have to modify this driver too */
 struct mx1_camera_dev {
+	struct soc_camera_host		soc_host;
 	struct soc_camera_device	*icd;
 	struct mx1_camera_pdata		*pdata;
 	struct mx1_buffer		*active;
@@ -633,12 +634,6 @@ static struct soc_camera_host_ops mx1_soc_camera_host_ops = {
 	.querycap	= mx1_camera_querycap,
 };
 
-/* Should be allocated dynamically too, but we have only one. */
-static struct soc_camera_host mx1_soc_camera_host = {
-	.drv_name	= DRIVER_NAME,
-	.ops		= &mx1_soc_camera_host_ops,
-};
-
 static struct fiq_handler fh = {
 	.name		= "csi_sof"
 };
@@ -673,7 +668,7 @@ static int __init mx1_camera_probe(struct platform_device *pdev)
 		goto exit_put_clk;
 	}
 
-	dev_set_drvdata(&pdev->dev, pcdev);
+	platform_set_drvdata(pdev, pcdev);
 	pcdev->res = res;
 	pcdev->clk = clk;
 
@@ -746,10 +741,12 @@ static int __init mx1_camera_probe(struct platform_device *pdev)
 	mxc_set_irq_fiq(irq, 1);
 	enable_fiq(irq);
 
-	mx1_soc_camera_host.priv	= pcdev;
-	mx1_soc_camera_host.dev.parent	= &pdev->dev;
-	mx1_soc_camera_host.nr		= pdev->id;
-	err = soc_camera_host_register(&mx1_soc_camera_host);
+	pcdev->soc_host.drv_name	= DRIVER_NAME;
+	pcdev->soc_host.ops		= &mx1_soc_camera_host_ops;
+	pcdev->soc_host.priv		= pcdev;
+	pcdev->soc_host.dev.parent	= &pdev->dev;
+	pcdev->soc_host.nr		= pdev->id;
+	err = soc_camera_host_register(&pcdev->soc_host);
 	if (err)
 		goto exit_free_irq;
 
@@ -787,7 +784,7 @@ static int __exit mx1_camera_remove(struct platform_device *pdev)
 
 	clk_put(pcdev->clk);
 
-	soc_camera_host_unregister(&mx1_soc_camera_host);
+	soc_camera_host_unregister(&pcdev->soc_host);
 
 	iounmap(pcdev->base);
 
diff --git a/drivers/media/video/mx3_camera.c b/drivers/media/video/mx3_camera.c
index c462b81..22c58dc 100644
--- a/drivers/media/video/mx3_camera.c
+++ b/drivers/media/video/mx3_camera.c
@@ -1106,7 +1106,7 @@ static int mx3_camera_probe(struct platform_device *pdev)
 		goto eclkget;
 	}
 
-	dev_set_drvdata(&pdev->dev, mx3_cam);
+	platform_set_drvdata(pdev, mx3_cam);
 
 	mx3_cam->pdata = pdev->dev.platform_data;
 	mx3_cam->platform_flags = mx3_cam->pdata->flags;
diff --git a/drivers/media/video/pxa_camera.c b/drivers/media/video/pxa_camera.c
index c639845..ad0d58c 100644
--- a/drivers/media/video/pxa_camera.c
+++ b/drivers/media/video/pxa_camera.c
@@ -202,6 +202,7 @@ struct pxa_buffer {
 };
 
 struct pxa_camera_dev {
+	struct soc_camera_host	soc_host;
 	struct device		*dev;
 	/* PXA27x is only supposed to handle one camera on its Quick Capture
 	 * interface. If anyone ever builds hardware to enable more than
@@ -1552,12 +1553,6 @@ static struct soc_camera_host_ops pxa_soc_camera_host_ops = {
 	.set_bus_param	= pxa_camera_set_bus_param,
 };
 
-/* Should be allocated dynamically too, but we have only one. */
-static struct soc_camera_host pxa_soc_camera_host = {
-	.drv_name		= PXA_CAM_DRV_NAME,
-	.ops			= &pxa_soc_camera_host_ops,
-};
-
 static int pxa_camera_probe(struct platform_device *pdev)
 {
 	struct pxa_camera_dev *pcdev;
@@ -1586,7 +1581,7 @@ static int pxa_camera_probe(struct platform_device *pdev)
 		goto exit_kfree;
 	}
 
-	dev_set_drvdata(&pdev->dev, pcdev);
+	platform_set_drvdata(pdev, pcdev);
 	pcdev->res = res;
 
 	pcdev->pdata = pdev->dev.platform_data;
@@ -1616,13 +1611,13 @@ static int pxa_camera_probe(struct platform_device *pdev)
 	/*
 	 * Request the regions.
 	 */
-	if (!request_mem_region(res->start, res->end - res->start + 1,
+	if (!request_mem_region(res->start, resource_size(res),
 				PXA_CAM_DRV_NAME)) {
 		err = -EBUSY;
 		goto exit_clk;
 	}
 
-	base = ioremap(res->start, res->end - res->start + 1);
+	base = ioremap(res->start, resource_size(res));
 	if (!base) {
 		err = -ENOMEM;
 		goto exit_release;
@@ -1670,10 +1665,12 @@ static int pxa_camera_probe(struct platform_device *pdev)
 		goto exit_free_dma;
 	}
 
-	pxa_soc_camera_host.priv	= pcdev;
-	pxa_soc_camera_host.dev.parent	= &pdev->dev;
-	pxa_soc_camera_host.nr		= pdev->id;
-	err = soc_camera_host_register(&pxa_soc_camera_host);
+	pcdev->soc_host.drv_name	= PXA_CAM_DRV_NAME;
+	pcdev->soc_host.ops		= &pxa_soc_camera_host_ops;
+	pcdev->soc_host.priv		= pcdev;
+	pcdev->soc_host.dev.parent	= &pdev->dev;
+	pcdev->soc_host.nr		= pdev->id;
+	err = soc_camera_host_register(&pcdev->soc_host);
 	if (err)
 		goto exit_free_irq;
 
@@ -1690,7 +1687,7 @@ exit_free_dma_y:
 exit_iounmap:
 	iounmap(base);
 exit_release:
-	release_mem_region(res->start, res->end - res->start + 1);
+	release_mem_region(res->start, resource_size(res));
 exit_clk:
 	clk_put(pcdev->clk);
 exit_kfree:
@@ -1711,12 +1708,12 @@ static int __devexit pxa_camera_remove(struct platform_device *pdev)
 	pxa_free_dma(pcdev->dma_chans[2]);
 	free_irq(pcdev->irq, pcdev);
 
-	soc_camera_host_unregister(&pxa_soc_camera_host);
+	soc_camera_host_unregister(&pcdev->soc_host);
 
 	iounmap(pcdev->base);
 
 	res = pcdev->res;
-	release_mem_region(res->start, res->end - res->start + 1);
+	release_mem_region(res->start, resource_size(res));
 
 	kfree(pcdev);
 
diff --git a/drivers/media/video/sh_mobile_ceu_camera.c b/drivers/media/video/sh_mobile_ceu_camera.c
index b5e37a5..8e4a8fc 100644
--- a/drivers/media/video/sh_mobile_ceu_camera.c
+++ b/drivers/media/video/sh_mobile_ceu_camera.c
@@ -840,7 +840,7 @@ static int sh_mobile_ceu_probe(struct platform_device *pdev)
 		goto exit_kfree;
 	}
 
-	base = ioremap_nocache(res->start, res->end - res->start + 1);
+	base = ioremap_nocache(res->start, resource_size(res));
 	if (!base) {
 		err = -ENXIO;
 		dev_err(&pdev->dev, "Unable to ioremap CEU registers.\n");
@@ -856,7 +856,7 @@ static int sh_mobile_ceu_probe(struct platform_device *pdev)
 	if (res) {
 		err = dma_declare_coherent_memory(&pdev->dev, res->start,
 						  res->start,
-						  (res->end - res->start) + 1,
+						  resource_size(res),
 						  DMA_MEMORY_MAP |
 						  DMA_MEMORY_EXCLUSIVE);
 		if (!err) {
@@ -865,7 +865,7 @@ static int sh_mobile_ceu_probe(struct platform_device *pdev)
 			goto exit_iounmap;
 		}
 
-		pcdev->video_limit = (res->end - res->start) + 1;
+		pcdev->video_limit = resource_size(res);
 	}
 
 	/* request irq */
-- 
1.5.4

