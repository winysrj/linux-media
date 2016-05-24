Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:18744 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751418AbcEXHQY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 24 May 2016 03:16:24 -0400
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
Subject: [PATCH v5 2/2] media: set proper max seg size for devices on Exynos
 SoCs
Date: Tue, 24 May 2016 09:16:07 +0200
Message-id: <1464074167-27330-3-git-send-email-m.szyprowski@samsung.com>
In-reply-to: <1464074167-27330-1-git-send-email-m.szyprowski@samsung.com>
References: <1464074167-27330-1-git-send-email-m.szyprowski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

All multimedia devices found on Exynos SoCs support only contiguous
buffers, so set DMA max segment size to DMA_BIT_MASK(32) to let memory
allocator to correctly create contiguous memory mappings.

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
---
 drivers/media/platform/exynos-gsc/gsc-core.c  | 2 ++
 drivers/media/platform/exynos4-is/fimc-core.c | 2 ++
 drivers/media/platform/exynos4-is/fimc-is.c   | 2 ++
 drivers/media/platform/exynos4-is/fimc-lite.c | 2 ++
 drivers/media/platform/s5p-g2d/g2d.c          | 2 ++
 drivers/media/platform/s5p-jpeg/jpeg-core.c   | 2 ++
 drivers/media/platform/s5p-mfc/s5p_mfc.c      | 4 ++++
 drivers/media/platform/s5p-tv/mixer_video.c   | 2 ++
 8 files changed, 18 insertions(+)

diff --git a/drivers/media/platform/exynos-gsc/gsc-core.c b/drivers/media/platform/exynos-gsc/gsc-core.c
index c049736..c9d2009 100644
--- a/drivers/media/platform/exynos-gsc/gsc-core.c
+++ b/drivers/media/platform/exynos-gsc/gsc-core.c
@@ -1124,6 +1124,7 @@ static int gsc_probe(struct platform_device *pdev)
 		goto err_m2m;
 
 	/* Initialize continious memory allocator */
+	vb2_dma_contig_set_max_seg_size(dev, DMA_BIT_MASK(32));
 	gsc->alloc_ctx = vb2_dma_contig_init_ctx(dev);
 	if (IS_ERR(gsc->alloc_ctx)) {
 		ret = PTR_ERR(gsc->alloc_ctx);
@@ -1153,6 +1154,7 @@ static int gsc_remove(struct platform_device *pdev)
 	v4l2_device_unregister(&gsc->v4l2_dev);
 
 	vb2_dma_contig_cleanup_ctx(gsc->alloc_ctx);
+	vb2_dma_contig_clear_max_seg_size(&pdev->dev);
 	pm_runtime_disable(&pdev->dev);
 	gsc_clk_put(gsc);
 
diff --git a/drivers/media/platform/exynos4-is/fimc-core.c b/drivers/media/platform/exynos4-is/fimc-core.c
index b1c1cea..368f44f 100644
--- a/drivers/media/platform/exynos4-is/fimc-core.c
+++ b/drivers/media/platform/exynos4-is/fimc-core.c
@@ -1019,6 +1019,7 @@ static int fimc_probe(struct platform_device *pdev)
 	}
 
 	/* Initialize contiguous memory allocator */
+	vb2_dma_contig_set_max_seg_size(dev, DMA_BIT_MASK(32));
 	fimc->alloc_ctx = vb2_dma_contig_init_ctx(dev);
 	if (IS_ERR(fimc->alloc_ctx)) {
 		ret = PTR_ERR(fimc->alloc_ctx);
@@ -1124,6 +1125,7 @@ static int fimc_remove(struct platform_device *pdev)
 
 	fimc_unregister_capture_subdev(fimc);
 	vb2_dma_contig_cleanup_ctx(fimc->alloc_ctx);
+	vb2_dma_contig_clear_max_seg_size(&pdev->dev);
 
 	clk_disable(fimc->clock[CLK_BUS]);
 	fimc_clk_put(fimc);
diff --git a/drivers/media/platform/exynos4-is/fimc-is.c b/drivers/media/platform/exynos4-is/fimc-is.c
index 979c388..bd98b56 100644
--- a/drivers/media/platform/exynos4-is/fimc-is.c
+++ b/drivers/media/platform/exynos4-is/fimc-is.c
@@ -847,6 +847,7 @@ static int fimc_is_probe(struct platform_device *pdev)
 	if (ret < 0)
 		goto err_pm;
 
+	vb2_dma_contig_set_max_seg_size(dev, DMA_BIT_MASK(32));
 	is->alloc_ctx = vb2_dma_contig_init_ctx(dev);
 	if (IS_ERR(is->alloc_ctx)) {
 		ret = PTR_ERR(is->alloc_ctx);
@@ -940,6 +941,7 @@ static int fimc_is_remove(struct platform_device *pdev)
 	free_irq(is->irq, is);
 	fimc_is_unregister_subdevs(is);
 	vb2_dma_contig_cleanup_ctx(is->alloc_ctx);
+	vb2_dma_contig_clear_max_seg_size(dev);
 	fimc_is_put_clocks(is);
 	fimc_is_debugfs_remove(is);
 	release_firmware(is->fw.f_w);
diff --git a/drivers/media/platform/exynos4-is/fimc-lite.c b/drivers/media/platform/exynos4-is/fimc-lite.c
index dc1b929..27cb620 100644
--- a/drivers/media/platform/exynos4-is/fimc-lite.c
+++ b/drivers/media/platform/exynos4-is/fimc-lite.c
@@ -1551,6 +1551,7 @@ static int fimc_lite_probe(struct platform_device *pdev)
 			goto err_sd;
 	}
 
+	vb2_dma_contig_set_max_seg_size(dev, DMA_BIT_MASK(32));
 	fimc->alloc_ctx = vb2_dma_contig_init_ctx(dev);
 	if (IS_ERR(fimc->alloc_ctx)) {
 		ret = PTR_ERR(fimc->alloc_ctx);
@@ -1652,6 +1653,7 @@ static int fimc_lite_remove(struct platform_device *pdev)
 	pm_runtime_set_suspended(dev);
 	fimc_lite_unregister_capture_subdev(fimc);
 	vb2_dma_contig_cleanup_ctx(fimc->alloc_ctx);
+	vb2_dma_contig_clear_max_seg_size(dev);
 	fimc_lite_clk_put(fimc);
 
 	dev_info(dev, "Driver unloaded\n");
diff --git a/drivers/media/platform/s5p-g2d/g2d.c b/drivers/media/platform/s5p-g2d/g2d.c
index 612d1ea..d3e3469 100644
--- a/drivers/media/platform/s5p-g2d/g2d.c
+++ b/drivers/media/platform/s5p-g2d/g2d.c
@@ -681,6 +681,7 @@ static int g2d_probe(struct platform_device *pdev)
 		goto put_clk_gate;
 	}
 
+	vb2_dma_contig_set_max_seg_size(&pdev->dev, DMA_BIT_MASK(32));
 	dev->alloc_ctx = vb2_dma_contig_init_ctx(&pdev->dev);
 	if (IS_ERR(dev->alloc_ctx)) {
 		ret = PTR_ERR(dev->alloc_ctx);
@@ -757,6 +758,7 @@ static int g2d_remove(struct platform_device *pdev)
 	video_unregister_device(dev->vfd);
 	v4l2_device_unregister(&dev->v4l2_dev);
 	vb2_dma_contig_cleanup_ctx(dev->alloc_ctx);
+	vb2_dma_contig_clear_max_seg_size(&pdev->dev);
 	clk_unprepare(dev->gate);
 	clk_put(dev->gate);
 	clk_unprepare(dev->clk);
diff --git a/drivers/media/platform/s5p-jpeg/jpeg-core.c b/drivers/media/platform/s5p-jpeg/jpeg-core.c
index caa19b4..17bc94092 100644
--- a/drivers/media/platform/s5p-jpeg/jpeg-core.c
+++ b/drivers/media/platform/s5p-jpeg/jpeg-core.c
@@ -2843,6 +2843,7 @@ static int s5p_jpeg_probe(struct platform_device *pdev)
 		goto device_register_rollback;
 	}
 
+	vb2_dma_contig_set_max_seg_size(&pdev->dev, DMA_BIT_MASK(32));
 	jpeg->alloc_ctx = vb2_dma_contig_init_ctx(&pdev->dev);
 	if (IS_ERR(jpeg->alloc_ctx)) {
 		v4l2_err(&jpeg->v4l2_dev, "Failed to init memory allocator\n");
@@ -2942,6 +2943,7 @@ static int s5p_jpeg_remove(struct platform_device *pdev)
 	video_unregister_device(jpeg->vfd_decoder);
 	video_unregister_device(jpeg->vfd_encoder);
 	vb2_dma_contig_cleanup_ctx(jpeg->alloc_ctx);
+	vb2_dma_contig_clear_max_seg_size(&pdev->dev);
 	v4l2_m2m_release(jpeg->m2m_dev);
 	v4l2_device_unregister(&jpeg->v4l2_dev);
 
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc.c b/drivers/media/platform/s5p-mfc/s5p_mfc.c
index b16466f..274473e 100644
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
@@ -1293,6 +1295,8 @@ static int s5p_mfc_remove(struct platform_device *pdev)
 	s5p_mfc_release_firmware(dev);
 	vb2_dma_contig_cleanup_ctx(dev->alloc_ctx[0]);
 	vb2_dma_contig_cleanup_ctx(dev->alloc_ctx[1]);
+	vb2_dma_contig_clear_max_seg_size(dev->mem_dev_l);
+	vb2_dma_contig_clear_max_seg_size(dev->mem_dev_r);
 	if (pdev->dev.of_node) {
 		put_device(dev->mem_dev_l);
 		put_device(dev->mem_dev_r);
diff --git a/drivers/media/platform/s5p-tv/mixer_video.c b/drivers/media/platform/s5p-tv/mixer_video.c
index 7ab5578..123d271 100644
--- a/drivers/media/platform/s5p-tv/mixer_video.c
+++ b/drivers/media/platform/s5p-tv/mixer_video.c
@@ -80,6 +80,7 @@ int mxr_acquire_video(struct mxr_device *mdev,
 		goto fail;
 	}
 
+	vb2_dma_contig_set_max_seg_size(mdev->dev, DMA_BIT_MASK(32));
 	mdev->alloc_ctx = vb2_dma_contig_init_ctx(mdev->dev);
 	if (IS_ERR(mdev->alloc_ctx)) {
 		mxr_err(mdev, "could not acquire vb2 allocator\n");
@@ -152,6 +153,7 @@ void mxr_release_video(struct mxr_device *mdev)
 		kfree(mdev->output[i]);
 
 	vb2_dma_contig_cleanup_ctx(mdev->alloc_ctx);
+	vb2_dma_contig_clear_max_seg_size(mdev->dev);
 	v4l2_device_unregister(&mdev->v4l2_dev);
 }
 
-- 
1.9.2

