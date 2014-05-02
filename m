Return-path: <linux-media-owner@vger.kernel.org>
Received: from fallback1.mail.ru ([94.100.176.18]:52300 "EHLO
	fallback1.mail.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751851AbaEBHSW (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 2 May 2014 03:18:22 -0400
Received: from smtp10.mail.ru (smtp10.mail.ru [94.100.176.152])
	by fallback1.mail.ru (mPOP.Fallback_MX) with ESMTP id 3EF1D37EE889
	for <linux-media@vger.kernel.org>; Fri,  2 May 2014 11:18:20 +0400 (MSK)
From: Alexander Shiyan <shc_work@mail.ru>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Shawn Guo <shawn.guo@freescale.com>,
	Alexander Shiyan <shc_work@mail.ru>
Subject: [PATCH 1/3] media: mx2-emmaprp: Cleanup internal structure
Date: Fri,  2 May 2014 11:18:00 +0400
Message-Id: <1399015081-23953-1-git-send-email-shc_work@mail.ru>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There are no need to store resource struct and IRQ in the driver
internal structure.
This patch remove these fields and improve error handling by using
proper return codes from devm_ioremap_resource() and devm_request_irq().

Signed-off-by: Alexander Shiyan <shc_work@mail.ru>
---
 drivers/media/platform/mx2_emmaprp.c | 34 ++++++++++------------------------
 1 file changed, 10 insertions(+), 24 deletions(-)

diff --git a/drivers/media/platform/mx2_emmaprp.c b/drivers/media/platform/mx2_emmaprp.c
index 0b7480e..85ce099 100644
--- a/drivers/media/platform/mx2_emmaprp.c
+++ b/drivers/media/platform/mx2_emmaprp.c
@@ -207,10 +207,8 @@ struct emmaprp_dev {
 	struct mutex		dev_mutex;
 	spinlock_t		irqlock;
 
-	int			irq_emma;
 	void __iomem		*base_emma;
 	struct clk		*clk_emma_ahb, *clk_emma_ipg;
-	struct resource		*res_emma;
 
 	struct v4l2_m2m_dev	*m2m_dev;
 	struct vb2_alloc_ctx	*alloc_ctx;
@@ -901,9 +899,8 @@ static int emmaprp_probe(struct platform_device *pdev)
 {
 	struct emmaprp_dev *pcdev;
 	struct video_device *vfd;
-	struct resource *res_emma;
-	int irq_emma;
-	int ret;
+	struct resource *res;
+	int irq, ret;
 
 	pcdev = devm_kzalloc(&pdev->dev, sizeof(*pcdev), GFP_KERNEL);
 	if (!pcdev)
@@ -920,12 +917,10 @@ static int emmaprp_probe(struct platform_device *pdev)
 	if (IS_ERR(pcdev->clk_emma_ahb))
 		return PTR_ERR(pcdev->clk_emma_ahb);
 
-	irq_emma = platform_get_irq(pdev, 0);
-	res_emma = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (irq_emma < 0 || res_emma == NULL) {
-		dev_err(&pdev->dev, "Missing platform resources data\n");
-		return -ENODEV;
-	}
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	pcdev->base_emma = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(pcdev->base_emma))
+		return PTR_ERR(pcdev->base_emma);
 
 	ret = v4l2_device_register(&pdev->dev, &pcdev->v4l2_dev);
 	if (ret)
@@ -952,20 +947,11 @@ static int emmaprp_probe(struct platform_device *pdev)
 
 	platform_set_drvdata(pdev, pcdev);
 
-	pcdev->base_emma = devm_ioremap_resource(&pdev->dev, res_emma);
-	if (IS_ERR(pcdev->base_emma)) {
-		ret = PTR_ERR(pcdev->base_emma);
-		goto rel_vdev;
-	}
-
-	pcdev->irq_emma = irq_emma;
-	pcdev->res_emma = res_emma;
-
-	if (devm_request_irq(&pdev->dev, pcdev->irq_emma, emmaprp_irq,
-			     0, MEM2MEM_NAME, pcdev) < 0) {
-		ret = -ENODEV;
+	irq = platform_get_irq(pdev, 0);
+	ret = devm_request_irq(&pdev->dev, irq, emmaprp_irq, 0,
+			       dev_name(&pdev->dev), pcdev);
+	if (ret)
 		goto rel_vdev;
-	}
 
 	pcdev->alloc_ctx = vb2_dma_contig_init_ctx(&pdev->dev);
 	if (IS_ERR(pcdev->alloc_ctx)) {
-- 
1.8.3.2

