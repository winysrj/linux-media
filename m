Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:54625 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760408Ab3DBN0V (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 2 Apr 2013 09:26:21 -0400
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: kyungmin.park@samsung.com, linux-samsung-soc@vger.kernel.org,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH] exynos4-is: Remove dependency on SYSCON for non-dt platforms
Date: Tue, 02 Apr 2013 15:26:05 +0200
Message-id: <1364909165-25136-1-git-send-email-s.nawrocki@samsung.com>
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
 drivers/media/platform/exynos4-is/Kconfig     |    7 ++++++-
 drivers/media/platform/exynos4-is/fimc-core.c |    3 +--
 drivers/media/platform/exynos4-is/fimc-core.h |   10 ++++++++++
 drivers/media/platform/exynos4-is/fimc-reg.c  |    3 +++
 4 files changed, 20 insertions(+), 3 deletions(-)

diff --git a/drivers/media/platform/exynos4-is/Kconfig b/drivers/media/platform/exynos4-is/Kconfig
index 6954f05..c56f714 100644
--- a/drivers/media/platform/exynos4-is/Kconfig
+++ b/drivers/media/platform/exynos4-is/Kconfig
@@ -3,13 +3,18 @@ config VIDEO_SAMSUNG_EXYNOS4_IS
 	bool "Samsung S5P/EXYNOS4 SoC series Camera Subsystem driver"
 	depends on VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API && PLAT_S5P && PM_RUNTIME
 	depends on EXPERIMENTAL
-	depends on MFD_SYSCON
 	help
 	  Say Y here to enable camera host interface devices for
 	  Samsung S5P and EXYNOS SoC series.
 
 if VIDEO_SAMSUNG_EXYNOS4_IS
 
+config FIMC_SYSREG
+       bool
+       depends on OF
+       select MFD_SYSCON
+       default y
+
 config VIDEO_S5P_FIMC
 	tristate "S5P/EXYNOS4 FIMC/CAMIF camera interface driver"
 	depends on I2C
diff --git a/drivers/media/platform/exynos4-is/fimc-core.c b/drivers/media/platform/exynos4-is/fimc-core.c
index f6efa47..c7a8bc1 100644
--- a/drivers/media/platform/exynos4-is/fimc-core.c
+++ b/drivers/media/platform/exynos4-is/fimc-core.c
@@ -964,8 +964,7 @@ static int fimc_probe(struct platform_device *pdev)
 	spin_lock_init(&fimc->slock);
 	mutex_init(&fimc->lock);
 
-	fimc->sysreg = syscon_regmap_lookup_by_phandle(dev->of_node,
-						"samsung,sysreg");
+	fimc->sysreg = fimc_get_sysreg_regmap(dev->of_node);
 	if (IS_ERR(fimc->sysreg))
 		return PTR_ERR(fimc->sysreg);
 
diff --git a/drivers/media/platform/exynos4-is/fimc-core.h b/drivers/media/platform/exynos4-is/fimc-core.h
index de2b57e..dfd7476 100644
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
@@ -646,6 +647,15 @@ void fimc_unregister_m2m_device(struct fimc_dev *fimc);
 int fimc_register_driver(void);
 void fimc_unregister_driver(void);
 
+#ifdef CONFIG_FIMC_SYSREG
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
index fd144a1..f079f36 100644
--- a/drivers/media/platform/exynos4-is/fimc-reg.c
+++ b/drivers/media/platform/exynos4-is/fimc-reg.c
@@ -806,6 +806,9 @@ int fimc_hw_camblk_cfg_writeback(struct fimc_dev *fimc)
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

