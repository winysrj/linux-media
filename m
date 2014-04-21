Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:38683 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752188AbaDUM3R (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Apr 2014 08:29:17 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Sakari Ailus <sakari.ailus@iki.fi>
Subject: [PATCH v2 16/26] omap3isp: queue: Map PFNMAP buffers to device
Date: Mon, 21 Apr 2014 14:29:02 +0200
Message-Id: <1398083352-8451-17-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1398083352-8451-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1398083352-8451-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Userspace PFNMAP buffers need to be mapped to the device like the
userspace non-PFNMAP buffers in order for the DMA mapping implementation
to create IOMMU mappings when we'll switch to the IOMMU-aware DMA
mapping backend.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/platform/omap3isp/ispqueue.c | 37 +++++++++++++++++-------------
 drivers/media/platform/omap3isp/ispqueue.h |  4 ++--
 2 files changed, 23 insertions(+), 18 deletions(-)

diff --git a/drivers/media/platform/omap3isp/ispqueue.c b/drivers/media/platform/omap3isp/ispqueue.c
index 479d348..4a271c7 100644
--- a/drivers/media/platform/omap3isp/ispqueue.c
+++ b/drivers/media/platform/omap3isp/ispqueue.c
@@ -173,6 +173,7 @@ static void isp_video_buffer_cleanup(struct isp_video_buffer *buf)
 	struct isp_video_fh *vfh = isp_video_queue_to_isp_video_fh(buf->queue);
 	struct isp_video *video = vfh->video;
 	enum dma_data_direction direction;
+	DEFINE_DMA_ATTRS(attrs);
 	unsigned int i;
 
 	if (buf->dma) {
@@ -181,11 +182,14 @@ static void isp_video_buffer_cleanup(struct isp_video_buffer *buf)
 		buf->dma = 0;
 	}
 
-	if (!(buf->vm_flags & VM_PFNMAP)) {
+	if (buf->vbuf.memory == V4L2_MEMORY_USERPTR) {
+		if (buf->skip_cache)
+			dma_set_attr(DMA_ATTR_SKIP_CPU_SYNC, &attrs);
+
 		direction = buf->vbuf.type == V4L2_BUF_TYPE_VIDEO_CAPTURE
 			  ? DMA_FROM_DEVICE : DMA_TO_DEVICE;
-		dma_unmap_sg(buf->queue->dev, buf->sgt.sgl, buf->sgt.orig_nents,
-			     direction);
+		dma_unmap_sg_attrs(buf->queue->dev, buf->sgt.sgl,
+				   buf->sgt.orig_nents, direction, &attrs);
 	}
 
 	sg_free_table(&buf->sgt);
@@ -345,10 +349,6 @@ unlock:
 
 	for (sg = buf->sgt.sgl, i = 0; i < buf->npages; ++i, ++pfn) {
 		sg_set_page(sg, pfn_to_page(pfn), PAGE_SIZE - offset, offset);
-		/* PFNMAP buffers will not get DMA-mapped, set the DMA address
-		 * manually.
-		 */
-		sg_dma_address(sg) = (pfn << PAGE_SHIFT) + offset;
 		sg = sg_next(sg);
 		offset = 0;
 	}
@@ -434,12 +434,15 @@ static int isp_video_buffer_prepare(struct isp_video_buffer *buf)
 	struct isp_video_fh *vfh = isp_video_queue_to_isp_video_fh(buf->queue);
 	struct isp_video *video = vfh->video;
 	enum dma_data_direction direction;
+	DEFINE_DMA_ATTRS(attrs);
 	unsigned long addr;
 	int ret;
 
 	switch (buf->vbuf.memory) {
 	case V4L2_MEMORY_MMAP:
 		ret = isp_video_buffer_prepare_kernel(buf);
+		if (ret < 0)
+			goto done;
 		break;
 
 	case V4L2_MEMORY_USERPTR:
@@ -451,24 +454,26 @@ static int isp_video_buffer_prepare(struct isp_video_buffer *buf)
 			ret = isp_video_buffer_prepare_pfnmap(buf);
 		else
 			ret = isp_video_buffer_prepare_user(buf);
-		break;
 
-	default:
-		return -EINVAL;
-	}
+		if (ret < 0)
+			goto done;
 
-	if (ret < 0)
-		goto done;
+		if (buf->skip_cache)
+			dma_set_attr(DMA_ATTR_SKIP_CPU_SYNC, &attrs);
 
-	if (!(buf->vm_flags & VM_PFNMAP)) {
 		direction = buf->vbuf.type == V4L2_BUF_TYPE_VIDEO_CAPTURE
 			  ? DMA_FROM_DEVICE : DMA_TO_DEVICE;
-		ret = dma_map_sg(buf->queue->dev, buf->sgt.sgl,
-				 buf->sgt.orig_nents, direction);
+		ret = dma_map_sg_attrs(buf->queue->dev, buf->sgt.sgl,
+				       buf->sgt.orig_nents, direction, &attrs);
 		if (ret <= 0) {
 			ret = -EFAULT;
 			goto done;
 		}
+
+		break;
+
+	default:
+		return -EINVAL;
 	}
 
 	addr = omap_iommu_vmap(video->isp->domain, video->isp->dev, 0,
diff --git a/drivers/media/platform/omap3isp/ispqueue.h b/drivers/media/platform/omap3isp/ispqueue.h
index e03af74..d580f58 100644
--- a/drivers/media/platform/omap3isp/ispqueue.h
+++ b/drivers/media/platform/omap3isp/ispqueue.h
@@ -72,7 +72,7 @@ enum isp_video_buffer_state {
  * @vm_flags: Buffer VMA flags (for userspace buffers)
  * @npages: Number of pages (for userspace buffers)
  * @pages: Pages table (for userspace non-VM_PFNMAP buffers)
- * @sgt: Scatter gather table (for non-VM_PFNMAP buffers)
+ * @sgt: Scatter gather table
  * @vbuf: V4L2 buffer
  * @irqlist: List head for insertion into IRQ queue
  * @state: Current buffer state
@@ -94,7 +94,7 @@ struct isp_video_buffer {
 	unsigned int npages;
 	struct page **pages;
 
-	/* For all buffers except VM_PFNMAP. */
+	/* For all buffers. */
 	struct sg_table sgt;
 
 	/* Touched by the interrupt handler. */
-- 
1.8.3.2

