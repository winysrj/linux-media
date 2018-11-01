Return-path: <linux-media-owner@vger.kernel.org>
Received: from bin-mail-out-05.binero.net ([195.74.38.228]:39904 "EHLO
        bin-mail-out-05.binero.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728125AbeKBIiC (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 2 Nov 2018 04:38:02 -0400
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Benoit Parrot <bparrot@ti.com>, linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org
Subject: [PATCH v2 06/30] media: entity: Use pad as the starting point for a pipeline
Date: Fri,  2 Nov 2018 00:31:20 +0100
Message-Id: <20181101233144.31507-7-niklas.soderlund+renesas@ragnatech.se>
In-Reply-To: <20181101233144.31507-1-niklas.soderlund+renesas@ragnatech.se>
References: <20181101233144.31507-1-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Sakari Ailus <sakari.ailus@linux.intel.com>

The pipeline will be moved from the entity to the pads; reflect this in
the media pipeline function API.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Reviewed-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
---
 Documentation/media/kapi/mc-core.rst          |  6 ++--
 drivers/media/media-entity.c                  | 25 +++++++-------
 drivers/media/pci/intel/ipu3/ipu3-cio2.c      |  6 ++--
 .../media/platform/exynos4-is/fimc-capture.c  |  8 ++---
 .../platform/exynos4-is/fimc-isp-video.c      |  8 ++---
 drivers/media/platform/exynos4-is/fimc-lite.c |  8 ++---
 drivers/media/platform/omap3isp/ispvideo.c    |  6 ++--
 .../media/platform/qcom/camss/camss-video.c   |  6 ++--
 drivers/media/platform/rcar-vin/rcar-dma.c    |  6 ++--
 .../media/platform/s3c-camif/camif-capture.c  |  6 ++--
 drivers/media/platform/vimc/vimc-capture.c    |  6 ++--
 drivers/media/platform/vsp1/vsp1_video.c      |  6 ++--
 drivers/media/platform/xilinx/xilinx-dma.c    |  6 ++--
 drivers/media/usb/au0828/au0828-core.c        |  4 +--
 drivers/staging/media/imx/imx-media-utils.c   |  6 ++--
 drivers/staging/media/omap4iss/iss_video.c    |  6 ++--
 include/media/media-entity.h                  | 33 ++++++++++---------
 17 files changed, 76 insertions(+), 76 deletions(-)

diff --git a/Documentation/media/kapi/mc-core.rst b/Documentation/media/kapi/mc-core.rst
index 849b87439b7a9772..ede7e946f6a82ac0 100644
--- a/Documentation/media/kapi/mc-core.rst
+++ b/Documentation/media/kapi/mc-core.rst
@@ -211,11 +211,11 @@ When starting streaming, drivers must notify all entities in the pipeline to
 prevent link states from being modified during streaming by calling
 :c:func:`media_pipeline_start()`.
 
-The function will mark all entities connected to the given entity through
-enabled links, either directly or indirectly, as streaming.
+The function will mark all entities connected to the given pad through
+enabled routes and links, either directly or indirectly, as streaming.
 
 The struct :c:type:`media_pipeline` instance pointed to by
-the pipe argument will be stored in every entity in the pipeline.
+the pipe argument will be stored in every pad in the pipeline.
 Drivers should embed the struct :c:type:`media_pipeline`
 in higher-level pipeline structures and can then access the
 pipeline through the struct :c:type:`media_entity`
diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
index 13260149c4dfc90c..f2fa0b7826dbc2f3 100644
--- a/drivers/media/media-entity.c
+++ b/drivers/media/media-entity.c
@@ -411,12 +411,11 @@ EXPORT_SYMBOL_GPL(media_entity_get_fwnode_pad);
  * Pipeline management
  */
 
-__must_check int __media_pipeline_start(struct media_entity *entity,
+__must_check int __media_pipeline_start(struct media_pad *pad,
 					struct media_pipeline *pipe)
 {
-	struct media_device *mdev = entity->graph_obj.mdev;
+	struct media_device *mdev = pad->graph_obj.mdev;
 	struct media_graph *graph = &pipe->graph;
-	struct media_pad *pad = entity->pads;
 	struct media_pad *pad_err = pad;
 	struct media_link *link;
 	int ret = 0;
@@ -549,24 +548,23 @@ __must_check int __media_pipeline_start(struct media_entity *entity,
 }
 EXPORT_SYMBOL_GPL(__media_pipeline_start);
 
-__must_check int media_pipeline_start(struct media_entity *entity,
+__must_check int media_pipeline_start(struct media_pad *pad,
 				      struct media_pipeline *pipe)
 {
-	struct media_device *mdev = entity->graph_obj.mdev;
+	struct media_device *mdev = pad->graph_obj.mdev;
 	int ret;
 
 	mutex_lock(&mdev->graph_mutex);
-	ret = __media_pipeline_start(entity, pipe);
+	ret = __media_pipeline_start(pad, pipe);
 	mutex_unlock(&mdev->graph_mutex);
 	return ret;
 }
 EXPORT_SYMBOL_GPL(media_pipeline_start);
 
-void __media_pipeline_stop(struct media_entity *entity)
+void __media_pipeline_stop(struct media_pad *pad)
 {
-	struct media_pipeline *pipe = entity->pads->pipe;
+	struct media_pipeline *pipe = pad->pipe;
 	struct media_graph *graph = &pipe->graph;
-	struct media_pad *pad;
 
 	/*
 	 * If the following check fails, the driver has performed an
@@ -575,9 +573,10 @@ void __media_pipeline_stop(struct media_entity *entity)
 	if (WARN_ON(!pipe))
 		return;
 
-	media_graph_walk_start(graph, entity->pads);
+	media_graph_walk_start(graph, pad);
 
 	while ((pad = media_graph_walk_next(graph))) {
+		struct media_entity *entity = pad->entity;
 		unsigned int i;
 
 		for (i = 0; i < entity->num_pads; i++) {
@@ -598,12 +597,12 @@ void __media_pipeline_stop(struct media_entity *entity)
 }
 EXPORT_SYMBOL_GPL(__media_pipeline_stop);
 
-void media_pipeline_stop(struct media_entity *entity)
+void media_pipeline_stop(struct media_pad *pad)
 {
-	struct media_device *mdev = entity->graph_obj.mdev;
+	struct media_device *mdev = pad->graph_obj.mdev;
 
 	mutex_lock(&mdev->graph_mutex);
-	__media_pipeline_stop(entity);
+	__media_pipeline_stop(pad);
 	mutex_unlock(&mdev->graph_mutex);
 }
 EXPORT_SYMBOL_GPL(media_pipeline_stop);
diff --git a/drivers/media/pci/intel/ipu3/ipu3-cio2.c b/drivers/media/pci/intel/ipu3/ipu3-cio2.c
index 452eb9b42140bb92..3e17a3a546ee5458 100644
--- a/drivers/media/pci/intel/ipu3/ipu3-cio2.c
+++ b/drivers/media/pci/intel/ipu3/ipu3-cio2.c
@@ -1000,7 +1000,7 @@ static int cio2_vb2_start_streaming(struct vb2_queue *vq, unsigned int count)
 		return r;
 	}
 
-	r = media_pipeline_start(&q->vdev.entity, &q->pipe);
+	r = media_pipeline_start(q->vdev.entity.pads, &q->pipe);
 	if (r)
 		goto fail_pipeline;
 
@@ -1020,7 +1020,7 @@ static int cio2_vb2_start_streaming(struct vb2_queue *vq, unsigned int count)
 fail_csi2_subdev:
 	cio2_hw_exit(cio2, q);
 fail_hw:
-	media_pipeline_stop(&q->vdev.entity);
+	media_pipeline_stop(q->vdev.entity.pads);
 fail_pipeline:
 	dev_dbg(&cio2->pci_dev->dev, "failed to start streaming (%d)\n", r);
 	cio2_vb2_return_all_buffers(q, VB2_BUF_STATE_QUEUED);
@@ -1041,7 +1041,7 @@ static void cio2_vb2_stop_streaming(struct vb2_queue *vq)
 	cio2_hw_exit(cio2, q);
 	synchronize_irq(cio2->pci_dev->irq);
 	cio2_vb2_return_all_buffers(q, VB2_BUF_STATE_ERROR);
-	media_pipeline_stop(&q->vdev.entity);
+	media_pipeline_stop(q->vdev.entity.pads);
 	pm_runtime_put(&cio2->pci_dev->dev);
 	cio2->streaming = false;
 }
diff --git a/drivers/media/platform/exynos4-is/fimc-capture.c b/drivers/media/platform/exynos4-is/fimc-capture.c
index f56220e549bb9511..04fa01caa3aba5f8 100644
--- a/drivers/media/platform/exynos4-is/fimc-capture.c
+++ b/drivers/media/platform/exynos4-is/fimc-capture.c
@@ -537,7 +537,7 @@ static int fimc_capture_release(struct file *file)
 	mutex_lock(&fimc->lock);
 
 	if (close && vc->streaming) {
-		media_pipeline_stop(&vc->ve.vdev.entity);
+		media_pipeline_stop(vc->ve.vdev.entity.pads);
 		vc->streaming = false;
 	}
 
@@ -1201,7 +1201,7 @@ static int fimc_cap_streamon(struct file *file, void *priv,
 	if (fimc_capture_active(fimc))
 		return -EBUSY;
 
-	ret = media_pipeline_start(entity, &vc->ve.pipe->mp);
+	ret = media_pipeline_start(entity->pads, &vc->ve.pipe->mp);
 	if (ret < 0)
 		return ret;
 
@@ -1235,7 +1235,7 @@ static int fimc_cap_streamon(struct file *file, void *priv,
 	}
 
 err_p_stop:
-	media_pipeline_stop(entity);
+	media_pipeline_stop(entity->pads);
 	return ret;
 }
 
@@ -1250,7 +1250,7 @@ static int fimc_cap_streamoff(struct file *file, void *priv,
 	if (ret < 0)
 		return ret;
 
-	media_pipeline_stop(&vc->ve.vdev.entity);
+	media_pipeline_stop(vc->ve.vdev.entity.pads);
 	vc->streaming = false;
 	return 0;
 }
diff --git a/drivers/media/platform/exynos4-is/fimc-isp-video.c b/drivers/media/platform/exynos4-is/fimc-isp-video.c
index de6bd28f7e313d20..af25aa85fa647ca3 100644
--- a/drivers/media/platform/exynos4-is/fimc-isp-video.c
+++ b/drivers/media/platform/exynos4-is/fimc-isp-video.c
@@ -312,7 +312,7 @@ static int isp_video_release(struct file *file)
 	mutex_lock(&isp->video_lock);
 
 	if (v4l2_fh_is_singular_file(file) && ivc->streaming) {
-		media_pipeline_stop(entity);
+		media_pipeline_stop(entity->pads);
 		ivc->streaming = 0;
 	}
 
@@ -494,7 +494,7 @@ static int isp_video_streamon(struct file *file, void *priv,
 	struct media_entity *me = &ve->vdev.entity;
 	int ret;
 
-	ret = media_pipeline_start(me, &ve->pipe->mp);
+	ret = media_pipeline_start(me->pads, &ve->pipe->mp);
 	if (ret < 0)
 		return ret;
 
@@ -509,7 +509,7 @@ static int isp_video_streamon(struct file *file, void *priv,
 	isp->video_capture.streaming = 1;
 	return 0;
 p_stop:
-	media_pipeline_stop(me);
+	media_pipeline_stop(me->pads);
 	return ret;
 }
 
@@ -524,7 +524,7 @@ static int isp_video_streamoff(struct file *file, void *priv,
 	if (ret < 0)
 		return ret;
 
-	media_pipeline_stop(&video->ve.vdev.entity);
+	media_pipeline_stop(video->ve.vdev.entity.pads);
 	video->streaming = 0;
 	return 0;
 }
diff --git a/drivers/media/platform/exynos4-is/fimc-lite.c b/drivers/media/platform/exynos4-is/fimc-lite.c
index dbadcba6739a286b..1d6858e5abb0b9f3 100644
--- a/drivers/media/platform/exynos4-is/fimc-lite.c
+++ b/drivers/media/platform/exynos4-is/fimc-lite.c
@@ -524,7 +524,7 @@ static int fimc_lite_release(struct file *file)
 	if (v4l2_fh_is_singular_file(file) &&
 	    atomic_read(&fimc->out_path) == FIMC_IO_DMA) {
 		if (fimc->streaming) {
-			media_pipeline_stop(entity);
+			media_pipeline_stop(entity->pads);
 			fimc->streaming = false;
 		}
 		fimc_lite_stop_capture(fimc, false);
@@ -832,7 +832,7 @@ static int fimc_lite_streamon(struct file *file, void *priv,
 	if (fimc_lite_active(fimc))
 		return -EBUSY;
 
-	ret = media_pipeline_start(entity, &fimc->ve.pipe->mp);
+	ret = media_pipeline_start(entity->pads, &fimc->ve.pipe->mp);
 	if (ret < 0)
 		return ret;
 
@@ -849,7 +849,7 @@ static int fimc_lite_streamon(struct file *file, void *priv,
 	}
 
 err_p_stop:
-	media_pipeline_stop(entity);
+	media_pipeline_stop(entity->pads);
 	return 0;
 }
 
@@ -863,7 +863,7 @@ static int fimc_lite_streamoff(struct file *file, void *priv,
 	if (ret < 0)
 		return ret;
 
-	media_pipeline_stop(&fimc->ve.vdev.entity);
+	media_pipeline_stop(fimc->ve.vdev.entity.pads);
 	fimc->streaming = false;
 	return 0;
 }
diff --git a/drivers/media/platform/omap3isp/ispvideo.c b/drivers/media/platform/omap3isp/ispvideo.c
index f354cd7ceb8ffce5..6a85a8323a113869 100644
--- a/drivers/media/platform/omap3isp/ispvideo.c
+++ b/drivers/media/platform/omap3isp/ispvideo.c
@@ -1113,7 +1113,7 @@ isp_video_streamon(struct file *file, void *fh, enum v4l2_buf_type type)
 	pipe->l3_ick = clk_get_rate(video->isp->clock[ISP_CLK_L3_ICK]);
 	pipe->max_rate = pipe->l3_ick;
 
-	ret = media_pipeline_start(&video->video.entity, &pipe->pipe);
+	ret = media_pipeline_start(video->video.entity.pads, &pipe->pipe);
 	if (ret < 0)
 		goto err_pipeline_start;
 
@@ -1170,7 +1170,7 @@ isp_video_streamon(struct file *file, void *fh, enum v4l2_buf_type type)
 	return 0;
 
 err_check_format:
-	media_pipeline_stop(&video->video.entity);
+	media_pipeline_stop(video->video.entity.pads);
 err_pipeline_start:
 	/* TODO: Implement PM QoS */
 	/* The DMA queue must be emptied here, otherwise CCDC interrupts that
@@ -1237,7 +1237,7 @@ isp_video_streamoff(struct file *file, void *fh, enum v4l2_buf_type type)
 	video->error = false;
 
 	/* TODO: Implement PM QoS */
-	media_pipeline_stop(&video->video.entity);
+	media_pipeline_stop(video->video.entity.pads);
 
 	media_entity_enum_cleanup(&pipe->ent_enum);
 
diff --git a/drivers/media/platform/qcom/camss/camss-video.c b/drivers/media/platform/qcom/camss/camss-video.c
index 58aebe7114cd7dc5..3ec24286e38d6856 100644
--- a/drivers/media/platform/qcom/camss/camss-video.c
+++ b/drivers/media/platform/qcom/camss/camss-video.c
@@ -436,7 +436,7 @@ static int video_start_streaming(struct vb2_queue *q, unsigned int count)
 	struct v4l2_subdev *subdev;
 	int ret;
 
-	ret = media_pipeline_start(&vdev->entity, &video->pipe);
+	ret = media_pipeline_start(vdev->entity.pads, &video->pipe);
 	if (ret < 0)
 		return ret;
 
@@ -465,7 +465,7 @@ static int video_start_streaming(struct vb2_queue *q, unsigned int count)
 	return 0;
 
 error:
-	media_pipeline_stop(&vdev->entity);
+	media_pipeline_stop(vdev->entity.pads);
 
 	video->ops->flush_buffers(video, VB2_BUF_STATE_QUEUED);
 
@@ -496,7 +496,7 @@ static void video_stop_streaming(struct vb2_queue *q)
 		v4l2_subdev_call(subdev, video, s_stream, 0);
 	}
 
-	media_pipeline_stop(&vdev->entity);
+	media_pipeline_stop(vdev->entity.pads);
 
 	video->ops->flush_buffers(video, VB2_BUF_STATE_ERROR);
 }
diff --git a/drivers/media/platform/rcar-vin/rcar-dma.c b/drivers/media/platform/rcar-vin/rcar-dma.c
index e749096926f34d4a..57c2087f7ad472f3 100644
--- a/drivers/media/platform/rcar-vin/rcar-dma.c
+++ b/drivers/media/platform/rcar-vin/rcar-dma.c
@@ -1112,7 +1112,7 @@ static int rvin_set_stream(struct rvin_dev *vin, int on)
 	sd = media_entity_to_v4l2_subdev(pad->entity);
 
 	if (!on) {
-		media_pipeline_stop(&vin->vdev.entity);
+		media_pipeline_stop(vin->vdev.entity.pads);
 		return v4l2_subdev_call(sd, video, s_stream, 0);
 	}
 
@@ -1129,7 +1129,7 @@ static int rvin_set_stream(struct rvin_dev *vin, int on)
 	mdev = vin->vdev.entity.graph_obj.mdev;
 	mutex_lock(&mdev->graph_mutex);
 	pipe = sd->entity.pads->pipe ? sd->entity.pads->pipe : &vin->vdev.pipe;
-	ret = __media_pipeline_start(&vin->vdev.entity, pipe);
+	ret = __media_pipeline_start(vin->vdev.entity.pads, pipe);
 	mutex_unlock(&mdev->graph_mutex);
 	if (ret)
 		return ret;
@@ -1138,7 +1138,7 @@ static int rvin_set_stream(struct rvin_dev *vin, int on)
 	if (ret == -ENOIOCTLCMD)
 		ret = 0;
 	if (ret)
-		media_pipeline_stop(&vin->vdev.entity);
+		media_pipeline_stop(vin->vdev.entity.pads);
 
 	return ret;
 }
diff --git a/drivers/media/platform/s3c-camif/camif-capture.c b/drivers/media/platform/s3c-camif/camif-capture.c
index 23b008d1a47bb9d1..21f407985afaedfc 100644
--- a/drivers/media/platform/s3c-camif/camif-capture.c
+++ b/drivers/media/platform/s3c-camif/camif-capture.c
@@ -858,13 +858,13 @@ static int s3c_camif_streamon(struct file *file, void *priv,
 	if (s3c_vp_active(vp))
 		return 0;
 
-	ret = media_pipeline_start(sensor, camif->m_pipeline);
+	ret = media_pipeline_start(sensor->pads, camif->m_pipeline);
 	if (ret < 0)
 		return ret;
 
 	ret = camif_pipeline_validate(camif);
 	if (ret < 0) {
-		media_pipeline_stop(sensor);
+		media_pipeline_stop(sensor->pads);
 		return ret;
 	}
 
@@ -888,7 +888,7 @@ static int s3c_camif_streamoff(struct file *file, void *priv,
 
 	ret = vb2_streamoff(&vp->vb_queue, type);
 	if (ret == 0)
-		media_pipeline_stop(&camif->sensor.sd->entity);
+		media_pipeline_stop(camif->sensor.sd->entity.pads);
 	return ret;
 }
 
diff --git a/drivers/media/platform/vimc/vimc-capture.c b/drivers/media/platform/vimc/vimc-capture.c
index 3f7e9ed5663376df..55e72fcd97c54f7c 100644
--- a/drivers/media/platform/vimc/vimc-capture.c
+++ b/drivers/media/platform/vimc/vimc-capture.c
@@ -248,7 +248,7 @@ static int vimc_cap_start_streaming(struct vb2_queue *vq, unsigned int count)
 	vcap->sequence = 0;
 
 	/* Start the media pipeline */
-	ret = media_pipeline_start(entity, &vcap->pipe);
+	ret = media_pipeline_start(entity->pads, &vcap->pipe);
 	if (ret) {
 		vimc_cap_return_all_buffers(vcap, VB2_BUF_STATE_QUEUED);
 		return ret;
@@ -257,7 +257,7 @@ static int vimc_cap_start_streaming(struct vb2_queue *vq, unsigned int count)
 	/* Enable streaming from the pipe */
 	ret = vimc_pipeline_s_stream(&vcap->vdev.entity, 1);
 	if (ret) {
-		media_pipeline_stop(entity);
+		media_pipeline_stop(entity->pads);
 		vimc_cap_return_all_buffers(vcap, VB2_BUF_STATE_QUEUED);
 		return ret;
 	}
@@ -277,7 +277,7 @@ static void vimc_cap_stop_streaming(struct vb2_queue *vq)
 	vimc_pipeline_s_stream(&vcap->vdev.entity, 0);
 
 	/* Stop the media pipeline */
-	media_pipeline_stop(&vcap->vdev.entity);
+	media_pipeline_stop(vcap->vdev.entity.pads);
 
 	/* Release all active buffers */
 	vimc_cap_return_all_buffers(vcap, VB2_BUF_STATE_ERROR);
diff --git a/drivers/media/platform/vsp1/vsp1_video.c b/drivers/media/platform/vsp1/vsp1_video.c
index 806825bd3484167a..1209d2622fca646b 100644
--- a/drivers/media/platform/vsp1/vsp1_video.c
+++ b/drivers/media/platform/vsp1/vsp1_video.c
@@ -937,7 +937,7 @@ static void vsp1_video_stop_streaming(struct vb2_queue *vq)
 	}
 	mutex_unlock(&pipe->lock);
 
-	media_pipeline_stop(&video->video.entity);
+	media_pipeline_stop(video->video.entity.pads);
 	vsp1_video_release_buffers(video);
 	vsp1_video_pipeline_put(pipe);
 }
@@ -1064,7 +1064,7 @@ vsp1_video_streamon(struct file *file, void *fh, enum v4l2_buf_type type)
 		return PTR_ERR(pipe);
 	}
 
-	ret = __media_pipeline_start(&video->video.entity, &pipe->pipe);
+	ret = __media_pipeline_start(video->video.entity.pads, &pipe->pipe);
 	if (ret < 0) {
 		mutex_unlock(&mdev->graph_mutex);
 		goto err_pipe;
@@ -1088,7 +1088,7 @@ vsp1_video_streamon(struct file *file, void *fh, enum v4l2_buf_type type)
 	return 0;
 
 err_stop:
-	media_pipeline_stop(&video->video.entity);
+	media_pipeline_stop(video->video.entity.pads);
 err_pipe:
 	vsp1_video_pipeline_put(pipe);
 	return ret;
diff --git a/drivers/media/platform/xilinx/xilinx-dma.c b/drivers/media/platform/xilinx/xilinx-dma.c
index f27a7be5f5d0f0b5..d171925168745e45 100644
--- a/drivers/media/platform/xilinx/xilinx-dma.c
+++ b/drivers/media/platform/xilinx/xilinx-dma.c
@@ -409,7 +409,7 @@ static int xvip_dma_start_streaming(struct vb2_queue *vq, unsigned int count)
 	pipe = dma->video.entity.pads->pipe
 	     ? to_xvip_pipeline(&dma->video.entity) : &dma->pipe;
 
-	ret = media_pipeline_start(&dma->video.entity, &pipe->pipe);
+	ret = media_pipeline_start(dma->video.entity.pads, &pipe->pipe);
 	if (ret < 0)
 		goto error;
 
@@ -435,7 +435,7 @@ static int xvip_dma_start_streaming(struct vb2_queue *vq, unsigned int count)
 	return 0;
 
 error_stop:
-	media_pipeline_stop(&dma->video.entity);
+	media_pipeline_stop(dma->video.entity.pads);
 
 error:
 	/* Give back all queued buffers to videobuf2. */
@@ -463,7 +463,7 @@ static void xvip_dma_stop_streaming(struct vb2_queue *vq)
 
 	/* Cleanup the pipeline and mark it as being stopped. */
 	xvip_pipeline_cleanup(pipe);
-	media_pipeline_stop(&dma->video.entity);
+	media_pipeline_stop(dma->video.entity.pads);
 
 	/* Give back all queued buffers to videobuf2. */
 	spin_lock_irq(&dma->queued_lock);
diff --git a/drivers/media/usb/au0828/au0828-core.c b/drivers/media/usb/au0828/au0828-core.c
index 1fdb1601dc653e64..32c2fe808113ea0b 100644
--- a/drivers/media/usb/au0828/au0828-core.c
+++ b/drivers/media/usb/au0828/au0828-core.c
@@ -396,7 +396,7 @@ static int au0828_enable_source(struct media_entity *entity,
 		goto end;
 	}
 
-	ret = __media_pipeline_start(entity, pipe);
+	ret = __media_pipeline_start(entity->pads, pipe);
 	if (ret) {
 		pr_err("Start Pipeline: %s->%s Error %d\n",
 			source->name, entity->name, ret);
@@ -447,7 +447,7 @@ static void au0828_disable_source(struct media_entity *entity)
 		*/
 		if (dev->active_link_owner != entity)
 			return;
-		__media_pipeline_stop(entity);
+		__media_pipeline_stop(entity->pads);
 		ret = __media_entity_setup_link(dev->active_link, 0);
 		if (ret)
 			pr_err("Deactivate link Error %d\n", ret);
diff --git a/drivers/staging/media/imx/imx-media-utils.c b/drivers/staging/media/imx/imx-media-utils.c
index ba9d9a8337cb159e..44bc20068876f15b 100644
--- a/drivers/staging/media/imx/imx-media-utils.c
+++ b/drivers/staging/media/imx/imx-media-utils.c
@@ -909,16 +909,16 @@ int imx_media_pipeline_set_stream(struct imx_media_dev *imxmd,
 	mutex_lock(&imxmd->md.graph_mutex);
 
 	if (on) {
-		ret = __media_pipeline_start(entity, &imxmd->pipe);
+		ret = __media_pipeline_start(entity->pads, &imxmd->pipe);
 		if (ret)
 			goto out;
 		ret = v4l2_subdev_call(sd, video, s_stream, 1);
 		if (ret)
-			__media_pipeline_stop(entity);
+			__media_pipeline_stop(entity->pads);
 	} else {
 		v4l2_subdev_call(sd, video, s_stream, 0);
 		if (entity->pads->pipe)
-			__media_pipeline_stop(entity);
+			__media_pipeline_stop(entity->pads);
 	}
 
 out:
diff --git a/drivers/staging/media/omap4iss/iss_video.c b/drivers/staging/media/omap4iss/iss_video.c
index 65f1e358271b3743..87f5d16b3a822692 100644
--- a/drivers/staging/media/omap4iss/iss_video.c
+++ b/drivers/staging/media/omap4iss/iss_video.c
@@ -895,7 +895,7 @@ iss_video_streamon(struct file *file, void *fh, enum v4l2_buf_type type)
 	if (video->iss->pdata->set_constraints)
 		video->iss->pdata->set_constraints(video->iss, true);
 
-	ret = media_pipeline_start(pad->entity, &pipe->pipe);
+	ret = media_pipeline_start(pad, &pipe->pipe);
 	if (ret < 0)
 		goto err_media_pipeline_start;
 
@@ -984,7 +984,7 @@ iss_video_streamon(struct file *file, void *fh, enum v4l2_buf_type type)
 err_omap4iss_set_stream:
 	vb2_streamoff(&vfh->queue, type);
 err_iss_video_check_format:
-	media_pipeline_stop(&video->video.entity);
+	media_pipeline_stop(video->video.entity.pads);
 err_media_pipeline_start:
 	if (video->iss->pdata->set_constraints)
 		video->iss->pdata->set_constraints(video->iss, false);
@@ -1038,7 +1038,7 @@ iss_video_streamoff(struct file *file, void *fh, enum v4l2_buf_type type)
 
 	if (video->iss->pdata->set_constraints)
 		video->iss->pdata->set_constraints(video->iss, false);
-	media_pipeline_stop(&video->video.entity);
+	media_pipeline_stop(video->video.entity.pads);
 
 done:
 	mutex_unlock(&video->stream_lock);
diff --git a/include/media/media-entity.h b/include/media/media-entity.h
index ca0b79288ea7fd11..8378f700389635ea 100644
--- a/include/media/media-entity.h
+++ b/include/media/media-entity.h
@@ -965,53 +965,54 @@ struct media_pad *media_graph_walk_next(struct media_graph *graph);
 
 /**
  * media_pipeline_start - Mark a pipeline as streaming
- * @entity: Starting entity
- * @pipe: Media pipeline to be assigned to all entities in the pipeline.
+ * @pad: Starting pad
+ * @pipe: Media pipeline to be assigned to all pads in the pipeline.
  *
- * Mark all entities connected to a given entity through enabled links, either
- * directly or indirectly, as streaming. The given pipeline object is assigned
- * to every entity in the pipeline and stored in the media_entity pipe field.
+ * Mark all pads connected to a given pad through enabled
+ * routes or links, either directly or indirectly, as streaming. The
+ * given pipeline object is assigned to every pad in the pipeline
+ * and stored in the media_pad pipe field.
  *
  * Calls to this function can be nested, in which case the same number of
  * media_pipeline_stop() calls will be required to stop streaming. The
  * pipeline pointer must be identical for all nested calls to
  * media_pipeline_start().
  */
-__must_check int media_pipeline_start(struct media_entity *entity,
+__must_check int media_pipeline_start(struct media_pad *pad,
 				      struct media_pipeline *pipe);
 /**
  * __media_pipeline_start - Mark a pipeline as streaming
  *
- * @entity: Starting entity
- * @pipe: Media pipeline to be assigned to all entities in the pipeline.
+ * @pad: Starting pad
+ * @pipe: Media pipeline to be assigned to all pads in the pipeline.
  *
  * ..note:: This is the non-locking version of media_pipeline_start()
  */
-__must_check int __media_pipeline_start(struct media_entity *entity,
+__must_check int __media_pipeline_start(struct media_pad *pad,
 					struct media_pipeline *pipe);
 
 /**
  * media_pipeline_stop - Mark a pipeline as not streaming
- * @entity: Starting entity
+ * @pad: Starting pad
  *
- * Mark all entities connected to a given entity through enabled links, either
- * directly or indirectly, as not streaming. The media_entity pipe field is
- * reset to %NULL.
+ * Mark all pads connected to a given pad through enabled routes or
+ * links, either directly or indirectly, as not streaming. The
+ * media_pad pipe field is reset to %NULL.
  *
  * If multiple calls to media_pipeline_start() have been made, the same
  * number of calls to this function are required to mark the pipeline as not
  * streaming.
  */
-void media_pipeline_stop(struct media_entity *entity);
+void media_pipeline_stop(struct media_pad *pad);
 
 /**
  * __media_pipeline_stop - Mark a pipeline as not streaming
  *
- * @entity: Starting entity
+ * @pad: Starting pad
  *
  * .. note:: This is the non-locking version of media_pipeline_stop()
  */
-void __media_pipeline_stop(struct media_entity *entity);
+void __media_pipeline_stop(struct media_pad *pad);
 
 /**
  * media_devnode_create() - creates and initializes a device node interface
-- 
2.19.1
