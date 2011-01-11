Return-path: <mchehab@pedra>
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:1595 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932191Ab1AKXG3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Jan 2011 18:06:29 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Magnus Damm <magnus.damm@gmail.com>,
	Kuninori Morimoto <morimoto.kuninori@renesas.com>,
	Alberto Panizzo <maramaopercheseimorto@gmail.com>,
	Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>,
	Marek Vasut <marek.vasut@gmail.com>,
	Robert Jarzmik <robert.jarzmik@free.fr>
Subject: [RFC PATCH 01/12] soc_camera: add control handler support
Date: Wed, 12 Jan 2011 00:06:01 +0100
Message-Id: <8aa4d48eaf40a1e967e4a7450d9313de0e2c8452.1294786597.git.hverkuil@xs4all.nl>
In-Reply-To: <1294787172-13638-1-git-send-email-hverkuil@xs4all.nl>
References: <1294787172-13638-1-git-send-email-hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

The soc_camera framework is switched over to use the control framework.
After this patch none of the controls in subdevs or host drivers are available,
until those drivers are also converted to the control framework.

Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
---
 drivers/media/video/soc_camera.c          |  104 +++++++----------------------
 drivers/media/video/soc_camera_platform.c |    8 ++-
 include/media/soc_camera.h                |    2 +
 3 files changed, 33 insertions(+), 81 deletions(-)

diff --git a/drivers/media/video/soc_camera.c b/drivers/media/video/soc_camera.c
index a66811b..7de3fe2 100644
--- a/drivers/media/video/soc_camera.c
+++ b/drivers/media/video/soc_camera.c
@@ -445,6 +445,7 @@ static int soc_camera_open(struct file *file)
 			goto esfmt;
 
 		ici->ops->init_videobuf(&icd->vb_vidq, icd);
+		v4l2_ctrl_handler_setup(&icd->ctrl_handler);
 	}
 
 	file->private_data = icd;
@@ -679,75 +680,6 @@ static int soc_camera_streamoff(struct file *file, void *priv,
 	return 0;
 }
 
-static int soc_camera_queryctrl(struct file *file, void *priv,
-				struct v4l2_queryctrl *qc)
-{
-	struct soc_camera_device *icd = file->private_data;
-	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
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
-	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
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
-	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
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
@@ -908,6 +840,8 @@ static int soc_camera_init_i2c(struct soc_camera_device *icd,
 				icl->board_info, NULL);
 	if (!subdev)
 		goto ei2cnd;
+	if (v4l2_ctrl_add_handler(&icd->ctrl_handler, subdev->ctrl_handler))
+		goto ei2cnd;
 
 	client = v4l2_get_subdevdata(subdev);
 
@@ -963,15 +897,15 @@ static int soc_camera_probe(struct device *dev)
 	if (icl->reset)
 		icl->reset(icd->pdev);
 
-	ret = ici->ops->add(icd);
-	if (ret < 0)
-		goto eadd;
-
 	/* Must have icd->vdev before registering the device */
 	ret = video_dev_create(icd);
 	if (ret < 0)
 		goto evdc;
 
+	ret = ici->ops->add(icd);
+	if (ret < 0)
+		goto eadd;
+
 	/* Non-i2c cameras, e.g., soc_camera_platform, have no board_info */
 	if (icl->board_info) {
 		ret = soc_camera_init_i2c(icd, icl);
@@ -1054,10 +988,10 @@ eiufmt:
 	}
 enodrv:
 eadddev:
-	video_device_release(icd->vdev);
-evdc:
 	ici->ops->remove(icd);
 eadd:
+	video_device_release(icd->vdev);
+evdc:
 	soc_camera_power_set(icd, icl, 0);
 epower:
 	regulator_bulk_free(icl->num_regulators, icl->regulators);
@@ -1324,9 +1258,6 @@ static const struct v4l2_ioctl_ops soc_camera_ioctl_ops = {
 	.vidioc_dqbuf		 = soc_camera_dqbuf,
 	.vidioc_streamon	 = soc_camera_streamon,
 	.vidioc_streamoff	 = soc_camera_streamoff,
-	.vidioc_queryctrl	 = soc_camera_queryctrl,
-	.vidioc_g_ctrl		 = soc_camera_g_ctrl,
-	.vidioc_s_ctrl		 = soc_camera_s_ctrl,
 	.vidioc_cropcap		 = soc_camera_cropcap,
 	.vidioc_g_crop		 = soc_camera_g_crop,
 	.vidioc_s_crop		 = soc_camera_s_crop,
@@ -1355,6 +1286,7 @@ static int video_dev_create(struct soc_camera_device *icd)
 	vdev->ioctl_ops		= &soc_camera_ioctl_ops;
 	vdev->release		= video_device_release;
 	vdev->tvnorms		= V4L2_STD_UNKNOWN;
+	vdev->ctrl_handler	= &icd->ctrl_handler;
 
 	icd->vdev = vdev;
 
@@ -1402,13 +1334,24 @@ static int __devinit soc_camera_pdrv_probe(struct platform_device *pdev)
 	if (!icd)
 		return -ENOMEM;
 
+	/*
+	 * Currently the subdev with the largest number of controls (13) is
+	 * ov6550. So let's pick 16 as a hint for the control handler. Note
+	 * that this is a hint only: too large and you waste some memory, too
+	 * small and there is a (very) small performance hit when looking up
+	 * controls in the internal hash.
+	 */
+	ret = v4l2_ctrl_handler_init(&icd->ctrl_handler, 16);
+	if (ret < 0)
+		goto escdevreg;
+
 	icd->iface = icl->bus_id;
 	icd->pdev = &pdev->dev;
 	platform_set_drvdata(pdev, icd);
 
 	ret = soc_camera_device_register(icd);
 	if (ret < 0)
-		goto escdevreg;
+		goto eschdlinit;
 
 	soc_camera_device_init(&icd->dev, icl);
 
@@ -1417,6 +1360,8 @@ static int __devinit soc_camera_pdrv_probe(struct platform_device *pdev)
 
 	return 0;
 
+eschdlinit:
+	v4l2_ctrl_handler_free(&icd->ctrl_handler);
 escdevreg:
 	kfree(icd);
 
@@ -1437,6 +1382,7 @@ static int __devexit soc_camera_pdrv_remove(struct platform_device *pdev)
 
 	soc_camera_device_unregister(icd);
 
+	v4l2_ctrl_handler_free(&icd->ctrl_handler);
 	kfree(icd);
 
 	return 0;
diff --git a/drivers/media/video/soc_camera_platform.c b/drivers/media/video/soc_camera_platform.c
index bf406e8..e319dda 100644
--- a/drivers/media/video/soc_camera_platform.c
+++ b/drivers/media/video/soc_camera_platform.c
@@ -174,9 +174,13 @@ static int soc_camera_platform_probe(struct platform_device *pdev)
 	ret = v4l2_device_register_subdev(&ici->v4l2_dev, &priv->subdev);
 	if (ret)
 		goto evdrs;
+	ret = v4l2_ctrl_add_handler(&icd->ctrl_handler, priv->subdev.ctrl_handler);
+	if (ret)
+		goto evunreg;
+	return 0;
 
-	return ret;
-
+evunreg:
+	v4l2_device_unregister_subdev(&priv->subdev);
 evdrs:
 	icd->ops = NULL;
 	platform_set_drvdata(pdev, NULL);
diff --git a/include/media/soc_camera.h b/include/media/soc_camera.h
index 9386db8..ee61ffb 100644
--- a/include/media/soc_camera.h
+++ b/include/media/soc_camera.h
@@ -18,6 +18,7 @@
 #include <linux/videodev2.h>
 #include <media/videobuf-core.h>
 #include <media/v4l2-device.h>
+#include <media/v4l2-ctrls.h>
 
 extern struct bus_type soc_camera_bus_type;
 
@@ -35,6 +36,7 @@ struct soc_camera_device {
 	struct soc_camera_sense *sense;	/* See comment in struct definition */
 	struct soc_camera_ops *ops;
 	struct video_device *vdev;
+	struct v4l2_ctrl_handler ctrl_handler;
 	const struct soc_camera_format_xlate *current_fmt;
 	struct soc_camera_format_xlate *user_formats;
 	int num_user_formats;
-- 
1.7.0.4

