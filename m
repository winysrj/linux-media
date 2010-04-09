Return-path: <linux-media-owner@vger.kernel.org>
Received: from gateway16.websitewelcome.com ([69.93.243.5]:34528 "HELO
	gateway16.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751292Ab0DIWya (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 9 Apr 2010 18:54:30 -0400
Date: Fri, 9 Apr 2010 15:54:26 -0700 (PDT)
From: sensoray-dev <linux-dev@sensoray.com>
Subject: [PATCH] s2255drv: removes kref tracking and videodev parent
To: linux-media@vger.kernel.org
cc: hverkuil@xs4all.nl, mchehab@infradead.org,
	sensoray-dev <linux-dev@sensoray.com>
Message-ID: <tkrat.21e84d30cf1ac356@sensoray.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

# HG changeset patch
# User Dean Anderson <linux-dev@sensoray.com>
# Date 1270853488 25200
# Node ID f2f44853e2eb914d4fc6c7004631839b86fb6d0e
# Parent  040de984898870b01dfe553319aa18edb3a442bb
s2255drv: removes kref tracking and videodev parent

From: Dean Anderson <linux-dev@sensoray.com>

kref replaced as suggested in code review
uses atomic variable to track when it is ok to delete device
removes setting of video device parent, which is now
handled in v4l2_device.c

Priority: normal

Signed-off-by: Dean Anderson <linux-dev@sensoray.com>

diff -r 040de9848988 -r f2f44853e2eb linux/drivers/media/video/s2255drv.c
--- a/linux/drivers/media/video/s2255drv.c	Fri Apr 09 14:56:30 2010 -0700
+++ b/linux/drivers/media/video/s2255drv.c	Fri Apr 09 15:51:28 2010 -0700
@@ -230,7 +230,7 @@
 struct s2255_dev {
 	struct video_device	vdev[MAX_CHANNELS];
 	struct v4l2_device 	v4l2_dev;
-	int                     channels; /* number of channels registered */
+	atomic_t                channels; /* number of channels registered */
 	int			frames;
 	struct mutex		lock;
 	struct mutex		open_lock;
@@ -276,12 +276,8 @@
 	/* dsp firmware version (f2255usb.bin) */
 	int                     dsp_fw_ver;
 	u16                     pid; /* product id */
-	struct kref		kref;
 };
 
-/* kref will be removed soon */
-#define to_s2255_dev_from_kref(d) container_of(d, struct s2255_dev, kref)
-
 static inline struct s2255_dev *to_s2255_dev(struct v4l2_device *v4l2_dev)
 {
 	return container_of(v4l2_dev, struct s2255_dev, v4l2_dev);
@@ -372,7 +368,7 @@
 			  struct s2255_mode *mode);
 static int s2255_board_shutdown(struct s2255_dev *dev);
 static void s2255_fwload_start(struct s2255_dev *dev, int reset);
-static void s2255_destroy(struct kref *kref);
+static void s2255_destroy(struct s2255_dev *dev);
 static long s2255_vendor_req(struct s2255_dev *dev, unsigned char req,
 			     u16 index, u16 value, void *buf,
 			     s32 buf_len, int bOut);
@@ -1720,7 +1716,7 @@
 	dprintk(1, "s2255: open called (dev=%s)\n",
 		video_device_node_name(vdev));
 
-	for (i = 0; i < dev->channels; i++)
+	for (i = 0; i < MAX_CHANNELS; i++)
 		if (&dev->vdev[i] == vdev) {
 			cur_channel = i;
 			break;
@@ -1834,9 +1830,8 @@
 	return rc;
 }
 
-static void s2255_destroy(struct kref *kref)
+static void s2255_destroy(struct s2255_dev *dev)
 {
-	struct s2255_dev *dev = to_s2255_dev_from_kref(kref);
 	/* board shutdown stops the read pipe if it is running */
 	s2255_board_shutdown(dev);
 	/* make sure firmware still not trying to load */
@@ -1936,7 +1931,9 @@
 static void s2255_video_device_release(struct video_device *vdev)
 {
 	struct s2255_dev *dev = video_get_drvdata(vdev);
-	kref_put(&dev->kref, s2255_destroy);
+	dprintk(4, "%s, chnls: %d \n", __func__, atomic_read(&dev->channels));
+	if (atomic_dec_and_test(&dev->channels))
+		s2255_destroy(dev);
 	return;
 }
 
@@ -1965,7 +1962,8 @@
 		dev->vidq[i].channel = i;
 		/* register 4 video devices */
 		memcpy(&dev->vdev[i], &template, sizeof(struct video_device));
-		dev->vdev[i].parent = &dev->interface->dev;
+		dev->vdev[i].v4l2_dev = &dev->v4l2_dev;
+		video_set_drvdata(&dev->vdev[i], dev);
 		if (video_nr == -1)
 			ret = video_register_device(&dev->vdev[i],
 						    VFL_TYPE_GRABBER,
@@ -1974,13 +1972,12 @@
 			ret = video_register_device(&dev->vdev[i],
 						    VFL_TYPE_GRABBER,
 						    cur_nr + i);
-		video_set_drvdata(&dev->vdev[i], dev);
 		if (ret) {
 			dev_err(&dev->udev->dev,
 				"failed to register video device!\n");
 			break;
 		}
-		dev->channels++;
+		atomic_inc(&dev->channels);
 		v4l2_info(&dev->v4l2_dev, "V4L2 device registered as %s\n",
 			  video_device_node_name(&dev->vdev[i]));
 
@@ -1989,11 +1986,11 @@
 	       S2255_MAJOR_VERSION,
 	       S2255_MINOR_VERSION);
 	/* if no channels registered, return error and probe will fail*/
-	if (dev->channels == 0) {
+	if (atomic_read(&dev->channels) == 0) {
 		v4l2_device_unregister(&dev->v4l2_dev);
 		return ret;
 	}
-	if (dev->channels != MAX_CHANNELS)
+	if (atomic_read(&dev->channels) != MAX_CHANNELS)
 		printk(KERN_WARNING "s2255: Not all channels available.\n");
 	return 0;
 }
@@ -2566,7 +2563,7 @@
 		s2255_dev_err(&interface->dev, "out of memory\n");
 		return -ENOMEM;
 	}
-	kref_init(&dev->kref);
+	atomic_set(&dev->channels, 0);
 	dev->pid = id->idProduct;
 	dev->fw_data = kzalloc(sizeof(struct s2255_fw), GFP_KERNEL);
 	if (!dev->fw_data)
@@ -2580,7 +2577,7 @@
 		retval = -ENODEV;
 		goto errorUDEV;
 	}
-	dprintk(1, "dev: %p, kref: %p udev %p interface %p\n", dev, &dev->kref,
+	dprintk(1, "dev: %p, udev %p interface %p\n", dev,
 		dev->udev, interface);
 	dev->interface = interface;
 	/* set up the endpoint information  */
@@ -2651,9 +2648,6 @@
 		goto errorBOARDINIT;
 	spin_lock_init(&dev->slock);
 	s2255_fwload_start(dev, 0);
-	/* kref for each vdev. Released on video_device_release callback */
-	for (i = 0; i < MAX_CHANNELS; i++)
-		kref_get(&dev->kref);
 	/* loads v4l specific */
 	retval = s2255_probe_v4l(dev);
 	if (retval)
@@ -2687,11 +2681,15 @@
 {
 	struct s2255_dev *dev = to_s2255_dev(usb_get_intfdata(interface));
 	int i;
+	int channels = atomic_read(&dev->channels);
 	v4l2_device_unregister(&dev->v4l2_dev);
+	/*see comments in the uvc_driver.c usb disconnect function */
+	atomic_inc(&dev->channels);
 	/* unregister each video device. */
-	for (i = 0; i < MAX_CHANNELS; i++)
+	for (i = 0; i < channels; i++) {
 		if (video_is_registered(&dev->vdev[i]))
 			video_unregister_device(&dev->vdev[i]);
+	}
 	/* wake up any of our timers */
 	atomic_set(&dev->fw_data->fw_state, S2255_FW_DISCONNECTING);
 	wake_up(&dev->fw_data->wait_fw);
@@ -2701,7 +2699,8 @@
 		dev->vidstatus_ready[i] = 1;
 		wake_up(&dev->wait_vidstatus[i]);
 	}
-	kref_put(&dev->kref, s2255_destroy);
+	if (atomic_dec_and_test(&dev->channels))
+		s2255_destroy(dev);
 	dev_info(&interface->dev, "%s\n", __func__);
 }
 

