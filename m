Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:46122 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754478Ab2JPEk5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 16 Oct 2012 00:40:57 -0400
Received: from epcpsbgm2.samsung.com (epcpsbgm2 [203.254.230.27])
 by mailout3.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MBY000A6YB5UTE0@mailout3.samsung.com> for
 linux-media@vger.kernel.org; Tue, 16 Oct 2012 13:40:55 +0900 (KST)
Received: from localhost.localdomain ([107.108.73.106])
 by mmp1.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTPA id <0MBY00EGRYBWQP90@mmp1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 16 Oct 2012 13:40:55 +0900 (KST)
From: Shaik Ameer Basha <shaik.ameer@samsung.com>
To: linux-media@vger.kernel.org
Cc: s.nawrocki@samsung.com, shaik.samsung@gmail.com
Subject: [PATCH] [media] exynos-gsc: change driver compatible string
Date: Tue, 16 Oct 2012 20:13:44 +0530
Message-id: <1350398624-20751-1-git-send-email-shaik.ameer@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As G-Scaler is going to stay unchanged across all exynos5 series
SoCs, changing the driver compatible string name to
"samsung,exynos5-gsc" from "samsung,exynos5250-gsc".

This change is as per the discussion in the devicetree forum.
http://www.mail-archive.com/devicetree-discuss@lists.ozlabs.org/msg16448.html

Signed-off-by: Shaik Ameer Basha <shaik.ameer@samsung.com>
---
 drivers/media/platform/exynos-gsc/gsc-core.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/exynos-gsc/gsc-core.c b/drivers/media/platform/exynos-gsc/gsc-core.c
index bfec9e6..19cbb12 100644
--- a/drivers/media/platform/exynos-gsc/gsc-core.c
+++ b/drivers/media/platform/exynos-gsc/gsc-core.c
@@ -965,8 +965,10 @@ static struct platform_device_id gsc_driver_ids[] = {
 MODULE_DEVICE_TABLE(platform, gsc_driver_ids);
 
 static const struct of_device_id exynos_gsc_match[] = {
-	{ .compatible = "samsung,exynos5250-gsc",
-	.data = &gsc_v_100_drvdata, },
+	{
+		.compatible = "samsung,exynos5-gsc",
+		.data = &gsc_v_100_drvdata,
+	},
 	{},
 };
 MODULE_DEVICE_TABLE(of, exynos_gsc_match);
-- 
1.7.0.4

