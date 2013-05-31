Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:63482 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754985Ab3EaOlH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 31 May 2013 10:41:07 -0400
Received: from epcpsbgm1.samsung.com (epcpsbgm1 [203.254.230.26])
 by mailout4.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MNO00ELB3G99NW0@mailout4.samsung.com> for
 linux-media@vger.kernel.org; Fri, 31 May 2013 23:41:06 +0900 (KST)
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, hj210.choi@samsung.com,
	arun.kk@samsung.com, shaik.ameer@samsung.com,
	kyungmin.park@samsung.com,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [REVIEW PATCH v2 06/11] exynos4-is: Use common exynos_media_pipeline
 data structure
Date: Fri, 31 May 2013 16:37:22 +0200
Message-id: <1370011047-11488-7-git-send-email-s.nawrocki@samsung.com>
In-reply-to: <1370011047-11488-1-git-send-email-s.nawrocki@samsung.com>
References: <1370011047-11488-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This enumeration is now private to exynos4-is and the exynos5 camera
subsystem driver may have the subdevs handling designed differently.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
Changes since v1:
 - corrected description of struct fimc_pipeline at media-dev.h
---
 drivers/media/platform/exynos4-is/fimc-capture.c |   67 ++++++++-----
 drivers/media/platform/exynos4-is/fimc-core.h    |    2 -
 drivers/media/platform/exynos4-is/fimc-lite.c    |   29 +++---
 drivers/media/platform/exynos4-is/fimc-lite.h    |    2 -
 drivers/media/platform/exynos4-is/media-dev.c    |  110 ++++++++++++++--------
 drivers/media/platform/exynos4-is/media-dev.h    |   38 ++++++++
 include/media/s5p_fimc.h                         |   53 +++++------
 7 files changed, 187 insertions(+), 114 deletions(-)

diff --git a/drivers/media/platform/exynos4-is/fimc-capture.c b/drivers/media/platform/exynos4-is/fimc-capture.c
index 534ea68..c2586a2 100644
--- a/drivers/media/platform/exynos4-is/fimc-capture.c
+++ b/drivers/media/platform/exynos4-is/fimc-capture.c
@@ -120,8 +120,7 @@ static int fimc_capture_state_cleanup(struct fimc_dev *fimc, bool suspend)
 	spin_unlock_irqrestore(&fimc->slock, flags);
 
 	if (streaming)
-		return fimc_pipeline_call(fimc, set_stream,
-					  &fimc->pipeline, 0);
+		return fimc_pipeline_call(&cap->ve, set_stream, 0);
 	else
 		return 0;
 }
@@ -179,8 +178,9 @@ static int fimc_capture_config_update(struct fimc_ctx *ctx)
 
 void fimc_capture_irq_handler(struct fimc_dev *fimc, int deq_buf)
 {
-	struct v4l2_subdev *csis = fimc->pipeline.subdevs[IDX_CSIS];
 	struct fimc_vid_cap *cap = &fimc->vid_cap;
+	struct fimc_pipeline *p = to_fimc_pipeline(cap->ve.pipe);
+	struct v4l2_subdev *csis = p->subdevs[IDX_CSIS];
 	struct fimc_frame *f = &cap->ctx->d_frame;
 	struct fimc_vid_buffer *v_buf;
 	struct timeval *tv;
@@ -288,8 +288,7 @@ static int start_streaming(struct vb2_queue *q, unsigned int count)
 		fimc_activate_capture(ctx);
 
 		if (!test_and_set_bit(ST_CAPT_ISP_STREAM, &fimc->state))
-			return fimc_pipeline_call(fimc, set_stream,
-						  &fimc->pipeline, 1);
+			return fimc_pipeline_call(&vid_cap->ve, set_stream, 1);
 	}
 
 	return 0;
@@ -313,7 +312,7 @@ int fimc_capture_suspend(struct fimc_dev *fimc)
 	int ret = fimc_stop_capture(fimc, suspend);
 	if (ret)
 		return ret;
-	return fimc_pipeline_call(fimc, close, &fimc->pipeline);
+	return fimc_pipeline_call(&fimc->vid_cap.ve, close);
 }
 
 static void buffer_queue(struct vb2_buffer *vb);
@@ -330,8 +329,7 @@ int fimc_capture_resume(struct fimc_dev *fimc)
 
 	INIT_LIST_HEAD(&fimc->vid_cap.active_buf_q);
 	vid_cap->buf_index = 0;
-	fimc_pipeline_call(fimc, open, &fimc->pipeline,
-			   &ve->vdev.entity, false);
+	fimc_pipeline_call(ve, open, &ve->vdev.entity, false);
 	fimc_capture_hw_init(fimc);
 
 	clear_bit(ST_CAPT_SUSPENDED, &fimc->state);
@@ -455,7 +453,7 @@ static void buffer_queue(struct vb2_buffer *vb)
 		if (test_and_set_bit(ST_CAPT_ISP_STREAM, &fimc->state))
 			return;
 
-		ret = fimc_pipeline_call(fimc, set_stream, &fimc->pipeline, 1);
+		ret = fimc_pipeline_call(ve, set_stream, 1);
 		if (ret < 0)
 			v4l2_err(&ve->vdev, "stream on failed: %d\n", ret);
 		return;
@@ -503,8 +501,8 @@ static int fimc_capture_open(struct file *file)
 	if (v4l2_fh_is_singular_file(file)) {
 		fimc_md_graph_lock(ve);
 
-		ret = fimc_pipeline_call(fimc, open, &fimc->pipeline,
-					 &fimc->vid_cap.ve.vdev.entity, true);
+		ret = fimc_pipeline_call(ve, open, &ve->vdev.entity, true);
+
 		if (ret == 0)
 			ret = fimc_capture_set_default_format(fimc);
 
@@ -555,8 +553,7 @@ static int fimc_capture_release(struct file *file)
 
 	if (close) {
 		clear_bit(ST_CAPT_BUSY, &fimc->state);
-		fimc_stop_capture(fimc, false);
-		fimc_pipeline_call(fimc, close, &fimc->pipeline);
+		fimc_pipeline_call(&vc->ve, close);
 		clear_bit(ST_CAPT_SUSPENDED, &fimc->state);
 
 		fimc_md_graph_lock(&vc->ve);
@@ -786,7 +783,8 @@ static int fimc_pipeline_try_format(struct fimc_ctx *ctx,
 				    bool set)
 {
 	struct fimc_dev *fimc = ctx->fimc_dev;
-	struct v4l2_subdev *sd = fimc->pipeline.subdevs[IDX_SENSOR];
+	struct fimc_pipeline *p = to_fimc_pipeline(fimc->vid_cap.ve.pipe);
+	struct v4l2_subdev *sd = p->subdevs[IDX_SENSOR];
 	struct v4l2_subdev_format sfmt;
 	struct v4l2_mbus_framefmt *mf = &sfmt.format;
 	struct media_entity *me;
@@ -926,6 +924,7 @@ static int fimc_cap_try_fmt_mplane(struct file *file, void *fh,
 	struct fimc_ctx *ctx = fimc->vid_cap.ctx;
 	struct exynos_video_entity *ve = &fimc->vid_cap.ve;
 	struct v4l2_mbus_framefmt mf;
+	struct v4l2_subdev *sensor;
 	struct fimc_fmt *ffmt = NULL;
 	int ret = 0;
 
@@ -959,9 +958,18 @@ static int fimc_cap_try_fmt_mplane(struct file *file, void *fh,
 
 	fimc_adjust_mplane_format(ffmt, pix->width, pix->height, pix);
 
-	if (ffmt->flags & FMT_FLAGS_COMPRESSED)
-		fimc_get_sensor_frame_desc(fimc->pipeline.subdevs[IDX_SENSOR],
-					pix->plane_fmt, ffmt->memplanes, true);
+	if (ffmt->flags & FMT_FLAGS_COMPRESSED) {
+		fimc_md_graph_lock(ve);
+
+		sensor = __fimc_md_get_subdev(ve->pipe, IDX_SENSOR);
+		if (sensor)
+			fimc_get_sensor_frame_desc(sensor, pix->plane_fmt,
+						   ffmt->memplanes, true);
+		else
+			ret = -EPIPE;
+
+		fimc_md_graph_unlock(ve);
+	}
 
 	return ret;
 }
@@ -986,6 +994,7 @@ static int __fimc_capture_set_format(struct fimc_dev *fimc,
 	struct fimc_ctx *ctx = fimc->vid_cap.ctx;
 	struct v4l2_pix_format_mplane *pix = &f->fmt.pix_mp;
 	struct v4l2_mbus_framefmt *mf = &fimc->vid_cap.ci_fmt;
+	struct fimc_pipeline *p = to_fimc_pipeline(fimc->vid_cap.ve.pipe);
 	struct fimc_frame *ff = &ctx->d_frame;
 	struct fimc_fmt *s_fmt = NULL;
 	int ret, i;
@@ -1027,7 +1036,7 @@ static int __fimc_capture_set_format(struct fimc_dev *fimc,
 	fimc_adjust_mplane_format(ff->fmt, pix->width, pix->height, pix);
 
 	if (ff->fmt->flags & FMT_FLAGS_COMPRESSED) {
-		ret = fimc_get_sensor_frame_desc(fimc->pipeline.subdevs[IDX_SENSOR],
+		ret = fimc_get_sensor_frame_desc(p->subdevs[IDX_SENSOR],
 					pix->plane_fmt, ff->fmt->memplanes,
 					true);
 		if (ret < 0)
@@ -1078,14 +1087,20 @@ static int fimc_cap_enum_input(struct file *file, void *priv,
 			       struct v4l2_input *i)
 {
 	struct fimc_dev *fimc = video_drvdata(file);
-	struct v4l2_subdev *sd = fimc->pipeline.subdevs[IDX_SENSOR];
+	struct exynos_video_entity *ve = &fimc->vid_cap.ve;
+	struct v4l2_subdev *sd;
 
 	if (i->index != 0)
 		return -EINVAL;
 
 	i->type = V4L2_INPUT_TYPE_CAMERA;
+	fimc_md_graph_lock(ve);
+	sd = __fimc_md_get_subdev(ve->pipe, IDX_SENSOR);
+	fimc_md_graph_unlock(ve);
+
 	if (sd)
 		strlcpy(i->name, sd->name, sizeof(i->name));
+
 	return 0;
 }
 
@@ -1111,6 +1126,7 @@ static int fimc_pipeline_validate(struct fimc_dev *fimc)
 	struct v4l2_subdev_format sink_fmt, src_fmt;
 	struct fimc_vid_cap *vc = &fimc->vid_cap;
 	struct v4l2_subdev *sd = &vc->subdev;
+	struct fimc_pipeline *p = to_fimc_pipeline(vc->ve.pipe);
 	struct media_pad *sink_pad, *src_pad;
 	int i, ret;
 
@@ -1164,7 +1180,7 @@ static int fimc_pipeline_validate(struct fimc_dev *fimc)
 		    src_fmt.format.code != sink_fmt.format.code)
 			return -EPIPE;
 
-		if (sd == fimc->pipeline.subdevs[IDX_SENSOR] &&
+		if (sd == p->subdevs[IDX_SENSOR] &&
 		    fimc_user_defined_mbus_fmt(src_fmt.format.code)) {
 			struct v4l2_plane_pix_format plane_fmt[FIMC_MAX_PLANES];
 			struct fimc_frame *frame = &vc->ctx->d_frame;
@@ -1188,7 +1204,6 @@ static int fimc_cap_streamon(struct file *file, void *priv,
 			     enum v4l2_buf_type type)
 {
 	struct fimc_dev *fimc = video_drvdata(file);
-	struct fimc_pipeline *p = &fimc->pipeline;
 	struct fimc_vid_cap *vc = &fimc->vid_cap;
 	struct media_entity *entity = &vc->ve.vdev.entity;
 	struct fimc_source_info *si = NULL;
@@ -1198,11 +1213,11 @@ static int fimc_cap_streamon(struct file *file, void *priv,
 	if (fimc_capture_active(fimc))
 		return -EBUSY;
 
-	ret = media_entity_pipeline_start(entity, p->m_pipeline);
+	ret = media_entity_pipeline_start(entity, &vc->ve.pipe->mp);
 	if (ret < 0)
 		return ret;
 
-	sd = p->subdevs[IDX_SENSOR];
+	sd = __fimc_md_get_subdev(vc->ve.pipe, IDX_SENSOR);
 	if (sd)
 		si = v4l2_get_subdev_hostdata(sd);
 
@@ -1821,12 +1836,12 @@ static int fimc_capture_subdev_registered(struct v4l2_subdev *sd)
 	if (ret)
 		return ret;
 
-	fimc->pipeline_ops = v4l2_get_subdev_hostdata(sd);
+	fimc->vid_cap.ve.pipe = v4l2_get_subdev_hostdata(sd);
 
 	ret = fimc_register_capture_device(fimc, sd->v4l2_dev);
 	if (ret) {
 		fimc_unregister_m2m_device(fimc);
-		fimc->pipeline_ops = NULL;
+		fimc->vid_cap.ve.pipe = NULL;
 	}
 
 	return ret;
@@ -1847,7 +1862,7 @@ static void fimc_capture_subdev_unregistered(struct v4l2_subdev *sd)
 		video_unregister_device(vdev);
 		media_entity_cleanup(&vdev->entity);
 		fimc_ctrls_delete(fimc->vid_cap.ctx);
-		fimc->pipeline_ops = NULL;
+		fimc->vid_cap.ve.pipe = NULL;
 	}
 	kfree(fimc->vid_cap.ctx);
 	fimc->vid_cap.ctx = NULL;
diff --git a/drivers/media/platform/exynos4-is/fimc-core.h b/drivers/media/platform/exynos4-is/fimc-core.h
index 09c061d..bba6b25 100644
--- a/drivers/media/platform/exynos4-is/fimc-core.h
+++ b/drivers/media/platform/exynos4-is/fimc-core.h
@@ -437,8 +437,6 @@ struct fimc_dev {
 	struct fimc_vid_cap		vid_cap;
 	unsigned long			state;
 	struct vb2_alloc_ctx		*alloc_ctx;
-	struct fimc_pipeline		pipeline;
-	const struct fimc_pipeline_ops	*pipeline_ops;
 };
 
 /**
diff --git a/drivers/media/platform/exynos4-is/fimc-lite.c b/drivers/media/platform/exynos4-is/fimc-lite.c
index 1da3ed1..27232cd 100644
--- a/drivers/media/platform/exynos4-is/fimc-lite.c
+++ b/drivers/media/platform/exynos4-is/fimc-lite.c
@@ -210,7 +210,7 @@ static int fimc_lite_reinit(struct fimc_lite *fimc, bool suspend)
 	if (!streaming)
 		return 0;
 
-	return fimc_pipeline_call(fimc, set_stream, &fimc->pipeline, 0);
+	return fimc_pipeline_call(&fimc->ve, set_stream, 0);
 }
 
 static int fimc_lite_stop_capture(struct fimc_lite *fimc, bool suspend)
@@ -324,8 +324,7 @@ static int start_streaming(struct vb2_queue *q, unsigned int count)
 		flite_hw_capture_start(fimc);
 
 		if (!test_and_set_bit(ST_SENSOR_STREAM, &fimc->state))
-			fimc_pipeline_call(fimc, set_stream,
-					   &fimc->pipeline, 1);
+			fimc_pipeline_call(&fimc->ve, set_stream, 1);
 	}
 	if (debug > 0)
 		flite_hw_dump_regs(fimc, __func__);
@@ -429,8 +428,7 @@ static void buffer_queue(struct vb2_buffer *vb)
 		spin_unlock_irqrestore(&fimc->slock, flags);
 
 		if (!test_and_set_bit(ST_SENSOR_STREAM, &fimc->state))
-			fimc_pipeline_call(fimc, set_stream,
-					   &fimc->pipeline, 1);
+			fimc_pipeline_call(&fimc->ve, set_stream, 1);
 		return;
 	}
 	spin_unlock_irqrestore(&fimc->slock, flags);
@@ -482,8 +480,7 @@ static int fimc_lite_open(struct file *file)
 
 	mutex_lock(&me->parent->graph_mutex);
 
-	ret = fimc_pipeline_call(fimc, open, &fimc->pipeline,
-						me, true);
+	ret = fimc_pipeline_call(&fimc->ve, open, me, true);
 
 	/* Mark video pipeline ending at this video node as in use. */
 	if (ret == 0)
@@ -518,9 +515,10 @@ static int fimc_lite_release(struct file *file)
 			media_entity_pipeline_stop(entity);
 			fimc->streaming = false;
 		}
-		clear_bit(ST_FLITE_IN_USE, &fimc->state);
 		fimc_lite_stop_capture(fimc, false);
-		fimc_pipeline_call(fimc, close, &fimc->pipeline);
+		fimc_pipeline_call(&fimc->ve, close);
+		clear_bit(ST_FLITE_IN_USE, &fimc->state);
+
 		mutex_lock(&entity->parent->graph_mutex);
 		entity->use_count--;
 		mutex_unlock(&entity->parent->graph_mutex);
@@ -801,13 +799,12 @@ static int fimc_lite_streamon(struct file *file, void *priv,
 {
 	struct fimc_lite *fimc = video_drvdata(file);
 	struct media_entity *entity = &fimc->ve.vdev.entity;
-	struct fimc_pipeline *p = &fimc->pipeline;
 	int ret;
 
 	if (fimc_lite_active(fimc))
 		return -EBUSY;
 
-	ret = media_entity_pipeline_start(entity, p->m_pipeline);
+	ret = media_entity_pipeline_start(entity, &fimc->ve.pipe->mp);
 	if (ret < 0)
 		return ret;
 
@@ -1282,12 +1279,12 @@ static int fimc_lite_subdev_registered(struct v4l2_subdev *sd)
 		return ret;
 
 	video_set_drvdata(vfd, fimc);
-	fimc->pipeline_ops = v4l2_get_subdev_hostdata(sd);
+	fimc->ve.pipe = v4l2_get_subdev_hostdata(sd);
 
 	ret = video_register_device(vfd, VFL_TYPE_GRABBER, -1);
 	if (ret < 0) {
 		media_entity_cleanup(&vfd->entity);
-		fimc->pipeline_ops = NULL;
+		fimc->ve.pipe = NULL;
 		return ret;
 	}
 
@@ -1306,7 +1303,7 @@ static void fimc_lite_subdev_unregistered(struct v4l2_subdev *sd)
 	if (video_is_registered(&fimc->ve.vdev)) {
 		video_unregister_device(&fimc->ve.vdev);
 		media_entity_cleanup(&fimc->ve.vdev.entity);
-		fimc->pipeline_ops = NULL;
+		fimc->ve.pipe = NULL;
 	}
 }
 
@@ -1552,7 +1549,7 @@ static int fimc_lite_resume(struct device *dev)
 		return 0;
 
 	INIT_LIST_HEAD(&fimc->active_buf_q);
-	fimc_pipeline_call(fimc, open, &fimc->pipeline,
+	fimc_pipeline_call(&fimc->ve, open,
 			   &fimc->ve.vdev.entity, false);
 	fimc_lite_hw_init(fimc, atomic_read(&fimc->out_path) == FIMC_IO_ISP);
 	clear_bit(ST_FLITE_SUSPENDED, &fimc->state);
@@ -1579,7 +1576,7 @@ static int fimc_lite_suspend(struct device *dev)
 	if (ret < 0 || !fimc_lite_active(fimc))
 		return ret;
 
-	return fimc_pipeline_call(fimc, close, &fimc->pipeline);
+	return fimc_pipeline_call(&fimc->ve, close);
 }
 #endif /* CONFIG_PM_SLEEP */
 
diff --git a/drivers/media/platform/exynos4-is/fimc-lite.h b/drivers/media/platform/exynos4-is/fimc-lite.h
index 25abba9..c7aa084 100644
--- a/drivers/media/platform/exynos4-is/fimc-lite.h
+++ b/drivers/media/platform/exynos4-is/fimc-lite.h
@@ -140,8 +140,6 @@ struct fimc_lite {
 	struct v4l2_ctrl_handler ctrl_handler;
 	struct v4l2_ctrl	*test_pattern;
 	int			index;
-	struct fimc_pipeline	pipeline;
-	const struct fimc_pipeline_ops *pipeline_ops;
 
 	struct mutex		lock;
 	spinlock_t		slock;
diff --git a/drivers/media/platform/exynos4-is/media-dev.c b/drivers/media/platform/exynos4-is/media-dev.c
index 416dbcb..e95a6d5 100644
--- a/drivers/media/platform/exynos4-is/media-dev.c
+++ b/drivers/media/platform/exynos4-is/media-dev.c
@@ -46,7 +46,7 @@ static int __fimc_md_set_camclk(struct fimc_md *fmd,
  * Caller holds the graph mutex.
  */
 static void fimc_pipeline_prepare(struct fimc_pipeline *p,
-				  struct media_entity *me)
+					struct media_entity *me)
 {
 	struct v4l2_subdev *sd;
 	int i;
@@ -168,10 +168,11 @@ error:
  *
  * Called with the graph mutex held.
  */
-static int __fimc_pipeline_open(struct fimc_pipeline *p,
+static int __fimc_pipeline_open(struct exynos_media_pipeline *ep,
 				struct media_entity *me, bool prepare)
 {
 	struct fimc_md *fmd = entity_to_fimc_mdev(me);
+	struct fimc_pipeline *p = to_fimc_pipeline(ep);
 	struct v4l2_subdev *sd;
 	int ret;
 
@@ -214,8 +215,9 @@ err_wbclk:
  *
  * Disable power of all subdevs and turn the external sensor clock off.
  */
-static int __fimc_pipeline_close(struct fimc_pipeline *p)
+static int __fimc_pipeline_close(struct exynos_media_pipeline *ep)
 {
+	struct fimc_pipeline *p = to_fimc_pipeline(ep);
 	struct v4l2_subdev *sd = p ? p->subdevs[IDX_SENSOR] : NULL;
 	struct fimc_md *fmd;
 	int ret = 0;
@@ -242,12 +244,13 @@ static int __fimc_pipeline_close(struct fimc_pipeline *p)
  * @pipeline: video pipeline structure
  * @on: passed as the s_stream() callback argument
  */
-static int __fimc_pipeline_s_stream(struct fimc_pipeline *p, bool on)
+static int __fimc_pipeline_s_stream(struct exynos_media_pipeline *ep, bool on)
 {
 	static const u8 seq[2][IDX_MAX] = {
 		{ IDX_FIMC, IDX_SENSOR, IDX_IS_ISP, IDX_CSIS, IDX_FLITE },
 		{ IDX_CSIS, IDX_FLITE, IDX_FIMC, IDX_SENSOR, IDX_IS_ISP },
 	};
+	struct fimc_pipeline *p = to_fimc_pipeline(ep);
 	int i, ret = 0;
 
 	if (p->subdevs[IDX_SENSOR] == NULL)
@@ -271,12 +274,38 @@ error:
 }
 
 /* Media pipeline operations for the FIMC/FIMC-LITE video device driver */
-static const struct fimc_pipeline_ops fimc_pipeline_ops = {
+static const struct exynos_media_pipeline_ops fimc_pipeline_ops = {
 	.open		= __fimc_pipeline_open,
 	.close		= __fimc_pipeline_close,
 	.set_stream	= __fimc_pipeline_s_stream,
 };
 
+static struct exynos_media_pipeline *fimc_md_pipeline_create(
+						struct fimc_md *fmd)
+{
+	struct fimc_pipeline *p;
+
+	p = kzalloc(sizeof(*p), GFP_KERNEL);
+	if (!p)
+		return NULL;
+
+	list_add_tail(&p->list, &fmd->pipelines);
+
+	p->ep.ops = &fimc_pipeline_ops;
+	return &p->ep;
+}
+
+static void fimc_md_pipelines_free(struct fimc_md *fmd)
+{
+	while (!list_empty(&fmd->pipelines)) {
+		struct fimc_pipeline *p;
+
+		p = list_entry(fmd->pipelines.next, typeof(*p), list);
+		list_del(&p->list);
+		kfree(p);
+	}
+}
+
 /*
  * Sensor subdevice helper functions
  */
@@ -592,6 +621,7 @@ static int register_fimc_lite_entity(struct fimc_md *fmd,
 				     struct fimc_lite *fimc_lite)
 {
 	struct v4l2_subdev *sd;
+	struct exynos_media_pipeline *ep;
 	int ret;
 
 	if (WARN_ON(fimc_lite->index >= FIMC_LITE_MAX_DEVS ||
@@ -600,7 +630,12 @@ static int register_fimc_lite_entity(struct fimc_md *fmd,
 
 	sd = &fimc_lite->subdev;
 	sd->grp_id = GRP_ID_FLITE;
-	v4l2_set_subdev_hostdata(sd, (void *)&fimc_pipeline_ops);
+
+	ep = fimc_md_pipeline_create(fmd);
+	if (!ep)
+		return -ENOMEM;
+
+	v4l2_set_subdev_hostdata(sd, ep);
 
 	ret = v4l2_device_register_subdev(&fmd->v4l2_dev, sd);
 	if (!ret)
@@ -614,6 +649,7 @@ static int register_fimc_lite_entity(struct fimc_md *fmd,
 static int register_fimc_entity(struct fimc_md *fmd, struct fimc_dev *fimc)
 {
 	struct v4l2_subdev *sd;
+	struct exynos_media_pipeline *ep;
 	int ret;
 
 	if (WARN_ON(fimc->id >= FIMC_MAX_DEVS || fmd->fimc[fimc->id]))
@@ -621,7 +657,12 @@ static int register_fimc_entity(struct fimc_md *fmd, struct fimc_dev *fimc)
 
 	sd = &fimc->vid_cap.subdev;
 	sd->grp_id = GRP_ID_FIMC;
-	v4l2_set_subdev_hostdata(sd, (void *)&fimc_pipeline_ops);
+
+	ep = fimc_md_pipeline_create(fmd);
+	if (!ep)
+		return -ENOMEM;
+
+	v4l2_set_subdev_hostdata(sd, ep);
 
 	ret = v4l2_device_register_subdev(&fmd->v4l2_dev, sd);
 	if (!ret) {
@@ -797,17 +838,19 @@ static void fimc_md_unregister_entities(struct fimc_md *fmd)
 	int i;
 
 	for (i = 0; i < FIMC_MAX_DEVS; i++) {
-		if (fmd->fimc[i] == NULL)
+		struct fimc_dev *dev = fmd->fimc[i];
+		if (dev == NULL)
 			continue;
-		v4l2_device_unregister_subdev(&fmd->fimc[i]->vid_cap.subdev);
-		fmd->fimc[i]->pipeline_ops = NULL;
+		v4l2_device_unregister_subdev(&dev->vid_cap.subdev);
+		dev->vid_cap.ve.pipe = NULL;
 		fmd->fimc[i] = NULL;
 	}
 	for (i = 0; i < FIMC_LITE_MAX_DEVS; i++) {
-		if (fmd->fimc_lite[i] == NULL)
+		struct fimc_lite *dev = fmd->fimc_lite[i];
+		if (dev == NULL)
 			continue;
-		v4l2_device_unregister_subdev(&fmd->fimc_lite[i]->subdev);
-		fmd->fimc_lite[i]->pipeline_ops = NULL;
+		v4l2_device_unregister_subdev(&dev->subdev);
+		dev->ve.pipe = NULL;
 		fmd->fimc_lite[i] = NULL;
 	}
 	for (i = 0; i < CSIS_MAX_ENTITIES; i++) {
@@ -1234,38 +1277,22 @@ int fimc_md_set_camclk(struct v4l2_subdev *sd, bool on)
 static int fimc_md_link_notify(struct media_pad *source,
 			       struct media_pad *sink, u32 flags)
 {
-	struct fimc_lite *fimc_lite = NULL;
-	struct fimc_dev *fimc = NULL;
+	struct exynos_video_entity *ve;
+	struct video_device *vdev;
 	struct fimc_pipeline *pipeline;
-	struct v4l2_subdev *sd;
 	int i, ret = 0;
 
-	if (media_entity_type(sink->entity) != MEDIA_ENT_T_V4L2_SUBDEV)
+	if (media_entity_type(sink->entity) != MEDIA_ENT_T_DEVNODE_V4L)
 		return 0;
 
-	sd = media_entity_to_v4l2_subdev(sink->entity);
-
-	switch (sd->grp_id) {
-	case GRP_ID_FLITE:
-		fimc_lite = v4l2_get_subdevdata(sd);
-		if (WARN_ON(fimc_lite == NULL))
-			return 0;
-		pipeline = &fimc_lite->pipeline;
-		break;
-	case GRP_ID_FIMC:
-		fimc = v4l2_get_subdevdata(sd);
-		if (WARN_ON(fimc == NULL))
-			return 0;
-		pipeline = &fimc->pipeline;
-		break;
-	default:
-		return 0;
-	}
+	vdev = media_entity_to_video_device(sink->entity);
+	ve = vdev_to_exynos_video_entity(vdev);
+	pipeline = to_fimc_pipeline(ve->pipe);
+
+	if (!(flags & MEDIA_LNK_FL_ENABLED) && pipeline->subdevs[IDX_SENSOR]) {
+		if (sink->entity->use_count > 0)
+			ret = __fimc_pipeline_close(ve->pipe);
 
-	if (!(flags & MEDIA_LNK_FL_ENABLED)) {
-		if (sink->entity->use_count > 0) {
-			ret = __fimc_pipeline_close(pipeline);
-		}
 		for (i = 0; i < IDX_MAX; i++)
 			pipeline->subdevs[i] = NULL;
 	} else if (sink->entity->use_count > 0) {
@@ -1274,8 +1301,7 @@ static int fimc_md_link_notify(struct media_pad *source,
 		 * the pipeline is already in use, i.e. its video node is open.
 		 * Recreate the controls destroyed during the link deactivation.
 		 */
-		ret = __fimc_pipeline_open(pipeline,
-					   source->entity, true);
+		ret = __fimc_pipeline_open(ve->pipe, sink->entity, true);
 	}
 
 	return ret ? -EPIPE : ret;
@@ -1358,6 +1384,7 @@ static int fimc_md_probe(struct platform_device *pdev)
 
 	spin_lock_init(&fmd->slock);
 	fmd->pdev = pdev;
+	INIT_LIST_HEAD(&fmd->pipelines);
 
 	strlcpy(fmd->media_dev.model, "SAMSUNG S5P FIMC",
 		sizeof(fmd->media_dev.model));
@@ -1445,6 +1472,7 @@ static int fimc_md_remove(struct platform_device *pdev)
 		return 0;
 	device_remove_file(&pdev->dev, &dev_attr_subdev_conf_mode);
 	fimc_md_unregister_entities(fmd);
+	fimc_md_pipelines_free(fmd);
 	media_device_unregister(&fmd->media_dev);
 	fimc_md_put_clocks(fmd);
 	return 0;
diff --git a/drivers/media/platform/exynos4-is/media-dev.h b/drivers/media/platform/exynos4-is/media-dev.h
index 3e9680c..a704eea 100644
--- a/drivers/media/platform/exynos4-is/media-dev.h
+++ b/drivers/media/platform/exynos4-is/media-dev.h
@@ -18,6 +18,7 @@
 #include <media/media-entity.h>
 #include <media/v4l2-device.h>
 #include <media/v4l2-subdev.h>
+#include <media/s5p_fimc.h>
 
 #include "fimc-core.h"
 #include "fimc-lite.h"
@@ -40,6 +41,29 @@ enum {
 	FIMC_MAX_WBCLKS
 };
 
+enum fimc_subdev_index {
+	IDX_SENSOR,
+	IDX_CSIS,
+	IDX_FLITE,
+	IDX_IS_ISP,
+	IDX_FIMC,
+	IDX_MAX,
+};
+
+/*
+ * This structure represents a chain of media entities, including a data
+ * source entity (e.g. an image sensor subdevice), a data capture entity
+ * - a video capture device node and any remaining entities.
+ */
+struct fimc_pipeline {
+	struct exynos_media_pipeline ep;
+	struct list_head list;
+	struct media_entity *vdev_entity;
+	struct v4l2_subdev *subdevs[IDX_MAX];
+};
+
+#define to_fimc_pipeline(_ep) container_of(_ep, struct fimc_pipeline, ep)
+
 struct fimc_csis_info {
 	struct v4l2_subdev *sd;
 	int id;
@@ -104,7 +128,9 @@ struct fimc_md {
 		struct pinctrl_state *state_idle;
 	} pinctl;
 	bool user_subdev_api;
+
 	spinlock_t slock;
+	struct list_head pipelines;
 };
 
 #define is_subdev_pad(pad) (pad == NULL || \
@@ -149,4 +175,16 @@ static inline bool fimc_md_is_isp_available(struct device_node *node)
 #define fimc_md_is_isp_available(node) (false)
 #endif /* CONFIG_OF */
 
+static inline struct v4l2_subdev *__fimc_md_get_subdev(
+				struct exynos_media_pipeline *ep,
+				unsigned int index)
+{
+	struct fimc_pipeline *p = to_fimc_pipeline(ep);
+
+	if (!p || index >= IDX_MAX)
+		return NULL;
+	else
+		return p->subdevs[index];
+}
+
 #endif
diff --git a/include/media/s5p_fimc.h b/include/media/s5p_fimc.h
index f5313b4..0afadb6 100644
--- a/include/media/s5p_fimc.h
+++ b/include/media/s5p_fimc.h
@@ -141,41 +141,40 @@ struct fimc_fmt {
 #define FMT_FLAGS_YUV		(1 << 7)
 };
 
-enum fimc_subdev_index {
-	IDX_SENSOR,
-	IDX_CSIS,
-	IDX_FLITE,
-	IDX_IS_ISP,
-	IDX_FIMC,
-	IDX_MAX,
-};
-
-struct media_pipeline;
-struct v4l2_subdev;
+struct exynos_media_pipeline;
 
-struct fimc_pipeline {
-	struct v4l2_subdev *subdevs[IDX_MAX];
-	struct media_pipeline *m_pipeline;
+/*
+ * Media pipeline operations to be called from within a video node,  i.e. the
+ * last entity within the pipeline. Implemented by related media device driver.
+ */
+struct exynos_media_pipeline_ops {
+	int (*prepare)(struct exynos_media_pipeline *p,
+						struct media_entity *me);
+	int (*unprepare)(struct exynos_media_pipeline *p);
+	int (*open)(struct exynos_media_pipeline *p, struct media_entity *me,
+							bool resume);
+	int (*close)(struct exynos_media_pipeline *p);
+	int (*set_stream)(struct exynos_media_pipeline *p, bool state);
 };
 
 struct exynos_video_entity {
 	struct video_device vdev;
+	struct exynos_media_pipeline *pipe;
 };
 
-/*
- * Media pipeline operations to be called from within the fimc(-lite)
- * video node when it is the last entity of the pipeline. Implemented
- * by corresponding media device driver.
- */
-struct fimc_pipeline_ops {
-	int (*open)(struct fimc_pipeline *p, struct media_entity *me,
-			  bool resume);
-	int (*close)(struct fimc_pipeline *p);
-	int (*set_stream)(struct fimc_pipeline *p, bool state);
+struct exynos_media_pipeline {
+	struct media_pipeline mp;
+	const struct exynos_media_pipeline_ops *ops;
 };
 
-#define fimc_pipeline_call(f, op, p, args...)				\
-	(!(f) ? -ENODEV : (((f)->pipeline_ops && (f)->pipeline_ops->op) ? \
-			    (f)->pipeline_ops->op((p), ##args) : -ENOIOCTLCMD))
+static inline struct exynos_video_entity *vdev_to_exynos_video_entity(
+					struct video_device *vdev)
+{
+	return container_of(vdev, struct exynos_video_entity, vdev);
+}
+
+#define fimc_pipeline_call(ent, op, args...)				  \
+	(!(ent) ? -ENOENT : (((ent)->pipe->ops && (ent)->pipe->ops->op) ? \
+	(ent)->pipe->ops->op(((ent)->pipe), ##args) : -ENOIOCTLCMD))	  \
 
 #endif /* S5P_FIMC_H_ */
-- 
1.7.9.5

