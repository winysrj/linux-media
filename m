Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:17536 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753446Ab3ACPpa (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 3 Jan 2013 10:45:30 -0500
Received: from epcpsbgm2.samsung.com (epcpsbgm2 [203.254.230.27])
 by mailout4.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MG2008YN3RCGY30@mailout4.samsung.com> for
 linux-media@vger.kernel.org; Fri, 04 Jan 2013 00:45:28 +0900 (KST)
Received: from amdc1344.digital.local ([106.116.147.32])
 by mmp2.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTPA id <0MG2002B73RD7GA0@mmp2.samsung.com> for
 linux-media@vger.kernel.org; Fri, 04 Jan 2013 00:45:28 +0900 (KST)
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>
Subject: [PATCH 5/5] s5p-fimc: Prevent AB-BA deadlock during links
 reconfiguration
Date: Thu, 03 Jan 2013 16:45:10 +0100
Message-id: <1357227910-28870-5-git-send-email-s.nawrocki@samsung.com>
In-reply-to: <1357227910-28870-1-git-send-email-s.nawrocki@samsung.com>
References: <1357227910-28870-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch patch eliminates potential AB-BA deadlock when one process calls
open(), or VIDIOC_S/TRY_FMT ioctl  on the FIMC capture video node, while
other thread is reconfiguring media links via media device node:

/dev/video? open()		  /dev/media? MEDIA_IOC_SETUP_LINK ioctl

mutex_lock(video_lock)            mutex_lock(graph_lock)
    fimc_pipeline_open()               fimc_md_link_notify()
        mutex_lock(graph_lock)	          mutex_lock(video_lock)
          ...                               ...

The deadlock is avoided by always taking the graph mutex first in video
node open() or an ioctl, before the video lock is acquired. Reversed
order seems impossible, since media device driver's link_notify callback
is called with media graph mutex already held.

To ensure proper locking order VIDIOC_S_FMT and VIDIOC_TRY_FMT ioctls are
not serialized in the v4l2-core and the driver takes care of it itself.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/platform/s5p-fimc/fimc-capture.c |   54 ++++++++++----
 drivers/media/platform/s5p-fimc/fimc-lite.c    |    6 +-
 drivers/media/platform/s5p-fimc/fimc-mdevice.c |   94 +++++++++---------------
 3 files changed, 78 insertions(+), 76 deletions(-)

diff --git a/drivers/media/platform/s5p-fimc/fimc-capture.c b/drivers/media/platform/s5p-fimc/fimc-capture.c
index aad0850..18a70e4 100644
--- a/drivers/media/platform/s5p-fimc/fimc-capture.c
+++ b/drivers/media/platform/s5p-fimc/fimc-capture.c
@@ -510,8 +510,8 @@ static int fimc_capture_open(struct file *file)
 
 	dbg("pid: %d, state: 0x%lx", task_pid_nr(current), fimc->state);
 
-	if (mutex_lock_interruptible(&fimc->lock))
-		return -ERESTARTSYS;
+	fimc_md_graph_lock(fimc);
+	mutex_lock(&fimc->lock);
 
 	if (fimc_m2m_active(fimc))
 		goto unlock;
@@ -546,6 +546,7 @@ static int fimc_capture_open(struct file *file)
 	}
 unlock:
 	mutex_unlock(&fimc->lock);
+	fimc_md_graph_unlock(fimc);
 	return ret;
 }
 
@@ -962,6 +963,10 @@ static int fimc_cap_try_fmt_mplane(struct file *file, void *fh,
 	struct fimc_ctx *ctx = fimc->vid_cap.ctx;
 	struct v4l2_mbus_framefmt mf;
 	struct fimc_fmt *ffmt = NULL;
+	int ret = 0;
+
+	fimc_md_graph_lock(fimc);
+	mutex_lock(&fimc->lock);
 
 	if (fimc_jpeg_fourcc(pix->pixelformat)) {
 		fimc_capture_try_format(ctx, &pix->width, &pix->height,
@@ -973,16 +978,16 @@ static int fimc_cap_try_fmt_mplane(struct file *file, void *fh,
 	ffmt = fimc_capture_try_format(ctx, &pix->width, &pix->height,
 				       NULL, &pix->pixelformat,
 				       FIMC_SD_PAD_SOURCE);
-	if (!ffmt)
-		return -EINVAL;
+	if (!ffmt) {
+		ret = -EINVAL;
+		goto unlock;
+	}
 
 	if (!fimc->vid_cap.user_subdev_api) {
 		mf.width = pix->width;
 		mf.height = pix->height;
 		mf.code = ffmt->mbus_code;
-		fimc_md_graph_lock(fimc);
 		fimc_pipeline_try_format(ctx, &mf, &ffmt, false);
-		fimc_md_graph_unlock(fimc);
 		pix->width = mf.width;
 		pix->height = mf.height;
 		if (ffmt)
@@ -994,8 +999,11 @@ static int fimc_cap_try_fmt_mplane(struct file *file, void *fh,
 	if (ffmt->flags & FMT_FLAGS_COMPRESSED)
 		fimc_get_sensor_frame_desc(fimc->pipeline.subdevs[IDX_SENSOR],
 					pix->plane_fmt, ffmt->memplanes, true);
+unlock:
+	mutex_unlock(&fimc->lock);
+	fimc_md_graph_unlock(fimc);
 
-	return 0;
+	return ret;
 }
 
 static void fimc_capture_mark_jpeg_xfer(struct fimc_ctx *ctx,
@@ -1012,7 +1020,8 @@ static void fimc_capture_mark_jpeg_xfer(struct fimc_ctx *ctx,
 		clear_bit(ST_CAPT_JPEG, &ctx->fimc_dev->state);
 }
 
-static int fimc_capture_set_format(struct fimc_dev *fimc, struct v4l2_format *f)
+static int __fimc_capture_set_format(struct fimc_dev *fimc,
+				     struct v4l2_format *f)
 {
 	struct fimc_ctx *ctx = fimc->vid_cap.ctx;
 	struct v4l2_pix_format_mplane *pix = &f->fmt.pix_mp;
@@ -1047,12 +1056,10 @@ static int fimc_capture_set_format(struct fimc_dev *fimc, struct v4l2_format *f)
 		mf->code   = ff->fmt->mbus_code;
 		mf->width  = pix->width;
 		mf->height = pix->height;
-
-		fimc_md_graph_lock(fimc);
 		ret = fimc_pipeline_try_format(ctx, mf, &s_fmt, true);
-		fimc_md_graph_unlock(fimc);
 		if (ret)
 			return ret;
+
 		pix->width  = mf->width;
 		pix->height = mf->height;
 	}
@@ -1091,8 +1098,23 @@ static int fimc_cap_s_fmt_mplane(struct file *file, void *priv,
 				 struct v4l2_format *f)
 {
 	struct fimc_dev *fimc = video_drvdata(file);
+	int ret;
+
+	fimc_md_graph_lock(fimc);
+	mutex_lock(&fimc->lock);
+	/*
+	 * The graph is walked within __fimc_capture_set_format() to set
+	 * the format at subdevs thus the graph mutex needs to be held at
+	 * this point and acquired before the video mutex, to avoid  AB-BA
+	 * deadlock when fimc_md_link_notify() is called by other thread.
+	 * Ideally the graph walking and setting format at the whole pipeline
+	 * should be removed from this driver and handled in userspace only.
+	 */
+	ret = __fimc_capture_set_format(fimc, f);
 
-	return fimc_capture_set_format(fimc, f);
+	mutex_unlock(&fimc->lock);
+	fimc_md_graph_unlock(fimc);
+	return ret;
 }
 
 static int fimc_cap_enum_input(struct file *file, void *priv,
@@ -1727,7 +1749,7 @@ static int fimc_capture_set_default_format(struct fimc_dev *fimc)
 		},
 	};
 
-	return fimc_capture_set_format(fimc, &fmt);
+	return __fimc_capture_set_format(fimc, &fmt);
 }
 
 /* fimc->lock must be already initialized */
@@ -1789,6 +1811,12 @@ static int fimc_register_capture_device(struct fimc_dev *fimc,
 	ret = media_entity_init(&vfd->entity, 1, &vid_cap->vd_pad, 0);
 	if (ret)
 		goto err_ent;
+	/*
+	 * For proper order of acquiring/releasing the video
+	 * and the graph mutex.
+	 */
+	v4l2_disable_ioctl_locking(vfd, VIDIOC_TRY_FMT);
+	v4l2_disable_ioctl_locking(vfd, VIDIOC_S_FMT);
 
 	ret = video_register_device(vfd, VFL_TYPE_GRABBER, -1);
 	if (ret)
diff --git a/drivers/media/platform/s5p-fimc/fimc-lite.c b/drivers/media/platform/s5p-fimc/fimc-lite.c
index 765b8e4..ef31c39 100644
--- a/drivers/media/platform/s5p-fimc/fimc-lite.c
+++ b/drivers/media/platform/s5p-fimc/fimc-lite.c
@@ -459,11 +459,12 @@ static void fimc_lite_clear_event_counters(struct fimc_lite *fimc)
 static int fimc_lite_open(struct file *file)
 {
 	struct fimc_lite *fimc = video_drvdata(file);
+	struct media_entity *me = &fimc->vfd.entity;
 	int ret;
 
-	if (mutex_lock_interruptible(&fimc->lock))
-		return -ERESTARTSYS;
+	mutex_lock(&me->parent->graph_mutex);
 
+	mutex_lock(&fimc->lock);
 	if (fimc->out_path != FIMC_IO_DMA) {
 		ret = -EBUSY;
 		goto done;
@@ -492,6 +493,7 @@ static int fimc_lite_open(struct file *file)
 	}
 done:
 	mutex_unlock(&fimc->lock);
+	mutex_unlock(&me->parent->graph_mutex);
 	return ret;
 }
 
diff --git a/drivers/media/platform/s5p-fimc/fimc-mdevice.c b/drivers/media/platform/s5p-fimc/fimc-mdevice.c
index c243220..7aaa517 100644
--- a/drivers/media/platform/s5p-fimc/fimc-mdevice.c
+++ b/drivers/media/platform/s5p-fimc/fimc-mdevice.c
@@ -142,7 +142,7 @@ static int fimc_pipeline_s_power(struct fimc_pipeline *p, bool state)
  * @me: media entity to start graph walk with
  * @prep: true to acquire sensor (and csis) subdevs
  *
- * This function must be called with the graph mutex held.
+ * Called with the graph mutex held.
  */
 static int __fimc_pipeline_open(struct fimc_pipeline *p,
 				struct media_entity *me, bool prep)
@@ -162,30 +162,19 @@ static int __fimc_pipeline_open(struct fimc_pipeline *p,
 	return fimc_pipeline_s_power(p, 1);
 }
 
-static int fimc_pipeline_open(struct fimc_pipeline *p,
-			      struct media_entity *me, bool prep)
-{
-	int ret;
-
-	mutex_lock(&me->parent->graph_mutex);
-	ret =  __fimc_pipeline_open(p, me, prep);
-	mutex_unlock(&me->parent->graph_mutex);
-
-	return ret;
-}
-
 /**
  * __fimc_pipeline_close - disable the sensor clock and pipeline power
  * @fimc: fimc device terminating the pipeline
  *
- * Disable power of all subdevs in the pipeline and turn off the external
- * sensor clock.
- * Called with the graph mutex held.
+ * Disable power of all subdevs and turn the external sensor clock off.
  */
 static int __fimc_pipeline_close(struct fimc_pipeline *p)
 {
 	int ret = 0;
 
+	if (!p || !p->subdevs[IDX_SENSOR])
+		return -EINVAL;
+
 	if (p->subdevs[IDX_SENSOR]) {
 		ret = fimc_pipeline_s_power(p, 0);
 		fimc_md_set_camclk(p->subdevs[IDX_SENSOR], false);
@@ -193,28 +182,12 @@ static int __fimc_pipeline_close(struct fimc_pipeline *p)
 	return ret == -ENXIO ? 0 : ret;
 }
 
-static int fimc_pipeline_close(struct fimc_pipeline *p)
-{
-	struct media_entity *me;
-	int ret;
-
-	if (!p || !p->subdevs[IDX_SENSOR])
-		return -EINVAL;
-
-	me = &p->subdevs[IDX_SENSOR]->entity;
-	mutex_lock(&me->parent->graph_mutex);
-	ret = __fimc_pipeline_close(p);
-	mutex_unlock(&me->parent->graph_mutex);
-
-	return ret;
-}
-
 /**
- * fimc_pipeline_s_stream - invoke s_stream on pipeline subdevs
+ * __fimc_pipeline_s_stream - invoke s_stream on pipeline subdevs
  * @pipeline: video pipeline structure
  * @on: passed as the s_stream call argument
  */
-static int fimc_pipeline_s_stream(struct fimc_pipeline *p, bool on)
+static int __fimc_pipeline_s_stream(struct fimc_pipeline *p, bool on)
 {
 	int i, ret;
 
@@ -236,9 +209,9 @@ static int fimc_pipeline_s_stream(struct fimc_pipeline *p, bool on)
 
 /* Media pipeline operations for the FIMC/FIMC-LITE video device driver */
 static const struct fimc_pipeline_ops fimc_pipeline_ops = {
-	.open		= fimc_pipeline_open,
-	.close		= fimc_pipeline_close,
-	.set_stream	= fimc_pipeline_s_stream,
+	.open		= __fimc_pipeline_open,
+	.close		= __fimc_pipeline_close,
+	.set_stream	= __fimc_pipeline_s_stream,
 };
 
 /*
@@ -822,7 +795,9 @@ static int fimc_md_link_notify(struct media_pad *source,
 	struct fimc_dev *fimc = NULL;
 	struct fimc_pipeline *pipeline;
 	struct v4l2_subdev *sd;
+	struct mutex *lock;
 	int ret = 0;
+	int ref_count;
 
 	if (media_entity_type(sink->entity) != MEDIA_ENT_T_V4L2_SUBDEV)
 		return 0;
@@ -832,26 +807,31 @@ static int fimc_md_link_notify(struct media_pad *source,
 	switch (sd->grp_id) {
 	case GRP_ID_FLITE:
 		fimc_lite = v4l2_get_subdevdata(sd);
+		if (WARN_ON(fimc_lite == NULL))
+			return 0;
 		pipeline = &fimc_lite->pipeline;
+		lock = &fimc_lite->lock;
 		break;
 	case GRP_ID_FIMC:
 		fimc = v4l2_get_subdevdata(sd);
+		if (WARN_ON(fimc == NULL))
+			return 0;
 		pipeline = &fimc->pipeline;
+		lock = &fimc->lock;
 		break;
 	default:
 		return 0;
 	}
 
 	if (!(flags & MEDIA_LNK_FL_ENABLED)) {
+		int i;
+		mutex_lock(lock);
 		ret = __fimc_pipeline_close(pipeline);
-		pipeline->subdevs[IDX_SENSOR] = NULL;
-		pipeline->subdevs[IDX_CSIS] = NULL;
-
-		if (fimc) {
-			mutex_lock(&fimc->lock);
+		for (i = 0; i < IDX_MAX; i++)
+			pipeline->subdevs[i] = NULL;
+		if (fimc)
 			fimc_ctrls_delete(fimc->vid_cap.ctx);
-			mutex_unlock(&fimc->lock);
-		}
+		mutex_unlock(lock);
 		return ret;
 	}
 	/*
@@ -859,23 +839,15 @@ static int fimc_md_link_notify(struct media_pad *source,
 	 * pipeline is already in use, i.e. its video node is opened.
 	 * Recreate the controls destroyed during the link deactivation.
 	 */
-	if (fimc) {
-		mutex_lock(&fimc->lock);
-		if (fimc->vid_cap.refcnt > 0) {
-			ret = __fimc_pipeline_open(pipeline,
-						   source->entity, true);
-		if (!ret)
-			ret = fimc_capture_ctrls_create(fimc);
-		}
-		mutex_unlock(&fimc->lock);
-	} else {
-		mutex_lock(&fimc_lite->lock);
-		if (fimc_lite->ref_count > 0) {
-			ret = __fimc_pipeline_open(pipeline,
-						   source->entity, true);
-		}
-		mutex_unlock(&fimc_lite->lock);
-	}
+	mutex_lock(lock);
+
+	ref_count = fimc ? fimc->vid_cap.refcnt : fimc_lite->ref_count;
+	if (ref_count > 0)
+		ret = __fimc_pipeline_open(pipeline, source->entity, true);
+	if (!ret && fimc)
+		ret = fimc_capture_ctrls_create(fimc);
+
+	mutex_unlock(lock);
 	return ret ? -EPIPE : ret;
 }
 
-- 
1.7.9.5

