Return-path: <mchehab@gaivota>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:25805 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753755Ab0IFGx5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 6 Sep 2010 02:53:57 -0400
Received: from eu_spt2 (mailout1.w1.samsung.com [210.118.77.11])
 by mailout1.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0L8B00AQYCHTID@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 06 Sep 2010 07:53:53 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0L8B009H9CHS9N@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 06 Sep 2010 07:53:53 +0100 (BST)
Date: Mon, 06 Sep 2010 08:53:48 +0200
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: [PATCH 6/8] v4l: videobuf: remove unused is_userptr variable
In-reply-to: <1283756030-28634-1-git-send-email-m.szyprowski@samsung.com>
To: linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, kyungmin.park@samsung.com,
	p.osciak@samsung.com, s.nawrocki@samsung.com
Message-id: <1283756030-28634-7-git-send-email-m.szyprowski@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <1283756030-28634-1-git-send-email-m.szyprowski@samsung.com>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

From: Pawel Osciak <p.osciak@samsung.com>

Remove unused is_userptr variable from videobuf-dma-contig.

Signed-off-by: Pawel Osciak <p.osciak@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
---
 drivers/media/video/videobuf-dma-contig.c |    6 ------
 1 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/drivers/media/video/videobuf-dma-contig.c b/drivers/media/video/videobuf-dma-contig.c
index 6ff9e4b..4b3f0e1 100644
--- a/drivers/media/video/videobuf-dma-contig.c
+++ b/drivers/media/video/videobuf-dma-contig.c
@@ -28,7 +28,6 @@ struct videobuf_dma_contig_memory {
 	void *vaddr;
 	dma_addr_t dma_handle;
 	unsigned long size;
-	int is_userptr;
 };
 
 #define MAGIC_DC_MEM 0x0733ac61
@@ -120,7 +119,6 @@ static const struct vm_operations_struct videobuf_vm_ops = {
  */
 static void videobuf_dma_contig_user_put(struct videobuf_dma_contig_memory *mem)
 {
-	mem->is_userptr = 0;
 	mem->dma_handle = 0;
 	mem->size = 0;
 }
@@ -147,7 +145,6 @@ static int videobuf_dma_contig_user_get(struct videobuf_dma_contig_memory *mem,
 
 	offset = vb->baddr & ~PAGE_MASK;
 	mem->size = PAGE_ALIGN(vb->size + offset);
-	mem->is_userptr = 0;
 	ret = -EINVAL;
 
 	down_read(&mm->mmap_sem);
@@ -181,9 +178,6 @@ static int videobuf_dma_contig_user_get(struct videobuf_dma_contig_memory *mem,
 		pages_done++;
 	}
 
-	if (!ret)
-		mem->is_userptr = 1;
-
  out_up:
 	up_read(&current->mm->mmap_sem);
 
-- 
1.7.2.2

