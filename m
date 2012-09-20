Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:49998 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752991Ab2ITGrl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 20 Sep 2012 02:47:41 -0400
Received: by mail-pb0-f46.google.com with SMTP id rr13so4370522pbb.19
        for <linux-media@vger.kernel.org>; Wed, 19 Sep 2012 23:47:41 -0700 (PDT)
From: Shawn Guo <shawn.guo@linaro.org>
To: linux-arm-kernel@lists.infradead.org
Cc: Sascha Hauer <s.hauer@pengutronix.de>,
	Javier Martin <javier.martin@vista-silicon.com>,
	Rob Herring <rob.herring@calxeda.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Shawn Guo <shawn.guo@linaro.org>, linux-media@vger.kernel.org
Subject: [PATCH v2 26/34] media: mx2_camera: use managed functions to clean up code
Date: Thu, 20 Sep 2012 14:45:39 +0800
Message-Id: <1348123547-31082-27-git-send-email-shawn.guo@linaro.org>
In-Reply-To: <1348123547-31082-1-git-send-email-shawn.guo@linaro.org>
References: <1348123547-31082-1-git-send-email-shawn.guo@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Use managed functions to clean up the error handling code and function
mx2_camera_remove().  Along with the change, a few variables get removed
from struct mx2_camera_dev.

Signed-off-by: Shawn Guo <shawn.guo@linaro.org>
Acked-by: Sascha Hauer <s.hauer@pengutronix.de>
Acked-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Tested-by: Javier Martin <javier.martin@vista-silicon.com>
Cc: linux-media@vger.kernel.org
---
 drivers/media/video/mx2_camera.c |  149 ++++++++++++--------------------------
 1 file changed, 45 insertions(+), 104 deletions(-)

diff --git a/drivers/media/video/mx2_camera.c b/drivers/media/video/mx2_camera.c
index 89c7e28..9bb9e8c 100644
--- a/drivers/media/video/mx2_camera.c
+++ b/drivers/media/video/mx2_camera.c
@@ -274,12 +274,9 @@ struct mx2_camera_dev {
 	struct soc_camera_device *icd;
 	struct clk		*clk_csi, *clk_emma_ahb, *clk_emma_ipg;
 
-	unsigned int		irq_csi, irq_emma;
 	void __iomem		*base_csi, *base_emma;
-	unsigned long		base_dma;
 
 	struct mx2_camera_platform_data *pdata;
-	struct resource		*res_csi, *res_emma;
 	unsigned long		platform_flags;
 
 	struct list_head	capture;
@@ -1607,64 +1604,59 @@ static irqreturn_t mx27_camera_emma_irq(int irq_emma, void *data)
 	return IRQ_HANDLED;
 }
 
-static int __devinit mx27_camera_emma_init(struct mx2_camera_dev *pcdev)
+static int __devinit mx27_camera_emma_init(struct platform_device *pdev)
 {
-	struct resource *res_emma = pcdev->res_emma;
+	struct mx2_camera_dev *pcdev = platform_get_drvdata(pdev);
+	struct resource *res_emma;
+	int irq_emma;
 	int err = 0;
 
-	if (!request_mem_region(res_emma->start, resource_size(res_emma),
-				MX2_CAM_DRV_NAME)) {
-		err = -EBUSY;
+	res_emma = platform_get_resource(pdev, IORESOURCE_MEM, 1);
+	irq_emma = platform_get_irq(pdev, 1);
+	if (!res_emma || !irq_emma) {
+		dev_err(pcdev->dev, "no EMMA resources\n");
 		goto out;
 	}
 
-	pcdev->base_emma = ioremap(res_emma->start, resource_size(res_emma));
+	pcdev->base_emma = devm_request_and_ioremap(pcdev->dev, res_emma);
 	if (!pcdev->base_emma) {
-		err = -ENOMEM;
-		goto exit_release;
+		err = -EADDRNOTAVAIL;
+		goto out;
 	}
 
-	err = request_irq(pcdev->irq_emma, mx27_camera_emma_irq, 0,
-			MX2_CAM_DRV_NAME, pcdev);
+	err = devm_request_irq(pcdev->dev, irq_emma, mx27_camera_emma_irq, 0,
+			       MX2_CAM_DRV_NAME, pcdev);
 	if (err) {
 		dev_err(pcdev->dev, "Camera EMMA interrupt register failed \n");
-		goto exit_iounmap;
+		goto out;
 	}
 
-	pcdev->clk_emma_ipg = clk_get(pcdev->dev, "emma-ipg");
+	pcdev->clk_emma_ipg = devm_clk_get(pcdev->dev, "emma-ipg");
 	if (IS_ERR(pcdev->clk_emma_ipg)) {
 		err = PTR_ERR(pcdev->clk_emma_ipg);
-		goto exit_free_irq;
+		goto out;
 	}
 
 	clk_prepare_enable(pcdev->clk_emma_ipg);
 
-	pcdev->clk_emma_ahb = clk_get(pcdev->dev, "emma-ahb");
+	pcdev->clk_emma_ahb = devm_clk_get(pcdev->dev, "emma-ahb");
 	if (IS_ERR(pcdev->clk_emma_ahb)) {
 		err = PTR_ERR(pcdev->clk_emma_ahb);
-		goto exit_clk_emma_ipg_put;
+		goto exit_clk_emma_ipg;
 	}
 
 	clk_prepare_enable(pcdev->clk_emma_ahb);
 
 	err = mx27_camera_emma_prp_reset(pcdev);
 	if (err)
-		goto exit_clk_emma_ahb_put;
+		goto exit_clk_emma_ahb;
 
 	return err;
 
-exit_clk_emma_ahb_put:
+exit_clk_emma_ahb:
 	clk_disable_unprepare(pcdev->clk_emma_ahb);
-	clk_put(pcdev->clk_emma_ahb);
-exit_clk_emma_ipg_put:
+exit_clk_emma_ipg:
 	clk_disable_unprepare(pcdev->clk_emma_ipg);
-	clk_put(pcdev->clk_emma_ipg);
-exit_free_irq:
-	free_irq(pcdev->irq_emma, pcdev);
-exit_iounmap:
-	iounmap(pcdev->base_emma);
-exit_release:
-	release_mem_region(res_emma->start, resource_size(res_emma));
 out:
 	return err;
 }
@@ -1672,9 +1664,8 @@ out:
 static int __devinit mx2_camera_probe(struct platform_device *pdev)
 {
 	struct mx2_camera_dev *pcdev;
-	struct resource *res_csi, *res_emma;
-	void __iomem *base_csi;
-	int irq_csi, irq_emma;
+	struct resource *res_csi;
+	int irq_csi;
 	int err = 0;
 
 	dev_dbg(&pdev->dev, "initialising\n");
@@ -1687,21 +1678,20 @@ static int __devinit mx2_camera_probe(struct platform_device *pdev)
 		goto exit;
 	}
 
-	pcdev = kzalloc(sizeof(*pcdev), GFP_KERNEL);
+	pcdev = devm_kzalloc(&pdev->dev, sizeof(*pcdev), GFP_KERNEL);
 	if (!pcdev) {
 		dev_err(&pdev->dev, "Could not allocate pcdev\n");
 		err = -ENOMEM;
 		goto exit;
 	}
 
-	pcdev->clk_csi = clk_get(&pdev->dev, "ahb");
+	pcdev->clk_csi = devm_clk_get(&pdev->dev, "ahb");
 	if (IS_ERR(pcdev->clk_csi)) {
 		dev_err(&pdev->dev, "Could not get csi clock\n");
 		err = PTR_ERR(pcdev->clk_csi);
-		goto exit_kfree;
+		goto exit;
 	}
 
-	pcdev->res_csi = res_csi;
 	pcdev->pdata = pdev->dev.platform_data;
 	if (pcdev->pdata) {
 		long rate;
@@ -1711,11 +1701,11 @@ static int __devinit mx2_camera_probe(struct platform_device *pdev)
 		rate = clk_round_rate(pcdev->clk_csi, pcdev->pdata->clk * 2);
 		if (rate <= 0) {
 			err = -ENODEV;
-			goto exit_dma_free;
+			goto exit;
 		}
 		err = clk_set_rate(pcdev->clk_csi, rate);
 		if (err < 0)
-			goto exit_dma_free;
+			goto exit;
 	}
 
 	INIT_LIST_HEAD(&pcdev->capture);
@@ -1723,50 +1713,36 @@ static int __devinit mx2_camera_probe(struct platform_device *pdev)
 	INIT_LIST_HEAD(&pcdev->discard);
 	spin_lock_init(&pcdev->lock);
 
-	/*
-	 * Request the regions.
-	 */
-	if (!request_mem_region(res_csi->start, resource_size(res_csi),
-				MX2_CAM_DRV_NAME)) {
-		err = -EBUSY;
-		goto exit_dma_free;
+	pcdev->base_csi = devm_request_and_ioremap(&pdev->dev, res_csi);
+	if (!pcdev->base_csi) {
+		err = -EADDRNOTAVAIL;
+		goto exit;
 	}
 
-	base_csi = ioremap(res_csi->start, resource_size(res_csi));
-	if (!base_csi) {
-		err = -ENOMEM;
-		goto exit_release;
-	}
-	pcdev->irq_csi = irq_csi;
-	pcdev->base_csi = base_csi;
-	pcdev->base_dma = res_csi->start;
 	pcdev->dev = &pdev->dev;
+	platform_set_drvdata(pdev, pcdev);
 
 	if (cpu_is_mx25()) {
-		err = request_irq(pcdev->irq_csi, mx25_camera_irq, 0,
-				MX2_CAM_DRV_NAME, pcdev);
+		err = devm_request_irq(&pdev->dev, irq_csi, mx25_camera_irq, 0,
+				       MX2_CAM_DRV_NAME, pcdev);
 		if (err) {
 			dev_err(pcdev->dev, "Camera interrupt register failed \n");
-			goto exit_iounmap;
+			goto exit;
 		}
 	}
 
 	if (cpu_is_mx27()) {
-		/* EMMA support */
-		res_emma = platform_get_resource(pdev, IORESOURCE_MEM, 1);
-		irq_emma = platform_get_irq(pdev, 1);
-
-		if (!res_emma || !irq_emma) {
-			dev_err(&pdev->dev, "no EMMA resources\n");
-			goto exit_free_irq;
-		}
-
-		pcdev->res_emma = res_emma;
-		pcdev->irq_emma = irq_emma;
-		if (mx27_camera_emma_init(pcdev))
-			goto exit_free_irq;
+		err = mx27_camera_emma_init(pdev);
+		if (err)
+			goto exit;
 	}
 
+	/*
+	 * We're done with drvdata here.  Clear the pointer so that
+	 * v4l2 core can start using drvdata on its purpose.
+	 */
+	platform_set_drvdata(pdev, NULL);
+
 	pcdev->soc_host.drv_name	= MX2_CAM_DRV_NAME,
 	pcdev->soc_host.ops		= &mx2_soc_camera_host_ops,
 	pcdev->soc_host.priv		= pcdev;
@@ -1793,25 +1769,9 @@ exit_free_emma:
 	vb2_dma_contig_cleanup_ctx(pcdev->alloc_ctx);
 eallocctx:
 	if (cpu_is_mx27()) {
-		free_irq(pcdev->irq_emma, pcdev);
 		clk_disable_unprepare(pcdev->clk_emma_ipg);
-		clk_put(pcdev->clk_emma_ipg);
 		clk_disable_unprepare(pcdev->clk_emma_ahb);
-		clk_put(pcdev->clk_emma_ahb);
-		iounmap(pcdev->base_emma);
-		release_mem_region(pcdev->res_emma->start, resource_size(pcdev->res_emma));
 	}
-exit_free_irq:
-	if (cpu_is_mx25())
-		free_irq(pcdev->irq_csi, pcdev);
-exit_iounmap:
-	iounmap(base_csi);
-exit_release:
-	release_mem_region(res_csi->start, resource_size(res_csi));
-exit_dma_free:
-	clk_put(pcdev->clk_csi);
-exit_kfree:
-	kfree(pcdev);
 exit:
 	return err;
 }
@@ -1821,35 +1781,16 @@ static int __devexit mx2_camera_remove(struct platform_device *pdev)
 	struct soc_camera_host *soc_host = to_soc_camera_host(&pdev->dev);
 	struct mx2_camera_dev *pcdev = container_of(soc_host,
 			struct mx2_camera_dev, soc_host);
-	struct resource *res;
-
-	clk_put(pcdev->clk_csi);
-	if (cpu_is_mx25())
-		free_irq(pcdev->irq_csi, pcdev);
-	if (cpu_is_mx27())
-		free_irq(pcdev->irq_emma, pcdev);
 
 	soc_camera_host_unregister(&pcdev->soc_host);
 
 	vb2_dma_contig_cleanup_ctx(pcdev->alloc_ctx);
 
-	iounmap(pcdev->base_csi);
-
 	if (cpu_is_mx27()) {
 		clk_disable_unprepare(pcdev->clk_emma_ipg);
-		clk_put(pcdev->clk_emma_ipg);
 		clk_disable_unprepare(pcdev->clk_emma_ahb);
-		clk_put(pcdev->clk_emma_ahb);
-		iounmap(pcdev->base_emma);
-		res = pcdev->res_emma;
-		release_mem_region(res->start, resource_size(res));
 	}
 
-	res = pcdev->res_csi;
-	release_mem_region(res->start, resource_size(res));
-
-	kfree(pcdev);
-
 	dev_info(&pdev->dev, "MX2 Camera driver unloaded\n");
 
 	return 0;
-- 
1.7.9.5

