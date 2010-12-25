Return-path: <mchehab@gaivota>
Received: from moutng.kundenserver.de ([212.227.126.171]:49757 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751103Ab0LYVq1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 25 Dec 2010 16:46:27 -0500
Date: Sat, 25 Dec 2010 22:46:25 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
cc: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH] v4l: soc-camera: switch to .unlocked_ioctl
Message-ID: <Pine.LNX.4.64.1012252245070.5248@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Use the V4L mutex infrastructure in soc-camera core and drivers and switch to
.unlocked_ioctl.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 drivers/media/video/mx1_camera.c           |    7 ++--
 drivers/media/video/mx2_camera.c           |    3 +-
 drivers/media/video/mx3_camera.c           |    2 +-
 drivers/media/video/omap1_camera.c         |    4 +-
 drivers/media/video/pxa_camera.c           |    2 +-
 drivers/media/video/sh_mobile_ceu_camera.c |    2 +-
 drivers/media/video/soc_camera.c           |   47 +++++----------------------
 7 files changed, 19 insertions(+), 48 deletions(-)

diff --git a/drivers/media/video/mx1_camera.c b/drivers/media/video/mx1_camera.c
index 5e486a8..bc0c23a 100644
--- a/drivers/media/video/mx1_camera.c
+++ b/drivers/media/video/mx1_camera.c
@@ -382,10 +382,9 @@ static void mx1_camera_init_videobuf(struct videobuf_queue *q,
 	struct mx1_camera_dev *pcdev = ici->priv;
 
 	videobuf_queue_dma_contig_init(q, &mx1_videobuf_ops, icd->dev.parent,
-					&pcdev->lock,
-					V4L2_BUF_TYPE_VIDEO_CAPTURE,
-					V4L2_FIELD_NONE,
-					sizeof(struct mx1_buffer), icd, NULL);
+				&pcdev->lock, V4L2_BUF_TYPE_VIDEO_CAPTURE,
+				V4L2_FIELD_NONE,
+				sizeof(struct mx1_buffer), icd, &icd->video_lock);
 }
 
 static int mclk_get_divisor(struct mx1_camera_dev *pcdev)
diff --git a/drivers/media/video/mx2_camera.c b/drivers/media/video/mx2_camera.c
index 13565cb..4eab1c6 100644
--- a/drivers/media/video/mx2_camera.c
+++ b/drivers/media/video/mx2_camera.c
@@ -683,7 +683,8 @@ static void mx2_camera_init_videobuf(struct videobuf_queue *q,
 
 	videobuf_queue_dma_contig_init(q, &mx2_videobuf_ops, pcdev->dev,
 			&pcdev->lock, V4L2_BUF_TYPE_VIDEO_CAPTURE,
-			V4L2_FIELD_NONE, sizeof(struct mx2_buffer), icd, NULL);
+			V4L2_FIELD_NONE, sizeof(struct mx2_buffer),
+			icd, &icd->video_lock);
 }
 
 #define MX2_BUS_FLAGS	(SOCAM_DATAWIDTH_8 | \
diff --git a/drivers/media/video/mx3_camera.c b/drivers/media/video/mx3_camera.c
index 330d42e..b9cb4a4 100644
--- a/drivers/media/video/mx3_camera.c
+++ b/drivers/media/video/mx3_camera.c
@@ -443,7 +443,7 @@ static void mx3_camera_init_videobuf(struct videobuf_queue *q,
 				       V4L2_BUF_TYPE_VIDEO_CAPTURE,
 				       V4L2_FIELD_NONE,
 				       sizeof(struct mx3_camera_buffer), icd,
-				       NULL);
+				       &icd->video_lock);
 }
 
 /* First part of ipu_csi_init_interface() */
diff --git a/drivers/media/video/omap1_camera.c b/drivers/media/video/omap1_camera.c
index cbfd07f..0a2fb2b 100644
--- a/drivers/media/video/omap1_camera.c
+++ b/drivers/media/video/omap1_camera.c
@@ -1365,12 +1365,12 @@ static void omap1_cam_init_videobuf(struct videobuf_queue *q,
 		videobuf_queue_dma_contig_init(q, &omap1_videobuf_ops,
 				icd->dev.parent, &pcdev->lock,
 				V4L2_BUF_TYPE_VIDEO_CAPTURE, V4L2_FIELD_NONE,
-				sizeof(struct omap1_cam_buf), icd, NULL);
+				sizeof(struct omap1_cam_buf), icd, &icd->video_lock);
 	else
 		videobuf_queue_sg_init(q, &omap1_videobuf_ops,
 				icd->dev.parent, &pcdev->lock,
 				V4L2_BUF_TYPE_VIDEO_CAPTURE, V4L2_FIELD_NONE,
-				sizeof(struct omap1_cam_buf), icd, NULL);
+				sizeof(struct omap1_cam_buf), icd, &icd->video_lock);
 
 	/* use videobuf mode (auto)selected with the module parameter */
 	pcdev->vb_mode = sg_mode ? OMAP1_CAM_DMA_SG : OMAP1_CAM_DMA_CONTIG;
diff --git a/drivers/media/video/pxa_camera.c b/drivers/media/video/pxa_camera.c
index c143ed0..0268677 100644
--- a/drivers/media/video/pxa_camera.c
+++ b/drivers/media/video/pxa_camera.c
@@ -852,7 +852,7 @@ static void pxa_camera_init_videobuf(struct videobuf_queue *q,
 	 */
 	videobuf_queue_sg_init(q, &pxa_videobuf_ops, NULL, &pcdev->lock,
 				V4L2_BUF_TYPE_VIDEO_CAPTURE, V4L2_FIELD_NONE,
-				sizeof(struct pxa_buffer), icd, NULL);
+				sizeof(struct pxa_buffer), icd, &icd->video_lock);
 }
 
 static u32 mclk_get_divisor(struct platform_device *pdev,
diff --git a/drivers/media/video/sh_mobile_ceu_camera.c b/drivers/media/video/sh_mobile_ceu_camera.c
index 5c209af..e826923 100644
--- a/drivers/media/video/sh_mobile_ceu_camera.c
+++ b/drivers/media/video/sh_mobile_ceu_camera.c
@@ -1786,7 +1786,7 @@ static void sh_mobile_ceu_init_videobuf(struct videobuf_queue *q,
 				       V4L2_BUF_TYPE_VIDEO_CAPTURE,
 				       pcdev->field,
 				       sizeof(struct sh_mobile_ceu_buffer),
-				       icd, NULL);
+				       icd, &icd->video_lock);
 }
 
 static int sh_mobile_ceu_get_ctrl(struct soc_camera_device *icd,
diff --git a/drivers/media/video/soc_camera.c b/drivers/media/video/soc_camera.c
index 052bd6d..e3927b5 100644
--- a/drivers/media/video/soc_camera.c
+++ b/drivers/media/video/soc_camera.c
@@ -352,12 +352,6 @@ static int soc_camera_open(struct file *file)
 		return -EINVAL;
 	}
 
-	/*
-	 * Protect against icd->ops->remove() until we module_get() both
-	 * drivers.
-	 */
-	mutex_lock(&icd->video_lock);
-
 	icd->use_count++;
 
 	/* Now we really have to activate the camera */
@@ -412,8 +406,6 @@ static int soc_camera_open(struct file *file)
 	file->private_data = icd;
 	dev_dbg(&icd->dev, "camera device open\n");
 
-	mutex_unlock(&icd->video_lock);
-
 	return 0;
 
 	/*
@@ -429,7 +421,6 @@ eiciadd:
 		icl->power(icd->pdev, 0);
 epower:
 	icd->use_count--;
-	mutex_unlock(&icd->video_lock);
 	module_put(ici->ops->owner);
 
 	return ret;
@@ -440,7 +431,6 @@ static int soc_camera_close(struct file *file)
 	struct soc_camera_device *icd = file->private_data;
 	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
 
-	mutex_lock(&icd->video_lock);
 	icd->use_count--;
 	if (!icd->use_count) {
 		struct soc_camera_link *icl = to_soc_camera_link(icd);
@@ -457,8 +447,6 @@ static int soc_camera_close(struct file *file)
 	if (icd->streamer == file)
 		icd->streamer = NULL;
 
-	mutex_unlock(&icd->video_lock);
-
 	module_put(ici->ops->owner);
 
 	dev_dbg(&icd->dev, "camera device close\n");
@@ -517,7 +505,7 @@ static struct v4l2_file_operations soc_camera_fops = {
 	.owner		= THIS_MODULE,
 	.open		= soc_camera_open,
 	.release	= soc_camera_close,
-	.ioctl		= video_ioctl2,
+	.unlocked_ioctl	= video_ioctl2,
 	.read		= soc_camera_read,
 	.mmap		= soc_camera_mmap,
 	.poll		= soc_camera_poll,
@@ -534,12 +522,9 @@ static int soc_camera_s_fmt_vid_cap(struct file *file, void *priv,
 	if (icd->streamer && icd->streamer != file)
 		return -EBUSY;
 
-	mutex_lock(&icd->vb_vidq.vb_lock);
-
 	if (icd->vb_vidq.bufs[0]) {
 		dev_err(&icd->dev, "S_FMT denied: queue initialised\n");
-		ret = -EBUSY;
-		goto unlock;
+		return -EBUSY;
 	}
 
 	ret = soc_camera_set_fmt(icd, f);
@@ -547,9 +532,6 @@ static int soc_camera_s_fmt_vid_cap(struct file *file, void *priv,
 	if (!ret && !icd->streamer)
 		icd->streamer = file;
 
-unlock:
-	mutex_unlock(&icd->vb_vidq.vb_lock);
-
 	return ret;
 }
 
@@ -622,15 +604,11 @@ static int soc_camera_streamon(struct file *file, void *priv,
 	if (icd->streamer != file)
 		return -EBUSY;
 
-	mutex_lock(&icd->video_lock);
-
 	v4l2_subdev_call(sd, video, s_stream, 1);
 
 	/* This calls buf_queue from host driver's videobuf_queue_ops */
 	ret = videobuf_streamon(&icd->vb_vidq);
 
-	mutex_unlock(&icd->video_lock);
-
 	return ret;
 }
 
@@ -648,8 +626,6 @@ static int soc_camera_streamoff(struct file *file, void *priv,
 	if (icd->streamer != file)
 		return -EBUSY;
 
-	mutex_lock(&icd->video_lock);
-
 	/*
 	 * This calls buf_release from host driver's videobuf_queue_ops for all
 	 * remaining buffers. When the last buffer is freed, stop capture
@@ -658,8 +634,6 @@ static int soc_camera_streamoff(struct file *file, void *priv,
 
 	v4l2_subdev_call(sd, video, s_stream, 0);
 
-	mutex_unlock(&icd->video_lock);
-
 	return 0;
 }
 
@@ -748,9 +722,7 @@ static int soc_camera_g_crop(struct file *file, void *fh,
 	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
 	int ret;
 
-	mutex_lock(&icd->vb_vidq.vb_lock);
 	ret = ici->ops->get_crop(icd, a);
-	mutex_unlock(&icd->vb_vidq.vb_lock);
 
 	return ret;
 }
@@ -775,9 +747,6 @@ static int soc_camera_s_crop(struct file *file, void *fh,
 	dev_dbg(&icd->dev, "S_CROP(%ux%u@%u:%u)\n",
 		rect->width, rect->height, rect->left, rect->top);
 
-	/* Cropping is allowed during a running capture, guard consistency */
-	mutex_lock(&icd->vb_vidq.vb_lock);
-
 	/* If get_crop fails, we'll let host and / or client drivers decide */
 	ret = ici->ops->get_crop(icd, &current_crop);
 
@@ -795,8 +764,6 @@ static int soc_camera_s_crop(struct file *file, void *fh,
 		ret = ici->ops->set_crop(icd, a);
 	}
 
-	mutex_unlock(&icd->vb_vidq.vb_lock);
-
 	return ret;
 }
 
@@ -998,7 +965,13 @@ static int soc_camera_probe(struct device *dev)
 
 	icd->field = V4L2_FIELD_ANY;
 
-	/* ..._video_start() will create a device node, so we have to protect */
+	icd->vdev->lock = &icd->video_lock;
+
+	/*
+	 * ..._video_start() will create a device node, video_register_device()
+	 * itself is protected against concurrent open() calls, but we also have
+	 * to protect our data.
+	 */
 	mutex_lock(&icd->video_lock);
 
 	ret = soc_camera_video_start(icd);
@@ -1063,10 +1036,8 @@ static int soc_camera_remove(struct device *dev)
 	BUG_ON(!dev->parent);
 
 	if (vdev) {
-		mutex_lock(&icd->video_lock);
 		video_unregister_device(vdev);
 		icd->vdev = NULL;
-		mutex_unlock(&icd->video_lock);
 	}
 
 	if (icl->board_info) {
-- 
1.7.2.3

