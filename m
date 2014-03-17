Return-path: <linux-media-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:48026 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751295AbaCQTto (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 17 Mar 2014 15:49:44 -0400
From: Jan Kara <jack@suse.cz>
To: linux-mm@kvack.org
Cc: linux-media@vger.kernel.org, Jan Kara <jack@suse.cz>
Subject: [PATCH 2/9] media: omap_vout: Convert omap_vout_uservirt_to_phys() to use get_vaddr_pfns()
Date: Mon, 17 Mar 2014 20:49:29 +0100
Message-Id: <1395085776-8626-3-git-send-email-jack@suse.cz>
In-Reply-To: <1395085776-8626-1-git-send-email-jack@suse.cz>
References: <1395085776-8626-1-git-send-email-jack@suse.cz>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Convert omap_vout_uservirt_to_phys() to use get_vaddr_pfns() instead of
hand made mapping of virtual address to physical address. Also the
function leaked page reference from get_user_pages() so fix that by
properly release the reference when omap_vout_buffer_release() is
called.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 drivers/media/platform/omap/omap_vout.c | 63 +++++++++++++++------------------
 1 file changed, 29 insertions(+), 34 deletions(-)

diff --git a/drivers/media/platform/omap/omap_vout.c b/drivers/media/platform/omap/omap_vout.c
index dfd0a21a0658..8c5803e4ce15 100644
--- a/drivers/media/platform/omap/omap_vout.c
+++ b/drivers/media/platform/omap/omap_vout.c
@@ -199,43 +199,31 @@ static int omap_vout_try_format(struct v4l2_pix_format *pix)
  * omap_vout_uservirt_to_phys: This inline function is used to convert user
  * space virtual address to physical address.
  */
-static u32 omap_vout_uservirt_to_phys(u32 virtp)
+static int omap_vout_get_userptr(struct videobuf_buffer *vb, u32 virtp,
+				 u32 *physp)
 {
-	unsigned long physp = 0;
-	struct vm_area_struct *vma;
-	struct mm_struct *mm = current->mm;
+	struct pinned_pfns *pfns;
+	int ret;
 
 	/* For kernel direct-mapped memory, take the easy way */
-	if (virtp >= PAGE_OFFSET)
-		return virt_to_phys((void *) virtp);
-
-	down_read(&current->mm->mmap_sem);
-	vma = find_vma(mm, virtp);
-	if (vma && (vma->vm_flags & VM_IO) && vma->vm_pgoff) {
-		/* this will catch, kernel-allocated, mmaped-to-usermode
-		   addresses */
-		physp = (vma->vm_pgoff << PAGE_SHIFT) + (virtp - vma->vm_start);
-		up_read(&current->mm->mmap_sem);
-	} else {
-		/* otherwise, use get_user_pages() for general userland pages */
-		int res, nr_pages = 1;
-		struct page *pages;
+	if (virtp >= PAGE_OFFSET) {
+		*physp = virt_to_phys((void *)virtp);
+		return 0;
+	}
 
-		res = get_user_pages(current, current->mm, virtp, nr_pages, 1,
-				0, &pages, NULL);
-		up_read(&current->mm->mmap_sem);
+	pfns = pfns_vector_create(1);
+	if (!pfns)
+		return -ENOMEM;
 
-		if (res == nr_pages) {
-			physp =  __pa(page_address(&pages[0]) +
-					(virtp & ~PAGE_MASK));
-		} else {
-			printk(KERN_WARNING VOUT_NAME
-					"get_user_pages failed\n");
-			return 0;
-		}
+	ret = get_vaddr_pfns(virtp, 1, 1, 0, pfns);
+	if (ret != 1) {
+		pfns_vector_destroy(pfns);
+		return -EINVAL;
 	}
+	*physp = __pfn_to_phys(pfns_vector_pfns(pfns)[0]);
+	vb->priv = pfns;
 
-	return physp;
+	return 0;
 }
 
 /*
@@ -790,11 +778,15 @@ static int omap_vout_buffer_prepare(struct videobuf_queue *q,
 	 * address of the buffer
 	 */
 	if (V4L2_MEMORY_USERPTR == vb->memory) {
+		int ret;
+
 		if (0 == vb->baddr)
 			return -EINVAL;
 		/* Physical address */
-		vout->queued_buf_addr[vb->i] = (u8 *)
-			omap_vout_uservirt_to_phys(vb->baddr);
+		ret = omap_vout_get_userptr(vb, vb->baddr,
+				(u32 *)&vout->queued_buf_addr[vb->i]);
+		if (ret < 0)
+			return ret;
 	} else {
 		u32 addr, dma_addr;
 		unsigned long size;
@@ -843,9 +835,12 @@ static void omap_vout_buffer_release(struct videobuf_queue *q,
 	struct omap_vout_device *vout = q->priv_data;
 
 	vb->state = VIDEOBUF_NEEDS_INIT;
+	if (vb->memory == V4L2_MEMORY_USERPTR && vb->priv) {
+		struct pinned_pfns *pfns = vb->priv;
 
-	if (V4L2_MEMORY_MMAP != vout->memory)
-		return;
+		put_vaddr_pfns(pfns);
+		pfns_vector_destroy(pfns);
+	}
 }
 
 /*
-- 
1.8.1.4

