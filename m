Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:60727 "EHLO
	lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751784AbcF0Nc0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 27 Jun 2016 09:32:26 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Mikhail Ulyanov <mikhail.ulyanov@cogentembedded.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Jonathan Corbet <corbet@lwn.net>
Subject: [PATCHv5 09/13] media/platform: convert drivers to use the new vb2_queue dev field
Date: Mon, 27 Jun 2016 15:32:00 +0200
Message-Id: <1467034324-37626-10-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1467034324-37626-1-git-send-email-hverkuil@xs4all.nl>
References: <1467034324-37626-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Stop using alloc_ctx and just fill in the device pointer.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Mikhail Ulyanov <mikhail.ulyanov@cogentembedded.com>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Jonathan Corbet <corbet@lwn.net>
---
 drivers/media/platform/m2m-deinterlace.c        | 15 ++-------------
 drivers/media/platform/marvell-ccic/mcam-core.c | 24 +-----------------------
 drivers/media/platform/marvell-ccic/mcam-core.h |  2 --
 drivers/media/platform/mx2_emmaprp.c            | 17 +++--------------
 drivers/media/platform/omap3isp/ispvideo.c      | 12 ++----------
 drivers/media/platform/omap3isp/ispvideo.h      |  1 -
 drivers/media/platform/rcar_jpu.c               | 22 ++++------------------
 drivers/media/platform/sh_veu.c                 | 17 +++--------------
 drivers/media/platform/sh_vou.c                 | 14 ++------------
 9 files changed, 17 insertions(+), 107 deletions(-)

diff --git a/drivers/media/platform/m2m-deinterlace.c b/drivers/media/platform/m2m-deinterlace.c
index 7383818..15110ea 100644
--- a/drivers/media/platform/m2m-deinterlace.c
+++ b/drivers/media/platform/m2m-deinterlace.c
@@ -136,7 +136,6 @@ struct deinterlace_dev {
 	struct dma_chan		*dma_chan;
 
 	struct v4l2_m2m_dev	*m2m_dev;
-	struct vb2_alloc_ctx	*alloc_ctx;
 };
 
 struct deinterlace_ctx {
@@ -820,8 +819,6 @@ static int deinterlace_queue_setup(struct vb2_queue *vq,
 	*nbuffers = count;
 	sizes[0] = size;
 
-	alloc_ctxs[0] = ctx->dev->alloc_ctx;
-
 	dprintk(ctx->dev, "get %d buffer(s) of size %d each.\n", count, size);
 
 	return 0;
@@ -874,6 +871,7 @@ static int queue_init(void *priv, struct vb2_queue *src_vq,
 	src_vq->ops = &deinterlace_qops;
 	src_vq->mem_ops = &vb2_dma_contig_memops;
 	src_vq->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_COPY;
+	src_vq->dev = ctx->dev->v4l2_dev.dev;
 	q_data[V4L2_M2M_SRC].fmt = &formats[0];
 	q_data[V4L2_M2M_SRC].width = 640;
 	q_data[V4L2_M2M_SRC].height = 480;
@@ -891,6 +889,7 @@ static int queue_init(void *priv, struct vb2_queue *src_vq,
 	dst_vq->ops = &deinterlace_qops;
 	dst_vq->mem_ops = &vb2_dma_contig_memops;
 	dst_vq->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_COPY;
+	dst_vq->dev = ctx->dev->v4l2_dev.dev;
 	q_data[V4L2_M2M_DST].fmt = &formats[0];
 	q_data[V4L2_M2M_DST].width = 640;
 	q_data[V4L2_M2M_DST].height = 480;
@@ -1046,13 +1045,6 @@ static int deinterlace_probe(struct platform_device *pdev)
 
 	platform_set_drvdata(pdev, pcdev);
 
-	pcdev->alloc_ctx = vb2_dma_contig_init_ctx(&pdev->dev);
-	if (IS_ERR(pcdev->alloc_ctx)) {
-		v4l2_err(&pcdev->v4l2_dev, "Failed to alloc vb2 context\n");
-		ret = PTR_ERR(pcdev->alloc_ctx);
-		goto err_ctx;
-	}
-
 	pcdev->m2m_dev = v4l2_m2m_init(&m2m_ops);
 	if (IS_ERR(pcdev->m2m_dev)) {
 		v4l2_err(&pcdev->v4l2_dev, "Failed to init mem2mem device\n");
@@ -1064,8 +1056,6 @@ static int deinterlace_probe(struct platform_device *pdev)
 
 err_m2m:
 	video_unregister_device(&pcdev->vfd);
-err_ctx:
-	vb2_dma_contig_cleanup_ctx(pcdev->alloc_ctx);
 unreg_dev:
 	v4l2_device_unregister(&pcdev->v4l2_dev);
 rel_dma:
@@ -1082,7 +1072,6 @@ static int deinterlace_remove(struct platform_device *pdev)
 	v4l2_m2m_release(pcdev->m2m_dev);
 	video_unregister_device(&pcdev->vfd);
 	v4l2_device_unregister(&pcdev->v4l2_dev);
-	vb2_dma_contig_cleanup_ctx(pcdev->alloc_ctx);
 	dma_release_channel(pcdev->dma_chan);
 
 	return 0;
diff --git a/drivers/media/platform/marvell-ccic/mcam-core.c b/drivers/media/platform/marvell-ccic/mcam-core.c
index 9b878de..8a1f12d 100644
--- a/drivers/media/platform/marvell-ccic/mcam-core.c
+++ b/drivers/media/platform/marvell-ccic/mcam-core.c
@@ -1059,10 +1059,6 @@ static int mcam_vb_queue_setup(struct vb2_queue *vq,
 
 	if (*nbufs < minbufs)
 		*nbufs = minbufs;
-	if (cam->buffer_mode == B_DMA_contig)
-		alloc_ctxs[0] = cam->vb_alloc_ctx;
-	else if (cam->buffer_mode == B_DMA_sg)
-		alloc_ctxs[0] = cam->vb_alloc_ctx_sg;
 
 	if (*num_planes)
 		return sizes[0] < size ? -EINVAL : 0;
@@ -1271,6 +1267,7 @@ static int mcam_setup_vb2(struct mcam_camera *cam)
 	vq->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
 	vq->io_modes = VB2_MMAP | VB2_USERPTR | VB2_DMABUF | VB2_READ;
 	vq->buf_struct_size = sizeof(struct mcam_vb_buffer);
+	vq->dev = cam->dev;
 	INIT_LIST_HEAD(&cam->buffers);
 	switch (cam->buffer_mode) {
 	case B_DMA_contig:
@@ -1279,9 +1276,6 @@ static int mcam_setup_vb2(struct mcam_camera *cam)
 		vq->mem_ops = &vb2_dma_contig_memops;
 		cam->dma_setup = mcam_ctlr_dma_contig;
 		cam->frame_complete = mcam_dma_contig_done;
-		cam->vb_alloc_ctx = vb2_dma_contig_init_ctx(cam->dev);
-		if (IS_ERR(cam->vb_alloc_ctx))
-			return PTR_ERR(cam->vb_alloc_ctx);
 #endif
 		break;
 	case B_DMA_sg:
@@ -1290,9 +1284,6 @@ static int mcam_setup_vb2(struct mcam_camera *cam)
 		vq->mem_ops = &vb2_dma_sg_memops;
 		cam->dma_setup = mcam_ctlr_dma_sg;
 		cam->frame_complete = mcam_dma_sg_done;
-		cam->vb_alloc_ctx_sg = vb2_dma_sg_init_ctx(cam->dev);
-		if (IS_ERR(cam->vb_alloc_ctx_sg))
-			return PTR_ERR(cam->vb_alloc_ctx_sg);
 #endif
 		break;
 	case B_vmalloc:
@@ -1309,18 +1300,6 @@ static int mcam_setup_vb2(struct mcam_camera *cam)
 	return vb2_queue_init(vq);
 }
 
-static void mcam_cleanup_vb2(struct mcam_camera *cam)
-{
-#ifdef MCAM_MODE_DMA_CONTIG
-	if (cam->buffer_mode == B_DMA_contig)
-		vb2_dma_contig_cleanup_ctx(cam->vb_alloc_ctx);
-#endif
-#ifdef MCAM_MODE_DMA_SG
-	if (cam->buffer_mode == B_DMA_sg)
-		vb2_dma_sg_cleanup_ctx(cam->vb_alloc_ctx_sg);
-#endif
-}
-
 
 /* ---------------------------------------------------------------------- */
 /*
@@ -1875,7 +1854,6 @@ void mccic_shutdown(struct mcam_camera *cam)
 		cam_warn(cam, "Removing a device with users!\n");
 		mcam_ctlr_power_down(cam);
 	}
-	mcam_cleanup_vb2(cam);
 	if (cam->buffer_mode == B_vmalloc)
 		mcam_free_dma_bufs(cam);
 	video_unregister_device(&cam->vdev);
diff --git a/drivers/media/platform/marvell-ccic/mcam-core.h b/drivers/media/platform/marvell-ccic/mcam-core.h
index 35cd9e5..beb339f 100644
--- a/drivers/media/platform/marvell-ccic/mcam-core.h
+++ b/drivers/media/platform/marvell-ccic/mcam-core.h
@@ -176,8 +176,6 @@ struct mcam_camera {
 
 	/* DMA buffers - DMA modes */
 	struct mcam_vb_buffer *vb_bufs[MAX_DMA_BUFS];
-	struct vb2_alloc_ctx *vb_alloc_ctx;
-	struct vb2_alloc_ctx *vb_alloc_ctx_sg;
 
 	/* Mode-specific ops, set at open time */
 	void (*dma_setup)(struct mcam_camera *cam);
diff --git a/drivers/media/platform/mx2_emmaprp.c b/drivers/media/platform/mx2_emmaprp.c
index 3c4012d..88b3d98 100644
--- a/drivers/media/platform/mx2_emmaprp.c
+++ b/drivers/media/platform/mx2_emmaprp.c
@@ -211,7 +211,6 @@ struct emmaprp_dev {
 	struct clk		*clk_emma_ahb, *clk_emma_ipg;
 
 	struct v4l2_m2m_dev	*m2m_dev;
-	struct vb2_alloc_ctx	*alloc_ctx;
 };
 
 struct emmaprp_ctx {
@@ -710,8 +709,6 @@ static int emmaprp_queue_setup(struct vb2_queue *vq,
 	*nbuffers = count;
 	sizes[0] = size;
 
-	alloc_ctxs[0] = ctx->dev->alloc_ctx;
-
 	dprintk(ctx->dev, "get %d buffer(s) of size %d each.\n", count, size);
 
 	return 0;
@@ -765,6 +762,7 @@ static int queue_init(void *priv, struct vb2_queue *src_vq,
 	src_vq->ops = &emmaprp_qops;
 	src_vq->mem_ops = &vb2_dma_contig_memops;
 	src_vq->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_COPY;
+	src_vq->dev = ctx->dev->v4l2_dev.dev;
 
 	ret = vb2_queue_init(src_vq);
 	if (ret)
@@ -777,6 +775,7 @@ static int queue_init(void *priv, struct vb2_queue *src_vq,
 	dst_vq->ops = &emmaprp_qops;
 	dst_vq->mem_ops = &vb2_dma_contig_memops;
 	dst_vq->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_COPY;
+	dst_vq->dev = ctx->dev->v4l2_dev.dev;
 
 	return vb2_queue_init(dst_vq);
 }
@@ -948,18 +947,11 @@ static int emmaprp_probe(struct platform_device *pdev)
 	if (ret)
 		goto rel_vdev;
 
-	pcdev->alloc_ctx = vb2_dma_contig_init_ctx(&pdev->dev);
-	if (IS_ERR(pcdev->alloc_ctx)) {
-		v4l2_err(&pcdev->v4l2_dev, "Failed to alloc vb2 context\n");
-		ret = PTR_ERR(pcdev->alloc_ctx);
-		goto rel_vdev;
-	}
-
 	pcdev->m2m_dev = v4l2_m2m_init(&m2m_ops);
 	if (IS_ERR(pcdev->m2m_dev)) {
 		v4l2_err(&pcdev->v4l2_dev, "Failed to init mem2mem device\n");
 		ret = PTR_ERR(pcdev->m2m_dev);
-		goto rel_ctx;
+		goto rel_vdev;
 	}
 
 	ret = video_register_device(vfd, VFL_TYPE_GRABBER, 0);
@@ -973,8 +965,6 @@ static int emmaprp_probe(struct platform_device *pdev)
 
 rel_m2m:
 	v4l2_m2m_release(pcdev->m2m_dev);
-rel_ctx:
-	vb2_dma_contig_cleanup_ctx(pcdev->alloc_ctx);
 rel_vdev:
 	video_device_release(vfd);
 unreg_dev:
@@ -993,7 +983,6 @@ static int emmaprp_remove(struct platform_device *pdev)
 
 	video_unregister_device(pcdev->vfd);
 	v4l2_m2m_release(pcdev->m2m_dev);
-	vb2_dma_contig_cleanup_ctx(pcdev->alloc_ctx);
 	v4l2_device_unregister(&pcdev->v4l2_dev);
 	mutex_destroy(&pcdev->dev_mutex);
 
diff --git a/drivers/media/platform/omap3isp/ispvideo.c b/drivers/media/platform/omap3isp/ispvideo.c
index 1b1a95d..486b875 100644
--- a/drivers/media/platform/omap3isp/ispvideo.c
+++ b/drivers/media/platform/omap3isp/ispvideo.c
@@ -342,8 +342,6 @@ static int isp_video_queue_setup(struct vb2_queue *queue,
 	if (sizes[0] == 0)
 		return -EINVAL;
 
-	alloc_ctxs[0] = video->alloc_ctx;
-
 	*count = min(*count, video->capture_mem / PAGE_ALIGN(sizes[0]));
 
 	return 0;
@@ -1308,6 +1306,7 @@ static int isp_video_open(struct file *file)
 	queue->mem_ops = &vb2_dma_contig_memops;
 	queue->buf_struct_size = sizeof(struct isp_buffer);
 	queue->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
+	queue->dev = video->isp->dev;
 
 	ret = vb2_queue_init(&handle->queue);
 	if (ret < 0) {
@@ -1414,15 +1413,9 @@ int omap3isp_video_init(struct isp_video *video, const char *name)
 		return -EINVAL;
 	}
 
-	video->alloc_ctx = vb2_dma_contig_init_ctx(video->isp->dev);
-	if (IS_ERR(video->alloc_ctx))
-		return PTR_ERR(video->alloc_ctx);
-
 	ret = media_entity_pads_init(&video->video.entity, 1, &video->pad);
-	if (ret < 0) {
-		vb2_dma_contig_cleanup_ctx(video->alloc_ctx);
+	if (ret < 0)
 		return ret;
-	}
 
 	mutex_init(&video->mutex);
 	atomic_set(&video->active, 0);
@@ -1451,7 +1444,6 @@ int omap3isp_video_init(struct isp_video *video, const char *name)
 
 void omap3isp_video_cleanup(struct isp_video *video)
 {
-	vb2_dma_contig_cleanup_ctx(video->alloc_ctx);
 	media_entity_cleanup(&video->video.entity);
 	mutex_destroy(&video->queue_lock);
 	mutex_destroy(&video->stream_lock);
diff --git a/drivers/media/platform/omap3isp/ispvideo.h b/drivers/media/platform/omap3isp/ispvideo.h
index 6a48d58..f6a2082 100644
--- a/drivers/media/platform/omap3isp/ispvideo.h
+++ b/drivers/media/platform/omap3isp/ispvideo.h
@@ -171,7 +171,6 @@ struct isp_video {
 	bool error;
 
 	/* Video buffers queue */
-	void *alloc_ctx;
 	struct vb2_queue *queue;
 	struct mutex queue_lock;	/* protects the queue */
 	spinlock_t irqlock;		/* protects dmaqueue */
diff --git a/drivers/media/platform/rcar_jpu.c b/drivers/media/platform/rcar_jpu.c
index 552789a..d81c410 100644
--- a/drivers/media/platform/rcar_jpu.c
+++ b/drivers/media/platform/rcar_jpu.c
@@ -203,7 +203,6 @@
  * @irq: JPEG IP irq
  * @clk: JPEG IP clock
  * @dev: JPEG IP struct device
- * @alloc_ctx: videobuf2 memory allocator's context
  * @ref_count: reference counter
  */
 struct jpu {
@@ -220,7 +219,6 @@ struct jpu {
 	unsigned int		irq;
 	struct clk		*clk;
 	struct device		*dev;
-	void			*alloc_ctx;
 	int			ref_count;
 };
 
@@ -1033,17 +1031,14 @@ static int jpu_queue_setup(struct vb2_queue *vq,
 
 			if (sizes[i] < q_size)
 				return -EINVAL;
-			alloc_ctxs[i] = ctx->jpu->alloc_ctx;
 		}
 		return 0;
 	}
 
 	*nplanes = q_data->format.num_planes;
 
-	for (i = 0; i < *nplanes; i++) {
+	for (i = 0; i < *nplanes; i++)
 		sizes[i] = q_data->format.plane_fmt[i].sizeimage;
-		alloc_ctxs[i] = ctx->jpu->alloc_ctx;
-	}
 
 	return 0;
 }
@@ -1214,6 +1209,7 @@ static int jpu_queue_init(void *priv, struct vb2_queue *src_vq,
 	src_vq->mem_ops = &vb2_dma_contig_memops;
 	src_vq->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_COPY;
 	src_vq->lock = &ctx->jpu->mutex;
+	src_vq->dev = ctx->jpu->v4l2_dev.dev;
 
 	ret = vb2_queue_init(src_vq);
 	if (ret)
@@ -1228,6 +1224,7 @@ static int jpu_queue_init(void *priv, struct vb2_queue *src_vq,
 	dst_vq->mem_ops = &vb2_dma_contig_memops;
 	dst_vq->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_COPY;
 	dst_vq->lock = &ctx->jpu->mutex;
+	dst_vq->dev = ctx->jpu->v4l2_dev.dev;
 
 	return vb2_queue_init(dst_vq);
 }
@@ -1676,13 +1673,6 @@ static int jpu_probe(struct platform_device *pdev)
 		goto device_register_rollback;
 	}
 
-	jpu->alloc_ctx = vb2_dma_contig_init_ctx(&pdev->dev);
-	if (IS_ERR(jpu->alloc_ctx)) {
-		v4l2_err(&jpu->v4l2_dev, "Failed to init memory allocator\n");
-		ret = PTR_ERR(jpu->alloc_ctx);
-		goto m2m_init_rollback;
-	}
-
 	/* fill in qantization and Huffman tables for encoder */
 	for (i = 0; i < JPU_MAX_QUALITY; i++)
 		jpu_generate_hdr(i, (unsigned char *)jpeg_hdrs[i]);
@@ -1699,7 +1689,7 @@ static int jpu_probe(struct platform_device *pdev)
 	ret = video_register_device(&jpu->vfd_encoder, VFL_TYPE_GRABBER, -1);
 	if (ret) {
 		v4l2_err(&jpu->v4l2_dev, "Failed to register video device\n");
-		goto vb2_allocator_rollback;
+		goto m2m_init_rollback;
 	}
 
 	video_set_drvdata(&jpu->vfd_encoder, jpu);
@@ -1732,9 +1722,6 @@ static int jpu_probe(struct platform_device *pdev)
 enc_vdev_register_rollback:
 	video_unregister_device(&jpu->vfd_encoder);
 
-vb2_allocator_rollback:
-	vb2_dma_contig_cleanup_ctx(jpu->alloc_ctx);
-
 m2m_init_rollback:
 	v4l2_m2m_release(jpu->m2m_dev);
 
@@ -1750,7 +1737,6 @@ static int jpu_remove(struct platform_device *pdev)
 
 	video_unregister_device(&jpu->vfd_decoder);
 	video_unregister_device(&jpu->vfd_encoder);
-	vb2_dma_contig_cleanup_ctx(jpu->alloc_ctx);
 	v4l2_m2m_release(jpu->m2m_dev);
 	v4l2_device_unregister(&jpu->v4l2_dev);
 
diff --git a/drivers/media/platform/sh_veu.c b/drivers/media/platform/sh_veu.c
index 82b5d69..afd21c9 100644
--- a/drivers/media/platform/sh_veu.c
+++ b/drivers/media/platform/sh_veu.c
@@ -118,7 +118,6 @@ struct sh_veu_dev {
 	struct sh_veu_file *output;
 	struct mutex fop_lock;
 	void __iomem *base;
-	struct vb2_alloc_ctx *alloc_ctx;
 	spinlock_t lock;
 	bool is_2h;
 	unsigned int xaction;
@@ -882,14 +881,11 @@ static int sh_veu_queue_setup(struct vb2_queue *vq,
 		*nbuffers = count;
 	}
 
-	if (*nplanes) {
-		alloc_ctxs[0] = veu->alloc_ctx;
+	if (*nplanes)
 		return sizes[0] < size ? -EINVAL : 0;
-	}
 
 	*nplanes = 1;
 	sizes[0] = size;
-	alloc_ctxs[0] = veu->alloc_ctx;
 
 	dev_dbg(veu->dev, "get %d buffer(s) of size %d each.\n", count, size);
 
@@ -948,6 +944,7 @@ static int sh_veu_queue_init(void *priv, struct vb2_queue *src_vq,
 	src_vq->mem_ops = &vb2_dma_contig_memops;
 	src_vq->lock = &veu->fop_lock;
 	src_vq->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_COPY;
+	src_vq->dev = veu->v4l2_dev.dev;
 
 	ret = vb2_queue_init(src_vq);
 	if (ret < 0)
@@ -962,6 +959,7 @@ static int sh_veu_queue_init(void *priv, struct vb2_queue *src_vq,
 	dst_vq->mem_ops = &vb2_dma_contig_memops;
 	dst_vq->lock = &veu->fop_lock;
 	dst_vq->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_COPY;
+	dst_vq->dev = veu->v4l2_dev.dev;
 
 	return vb2_queue_init(dst_vq);
 }
@@ -1148,12 +1146,6 @@ static int sh_veu_probe(struct platform_device *pdev)
 
 	vdev = &veu->vdev;
 
-	veu->alloc_ctx = vb2_dma_contig_init_ctx(&pdev->dev);
-	if (IS_ERR(veu->alloc_ctx)) {
-		ret = PTR_ERR(veu->alloc_ctx);
-		goto einitctx;
-	}
-
 	*vdev = sh_veu_videodev;
 	vdev->v4l2_dev = &veu->v4l2_dev;
 	spin_lock_init(&veu->lock);
@@ -1187,8 +1179,6 @@ evidreg:
 	pm_runtime_disable(&pdev->dev);
 	v4l2_m2m_release(veu->m2m_dev);
 em2minit:
-	vb2_dma_contig_cleanup_ctx(veu->alloc_ctx);
-einitctx:
 	v4l2_device_unregister(&veu->v4l2_dev);
 	return ret;
 }
@@ -1202,7 +1192,6 @@ static int sh_veu_remove(struct platform_device *pdev)
 	video_unregister_device(&veu->vdev);
 	pm_runtime_disable(&pdev->dev);
 	v4l2_m2m_release(veu->m2m_dev);
-	vb2_dma_contig_cleanup_ctx(veu->alloc_ctx);
 	v4l2_device_unregister(&veu->v4l2_dev);
 
 	return 0;
diff --git a/drivers/media/platform/sh_vou.c b/drivers/media/platform/sh_vou.c
index 1157404..59830a4 100644
--- a/drivers/media/platform/sh_vou.c
+++ b/drivers/media/platform/sh_vou.c
@@ -86,7 +86,6 @@ struct sh_vou_device {
 	v4l2_std_id std;
 	int pix_idx;
 	struct vb2_queue queue;
-	struct vb2_alloc_ctx *alloc_ctx;
 	struct sh_vou_buffer *active;
 	enum sh_vou_status status;
 	unsigned sequence;
@@ -253,7 +252,6 @@ static int sh_vou_queue_setup(struct vb2_queue *vq,
 
 	dev_dbg(vou_dev->v4l2_dev.dev, "%s()\n", __func__);
 
-	alloc_ctxs[0] = vou_dev->alloc_ctx;
 	if (*nplanes)
 		return sizes[0] < pix->height * bytes_per_line ? -EINVAL : 0;
 	*nplanes = 1;
@@ -1304,16 +1302,11 @@ static int sh_vou_probe(struct platform_device *pdev)
 	q->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
 	q->min_buffers_needed = 2;
 	q->lock = &vou_dev->fop_lock;
+	q->dev = &pdev->dev;
 	ret = vb2_queue_init(q);
 	if (ret)
-		goto einitctx;
+		goto ei2cgadap;
 
-	vou_dev->alloc_ctx = vb2_dma_contig_init_ctx(&pdev->dev);
-	if (IS_ERR(vou_dev->alloc_ctx)) {
-		dev_err(&pdev->dev, "Can't allocate buffer context");
-		ret = PTR_ERR(vou_dev->alloc_ctx);
-		goto einitctx;
-	}
 	vdev->queue = q;
 	INIT_LIST_HEAD(&vou_dev->buf_list);
 
@@ -1348,8 +1341,6 @@ ei2cnd:
 ereset:
 	i2c_put_adapter(i2c_adap);
 ei2cgadap:
-	vb2_dma_contig_cleanup_ctx(vou_dev->alloc_ctx);
-einitctx:
 	pm_runtime_disable(&pdev->dev);
 	v4l2_device_unregister(&vou_dev->v4l2_dev);
 	return ret;
@@ -1367,7 +1358,6 @@ static int sh_vou_remove(struct platform_device *pdev)
 	pm_runtime_disable(&pdev->dev);
 	video_unregister_device(&vou_dev->vdev);
 	i2c_put_adapter(client->adapter);
-	vb2_dma_contig_cleanup_ctx(vou_dev->alloc_ctx);
 	v4l2_device_unregister(&vou_dev->v4l2_dev);
 	return 0;
 }
-- 
2.8.1

