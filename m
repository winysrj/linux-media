Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:61529 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752674Ab3EaOj2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 31 May 2013 10:39:28 -0400
Received: from epcpsbgm2.samsung.com (epcpsbgm2 [203.254.230.27])
 by mailout2.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MNO009QV3D7QJV0@mailout2.samsung.com> for
 linux-media@vger.kernel.org; Fri, 31 May 2013 23:39:27 +0900 (KST)
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, hj210.choi@samsung.com,
	arun.kk@samsung.com, shaik.ameer@samsung.com,
	kyungmin.park@samsung.com,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [REVIEW PATCH v2 03/11] exynos4-is: Preserve state of controls between
 /dev/video open/close
Date: Fri, 31 May 2013 16:37:19 +0200
Message-id: <1370011047-11488-4-git-send-email-s.nawrocki@samsung.com>
In-reply-to: <1370011047-11488-1-git-send-email-s.nawrocki@samsung.com>
References: <1370011047-11488-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch moves the code for inheriting subdev v4l2 controls on the
FIMC video capture nodes from open()/close() fops to the link setup
notification callback. This allows for the state of the FIMC controls
to be always kept, in opposite to the current situation when it is
lost when last process closes video device.

There is no visible change for the original V4L2 compliant interface.
For the MC aware applications (user_subdev_api == true) inheriting
of the controls is dropped, since there can be same controls on the
subdevs withing single pipeline, now when the ISP (FIMC-IS) is also
used.

This patch is a prerequisite to allow /dev/video device to be opened
without errors even if there is no media links connecting it to an
image source (sensor) subdev. This is required for a libv4l2 plugin
to be initialized while a video node is opened and it also should be
possible to always open the device to query the capabilities.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/platform/exynos4-is/fimc-capture.c |   96 +++++++++++-----------
 drivers/media/platform/exynos4-is/fimc-core.h    |    3 +
 drivers/media/platform/exynos4-is/media-dev.c    |    4 -
 3 files changed, 50 insertions(+), 53 deletions(-)

diff --git a/drivers/media/platform/exynos4-is/fimc-capture.c b/drivers/media/platform/exynos4-is/fimc-capture.c
index be4387b..762fc7b9 100644
--- a/drivers/media/platform/exynos4-is/fimc-capture.c
+++ b/drivers/media/platform/exynos4-is/fimc-capture.c
@@ -27,9 +27,10 @@
 #include <media/videobuf2-core.h>
 #include <media/videobuf2-dma-contig.h>
 
-#include "media-dev.h"
+#include "common.h"
 #include "fimc-core.h"
 #include "fimc-reg.h"
+#include "media-dev.h"
 
 static int fimc_capture_hw_init(struct fimc_dev *fimc)
 {
@@ -472,40 +473,13 @@ static struct vb2_ops fimc_capture_qops = {
 	.stop_streaming		= stop_streaming,
 };
 
-/**
- * fimc_capture_ctrls_create - initialize the control handler
- * Initialize the capture video node control handler and fill it
- * with the FIMC controls. Inherit any sensor's controls if the
- * 'user_subdev_api' flag is false (default behaviour).
- * This function need to be called with the graph mutex held.
- */
-int fimc_capture_ctrls_create(struct fimc_dev *fimc)
-{
-	struct fimc_vid_cap *vid_cap = &fimc->vid_cap;
-	struct v4l2_subdev *sensor = fimc->pipeline.subdevs[IDX_SENSOR];
-	int ret;
-
-	if (WARN_ON(vid_cap->ctx == NULL))
-		return -ENXIO;
-	if (vid_cap->ctx->ctrls.ready)
-		return 0;
-
-	ret = fimc_ctrls_create(vid_cap->ctx);
-
-	if (ret || vid_cap->user_subdev_api || !sensor ||
-	    !vid_cap->ctx->ctrls.ready)
-		return ret;
-
-	return v4l2_ctrl_add_handler(&vid_cap->ctx->ctrls.handler,
-				     sensor->ctrl_handler, NULL);
-}
-
 static int fimc_capture_set_default_format(struct fimc_dev *fimc);
 
 static int fimc_capture_open(struct file *file)
 {
 	struct fimc_dev *fimc = video_drvdata(file);
-	struct exynos_video_entity *ve = &fimc->vid_cap.ve;
+	struct fimc_vid_cap *vc = &fimc->vid_cap;
+	struct exynos_video_entity *ve = &vc->ve;
 	int ret = -EBUSY;
 
 	dbg("pid: %d, state: 0x%lx", task_pid_nr(current), fimc->state);
@@ -530,12 +504,20 @@ static int fimc_capture_open(struct file *file)
 	if (v4l2_fh_is_singular_file(file)) {
 		ret = fimc_pipeline_call(fimc, open, &fimc->pipeline,
 					 &fimc->vid_cap.ve.vdev.entity, true);
-
-		if (!ret && !fimc->vid_cap.user_subdev_api)
+		if (ret == 0)
 			ret = fimc_capture_set_default_format(fimc);
 
-		if (!ret)
-			ret = fimc_capture_ctrls_create(fimc);
+		if (ret == 0 && vc->user_subdev_api && vc->inh_sensor_ctrls) {
+			/*
+			 * Recreate controls of the the video node to drop
+			 * any controls inherited from the sensor subdev.
+			 */
+			fimc_ctrls_delete(vc->ctx);
+
+			ret = fimc_ctrls_create(vc->ctx);
+			if (ret == 0)
+				vc->inh_sensor_ctrls = false;
+		}
 
 		if (ret < 0) {
 			clear_bit(ST_CAPT_BUSY, &fimc->state);
@@ -574,10 +556,6 @@ static int fimc_capture_release(struct file *file)
 	}
 
 	pm_runtime_put(&fimc->pdev->dev);
-
-	if (v4l2_fh_is_singular_file(file))
-		fimc_ctrls_delete(fimc->vid_cap.ctx);
-
 	ret = vb2_fop_release(file);
 	mutex_unlock(&fimc->lock);
 
@@ -1410,6 +1388,8 @@ static int fimc_link_setup(struct media_entity *entity,
 {
 	struct v4l2_subdev *sd = media_entity_to_v4l2_subdev(entity);
 	struct fimc_dev *fimc = v4l2_get_subdevdata(sd);
+	struct fimc_vid_cap *vc = &fimc->vid_cap;
+	struct v4l2_subdev *sensor;
 
 	if (media_entity_type(remote->entity) != MEDIA_ENT_T_V4L2_SUBDEV)
 		return -EINVAL;
@@ -1421,15 +1401,26 @@ static int fimc_link_setup(struct media_entity *entity,
 	    local->entity->name, remote->entity->name, flags,
 	    fimc->vid_cap.input);
 
-	if (flags & MEDIA_LNK_FL_ENABLED) {
-		if (fimc->vid_cap.input != 0)
-			return -EBUSY;
-		fimc->vid_cap.input = sd->grp_id;
+	if (!(flags & MEDIA_LNK_FL_ENABLED)) {
+		fimc->vid_cap.input = 0;
 		return 0;
 	}
 
-	fimc->vid_cap.input = 0;
-	return 0;
+	if (vc->input != 0)
+		return -EBUSY;
+
+	vc->input = sd->grp_id;
+
+	if (vc->user_subdev_api || vc->inh_sensor_ctrls)
+		return 0;
+
+	/* Inherit V4L2 controls from the image sensor subdev. */
+	sensor = fimc_find_remote_sensor(&vc->subdev.entity);
+	if (sensor == NULL)
+		return 0;
+
+	return v4l2_ctrl_add_handler(&vc->ctx->ctrls.handler,
+				     sensor->ctrl_handler, NULL);
 }
 
 static const struct media_entity_operations fimc_sd_media_ops = {
@@ -1789,12 +1780,16 @@ static int fimc_register_capture_device(struct fimc_dev *fimc,
 
 	ret = vb2_queue_init(q);
 	if (ret)
-		goto err_ent;
+		goto err_free_ctx;
 
 	vid_cap->vd_pad.flags = MEDIA_PAD_FL_SINK;
 	ret = media_entity_init(&vfd->entity, 1, &vid_cap->vd_pad, 0);
 	if (ret)
-		goto err_ent;
+		goto err_free_ctx;
+
+	ret = fimc_ctrls_create(ctx);
+	if (ret)
+		goto err_me_cleanup;
 	/*
 	 * For proper order of acquiring/releasing the video
 	 * and the graph mutex.
@@ -1804,7 +1799,7 @@ static int fimc_register_capture_device(struct fimc_dev *fimc,
 
 	ret = video_register_device(vfd, VFL_TYPE_GRABBER, -1);
 	if (ret)
-		goto err_vd;
+		goto err_ctrl_free;
 
 	v4l2_info(v4l2_dev, "Registered %s as /dev/%s\n",
 		  vfd->name, video_device_node_name(vfd));
@@ -1812,9 +1807,11 @@ static int fimc_register_capture_device(struct fimc_dev *fimc,
 	vfd->ctrl_handler = &ctx->ctrls.handler;
 	return 0;
 
-err_vd:
+err_ctrl_free:
+	fimc_ctrls_delete(ctx);
+err_me_cleanup:
 	media_entity_cleanup(&vfd->entity);
-err_ent:
+err_free_ctx:
 	kfree(ctx);
 	return ret;
 }
@@ -1856,6 +1853,7 @@ static void fimc_capture_subdev_unregistered(struct v4l2_subdev *sd)
 	if (video_is_registered(vdev)) {
 		video_unregister_device(vdev);
 		media_entity_cleanup(&vdev->entity);
+		fimc_ctrls_delete(fimc->vid_cap.ctx);
 		fimc->pipeline_ops = NULL;
 	}
 	kfree(fimc->vid_cap.ctx);
diff --git a/drivers/media/platform/exynos4-is/fimc-core.h b/drivers/media/platform/exynos4-is/fimc-core.h
index 401b746..86bb8e6 100644
--- a/drivers/media/platform/exynos4-is/fimc-core.h
+++ b/drivers/media/platform/exynos4-is/fimc-core.h
@@ -303,6 +303,8 @@ struct fimc_m2m_device {
  * @refcnt: driver's private reference counter
  * @input: capture input type, grp_id of the attached subdev
  * @user_subdev_api: true if subdevs are not configured by the host driver
+ * @inh_sensor_ctrls: a flag indicating v4l2 controls are inherited from
+ * 		      an image sensor subdev
  */
 struct fimc_vid_cap {
 	struct fimc_ctx			*ctx;
@@ -326,6 +328,7 @@ struct fimc_vid_cap {
 	int				refcnt;
 	u32				input;
 	bool				user_subdev_api;
+	bool				inh_sensor_ctrls;
 };
 
 /**
diff --git a/drivers/media/platform/exynos4-is/media-dev.c b/drivers/media/platform/exynos4-is/media-dev.c
index 032d2b7..122a6ba 100644
--- a/drivers/media/platform/exynos4-is/media-dev.c
+++ b/drivers/media/platform/exynos4-is/media-dev.c
@@ -1272,8 +1272,6 @@ static int fimc_md_link_notify(struct media_pad *source,
 	if (!(flags & MEDIA_LNK_FL_ENABLED)) {
 		if (ref_count > 0) {
 			ret = __fimc_pipeline_close(pipeline);
-			if (!ret && fimc)
-				fimc_ctrls_delete(fimc->vid_cap.ctx);
 		}
 		for (i = 0; i < IDX_MAX; i++)
 			pipeline->subdevs[i] = NULL;
@@ -1285,8 +1283,6 @@ static int fimc_md_link_notify(struct media_pad *source,
 		 */
 		ret = __fimc_pipeline_open(pipeline,
 					   source->entity, true);
-		if (!ret && fimc)
-			ret = fimc_capture_ctrls_create(fimc);
 	}
 
 	mutex_unlock(lock);
-- 
1.7.9.5

