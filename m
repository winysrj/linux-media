Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:38683 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752201AbaDUM3S (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Apr 2014 08:29:18 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Sakari Ailus <sakari.ailus@iki.fi>
Subject: [PATCH v2 18/26] omap3isp: Use the ARM DMA IOMMU-aware operations
Date: Mon, 21 Apr 2014 14:29:04 +0200
Message-Id: <1398083352-8451-19-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1398083352-8451-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1398083352-8451-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Attach an ARM DMA I/O virtual address space to the ISP device. This
switches to the IOMMU-aware ARM DMA backend, we can thus remove the
explicit calls to the OMAP IOMMU map and unmap functions.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/platform/Kconfig             |   4 +-
 drivers/media/platform/omap3isp/isp.c      | 102 +++++++++++++++++++++--------
 drivers/media/platform/omap3isp/isp.h      |   8 +--
 drivers/media/platform/omap3isp/ispqueue.c |  34 ++--------
 drivers/media/platform/omap3isp/ispqueue.h |   2 -
 5 files changed, 89 insertions(+), 61 deletions(-)

diff --git a/drivers/media/platform/Kconfig b/drivers/media/platform/Kconfig
index c137abf..2091b2b 100644
--- a/drivers/media/platform/Kconfig
+++ b/drivers/media/platform/Kconfig
@@ -93,7 +93,9 @@ config VIDEO_M32R_AR_M64278
 
 config VIDEO_OMAP3
 	tristate "OMAP 3 Camera support"
-	depends on OMAP_IOVMM && VIDEO_V4L2 && I2C && VIDEO_V4L2_SUBDEV_API && ARCH_OMAP3
+	depends on VIDEO_V4L2 && I2C && VIDEO_V4L2_SUBDEV_API && ARCH_OMAP3
+	select ARM_DMA_USE_IOMMU
+	select OMAP_IOMMU
 	---help---
 	  Driver for an OMAP 3 camera controller.
 
diff --git a/drivers/media/platform/omap3isp/isp.c b/drivers/media/platform/omap3isp/isp.c
index 06a0df4..5a4801b 100644
--- a/drivers/media/platform/omap3isp/isp.c
+++ b/drivers/media/platform/omap3isp/isp.c
@@ -69,6 +69,8 @@
 #include <linux/sched.h>
 #include <linux/vmalloc.h>
 
+#include <asm/dma-iommu.h>
+
 #include <media/v4l2-common.h>
 #include <media/v4l2-device.h>
 
@@ -1625,7 +1627,7 @@ struct isp_device *omap3isp_get(struct isp_device *isp)
  * Decrement the reference count on the ISP. If the last reference is released,
  * power-down all submodules, disable clocks and free temporary buffers.
  */
-void omap3isp_put(struct isp_device *isp)
+static void __omap3isp_put(struct isp_device *isp, bool save_ctx)
 {
 	if (isp == NULL)
 		return;
@@ -1634,7 +1636,7 @@ void omap3isp_put(struct isp_device *isp)
 	BUG_ON(isp->ref_count == 0);
 	if (--isp->ref_count == 0) {
 		isp_disable_interrupts(isp);
-		if (isp->domain) {
+		if (save_ctx) {
 			isp_save_ctx(isp);
 			isp->has_context = 1;
 		}
@@ -1648,6 +1650,11 @@ void omap3isp_put(struct isp_device *isp)
 	mutex_unlock(&isp->isp_mutex);
 }
 
+void omap3isp_put(struct isp_device *isp)
+{
+	__omap3isp_put(isp, true);
+}
+
 /* --------------------------------------------------------------------------
  * Platform device driver
  */
@@ -2120,6 +2127,61 @@ error_csiphy:
 	return ret;
 }
 
+static void isp_detach_iommu(struct isp_device *isp)
+{
+	arm_iommu_release_mapping(isp->mapping);
+	isp->mapping = NULL;
+	iommu_group_remove_device(isp->dev);
+}
+
+static int isp_attach_iommu(struct isp_device *isp)
+{
+	struct dma_iommu_mapping *mapping;
+	struct iommu_group *group;
+	int ret;
+
+	/* Create a device group and add the device to it. */
+	group = iommu_group_alloc();
+	if (IS_ERR(group)) {
+		dev_err(isp->dev, "failed to allocate IOMMU group\n");
+		return PTR_ERR(group);
+	}
+
+	ret = iommu_group_add_device(group, isp->dev);
+	iommu_group_put(group);
+
+	if (ret < 0) {
+		dev_err(isp->dev, "failed to add device to IPMMU group\n");
+		return ret;
+	}
+
+	/*
+	 * Create the ARM mapping, used by the ARM DMA mapping core to allocate
+	 * VAs. This will allocate a corresponding IOMMU domain.
+	 */
+	mapping = arm_iommu_create_mapping(&platform_bus_type, SZ_1G, SZ_2G);
+	if (IS_ERR(mapping)) {
+		dev_err(isp->dev, "failed to create ARM IOMMU mapping\n");
+		ret = PTR_ERR(mapping);
+		goto error;
+	}
+
+	isp->mapping = mapping;
+
+	/* Attach the ARM VA mapping to the device. */
+	ret = arm_iommu_attach_device(isp->dev, mapping);
+	if (ret < 0) {
+		dev_err(isp->dev, "failed to attach device to VA mapping\n");
+		goto error;
+	}
+
+	return 0;
+
+error:
+	isp_detach_iommu(isp);
+	return ret;
+}
+
 /*
  * isp_remove - Remove ISP platform device
  * @pdev: Pointer to ISP platform device
@@ -2135,10 +2197,8 @@ static int isp_remove(struct platform_device *pdev)
 	isp_xclk_cleanup(isp);
 
 	__omap3isp_get(isp, false);
-	iommu_detach_device(isp->domain, &pdev->dev);
-	iommu_domain_free(isp->domain);
-	isp->domain = NULL;
-	omap3isp_put(isp);
+	isp_detach_iommu(isp);
+	__omap3isp_put(isp, false);
 
 	return 0;
 }
@@ -2265,39 +2325,32 @@ static int isp_probe(struct platform_device *pdev)
 		}
 	}
 
-	isp->domain = iommu_domain_alloc(pdev->dev.bus);
-	if (!isp->domain) {
-		dev_err(isp->dev, "can't alloc iommu domain\n");
-		ret = -ENOMEM;
+	/* IOMMU */
+	ret = isp_attach_iommu(isp);
+	if (ret < 0) {
+		dev_err(&pdev->dev, "unable to attach to IOMMU\n");
 		goto error_isp;
 	}
 
-	ret = iommu_attach_device(isp->domain, &pdev->dev);
-	if (ret) {
-		dev_err(&pdev->dev, "can't attach iommu device: %d\n", ret);
-		ret = -EPROBE_DEFER;
-		goto free_domain;
-	}
-
 	/* Interrupt */
 	isp->irq_num = platform_get_irq(pdev, 0);
 	if (isp->irq_num <= 0) {
 		dev_err(isp->dev, "No IRQ resource\n");
 		ret = -ENODEV;
-		goto detach_dev;
+		goto error_iommu;
 	}
 
 	if (devm_request_irq(isp->dev, isp->irq_num, isp_isr, IRQF_SHARED,
 			     "OMAP3 ISP", isp)) {
 		dev_err(isp->dev, "Unable to request IRQ\n");
 		ret = -EINVAL;
-		goto detach_dev;
+		goto error_iommu;
 	}
 
 	/* Entities */
 	ret = isp_initialize_modules(isp);
 	if (ret < 0)
-		goto detach_dev;
+		goto error_iommu;
 
 	ret = isp_register_entities(isp);
 	if (ret < 0)
@@ -2310,14 +2363,11 @@ static int isp_probe(struct platform_device *pdev)
 
 error_modules:
 	isp_cleanup_modules(isp);
-detach_dev:
-	iommu_detach_device(isp->domain, &pdev->dev);
-free_domain:
-	iommu_domain_free(isp->domain);
-	isp->domain = NULL;
+error_iommu:
+	isp_detach_iommu(isp);
 error_isp:
 	isp_xclk_cleanup(isp);
-	omap3isp_put(isp);
+	__omap3isp_put(isp, false);
 error:
 	mutex_destroy(&isp->isp_mutex);
 
diff --git a/drivers/media/platform/omap3isp/isp.h b/drivers/media/platform/omap3isp/isp.h
index 6d5e697..2c314ee 100644
--- a/drivers/media/platform/omap3isp/isp.h
+++ b/drivers/media/platform/omap3isp/isp.h
@@ -45,8 +45,6 @@
 #include "ispcsi2.h"
 #include "ispccp2.h"
 
-#define IOMMU_FLAG (IOVMF_ENDIAN_LITTLE | IOVMF_ELSZ_8)
-
 #define ISP_TOK_TERM		0xFFFFFFFF	/*
 						 * terminating token for ISP
 						 * modules reg list
@@ -152,6 +150,7 @@ struct isp_xclk {
  *             regions.
  * @mmio_base_phys: Array with physical L4 bus addresses for ISP register
  *                  regions.
+ * @mapping: IOMMU mapping
  * @stat_lock: Spinlock for handling statistics
  * @isp_mutex: Mutex for serializing requests to ISP.
  * @stop_failure: Indicates that an entity failed to stop.
@@ -171,7 +170,6 @@ struct isp_xclk {
  * @isp_res: Pointer to current settings for ISP Resizer.
  * @isp_prev: Pointer to current settings for ISP Preview.
  * @isp_ccdc: Pointer to current settings for ISP CCDC.
- * @iommu: Pointer to requested IOMMU instance for ISP.
  * @platform_cb: ISP driver callback function pointers for platform code
  *
  * This structure is used to store the OMAP ISP Information.
@@ -189,6 +187,8 @@ struct isp_device {
 	void __iomem *mmio_base[OMAP3_ISP_IOMEM_LAST];
 	unsigned long mmio_base_phys[OMAP3_ISP_IOMEM_LAST];
 
+	struct dma_iommu_mapping *mapping;
+
 	/* ISP Obj */
 	spinlock_t stat_lock;	/* common lock for statistic drivers */
 	struct mutex isp_mutex;	/* For handling ref_count field */
@@ -219,8 +219,6 @@ struct isp_device {
 
 	unsigned int sbl_resources;
 	unsigned int subclk_resources;
-
-	struct iommu_domain *domain;
 };
 
 #define v4l2_dev_to_isp_device(dev) \
diff --git a/drivers/media/platform/omap3isp/ispqueue.c b/drivers/media/platform/omap3isp/ispqueue.c
index cee1b5d..9c90fb0 100644
--- a/drivers/media/platform/omap3isp/ispqueue.c
+++ b/drivers/media/platform/omap3isp/ispqueue.c
@@ -26,7 +26,6 @@
 #include <asm/cacheflush.h>
 #include <linux/dma-mapping.h>
 #include <linux/mm.h>
-#include <linux/omap-iommu.h>
 #include <linux/pagemap.h>
 #include <linux/poll.h>
 #include <linux/scatterlist.h>
@@ -159,7 +158,7 @@ static int isp_video_buffer_prepare_kernel(struct isp_video_buffer *buf)
 	struct isp_video *video = vfh->video;
 
 	return dma_get_sgtable(video->isp->dev, &buf->sgt, buf->vaddr,
-			       buf->paddr, PAGE_ALIGN(buf->vbuf.length));
+			       buf->dma, PAGE_ALIGN(buf->vbuf.length));
 }
 
 /*
@@ -170,18 +169,10 @@ static int isp_video_buffer_prepare_kernel(struct isp_video_buffer *buf)
  */
 static void isp_video_buffer_cleanup(struct isp_video_buffer *buf)
 {
-	struct isp_video_fh *vfh = isp_video_queue_to_isp_video_fh(buf->queue);
-	struct isp_video *video = vfh->video;
 	enum dma_data_direction direction;
 	DEFINE_DMA_ATTRS(attrs);
 	unsigned int i;
 
-	if (buf->dma) {
-		omap_iommu_vunmap(video->isp->domain, video->isp->dev,
-				  buf->dma);
-		buf->dma = 0;
-	}
-
 	if (buf->vbuf.memory == V4L2_MEMORY_USERPTR) {
 		if (buf->skip_cache)
 			dma_set_attr(DMA_ATTR_SKIP_CPU_SYNC, &attrs);
@@ -419,11 +410,8 @@ done:
  */
 static int isp_video_buffer_prepare(struct isp_video_buffer *buf)
 {
-	struct isp_video_fh *vfh = isp_video_queue_to_isp_video_fh(buf->queue);
-	struct isp_video *video = vfh->video;
 	enum dma_data_direction direction;
 	DEFINE_DMA_ATTRS(attrs);
-	unsigned long addr;
 	int ret;
 
 	switch (buf->vbuf.memory) {
@@ -458,23 +446,15 @@ static int isp_video_buffer_prepare(struct isp_video_buffer *buf)
 			goto done;
 		}
 
+		buf->dma = sg_dma_address(buf->sgt.sgl);
 		break;
 
 	default:
 		return -EINVAL;
 	}
 
-	addr = omap_iommu_vmap(video->isp->domain, video->isp->dev, 0,
-			       &buf->sgt, IOVMF_ENDIAN_LITTLE | IOVMF_ELSZ_8);
-	if (IS_ERR_VALUE(addr)) {
-		ret = -EIO;
-		goto done;
-	}
-
-	buf->dma = addr;
-
-	if (!IS_ALIGNED(addr, 32)) {
-		dev_dbg(video->isp->dev,
+	if (!IS_ALIGNED(buf->dma, 32)) {
+		dev_dbg(buf->queue->dev,
 			"Buffer address must be aligned to 32 bytes boundary.\n");
 		ret = -EINVAL;
 		goto done;
@@ -576,7 +556,7 @@ static int isp_video_queue_free(struct isp_video_queue *queue)
 		if (buf->vaddr) {
 			dma_free_coherent(queue->dev,
 					  PAGE_ALIGN(buf->vbuf.length),
-					  buf->vaddr, buf->paddr);
+					  buf->vaddr, buf->dma);
 			buf->vaddr = NULL;
 		}
 
@@ -632,7 +612,7 @@ static int isp_video_queue_alloc(struct isp_video_queue *queue,
 
 			buf->vbuf.m.offset = i * PAGE_ALIGN(size);
 			buf->vaddr = mem;
-			buf->paddr = dma;
+			buf->dma = dma;
 		}
 
 		buf->vbuf.index = i;
@@ -1079,7 +1059,7 @@ int omap3isp_video_queue_mmap(struct isp_video_queue *queue,
 	 */
 	vma->vm_pgoff = 0;
 
-	ret = dma_mmap_coherent(queue->dev, vma, buf->vaddr, buf->paddr, size);
+	ret = dma_mmap_coherent(queue->dev, vma, buf->vaddr, buf->dma, size);
 	if (ret < 0)
 		goto done;
 
diff --git a/drivers/media/platform/omap3isp/ispqueue.h b/drivers/media/platform/omap3isp/ispqueue.h
index d580f58..ae4acb9 100644
--- a/drivers/media/platform/omap3isp/ispqueue.h
+++ b/drivers/media/platform/omap3isp/ispqueue.h
@@ -68,7 +68,6 @@ enum isp_video_buffer_state {
  * @prepared: Whether the buffer has been prepared
  * @skip_cache: Whether to skip cache management operations for this buffer
  * @vaddr: Memory virtual address (for kernel buffers)
- * @paddr: Memory physicall address (for kernel buffers)
  * @vm_flags: Buffer VMA flags (for userspace buffers)
  * @npages: Number of pages (for userspace buffers)
  * @pages: Pages table (for userspace non-VM_PFNMAP buffers)
@@ -87,7 +86,6 @@ struct isp_video_buffer {
 
 	/* For kernel buffers. */
 	void *vaddr;
-	dma_addr_t paddr;
 
 	/* For userspace buffers. */
 	vm_flags_t vm_flags;
-- 
1.8.3.2

