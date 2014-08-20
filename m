Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:40826 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751037AbaHTUMG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 20 Aug 2014 16:12:06 -0400
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 3/5] [media] allow COMPILE_TEST for SAMSUNG_EXYNOS4_IS
Date: Wed, 20 Aug 2014 15:11:55 -0500
Message-Id: <1408565517-22034-3-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1408565517-22034-1-git-send-email-m.chehab@samsung.com>
References: <1408565517-22034-1-git-send-email-m.chehab@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

That helps some static checks, so enable it. While there, it was
noticed that linux/sizes.h was missing:

drivers/media/platform/exynos4-is/mipi-csis.c: In function ‘s5pcsis_s_rx_buffer’:
drivers/media/platform/exynos4-is/mipi-csis.c:114:31: error: ‘SZ_4K’ undeclared (first use in this function)
 #define S5PCSIS_PKTDATA_SIZE  SZ_4K
                               ^

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/platform/exynos4-is/Kconfig     | 2 +-
 drivers/media/platform/exynos4-is/mipi-csis.c | 1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/exynos4-is/Kconfig b/drivers/media/platform/exynos4-is/Kconfig
index 5dcaa0a80540..811872195f36 100644
--- a/drivers/media/platform/exynos4-is/Kconfig
+++ b/drivers/media/platform/exynos4-is/Kconfig
@@ -2,7 +2,7 @@
 config VIDEO_SAMSUNG_EXYNOS4_IS
 	bool "Samsung S5P/EXYNOS4 SoC series Camera Subsystem driver"
 	depends on VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API
-	depends on (PLAT_S5P || ARCH_EXYNOS)
+	depends on (PLAT_S5P || ARCH_EXYNOS || COMPILE_TEST)
 	depends on OF && COMMON_CLK
 	help
 	  Say Y here to enable camera host interface devices for
diff --git a/drivers/media/platform/exynos4-is/mipi-csis.c b/drivers/media/platform/exynos4-is/mipi-csis.c
index ae54ef5f535d..e05ce02c0ff9 100644
--- a/drivers/media/platform/exynos4-is/mipi-csis.c
+++ b/drivers/media/platform/exynos4-is/mipi-csis.c
@@ -25,6 +25,7 @@
 #include <linux/platform_device.h>
 #include <linux/pm_runtime.h>
 #include <linux/regulator/consumer.h>
+#include <linux/sizes.h>
 #include <linux/slab.h>
 #include <linux/spinlock.h>
 #include <linux/videodev2.h>
-- 
1.9.3

