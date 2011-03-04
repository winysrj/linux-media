Return-path: <mchehab@pedra>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:22339 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759315Ab1CDJBc (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 4 Mar 2011 04:01:32 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Date: Fri, 04 Mar 2011 10:01:13 +0100
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: [PATCH 6/7] s5p-fimc: Add support for vb2-s5p-iommu allocator
In-reply-to: <1299229274-9753-1-git-send-email-m.szyprowski@samsung.com>
To: linux-samsung-soc@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, kyungmin.park@samsung.com,
	kgene.kim@samsung.com, andrzej.p@samsung.com,
	t.stanislaws@samsung.com, s.nawrocki@samsung.com,
	k.debski@samsung.com
Message-id: <1299229274-9753-7-git-send-email-m.szyprowski@samsung.com>
References: <1299229274-9753-1-git-send-email-m.szyprowski@samsung.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

This patch adds support for videobuf2-s5p-iommu allocator to s5p-fimc
driver. This allocator is selected only on systems that contains support
for S5P SYSMMU module. Otherwise the standard videobuf2-dma-contig is
used.

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/video/Kconfig                 |    3 +-
 drivers/media/video/s5p-fimc/fimc-capture.c |    4 +-
 drivers/media/video/s5p-fimc/fimc-core.c    |   22 ++++---
 drivers/media/video/s5p-fimc/fimc-mem.h     |   87 +++++++++++++++++++++++++++
 4 files changed, 104 insertions(+), 12 deletions(-)
 create mode 100644 drivers/media/video/s5p-fimc/fimc-mem.h

diff --git a/drivers/media/video/Kconfig b/drivers/media/video/Kconfig
index 9806505..12fb325 100644
--- a/drivers/media/video/Kconfig
+++ b/drivers/media/video/Kconfig
@@ -1018,7 +1018,8 @@ config VIDEO_MEM2MEM_TESTDEV
 config  VIDEO_SAMSUNG_S5P_FIMC
 	tristate "Samsung S5P FIMC (video postprocessor) driver"
 	depends on VIDEO_DEV && VIDEO_V4L2 && PLAT_S5P
-	select VIDEOBUF2_DMA_CONTIG
+	select VIDEOBUF2_S5P_IOMMU if S5P_SYSTEM_MMU
+	select VIDEOBUF2_DMA_CONTIG if !S5P_SYSTEM_MMU
 	select V4L2_MEM2MEM_DEV
 	help
 	  This is a v4l2 driver for the S5P camera interface
diff --git a/drivers/media/video/s5p-fimc/fimc-capture.c b/drivers/media/video/s5p-fimc/fimc-capture.c
index f8d7de5..6819908 100644
--- a/drivers/media/video/s5p-fimc/fimc-capture.c
+++ b/drivers/media/video/s5p-fimc/fimc-capture.c
@@ -29,8 +29,8 @@
 #include <media/v4l2-ioctl.h>
 #include <media/v4l2-mem2mem.h>
 #include <media/videobuf2-core.h>
-#include <media/videobuf2-dma-contig.h>
 
+#include "fimc-mem.h"
 #include "fimc-core.h"
 
 static struct v4l2_subdev *fimc_subdev_register(struct fimc_dev *fimc,
@@ -881,7 +881,7 @@ int fimc_register_capture_device(struct fimc_dev *fimc)
 	q->io_modes = VB2_MMAP | VB2_USERPTR;
 	q->drv_priv = fimc->vid_cap.ctx;
 	q->ops = &fimc_capture_qops;
-	q->mem_ops = &vb2_dma_contig_memops;
+	q->mem_ops = &fimc_vb2_allocator_memops;
 	q->buf_struct_size = sizeof(struct fimc_vid_buffer);
 
 	vb2_queue_init(q);
diff --git a/drivers/media/video/s5p-fimc/fimc-core.c b/drivers/media/video/s5p-fimc/fimc-core.c
index c92dbdb..f06aaea 100644
--- a/drivers/media/video/s5p-fimc/fimc-core.c
+++ b/drivers/media/video/s5p-fimc/fimc-core.c
@@ -27,8 +27,8 @@
 #include <linux/clk.h>
 #include <media/v4l2-ioctl.h>
 #include <media/videobuf2-core.h>
-#include <media/videobuf2-dma-contig.h>
 
+#include "fimc-mem.h"
 #include "fimc-core.h"
 
 static char *fimc_clocks[MAX_FIMC_CLOCKS] = {
@@ -458,7 +458,7 @@ int fimc_prepare_addr(struct fimc_ctx *ctx, struct vb2_buffer *vb,
 	dbg("memplanes= %d, colplanes= %d, pix_size= %d",
 		frame->fmt->memplanes, frame->fmt->colplanes, pix_size);
 
-	paddr->y = vb2_dma_contig_plane_paddr(vb, 0);
+	paddr->y = fimc_vb2_plane_addr(vb, 0);
 
 	if (frame->fmt->memplanes == 1) {
 		switch (frame->fmt->colplanes) {
@@ -486,10 +486,10 @@ int fimc_prepare_addr(struct fimc_ctx *ctx, struct vb2_buffer *vb,
 		}
 	} else {
 		if (frame->fmt->memplanes >= 2)
-			paddr->cb = vb2_dma_contig_plane_paddr(vb, 1);
+			paddr->cb = fimc_vb2_plane_addr(vb, 1);
 
 		if (frame->fmt->memplanes == 3)
-			paddr->cr = vb2_dma_contig_plane_paddr(vb, 2);
+			paddr->cr = fimc_vb2_plane_addr(vb, 2);
 	}
 
 	dbg("PHYS_ADDR: y= 0x%X  cb= 0x%X cr= 0x%X ret= %d",
@@ -1375,7 +1375,7 @@ static int queue_init(void *priv, struct vb2_queue *src_vq,
 	src_vq->io_modes = VB2_MMAP | VB2_USERPTR;
 	src_vq->drv_priv = ctx;
 	src_vq->ops = &fimc_qops;
-	src_vq->mem_ops = &vb2_dma_contig_memops;
+	src_vq->mem_ops = &fimc_vb2_allocator_memops;
 	src_vq->buf_struct_size = sizeof(struct v4l2_m2m_buffer);
 
 	ret = vb2_queue_init(src_vq);
@@ -1387,7 +1387,7 @@ static int queue_init(void *priv, struct vb2_queue *src_vq,
 	dst_vq->io_modes = VB2_MMAP | VB2_USERPTR;
 	dst_vq->drv_priv = ctx;
 	dst_vq->ops = &fimc_qops;
-	dst_vq->mem_ops = &vb2_dma_contig_memops;
+	dst_vq->mem_ops = &fimc_vb2_allocator_memops;
 	dst_vq->buf_struct_size = sizeof(struct v4l2_m2m_buffer);
 
 	return vb2_queue_init(dst_vq);
@@ -1685,12 +1685,15 @@ static int fimc_probe(struct platform_device *pdev)
 		goto err_clk;
 	}
 
-	/* Initialize contiguous memory allocator */
-	fimc->alloc_ctx = vb2_dma_contig_init_ctx(&fimc->pdev->dev);
+	/* Initialize memory allocator */
+	fimc->alloc_ctx = fimc_vb2_allocator_init(pdev);
 	if (IS_ERR(fimc->alloc_ctx)) {
 		ret = PTR_ERR(fimc->alloc_ctx);
 		goto err_irq;
 	}
+	ret = fimc_vb2_allocator_enable(fimc->alloc_ctx);
+	if (ret)
+		goto err_irq;
 
 	ret = fimc_register_m2m_device(fimc);
 	if (ret)
@@ -1747,7 +1750,8 @@ static int __devexit fimc_remove(struct platform_device *pdev)
 
 	fimc_clk_release(fimc);
 
-	vb2_dma_contig_cleanup_ctx(fimc->alloc_ctx);
+	fimc_vb2_allocator_disable(fimc->alloc_ctx);
+	fimc_vb2_allocator_cleanup(fimc->alloc_ctx);
 
 	pm_runtime_disable(&pdev->dev);
 
diff --git a/drivers/media/video/s5p-fimc/fimc-mem.h b/drivers/media/video/s5p-fimc/fimc-mem.h
new file mode 100644
index 0000000..9ac9bc6
--- /dev/null
+++ b/drivers/media/video/s5p-fimc/fimc-mem.h
@@ -0,0 +1,87 @@
+/*
+ * Copyright (c) 2011 Samsung Electronics
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef FIMC_MEM_H_
+#define FIMC_MEM_H_
+
+/*
+ * fimc-mem.h is the interface for videbuf2 allocator. It is a proxy
+ * to real allocator depending on system capabilities.
+ * 1. on S5PC100 & S5PV210/S5PC110 systems vb2-dma-contig is used
+ * 2. on S5PV310/S5PC210 systems vb2-s5p-iommu allocator is selected.
+ *
+ */
+
+#ifdef CONFIG_S5P_SYSTEM_MMU
+
+#include <media/videobuf2-s5p-iommu.h>
+
+#define fimc_vb2_allocator_memops vb2_s5p_iommu_memops
+
+static inline void *fimc_vb2_allocator_init(struct platform_device *pdev)
+{
+	struct vb2_s5p_iommu_request iommu_req;
+	memset(&iommu_req, 0, sizeof(iommu_req));
+	iommu_req.ip = S5P_SYSMMU_FIMC0 + pdev->id;
+	return vb2_s5p_iommu_init(&pdev->dev, &iommu_req);
+}
+
+static inline void fimc_vb2_allocator_cleanup(void *alloc_ctx)
+{
+	return vb2_s5p_iommu_cleanup(alloc_ctx);
+}
+
+static inline unsigned long fimc_vb2_plane_addr(struct vb2_buffer *b, int n)
+{
+	return vb2_s5p_iommu_plane_addr(b, n);
+}
+
+static inline int fimc_vb2_allocator_enable(void *alloc_ctx)
+{
+	return vb2_s5p_iommu_enable(alloc_ctx);
+}
+
+static inline int fimc_vb2_allocator_disable(void *alloc_ctx)
+{
+	return vb2_s5p_iommu_disable(alloc_ctx);
+}
+
+#else	/* use vb2-dma-contig allocator */
+
+#include <media/videobuf2-dma-contig.h>
+
+#define fimc_vb2_allocator_memops vb2_dma_contig_memops
+
+static inline void *fimc_vb2_allocator_init(struct platform_device *pdev)
+{
+	return vb2_dma_contig_init_ctx(&pdev->dev);
+}
+
+static inline void fimc_vb2_allocator_cleanup(void *alloc_ctx)
+{
+	vb2_dma_contig_cleanup_ctx(alloc_ctx);
+}
+
+static inline unsigned long fimc_vb2_plane_addr(struct vb2_buffer *b, int n)
+{
+	return vb2_dma_contig_plane_paddr(b, n);
+}
+
+static inline int fimc_vb2_allocator_enable(void *alloc_ctx)
+{
+	return 0;
+}
+
+static inline int fimc_vb2_allocator_disable(void *alloc_ctx)
+{
+	return 0;
+}
+
+#endif
+
+#endif /* FIMC_CORE_H_ */
-- 
1.7.1.569.g6f426
