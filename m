Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud3.xs4all.net ([194.109.24.26]:42143 "EHLO
	lb2-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751911AbcDWLEO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 23 Apr 2016 07:04:14 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCHv4 12/13] media/platform: convert drivers to use the new vb2_queue dev field
Date: Sat, 23 Apr 2016 13:03:48 +0200
Message-Id: <1461409429-24995-13-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1461409429-24995-1-git-send-email-hverkuil@xs4all.nl>
References: <1461409429-24995-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Stop using alloc_ctx and just fill in the device pointer.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>
---
 drivers/media/platform/exynos4-is/fimc-capture.c   |  7 ++-----
 drivers/media/platform/exynos4-is/fimc-core.c      | 11 -----------
 drivers/media/platform/exynos4-is/fimc-core.h      |  3 ---
 drivers/media/platform/exynos4-is/fimc-is.c        | 13 +------------
 drivers/media/platform/exynos4-is/fimc-is.h        |  2 --
 drivers/media/platform/exynos4-is/fimc-isp-video.c |  9 +++------
 drivers/media/platform/exynos4-is/fimc-isp.h       |  2 --
 drivers/media/platform/exynos4-is/fimc-lite.c      | 19 +++----------------
 drivers/media/platform/exynos4-is/fimc-lite.h      |  2 --
 drivers/media/platform/exynos4-is/fimc-m2m.c       |  6 +++---
 drivers/media/platform/s5p-mfc/s5p_mfc.c           | 19 +------------------
 drivers/media/platform/s5p-mfc/s5p_mfc_common.h    |  2 --
 drivers/media/platform/s5p-mfc/s5p_mfc_dec.c       | 10 ++++------
 drivers/media/platform/s5p-mfc/s5p_mfc_enc.c       | 14 +++++---------
 14 files changed, 22 insertions(+), 97 deletions(-)

diff --git a/drivers/media/platform/exynos4-is/fimc-capture.c b/drivers/media/platform/exynos4-is/fimc-capture.c
index bf47d3b..512b254 100644
--- a/drivers/media/platform/exynos4-is/fimc-capture.c
+++ b/drivers/media/platform/exynos4-is/fimc-capture.c
@@ -354,11 +354,9 @@ static int queue_setup(struct vb2_queue *vq,
 	if (*num_planes) {
 		if (*num_planes != fmt->memplanes)
 			return -EINVAL;
-		for (i = 0; i < *num_planes; i++) {
+		for (i = 0; i < *num_planes; i++)
 			if (sizes[i] < (wh * fmt->depth[i]) / 8)
 				return -EINVAL;
-			allocators[i] = ctx->fimc_dev->alloc_ctx;
-		}
 		return 0;
 	}
 
@@ -371,8 +369,6 @@ static int queue_setup(struct vb2_queue *vq,
 			sizes[i] = frame->payload[i];
 		else
 			sizes[i] = max_t(u32, size, frame->payload[i]);
-
-		allocators[i] = ctx->fimc_dev->alloc_ctx;
 	}
 
 	return 0;
@@ -1779,6 +1775,7 @@ static int fimc_register_capture_device(struct fimc_dev *fimc,
 	q->buf_struct_size = sizeof(struct fimc_vid_buffer);
 	q->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
 	q->lock = &fimc->lock;
+	q->dev = &fimc->pdev->dev;
 
 	ret = vb2_queue_init(q);
 	if (ret)
diff --git a/drivers/media/platform/exynos4-is/fimc-core.c b/drivers/media/platform/exynos4-is/fimc-core.c
index b1c1cea..a767c76 100644
--- a/drivers/media/platform/exynos4-is/fimc-core.c
+++ b/drivers/media/platform/exynos4-is/fimc-core.c
@@ -1018,19 +1018,9 @@ static int fimc_probe(struct platform_device *pdev)
 			goto err_sd;
 	}
 
-	/* Initialize contiguous memory allocator */
-	fimc->alloc_ctx = vb2_dma_contig_init_ctx(dev);
-	if (IS_ERR(fimc->alloc_ctx)) {
-		ret = PTR_ERR(fimc->alloc_ctx);
-		goto err_gclk;
-	}
-
 	dev_dbg(dev, "FIMC.%d registered successfully\n", fimc->id);
 	return 0;
 
-err_gclk:
-	if (!pm_runtime_enabled(dev))
-		clk_disable(fimc->clock[CLK_GATE]);
 err_sd:
 	fimc_unregister_capture_subdev(fimc);
 err_sclk:
@@ -1123,7 +1113,6 @@ static int fimc_remove(struct platform_device *pdev)
 	pm_runtime_set_suspended(&pdev->dev);
 
 	fimc_unregister_capture_subdev(fimc);
-	vb2_dma_contig_cleanup_ctx(fimc->alloc_ctx);
 
 	clk_disable(fimc->clock[CLK_BUS]);
 	fimc_clk_put(fimc);
diff --git a/drivers/media/platform/exynos4-is/fimc-core.h b/drivers/media/platform/exynos4-is/fimc-core.h
index 6b74354..5615fef 100644
--- a/drivers/media/platform/exynos4-is/fimc-core.h
+++ b/drivers/media/platform/exynos4-is/fimc-core.h
@@ -307,7 +307,6 @@ struct fimc_m2m_device {
  */
 struct fimc_vid_cap {
 	struct fimc_ctx			*ctx;
-	struct vb2_alloc_ctx		*alloc_ctx;
 	struct v4l2_subdev		subdev;
 	struct exynos_video_entity	ve;
 	struct media_pad		vd_pad;
@@ -417,7 +416,6 @@ struct fimc_ctx;
  * @m2m:	memory-to-memory V4L2 device information
  * @vid_cap:	camera capture device information
  * @state:	flags used to synchronize m2m and capture mode operation
- * @alloc_ctx:	videobuf2 memory allocator context
  * @pipeline:	fimc video capture pipeline data structure
  */
 struct fimc_dev {
@@ -436,7 +434,6 @@ struct fimc_dev {
 	struct fimc_m2m_device		m2m;
 	struct fimc_vid_cap		vid_cap;
 	unsigned long			state;
-	struct vb2_alloc_ctx		*alloc_ctx;
 };
 
 /**
diff --git a/drivers/media/platform/exynos4-is/fimc-is.c b/drivers/media/platform/exynos4-is/fimc-is.c
index 979c388..4456c84 100644
--- a/drivers/media/platform/exynos4-is/fimc-is.c
+++ b/drivers/media/platform/exynos4-is/fimc-is.c
@@ -204,9 +204,6 @@ static int fimc_is_register_subdevs(struct fimc_is *is)
 	if (ret < 0)
 		return ret;
 
-	/* Initialize memory allocator context for the ISP DMA. */
-	is->isp.alloc_ctx = is->alloc_ctx;
-
 	for_each_compatible_node(i2c_bus, NULL, FIMC_IS_I2C_COMPATIBLE) {
 		for_each_available_child_of_node(i2c_bus, child) {
 			ret = fimc_is_parse_sensor_config(is, index, child);
@@ -847,18 +844,13 @@ static int fimc_is_probe(struct platform_device *pdev)
 	if (ret < 0)
 		goto err_pm;
 
-	is->alloc_ctx = vb2_dma_contig_init_ctx(dev);
-	if (IS_ERR(is->alloc_ctx)) {
-		ret = PTR_ERR(is->alloc_ctx);
-		goto err_pm;
-	}
 	/*
 	 * Register FIMC-IS V4L2 subdevs to this driver. The video nodes
 	 * will be created within the subdev's registered() callback.
 	 */
 	ret = fimc_is_register_subdevs(is);
 	if (ret < 0)
-		goto err_vb;
+		goto err_pm;
 
 	ret = fimc_is_debugfs_create(is);
 	if (ret < 0)
@@ -877,8 +869,6 @@ err_dfs:
 	fimc_is_debugfs_remove(is);
 err_sd:
 	fimc_is_unregister_subdevs(is);
-err_vb:
-	vb2_dma_contig_cleanup_ctx(is->alloc_ctx);
 err_pm:
 	if (!pm_runtime_enabled(dev))
 		fimc_is_runtime_suspend(dev);
@@ -939,7 +929,6 @@ static int fimc_is_remove(struct platform_device *pdev)
 		fimc_is_runtime_suspend(dev);
 	free_irq(is->irq, is);
 	fimc_is_unregister_subdevs(is);
-	vb2_dma_contig_cleanup_ctx(is->alloc_ctx);
 	fimc_is_put_clocks(is);
 	fimc_is_debugfs_remove(is);
 	release_firmware(is->fw.f_w);
diff --git a/drivers/media/platform/exynos4-is/fimc-is.h b/drivers/media/platform/exynos4-is/fimc-is.h
index 386eb49..3a82c6a 100644
--- a/drivers/media/platform/exynos4-is/fimc-is.h
+++ b/drivers/media/platform/exynos4-is/fimc-is.h
@@ -233,7 +233,6 @@ struct chain_config {
  * @pdev: pointer to FIMC-IS platform device
  * @pctrl: pointer to pinctrl structure for this device
  * @v4l2_dev: pointer to top the level v4l2_device
- * @alloc_ctx: videobuf2 memory allocator context
  * @lock: mutex serializing video device and the subdev operations
  * @slock: spinlock protecting this data structure and the hw registers
  * @clocks: FIMC-LITE gate clock
@@ -256,7 +255,6 @@ struct fimc_is {
 	struct fimc_is_sensor		sensor[FIMC_IS_SENSORS_NUM];
 	struct fimc_is_setfile		setfile;
 
-	struct vb2_alloc_ctx		*alloc_ctx;
 	struct v4l2_ctrl_handler	ctrl_handler;
 
 	struct mutex			lock;
diff --git a/drivers/media/platform/exynos4-is/fimc-isp-video.c b/drivers/media/platform/exynos4-is/fimc-isp-video.c
index c081672..abc3389 100644
--- a/drivers/media/platform/exynos4-is/fimc-isp-video.c
+++ b/drivers/media/platform/exynos4-is/fimc-isp-video.c
@@ -57,20 +57,16 @@ static int isp_video_capture_queue_setup(struct vb2_queue *vq,
 	if (*num_planes) {
 		if (*num_planes != fmt->memplanes)
 			return -EINVAL;
-		for (i = 0; i < *num_planes; i++) {
+		for (i = 0; i < *num_planes; i++)
 			if (sizes[i] < (wh * fmt->depth[i]) / 8)
 				return -EINVAL;
-			allocators[i] = isp->alloc_ctx;
-		}
 		return 0;
 	}
 
 	*num_planes = fmt->memplanes;
 
-	for (i = 0; i < fmt->memplanes; i++) {
+	for (i = 0; i < fmt->memplanes; i++)
 		sizes[i] = (wh * fmt->depth[i]) / 8;
-		allocators[i] = isp->alloc_ctx;
-	}
 
 	return 0;
 }
@@ -597,6 +593,7 @@ int fimc_isp_video_device_register(struct fimc_isp *isp,
 	q->drv_priv = isp;
 	q->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
 	q->lock = &isp->video_lock;
+	q->dev = &isp->pdev->dev;
 
 	ret = vb2_queue_init(q);
 	if (ret < 0)
diff --git a/drivers/media/platform/exynos4-is/fimc-isp.h b/drivers/media/platform/exynos4-is/fimc-isp.h
index e0686b5..3cdd524 100644
--- a/drivers/media/platform/exynos4-is/fimc-isp.h
+++ b/drivers/media/platform/exynos4-is/fimc-isp.h
@@ -148,7 +148,6 @@ struct fimc_is_video {
 /**
  * struct fimc_isp - FIMC-IS ISP data structure
  * @pdev: pointer to FIMC-IS platform device
- * @alloc_ctx: videobuf2 memory allocator context
  * @subdev: ISP v4l2_subdev
  * @subdev_pads: the ISP subdev media pads
  * @test_pattern: test pattern controls
@@ -161,7 +160,6 @@ struct fimc_is_video {
  */
 struct fimc_isp {
 	struct platform_device		*pdev;
-	struct vb2_alloc_ctx		*alloc_ctx;
 	struct v4l2_subdev		subdev;
 	struct media_pad		subdev_pads[FIMC_ISP_SD_PADS_NUM];
 	struct v4l2_mbus_framefmt	src_fmt;
diff --git a/drivers/media/platform/exynos4-is/fimc-lite.c b/drivers/media/platform/exynos4-is/fimc-lite.c
index dc1b929..b2d3f98 100644
--- a/drivers/media/platform/exynos4-is/fimc-lite.c
+++ b/drivers/media/platform/exynos4-is/fimc-lite.c
@@ -371,20 +371,16 @@ static int queue_setup(struct vb2_queue *vq,
 	if (*num_planes) {
 		if (*num_planes != fmt->memplanes)
 			return -EINVAL;
-		for (i = 0; i < *num_planes; i++) {
+		for (i = 0; i < *num_planes; i++)
 			if (sizes[i] < (wh * fmt->depth[i]) / 8)
 				return -EINVAL;
-			allocators[i] = fimc->alloc_ctx;
-		}
 		return 0;
 	}
 
 	*num_planes = fmt->memplanes;
 
-	for (i = 0; i < fmt->memplanes; i++) {
+	for (i = 0; i < fmt->memplanes; i++)
 		sizes[i] = (wh * fmt->depth[i]) / 8;
-		allocators[i] = fimc->alloc_ctx;
-	}
 
 	return 0;
 }
@@ -1300,6 +1296,7 @@ static int fimc_lite_subdev_registered(struct v4l2_subdev *sd)
 	q->drv_priv = fimc;
 	q->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
 	q->lock = &fimc->lock;
+	q->dev = &fimc->pdev->dev;
 
 	ret = vb2_queue_init(q);
 	if (ret < 0)
@@ -1551,21 +1548,12 @@ static int fimc_lite_probe(struct platform_device *pdev)
 			goto err_sd;
 	}
 
-	fimc->alloc_ctx = vb2_dma_contig_init_ctx(dev);
-	if (IS_ERR(fimc->alloc_ctx)) {
-		ret = PTR_ERR(fimc->alloc_ctx);
-		goto err_clk_dis;
-	}
-
 	fimc_lite_set_default_config(fimc);
 
 	dev_dbg(dev, "FIMC-LITE.%d registered successfully\n",
 		fimc->index);
 	return 0;
 
-err_clk_dis:
-	if (!pm_runtime_enabled(dev))
-		clk_disable(fimc->clock);
 err_sd:
 	fimc_lite_unregister_capture_subdev(fimc);
 err_clk_put:
@@ -1651,7 +1639,6 @@ static int fimc_lite_remove(struct platform_device *pdev)
 	pm_runtime_disable(dev);
 	pm_runtime_set_suspended(dev);
 	fimc_lite_unregister_capture_subdev(fimc);
-	vb2_dma_contig_cleanup_ctx(fimc->alloc_ctx);
 	fimc_lite_clk_put(fimc);
 
 	dev_info(dev, "Driver unloaded\n");
diff --git a/drivers/media/platform/exynos4-is/fimc-lite.h b/drivers/media/platform/exynos4-is/fimc-lite.h
index 11690d5..9ae1e96 100644
--- a/drivers/media/platform/exynos4-is/fimc-lite.h
+++ b/drivers/media/platform/exynos4-is/fimc-lite.h
@@ -113,7 +113,6 @@ struct flite_buffer {
  * @ve: exynos video device entity structure
  * @v4l2_dev: pointer to top the level v4l2_device
  * @fh: v4l2 file handle
- * @alloc_ctx: videobuf2 memory allocator context
  * @subdev: FIMC-LITE subdev
  * @vd_pad: media (sink) pad for the capture video node
  * @subdev_pads: the subdev media pads
@@ -148,7 +147,6 @@ struct fimc_lite {
 	struct exynos_video_entity ve;
 	struct v4l2_device	*v4l2_dev;
 	struct v4l2_fh		fh;
-	struct vb2_alloc_ctx	*alloc_ctx;
 	struct v4l2_subdev	subdev;
 	struct media_pad	vd_pad;
 	struct media_pad	subdev_pads[FLITE_SD_PADS_NUM];
diff --git a/drivers/media/platform/exynos4-is/fimc-m2m.c b/drivers/media/platform/exynos4-is/fimc-m2m.c
index 55ec4c9..365f06e 100644
--- a/drivers/media/platform/exynos4-is/fimc-m2m.c
+++ b/drivers/media/platform/exynos4-is/fimc-m2m.c
@@ -195,10 +195,8 @@ static int fimc_queue_setup(struct vb2_queue *vq,
 		return -EINVAL;
 
 	*num_planes = f->fmt->memplanes;
-	for (i = 0; i < f->fmt->memplanes; i++) {
+	for (i = 0; i < f->fmt->memplanes; i++)
 		sizes[i] = f->payload[i];
-		allocators[i] = ctx->fimc_dev->alloc_ctx;
-	}
 	return 0;
 }
 
@@ -562,6 +560,7 @@ static int queue_init(void *priv, struct vb2_queue *src_vq,
 	src_vq->buf_struct_size = sizeof(struct v4l2_m2m_buffer);
 	src_vq->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_COPY;
 	src_vq->lock = &ctx->fimc_dev->lock;
+	src_vq->dev = &ctx->fimc_dev->pdev->dev;
 
 	ret = vb2_queue_init(src_vq);
 	if (ret)
@@ -575,6 +574,7 @@ static int queue_init(void *priv, struct vb2_queue *src_vq,
 	dst_vq->buf_struct_size = sizeof(struct v4l2_m2m_buffer);
 	dst_vq->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_COPY;
 	dst_vq->lock = &ctx->fimc_dev->lock;
+	dst_vq->dev = &ctx->fimc_dev->pdev->dev;
 
 	return vb2_queue_init(dst_vq);
 }
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc.c b/drivers/media/platform/s5p-mfc/s5p_mfc.c
index b16466f..a6bfcef 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc.c
@@ -1164,22 +1164,11 @@ static int s5p_mfc_probe(struct platform_device *pdev)
 		}
 	}
 
-	dev->alloc_ctx[0] = vb2_dma_contig_init_ctx(dev->mem_dev_l);
-	if (IS_ERR(dev->alloc_ctx[0])) {
-		ret = PTR_ERR(dev->alloc_ctx[0]);
-		goto err_res;
-	}
-	dev->alloc_ctx[1] = vb2_dma_contig_init_ctx(dev->mem_dev_r);
-	if (IS_ERR(dev->alloc_ctx[1])) {
-		ret = PTR_ERR(dev->alloc_ctx[1]);
-		goto err_mem_init_ctx_1;
-	}
-
 	mutex_init(&dev->mfc_mutex);
 
 	ret = s5p_mfc_alloc_firmware(dev);
 	if (ret)
-		goto err_alloc_fw;
+		goto err_res;
 
 	ret = v4l2_device_register(&pdev->dev, &dev->v4l2_dev);
 	if (ret)
@@ -1264,10 +1253,6 @@ err_dec_alloc:
 	v4l2_device_unregister(&dev->v4l2_dev);
 err_v4l2_dev_reg:
 	s5p_mfc_release_firmware(dev);
-err_alloc_fw:
-	vb2_dma_contig_cleanup_ctx(dev->alloc_ctx[1]);
-err_mem_init_ctx_1:
-	vb2_dma_contig_cleanup_ctx(dev->alloc_ctx[0]);
 err_res:
 	s5p_mfc_final_pm(dev);
 
@@ -1291,8 +1276,6 @@ static int s5p_mfc_remove(struct platform_device *pdev)
 	video_unregister_device(dev->vfd_dec);
 	v4l2_device_unregister(&dev->v4l2_dev);
 	s5p_mfc_release_firmware(dev);
-	vb2_dma_contig_cleanup_ctx(dev->alloc_ctx[0]);
-	vb2_dma_contig_cleanup_ctx(dev->alloc_ctx[1]);
 	if (pdev->dev.of_node) {
 		put_device(dev->mem_dev_l);
 		put_device(dev->mem_dev_r);
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_common.h b/drivers/media/platform/s5p-mfc/s5p_mfc_common.h
index 9eb2481..1ce379a 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_common.h
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_common.h
@@ -285,7 +285,6 @@ struct s5p_mfc_priv_buf {
  * @watchdog_cnt:	counter for the watchdog
  * @watchdog_workqueue:	workqueue for the watchdog
  * @watchdog_work:	worker for the watchdog
- * @alloc_ctx:		videobuf2 allocator contexts for two memory banks
  * @enter_suspend:	flag set when entering suspend
  * @ctx_buf:		common context memory (MFCv6)
  * @warn_start:		hardware error code from which warnings start
@@ -328,7 +327,6 @@ struct s5p_mfc_dev {
 	struct timer_list watchdog_timer;
 	struct workqueue_struct *watchdog_workqueue;
 	struct work_struct watchdog_work;
-	void *alloc_ctx[2];
 	unsigned long enter_suspend;
 
 	struct s5p_mfc_priv_buf ctx_buf;
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c b/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
index f2d6376..7e7c11c 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
@@ -931,16 +931,14 @@ static int s5p_mfc_queue_setup(struct vb2_queue *vq,
 		psize[1] = ctx->chroma_size;
 
 		if (IS_MFCV6_PLUS(dev))
-			allocators[0] =
-				ctx->dev->alloc_ctx[MFC_BANK1_ALLOC_CTX];
+			allocators[0] = &ctx->dev->mem_dev_l;
 		else
-			allocators[0] =
-				ctx->dev->alloc_ctx[MFC_BANK2_ALLOC_CTX];
-		allocators[1] = ctx->dev->alloc_ctx[MFC_BANK1_ALLOC_CTX];
+			allocators[0] = &ctx->dev->mem_dev_r;
+		allocators[1] = &ctx->dev->mem_dev_l;
 	} else if (vq->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE &&
 		   ctx->state == MFCINST_INIT) {
 		psize[0] = ctx->dec_src_buf_size;
-		allocators[0] = ctx->dev->alloc_ctx[MFC_BANK1_ALLOC_CTX];
+		allocators[0] = &ctx->dev->mem_dev_l;
 	} else {
 		mfc_err("This video node is dedicated to decoding. Decoding not initialized\n");
 		return -EINVAL;
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c b/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
index 034b5c1..0314c78 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
@@ -1837,7 +1837,7 @@ static int s5p_mfc_queue_setup(struct vb2_queue *vq,
 		if (*buf_count > MFC_MAX_BUFFERS)
 			*buf_count = MFC_MAX_BUFFERS;
 		psize[0] = ctx->enc_dst_buf_size;
-		allocators[0] = ctx->dev->alloc_ctx[MFC_BANK1_ALLOC_CTX];
+		allocators[0] = &ctx->dev->mem_dev_l;
 	} else if (vq->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) {
 		if (ctx->src_fmt)
 			*plane_count = ctx->src_fmt->num_planes;
@@ -1853,15 +1853,11 @@ static int s5p_mfc_queue_setup(struct vb2_queue *vq,
 		psize[1] = ctx->chroma_size;
 
 		if (IS_MFCV6_PLUS(dev)) {
-			allocators[0] =
-				ctx->dev->alloc_ctx[MFC_BANK1_ALLOC_CTX];
-			allocators[1] =
-				ctx->dev->alloc_ctx[MFC_BANK1_ALLOC_CTX];
+			allocators[0] = &ctx->dev->mem_dev_l;
+			allocators[1] = &ctx->dev->mem_dev_l;
 		} else {
-			allocators[0] =
-				ctx->dev->alloc_ctx[MFC_BANK2_ALLOC_CTX];
-			allocators[1] =
-				ctx->dev->alloc_ctx[MFC_BANK2_ALLOC_CTX];
+			allocators[0] = &ctx->dev->mem_dev_r;
+			allocators[1] = &ctx->dev->mem_dev_r;
 		}
 	} else {
 		mfc_err("invalid queue type: %d\n", vq->type);
-- 
2.8.0.rc3

