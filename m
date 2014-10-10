Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bn1bon0147.outbound.protection.outlook.com ([157.56.111.147]:19584
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751128AbaJJD0R (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 9 Oct 2014 23:26:17 -0400
From: Fancy Fang <chen.fang@freescale.com>
To: <m.szyprowski@samsung.com>, <hverkuil@xs4all.nl>,
	<m.chehab@samsung.com>
CC: <shawn.guo@freescale.com>, <linux-media@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
Subject: [PATCH v2] [media] videobuf-dma-contig: set vm_pgoff to be zero to pass the sanity check in vm_iomap_memory().
Date: Fri, 10 Oct 2014 10:21:22 +0800
Message-ID: <1412907682-26086-1-git-send-email-chen.fang@freescale.com>
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
Reviewed-by: Marek Szyprowski <m.szyprowski@samsung.com>
Reviewed-by: Hans Verkuil <hverkuil@xs4all.nl>
---
 drivers/media/v4l2-core/videobuf-dma-contig.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/media/v4l2-core/videobuf-dma-contig.c b/drivers/media/v4l2-core/videobuf-dma-contig.c
index bf80f0f..e02353e 100644
--- a/drivers/media/v4l2-core/videobuf-dma-contig.c
+++ b/drivers/media/v4l2-core/videobuf-dma-contig.c
@@ -305,6 +305,15 @@ static int __videobuf_mmap_mapper(struct videobuf_queue *q,
 	/* Try to remap memory */
 	size = vma->vm_end - vma->vm_start;
 	vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
+
+	/* the "vm_pgoff" is just used in v4l2 to find the
+	 * corresponding buffer data structure which is allocated
+	 * earlier and it does not mean the offset from the physical
+	 * buffer start address as usual. So set it to 0 to pass
+	 * the sanity check in vm_iomap_memory().
+	 */
+	vma->vm_pgoff = 0;
+
 	retval = vm_iomap_memory(vma, mem->dma_handle, size);
 	if (retval) {
 		dev_err(q->dev, "mmap: remap failed with error %d. ",
-- 
1.9.1

