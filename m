Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:37576 "EHLO
	lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751784AbcF0Nc3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 27 Jun 2016 09:32:29 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCHv5 11/13] media/platform: convert drivers to use the new vb2_queue dev field
Date: Mon, 27 Jun 2016 15:32:02 +0200
Message-Id: <1467034324-37626-12-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1467034324-37626-1-git-send-email-hverkuil@xs4all.nl>
References: <1467034324-37626-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Stop using alloc_ctx and just fill in the device pointer.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>
---
 drivers/media/platform/exynos-gsc/gsc-core.c     | 10 +---------
 drivers/media/platform/exynos-gsc/gsc-core.h     |  1 -
 drivers/media/platform/exynos-gsc/gsc-m2m.c      |  6 +++---
 drivers/media/platform/s3c-camif/camif-capture.c |  3 +--
 drivers/media/platform/s3c-camif/camif-core.c    | 11 +----------
 drivers/media/platform/s3c-camif/camif-core.h    |  2 --
 drivers/media/platform/s5p-g2d/g2d.c             | 13 +++----------
 drivers/media/platform/s5p-g2d/g2d.h             |  1 -
 drivers/media/platform/s5p-jpeg/jpeg-core.c      | 17 ++++-------------
 drivers/media/platform/s5p-jpeg/jpeg-core.h      |  2 --
 drivers/media/platform/s5p-tv/mixer.h            |  2 --
 drivers/media/platform/s5p-tv/mixer_video.c      | 15 ++-------------
 12 files changed, 15 insertions(+), 68 deletions(-)

diff --git a/drivers/media/platform/exynos-gsc/gsc-core.c b/drivers/media/platform/exynos-gsc/gsc-core.c
index c9d2009..787bd16 100644
--- a/drivers/media/platform/exynos-gsc/gsc-core.c
+++ b/drivers/media/platform/exynos-gsc/gsc-core.c
@@ -1123,20 +1123,13 @@ static int gsc_probe(struct platform_device *pdev)
 	if (ret < 0)
 		goto err_m2m;
 
-	/* Initialize continious memory allocator */
 	vb2_dma_contig_set_max_seg_size(dev, DMA_BIT_MASK(32));
-	gsc->alloc_ctx = vb2_dma_contig_init_ctx(dev);
-	if (IS_ERR(gsc->alloc_ctx)) {
-		ret = PTR_ERR(gsc->alloc_ctx);
-		goto err_pm;
-	}
 
 	dev_dbg(dev, "gsc-%d registered successfully\n", gsc->id);
 
 	pm_runtime_put(dev);
 	return 0;
-err_pm:
-	pm_runtime_put(dev);
+
 err_m2m:
 	gsc_unregister_m2m_device(gsc);
 err_v4l2:
@@ -1153,7 +1146,6 @@ static int gsc_remove(struct platform_device *pdev)
 	gsc_unregister_m2m_device(gsc);
 	v4l2_device_unregister(&gsc->v4l2_dev);
 
-	vb2_dma_contig_cleanup_ctx(gsc->alloc_ctx);
 	vb2_dma_contig_clear_max_seg_size(&pdev->dev);
 	pm_runtime_disable(&pdev->dev);
 	gsc_clk_put(gsc);
diff --git a/drivers/media/platform/exynos-gsc/gsc-core.h b/drivers/media/platform/exynos-gsc/gsc-core.h
index ec4000c..5c48329 100644
--- a/drivers/media/platform/exynos-gsc/gsc-core.h
+++ b/drivers/media/platform/exynos-gsc/gsc-core.h
@@ -341,7 +341,6 @@ struct gsc_dev {
 	wait_queue_head_t		irq_queue;
 	struct gsc_m2m_device		m2m;
 	unsigned long			state;
-	struct vb2_alloc_ctx		*alloc_ctx;
 	struct video_device		vdev;
 	struct v4l2_device		v4l2_dev;
 };
diff --git a/drivers/media/platform/exynos-gsc/gsc-m2m.c b/drivers/media/platform/exynos-gsc/gsc-m2m.c
index a600e32..622709c 100644
--- a/drivers/media/platform/exynos-gsc/gsc-m2m.c
+++ b/drivers/media/platform/exynos-gsc/gsc-m2m.c
@@ -227,10 +227,8 @@ static int gsc_m2m_queue_setup(struct vb2_queue *vq,
 		return -EINVAL;
 
 	*num_planes = frame->fmt->num_planes;
-	for (i = 0; i < frame->fmt->num_planes; i++) {
+	for (i = 0; i < frame->fmt->num_planes; i++)
 		sizes[i] = frame->payload[i];
-		allocators[i] = ctx->gsc_dev->alloc_ctx;
-	}
 	return 0;
 }
 
@@ -591,6 +589,7 @@ static int queue_init(void *priv, struct vb2_queue *src_vq,
 	src_vq->buf_struct_size = sizeof(struct v4l2_m2m_buffer);
 	src_vq->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_COPY;
 	src_vq->lock = &ctx->gsc_dev->lock;
+	src_vq->dev = &ctx->gsc_dev->pdev->dev;
 
 	ret = vb2_queue_init(src_vq);
 	if (ret)
@@ -605,6 +604,7 @@ static int queue_init(void *priv, struct vb2_queue *src_vq,
 	dst_vq->buf_struct_size = sizeof(struct v4l2_m2m_buffer);
 	dst_vq->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_COPY;
 	dst_vq->lock = &ctx->gsc_dev->lock;
+	dst_vq->dev = &ctx->gsc_dev->pdev->dev;
 
 	return vb2_queue_init(dst_vq);
 }
diff --git a/drivers/media/platform/s3c-camif/camif-capture.c b/drivers/media/platform/s3c-camif/camif-capture.c
index bd060ef..5eb5df1 100644
--- a/drivers/media/platform/s3c-camif/camif-capture.c
+++ b/drivers/media/platform/s3c-camif/camif-capture.c
@@ -440,7 +440,6 @@ static int queue_setup(struct vb2_queue *vq,
 		       unsigned int sizes[], void *allocators[])
 {
 	struct camif_vp *vp = vb2_get_drv_priv(vq);
-	struct camif_dev *camif = vp->camif;
 	struct camif_frame *frame = &vp->out_frame;
 	const struct camif_fmt *fmt = vp->out_fmt;
 	unsigned int size;
@@ -449,7 +448,6 @@ static int queue_setup(struct vb2_queue *vq,
 		return -EINVAL;
 
 	size = (frame->f_width * frame->f_height * fmt->depth) / 8;
-	allocators[0] = camif->alloc_ctx;
 
 	if (*num_planes)
 		return sizes[0] < size ? -EINVAL : 0;
@@ -1138,6 +1136,7 @@ int s3c_camif_register_video_node(struct camif_dev *camif, int idx)
 	q->drv_priv = vp;
 	q->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
 	q->lock = &vp->camif->lock;
+	q->dev = camif->v4l2_dev.dev;
 
 	ret = vb2_queue_init(q);
 	if (ret)
diff --git a/drivers/media/platform/s3c-camif/camif-core.c b/drivers/media/platform/s3c-camif/camif-core.c
index af237af..ec40019 100644
--- a/drivers/media/platform/s3c-camif/camif-core.c
+++ b/drivers/media/platform/s3c-camif/camif-core.c
@@ -474,16 +474,9 @@ static int s3c_camif_probe(struct platform_device *pdev)
 	if (ret < 0)
 		goto err_pm;
 
-	/* Initialize contiguous memory allocator */
-	camif->alloc_ctx = vb2_dma_contig_init_ctx(dev);
-	if (IS_ERR(camif->alloc_ctx)) {
-		ret = PTR_ERR(camif->alloc_ctx);
-		goto err_alloc;
-	}
-
 	ret = camif_media_dev_init(camif);
 	if (ret < 0)
-		goto err_mdev;
+		goto err_alloc;
 
 	ret = camif_register_sensor(camif);
 	if (ret < 0)
@@ -517,8 +510,6 @@ err_sens:
 	media_device_unregister(&camif->media_dev);
 	media_device_cleanup(&camif->media_dev);
 	camif_unregister_media_entities(camif);
-err_mdev:
-	vb2_dma_contig_cleanup_ctx(camif->alloc_ctx);
 err_alloc:
 	pm_runtime_put(dev);
 	pm_runtime_disable(dev);
diff --git a/drivers/media/platform/s3c-camif/camif-core.h b/drivers/media/platform/s3c-camif/camif-core.h
index 57cbc3d..1f5c8c9 100644
--- a/drivers/media/platform/s3c-camif/camif-core.h
+++ b/drivers/media/platform/s3c-camif/camif-core.h
@@ -254,7 +254,6 @@ struct camif_vp {
  * @ctrl_handler: v4l2 control handler (owned by @subdev)
  * @test_pattern: test pattern controls
  * @vp:           video path (DMA) description (codec/preview)
- * @alloc_ctx:    memory buffer allocator context
  * @variant:      variant information for this device
  * @dev:	  pointer to the CAMIF device struct
  * @pdata:	  a copy of the driver's platform data
@@ -291,7 +290,6 @@ struct camif_dev {
 	u8				colorfx_cr;
 
 	struct camif_vp			vp[CAMIF_VP_NUM];
-	struct vb2_alloc_ctx		*alloc_ctx;
 
 	const struct s3c_camif_variant	*variant;
 	struct device			*dev;
diff --git a/drivers/media/platform/s5p-g2d/g2d.c b/drivers/media/platform/s5p-g2d/g2d.c
index d3e3469..2aeb950 100644
--- a/drivers/media/platform/s5p-g2d/g2d.c
+++ b/drivers/media/platform/s5p-g2d/g2d.c
@@ -113,7 +113,6 @@ static int g2d_queue_setup(struct vb2_queue *vq,
 
 	sizes[0] = f->size;
 	*nplanes = 1;
-	alloc_ctxs[0] = ctx->dev->alloc_ctx;
 
 	if (*nbuffers == 0)
 		*nbuffers = 1;
@@ -159,6 +158,7 @@ static int queue_init(void *priv, struct vb2_queue *src_vq,
 	src_vq->buf_struct_size = sizeof(struct v4l2_m2m_buffer);
 	src_vq->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_COPY;
 	src_vq->lock = &ctx->dev->mutex;
+	src_vq->dev = ctx->dev->v4l2_dev.dev;
 
 	ret = vb2_queue_init(src_vq);
 	if (ret)
@@ -172,6 +172,7 @@ static int queue_init(void *priv, struct vb2_queue *src_vq,
 	dst_vq->buf_struct_size = sizeof(struct v4l2_m2m_buffer);
 	dst_vq->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_COPY;
 	dst_vq->lock = &ctx->dev->mutex;
+	dst_vq->dev = ctx->dev->v4l2_dev.dev;
 
 	return vb2_queue_init(dst_vq);
 }
@@ -682,15 +683,10 @@ static int g2d_probe(struct platform_device *pdev)
 	}
 
 	vb2_dma_contig_set_max_seg_size(&pdev->dev, DMA_BIT_MASK(32));
-	dev->alloc_ctx = vb2_dma_contig_init_ctx(&pdev->dev);
-	if (IS_ERR(dev->alloc_ctx)) {
-		ret = PTR_ERR(dev->alloc_ctx);
-		goto unprep_clk_gate;
-	}
 
 	ret = v4l2_device_register(&pdev->dev, &dev->v4l2_dev);
 	if (ret)
-		goto alloc_ctx_cleanup;
+		goto unprep_clk_gate;
 	vfd = video_device_alloc();
 	if (!vfd) {
 		v4l2_err(&dev->v4l2_dev, "Failed to allocate video device\n");
@@ -735,8 +731,6 @@ rel_vdev:
 	video_device_release(vfd);
 unreg_v4l2_dev:
 	v4l2_device_unregister(&dev->v4l2_dev);
-alloc_ctx_cleanup:
-	vb2_dma_contig_cleanup_ctx(dev->alloc_ctx);
 unprep_clk_gate:
 	clk_unprepare(dev->gate);
 put_clk_gate:
@@ -757,7 +751,6 @@ static int g2d_remove(struct platform_device *pdev)
 	v4l2_m2m_release(dev->m2m_dev);
 	video_unregister_device(dev->vfd);
 	v4l2_device_unregister(&dev->v4l2_dev);
-	vb2_dma_contig_cleanup_ctx(dev->alloc_ctx);
 	vb2_dma_contig_clear_max_seg_size(&pdev->dev);
 	clk_unprepare(dev->gate);
 	clk_put(dev->gate);
diff --git a/drivers/media/platform/s5p-g2d/g2d.h b/drivers/media/platform/s5p-g2d/g2d.h
index e31df54..dd812b5 100644
--- a/drivers/media/platform/s5p-g2d/g2d.h
+++ b/drivers/media/platform/s5p-g2d/g2d.h
@@ -25,7 +25,6 @@ struct g2d_dev {
 	struct mutex		mutex;
 	spinlock_t		ctrl_lock;
 	atomic_t		num_inst;
-	struct vb2_alloc_ctx	*alloc_ctx;
 	void __iomem		*regs;
 	struct clk		*clk;
 	struct clk		*gate;
diff --git a/drivers/media/platform/s5p-jpeg/jpeg-core.c b/drivers/media/platform/s5p-jpeg/jpeg-core.c
index 17bc94092..d8842c4 100644
--- a/drivers/media/platform/s5p-jpeg/jpeg-core.c
+++ b/drivers/media/platform/s5p-jpeg/jpeg-core.c
@@ -2457,7 +2457,6 @@ static int s5p_jpeg_queue_setup(struct vb2_queue *vq,
 	*nbuffers = count;
 	*nplanes = 1;
 	sizes[0] = size;
-	alloc_ctxs[0] = ctx->jpeg->alloc_ctx;
 
 	return 0;
 }
@@ -2563,6 +2562,7 @@ static int queue_init(void *priv, struct vb2_queue *src_vq,
 	src_vq->mem_ops = &vb2_dma_contig_memops;
 	src_vq->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_COPY;
 	src_vq->lock = &ctx->jpeg->lock;
+	src_vq->dev = ctx->jpeg->dev;
 
 	ret = vb2_queue_init(src_vq);
 	if (ret)
@@ -2576,6 +2576,7 @@ static int queue_init(void *priv, struct vb2_queue *src_vq,
 	dst_vq->mem_ops = &vb2_dma_contig_memops;
 	dst_vq->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_COPY;
 	dst_vq->lock = &ctx->jpeg->lock;
+	dst_vq->dev = ctx->jpeg->dev;
 
 	return vb2_queue_init(dst_vq);
 }
@@ -2844,19 +2845,13 @@ static int s5p_jpeg_probe(struct platform_device *pdev)
 	}
 
 	vb2_dma_contig_set_max_seg_size(&pdev->dev, DMA_BIT_MASK(32));
-	jpeg->alloc_ctx = vb2_dma_contig_init_ctx(&pdev->dev);
-	if (IS_ERR(jpeg->alloc_ctx)) {
-		v4l2_err(&jpeg->v4l2_dev, "Failed to init memory allocator\n");
-		ret = PTR_ERR(jpeg->alloc_ctx);
-		goto m2m_init_rollback;
-	}
 
 	/* JPEG encoder /dev/videoX node */
 	jpeg->vfd_encoder = video_device_alloc();
 	if (!jpeg->vfd_encoder) {
 		v4l2_err(&jpeg->v4l2_dev, "Failed to allocate video device\n");
 		ret = -ENOMEM;
-		goto vb2_allocator_rollback;
+		goto m2m_init_rollback;
 	}
 	snprintf(jpeg->vfd_encoder->name, sizeof(jpeg->vfd_encoder->name),
 				"%s-enc", S5P_JPEG_M2M_NAME);
@@ -2872,7 +2867,7 @@ static int s5p_jpeg_probe(struct platform_device *pdev)
 	if (ret) {
 		v4l2_err(&jpeg->v4l2_dev, "Failed to register video device\n");
 		video_device_release(jpeg->vfd_encoder);
-		goto vb2_allocator_rollback;
+		goto m2m_init_rollback;
 	}
 
 	video_set_drvdata(jpeg->vfd_encoder, jpeg);
@@ -2921,9 +2916,6 @@ static int s5p_jpeg_probe(struct platform_device *pdev)
 enc_vdev_register_rollback:
 	video_unregister_device(jpeg->vfd_encoder);
 
-vb2_allocator_rollback:
-	vb2_dma_contig_cleanup_ctx(jpeg->alloc_ctx);
-
 m2m_init_rollback:
 	v4l2_m2m_release(jpeg->m2m_dev);
 
@@ -2942,7 +2934,6 @@ static int s5p_jpeg_remove(struct platform_device *pdev)
 
 	video_unregister_device(jpeg->vfd_decoder);
 	video_unregister_device(jpeg->vfd_encoder);
-	vb2_dma_contig_cleanup_ctx(jpeg->alloc_ctx);
 	vb2_dma_contig_clear_max_seg_size(&pdev->dev);
 	v4l2_m2m_release(jpeg->m2m_dev);
 	v4l2_device_unregister(&jpeg->v4l2_dev);
diff --git a/drivers/media/platform/s5p-jpeg/jpeg-core.h b/drivers/media/platform/s5p-jpeg/jpeg-core.h
index 9b1db09..4492a35 100644
--- a/drivers/media/platform/s5p-jpeg/jpeg-core.h
+++ b/drivers/media/platform/s5p-jpeg/jpeg-core.h
@@ -110,7 +110,6 @@ enum  exynos4_jpeg_img_quality_level {
  * @irq:		JPEG IP irq
  * @clocks:		JPEG IP clock(s)
  * @dev:		JPEG IP struct device
- * @alloc_ctx:		videobuf2 memory allocator's context
  * @variant:		driver variant to be used
  * @irq_status		interrupt flags set during single encode/decode
 			operation
@@ -130,7 +129,6 @@ struct s5p_jpeg {
 	enum exynos4_jpeg_result irq_ret;
 	struct clk		*clocks[JPEG_MAX_CLOCKS];
 	struct device		*dev;
-	void			*alloc_ctx;
 	struct s5p_jpeg_variant *variant;
 	u32			irq_status;
 };
diff --git a/drivers/media/platform/s5p-tv/mixer.h b/drivers/media/platform/s5p-tv/mixer.h
index 4dd62a9..869f0ce 100644
--- a/drivers/media/platform/s5p-tv/mixer.h
+++ b/drivers/media/platform/s5p-tv/mixer.h
@@ -245,8 +245,6 @@ struct mxr_device {
 
 	/** V4L2 device */
 	struct v4l2_device v4l2_dev;
-	/** context of allocator */
-	void *alloc_ctx;
 	/** event wait queue */
 	wait_queue_head_t event_queue;
 	/** state flags */
diff --git a/drivers/media/platform/s5p-tv/mixer_video.c b/drivers/media/platform/s5p-tv/mixer_video.c
index 123d271..6c4d1b9 100644
--- a/drivers/media/platform/s5p-tv/mixer_video.c
+++ b/drivers/media/platform/s5p-tv/mixer_video.c
@@ -81,12 +81,6 @@ int mxr_acquire_video(struct mxr_device *mdev,
 	}
 
 	vb2_dma_contig_set_max_seg_size(mdev->dev, DMA_BIT_MASK(32));
-	mdev->alloc_ctx = vb2_dma_contig_init_ctx(mdev->dev);
-	if (IS_ERR(mdev->alloc_ctx)) {
-		mxr_err(mdev, "could not acquire vb2 allocator\n");
-		ret = PTR_ERR(mdev->alloc_ctx);
-		goto fail_v4l2_dev;
-	}
 
 	/* registering outputs */
 	mdev->output_cnt = 0;
@@ -121,7 +115,7 @@ int mxr_acquire_video(struct mxr_device *mdev,
 		mxr_err(mdev, "failed to register any output\n");
 		ret = -ENODEV;
 		/* skipping fail_output because there is nothing to free */
-		goto fail_vb2_allocator;
+		goto fail_v4l2_dev;
 	}
 
 	return 0;
@@ -132,10 +126,6 @@ fail_output:
 		kfree(mdev->output[i]);
 	memset(mdev->output, 0, sizeof(mdev->output));
 
-fail_vb2_allocator:
-	/* freeing allocator context */
-	vb2_dma_contig_cleanup_ctx(mdev->alloc_ctx);
-
 fail_v4l2_dev:
 	/* NOTE: automatically unregister all subdevs */
 	v4l2_device_unregister(v4l2_dev);
@@ -152,7 +142,6 @@ void mxr_release_video(struct mxr_device *mdev)
 	for (i = 0; i < mdev->output_cnt; ++i)
 		kfree(mdev->output[i]);
 
-	vb2_dma_contig_cleanup_ctx(mdev->alloc_ctx);
 	vb2_dma_contig_clear_max_seg_size(mdev->dev);
 	v4l2_device_unregister(&mdev->v4l2_dev);
 }
@@ -903,7 +892,6 @@ static int queue_setup(struct vb2_queue *vq,
 
 	*nplanes = fmt->num_subframes;
 	for (i = 0; i < fmt->num_subframes; ++i) {
-		alloc_ctxs[i] = layer->mdev->alloc_ctx;
 		sizes[i] = planes[i].sizeimage;
 		mxr_dbg(mdev, "size[%d] = %08x\n", i, sizes[i]);
 	}
@@ -1112,6 +1100,7 @@ struct mxr_layer *mxr_base_layer_create(struct mxr_device *mdev,
 		.min_buffers_needed = 1,
 		.mem_ops = &vb2_dma_contig_memops,
 		.lock = &layer->mutex,
+		.dev = mdev->dev,
 	};
 
 	return layer;
-- 
2.8.1

