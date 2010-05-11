Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.irobotique.be ([92.243.18.41]:43075 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757191Ab0EKNfk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 11 May 2010 09:35:40 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: p.osciak@samsung.com, hverkuil@xs4all.nl
Subject: [PATCH 5/7] v4l: videobuf: Don't export videobuf_(vmalloc|pages)_to_sg
Date: Tue, 11 May 2010 15:36:32 +0200
Message-Id: <1273584994-14211-6-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1273584994-14211-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1273584994-14211-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Those functions are only called inside videobuf-dma-sg.c, make them
static.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/video/videobuf-dma-sg.c |   18 ++++++++++++++----
 include/media/videobuf-dma-sg.h       |   17 -----------------
 2 files changed, 14 insertions(+), 21 deletions(-)

diff --git a/drivers/media/video/videobuf-dma-sg.c b/drivers/media/video/videobuf-dma-sg.c
index 17b1f89..8924e51 100644
--- a/drivers/media/video/videobuf-dma-sg.c
+++ b/drivers/media/video/videobuf-dma-sg.c
@@ -57,7 +57,13 @@ MODULE_LICENSE("GPL");
 
 /* --------------------------------------------------------------------- */
 
-struct scatterlist *videobuf_vmalloc_to_sg(unsigned char *virt, int nr_pages)
+/*
+ * Return a scatterlist for some page-aligned vmalloc()'ed memory
+ * block (NULL on errors).  Memory for the scatterlist is allocated
+ * using kmalloc.  The caller must free the memory.
+ */
+static struct scatterlist *videobuf_vmalloc_to_sg(unsigned char *virt,
+						  int nr_pages)
 {
 	struct scatterlist *sglist;
 	struct page *pg;
@@ -81,10 +87,14 @@ err:
 	vfree(sglist);
 	return NULL;
 }
-EXPORT_SYMBOL_GPL(videobuf_vmalloc_to_sg);
 
-struct scatterlist *videobuf_pages_to_sg(struct page **pages, int nr_pages,
-					 int offset)
+/*
+ * Return a scatterlist for a an array of userpages (NULL on errors).
+ * Memory for the scatterlist is allocated using kmalloc.  The caller
+ * must free the memory.
+ */
+static struct scatterlist *videobuf_pages_to_sg(struct page **pages,
+						int nr_pages, int offset)
 {
 	struct scatterlist *sglist;
 	int i;
diff --git a/include/media/videobuf-dma-sg.h b/include/media/videobuf-dma-sg.h
index 8013010..913860e 100644
--- a/include/media/videobuf-dma-sg.h
+++ b/include/media/videobuf-dma-sg.h
@@ -25,23 +25,6 @@
 /* --------------------------------------------------------------------- */
 
 /*
- * Return a scatterlist for some page-aligned vmalloc()'ed memory
- * block (NULL on errors).  Memory for the scatterlist is allocated
- * using kmalloc.  The caller must free the memory.
- */
-struct scatterlist *videobuf_vmalloc_to_sg(unsigned char *virt, int nr_pages);
-
-/*
- * Return a scatterlist for a an array of userpages (NULL on errors).
- * Memory for the scatterlist is allocated using kmalloc.  The caller
- * must free the memory.
- */
-struct scatterlist *videobuf_pages_to_sg(struct page **pages, int nr_pages,
-					 int offset);
-
-/* --------------------------------------------------------------------- */
-
-/*
  * A small set of helper functions to manage buffers (both userland
  * and kernel) for DMA.
  *
-- 
1.6.4.4

