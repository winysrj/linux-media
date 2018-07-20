Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf1-f68.google.com ([209.85.167.68]:33720 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729117AbeGTJta (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 20 Jul 2018 05:49:30 -0400
From: Oleksandr Andrushchenko <andr2000@gmail.com>
To: xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
        jgross@suse.com, boris.ostrovsky@oracle.com, konrad.wilk@oracle.com
Cc: daniel.vetter@intel.com, andr2000@gmail.com, dongwon.kim@intel.com,
        matthew.d.roper@intel.com,
        Oleksandr Andrushchenko <oleksandr_andrushchenko@epam.com>
Subject: [PATCH v5 8/8] xen/gntdev: Implement dma-buf import functionality
Date: Fri, 20 Jul 2018 12:01:50 +0300
Message-Id: <20180720090150.24560-9-andr2000@gmail.com>
In-Reply-To: <20180720090150.24560-1-andr2000@gmail.com>
References: <20180720090150.24560-1-andr2000@gmail.com>
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
Reviewed-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
---
 drivers/xen/gntdev-dmabuf.c | 239 +++++++++++++++++++++++++++++++++++-
 1 file changed, 234 insertions(+), 5 deletions(-)

diff --git a/drivers/xen/gntdev-dmabuf.c b/drivers/xen/gntdev-dmabuf.c
index cc4f16c81919..e4c9f1f74476 100644
--- a/drivers/xen/gntdev-dmabuf.c
+++ b/drivers/xen/gntdev-dmabuf.c
@@ -21,6 +21,15 @@
 #include "gntdev-common.h"
 #include "gntdev-dmabuf.h"
 
+#ifndef GRANT_INVALID_REF
+/*
+ * Note on usage of grant reference 0 as invalid grant reference:
+ * grant reference 0 is valid, but never exposed to a driver,
+ * because of the fact it is already in use/reserved by the PV console.
+ */
+#define GRANT_INVALID_REF	0
+#endif
+
 struct gntdev_dmabuf {
 	struct gntdev_dmabuf_priv *priv;
 	struct dma_buf *dmabuf;
@@ -35,6 +44,14 @@ struct gntdev_dmabuf {
 			struct gntdev_priv *priv;
 			struct gntdev_grant_map *map;
 		} exp;
+		struct {
+			/* Granted references of the imported buffer. */
+			grant_ref_t *refs;
+			/* Scatter-gather table of the imported buffer. */
+			struct sg_table *sgt;
+			/* dma-buf attachment of the imported buffer. */
+			struct dma_buf_attachment *attach;
+		} imp;
 	} u;
 
 	/* Number of pages this buffer has. */
@@ -59,6 +76,8 @@ struct gntdev_dmabuf_priv {
 	struct list_head exp_list;
 	/* List of wait objects. */
 	struct list_head exp_wait_list;
+	/* List of imported DMA buffers. */
+	struct list_head imp_list;
 	/* This is the lock which protects dma_buf_xxx lists. */
 	struct mutex lock;
 };
@@ -491,21 +510,230 @@ static int dmabuf_exp_from_refs(struct gntdev_priv *priv, int flags,
 
 /* DMA buffer import support. */
 
+static int
+dmabuf_imp_grant_foreign_access(struct page **pages, u32 *refs,
+				int count, int domid)
+{
+	grant_ref_t priv_gref_head;
+	int i, ret;
+
+	ret = gnttab_alloc_grant_references(count, &priv_gref_head);
+	if (ret < 0) {
+		pr_debug("Cannot allocate grant references, ret %d\n", ret);
+		return ret;
+	}
+
+	for (i = 0; i < count; i++) {
+		int cur_ref;
+
+		cur_ref = gnttab_claim_grant_reference(&priv_gref_head);
+		if (cur_ref < 0) {
+			ret = cur_ref;
+			pr_debug("Cannot claim grant reference, ret %d\n", ret);
+			goto out;
+		}
+
+		gnttab_grant_foreign_access_ref(cur_ref, domid,
+						xen_page_to_gfn(pages[i]), 0);
+		refs[i] = cur_ref;
+	}
+
+	return 0;
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
+static void dmabuf_imp_free_storage(struct gntdev_dmabuf *gntdev_dmabuf)
+{
+	kfree(gntdev_dmabuf->pages);
+	kfree(gntdev_dmabuf->u.imp.refs);
+	kfree(gntdev_dmabuf);
+}
+
+static struct gntdev_dmabuf *dmabuf_imp_alloc_storage(int count)
+{
+	struct gntdev_dmabuf *gntdev_dmabuf;
+	int i;
+
+	gntdev_dmabuf = kzalloc(sizeof(*gntdev_dmabuf), GFP_KERNEL);
+	if (!gntdev_dmabuf)
+		goto fail;
+
+	gntdev_dmabuf->u.imp.refs = kcalloc(count,
+					    sizeof(gntdev_dmabuf->u.imp.refs[0]),
+					    GFP_KERNEL);
+	if (!gntdev_dmabuf->u.imp.refs)
+		goto fail;
+
+	gntdev_dmabuf->pages = kcalloc(count,
+				       sizeof(gntdev_dmabuf->pages[0]),
+				       GFP_KERNEL);
+	if (!gntdev_dmabuf->pages)
+		goto fail;
+
+	gntdev_dmabuf->nr_pages = count;
+
+	for (i = 0; i < count; i++)
+		gntdev_dmabuf->u.imp.refs[i] = GRANT_INVALID_REF;
+
+	return gntdev_dmabuf;
+
+fail:
+	dmabuf_imp_free_storage(gntdev_dmabuf);
+	return ERR_PTR(-ENOMEM);
+}
+
 static struct gntdev_dmabuf *
 dmabuf_imp_to_refs(struct gntdev_dmabuf_priv *priv, struct device *dev,
 		   int fd, int count, int domid)
 {
-	return ERR_PTR(-ENOMEM);
+	struct gntdev_dmabuf *gntdev_dmabuf, *ret;
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
+	gntdev_dmabuf = dmabuf_imp_alloc_storage(count);
+	if (IS_ERR(gntdev_dmabuf)) {
+		ret = gntdev_dmabuf;
+		goto fail_put;
+	}
+
+	gntdev_dmabuf->priv = priv;
+	gntdev_dmabuf->fd = fd;
+
+	attach = dma_buf_attach(dma_buf, dev);
+	if (IS_ERR(attach)) {
+		ret = ERR_CAST(attach);
+		goto fail_free_obj;
+	}
+
+	gntdev_dmabuf->u.imp.attach = attach;
+
+	sgt = dma_buf_map_attachment(attach, DMA_BIDIRECTIONAL);
+	if (IS_ERR(sgt)) {
+		ret = ERR_CAST(sgt);
+		goto fail_detach;
+	}
+
+	/* Check number of pages that imported buffer has. */
+	if (attach->dmabuf->size != gntdev_dmabuf->nr_pages << PAGE_SHIFT) {
+		ret = ERR_PTR(-EINVAL);
+		pr_debug("DMA buffer has %zu pages, user-space expects %d\n",
+			 attach->dmabuf->size, gntdev_dmabuf->nr_pages);
+		goto fail_unmap;
+	}
+
+	gntdev_dmabuf->u.imp.sgt = sgt;
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
+		gntdev_dmabuf->pages[i++] = page;
+	}
+
+	ret = ERR_PTR(dmabuf_imp_grant_foreign_access(gntdev_dmabuf->pages,
+						      gntdev_dmabuf->u.imp.refs,
+						      count, domid));
+	if (IS_ERR(ret))
+		goto fail_end_access;
+
+	pr_debug("Imported DMA buffer with fd %d\n", fd);
+
+	mutex_lock(&priv->lock);
+	list_add(&gntdev_dmabuf->next, &priv->imp_list);
+	mutex_unlock(&priv->lock);
+
+	return gntdev_dmabuf;
+
+fail_end_access:
+	dmabuf_imp_end_foreign_access(gntdev_dmabuf->u.imp.refs, count);
+fail_unmap:
+	dma_buf_unmap_attachment(attach, sgt, DMA_BIDIRECTIONAL);
+fail_detach:
+	dma_buf_detach(dma_buf, attach);
+fail_free_obj:
+	dmabuf_imp_free_storage(gntdev_dmabuf);
+fail_put:
+	dma_buf_put(dma_buf);
+	return ret;
 }
 
-static u32 *dmabuf_imp_get_refs(struct gntdev_dmabuf *gntdev_dmabuf)
+/*
+ * Find the hyper dma-buf by its file descriptor and remove
+ * it from the buffer's list.
+ */
+static struct gntdev_dmabuf *
+dmabuf_imp_find_unlink(struct gntdev_dmabuf_priv *priv, int fd)
 {
-	return NULL;
+	struct gntdev_dmabuf *q, *gntdev_dmabuf, *ret = ERR_PTR(-ENOENT);
+
+	mutex_lock(&priv->lock);
+	list_for_each_entry_safe(gntdev_dmabuf, q, &priv->imp_list, next) {
+		if (gntdev_dmabuf->fd == fd) {
+			pr_debug("Found gntdev_dmabuf in the import list\n");
+			ret = gntdev_dmabuf;
+			list_del(&gntdev_dmabuf->next);
+			break;
+		}
+	}
+	mutex_unlock(&priv->lock);
+	return ret;
 }
 
 static int dmabuf_imp_release(struct gntdev_dmabuf_priv *priv, u32 fd)
 {
-	return -EINVAL;
+	struct gntdev_dmabuf *gntdev_dmabuf;
+	struct dma_buf_attachment *attach;
+	struct dma_buf *dma_buf;
+
+	gntdev_dmabuf = dmabuf_imp_find_unlink(priv, fd);
+	if (IS_ERR(gntdev_dmabuf))
+		return PTR_ERR(gntdev_dmabuf);
+
+	pr_debug("Releasing DMA buffer with fd %d\n", fd);
+
+	dmabuf_imp_end_foreign_access(gntdev_dmabuf->u.imp.refs,
+				      gntdev_dmabuf->nr_pages);
+
+	attach = gntdev_dmabuf->u.imp.attach;
+
+	if (gntdev_dmabuf->u.imp.sgt)
+		dma_buf_unmap_attachment(attach, gntdev_dmabuf->u.imp.sgt,
+					 DMA_BIDIRECTIONAL);
+	dma_buf = attach->dmabuf;
+	dma_buf_detach(attach->dmabuf, attach);
+	dma_buf_put(dma_buf);
+
+	dmabuf_imp_free_storage(gntdev_dmabuf);
+	return 0;
 }
 
 /* DMA buffer IOCTL support. */
@@ -582,7 +810,7 @@ long gntdev_ioctl_dmabuf_imp_to_refs(struct gntdev_priv *priv,
 	if (IS_ERR(gntdev_dmabuf))
 		return PTR_ERR(gntdev_dmabuf);
 
-	if (copy_to_user(u->refs, dmabuf_imp_get_refs(gntdev_dmabuf),
+	if (copy_to_user(u->refs, gntdev_dmabuf->u.imp.refs,
 			 sizeof(*u->refs) * op.count) != 0) {
 		ret = -EFAULT;
 		goto out_release;
@@ -616,6 +844,7 @@ struct gntdev_dmabuf_priv *gntdev_dmabuf_init(void)
 	mutex_init(&priv->lock);
 	INIT_LIST_HEAD(&priv->exp_list);
 	INIT_LIST_HEAD(&priv->exp_wait_list);
+	INIT_LIST_HEAD(&priv->imp_list);
 
 	return priv;
 }
-- 
2.18.0
