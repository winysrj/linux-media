Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:39065 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S966576AbeEYPdu (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 25 May 2018 11:33:50 -0400
From: Oleksandr Andrushchenko <andr2000@gmail.com>
To: xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
        jgross@suse.com, boris.ostrovsky@oracle.com, konrad.wilk@oracle.com
Cc: daniel.vetter@intel.com, andr2000@gmail.com, dongwon.kim@intel.com,
        matthew.d.roper@intel.com,
        Oleksandr Andrushchenko <oleksandr_andrushchenko@epam.com>
Subject: [PATCH 4/8] xen/gntdev: Allow mappings for DMA buffers
Date: Fri, 25 May 2018 18:33:27 +0300
Message-Id: <20180525153331.31188-5-andr2000@gmail.com>
In-Reply-To: <20180525153331.31188-1-andr2000@gmail.com>
References: <20180525153331.31188-1-andr2000@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Oleksandr Andrushchenko <oleksandr_andrushchenko@epam.com>

Allow mappings for DMA backed  buffers if grant table module
supports such: this extends grant device to not only map buffers
made of balloon pages, but also from buffers allocated with
dma_alloc_xxx.

Signed-off-by: Oleksandr Andrushchenko <oleksandr_andrushchenko@epam.com>
---
 drivers/xen/gntdev.c      | 100 +++++++++++++++++++++++++++++++++++++-
 include/uapi/xen/gntdev.h |  15 ++++++
 2 files changed, 113 insertions(+), 2 deletions(-)

diff --git a/drivers/xen/gntdev.c b/drivers/xen/gntdev.c
index bd56653b9bbc..640a579f42ea 100644
--- a/drivers/xen/gntdev.c
+++ b/drivers/xen/gntdev.c
@@ -37,6 +37,9 @@
 #include <linux/slab.h>
 #include <linux/highmem.h>
 #include <linux/refcount.h>
+#ifdef CONFIG_XEN_GRANT_DMA_ALLOC
+#include <linux/of_device.h>
+#endif
 
 #include <xen/xen.h>
 #include <xen/grant_table.h>
@@ -72,6 +75,11 @@ struct gntdev_priv {
 	struct mutex lock;
 	struct mm_struct *mm;
 	struct mmu_notifier mn;
+
+#ifdef CONFIG_XEN_GRANT_DMA_ALLOC
+	/* Device for which DMA memory is allocated. */
+	struct device *dma_dev;
+#endif
 };
 
 struct unmap_notify {
@@ -96,10 +104,28 @@ struct grant_map {
 	struct gnttab_unmap_grant_ref *kunmap_ops;
 	struct page **pages;
 	unsigned long pages_vm_start;
+
+#ifdef CONFIG_XEN_GRANT_DMA_ALLOC
+	/*
+	 * If dmabuf_vaddr is not NULL then this mapping is backed by DMA
+	 * capable memory.
+	 */
+
+	/* Device for which DMA memory is allocated. */
+	struct device *dma_dev;
+	/* Flags used to create this DMA buffer: GNTDEV_DMABUF_FLAG_XXX. */
+	bool dma_flags;
+	/* Virtual/CPU address of the DMA buffer. */
+	void *dma_vaddr;
+	/* Bus address of the DMA buffer. */
+	dma_addr_t dma_bus_addr;
+#endif
 };
 
 static int unmap_grant_pages(struct grant_map *map, int offset, int pages);
 
+static struct miscdevice gntdev_miscdev;
+
 /* ------------------------------------------------------------------ */
 
 static void gntdev_print_maps(struct gntdev_priv *priv,
@@ -121,8 +147,26 @@ static void gntdev_free_map(struct grant_map *map)
 	if (map == NULL)
 		return;
 
+#ifdef CONFIG_XEN_GRANT_DMA_ALLOC
+	if (map->dma_vaddr) {
+		struct gnttab_dma_alloc_args args;
+
+		args.dev = map->dma_dev;
+		args.coherent = map->dma_flags & GNTDEV_DMA_FLAG_COHERENT;
+		args.nr_pages = map->count;
+		args.pages = map->pages;
+		args.vaddr = map->dma_vaddr;
+		args.dev_bus_addr = map->dma_bus_addr;
+
+		gnttab_dma_free_pages(&args);
+	} else if (map->pages) {
+		gnttab_free_pages(map->count, map->pages);
+	}
+#else
 	if (map->pages)
 		gnttab_free_pages(map->count, map->pages);
+#endif
+
 	kfree(map->pages);
 	kfree(map->grants);
 	kfree(map->map_ops);
@@ -132,7 +176,8 @@ static void gntdev_free_map(struct grant_map *map)
 	kfree(map);
 }
 
-static struct grant_map *gntdev_alloc_map(struct gntdev_priv *priv, int count)
+static struct grant_map *gntdev_alloc_map(struct gntdev_priv *priv, int count,
+					  int dma_flags)
 {
 	struct grant_map *add;
 	int i;
@@ -155,8 +200,37 @@ static struct grant_map *gntdev_alloc_map(struct gntdev_priv *priv, int count)
 	    NULL == add->pages)
 		goto err;
 
+#ifdef CONFIG_XEN_GRANT_DMA_ALLOC
+	add->dma_flags = dma_flags;
+
+	/*
+	 * Check if this mapping is requested to be backed
+	 * by a DMA buffer.
+	 */
+	if (dma_flags & (GNTDEV_DMA_FLAG_WC | GNTDEV_DMA_FLAG_COHERENT)) {
+		struct gnttab_dma_alloc_args args;
+
+		/* Remember the device, so we can free DMA memory. */
+		add->dma_dev = priv->dma_dev;
+
+		args.dev = priv->dma_dev;
+		args.coherent = dma_flags & GNTDEV_DMA_FLAG_COHERENT;
+		args.nr_pages = count;
+		args.pages = add->pages;
+
+		if (gnttab_dma_alloc_pages(&args))
+			goto err;
+
+		add->dma_vaddr = args.vaddr;
+		add->dma_bus_addr = args.dev_bus_addr;
+	} else {
+		if (gnttab_alloc_pages(count, add->pages))
+			goto err;
+	}
+#else
 	if (gnttab_alloc_pages(count, add->pages))
 		goto err;
+#endif
 
 	for (i = 0; i < count; i++) {
 		add->map_ops[i].handle = -1;
@@ -323,8 +397,19 @@ static int map_grant_pages(struct grant_map *map)
 		}
 
 		map->unmap_ops[i].handle = map->map_ops[i].handle;
+#ifdef CONFIG_XEN_GRANT_DMA_ALLOC
+		if (use_ptemod) {
+			map->kunmap_ops[i].handle = map->kmap_ops[i].handle;
+		} else if (map->dma_vaddr) {
+			unsigned long mfn;
+
+			mfn = __pfn_to_mfn(page_to_pfn(map->pages[i]));
+			map->unmap_ops[i].dev_bus_addr = __pfn_to_phys(mfn);
+		}
+#else
 		if (use_ptemod)
 			map->kunmap_ops[i].handle = map->kmap_ops[i].handle;
+#endif
 	}
 	return err;
 }
@@ -548,6 +633,17 @@ static int gntdev_open(struct inode *inode, struct file *flip)
 	}
 
 	flip->private_data = priv;
+#ifdef CONFIG_XEN_GRANT_DMA_ALLOC
+	priv->dma_dev = gntdev_miscdev.this_device;
+
+	/*
+	 * The device is not spawn from a device tree, so arch_setup_dma_ops
+	 * is not called, thus leaving the device with dummy DMA ops.
+	 * Fix this call of_dma_configure() with a NULL node to set
+	 * default DMA ops.
+	 */
+	of_dma_configure(priv->dma_dev, NULL);
+#endif
 	pr_debug("priv %p\n", priv);
 
 	return 0;
@@ -589,7 +685,7 @@ static long gntdev_ioctl_map_grant_ref(struct gntdev_priv *priv,
 		return -EINVAL;
 
 	err = -ENOMEM;
-	map = gntdev_alloc_map(priv, op.count);
+	map = gntdev_alloc_map(priv, op.count, 0 /* This is not a dma-buf. */);
 	if (!map)
 		return err;
 
diff --git a/include/uapi/xen/gntdev.h b/include/uapi/xen/gntdev.h
index 6d1163456c03..2d5a4672f07c 100644
--- a/include/uapi/xen/gntdev.h
+++ b/include/uapi/xen/gntdev.h
@@ -200,4 +200,19 @@ struct ioctl_gntdev_grant_copy {
 /* Send an interrupt on the indicated event channel */
 #define UNMAP_NOTIFY_SEND_EVENT 0x2
 
+/*
+ * Flags to be used while requesting memory mapping's backing storage
+ * to be allocated with DMA API.
+ */
+
+/*
+ * The buffer is backed with memory allocated with dma_alloc_wc.
+ */
+#define GNTDEV_DMA_FLAG_WC		(1 << 1)
+
+/*
+ * The buffer is backed with memory allocated with dma_alloc_coherent.
+ */
+#define GNTDEV_DMA_FLAG_COHERENT	(1 << 2)
+
 #endif /* __LINUX_PUBLIC_GNTDEV_H__ */
-- 
2.17.0
