Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:58225 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752709Ab2GFK4M (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 6 Jul 2012 06:56:12 -0400
Received: by wibhm11 with SMTP id hm11so711803wib.1
        for <linux-media@vger.kernel.org>; Fri, 06 Jul 2012 03:56:11 -0700 (PDT)
From: Javier Martin <javier.martin@vista-silicon.com>
To: linux-media@vger.kernel.org
Cc: fabio.estevam@freescale.com, linux-arm-kernel@lists.infradead.org,
	laurent.pinchart@ideasonboard.com, g.liakhovetski@gmx.de,
	mchehab@infradead.org, kernel@pengutronix.de,
	Javier Martin <javier.martin@vista-silicon.com>
Subject: [PATCH] [v3] i.MX27: Fix emma-prp clocks in mx2_camera.c
Date: Fri,  6 Jul 2012 12:56:02 +0200
Message-Id: <1341572162-29126-1-git-send-email-javier.martin@vista-silicon.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This driver wasn't converted to the new clock changes
(clk_prepare_enable/clk_disable_unprepare). Also naming
of emma-prp related clocks for the i.MX27 was not correct.
---
Enable clocks only for i.MX27.

---
 arch/arm/mach-imx/clk-imx27.c    |    8 +++--
 drivers/media/video/mx2_camera.c |   67 ++++++++++++++++++++++----------------
 2 files changed, 44 insertions(+), 31 deletions(-)

diff --git a/arch/arm/mach-imx/clk-imx27.c b/arch/arm/mach-imx/clk-imx27.c
index 295cbd7..373c8fd 100644
--- a/arch/arm/mach-imx/clk-imx27.c
+++ b/arch/arm/mach-imx/clk-imx27.c
@@ -223,7 +223,7 @@ int __init mx27_clocks_init(unsigned long fref)
 	clk_register_clkdev(clk[per3_gate], "per", "imx-fb.0");
 	clk_register_clkdev(clk[lcdc_ipg_gate], "ipg", "imx-fb.0");
 	clk_register_clkdev(clk[lcdc_ahb_gate], "ahb", "imx-fb.0");
-	clk_register_clkdev(clk[csi_ahb_gate], NULL, "mx2-camera.0");
+	clk_register_clkdev(clk[csi_ahb_gate], "ahb", "mx2-camera.0");
 	clk_register_clkdev(clk[usb_div], "per", "fsl-usb2-udc");
 	clk_register_clkdev(clk[usb_ipg_gate], "ipg", "fsl-usb2-udc");
 	clk_register_clkdev(clk[usb_ahb_gate], "ahb", "fsl-usb2-udc");
@@ -250,8 +250,10 @@ int __init mx27_clocks_init(unsigned long fref)
 	clk_register_clkdev(clk[i2c2_ipg_gate], NULL, "imx-i2c.1");
 	clk_register_clkdev(clk[owire_ipg_gate], NULL, "mxc_w1.0");
 	clk_register_clkdev(clk[kpp_ipg_gate], NULL, "imx-keypad");
-	clk_register_clkdev(clk[emma_ahb_gate], "ahb", "imx-emma");
-	clk_register_clkdev(clk[emma_ipg_gate], "ipg", "imx-emma");
+	clk_register_clkdev(clk[emma_ahb_gate], "emma-ahb", "mx2-camera.0");
+	clk_register_clkdev(clk[emma_ipg_gate], "emma-ipg", "mx2-camera.0");
+	clk_register_clkdev(clk[emma_ahb_gate], "ahb", "m2m-emmaprp.0");
+	clk_register_clkdev(clk[emma_ipg_gate], "ipg", "m2m-emmaprp.0");
 	clk_register_clkdev(clk[iim_ipg_gate], "iim", NULL);
 	clk_register_clkdev(clk[gpio_ipg_gate], "gpio", NULL);
 	clk_register_clkdev(clk[brom_ahb_gate], "brom", NULL);
diff --git a/drivers/media/video/mx2_camera.c b/drivers/media/video/mx2_camera.c
index 41f9a25..11a9353 100644
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
@@ -389,7 +389,8 @@ static void mx2_camera_deactivate(struct mx2_camera_dev *pcdev)
 {
 	unsigned long flags;
 
-	clk_disable(pcdev->clk_csi);
+	if (cpu_is_mx27())
+		clk_disable_unprepare(pcdev->clk_csi);
 	writel(0, pcdev->base_csi + CSICR1);
 	if (cpu_is_mx27()) {
 		writel(0, pcdev->base_emma + PRP_CNTL);
@@ -417,9 +418,11 @@ static int mx2_camera_add_device(struct soc_camera_device *icd)
 	if (pcdev->icd)
 		return -EBUSY;
 
-	ret = clk_enable(pcdev->clk_csi);
-	if (ret < 0)
-		return ret;
+	if (cpu_is_mx27()) {
+		ret = clk_prepare_enable(pcdev->clk_csi);
+		if (ret < 0)
+			return ret;
+	}
 
 	csicr1 = CSICR1_MCLKEN;
 
@@ -1616,23 +1619,12 @@ static int __devinit mx27_camera_emma_init(struct mx2_camera_dev *pcdev)
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
@@ -1655,6 +1647,7 @@ static int __devinit mx2_camera_probe(struct platform_device *pdev)
 
 	res_csi = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	irq_csi = platform_get_irq(pdev, 0);
+
 	if (res_csi == NULL || irq_csi < 0) {
 		dev_err(&pdev->dev, "Missing platform resources data\n");
 		err = -ENODEV;
@@ -1668,11 +1661,26 @@ static int __devinit mx2_camera_probe(struct platform_device *pdev)
 		goto exit;
 	}
 
-	pcdev->clk_csi = clk_get(&pdev->dev, NULL);
-	if (IS_ERR(pcdev->clk_csi)) {
-		dev_err(&pdev->dev, "Could not get csi clock\n");
-		err = PTR_ERR(pcdev->clk_csi);
-		goto exit_kfree;
+	if (cpu_is_mx27()) {
+		pcdev->clk_csi = devm_clk_get(&pdev->dev, "ahb");
+		if (IS_ERR(pcdev->clk_csi)) {
+			dev_err(&pdev->dev, "Could not get csi clock\n");
+			err = PTR_ERR(pcdev->clk_csi);
+			goto exit_kfree;
+		}
+		pcdev->clk_emma_ipg = devm_clk_get(&pdev->dev, "emma-ipg");
+		if (IS_ERR(pcdev->clk_emma_ipg)) {
+			err = PTR_ERR(pcdev->clk_emma_ipg);
+			goto exit_kfree;
+		}
+		pcdev->clk_emma_ahb = devm_clk_get(&pdev->dev, "emma-ahb");
+		if (IS_ERR(pcdev->clk_emma_ahb)) {
+			err = PTR_ERR(pcdev->clk_emma_ahb);
+			goto exit_kfree;
+		}
+		clk_prepare_enable(pcdev->clk_csi);
+		clk_prepare_enable(pcdev->clk_emma_ipg);
+		clk_prepare_enable(pcdev->clk_emma_ahb);
 	}
 
 	pcdev->res_csi = res_csi;
@@ -1768,8 +1776,8 @@ exit_free_emma:
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
@@ -1781,7 +1789,11 @@ exit_iounmap:
 exit_release:
 	release_mem_region(res_csi->start, resource_size(res_csi));
 exit_dma_free:
-	clk_put(pcdev->clk_csi);
+	if (cpu_is_mx27()) {
+		clk_disable_unprepare(pcdev->clk_emma_ipg);
+		clk_disable_unprepare(pcdev->clk_emma_ahb);
+		clk_disable_unprepare(pcdev->clk_csi);
+	}
 exit_kfree:
 	kfree(pcdev);
 exit:
@@ -1795,7 +1807,6 @@ static int __devexit mx2_camera_remove(struct platform_device *pdev)
 			struct mx2_camera_dev, soc_host);
 	struct resource *res;
 
-	clk_put(pcdev->clk_csi);
 	if (cpu_is_mx25())
 		free_irq(pcdev->irq_csi, pcdev);
 	if (cpu_is_mx27())
@@ -1808,8 +1819,8 @@ static int __devexit mx2_camera_remove(struct platform_device *pdev)
 	iounmap(pcdev->base_csi);
 
 	if (cpu_is_mx27()) {
-		clk_disable(pcdev->clk_emma);
-		clk_put(pcdev->clk_emma);
+		clk_disable_unprepare(pcdev->clk_emma_ipg);
+		clk_disable_unprepare(pcdev->clk_emma_ahb);
 		iounmap(pcdev->base_emma);
 		res = pcdev->res_emma;
 		release_mem_region(res->start, resource_size(res));
-- 
1.7.9.5

