Return-path: <linux-media-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.233]:54880 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753287AbZD1IsZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 28 Apr 2009 04:48:25 -0400
Received: by rv-out-0506.google.com with SMTP id f9so315072rvb.1
        for <linux-media@vger.kernel.org>; Tue, 28 Apr 2009 01:48:24 -0700 (PDT)
From: Magnus Damm <magnus.damm@gmail.com>
To: linux-media@vger.kernel.org
Cc: Magnus Damm <magnus.damm@gmail.com>, paulius.zaleckas@teltonika.lt,
	g.liakhovetski@gmx.de, matthieu.castet@parrot.com,
	lethal@linux-sh.org
Date: Tue, 28 Apr 2009 17:45:39 +0900
Message-Id: <20090428084539.16911.79893.sendpatchset@rx1.opensource.se>
Subject: [PATCH] videobuf-dma-contig: remove sync operation
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Magnus Damm <damm@igel.co.jp>

Remove the videobuf-dma-contig sync operation. Sync is only needed
for noncoherent buffers, and since videobuf-dma-contig is built on
coherent memory allocators the memory is by definition always in sync.

Reported-by: Matthieu CASTET <matthieu.castet@parrot.com>
Signed-off-by: Magnus Damm <damm@igel.co.jp>
---

 Thanks to Mattieu, Paul and Paulius for all the help!
 Tested on SH7722 Migo-R with CEU and ov7725.

 drivers/media/video/videobuf-dma-contig.c |   14 --------------
 1 file changed, 14 deletions(-)

--- 0001/drivers/media/video/videobuf-dma-contig.c
+++ work/drivers/media/video/videobuf-dma-contig.c	2009-04-28 13:09:37.000000000 +0900
@@ -182,19 +182,6 @@ static int __videobuf_iolock(struct vide
 	return 0;
 }
 
-static int __videobuf_sync(struct videobuf_queue *q,
-			   struct videobuf_buffer *buf)
-{
-	struct videobuf_dma_contig_memory *mem = buf->priv;
-
-	BUG_ON(!mem);
-	MAGIC_CHECK(mem->magic, MAGIC_DC_MEM);
-
-	dma_sync_single_for_cpu(q->dev, mem->dma_handle, mem->size,
-				DMA_FROM_DEVICE);
-	return 0;
-}
-
 static int __videobuf_mmap_free(struct videobuf_queue *q)
 {
 	unsigned int i;
@@ -356,7 +343,6 @@ static struct videobuf_qtype_ops qops = 
 
 	.alloc        = __videobuf_alloc,
 	.iolock       = __videobuf_iolock,
-	.sync         = __videobuf_sync,
 	.mmap_free    = __videobuf_mmap_free,
 	.mmap_mapper  = __videobuf_mmap_mapper,
 	.video_copy_to_user = __videobuf_copy_to_user,
