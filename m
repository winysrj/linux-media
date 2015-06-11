Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay1.mentorg.com ([192.94.38.131]:45719 "EHLO
	relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932587AbbFKN2h (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Jun 2015 09:28:37 -0400
From: Vladimir Zapolskiy <vladimir_zapolskiy@mentor.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Philipp Zabel <p.zabel@pengutronix.de>
CC: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Vinod Koul <vinod.koul@intel.com>,
	Takashi Iwai <tiwai@suse.de>, Jaroslav Kysela <perex@perex.cz>,
	<dmaengine@vger.kernel.org>, <linux-media@vger.kernel.org>,
	<alsa-devel@alsa-project.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/2] genalloc: rename of_get_named_gen_pool() to of_gen_pool_get()
Date: Thu, 11 Jun 2015 16:28:32 +0300
Message-ID: <1434029312-7288-1-git-send-email-vladimir_zapolskiy@mentor.com>
In-Reply-To: <1434029192-7082-1-git-send-email-vladimir_zapolskiy@mentor.com>
References: <1434029192-7082-1-git-send-email-vladimir_zapolskiy@mentor.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

To be consistent with other kernel interface namings, rename
of_get_named_gen_pool() to of_gen_pool_get(). In the original
function name "_named" suffix references to a device tree property,
which contains a phandle to a device and the corresponding
device driver is assumed to register a gen_pool object.

Due to a weak relation and to avoid any confusion (e.g. in future
possible scenario if gen_pool objects are named) the suffix is
removed.

Signed-off-by: Vladimir Zapolskiy <vladimir_zapolskiy@mentor.com>
---
 drivers/dma/mmp_tdma.c                    | 2 +-
 drivers/media/platform/coda/coda-common.c | 2 +-
 include/linux/genalloc.h                  | 4 ++--
 lib/genalloc.c                            | 6 +++---
 sound/core/memalloc.c                     | 2 +-
 5 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/dma/mmp_tdma.c b/drivers/dma/mmp_tdma.c
index 449e785..e683761 100644
--- a/drivers/dma/mmp_tdma.c
+++ b/drivers/dma/mmp_tdma.c
@@ -657,7 +657,7 @@ static int mmp_tdma_probe(struct platform_device *pdev)
 	INIT_LIST_HEAD(&tdev->device.channels);
 
 	if (pdev->dev.of_node)
-		pool = of_get_named_gen_pool(pdev->dev.of_node, "asram", 0);
+		pool = of_gen_pool_get(pdev->dev.of_node, "asram", 0);
 	else
 		pool = sram_get_gpool("asram");
 	if (!pool) {
diff --git a/drivers/media/platform/coda/coda-common.c b/drivers/media/platform/coda/coda-common.c
index 6e640c0..58f6548 100644
--- a/drivers/media/platform/coda/coda-common.c
+++ b/drivers/media/platform/coda/coda-common.c
@@ -2155,7 +2155,7 @@ static int coda_probe(struct platform_device *pdev)
 	}
 
 	/* Get IRAM pool from device tree or platform data */
-	pool = of_get_named_gen_pool(np, "iram", 0);
+	pool = of_gen_pool_get(np, "iram", 0);
 	if (!pool && pdata)
 		pool = gen_pool_get(pdata->iram_dev);
 	if (!pool) {
diff --git a/include/linux/genalloc.h b/include/linux/genalloc.h
index 015d170..5383bb1 100644
--- a/include/linux/genalloc.h
+++ b/include/linux/genalloc.h
@@ -125,10 +125,10 @@ bool addr_in_gen_pool(struct gen_pool *pool, unsigned long start,
 			size_t size);
 
 #ifdef CONFIG_OF
-extern struct gen_pool *of_get_named_gen_pool(struct device_node *np,
+extern struct gen_pool *of_gen_pool_get(struct device_node *np,
 	const char *propname, int index);
 #else
-static inline struct gen_pool *of_get_named_gen_pool(struct device_node *np,
+static inline struct gen_pool *of_gen_pool_get(struct device_node *np,
 	const char *propname, int index)
 {
 	return NULL;
diff --git a/lib/genalloc.c b/lib/genalloc.c
index 948e92c..daf0afb 100644
--- a/lib/genalloc.c
+++ b/lib/genalloc.c
@@ -620,7 +620,7 @@ EXPORT_SYMBOL_GPL(gen_pool_get);
 
 #ifdef CONFIG_OF
 /**
- * of_get_named_gen_pool - find a pool by phandle property
+ * of_gen_pool_get - find a pool by phandle property
  * @np: device node
  * @propname: property name containing phandle(s)
  * @index: index into the phandle array
@@ -629,7 +629,7 @@ EXPORT_SYMBOL_GPL(gen_pool_get);
  * address of the device tree node pointed at by the phandle property,
  * or NULL if not found.
  */
-struct gen_pool *of_get_named_gen_pool(struct device_node *np,
+struct gen_pool *of_gen_pool_get(struct device_node *np,
 	const char *propname, int index)
 {
 	struct platform_device *pdev;
@@ -644,5 +644,5 @@ struct gen_pool *of_get_named_gen_pool(struct device_node *np,
 		return NULL;
 	return gen_pool_get(&pdev->dev);
 }
-EXPORT_SYMBOL_GPL(of_get_named_gen_pool);
+EXPORT_SYMBOL_GPL(of_gen_pool_get);
 #endif /* CONFIG_OF */
diff --git a/sound/core/memalloc.c b/sound/core/memalloc.c
index 082509e..f05cb6a 100644
--- a/sound/core/memalloc.c
+++ b/sound/core/memalloc.c
@@ -124,7 +124,7 @@ static void snd_malloc_dev_iram(struct snd_dma_buffer *dmab, size_t size)
 	dmab->addr = 0;
 
 	if (dev->of_node)
-		pool = of_get_named_gen_pool(dev->of_node, "iram", 0);
+		pool = of_gen_pool_get(dev->of_node, "iram", 0);
 
 	if (!pool)
 		return;
-- 
2.1.4

