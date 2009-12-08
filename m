Return-path: <linux-media-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:51933 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756297AbZLHVgy (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 8 Dec 2009 16:36:54 -0500
From: m-karicheri2@ti.com
To: linux-media@vger.kernel.org, magnus.damm@gmail.com
Cc: Muralidharan Karicheri <m-karicheri2@ti.com>
Subject: [PATCH - v1] V4L-Fix videobuf_dma_contig_user_get() for non-aligned offsets
Date: Tue,  8 Dec 2009 16:36:57 -0500
Message-Id: <1260308217-22871-1-git-send-email-m-karicheri2@ti.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Muralidharan Karicheri <m-karicheri2@ti.com>

If a USERPTR address that is not aligned to page boundary is passed to the
videobuf_dma_contig_user_get() function, it saves a page aligned address to
the dma_handle. This is not correct. This issue is observed when using USERPTR
IO machism for buffer exchange.

Updates from last version:-

Adding offset for size calculation as per comment from Magnus Damm. This
ensures the last page is also included for checking if memory is
contiguous.

Signed-off-by: Muralidharan Karicheri <m-karicheri2@ti.com>
---
 drivers/media/video/videobuf-dma-contig.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/media/video/videobuf-dma-contig.c b/drivers/media/video/videobuf-dma-contig.c
index d25f284..22c0109 100644
--- a/drivers/media/video/videobuf-dma-contig.c
+++ b/drivers/media/video/videobuf-dma-contig.c
@@ -141,9 +141,11 @@ static int videobuf_dma_contig_user_get(struct videobuf_dma_contig_memory *mem,
 	struct vm_area_struct *vma;
 	unsigned long prev_pfn, this_pfn;
 	unsigned long pages_done, user_address;
+	unsigned int offset;
 	int ret;
 
-	mem->size = PAGE_ALIGN(vb->size);
+	offset = vb->baddr & ~PAGE_MASK;
+	mem->size = PAGE_ALIGN(vb->size + offset);
 	mem->is_userptr = 0;
 	ret = -EINVAL;
 
@@ -166,7 +168,7 @@ static int videobuf_dma_contig_user_get(struct videobuf_dma_contig_memory *mem,
 			break;
 
 		if (pages_done == 0)
-			mem->dma_handle = this_pfn << PAGE_SHIFT;
+			mem->dma_handle = (this_pfn << PAGE_SHIFT) + offset;
 		else if (this_pfn != (prev_pfn + 1))
 			ret = -EFAULT;
 
-- 
1.6.0.4

