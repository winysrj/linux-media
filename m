Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:39194 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752279Ab2GZLU4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 26 Jul 2012 07:20:56 -0400
Received: by mail-wg0-f44.google.com with SMTP id dr13so1708544wgb.1
        for <linux-media@vger.kernel.org>; Thu, 26 Jul 2012 04:20:56 -0700 (PDT)
From: Javier Martin <javier.martin@vista-silicon.com>
To: linux-media@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, fabio.estevam@freescale.com,
	g.liakhovetski@gmx.de, sakari.ailus@maxwell.research.nokia.com,
	kyungmin.park@samsung.com, s.nawrocki@samsung.com,
	laurent.pinchart@ideasonboard.com, mchehab@infradead.org,
	linux@arm.linux.org.uk, kernel@pengutronix.de,
	Javier Martin <javier.martin@vista-silicon.com>
Subject: [PATCH 4/4] media: mx2_camera: Fix clock handling for i.MX27.
Date: Thu, 26 Jul 2012 13:20:37 +0200
Message-Id: <1343301637-19676-5-git-send-email-javier.martin@vista-silicon.com>
In-Reply-To: <1343301637-19676-1-git-send-email-javier.martin@vista-silicon.com>
References: <1343301637-19676-1-git-send-email-javier.martin@vista-silicon.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This driver wasn't converted to the new clock framework
(e038ed50a4a767add205094c035b6943e7b30140).

Signed-off-by: Javier Martin <javier.martin@vista-silicon.com>
---
 drivers/media/video/mx2_camera.c |   67 ++++++++++++++++++++++----------------
 1 file changed, 39 insertions(+), 28 deletions(-)

diff --git a/drivers/media/video/mx2_camera.c b/drivers/media/video/mx2_camera.c
index 3c38b5f..88dcae6 100644
--- a/drivers/media/video/mx2_camera.c
+++ b/drivers/media/video/mx2_camera.c
@@ -273,7 +273,7 @@ struct mx2_camera_dev {
 	struct device		*dev;
 	struct soc_camera_host	soc_host;
 	struct soc_camera_device *icd;
-	struct clk		*clk_csi, *clk_emma;
+	struct clk		*clk_csi, *clk_emma_ahb, *clk_emma_ipg;
 
 	unsigned int		irq_csi, irq_emma;
 	void __iomem		*base_csi, *base_emma;
@@ -436,7 +436,8 @@ static void mx2_camera_deactivate(struct mx2_camera_dev *pcdev)
 {
 	unsigned long flags;
 
-	clk_disable(pcdev->clk_csi);
+	if (cpu_is_mx27())
+		clk_disable_unprepare(pcdev->clk_csi);
 	writel(0, pcdev->base_csi + CSICR1);
 	if (cpu_is_mx27()) {
 		writel(0, pcdev->base_emma + PRP_CNTL);
@@ -464,9 +465,11 @@ static int mx2_camera_add_device(struct soc_camera_device *icd)
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
 
@@ -1675,23 +1678,12 @@ static int __devinit mx27_camera_emma_init(struct mx2_camera_dev *pcdev)
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
@@ -1714,6 +1706,7 @@ static int __devinit mx2_camera_probe(struct platform_device *pdev)
 
 	res_csi = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	irq_csi = platform_get_irq(pdev, 0);
+
 	if (res_csi == NULL || irq_csi < 0) {
 		dev_err(&pdev->dev, "Missing platform resources data\n");
 		err = -ENODEV;
@@ -1727,11 +1720,26 @@ static int __devinit mx2_camera_probe(struct platform_device *pdev)
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
@@ -1827,8 +1835,8 @@ exit_free_emma:
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
@@ -1840,7 +1848,11 @@ exit_iounmap:
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
@@ -1854,7 +1866,6 @@ static int __devexit mx2_camera_remove(struct platform_device *pdev)
 			struct mx2_camera_dev, soc_host);
 	struct resource *res;
 
-	clk_put(pcdev->clk_csi);
 	if (cpu_is_mx25())
 		free_irq(pcdev->irq_csi, pcdev);
 	if (cpu_is_mx27())
@@ -1867,8 +1878,8 @@ static int __devexit mx2_camera_remove(struct platform_device *pdev)
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

