Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:44301 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965197AbaDJHcg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Apr 2014 03:32:36 -0400
Received: from epcpsbgm1.samsung.com (epcpsbgm1 [203.254.230.26])
 by mailout4.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0N3T00CAT0Y7UK10@mailout4.samsung.com> for
 linux-media@vger.kernel.org; Thu, 10 Apr 2014 16:32:31 +0900 (KST)
From: Jacek Anaszewski <j.anaszewski@samsung.com>
To: linux-media@vger.kernel.org
Cc: s.nawrocki@samsung.com,
	Jacek Anaszewski <j.anaszewski@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>
Subject: [PATCH v2 4/8] s5p-jpeg: Fix build break when CONFIG_OF is undefined
Date: Thu, 10 Apr 2014 09:32:14 +0200
Message-id: <1397115138-1095-4-git-send-email-j.anaszewski@samsung.com>
In-reply-to: <1397115138-1095-1-git-send-email-j.anaszewski@samsung.com>
References: <1397115138-1095-1-git-send-email-j.anaszewski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch fixes build break occurring when
there is no support for Device Tree turned on
in the kernel configuration. In such a case only
the driver variant for S5PC210 SoC will be available.

Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/platform/s5p-jpeg/jpeg-core.c |   18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)

diff --git a/drivers/media/platform/s5p-jpeg/jpeg-core.c b/drivers/media/platform/s5p-jpeg/jpeg-core.c
index 1b69b69..04260c2 100644
--- a/drivers/media/platform/s5p-jpeg/jpeg-core.c
+++ b/drivers/media/platform/s5p-jpeg/jpeg-core.c
@@ -1840,7 +1840,7 @@ static irqreturn_t exynos4_jpeg_irq(int irq, void *priv)
 	return IRQ_HANDLED;
 }
 
-static void *jpeg_get_drv_data(struct platform_device *pdev);
+static void *jpeg_get_drv_data(struct device *dev);
 
 /*
  * ============================================================================
@@ -1854,15 +1854,12 @@ static int s5p_jpeg_probe(struct platform_device *pdev)
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
@@ -2091,7 +2088,6 @@ static const struct dev_pm_ops s5p_jpeg_pm_ops = {
 	SET_RUNTIME_PM_OPS(s5p_jpeg_runtime_suspend, s5p_jpeg_runtime_resume, NULL)
 };
 
-#ifdef CONFIG_OF
 static struct s5p_jpeg_variant s5p_jpeg_drvdata = {
 	.version	= SJPEG_S5P,
 	.jpeg_irq	= s5p_jpeg_irq,
@@ -2122,19 +2118,21 @@ static const struct of_device_id samsung_jpeg_match[] = {
 
 MODULE_DEVICE_TABLE(of, samsung_jpeg_match);
 
-static void *jpeg_get_drv_data(struct platform_device *pdev)
+static void *jpeg_get_drv_data(struct device *dev)
 {
 	struct s5p_jpeg_variant *driver_data = NULL;
 	const struct of_device_id *match;
 
-	match = of_match_node(of_match_ptr(samsung_jpeg_match),
-					 pdev->dev.of_node);
+	if (!IS_ENABLED(CONFIG_OF) || !dev->of_node)
+		return &s5p_jpeg_drvdata;
+
+	match = of_match_node(samsung_jpeg_match, dev->of_node);
+
 	if (match)
 		driver_data = (struct s5p_jpeg_variant *)match->data;
 
 	return driver_data;
 }
-#endif
 
 static struct platform_driver s5p_jpeg_driver = {
 	.probe = s5p_jpeg_probe,
-- 
1.7.9.5

