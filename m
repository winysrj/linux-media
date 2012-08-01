Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:41269 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753388Ab2HAJQ7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 1 Aug 2012 05:16:59 -0400
Received: by wibhm11 with SMTP id hm11so3775829wib.1
        for <linux-media@vger.kernel.org>; Wed, 01 Aug 2012 02:16:58 -0700 (PDT)
From: Javier Martin <javier.martin@vista-silicon.com>
To: linux-media@vger.kernel.org
Cc: g.liakhovetski@gmx.de, mchehab@infradead.org,
	laurent.pinchart@ideasonboard.com, fabio.estevam@freescale.com,
	s.hauer@pengutronix.de,
	Javier Martin <javier.martin@vista-silicon.com>
Subject: [PATCH v2] media: mx2_camera: Fix clock handling for i.MX27.
Date: Wed,  1 Aug 2012 11:16:44 +0200
Message-Id: <1343812604-21359-1-git-send-email-javier.martin@vista-silicon.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This driver wasn't converted to the new clock framework
(e038ed50a4a767add205094c035b6943e7b30140).

Signed-off-by: Javier Martin <javier.martin@vista-silicon.com>
---
 drivers/media/video/mx2_camera.c |   47 +++++++++++++++++++++++++-------------
 1 file changed, 31 insertions(+), 16 deletions(-)

diff --git a/drivers/media/video/mx2_camera.c b/drivers/media/video/mx2_camera.c
index 3c38b5f..6de7c48 100644
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
@@ -436,7 +436,7 @@ static void mx2_camera_deactivate(struct mx2_camera_dev *pcdev)
 {
 	unsigned long flags;
 
-	clk_disable(pcdev->clk_csi);
+	clk_disable_unprepare(pcdev->clk_csi);
 	writel(0, pcdev->base_csi + CSICR1);
 	if (cpu_is_mx27()) {
 		writel(0, pcdev->base_emma + PRP_CNTL);
@@ -464,7 +464,7 @@ static int mx2_camera_add_device(struct soc_camera_device *icd)
 	if (pcdev->icd)
 		return -EBUSY;
 
-	ret = clk_enable(pcdev->clk_csi);
+	ret = clk_prepare_enable(pcdev->clk_csi);
 	if (ret < 0)
 		return ret;
 
@@ -1675,23 +1675,34 @@ static int __devinit mx27_camera_emma_init(struct mx2_camera_dev *pcdev)
 		goto exit_iounmap;
 	}
 
-	pcdev->clk_emma = clk_get(NULL, "emma");
-	if (IS_ERR(pcdev->clk_emma)) {
-		err = PTR_ERR(pcdev->clk_emma);
+	pcdev->clk_emma_ipg = clk_get(pcdev->dev, "emma-ipg");
+	if (IS_ERR(pcdev->clk_emma_ipg)) {
+		err = PTR_ERR(pcdev->clk_emma_ipg);
 		goto exit_free_irq;
 	}
 
-	clk_enable(pcdev->clk_emma);
+	clk_prepare_enable(pcdev->clk_emma_ipg);
+
+	pcdev->clk_emma_ahb = clk_get(pcdev->dev, "emma-ahb");
+	if (IS_ERR(pcdev->clk_emma_ahb)) {
+		err = PTR_ERR(pcdev->clk_emma_ahb);
+		goto exit_clk_emma_ipg_put;
+	}
+
+	clk_prepare_enable(pcdev->clk_emma_ahb);
 
 	err = mx27_camera_emma_prp_reset(pcdev);
 	if (err)
-		goto exit_clk_emma_put;
+		goto exit_clk_emma_ahb_put;
 
 	return err;
 
-exit_clk_emma_put:
-	clk_disable(pcdev->clk_emma);
-	clk_put(pcdev->clk_emma);
+exit_clk_emma_ahb_put:
+	clk_disable_unprepare(pcdev->clk_emma_ahb);
+	clk_put(pcdev->clk_emma_ahb);
+exit_clk_emma_ipg_put:
+	clk_disable_unprepare(pcdev->clk_emma_ipg);
+	clk_put(pcdev->clk_emma_ipg);
 exit_free_irq:
 	free_irq(pcdev->irq_emma, pcdev);
 exit_iounmap:
@@ -1727,7 +1738,7 @@ static int __devinit mx2_camera_probe(struct platform_device *pdev)
 		goto exit;
 	}
 
-	pcdev->clk_csi = clk_get(&pdev->dev, NULL);
+	pcdev->clk_csi = clk_get(&pdev->dev, "ahb");
 	if (IS_ERR(pcdev->clk_csi)) {
 		dev_err(&pdev->dev, "Could not get csi clock\n");
 		err = PTR_ERR(pcdev->clk_csi);
@@ -1827,8 +1838,10 @@ exit_free_emma:
 eallocctx:
 	if (cpu_is_mx27()) {
 		free_irq(pcdev->irq_emma, pcdev);
-		clk_disable(pcdev->clk_emma);
-		clk_put(pcdev->clk_emma);
+		clk_disable_unprepare(pcdev->clk_emma_ipg);
+		clk_put(pcdev->clk_emma_ipg);
+		clk_disable_unprepare(pcdev->clk_emma_ahb);
+		clk_put(pcdev->clk_emma_ahb);
 		iounmap(pcdev->base_emma);
 		release_mem_region(pcdev->res_emma->start, resource_size(pcdev->res_emma));
 	}
@@ -1867,8 +1880,10 @@ static int __devexit mx2_camera_remove(struct platform_device *pdev)
 	iounmap(pcdev->base_csi);
 
 	if (cpu_is_mx27()) {
-		clk_disable(pcdev->clk_emma);
-		clk_put(pcdev->clk_emma);
+		clk_disable_unprepare(pcdev->clk_emma_ipg);
+		clk_put(pcdev->clk_emma_ipg);
+		clk_disable_unprepare(pcdev->clk_emma_ahb);
+		clk_put(pcdev->clk_emma_ahb);
 		iounmap(pcdev->base_emma);
 		res = pcdev->res_emma;
 		release_mem_region(res->start, resource_size(res));
-- 
1.7.9.5

