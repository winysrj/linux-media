Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pb0-f53.google.com ([209.85.160.53]:41463 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757931Ab3DXHmV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 24 Apr 2013 03:42:21 -0400
From: Shaik Ameer Basha <shaik.ameer@samsung.com>
To: linux-media@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
	linux-samsung-soc@vger.kernel.org
Cc: s.nawrocki@samsung.com, shaik.samsung@gmail.com,
	arunkk.samsung@gmail.com
Subject: [RFC v2 2/6] fimc-lite: Adding Exynos5 compatibility to fimc-lite driver
Date: Wed, 24 Apr 2013 13:11:09 +0530
Message-Id: <1366789273-30184-3-git-send-email-shaik.ameer@samsung.com>
In-Reply-To: <1366789273-30184-1-git-send-email-shaik.ameer@samsung.com>
References: <1366789273-30184-1-git-send-email-shaik.ameer@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds,
1] Exynos5 soc compatibility to the fimc-lite driver
2] Multiple dma output buffer support as from Exynos5 onwards,
   fimc-lite h/w ip supports multiple dma buffers.

Signed-off-by: Shaik Ameer Basha <shaik.ameer@samsung.com>
---
 drivers/media/platform/exynos4-is/fimc-lite.c |   19 ++++++++++++++++++-
 drivers/media/platform/exynos4-is/fimc-lite.h |    4 +++-
 2 files changed, 21 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/exynos4-is/fimc-lite.c b/drivers/media/platform/exynos4-is/fimc-lite.c
index 4878089..cb173ec 100644
--- a/drivers/media/platform/exynos4-is/fimc-lite.c
+++ b/drivers/media/platform/exynos4-is/fimc-lite.c
@@ -1467,7 +1467,7 @@ static int fimc_lite_probe(struct platform_device *pdev)
 		fimc->index = pdev->id;
 	}
 
-	if (!drv_data || fimc->index < 0 || fimc->index >= FIMC_LITE_MAX_DEVS)
+	if (!drv_data || fimc->index < 0 || fimc->index >= drv_data->num_devs)
 		return -EINVAL;
 
 	fimc->dd = drv_data;
@@ -1625,6 +1625,19 @@ static struct flite_drvdata fimc_lite_drvdata_exynos4 = {
 	.out_width_align	= 8,
 	.win_hor_offs_align	= 2,
 	.out_hor_offs_align	= 8,
+	.support_multi_dma_buf	= false,
+	.num_devs = 2,
+};
+
+/* EXYNOS5250 */
+static struct flite_drvdata fimc_lite_drvdata_exynos5 = {
+	.max_width		= 8192,
+	.max_height		= 8192,
+	.out_width_align	= 8,
+	.win_hor_offs_align	= 2,
+	.out_hor_offs_align	= 8,
+	.support_multi_dma_buf	= true,
+	.num_devs = 3,
 };
 
 static struct platform_device_id fimc_lite_driver_ids[] = {
@@ -1641,6 +1654,10 @@ static const struct of_device_id flite_of_match[] = {
 		.compatible = "samsung,exynos4212-fimc-lite",
 		.data = &fimc_lite_drvdata_exynos4,
 	},
+	{
+		.compatible = "samsung,exynos5250-fimc-lite",
+		.data = &fimc_lite_drvdata_exynos5,
+	},
 	{ /* sentinel */ },
 };
 MODULE_DEVICE_TABLE(of, flite_of_match);
diff --git a/drivers/media/platform/exynos4-is/fimc-lite.h b/drivers/media/platform/exynos4-is/fimc-lite.h
index 71fed51..a35f29e 100644
--- a/drivers/media/platform/exynos4-is/fimc-lite.h
+++ b/drivers/media/platform/exynos4-is/fimc-lite.h
@@ -27,7 +27,7 @@
 
 #define FIMC_LITE_DRV_NAME	"exynos-fimc-lite"
 #define FLITE_CLK_NAME		"flite"
-#define FIMC_LITE_MAX_DEVS	2
+#define FIMC_LITE_MAX_DEVS	3
 #define FLITE_REQ_BUFS_MIN	2
 
 /* Bit index definitions for struct fimc_lite::state */
@@ -54,6 +54,8 @@ struct flite_drvdata {
 	unsigned short out_width_align;
 	unsigned short win_hor_offs_align;
 	unsigned short out_hor_offs_align;
+	unsigned short support_multi_dma_buf;
+	unsigned short num_devs;
 };
 
 #define fimc_lite_get_drvdata(_pdev) \
-- 
1.7.9.5

