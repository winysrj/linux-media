Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:9684 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751452Ab1LOPZx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 15 Dec 2011 10:25:53 -0500
Received: from euspt2 (mailout1.w1.samsung.com [210.118.77.11])
 by mailout1.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0LW900837473CT@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 15 Dec 2011 15:25:51 +0000 (GMT)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LW900JS24722T@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 15 Dec 2011 15:25:51 +0000 (GMT)
Date: Thu, 15 Dec 2011 16:25:29 +0100
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: [PATCH] media: vb2: vmalloc-based allocator user pointer handling
In-reply-to: <201112120024.04418.laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Pawel Osciak <pawel@osciak.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Andrzej Pietrasiewicz <andrzej.p@samsung.com>
Message-id: <1323962729-5689-1-git-send-email-m.szyprowski@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <201112120024.04418.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Andrzej Pietrasiewicz <andrzej.p@samsung.com>

This patch adds support for user pointer memory buffers to vmalloc
videobuf2 allocator.

Signed-off-by: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
CC: Pawel Osciak <pawel@osciak.com>
---
 drivers/media/video/videobuf2-vmalloc.c |   90 ++++++++++++++++++++++++++----
 1 files changed, 78 insertions(+), 12 deletions(-)

diff --git a/drivers/media/video/videobuf2-vmalloc.c b/drivers/media/video/videobuf2-vmalloc.c
index a3a8842..4e789a1 100644
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
@@ -31,7 +35,7 @@ static void *vb2_vmalloc_alloc(void *alloc_ctx, unsigned long size)
 {
 	struct vb2_vmalloc_buf *buf;
 
-	buf = kzalloc(sizeof *buf, GFP_KERNEL);
+	buf = kzalloc(sizeof(*buf), GFP_KERNEL);
 	if (!buf)
 		return NULL;
 
@@ -42,15 +46,12 @@ static void *vb2_vmalloc_alloc(void *alloc_ctx, unsigned long size)
 	buf->handler.arg = buf;
 
 	if (!buf->vaddr) {
-		printk(KERN_ERR "vmalloc of size %ld failed\n", buf->size);
+		pr_debug("vmalloc of size %ld failed\n", buf->size);
 		kfree(buf);
 		return NULL;
 	}
 
 	atomic_inc(&buf->refcount);
-	printk(KERN_DEBUG "Allocated vmalloc buffer of size %ld at vaddr=%p\n",
-			buf->size, buf->vaddr);
-
 	return buf;
 }
 
@@ -59,21 +60,84 @@ static void vb2_vmalloc_put(void *buf_priv)
 	struct vb2_vmalloc_buf *buf = buf_priv;
 
 	if (atomic_dec_and_test(&buf->refcount)) {
-		printk(KERN_DEBUG "%s: Freeing vmalloc mem at vaddr=%p\n",
-			__func__, buf->vaddr);
 		vfree(buf->vaddr);
 		kfree(buf);
 	}
 }
 
-static void *vb2_vmalloc_vaddr(void *buf_priv)
+static void *vb2_vmalloc_get_userptr(void *alloc_ctx, unsigned long vaddr,
+				     unsigned long size, int write)
+{
+	struct vb2_vmalloc_buf *buf;
+	unsigned long first, last;
+	int n_pages, offset;
+
+	buf = kzalloc(sizeof(*buf), GFP_KERNEL);
+	if (!buf)
+		return NULL;
+
+	buf->write = write;
+	offset = vaddr & ~PAGE_MASK;
+	buf->size = size;
+
+	first = vaddr >> PAGE_SHIFT;
+	last  = (vaddr + size - 1) >> PAGE_SHIFT;
+	buf->n_pages = last - first + 1;
+	buf->pages = kzalloc(buf->n_pages * sizeof(struct page *), GFP_KERNEL);
+	if (!buf->pages)
+		goto fail_pages_array_alloc;
+
+	/* current->mm->mmap_sem is taken by videobuf2 core */
+	n_pages = get_user_pages(current, current->mm, vaddr & PAGE_MASK,
+				 buf->n_pages, write, 1, /* force */
+				 buf->pages, NULL);
+	if (n_pages != buf->n_pages)
+		goto fail_get_user_pages;
+
+	buf->vaddr = vm_map_ram(buf->pages, buf->n_pages, -1, PAGE_KERNEL);
+	if (!buf->vaddr)
+		goto fail_get_user_pages;
+
+	buf->vaddr += offset;
+	return buf;
+
+fail_get_user_pages:
+	pr_debug("get_user_pages requested/got: %d/%d]\n", n_pages,
+		 buf->n_pages);
+	while (--n_pages >= 0)
+		put_page(buf->pages[n_pages]);
+	kfree(buf->pages);
+
+fail_pages_array_alloc:
+	kfree(buf);
+
+	return NULL;
+}
+
+static void vb2_vmalloc_put_userptr(void *buf_priv)
 {
 	struct vb2_vmalloc_buf *buf = buf_priv;
+	unsigned long vaddr = (unsigned long)buf->vaddr & PAGE_MASK;
+	unsigned int i;
+
+	if (vaddr)
+		vm_unmap_ram((void *)vaddr, buf->n_pages);
+	for (i = 0; i < buf->n_pages; ++i) {
+		if (buf->write)
+			set_page_dirty_lock(buf->pages[i]);
+		put_page(buf->pages[i]);
+	}
+	kfree(buf->pages);
+	kfree(buf);
+}
 
-	BUG_ON(!buf);
+static void *vb2_vmalloc_vaddr(void *buf_priv)
+{
+	struct vb2_vmalloc_buf *buf = buf_priv;
 
 	if (!buf->vaddr) {
-		printk(KERN_ERR "Address of an unallocated plane requested\n");
+		pr_err("Address of an unallocated plane requested "
+		       "or cannot map user pointer\n");
 		return NULL;
 	}
 
@@ -92,13 +156,13 @@ static int vb2_vmalloc_mmap(void *buf_priv, struct vm_area_struct *vma)
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
 
@@ -121,6 +185,8 @@ static int vb2_vmalloc_mmap(void *buf_priv, struct vm_area_struct *vma)
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

