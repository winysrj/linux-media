Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:34781 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752425Ab0G0MXL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 27 Jul 2010 08:23:11 -0400
Received: by pwi5 with SMTP id 5so404545pwi.19
        for <linux-media@vger.kernel.org>; Tue, 27 Jul 2010 05:23:11 -0700 (PDT)
Subject: [PATCH]videobuf_dma_sg: a new implementation for mmap
From: "Figo.zhang" <figo1802@gmail.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: linux-media <linux-media@vger.kernel.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 27 Jul 2010 20:21:40 +0800
Message-ID: <1280233300.2628.8.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


a mmap issue for videobuf-dma-sg: it will alloc a new page for mmaping
when it encounter page fault at video_vm_ops->fault().

a new implementation for mmap, it translate the vmalloc to page at
video_vm_ops->fault().

Signed-off-by: Figo.zhang <figo1802@gmail.com>
---
drivers/media/video/videobuf-dma-sg.c |   38
++++++++++++++++++++++++++++----
 1 files changed, 33 insertions(+), 5 deletions(-)

diff --git a/drivers/media/video/videobuf-dma-sg.c
b/drivers/media/video/videobuf-dma-sg.c
index 8359e6b..c9a8817 100644
--- a/drivers/media/video/videobuf-dma-sg.c
+++ b/drivers/media/video/videobuf-dma-sg.c
@@ -397,16 +397,44 @@ static void videobuf_vm_close(struct
vm_area_struct *vma)
  */
 static int videobuf_vm_fault(struct vm_area_struct *vma, struct
vm_fault *vmf)
 {
-	struct page *page;
+	struct page *page = NULL;
+	struct videobuf_mapping *map = vma->vm_private_data;
+	struct videobuf_queue *q = map->q;
+	struct videobuf_dma_sg_memory *mem = NULL;
+
+	unsigned long offset;
+	unsigned long page_nr;
+	int first;
 
 	dprintk(3, "fault: fault @ %08lx [vma %08lx-%08lx]\n",
 		(unsigned long)vmf->virtual_address,
 		vma->vm_start, vma->vm_end);
 
-	page = alloc_page(GFP_USER | __GFP_DMA32);
-	if (!page)
-		return VM_FAULT_OOM;
-	clear_user_highpage(page, (unsigned long)vmf->virtual_address);
+	mutex_lock(&q->vb_lock);
+
+	offset = (unsigned long)vmf->virtual_address - vma->vm_start;
+	page_nr = offset >> PAGE_SHIFT;
+
+	for (first = 0; first < VIDEO_MAX_FRAME; first++) {
+			if (NULL == q->bufs[first])
+				continue;
+
+			MAGIC_CHECK(mem->magic, MAGIC_SG_MEM);
+
+			if (q->bufs[first]->map == map)
+				break;
+	}
+
+	mem = q->bufs[first]->priv;
+	if (!mem)
+		return VM_FAULT_SIGBUS;
+	if (mem->dma.vmalloc)
+		page = vmalloc_to_page(mem->dma.vmalloc+
+				(offset & (~PAGE_MASK)));
+	if (mem->dma.pages)
+		page = mem->dma.pages[page_nr];
+	mutex_unlock(&q->vb_lock);
+
 	vmf->page = page;
 
 	return 0;


