Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:56682 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751017AbaJFQKS (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 6 Oct 2014 12:10:18 -0400
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, pebolle@tiscali.nl,
	linux-samsung-soc@vger.kernel.org,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH v2] [media] Remove references to non-existent PLAT_S5P symbol
Date: Mon, 06 Oct 2014 18:10:06 +0200
Message-id: <1412611806-9346-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The PLAT_S5P Kconfig symbol was removed in commit d78c16ccde96
("ARM: SAMSUNG: Remove remaining legacy code"). However, there
are still some references to that symbol left, fix that by
substituting them with ARCH_S5PV210.

Reported-by: Paul Bolle <pebolle@tiscali.nl>
Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
---
 drivers/media/platform/Kconfig            |    6 +++---
 drivers/media/platform/exynos4-is/Kconfig |    2 +-
 drivers/media/platform/s5p-tv/Kconfig     |    2 +-
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/media/platform/Kconfig b/drivers/media/platform/Kconfig
index bee9074..3aac88f 100644
--- a/drivers/media/platform/Kconfig
+++ b/drivers/media/platform/Kconfig
@@ -166,7 +166,7 @@ config VIDEO_MEM2MEM_DEINTERLACE
 config VIDEO_SAMSUNG_S5P_G2D
 	tristate "Samsung S5P and EXYNOS4 G2D 2d graphics accelerator driver"
 	depends on VIDEO_DEV && VIDEO_V4L2
-	depends on PLAT_S5P || ARCH_EXYNOS || COMPILE_TEST
+	depends on ARCH_S5PV210 || ARCH_EXYNOS || COMPILE_TEST
 	depends on HAS_DMA
 	select VIDEOBUF2_DMA_CONTIG
 	select V4L2_MEM2MEM_DEV
@@ -178,7 +178,7 @@ config VIDEO_SAMSUNG_S5P_G2D
 config VIDEO_SAMSUNG_S5P_JPEG
 	tristate "Samsung S5P/Exynos3250/Exynos4 JPEG codec driver"
 	depends on VIDEO_DEV && VIDEO_V4L2
-	depends on PLAT_S5P || ARCH_EXYNOS || COMPILE_TEST
+	depends on ARCH_S5PV210 || ARCH_EXYNOS || COMPILE_TEST
 	depends on HAS_DMA
 	select VIDEOBUF2_DMA_CONTIG
 	select V4L2_MEM2MEM_DEV
@@ -189,7 +189,7 @@ config VIDEO_SAMSUNG_S5P_JPEG
 config VIDEO_SAMSUNG_S5P_MFC
 	tristate "Samsung S5P MFC Video Codec"
 	depends on VIDEO_DEV && VIDEO_V4L2
-	depends on PLAT_S5P || ARCH_EXYNOS || COMPILE_TEST
+	depends on ARCH_S5PV210 || ARCH_EXYNOS || COMPILE_TEST
 	depends on HAS_DMA
 	select VIDEOBUF2_DMA_CONTIG
 	default n
diff --git a/drivers/media/platform/exynos4-is/Kconfig b/drivers/media/platform/exynos4-is/Kconfig
index 77c9512..b7b2e47 100644
--- a/drivers/media/platform/exynos4-is/Kconfig
+++ b/drivers/media/platform/exynos4-is/Kconfig
@@ -2,7 +2,7 @@
 config VIDEO_SAMSUNG_EXYNOS4_IS
 	bool "Samsung S5P/EXYNOS4 SoC series Camera Subsystem driver"
 	depends on VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API
-	depends on (PLAT_S5P || ARCH_EXYNOS || COMPILE_TEST)
+	depends on ARCH_S5PV210 || ARCH_EXYNOS || COMPILE_TEST
 	depends on OF && COMMON_CLK
 	help
 	  Say Y here to enable camera host interface devices for
diff --git a/drivers/media/platform/s5p-tv/Kconfig b/drivers/media/platform/s5p-tv/Kconfig
index a9d56f8..beb180e 100644
--- a/drivers/media/platform/s5p-tv/Kconfig
+++ b/drivers/media/platform/s5p-tv/Kconfig
@@ -9,7 +9,7 @@
 config VIDEO_SAMSUNG_S5P_TV
 	bool "Samsung TV driver for S5P platform"
 	depends on PM_RUNTIME
-	depends on PLAT_S5P || ARCH_EXYNOS || COMPILE_TEST
+	depends on ARCH_S5PV210 || ARCH_EXYNOS || COMPILE_TEST
 	default n
 	---help---
 	  Say Y here to enable selecting the TV output devices for
--
1.7.9.5

