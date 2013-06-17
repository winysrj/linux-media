Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:64387 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752874Ab3FQQnK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 17 Jun 2013 12:43:10 -0400
Received: from epcpsbgm2.samsung.com (epcpsbgm2 [203.254.230.27])
 by mailout2.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MOJ00BBHQFXAK20@mailout2.samsung.com> for
 linux-media@vger.kernel.org; Tue, 18 Jun 2013 01:43:09 +0900 (KST)
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>
Subject: [PATCH] MAINTAINERS: Update S5P/Exynos FIMC driver entry
Date: Mon, 17 Jun 2013 18:42:51 +0200
Message-id: <1371487371-31143-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This change is mainly to update the driver's path changed from
drivers/media/platform/s5p-fimc to drivers/media/platform/exynos4-is/.
While at it, remove non-existent files rule, move the whole entry to
the Samsung drivers section and add the patch tracking system URL.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 MAINTAINERS |   17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 3d7782b..d2c5618 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1153,15 +1153,6 @@ L:	linux-media@vger.kernel.org
 S:	Maintained
 F:	drivers/media/platform/s5p-g2d/
 
-ARM/SAMSUNG S5P SERIES FIMC SUPPORT
-M:	Kyungmin Park <kyungmin.park@samsung.com>
-M:	Sylwester Nawrocki <s.nawrocki@samsung.com>
-L:	linux-arm-kernel@lists.infradead.org
-L:	linux-media@vger.kernel.org
-S:	Maintained
-F:	arch/arm/plat-samsung/include/plat/*fimc*
-F:	drivers/media/platform/s5p-fimc/
-
 ARM/SAMSUNG S5P SERIES Multi Format Codec (MFC) SUPPORT
 M:	Kyungmin Park <kyungmin.park@samsung.com>
 M:	Kamil Debski <k.debski@samsung.com>
@@ -6930,6 +6921,14 @@ F:	drivers/regulator/s5m*.c
 F:	drivers/rtc/rtc-sec.c
 F:	include/linux/mfd/samsung/
 
+SAMSUNG S5P/EXYNOS4 SOC SERIES CAMERA SUBSYSTEM DRIVERS
+M:	Kyungmin Park <kyungmin.park@samsung.com>
+M:	Sylwester Nawrocki <s.nawrocki@samsung.com>
+L:	linux-media@vger.kernel.org
+Q:	https://patchwork.linuxtv.org/project/linux-media/list/
+S:	Supported
+F:	drivers/media/platform/exynos4-is/
+
 SAMSUNG S3C24XX/S3C64XX SOC SERIES CAMIF DRIVER
 M:	Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
 L:	linux-media@vger.kernel.org
-- 
1.7.9.5

