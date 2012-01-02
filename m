Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:59985 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752335Ab2ABOMf (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 2 Jan 2012 09:12:35 -0500
Received: by werm1 with SMTP id m1so7432655wer.19
        for <linux-media@vger.kernel.org>; Mon, 02 Jan 2012 06:12:33 -0800 (PST)
From: Javier Martin <javier.martin@vista-silicon.com>
To: linux-media@vger.kernel.org
Cc: mchehab@infradead.org, pawel@osciak.com,
	laurent.pinchart@ideasonboard.com, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com,
	Javier Martin <javier.martin@vista-silicon.com>
Subject: [PATCH 1/2] media: vb2: support userptr for PFN mappings.
Date: Mon,  2 Jan 2012 15:12:22 +0100
Message-Id: <1325513543-17299-1-git-send-email-javier.martin@vista-silicon.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Some video devices need to use contiguous memory
which is not backed by pages as it happens with
vmalloc. This patch provides userptr handling for
those devices.

Signed-off-by: Javier Martin <javier.martin@vista-silicon.com>
---
 drivers/media/video/videobuf2-vmalloc.c |   66 +++++++++++++++++++-----------
 1 files changed, 42 insertions(+), 24 deletions(-)

diff --git a/drivers/media/video/videobuf2-vmalloc.c b/drivers/media/video/videobuf2-vmalloc.c
index 03aa62f..5bc7cec 100644
--- a/drivers/media/video/videobuf2-vmalloc.c
+++ b/drivers/media/video/videobuf2-vmalloc.c
@@ -15,6 +15,7 @@
 #include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/vmalloc.h>
+#include <linux/io.h>
 
 #include <media/videobuf2-core.h>
 #include <media/videobuf2-memops.h>
@@ -71,6 +72,8 @@ static void *vb2_vmalloc_get_userptr(void *alloc_ctx, unsigned long vaddr,
 	struct vb2_vmalloc_buf *buf;
 	unsigned long first, last;
 	int n_pages, offset;
+	struct vm_area_struct *vma;
+	unsigned long int physp;
 
 	buf = kzalloc(sizeof(*buf), GFP_KERNEL);
 	if (!buf)
@@ -80,23 +83,34 @@ static void *vb2_vmalloc_get_userptr(void *alloc_ctx, unsigned long vaddr,
 	offset = vaddr & ~PAGE_MASK;
 	buf->size = size;
 
-	first = vaddr >> PAGE_SHIFT;
-	last  = (vaddr + size - 1) >> PAGE_SHIFT;
-	buf->n_pages = last - first + 1;
-	buf->pages = kzalloc(buf->n_pages * sizeof(struct page *), GFP_KERNEL);
-	if (!buf->pages)
-		goto fail_pages_array_alloc;
-
-	/* current->mm->mmap_sem is taken by videobuf2 core */
-	n_pages = get_user_pages(current, current->mm, vaddr & PAGE_MASK,
-					buf->n_pages, write, 1, /* force */
-					buf->pages, NULL);
-	if (n_pages != buf->n_pages)
-		goto fail_get_user_pages;
-
-	buf->vaddr = vm_map_ram(buf->pages, buf->n_pages, -1, PAGE_KERNEL);
-	if (!buf->vaddr)
-		goto fail_get_user_pages;
+	vma = find_vma(current->mm, vaddr);
+	if (vma && (vma->vm_flags & VM_IO) && (vma->vm_pgoff)) {
+		physp = (vma->vm_pgoff << PAGE_SHIFT) + (vaddr - vma->vm_start);
+		buf->vaddr = ioremap_nocache(physp, size);
+		if (!buf->vaddr)
+			goto fail_pages_array_alloc;
+	} else {
+		first = vaddr >> PAGE_SHIFT;
+		last  = (vaddr + size - 1) >> PAGE_SHIFT;
+		buf->n_pages = last - first + 1;
+		buf->pages = kzalloc(buf->n_pages * sizeof(struct page *),
+				     GFP_KERNEL);
+		if (!buf->pages)
+			goto fail_pages_array_alloc;
+
+		/* current->mm->mmap_sem is taken by videobuf2 core */
+		n_pages = get_user_pages(current, current->mm,
+					 vaddr & PAGE_MASK, buf->n_pages,
+					 write,1, /* force */
+					 buf->pages, NULL);
+		if (n_pages != buf->n_pages)
+			goto fail_get_user_pages;
+
+		buf->vaddr = vm_map_ram(buf->pages, buf->n_pages, -1,
+					PAGE_KERNEL);
+		if (!buf->vaddr)
+			goto fail_get_user_pages;
+	}
 
 	buf->vaddr += offset;
 	return buf;
@@ -120,14 +134,18 @@ static void vb2_vmalloc_put_userptr(void *buf_priv)
 	unsigned long vaddr = (unsigned long)buf->vaddr & PAGE_MASK;
 	unsigned int i;
 
-	if (vaddr)
-		vm_unmap_ram((void *)vaddr, buf->n_pages);
-	for (i = 0; i < buf->n_pages; ++i) {
-		if (buf->write)
-			set_page_dirty_lock(buf->pages[i]);
-		put_page(buf->pages[i]);
+	if (buf->pages) {
+		if (vaddr)
+			vm_unmap_ram((void *)vaddr, buf->n_pages);
+		for (i = 0; i < buf->n_pages; ++i) {
+			if (buf->write)
+				set_page_dirty_lock(buf->pages[i]);
+			put_page(buf->pages[i]);
+		}
+		kfree(buf->pages);
+	} else {
+		iounmap(buf->vaddr);
 	}
-	kfree(buf->pages);
 	kfree(buf);
 }
 
-- 
1.7.0.4

