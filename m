Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:45768 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932307Ab2GFGcE (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 6 Jul 2012 02:32:04 -0400
Received: by wibhr14 with SMTP id hr14so465106wib.1
        for <linux-media@vger.kernel.org>; Thu, 05 Jul 2012 23:32:02 -0700 (PDT)
From: Javier Martin <javier.martin@vista-silicon.com>
To: linux-media@vger.kernel.org
Cc: fabio.estevam@freescale.com, laurent.pinchart@ideasonboard.com,
	g.liakhovetski@gmx.de, mchehab@infradead.org, kernel@pengutronix.de
Subject: media: i.MX27: Fix emma-prp clocks in mx2_camera.c
Date: Fri,  6 Jul 2012 08:31:49 +0200
Message-Id: <1341556309-2934-1-git-send-email-javier.martin@vista-silicon.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This driver wasn't converted to the new clock changes
(clk_prepare_enable/clk_disable_unprepare). Also naming
of emma-prp related clocks for the i.MX27 was not correct.

Signed-of-by: Javier Martin <javier.martin@vista-silicon.com>
---
diff --git a/arch/arm/mach-imx/clk-imx27.c b/arch/arm/mach-imx/clk-imx27.c
index 295cbd7..e8a6016 100644
--- a/arch/arm/mach-imx/clk-imx27.c
+++ b/arch/arm/mach-imx/clk-imx27.c
@@ -250,8 +250,10 @@ int __init mx27_clocks_init(unsigned long fref)
 	clk_register_clkdev(clk[i2c2_ipg_gate], NULL, "imx-i2c.1");
 	clk_register_clkdev(clk[owire_ipg_gate], NULL, "mxc_w1.0");
 	clk_register_clkdev(clk[kpp_ipg_gate], NULL, "imx-keypad");
-	clk_register_clkdev(clk[emma_ahb_gate], "ahb", "imx-emma");
-	clk_register_clkdev(clk[emma_ipg_gate], "ipg", "imx-emma");
+	clk_register_clkdev(clk[emma_ahb_gate], "ahb", "mx2-camera.0");
+	clk_register_clkdev(clk[emma_ipg_gate], "ipg", "mx2-camera.0");
+	clk_register_clkdev(clk[emma_ahb_gate], "ahb", "m2m-emmaprp.0");
+	clk_register_clkdev(clk[emma_ipg_gate], "ipg", "m2m-emmaprp.0");
 	clk_register_clkdev(clk[iim_ipg_gate], "iim", NULL);
 	clk_register_clkdev(clk[gpio_ipg_gate], "gpio", NULL);
 	clk_register_clkdev(clk[brom_ahb_gate], "brom", NULL);
diff --git a/drivers/media/video/mx2_camera.c b/drivers/media/video/mx2_camera.c
index 41f9a25..95154e8 100644
--- a/drivers/media/video/mx2_camera.c
+++ b/drivers/media/video/mx2_camera.c
@@ -270,7 +270,7 @@ struct mx2_camera_dev {
 	struct device		*dev;
 	struct soc_camera_host	soc_host;
 	struct soc_camera_device *icd;
-	struct clk		*clk_csi, *clk_emma;
+	struct clk		*clk_csi, *clk_emma_ahb, *clk_emma_ipg;
 
 	unsigned int		irq_csi, irq_emma;
 	void __iomem		*base_csi, *base_emma;
@@ -417,7 +417,7 @@ static int mx2_camera_add_device(struct soc_camera_device *icd)
 	if (pcdev->icd)
 		return -EBUSY;
 
-	ret = clk_enable(pcdev->clk_csi);
+	ret = clk_prepare_enable(pcdev->clk_csi);
 	if (ret < 0)
 		return ret;
 
@@ -1616,23 +1616,12 @@ static int __devinit mx27_camera_emma_init(struct mx2_camera_dev *pcdev)
 		goto exit_iounmap;
 	}
 
-	pcdev->clk_emma = clk_get(NULL, "emma");
-	if (IS_ERR(pcdev->clk_emma)) {
-		err = PTR_ERR(pcdev->clk_emma);
-		goto exit_free_irq;
-	}
-
-	clk_enable(pcdev->clk_emma);
-
 	err = mx27_camera_emma_prp_reset(pcdev);
 	if (err)
-		goto exit_clk_emma_put;
+		goto exit_free_irq;
 
 	return err;
 
-exit_clk_emma_put:
-	clk_disable(pcdev->clk_emma);
-	clk_put(pcdev->clk_emma);
 exit_free_irq:
 	free_irq(pcdev->irq_emma, pcdev);
 exit_iounmap:
@@ -1655,6 +1644,7 @@ static int __devinit mx2_camera_probe(struct platform_device *pdev)
 
 	res_csi = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	irq_csi = platform_get_irq(pdev, 0);
+
 	if (res_csi == NULL || irq_csi < 0) {
 		dev_err(&pdev->dev, "Missing platform resources data\n");
 		err = -ENODEV;
@@ -1668,12 +1658,26 @@ static int __devinit mx2_camera_probe(struct platform_device *pdev)
 		goto exit;
 	}
 
-	pcdev->clk_csi = clk_get(&pdev->dev, NULL);
+	pcdev->clk_csi = devm_clk_get(&pdev->dev, NULL);
 	if (IS_ERR(pcdev->clk_csi)) {
 		dev_err(&pdev->dev, "Could not get csi clock\n");
 		err = PTR_ERR(pcdev->clk_csi);
 		goto exit_kfree;
 	}
+	pcdev->clk_emma_ipg = devm_clk_get(&pdev->dev, "ipg");
+	if (IS_ERR(pcdev->clk_emma_ipg)) {
+		err = PTR_ERR(pcdev->clk_emma_ipg);
+		goto exit_kfree;
+	}
+	pcdev->clk_emma_ahb = devm_clk_get(&pdev->dev, "ahb");
+	if (IS_ERR(pcdev->clk_emma_ahb)) {
+		err = PTR_ERR(pcdev->clk_emma_ahb);
+		goto exit_kfree;
+	}
+
+	clk_prepare_enable(pcdev->clk_csi);
+	clk_prepare_enable(pcdev->clk_emma_ipg);
+	clk_prepare_enable(pcdev->clk_emma_ahb);
 
 	pcdev->res_csi = res_csi;
 	pcdev->pdata = pdev->dev.platform_data;
@@ -1768,8 +1772,8 @@ exit_free_emma:
 eallocctx:
 	if (cpu_is_mx27()) {
 		free_irq(pcdev->irq_emma, pcdev);
-		clk_disable(pcdev->clk_emma);
-		clk_put(pcdev->clk_emma);
+		clk_disable_unprepare(pcdev->clk_emma_ipg);
+		clk_disable_unprepare(pcdev->clk_emma_ahb);
 		iounmap(pcdev->base_emma);
 		release_mem_region(pcdev->res_emma->start, resource_size(pcdev->res_emma));
 	}
@@ -1781,7 +1785,9 @@ exit_iounmap:
 exit_release:
 	release_mem_region(res_csi->start, resource_size(res_csi));
 exit_dma_free:
-	clk_put(pcdev->clk_csi);
+	clk_disable_unprepare(pcdev->clk_emma_ipg);
+	clk_disable_unprepare(pcdev->clk_emma_ahb);
+	clk_disable_unprepare(pcdev->clk_csi);
 exit_kfree:
 	kfree(pcdev);
 exit:
@@ -1795,7 +1801,6 @@ static int __devexit mx2_camera_remove(struct platform_device *pdev)
 			struct mx2_camera_dev, soc_host);
 	struct resource *res;
 
-	clk_put(pcdev->clk_csi);
 	if (cpu_is_mx25())
 		free_irq(pcdev->irq_csi, pcdev);
 	if (cpu_is_mx27())
@@ -1808,8 +1813,8 @@ static int __devexit mx2_camera_remove(struct platform_device *pdev)
 	iounmap(pcdev->base_csi);
 
 	if (cpu_is_mx27()) {
-		clk_disable(pcdev->clk_emma);
-		clk_put(pcdev->clk_emma);
+		clk_disable_unprepare(pcdev->clk_emma_ipg);
+		clk_disable_unprepare(pcdev->clk_emma_ahb);
 		iounmap(pcdev->base_emma);
 		res = pcdev->res_emma;
 		release_mem_region(res->start, resource_size(res));
