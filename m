Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:39361 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965746Ab3FUNL3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 21 Jun 2013 09:11:29 -0400
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: kyungmin.park@samsung.com, linux-samsung-soc@vger.kernel.org,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH] MAINTAINERS: Update S5P/Exynos FIMC driver entry
Date: Fri, 21 Jun 2013 15:11:13 +0200
Message-id: <1371820273-14461-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This change is mainly to update the driver's path changed from
drivers/media/platform/s5p-fimc to drivers/media/platform/exynos4-is/.
While at it, remove non-existent files rule, move the whole entry to
the Samsung drivers section and add the patch tracking system URL
and git repository details.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
Changes since v1:
 - added SCM details, moved to proper location to keep
   alphabetical order
---
 MAINTAINERS |   19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 3d7782b..22435e8 100644
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
@@ -6945,6 +6936,16 @@ L:	linux-media@vger.kernel.org
 S:	Supported
 F:	drivers/media/i2c/s5c73m3/*
 
+SAMSUNG S5P/EXYNOS4 SOC SERIES CAMERA SUBSYSTEM DRIVERS
+M:	Kyungmin Park <kyungmin.park@samsung.com>
+M:	Sylwester Nawrocki <s.nawrocki@samsung.com>
+L:	linux-media@vger.kernel.org
+Q:	https://patchwork.linuxtv.org/project/linux-media/list/
+T:	git git://linuxtv.org/snawrocki/samsung.git
+S:	Supported
+F:	drivers/media/platform/exynos4-is/
+F:	include/media/s5p_fimc.h
+
 SERIAL DRIVERS
 M:	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
 L:	linux-serial@vger.kernel.org
-- 
1.7.9.5

