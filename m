Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:52434 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753991AbaDCWiK (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 3 Apr 2014 18:38:10 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Sakari Ailus <sakari.ailus@iki.fi>
Subject: [PATCH 19/25] omap3isp: queue: Don't build scatterlist for kernel buffer
Date: Fri,  4 Apr 2014 00:39:49 +0200
Message-Id: <1396564795-27192-20-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1396564795-27192-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1396564795-27192-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The scatterlist is not needed for those buffers, don't build it.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/platform/omap3isp/ispqueue.c | 24 +++---------------------
 drivers/media/platform/omap3isp/ispqueue.h |  8 ++++----
 2 files changed, 7 insertions(+), 25 deletions(-)

diff --git a/drivers/media/platform/omap3isp/ispqueue.c b/drivers/media/platform/omap3isp/ispqueue.c
index 9c90fb0..515ed94 100644
--- a/drivers/media/platform/omap3isp/ispqueue.c
+++ b/drivers/media/platform/omap3isp/ispqueue.c
@@ -147,21 +147,6 @@ out:
 }
 
 /*
- * isp_video_buffer_prepare_kernel - Build scatter list for a kernel-allocated
- * buffer
- *
- * Retrieve the sgtable using the DMA API.
- */
-static int isp_video_buffer_prepare_kernel(struct isp_video_buffer *buf)
-{
-	struct isp_video_fh *vfh = isp_video_queue_to_isp_video_fh(buf->queue);
-	struct isp_video *video = vfh->video;
-
-	return dma_get_sgtable(video->isp->dev, &buf->sgt, buf->vaddr,
-			       buf->dma, PAGE_ALIGN(buf->vbuf.length));
-}
-
-/*
  * isp_video_buffer_cleanup - Release pages for a userspace VMA.
  *
  * Release pages locked by a call isp_video_buffer_prepare_user and free the
@@ -181,10 +166,9 @@ static void isp_video_buffer_cleanup(struct isp_video_buffer *buf)
 			  ? DMA_FROM_DEVICE : DMA_TO_DEVICE;
 		dma_unmap_sg_attrs(buf->queue->dev, buf->sgt.sgl,
 				   buf->sgt.orig_nents, direction, &attrs);
+		sg_free_table(&buf->sgt);
 	}
 
-	sg_free_table(&buf->sgt);
-
 	if (buf->pages != NULL) {
 		isp_video_buffer_lock_vma(buf, 0);
 
@@ -400,7 +384,7 @@ done:
  *
  * - validating VMAs (userspace buffers only)
  * - locking pages and VMAs into memory (userspace buffers only)
- * - building page and scatter-gather lists
+ * - building page and scatter-gather lists (userspace buffers only)
  * - mapping buffers for DMA operation
  * - performing driver-specific preparation
  *
@@ -416,9 +400,7 @@ static int isp_video_buffer_prepare(struct isp_video_buffer *buf)
 
 	switch (buf->vbuf.memory) {
 	case V4L2_MEMORY_MMAP:
-		ret = isp_video_buffer_prepare_kernel(buf);
-		if (ret < 0)
-			goto done;
+		ret = 0;
 		break;
 
 	case V4L2_MEMORY_USERPTR:
diff --git a/drivers/media/platform/omap3isp/ispqueue.h b/drivers/media/platform/omap3isp/ispqueue.h
index ae4acb9..27189bb 100644
--- a/drivers/media/platform/omap3isp/ispqueue.h
+++ b/drivers/media/platform/omap3isp/ispqueue.h
@@ -70,8 +70,8 @@ enum isp_video_buffer_state {
  * @vaddr: Memory virtual address (for kernel buffers)
  * @vm_flags: Buffer VMA flags (for userspace buffers)
  * @npages: Number of pages (for userspace buffers)
+ * @sgt: Scatter gather table (for userspace buffers)
  * @pages: Pages table (for userspace non-VM_PFNMAP buffers)
- * @sgt: Scatter gather table
  * @vbuf: V4L2 buffer
  * @irqlist: List head for insertion into IRQ queue
  * @state: Current buffer state
@@ -90,11 +90,11 @@ struct isp_video_buffer {
 	/* For userspace buffers. */
 	vm_flags_t vm_flags;
 	unsigned int npages;
-	struct page **pages;
-
-	/* For all buffers. */
 	struct sg_table sgt;
 
+	/* For non-VM_PFNMAP userspace buffers. */
+	struct page **pages;
+
 	/* Touched by the interrupt handler. */
 	struct v4l2_buffer vbuf;
 	struct list_head irqlist;
-- 
1.8.3.2

