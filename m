Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:29262 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752530AbeC3CPR (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 29 Mar 2018 22:15:17 -0400
From: Yong Zhi <yong.zhi@intel.com>
To: linux-media@vger.kernel.org, sakari.ailus@linux.intel.com
Cc: tfiga@chromium.org, rajmohan.mani@intel.com,
        tuukka.toivonen@intel.com, jerry.w.hu@intel.com,
        jian.xu.zheng@intel.com, Yong Zhi <yong.zhi@intel.com>
Subject: [PATCH v6 05/12] intel-ipu3: css: Add dma buff pool utility functions
Date: Thu, 29 Mar 2018 21:14:53 -0500
Message-Id: <1522376100-22098-6-git-send-email-yong.zhi@intel.com>
In-Reply-To: <1522376100-22098-1-git-send-email-yong.zhi@intel.com>
References: <1522376100-22098-1-git-send-email-yong.zhi@intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The pools are used to store previous parameters set by
user with the parameter queue. Due to pipelining,
there needs to be multiple sets (up to four)
of parameters which are queued in a host-to-sp queue.

Signed-off-by: Yong Zhi <yong.zhi@intel.com>
---
 drivers/media/pci/intel/ipu3/ipu3-css-pool.c | 131 +++++++++++++++++++++++++++
 1 file changed, 131 insertions(+)
 create mode 100644 drivers/media/pci/intel/ipu3/ipu3-css-pool.c

diff --git a/drivers/media/pci/intel/ipu3/ipu3-css-pool.c b/drivers/media/pci/intel/ipu3/ipu3-css-pool.c
new file mode 100644
index 000000000000..84f6a7801a01
--- /dev/null
+++ b/drivers/media/pci/intel/ipu3/ipu3-css-pool.c
@@ -0,0 +1,131 @@
+// SPDX-License-Identifier: GPL-2.0
+// Copyright (C) 2018 Intel Corporation
+
+#include <linux/device.h>
+
+#include "ipu3-css-pool.h"
+#include "ipu3-dmamap.h"
+
+int ipu3_css_dma_buffer_resize(struct device *dev, struct ipu3_css_map *map,
+			       size_t size)
+{
+	if (map->size < size && map->vaddr) {
+		dev_warn(dev, "dma buffer is resized from %zu to %zu",
+			 map->size, size);
+
+		ipu3_dmamap_free(dev, map);
+		if (!ipu3_dmamap_alloc(dev, map, size))
+			return -ENOMEM;
+	}
+
+	return 0;
+}
+
+void ipu3_css_pool_cleanup(struct device *dev, struct ipu3_css_pool *pool)
+{
+	unsigned int i;
+
+	for (i = 0; i < IPU3_CSS_POOL_SIZE; i++)
+		ipu3_dmamap_free(dev, &pool->entry[i].param);
+}
+
+int ipu3_css_pool_init(struct device *dev, struct ipu3_css_pool *pool,
+		       size_t size)
+{
+	unsigned int i;
+
+	for (i = 0; i < IPU3_CSS_POOL_SIZE; i++) {
+		/*
+		 * entry[i].framenum is initialized to INT_MIN so that
+		 * ipu3_css_pool_check() can treat it as usesable slot.
+		 */
+		pool->entry[i].framenum = INT_MIN;
+
+		if (size == 0) {
+			pool->entry[i].param.vaddr = NULL;
+			continue;
+		}
+
+		if (!ipu3_dmamap_alloc(dev, &pool->entry[i].param, size))
+			goto fail;
+	}
+
+	pool->last = IPU3_CSS_POOL_SIZE;
+
+	return 0;
+
+fail:
+	ipu3_css_pool_cleanup(dev, pool);
+	return -ENOMEM;
+}
+
+/*
+ * Check that the following call to pool_get succeeds.
+ * Return negative on error.
+ */
+static int ipu3_css_pool_check(struct ipu3_css_pool *pool, long framenum)
+{
+	/* Get the oldest entry */
+	int n = (pool->last + 1) % IPU3_CSS_POOL_SIZE;
+	long diff = framenum - pool->entry[n].framenum;
+
+	/* if framenum wraps around and becomes smaller than entry n */
+	if (diff < 0)
+		diff += LONG_MAX;
+
+	/*
+	 * pool->entry[n].framenum stores the frame number where that
+	 * entry was allocated. If that was allocated more than POOL_SIZE
+	 * frames back, it is old enough that we know it is no more in
+	 * use by firmware.
+	 */
+	if (diff > IPU3_CSS_POOL_SIZE)
+		return n;
+
+	return -ENOSPC;
+}
+
+/*
+ * Allocate a new parameter from pool at frame number `framenum'.
+ * Release the oldest entry in the pool to make space for the new entry.
+ * Return negative on error.
+ */
+int ipu3_css_pool_get(struct ipu3_css_pool *pool, long framenum)
+{
+	int n = ipu3_css_pool_check(pool, framenum);
+
+	if (n < 0)
+		return n;
+
+	pool->entry[n].framenum = framenum;
+	pool->last = n;
+
+	return n;
+}
+
+/*
+ * Undo, for all practical purposes, the effect of pool_get().
+ */
+void ipu3_css_pool_put(struct ipu3_css_pool *pool)
+{
+	pool->entry[pool->last].framenum = INT_MIN;
+	pool->last = (pool->last + IPU3_CSS_POOL_SIZE - 1) % IPU3_CSS_POOL_SIZE;
+}
+
+/*
+ * Return the nth entry from last, if that entry has no frame stored,
+ * return a null map instead to indicate frame not available for the entry.
+ */
+const struct ipu3_css_map *
+ipu3_css_pool_last(struct ipu3_css_pool *pool, unsigned int n)
+{
+	static const struct ipu3_css_map null_map = { 0 };
+	int i = (pool->last + IPU3_CSS_POOL_SIZE - n) % IPU3_CSS_POOL_SIZE;
+
+	WARN_ON(n >= IPU3_CSS_POOL_SIZE);
+
+	if (pool->entry[i].framenum < 0)
+		return &null_map;
+
+	return &pool->entry[i].param;
+}
-- 
2.7.4
