Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:63277 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751514AbbLIOA2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 9 Dec 2015 09:00:28 -0500
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Kamil Debski <k.debski@samsung.com>
Subject: [PATCH 1/4] media: exynos-gsc: remove non-device-tree init code
Date: Wed, 09 Dec 2015 15:00:13 +0100
Message-id: <1449669616-24802-1-git-send-email-m.szyprowski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Exynos platform has been fully converted to device tree, so old platform
device based init data can be now removed.

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
---
 drivers/media/platform/exynos-gsc/gsc-core.c | 33 +++++-----------------------
 drivers/media/platform/exynos-gsc/gsc-core.h |  1 -
 2 files changed, 6 insertions(+), 28 deletions(-)

diff --git a/drivers/media/platform/exynos-gsc/gsc-core.c b/drivers/media/platform/exynos-gsc/gsc-core.c
index 4f90be4..1b744a6 100644
--- a/drivers/media/platform/exynos-gsc/gsc-core.c
+++ b/drivers/media/platform/exynos-gsc/gsc-core.c
@@ -967,15 +967,6 @@ static struct gsc_driverdata gsc_v_100_drvdata = {
 	.lclk_frequency = 266000000UL,
 };
 
-static const struct platform_device_id gsc_driver_ids[] = {
-	{
-		.name		= "exynos-gsc",
-		.driver_data	= (unsigned long)&gsc_v_100_drvdata,
-	},
-	{},
-};
-MODULE_DEVICE_TABLE(platform, gsc_driver_ids);
-
 static const struct of_device_id exynos_gsc_match[] = {
 	{
 		.compatible = "samsung,exynos5-gsc",
@@ -988,17 +979,11 @@ MODULE_DEVICE_TABLE(of, exynos_gsc_match);
 static void *gsc_get_drv_data(struct platform_device *pdev)
 {
 	struct gsc_driverdata *driver_data = NULL;
+	const struct of_device_id *match;
 
-	if (pdev->dev.of_node) {
-		const struct of_device_id *match;
-		match = of_match_node(exynos_gsc_match,
-					pdev->dev.of_node);
-		if (match)
-			driver_data = (struct gsc_driverdata *)match->data;
-	} else {
-		driver_data = (struct gsc_driverdata *)
-			platform_get_device_id(pdev)->driver_data;
-	}
+	match = of_match_node(exynos_gsc_match, pdev->dev.of_node);
+	if (match)
+		driver_data = (struct gsc_driverdata *)match->data;
 
 	return driver_data;
 }
@@ -1084,19 +1069,14 @@ static int gsc_probe(struct platform_device *pdev)
 	if (!gsc)
 		return -ENOMEM;
 
-	if (dev->of_node)
-		gsc->id = of_alias_get_id(pdev->dev.of_node, "gsc");
-	else
-		gsc->id = pdev->id;
-
-	if (gsc->id >= drv_data->num_entities) {
+	gsc->id = of_alias_get_id(pdev->dev.of_node, "gsc");
+	if (gsc->id >= drv_data->num_entities || gsc->id < 0) {
 		dev_err(dev, "Invalid platform device id: %d\n", gsc->id);
 		return -EINVAL;
 	}
 
 	gsc->variant = drv_data->variant[gsc->id];
 	gsc->pdev = pdev;
-	gsc->pdata = dev->platform_data;
 
 	init_waitqueue_head(&gsc->irq_queue);
 	spin_lock_init(&gsc->slock);
@@ -1254,7 +1234,6 @@ static const struct dev_pm_ops gsc_pm_ops = {
 static struct platform_driver gsc_driver = {
 	.probe		= gsc_probe,
 	.remove		= gsc_remove,
-	.id_table	= gsc_driver_ids,
 	.driver = {
 		.name	= GSC_MODULE_NAME,
 		.pm	= &gsc_pm_ops,
diff --git a/drivers/media/platform/exynos-gsc/gsc-core.h b/drivers/media/platform/exynos-gsc/gsc-core.h
index e93a233..ec4000c 100644
--- a/drivers/media/platform/exynos-gsc/gsc-core.h
+++ b/drivers/media/platform/exynos-gsc/gsc-core.h
@@ -340,7 +340,6 @@ struct gsc_dev {
 	void __iomem			*regs;
 	wait_queue_head_t		irq_queue;
 	struct gsc_m2m_device		m2m;
-	struct exynos_platform_gscaler	*pdata;
 	unsigned long			state;
 	struct vb2_alloc_ctx		*alloc_ctx;
 	struct video_device		vdev;
-- 
1.9.2

