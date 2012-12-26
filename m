Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.8]:60337 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752400Ab2LZRgB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 26 Dec 2012 12:36:01 -0500
Received: from 6a.grange (6a.grange [192.168.1.11])
	by axis700.grange (Postfix) with ESMTPS id 380BC40B9C
	for <linux-media@vger.kernel.org>; Wed, 26 Dec 2012 18:35:59 +0100 (CET)
Received: from lyakh by 6a.grange with local (Exim 4.72)
	(envelope-from <g.liakhovetski@gmx.de>)
	id 1Tnuta-0001cO-TA
	for linux-media@vger.kernel.org; Wed, 26 Dec 2012 18:35:58 +0100
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: linux-media@vger.kernel.org
Subject: [PATCH 3/6] soc-camera: remove struct soc_camera_device::video_lock
Date: Wed, 26 Dec 2012 18:35:55 +0100
Message-Id: <1356543358-6180-4-git-send-email-g.liakhovetski@gmx.de>
In-Reply-To: <1356543358-6180-1-git-send-email-g.liakhovetski@gmx.de>
References: <1356543358-6180-1-git-send-email-g.liakhovetski@gmx.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Currently soc-camera has a per-device node lock, used for video operations
and a per-host lock for code paths, modifying host's pipeline. Manipulating
the two locks increases complexity and doesn't bring any advantages. This
patch removes the per-device lock and uses the per-host lock for all
operations.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 drivers/media/platform/soc_camera/atmel-isi.c      |    4 +-
 drivers/media/platform/soc_camera/mx1_camera.c     |    3 +-
 drivers/media/platform/soc_camera/mx2_camera.c     |    1 -
 drivers/media/platform/soc_camera/mx3_camera.c     |    4 +-
 drivers/media/platform/soc_camera/omap1_camera.c   |    4 +-
 drivers/media/platform/soc_camera/pxa_camera.c     |    6 +-
 .../platform/soc_camera/sh_mobile_ceu_camera.c     |    4 +-
 drivers/media/platform/soc_camera/soc_camera.c     |   51 ++++++++-----------
 include/media/soc_camera.h                         |    3 +-
 9 files changed, 35 insertions(+), 45 deletions(-)

diff --git a/drivers/media/platform/soc_camera/atmel-isi.c b/drivers/media/platform/soc_camera/atmel-isi.c
index 6274a91..683aa28 100644
--- a/drivers/media/platform/soc_camera/atmel-isi.c
+++ b/drivers/media/platform/soc_camera/atmel-isi.c
@@ -745,7 +745,7 @@ static int isi_camera_get_formats(struct soc_camera_device *icd,
 	return formats;
 }
 
-/* Called with .video_lock held */
+/* Called with .host_lock held */
 static int isi_camera_add_device(struct soc_camera_device *icd)
 {
 	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
@@ -770,7 +770,7 @@ static int isi_camera_add_device(struct soc_camera_device *icd)
 		 icd->devnum);
 	return 0;
 }
-/* Called with .video_lock held */
+/* Called with .host_lock held */
 static void isi_camera_remove_device(struct soc_camera_device *icd)
 {
 	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
diff --git a/drivers/media/platform/soc_camera/mx1_camera.c b/drivers/media/platform/soc_camera/mx1_camera.c
index 032b8c9..aeb3e01 100644
--- a/drivers/media/platform/soc_camera/mx1_camera.c
+++ b/drivers/media/platform/soc_camera/mx1_camera.c
@@ -26,7 +26,6 @@
 #include <linux/mm.h>
 #include <linux/module.h>
 #include <linux/moduleparam.h>
-#include <linux/mutex.h>
 #include <linux/platform_device.h>
 #include <linux/sched.h>
 #include <linux/slab.h>
@@ -373,7 +372,7 @@ static void mx1_camera_init_videobuf(struct videobuf_queue *q,
 	videobuf_queue_dma_contig_init(q, &mx1_videobuf_ops, icd->parent,
 				&pcdev->lock, V4L2_BUF_TYPE_VIDEO_CAPTURE,
 				V4L2_FIELD_NONE,
-				sizeof(struct mx1_buffer), icd, &icd->video_lock);
+				sizeof(struct mx1_buffer), icd, &icd->host_lock);
 }
 
 static int mclk_get_divisor(struct mx1_camera_dev *pcdev)
diff --git a/drivers/media/platform/soc_camera/mx2_camera.c b/drivers/media/platform/soc_camera/mx2_camera.c
index 860aef5..f48788c 100644
--- a/drivers/media/platform/soc_camera/mx2_camera.c
+++ b/drivers/media/platform/soc_camera/mx2_camera.c
@@ -28,7 +28,6 @@
 #include <linux/time.h>
 #include <linux/device.h>
 #include <linux/platform_device.h>
-#include <linux/mutex.h>
 #include <linux/clk.h>
 
 #include <media/v4l2-common.h>
diff --git a/drivers/media/platform/soc_camera/mx3_camera.c b/drivers/media/platform/soc_camera/mx3_camera.c
index 261f6e9..f2eabd7 100644
--- a/drivers/media/platform/soc_camera/mx3_camera.c
+++ b/drivers/media/platform/soc_camera/mx3_camera.c
@@ -510,7 +510,7 @@ static void mx3_camera_activate(struct mx3_camera_dev *mx3_cam,
 		clk_set_rate(mx3_cam->clk, rate);
 }
 
-/* Called with .video_lock held */
+/* Called with .host_lock held */
 static int mx3_camera_add_device(struct soc_camera_device *icd)
 {
 	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
@@ -530,7 +530,7 @@ static int mx3_camera_add_device(struct soc_camera_device *icd)
 	return 0;
 }
 
-/* Called with .video_lock held */
+/* Called with .host_lock held */
 static void mx3_camera_remove_device(struct soc_camera_device *icd)
 {
 	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
diff --git a/drivers/media/platform/soc_camera/omap1_camera.c b/drivers/media/platform/soc_camera/omap1_camera.c
index 13636a5..4ccd1a8 100644
--- a/drivers/media/platform/soc_camera/omap1_camera.c
+++ b/drivers/media/platform/soc_camera/omap1_camera.c
@@ -1382,12 +1382,12 @@ static void omap1_cam_init_videobuf(struct videobuf_queue *q,
 		videobuf_queue_dma_contig_init(q, &omap1_videobuf_ops,
 				icd->parent, &pcdev->lock,
 				V4L2_BUF_TYPE_VIDEO_CAPTURE, V4L2_FIELD_NONE,
-				sizeof(struct omap1_cam_buf), icd, &icd->video_lock);
+				sizeof(struct omap1_cam_buf), icd, &icd->host_lock);
 	else
 		videobuf_queue_sg_init(q, &omap1_videobuf_ops,
 				icd->parent, &pcdev->lock,
 				V4L2_BUF_TYPE_VIDEO_CAPTURE, V4L2_FIELD_NONE,
-				sizeof(struct omap1_cam_buf), icd, &icd->video_lock);
+				sizeof(struct omap1_cam_buf), icd, &icd->host_lock);
 
 	/* use videobuf mode (auto)selected with the module parameter */
 	pcdev->vb_mode = sg_mode ? OMAP1_CAM_DMA_SG : OMAP1_CAM_DMA_CONTIG;
diff --git a/drivers/media/platform/soc_camera/pxa_camera.c b/drivers/media/platform/soc_camera/pxa_camera.c
index 3434ffe..a32077c 100644
--- a/drivers/media/platform/soc_camera/pxa_camera.c
+++ b/drivers/media/platform/soc_camera/pxa_camera.c
@@ -842,7 +842,7 @@ static void pxa_camera_init_videobuf(struct videobuf_queue *q,
 	 */
 	videobuf_queue_sg_init(q, &pxa_videobuf_ops, NULL, &pcdev->lock,
 				V4L2_BUF_TYPE_VIDEO_CAPTURE, V4L2_FIELD_NONE,
-				sizeof(struct pxa_buffer), icd, &icd->video_lock);
+				sizeof(struct pxa_buffer), icd, &icd->host_lock);
 }
 
 static u32 mclk_get_divisor(struct platform_device *pdev,
@@ -958,7 +958,7 @@ static irqreturn_t pxa_camera_irq(int irq, void *data)
 /*
  * The following two functions absolutely depend on the fact, that
  * there can be only one camera on PXA quick capture interface
- * Called with .video_lock held
+ * Called with .host_lock held
  */
 static int pxa_camera_add_device(struct soc_camera_device *icd)
 {
@@ -978,7 +978,7 @@ static int pxa_camera_add_device(struct soc_camera_device *icd)
 	return 0;
 }
 
-/* Called with .video_lock held */
+/* Called with .host_lock held */
 static void pxa_camera_remove_device(struct soc_camera_device *icd)
 {
 	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
diff --git a/drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c b/drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c
index cf65e7f..ba36257 100644
--- a/drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c
+++ b/drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c
@@ -545,7 +545,7 @@ static struct v4l2_subdev *find_csi2(struct sh_mobile_ceu_dev *pcdev)
 	return NULL;
 }
 
-/* Called with .video_lock held */
+/* Called with .host_lock held */
 static int sh_mobile_ceu_add_device(struct soc_camera_device *icd)
 {
 	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
@@ -589,7 +589,7 @@ static int sh_mobile_ceu_add_device(struct soc_camera_device *icd)
 	return 0;
 }
 
-/* Called with .video_lock held */
+/* Called with .host_lock held */
 static void sh_mobile_ceu_remove_device(struct soc_camera_device *icd)
 {
 	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
diff --git a/drivers/media/platform/soc_camera/soc_camera.c b/drivers/media/platform/soc_camera/soc_camera.c
index 37c53e7..560390d 100644
--- a/drivers/media/platform/soc_camera/soc_camera.c
+++ b/drivers/media/platform/soc_camera/soc_camera.c
@@ -383,7 +383,7 @@ static int soc_camera_prepare_buf(struct file *file, void *priv,
 		return vb2_prepare_buf(&icd->vb2_vidq, b);
 }
 
-/* Always entered with .video_lock held */
+/* Always entered with .host_lock held */
 static int soc_camera_init_user_formats(struct soc_camera_device *icd)
 {
 	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
@@ -450,7 +450,7 @@ egfmt:
 	return ret;
 }
 
-/* Always entered with .video_lock held */
+/* Always entered with .host_lock held */
 static void soc_camera_free_user_formats(struct soc_camera_device *icd)
 {
 	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
@@ -526,7 +526,7 @@ static int soc_camera_open(struct file *file)
 	ici = to_soc_camera_host(icd->parent);
 	mutex_unlock(&list_lock);
 
-	if (mutex_lock_interruptible(&icd->video_lock))
+	if (mutex_lock_interruptible(&ici->host_lock))
 		return -ERESTARTSYS;
 	if (!try_module_get(ici->ops->owner)) {
 		dev_err(icd->pdev, "Couldn't lock capture bus driver.\n");
@@ -555,9 +555,7 @@ static int soc_camera_open(struct file *file)
 		if (icl->reset)
 			icl->reset(icd->pdev);
 
-		mutex_lock(&ici->host_lock);
 		ret = ici->ops->add(icd);
-		mutex_unlock(&ici->host_lock);
 		if (ret < 0) {
 			dev_err(icd->pdev, "Couldn't activate the camera: %d\n", ret);
 			goto eiciadd;
@@ -576,7 +574,7 @@ static int soc_camera_open(struct file *file)
 		 * Try to configure with default parameters. Notice: this is the
 		 * very first open, so, we cannot race against other calls,
 		 * apart from someone else calling open() simultaneously, but
-		 * .video_lock is protecting us against it.
+		 * .host_lock is protecting us against it.
 		 */
 		ret = soc_camera_set_fmt(icd, &f);
 		if (ret < 0)
@@ -591,7 +589,7 @@ static int soc_camera_open(struct file *file)
 		}
 		v4l2_ctrl_handler_setup(&icd->ctrl_handler);
 	}
-	mutex_unlock(&icd->video_lock);
+	mutex_unlock(&ici->host_lock);
 
 	file->private_data = icd;
 	dev_dbg(icd->pdev, "camera device open\n");
@@ -599,7 +597,7 @@ static int soc_camera_open(struct file *file)
 	return 0;
 
 	/*
-	 * First four errors are entered with the .video_lock held
+	 * First four errors are entered with the .host_lock held
 	 * and use_count == 1
 	 */
 einitvb:
@@ -608,14 +606,12 @@ esfmt:
 eresume:
 	__soc_camera_power_off(icd);
 epower:
-	mutex_lock(&ici->host_lock);
 	ici->ops->remove(icd);
-	mutex_unlock(&ici->host_lock);
 eiciadd:
 	icd->use_count--;
 	module_put(ici->ops->owner);
 emodule:
-	mutex_unlock(&icd->video_lock);
+	mutex_unlock(&ici->host_lock);
 
 	return ret;
 }
@@ -625,7 +621,7 @@ static int soc_camera_close(struct file *file)
 	struct soc_camera_device *icd = file->private_data;
 	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
 
-	mutex_lock(&icd->video_lock);
+	mutex_lock(&ici->host_lock);
 	icd->use_count--;
 	if (!icd->use_count) {
 		pm_runtime_suspend(&icd->vdev->dev);
@@ -633,16 +629,14 @@ static int soc_camera_close(struct file *file)
 
 		if (ici->ops->init_videobuf2)
 			vb2_queue_release(&icd->vb2_vidq);
-		mutex_lock(&ici->host_lock);
 		ici->ops->remove(icd);
-		mutex_unlock(&ici->host_lock);
 
 		__soc_camera_power_off(icd);
 	}
 
 	if (icd->streamer == file)
 		icd->streamer = NULL;
-	mutex_unlock(&icd->video_lock);
+	mutex_unlock(&ici->host_lock);
 
 	module_put(ici->ops->owner);
 
@@ -679,13 +673,13 @@ static int soc_camera_mmap(struct file *file, struct vm_area_struct *vma)
 	if (icd->streamer != file)
 		return -EBUSY;
 
-	if (mutex_lock_interruptible(&icd->video_lock))
+	if (mutex_lock_interruptible(&ici->host_lock))
 		return -ERESTARTSYS;
 	if (ici->ops->init_videobuf)
 		err = videobuf_mmap_mapper(&icd->vb_vidq, vma);
 	else
 		err = vb2_mmap(&icd->vb2_vidq, vma);
-	mutex_unlock(&icd->video_lock);
+	mutex_unlock(&ici->host_lock);
 
 	dev_dbg(icd->pdev, "vma start=0x%08lx, size=%ld, ret=%d\n",
 		(unsigned long)vma->vm_start,
@@ -704,26 +698,28 @@ static unsigned int soc_camera_poll(struct file *file, poll_table *pt)
 	if (icd->streamer != file)
 		return POLLERR;
 
-	mutex_lock(&icd->video_lock);
+	mutex_lock(&ici->host_lock);
 	if (ici->ops->init_videobuf && list_empty(&icd->vb_vidq.stream))
 		dev_err(icd->pdev, "Trying to poll with no queued buffers!\n");
 	else
 		res = ici->ops->poll(file, pt);
-	mutex_unlock(&icd->video_lock);
+	mutex_unlock(&ici->host_lock);
 	return res;
 }
 
 void soc_camera_lock(struct vb2_queue *vq)
 {
 	struct soc_camera_device *icd = vb2_get_drv_priv(vq);
-	mutex_lock(&icd->video_lock);
+	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
+	mutex_lock(&ici->host_lock);
 }
 EXPORT_SYMBOL(soc_camera_lock);
 
 void soc_camera_unlock(struct vb2_queue *vq)
 {
 	struct soc_camera_device *icd = vb2_get_drv_priv(vq);
-	mutex_unlock(&icd->video_lock);
+	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
+	mutex_unlock(&ici->host_lock);
 }
 EXPORT_SYMBOL(soc_camera_unlock);
 
@@ -1216,7 +1212,7 @@ static int soc_camera_probe(struct soc_camera_device *icd)
 	 * itself is protected against concurrent open() calls, but we also have
 	 * to protect our data.
 	 */
-	mutex_lock(&icd->video_lock);
+	mutex_lock(&ici->host_lock);
 
 	ret = soc_camera_video_start(icd);
 	if (ret < 0)
@@ -1230,16 +1226,14 @@ static int soc_camera_probe(struct soc_camera_device *icd)
 		icd->field		= mf.field;
 	}
 
-	mutex_lock(&ici->host_lock);
 	ici->ops->remove(icd);
-	mutex_unlock(&ici->host_lock);
 
-	mutex_unlock(&icd->video_lock);
+	mutex_unlock(&ici->host_lock);
 
 	return 0;
 
 evidstart:
-	mutex_unlock(&icd->video_lock);
+	mutex_unlock(&ici->host_lock);
 	soc_camera_free_user_formats(icd);
 eiufmt:
 ectrl:
@@ -1455,7 +1449,6 @@ static int soc_camera_device_register(struct soc_camera_device *icd)
 	icd->devnum		= num;
 	icd->use_count		= 0;
 	icd->host_priv		= NULL;
-	mutex_init(&icd->video_lock);
 
 	list_add_tail(&icd->list, &devices);
 
@@ -1513,7 +1506,7 @@ static int video_dev_create(struct soc_camera_device *icd)
 	vdev->release		= video_device_release;
 	vdev->tvnorms		= V4L2_STD_UNKNOWN;
 	vdev->ctrl_handler	= &icd->ctrl_handler;
-	vdev->lock		= &icd->video_lock;
+	vdev->lock		= &ici->host_lock;
 
 	icd->vdev = vdev;
 
@@ -1521,7 +1514,7 @@ static int video_dev_create(struct soc_camera_device *icd)
 }
 
 /*
- * Called from soc_camera_probe() above (with .video_lock held???)
+ * Called from soc_camera_probe() above with .host_lock held
  */
 static int soc_camera_video_start(struct soc_camera_device *icd)
 {
diff --git a/include/media/soc_camera.h b/include/media/soc_camera.h
index 0370a95..5a662c9 100644
--- a/include/media/soc_camera.h
+++ b/include/media/soc_camera.h
@@ -46,9 +46,8 @@ struct soc_camera_device {
 	int num_user_formats;
 	enum v4l2_field field;		/* Preserve field over close() */
 	void *host_priv;		/* Per-device host private data */
-	/* soc_camera.c private count. Only accessed with .video_lock held */
+	/* soc_camera.c private count. Only accessed with .host_lock held */
 	int use_count;
-	struct mutex video_lock;	/* Protects device data */
 	struct file *streamer;		/* stream owner */
 	union {
 		struct videobuf_queue vb_vidq;
-- 
1.7.2.5

