Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:21732 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755263AbbLGMJn (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 7 Dec 2015 07:09:43 -0500
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
	devicetree@vger.kernel.org,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Kamil Debski <k.debski@samsung.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Andrzej Hajda <a.hajda@samsung.com>,
	Kukjin Kim <kgene@kernel.org>,
	Krzysztof Kozlowski <k.kozlowski@samsung.com>,
	Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: [PATCH 5/7] media: set proper max seg size for devices on Exynos SoCs
Date: Mon, 07 Dec 2015 13:09:00 +0100
Message-id: <1449490142-27502-6-git-send-email-m.szyprowski@samsung.com>
In-reply-to: <1449490142-27502-1-git-send-email-m.szyprowski@samsung.com>
References: <1449490142-27502-1-git-send-email-m.szyprowski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

All multimedia devices found on Exynos SoCs support only contiguous
buffers, so set DMA max segment size to DMA_BIT_MASK(32) to let memory
allocator to correctly create contiguous memory mappings.

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
---
 drivers/media/platform/exynos-gsc/gsc-core.c  | 1 +
 drivers/media/platform/exynos4-is/fimc-core.c | 1 +
 drivers/media/platform/exynos4-is/fimc-is.c   | 1 +
 drivers/media/platform/exynos4-is/fimc-lite.c | 1 +
 drivers/media/platform/s5p-g2d/g2d.c          | 1 +
 drivers/media/platform/s5p-jpeg/jpeg-core.c   | 1 +
 drivers/media/platform/s5p-mfc/s5p_mfc.c      | 2 ++
 drivers/media/platform/s5p-tv/mixer_video.c   | 1 +
 8 files changed, 9 insertions(+)

diff --git a/drivers/media/platform/exynos-gsc/gsc-core.c b/drivers/media/platform/exynos-gsc/gsc-core.c
index 9b9e423e4fc4..4f90be43b5a9 100644
--- a/drivers/media/platform/exynos-gsc/gsc-core.c
+++ b/drivers/media/platform/exynos-gsc/gsc-core.c
@@ -1140,6 +1140,7 @@ static int gsc_probe(struct platform_device *pdev)
 		goto err_m2m;
 
 	/* Initialize continious memory allocator */
+	vb2_dma_contig_set_max_seg_size(dev, DMA_BIT_MASK(32));
 	gsc->alloc_ctx = vb2_dma_contig_init_ctx(dev);
 	if (IS_ERR(gsc->alloc_ctx)) {
 		ret = PTR_ERR(gsc->alloc_ctx);
diff --git a/drivers/media/platform/exynos4-is/fimc-core.c b/drivers/media/platform/exynos4-is/fimc-core.c
index cef2a7f07cdb..368e19b50498 100644
--- a/drivers/media/platform/exynos4-is/fimc-core.c
+++ b/drivers/media/platform/exynos4-is/fimc-core.c
@@ -1019,6 +1019,7 @@ static int fimc_probe(struct platform_device *pdev)
 	}
 
 	/* Initialize contiguous memory allocator */
+	vb2_dma_contig_set_max_seg_size(dev, DMA_BIT_MASK(32));
 	fimc->alloc_ctx = vb2_dma_contig_init_ctx(dev);
 	if (IS_ERR(fimc->alloc_ctx)) {
 		ret = PTR_ERR(fimc->alloc_ctx);
diff --git a/drivers/media/platform/exynos4-is/fimc-is.c b/drivers/media/platform/exynos4-is/fimc-is.c
index 49658ca39e51..123772fa0241 100644
--- a/drivers/media/platform/exynos4-is/fimc-is.c
+++ b/drivers/media/platform/exynos4-is/fimc-is.c
@@ -841,6 +841,7 @@ static int fimc_is_probe(struct platform_device *pdev)
 	if (ret < 0)
 		goto err_pm;
 
+	vb2_dma_contig_set_max_seg_size(dev, DMA_BIT_MASK(32));
 	is->alloc_ctx = vb2_dma_contig_init_ctx(dev);
 	if (IS_ERR(is->alloc_ctx)) {
 		ret = PTR_ERR(is->alloc_ctx);
diff --git a/drivers/media/platform/exynos4-is/fimc-lite.c b/drivers/media/platform/exynos4-is/fimc-lite.c
index 6f76afd909c4..9cfd2221f53d 100644
--- a/drivers/media/platform/exynos4-is/fimc-lite.c
+++ b/drivers/media/platform/exynos4-is/fimc-lite.c
@@ -1564,6 +1564,7 @@ static int fimc_lite_probe(struct platform_device *pdev)
 			goto err_sd;
 	}
 
+	vb2_dma_contig_set_max_seg_size(dev, DMA_BIT_MASK(32));
 	fimc->alloc_ctx = vb2_dma_contig_init_ctx(dev);
 	if (IS_ERR(fimc->alloc_ctx)) {
 		ret = PTR_ERR(fimc->alloc_ctx);
diff --git a/drivers/media/platform/s5p-g2d/g2d.c b/drivers/media/platform/s5p-g2d/g2d.c
index e1936d9d27da..31f6c233b146 100644
--- a/drivers/media/platform/s5p-g2d/g2d.c
+++ b/drivers/media/platform/s5p-g2d/g2d.c
@@ -681,6 +681,7 @@ static int g2d_probe(struct platform_device *pdev)
 		goto put_clk_gate;
 	}
 
+	vb2_dma_contig_set_max_seg_size(&pdev->dev, DMA_BIT_MASK(32));
 	dev->alloc_ctx = vb2_dma_contig_init_ctx(&pdev->dev);
 	if (IS_ERR(dev->alloc_ctx)) {
 		ret = PTR_ERR(dev->alloc_ctx);
diff --git a/drivers/media/platform/s5p-jpeg/jpeg-core.c b/drivers/media/platform/s5p-jpeg/jpeg-core.c
index 4a608cbe0fdb..6bd92f014a23 100644
--- a/drivers/media/platform/s5p-jpeg/jpeg-core.c
+++ b/drivers/media/platform/s5p-jpeg/jpeg-core.c
@@ -2839,6 +2839,7 @@ static int s5p_jpeg_probe(struct platform_device *pdev)
 		goto device_register_rollback;
 	}
 
+	vb2_dma_contig_set_max_seg_size(&pdev->dev, DMA_BIT_MASK(32));
 	jpeg->alloc_ctx = vb2_dma_contig_init_ctx(&pdev->dev);
 	if (IS_ERR(jpeg->alloc_ctx)) {
 		v4l2_err(&jpeg->v4l2_dev, "Failed to init memory allocator\n");
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc.c b/drivers/media/platform/s5p-mfc/s5p_mfc.c
index 81ffb67e6d66..8fcecf8a9a17 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc.c
@@ -1164,11 +1164,13 @@ static int s5p_mfc_probe(struct platform_device *pdev)
 		}
 	}
 
+	vb2_dma_contig_set_max_seg_size(dev->mem_dev_l, DMA_BIT_MASK(32));
 	dev->alloc_ctx[0] = vb2_dma_contig_init_ctx(dev->mem_dev_l);
 	if (IS_ERR(dev->alloc_ctx[0])) {
 		ret = PTR_ERR(dev->alloc_ctx[0]);
 		goto err_res;
 	}
+	vb2_dma_contig_set_max_seg_size(dev->mem_dev_r, DMA_BIT_MASK(32));
 	dev->alloc_ctx[1] = vb2_dma_contig_init_ctx(dev->mem_dev_r);
 	if (IS_ERR(dev->alloc_ctx[1])) {
 		ret = PTR_ERR(dev->alloc_ctx[1]);
diff --git a/drivers/media/platform/s5p-tv/mixer_video.c b/drivers/media/platform/s5p-tv/mixer_video.c
index dc1c679e136c..1d9c2d5a10e7 100644
--- a/drivers/media/platform/s5p-tv/mixer_video.c
+++ b/drivers/media/platform/s5p-tv/mixer_video.c
@@ -80,6 +80,7 @@ int mxr_acquire_video(struct mxr_device *mdev,
 		goto fail;
 	}
 
+	vb2_dma_contig_set_max_seg_size(mdev->dev, DMA_BIT_MASK(32));
 	mdev->alloc_ctx = vb2_dma_contig_init_ctx(mdev->dev);
 	if (IS_ERR(mdev->alloc_ctx)) {
 		mxr_err(mdev, "could not acquire vb2 allocator\n");
-- 
1.9.2

