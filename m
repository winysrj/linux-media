Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:45849 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753005AbcD1MMa (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 28 Apr 2016 08:12:30 -0400
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Krzysztof Kozlowski <k.kozlowski@samsung.com>,
	Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH] media: vb2-dma-contig: configure DMA max segment size properly
Date: Thu, 28 Apr 2016 14:12:20 +0200
Message-id: <1461845540-26454-1-git-send-email-m.szyprowski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch lets vb2-dma-contig memory allocator to configure DMA max
segment size properly for the client device. Setting it is needed to let
DMA-mapping subsystem to create a single, contiguous mapping in DMA
address space. This is essential for all devices, which use dma-contig
videobuf2 memory allocator and shared buffers (in USERPTR or DMAbuf modes
of operations).

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
---
Hello,

This patch is a follow-up of my previous attempts to let Exynos
multimedia devices to work properly with shared buffers when IOMMU is
enabled:
1. https://www.mail-archive.com/linux-media@vger.kernel.org/msg96946.html
2. http://thread.gmane.org/gmane.linux.drivers.video-input-infrastructure/97316
3. https://patchwork.linuxtv.org/patch/30870/

As sugested by Hans, configuring DMA max segment size should be done by
videobuf2-dma-contig module instead of requiring all device drivers to
do it on their own.

Here is some backgroud why this is done in videobuf2-dc not in the
respective generic bus code:
http://lists.infradead.org/pipermail/linux-arm-kernel/2014-November/305913.html

Best regards,
Marek Szyprowski
---
 drivers/media/v4l2-core/videobuf2-dma-contig.c | 39 ++++++++++++++++++++++++++
 1 file changed, 39 insertions(+)

diff --git a/drivers/media/v4l2-core/videobuf2-dma-contig.c b/drivers/media/v4l2-core/videobuf2-dma-contig.c
index 461ae55eaa98..871e370f8e88 100644
--- a/drivers/media/v4l2-core/videobuf2-dma-contig.c
+++ b/drivers/media/v4l2-core/videobuf2-dma-contig.c
@@ -443,6 +443,35 @@ static void vb2_dc_put_userptr(void *buf_priv)
 }
 
 /*
+ * To allow mapping scatter-list into signle chunk in DMA address space,
+ * device is required to have DMA max segment size parameter set to value
+ * larger than the buffer size. Otherwise, DMA-mapping subsystem will
+ * split the mapping into max segment size chunks.
+ * This function increases DMA max segment size parameter to let
+ * DMA-mapping to map a buffer as a single chunk in DMA address space.
+ * This code assumes that the DMA-mapping subsystem will merge all
+ * scatter-list segments if this is really possible (for example when
+ * IOMMU is available and enabled).
+ * Ideally, this parameter should be set by generic bus code, but it is
+ * left with the default 64KiB value due to some historical limitations
+ * in other subsystems (like limited USB host drivers) and there is no
+ * good place to set it to the proper value. It is done here to avoid
+ * fixing all vb2-dc client drivers.
+ */
+static int vb2_dc_set_max_seg_size(struct device *dev, unsigned int size)
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
+
+/*
  * For some kind of reserved memory there might be no struct page available,
  * so all that can be done to support such 'pages' is to try to convert
  * pfn to dma address or at the last resort just assume that
@@ -499,6 +528,10 @@ static void *vb2_dc_get_userptr(struct device *dev, unsigned long vaddr,
 		return ERR_PTR(-EINVAL);
 	}
 
+	ret = vb2_dc_set_max_seg_size(dev, PAGE_ALIGN(size + PAGE_SIZE));
+	if (!ret)
+		return ERR_PTR(ret);
+
 	buf = kzalloc(sizeof *buf, GFP_KERNEL);
 	if (!buf)
 		return ERR_PTR(-ENOMEM);
@@ -675,10 +708,15 @@ static void *vb2_dc_attach_dmabuf(struct device *dev, struct dma_buf *dbuf,
 {
 	struct vb2_dc_buf *buf;
 	struct dma_buf_attachment *dba;
+	int ret;
 
 	if (dbuf->size < size)
 		return ERR_PTR(-EFAULT);
 
+	ret = vb2_dc_set_max_seg_size(dev, PAGE_ALIGN(size));
+	if (!ret)
+		return ERR_PTR(ret);
+
 	buf = kzalloc(sizeof(*buf), GFP_KERNEL);
 	if (!buf)
 		return ERR_PTR(-ENOMEM);
@@ -722,6 +760,7 @@ const struct vb2_mem_ops vb2_dma_contig_memops = {
 };
 EXPORT_SYMBOL_GPL(vb2_dma_contig_memops);
 
+
 MODULE_DESCRIPTION("DMA-contig memory handling routines for videobuf2");
 MODULE_AUTHOR("Pawel Osciak <pawel@osciak.com>");
 MODULE_LICENSE("GPL");
-- 
1.9.2

