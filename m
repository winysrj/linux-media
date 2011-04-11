Return-path: <mchehab@gaivota>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:38625 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753190Ab1DKJHu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Apr 2011 05:07:50 -0400
Date: Mon, 11 Apr 2011 11:07:42 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH 1/4] s5p-fimc: Fix FIMC3 pixel limits on Exynos4
In-reply-to: <1302512865-20379-1-git-send-email-s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: m.szyprowski@samsung.com, kyungmin.park@samsung.com,
	s.nawrocki@samsung.com
Message-id: <1302512865-20379-2-git-send-email-s.nawrocki@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <1302512865-20379-1-git-send-email-s.nawrocki@samsung.com>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Correct pixel limits for the fourth FIMC entity on Exynos4 SoCs.
FIMC3 only supports the writeback input from the LCD mixer.
Also rename s5pv310 variant to exynos4 which is needed after
renaming s5pv310 series to Exynos4.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/video/s5p-fimc/fimc-core.c |   30 +++++++++++++++++++-----------
 1 files changed, 19 insertions(+), 11 deletions(-)

diff --git a/drivers/media/video/s5p-fimc/fimc-core.c b/drivers/media/video/s5p-fimc/fimc-core.c
index 6c919b3..d54e6d85 100644
--- a/drivers/media/video/s5p-fimc/fimc-core.c
+++ b/drivers/media/video/s5p-fimc/fimc-core.c
@@ -1750,7 +1750,7 @@ static int __devexit fimc_remove(struct platform_device *pdev)
 }
 
 /* Image pixel limits, similar across several FIMC HW revisions. */
-static struct fimc_pix_limit s5p_pix_limit[3] = {
+static struct fimc_pix_limit s5p_pix_limit[4] = {
 	[0] = {
 		.scaler_en_w	= 3264,
 		.scaler_dis_w	= 8192,
@@ -1775,6 +1775,14 @@ static struct fimc_pix_limit s5p_pix_limit[3] = {
 		.out_rot_en_w	= 1280,
 		.out_rot_dis_w	= 1920,
 	},
+	[3] = {
+		.scaler_en_w	= 1920,
+		.scaler_dis_w	= 8192,
+		.in_rot_en_h	= 1366,
+		.in_rot_dis_w	= 8192,
+		.out_rot_en_w	= 1366,
+		.out_rot_dis_w	= 1920,
+	},
 };
 
 static struct samsung_fimc_variant fimc0_variant_s5p = {
@@ -1827,7 +1835,7 @@ static struct samsung_fimc_variant fimc2_variant_s5pv210 = {
 	.pix_limit	 = &s5p_pix_limit[2],
 };
 
-static struct samsung_fimc_variant fimc0_variant_s5pv310 = {
+static struct samsung_fimc_variant fimc0_variant_exynos4 = {
 	.pix_hoff	 = 1,
 	.has_inp_rot	 = 1,
 	.has_out_rot	 = 1,
@@ -1840,7 +1848,7 @@ static struct samsung_fimc_variant fimc0_variant_s5pv310 = {
 	.pix_limit	 = &s5p_pix_limit[1],
 };
 
-static struct samsung_fimc_variant fimc2_variant_s5pv310 = {
+static struct samsung_fimc_variant fimc2_variant_exynos4 = {
 	.pix_hoff	 = 1,
 	.has_cistatus2	 = 1,
 	.has_mainscaler_ext = 1,
@@ -1848,7 +1856,7 @@ static struct samsung_fimc_variant fimc2_variant_s5pv310 = {
 	.min_out_pixsize = 16,
 	.hor_offs_align	 = 1,
 	.out_buf_count	 = 32,
-	.pix_limit	 = &s5p_pix_limit[2],
+	.pix_limit	 = &s5p_pix_limit[3],
 };
 
 /* S5PC100 */
@@ -1874,12 +1882,12 @@ static struct samsung_fimc_driverdata fimc_drvdata_s5pv210 = {
 };
 
 /* S5PV310, S5PC210 */
-static struct samsung_fimc_driverdata fimc_drvdata_s5pv310 = {
+static struct samsung_fimc_driverdata fimc_drvdata_exynos4 = {
 	.variant = {
-		[0] = &fimc0_variant_s5pv310,
-		[1] = &fimc0_variant_s5pv310,
-		[2] = &fimc0_variant_s5pv310,
-		[3] = &fimc2_variant_s5pv310,
+		[0] = &fimc0_variant_exynos4,
+		[1] = &fimc0_variant_exynos4,
+		[2] = &fimc0_variant_exynos4,
+		[3] = &fimc2_variant_exynos4,
 	},
 	.num_entities = 4,
 	.lclk_frequency = 166000000UL,
@@ -1893,8 +1901,8 @@ static struct platform_device_id fimc_driver_ids[] = {
 		.name		= "s5pv210-fimc",
 		.driver_data	= (unsigned long)&fimc_drvdata_s5pv210,
 	}, {
-		.name		= "s5pv310-fimc",
-		.driver_data	= (unsigned long)&fimc_drvdata_s5pv310,
+		.name		= "exynos4-fimc",
+		.driver_data	= (unsigned long)&fimc_drvdata_exynos4,
 	},
 	{},
 };
-- 
1.7.4.3
