Return-path: <mchehab@pedra>
Received: from smtp.nokia.com ([147.243.128.26]:41987 "EHLO mgw-da02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750922Ab1CYPNo (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 25 Mar 2011 11:13:44 -0400
From: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, david.cohen@nokia.com,
	hiroshi.doyu@nokia.com
Subject: [PATCH 4/4] omap iommu: Prevent iommu implementations from being unloaded while in use
Date: Fri, 25 Mar 2011 17:13:25 +0200
Message-Id: <1301066005-7882-4-git-send-email-sakari.ailus@maxwell.research.nokia.com>
In-Reply-To: <4D8CB106.7030608@maxwell.research.nokia.com>
References: <4D8CB106.7030608@maxwell.research.nokia.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Prevent module implementing arch_iommu from being unloaded while the
arch_iommu is in use, essentially while the iommu has been acquired using
iommu_get() by increasing module use count.

This assumes that the arch_iommu has to be uninstalled at module unload
time.

Signed-off-by: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
---
 arch/arm/plat-omap/iommu.c |   31 +++++++++++++++++++++++++++++--
 1 files changed, 29 insertions(+), 2 deletions(-)

diff --git a/arch/arm/plat-omap/iommu.c b/arch/arm/plat-omap/iommu.c
index f0fea0b..430ed94 100644
--- a/arch/arm/plat-omap/iommu.c
+++ b/arch/arm/plat-omap/iommu.c
@@ -35,6 +35,7 @@ static const struct iommu_functions *arch_iommu;
 
 static struct platform_driver omap_iommu_driver;
 static struct kmem_cache *iopte_cachep;
+static struct mutex arch_iommu_mutex;
 
 /**
  * install_iommu_arch - Install archtecure specific iommu functions
@@ -45,10 +46,17 @@ static struct kmem_cache *iopte_cachep;
  **/
 int install_iommu_arch(const struct iommu_functions *ops)
 {
-	if (arch_iommu)
+	mutex_lock(&arch_iommu_mutex);
+
+	if (arch_iommu) {
+		mutex_unlock(&arch_iommu_mutex);
 		return -EBUSY;
+	}
 
 	arch_iommu = ops;
+
+	mutex_unlock(&arch_iommu_mutex);
+
 	return 0;
 }
 EXPORT_SYMBOL_GPL(install_iommu_arch);
@@ -58,13 +66,22 @@ EXPORT_SYMBOL_GPL(install_iommu_arch);
  * @ops:	a pointer to architecture specific iommu functions
  *
  * This interface uninstalls the iommu algorighm installed previously.
+ *
+ * Note: This function may only be called at module_exit() function of
+ * a module which implements arch_iommu. Otherwise another mechanism
+ * from the module use count only to ensure the arch_iommu stays there
+ * has to be implemented.
  **/
 void uninstall_iommu_arch(const struct iommu_functions *ops)
 {
+	mutex_lock(&arch_iommu_mutex);
+
 	if (arch_iommu != ops)
 		pr_err("%s: not your arch\n", __func__);
 
 	arch_iommu = NULL;
+
+	mutex_unlock(&arch_iommu_mutex);
 }
 EXPORT_SYMBOL_GPL(uninstall_iommu_arch);
 
@@ -104,14 +121,20 @@ static int iommu_enable(struct iommu *obj)
 	if (!obj)
 		return -EINVAL;
 
-	if (!arch_iommu)
+	mutex_lock(&arch_iommu_mutex);
+	if (!arch_iommu || !try_module_get(arch_iommu->module)) {
+		mutex_unlock(&arch_iommu_mutex);
 		return -ENOENT;
+	}
 
 	clk_enable(obj->clk);
 
 	err = arch_iommu->enable(obj);
 
 	clk_disable(obj->clk);
+
+	mutex_unlock(&arch_iommu_mutex);
+
 	return err;
 }
 
@@ -125,6 +148,8 @@ static void iommu_disable(struct iommu *obj)
 	arch_iommu->disable(obj);
 
 	clk_disable(obj->clk);
+
+	module_put(arch_iommu->module);
 }
 
 /*
@@ -1058,6 +1083,8 @@ static int __init omap_iommu_init(void)
 		return -ENOMEM;
 	iopte_cachep = p;
 
+	mutex_init(&arch_iommu_mutex);
+
 	return platform_driver_register(&omap_iommu_driver);
 }
 module_init(omap_iommu_init);
-- 
1.7.2.3

