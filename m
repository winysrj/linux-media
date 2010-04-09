Return-path: <linux-media-owner@vger.kernel.org>
Received: from gateway16.websitewelcome.com ([69.93.243.5]:46809 "HELO
	gateway16.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751506Ab0DIWHe (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 9 Apr 2010 18:07:34 -0400
Date: Fri, 9 Apr 2010 15:00:51 -0700 (PDT)
From: sensoray-dev <linux-dev@sensoray.com>
Subject: [PATCH] s2255drv: v4l2_dev bug fix
To: linux-media@vger.kernel.org
cc: mchehab@infradead.org, hverkuil@xs4all.nl, linux-dev@sensoray.com
Message-ID: <tkrat.ce8ce4f2513d3312@sensoray.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

# HG changeset patch
# User Dean Anderson <linux-dev@sensoray.com>
# Date 1270850190 25200
# Node ID 040de984898870b01dfe553319aa18edb3a442bb
# Parent  f987f637d904a281992844f2b17f805edd4734c2
s2255drv: v4l2_dev fixed

From: Dean Anderson <linux-dev@sensoray.com>

v4l2_dev should be registered once only.
usb_set_intfdata should not be used when using v4l2_device_register
and a non-NULL argument for the device.

Priority: high

Signed-off-by: Dean Anderson <linux-dev@sensoray.com>

diff -r f987f637d904 -r 040de9848988 linux/drivers/media/video/s2255drv.c
--- a/linux/drivers/media/video/s2255drv.c	Fri Apr 09 14:28:44 2010 -0700
+++ b/linux/drivers/media/video/s2255drv.c	Fri Apr 09 14:56:30 2010 -0700
@@ -229,7 +229,7 @@
 
 struct s2255_dev {
 	struct video_device	vdev[MAX_CHANNELS];
-	struct v4l2_device 	v4l2_dev[MAX_CHANNELS];
+	struct v4l2_device 	v4l2_dev;
 	int                     channels; /* number of channels registered */
 	int			frames;
 	struct mutex		lock;
@@ -278,7 +278,14 @@
 	u16                     pid; /* product id */
 	struct kref		kref;
 };
-#define to_s2255_dev(d) container_of(d, struct s2255_dev, kref)
+
+/* kref will be removed soon */
+#define to_s2255_dev_from_kref(d) container_of(d, struct s2255_dev, kref)
+
+static inline struct s2255_dev *to_s2255_dev(struct v4l2_device *v4l2_dev)
+{
+	return container_of(v4l2_dev, struct s2255_dev, v4l2_dev);
+}
 
 struct s2255_fmt {
 	char *name;
@@ -1829,7 +1836,7 @@
 
 static void s2255_destroy(struct kref *kref)
 {
-	struct s2255_dev *dev = to_s2255_dev(kref);
+	struct s2255_dev *dev = to_s2255_dev_from_kref(kref);
 	/* board shutdown stops the read pipe if it is running */
 	s2255_board_shutdown(dev);
 	/* make sure firmware still not trying to load */
@@ -1947,11 +1954,9 @@
 	int ret;
 	int i;
 	int cur_nr = video_nr;
-	for (i = 0; i < MAX_CHANNELS; i++) {
-		ret = v4l2_device_register(&dev->udev->dev, &dev->v4l2_dev[i]);
-		if (ret)
-			goto unreg_v4l2;
-	}
+	ret = v4l2_device_register(&dev->interface->dev, &dev->v4l2_dev);
+	if (ret)
+		return ret;
 	/* initialize all video 4 linux */
 	/* register 4 video devices */
 	for (i = 0; i < MAX_CHANNELS; i++) {
@@ -1976,7 +1981,7 @@
 			break;
 		}
 		dev->channels++;
-		v4l2_info(&dev->v4l2_dev[i], "V4L2 device registered as %s\n",
+		v4l2_info(&dev->v4l2_dev, "V4L2 device registered as %s\n",
 			  video_device_node_name(&dev->vdev[i]));
 
 	}
@@ -1984,15 +1989,13 @@
 	       S2255_MAJOR_VERSION,
 	       S2255_MINOR_VERSION);
 	/* if no channels registered, return error and probe will fail*/
-	if (dev->channels == 0)
+	if (dev->channels == 0) {
+		v4l2_device_unregister(&dev->v4l2_dev);
 		return ret;
+	}
 	if (dev->channels != MAX_CHANNELS)
 		printk(KERN_WARNING "s2255: Not all channels available.\n");
 	return 0;
-unreg_v4l2:
-	for (i-- ; i > 0; i--)
-		v4l2_device_unregister(&dev->v4l2_dev[i]);
-	return ret;
 }
 
 /* this function moves the usb stream read pipe data
@@ -2595,8 +2598,6 @@
 		dev_err(&interface->dev, "Could not find bulk-in endpoint\n");
 		goto errorEP;
 	}
-	/* set intfdata */
-	usb_set_intfdata(interface, dev);
 	init_timer(&dev->timer);
 	dev->timer.function = s2255_timer;
 	dev->timer.data = (unsigned long)dev->fw_data;
@@ -2681,13 +2682,12 @@
 	return retval;
 }
 
-
 /* disconnect routine. when board is removed physically or with rmmod */
 static void s2255_disconnect(struct usb_interface *interface)
 {
-	struct s2255_dev *dev = NULL;
+	struct s2255_dev *dev = to_s2255_dev(usb_get_intfdata(interface));
 	int i;
-	dev = usb_get_intfdata(interface);
+	v4l2_device_unregister(&dev->v4l2_dev);
 	/* unregister each video device. */
 	for (i = 0; i < MAX_CHANNELS; i++)
 		if (video_is_registered(&dev->vdev[i]))
@@ -2701,7 +2701,6 @@
 		dev->vidstatus_ready[i] = 1;
 		wake_up(&dev->wait_vidstatus[i]);
 	}
-	usb_set_intfdata(interface, NULL);
 	kref_put(&dev->kref, s2255_destroy);
 	dev_info(&interface->dev, "%s\n", __func__);
 }

