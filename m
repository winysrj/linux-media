Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pd0-f169.google.com ([209.85.192.169]:39502 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757951Ab3DXHmb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 24 Apr 2013 03:42:31 -0400
From: Shaik Ameer Basha <shaik.ameer@samsung.com>
To: linux-media@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
	linux-samsung-soc@vger.kernel.org
Cc: s.nawrocki@samsung.com, shaik.samsung@gmail.com,
	arunkk.samsung@gmail.com
Subject: [RFC v2 5/6] media: s5p-csis: Adding Exynos5250 compatibility
Date: Wed, 24 Apr 2013 13:11:12 +0530
Message-Id: <1366789273-30184-6-git-send-email-shaik.ameer@samsung.com>
In-Reply-To: <1366789273-30184-1-git-send-email-shaik.ameer@samsung.com>
References: <1366789273-30184-1-git-send-email-shaik.ameer@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

FIMC-IS firmware needs all the MIPI-CSIS interrupts to be enabled.
This patch enables all those MIPI interrupts and adds the Exynos5
compatible string.

Signed-off-by: Shaik Ameer Basha <shaik.ameer@samsung.com>
---
 drivers/media/platform/exynos4-is/mipi-csis.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/exynos4-is/mipi-csis.c b/drivers/media/platform/exynos4-is/mipi-csis.c
index 8636bcd..51ad9b2 100644
--- a/drivers/media/platform/exynos4-is/mipi-csis.c
+++ b/drivers/media/platform/exynos4-is/mipi-csis.c
@@ -66,7 +66,7 @@ MODULE_PARM_DESC(debug, "Debug level (0-2)");
 
 /* Interrupt mask */
 #define S5PCSIS_INTMSK			0x10
-#define S5PCSIS_INTMSK_EN_ALL		0xf000103f
+#define S5PCSIS_INTMSK_EN_ALL		0xfc00103f
 #define S5PCSIS_INTMSK_EVEN_BEFORE	(1 << 31)
 #define S5PCSIS_INTMSK_EVEN_AFTER	(1 << 30)
 #define S5PCSIS_INTMSK_ODD_BEFORE	(1 << 29)
@@ -1003,6 +1003,7 @@ static const struct dev_pm_ops s5pcsis_pm_ops = {
 static const struct of_device_id s5pcsis_of_match[] = {
 	{ .compatible = "samsung,s5pv210-csis" },
 	{ .compatible = "samsung,exynos4210-csis" },
+	{ .compatible = "samsung,exynos5250-csis" },
 	{ /* sentinel */ },
 };
 MODULE_DEVICE_TABLE(of, s5pcsis_of_match);
-- 
1.7.9.5

