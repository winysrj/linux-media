Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mBHIiwqY024073
	for <video4linux-list@redhat.com>; Wed, 17 Dec 2008 13:44:59 -0500
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id mBHIiXgU013249
	for <video4linux-list@redhat.com>; Wed, 17 Dec 2008 13:44:34 -0500
Received: from lyakh (helo=localhost)
	by axis700.grange with local-esmtp (Exim 4.63)
	(envelope-from <g.liakhovetski@gmx.de>) id 1LD1O2-0002M7-Aa
	for video4linux-list@redhat.com; Wed, 17 Dec 2008 19:44:46 +0100
Date: Wed, 17 Dec 2008 19:44:46 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: video4linux-list@redhat.com
Message-ID: <Pine.LNX.4.64.0812171937560.8733@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Subject: [PATCH 2/4] soc-camera: unify locking, play nicer with videobuf
 locking
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

Move mutex from host drivers to camera device object, take into account
videobuf locking.

Signed-off-by: Guennadi Liakhovetski <lg@denx.de>
---
 drivers/media/video/pxa_camera.c           |   15 ++---
 drivers/media/video/sh_mobile_ceu_camera.c |    9 +--
 drivers/media/video/soc_camera.c           |   99 +++++++++++++++++++++++-----
 include/media/soc_camera.h                 |    8 ++-
 4 files changed, 96 insertions(+), 35 deletions(-)

diff --git a/drivers/media/video/pxa_camera.c b/drivers/media/video/pxa_camera.c
index 56f972f..84f0e57 100644
--- a/drivers/media/video/pxa_camera.c
+++ b/drivers/media/video/pxa_camera.c
@@ -25,7 +25,6 @@
 #include <linux/version.h>
 #include <linux/device.h>
 #include <linux/platform_device.h>
-#include <linux/mutex.h>
 #include <linux/clk.h>
 
 #include <media/v4l2-common.h>
@@ -164,8 +163,6 @@
 			CICR0_PERRM | CICR0_QDM | CICR0_CDM | CICR0_SOFM | \
 			CICR0_EOFM | CICR0_FOM)
 
-static DEFINE_MUTEX(camera_lock);
-
 /*
  * Structures
  */
@@ -813,16 +810,17 @@ static irqreturn_t pxa_camera_irq(int irq, void *data)
 	return IRQ_HANDLED;
 }
 
-/* The following two functions absolutely depend on the fact, that
- * there can be only one camera on PXA quick capture interface */
+/*
+ * The following two functions absolutely depend on the fact, that
+ * there can be only one camera on PXA quick capture interface
+ * Called with .video_lock held
+ */
 static int pxa_camera_add_device(struct soc_camera_device *icd)
 {
 	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
 	struct pxa_camera_dev *pcdev = ici->priv;
 	int ret;
 
-	mutex_lock(&camera_lock);
-
 	if (pcdev->icd) {
 		ret = -EBUSY;
 		goto ebusy;
@@ -838,11 +836,10 @@ static int pxa_camera_add_device(struct soc_camera_device *icd)
 		pcdev->icd = icd;
 
 ebusy:
-	mutex_unlock(&camera_lock);
-
 	return ret;
 }
 
+/* Called with .video_lock held */
 static void pxa_camera_remove_device(struct soc_camera_device *icd)
 {
 	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
diff --git a/drivers/media/video/sh_mobile_ceu_camera.c b/drivers/media/video/sh_mobile_ceu_camera.c
index 3d35499..575c7ea 100644
--- a/drivers/media/video/sh_mobile_ceu_camera.c
+++ b/drivers/media/video/sh_mobile_ceu_camera.c
@@ -29,7 +29,6 @@
 #include <linux/version.h>
 #include <linux/device.h>
 #include <linux/platform_device.h>
-#include <linux/mutex.h>
 #include <linux/videodev2.h>
 #include <linux/clk.h>
 
@@ -75,8 +74,6 @@
 #define CDBYR2 0x98 /* Capture data bottom-field address Y register 2 */
 #define CDBCR2 0x9c /* Capture data bottom-field address C register 2 */
 
-static DEFINE_MUTEX(camera_lock);
-
 /* per video frame buffer */
 struct sh_mobile_ceu_buffer {
 	struct videobuf_buffer vb; /* v4l buffer must be first */
@@ -292,14 +289,13 @@ static irqreturn_t sh_mobile_ceu_irq(int irq, void *data)
 	return IRQ_HANDLED;
 }
 
+/* Called with .video_lock held */
 static int sh_mobile_ceu_add_device(struct soc_camera_device *icd)
 {
 	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
 	struct sh_mobile_ceu_dev *pcdev = ici->priv;
 	int ret = -EBUSY;
 
-	mutex_lock(&camera_lock);
-
 	if (pcdev->icd)
 		goto err;
 
@@ -319,11 +315,10 @@ static int sh_mobile_ceu_add_device(struct soc_camera_device *icd)
 
 	pcdev->icd = icd;
 err:
-	mutex_unlock(&camera_lock);
-
 	return ret;
 }
 
+/* Called with .video_lock held */
 static void sh_mobile_ceu_remove_device(struct soc_camera_device *icd)
 {
 	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
diff --git a/drivers/media/video/soc_camera.c b/drivers/media/video/soc_camera.c
index 4722bc8..0fbb238 100644
--- a/drivers/media/video/soc_camera.c
+++ b/drivers/media/video/soc_camera.c
@@ -33,7 +33,6 @@
 static LIST_HEAD(hosts);
 static LIST_HEAD(devices);
 static DEFINE_MUTEX(list_lock);
-static DEFINE_MUTEX(video_lock);
 
 const struct soc_camera_data_format *soc_camera_format_by_fourcc(
 	struct soc_camera_device *icd, unsigned int fourcc)
@@ -236,8 +235,10 @@ static int soc_camera_open(struct inode *inode, struct file *file)
 	if (!icf)
 		return -ENOMEM;
 
-	/* Protect against icd->remove() until we module_get() both drivers. */
-	mutex_lock(&video_lock);
+	/*
+	 * It is safe to dereference these pointers now as long as a user has
+	 * the video device open - we are protected by the held cdev reference.
+	 */
 
 	vdev = video_devdata(file);
 	icd = container_of(vdev->parent, struct soc_camera_device, dev);
@@ -255,6 +256,9 @@ static int soc_camera_open(struct inode *inode, struct file *file)
 		goto emgi;
 	}
 
+	/* Protect against icd->remove() until we module_get() both drivers. */
+	mutex_lock(&icd->video_lock);
+
 	icf->icd = icd;
 	icd->use_count++;
 
@@ -270,7 +274,7 @@ static int soc_camera_open(struct inode *inode, struct file *file)
 		}
 	}
 
-	mutex_unlock(&video_lock);
+	mutex_unlock(&icd->video_lock);
 
 	file->private_data = icf;
 	dev_dbg(&icd->dev, "camera device open\n");
@@ -279,16 +283,16 @@ static int soc_camera_open(struct inode *inode, struct file *file)
 
 	return 0;
 
-	/* All errors are entered with the video_lock held */
+	/* First two errors are entered with the .video_lock held */
 eiciadd:
 	soc_camera_free_user_formats(icd);
 eiufmt:
 	icd->use_count--;
+	mutex_unlock(&icd->video_lock);
 	module_put(ici->ops->owner);
 emgi:
 	module_put(icd->ops->owner);
 emgd:
-	mutex_unlock(&video_lock);
 	vfree(icf);
 	return ret;
 }
@@ -300,15 +304,16 @@ static int soc_camera_close(struct inode *inode, struct file *file)
 	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
 	struct video_device *vdev = icd->vdev;
 
-	mutex_lock(&video_lock);
+	mutex_lock(&icd->video_lock);
 	icd->use_count--;
 	if (!icd->use_count) {
 		ici->ops->remove(icd);
 		soc_camera_free_user_formats(icd);
 	}
+	mutex_unlock(&icd->video_lock);
+
 	module_put(icd->ops->owner);
 	module_put(ici->ops->owner);
-	mutex_unlock(&video_lock);
 
 	vfree(icf);
 
@@ -390,18 +395,27 @@ static int soc_camera_s_fmt_vid_cap(struct file *file, void *priv,
 	if (ret < 0)
 		return ret;
 
+	mutex_lock(&icf->vb_vidq.vb_lock);
+
+	if (videobuf_queue_is_busy(&icf->vb_vidq)) {
+		dev_err(&icd->dev, "S_FMT denied: queue busy\n");
+		ret = -EBUSY;
+		goto unlock;
+	}
+
 	rect.left	= icd->x_current;
 	rect.top	= icd->y_current;
 	rect.width	= pix->width;
 	rect.height	= pix->height;
 	ret = ici->ops->set_fmt(icd, pix->pixelformat, &rect);
 	if (ret < 0) {
-		return ret;
+		goto unlock;
 	} else if (!icd->current_fmt ||
 		   icd->current_fmt->fourcc != pixfmt) {
 		dev_err(&ici->dev,
 			"Host driver hasn't set up current format correctly!\n");
-		return -EINVAL;
+		ret = -EINVAL;
+		goto unlock;
 	}
 
 	icd->width		= rect.width;
@@ -415,7 +429,12 @@ static int soc_camera_s_fmt_vid_cap(struct file *file, void *priv,
 		icd->width, icd->height);
 
 	/* set physical bus parameters */
-	return ici->ops->set_bus_param(icd, pixfmt);
+	ret = ici->ops->set_bus_param(icd, pixfmt);
+
+unlock:
+	mutex_unlock(&icf->vb_vidq.vb_lock);
+
+	return ret;
 }
 
 static int soc_camera_enum_fmt_vid_cap(struct file *file, void  *priv,
@@ -476,6 +495,7 @@ static int soc_camera_streamon(struct file *file, void *priv,
 {
 	struct soc_camera_file *icf = file->private_data;
 	struct soc_camera_device *icd = icf->icd;
+	int ret;
 
 	WARN_ON(priv != file->private_data);
 
@@ -484,10 +504,16 @@ static int soc_camera_streamon(struct file *file, void *priv,
 	if (i != V4L2_BUF_TYPE_VIDEO_CAPTURE)
 		return -EINVAL;
 
+	mutex_lock(&icd->video_lock);
+
 	icd->ops->start_capture(icd);
 
 	/* This calls buf_queue from host driver's videobuf_queue_ops */
-	return videobuf_streamon(&icf->vb_vidq);
+	ret = videobuf_streamon(&icf->vb_vidq);
+
+	mutex_unlock(&icd->video_lock);
+
+	return ret;
 }
 
 static int soc_camera_streamoff(struct file *file, void *priv,
@@ -503,12 +529,16 @@ static int soc_camera_streamoff(struct file *file, void *priv,
 	if (i != V4L2_BUF_TYPE_VIDEO_CAPTURE)
 		return -EINVAL;
 
+	mutex_lock(&icd->video_lock);
+
 	/* This calls buf_release from host driver's videobuf_queue_ops for all
 	 * remaining buffers. When the last buffer is freed, stop capture */
 	videobuf_streamoff(&icf->vb_vidq);
 
 	icd->ops->stop_capture(icd);
 
+	mutex_unlock(&icd->video_lock);
+
 	return 0;
 }
 
@@ -620,6 +650,9 @@ static int soc_camera_s_crop(struct file *file, void *fh,
 	if (a->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
 		return -EINVAL;
 
+	/* Cropping is allowed during a running capture, guard consistency */
+	mutex_lock(&icf->vb_vidq.vb_lock);
+
 	ret = ici->ops->set_fmt(icd, 0, &a->c);
 	if (!ret) {
 		icd->width	= a->c.width;
@@ -628,6 +661,8 @@ static int soc_camera_s_crop(struct file *file, void *fh,
 		icd->y_current	= a->c.top;
 	}
 
+	mutex_unlock(&icf->vb_vidq.vb_lock);
+
 	return ret;
 }
 
@@ -741,11 +776,32 @@ static int soc_camera_probe(struct device *dev)
 	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
 	int ret;
 
+	/*
+	 * Possible race scenario:
+	 * modprobe <camera-host-driver> triggers __func__
+	 * at this moment respective <camera-sensor-driver> gets rmmod'ed
+	 * to protect take module references.
+	 */
+
+	if (!try_module_get(icd->ops->owner)) {
+		dev_err(&icd->dev, "Couldn't lock sensor driver.\n");
+		ret = -EINVAL;
+		goto emgd;
+	}
+
+	if (!try_module_get(ici->ops->owner)) {
+		dev_err(&icd->dev, "Couldn't lock capture bus driver.\n");
+		ret = -EINVAL;
+		goto emgi;
+	}
+
+	mutex_lock(&icd->video_lock);
+
 	/* We only call ->add() here to activate and probe the camera.
 	 * We shall ->remove() and deactivate it immediately afterwards. */
 	ret = ici->ops->add(icd);
 	if (ret < 0)
-		return ret;
+		goto eiadd;
 
 	ret = icd->ops->probe(icd);
 	if (ret >= 0) {
@@ -759,6 +815,12 @@ static int soc_camera_probe(struct device *dev)
 	}
 	ici->ops->remove(icd);
 
+eiadd:
+	mutex_unlock(&icd->video_lock);
+	module_put(ici->ops->owner);
+emgi:
+	module_put(icd->ops->owner);
+emgd:
 	return ret;
 }
 
@@ -933,6 +995,7 @@ int soc_camera_device_register(struct soc_camera_device *icd)
 	icd->dev.release	= dummy_release;
 	icd->use_count		= 0;
 	icd->host_priv		= NULL;
+	mutex_init(&icd->video_lock);
 
 	return scan_add_device(icd);
 }
@@ -979,6 +1042,10 @@ static const struct v4l2_ioctl_ops soc_camera_ioctl_ops = {
 #endif
 };
 
+/*
+ * Usually called from the struct soc_camera_ops .probe() method, i.e., from
+ * soc_camera_probe() above with .video_lock held
+ */
 int soc_camera_video_start(struct soc_camera_device *icd)
 {
 	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
@@ -994,7 +1061,7 @@ int soc_camera_video_start(struct soc_camera_device *icd)
 	dev_dbg(&ici->dev, "Allocated video_device %p\n", vdev);
 
 	strlcpy(vdev->name, ici->drv_name, sizeof(vdev->name));
-	/* Maybe better &ici->dev */
+
 	vdev->parent		= &icd->dev;
 	vdev->current_norm	= V4L2_STD_UNKNOWN;
 	vdev->fops		= &soc_camera_fops;
@@ -1028,10 +1095,10 @@ void soc_camera_video_stop(struct soc_camera_device *icd)
 	if (!icd->dev.parent || !vdev)
 		return;
 
-	mutex_lock(&video_lock);
+	mutex_lock(&icd->video_lock);
 	video_unregister_device(vdev);
 	icd->vdev = NULL;
-	mutex_unlock(&video_lock);
+	mutex_unlock(&icd->video_lock);
 }
 EXPORT_SYMBOL(soc_camera_video_stop);
 
diff --git a/include/media/soc_camera.h b/include/media/soc_camera.h
index afeca4b..0ca446a 100644
--- a/include/media/soc_camera.h
+++ b/include/media/soc_camera.h
@@ -12,9 +12,10 @@
 #ifndef SOC_CAMERA_H
 #define SOC_CAMERA_H
 
+#include <linux/mutex.h>
+#include <linux/pm.h>
 #include <linux/videodev2.h>
 #include <media/videobuf-core.h>
-#include <linux/pm.h>
 
 struct soc_camera_device {
 	struct list_head list;
@@ -45,9 +46,10 @@ struct soc_camera_device {
 	struct soc_camera_format_xlate *user_formats;
 	int num_user_formats;
 	struct module *owner;
-	void *host_priv;		/* per-device host private data */
-	/* soc_camera.c private count. Only accessed with video_lock held */
+	void *host_priv;		/* Per-device host private data */
+	/* soc_camera.c private count. Only accessed with .video_lock held */
 	int use_count;
+	struct mutex video_lock;	/* Protects device data */
 };
 
 struct soc_camera_file {
-- 
1.5.4

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
