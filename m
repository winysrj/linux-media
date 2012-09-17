Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:29707 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755593Ab2IQKzS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 17 Sep 2012 06:55:18 -0400
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: kyungmin.park@samsung.com, sw0312.kim@samsung.com,
	linux-samsung-soc@vger.kernel.org,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH 7/7] s5p-csis: Change regulator supply names
Date: Mon, 17 Sep 2012 12:54:33 +0200
Message-id: <1347879273-30463-4-git-send-email-s.nawrocki@samsung.com>
In-reply-to: <1347879273-30463-1-git-send-email-s.nawrocki@samsung.com>
References: <1347878888-30001-1-git-send-email-s.nawrocki@samsung.com>
 <1347879273-30463-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Rename the regulator supply names to more meaningful ones.
It's a prerequisite for adding device tree support.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/video/s5p-fimc/mipi-csis.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/media/video/s5p-fimc/mipi-csis.c b/drivers/media/video/s5p-fimc/mipi-csis.c
index fbfe739..4bf7a68 100644
--- a/drivers/media/video/s5p-fimc/mipi-csis.c
+++ b/drivers/media/video/s5p-fimc/mipi-csis.c
@@ -2,7 +2,7 @@
  * Samsung S5P/EXYNOS4 SoC series MIPI-CSI receiver driver
  *
  * Copyright (C) 2011 - 2012 Samsung Electronics Co., Ltd.
- * Sylwester Nawrocki, <s.nawrocki@samsung.com>
+ * Sylwester Nawrocki <s.nawrocki@samsung.com>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
@@ -110,8 +110,8 @@ static char *csi_clock_name[] = {
 #define NUM_CSIS_CLOCKS	ARRAY_SIZE(csi_clock_name)
 
 static const char * const csis_supply_name[] = {
-	"vdd11", /* 1.1V or 1.2V (s5pc100) MIPI CSI suppply */
-	"vdd18", /* VDD 1.8V and MIPI CSI PLL supply */
+	"vddcore",  /* CSIS Core (1.0V, 1.1V or 1.2V) suppply */
+	"vddio",    /* CSIS I/O and PLL (1.8V) supply */
 };
 #define CSIS_NUM_SUPPLIES ARRAY_SIZE(csis_supply_name)
 
-- 
1.7.11.3

