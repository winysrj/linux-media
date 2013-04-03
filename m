Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:32285 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763353Ab3DCJ41 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 3 Apr 2013 05:56:27 -0400
Received: from epcpsbgm1.samsung.com (epcpsbgm1 [203.254.230.26])
 by mailout2.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MKO005TWBM1PT90@mailout2.samsung.com> for
 linux-media@vger.kernel.org; Wed, 03 Apr 2013 18:56:26 +0900 (KST)
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: kyungmin.park@samsung.com, t.figa@samsung.com,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH v2] exynos4-is: Remove dependency on SYSCON for non-dt platforms
Date: Wed, 03 Apr 2013 11:55:53 +0200
Message-id: <1364982953-21324-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Currently the whole driver depends on MFD_SYSCON, which in turn
depends on OF. To allow to use the driver on non-dt platforms
(S5PV210) the SYSREG support is made conditional (it is needed
only for dt enabled platforms) and MFD_SYSCON is selected if
OF is enabled, instead of depending on OF.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---

Changes since v1:
 - select MFD_SYSCON if OF is enabled and use this symbol in
   the code, rather than creating a separate Kconfig option.

---
 drivers/media/platform/exynos4-is/Kconfig     |    2 +-
 drivers/media/platform/exynos4-is/fimc-core.c |    3 +--
 drivers/media/platform/exynos4-is/fimc-core.h |   10 ++++++++++
 drivers/media/platform/exynos4-is/fimc-reg.c  |    3 +++
 4 files changed, 15 insertions(+), 3 deletions(-)

diff --git a/drivers/media/platform/exynos4-is/Kconfig b/drivers/media/platform/exynos4-is/Kconfig
index 91dbd4b..ae57920 100644
--- a/drivers/media/platform/exynos4-is/Kconfig
+++ b/drivers/media/platform/exynos4-is/Kconfig
@@ -2,7 +2,6 @@
 config VIDEO_SAMSUNG_EXYNOS4_IS
 	bool "Samsung S5P/EXYNOS4 SoC series Camera Subsystem driver"
 	depends on VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API && PLAT_S5P && PM_RUNTIME
-	depends on MFD_SYSCON
 	help
 	  Say Y here to enable camera host interface devices for
 	  Samsung S5P and EXYNOS SoC series.
@@ -14,6 +13,7 @@ config VIDEO_S5P_FIMC
 	depends on I2C
 	select VIDEOBUF2_DMA_CONTIG
 	select V4L2_MEM2MEM_DEV
+	select MFD_SYSCON if OF
 	help
 	  This is a V4L2 driver for Samsung S5P and EXYNOS4 SoC camera host
 	  interface and video postprocessor (FIMC) devices.
diff --git a/drivers/media/platform/exynos4-is/fimc-core.c b/drivers/media/platform/exynos4-is/fimc-core.c
index 44239e5..6b4a244 100644
--- a/drivers/media/platform/exynos4-is/fimc-core.c
+++ b/drivers/media/platform/exynos4-is/fimc-core.c
@@ -966,8 +966,7 @@ static int fimc_probe(struct platform_device *pdev)
 	spin_lock_init(&fimc->slock);
 	mutex_init(&fimc->lock);

-	fimc->sysreg = syscon_regmap_lookup_by_phandle(dev->of_node,
-						"samsung,sysreg");
+	fimc->sysreg = fimc_get_sysreg_regmap(dev->of_node);
 	if (IS_ERR(fimc->sysreg))
 		return PTR_ERR(fimc->sysreg);

diff --git a/drivers/media/platform/exynos4-is/fimc-core.h b/drivers/media/platform/exynos4-is/fimc-core.h
index 793333a..7d361b2 100644
--- a/drivers/media/platform/exynos4-is/fimc-core.h
+++ b/drivers/media/platform/exynos4-is/fimc-core.h
@@ -15,6 +15,7 @@
 #include <linux/regmap.h>
 #include <linux/sched.h>
 #include <linux/spinlock.h>
+#include <linux/mfd/syscon.h>
 #include <linux/types.h>
 #include <linux/videodev2.h>
 #include <linux/io.h>
@@ -645,6 +646,15 @@ void fimc_unregister_m2m_device(struct fimc_dev *fimc);
 int fimc_register_driver(void);
 void fimc_unregister_driver(void);

+#ifdef CONFIG_MFD_SYSCON
+static inline struct regmap * fimc_get_sysreg_regmap(struct device_node *node)
+{
+	return syscon_regmap_lookup_by_phandle(node, "samsung,sysreg");
+}
+#else
+#define fimc_get_sysreg_regmap(node) (NULL)
+#endif
+
 /* -----------------------------------------------------*/
 /* fimc-m2m.c */
 void fimc_m2m_job_finish(struct fimc_ctx *ctx, int vb_state);
diff --git a/drivers/media/platform/exynos4-is/fimc-reg.c b/drivers/media/platform/exynos4-is/fimc-reg.c
index c276eb8..c82e9bd 100644
--- a/drivers/media/platform/exynos4-is/fimc-reg.c
+++ b/drivers/media/platform/exynos4-is/fimc-reg.c
@@ -805,6 +805,9 @@ int fimc_hw_camblk_cfg_writeback(struct fimc_dev *fimc)
 	unsigned int mask, val, camblk_cfg;
 	int ret;

+	if (map == NULL)
+		return 0;
+
 	ret = regmap_read(map, SYSREG_CAMBLK, &camblk_cfg);
 	if (ret < 0 || ((camblk_cfg & 0x00700000) >> 20 != 0x3))
 		return ret;
--
1.7.9.5

