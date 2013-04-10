Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:23200 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751746Ab3DJKnt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Apr 2013 06:43:49 -0400
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: kyungmin.park@samsung.com, linux-samsung-soc@vger.kernel.org,
	shaik.samsung@gmail.com, arun.kk@samsung.com,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH 2/7] exynos4-is: Make fimc-lite independent of the
 pipeline->subdevs array
Date: Wed, 10 Apr 2013 12:42:37 +0200
Message-id: <1365590562-5747-3-git-send-email-s.nawrocki@samsung.com>
In-reply-to: <1365590562-5747-1-git-send-email-s.nawrocki@samsung.com>
References: <1365590562-5747-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Get the sensor subdev by walking media graph in both cases: when the
device is used as a subdev only and through video node. This allows
to not dereference the pipeline->subdevs[] array and makes the module
more generic and easier to re-use in other media driver.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/platform/exynos4-is/fimc-lite.c |   57 ++++++++++++-------------
 1 file changed, 28 insertions(+), 29 deletions(-)

diff --git a/drivers/media/platform/exynos4-is/fimc-lite.c b/drivers/media/platform/exynos4-is/fimc-lite.c
index cb196b8..3ea4fc7 100644
--- a/drivers/media/platform/exynos4-is/fimc-lite.c
+++ b/drivers/media/platform/exynos4-is/fimc-lite.c
@@ -130,23 +130,43 @@ static const struct fimc_fmt *fimc_lite_find_format(const u32 *pixelformat,
 	return def_fmt;
 }
 
+/* Called with the media graph mutex held or @me stream_count > 0. */
+static struct v4l2_subdev *__find_remote_sensor(struct media_entity *me)
+{
+	struct media_pad *pad = &me->pads[0];
+	struct v4l2_subdev *sd;
+
+	while (pad->flags & MEDIA_PAD_FL_SINK) {
+		/* source pad */
+		pad = media_entity_remote_source(pad);
+		if (pad == NULL ||
+		    media_entity_type(pad->entity) != MEDIA_ENT_T_V4L2_SUBDEV)
+			break;
+
+		sd = media_entity_to_v4l2_subdev(pad->entity);
+
+		if (sd->grp_id == GRP_ID_FIMC_IS_SENSOR ||
+		    sd->grp_id == GRP_ID_SENSOR)
+			return sd;
+		/* sink pad */
+		pad = &sd->entity.pads[0];
+	}
+	return NULL;
+}
+
 static int fimc_lite_hw_init(struct fimc_lite *fimc, bool isp_output)
 {
-	struct fimc_pipeline *pipeline = &fimc->pipeline;
-	struct v4l2_subdev *sensor;
 	struct fimc_sensor_info *si;
 	unsigned long flags;
 
-	sensor = isp_output ? fimc->sensor : pipeline->subdevs[IDX_SENSOR];
-
-	if (sensor == NULL)
+	if (fimc->sensor == NULL)
 		return -ENXIO;
 
 	if (fimc->inp_frame.fmt == NULL || fimc->out_frame.fmt == NULL)
 		return -EINVAL;
 
 	/* Get sensor configuration data from the sensor subdev */
-	si = v4l2_get_subdev_hostdata(sensor);
+	si = v4l2_get_subdev_hostdata(fimc->sensor);
 	spin_lock_irqsave(&fimc->slock, flags);
 
 	flite_hw_set_camera_bus(fimc, &si->pdata);
@@ -801,6 +821,8 @@ static int fimc_lite_streamon(struct file *file, void *priv,
 	if (ret < 0)
 		goto err_p_stop;
 
+	fimc->sensor = __find_remote_sensor(&fimc->subdev.entity);
+
 	ret = vb2_ioctl_streamon(file, priv, type);
 	if (!ret) {
 		fimc->streaming = true;
@@ -929,29 +951,6 @@ static const struct v4l2_ioctl_ops fimc_lite_ioctl_ops = {
 	.vidioc_streamoff		= fimc_lite_streamoff,
 };
 
-/* Called with the media graph mutex held */
-static struct v4l2_subdev *__find_remote_sensor(struct media_entity *me)
-{
-	struct media_pad *pad = &me->pads[0];
-	struct v4l2_subdev *sd;
-
-	while (pad->flags & MEDIA_PAD_FL_SINK) {
-		/* source pad */
-		pad = media_entity_remote_source(pad);
-		if (pad == NULL ||
-		    media_entity_type(pad->entity) != MEDIA_ENT_T_V4L2_SUBDEV)
-			break;
-
-		sd = media_entity_to_v4l2_subdev(pad->entity);
-
-		if (sd->grp_id == GRP_ID_FIMC_IS_SENSOR)
-			return sd;
-		/* sink pad */
-		pad = &sd->entity.pads[0];
-	}
-	return NULL;
-}
-
 /* Capture subdev media entity operations */
 static int fimc_lite_link_setup(struct media_entity *entity,
 				const struct media_pad *local,
-- 
1.7.9.5

