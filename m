Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f173.google.com ([209.85.212.173]:52439 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754123Ab3LTWY0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 20 Dec 2013 17:24:26 -0500
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
To: linux-media@vger.kernel.org
Cc: linux-samsung-soc@vger.kernel.org,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH 6/6] exynos4-is: Remove dependency on PM_RUNTIME from Kconfig
Date: Fri, 20 Dec 2013 23:23:27 +0100
Message-Id: <1387578207-17625-7-git-send-email-s.nawrocki@samsung.com>
In-Reply-To: <1387578207-17625-1-git-send-email-s.nawrocki@samsung.com>
References: <1387578207-17625-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Now when the sub-drivers are fixed to work with runtime PM disabled
this erroneous dependency can be removed.
The CAM and ISP power domains should be left in active state by the
platform if runtime PM is not used.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
---
 drivers/media/platform/exynos4-is/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/platform/exynos4-is/Kconfig b/drivers/media/platform/exynos4-is/Kconfig
index d2d3b4b..01ed1ec 100644
--- a/drivers/media/platform/exynos4-is/Kconfig
+++ b/drivers/media/platform/exynos4-is/Kconfig
@@ -1,7 +1,7 @@
 
 config VIDEO_SAMSUNG_EXYNOS4_IS
 	bool "Samsung S5P/EXYNOS4 SoC series Camera Subsystem driver"
-	depends on VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API && PM_RUNTIME
+	depends on VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API
 	depends on (PLAT_S5P || ARCH_EXYNOS)
 	help
 	  Say Y here to enable camera host interface devices for
-- 
1.7.4.1

