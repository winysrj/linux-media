Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay1.mentorg.com ([192.94.38.131]:45694 "EHLO
	relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932177AbbFKN2f (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Jun 2015 09:28:35 -0400
From: Vladimir Zapolskiy <vladimir_zapolskiy@mentor.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Philipp Zabel <p.zabel@pengutronix.de>
CC: Shawn Guo <shawn.guo@linaro.org>,
	Sascha Hauer <kernel@pengutronix.de>,
	Nicolas Ferre <nicolas.ferre@atmel.com>,
	Alexandre Belloni <alexandre.belloni@free-electrons.com>,
	Russell King <linux@arm.linux.org.uk>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	<linux-media@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>,
	<linux-kernel@vger.kernel.org>
Subject: [PATCH 1/2] genalloc: rename dev_get_gen_pool() to gen_pool_get()
Date: Thu, 11 Jun 2015 16:28:22 +0300
Message-ID: <1434029302-7239-1-git-send-email-vladimir_zapolskiy@mentor.com>
In-Reply-To: <1434029192-7082-1-git-send-email-vladimir_zapolskiy@mentor.com>
References: <1434029192-7082-1-git-send-email-vladimir_zapolskiy@mentor.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

To be consistent with other genalloc interface namings, rename
dev_get_gen_pool() to gen_pool_get(). The original omitted "dev_"
prefix is removed, since it points to argument type of the function,
and so it does not bring any useful information.

Signed-off-by: Vladimir Zapolskiy <vladimir_zapolskiy@mentor.com>
---
 arch/arm/mach-at91/pm.c                   | 2 +-
 arch/arm/mach-imx/pm-imx5.c               | 2 +-
 arch/arm/mach-imx/pm-imx6.c               | 2 +-
 drivers/media/platform/coda/coda-common.c | 2 +-
 include/linux/genalloc.h                  | 2 +-
 lib/genalloc.c                            | 8 ++++----
 6 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/arch/arm/mach-at91/pm.c b/arch/arm/mach-at91/pm.c
index 1e18476..e24df77 100644
--- a/arch/arm/mach-at91/pm.c
+++ b/arch/arm/mach-at91/pm.c
@@ -369,7 +369,7 @@ static void __init at91_pm_sram_init(void)
 		return;
 	}
 
-	sram_pool = dev_get_gen_pool(&pdev->dev);
+	sram_pool = gen_pool_get(&pdev->dev);
 	if (!sram_pool) {
 		pr_warn("%s: sram pool unavailable!\n", __func__);
 		return;
diff --git a/arch/arm/mach-imx/pm-imx5.c b/arch/arm/mach-imx/pm-imx5.c
index 0309ccd..1885676 100644
--- a/arch/arm/mach-imx/pm-imx5.c
+++ b/arch/arm/mach-imx/pm-imx5.c
@@ -297,7 +297,7 @@ static int __init imx_suspend_alloc_ocram(
 		goto put_node;
 	}
 
-	ocram_pool = dev_get_gen_pool(&pdev->dev);
+	ocram_pool = gen_pool_get(&pdev->dev);
 	if (!ocram_pool) {
 		pr_warn("%s: ocram pool unavailable!\n", __func__);
 		ret = -ENODEV;
diff --git a/arch/arm/mach-imx/pm-imx6.c b/arch/arm/mach-imx/pm-imx6.c
index b01650d..93ecf55 100644
--- a/arch/arm/mach-imx/pm-imx6.c
+++ b/arch/arm/mach-imx/pm-imx6.c
@@ -451,7 +451,7 @@ static int __init imx6q_suspend_init(const struct imx6_pm_socdata *socdata)
 		goto put_node;
 	}
 
-	ocram_pool = dev_get_gen_pool(&pdev->dev);
+	ocram_pool = gen_pool_get(&pdev->dev);
 	if (!ocram_pool) {
 		pr_warn("%s: ocram pool unavailable!\n", __func__);
 		ret = -ENODEV;
diff --git a/drivers/media/platform/coda/coda-common.c b/drivers/media/platform/coda/coda-common.c
index 6d6e0ca..6e640c0 100644
--- a/drivers/media/platform/coda/coda-common.c
+++ b/drivers/media/platform/coda/coda-common.c
@@ -2157,7 +2157,7 @@ static int coda_probe(struct platform_device *pdev)
 	/* Get IRAM pool from device tree or platform data */
 	pool = of_get_named_gen_pool(np, "iram", 0);
 	if (!pool && pdata)
-		pool = dev_get_gen_pool(pdata->iram_dev);
+		pool = gen_pool_get(pdata->iram_dev);
 	if (!pool) {
 		dev_err(&pdev->dev, "iram pool not available\n");
 		return -ENOMEM;
diff --git a/include/linux/genalloc.h b/include/linux/genalloc.h
index 1ccaab4..015d170 100644
--- a/include/linux/genalloc.h
+++ b/include/linux/genalloc.h
@@ -119,7 +119,7 @@ extern unsigned long gen_pool_best_fit(unsigned long *map, unsigned long size,
 
 extern struct gen_pool *devm_gen_pool_create(struct device *dev,
 		int min_alloc_order, int nid);
-extern struct gen_pool *dev_get_gen_pool(struct device *dev);
+extern struct gen_pool *gen_pool_get(struct device *dev);
 
 bool addr_in_gen_pool(struct gen_pool *pool, unsigned long start,
 			size_t size);
diff --git a/lib/genalloc.c b/lib/genalloc.c
index d214866..948e92c 100644
--- a/lib/genalloc.c
+++ b/lib/genalloc.c
@@ -602,12 +602,12 @@ struct gen_pool *devm_gen_pool_create(struct device *dev, int min_alloc_order,
 EXPORT_SYMBOL(devm_gen_pool_create);
 
 /**
- * dev_get_gen_pool - Obtain the gen_pool (if any) for a device
+ * gen_pool_get - Obtain the gen_pool (if any) for a device
  * @dev: device to retrieve the gen_pool from
  *
  * Returns the gen_pool for the device if one is present, or NULL.
  */
-struct gen_pool *dev_get_gen_pool(struct device *dev)
+struct gen_pool *gen_pool_get(struct device *dev)
 {
 	struct gen_pool **p = devres_find(dev, devm_gen_pool_release, NULL,
 					NULL);
@@ -616,7 +616,7 @@ struct gen_pool *dev_get_gen_pool(struct device *dev)
 		return NULL;
 	return *p;
 }
-EXPORT_SYMBOL_GPL(dev_get_gen_pool);
+EXPORT_SYMBOL_GPL(gen_pool_get);
 
 #ifdef CONFIG_OF
 /**
@@ -642,7 +642,7 @@ struct gen_pool *of_get_named_gen_pool(struct device_node *np,
 	of_node_put(np_pool);
 	if (!pdev)
 		return NULL;
-	return dev_get_gen_pool(&pdev->dev);
+	return gen_pool_get(&pdev->dev);
 }
 EXPORT_SYMBOL_GPL(of_get_named_gen_pool);
 #endif /* CONFIG_OF */
-- 
2.1.4

