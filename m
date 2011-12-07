Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:54462 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757923Ab1LGQ3R (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 7 Dec 2011 11:29:17 -0500
Received: from euspt1 (mailout1.w1.samsung.com [210.118.77.11])
 by mailout1.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0LVU00C6FDSQ5U@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 07 Dec 2011 16:29:15 +0000 (GMT)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LVU006NODSP0V@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 07 Dec 2011 16:29:14 +0000 (GMT)
Date: Wed, 07 Dec 2011 17:29:06 +0100
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: [PATCH v2] media: vb2: vmalloc-based allocator user pointer handling
To: linux-media@vger.kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Pawel Osciak <pawel@osciak.com>,
	Andrzej Pietrasiewicz <andrzej.p@samsung.com>
Message-id: <1323275346-25824-1-git-send-email-m.szyprowski@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Andrzej Pietrasiewicz <andrzej.p@samsung.com>

This patch adds support for user pointer memory buffers to vmalloc
videobuf2 allocator.

Signed-off-by: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
---
 drivers/media/video/videobuf2-vmalloc.c |   97 ++++++++++++++++++++++++++++---
 1 files changed, 89 insertions(+), 8 deletions(-)

diff --git a/drivers/media/video/videobuf2-vmalloc.c b/drivers/media/video/videobuf2-vmalloc.c
index a3a8842..8843ad0 100644
--- a/drivers/media/video/videobuf2-vmalloc.c
+++ b/drivers/media/video/videobuf2-vmalloc.c
@@ -12,6 +12,7 @@
 
 #include <linux/module.h>
 #include <linux/mm.h>
+#include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/vmalloc.h>
 
@@ -20,7 +21,10 @@
 
 struct vb2_vmalloc_buf {
 	void				*vaddr;
+	struct page			**pages;
+	int				write;
 	unsigned long			size;
+	unsigned int			n_pages;
 	atomic_t			refcount;
 	struct vb2_vmarea_handler	handler;
 };
@@ -42,14 +46,14 @@ static void *vb2_vmalloc_alloc(void *alloc_ctx, unsigned long size)
 	buf->handler.arg = buf;
 
 	if (!buf->vaddr) {
-		printk(KERN_ERR "vmalloc of size %ld failed\n", buf->size);
+		pr_err("vmalloc of size %ld failed\n", buf->size);
 		kfree(buf);
 		return NULL;
 	}
 
 	atomic_inc(&buf->refcount);
-	printk(KERN_DEBUG "Allocated vmalloc buffer of size %ld at vaddr=%p\n",
-			buf->size, buf->vaddr);
+	pr_err("Allocated vmalloc buffer of size %ld at vaddr=%p\n", buf->size,
+	       buf->vaddr);
 
 	return buf;
 }
@@ -59,13 +63,87 @@ static void vb2_vmalloc_put(void *buf_priv)
 	struct vb2_vmalloc_buf *buf = buf_priv;
 
 	if (atomic_dec_and_test(&buf->refcount)) {
-		printk(KERN_DEBUG "%s: Freeing vmalloc mem at vaddr=%p\n",
-			__func__, buf->vaddr);
+		pr_debug("%s: Freeing vmalloc mem at vaddr=%p\n", __func__,
+			 buf->vaddr);
 		vfree(buf->vaddr);
 		kfree(buf);
 	}
 }
 
+static void *vb2_vmalloc_get_userptr(void *alloc_ctx, unsigned long vaddr,
+				     unsigned long size, int write)
+{
+	struct vb2_vmalloc_buf *buf;
+
+	unsigned long first, last;
+	int n_pages_from_user, offset;
+
+	buf = kzalloc(sizeof *buf, GFP_KERNEL);
+	if (!buf)
+		return NULL;
+
+	buf->write = write;
+	offset = vaddr & ~PAGE_MASK;
+	buf->size = size;
+
+	first = (vaddr & PAGE_MASK) >> PAGE_SHIFT;
+	last  = ((vaddr + size - 1) & PAGE_MASK) >> PAGE_SHIFT;
+	buf->n_pages = last - first + 1;
+	buf->pages = kzalloc(buf->n_pages * sizeof(struct page *), GFP_KERNEL);
+	if (!buf->pages)
+		goto userptr_fail_pages_array_alloc;
+
+	/* current->mm->mmap_sem is taken by videobuf core */
+	n_pages_from_user = get_user_pages(current, current->mm,
+					     vaddr & PAGE_MASK,
+					     buf->n_pages,
+					     write,
+					     1, /* force */
+					     buf->pages,
+					     NULL);
+	if (n_pages_from_user != buf->n_pages)
+		goto userptr_fail_get_user_pages;
+
+	buf->vaddr = vm_map_ram(buf->pages, buf->n_pages, -1, PAGE_KERNEL);
+
+	if (!buf->vaddr)
+		goto userptr_fail_get_user_pages;
+
+	buf->vaddr += offset;
+	return buf;
+
+userptr_fail_get_user_pages:
+	pr_debug("get_user_pages requested/got: %d/%d]\n", n_pages_from_user,
+		 buf->n_pages);
+	while (--n_pages_from_user >= 0)
+		put_page(buf->pages[n_pages_from_user]);
+	kfree(buf->pages);
+
+userptr_fail_pages_array_alloc:
+	kfree(buf);
+
+	return NULL;
+}
+
+static void vb2_vmalloc_put_userptr(void *buf_priv)
+{
+	struct vb2_vmalloc_buf *buf = buf_priv;
+
+	unsigned int i;
+	int offset = (unsigned long)buf->vaddr & ~PAGE_MASK;
+
+	if (buf->vaddr)
+		vm_unmap_ram((const void *)((unsigned long)buf->vaddr - offset),
+			     buf->n_pages);
+	for (i = 0; i < buf->n_pages; ++i) {
+		if (buf->write)
+			set_page_dirty_lock(buf->pages[i]);
+		put_page(buf->pages[i]);
+	}
+	kfree(buf->pages);
+	kfree(buf);
+}
+
 static void *vb2_vmalloc_vaddr(void *buf_priv)
 {
 	struct vb2_vmalloc_buf *buf = buf_priv;
@@ -73,7 +151,8 @@ static void *vb2_vmalloc_vaddr(void *buf_priv)
 	BUG_ON(!buf);
 
 	if (!buf->vaddr) {
-		printk(KERN_ERR "Address of an unallocated plane requested\n");
+		pr_err("Address of an unallocated plane requested "
+		       "or cannot map user pointer\n");
 		return NULL;
 	}
 
@@ -92,13 +171,13 @@ static int vb2_vmalloc_mmap(void *buf_priv, struct vm_area_struct *vma)
 	int ret;
 
 	if (!buf) {
-		printk(KERN_ERR "No memory to map\n");
+		pr_err("No memory to map\n");
 		return -EINVAL;
 	}
 
 	ret = remap_vmalloc_range(vma, buf->vaddr, 0);
 	if (ret) {
-		printk(KERN_ERR "Remapping vmalloc memory, error: %d\n", ret);
+		pr_err("Remapping vmalloc memory, error: %d\n", ret);
 		return ret;
 	}
 
@@ -121,6 +200,8 @@ static int vb2_vmalloc_mmap(void *buf_priv, struct vm_area_struct *vma)
 const struct vb2_mem_ops vb2_vmalloc_memops = {
 	.alloc		= vb2_vmalloc_alloc,
 	.put		= vb2_vmalloc_put,
+	.get_userptr	= vb2_vmalloc_get_userptr,
+	.put_userptr	= vb2_vmalloc_put_userptr,
 	.vaddr		= vb2_vmalloc_vaddr,
 	.mmap		= vb2_vmalloc_mmap,
 	.num_users	= vb2_vmalloc_num_users,
-- 
1.7.1.569.g6f426

