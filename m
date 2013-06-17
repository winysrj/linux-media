Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:10306 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752907Ab3FQQeu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 17 Jun 2013 12:34:50 -0400
From: Tomasz Figa <t.figa@samsung.com>
To: linux-samsung-soc@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org,
	Kukjin Kim <kgene.kim@samsung.com>,
	Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Thomas Abraham <thomas.abraham@linaro.org>,
	Tomasz Figa <t.figa@samsung.com>, linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Kamil Debski <k.debski@samsung.com>,
	Tomasz Stanislawski <t.stanislaws@samsung.com>,
	Jeongtae Park <jtp.park@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>
Subject: [PATCH v2 17/38] [media] platform: Check for ARCH_EXYNOS separately
Date: Mon, 17 Jun 2013 18:34:02 +0200
Message-id: <1371486863-12398-18-git-send-email-t.figa@samsung.com>
In-reply-to: <1371486863-12398-1-git-send-email-t.figa@samsung.com>
References: <1371486863-12398-1-git-send-email-t.figa@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

ARCH_EXYNOS is going to be excluded from PLAT_S5P, so it must be checked
separately in Exynos-related Kconfig entries.

Cc: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: Kamil Debski <k.debski@samsung.com>
Cc: Tomasz Stanislawski <t.stanislaws@samsung.com>
Cc: Jeongtae Park <jtp.park@samsung.com>
Signed-off-by: Tomasz Figa <t.figa@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/platform/Kconfig            | 6 +++---
 drivers/media/platform/exynos4-is/Kconfig | 3 ++-
 drivers/media/platform/s5p-tv/Kconfig     | 2 +-
 3 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/media/platform/Kconfig b/drivers/media/platform/Kconfig
index 0494d27..bce695d 100644
--- a/drivers/media/platform/Kconfig
+++ b/drivers/media/platform/Kconfig
@@ -159,7 +159,7 @@ config VIDEO_MEM2MEM_DEINTERLACE
 
 config VIDEO_SAMSUNG_S5P_G2D
 	tristate "Samsung S5P and EXYNOS4 G2D 2d graphics accelerator driver"
-	depends on VIDEO_DEV && VIDEO_V4L2 && PLAT_S5P
+	depends on VIDEO_DEV && VIDEO_V4L2 && (PLAT_S5P || ARCH_EXYNOS)
 	select VIDEOBUF2_DMA_CONTIG
 	select V4L2_MEM2MEM_DEV
 	default n
@@ -169,7 +169,7 @@ config VIDEO_SAMSUNG_S5P_G2D
 
 config VIDEO_SAMSUNG_S5P_JPEG
 	tristate "Samsung S5P/Exynos4 JPEG codec driver"
-	depends on VIDEO_DEV && VIDEO_V4L2 && PLAT_S5P
+	depends on VIDEO_DEV && VIDEO_V4L2 && (PLAT_S5P || ARCH_EXYNOS)
 	select VIDEOBUF2_DMA_CONTIG
 	select V4L2_MEM2MEM_DEV
 	---help---
@@ -177,7 +177,7 @@ config VIDEO_SAMSUNG_S5P_JPEG
 
 config VIDEO_SAMSUNG_S5P_MFC
 	tristate "Samsung S5P MFC Video Codec"
-	depends on VIDEO_DEV && VIDEO_V4L2 && PLAT_S5P
+	depends on VIDEO_DEV && VIDEO_V4L2 && (PLAT_S5P || ARCH_EXYNOS)
 	select VIDEOBUF2_DMA_CONTIG
 	default n
 	help
diff --git a/drivers/media/platform/exynos4-is/Kconfig b/drivers/media/platform/exynos4-is/Kconfig
index 6ff99b5..004fd0b 100644
--- a/drivers/media/platform/exynos4-is/Kconfig
+++ b/drivers/media/platform/exynos4-is/Kconfig
@@ -1,7 +1,8 @@
 
 config VIDEO_SAMSUNG_EXYNOS4_IS
 	bool "Samsung S5P/EXYNOS4 SoC series Camera Subsystem driver"
-	depends on VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API && PLAT_S5P && PM_RUNTIME
+	depends on VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API && PM_RUNTIME
+	depends on (PLAT_S5P || ARCH_EXYNOS)
 	help
 	  Say Y here to enable camera host interface devices for
 	  Samsung S5P and EXYNOS SoC series.
diff --git a/drivers/media/platform/s5p-tv/Kconfig b/drivers/media/platform/s5p-tv/Kconfig
index 7b659bd..369a4c1 100644
--- a/drivers/media/platform/s5p-tv/Kconfig
+++ b/drivers/media/platform/s5p-tv/Kconfig
@@ -8,7 +8,7 @@
 
 config VIDEO_SAMSUNG_S5P_TV
 	bool "Samsung TV driver for S5P platform"
-	depends on PLAT_S5P && PM_RUNTIME
+	depends on (PLAT_S5P || ARCH_EXYNOS) && PM_RUNTIME
 	default n
 	---help---
 	  Say Y here to enable selecting the TV output devices for
-- 
1.8.2.1

