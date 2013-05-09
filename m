Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:35584 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754917Ab3EIPhX (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 9 May 2013 11:37:23 -0400
Received: from epcpsbgm1.samsung.com (epcpsbgm1 [203.254.230.26])
 by mailout1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MMJ00DJCFEAKSV0@mailout1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 10 May 2013 00:37:22 +0900 (KST)
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: hj210.choi@samsung.com, dh09.lee@samsung.com, a.hajda@samsung.com,
	shaik.ameer@samsung.com, arun.kk@samsung.com,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>
Subject: [PATCH 04/13] exynos4-is: Add struct exynos_video_entity
Date: Thu, 09 May 2013 17:36:36 +0200
Message-id: <1368113805-20233-5-git-send-email-s.nawrocki@samsung.com>
In-reply-to: <1368113805-20233-1-git-send-email-s.nawrocki@samsung.com>
References: <1368113805-20233-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch introduces common structure for the video entities
to handle all video nodes and media pipelines associated with
them in more generic way.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/platform/exynos4-is/fimc-capture.c  |   43 ++++++++++++---------
 drivers/media/platform/exynos4-is/fimc-core.h     |    4 +-
 drivers/media/platform/exynos4-is/fimc-lite-reg.c |    2 +-
 drivers/media/platform/exynos4-is/fimc-lite.c     |   20 +++++-----
 drivers/media/platform/exynos4-is/fimc-lite.h     |    4 +-
 drivers/media/platform/exynos4-is/fimc-reg.c      |    7 ++--
 drivers/media/platform/exynos4-is/media-dev.c     |    4 +-
 drivers/media/platform/exynos4-is/media-dev.h     |    8 ++--
 include/media/s5p_fimc.h                          |    5 +++
 9 files changed, 55 insertions(+), 42 deletions(-)

diff --git a/drivers/media/platform/exynos4-is/fimc-capture.c b/drivers/media/platform/exynos4-is/fimc-capture.c
index 528f413..be4387b 100644
--- a/drivers/media/platform/exynos4-is/fimc-capture.c
+++ b/drivers/media/platform/exynos4-is/fimc-capture.c
@@ -320,6 +320,7 @@ static void buffer_queue(struct vb2_buffer *vb);
 int fimc_capture_resume(struct fimc_dev *fimc)
 {
 	struct fimc_vid_cap *vid_cap = &fimc->vid_cap;
+	struct exynos_video_entity *ve = &vid_cap->ve;
 	struct fimc_vid_buffer *buf;
 	int i;
 
@@ -329,7 +330,7 @@ int fimc_capture_resume(struct fimc_dev *fimc)
 	INIT_LIST_HEAD(&fimc->vid_cap.active_buf_q);
 	vid_cap->buf_index = 0;
 	fimc_pipeline_call(fimc, open, &fimc->pipeline,
-			   &vid_cap->vfd.entity, false);
+			   &ve->vdev.entity, false);
 	fimc_capture_hw_init(fimc);
 
 	clear_bit(ST_CAPT_SUSPENDED, &fimc->state);
@@ -397,7 +398,7 @@ static int buffer_prepare(struct vb2_buffer *vb)
 		unsigned long size = ctx->d_frame.payload[i];
 
 		if (vb2_plane_size(vb, i) < size) {
-			v4l2_err(&ctx->fimc_dev->vid_cap.vfd,
+			v4l2_err(&ctx->fimc_dev->vid_cap.ve.vdev,
 				 "User buffer too small (%ld < %ld)\n",
 				 vb2_plane_size(vb, i), size);
 			return -EINVAL;
@@ -415,6 +416,7 @@ static void buffer_queue(struct vb2_buffer *vb)
 	struct fimc_ctx *ctx = vb2_get_drv_priv(vb->vb2_queue);
 	struct fimc_dev *fimc = ctx->fimc_dev;
 	struct fimc_vid_cap *vid_cap = &fimc->vid_cap;
+	struct exynos_video_entity *ve = &vid_cap->ve;
 	unsigned long flags;
 	int min_bufs;
 
@@ -454,7 +456,7 @@ static void buffer_queue(struct vb2_buffer *vb)
 
 		ret = fimc_pipeline_call(fimc, set_stream, &fimc->pipeline, 1);
 		if (ret < 0)
-			v4l2_err(&vid_cap->vfd, "stream on failed: %d\n", ret);
+			v4l2_err(&ve->vdev, "stream on failed: %d\n", ret);
 		return;
 	}
 	spin_unlock_irqrestore(&fimc->slock, flags);
@@ -503,11 +505,12 @@ static int fimc_capture_set_default_format(struct fimc_dev *fimc);
 static int fimc_capture_open(struct file *file)
 {
 	struct fimc_dev *fimc = video_drvdata(file);
+	struct exynos_video_entity *ve = &fimc->vid_cap.ve;
 	int ret = -EBUSY;
 
 	dbg("pid: %d, state: 0x%lx", task_pid_nr(current), fimc->state);
 
-	fimc_md_graph_lock(fimc);
+	fimc_md_graph_lock(ve);
 	mutex_lock(&fimc->lock);
 
 	if (fimc_m2m_active(fimc))
@@ -526,7 +529,7 @@ static int fimc_capture_open(struct file *file)
 
 	if (v4l2_fh_is_singular_file(file)) {
 		ret = fimc_pipeline_call(fimc, open, &fimc->pipeline,
-					 &fimc->vid_cap.vfd.entity, true);
+					 &fimc->vid_cap.ve.vdev.entity, true);
 
 		if (!ret && !fimc->vid_cap.user_subdev_api)
 			ret = fimc_capture_set_default_format(fimc);
@@ -544,7 +547,7 @@ static int fimc_capture_open(struct file *file)
 	}
 unlock:
 	mutex_unlock(&fimc->lock);
-	fimc_md_graph_unlock(fimc);
+	fimc_md_graph_unlock(ve);
 	return ret;
 }
 
@@ -560,7 +563,7 @@ static int fimc_capture_release(struct file *file)
 
 	if (v4l2_fh_is_singular_file(file)) {
 		if (vc->streaming) {
-			media_entity_pipeline_stop(&vc->vfd.entity);
+			media_entity_pipeline_stop(&vc->ve.vdev.entity);
 			vc->streaming = false;
 		}
 		clear_bit(ST_CAPT_BUSY, &fimc->state);
@@ -935,11 +938,12 @@ static int fimc_cap_try_fmt_mplane(struct file *file, void *fh,
 	struct v4l2_pix_format_mplane *pix = &f->fmt.pix_mp;
 	struct fimc_dev *fimc = video_drvdata(file);
 	struct fimc_ctx *ctx = fimc->vid_cap.ctx;
+	struct exynos_video_entity *ve = &fimc->vid_cap.ve;
 	struct v4l2_mbus_framefmt mf;
 	struct fimc_fmt *ffmt = NULL;
 	int ret = 0;
 
-	fimc_md_graph_lock(fimc);
+	fimc_md_graph_lock(ve);
 	mutex_lock(&fimc->lock);
 
 	if (fimc_jpeg_fourcc(pix->pixelformat)) {
@@ -975,7 +979,7 @@ static int fimc_cap_try_fmt_mplane(struct file *file, void *fh,
 					pix->plane_fmt, ffmt->memplanes, true);
 unlock:
 	mutex_unlock(&fimc->lock);
-	fimc_md_graph_unlock(fimc);
+	fimc_md_graph_unlock(ve);
 
 	return ret;
 }
@@ -1076,7 +1080,7 @@ static int fimc_cap_s_fmt_mplane(struct file *file, void *priv,
 	struct fimc_dev *fimc = video_drvdata(file);
 	int ret;
 
-	fimc_md_graph_lock(fimc);
+	fimc_md_graph_lock(&fimc->vid_cap.ve);
 	mutex_lock(&fimc->lock);
 	/*
 	 * The graph is walked within __fimc_capture_set_format() to set
@@ -1088,8 +1092,8 @@ static int fimc_cap_s_fmt_mplane(struct file *file, void *priv,
 	 */
 	ret = __fimc_capture_set_format(fimc, f);
 
+	fimc_md_graph_unlock(&fimc->vid_cap.ve);
 	mutex_unlock(&fimc->lock);
-	fimc_md_graph_unlock(fimc);
 	return ret;
 }
 
@@ -1209,7 +1213,7 @@ static int fimc_cap_streamon(struct file *file, void *priv,
 	struct fimc_dev *fimc = video_drvdata(file);
 	struct fimc_pipeline *p = &fimc->pipeline;
 	struct fimc_vid_cap *vc = &fimc->vid_cap;
-	struct media_entity *entity = &vc->vfd.entity;
+	struct media_entity *entity = &vc->ve.vdev.entity;
 	struct fimc_source_info *si = NULL;
 	struct v4l2_subdev *sd;
 	int ret;
@@ -1259,14 +1263,15 @@ static int fimc_cap_streamoff(struct file *file, void *priv,
 			    enum v4l2_buf_type type)
 {
 	struct fimc_dev *fimc = video_drvdata(file);
+	struct fimc_vid_cap *vc = &fimc->vid_cap;
 	int ret;
 
 	ret = vb2_ioctl_streamoff(file, priv, type);
 	if (ret < 0)
 		return ret;
 
-	media_entity_pipeline_stop(&fimc->vid_cap.vfd.entity);
-	fimc->vid_cap.streaming = false;
+	media_entity_pipeline_stop(&vc->ve.vdev.entity);
+	vc->streaming = false;
 	return 0;
 }
 
@@ -1735,7 +1740,7 @@ static int fimc_capture_set_default_format(struct fimc_dev *fimc)
 static int fimc_register_capture_device(struct fimc_dev *fimc,
 				 struct v4l2_device *v4l2_dev)
 {
-	struct video_device *vfd = &fimc->vid_cap.vfd;
+	struct video_device *vfd = &fimc->vid_cap.ve.vdev;
 	struct vb2_queue *q = &fimc->vid_cap.vbq;
 	struct fimc_ctx *ctx;
 	struct fimc_vid_cap *vid_cap;
@@ -1840,15 +1845,17 @@ static int fimc_capture_subdev_registered(struct v4l2_subdev *sd)
 static void fimc_capture_subdev_unregistered(struct v4l2_subdev *sd)
 {
 	struct fimc_dev *fimc = v4l2_get_subdevdata(sd);
+	struct video_device *vdev;
 
 	if (fimc == NULL)
 		return;
 
 	fimc_unregister_m2m_device(fimc);
+	vdev = &fimc->vid_cap.ve.vdev;
 
-	if (video_is_registered(&fimc->vid_cap.vfd)) {
-		video_unregister_device(&fimc->vid_cap.vfd);
-		media_entity_cleanup(&fimc->vid_cap.vfd.entity);
+	if (video_is_registered(vdev)) {
+		video_unregister_device(vdev);
+		media_entity_cleanup(&vdev->entity);
 		fimc->pipeline_ops = NULL;
 	}
 	kfree(fimc->vid_cap.ctx);
diff --git a/drivers/media/platform/exynos4-is/fimc-core.h b/drivers/media/platform/exynos4-is/fimc-core.h
index 539a3f7..dfecef6 100644
--- a/drivers/media/platform/exynos4-is/fimc-core.h
+++ b/drivers/media/platform/exynos4-is/fimc-core.h
@@ -283,8 +283,8 @@ struct fimc_m2m_device {
 /**
  * struct fimc_vid_cap - camera capture device information
  * @ctx: hardware context data
- * @vfd: video device node for camera capture mode
  * @subdev: subdev exposing the FIMC processing block
+ * @ve: exynos video device entity structure
  * @vd_pad: fimc video capture node pad
  * @sd_pads: fimc video processing block pads
  * @ci_fmt: image format at the FIMC camera input (and the scaler output)
@@ -305,8 +305,8 @@ struct fimc_m2m_device {
 struct fimc_vid_cap {
 	struct fimc_ctx			*ctx;
 	struct vb2_alloc_ctx		*alloc_ctx;
-	struct video_device		vfd;
 	struct v4l2_subdev		subdev;
+	struct exynos_video_entity	ve;
 	struct media_pad		vd_pad;
 	struct media_pad		sd_pads[FIMC_SD_PADS_NUM];
 	struct v4l2_mbus_framefmt	ci_fmt;
diff --git a/drivers/media/platform/exynos4-is/fimc-lite-reg.c b/drivers/media/platform/exynos4-is/fimc-lite-reg.c
index 8cc0d39..eb4f763 100644
--- a/drivers/media/platform/exynos4-is/fimc-lite-reg.c
+++ b/drivers/media/platform/exynos4-is/fimc-lite-reg.c
@@ -137,7 +137,7 @@ void flite_hw_set_source_format(struct fimc_lite *dev, struct flite_frame *f)
 	}
 
 	if (i == 0 && src_pixfmt_map[i][0] != pixelcode) {
-		v4l2_err(&dev->vfd,
+		v4l2_err(&dev->ve.vdev,
 			 "Unsupported pixel code, falling back to %#08x\n",
 			 src_pixfmt_map[i][0]);
 	}
diff --git a/drivers/media/platform/exynos4-is/fimc-lite.c b/drivers/media/platform/exynos4-is/fimc-lite.c
index 66480e7..a68c9c6 100644
--- a/drivers/media/platform/exynos4-is/fimc-lite.c
+++ b/drivers/media/platform/exynos4-is/fimc-lite.c
@@ -392,7 +392,7 @@ static int buffer_prepare(struct vb2_buffer *vb)
 		unsigned long size = fimc->payload[i];
 
 		if (vb2_plane_size(vb, i) < size) {
-			v4l2_err(&fimc->vfd,
+			v4l2_err(&fimc->ve.vdev,
 				 "User buffer too small (%ld < %ld)\n",
 				 vb2_plane_size(vb, i), size);
 			return -EINVAL;
@@ -458,7 +458,7 @@ static void fimc_lite_clear_event_counters(struct fimc_lite *fimc)
 static int fimc_lite_open(struct file *file)
 {
 	struct fimc_lite *fimc = video_drvdata(file);
-	struct media_entity *me = &fimc->vfd.entity;
+	struct media_entity *me = &fimc->ve.vdev.entity;
 	int ret;
 
 	mutex_lock(&me->parent->graph_mutex);
@@ -509,7 +509,7 @@ static int fimc_lite_release(struct file *file)
 	if (v4l2_fh_is_singular_file(file) &&
 	    atomic_read(&fimc->out_path) == FIMC_IO_DMA) {
 		if (fimc->streaming) {
-			media_entity_pipeline_stop(&fimc->vfd.entity);
+			media_entity_pipeline_stop(&fimc->ve.vdev.entity);
 			fimc->streaming = false;
 		}
 		clear_bit(ST_FLITE_IN_USE, &fimc->state);
@@ -792,7 +792,7 @@ static int fimc_lite_streamon(struct file *file, void *priv,
 			      enum v4l2_buf_type type)
 {
 	struct fimc_lite *fimc = video_drvdata(file);
-	struct media_entity *entity = &fimc->vfd.entity;
+	struct media_entity *entity = &fimc->ve.vdev.entity;
 	struct fimc_pipeline *p = &fimc->pipeline;
 	int ret;
 
@@ -830,7 +830,7 @@ static int fimc_lite_streamoff(struct file *file, void *priv,
 	if (ret < 0)
 		return ret;
 
-	media_entity_pipeline_stop(&fimc->vfd.entity);
+	media_entity_pipeline_stop(&fimc->ve.vdev.entity);
 	fimc->streaming = false;
 	return 0;
 }
@@ -1234,7 +1234,7 @@ static int fimc_lite_subdev_registered(struct v4l2_subdev *sd)
 {
 	struct fimc_lite *fimc = v4l2_get_subdevdata(sd);
 	struct vb2_queue *q = &fimc->vb_queue;
-	struct video_device *vfd = &fimc->vfd;
+	struct video_device *vfd = &fimc->ve.vdev;
 	int ret;
 
 	memset(vfd, 0, sizeof(*vfd));
@@ -1298,9 +1298,9 @@ static void fimc_lite_subdev_unregistered(struct v4l2_subdev *sd)
 	if (fimc == NULL)
 		return;
 
-	if (video_is_registered(&fimc->vfd)) {
-		video_unregister_device(&fimc->vfd);
-		media_entity_cleanup(&fimc->vfd.entity);
+	if (video_is_registered(&fimc->ve.vdev)) {
+		video_unregister_device(&fimc->ve.vdev);
+		media_entity_cleanup(&fimc->ve.vdev.entity);
 		fimc->pipeline_ops = NULL;
 	}
 }
@@ -1548,7 +1548,7 @@ static int fimc_lite_resume(struct device *dev)
 
 	INIT_LIST_HEAD(&fimc->active_buf_q);
 	fimc_pipeline_call(fimc, open, &fimc->pipeline,
-			   &fimc->vfd.entity, false);
+			   &fimc->ve.vdev.entity, false);
 	fimc_lite_hw_init(fimc, atomic_read(&fimc->out_path) == FIMC_IO_ISP);
 	clear_bit(ST_FLITE_SUSPENDED, &fimc->state);
 
diff --git a/drivers/media/platform/exynos4-is/fimc-lite.h b/drivers/media/platform/exynos4-is/fimc-lite.h
index 47da5e0..fa3886a 100644
--- a/drivers/media/platform/exynos4-is/fimc-lite.h
+++ b/drivers/media/platform/exynos4-is/fimc-lite.h
@@ -95,8 +95,8 @@ struct flite_buffer {
  * struct fimc_lite - fimc lite structure
  * @pdev: pointer to FIMC-LITE platform device
  * @dd: SoC specific driver data structure
+ * @ve: exynos video device entity structure
  * @v4l2_dev: pointer to top the level v4l2_device
- * @vfd: video device node
  * @fh: v4l2 file handle
  * @alloc_ctx: videobuf2 memory allocator context
  * @subdev: FIMC-LITE subdev
@@ -130,8 +130,8 @@ struct flite_buffer {
 struct fimc_lite {
 	struct platform_device	*pdev;
 	struct flite_drvdata	*dd;
+	struct exynos_video_entity ve;
 	struct v4l2_device	*v4l2_dev;
-	struct video_device	vfd;
 	struct v4l2_fh		fh;
 	struct vb2_alloc_ctx	*alloc_ctx;
 	struct v4l2_subdev	subdev;
diff --git a/drivers/media/platform/exynos4-is/fimc-reg.c b/drivers/media/platform/exynos4-is/fimc-reg.c
index f079f36..1db8cb4 100644
--- a/drivers/media/platform/exynos4-is/fimc-reg.c
+++ b/drivers/media/platform/exynos4-is/fimc-reg.c
@@ -618,7 +618,7 @@ int fimc_hw_set_camera_source(struct fimc_dev *fimc,
 		}
 
 		if (i == ARRAY_SIZE(pix_desc)) {
-			v4l2_err(&vc->vfd,
+			v4l2_err(&vc->ve.vdev,
 				 "Camera color format not supported: %d\n",
 				 vc->ci_fmt.code);
 			return -EINVAL;
@@ -698,7 +698,7 @@ int fimc_hw_set_camera_type(struct fimc_dev *fimc,
 			cfg |= FIMC_REG_CIGCTRL_CAM_JPEG;
 			break;
 		default:
-			v4l2_err(&vid_cap->vfd,
+			v4l2_err(&vid_cap->ve.vdev,
 				 "Not supported camera pixel format: %#x\n",
 				 vid_cap->ci_fmt.code);
 			return -EINVAL;
@@ -721,7 +721,8 @@ int fimc_hw_set_camera_type(struct fimc_dev *fimc,
 			WARN_ONCE(1, "ISP Writeback input is not supported\n");
 		break;
 	default:
-		v4l2_err(&vid_cap->vfd, "Invalid FIMC bus type selected: %d\n",
+		v4l2_err(&vid_cap->ve.vdev,
+			 "Invalid FIMC bus type selected: %d\n",
 			 source->fimc_bus_type);
 		return -EINVAL;
 	}
diff --git a/drivers/media/platform/exynos4-is/media-dev.c b/drivers/media/platform/exynos4-is/media-dev.c
index 15ef8f2..032d2b7 100644
--- a/drivers/media/platform/exynos4-is/media-dev.c
+++ b/drivers/media/platform/exynos4-is/media-dev.c
@@ -929,7 +929,7 @@ static int __fimc_md_create_flite_source_links(struct fimc_md *fmd)
 			continue;
 
 		source = &fimc->subdev.entity;
-		sink = &fimc->vfd.entity;
+		sink = &fimc->ve.vdev.entity;
 		/* FIMC-LITE's subdev and video node */
 		ret = media_entity_create_link(source, FLITE_SD_PAD_SOURCE_DMA,
 					       sink, 0, 0);
@@ -1066,7 +1066,7 @@ static int fimc_md_create_links(struct fimc_md *fmd)
 			continue;
 
 		source = &fmd->fimc[i]->vid_cap.subdev.entity;
-		sink = &fmd->fimc[i]->vid_cap.vfd.entity;
+		sink = &fmd->fimc[i]->vid_cap.ve.vdev.entity;
 
 		ret = media_entity_create_link(source, FIMC_SD_PAD_SOURCE,
 					      sink, 0, flags);
diff --git a/drivers/media/platform/exynos4-is/media-dev.h b/drivers/media/platform/exynos4-is/media-dev.h
index 44d86b6..3e9680c 100644
--- a/drivers/media/platform/exynos4-is/media-dev.h
+++ b/drivers/media/platform/exynos4-is/media-dev.h
@@ -127,14 +127,14 @@ static inline struct fimc_md *entity_to_fimc_mdev(struct media_entity *me)
 		container_of(me->parent, struct fimc_md, media_dev);
 }
 
-static inline void fimc_md_graph_lock(struct fimc_dev *fimc)
+static inline void fimc_md_graph_lock(struct exynos_video_entity *ve)
 {
-	mutex_lock(&fimc->vid_cap.vfd.entity.parent->graph_mutex);
+	mutex_lock(&ve->vdev.entity.parent->graph_mutex);
 }
 
-static inline void fimc_md_graph_unlock(struct fimc_dev *fimc)
+static inline void fimc_md_graph_unlock(struct exynos_video_entity *ve)
 {
-	mutex_unlock(&fimc->vid_cap.vfd.entity.parent->graph_mutex);
+	mutex_unlock(&ve->vdev.entity.parent->graph_mutex);
 }
 
 int fimc_md_set_camclk(struct v4l2_subdev *sd, bool on);
diff --git a/include/media/s5p_fimc.h b/include/media/s5p_fimc.h
index f509690..f5313b4 100644
--- a/include/media/s5p_fimc.h
+++ b/include/media/s5p_fimc.h
@@ -13,6 +13,7 @@
 #define S5P_FIMC_H_
 
 #include <media/media-entity.h>
+#include <media/v4l2-dev.h>
 #include <media/v4l2-mediabus.h>
 
 /*
@@ -157,6 +158,10 @@ struct fimc_pipeline {
 	struct media_pipeline *m_pipeline;
 };
 
+struct exynos_video_entity {
+	struct video_device vdev;
+};
+
 /*
  * Media pipeline operations to be called from within the fimc(-lite)
  * video node when it is the last entity of the pipeline. Implemented
-- 
1.7.9.5

