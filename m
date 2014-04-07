Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:34040 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755338AbaDGNQp (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 7 Apr 2014 09:16:45 -0400
Received: from epcpsbgm1.samsung.com (epcpsbgm1 [203.254.230.26])
 by mailout1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0N3N00DDYWVW03C0@mailout1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 07 Apr 2014 22:16:44 +0900 (KST)
From: Jacek Anaszewski <j.anaszewski@samsung.com>
To: linux-media@vger.kernel.org
Cc: s.nawrocki@samsung.com,
	Jacek Anaszewski <j.anaszewski@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>
Subject: [PATCH 4/8] [media] s5p-jpeg: Fix build break when CONFIG_OF is
 undefined
Date: Mon, 07 Apr 2014 15:16:09 +0200
Message-id: <1396876573-15811-4-git-send-email-j.anaszewski@samsung.com>
In-reply-to: <1396876573-15811-1-git-send-email-j.anaszewski@samsung.com>
References: <1396876573-15811-1-git-send-email-j.anaszewski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch fixes build break occurring when
there is no support for Device Tree turned on
in the kernel configuration. In such a case only
the driver variant for S5PC210 SoC will be available.

Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/platform/s5p-jpeg/jpeg-core.c |   16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

diff --git a/drivers/media/platform/s5p-jpeg/jpeg-core.c b/drivers/media/platform/s5p-jpeg/jpeg-core.c
index 4f4dc81..913a027 100644
--- a/drivers/media/platform/s5p-jpeg/jpeg-core.c
+++ b/drivers/media/platform/s5p-jpeg/jpeg-core.c
@@ -1837,7 +1837,7 @@ static irqreturn_t exynos4_jpeg_irq(int irq, void *priv)
 	return IRQ_HANDLED;
 }
 
-static void *jpeg_get_drv_data(struct platform_device *pdev);
+static void *jpeg_get_drv_data(struct device *dev);
 
 /*
  * ============================================================================
@@ -1851,15 +1851,12 @@ static int s5p_jpeg_probe(struct platform_device *pdev)
 	struct resource *res;
 	int ret;
 
-	if (!pdev->dev.of_node)
-		return -ENODEV;
-
 	/* JPEG IP abstraction struct */
 	jpeg = devm_kzalloc(&pdev->dev, sizeof(struct s5p_jpeg), GFP_KERNEL);
 	if (!jpeg)
 		return -ENOMEM;
 
-	jpeg->variant = jpeg_get_drv_data(pdev);
+	jpeg->variant = jpeg_get_drv_data(&pdev->dev);
 
 	mutex_init(&jpeg->lock);
 	spin_lock_init(&jpeg->slock);
@@ -2088,7 +2085,6 @@ static const struct dev_pm_ops s5p_jpeg_pm_ops = {
 	SET_RUNTIME_PM_OPS(s5p_jpeg_runtime_suspend, s5p_jpeg_runtime_resume, NULL)
 };
 
-#ifdef CONFIG_OF
 static struct s5p_jpeg_variant s5p_jpeg_drvdata = {
 	.version	= SJPEG_S5P,
 	.jpeg_irq	= s5p_jpeg_irq,
@@ -2119,19 +2115,21 @@ static const struct of_device_id samsung_jpeg_match[] = {
 
 MODULE_DEVICE_TABLE(of, samsung_jpeg_match);
 
-static void *jpeg_get_drv_data(struct platform_device *pdev)
+static void *jpeg_get_drv_data(struct device *dev)
 {
 	struct s5p_jpeg_variant *driver_data = NULL;
 	const struct of_device_id *match;
 
+	if (!IS_ENABLED(CONFIG_OF) || dev->of_node == NULL)
+		return &s5p_jpeg_drvdata;
+
 	match = of_match_node(of_match_ptr(samsung_jpeg_match),
-					 pdev->dev.of_node);
+					dev->of_node);
 	if (match)
 		driver_data = (struct s5p_jpeg_variant *)match->data;
 
 	return driver_data;
 }
-#endif
 
 static struct platform_driver s5p_jpeg_driver = {
 	.probe = s5p_jpeg_probe,
-- 
1.7.9.5

