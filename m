Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:52921 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751850AbZENHFv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 14 May 2009 03:05:51 -0400
From: David Cohen <david.cohen@nokia.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org,
	"Cohen David.A (Nokia-D/Helsinki)" <david.cohen@nokia.com>
Subject: [PATCH] v4l2: change kmalloc to vmalloc for sglist allocation in videobuf_dma_map/unmap
Date: Thu, 14 May 2009 10:04:48 +0300
Message-Id: <1242284688-8179-1-git-send-email-david.cohen@nokia.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Cohen David.A (Nokia-D/Helsinki) <david.cohen@nokia.com>

Change kmalloc()/kfree() to vmalloc()/vfree() for sglist allocation
during videobuf_dma_map() and videobuf_dma_unmap()

High resolution sensors might require too many contiguous pages
to be allocated for sglist by kmalloc() during videobuf_dma_map()
(i.e. 256Kib for 8MP sensor).
In such situations, kmalloc() could face some problem to find the
required free memory. vmalloc() is a safer solution instead, as the
allocated memory does not need to be contiguous.

Signed-off-by: David Cohen <david.cohen@nokia.com>
---
 drivers/media/video/videobuf-dma-sg.c |   17 +++++++++--------
 1 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/media/video/videobuf-dma-sg.c b/drivers/media/video/videobuf-dma-sg.c
index da1790e..c9a5d7e 100644
--- a/drivers/media/video/videobuf-dma-sg.c
+++ b/drivers/media/video/videobuf-dma-sg.c
@@ -58,9 +58,10 @@ videobuf_vmalloc_to_sg(unsigned char *virt, int nr_pages)
 	struct page *pg;
 	int i;
 
-	sglist = kcalloc(nr_pages, sizeof(struct scatterlist), GFP_KERNEL);
+	sglist = vmalloc(nr_pages * sizeof(*sglist));
 	if (NULL == sglist)
 		return NULL;
+	memset(sglist, 0, nr_pages * sizeof(*sglist));
 	sg_init_table(sglist, nr_pages);
 	for (i = 0; i < nr_pages; i++, virt += PAGE_SIZE) {
 		pg = vmalloc_to_page(virt);
@@ -72,7 +73,7 @@ videobuf_vmalloc_to_sg(unsigned char *virt, int nr_pages)
 	return sglist;
 
  err:
-	kfree(sglist);
+	vfree(sglist);
 	return NULL;
 }
 
@@ -84,7 +85,7 @@ videobuf_pages_to_sg(struct page **pages, int nr_pages, int offset)
 
 	if (NULL == pages[0])
 		return NULL;
-	sglist = kmalloc(nr_pages * sizeof(*sglist), GFP_KERNEL);
+	sglist = vmalloc(nr_pages * sizeof(*sglist));
 	if (NULL == sglist)
 		return NULL;
 	sg_init_table(sglist, nr_pages);
@@ -104,12 +105,12 @@ videobuf_pages_to_sg(struct page **pages, int nr_pages, int offset)
 
  nopage:
 	dprintk(2,"sgl: oops - no page\n");
-	kfree(sglist);
+	vfree(sglist);
 	return NULL;
 
  highmem:
 	dprintk(2,"sgl: oops - highmem page\n");
-	kfree(sglist);
+	vfree(sglist);
 	return NULL;
 }
 
@@ -230,7 +231,7 @@ int videobuf_dma_map(struct videobuf_queue* q, struct videobuf_dmabuf *dma)
 						(dma->vmalloc,dma->nr_pages);
 	}
 	if (dma->bus_addr) {
-		dma->sglist = kmalloc(sizeof(struct scatterlist), GFP_KERNEL);
+		dma->sglist = vmalloc(sizeof(*dma->sglist));
 		if (NULL != dma->sglist) {
 			dma->sglen  = 1;
 			sg_dma_address(&dma->sglist[0]) = dma->bus_addr & PAGE_MASK;
@@ -248,7 +249,7 @@ int videobuf_dma_map(struct videobuf_queue* q, struct videobuf_dmabuf *dma)
 		if (0 == dma->sglen) {
 			printk(KERN_WARNING
 			       "%s: videobuf_map_sg failed\n",__func__);
-			kfree(dma->sglist);
+			vfree(dma->sglist);
 			dma->sglist = NULL;
 			dma->sglen = 0;
 			return -EIO;
@@ -274,7 +275,7 @@ int videobuf_dma_unmap(struct videobuf_queue* q,struct videobuf_dmabuf *dma)
 
 	dma_unmap_sg(q->dev, dma->sglist, dma->nr_pages, dma->direction);
 
-	kfree(dma->sglist);
+	vfree(dma->sglist);
 	dma->sglist = NULL;
 	dma->sglen = 0;
 	return 0;
-- 
1.6.1

