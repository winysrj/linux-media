Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:29681 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750768Ab2KGGdT (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 7 Nov 2012 01:33:19 -0500
Received: from epcpsbgm1.samsung.com (epcpsbgm1 [203.254.230.26])
 by mailout4.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MD300DESU7H8370@mailout4.samsung.com> for
 linux-media@vger.kernel.org; Wed, 07 Nov 2012 15:33:18 +0900 (KST)
Received: from localhost.localdomain ([107.108.73.106])
 by mmp1.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTPA id <0MD300H8EU5IHNA0@mmp1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 07 Nov 2012 15:33:17 +0900 (KST)
From: Prathyush K <prathyush.k@samsung.com>
To: dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org
Cc: t.stanislaws@samsung.com, daniel.vetter@ffwll.ch
Subject: [PATCH] scatterlist: add sg_clone_table function
Date: Wed, 07 Nov 2012 12:22:55 +0530
Message-id: <1352271175-1336-1-git-send-email-prathyush.k@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds another constructor for an sg table. An sg table is
created from an existing sg table. The new sg table is allocated and
initialized with same data from the original sg table. The user has to
call 'sg_clone_table' with the required sg table, the existing sg table
and the gfp allocation mask.

This function can be used in the dma-buf framework. If a buffer needs
to be shared across multiple devices using the dma_buf framework, an
sg table needs to be created and mapped to the target device's address
space. This is done in most drivers by creating the sg table from the
pages of the buffer (e.g. calling sg_alloc_table_from_pages function).
In case this needs to be done frequently (e.g. a framebuffer
is repeatedly shared with the GPU, video accelerator, CSC etc), it is
efficient to create an sg table once during buffer allocation and then
create temporary sg tables for dma mapping from the original sg table.

Signed-off-by: Prathyush K <prathyush.k@samsung.com>
---
 include/linux/scatterlist.h |    1 +
 lib/scatterlist.c           |   36 ++++++++++++++++++++++++++++++++++++
 2 files changed, 37 insertions(+), 0 deletions(-)

diff --git a/include/linux/scatterlist.h b/include/linux/scatterlist.h
index 4bd6c06..fd12525 100644
--- a/include/linux/scatterlist.h
+++ b/include/linux/scatterlist.h
@@ -215,6 +215,7 @@ void sg_free_table(struct sg_table *);
 int __sg_alloc_table(struct sg_table *, unsigned int, unsigned int, gfp_t,
 		     sg_alloc_fn *);
 int sg_alloc_table(struct sg_table *, unsigned int, gfp_t);
+int sg_clone_table(struct sg_table *, struct sg_table *, gfp_t);
 int sg_alloc_table_from_pages(struct sg_table *sgt,
 	struct page **pages, unsigned int n_pages,
 	unsigned long offset, unsigned long size,
diff --git a/lib/scatterlist.c b/lib/scatterlist.c
index 3675452..4f106b3 100644
--- a/lib/scatterlist.c
+++ b/lib/scatterlist.c
@@ -329,6 +329,42 @@ int sg_alloc_table(struct sg_table *table, unsigned int nents, gfp_t gfp_mask)
 }
 EXPORT_SYMBOL(sg_alloc_table);
 
+/*
+ * sg_clone_table - Allocate and initialize an sg table from an existing
+ *			sg table
+ * @sgt_in:	The sg table to clone
+ * @sgt_out:	The output sg table cloned from the original sg table.
+ * @gfp_mask:	GFP allocation mask
+ *
+ * Description:
+ *    Allocate and initialize an sg table from an existing sg table. A user
+ *    would want to create a temporary sg table which is a clone of an
+ *    existing table. This cloned sg table is released by sg_free_table.
+ *
+ * Returns:
+ *    0 on success, negative error on failure
+ */
+int sg_clone_table(struct sg_table *sgt_in, struct sg_table *sgt_out,
+		   gfp_t gfp_mask)
+{
+	struct scatterlist *s, *s_out;
+	unsigned int i;
+	int ret;
+
+	ret = sg_alloc_table(sgt_out, sgt_in->orig_nents, gfp_mask);
+	if (unlikely(ret))
+		return ret;
+
+	s_out = sgt_out->sgl;
+	for_each_sg(sgt_in->sgl, s, sgt_in->orig_nents, i) {
+		sg_set_page(s_out, sg_page(s), s->length, s->offset);
+		s_out = sg_next(s_out);
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL(sg_clone_table);
+
 /**
  * sg_alloc_table_from_pages - Allocate and initialize an sg table from
  *			       an array of pages
-- 
1.7.0.4

