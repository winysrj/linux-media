Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:63277 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754449AbbLIOA3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 9 Dec 2015 09:00:29 -0500
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Kamil Debski <k.debski@samsung.com>
Subject: [PATCH 3/4] media: s5p-mfc: remove non-device-tree init code
Date: Wed, 09 Dec 2015 15:00:15 +0100
Message-id: <1449669616-24802-3-git-send-email-m.szyprowski@samsung.com>
In-reply-to: <1449669616-24802-1-git-send-email-m.szyprowski@samsung.com>
References: <1449669616-24802-1-git-send-email-m.szyprowski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Exynos and Samsung S5Pxxxx platforms has been fully converted to device
tree, so old platform device based init data can be now removed.

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
---
 drivers/media/platform/s5p-mfc/s5p_mfc.c | 37 +++++---------------------------
 1 file changed, 5 insertions(+), 32 deletions(-)

diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc.c b/drivers/media/platform/s5p-mfc/s5p_mfc.c
index bae7c0f..5d0a75e 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc.c
@@ -1489,27 +1489,6 @@ static struct s5p_mfc_variant mfc_drvdata_v8 = {
 	.fw_name[0]     = "s5p-mfc-v8.fw",
 };
 
-static const struct platform_device_id mfc_driver_ids[] = {
-	{
-		.name = "s5p-mfc",
-		.driver_data = (unsigned long)&mfc_drvdata_v5,
-	}, {
-		.name = "s5p-mfc-v5",
-		.driver_data = (unsigned long)&mfc_drvdata_v5,
-	}, {
-		.name = "s5p-mfc-v6",
-		.driver_data = (unsigned long)&mfc_drvdata_v6,
-	}, {
-		.name = "s5p-mfc-v7",
-		.driver_data = (unsigned long)&mfc_drvdata_v7,
-	}, {
-		.name = "s5p-mfc-v8",
-		.driver_data = (unsigned long)&mfc_drvdata_v8,
-	},
-	{},
-};
-MODULE_DEVICE_TABLE(platform, mfc_driver_ids);
-
 static const struct of_device_id exynos_mfc_match[] = {
 	{
 		.compatible = "samsung,mfc-v5",
@@ -1531,24 +1510,18 @@ MODULE_DEVICE_TABLE(of, exynos_mfc_match);
 static void *mfc_get_drv_data(struct platform_device *pdev)
 {
 	struct s5p_mfc_variant *driver_data = NULL;
+	const struct of_device_id *match;
+
+	match = of_match_node(exynos_mfc_match, pdev->dev.of_node);
+	if (match)
+		driver_data = (struct s5p_mfc_variant *)match->data;
 
-	if (pdev->dev.of_node) {
-		const struct of_device_id *match;
-		match = of_match_node(exynos_mfc_match,
-				pdev->dev.of_node);
-		if (match)
-			driver_data = (struct s5p_mfc_variant *)match->data;
-	} else {
-		driver_data = (struct s5p_mfc_variant *)
-			platform_get_device_id(pdev)->driver_data;
-	}
 	return driver_data;
 }
 
 static struct platform_driver s5p_mfc_driver = {
 	.probe		= s5p_mfc_probe,
 	.remove		= s5p_mfc_remove,
-	.id_table	= mfc_driver_ids,
 	.driver	= {
 		.name	= S5P_MFC_NAME,
 		.pm	= &s5p_mfc_pm_ops,
-- 
1.9.2

