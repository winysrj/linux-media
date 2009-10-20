Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailrelay009.isp.belgacom.be ([195.238.6.176]:43881 "EHLO
	mailrelay009.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751339AbZJTIO6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 20 Oct 2009 04:14:58 -0400
Message-Id: <20091020011215.937017164@ideasonboard.com>
Date: Tue, 20 Oct 2009 03:12:23 +0200
From: laurent.pinchart@ideasonboard.com
To: linux-media@vger.kernel.org
Cc: sakari.ailus@maxwell.research.nokia.com, hverkuil@xs4all.nl,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: [RFC/PATCH 13/14] uvcvideo: Register a v4l2_device
References: <20091020011210.623421213@ideasonboard.com>
Content-Disposition: inline; filename=uvc-v4l2-device.diff
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As a first step to the media controller integration register a
v4l2_device for each UVC control interface and make the video_device a
child of the v4l2_device.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

Index: v4l-dvb-mc/linux/drivers/media/video/uvc/uvc_driver.c
===================================================================
--- v4l-dvb-mc.orig/linux/drivers/media/video/uvc/uvc_driver.c
+++ v4l-dvb-mc/linux/drivers/media/video/uvc/uvc_driver.c
@@ -1544,6 +1544,9 @@ static void uvc_delete(struct uvc_device
 	uvc_status_cleanup(dev);
 	uvc_ctrl_cleanup_device(dev);
 
+	if (dev->vdev.name[0])
+		v4l2_device_unregister(&dev->vdev);
+
 	list_for_each_safe(p, n, &dev->chains) {
 		struct uvc_video_chain *chain;
 		chain = list_entry(p, struct uvc_video_chain, list);
@@ -1641,7 +1644,7 @@ static int uvc_register_video(struct uvc
 	 * unregistered before the reference is released, so we don't need to
 	 * get another one.
 	 */
-	vdev->parent = &dev->intf->dev;
+	vdev->entity.parent = &dev->vdev;
 	vdev->minor = -1;
 	vdev->fops = &uvc_fops;
 	vdev->release = uvc_release;
@@ -1772,6 +1775,10 @@ static int uvc_probe(struct usb_interfac
 			"linux-uvc-devel mailing list.\n");
 	}
 
+	/* Register the V4L2 device. */
+	if (v4l2_device_register(&intf->dev, &dev->vdev) < 0)
+		goto error;
+
 	/* Initialize controls. */
 	if (uvc_ctrl_init_device(dev) < 0)
 		goto error;
@@ -1780,7 +1787,7 @@ static int uvc_probe(struct usb_interfac
 	if (uvc_scan_device(dev) < 0)
 		goto error;
 
-	/* Register video devices. */
+	/* Register video device nodes. */
 	if (uvc_register_chains(dev) < 0)
 		goto error;
 
Index: v4l-dvb-mc/linux/drivers/media/video/uvc/uvcvideo.h
===================================================================
--- v4l-dvb-mc.orig/linux/drivers/media/video/uvc/uvcvideo.h
+++ v4l-dvb-mc/linux/drivers/media/video/uvc/uvcvideo.h
@@ -68,6 +68,7 @@ struct uvc_xu_control {
 
 #include <linux/poll.h>
 #include <linux/usb/video.h>
+#include <media/v4l2-device.h>
 #include "compat.h"
 
 /* --------------------------------------------------------------------------
@@ -476,6 +477,7 @@ struct uvc_device {
 	atomic_t users;
 
 	/* Video control interface */
+	struct v4l2_device vdev;
 	__u16 uvc_version;
 	__u32 clock_frequency;
 


