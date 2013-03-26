Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:56486 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756485Ab3CZSij (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Mar 2013 14:38:39 -0400
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: kyungmin.park@samsung.com, myungjoo.ham@samsung.com,
	dh09.lee@samsung.com, shaik.samsung@gmail.com, arun.kk@samsung.com,
	a.hajda@samsung.com, linux-samsung-soc@vger.kernel.org,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH v2 1/5] exynos4-is: Remove static driver data for Exynos4210
 FIMC variants
Date: Tue, 26 Mar 2013 19:38:13 +0100
Message-id: <1364323101-22046-2-git-send-email-s.nawrocki@samsung.com>
In-reply-to: <1364323101-22046-1-git-send-email-s.nawrocki@samsung.com>
References: <1364323101-22046-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

All Exynos4210 based boards files using FIMC are going to be removed
in 3.10 and corresponding device trees are to be used instead.
The FIMC variant data will be parsed directly form the device tree
for those SoCs as well. Hence now unused static data is removed.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/platform/exynos4-is/fimc-core.c |   35 -------------------------
 1 file changed, 35 deletions(-)

diff --git a/drivers/media/platform/exynos4-is/fimc-core.c b/drivers/media/platform/exynos4-is/fimc-core.c
index 1248cdd..2e153bb 100644
--- a/drivers/media/platform/exynos4-is/fimc-core.c
+++ b/drivers/media/platform/exynos4-is/fimc-core.c
@@ -1141,14 +1141,6 @@ static const struct fimc_pix_limit s5p_pix_limit[4] = {
 		.out_rot_en_w	= 1280,
 		.out_rot_dis_w	= 1920,
 	},
-	[3] = {
-		.scaler_en_w	= 1920,
-		.scaler_dis_w	= 8192,
-		.in_rot_en_h	= 1366,
-		.in_rot_dis_w	= 8192,
-		.out_rot_en_w	= 1366,
-		.out_rot_dis_w	= 1920,
-	},
 };
 
 static const struct fimc_variant fimc0_variant_s5p = {
@@ -1203,27 +1195,6 @@ static const struct fimc_variant fimc2_variant_s5pv210 = {
 	.pix_limit	 = &s5p_pix_limit[2],
 };
 
-static const struct fimc_variant fimc0_variant_exynos4210 = {
-	.has_inp_rot	 = 1,
-	.has_out_rot	 = 1,
-	.has_cam_if	 = 1,
-	.has_mainscaler_ext = 1,
-	.min_inp_pixsize = 16,
-	.min_out_pixsize = 16,
-	.hor_offs_align	 = 2,
-	.min_vsize_align = 1,
-	.pix_limit	 = &s5p_pix_limit[1],
-};
-
-static const struct fimc_variant fimc3_variant_exynos4210 = {
-	.has_mainscaler_ext = 1,
-	.min_inp_pixsize = 16,
-	.min_out_pixsize = 16,
-	.hor_offs_align	 = 2,
-	.min_vsize_align = 1,
-	.pix_limit	 = &s5p_pix_limit[3],
-};
-
 /* S5PC100 */
 static const struct fimc_drvdata fimc_drvdata_s5p = {
 	.variant = {
@@ -1251,12 +1222,6 @@ static const struct fimc_drvdata fimc_drvdata_s5pv210 = {
 
 /* EXYNOS4210, S5PV310, S5PC210 */
 static const struct fimc_drvdata fimc_drvdata_exynos4210 = {
-	.variant = {
-		[0] = &fimc0_variant_exynos4210,
-		[1] = &fimc0_variant_exynos4210,
-		[2] = &fimc0_variant_exynos4210,
-		[3] = &fimc3_variant_exynos4210,
-	},
 	.num_entities	= 4,
 	.lclk_frequency = 166000000UL,
 	.dma_pix_hoff	= 1,
-- 
1.7.9.5

