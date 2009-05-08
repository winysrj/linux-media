Return-path: <linux-media-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.183]:25488 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751211AbZEHIz4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 8 May 2009 04:55:56 -0400
Received: by wa-out-1112.google.com with SMTP id j5so763564wah.21
        for <linux-media@vger.kernel.org>; Fri, 08 May 2009 01:55:56 -0700 (PDT)
From: Magnus Damm <magnus.damm@gmail.com>
To: linux-media@vger.kernel.org
Cc: mchehab@infradead.org, hverkuil@xs4all.nl, linux-mm@kvack.org,
	lethal@linux-sh.org, hannes@cmpxchg.org,
	Magnus Damm <magnus.damm@gmail.com>, akpm@linux-foundation.org
Date: Fri, 08 May 2009 17:53:10 +0900
Message-Id: <20090508085310.31326.38083.sendpatchset@rx1.opensource.se>
Subject: [PATCH] videobuf-dma-contig: zero copy USERPTR support V3
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Magnus Damm <damm@igel.co.jp>

This is V3 of the V4L2 videobuf-dma-contig USERPTR zero copy patch.

Since videobuf-dma-contig is designed to handle physically contiguous
memory, this patch modifies the videobuf-dma-contig code to only accept
a user space pointer to physically contiguous memory. For now only
VM_PFNMAP vmas are supported, so forget hotplug.

On SuperH Mobile we use this with our sh_mobile_ceu_camera driver
together with various multimedia accelerator blocks that are exported to
user space using UIO. The UIO kernel code exports physically contiguous
memory to user space and lets the user space application mmap() this memory
and pass a pointer using the USERPTR interface for V4L2 zero copy operation.

With this approach we support zero copy capture, hardware scaling and
various forms of hardware encoding and decoding.

Signed-off-by: Magnus Damm <damm@igel.co.jp>
---

 Needs the following patches (Thanks to Johannes Weiner and akpm):
 - mm-introduce-follow_pte.patch
 - mm-use-generic-follow_pte-in-follow_phys.patch
 - mm-introduce-follow_pfn.patch
 
 Tested on SH7722 Migo-R with a hacked up capture.c

 Changes since V2:
 - use follow_pfn(), drop mm/memory.c changes

 Changes since V1:
 - minor cleanups and formatting changes
 - use follow_phys() in videobuf-dma-contig instead of duplicating code
 - since videobuf-dma-contig can be a module: EXPORT_SYMBOL(follow_phys)
 - move CONFIG_HAVE_IOREMAP_PROT to always build follow_phys()

 drivers/media/video/videobuf-dma-contig.c |   78 +++++++++++++++++++++++++++--
 1 file changed, 73 insertions(+), 5 deletions(-)

--- 0013/drivers/media/video/videobuf-dma-contig.c
+++ work/drivers/media/video/videobuf-dma-contig.c	2009-05-08 15:57:21.000000000 +0900
@@ -17,6 +17,7 @@
 #include <linux/init.h>
 #include <linux/module.h>
 #include <linux/mm.h>
+#include <linux/pagemap.h>
 #include <linux/dma-mapping.h>
 #include <media/videobuf-dma-contig.h>
 
@@ -25,6 +26,7 @@ struct videobuf_dma_contig_memory {
 	void *vaddr;
 	dma_addr_t dma_handle;
 	unsigned long size;
+	int is_userptr;
 };
 
 #define MAGIC_DC_MEM 0x0733ac61
@@ -108,6 +110,66 @@ static struct vm_operations_struct video
 	.close    = videobuf_vm_close,
 };
 
+static void videobuf_dma_contig_user_put(struct videobuf_dma_contig_memory *mem)
+{
+	mem->is_userptr = 0;
+	mem->dma_handle = 0;
+	mem->size = 0;
+}
+
+static int videobuf_dma_contig_user_get(struct videobuf_dma_contig_memory *mem,
+					struct videobuf_buffer *vb)
+{
+	struct mm_struct *mm = current->mm;
+	struct vm_area_struct *vma;
+	unsigned long prev_pfn, this_pfn;
+	unsigned long pages_done, user_address;
+	int ret;
+
+	mem->size = PAGE_ALIGN(vb->size);
+	mem->is_userptr = 0;
+	ret = -EINVAL;
+
+	down_read(&mm->mmap_sem);
+
+	vma = find_vma(mm, vb->baddr);
+	if (!vma)
+		goto out_up;
+
+	if ((vb->baddr + mem->size) > vma->vm_end)
+		goto out_up;
+
+	pages_done = 0;
+	prev_pfn = 0; /* kill warning */
+	user_address = vb->baddr;
+
+	while (pages_done < (mem->size >> PAGE_SHIFT)) {
+		ret = follow_pfn(vma, user_address, &this_pfn);
+		if (ret)
+			break;
+
+		if (pages_done == 0)
+			mem->dma_handle = this_pfn << PAGE_SHIFT;
+		else if (this_pfn != (prev_pfn + 1))
+			ret = -EFAULT;
+
+		if (ret)
+			break;
+
+		prev_pfn = this_pfn;
+		user_address += PAGE_SIZE;
+		pages_done++;
+	}
+
+	if (!ret)
+		mem->is_userptr = 1;
+
+ out_up:
+	up_read(&current->mm->mmap_sem);
+
+	return ret;
+}
+
 static void *__videobuf_alloc(size_t size)
 {
 	struct videobuf_dma_contig_memory *mem;
@@ -154,12 +216,11 @@ static int __videobuf_iolock(struct vide
 	case V4L2_MEMORY_USERPTR:
 		dev_dbg(q->dev, "%s memory method USERPTR\n", __func__);
 
-		/* The only USERPTR currently supported is the one needed for
-		   read() method.
-		 */
+		/* handle pointer from user space */
 		if (vb->baddr)
-			return -EINVAL;
+			return videobuf_dma_contig_user_get(mem, vb);
 
+		/* allocate memory for the read() method */
 		mem->size = PAGE_ALIGN(vb->size);
 		mem->vaddr = dma_alloc_coherent(q->dev, mem->size,
 						&mem->dma_handle, GFP_KERNEL);
@@ -386,7 +447,7 @@ void videobuf_dma_contig_free(struct vid
 	   So, it should free memory only if the memory were allocated for
 	   read() operation.
 	 */
-	if ((buf->memory != V4L2_MEMORY_USERPTR) || buf->baddr)
+	if (buf->memory != V4L2_MEMORY_USERPTR)
 		return;
 
 	if (!mem)
@@ -394,6 +455,13 @@ void videobuf_dma_contig_free(struct vid
 
 	MAGIC_CHECK(mem->magic, MAGIC_DC_MEM);
 
+	/* handle user space pointer case */
+	if (buf->baddr) {
+		videobuf_dma_contig_user_put(mem);
+		return;
+	}
+
+	/* read() method */
 	dma_free_coherent(q->dev, mem->size, mem->vaddr, mem->dma_handle);
 	mem->vaddr = NULL;
 }
