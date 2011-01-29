Return-path: <mchehab@pedra>
Received: from moutng.kundenserver.de ([212.227.126.187]:63992 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751393Ab1A2AyG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 28 Jan 2011 19:54:06 -0500
Date: Sat, 29 Jan 2011 01:54:03 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>,
	Robert Jarzmik <robert.jarzmik@free.fr>,
	Baruch Siach <baruch@tkos.co.il>,
	Paulius Zaleckas <paulius.zaleckas@teltonika.lt>
Subject: [PATCH/RFC 2/3] V4L: soc-camera: convert to videobuf2
In-Reply-To: <Pine.LNX.4.64.1101290113500.19247@axis700.grange>
Message-ID: <Pine.LNX.4.64.1101290151440.19247@axis700.grange>
References: <Pine.LNX.4.64.1101290113500.19247@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Convert soc-camera core to the videobuf2 API.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 drivers/media/video/Kconfig      |    2 +-
 drivers/media/video/soc_camera.c |   53 +++++++++++++++++++++----------------
 include/media/soc_camera.h       |   10 ++++---
 3 files changed, 37 insertions(+), 28 deletions(-)

diff --git a/drivers/media/video/Kconfig b/drivers/media/video/Kconfig
index ce3555a..15515d9 100644
--- a/drivers/media/video/Kconfig
+++ b/drivers/media/video/Kconfig
@@ -749,7 +749,7 @@ config VIDEO_NOON010PC30
 config SOC_CAMERA
 	tristate "SoC camera support"
 	depends on VIDEO_V4L2 && HAS_DMA && I2C
-	select VIDEOBUF_GEN
+	select VIDEOBUF2_CORE
 	help
 	  SoC Camera is a common API to several cameras, not connecting
 	  over a bus like PCI or USB. For example some i2c camera connected
diff --git a/drivers/media/video/soc_camera.c b/drivers/media/video/soc_camera.c
index a66811b..c451493 100644
--- a/drivers/media/video/soc_camera.c
+++ b/drivers/media/video/soc_camera.c
@@ -33,7 +33,7 @@
 #include <media/v4l2-common.h>
 #include <media/v4l2-ioctl.h>
 #include <media/v4l2-dev.h>
-#include <media/videobuf-core.h>
+#include <media/videobuf2-core.h>
 #include <media/soc_mediabus.h>
 
 /* Default to VGA resolution */
@@ -196,18 +196,13 @@ static int soc_camera_reqbufs(struct file *file, void *priv,
 {
 	int ret;
 	struct soc_camera_device *icd = file->private_data;
-	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
 
 	WARN_ON(priv != file->private_data);
 
 	if (icd->streamer && icd->streamer != file)
 		return -EBUSY;
 
-	ret = videobuf_reqbufs(&icd->vb_vidq, p);
-	if (ret < 0)
-		return ret;
-
-	ret = ici->ops->reqbufs(icd, p);
+	ret = vb2_reqbufs(&icd->vb_vidq, p);
 	if (!ret && !icd->streamer)
 		icd->streamer = file;
 
@@ -221,7 +216,7 @@ static int soc_camera_querybuf(struct file *file, void *priv,
 
 	WARN_ON(priv != file->private_data);
 
-	return videobuf_querybuf(&icd->vb_vidq, p);
+	return vb2_querybuf(&icd->vb_vidq, p);
 }
 
 static int soc_camera_qbuf(struct file *file, void *priv,
@@ -234,7 +229,7 @@ static int soc_camera_qbuf(struct file *file, void *priv,
 	if (icd->streamer != file)
 		return -EBUSY;
 
-	return videobuf_qbuf(&icd->vb_vidq, p);
+	return vb2_qbuf(&icd->vb_vidq, p);
 }
 
 static int soc_camera_dqbuf(struct file *file, void *priv,
@@ -247,7 +242,7 @@ static int soc_camera_dqbuf(struct file *file, void *priv,
 	if (icd->streamer != file)
 		return -EBUSY;
 
-	return videobuf_dqbuf(&icd->vb_vidq, p, file->f_flags & O_NONBLOCK);
+	return vb2_dqbuf(&icd->vb_vidq, p, file->f_flags & O_NONBLOCK);
 }
 
 /* Always entered with .video_lock held */
@@ -363,8 +358,8 @@ static int soc_camera_set_fmt(struct soc_camera_device *icd,
 	icd->user_width		= pix->width;
 	icd->user_height	= pix->height;
 	icd->colorspace		= pix->colorspace;
-	icd->vb_vidq.field	=
-		icd->field	= pix->field;
+//	icd->vb_vidq.field	=
+	icd->field	= pix->field;
 
 	if (f->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
 		dev_warn(&icd->dev, "Attention! Wrong buf-type %d\n",
@@ -444,7 +439,9 @@ static int soc_camera_open(struct file *file)
 		if (ret < 0)
 			goto esfmt;
 
-		ici->ops->init_videobuf(&icd->vb_vidq, icd);
+		ret = ici->ops->init_videobuf(&icd->vb_vidq, icd);
+		if (ret < 0)
+			goto einitvb;
 	}
 
 	file->private_data = icd;
@@ -456,6 +453,7 @@ static int soc_camera_open(struct file *file)
 	 * First four errors are entered with the .video_lock held
 	 * and use_count == 1
 	 */
+einitvb:
 esfmt:
 	pm_runtime_disable(&icd->vdev->dev);
 eresume:
@@ -482,6 +480,7 @@ static int soc_camera_close(struct file *file)
 		pm_runtime_disable(&icd->vdev->dev);
 
 		ici->ops->remove(icd);
+		vb2_queue_release(&icd->vb_vidq);
 
 		soc_camera_power_set(icd, icl, 0);
 	}
@@ -517,7 +516,7 @@ static int soc_camera_mmap(struct file *file, struct vm_area_struct *vma)
 	if (icd->streamer != file)
 		return -EBUSY;
 
-	err = videobuf_mmap_mapper(&icd->vb_vidq, vma);
+	err = vb2_mmap(&icd->vb_vidq, vma);
 
 	dev_dbg(&icd->dev, "vma start=0x%08lx, size=%ld, ret=%d\n",
 		(unsigned long)vma->vm_start,
@@ -535,14 +534,23 @@ static unsigned int soc_camera_poll(struct file *file, poll_table *pt)
 	if (icd->streamer != file)
 		return -EBUSY;
 
-	if (list_empty(&icd->vb_vidq.stream)) {
-		dev_err(&icd->dev, "Trying to poll with no queued buffers!\n");
-		return POLLERR;
-	}
-
 	return ici->ops->poll(file, pt);
 }
 
+void soc_camera_lock(struct vb2_queue *vq)
+{
+	struct soc_camera_device *icd = vb2_get_drv_priv(vq);
+	mutex_lock(&icd->video_lock);
+}
+EXPORT_SYMBOL(soc_camera_lock);
+
+void soc_camera_unlock(struct vb2_queue *vq)
+{
+	struct soc_camera_device *icd = vb2_get_drv_priv(vq);
+	mutex_unlock(&icd->video_lock);
+}
+EXPORT_SYMBOL(soc_camera_unlock);
+
 static struct v4l2_file_operations soc_camera_fops = {
 	.owner		= THIS_MODULE,
 	.open		= soc_camera_open,
@@ -606,7 +614,7 @@ static int soc_camera_g_fmt_vid_cap(struct file *file, void *priv,
 
 	pix->width		= icd->user_width;
 	pix->height		= icd->user_height;
-	pix->field		= icd->vb_vidq.field;
+	pix->field		= icd->field;
 	pix->pixelformat	= icd->current_fmt->host_fmt->fourcc;
 	pix->bytesperline	= soc_mbus_bytes_per_line(pix->width,
 						icd->current_fmt->host_fmt);
@@ -649,7 +657,7 @@ static int soc_camera_streamon(struct file *file, void *priv,
 	v4l2_subdev_call(sd, video, s_stream, 1);
 
 	/* This calls buf_queue from host driver's videobuf_queue_ops */
-	ret = videobuf_streamon(&icd->vb_vidq);
+	ret = vb2_streamon(&icd->vb_vidq, i);
 
 	return ret;
 }
@@ -672,7 +680,7 @@ static int soc_camera_streamoff(struct file *file, void *priv,
 	 * This calls buf_release from host driver's videobuf_queue_ops for all
 	 * remaining buffers. When the last buffer is freed, stop capture
 	 */
-	videobuf_streamoff(&icd->vb_vidq);
+	vb2_streamoff(&icd->vb_vidq, i);
 
 	v4l2_subdev_call(sd, video, s_stream, 0);
 
@@ -1193,7 +1201,6 @@ int soc_camera_host_register(struct soc_camera_host *ici)
 	    !ici->ops->set_bus_param ||
 	    !ici->ops->querycap ||
 	    !ici->ops->init_videobuf ||
-	    !ici->ops->reqbufs ||
 	    !ici->ops->add ||
 	    !ici->ops->remove ||
 	    !ici->ops->poll ||
diff --git a/include/media/soc_camera.h b/include/media/soc_camera.h
index 9386db8..ffc0e7a 100644
--- a/include/media/soc_camera.h
+++ b/include/media/soc_camera.h
@@ -16,7 +16,7 @@
 #include <linux/mutex.h>
 #include <linux/pm.h>
 #include <linux/videodev2.h>
-#include <media/videobuf-core.h>
+#include <media/videobuf2-core.h>
 #include <media/v4l2-device.h>
 
 extern struct bus_type soc_camera_bus_type;
@@ -44,7 +44,7 @@ struct soc_camera_device {
 	int use_count;
 	struct mutex video_lock;	/* Protects device data */
 	struct file *streamer;		/* stream owner */
-	struct videobuf_queue vb_vidq;
+	struct vb2_queue vb_vidq;
 };
 
 struct soc_camera_host {
@@ -76,9 +76,8 @@ struct soc_camera_host_ops {
 	int (*set_crop)(struct soc_camera_device *, struct v4l2_crop *);
 	int (*set_fmt)(struct soc_camera_device *, struct v4l2_format *);
 	int (*try_fmt)(struct soc_camera_device *, struct v4l2_format *);
-	void (*init_videobuf)(struct videobuf_queue *,
+	int (*init_videobuf)(struct vb2_queue *,
 			      struct soc_camera_device *);
-	int (*reqbufs)(struct soc_camera_device *, struct v4l2_requestbuffers *);
 	int (*querycap)(struct soc_camera_host *, struct v4l2_capability *);
 	int (*set_bus_param)(struct soc_camera_device *, __u32);
 	int (*get_ctrl)(struct soc_camera_device *, struct v4l2_control *);
@@ -299,4 +298,7 @@ static inline struct video_device *soc_camera_i2c_to_vdev(struct i2c_client *cli
 	return icd->vdev;
 }
 
+void soc_camera_lock(struct vb2_queue *vq);
+void soc_camera_unlock(struct vb2_queue *vq);
+
 #endif
-- 
1.7.2.3

