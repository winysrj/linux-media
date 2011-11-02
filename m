Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:44729 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752143Ab1KBKw4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 2 Nov 2011 06:52:56 -0400
Received: from euspt1 (mailout1.w1.samsung.com [210.118.77.11])
 by mailout1.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0LU100B4Q4W5Z6@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 02 Nov 2011 10:52:54 +0000 (GMT)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LU1008AJ4W5AO@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 02 Nov 2011 10:52:53 +0000 (GMT)
Date: Wed, 02 Nov 2011 11:52:02 +0100
From: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
Subject: [PATCH] media: vb2: vmalloc-based allocator user pointer handling
To: linux-media@vger.kernel.org
Cc: Andrzej Pietrasiewicz <andrzej.p@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Pawel Osciak <pawel@osciak.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Message-id: <1320231122-22518-1-git-send-email-andrzej.p@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

vmalloc-based allocator user pointer handling

Signed-off-by: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/video/videobuf2-vmalloc.c |   86 ++++++++++++++++++++++++++++++-
 1 files changed, 85 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/videobuf2-vmalloc.c b/drivers/media/video/videobuf2-vmalloc.c
index a3a8842..ee0ee37 100644
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
@@ -66,6 +70,83 @@ static void vb2_vmalloc_put(void *buf_priv)
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
+	buf->vaddr = NULL;
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
+	down_read(&current->mm->mmap_sem);
+	n_pages_from_user = get_user_pages(current, current->mm,
+					     vaddr & PAGE_MASK,
+					     buf->n_pages,
+					     write,
+					     1, /* force */
+					     buf->pages,
+					     NULL);
+	up_read(&current->mm->mmap_sem);
+	if (n_pages_from_user != buf->n_pages)
+		goto userptr_fail_get_user_pages;
+
+	buf->vaddr = vm_map_ram(buf->pages, buf->n_pages, -1, PAGE_KERNEL);
+
+	if (buf->vaddr) {
+		buf->vaddr += offset;
+		return buf;
+	}
+
+userptr_fail_get_user_pages:
+	printk(KERN_DEBUG "get_user_pages requested/got: %d/%d]\n",
+	       n_pages_from_user, buf->n_pages);
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
+	int i = buf->n_pages;
+	int offset = (unsigned long)buf->vaddr & ~PAGE_MASK;
+
+	printk(KERN_DEBUG "%s: Releasing userspace buffer of %d pages\n",
+	       __func__, buf->n_pages);
+	if (buf->vaddr)
+		vm_unmap_ram((const void *)((unsigned long)buf->vaddr - offset),
+			     buf->n_pages);
+	while (--i >= 0) {
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
@@ -73,7 +154,8 @@ static void *vb2_vmalloc_vaddr(void *buf_priv)
 	BUG_ON(!buf);
 
 	if (!buf->vaddr) {
-		printk(KERN_ERR "Address of an unallocated plane requested\n");
+		printk(KERN_ERR "Address of an unallocated plane requested "
+		       "or cannot map user pointer\n");
 		return NULL;
 	}
 
@@ -121,6 +203,8 @@ static int vb2_vmalloc_mmap(void *buf_priv, struct vm_area_struct *vma)
 const struct vb2_mem_ops vb2_vmalloc_memops = {
 	.alloc		= vb2_vmalloc_alloc,
 	.put		= vb2_vmalloc_put,
+	.get_userptr	= vb2_vmalloc_get_userptr,
+	.put_userptr	= vb2_vmalloc_put_userptr,
 	.vaddr		= vb2_vmalloc_vaddr,
 	.mmap		= vb2_vmalloc_mmap,
 	.num_users	= vb2_vmalloc_num_users,
-- 
1.7.0.4

