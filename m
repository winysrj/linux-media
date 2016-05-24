Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:50239 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753719AbcEXHQ0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 24 May 2016 03:16:26 -0400
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Krzysztof Kozlowski <k.kozlowski@samsung.com>,
	Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>
Subject: [PATCH v5 1/2] media: vb2-dma-contig: add helper for setting dma max
 seg size
Date: Tue, 24 May 2016 09:16:06 +0200
Message-id: <1464074167-27330-2-git-send-email-m.szyprowski@samsung.com>
In-reply-to: <1464074167-27330-1-git-send-email-m.szyprowski@samsung.com>
References: <1464074167-27330-1-git-send-email-m.szyprowski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add a helper function for device drivers to set DMA's max_seg_size.
Setting it to largest possible value lets DMA-mapping API always create
contiguous mappings in DMA address space. This is essential for all
devices, which use dma-contig videobuf2 memory allocator and shared
buffers.

Till now, the only case when vb2-dma-contig really 'worked' was a case
where userspace provided USERPTR buffer, which was in fact mmaped
contiguous buffer from the other v4l2/drm device. Also DMABUF made of
contiguous buffer worked only when its exporter did not split it into
several chunks in the scatter-list. Any other buffer failed, regardless
of the arch/platform used and the presence of the IOMMU of the device bus.

This patch provides interface to fix this issue.

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
---
 drivers/media/v4l2-core/videobuf2-dma-contig.c | 53 ++++++++++++++++++++++++++
 include/media/videobuf2-dma-contig.h           |  2 +
 2 files changed, 55 insertions(+)

diff --git a/drivers/media/v4l2-core/videobuf2-dma-contig.c b/drivers/media/v4l2-core/videobuf2-dma-contig.c
index 5361197..e3e47ac 100644
--- a/drivers/media/v4l2-core/videobuf2-dma-contig.c
+++ b/drivers/media/v4l2-core/videobuf2-dma-contig.c
@@ -753,6 +753,59 @@ void vb2_dma_contig_cleanup_ctx(void *alloc_ctx)
 }
 EXPORT_SYMBOL_GPL(vb2_dma_contig_cleanup_ctx);
 
+/**
+ * vb2_dma_contig_set_max_seg_size() - configure DMA max segment size
+ * @dev:	device for configuring DMA parameters
+ * @size:	size of DMA max segment size to set
+ *
+ * To allow mapping the scatter-list into a single chunk in the DMA
+ * address space, the device is required to have the DMA max segment
+ * size parameter set to a value larger than the buffer size. Otherwise,
+ * the DMA-mapping subsystem will split the mapping into max segment
+ * size chunks. This function sets the DMA max segment size
+ * parameter to let DMA-mapping map a buffer as a single chunk in DMA
+ * address space.
+ * This code assumes that the DMA-mapping subsystem will merge all
+ * scatterlist segments if this is really possible (for example when
+ * an IOMMU is available and enabled).
+ * Ideally, this parameter should be set by the generic bus code, but it
+ * is left with the default 64KiB value due to historical litmiations in
+ * other subsystems (like limited USB host drivers) and there no good
+ * place to set it to the proper value.
+ * This function should be called from the drivers, which are known to
+ * operate on platforms with IOMMU and provide access to shared buffers
+ * (either USERPTR or DMABUF). This should be done before initializing
+ * videobuf2 queue.
+ */
+int vb2_dma_contig_set_max_seg_size(struct device *dev, unsigned int size)
+{
+	if (!dev->dma_parms) {
+		dev->dma_parms = kzalloc(sizeof(dev->dma_parms), GFP_KERNEL);
+		if (!dev->dma_parms)
+			return -ENOMEM;
+	}
+	if (dma_get_max_seg_size(dev) < size)
+		return dma_set_max_seg_size(dev, size);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(vb2_dma_contig_set_max_seg_size);
+
+/*
+ * vb2_dma_contig_clear_max_seg_size() - release resources for DMA parameters
+ * @dev:	device for configuring DMA parameters
+ *
+ * This function releases resources allocated to configure DMA parameters
+ * (see vb2_dma_contig_set_max_seg_size() function). It should be called from
+ * device drivers on driver remove.
+ */
+void vb2_dma_contig_clear_max_seg_size(struct device *dev)
+{
+	kfree(dev->dma_parms);
+	dev->dma_parms = NULL;
+}
+EXPORT_SYMBOL_GPL(vb2_dma_contig_clear_max_seg_size);
+
 MODULE_DESCRIPTION("DMA-contig memory handling routines for videobuf2");
 MODULE_AUTHOR("Pawel Osciak <pawel@osciak.com>");
 MODULE_LICENSE("GPL");
diff --git a/include/media/videobuf2-dma-contig.h b/include/media/videobuf2-dma-contig.h
index 2087c9a..f7dc840 100644
--- a/include/media/videobuf2-dma-contig.h
+++ b/include/media/videobuf2-dma-contig.h
@@ -35,6 +35,8 @@ static inline void *vb2_dma_contig_init_ctx(struct device *dev)
 }
 
 void vb2_dma_contig_cleanup_ctx(void *alloc_ctx);
+int vb2_dma_contig_set_max_seg_size(struct device *dev, unsigned int size);
+void vb2_dma_contig_clear_max_seg_size(struct device *dev);
 
 extern const struct vb2_mem_ops vb2_dma_contig_memops;
 
-- 
1.9.2

