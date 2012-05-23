Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:45664 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751687Ab2EWNHq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 23 May 2012 09:07:46 -0400
Received: from euspt2 (mailout1.w1.samsung.com [210.118.77.11])
 by mailout1.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0M4H00EPK8D0GP@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 23 May 2012 14:05:24 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0M4H003TV8GUN0@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 23 May 2012 14:07:42 +0100 (BST)
Date: Wed, 23 May 2012 15:07:24 +0200
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
Subject: [PATCH 01/12] v4l: vb2-dma-contig: let mmap method to use
 dma_mmap_coherent call
In-reply-to: <1337778455-27912-1-git-send-email-t.stanislaws@samsung.com>
To: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org
Cc: airlied@redhat.com, m.szyprowski@samsung.com,
	t.stanislaws@samsung.com, kyungmin.park@samsung.com,
	laurent.pinchart@ideasonboard.com, sumit.semwal@ti.com,
	daeinki@gmail.com, daniel.vetter@ffwll.ch, robdclark@gmail.com,
	pawel@osciak.com, linaro-mm-sig@lists.linaro.org,
	hverkuil@xs4all.nl, remi@remlab.net, subashrp@gmail.com,
	mchehab@redhat.com, g.liakhovetski@gmx.de
Message-id: <1337778455-27912-2-git-send-email-t.stanislaws@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <1337778455-27912-1-git-send-email-t.stanislaws@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Marek Szyprowski <m.szyprowski@samsung.com>

Let mmap method to use dma_mmap_coherent call.  This patch depends on DMA
mapping redesign patches because the usage of dma_mmap_coherent breaks
dma-contig allocator for architectures other than ARM and AVR.

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
---
 drivers/media/video/videobuf2-dma-contig.c |   28 ++++++++++++++++++++++++++--
 1 file changed, 26 insertions(+), 2 deletions(-)

diff --git a/drivers/media/video/videobuf2-dma-contig.c b/drivers/media/video/videobuf2-dma-contig.c
index 9c213bc..52b4f59 100644
--- a/drivers/media/video/videobuf2-dma-contig.c
+++ b/drivers/media/video/videobuf2-dma-contig.c
@@ -224,14 +224,38 @@ static void *vb2_dc_alloc(void *alloc_ctx, unsigned long size)
 static int vb2_dc_mmap(void *buf_priv, struct vm_area_struct *vma)
 {
 	struct vb2_dc_buf *buf = buf_priv;
+	int ret;
 
 	if (!buf) {
 		printk(KERN_ERR "No buffer to map\n");
 		return -EINVAL;
 	}
 
-	return vb2_mmap_pfn_range(vma, buf->dma_addr, buf->size,
-				  &vb2_common_vm_ops, &buf->handler);
+	/*
+	 * dma_mmap_* uses vm_pgoff as in-buffer offset, but we want to
+	 * map whole buffer
+	 */
+	vma->vm_pgoff = 0;
+
+	ret = dma_mmap_coherent(buf->dev, vma, buf->vaddr,
+		buf->dma_addr, buf->size);
+
+	if (ret) {
+		printk(KERN_ERR "Remapping memory failed, error: %d\n", ret);
+		return ret;
+	}
+
+	vma->vm_flags		|= VM_DONTEXPAND | VM_RESERVED;
+	vma->vm_private_data	= &buf->handler;
+	vma->vm_ops		= &vb2_common_vm_ops;
+
+	vma->vm_ops->open(vma);
+
+	printk(KERN_DEBUG "%s: mapped dma addr 0x%08lx at 0x%08lx, size %ld\n",
+		__func__, (unsigned long)buf->dma_addr, vma->vm_start,
+		buf->size);
+
+	return 0;
 }
 
 /*********************************************/
-- 
1.7.9.5

