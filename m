Return-path: <mchehab@pedra>
Received: from moutng.kundenserver.de ([212.227.126.187]:58901 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752634Ab1A2R2Q (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 29 Jan 2011 12:28:16 -0500
Date: Sat, 29 Jan 2011 18:27:18 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>,
	Robert Jarzmik <robert.jarzmik@free.fr>,
	Baruch Siach <baruch@tkos.co.il>,
	Paulius Zaleckas <paulius.zaleckas@teltonika.lt>
Subject: [PATCH/RFC 2/3 v2] V4L: soc-camera: extend to also support videobuf2
In-Reply-To: <Pine.LNX.4.64.1101290151440.19247@axis700.grange>
Message-ID: <Pine.LNX.4.64.1101291825001.26696@axis700.grange>
References: <Pine.LNX.4.64.1101290113500.19247@axis700.grange>
 <Pine.LNX.4.64.1101290151440.19247@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Extend soc-camera core to also support the videobuf2 API.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---

v2: supporting both vb1 and vb2 in soc-camera turned out much easier, 
than I thought. With this patch we can convert all soc-camera host drivers 
one after another without breaking them.

 drivers/media/video/Kconfig      |    1 +
 drivers/media/video/soc_camera.c |   89 ++++++++++++++++++++++++++++++-------
 include/media/soc_camera.h       |   11 ++++-
 3 files changed, 83 insertions(+), 18 deletions(-)

diff --git a/drivers/media/video/Kconfig b/drivers/media/video/Kconfig
index ce3555a..f26aa3e 100644
--- a/drivers/media/video/Kconfig
+++ b/drivers/media/video/Kconfig
@@ -750,6 +750,7 @@ config SOC_CAMERA
 	tristate "SoC camera support"
 	depends on VIDEO_V4L2 && HAS_DMA && I2C
 	select VIDEOBUF_GEN
+	select VIDEOBUF2_CORE
 	help
 	  SoC Camera is a common API to several cameras, not connecting
 	  over a bus like PCI or USB. For example some i2c camera connected
diff --git a/drivers/media/video/soc_camera.c b/drivers/media/video/soc_camera.c
index a66811b..470ec16 100644
--- a/drivers/media/video/soc_camera.c
+++ b/drivers/media/video/soc_camera.c
@@ -34,6 +34,7 @@
 #include <media/v4l2-ioctl.h>
 #include <media/v4l2-dev.h>
 #include <media/videobuf-core.h>
+#include <media/videobuf2-core.h>
 #include <media/soc_mediabus.h>
 
 /* Default to VGA resolution */
@@ -203,11 +204,16 @@ static int soc_camera_reqbufs(struct file *file, void *priv,
 	if (icd->streamer && icd->streamer != file)
 		return -EBUSY;
 
-	ret = videobuf_reqbufs(&icd->vb_vidq, p);
-	if (ret < 0)
-		return ret;
+	if (ici->ops->init_videobuf) {
+		ret = videobuf_reqbufs(&icd->vb_vidq, p);
+		if (ret < 0)
+			return ret;
+
+		ret = ici->ops->reqbufs(icd, p);
+	} else {
+		ret = vb2_reqbufs(&icd->vb2_vidq, p);
+	}
 
-	ret = ici->ops->reqbufs(icd, p);
 	if (!ret && !icd->streamer)
 		icd->streamer = file;
 
@@ -218,36 +224,48 @@ static int soc_camera_querybuf(struct file *file, void *priv,
 			       struct v4l2_buffer *p)
 {
 	struct soc_camera_device *icd = file->private_data;
+	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
 
 	WARN_ON(priv != file->private_data);
 
-	return videobuf_querybuf(&icd->vb_vidq, p);
+	if (ici->ops->init_videobuf)
+		return videobuf_querybuf(&icd->vb_vidq, p);
+	else
+		return vb2_querybuf(&icd->vb2_vidq, p);
 }
 
 static int soc_camera_qbuf(struct file *file, void *priv,
 			   struct v4l2_buffer *p)
 {
 	struct soc_camera_device *icd = file->private_data;
+	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
 
 	WARN_ON(priv != file->private_data);
 
 	if (icd->streamer != file)
 		return -EBUSY;
 
-	return videobuf_qbuf(&icd->vb_vidq, p);
+	if (ici->ops->init_videobuf)
+		return videobuf_qbuf(&icd->vb_vidq, p);
+	else
+		return vb2_qbuf(&icd->vb2_vidq, p);
 }
 
 static int soc_camera_dqbuf(struct file *file, void *priv,
 			    struct v4l2_buffer *p)
 {
 	struct soc_camera_device *icd = file->private_data;
+	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
 
 	WARN_ON(priv != file->private_data);
 
 	if (icd->streamer != file)
 		return -EBUSY;
 
-	return videobuf_dqbuf(&icd->vb_vidq, p, file->f_flags & O_NONBLOCK);
+	if (ici->ops->init_videobuf)
+		return videobuf_dqbuf(&icd->vb_vidq, p, file->f_flags & O_NONBLOCK);
+	else
+		return vb2_dqbuf(&icd->vb2_vidq, p, file->f_flags & O_NONBLOCK);
 }
 
 /* Always entered with .video_lock held */
@@ -363,8 +381,9 @@ static int soc_camera_set_fmt(struct soc_camera_device *icd,
 	icd->user_width		= pix->width;
 	icd->user_height	= pix->height;
 	icd->colorspace		= pix->colorspace;
-	icd->vb_vidq.field	=
-		icd->field	= pix->field;
+	icd->field		= pix->field;
+	if (ici->ops->init_videobuf)
+		icd->vb_vidq.field = pix->field;
 
 	if (f->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
 		dev_warn(&icd->dev, "Attention! Wrong buf-type %d\n",
@@ -444,7 +463,13 @@ static int soc_camera_open(struct file *file)
 		if (ret < 0)
 			goto esfmt;
 
-		ici->ops->init_videobuf(&icd->vb_vidq, icd);
+		if (ici->ops->init_videobuf) {
+			ici->ops->init_videobuf(&icd->vb_vidq, icd);
+		} else {
+			ret = ici->ops->init_videobuf2(&icd->vb2_vidq, icd);
+			if (ret < 0)
+				goto einitvb;
+		}
 	}
 
 	file->private_data = icd;
@@ -456,6 +481,7 @@ static int soc_camera_open(struct file *file)
 	 * First four errors are entered with the .video_lock held
 	 * and use_count == 1
 	 */
+einitvb:
 esfmt:
 	pm_runtime_disable(&icd->vdev->dev);
 eresume:
@@ -482,6 +508,8 @@ static int soc_camera_close(struct file *file)
 		pm_runtime_disable(&icd->vdev->dev);
 
 		ici->ops->remove(icd);
+		if (ici->ops->init_videobuf2)
+			vb2_queue_release(&icd->vb2_vidq);
 
 		soc_camera_power_set(icd, icl, 0);
 	}
@@ -510,6 +538,7 @@ static ssize_t soc_camera_read(struct file *file, char __user *buf,
 static int soc_camera_mmap(struct file *file, struct vm_area_struct *vma)
 {
 	struct soc_camera_device *icd = file->private_data;
+	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
 	int err;
 
 	dev_dbg(&icd->dev, "mmap called, vma=0x%08lx\n", (unsigned long)vma);
@@ -517,7 +546,10 @@ static int soc_camera_mmap(struct file *file, struct vm_area_struct *vma)
 	if (icd->streamer != file)
 		return -EBUSY;
 
-	err = videobuf_mmap_mapper(&icd->vb_vidq, vma);
+	if (ici->ops->init_videobuf)
+		err = videobuf_mmap_mapper(&icd->vb_vidq, vma);
+	else
+		err = vb2_mmap(&icd->vb2_vidq, vma);
 
 	dev_dbg(&icd->dev, "vma start=0x%08lx, size=%ld, ret=%d\n",
 		(unsigned long)vma->vm_start,
@@ -535,7 +567,7 @@ static unsigned int soc_camera_poll(struct file *file, poll_table *pt)
 	if (icd->streamer != file)
 		return -EBUSY;
 
-	if (list_empty(&icd->vb_vidq.stream)) {
+	if (ici->ops->init_videobuf && list_empty(&icd->vb_vidq.stream)) {
 		dev_err(&icd->dev, "Trying to poll with no queued buffers!\n");
 		return POLLERR;
 	}
@@ -543,6 +575,20 @@ static unsigned int soc_camera_poll(struct file *file, poll_table *pt)
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
@@ -606,7 +652,7 @@ static int soc_camera_g_fmt_vid_cap(struct file *file, void *priv,
 
 	pix->width		= icd->user_width;
 	pix->height		= icd->user_height;
-	pix->field		= icd->vb_vidq.field;
+	pix->field		= icd->field;
 	pix->pixelformat	= icd->current_fmt->host_fmt->fourcc;
 	pix->bytesperline	= soc_mbus_bytes_per_line(pix->width,
 						icd->current_fmt->host_fmt);
@@ -635,6 +681,7 @@ static int soc_camera_streamon(struct file *file, void *priv,
 			       enum v4l2_buf_type i)
 {
 	struct soc_camera_device *icd = file->private_data;
+	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
 	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
 	int ret;
 
@@ -649,7 +696,10 @@ static int soc_camera_streamon(struct file *file, void *priv,
 	v4l2_subdev_call(sd, video, s_stream, 1);
 
 	/* This calls buf_queue from host driver's videobuf_queue_ops */
-	ret = videobuf_streamon(&icd->vb_vidq);
+	if (ici->ops->init_videobuf)
+		ret = videobuf_streamon(&icd->vb_vidq);
+	else
+		ret = vb2_streamon(&icd->vb2_vidq, i);
 
 	return ret;
 }
@@ -659,6 +709,7 @@ static int soc_camera_streamoff(struct file *file, void *priv,
 {
 	struct soc_camera_device *icd = file->private_data;
 	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
+	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
 
 	WARN_ON(priv != file->private_data);
 
@@ -672,7 +723,10 @@ static int soc_camera_streamoff(struct file *file, void *priv,
 	 * This calls buf_release from host driver's videobuf_queue_ops for all
 	 * remaining buffers. When the last buffer is freed, stop capture
 	 */
-	videobuf_streamoff(&icd->vb_vidq);
+	if (ici->ops->init_videobuf)
+		videobuf_streamoff(&icd->vb_vidq);
+	else
+		vb2_streamoff(&icd->vb2_vidq, i);
 
 	v4l2_subdev_call(sd, video, s_stream, 0);
 
@@ -1192,8 +1246,9 @@ int soc_camera_host_register(struct soc_camera_host *ici)
 	    !ici->ops->set_fmt ||
 	    !ici->ops->set_bus_param ||
 	    !ici->ops->querycap ||
-	    !ici->ops->init_videobuf ||
-	    !ici->ops->reqbufs ||
+	    ((!ici->ops->init_videobuf ||
+	      !ici->ops->reqbufs) &&
+	     !ici->ops->init_videobuf2) ||
 	    !ici->ops->add ||
 	    !ici->ops->remove ||
 	    !ici->ops->poll ||
diff --git a/include/media/soc_camera.h b/include/media/soc_camera.h
index 9386db8..9f10921 100644
--- a/include/media/soc_camera.h
+++ b/include/media/soc_camera.h
@@ -17,6 +17,7 @@
 #include <linux/pm.h>
 #include <linux/videodev2.h>
 #include <media/videobuf-core.h>
+#include <media/videobuf2-core.h>
 #include <media/v4l2-device.h>
 
 extern struct bus_type soc_camera_bus_type;
@@ -44,7 +45,10 @@ struct soc_camera_device {
 	int use_count;
 	struct mutex video_lock;	/* Protects device data */
 	struct file *streamer;		/* stream owner */
-	struct videobuf_queue vb_vidq;
+	union {
+		struct videobuf_queue vb_vidq;
+		struct vb2_queue vb2_vidq;
+	};
 };
 
 struct soc_camera_host {
@@ -78,6 +82,8 @@ struct soc_camera_host_ops {
 	int (*try_fmt)(struct soc_camera_device *, struct v4l2_format *);
 	void (*init_videobuf)(struct videobuf_queue *,
 			      struct soc_camera_device *);
+	int (*init_videobuf2)(struct vb2_queue *,
+			      struct soc_camera_device *);
 	int (*reqbufs)(struct soc_camera_device *, struct v4l2_requestbuffers *);
 	int (*querycap)(struct soc_camera_host *, struct v4l2_capability *);
 	int (*set_bus_param)(struct soc_camera_device *, __u32);
@@ -299,4 +305,7 @@ static inline struct video_device *soc_camera_i2c_to_vdev(struct i2c_client *cli
 	return icd->vdev;
 }
 
+void soc_camera_lock(struct vb2_queue *vq);
+void soc_camera_unlock(struct vb2_queue *vq);
+
 #endif
-- 
1.7.2.3

