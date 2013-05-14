Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:28055 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753138Ab3ENLvW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 14 May 2013 07:51:22 -0400
From: George Joseph <george.jp@samsung.com>
To: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: s.nawrocki@samsung.com, a.hajda@samsung.com, ym.song@samsung.com
Subject: [RFC PATCH 2/3] [media] s5p-jpeg: Add DT support to JPEG driver
Date: Tue, 14 May 2013 17:23:39 +0530
Message-id: <1368532420-21555-3-git-send-email-george.jp@samsung.com>
In-reply-to: <1368532420-21555-1-git-send-email-george.jp@samsung.com>
References: <1368532420-21555-1-git-send-email-george.jp@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: George Joseph Palathingal <george.jp@samsung.com>

Adding DT support to the driver. Driver supports Exynos 4210, 4412 and 5250.

Signed-off-by: George Joseph Palathingal <george.jp@samsung.com>
Cc: devicetree-discuss@lists.ozlabs.org
---
 drivers/media/platform/s5p-jpeg/jpeg-core.c |   36 +++++++++++++++++++++++++--
 1 file changed, 34 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/s5p-jpeg/jpeg-core.c b/drivers/media/platform/s5p-jpeg/jpeg-core.c
index f964566..b2bf412 100644
--- a/drivers/media/platform/s5p-jpeg/jpeg-core.c
+++ b/drivers/media/platform/s5p-jpeg/jpeg-core.c
@@ -970,6 +970,8 @@ const struct jpeg_vb2 jpeg_vb2_dma = {
 	.plane_addr	= vb2_dma_contig_plane_dma_addr,
 };
 
+static void *jpeg_get_drv_data(struct platform_device *pdev);
+
 static int jpeg_probe(struct platform_device *pdev)
 {
 	struct jpeg_dev *dev;
@@ -982,8 +984,7 @@ static int jpeg_probe(struct platform_device *pdev)
 		return -ENOMEM;
 
 	dev->plat_dev = pdev;
-	dev->variant = (struct s5p_jpeg_variant *)
-				platform_get_device_id(pdev)->driver_data;
+	dev->variant = (struct s5p_jpeg_variant *)jpeg_get_drv_data(pdev);
 	spin_lock_init(&dev->slock);
 
 	/* setup jpeg control */
@@ -1232,6 +1233,36 @@ static struct platform_device_id jpeg_driver_ids[] = {
 
 MODULE_DEVICE_TABLE(platform, jpeg_driver_ids);
 
+static const struct of_device_id exynos_jpeg_match[] = {
+	{
+		.compatible = "samsung,s5pv210-jpeg",
+		.data = &jpeg_drvdata_v1,
+	}, {
+		.compatible = "samsung,exynos4212-jpeg",
+		.data = &jpeg_drvdata_v2,
+	},
+	{},
+};
+
+MODULE_DEVICE_TABLE(of, exynos_jpeg_match);
+
+static void *jpeg_get_drv_data(struct platform_device *pdev)
+{
+	struct s5p_jpeg_variant *driver_data = NULL;
+
+	if (pdev->dev.of_node) {
+		const struct of_device_id *match;
+		match = of_match_node(of_match_ptr(exynos_jpeg_match),
+					 pdev->dev.of_node);
+		if (match)
+			driver_data = (struct s5p_jpeg_variant *)match->data;
+		} else {
+			driver_data = (struct s5p_jpeg_variant *)
+				platform_get_device_id(pdev)->driver_data;
+		}
+	return driver_data;
+}
+
 static struct platform_driver jpeg_driver = {
 	.probe		= jpeg_probe,
 	.remove		= jpeg_remove,
@@ -1241,6 +1272,7 @@ static struct platform_driver jpeg_driver = {
 	.driver	= {
 		.owner			= THIS_MODULE,
 		.name			= JPEG_NAME,
+		.of_match_table		= exynos_jpeg_match,
 		.pm			= NULL,
 	},
 };
-- 
1.7.9.5

