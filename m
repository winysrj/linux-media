Return-Path: <SRS0=yFxv=OW=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 388BBC67873
	for <linux-media@archiver.kernel.org>; Thu, 13 Dec 2018 09:51:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 094EE208E7
	for <linux-media@archiver.kernel.org>; Thu, 13 Dec 2018 09:51:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 094EE208E7
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.intel.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728008AbeLMJvS (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 13 Dec 2018 04:51:18 -0500
Received: from mga06.intel.com ([134.134.136.31]:36728 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727969AbeLMJvR (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 13 Dec 2018 04:51:17 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 13 Dec 2018 01:51:16 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.56,348,1539673200"; 
   d="scan'208";a="125531649"
Received: from paasikivi.fi.intel.com ([10.237.72.42])
  by fmsmga002.fm.intel.com with ESMTP; 13 Dec 2018 01:51:14 -0800
Received: from punajuuri.localdomain (punajuuri.localdomain [192.168.240.130])
        by paasikivi.fi.intel.com (Postfix) with ESMTPS id 321BC204CC;
        Thu, 13 Dec 2018 11:51:14 +0200 (EET)
Received: from sailus by punajuuri.localdomain with local (Exim 4.89)
        (envelope-from <sakari.ailus@linux.intel.com>)
        id 1gXNeB-0003ta-TU; Thu, 13 Dec 2018 11:51:11 +0200
From:   Sakari Ailus <sakari.ailus@linux.intel.com>
To:     linux-media@vger.kernel.org
Cc:     yong.zhi@intel.com, laurent.pinchart@ideasonboard.com,
        rajmohan.mani@intel.com
Subject: [PATCH v9 07/22] media: staging/intel-ipu3: css: Add dma buff pool utility functions
Date:   Thu, 13 Dec 2018 11:50:52 +0200
Message-Id: <20181213095107.14894-8-sakari.ailus@linux.intel.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20181213095107.14894-1-sakari.ailus@linux.intel.com>
References: <20181213095107.14894-1-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

From: Yong Zhi <yong.zhi@intel.com>

The pools are used to store previous parameters set by
user with the parameter queue. Due to pipelining,
there needs to be multiple sets (up to four)
of parameters which are queued in a host-to-sp queue.

Signed-off-by: Yong Zhi <yong.zhi@intel.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/staging/media/ipu3/ipu3-css-pool.c | 100 +++++++++++++++++++++++++++++
 drivers/staging/media/ipu3/ipu3-css-pool.h |  55 ++++++++++++++++
 2 files changed, 155 insertions(+)
 create mode 100644 drivers/staging/media/ipu3/ipu3-css-pool.c
 create mode 100644 drivers/staging/media/ipu3/ipu3-css-pool.h

diff --git a/drivers/staging/media/ipu3/ipu3-css-pool.c b/drivers/staging/media/ipu3/ipu3-css-pool.c
new file mode 100644
index 0000000000000..6f271f81669b7
--- /dev/null
+++ b/drivers/staging/media/ipu3/ipu3-css-pool.c
@@ -0,0 +1,100 @@
+// SPDX-License-Identifier: GPL-2.0
+// Copyright (C) 2018 Intel Corporation
+
+#include <linux/device.h>
+
+#include "ipu3.h"
+#include "ipu3-css-pool.h"
+#include "ipu3-dmamap.h"
+
+int ipu3_css_dma_buffer_resize(struct imgu_device *imgu,
+			       struct ipu3_css_map *map, size_t size)
+{
+	if (map->size < size && map->vaddr) {
+		dev_warn(&imgu->pci_dev->dev, "dma buf resized from %zu to %zu",
+			 map->size, size);
+
+		ipu3_dmamap_free(imgu, map);
+		if (!ipu3_dmamap_alloc(imgu, map, size))
+			return -ENOMEM;
+	}
+
+	return 0;
+}
+
+void ipu3_css_pool_cleanup(struct imgu_device *imgu, struct ipu3_css_pool *pool)
+{
+	unsigned int i;
+
+	for (i = 0; i < IPU3_CSS_POOL_SIZE; i++)
+		ipu3_dmamap_free(imgu, &pool->entry[i].param);
+}
+
+int ipu3_css_pool_init(struct imgu_device *imgu, struct ipu3_css_pool *pool,
+		       size_t size)
+{
+	unsigned int i;
+
+	for (i = 0; i < IPU3_CSS_POOL_SIZE; i++) {
+		pool->entry[i].valid = false;
+		if (size == 0) {
+			pool->entry[i].param.vaddr = NULL;
+			continue;
+		}
+
+		if (!ipu3_dmamap_alloc(imgu, &pool->entry[i].param, size))
+			goto fail;
+	}
+
+	pool->last = IPU3_CSS_POOL_SIZE;
+
+	return 0;
+
+fail:
+	ipu3_css_pool_cleanup(imgu, pool);
+	return -ENOMEM;
+}
+
+/*
+ * Allocate a new parameter via recycling the oldest entry in the pool.
+ */
+void ipu3_css_pool_get(struct ipu3_css_pool *pool)
+{
+	/* Get the oldest entry */
+	u32 n = (pool->last + 1) % IPU3_CSS_POOL_SIZE;
+
+	pool->entry[n].valid = true;
+	pool->last = n;
+}
+
+/*
+ * Undo, for all practical purposes, the effect of pool_get().
+ */
+void ipu3_css_pool_put(struct ipu3_css_pool *pool)
+{
+	pool->entry[pool->last].valid = false;
+	pool->last = (pool->last + IPU3_CSS_POOL_SIZE - 1) % IPU3_CSS_POOL_SIZE;
+}
+
+/**
+ * ipu3_css_pool_last - Retrieve the nth pool entry from last
+ *
+ * @pool: a pointer to &struct ipu3_css_pool.
+ * @n: the distance to the last index.
+ *
+ * Returns:
+ *  The nth entry from last or null map to indicate no frame stored.
+ */
+const struct ipu3_css_map *
+ipu3_css_pool_last(struct ipu3_css_pool *pool, unsigned int n)
+{
+	static const struct ipu3_css_map null_map = { 0 };
+	int i = (pool->last + IPU3_CSS_POOL_SIZE - n) % IPU3_CSS_POOL_SIZE;
+
+	WARN_ON(n >= IPU3_CSS_POOL_SIZE);
+
+	if (!pool->entry[i].valid)
+		return &null_map;
+
+	return &pool->entry[i].param;
+}
diff --git a/drivers/staging/media/ipu3/ipu3-css-pool.h b/drivers/staging/media/ipu3/ipu3-css-pool.h
new file mode 100644
index 0000000000000..9c895efd2bfac
--- /dev/null
+++ b/drivers/staging/media/ipu3/ipu3-css-pool.h
@@ -0,0 +1,55 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright (C) 2018 Intel Corporation */
+
+#ifndef __IPU3_UTIL_H
+#define __IPU3_UTIL_H
+
+struct device;
+struct imgu_device;
+
+#define IPU3_CSS_POOL_SIZE		4
+
+/**
+ * ipu3_css_map - store DMA mapping info for buffer
+ *
+ * @size:		size of the buffer in bytes.
+ * @vaddr:		kernel virtual address.
+ * @daddr:		iova dma address to access IPU3.
+ * @vma:		private, a pointer to &struct vm_struct,
+ * 			used for ipu3_dmamap_free.
+ */
+struct ipu3_css_map {
+	size_t size;
+	void *vaddr;
+	dma_addr_t daddr;
+	struct vm_struct *vma;
+};
+
+/**
+ * ipu3_css_pool - circular buffer pool definition
+ *
+ * @entry:		array with IPU3_CSS_POOL_SIZE elements.
+ * @entry.param:	a &struct ipu3_css_map for storing the mem mapping.
+ * @entry.valid:	used to mark if the entry has vaid data.
+ * @last:		write pointer, initialized to IPU3_CSS_POOL_SIZE.
+ */
+struct ipu3_css_pool {
+	struct {
+		struct ipu3_css_map param;
+		bool valid;
+	} entry[IPU3_CSS_POOL_SIZE];
+	u32 last;
+};
+
+int ipu3_css_dma_buffer_resize(struct imgu_device *imgu,
+			       struct ipu3_css_map *map, size_t size);
+void ipu3_css_pool_cleanup(struct imgu_device *imgu,
+			   struct ipu3_css_pool *pool);
+int ipu3_css_pool_init(struct imgu_device *imgu, struct ipu3_css_pool *pool,
+		       size_t size);
+void ipu3_css_pool_get(struct ipu3_css_pool *pool);
+void ipu3_css_pool_put(struct ipu3_css_pool *pool);
+const struct ipu3_css_map *ipu3_css_pool_last(struct ipu3_css_pool *pool,
+					      u32 last);
+
+#endif
-- 
2.11.0

