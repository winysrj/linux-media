Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:56704 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754336Ab0CWO7F (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Mar 2010 10:59:05 -0400
Received: from lyakh (helo=localhost)
	by axis700.grange with local-esmtp (Exim 4.63)
	(envelope-from <g.liakhovetski@gmx.de>)
	id 1Nu5ZZ-00024n-Vc
	for linux-media@vger.kernel.org; Tue, 23 Mar 2010 15:59:13 +0100
Date: Tue, 23 Mar 2010 15:59:13 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH] videobuf-dma-contig.c: simplify pointer dereference
Message-ID: <Pine.LNX.4.64.1003231558300.7689@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 drivers/media/video/videobuf-dma-contig.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/media/video/videobuf-dma-contig.c b/drivers/media/video/videobuf-dma-contig.c
index 22c0109..8e45a49 100644
--- a/drivers/media/video/videobuf-dma-contig.c
+++ b/drivers/media/video/videobuf-dma-contig.c
@@ -54,14 +54,14 @@ static void videobuf_vm_close(struct vm_area_struct *vma)
 	struct videobuf_queue *q = map->q;
 	int i;
 
-	dev_dbg(map->q->dev, "vm_close %p [count=%u,vma=%08lx-%08lx]\n",
+	dev_dbg(q->dev, "vm_close %p [count=%u,vma=%08lx-%08lx]\n",
 		map, map->count, vma->vm_start, vma->vm_end);
 
 	map->count--;
 	if (0 == map->count) {
 		struct videobuf_dma_contig_memory *mem;
 
-		dev_dbg(map->q->dev, "munmap %p q=%p\n", map, q);
+		dev_dbg(q->dev, "munmap %p q=%p\n", map, q);
 		mutex_lock(&q->vb_lock);
 
 		/* We need first to cancel streams, before unmapping */
@@ -88,7 +88,7 @@ static void videobuf_vm_close(struct vm_area_struct *vma)
 				/* vfree is not atomic - can't be
 				   called with IRQ's disabled
 				 */
-				dev_dbg(map->q->dev, "buf[%d] freeing %p\n",
+				dev_dbg(q->dev, "buf[%d] freeing %p\n",
 					i, mem->vaddr);
 
 				dma_free_coherent(q->dev, mem->size,
-- 
1.6.2.4

