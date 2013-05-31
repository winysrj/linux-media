Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:63469 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752463Ab3EaOk7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 31 May 2013 10:40:59 -0400
Received: from epcpsbgm1.samsung.com (epcpsbgm1 [203.254.230.26])
 by mailout4.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MNO00ELB3G99NW0@mailout4.samsung.com> for
 linux-media@vger.kernel.org; Fri, 31 May 2013 23:40:58 +0900 (KST)
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, hj210.choi@samsung.com,
	arun.kk@samsung.com, shaik.ameer@samsung.com,
	kyungmin.park@samsung.com,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [REVIEW PATCH v2 04/11] exynos4-is: Media graph/video device locking
 rework
Date: Fri, 31 May 2013 16:37:20 +0200
Message-id: <1370011047-11488-5-git-send-email-s.nawrocki@samsung.com>
In-reply-to: <1370011047-11488-1-git-send-email-s.nawrocki@samsung.com>
References: <1370011047-11488-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Remove driver private video node reference counters and use entity->use_count
instead. This makes the video pipelines power handling more similar to the
method used in omap3isp driver.

Now the graph mutex is taken always after the video mutex, as it is not
possible to ensure apposite order at the all modules.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
Changes since v1:
 - fixed use_count handling in fimc_lite_release() function.
---
 drivers/media/platform/exynos4-is/fimc-capture.c |   59 ++++++++++------------
 drivers/media/platform/exynos4-is/fimc-core.h    |    2 -
 drivers/media/platform/exynos4-is/fimc-lite.c    |   23 +++++----
 drivers/media/platform/exynos4-is/fimc-lite.h    |    2 -
 drivers/media/platform/exynos4-is/media-dev.c    |   12 +----
 5 files changed, 42 insertions(+), 56 deletions(-)

diff --git a/drivers/media/platform/exynos4-is/fimc-capture.c b/drivers/media/platform/exynos4-is/fimc-capture.c
index 762fc7b9..3b24f29 100644
--- a/drivers/media/platform/exynos4-is/fimc-capture.c
+++ b/drivers/media/platform/exynos4-is/fimc-capture.c
@@ -484,7 +484,6 @@ static int fimc_capture_open(struct file *file)
 
 	dbg("pid: %d, state: 0x%lx", task_pid_nr(current), fimc->state);
 
-	fimc_md_graph_lock(ve);
 	mutex_lock(&fimc->lock);
 
 	if (fimc_m2m_active(fimc))
@@ -502,6 +501,8 @@ static int fimc_capture_open(struct file *file)
 	}
 
 	if (v4l2_fh_is_singular_file(file)) {
+		fimc_md_graph_lock(ve);
+
 		ret = fimc_pipeline_call(fimc, open, &fimc->pipeline,
 					 &fimc->vid_cap.ve.vdev.entity, true);
 		if (ret == 0)
@@ -518,18 +519,19 @@ static int fimc_capture_open(struct file *file)
 			if (ret == 0)
 				vc->inh_sensor_ctrls = false;
 		}
+		if (ret == 0)
+			ve->vdev.entity.use_count++;
+
+		fimc_md_graph_unlock(ve);
 
 		if (ret < 0) {
 			clear_bit(ST_CAPT_BUSY, &fimc->state);
 			pm_runtime_put_sync(&fimc->pdev->dev);
 			v4l2_fh_release(file);
-		} else {
-			fimc->vid_cap.refcnt++;
 		}
 	}
 unlock:
 	mutex_unlock(&fimc->lock);
-	fimc_md_graph_unlock(ve);
 	return ret;
 }
 
@@ -537,26 +539,32 @@ static int fimc_capture_release(struct file *file)
 {
 	struct fimc_dev *fimc = video_drvdata(file);
 	struct fimc_vid_cap *vc = &fimc->vid_cap;
+	bool close = v4l2_fh_is_singular_file(file);
 	int ret;
 
 	dbg("pid: %d, state: 0x%lx", task_pid_nr(current), fimc->state);
 
 	mutex_lock(&fimc->lock);
 
-	if (v4l2_fh_is_singular_file(file)) {
-		if (vc->streaming) {
-			media_entity_pipeline_stop(&vc->ve.vdev.entity);
-			vc->streaming = false;
-		}
+	if (close && vc->streaming) {
+		media_entity_pipeline_stop(&vc->ve.vdev.entity);
+		vc->streaming = false;
+	}
+
+	ret = vb2_fop_release(file);
+
+	if (close) {
 		clear_bit(ST_CAPT_BUSY, &fimc->state);
 		fimc_stop_capture(fimc, false);
 		fimc_pipeline_call(fimc, close, &fimc->pipeline);
 		clear_bit(ST_CAPT_SUSPENDED, &fimc->state);
-		fimc->vid_cap.refcnt--;
+
+		fimc_md_graph_lock(&vc->ve);
+		vc->ve.vdev.entity.use_count--;
+		fimc_md_graph_unlock(&vc->ve);
 	}
 
 	pm_runtime_put(&fimc->pdev->dev);
-	ret = vb2_fop_release(file);
 	mutex_unlock(&fimc->lock);
 
 	return ret;
@@ -921,9 +929,6 @@ static int fimc_cap_try_fmt_mplane(struct file *file, void *fh,
 	struct fimc_fmt *ffmt = NULL;
 	int ret = 0;
 
-	fimc_md_graph_lock(ve);
-	mutex_lock(&fimc->lock);
-
 	if (fimc_jpeg_fourcc(pix->pixelformat)) {
 		fimc_capture_try_format(ctx, &pix->width, &pix->height,
 					NULL, &pix->pixelformat,
@@ -934,16 +939,18 @@ static int fimc_cap_try_fmt_mplane(struct file *file, void *fh,
 	ffmt = fimc_capture_try_format(ctx, &pix->width, &pix->height,
 				       NULL, &pix->pixelformat,
 				       FIMC_SD_PAD_SOURCE);
-	if (!ffmt) {
-		ret = -EINVAL;
-		goto unlock;
-	}
+	if (!ffmt)
+		return -EINVAL;
 
 	if (!fimc->vid_cap.user_subdev_api) {
 		mf.width = pix->width;
 		mf.height = pix->height;
 		mf.code = ffmt->mbus_code;
+
+		fimc_md_graph_lock(ve);
 		fimc_pipeline_try_format(ctx, &mf, &ffmt, false);
+		fimc_md_graph_unlock(ve);
+
 		pix->width = mf.width;
 		pix->height = mf.height;
 		if (ffmt)
@@ -955,9 +962,6 @@ static int fimc_cap_try_fmt_mplane(struct file *file, void *fh,
 	if (ffmt->flags & FMT_FLAGS_COMPRESSED)
 		fimc_get_sensor_frame_desc(fimc->pipeline.subdevs[IDX_SENSOR],
 					pix->plane_fmt, ffmt->memplanes, true);
-unlock:
-	mutex_unlock(&fimc->lock);
-	fimc_md_graph_unlock(ve);
 
 	return ret;
 }
@@ -1059,19 +1063,14 @@ static int fimc_cap_s_fmt_mplane(struct file *file, void *priv,
 	int ret;
 
 	fimc_md_graph_lock(&fimc->vid_cap.ve);
-	mutex_lock(&fimc->lock);
 	/*
 	 * The graph is walked within __fimc_capture_set_format() to set
 	 * the format at subdevs thus the graph mutex needs to be held at
-	 * this point and acquired before the video mutex, to avoid  AB-BA
-	 * deadlock when fimc_md_link_notify() is called by other thread.
-	 * Ideally the graph walking and setting format at the whole pipeline
-	 * should be removed from this driver and handled in userspace only.
+	 * this point.
 	 */
 	ret = __fimc_capture_set_format(fimc, f);
 
 	fimc_md_graph_unlock(&fimc->vid_cap.ve);
-	mutex_unlock(&fimc->lock);
 	return ret;
 }
 
@@ -1790,12 +1789,6 @@ static int fimc_register_capture_device(struct fimc_dev *fimc,
 	ret = fimc_ctrls_create(ctx);
 	if (ret)
 		goto err_me_cleanup;
-	/*
-	 * For proper order of acquiring/releasing the video
-	 * and the graph mutex.
-	 */
-	v4l2_disable_ioctl_locking(vfd, VIDIOC_TRY_FMT);
-	v4l2_disable_ioctl_locking(vfd, VIDIOC_S_FMT);
 
 	ret = video_register_device(vfd, VFL_TYPE_GRABBER, -1);
 	if (ret)
diff --git a/drivers/media/platform/exynos4-is/fimc-core.h b/drivers/media/platform/exynos4-is/fimc-core.h
index 86bb8e6..09c061d 100644
--- a/drivers/media/platform/exynos4-is/fimc-core.h
+++ b/drivers/media/platform/exynos4-is/fimc-core.h
@@ -300,7 +300,6 @@ struct fimc_m2m_device {
  * @frame_count: the frame counter for statistics
  * @reqbufs_count: the number of buffers requested in REQBUFS ioctl
  * @input_index: input (camera sensor) index
- * @refcnt: driver's private reference counter
  * @input: capture input type, grp_id of the attached subdev
  * @user_subdev_api: true if subdevs are not configured by the host driver
  * @inh_sensor_ctrls: a flag indicating v4l2 controls are inherited from
@@ -325,7 +324,6 @@ struct fimc_vid_cap {
 	unsigned int			reqbufs_count;
 	bool				streaming;
 	int				input_index;
-	int				refcnt;
 	u32				input;
 	bool				user_subdev_api;
 	bool				inh_sensor_ctrls;
diff --git a/drivers/media/platform/exynos4-is/fimc-lite.c b/drivers/media/platform/exynos4-is/fimc-lite.c
index a68c9c6..1da3ed1 100644
--- a/drivers/media/platform/exynos4-is/fimc-lite.c
+++ b/drivers/media/platform/exynos4-is/fimc-lite.c
@@ -461,8 +461,6 @@ static int fimc_lite_open(struct file *file)
 	struct media_entity *me = &fimc->ve.vdev.entity;
 	int ret;
 
-	mutex_lock(&me->parent->graph_mutex);
-
 	mutex_lock(&fimc->lock);
 	if (atomic_read(&fimc->out_path) != FIMC_IO_DMA) {
 		ret = -EBUSY;
@@ -482,11 +480,19 @@ static int fimc_lite_open(struct file *file)
 	    atomic_read(&fimc->out_path) != FIMC_IO_DMA)
 		goto unlock;
 
+	mutex_lock(&me->parent->graph_mutex);
+
 	ret = fimc_pipeline_call(fimc, open, &fimc->pipeline,
 						me, true);
+
+	/* Mark video pipeline ending at this video node as in use. */
+	if (ret == 0)
+		me->use_count++;
+
+	mutex_unlock(&me->parent->graph_mutex);
+
 	if (!ret) {
 		fimc_lite_clear_event_counters(fimc);
-		fimc->ref_count++;
 		goto unlock;
 	}
 
@@ -496,26 +502,28 @@ err_pm:
 	clear_bit(ST_FLITE_IN_USE, &fimc->state);
 unlock:
 	mutex_unlock(&fimc->lock);
-	mutex_unlock(&me->parent->graph_mutex);
 	return ret;
 }
 
 static int fimc_lite_release(struct file *file)
 {
 	struct fimc_lite *fimc = video_drvdata(file);
+	struct media_entity *entity = &fimc->ve.vdev.entity;
 
 	mutex_lock(&fimc->lock);
 
 	if (v4l2_fh_is_singular_file(file) &&
 	    atomic_read(&fimc->out_path) == FIMC_IO_DMA) {
 		if (fimc->streaming) {
-			media_entity_pipeline_stop(&fimc->ve.vdev.entity);
+			media_entity_pipeline_stop(entity);
 			fimc->streaming = false;
 		}
 		clear_bit(ST_FLITE_IN_USE, &fimc->state);
 		fimc_lite_stop_capture(fimc, false);
 		fimc_pipeline_call(fimc, close, &fimc->pipeline);
-		fimc->ref_count--;
+		mutex_lock(&entity->parent->graph_mutex);
+		entity->use_count--;
+		mutex_unlock(&entity->parent->graph_mutex);
 	}
 
 	vb2_fop_release(file);
@@ -954,8 +962,6 @@ static int fimc_lite_link_setup(struct media_entity *entity,
 		 __func__, remote->entity->name, local->entity->name,
 		 flags, fimc->source_subdev_grp_id);
 
-	mutex_lock(&fimc->lock);
-
 	switch (local->index) {
 	case FLITE_SD_PAD_SINK:
 		if (remote_ent_type != MEDIA_ENT_T_V4L2_SUBDEV) {
@@ -997,7 +1003,6 @@ static int fimc_lite_link_setup(struct media_entity *entity,
 	}
 	mb();
 
-	mutex_unlock(&fimc->lock);
 	return ret;
 }
 
diff --git a/drivers/media/platform/exynos4-is/fimc-lite.h b/drivers/media/platform/exynos4-is/fimc-lite.h
index fa3886a..25abba9 100644
--- a/drivers/media/platform/exynos4-is/fimc-lite.h
+++ b/drivers/media/platform/exynos4-is/fimc-lite.h
@@ -125,7 +125,6 @@ struct flite_buffer {
  * @active_buf_count: number of video buffers scheduled in hardware
  * @frame_count: the captured frames counter
  * @reqbufs_count: the number of buffers requested with REQBUFS ioctl
- * @ref_count: driver's private reference counter
  */
 struct fimc_lite {
 	struct platform_device	*pdev;
@@ -163,7 +162,6 @@ struct fimc_lite {
 	struct vb2_queue	vb_queue;
 	unsigned int		frame_count;
 	unsigned int		reqbufs_count;
-	int			ref_count;
 
 	struct fimc_lite_events	events;
 	bool			streaming;
diff --git a/drivers/media/platform/exynos4-is/media-dev.c b/drivers/media/platform/exynos4-is/media-dev.c
index 122a6ba..416dbcb 100644
--- a/drivers/media/platform/exynos4-is/media-dev.c
+++ b/drivers/media/platform/exynos4-is/media-dev.c
@@ -1238,9 +1238,7 @@ static int fimc_md_link_notify(struct media_pad *source,
 	struct fimc_dev *fimc = NULL;
 	struct fimc_pipeline *pipeline;
 	struct v4l2_subdev *sd;
-	struct mutex *lock;
 	int i, ret = 0;
-	int ref_count;
 
 	if (media_entity_type(sink->entity) != MEDIA_ENT_T_V4L2_SUBDEV)
 		return 0;
@@ -1253,29 +1251,24 @@ static int fimc_md_link_notify(struct media_pad *source,
 		if (WARN_ON(fimc_lite == NULL))
 			return 0;
 		pipeline = &fimc_lite->pipeline;
-		lock = &fimc_lite->lock;
 		break;
 	case GRP_ID_FIMC:
 		fimc = v4l2_get_subdevdata(sd);
 		if (WARN_ON(fimc == NULL))
 			return 0;
 		pipeline = &fimc->pipeline;
-		lock = &fimc->lock;
 		break;
 	default:
 		return 0;
 	}
 
-	mutex_lock(lock);
-	ref_count = fimc ? fimc->vid_cap.refcnt : fimc_lite->ref_count;
-
 	if (!(flags & MEDIA_LNK_FL_ENABLED)) {
-		if (ref_count > 0) {
+		if (sink->entity->use_count > 0) {
 			ret = __fimc_pipeline_close(pipeline);
 		}
 		for (i = 0; i < IDX_MAX; i++)
 			pipeline->subdevs[i] = NULL;
-	} else if (ref_count > 0) {
+	} else if (sink->entity->use_count > 0) {
 		/*
 		 * Link activation. Enable power of pipeline elements only if
 		 * the pipeline is already in use, i.e. its video node is open.
@@ -1285,7 +1278,6 @@ static int fimc_md_link_notify(struct media_pad *source,
 					   source->entity, true);
 	}
 
-	mutex_unlock(lock);
 	return ret ? -EPIPE : ret;
 }
 
-- 
1.7.9.5

