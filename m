Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:60555 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755573Ab3EIPhI (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 9 May 2013 11:37:08 -0400
Received: from epcpsbgm1.samsung.com (epcpsbgm1 [203.254.230.26])
 by mailout4.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MMJ00EQ1FDP2XF0@mailout4.samsung.com> for
 linux-media@vger.kernel.org; Fri, 10 May 2013 00:37:06 +0900 (KST)
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: hj210.choi@samsung.com, dh09.lee@samsung.com, a.hajda@samsung.com,
	shaik.ameer@samsung.com, arun.kk@samsung.com,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>
Subject: [PATCH 01/13] exynos4-is: Remove platform_device_id table at fimc-lite
 driver
Date: Thu, 09 May 2013 17:36:33 +0200
Message-id: <1368113805-20233-2-git-send-email-s.nawrocki@samsung.com>
In-reply-to: <1368113805-20233-1-git-send-email-s.nawrocki@samsung.com>
References: <1368113805-20233-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The driver id_table is unused since all SoCs containing the FIMC-LITE
IP block have been dt-only. Just remove it.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/platform/exynos4-is/fimc-lite.c |   14 ++------------
 1 file changed, 2 insertions(+), 12 deletions(-)

diff --git a/drivers/media/platform/exynos4-is/fimc-lite.c b/drivers/media/platform/exynos4-is/fimc-lite.c
index 14bb7bc..8af8add 100644
--- a/drivers/media/platform/exynos4-is/fimc-lite.c
+++ b/drivers/media/platform/exynos4-is/fimc-lite.c
@@ -1,8 +1,8 @@
 /*
  * Samsung EXYNOS FIMC-LITE (camera host interface) driver
 *
- * Copyright (C) 2012 Samsung Electronics Co., Ltd.
- * Sylwester Nawrocki <s.nawrocki@samsung.com>
+ * Copyright (C) 2012 - 2013 Samsung Electronics Co., Ltd.
+ * Author: Sylwester Nawrocki <s.nawrocki@samsung.com>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
@@ -1626,15 +1626,6 @@ static struct flite_drvdata fimc_lite_drvdata_exynos4 = {
 	.out_hor_offs_align	= 8,
 };
 
-static struct platform_device_id fimc_lite_driver_ids[] = {
-	{
-		.name		= "exynos-fimc-lite",
-		.driver_data	= (unsigned long)&fimc_lite_drvdata_exynos4,
-	},
-	{ /* sentinel */ },
-};
-MODULE_DEVICE_TABLE(platform, fimc_lite_driver_ids);
-
 static const struct of_device_id flite_of_match[] = {
 	{
 		.compatible = "samsung,exynos4212-fimc-lite",
@@ -1647,7 +1638,6 @@ MODULE_DEVICE_TABLE(of, flite_of_match);
 static struct platform_driver fimc_lite_driver = {
 	.probe		= fimc_lite_probe,
 	.remove		= fimc_lite_remove,
-	.id_table	= fimc_lite_driver_ids,
 	.driver = {
 		.of_match_table = flite_of_match,
 		.name		= FIMC_LITE_DRV_NAME,
-- 
1.7.9.5

