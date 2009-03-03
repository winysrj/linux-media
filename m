Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:32277 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753944AbZCCKHe (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 3 Mar 2009 05:07:34 -0500
From: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
To: linux-media@vger.kernel.org
Cc: linux-omap@vger.kernel.org, saaguirre@ti.com,
	tuukka.o.toivonen@nokia.com, dongsoo.kim@gmail.com
Subject: [PATCH 2/9] omap3isp: Add ISP MMU wrapper
Date: Tue,  3 Mar 2009 12:06:49 +0200
Message-Id: <1236074816-30018-2-git-send-email-sakari.ailus@maxwell.research.nokia.com>
In-Reply-To: <1236074816-30018-1-git-send-email-sakari.ailus@maxwell.research.nokia.com>
References: <49AD0128.5090503@maxwell.research.nokia.com>
 <1236074816-30018-1-git-send-email-sakari.ailus@maxwell.research.nokia.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

TODO:

- The ISP driver should start using the IOMMU directly without this wrapper.

Signed-off-by: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
---
 drivers/media/video/isp/ispmmu.c |  141 ++++++++++++++++++++++++++++++++++++++
 drivers/media/video/isp/ispmmu.h |   36 ++++++++++
 2 files changed, 177 insertions(+), 0 deletions(-)
 create mode 100644 drivers/media/video/isp/ispmmu.c
 create mode 100644 drivers/media/video/isp/ispmmu.h

diff --git a/drivers/media/video/isp/ispmmu.c b/drivers/media/video/isp/ispmmu.c
new file mode 100644
index 0000000..f872c71
--- /dev/null
+++ b/drivers/media/video/isp/ispmmu.c
@@ -0,0 +1,141 @@
+/*
+ * omap iommu wrapper for TI's OMAP3430 Camera ISP
+ *
+ * Copyright (C) 2008--2009 Nokia.
+ *
+ * Contributors:
+ *	Hiroshi Doyu <hiroshi.doyu@nokia.com>
+ *	Sakari Ailus <sakari.ailus@nokia.com>
+ *
+ * This package is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * THIS PACKAGE IS PROVIDED ``AS IS'' AND WITHOUT ANY EXPRESS OR
+ * IMPLIED WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED
+ * WARRANTIES OF MERCHANTIBILITY AND FITNESS FOR A PARTICULAR PURPOSE.
+ */
+
+#include <linux/module.h>
+
+#include "ispmmu.h"
+#include "isp.h"
+
+#include <mach/iommu.h>
+#include <mach/iovmm.h>
+
+#define IOMMU_FLAG (IOVMF_ENDIAN_LITTLE | IOVMF_ELSZ_8)
+
+static struct iommu *isp_iommu;
+
+dma_addr_t ispmmu_vmalloc(size_t bytes)
+{
+	return (dma_addr_t)iommu_vmalloc(isp_iommu, 0, bytes, IOMMU_FLAG);
+}
+
+void ispmmu_vfree(const dma_addr_t da)
+{
+	iommu_vfree(isp_iommu, (u32)da);
+}
+
+dma_addr_t ispmmu_kmap(u32 pa, int size)
+{
+	void *da;
+
+	da = (void *)iommu_kmap(isp_iommu, 0, pa, size, IOMMU_FLAG);
+	if (IS_ERR(da))
+		return PTR_ERR(da);
+
+	return (dma_addr_t)da;
+}
+
+void ispmmu_kunmap(dma_addr_t da)
+{
+	iommu_kunmap(isp_iommu, (u32)da);
+}
+
+dma_addr_t ispmmu_vmap(const struct scatterlist *sglist,
+		       int sglen)
+{
+	int err;
+	void *da;
+	struct sg_table *sgt;
+	unsigned int i;
+	struct scatterlist *sg, *src = (struct scatterlist *)sglist;
+
+	/*
+	 * convert isp sglist to iommu sgt
+	 * FIXME: should be fixed in the upper layer?
+	 */
+	sgt = kmalloc(sizeof(*sgt), GFP_KERNEL);
+	if (!sgt)
+		return -ENOMEM;
+	err = sg_alloc_table(sgt, sglen, GFP_KERNEL);
+	if (err)
+		goto err_sg_alloc;
+
+	for_each_sg(sgt->sgl, sg, sgt->nents, i)
+		sg_set_buf(sg, phys_to_virt(sg_dma_address(src + i)),
+			   sg_dma_len(src + i));
+
+	da = (void *)iommu_vmap(isp_iommu, 0, sgt, IOMMU_FLAG);
+	if (IS_ERR(da))
+		goto err_vmap;
+
+	return (dma_addr_t)da;
+
+err_vmap:
+	sg_free_table(sgt);
+err_sg_alloc:
+	kfree(sgt);
+	return -ENOMEM;
+}
+EXPORT_SYMBOL_GPL(ispmmu_vmap);
+
+void ispmmu_vunmap(dma_addr_t da)
+{
+	struct sg_table *sgt;
+
+	sgt = iommu_vunmap(isp_iommu, (u32)da);
+	if (!sgt)
+		return;
+	sg_free_table(sgt);
+	kfree(sgt);
+}
+EXPORT_SYMBOL_GPL(ispmmu_vunmap);
+
+void ispmmu_save_context(void)
+{
+	if (isp_iommu)
+		iommu_save_ctx(isp_iommu);
+}
+
+void ispmmu_restore_context(void)
+{
+	if (isp_iommu)
+		iommu_restore_ctx(isp_iommu);
+}
+
+int __init ispmmu_init(void)
+{
+	int err = 0;
+
+	isp_get();
+	isp_iommu = iommu_get("isp");
+	if (IS_ERR(isp_iommu)) {
+		err = PTR_ERR(isp_iommu);
+		isp_iommu = NULL;
+	}
+	isp_put();
+
+	return err;
+}
+
+void ispmmu_cleanup(void)
+{
+	isp_get();
+	if (isp_iommu)
+		iommu_put(isp_iommu);
+	isp_put();
+	isp_iommu = NULL;
+}
diff --git a/drivers/media/video/isp/ispmmu.h b/drivers/media/video/isp/ispmmu.h
new file mode 100644
index 0000000..0bc5bcb
--- /dev/null
+++ b/drivers/media/video/isp/ispmmu.h
@@ -0,0 +1,36 @@
+/*
+ * omap iommu wrapper for TI's OMAP3430 Camera ISP
+ *
+ * Copyright (C) 2008--2009 Nokia.
+ *
+ * Contributors:
+ *	Hiroshi Doyu <hiroshi.doyu@nokia.com>
+ *	Sakari Ailus <sakari.ailus@nokia.com>
+ *
+ * This package is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * THIS PACKAGE IS PROVIDED ``AS IS'' AND WITHOUT ANY EXPRESS OR
+ * IMPLIED WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED
+ * WARRANTIES OF MERCHANTIBILITY AND FITNESS FOR A PARTICULAR PURPOSE.
+ */
+
+#ifndef OMAP_ISP_MMU_H
+#define OMAP_ISP_MMU_H
+
+#include <linux/err.h>
+#include <linux/scatterlist.h>
+
+dma_addr_t ispmmu_vmalloc(size_t bytes);
+void ispmmu_vfree(const dma_addr_t da);
+dma_addr_t ispmmu_kmap(u32 pa, int size);
+void ispmmu_kunmap(dma_addr_t da);
+dma_addr_t ispmmu_vmap(const struct scatterlist *sglist, int sglen);
+void ispmmu_vunmap(dma_addr_t da);
+void ispmmu_save_context(void);
+void ispmmu_restore_context(void);
+int ispmmu_init(void);
+void ispmmu_cleanup(void);
+
+#endif /* OMAP_ISP_MMU_H */
-- 
1.5.6.5

