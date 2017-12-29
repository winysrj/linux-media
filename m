Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.anw.at ([195.234.101.228]:54714 "EHLO mail.anw.at"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932252AbdL2IJQ (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 29 Dec 2017 03:09:16 -0500
From: "Jasmin J." <jasmin@anw.at>
To: linux-media@vger.kernel.org
Cc: hverkuil@xs4all.nl, d.scheller@gmx.net, jasmin@anw.at
Subject: [PATCH] build: Update videobuf2 related patches
Date: Fri, 29 Dec 2017 09:09:02 +0000
Message-Id: <1514538542-19917-1-git-send-email-jasmin@anw.at>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Jasmin Jessich <jasmin@anw.at>

Commit 03fbdb2f moved videobuf2 to drivers/media/common. Modified the
backport patches to patch the files on the new location.

Signed-off-by: Jasmin Jessich <jasmin@anw.at>
---
 backports/v4.0_dma_buf_export.patch  | 18 +++++++++---------
 backports/v4.0_drop_trace.patch      |  6 +++---
 backports/v4.10_refcount.patch       | 24 ++++++++++++------------
 backports/v4.7_dma_attrs.patch       | 18 +++++++++---------
 backports/v4.8_user_pages_flag.patch |  6 +++---
 5 files changed, 36 insertions(+), 36 deletions(-)

diff --git a/backports/v4.0_dma_buf_export.patch b/backports/v4.0_dma_buf_export.patch
index 5230026..5bc07db 100644
--- a/backports/v4.0_dma_buf_export.patch
+++ b/backports/v4.0_dma_buf_export.patch
@@ -1,7 +1,7 @@
-diff --git a/drivers/media/v4l2-core/videobuf2-dma-contig.c b/drivers/media/v4l2-core/videobuf2-dma-contig.c
+diff --git a/drivers/media/common/videobuf/videobuf2-dma-contig.c b/drivers/media/common/videobuf/videobuf2-dma-contig.c
 index 620c4aa..4b62c9c 100644
---- a/drivers/media/v4l2-core/videobuf2-dma-contig.c
-+++ b/drivers/media/v4l2-core/videobuf2-dma-contig.c
+--- a/drivers/media/common/videobuf/videobuf2-dma-contig.c
++++ b/drivers/media/common/videobuf/videobuf2-dma-contig.c
 @@ -402,12 +402,6 @@ static struct dma_buf *vb2_dc_get_dmabuf(void *buf_priv, unsigned long flags)
  {
  	struct vb2_dc_buf *buf = buf_priv;
@@ -24,10 +24,10 @@ index 620c4aa..4b62c9c 100644
  	if (IS_ERR(dbuf))
  		return NULL;
  
-diff --git a/drivers/media/v4l2-core/videobuf2-dma-sg.c b/drivers/media/v4l2-core/videobuf2-dma-sg.c
+diff --git a/drivers/media/common/videobuf/videobuf2-dma-sg.c b/drivers/media/common/videobuf/videobuf2-dma-sg.c
 index afd4b51..71510e4 100644
---- a/drivers/media/v4l2-core/videobuf2-dma-sg.c
-+++ b/drivers/media/v4l2-core/videobuf2-dma-sg.c
+--- a/drivers/media/common/videobuf/videobuf2-dma-sg.c
++++ b/drivers/media/common/videobuf/videobuf2-dma-sg.c
 @@ -589,17 +589,11 @@ static struct dma_buf *vb2_dma_sg_get_dmabuf(void *buf_priv, unsigned long flags
  {
  	struct vb2_dma_sg_buf *buf = buf_priv;
@@ -47,10 +47,10 @@ index afd4b51..71510e4 100644
  	if (IS_ERR(dbuf))
  		return NULL;
  
-diff --git a/drivers/media/v4l2-core/videobuf2-vmalloc.c b/drivers/media/v4l2-core/videobuf2-vmalloc.c
+diff --git a/drivers/media/common/videobuf/videobuf2-vmalloc.c b/drivers/media/common/videobuf/videobuf2-vmalloc.c
 index 0ba40be..c060cf9 100644
---- a/drivers/media/v4l2-core/videobuf2-vmalloc.c
-+++ b/drivers/media/v4l2-core/videobuf2-vmalloc.c
+--- a/drivers/media/common/videobuf/videobuf2-vmalloc.c
++++ b/drivers/media/common/videobuf/videobuf2-vmalloc.c
 @@ -372,17 +372,11 @@ static struct dma_buf *vb2_vmalloc_get_dmabuf(void *buf_priv, unsigned long flag
  {
  	struct vb2_vmalloc_buf *buf = buf_priv;
diff --git a/backports/v4.0_drop_trace.patch b/backports/v4.0_drop_trace.patch
index d1fcef5..95c7243 100644
--- a/backports/v4.0_drop_trace.patch
+++ b/backports/v4.0_drop_trace.patch
@@ -38,10 +38,10 @@ index 4f27cfa134a1..3789a80f977e 100644
  
  	if (has_array_args) {
  		*kernel_ptr = (void __force *)user_ptr;
-diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
+diff --git a/drivers/media/common/videobuf/videobuf2-core.c b/drivers/media/common/videobuf/videobuf2-core.c
 index c0175ea7e7ad..bf9fee755ae4 100644
---- a/drivers/media/v4l2-core/videobuf2-core.c
-+++ b/drivers/media/v4l2-core/videobuf2-core.c
+--- a/drivers/media/common/videobuf/videobuf2-core.c
++++ b/drivers/media/common/videobuf/videobuf2-core.c
 @@ -27,8 +27,6 @@
  #include <media/videobuf2-core.h>
  #include <media/v4l2-mc.h>
diff --git a/backports/v4.10_refcount.patch b/backports/v4.10_refcount.patch
index 1d2a3d4..283f214 100644
--- a/backports/v4.10_refcount.patch
+++ b/backports/v4.10_refcount.patch
@@ -54,10 +54,10 @@ index 6777926f20f2..115414cf520f 100644
  
  	/* board name */
  	int                        nr;
-diff --git a/drivers/media/v4l2-core/videobuf2-dma-contig.c b/drivers/media/v4l2-core/videobuf2-dma-contig.c
+diff --git a/drivers/media/common/videobuf/videobuf2-dma-contig.c b/drivers/media/vcommon/videobuf/videobuf2-dma-contig.c
 index d29a07f3b048..fb6a177be461 100644
---- a/drivers/media/v4l2-core/videobuf2-dma-contig.c
-+++ b/drivers/media/v4l2-core/videobuf2-dma-contig.c
+--- a/drivers/media/common/videobuf/videobuf2-dma-contig.c
++++ b/drivers/media/common/videobuf/videobuf2-dma-contig.c
 @@ -12,7 +12,6 @@
  
  #include <linux/dma-buf.h>
@@ -111,10 +111,10 @@ index d29a07f3b048..fb6a177be461 100644
  
  	return dbuf;
  }
-diff --git a/drivers/media/v4l2-core/videobuf2-dma-sg.c b/drivers/media/v4l2-core/videobuf2-dma-sg.c
+diff --git a/drivers/media/common/videobuf/videobuf2-dma-sg.c b/drivers/media/common/videobuf/videobuf2-dma-sg.c
 index 29fde1a58a79..ecff8f492c4f 100644
---- a/drivers/media/v4l2-core/videobuf2-dma-sg.c
-+++ b/drivers/media/v4l2-core/videobuf2-dma-sg.c
+--- a/drivers/media/common/videobuf/videobuf2-dma-sg.c
++++ b/drivers/media/common/videobuf/videobuf2-dma-sg.c
 @@ -12,7 +12,6 @@
  
  #include <linux/module.h>
@@ -168,10 +168,10 @@ index 29fde1a58a79..ecff8f492c4f 100644
  
  	return dbuf;
  }
-diff --git a/drivers/media/v4l2-core/videobuf2-memops.c b/drivers/media/v4l2-core/videobuf2-memops.c
+diff --git a/drivers/media/common/videobuf/videobuf2-memops.c b/drivers/media/common/videobuf/videobuf2-memops.c
 index 4bb8424114ce..1cd322e939c7 100644
---- a/drivers/media/v4l2-core/videobuf2-memops.c
-+++ b/drivers/media/v4l2-core/videobuf2-memops.c
+--- a/drivers/media/common/videobuf/videobuf2-memops.c
++++ b/drivers/media/common/videobuf/videobuf2-memops.c
 @@ -96,10 +96,10 @@ static void vb2_common_vm_open(struct vm_area_struct *vma)
  	struct vb2_vmarea_handler *h = vma->vm_private_data;
  
@@ -194,10 +194,10 @@ index 4bb8424114ce..1cd322e939c7 100644
  	       vma->vm_end);
  
  	h->put(h->arg);
-diff --git a/drivers/media/v4l2-core/videobuf2-vmalloc.c b/drivers/media/v4l2-core/videobuf2-vmalloc.c
+diff --git a/drivers/media/common/videobuf/videobuf2-vmalloc.c b/drivers/media/common/videobuf/videobuf2-vmalloc.c
 index f83253a233ca..3f778147cdef 100644
---- a/drivers/media/v4l2-core/videobuf2-vmalloc.c
-+++ b/drivers/media/v4l2-core/videobuf2-vmalloc.c
+--- a/drivers/media/common/videobuf/videobuf2-vmalloc.c
++++ b/drivers/media/common/videobuf/videobuf2-vmalloc.c
 @@ -13,7 +13,6 @@
  #include <linux/io.h>
  #include <linux/module.h>
diff --git a/backports/v4.7_dma_attrs.patch b/backports/v4.7_dma_attrs.patch
index 40a7e5b..cccfbc5 100644
--- a/backports/v4.7_dma_attrs.patch
+++ b/backports/v4.7_dma_attrs.patch
@@ -65,10 +65,10 @@ index b7892f3..3df66d1 100644
  	if (!base)
  		return -ENOMEM;
  
-diff --git a/drivers/media/v4l2-core/videobuf2-dma-contig.c b/drivers/media/v4l2-core/videobuf2-dma-contig.c
+diff --git a/drivers/media/common/videobuf/videobuf2-dma-contig.c b/drivers/media/common/videobuf/videobuf2-dma-contig.c
 index fb6a177..e50ef6a 100644
---- a/drivers/media/v4l2-core/videobuf2-dma-contig.c
-+++ b/drivers/media/v4l2-core/videobuf2-dma-contig.c
+--- a/drivers/media/common/videobuf/videobuf2-dma-contig.c
++++ b/drivers/media/common/videobuf/videobuf2-dma-contig.c
 @@ -27,7 +27,7 @@ struct vb2_dc_buf {
  	unsigned long			size;
  	void				*cookie;
@@ -176,10 +176,10 @@ index fb6a177..e50ef6a 100644
  
  fail_sgt_init:
  	sg_free_table(sgt);
-diff --git a/drivers/media/v4l2-core/videobuf2-dma-sg.c b/drivers/media/v4l2-core/videobuf2-dma-sg.c
+diff --git a/drivers/media/common/videobuf/videobuf2-dma-sg.c b/drivers/media/common/videobuf/videobuf2-dma-sg.c
 index ecff8f4..64a386d 100644
---- a/drivers/media/v4l2-core/videobuf2-dma-sg.c
-+++ b/drivers/media/v4l2-core/videobuf2-dma-sg.c
+--- a/drivers/media/common/videobuf/videobuf2-dma-sg.c
++++ b/drivers/media/common/videobuf/videobuf2-dma-sg.c
 @@ -95,7 +95,7 @@ static int vb2_dma_sg_alloc_compacted(struct vb2_dma_sg_buf *buf,
  	return 0;
  }
@@ -262,10 +262,10 @@ index ecff8f4..64a386d 100644
  	if (buf->vaddr)
  		vm_unmap_ram(buf->vaddr, buf->num_pages);
  	sg_free_table(buf->dma_sgt);
-diff --git a/drivers/media/v4l2-core/videobuf2-vmalloc.c b/drivers/media/v4l2-core/videobuf2-vmalloc.c
+diff --git a/drivers/media/common/videobuf/videobuf2-vmalloc.c b/drivers/media/common/videobuf/videobuf2-vmalloc.c
 index ab3227b..4fdfefd 100644
---- a/drivers/media/v4l2-core/videobuf2-vmalloc.c
-+++ b/drivers/media/v4l2-core/videobuf2-vmalloc.c
+--- a/drivers/media/common/videobuf/videobuf2-vmalloc.c
++++ b/drivers/media/common/videobuf/videobuf2-vmalloc.c
 @@ -33,7 +33,7 @@ struct vb2_vmalloc_buf {
  
  static void vb2_vmalloc_put(void *buf_priv);
diff --git a/backports/v4.8_user_pages_flag.patch b/backports/v4.8_user_pages_flag.patch
index 7216626..b8253e9 100644
--- a/backports/v4.8_user_pages_flag.patch
+++ b/backports/v4.8_user_pages_flag.patch
@@ -62,10 +62,10 @@ index f412429..323ae3a 100644
  
  	if (err != dma->nr_pages) {
  		dma->nr_pages = (err >= 0) ? err : 0;
-diff --git a/drivers/media/v4l2-core/videobuf2-memops.c b/drivers/media/v4l2-core/videobuf2-memops.c
+diff --git a/drivers/media/common/videobuf/videobuf2-memops.c b/drivers/media/common/videobuf/videobuf2-memops.c
 index 1cd322e..3c3b517 100644
---- a/drivers/media/v4l2-core/videobuf2-memops.c
-+++ b/drivers/media/v4l2-core/videobuf2-memops.c
+--- a/drivers/media/common/videobuf/videobuf2-memops.c
++++ b/drivers/media/common/videobuf/videobuf2-memops.c
 @@ -42,10 +42,6 @@ struct frame_vector *vb2_create_framevec(unsigned long start,
  	unsigned long first, last;
  	unsigned long nr;
-- 
2.7.4
