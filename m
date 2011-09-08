Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.9]:61328 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932421Ab1IHIoR (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 8 Sep 2011 04:44:17 -0400
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [PATCH 01/13 v3] soc_camera: add control handler support
Date: Thu,  8 Sep 2011 10:43:54 +0200
Message-Id: <1315471446-17890-2-git-send-email-g.liakhovetski@gmx.de>
In-Reply-To: <1315471446-17890-1-git-send-email-g.liakhovetski@gmx.de>
References: <1315471446-17890-1-git-send-email-g.liakhovetski@gmx.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The soc_camera framework is switched over to use the control framework.
After this patch none of the controls in subdevs or host drivers are available,
until those drivers are also converted to the control framework.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
[g.liakhovetski@gmx.de: moved code around, fixed problems]
Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 drivers/media/video/soc_camera.c |   94 ++++++++------------------------------
 include/media/soc_camera.h       |    2 +
 2 files changed, 21 insertions(+), 75 deletions(-)

diff --git a/drivers/media/video/soc_camera.c b/drivers/media/video/soc_camera.c
index f0996de..6bd6fd9 100644
--- a/drivers/media/video/soc_camera.c
+++ b/drivers/media/video/soc_camera.c
@@ -554,6 +554,7 @@ static int soc_camera_open(struct file *file)
 			if (ret < 0)
 				goto einitvb;
 		}
+		v4l2_ctrl_handler_setup(&icd->ctrl_handler);
 	}
 
 	file->private_data = icd;
@@ -823,78 +824,6 @@ static int soc_camera_streamoff(struct file *file, void *priv,
 	return 0;
 }
 
-static int soc_camera_queryctrl(struct file *file, void *priv,
-				struct v4l2_queryctrl *qc)
-{
-	struct soc_camera_device *icd = file->private_data;
-	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
-	int i;
-
-	WARN_ON(priv != file->private_data);
-
-	if (!qc->id)
-		return -EINVAL;
-
-	/* First check host controls */
-	for (i = 0; i < ici->ops->num_controls; i++)
-		if (qc->id == ici->ops->controls[i].id) {
-			memcpy(qc, &(ici->ops->controls[i]),
-				sizeof(*qc));
-			return 0;
-		}
-
-	if (!icd->ops)
-		return -EINVAL;
-
-	/* Then device controls */
-	for (i = 0; i < icd->ops->num_controls; i++)
-		if (qc->id == icd->ops->controls[i].id) {
-			memcpy(qc, &(icd->ops->controls[i]),
-				sizeof(*qc));
-			return 0;
-		}
-
-	return -EINVAL;
-}
-
-static int soc_camera_g_ctrl(struct file *file, void *priv,
-			     struct v4l2_control *ctrl)
-{
-	struct soc_camera_device *icd = file->private_data;
-	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
-	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
-	int ret;
-
-	WARN_ON(priv != file->private_data);
-
-	if (ici->ops->get_ctrl) {
-		ret = ici->ops->get_ctrl(icd, ctrl);
-		if (ret != -ENOIOCTLCMD)
-			return ret;
-	}
-
-	return v4l2_subdev_call(sd, core, g_ctrl, ctrl);
-}
-
-static int soc_camera_s_ctrl(struct file *file, void *priv,
-			     struct v4l2_control *ctrl)
-{
-	struct soc_camera_device *icd = file->private_data;
-	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
-	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
-	int ret;
-
-	WARN_ON(priv != file->private_data);
-
-	if (ici->ops->set_ctrl) {
-		ret = ici->ops->set_ctrl(icd, ctrl);
-		if (ret != -ENOIOCTLCMD)
-			return ret;
-	}
-
-	return v4l2_subdev_call(sd, core, s_ctrl, ctrl);
-}
-
 static int soc_camera_cropcap(struct file *file, void *fh,
 			      struct v4l2_cropcap *a)
 {
@@ -1097,6 +1026,17 @@ static int soc_camera_probe(struct soc_camera_device *icd)
 
 	dev_info(icd->pdev, "Probing %s\n", dev_name(icd->pdev));
 
+	/*
+	 * Currently the subdev with the largest number of controls (13) is
+	 * ov6550. So let's pick 16 as a hint for the control handler. Note
+	 * that this is a hint only: too large and you waste some memory, too
+	 * small and there is a (very) small performance hit when looking up
+	 * controls in the internal hash.
+	 */
+	ret = v4l2_ctrl_handler_init(&icd->ctrl_handler, 16);
+	if (ret < 0)
+		return ret;
+
 	ret = regulator_bulk_get(icd->pdev, icl->num_regulators,
 				 icl->regulators);
 	if (ret < 0)
@@ -1157,6 +1097,9 @@ static int soc_camera_probe(struct soc_camera_device *icd)
 	sd = soc_camera_to_subdev(icd);
 	sd->grp_id = (long)icd;
 
+	if (v4l2_ctrl_add_handler(&icd->ctrl_handler, sd->ctrl_handler))
+		goto ectrl;
+
 	/* At this point client .probe() should have run already */
 	ret = soc_camera_init_user_formats(icd);
 	if (ret < 0)
@@ -1201,6 +1144,7 @@ evidstart:
 	mutex_unlock(&icd->video_lock);
 	soc_camera_free_user_formats(icd);
 eiufmt:
+ectrl:
 	if (icl->board_info) {
 		soc_camera_free_i2c(icd);
 	} else {
@@ -1218,6 +1162,7 @@ eadd:
 epower:
 	regulator_bulk_free(icl->num_regulators, icl->regulators);
 ereg:
+	v4l2_ctrl_handler_free(&icd->ctrl_handler);
 	return ret;
 }
 
@@ -1232,6 +1177,7 @@ static int soc_camera_remove(struct soc_camera_device *icd)
 
 	BUG_ON(!icd->parent);
 
+	v4l2_ctrl_handler_free(&icd->ctrl_handler);
 	if (vdev) {
 		video_unregister_device(vdev);
 		icd->vdev = NULL;
@@ -1439,9 +1385,6 @@ static const struct v4l2_ioctl_ops soc_camera_ioctl_ops = {
 	.vidioc_prepare_buf	 = soc_camera_prepare_buf,
 	.vidioc_streamon	 = soc_camera_streamon,
 	.vidioc_streamoff	 = soc_camera_streamoff,
-	.vidioc_queryctrl	 = soc_camera_queryctrl,
-	.vidioc_g_ctrl		 = soc_camera_g_ctrl,
-	.vidioc_s_ctrl		 = soc_camera_s_ctrl,
 	.vidioc_cropcap		 = soc_camera_cropcap,
 	.vidioc_g_crop		 = soc_camera_g_crop,
 	.vidioc_s_crop		 = soc_camera_s_crop,
@@ -1470,6 +1413,7 @@ static int video_dev_create(struct soc_camera_device *icd)
 	vdev->ioctl_ops		= &soc_camera_ioctl_ops;
 	vdev->release		= video_device_release;
 	vdev->tvnorms		= V4L2_STD_UNKNOWN;
+	vdev->ctrl_handler	= &icd->ctrl_handler;
 	vdev->lock		= &icd->video_lock;
 
 	icd->vdev = vdev;
diff --git a/include/media/soc_camera.h b/include/media/soc_camera.h
index 1864e22..2e15e17 100644
--- a/include/media/soc_camera.h
+++ b/include/media/soc_camera.h
@@ -19,6 +19,7 @@
 #include <linux/videodev2.h>
 #include <media/videobuf-core.h>
 #include <media/videobuf2-core.h>
+#include <media/v4l2-ctrls.h>
 #include <media/v4l2-device.h>
 
 struct file;
@@ -40,6 +41,7 @@ struct soc_camera_device {
 	struct soc_camera_sense *sense;	/* See comment in struct definition */
 	struct soc_camera_ops *ops;
 	struct video_device *vdev;
+	struct v4l2_ctrl_handler ctrl_handler;
 	const struct soc_camera_format_xlate *current_fmt;
 	struct soc_camera_format_xlate *user_formats;
 	int num_user_formats;
-- 
1.7.2.5

