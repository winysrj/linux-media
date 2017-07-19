Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:53170 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752424AbdGSDOC (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 18 Jul 2017 23:14:02 -0400
From: Yong Zhi <yong.zhi@intel.com>
To: linux-media@vger.kernel.org, sakari.ailus@linux.intel.com
Cc: jian.xu.zheng@intel.com, rajmohan.mani@intel.com,
        hyungwoo.yang@intel.com, jerry.w.hu@intel.com,
        Yong Zhi <yong.zhi@intel.com>, Tomasz Figa <tfiga@chromium.org>
Subject: [PATCH v3 06/12] intel-ipu3: css: imgu dma buff pool
Date: Tue, 18 Jul 2017 22:13:38 -0500
Message-Id: <1500434023-2411-4-git-send-email-yong.zhi@intel.com>
In-Reply-To: <1500434023-2411-1-git-send-email-yong.zhi@intel.com>
References: <1500434023-2411-1-git-send-email-yong.zhi@intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The pools are used to store previous parameters set by
user with the parameter queue. Due to pipelining,
there needs to be multiple sets (up to four)
of parameters which are queued in a host-to-sp queue.

Signed-off-by: Yong Zhi <yong.zhi@intel.com>
Signed-off-by: Tomasz Figa <tfiga@chromium.org>
---
 drivers/media/pci/intel/ipu3/ipu3-css-pool.c | 130 +++++++++++++++++++++++++++
 drivers/media/pci/intel/ipu3/ipu3-css-pool.h |  53 +++++++++++
 2 files changed, 183 insertions(+)
 create mode 100644 drivers/media/pci/intel/ipu3/ipu3-css-pool.c
 create mode 100644 drivers/media/pci/intel/ipu3/ipu3-css-pool.h

diff --git a/drivers/media/pci/intel/ipu3/ipu3-css-pool.c b/drivers/media/pci/intel/ipu3/ipu3-css-pool.c
new file mode 100644
index 0000000..db5ae93b
--- /dev/null
+++ b/drivers/media/pci/intel/ipu3/ipu3-css-pool.c
@@ -0,0 +1,130 @@
+/*
+ * Copyright (c) 2017 Intel Corporation.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License version
+ * 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <linux/types.h>
+#include <linux/dma-mapping.h>
+
+#include "ipu3-css-pool.h"
+
+int ipu3_css_dma_alloc(struct device *dma_dev,
+		       struct ipu3_css_map *map, size_t size)
+{
+	if (size == 0) {
+		map->vaddr = NULL;
+		return 0;
+	}
+
+	map->vaddr = dma_alloc_coherent(dma_dev, size, &map->daddr, GFP_KERNEL);
+	if (!map->vaddr)
+		return -ENOMEM;
+	map->size = size;
+
+	return 0;
+}
+
+void ipu3_css_dma_free(struct device *dma_dev, struct ipu3_css_map *map)
+{
+	if (map->vaddr)
+		dma_free_coherent(dma_dev, map->size, map->vaddr, map->daddr);
+	map->vaddr = NULL;
+}
+
+void ipu3_css_pool_cleanup(struct device *dma_dev, struct ipu3_css_pool *pool)
+{
+	int i;
+
+	for (i = 0; i < IPU3_CSS_POOL_SIZE; i++)
+		ipu3_css_dma_free(dma_dev, &pool->entry[i].param);
+}
+
+int ipu3_css_pool_init(struct device *dma_dev, struct ipu3_css_pool *pool,
+		       int size)
+{
+	int i;
+
+	for (i = 0; i < IPU3_CSS_POOL_SIZE; i++) {
+		pool->entry[i].framenum = INT_MIN;
+		if (ipu3_css_dma_alloc(dma_dev, &pool->entry[i].param, size))
+			goto fail;
+	}
+
+	pool->last = IPU3_CSS_POOL_SIZE;
+
+	return 0;
+
+fail:
+	ipu3_css_pool_cleanup(dma_dev, pool);
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
+
+	/*
+	 * pool->entry[n].framenum stores the frame number where that
+	 * entry was allocated. If that was allocated more than POOL_SIZE
+	 * frames back, it is old enough that we know it is no more in
+	 * use by firmware.
+	 */
+	if (pool->entry[n].framenum + IPU3_CSS_POOL_SIZE > framenum)
+		return -ENOSPC;
+
+	return n;
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
diff --git a/drivers/media/pci/intel/ipu3/ipu3-css-pool.h b/drivers/media/pci/intel/ipu3/ipu3-css-pool.h
new file mode 100644
index 0000000..f776c45
--- /dev/null
+++ b/drivers/media/pci/intel/ipu3/ipu3-css-pool.h
@@ -0,0 +1,53 @@
+/*
+ * Copyright (c) 2017 Intel Corporation.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License version
+ * 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#ifndef __IPU3_UTIL_H
+#define __IPU3_UTIL_H
+
+#include <linux/device.h>
+
+#define sqr(x)				((x) * (x))
+#define DIV_ROUND_CLOSEST_DOWN(a, b)	(((a) + (b / 2) - 1) / (b))
+#define roundclosest_down(a, b)		(DIV_ROUND_CLOSEST_DOWN(a, b) * (b))
+#define roundclosest(n, di)				\
+	({ typeof(n) __n = (n); typeof(di) __di = (di); \
+	DIV_ROUND_CLOSEST(__n, __di) * __di; })
+
+#define IPU3_CSS_POOL_SIZE		4
+
+struct ipu3_css_map {
+	size_t size;
+	void *vaddr;
+	dma_addr_t daddr;
+};
+
+struct ipu3_css_pool {
+	struct {
+		struct ipu3_css_map param;
+		long framenum;
+	} entry[IPU3_CSS_POOL_SIZE];
+	unsigned int last; /* Latest entry */
+};
+
+int ipu3_css_dma_alloc(struct device *dma_dev, struct ipu3_css_map *map,
+			size_t size);
+void ipu3_css_dma_free(struct device *dma_dev, struct ipu3_css_map *map);
+void ipu3_css_pool_cleanup(struct device *dma_dev, struct ipu3_css_pool *pool);
+int ipu3_css_pool_init(struct device *dma_dev, struct ipu3_css_pool *pool,
+			int size);
+int ipu3_css_pool_get(struct ipu3_css_pool *pool, long framenum);
+void ipu3_css_pool_put(struct ipu3_css_pool *pool);
+const struct ipu3_css_map *ipu3_css_pool_last(struct ipu3_css_pool *pool,
+						unsigned int last);
+
+#endif
-- 
2.7.4
