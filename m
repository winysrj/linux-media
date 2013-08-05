Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-1.atlantis.sk ([80.94.52.57]:41321 "EHLO
	mail-1.atlantis.sk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754432Ab3HEVUO (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 5 Aug 2013 17:20:14 -0400
From: Ondrej Zary <linux@rainbow-software.org>
To: linux-media@vger.kernel.org
Subject: Syntek webcams and out-of-tree driver
Date: Mon, 5 Aug 2013 23:19:26 +0200
Cc: Jaime Velasco Juan <jsagarribay@gmail.com>,
	syntekdriver-devel@lists.sourceforge.net
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201308052319.26720.linux@rainbow-software.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,
the in-kernel stkwebcam driver (by Jaime Velasco Juan and Nicolas VIVIEN)
supports only two webcam types (USB IDs 0x174f:0xa311 and 0x05e1:0x0501).
There are many other Syntek webcam types that are not supported by this
driver (such as 0x174f:0x6a31 in Asus F5RL laptop).

There is an out-of-tree GPL driver called stk11xx (by Martin Roos and also
Nicolas VIVIEN) at http://sourceforge.net/projects/syntekdriver/ which
supports more webcams. It can be even compiled for the latest kernels using
the patch below and seems to work somehow (slow and buggy but better than
nothing) with the Asus F5RL.

Is there any possibility that this driver could be merged into the kernel?
The code could probably be simplified a lot and integrated into gspca.


diff -urp syntekdriver-code-107-trunk-orig/driver/stk11xx.h syntekdriver-code-107-trunk//driver/stk11xx.h
--- syntekdriver-code-107-trunk-orig/driver/stk11xx.h	2012-03-10 10:03:12.000000000 +0100
+++ syntekdriver-code-107-trunk//driver/stk11xx.h	2013-08-05 22:50:00.000000000 +0200
@@ -33,6 +33,7 @@
 
 #ifndef STK11XX_H
 #define STK11XX_H
+#include <media/v4l2-device.h>
 
 #define DRIVER_NAME					"stk11xx"					/**< Name of this driver */
 #define DRIVER_VERSION				"v3.0.0"					/**< Version of this driver */
@@ -316,6 +317,7 @@ struct stk11xx_video {
  * @struct usb_stk11xx
  */
 struct usb_stk11xx {
+	struct v4l2_device v4l2_dev;
 	struct video_device *vdev; 			/**< Pointer on a V4L2 video device */
 	struct usb_device *udev;			/**< Pointer on a USB device */
 	struct usb_interface *interface;	/**< Pointer on a USB interface */
diff -urp syntekdriver-code-107-trunk-orig/driver/stk11xx-v4l.c syntekdriver-code-107-trunk//driver/stk11xx-v4l.c
--- syntekdriver-code-107-trunk-orig/driver/stk11xx-v4l.c	2012-03-10 09:54:57.000000000 +0100
+++ syntekdriver-code-107-trunk//driver/stk11xx-v4l.c	2013-08-05 22:51:12.000000000 +0200
@@ -1498,9 +1498,17 @@ int v4l_stk11xx_register_video_device(st
 {
 	int err;
 
+	err = v4l2_device_register(&dev->interface->dev, &dev->v4l2_dev);
+	if (err < 0) {
+		STK_ERROR("couldn't register v4l2_device\n");
+		kfree(dev);
+		return err;
+	}
+
 	strcpy(dev->vdev->name, DRIVER_DESC);
 
-	dev->vdev->parent = &dev->interface->dev;
+//	dev->vdev->parent = &dev->interface->dev;
+	dev->vdev->v4l2_dev = &dev->v4l2_dev;
 	dev->vdev->fops = &v4l_stk11xx_fops;
 	dev->vdev->release = video_device_release;
 	dev->vdev->minor = -1;
@@ -1533,6 +1541,7 @@ int v4l_stk11xx_unregister_video_device(
 
 	video_set_drvdata(dev->vdev, NULL);
 	video_unregister_device(dev->vdev);
+	v4l2_device_unregister(&dev->v4l2_dev);
 
 	return 0;
 }



-- 
Ondrej Zary
