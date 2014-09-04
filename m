Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-by2lp0244.outbound.protection.outlook.com ([207.46.163.244]:7514
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750902AbaIDJiC (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 4 Sep 2014 05:38:02 -0400
From: Fancy Fang <chen.fang@freescale.com>
To: <m.chehab@samsung.com>, <hverkuil@xs4all.nl>,
	<viro@ZenIV.linux.org.uk>
CC: <linux-media@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	Fancy Fang <chen.fang@freescale.com>
Subject: [PATCH] [media] videobuf-dma-contig: replace vm_iomap_memory() with remap_pfn_range().
Date: Thu, 4 Sep 2014 16:34:39 +0800
Message-ID: <1409819679-31497-1-git-send-email-chen.fang@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When user requests V4L2_MEMORY_MMAP type buffers, the videobuf-core
will assign the corresponding offset to the 'boff' field of the
videobuf_buffer for each requested buffer sequentially. Later, user
may call mmap() to map one or all of the buffers with the 'offset'
parameter which is equal to its 'boff' value. Obviously, the 'offset'
value is only used to find the matched buffer instead of to be the
real offset from the buffer's physical start address as used by
vm_iomap_memory(). So, in some case that if the offset is not zero,
vm_iomap_memory() will fail.

Signed-off-by: Fancy Fang <chen.fang@freescale.com>
---
 drivers/media/v4l2-core/videobuf-dma-contig.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/media/v4l2-core/videobuf-dma-contig.c b/drivers/media/v4l2-core/videobuf-dma-contig.c
index bf80f0f..8bd9889 100644
--- a/drivers/media/v4l2-core/videobuf-dma-contig.c
+++ b/drivers/media/v4l2-core/videobuf-dma-contig.c
@@ -305,7 +305,9 @@ static int __videobuf_mmap_mapper(struct videobuf_queue *q,
 	/* Try to remap memory */
 	size = vma->vm_end - vma->vm_start;
 	vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
-	retval = vm_iomap_memory(vma, mem->dma_handle, size);
+	retval = remap_pfn_range(vma, vma->vm_start,
+				 mem->dma_handle >> PAGE_SHIFT,
+				 size, vma->vm_page_prot);
 	if (retval) {
 		dev_err(q->dev, "mmap: remap failed with error %d. ",
 			retval);
-- 
1.9.1

