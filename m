Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:38683 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752128AbaDUM3O (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Apr 2014 08:29:14 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Sakari Ailus <sakari.ailus@iki.fi>
Subject: [PATCH v2 10/26] omap3isp: queue: Move IOMMU handling code to the queue
Date: Mon, 21 Apr 2014 14:28:56 +0200
Message-Id: <1398083352-8451-11-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1398083352-8451-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1398083352-8451-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As a preparation for the switch from the OMAP IOMMU API to the DMA API
move all IOMMU handling code from the video node implementation to the
buffers queue implementation.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/platform/omap3isp/ispqueue.c | 78 +++++++++++++++++++++++++++++-
 drivers/media/platform/omap3isp/ispqueue.h |  6 +--
 drivers/media/platform/omap3isp/ispvideo.c | 77 +----------------------------
 3 files changed, 78 insertions(+), 83 deletions(-)

diff --git a/drivers/media/platform/omap3isp/ispqueue.c b/drivers/media/platform/omap3isp/ispqueue.c
index a5e6585..8623c05 100644
--- a/drivers/media/platform/omap3isp/ispqueue.c
+++ b/drivers/media/platform/omap3isp/ispqueue.c
@@ -26,6 +26,7 @@
 #include <asm/cacheflush.h>
 #include <linux/dma-mapping.h>
 #include <linux/mm.h>
+#include <linux/omap-iommu.h>
 #include <linux/pagemap.h>
 #include <linux/poll.h>
 #include <linux/scatterlist.h>
@@ -33,7 +34,58 @@
 #include <linux/slab.h>
 #include <linux/vmalloc.h>
 
+#include "isp.h"
 #include "ispqueue.h"
+#include "ispvideo.h"
+
+/* -----------------------------------------------------------------------------
+ * IOMMU management
+ */
+
+#define IOMMU_FLAG	(IOVMF_ENDIAN_LITTLE | IOVMF_ELSZ_8)
+
+/*
+ * ispmmu_vmap - Wrapper for Virtual memory mapping of a scatter gather list
+ * @dev: Device pointer specific to the OMAP3 ISP.
+ * @sglist: Pointer to source Scatter gather list to allocate.
+ * @sglen: Number of elements of the scatter-gatter list.
+ *
+ * Returns a resulting mapped device address by the ISP MMU, or -ENOMEM if
+ * we ran out of memory.
+ */
+static dma_addr_t
+ispmmu_vmap(struct isp_device *isp, const struct scatterlist *sglist, int sglen)
+{
+	struct sg_table *sgt;
+	u32 da;
+
+	sgt = kmalloc(sizeof(*sgt), GFP_KERNEL);
+	if (sgt == NULL)
+		return -ENOMEM;
+
+	sgt->sgl = (struct scatterlist *)sglist;
+	sgt->nents = sglen;
+	sgt->orig_nents = sglen;
+
+	da = omap_iommu_vmap(isp->domain, isp->dev, 0, sgt, IOMMU_FLAG);
+	if (IS_ERR_VALUE(da))
+		kfree(sgt);
+
+	return da;
+}
+
+/*
+ * ispmmu_vunmap - Unmap a device address from the ISP MMU
+ * @dev: Device pointer specific to the OMAP3 ISP.
+ * @da: Device address generated from a ispmmu_vmap call.
+ */
+static void ispmmu_vunmap(struct isp_device *isp, dma_addr_t da)
+{
+	struct sg_table *sgt;
+
+	sgt = omap_iommu_vunmap(isp->domain, isp->dev, (u32)da);
+	kfree(sgt);
+}
 
 /* -----------------------------------------------------------------------------
  * Video buffers management
@@ -260,11 +312,15 @@ static int isp_video_buffer_sglist_pfnmap(struct isp_video_buffer *buf)
  */
 static void isp_video_buffer_cleanup(struct isp_video_buffer *buf)
 {
+	struct isp_video_fh *vfh = isp_video_queue_to_isp_video_fh(buf->queue);
+	struct isp_video *video = vfh->video;
 	enum dma_data_direction direction;
 	unsigned int i;
 
-	if (buf->queue->ops->buffer_cleanup)
-		buf->queue->ops->buffer_cleanup(buf);
+	if (buf->dma) {
+		ispmmu_vunmap(video->isp, buf->dma);
+		buf->dma = 0;
+	}
 
 	if (!(buf->vm_flags & VM_PFNMAP)) {
 		direction = buf->vbuf.type == V4L2_BUF_TYPE_VIDEO_CAPTURE
@@ -479,7 +535,10 @@ done:
  */
 static int isp_video_buffer_prepare(struct isp_video_buffer *buf)
 {
+	struct isp_video_fh *vfh = isp_video_queue_to_isp_video_fh(buf->queue);
+	struct isp_video *video = vfh->video;
 	enum dma_data_direction direction;
+	unsigned long addr;
 	int ret;
 
 	switch (buf->vbuf.memory) {
@@ -525,6 +584,21 @@ static int isp_video_buffer_prepare(struct isp_video_buffer *buf)
 		}
 	}
 
+	addr = ispmmu_vmap(video->isp, buf->sglist, buf->sglen);
+	if (IS_ERR_VALUE(addr)) {
+		ret = -EIO;
+		goto done;
+	}
+
+	buf->dma = addr;
+
+	if (!IS_ALIGNED(addr, 32)) {
+		dev_dbg(video->isp->dev,
+			"Buffer address must be aligned to 32 bytes boundary.\n");
+		ret = -EINVAL;
+		goto done;
+	}
+
 	if (buf->queue->ops->buffer_prepare)
 		ret = buf->queue->ops->buffer_prepare(buf);
 
diff --git a/drivers/media/platform/omap3isp/ispqueue.h b/drivers/media/platform/omap3isp/ispqueue.h
index 3e048ad..0899a11 100644
--- a/drivers/media/platform/omap3isp/ispqueue.h
+++ b/drivers/media/platform/omap3isp/ispqueue.h
@@ -106,6 +106,7 @@ struct isp_video_buffer {
 	struct list_head irqlist;
 	enum isp_video_buffer_state state;
 	wait_queue_head_t wait;
+	dma_addr_t dma;
 };
 
 #define to_isp_video_buffer(vb)	container_of(vb, struct isp_video_buffer, vb)
@@ -121,17 +122,12 @@ struct isp_video_buffer {
  *	mapping the buffer memory in an IOMMU). This operation is optional.
  * @buffer_queue: Called when a buffer is being added to the queue with the
  *	queue irqlock spinlock held.
- * @buffer_cleanup: Called before freeing buffers, or before changing the
- *	userspace memory address for a USERPTR buffer, with the queue lock held.
- *	Drivers must perform cleanup operations required to undo the
- *	buffer_prepare call. This operation is optional.
  */
 struct isp_video_queue_operations {
 	void (*queue_prepare)(struct isp_video_queue *queue,
 			      unsigned int *nbuffers, unsigned int *size);
 	int  (*buffer_prepare)(struct isp_video_buffer *buf);
 	void (*buffer_queue)(struct isp_video_buffer *buf);
-	void (*buffer_cleanup)(struct isp_video_buffer *buf);
 };
 
 /**
diff --git a/drivers/media/platform/omap3isp/ispvideo.c b/drivers/media/platform/omap3isp/ispvideo.c
index e0f594f3..a7ef081 100644
--- a/drivers/media/platform/omap3isp/ispvideo.c
+++ b/drivers/media/platform/omap3isp/ispvideo.c
@@ -27,7 +27,6 @@
 #include <linux/clk.h>
 #include <linux/mm.h>
 #include <linux/module.h>
-#include <linux/omap-iommu.h>
 #include <linux/pagemap.h>
 #include <linux/scatterlist.h>
 #include <linux/sched.h>
@@ -326,55 +325,6 @@ isp_video_check_format(struct isp_video *video, struct isp_video_fh *vfh)
 }
 
 /* -----------------------------------------------------------------------------
- * IOMMU management
- */
-
-#define IOMMU_FLAG	(IOVMF_ENDIAN_LITTLE | IOVMF_ELSZ_8)
-
-/*
- * ispmmu_vmap - Wrapper for Virtual memory mapping of a scatter gather list
- * @isp: Device pointer specific to the OMAP3 ISP.
- * @sglist: Pointer to source Scatter gather list to allocate.
- * @sglen: Number of elements of the scatter-gatter list.
- *
- * Returns a resulting mapped device address by the ISP MMU, or -ENOMEM if
- * we ran out of memory.
- */
-static dma_addr_t
-ispmmu_vmap(struct isp_device *isp, const struct scatterlist *sglist, int sglen)
-{
-	struct sg_table *sgt;
-	u32 da;
-
-	sgt = kmalloc(sizeof(*sgt), GFP_KERNEL);
-	if (sgt == NULL)
-		return -ENOMEM;
-
-	sgt->sgl = (struct scatterlist *)sglist;
-	sgt->nents = sglen;
-	sgt->orig_nents = sglen;
-
-	da = omap_iommu_vmap(isp->domain, isp->dev, 0, sgt, IOMMU_FLAG);
-	if (IS_ERR_VALUE(da))
-		kfree(sgt);
-
-	return da;
-}
-
-/*
- * ispmmu_vunmap - Unmap a device address from the ISP MMU
- * @isp: Device pointer specific to the OMAP3 ISP.
- * @da: Device address generated from a ispmmu_vmap call.
- */
-static void ispmmu_vunmap(struct isp_device *isp, dma_addr_t da)
-{
-	struct sg_table *sgt;
-
-	sgt = omap_iommu_vunmap(isp->domain, isp->dev, (u32)da);
-	kfree(sgt);
-}
-
-/* -----------------------------------------------------------------------------
  * Video queue operations
  */
 
@@ -392,24 +342,11 @@ static void isp_video_queue_prepare(struct isp_video_queue *queue,
 	*nbuffers = min(*nbuffers, video->capture_mem / PAGE_ALIGN(*size));
 }
 
-static void isp_video_buffer_cleanup(struct isp_video_buffer *buf)
-{
-	struct isp_video_fh *vfh = isp_video_queue_to_isp_video_fh(buf->queue);
-	struct isp_buffer *buffer = to_isp_buffer(buf);
-	struct isp_video *video = vfh->video;
-
-	if (buffer->isp_addr) {
-		ispmmu_vunmap(video->isp, buffer->isp_addr);
-		buffer->isp_addr = 0;
-	}
-}
-
 static int isp_video_buffer_prepare(struct isp_video_buffer *buf)
 {
 	struct isp_video_fh *vfh = isp_video_queue_to_isp_video_fh(buf->queue);
 	struct isp_buffer *buffer = to_isp_buffer(buf);
 	struct isp_video *video = vfh->video;
-	unsigned long addr;
 
 	/* Refuse to prepare the buffer is the video node has registered an
 	 * error. We don't need to take any lock here as the operation is
@@ -420,18 +357,7 @@ static int isp_video_buffer_prepare(struct isp_video_buffer *buf)
 	if (unlikely(video->error))
 		return -EIO;
 
-	addr = ispmmu_vmap(video->isp, buf->sglist, buf->sglen);
-	if (IS_ERR_VALUE(addr))
-		return -EIO;
-
-	if (!IS_ALIGNED(addr, 32)) {
-		dev_dbg(video->isp->dev, "Buffer address must be "
-			"aligned to 32 bytes boundary.\n");
-		ispmmu_vunmap(video->isp, buffer->isp_addr);
-		return -EINVAL;
-	}
-
-	buffer->isp_addr = addr;
+	buffer->isp_addr = buf->dma;
 	return 0;
 }
 
@@ -490,7 +416,6 @@ static const struct isp_video_queue_operations isp_video_queue_ops = {
 	.queue_prepare = &isp_video_queue_prepare,
 	.buffer_prepare = &isp_video_buffer_prepare,
 	.buffer_queue = &isp_video_buffer_queue,
-	.buffer_cleanup = &isp_video_buffer_cleanup,
 };
 
 /*
-- 
1.8.3.2

