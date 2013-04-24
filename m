Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-da0-f49.google.com ([209.85.210.49]:64826 "EHLO
	mail-da0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756653Ab3DXHmS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 24 Apr 2013 03:42:18 -0400
From: Shaik Ameer Basha <shaik.ameer@samsung.com>
To: linux-media@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
	linux-samsung-soc@vger.kernel.org
Cc: s.nawrocki@samsung.com, shaik.samsung@gmail.com,
	arunkk.samsung@gmail.com
Subject: [RFC v2 1/6] media: exynos4-is: modify existing mdev to use common pipeline
Date: Wed, 24 Apr 2013 13:11:08 +0530
Message-Id: <1366789273-30184-2-git-send-email-shaik.ameer@samsung.com>
In-Reply-To: <1366789273-30184-1-git-send-email-shaik.ameer@samsung.com>
References: <1366789273-30184-1-git-send-email-shaik.ameer@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Current fimc_pipeline is tightly coupled with exynos4-is media
device driver. And this will not allow to use the same pipeline
across different exynos series media device drivers.

This patch adds,
1] Changing of the existing pipeline as a common pipeline
   to be used across multiple exynos series media device drivers.
2] Modifies the existing exynos4-is media device driver to
   use the updated common pipeline implementation.

Signed-off-by: Shaik Ameer Basha <shaik.ameer@samsung.com>
---
 drivers/media/platform/exynos4-is/fimc-capture.c |   47 ++++--
 drivers/media/platform/exynos4-is/fimc-lite.c    |    4 +-
 drivers/media/platform/exynos4-is/media-dev.c    |  179 +++++++++++++++++++---
 drivers/media/platform/exynos4-is/media-dev.h    |   16 ++
 include/media/s5p_fimc.h                         |   46 ++++--
 5 files changed, 248 insertions(+), 44 deletions(-)

diff --git a/drivers/media/platform/exynos4-is/fimc-capture.c b/drivers/media/platform/exynos4-is/fimc-capture.c
index 72c516a..904d725 100644
--- a/drivers/media/platform/exynos4-is/fimc-capture.c
+++ b/drivers/media/platform/exynos4-is/fimc-capture.c
@@ -178,13 +178,16 @@ static int fimc_capture_config_update(struct fimc_ctx *ctx)
 
 void fimc_capture_irq_handler(struct fimc_dev *fimc, int deq_buf)
 {
-	struct v4l2_subdev *csis = fimc->pipeline.subdevs[IDX_CSIS];
+	struct v4l2_subdev *csis;
 	struct fimc_vid_cap *cap = &fimc->vid_cap;
 	struct fimc_frame *f = &cap->ctx->d_frame;
 	struct fimc_vid_buffer *v_buf;
 	struct timeval *tv;
 	struct timespec ts;
 
+	csis = fimc_pipeline_get_subdev(fimc->pipeline_ops,
+				&fimc->pipeline, EXYNOS_SD_CSIS);
+
 	if (test_and_clear_bit(ST_CAPT_SHUT, &fimc->state)) {
 		wake_up(&fimc->irq_queue);
 		goto done;
@@ -480,9 +483,12 @@ static struct vb2_ops fimc_capture_qops = {
 int fimc_capture_ctrls_create(struct fimc_dev *fimc)
 {
 	struct fimc_vid_cap *vid_cap = &fimc->vid_cap;
-	struct v4l2_subdev *sensor = fimc->pipeline.subdevs[IDX_SENSOR];
+	struct v4l2_subdev *sensor;
 	int ret;
 
+	sensor = fimc_pipeline_get_subdev(fimc->pipeline_ops,
+				&fimc->pipeline, EXYNOS_SD_SENSOR);
+
 	if (WARN_ON(vid_cap->ctx == NULL))
 		return -ENXIO;
 	if (vid_cap->ctx->ctrls.ready)
@@ -800,7 +806,7 @@ static int fimc_pipeline_try_format(struct fimc_ctx *ctx,
 				    bool set)
 {
 	struct fimc_dev *fimc = ctx->fimc_dev;
-	struct v4l2_subdev *sd = fimc->pipeline.subdevs[IDX_SENSOR];
+	struct v4l2_subdev *sd;
 	struct v4l2_subdev_format sfmt;
 	struct v4l2_mbus_framefmt *mf = &sfmt.format;
 	struct media_entity *me;
@@ -809,6 +815,8 @@ static int fimc_pipeline_try_format(struct fimc_ctx *ctx,
 	int ret, i = 1;
 	u32 fcc;
 
+	sd = fimc_pipeline_get_subdev(fimc->pipeline_ops,
+				&fimc->pipeline, EXYNOS_SD_SENSOR);
 	if (WARN_ON(!sd || !tfmt))
 		return -EINVAL;
 
@@ -974,8 +982,10 @@ static int fimc_cap_try_fmt_mplane(struct file *file, void *fh,
 	fimc_adjust_mplane_format(ffmt, pix->width, pix->height, pix);
 
 	if (ffmt->flags & FMT_FLAGS_COMPRESSED)
-		fimc_get_sensor_frame_desc(fimc->pipeline.subdevs[IDX_SENSOR],
-					pix->plane_fmt, ffmt->memplanes, true);
+		fimc_get_sensor_frame_desc(
+			fimc_pipeline_get_subdev(fimc->pipeline_ops,
+				&fimc->pipeline, EXYNOS_SD_SENSOR),
+			pix->plane_fmt, ffmt->memplanes, true);
 unlock:
 	mutex_unlock(&fimc->lock);
 	fimc_md_graph_unlock(fimc);
@@ -1044,9 +1054,10 @@ static int __fimc_capture_set_format(struct fimc_dev *fimc,
 	fimc_adjust_mplane_format(ff->fmt, pix->width, pix->height, pix);
 
 	if (ff->fmt->flags & FMT_FLAGS_COMPRESSED) {
-		ret = fimc_get_sensor_frame_desc(fimc->pipeline.subdevs[IDX_SENSOR],
-					pix->plane_fmt, ff->fmt->memplanes,
-					true);
+		ret = fimc_get_sensor_frame_desc(
+			fimc_pipeline_get_subdev(fimc->pipeline_ops,
+				&fimc->pipeline, EXYNOS_SD_SENSOR),
+			pix->plane_fmt, ff->fmt->memplanes, true);
 		if (ret < 0)
 			return ret;
 	}
@@ -1100,7 +1111,10 @@ static int fimc_cap_enum_input(struct file *file, void *priv,
 			       struct v4l2_input *i)
 {
 	struct fimc_dev *fimc = video_drvdata(file);
-	struct v4l2_subdev *sd = fimc->pipeline.subdevs[IDX_SENSOR];
+	struct v4l2_subdev *sd;
+
+	sd = fimc_pipeline_get_subdev(fimc->pipeline_ops,
+				&fimc->pipeline, EXYNOS_SD_SENSOR);
 
 	if (i->index != 0)
 		return -EINVAL;
@@ -1186,8 +1200,10 @@ static int fimc_pipeline_validate(struct fimc_dev *fimc)
 		    src_fmt.format.code != sink_fmt.format.code)
 			return -EPIPE;
 
-		if (sd == fimc->pipeline.subdevs[IDX_SENSOR] &&
-		    fimc_user_defined_mbus_fmt(src_fmt.format.code)) {
+		if (sd == fimc_pipeline_get_subdev(fimc->pipeline_ops,
+				&fimc->pipeline, EXYNOS_SD_SENSOR) &&
+			  fimc_user_defined_mbus_fmt(src_fmt.format.code)) {
+
 			struct v4l2_plane_pix_format plane_fmt[FIMC_MAX_PLANES];
 			struct fimc_frame *frame = &vc->ctx->d_frame;
 			unsigned int i;
@@ -1220,11 +1236,12 @@ static int fimc_cap_streamon(struct file *file, void *priv,
 	if (fimc_capture_active(fimc))
 		return -EBUSY;
 
-	ret = media_entity_pipeline_start(entity, p->m_pipeline);
+	ret = media_entity_pipeline_start(entity, &p->m_pipeline);
 	if (ret < 0)
 		return ret;
 
-	sd = p->subdevs[IDX_SENSOR];
+	sd = fimc_pipeline_get_subdev(fimc->pipeline_ops, p,
+						EXYNOS_SD_SENSOR);
 	if (sd)
 		si = v4l2_get_subdev_hostdata(sd);
 
@@ -1830,6 +1847,9 @@ static int fimc_capture_subdev_registered(struct v4l2_subdev *sd)
 		return ret;
 
 	fimc->pipeline_ops = v4l2_get_subdev_hostdata(sd);
+	fimc->pipeline_ops->init(&fimc->pipeline);
+	fimc->pipeline_ops->register_notify_cb(&fimc->pipeline,
+						fimc_sensor_notify);
 
 	ret = fimc_register_capture_device(fimc, sd->v4l2_dev);
 	if (ret) {
@@ -1852,6 +1872,7 @@ static void fimc_capture_subdev_unregistered(struct v4l2_subdev *sd)
 	if (video_is_registered(&fimc->vid_cap.vfd)) {
 		video_unregister_device(&fimc->vid_cap.vfd);
 		media_entity_cleanup(&fimc->vid_cap.vfd.entity);
+		fimc->pipeline_ops->free(&fimc->pipeline);
 		fimc->pipeline_ops = NULL;
 	}
 	kfree(fimc->vid_cap.ctx);
diff --git a/drivers/media/platform/exynos4-is/fimc-lite.c b/drivers/media/platform/exynos4-is/fimc-lite.c
index 661d0d1..4878089 100644
--- a/drivers/media/platform/exynos4-is/fimc-lite.c
+++ b/drivers/media/platform/exynos4-is/fimc-lite.c
@@ -817,7 +817,7 @@ static int fimc_lite_streamon(struct file *file, void *priv,
 	if (fimc_lite_active(fimc))
 		return -EBUSY;
 
-	ret = media_entity_pipeline_start(entity, p->m_pipeline);
+	ret = media_entity_pipeline_start(entity, &p->m_pipeline);
 	if (ret < 0)
 		return ret;
 
@@ -1296,6 +1296,7 @@ static int fimc_lite_subdev_registered(struct v4l2_subdev *sd)
 
 	video_set_drvdata(vfd, fimc);
 	fimc->pipeline_ops = v4l2_get_subdev_hostdata(sd);
+	fimc->pipeline_ops->init(&fimc->pipeline);
 
 	ret = video_register_device(vfd, VFL_TYPE_GRABBER, -1);
 	if (ret < 0) {
@@ -1319,6 +1320,7 @@ static void fimc_lite_subdev_unregistered(struct v4l2_subdev *sd)
 	if (video_is_registered(&fimc->vfd)) {
 		video_unregister_device(&fimc->vfd);
 		media_entity_cleanup(&fimc->vfd.entity);
+		fimc->pipeline_ops->free(&fimc->pipeline);
 		fimc->pipeline_ops = NULL;
 	}
 }
diff --git a/drivers/media/platform/exynos4-is/media-dev.c b/drivers/media/platform/exynos4-is/media-dev.c
index 1dbd554..c80633a 100644
--- a/drivers/media/platform/exynos4-is/media-dev.c
+++ b/drivers/media/platform/exynos4-is/media-dev.c
@@ -36,6 +36,8 @@
 #include "fimc-lite.h"
 #include "mipi-csis.h"
 
+static struct exynos4_pipeline exynos4_pl;
+
 static int __fimc_md_set_camclk(struct fimc_md *fmd,
 				struct fimc_source_info *si,
 				bool on);
@@ -45,7 +47,7 @@ static int __fimc_md_set_camclk(struct fimc_md *fmd,
  *
  * Caller holds the graph mutex.
  */
-static void fimc_pipeline_prepare(struct fimc_pipeline *p,
+static void fimc_pipeline_prepare(struct exynos4_pipeline *p,
 				  struct media_entity *me)
 {
 	struct v4l2_subdev *sd;
@@ -131,7 +133,7 @@ static int __subdev_set_power(struct v4l2_subdev *sd, int on)
  *
  * Needs to be called with the graph mutex held.
  */
-static int fimc_pipeline_s_power(struct fimc_pipeline *p, bool on)
+static int fimc_pipeline_s_power(struct exynos4_pipeline *p, bool on)
 {
 	static const u8 seq[2][IDX_MAX - 1] = {
 		{ IDX_IS_ISP, IDX_SENSOR, IDX_CSIS, IDX_FLITE },
@@ -146,8 +148,6 @@ static int fimc_pipeline_s_power(struct fimc_pipeline *p, bool on)
 		unsigned int idx = seq[on][i];
 
 		ret = __subdev_set_power(p->subdevs[idx], on);
-
-
 		if (ret < 0 && ret != -ENXIO)
 			goto error;
 	}
@@ -160,6 +160,48 @@ error:
 	return ret;
 }
 
+
+/**
+ * __fimc_pipeline_init - allocate the fimc_pipeline structure and do the
+ *                        basic initialization.
+ * @p: Pointer to fimc_pipeline structure
+ *
+ * Initializes the 'is_init' variable to indicate the pipeline structure
+ * is valid.
+ */
+static int __fimc_pipeline_init(struct fimc_pipeline *p)
+{
+	struct exynos4_pipeline *ep = &exynos4_pl;
+
+	if (ep->is_init)
+		return 0;
+
+	ep->is_init = true;
+	p->priv = (void *)ep;
+	return 0;
+}
+
+/**
+ * __fimc_pipeline_free - free the allocated resources for fimc_pipeline
+ * @p: Pointer to fimc_pipeline structure
+ *
+ * sets the 'is_init' variable to false, to indicate the pipeline structure
+ * is not valid.
+ *
+ * RETURNS:
+ * Zero in case of success and -EINVAL in case of failure.
+ */
+static int __fimc_pipeline_free(struct fimc_pipeline *p)
+{
+	struct exynos4_pipeline *ep = (struct exynos4_pipeline *)p->priv;
+
+	if (!ep || !ep->is_init)
+		return -EINVAL;
+
+	ep->is_init = false;
+	return 0;
+}
+
 /**
  * __fimc_pipeline_open - update the pipeline information, enable power
  *                        of all pipeline subdevs and the sensor clock
@@ -171,6 +213,7 @@ error:
 static int __fimc_pipeline_open(struct fimc_pipeline *p,
 				struct media_entity *me, bool prepare)
 {
+	struct exynos4_pipeline *ep = (struct exynos4_pipeline *)p->priv;
 	struct fimc_md *fmd = entity_to_fimc_mdev(me);
 	struct v4l2_subdev *sd;
 	int ret;
@@ -178,15 +221,18 @@ static int __fimc_pipeline_open(struct fimc_pipeline *p,
 	if (WARN_ON(p == NULL || me == NULL))
 		return -EINVAL;
 
+	if (!ep || !ep->is_init)
+		return -EINVAL;
+
 	if (prepare)
-		fimc_pipeline_prepare(p, me);
+		fimc_pipeline_prepare(ep, me);
 
-	sd = p->subdevs[IDX_SENSOR];
+	sd = ep->subdevs[IDX_SENSOR];
 	if (sd == NULL)
 		return -EINVAL;
 
 	/* Disable PXLASYNC clock if this pipeline includes FIMC-IS */
-	if (!IS_ERR(fmd->wbclk[CLK_IDX_WB_B]) && p->subdevs[IDX_IS_ISP]) {
+	if (!IS_ERR(fmd->wbclk[CLK_IDX_WB_B]) && ep->subdevs[IDX_IS_ISP]) {
 		ret = clk_prepare_enable(fmd->wbclk[CLK_IDX_WB_B]);
 		if (ret < 0)
 			return ret;
@@ -195,14 +241,14 @@ static int __fimc_pipeline_open(struct fimc_pipeline *p,
 	if (ret < 0)
 		goto err_wbclk;
 
-	ret = fimc_pipeline_s_power(p, 1);
+	ret = fimc_pipeline_s_power(ep, 1);
 	if (!ret)
 		return 0;
 
 	fimc_md_set_camclk(sd, false);
 
 err_wbclk:
-	if (!IS_ERR(fmd->wbclk[CLK_IDX_WB_B]) && p->subdevs[IDX_IS_ISP])
+	if (!IS_ERR(fmd->wbclk[CLK_IDX_WB_B]) && ep->subdevs[IDX_IS_ISP])
 		clk_disable_unprepare(fmd->wbclk[CLK_IDX_WB_B]);
 
 	return ret;
@@ -216,22 +262,23 @@ err_wbclk:
  */
 static int __fimc_pipeline_close(struct fimc_pipeline *p)
 {
-	struct v4l2_subdev *sd = p ? p->subdevs[IDX_SENSOR] : NULL;
+	struct exynos4_pipeline *ep = (struct exynos4_pipeline *)p->priv;
+	struct v4l2_subdev *sd = ep ? ep->subdevs[IDX_SENSOR] : NULL;
 	struct fimc_md *fmd;
 	int ret = 0;
 
 	if (WARN_ON(sd == NULL))
 		return -EINVAL;
 
-	if (p->subdevs[IDX_SENSOR]) {
-		ret = fimc_pipeline_s_power(p, 0);
+	if (ep->subdevs[IDX_SENSOR]) {
+		ret = fimc_pipeline_s_power(ep, 0);
 		fimc_md_set_camclk(sd, false);
 	}
 
 	fmd = entity_to_fimc_mdev(&sd->entity);
 
 	/* Disable PXLASYNC clock if this pipeline includes FIMC-IS */
-	if (!IS_ERR(fmd->wbclk[CLK_IDX_WB_B]) && p->subdevs[IDX_IS_ISP])
+	if (!IS_ERR(fmd->wbclk[CLK_IDX_WB_B]) && ep->subdevs[IDX_IS_ISP])
 		clk_disable_unprepare(fmd->wbclk[CLK_IDX_WB_B]);
 
 	return ret == -ENXIO ? 0 : ret;
@@ -244,19 +291,20 @@ static int __fimc_pipeline_close(struct fimc_pipeline *p)
  */
 static int __fimc_pipeline_s_stream(struct fimc_pipeline *p, bool on)
 {
+	struct exynos4_pipeline *ep = (struct exynos4_pipeline *)p->priv;
 	static const u8 seq[2][IDX_MAX] = {
 		{ IDX_FIMC, IDX_SENSOR, IDX_IS_ISP, IDX_CSIS, IDX_FLITE },
 		{ IDX_CSIS, IDX_FLITE, IDX_FIMC, IDX_SENSOR, IDX_IS_ISP },
 	};
 	int i, ret = 0;
 
-	if (p->subdevs[IDX_SENSOR] == NULL)
+	if (ep->subdevs[IDX_SENSOR] == NULL)
 		return -ENODEV;
 
 	for (i = 0; i < IDX_MAX; i++) {
 		unsigned int idx = seq[on][i];
 
-		ret = v4l2_subdev_call(p->subdevs[idx], video, s_stream, on);
+		ret = v4l2_subdev_call(ep->subdevs[idx], video, s_stream, on);
 
 		if (ret < 0 && ret != -ENOIOCTLCMD && ret != -ENODEV)
 			goto error;
@@ -265,16 +313,74 @@ static int __fimc_pipeline_s_stream(struct fimc_pipeline *p, bool on)
 error:
 	for (; i >= 0; i--) {
 		unsigned int idx = seq[on][i];
-		v4l2_subdev_call(p->subdevs[idx], video, s_stream, !on);
+		v4l2_subdev_call(ep->subdevs[idx], video, s_stream, !on);
 	}
 	return ret;
 }
 
+/**
+ * __fimc_pipeline_get_subdev_sensor - if valid pipeline, returns the sensor
+ *                                     subdev pointer else returns NULL
+ * @p: Pointer to fimc_pipeline structure
+ * @sd_idx: Index of the subdev associated with the current pipeline
+ *
+ * RETURNS:
+ * If success, returns valid subdev pointer or NULL in case of sudbev not found
+ */
+static struct v4l2_subdev *__fimc_pipeline_get_subdev(struct fimc_pipeline *p,
+					enum exynos_subdev_index sd_idx)
+{
+	struct exynos4_pipeline *ep = (struct exynos4_pipeline *)p->priv;
+	struct v4l2_subdev *sd;
+
+	if (!ep || !ep->is_init)
+		return NULL;
+
+	switch (sd_idx) {
+	case EXYNOS_SD_SENSOR:
+		sd = ep->subdevs[IDX_SENSOR];
+		break;
+	case EXYNOS_SD_CSIS:
+		sd = ep->subdevs[IDX_CSIS];
+		break;
+	case EXYNOS_SD_FLITE:
+		sd = ep->subdevs[IDX_FLITE];
+		break;
+	case EXYNOS_SD_IS_ISP:
+		sd = ep->subdevs[IDX_IS_ISP];
+		break;
+	case EXYNOS_SD_FIMC:
+		sd = ep->subdevs[IDX_FIMC];
+		break;
+	default:
+		sd = NULL;
+		break;
+	}
+	return sd;
+}
+
+static void __fimc_pipeline_register_notify_callback(
+		struct fimc_pipeline *p,
+		void (*notify_cb)(struct v4l2_subdev *sd,
+					unsigned int notification, void *arg))
+{
+	struct exynos4_pipeline *ep = (struct exynos4_pipeline *)p->priv;
+
+	if (!notify_cb)
+		return;
+
+	ep->sensor_notify = notify_cb;
+}
+
 /* Media pipeline operations for the FIMC/FIMC-LITE video device driver */
 static const struct fimc_pipeline_ops fimc_pipeline_ops = {
+	.init		= __fimc_pipeline_init,
+	.free		= __fimc_pipeline_free,
 	.open		= __fimc_pipeline_open,
 	.close		= __fimc_pipeline_close,
 	.set_stream	= __fimc_pipeline_s_stream,
+	.get_subdev	= __fimc_pipeline_get_subdev,
+	.register_notify_cb     = __fimc_pipeline_register_notify_callback,
 };
 
 /*
@@ -1234,6 +1340,7 @@ static int fimc_md_link_notify(struct media_pad *source,
 	struct fimc_lite *fimc_lite = NULL;
 	struct fimc_dev *fimc = NULL;
 	struct fimc_pipeline *pipeline;
+	struct exynos4_pipeline *ep;
 	struct v4l2_subdev *sd;
 	struct mutex *lock;
 	int i, ret = 0;
@@ -1266,6 +1373,10 @@ static int fimc_md_link_notify(struct media_pad *source,
 	mutex_lock(lock);
 	ref_count = fimc ? fimc->vid_cap.refcnt : fimc_lite->ref_count;
 
+	ep = (struct exynos4_pipeline *)pipeline->priv;
+	if (!ep || !ep->is_init)
+		return -EINVAL;
+
 	if (!(flags & MEDIA_LNK_FL_ENABLED)) {
 		if (ref_count > 0) {
 			ret = __fimc_pipeline_close(pipeline);
@@ -1273,7 +1384,7 @@ static int fimc_md_link_notify(struct media_pad *source,
 				fimc_ctrls_delete(fimc->vid_cap.ctx);
 		}
 		for (i = 0; i < IDX_MAX; i++)
-			pipeline->subdevs[i] = NULL;
+			ep->subdevs[i] = NULL;
 	} else if (ref_count > 0) {
 		/*
 		 * Link activation. Enable power of pipeline elements only if
@@ -1290,6 +1401,38 @@ static int fimc_md_link_notify(struct media_pad *source,
 	return ret ? -EPIPE : ret;
 }
 
+/**
+ * fimc_md_sensor_notify - v4l2_device notification from a sensor subdev
+ * @sd: pointer to a subdev generating the notification
+ * @notification: the notification type, must be S5P_FIMC_TX_END_NOTIFY
+ * @arg: pointer to an u32 type integer that stores the frame payload value
+ *
+ * Passes the sensor notification to the capture device
+ */
+void fimc_md_sensor_notify(struct v4l2_subdev *sd,
+				unsigned int notification, void *arg)
+{
+	struct fimc_md *fmd;
+	struct exynos4_pipeline *ep;
+	struct fimc_pipeline *p;
+	unsigned long flags;
+
+	fmd = entity_to_fimc_mdev(&sd->entity);
+
+	if (sd == NULL)
+		return;
+
+	p = media_pipe_to_fimc_pipeline(sd->entity.pipe);
+	ep = (struct exynos4_pipeline *)p->priv;
+
+	spin_lock_irqsave(&fmd->slock, flags);
+
+	if (ep->sensor_notify)
+		ep->sensor_notify(sd, notification, arg);
+
+	spin_unlock_irqrestore(&fmd->slock, flags);
+}
+
 static ssize_t fimc_md_sysfs_show(struct device *dev,
 				  struct device_attribute *attr, char *buf)
 {
@@ -1375,7 +1518,7 @@ static int fimc_md_probe(struct platform_device *pdev)
 
 	v4l2_dev = &fmd->v4l2_dev;
 	v4l2_dev->mdev = &fmd->media_dev;
-	v4l2_dev->notify = fimc_sensor_notify;
+	v4l2_dev->notify = fimc_md_sensor_notify;
 	strlcpy(v4l2_dev->name, "s5p-fimc-md", sizeof(v4l2_dev->name));
 
 	fmd->use_isp = fimc_md_is_isp_available(dev->of_node);
diff --git a/drivers/media/platform/exynos4-is/media-dev.h b/drivers/media/platform/exynos4-is/media-dev.h
index 44d86b6..7ee8dd8 100644
--- a/drivers/media/platform/exynos4-is/media-dev.h
+++ b/drivers/media/platform/exynos4-is/media-dev.h
@@ -40,6 +40,15 @@ enum {
 	FIMC_MAX_WBCLKS
 };
 
+enum exynos4_subdev_index {
+	IDX_SENSOR,
+	IDX_CSIS,
+	IDX_FLITE,
+	IDX_IS_ISP,
+	IDX_FIMC,
+	IDX_MAX,
+};
+
 struct fimc_csis_info {
 	struct v4l2_subdev *sd;
 	int id;
@@ -107,6 +116,13 @@ struct fimc_md {
 	spinlock_t slock;
 };
 
+struct exynos4_pipeline {
+	int is_init;
+	struct v4l2_subdev *subdevs[IDX_MAX];
+	void (*sensor_notify)(struct v4l2_subdev *sd,
+			unsigned int notification, void *arg);
+};
+
 #define is_subdev_pad(pad) (pad == NULL || \
 	media_entity_type(pad->entity) == MEDIA_ENT_T_V4L2_SUBDEV)
 
diff --git a/include/media/s5p_fimc.h b/include/media/s5p_fimc.h
index f509690..2908a02 100644
--- a/include/media/s5p_fimc.h
+++ b/include/media/s5p_fimc.h
@@ -105,6 +105,24 @@ struct s5p_platform_fimc {
  */
 #define S5P_FIMC_TX_END_NOTIFY _IO('e', 0)
 
+/* Group IDs of sensor, MIPI-CSIS, FIMC-LITE and the writeback subdevs. */
+#define GRP_ID_SENSOR		(1 << 8)
+#define GRP_ID_FIMC_IS_SENSOR	(1 << 9)
+#define GRP_ID_WRITEBACK	(1 << 10)
+#define GRP_ID_CSIS		(1 << 11)
+#define GRP_ID_FIMC		(1 << 12)
+#define GRP_ID_FLITE		(1 << 13)
+#define GRP_ID_FIMC_IS		(1 << 14)
+
+enum exynos_subdev_index {
+	EXYNOS_SD_SENSOR,
+	EXYNOS_SD_CSIS,
+	EXYNOS_SD_FLITE,
+	EXYNOS_SD_IS_ISP,
+	EXYNOS_SD_FIMC,
+	EXYNOS_SD_MAX,
+};
+
 #define FIMC_MAX_PLANES	3
 
 /**
@@ -140,21 +158,12 @@ struct fimc_fmt {
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
 struct media_pipeline;
 struct v4l2_subdev;
 
 struct fimc_pipeline {
-	struct v4l2_subdev *subdevs[IDX_MAX];
-	struct media_pipeline *m_pipeline;
+	struct media_pipeline m_pipeline;
+	void *priv;
 };
 
 /*
@@ -163,14 +172,27 @@ struct fimc_pipeline {
  * by corresponding media device driver.
  */
 struct fimc_pipeline_ops {
+	int (*init) (struct fimc_pipeline *p);
+	int (*free) (struct fimc_pipeline *p);
 	int (*open)(struct fimc_pipeline *p, struct media_entity *me,
-			  bool resume);
+					bool resume);
 	int (*close)(struct fimc_pipeline *p);
 	int (*set_stream)(struct fimc_pipeline *p, bool state);
+	struct v4l2_subdev *(*get_subdev)(struct fimc_pipeline *p,
+					enum exynos_subdev_index sd_idx);
+	void (*register_notify_cb)(struct fimc_pipeline *p,
+					void (*cb)(struct v4l2_subdev *sd,
+					unsigned int notification, void *arg));
 };
 
 #define fimc_pipeline_call(f, op, p, args...)				\
 	(!(f) ? -ENODEV : (((f)->pipeline_ops && (f)->pipeline_ops->op) ? \
 			    (f)->pipeline_ops->op((p), ##args) : -ENOIOCTLCMD))
 
+#define fimc_pipeline_get_subdev(ops, p, idx_subdev)			\
+	((ops && ops->get_subdev) ? ops->get_subdev(p, idx_subdev) : NULL)
+
+#define media_pipe_to_fimc_pipeline(mp) \
+	container_of(mp, struct fimc_pipeline, m_pipeline)
+
 #endif /* S5P_FIMC_H_ */
-- 
1.7.9.5

