Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.irobotique.be ([92.243.18.41]:52686 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756681AbZKRAiz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Nov 2009 19:38:55 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: hverkuil@xs4all.nl, mchehab@infradead.org,
	sakari.ailus@maxwell.research.nokia.com
Subject: v4l: Remove unneeded video_device::minor usage in drivers
Date: Wed, 18 Nov 2009 01:38:51 +0100
Message-Id: <1258504731-8430-11-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1258504731-8430-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1258504731-8430-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The video_device::minor field is used where it shouldn't, either to

- test for error conditions that can't happen anymore with the current
  v4l-dvb core,
- store the value in a driver private field that isn't used anymore,
- check the video device type where video_device::vfl_type should be
  used, or
- create the name of a kernel thread that should get a stable name.

Remove or fix those use cases.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

Index: v4l-dvb-mc-uvc/linux/drivers/media/radio/radio-tea5764.c
===================================================================
--- v4l-dvb-mc-uvc.orig/linux/drivers/media/radio/radio-tea5764.c
+++ v4l-dvb-mc-uvc/linux/drivers/media/radio/radio-tea5764.c
@@ -462,12 +462,8 @@ static int vidioc_s_audio(struct file *f
 static int tea5764_open(struct file *file)
 {
 	/* Currently we support only one device */
-	int minor = video_devdata(file)->minor;
 	struct tea5764_device *radio = video_drvdata(file);
 
-	if (radio->videodev->minor != minor)
-		return -ENODEV;
-
 	mutex_lock(&radio->mutex);
 	/* Only exclusive access */
 	if (radio->users) {
Index: v4l-dvb-mc-uvc/linux/drivers/media/video/bt8xx/bttv-driver.c
===================================================================
--- v4l-dvb-mc-uvc.orig/linux/drivers/media/video/bt8xx/bttv-driver.c
+++ v4l-dvb-mc-uvc/linux/drivers/media/video/bt8xx/bttv-driver.c
@@ -3234,7 +3234,6 @@ err:
 
 static int bttv_open(struct file *file)
 {
-	int minor = video_devdata(file)->minor;
 	struct video_device *vdev = video_devdata(file);
 	struct bttv *btv = video_drvdata(file);
 	struct bttv_fh *fh;
@@ -3242,17 +3241,17 @@ static int bttv_open(struct file *file)
 
 	dprintk(KERN_DEBUG "bttv: open dev=%s\n", video_device_node_name(vdev));
 
-	lock_kernel();
-	if (btv->video_dev->minor == minor) {
+	if (vdev->vfl_type == VFL_TYPE_GRABBER) {
 		type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
-	} else if (btv->vbi_dev->minor == minor) {
+	} else if (vdev->vfl_type == VFL_TYPE_VBI) {
 		type = V4L2_BUF_TYPE_VBI_CAPTURE;
 	} else {
 		WARN_ON(1);
-		unlock_kernel();
 		return -ENODEV;
 	}
 
+	lock_kernel();
+
 	dprintk(KERN_DEBUG "bttv%d: open called (type=%s)\n",
 		btv->c.nr,v4l2_type_names[type]);
 
@@ -3436,7 +3435,6 @@ static struct video_device bttv_video_te
 
 static int radio_open(struct file *file)
 {
-	int minor = video_devdata(file)->minor;
 	struct video_device *vdev = video_devdata(file);
 	struct bttv *btv = video_drvdata(file);
 	struct bttv_fh *fh;
@@ -3444,11 +3442,6 @@ static int radio_open(struct file *file)
 	dprintk("bttv: open dev=%s\n", video_device_node_name(vdev));
 
 	lock_kernel();
-	WARN_ON(btv->radio_dev && btv->radio_dev->minor != minor);
-	if (!btv->radio_dev || btv->radio_dev->minor != minor) {
-		unlock_kernel();
-		return -ENODEV;
-	}
 
 	dprintk("bttv%d: open called (radio)\n",btv->c.nr);
 
Index: v4l-dvb-mc-uvc/linux/drivers/media/video/omap24xxcam.c
===================================================================
--- v4l-dvb-mc-uvc.orig/linux/drivers/media/video/omap24xxcam.c
+++ v4l-dvb-mc-uvc/linux/drivers/media/video/omap24xxcam.c
@@ -1450,12 +1450,11 @@ static int omap24xxcam_mmap(struct file 
 
 static int omap24xxcam_open(struct file *file)
 {
-	int minor = video_devdata(file)->minor;
 	struct omap24xxcam_device *cam = omap24xxcam.priv;
 	struct omap24xxcam_fh *fh;
 	struct v4l2_format format;
 
-	if (!cam || !cam->vfd || (cam->vfd->minor != minor))
+	if (!cam || !cam->vfd)
 		return -ENODEV;
 
 	fh = kzalloc(sizeof(*fh), GFP_KERNEL);
Index: v4l-dvb-mc-uvc/linux/drivers/media/common/saa7146_fops.c
===================================================================
--- v4l-dvb-mc-uvc.orig/linux/drivers/media/common/saa7146_fops.c
+++ v4l-dvb-mc-uvc/linux/drivers/media/common/saa7146_fops.c
@@ -1,8 +1,6 @@
 #include <media/saa7146_vv.h>
 #include "compat.h"
 
-#define BOARD_CAN_DO_VBI(dev)   (dev->revision != 0 && dev->vv_data->vbi_minor != -1)
-
 /****************************************************************************/
 /* resource management functions, shamelessly stolen from saa7134 driver */
 
@@ -456,9 +454,6 @@ int saa7146_vv_init(struct saa7146_dev* 
 	   configuration data) */
 	dev->ext_vv_data = ext_vv;
 
-	vv->video_minor = -1;
-	vv->vbi_minor = -1;
-
 	vv->d_clipping.cpu_addr = pci_alloc_consistent(dev->pci, SAA7146_CLIPPING_MEM, &vv->d_clipping.dma_handle);
 	if( NULL == vv->d_clipping.cpu_addr ) {
 		ERR(("out of memory. aborting.\n"));
@@ -497,7 +492,6 @@ EXPORT_SYMBOL_GPL(saa7146_vv_release);
 int saa7146_register_device(struct video_device **vid, struct saa7146_dev* dev,
 			    char *name, int type)
 {
-	struct saa7146_vv *vv = dev->vv_data;
 	struct video_device *vfd;
 	int err;
 	int i;
@@ -525,11 +519,6 @@ int saa7146_register_device(struct video
 		return err;
 	}
 
-	if (VFL_TYPE_GRABBER == type)
-		vv->video_minor = vfd->minor;
-	else
-		vv->vbi_minor = vfd->minor;
-
 	INFO(("%s: registered device %s [v4l2]\n",
 		dev->name, video_device_node_name(vfd)));
 
@@ -540,16 +529,8 @@ EXPORT_SYMBOL_GPL(saa7146_register_devic
 
 int saa7146_unregister_device(struct video_device **vid, struct saa7146_dev* dev)
 {
-	struct saa7146_vv *vv = dev->vv_data;
-
 	DEB_EE(("dev:%p\n",dev));
 
-	if ((*vid)->vfl_type == VFL_TYPE_GRABBER) {
-		vv->video_minor = -1;
-	} else {
-		vv->vbi_minor = -1;
-	}
-
 	video_unregister_device(*vid);
 	*vid = NULL;
 
Index: v4l-dvb-mc-uvc/linux/include/media/saa7146_vv.h
===================================================================
--- v4l-dvb-mc-uvc.orig/linux/include/media/saa7146_vv.h
+++ v4l-dvb-mc-uvc/linux/include/media/saa7146_vv.h
@@ -108,8 +108,6 @@ struct saa7146_fh {
 
 struct saa7146_vv
 {
-	int vbi_minor;
-
 	/* vbi capture */
 	struct saa7146_dmaqueue		vbi_q;
 	/* vbi workaround interrupt queue */
@@ -117,8 +115,6 @@ struct saa7146_vv
 	int				vbi_fieldcount;
 	struct saa7146_fh		*vbi_streaming;
 
-	int video_minor;
-
 	int				video_status;
 	struct saa7146_fh		*video_fh;
 
Index: v4l-dvb-mc-uvc/linux/drivers/media/video/gspca/sn9c20x.c
===================================================================
--- v4l-dvb-mc-uvc.orig/linux/drivers/media/video/gspca/sn9c20x.c
+++ v4l-dvb-mc-uvc/linux/drivers/media/video/gspca/sn9c20x.c
@@ -1479,8 +1479,9 @@ static int sn9c20x_input_init(struct gsp
 	if (input_register_device(sd->input_dev))
 		return -EINVAL;
 
-	sd->input_task = kthread_run(input_kthread, gspca_dev, "sn9c20x/%d",
-				     gspca_dev->vdev.minor);
+	sd->input_task = kthread_run(input_kthread, gspca_dev, "sn9c20x/%s-%s",
+				     gspca_dev->dev->bus->bus_name,
+				     gspca_dev->dev->devpath);
 
 	if (IS_ERR(sd->input_task))
 		return -EINVAL;
