Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.irobotique.be ([92.243.18.41]:52686 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756687AbZKRAix (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Nov 2009 19:38:53 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: hverkuil@xs4all.nl, mchehab@infradead.org,
	sakari.ailus@maxwell.research.nokia.com
Subject: v4l: Use the video_is_registered function in device drivers
Date: Wed, 18 Nov 2009 01:38:47 +0100
Message-Id: <1258504731-8430-7-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1258504731-8430-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1258504731-8430-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fix all device drivers to use the video_is_registered function instead
of checking video_device::minor.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

Index: v4l-dvb-mc-uvc/linux/drivers/media/video/bt8xx/bttv-driver.c
===================================================================
--- v4l-dvb-mc-uvc.orig/linux/drivers/media/video/bt8xx/bttv-driver.c
+++ v4l-dvb-mc-uvc/linux/drivers/media/video/bt8xx/bttv-driver.c
@@ -4240,21 +4240,21 @@ static struct video_device *vdev_init(st
 static void bttv_unregister_video(struct bttv *btv)
 {
 	if (btv->video_dev) {
-		if (-1 != btv->video_dev->minor)
+		if (video_is_registered(btv->video_dev))
 			video_unregister_device(btv->video_dev);
 		else
 			video_device_release(btv->video_dev);
 		btv->video_dev = NULL;
 	}
 	if (btv->vbi_dev) {
-		if (-1 != btv->vbi_dev->minor)
+		if (video_is_registered(btv->vbi_dev))
 			video_unregister_device(btv->vbi_dev);
 		else
 			video_device_release(btv->vbi_dev);
 		btv->vbi_dev = NULL;
 	}
 	if (btv->radio_dev) {
-		if (-1 != btv->radio_dev->minor)
+		if (video_is_registered(btv->radio_dev))
 			video_unregister_device(btv->radio_dev);
 		else
 			video_device_release(btv->radio_dev);
Index: v4l-dvb-mc-uvc/linux/drivers/media/video/cx231xx/cx231xx-video.c
===================================================================
--- v4l-dvb-mc-uvc.orig/linux/drivers/media/video/cx231xx/cx231xx-video.c
+++ v4l-dvb-mc-uvc/linux/drivers/media/video/cx231xx/cx231xx-video.c
@@ -2020,7 +2020,7 @@ void cx231xx_release_analog_resources(st
 	/*FIXME: I2C IR should be disconnected */
 
 	if (dev->radio_dev) {
-		if (-1 != dev->radio_dev->minor)
+		if (video_is_registered(dev->radio_dev))
 			video_unregister_device(dev->radio_dev);
 		else
 			video_device_release(dev->radio_dev);
@@ -2029,7 +2029,7 @@ void cx231xx_release_analog_resources(st
 	if (dev->vbi_dev) {
 		cx231xx_info("V4L2 device /dev/%s deregistered\n",
 			     video_device_node_name(dev->vbi_dev));
-		if (-1 != dev->vbi_dev->minor)
+		if (video_is_registered(dev->vbi_dev))
 			video_unregister_device(dev->vbi_dev);
 		else
 			video_device_release(dev->vbi_dev);
@@ -2038,7 +2038,7 @@ void cx231xx_release_analog_resources(st
 	if (dev->vdev) {
 		cx231xx_info("V4L2 device /dev/%s deregistered\n",
 			     video_device_node_name(dev->vdev));
-		if (-1 != dev->vdev->minor)
+		if (video_is_registered(dev->vdev))
 			video_unregister_device(dev->vdev);
 		else
 			video_device_release(dev->vdev);
Index: v4l-dvb-mc-uvc/linux/drivers/media/video/cx23885/cx23885-417.c
===================================================================
--- v4l-dvb-mc-uvc.orig/linux/drivers/media/video/cx23885/cx23885-417.c
+++ v4l-dvb-mc-uvc/linux/drivers/media/video/cx23885/cx23885-417.c
@@ -1753,7 +1753,7 @@ void cx23885_417_unregister(struct cx238
 	dprintk(1, "%s()\n", __func__);
 
 	if (dev->v4l_device) {
-		if (-1 != dev->v4l_device->minor)
+		if (video_is_registered(dev->v4l_device))
 			video_unregister_device(dev->v4l_device);
 		else
 			video_device_release(dev->v4l_device);
Index: v4l-dvb-mc-uvc/linux/drivers/media/video/cx23885/cx23885-video.c
===================================================================
--- v4l-dvb-mc-uvc.orig/linux/drivers/media/video/cx23885/cx23885-video.c
+++ v4l-dvb-mc-uvc/linux/drivers/media/video/cx23885/cx23885-video.c
@@ -1691,14 +1691,14 @@ void cx23885_video_unregister(struct cx2
 
 #if 0
 	if (dev->radio_dev) {
-		if (-1 != dev->radio_dev->minor)
+		if (video_is_registered(dev->radio_dev))
 			video_unregister_device(dev->radio_dev);
 		else
 			video_device_release(dev->radio_dev);
 		dev->radio_dev = NULL;
 	}
 	if (dev->vbi_dev) {
-		if (-1 != dev->vbi_dev->minor)
+		if (video_is_registered(dev->vbi_dev)
 			video_unregister_device(dev->vbi_dev);
 		else
 			video_device_release(dev->vbi_dev);
@@ -1707,7 +1707,7 @@ void cx23885_video_unregister(struct cx2
 	}
 #endif
 	if (dev->video_dev) {
-		if (-1 != dev->video_dev->minor)
+		if (video_is_registered(dev->video_dev))
 			video_unregister_device(dev->video_dev);
 		else
 			video_device_release(dev->video_dev);
Index: v4l-dvb-mc-uvc/linux/drivers/media/video/cx88/cx88-blackbird.c
===================================================================
--- v4l-dvb-mc-uvc.orig/linux/drivers/media/video/cx88/cx88-blackbird.c
+++ v4l-dvb-mc-uvc/linux/drivers/media/video/cx88/cx88-blackbird.c
@@ -1298,7 +1298,7 @@ static int cx8802_blackbird_advise_relea
 static void blackbird_unregister_video(struct cx8802_dev *dev)
 {
 	if (dev->mpeg_dev) {
-		if (-1 != dev->mpeg_dev->minor)
+		if (video_is_registered(dev->mpeg_dev))
 			video_unregister_device(dev->mpeg_dev);
 		else
 			video_device_release(dev->mpeg_dev);
Index: v4l-dvb-mc-uvc/linux/drivers/media/video/cx88/cx88-video.c
===================================================================
--- v4l-dvb-mc-uvc.orig/linux/drivers/media/video/cx88/cx88-video.c
+++ v4l-dvb-mc-uvc/linux/drivers/media/video/cx88/cx88-video.c
@@ -2048,21 +2048,21 @@ static struct video_device cx8800_radio_
 static void cx8800_unregister_video(struct cx8800_dev *dev)
 {
 	if (dev->radio_dev) {
-		if (-1 != dev->radio_dev->minor)
+		if (video_is_registered(dev->radio_dev))
 			video_unregister_device(dev->radio_dev);
 		else
 			video_device_release(dev->radio_dev);
 		dev->radio_dev = NULL;
 	}
 	if (dev->vbi_dev) {
-		if (-1 != dev->vbi_dev->minor)
+		if (video_is_registered(dev->vbi_dev))
 			video_unregister_device(dev->vbi_dev);
 		else
 			video_device_release(dev->vbi_dev);
 		dev->vbi_dev = NULL;
 	}
 	if (dev->video_dev) {
-		if (-1 != dev->video_dev->minor)
+		if (video_is_registered(dev->video_dev))
 			video_unregister_device(dev->video_dev);
 		else
 			video_device_release(dev->video_dev);
Index: v4l-dvb-mc-uvc/linux/drivers/media/video/davinci/vpfe_capture.c
===================================================================
--- v4l-dvb-mc-uvc.orig/linux/drivers/media/video/davinci/vpfe_capture.c
+++ v4l-dvb-mc-uvc/linux/drivers/media/video/davinci/vpfe_capture.c
@@ -2034,7 +2034,7 @@ probe_out_video_unregister:
 probe_out_v4l2_unregister:
 	v4l2_device_unregister(&vpfe_dev->v4l2_dev);
 probe_out_video_release:
-	if (vpfe_dev->video_dev->minor == -1)
+	if (!video_is_registered(vpfe_dev->video_dev))
 		video_device_release(vpfe_dev->video_dev);
 probe_out_release_irq:
 	free_irq(vpfe_dev->ccdc_irq0, vpfe_dev);
Index: v4l-dvb-mc-uvc/linux/drivers/media/video/em28xx/em28xx-video.c
===================================================================
--- v4l-dvb-mc-uvc.orig/linux/drivers/media/video/em28xx/em28xx-video.c
+++ v4l-dvb-mc-uvc/linux/drivers/media/video/em28xx/em28xx-video.c
@@ -2217,7 +2217,7 @@ void em28xx_release_analog_resources(str
 	/*FIXME: I2C IR should be disconnected */
 
 	if (dev->radio_dev) {
-		if (-1 != dev->radio_dev->minor)
+		if (video_is_registered(dev->radio_dev))
 			video_unregister_device(dev->radio_dev);
 		else
 			video_device_release(dev->radio_dev);
@@ -2226,7 +2226,7 @@ void em28xx_release_analog_resources(str
 	if (dev->vbi_dev) {
 		em28xx_info("V4L2 device /dev/%s deregistered\n",
 			    video_device_node_name(dev->vbi_dev));
-		if (-1 != dev->vbi_dev->minor)
+		if (video_is_registered(dev->vbi_dev))
 			video_unregister_device(dev->vbi_dev);
 		else
 			video_device_release(dev->vbi_dev);
@@ -2235,7 +2235,7 @@ void em28xx_release_analog_resources(str
 	if (dev->vdev) {
 		em28xx_info("V4L2 device /dev/%s deregistered\n",
 			    video_device_node_name(dev->vdev));
-		if (-1 != dev->vdev->minor)
+		if (video_is_registered(dev->vdev))
 			video_unregister_device(dev->vdev);
 		else
 			video_device_release(dev->vdev);
Index: v4l-dvb-mc-uvc/linux/drivers/media/video/omap24xxcam.c
===================================================================
--- v4l-dvb-mc-uvc.orig/linux/drivers/media/video/omap24xxcam.c
+++ v4l-dvb-mc-uvc/linux/drivers/media/video/omap24xxcam.c
@@ -1696,7 +1696,7 @@ static void omap24xxcam_device_unregiste
 	omap24xxcam_sensor_exit(cam);
 
 	if (cam->vfd) {
-		if (cam->vfd->minor == -1) {
+		if (!video_is_registered(cam->vfd)) {
 			/*
 			 * The device was never registered, so release the
 			 * video_device struct directly.
Index: v4l-dvb-mc-uvc/linux/drivers/media/video/ov511.c
===================================================================
--- v4l-dvb-mc-uvc.orig/linux/drivers/media/video/ov511.c
+++ v4l-dvb-mc-uvc/linux/drivers/media/video/ov511.c
@@ -5888,7 +5888,7 @@ ov51x_probe(struct usb_interface *intf, 
 
 error:
 	if (ov->vdev) {
-		if (-1 == ov->vdev->minor)
+		if (!video_is_registered(ov->vdev))
 			video_device_release(ov->vdev);
 		else
 			video_unregister_device(ov->vdev);
Index: v4l-dvb-mc-uvc/linux/drivers/media/video/s2255drv.c
===================================================================
--- v4l-dvb-mc-uvc.orig/linux/drivers/media/video/s2255drv.c
+++ v4l-dvb-mc-uvc/linux/drivers/media/video/s2255drv.c
@@ -1881,7 +1881,7 @@ static void s2255_exit_v4l(struct s2255_
 
 	int i;
 	for (i = 0; i < MAX_CHANNELS; i++) {
-		if (-1 != dev->vdev[i]->minor) {
+		if (video_is_registered(dev->vdev[i])) {
 			video_unregister_device(dev->vdev[i]);
 			printk(KERN_INFO "s2255 unregistered\n");
 		} else {
Index: v4l-dvb-mc-uvc/linux/drivers/media/video/saa7134/saa7134-core.c
===================================================================
--- v4l-dvb-mc-uvc.orig/linux/drivers/media/video/saa7134/saa7134-core.c
+++ v4l-dvb-mc-uvc/linux/drivers/media/video/saa7134/saa7134-core.c
@@ -864,21 +864,21 @@ static struct video_device *vdev_init(st
 static void saa7134_unregister_video(struct saa7134_dev *dev)
 {
 	if (dev->video_dev) {
-		if (-1 != dev->video_dev->minor)
+		if (video_is_registered(dev->video_dev))
 			video_unregister_device(dev->video_dev);
 		else
 			video_device_release(dev->video_dev);
 		dev->video_dev = NULL;
 	}
 	if (dev->vbi_dev) {
-		if (-1 != dev->vbi_dev->minor)
+		if (video_is_registered(dev->vbi_dev))
 			video_unregister_device(dev->vbi_dev);
 		else
 			video_device_release(dev->vbi_dev);
 		dev->vbi_dev = NULL;
 	}
 	if (dev->radio_dev) {
-		if (-1 != dev->radio_dev->minor)
+		if (video_is_registered(dev->radio_dev))
 			video_unregister_device(dev->radio_dev);
 		else
 			video_device_release(dev->radio_dev);
Index: v4l-dvb-mc-uvc/linux/drivers/media/video/stradis.c
===================================================================
--- v4l-dvb-mc-uvc.orig/linux/drivers/media/video/stradis.c
+++ v4l-dvb-mc-uvc/linux/drivers/media/video/stradis.c
@@ -2139,7 +2139,7 @@ static void stradis_release_saa(struct p
 	free_irq(saa->irq, saa);
 	if (saa->saa7146_mem)
 		iounmap(saa->saa7146_mem);
-	if (saa->video_dev.minor != -1)
+	if (video_is_registered(&saa->video_dev))
 		video_unregister_device(&saa->video_dev);
 }
 
Index: v4l-dvb-mc-uvc/linux/drivers/media/video/usbvision/usbvision-video.c
===================================================================
--- v4l-dvb-mc-uvc.orig/linux/drivers/media/video/usbvision/usbvision-video.c
+++ v4l-dvb-mc-uvc/linux/drivers/media/video/usbvision/usbvision-video.c
@@ -1418,7 +1418,7 @@ static void usbvision_unregister_video(s
 	if (usbvision->vbi) {
 		PDEBUG(DBG_PROBE, "unregister /dev/%s [v4l2]",
 		       video_device_node_name(usbvision->vbi));
-		if (usbvision->vbi->minor != -1) {
+		if (video_is_registered(usbvision->vbi)) {
 			video_unregister_device(usbvision->vbi);
 		} else {
 			video_device_release(usbvision->vbi);
@@ -1430,7 +1430,7 @@ static void usbvision_unregister_video(s
 	if (usbvision->rdev) {
 		PDEBUG(DBG_PROBE, "unregister /dev/%s [v4l2]",
 		       video_device_node_name(usbvision->rdev));
-		if (usbvision->rdev->minor != -1) {
+		if (video_is_registered(usbvision->rdev)) {
 			video_unregister_device(usbvision->rdev);
 		} else {
 			video_device_release(usbvision->rdev);
@@ -1442,7 +1442,7 @@ static void usbvision_unregister_video(s
 	if (usbvision->vdev) {
 		PDEBUG(DBG_PROBE, "unregister /dev/%s [v4l2]",
 		       video_device_node_name(usbvision->vdev));
-		if (usbvision->vdev->minor != -1) {
+		if (video_is_registered(usbvision->vdev)) {
 			video_unregister_device(usbvision->vdev);
 		} else {
 			video_device_release(usbvision->vdev);
Index: v4l-dvb-mc-uvc/linux/drivers/staging/cx25821/cx25821-video.c
===================================================================
--- v4l-dvb-mc-uvc.orig/linux/drivers/staging/cx25821/cx25821-video.c
+++ v4l-dvb-mc-uvc/linux/drivers/staging/cx25821/cx25821-video.c
@@ -424,7 +424,7 @@ int cx25821_video_irq(struct cx25821_dev
 void cx25821_videoioctl_unregister(struct cx25821_dev *dev)
 {
 	if (dev->ioctl_dev) {
-		if (dev->ioctl_dev->minor != -1)
+		if (video_is_registered(dev->ioctl_dev))
 			video_unregister_device(dev->ioctl_dev);
 		else
 			video_device_release(dev->ioctl_dev);
@@ -438,7 +438,7 @@ void cx25821_video_unregister(struct cx2
 	cx_clear(PCI_INT_MSK, 1);
 
 	if (dev->video_dev[chan_num]) {
-		if (-1 != dev->video_dev[chan_num]->minor)
+		if (video_is_registered(dev->video_dev[chan_num]))
 			video_unregister_device(dev->video_dev[chan_num]);
 		else
 			video_device_release(dev->video_dev[chan_num]);
