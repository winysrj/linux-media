Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay1.mentorg.com ([192.94.38.131]:60951 "EHLO
	relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753380AbbGJJfO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 10 Jul 2015 05:35:14 -0400
From: Vladimir Zapolskiy <vladimir_zapolskiy@mentor.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: <linux-arm-kernel@lists.infradead.org>,
	<linux-media@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	"Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
	Russell King <linux@arm.linux.org.uk>,
	Nicolas Ferre <nicolas.ferre@atmel.com>,
	"Alexandre Belloni" <alexandre.belloni@free-electrons.com>,
	"Jean-Christophe Plagniol-Villard" <plagnioj@jcrosoft.com>,
	Shawn Guo <shawnguo@kernel.org>,
	Sascha Hauer <kernel@pengutronix.de>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Dinh Nguyen <dinguyen@opensource.altera.com>
Subject: [PATCH v2 1/2] genalloc: add name arg to gen_pool_get() and devm_gen_pool_create()
Date: Fri, 10 Jul 2015 12:33:37 +0300
Message-ID: <1436520817-20437-1-git-send-email-vladimir_zapolskiy@mentor.com>
In-Reply-To: <1434641182-23957-1-git-send-email-vladimir_zapolskiy@mentor.com>
References: <1434641182-23957-1-git-send-email-vladimir_zapolskiy@mentor.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This change modifies gen_pool_get() and devm_gen_pool_create() client
interfaces adding one more argument "name" of a gen_pool object.

Due to implementation gen_pool_get() is capable to retrieve only one
gen_pool associated with a device even if multiple gen_pools are created,
fortunately right at the moment it is sufficient for the clients, hence
provide NULL as a valid argument on both producer devm_gen_pool_create()
and consumer gen_pool_get() sides.

Because only one created gen_pool per device is addressable, explicitly
add a restriction to devm_gen_pool_create() to create only one gen_pool
per device, this implies two possible error codes returned by the
function, account it on client side (only misc/sram).  This completes
client side changes related to genalloc updates.

Signed-off-by: Vladimir Zapolskiy <vladimir_zapolskiy@mentor.com>
Cc: Philipp Zabel <p.zabel@pengutronix.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>
Cc: Shawn Guo <shawnguo@kernel.org>
Cc: Sascha Hauer <kernel@pengutronix.de>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Dinh Nguyen <dinguyen@opensource.altera.com>
---

Changes from v1 to v2:
* Added the same change in gen_pool_get() argument list
  to account a recently added client in arm/mach-socfpga/pm.c

 arch/arm/mach-at91/pm.c                   |  2 +-
 arch/arm/mach-imx/pm-imx5.c               |  2 +-
 arch/arm/mach-imx/pm-imx6.c               |  2 +-
 arch/arm/mach-socfpga/pm.c                |  2 +-
 drivers/media/platform/coda/coda-common.c |  2 +-
 drivers/misc/sram.c                       |  8 ++---
 include/linux/genalloc.h                  |  4 +--
 lib/genalloc.c                            | 49 ++++++++++++++++++-------------
 8 files changed, 39 insertions(+), 32 deletions(-)

diff --git a/arch/arm/mach-at91/pm.c b/arch/arm/mach-at91/pm.c
index e24df77..e65e9db 100644
--- a/arch/arm/mach-at91/pm.c
+++ b/arch/arm/mach-at91/pm.c
@@ -369,7 +369,7 @@ static void __init at91_pm_sram_init(void)
 		return;
 	}
 
-	sram_pool = gen_pool_get(&pdev->dev);
+	sram_pool = gen_pool_get(&pdev->dev, NULL);
 	if (!sram_pool) {
 		pr_warn("%s: sram pool unavailable!\n", __func__);
 		return;
diff --git a/arch/arm/mach-imx/pm-imx5.c b/arch/arm/mach-imx/pm-imx5.c
index 1885676..532d4b0 100644
--- a/arch/arm/mach-imx/pm-imx5.c
+++ b/arch/arm/mach-imx/pm-imx5.c
@@ -297,7 +297,7 @@ static int __init imx_suspend_alloc_ocram(
 		goto put_node;
 	}
 
-	ocram_pool = gen_pool_get(&pdev->dev);
+	ocram_pool = gen_pool_get(&pdev->dev, NULL);
 	if (!ocram_pool) {
 		pr_warn("%s: ocram pool unavailable!\n", __func__);
 		ret = -ENODEV;
diff --git a/arch/arm/mach-imx/pm-imx6.c b/arch/arm/mach-imx/pm-imx6.c
index 93ecf55..8ff8fc0 100644
--- a/arch/arm/mach-imx/pm-imx6.c
+++ b/arch/arm/mach-imx/pm-imx6.c
@@ -451,7 +451,7 @@ static int __init imx6q_suspend_init(const struct imx6_pm_socdata *socdata)
 		goto put_node;
 	}
 
-	ocram_pool = gen_pool_get(&pdev->dev);
+	ocram_pool = gen_pool_get(&pdev->dev, NULL);
 	if (!ocram_pool) {
 		pr_warn("%s: ocram pool unavailable!\n", __func__);
 		ret = -ENODEV;
diff --git a/arch/arm/mach-socfpga/pm.c b/arch/arm/mach-socfpga/pm.c
index 6a4199f..c378ab0 100644
--- a/arch/arm/mach-socfpga/pm.c
+++ b/arch/arm/mach-socfpga/pm.c
@@ -56,7 +56,7 @@ static int socfpga_setup_ocram_self_refresh(void)
 		goto put_node;
 	}
 
-	ocram_pool = gen_pool_get(&pdev->dev);
+	ocram_pool = gen_pool_get(&pdev->dev, NULL);
 	if (!ocram_pool) {
 		pr_warn("%s: ocram pool unavailable!\n", __func__);
 		ret = -ENODEV;
diff --git a/drivers/media/platform/coda/coda-common.c b/drivers/media/platform/coda/coda-common.c
index 58f6548..284ac4c 100644
--- a/drivers/media/platform/coda/coda-common.c
+++ b/drivers/media/platform/coda/coda-common.c
@@ -2157,7 +2157,7 @@ static int coda_probe(struct platform_device *pdev)
 	/* Get IRAM pool from device tree or platform data */
 	pool = of_gen_pool_get(np, "iram", 0);
 	if (!pool && pdata)
-		pool = gen_pool_get(pdata->iram_dev);
+		pool = gen_pool_get(pdata->iram_dev, NULL);
 	if (!pool) {
 		dev_err(&pdev->dev, "iram pool not available\n");
 		return -ENOMEM;
diff --git a/drivers/misc/sram.c b/drivers/misc/sram.c
index 15c33cc..431e1dd 100644
--- a/drivers/misc/sram.c
+++ b/drivers/misc/sram.c
@@ -186,10 +186,10 @@ static int sram_probe(struct platform_device *pdev)
 	if (IS_ERR(sram->virt_base))
 		return PTR_ERR(sram->virt_base);
 
-	sram->pool = devm_gen_pool_create(sram->dev,
-					  ilog2(SRAM_GRANULARITY), -1);
-	if (!sram->pool)
-		return -ENOMEM;
+	sram->pool = devm_gen_pool_create(sram->dev, ilog2(SRAM_GRANULARITY),
+					  NUMA_NO_NODE, NULL);
+	if (IS_ERR(sram->pool))
+		return PTR_ERR(sram->pool);
 
 	ret = sram_reserve_regions(sram, res);
 	if (ret)
diff --git a/include/linux/genalloc.h b/include/linux/genalloc.h
index 5383bb1..6afa65e 100644
--- a/include/linux/genalloc.h
+++ b/include/linux/genalloc.h
@@ -118,8 +118,8 @@ extern unsigned long gen_pool_best_fit(unsigned long *map, unsigned long size,
 		unsigned long start, unsigned int nr, void *data);
 
 extern struct gen_pool *devm_gen_pool_create(struct device *dev,
-		int min_alloc_order, int nid);
-extern struct gen_pool *gen_pool_get(struct device *dev);
+		int min_alloc_order, int nid, const char *name);
+extern struct gen_pool *gen_pool_get(struct device *dev, const char *name);
 
 bool addr_in_gen_pool(struct gen_pool *pool, unsigned long start,
 			size_t size);
diff --git a/lib/genalloc.c b/lib/genalloc.c
index daf0afb..7cf19a5 100644
--- a/lib/genalloc.c
+++ b/lib/genalloc.c
@@ -571,23 +571,46 @@ static void devm_gen_pool_release(struct device *dev, void *res)
 }
 
 /**
+ * gen_pool_get - Obtain the gen_pool (if any) for a device
+ * @dev: device to retrieve the gen_pool from
+ * @name: name of a gen_pool or NULL, identifies a particular gen_pool on device
+ *
+ * Returns the gen_pool for the device if one is present, or NULL.
+ */
+struct gen_pool *gen_pool_get(struct device *dev, const char *name)
+{
+	struct gen_pool **p = devres_find(dev, devm_gen_pool_release,
+					  NULL, NULL);
+
+	if (!p)
+		return NULL;
+	return *p;
+}
+EXPORT_SYMBOL_GPL(gen_pool_get);
+
+/**
  * devm_gen_pool_create - managed gen_pool_create
  * @dev: device that provides the gen_pool
  * @min_alloc_order: log base 2 of number of bytes each bitmap bit represents
- * @nid: node id of the node the pool structure should be allocated on, or -1
+ * @nid: node selector for allocated gen_pool, %NUMA_NO_NODE for all nodes
+ * @name: name of a gen_pool or NULL, identifies a particular gen_pool on device
  *
  * Create a new special memory pool that can be used to manage special purpose
  * memory not managed by the regular kmalloc/kfree interface. The pool will be
  * automatically destroyed by the device management code.
  */
 struct gen_pool *devm_gen_pool_create(struct device *dev, int min_alloc_order,
-		int nid)
+				      int nid, const char *name)
 {
 	struct gen_pool **ptr, *pool;
 
+	/* Check that genpool to be created is uniquely addressed on device */
+	if (gen_pool_get(dev, name))
+		return ERR_PTR(-EINVAL);
+
 	ptr = devres_alloc(devm_gen_pool_release, sizeof(*ptr), GFP_KERNEL);
 	if (!ptr)
-		return NULL;
+		return ERR_PTR(-ENOMEM);
 
 	pool = gen_pool_create(min_alloc_order, nid);
 	if (pool) {
@@ -595,29 +618,13 @@ struct gen_pool *devm_gen_pool_create(struct device *dev, int min_alloc_order,
 		devres_add(dev, ptr);
 	} else {
 		devres_free(ptr);
+		return ERR_PTR(-ENOMEM);
 	}
 
 	return pool;
 }
 EXPORT_SYMBOL(devm_gen_pool_create);
 
-/**
- * gen_pool_get - Obtain the gen_pool (if any) for a device
- * @dev: device to retrieve the gen_pool from
- *
- * Returns the gen_pool for the device if one is present, or NULL.
- */
-struct gen_pool *gen_pool_get(struct device *dev)
-{
-	struct gen_pool **p = devres_find(dev, devm_gen_pool_release, NULL,
-					NULL);
-
-	if (!p)
-		return NULL;
-	return *p;
-}
-EXPORT_SYMBOL_GPL(gen_pool_get);
-
 #ifdef CONFIG_OF
 /**
  * of_gen_pool_get - find a pool by phandle property
@@ -642,7 +649,7 @@ struct gen_pool *of_gen_pool_get(struct device_node *np,
 	of_node_put(np_pool);
 	if (!pdev)
 		return NULL;
-	return gen_pool_get(&pdev->dev);
+	return gen_pool_get(&pdev->dev, NULL);
 }
 EXPORT_SYMBOL_GPL(of_gen_pool_get);
 #endif /* CONFIG_OF */
-- 
2.1.4

