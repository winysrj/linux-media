Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:58303 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754883AbbLIOAa (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 9 Dec 2015 09:00:30 -0500
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Kamil Debski <k.debski@samsung.com>
Subject: [PATCH 4/4] media: exynos4-is: remove non-device-tree init code
Date: Wed, 09 Dec 2015 15:00:16 +0100
Message-id: <1449669616-24802-4-git-send-email-m.szyprowski@samsung.com>
In-reply-to: <1449669616-24802-1-git-send-email-m.szyprowski@samsung.com>
References: <1449669616-24802-1-git-send-email-m.szyprowski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Exynos and Samsung S5Pxxxx platforms has been fully converted to device
tree, so old platform device based init data can be now removed.

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
---
 drivers/media/platform/exynos4-is/fimc-core.c | 50 ---------------------------
 1 file changed, 50 deletions(-)

diff --git a/drivers/media/platform/exynos4-is/fimc-core.c b/drivers/media/platform/exynos4-is/fimc-core.c
index 368e19b..a470fe5 100644
--- a/drivers/media/platform/exynos4-is/fimc-core.c
+++ b/drivers/media/platform/exynos4-is/fimc-core.c
@@ -1155,26 +1155,6 @@ static const struct fimc_pix_limit s5p_pix_limit[4] = {
 	},
 };
 
-static const struct fimc_variant fimc0_variant_s5p = {
-	.has_inp_rot	 = 1,
-	.has_out_rot	 = 1,
-	.has_cam_if	 = 1,
-	.min_inp_pixsize = 16,
-	.min_out_pixsize = 16,
-	.hor_offs_align	 = 8,
-	.min_vsize_align = 16,
-	.pix_limit	 = &s5p_pix_limit[0],
-};
-
-static const struct fimc_variant fimc2_variant_s5p = {
-	.has_cam_if	 = 1,
-	.min_inp_pixsize = 16,
-	.min_out_pixsize = 16,
-	.hor_offs_align	 = 8,
-	.min_vsize_align = 16,
-	.pix_limit	 = &s5p_pix_limit[1],
-};
-
 static const struct fimc_variant fimc0_variant_s5pv210 = {
 	.has_inp_rot	 = 1,
 	.has_out_rot	 = 1,
@@ -1207,18 +1187,6 @@ static const struct fimc_variant fimc2_variant_s5pv210 = {
 	.pix_limit	 = &s5p_pix_limit[2],
 };
 
-/* S5PC100 */
-static const struct fimc_drvdata fimc_drvdata_s5p = {
-	.variant = {
-		[0] = &fimc0_variant_s5p,
-		[1] = &fimc0_variant_s5p,
-		[2] = &fimc2_variant_s5p,
-	},
-	.num_entities	= 3,
-	.lclk_frequency = 133000000UL,
-	.out_buf_count	= 4,
-};
-
 /* S5PV210, S5PC110 */
 static const struct fimc_drvdata fimc_drvdata_s5pv210 = {
 	.variant = {
@@ -1252,23 +1220,6 @@ static const struct fimc_drvdata fimc_drvdata_exynos4x12 = {
 	.out_buf_count	= 32,
 };
 
-static const struct platform_device_id fimc_driver_ids[] = {
-	{
-		.name		= "s5p-fimc",
-		.driver_data	= (unsigned long)&fimc_drvdata_s5p,
-	}, {
-		.name		= "s5pv210-fimc",
-		.driver_data	= (unsigned long)&fimc_drvdata_s5pv210,
-	}, {
-		.name		= "exynos4-fimc",
-		.driver_data	= (unsigned long)&fimc_drvdata_exynos4210,
-	}, {
-		.name		= "exynos4x12-fimc",
-		.driver_data	= (unsigned long)&fimc_drvdata_exynos4x12,
-	},
-	{ },
-};
-
 static const struct of_device_id fimc_of_match[] = {
 	{
 		.compatible = "samsung,s5pv210-fimc",
@@ -1291,7 +1242,6 @@ static const struct dev_pm_ops fimc_pm_ops = {
 static struct platform_driver fimc_driver = {
 	.probe		= fimc_probe,
 	.remove		= fimc_remove,
-	.id_table	= fimc_driver_ids,
 	.driver = {
 		.of_match_table = fimc_of_match,
 		.name		= FIMC_DRIVER_NAME,
-- 
1.9.2

