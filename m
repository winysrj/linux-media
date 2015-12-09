Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:58303 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754381AbbLIOA3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 9 Dec 2015 09:00:29 -0500
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Kamil Debski <k.debski@samsung.com>
Subject: [PATCH 2/4] media: s5p-g2d: remove non-device-tree init code
Date: Wed, 09 Dec 2015 15:00:14 +0100
Message-id: <1449669616-24802-2-git-send-email-m.szyprowski@samsung.com>
In-reply-to: <1449669616-24802-1-git-send-email-m.szyprowski@samsung.com>
References: <1449669616-24802-1-git-send-email-m.szyprowski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Exynos and Samsung S5PXXXX platforms has been fully converted to device
tree, so old platform device based init data can be now removed.

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
---
 drivers/media/platform/s5p-g2d/g2d.c | 27 +++++----------------------
 drivers/media/platform/s5p-g2d/g2d.h |  5 -----
 2 files changed, 5 insertions(+), 27 deletions(-)

diff --git a/drivers/media/platform/s5p-g2d/g2d.c b/drivers/media/platform/s5p-g2d/g2d.c
index 31f6c23..be411a9 100644
--- a/drivers/media/platform/s5p-g2d/g2d.c
+++ b/drivers/media/platform/s5p-g2d/g2d.c
@@ -720,16 +720,12 @@ static int g2d_probe(struct platform_device *pdev)
 
 	def_frame.stride = (def_frame.width * def_frame.fmt->depth) >> 3;
 
-	if (!pdev->dev.of_node) {
-		dev->variant = g2d_get_drv_data(pdev);
-	} else {
-		of_id = of_match_node(exynos_g2d_match, pdev->dev.of_node);
-		if (!of_id) {
-			ret = -ENODEV;
-			goto unreg_video_dev;
-		}
-		dev->variant = (struct g2d_variant *)of_id->data;
+	of_id = of_match_node(exynos_g2d_match, pdev->dev.of_node);
+	if (!of_id) {
+		ret = -ENODEV;
+		goto unreg_video_dev;
 	}
+	dev->variant = (struct g2d_variant *)of_id->data;
 
 	return 0;
 
@@ -789,22 +785,9 @@ static const struct of_device_id exynos_g2d_match[] = {
 };
 MODULE_DEVICE_TABLE(of, exynos_g2d_match);
 
-static const struct platform_device_id g2d_driver_ids[] = {
-	{
-		.name = "s5p-g2d",
-		.driver_data = (unsigned long)&g2d_drvdata_v3x,
-	}, {
-		.name = "s5p-g2d-v4x",
-		.driver_data = (unsigned long)&g2d_drvdata_v4x,
-	},
-	{},
-};
-MODULE_DEVICE_TABLE(platform, g2d_driver_ids);
-
 static struct platform_driver g2d_pdrv = {
 	.probe		= g2d_probe,
 	.remove		= g2d_remove,
-	.id_table	= g2d_driver_ids,
 	.driver		= {
 		.name = G2D_NAME,
 		.of_match_table = exynos_g2d_match,
diff --git a/drivers/media/platform/s5p-g2d/g2d.h b/drivers/media/platform/s5p-g2d/g2d.h
index b0e52ab..e31df54 100644
--- a/drivers/media/platform/s5p-g2d/g2d.h
+++ b/drivers/media/platform/s5p-g2d/g2d.h
@@ -89,8 +89,3 @@ void g2d_set_flip(struct g2d_dev *d, u32 r);
 void g2d_set_v41_stretch(struct g2d_dev *d,
 			struct g2d_frame *src, struct g2d_frame *dst);
 void g2d_set_cmd(struct g2d_dev *d, u32 c);
-
-static inline struct g2d_variant *g2d_get_drv_data(struct platform_device *pdev)
-{
-	return (struct g2d_variant *)platform_get_device_id(pdev)->driver_data;
-}
-- 
1.9.2

