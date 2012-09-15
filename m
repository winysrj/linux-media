Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:34397 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754433Ab2IOPim (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 15 Sep 2012 11:38:42 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Shaik Ameer Basha <shaik.ameer@samsung.com>,
	Sungchun Kang <sungchun.kang@samsung.com>,
	"Seung-Woo Kim/Mobile S/W Platform Lab(DMC)/E4"
	<sw0312.kim@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH] [media] gscaler: mark it as BROKEN
Date: Sat, 15 Sep 2012 12:38:34 -0300
Message-Id: <1347723514-18361-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

-EMISSINGMAKEFILE

Without a Makefile, the driver will not compile, causing
breakages for arm exynos5 sub-architecture.

Cc: Shaik Ameer Basha <shaik.ameer@samsung.com>
Cc: Sungchun Kang <sungchun.kang@samsung.com>
Cc: "Seung-Woo Kim/Mobile S/W Platform Lab(DMC)/E4"  <sw0312.kim@samsung.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/platform/Kconfig  | 1 +
 drivers/media/platform/Makefile | 4 +++-
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/Kconfig b/drivers/media/platform/Kconfig
index 682594e..aa84d1d 100644
--- a/drivers/media/platform/Kconfig
+++ b/drivers/media/platform/Kconfig
@@ -184,6 +184,7 @@ config VIDEO_MX2_EMMAPRP
 config VIDEO_SAMSUNG_EXYNOS_GSC
 	tristate "Samsung Exynos G-Scaler driver"
 	depends on VIDEO_DEV && VIDEO_V4L2 && ARCH_EXYNOS5
+	depends on BROKEN
 	select VIDEOBUF2_DMA_CONTIG
 	select V4L2_MEM2MEM_DEV
 	help
diff --git a/drivers/media/platform/Makefile b/drivers/media/platform/Makefile
index baaa550..12d34c4 100644
--- a/drivers/media/platform/Makefile
+++ b/drivers/media/platform/Makefile
@@ -33,7 +33,9 @@ obj-$(CONFIG_VIDEO_SAMSUNG_S5P_MFC)	+= s5p-mfc/
 obj-$(CONFIG_VIDEO_SAMSUNG_S5P_TV)	+= s5p-tv/
 
 obj-$(CONFIG_VIDEO_SAMSUNG_S5P_G2D)	+= s5p-g2d/
-obj-$(CONFIG_VIDEO_SAMSUNG_EXYNOS_GSC)	+= exynos-gsc/
+
+# FIXME!!! This driver is broken, as there's no makefile there!
+#obj-$(CONFIG_VIDEO_SAMSUNG_EXYNOS_GSC)	+= exynos-gsc/
 
 obj-$(CONFIG_BLACKFIN)                  += blackfin/
 
-- 
1.7.11.4

