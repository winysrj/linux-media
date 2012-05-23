Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:45664 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756161Ab2EWNHv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 23 May 2012 09:07:51 -0400
Received: from euspt2 (mailout1.w1.samsung.com [210.118.77.11])
 by mailout1.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0M4H00EPN8D0GP@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 23 May 2012 14:05:26 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0M4H003UB8GVN0@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 23 May 2012 14:07:43 +0100 (BST)
Date: Wed, 23 May 2012 15:07:33 +0200
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
Subject: [PATCH 10/12] v4l: vb2: remove vb2_mmap_pfn_range function
In-reply-to: <1337778455-27912-1-git-send-email-t.stanislaws@samsung.com>
To: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org
Cc: airlied@redhat.com, m.szyprowski@samsung.com,
	t.stanislaws@samsung.com, kyungmin.park@samsung.com,
	laurent.pinchart@ideasonboard.com, sumit.semwal@ti.com,
	daeinki@gmail.com, daniel.vetter@ffwll.ch, robdclark@gmail.com,
	pawel@osciak.com, linaro-mm-sig@lists.linaro.org,
	hverkuil@xs4all.nl, remi@remlab.net, subashrp@gmail.com,
	mchehab@redhat.com, g.liakhovetski@gmx.de
Message-id: <1337778455-27912-11-git-send-email-t.stanislaws@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <1337778455-27912-1-git-send-email-t.stanislaws@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch removes vb2_mmap_pfn_range from videobuf2 helpers.
The function is no longer used in vb2 code.

Suggested-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Tomasz Stanislawski <t.stanislaws@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/video/videobuf2-memops.c |   40 --------------------------------
 include/media/videobuf2-memops.h       |    5 ----
 2 files changed, 45 deletions(-)

diff --git a/drivers/media/video/videobuf2-memops.c b/drivers/media/video/videobuf2-memops.c
index 504cd4c..81c1ad8 100644
--- a/drivers/media/video/videobuf2-memops.c
+++ b/drivers/media/video/videobuf2-memops.c
@@ -137,46 +137,6 @@ int vb2_get_contig_userptr(unsigned long vaddr, unsigned long size,
 EXPORT_SYMBOL_GPL(vb2_get_contig_userptr);
 
 /**
- * vb2_mmap_pfn_range() - map physical pages to userspace
- * @vma:	virtual memory region for the mapping
- * @paddr:	starting physical address of the memory to be mapped
- * @size:	size of the memory to be mapped
- * @vm_ops:	vm operations to be assigned to the created area
- * @priv:	private data to be associated with the area
- *
- * Returns 0 on success.
- */
-int vb2_mmap_pfn_range(struct vm_area_struct *vma, unsigned long paddr,
-				unsigned long size,
-				const struct vm_operations_struct *vm_ops,
-				void *priv)
-{
-	int ret;
-
-	size = min_t(unsigned long, vma->vm_end - vma->vm_start, size);
-
-	vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
-	ret = remap_pfn_range(vma, vma->vm_start, paddr >> PAGE_SHIFT,
-				size, vma->vm_page_prot);
-	if (ret) {
-		printk(KERN_ERR "Remapping memory failed, error: %d\n", ret);
-		return ret;
-	}
-
-	vma->vm_flags		|= VM_DONTEXPAND | VM_RESERVED;
-	vma->vm_private_data	= priv;
-	vma->vm_ops		= vm_ops;
-
-	vma->vm_ops->open(vma);
-
-	pr_debug("%s: mapped paddr 0x%08lx at 0x%08lx, size %ld\n",
-			__func__, paddr, vma->vm_start, size);
-
-	return 0;
-}
-EXPORT_SYMBOL_GPL(vb2_mmap_pfn_range);
-
-/**
  * vb2_common_vm_open() - increase refcount of the vma
  * @vma:	virtual memory region for the mapping
  *
diff --git a/include/media/videobuf2-memops.h b/include/media/videobuf2-memops.h
index 84e1f6c..f05444c 100644
--- a/include/media/videobuf2-memops.h
+++ b/include/media/videobuf2-memops.h
@@ -33,11 +33,6 @@ extern const struct vm_operations_struct vb2_common_vm_ops;
 int vb2_get_contig_userptr(unsigned long vaddr, unsigned long size,
 			   struct vm_area_struct **res_vma, dma_addr_t *res_pa);
 
-int vb2_mmap_pfn_range(struct vm_area_struct *vma, unsigned long paddr,
-				unsigned long size,
-				const struct vm_operations_struct *vm_ops,
-				void *priv);
-
 struct vm_area_struct *vb2_get_vma(struct vm_area_struct *vma);
 void vb2_put_vma(struct vm_area_struct *vma);
 
-- 
1.7.9.5

