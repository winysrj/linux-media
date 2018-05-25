Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:40707 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S966698AbeEYPd4 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 25 May 2018 11:33:56 -0400
From: Oleksandr Andrushchenko <andr2000@gmail.com>
To: xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
        jgross@suse.com, boris.ostrovsky@oracle.com, konrad.wilk@oracle.com
Cc: daniel.vetter@intel.com, andr2000@gmail.com, dongwon.kim@intel.com,
        matthew.d.roper@intel.com,
        Oleksandr Andrushchenko <oleksandr_andrushchenko@epam.com>
Subject: [PATCH 7/8] xen/gntdev: Implement dma-buf import functionality
Date: Fri, 25 May 2018 18:33:30 +0300
Message-Id: <20180525153331.31188-8-andr2000@gmail.com>
In-Reply-To: <20180525153331.31188-1-andr2000@gmail.com>
References: <20180525153331.31188-1-andr2000@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Oleksandr Andrushchenko <oleksandr_andrushchenko@epam.com>

1. Import a dma-buf with the file descriptor provided and export
   granted references to the pages of that dma-buf into the array
   of grant references.

2. Add API to close all references to an imported buffer, so it can be
   released by the owner. This is only valid for buffers created with
   IOCTL_GNTDEV_DMABUF_IMP_TO_REFS.

Signed-off-by: Oleksandr Andrushchenko <oleksandr_andrushchenko@epam.com>
---
 drivers/xen/gntdev.c | 237 ++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 234 insertions(+), 3 deletions(-)

diff --git a/drivers/xen/gntdev.c b/drivers/xen/gntdev.c
index 52abc6cd5846..d8b6168f2cd9 100644
--- a/drivers/xen/gntdev.c
+++ b/drivers/xen/gntdev.c
@@ -71,6 +71,17 @@ static atomic_t pages_mapped = ATOMIC_INIT(0);
 static int use_ptemod;
 #define populate_freeable_maps use_ptemod
 
+#ifdef CONFIG_XEN_GNTDEV_DMABUF
+#ifndef GRANT_INVALID_REF
+/*
+ * Note on usage of grant reference 0 as invalid grant reference:
+ * grant reference 0 is valid, but never exposed to a driver,
+ * because of the fact it is already in use/reserved by the PV console.
+ */
+#define GRANT_INVALID_REF	0
+#endif
+#endif
+
 struct gntdev_priv {
 	/* maps with visible offsets in the file descriptor */
 	struct list_head maps;
@@ -94,6 +105,8 @@ struct gntdev_priv {
 	struct list_head dmabuf_exp_list;
 	/* List of wait objects. */
 	struct list_head dmabuf_exp_wait_list;
+	/* List of imported DMA buffers. */
+	struct list_head dmabuf_imp_list;
 	/* This is the lock which protects dma_buf_xxx lists. */
 	struct mutex dmabuf_lock;
 #endif
@@ -155,6 +168,10 @@ struct xen_dmabuf {
 		struct {
 			/* Granted references of the imported buffer. */
 			grant_ref_t *refs;
+			/* Scatter-gather table of the imported buffer. */
+			struct sg_table *sgt;
+			/* dma-buf attachment of the imported buffer. */
+			struct dma_buf_attachment *attach;
 		} imp;
 	} u;
 
@@ -684,6 +701,7 @@ static int gntdev_open(struct inode *inode, struct file *flip)
 	mutex_init(&priv->dmabuf_lock);
 	INIT_LIST_HEAD(&priv->dmabuf_exp_list);
 	INIT_LIST_HEAD(&priv->dmabuf_exp_wait_list);
+	INIT_LIST_HEAD(&priv->dmabuf_imp_list);
 #endif
 
 	if (use_ptemod) {
@@ -1544,15 +1562,228 @@ static int dmabuf_exp_from_refs(struct gntdev_priv *priv, int flags,
 /* DMA buffer import support.                                         */
 /* ------------------------------------------------------------------ */
 
-static int dmabuf_imp_release(struct gntdev_priv *priv, u32 fd)
+static int
+dmabuf_imp_grant_foreign_access(struct page **pages, u32 *refs,
+				int count, int domid)
 {
-	return 0;
+	grant_ref_t priv_gref_head;
+	int i, ret;
+
+	ret = gnttab_alloc_grant_references(count, &priv_gref_head);
+	if (ret < 0) {
+		pr_err("Cannot allocate grant references, ret %d\n", ret);
+		return ret;
+	}
+
+	for (i = 0; i < count; i++) {
+		int cur_ref;
+
+		cur_ref = gnttab_claim_grant_reference(&priv_gref_head);
+		if (cur_ref < 0) {
+			ret = cur_ref;
+			pr_err("Cannot claim grant reference, ret %d\n", ret);
+			goto out;
+		}
+
+		gnttab_grant_foreign_access_ref(cur_ref, domid,
+						xen_page_to_gfn(pages[i]), 0);
+		refs[i] = cur_ref;
+	}
+
+	ret = 0;
+
+out:
+	gnttab_free_grant_references(priv_gref_head);
+	return ret;
+}
+
+static void dmabuf_imp_end_foreign_access(u32 *refs, int count)
+{
+	int i;
+
+	for (i = 0; i < count; i++)
+		if (refs[i] != GRANT_INVALID_REF)
+			gnttab_end_foreign_access(refs[i], 0, 0UL);
+}
+
+static void dmabuf_imp_free_storage(struct xen_dmabuf *xen_dmabuf)
+{
+	kfree(xen_dmabuf->pages);
+	kfree(xen_dmabuf->u.imp.refs);
+	kfree(xen_dmabuf);
+}
+
+static struct xen_dmabuf *dmabuf_imp_alloc_storage(int count)
+{
+	struct xen_dmabuf *xen_dmabuf;
+	int i;
+
+	xen_dmabuf = kzalloc(sizeof(*xen_dmabuf), GFP_KERNEL);
+	if (!xen_dmabuf)
+		goto fail;
+
+	xen_dmabuf->u.imp.refs = kcalloc(count,
+					 sizeof(xen_dmabuf->u.imp.refs[0]),
+					 GFP_KERNEL);
+	if (!xen_dmabuf->u.imp.refs)
+		goto fail;
+
+	xen_dmabuf->pages = kcalloc(count,
+				    sizeof(xen_dmabuf->pages[0]),
+				    GFP_KERNEL);
+	if (!xen_dmabuf->pages)
+		goto fail;
+
+	xen_dmabuf->nr_pages = count;
+
+	for (i = 0; i < count; i++)
+		xen_dmabuf->u.imp.refs[i] = GRANT_INVALID_REF;
+
+	return xen_dmabuf;
+
+fail:
+	dmabuf_imp_free_storage(xen_dmabuf);
+	return ERR_PTR(-ENOMEM);
 }
 
 static struct xen_dmabuf *
 dmabuf_imp_to_refs(struct gntdev_priv *priv, int fd, int count, int domid)
 {
-	return ERR_PTR(-ENOMEM);
+	struct xen_dmabuf *xen_dmabuf, *ret;
+	struct dma_buf *dma_buf;
+	struct dma_buf_attachment *attach;
+	struct sg_table *sgt;
+	struct sg_page_iter sg_iter;
+	int i;
+
+	dma_buf = dma_buf_get(fd);
+	if (IS_ERR(dma_buf))
+		return ERR_CAST(dma_buf);
+
+	xen_dmabuf = dmabuf_imp_alloc_storage(count);
+	if (IS_ERR(xen_dmabuf)) {
+		ret = xen_dmabuf;
+		goto fail_put;
+	}
+
+	xen_dmabuf->priv = priv;
+	xen_dmabuf->fd = fd;
+
+	attach = dma_buf_attach(dma_buf, priv->dma_dev);
+	if (IS_ERR(attach)) {
+		ret = ERR_CAST(attach);
+		goto fail_free_obj;
+	}
+
+	xen_dmabuf->u.imp.attach = attach;
+
+	sgt = dma_buf_map_attachment(attach, DMA_BIDIRECTIONAL);
+	if (IS_ERR(sgt)) {
+		ret = ERR_CAST(sgt);
+		goto fail_detach;
+	}
+
+	/* Check number of pages that imported buffer has. */
+	if (attach->dmabuf->size != xen_dmabuf->nr_pages << PAGE_SHIFT) {
+		ret = ERR_PTR(-EINVAL);
+		pr_err("DMA buffer has %zu pages, user-space expects %d\n",
+		       attach->dmabuf->size, xen_dmabuf->nr_pages);
+		goto fail_unmap;
+	}
+
+	xen_dmabuf->u.imp.sgt = sgt;
+
+	/* Now convert sgt to array of pages and check for page validity. */
+	i = 0;
+	for_each_sg_page(sgt->sgl, &sg_iter, sgt->nents, 0) {
+		struct page *page = sg_page_iter_page(&sg_iter);
+		/*
+		 * Check if page is valid: this can happen if we are given
+		 * a page from VRAM or other resources which are not backed
+		 * by a struct page.
+		 */
+		if (!pfn_valid(page_to_pfn(page))) {
+			ret = ERR_PTR(-EINVAL);
+			goto fail_unmap;
+		}
+
+		xen_dmabuf->pages[i++] = page;
+	}
+
+	ret = ERR_PTR(dmabuf_imp_grant_foreign_access(xen_dmabuf->pages,
+						      xen_dmabuf->u.imp.refs,
+						      count, domid));
+	if (IS_ERR(ret))
+		goto fail_end_access;
+
+	pr_debug("Imported DMA buffer with fd %d\n", fd);
+
+	mutex_lock(&priv->dmabuf_lock);
+	list_add(&xen_dmabuf->next, &priv->dmabuf_imp_list);
+	mutex_unlock(&priv->dmabuf_lock);
+
+	return xen_dmabuf;
+
+fail_end_access:
+	dmabuf_imp_end_foreign_access(xen_dmabuf->u.imp.refs, count);
+fail_unmap:
+	dma_buf_unmap_attachment(attach, sgt, DMA_BIDIRECTIONAL);
+fail_detach:
+	dma_buf_detach(dma_buf, attach);
+fail_free_obj:
+	dmabuf_imp_free_storage(xen_dmabuf);
+fail_put:
+	dma_buf_put(dma_buf);
+	return ret;
+}
+
+/*
+ * Find the hyper dma-buf by its file descriptor and remove
+ * it from the buffer's list.
+ */
+static struct xen_dmabuf *
+dmabuf_imp_find_unlink(struct gntdev_priv *priv, int fd)
+{
+	struct xen_dmabuf *q, *xen_dmabuf, *ret = ERR_PTR(-ENOENT);
+
+	mutex_lock(&priv->dmabuf_lock);
+	list_for_each_entry_safe(xen_dmabuf, q, &priv->dmabuf_imp_list, next) {
+		if (xen_dmabuf->fd == fd) {
+			pr_debug("Found xen_dmabuf in the import list\n");
+			ret = xen_dmabuf;
+			list_del(&xen_dmabuf->next);
+			break;
+		}
+	}
+	mutex_unlock(&priv->dmabuf_lock);
+	return ret;
+}
+
+static int dmabuf_imp_release(struct gntdev_priv *priv, u32 fd)
+{
+	struct xen_dmabuf *xen_dmabuf;
+	struct dma_buf_attachment *attach;
+	struct dma_buf *dma_buf;
+
+	xen_dmabuf = dmabuf_imp_find_unlink(priv, fd);
+	if (IS_ERR(xen_dmabuf))
+		return PTR_ERR(xen_dmabuf);
+
+	pr_debug("Releasing DMA buffer with fd %d\n", fd);
+
+	attach = xen_dmabuf->u.imp.attach;
+
+	if (xen_dmabuf->u.imp.sgt)
+		dma_buf_unmap_attachment(attach, xen_dmabuf->u.imp.sgt,
+					 DMA_BIDIRECTIONAL);
+	dma_buf = attach->dmabuf;
+	dma_buf_detach(attach->dmabuf, attach);
+	dma_buf_put(dma_buf);
+
+	dmabuf_imp_end_foreign_access(xen_dmabuf->u.imp.refs,
+				      xen_dmabuf->nr_pages);
+	dmabuf_imp_free_storage(xen_dmabuf);
+	return 0;
 }
 
 /* ------------------------------------------------------------------ */
-- 
2.17.0
