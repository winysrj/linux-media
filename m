Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f193.google.com ([209.85.128.193]:40093 "EHLO
        mail-wr0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S966571AbeEYPdt (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 25 May 2018 11:33:49 -0400
From: Oleksandr Andrushchenko <andr2000@gmail.com>
To: xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
        jgross@suse.com, boris.ostrovsky@oracle.com, konrad.wilk@oracle.com
Cc: daniel.vetter@intel.com, andr2000@gmail.com, dongwon.kim@intel.com,
        matthew.d.roper@intel.com,
        Oleksandr Andrushchenko <oleksandr_andrushchenko@epam.com>
Subject: [PATCH 3/8] xen/grant-table: Allow allocating buffers suitable for DMA
Date: Fri, 25 May 2018 18:33:26 +0300
Message-Id: <20180525153331.31188-4-andr2000@gmail.com>
In-Reply-To: <20180525153331.31188-1-andr2000@gmail.com>
References: <20180525153331.31188-1-andr2000@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Oleksandr Andrushchenko <oleksandr_andrushchenko@epam.com>

Extend grant table module API to allow allocating buffers that can
be used for DMA operations and mapping foreign grant references
on top of those.
The resulting buffer is similar to the one allocated by the balloon
driver in terms that proper memory reservation is made
({increase|decrease}_reservation and VA mappings updated if needed).
This is useful for sharing foreign buffers with HW drivers which
cannot work with scattered buffers provided by the balloon driver,
but require DMAable memory instead.

Signed-off-by: Oleksandr Andrushchenko <oleksandr_andrushchenko@epam.com>
---
 drivers/xen/Kconfig       |  13 ++++
 drivers/xen/grant-table.c | 124 ++++++++++++++++++++++++++++++++++++++
 include/xen/grant_table.h |  25 ++++++++
 3 files changed, 162 insertions(+)

diff --git a/drivers/xen/Kconfig b/drivers/xen/Kconfig
index e5d0c28372ea..3431fe210624 100644
--- a/drivers/xen/Kconfig
+++ b/drivers/xen/Kconfig
@@ -161,6 +161,19 @@ config XEN_GRANT_DEV_ALLOC
 	  to other domains. This can be used to implement frontend drivers
 	  or as part of an inter-domain shared memory channel.
 
+config XEN_GRANT_DMA_ALLOC
+	bool "Allow allocating DMA capable buffers with grant reference module"
+	depends on XEN
+	help
+	  Extends grant table module API to allow allocating DMA capable
+	  buffers and mapping foreign grant references on top of it.
+	  The resulting buffer is similar to one allocated by the balloon
+	  driver in terms that proper memory reservation is made
+	  ({increase|decrease}_reservation and VA mappings updated if needed).
+	  This is useful for sharing foreign buffers with HW drivers which
+	  cannot work with scattered buffers provided by the balloon driver,
+	  but require DMAable memory instead.
+
 config SWIOTLB_XEN
 	def_bool y
 	select SWIOTLB
diff --git a/drivers/xen/grant-table.c b/drivers/xen/grant-table.c
index d7488226e1f2..06fe6e7f639c 100644
--- a/drivers/xen/grant-table.c
+++ b/drivers/xen/grant-table.c
@@ -45,6 +45,9 @@
 #include <linux/workqueue.h>
 #include <linux/ratelimit.h>
 #include <linux/moduleparam.h>
+#ifdef CONFIG_XEN_GRANT_DMA_ALLOC
+#include <linux/dma-mapping.h>
+#endif
 
 #include <xen/xen.h>
 #include <xen/interface/xen.h>
@@ -57,6 +60,7 @@
 #ifdef CONFIG_X86
 #include <asm/xen/cpuid.h>
 #endif
+#include <xen/mem_reservation.h>
 #include <asm/xen/hypercall.h>
 #include <asm/xen/interface.h>
 
@@ -811,6 +815,82 @@ int gnttab_alloc_pages(int nr_pages, struct page **pages)
 }
 EXPORT_SYMBOL(gnttab_alloc_pages);
 
+#ifdef CONFIG_XEN_GRANT_DMA_ALLOC
+/**
+ * gnttab_dma_alloc_pages - alloc DMAable pages suitable for grant mapping into
+ * @args: arguments to the function
+ */
+int gnttab_dma_alloc_pages(struct gnttab_dma_alloc_args *args)
+{
+	unsigned long pfn, start_pfn;
+	xen_pfn_t *frames;
+	size_t size;
+	int i, ret;
+
+	frames = kcalloc(args->nr_pages, sizeof(*frames), GFP_KERNEL);
+	if (!frames)
+		return -ENOMEM;
+
+	size = args->nr_pages << PAGE_SHIFT;
+	if (args->coherent)
+		args->vaddr = dma_alloc_coherent(args->dev, size,
+						 &args->dev_bus_addr,
+						 GFP_KERNEL | __GFP_NOWARN);
+	else
+		args->vaddr = dma_alloc_wc(args->dev, size,
+					   &args->dev_bus_addr,
+					   GFP_KERNEL | __GFP_NOWARN);
+	if (!args->vaddr) {
+		pr_err("Failed to allocate DMA buffer of size %zu\n", size);
+		ret = -ENOMEM;
+		goto fail_free_frames;
+	}
+
+	start_pfn = __phys_to_pfn(args->dev_bus_addr);
+	for (pfn = start_pfn, i = 0; pfn < start_pfn + args->nr_pages;
+			pfn++, i++) {
+		struct page *page = pfn_to_page(pfn);
+
+		args->pages[i] = page;
+		frames[i] = xen_page_to_gfn(page);
+		xenmem_reservation_scrub_page(page);
+	}
+
+	xenmem_reservation_va_mapping_reset(args->nr_pages, args->pages);
+
+	ret = xenmem_reservation_decrease(args->nr_pages, frames);
+	if (ret != args->nr_pages) {
+		pr_err("Failed to decrease reservation for DMA buffer\n");
+		xenmem_reservation_increase(ret, frames);
+		ret = -EFAULT;
+		goto fail_free_dma;
+	}
+
+	ret = gnttab_pages_set_private(args->nr_pages, args->pages);
+	if (ret < 0)
+		goto fail_clear_private;
+
+	kfree(frames);
+	return 0;
+
+fail_clear_private:
+	gnttab_pages_clear_private(args->nr_pages, args->pages);
+fail_free_dma:
+	xenmem_reservation_va_mapping_update(args->nr_pages, args->pages,
+					     frames);
+	if (args->coherent)
+		dma_free_coherent(args->dev, size,
+				  args->vaddr, args->dev_bus_addr);
+	else
+		dma_free_wc(args->dev, size,
+			    args->vaddr, args->dev_bus_addr);
+fail_free_frames:
+	kfree(frames);
+	return ret;
+}
+EXPORT_SYMBOL(gnttab_dma_alloc_pages);
+#endif
+
 void gnttab_pages_clear_private(int nr_pages, struct page **pages)
 {
 	int i;
@@ -838,6 +918,50 @@ void gnttab_free_pages(int nr_pages, struct page **pages)
 }
 EXPORT_SYMBOL(gnttab_free_pages);
 
+#ifdef CONFIG_XEN_GRANT_DMA_ALLOC
+/**
+ * gnttab_dma_free_pages - free DMAable pages
+ * @args: arguments to the function
+ */
+int gnttab_dma_free_pages(struct gnttab_dma_alloc_args *args)
+{
+	xen_pfn_t *frames;
+	size_t size;
+	int i, ret;
+
+	gnttab_pages_clear_private(args->nr_pages, args->pages);
+
+	frames = kcalloc(args->nr_pages, sizeof(*frames), GFP_KERNEL);
+	if (!frames)
+		return -ENOMEM;
+
+	for (i = 0; i < args->nr_pages; i++)
+		frames[i] = page_to_xen_pfn(args->pages[i]);
+
+	ret = xenmem_reservation_increase(args->nr_pages, frames);
+	if (ret != args->nr_pages) {
+		pr_err("Failed to decrease reservation for DMA buffer\n");
+		ret = -EFAULT;
+	} else {
+		ret = 0;
+	}
+
+	xenmem_reservation_va_mapping_update(args->nr_pages, args->pages,
+					     frames);
+
+	size = args->nr_pages << PAGE_SHIFT;
+	if (args->coherent)
+		dma_free_coherent(args->dev, size,
+				  args->vaddr, args->dev_bus_addr);
+	else
+		dma_free_wc(args->dev, size,
+			    args->vaddr, args->dev_bus_addr);
+	kfree(frames);
+	return ret;
+}
+EXPORT_SYMBOL(gnttab_dma_free_pages);
+#endif
+
 /* Handling of paged out grant targets (GNTST_eagain) */
 #define MAX_DELAY 256
 static inline void
diff --git a/include/xen/grant_table.h b/include/xen/grant_table.h
index de03f2542bb7..982e34242b9c 100644
--- a/include/xen/grant_table.h
+++ b/include/xen/grant_table.h
@@ -198,6 +198,31 @@ void gnttab_free_auto_xlat_frames(void);
 int gnttab_alloc_pages(int nr_pages, struct page **pages);
 void gnttab_free_pages(int nr_pages, struct page **pages);
 
+#ifdef CONFIG_XEN_GRANT_DMA_ALLOC
+struct gnttab_dma_alloc_args {
+	/* Device for which DMA memory will be/was allocated. */
+	struct device *dev;
+	/*
+	 * If set then DMA buffer is coherent and write-combine otherwise.
+	 */
+	bool coherent;
+	/*
+	 * Number of entries in the @pages array, defines the size
+	 * of the DMA buffer.
+	 */
+	int nr_pages;
+	/* Array of pages @pages filled with pages of the DMA buffer. */
+	struct page **pages;
+	/* Virtual/CPU address of the DMA buffer. */
+	void *vaddr;
+	/* Bus address of the DMA buffer. */
+	dma_addr_t dev_bus_addr;
+};
+
+int gnttab_dma_alloc_pages(struct gnttab_dma_alloc_args *args);
+int gnttab_dma_free_pages(struct gnttab_dma_alloc_args *args);
+#endif
+
 int gnttab_pages_set_private(int nr_pages, struct page **pages);
 void gnttab_pages_clear_private(int nr_pages, struct page **pages);
 
-- 
2.17.0
