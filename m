Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailrelay009.isp.belgacom.be ([195.238.6.176]:43921 "EHLO
	mailrelay009.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751320AbZJTIOz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 20 Oct 2009 04:14:55 -0400
Message-Id: <20091020011215.443876368@ideasonboard.com>
Date: Tue, 20 Oct 2009 03:12:18 +0200
From: laurent.pinchart@ideasonboard.com
To: linux-media@vger.kernel.org
Cc: sakari.ailus@maxwell.research.nokia.com, hverkuil@xs4all.nl,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: [RFC/PATCH 08/14] uvcvideo: Rely on videodev to reference-count the device
References: <20091020011210.623421213@ideasonboard.com>
Content-Disposition: inline; filename=uvc-faba04f47c9b.diff
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The uvcvideo driver has a driver-wide lock and a reference count to protect
against a disconnect/open race. Now that videodev handles the race itself,
reference-counting in the driver can be removed.

This is a backport from the v4l-dvb tree.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

--- a/linux/drivers/media/video/uvc/uvc_driver.c	Wed Sep 02 08:12:26 2009 +0200
+++ b/linux/drivers/media/video/uvc/uvc_driver.c	Wed Sep 30 02:07:19 2009 +0200
@@ -1531,22 +1531,92 @@
  */
 
 /*
+ * Delete the UVC device.
+ *
+ * Called by the kernel when the last reference to the uvc_device structure
+ * is released.
+ *
+ * As this function is called after or during disconnect(), all URBs have
+ * already been canceled by the USB core. There is no need to kill the
+ * interrupt URB manually.
+ */
+static void uvc_delete(struct uvc_device *dev)
+{
+	struct list_head *p, *n;
+
+	usb_put_intf(dev->intf);
+	usb_put_dev(dev->udev);
+
+	uvc_status_cleanup(dev);
+	uvc_ctrl_cleanup_device(dev);
+
+	list_for_each_safe(p, n, &dev->chains) {
+		struct uvc_video_chain *chain;
+		chain = list_entry(p, struct uvc_video_chain, list);
+		kfree(chain);
+	}
+
+	list_for_each_safe(p, n, &dev->entities) {
+		struct uvc_entity *entity;
+		entity = list_entry(p, struct uvc_entity, list);
+		kfree(entity);
+	}
+
+	list_for_each_safe(p, n, &dev->streams) {
+		struct uvc_streaming *streaming;
+		streaming = list_entry(p, struct uvc_streaming, list);
+		usb_driver_release_interface(&uvc_driver.driver,
+			streaming->intf);
+		usb_put_intf(streaming->intf);
+		kfree(streaming->format);
+		kfree(streaming->header.bmaControls);
+		kfree(streaming);
+	}
+
+	kfree(dev);
+}
+
+static void uvc_release(struct video_device *vdev)
+{
+	struct uvc_streaming *stream = video_get_drvdata(vdev);
+	struct uvc_device *dev = stream->dev;
+
+	video_device_release(vdev);
+
+	/* Decrement the registered streams count and delete the device when it
+	 * reaches zero.
+	 */
+	if (atomic_dec_and_test(&dev->nstreams))
+		uvc_delete(dev);
+}
+
+/*
  * Unregister the video devices.
  */
 static void uvc_unregister_video(struct uvc_device *dev)
 {
 	struct uvc_streaming *stream;
 
+	/* Unregistering all video devices might result in uvc_delete() being
+	 * called from inside the loop if there's no open file handle. To avoid
+	 * that, increment the stream count before iterating over the streams
+	 * and decrement it when done.
+	 */
+	atomic_inc(&dev->nstreams);
+
 	list_for_each_entry(stream, &dev->streams, list) {
 		if (stream->vdev == NULL)
 			continue;
 
-		if (stream->vdev->minor == -1)
-			video_device_release(stream->vdev);
-		else
-			video_unregister_device(stream->vdev);
+		video_unregister_device(stream->vdev);
 		stream->vdev = NULL;
 	}
+
+	/* Decrement the stream count and call uvc_delete explicitly if there
+	 * are no stream left.
+	 */
+	if (atomic_dec_and_test(&dev->nstreams))
+		uvc_delete(dev);
 }
 
 static int uvc_register_video(struct uvc_device *dev,
@@ -1580,7 +1650,7 @@
 	vdev->parent = &dev->intf->dev;
 	vdev->minor = -1;
 	vdev->fops = &uvc_fops;
-	vdev->release = video_device_release;
+	vdev->release = uvc_release;
 	strlcpy(vdev->name, dev->name, sizeof vdev->name);
 
 	/* Set the driver data before calling video_register_device, otherwise
@@ -1598,6 +1668,7 @@
 		return ret;
 	}
 
+	atomic_inc(&dev->nstreams);
 	return 0;
 }
 
@@ -1653,61 +1724,6 @@
  * USB probe, disconnect, suspend and resume
  */
 
-/*
- * Delete the UVC device.
- *
- * Called by the kernel when the last reference to the uvc_device structure
- * is released.
- *
- * Unregistering the video devices is done here because every opened instance
- * must be closed before the device can be unregistered. An alternative would
- * have been to use another reference count for uvc_v4l2_open/uvc_release, and
- * unregister the video devices on disconnect when that reference count drops
- * to zero.
- *
- * As this function is called after or during disconnect(), all URBs have
- * already been canceled by the USB core. There is no need to kill the
- * interrupt URB manually.
- */
-void uvc_delete(struct kref *kref)
-{
-	struct uvc_device *dev = container_of(kref, struct uvc_device, kref);
-	struct list_head *p, *n;
-
-	/* Unregister the video devices. */
-	uvc_unregister_video(dev);
-	usb_put_intf(dev->intf);
-	usb_put_dev(dev->udev);
-
-	uvc_status_cleanup(dev);
-	uvc_ctrl_cleanup_device(dev);
-
-	list_for_each_safe(p, n, &dev->chains) {
-		struct uvc_video_chain *chain;
-		chain = list_entry(p, struct uvc_video_chain, list);
-		kfree(chain);
-	}
-
-	list_for_each_safe(p, n, &dev->entities) {
-		struct uvc_entity *entity;
-		entity = list_entry(p, struct uvc_entity, list);
-		kfree(entity);
-	}
-
-	list_for_each_safe(p, n, &dev->streams) {
-		struct uvc_streaming *streaming;
-		streaming = list_entry(p, struct uvc_streaming, list);
-		usb_driver_release_interface(&uvc_driver.driver,
-			streaming->intf);
-		usb_put_intf(streaming->intf);
-		kfree(streaming->format);
-		kfree(streaming->header.bmaControls);
-		kfree(streaming);
-	}
-
-	kfree(dev);
-}
-
 static int uvc_probe(struct usb_interface *intf,
 		     const struct usb_device_id *id)
 {
@@ -1730,7 +1746,7 @@
 	INIT_LIST_HEAD(&dev->entities);
 	INIT_LIST_HEAD(&dev->chains);
 	INIT_LIST_HEAD(&dev->streams);
-	kref_init(&dev->kref);
+	atomic_set(&dev->nstreams, 0);
 	atomic_set(&dev->users, 0);
 
 	dev->udev = usb_get_dev(udev);
@@ -1792,7 +1808,7 @@
 	return 0;
 
 error:
-	kref_put(&dev->kref, uvc_delete);
+	uvc_unregister_video(dev);
 	return -ENODEV;
 }
 
@@ -1809,21 +1825,9 @@
 	    UVC_SC_VIDEOSTREAMING)
 		return;
 
-	/* uvc_v4l2_open() might race uvc_disconnect(). A static driver-wide
-	 * lock is needed to prevent uvc_disconnect from releasing its
-	 * reference to the uvc_device instance after uvc_v4l2_open() received
-	 * the pointer to the device (video_devdata) but before it got the
-	 * chance to increase the reference count (kref_get).
-	 *
-	 * Note that the reference can't be released with the lock held,
-	 * otherwise a AB-BA deadlock can occur with videodev_lock that
-	 * videodev acquires in videodev_open() and video_unregister_device().
-	 */
-	mutex_lock(&uvc_driver.open_mutex);
 	dev->state |= UVC_DEV_DISCONNECTED;
-	mutex_unlock(&uvc_driver.open_mutex);
 
-	kref_put(&dev->kref, uvc_delete);
+	uvc_unregister_video(dev);
 }
 
 static int uvc_suspend(struct usb_interface *intf, pm_message_t message)
@@ -2165,7 +2169,6 @@
 
 	INIT_LIST_HEAD(&uvc_driver.devices);
 	INIT_LIST_HEAD(&uvc_driver.controls);
-	mutex_init(&uvc_driver.open_mutex);
 	mutex_init(&uvc_driver.ctrl_mutex);
 
 	uvc_ctrl_init();
--- a/linux/drivers/media/video/uvc/uvc_v4l2.c	Wed Sep 02 08:12:26 2009 +0200
+++ b/linux/drivers/media/video/uvc/uvc_v4l2.c	Wed Sep 30 02:07:19 2009 +0200
@@ -376,25 +376,18 @@
  */
 static int uvc_acquire_privileges(struct uvc_fh *handle)
 {
-	int ret = 0;
-
 	/* Always succeed if the handle is already privileged. */
 	if (handle->state == UVC_HANDLE_ACTIVE)
 		return 0;
 
 	/* Check if the device already has a privileged handle. */
-	mutex_lock(&uvc_driver.open_mutex);
 	if (atomic_inc_return(&handle->stream->active) != 1) {
 		atomic_dec(&handle->stream->active);
-		ret = -EBUSY;
-		goto done;
+		return -EBUSY;
 	}
 
 	handle->state = UVC_HANDLE_ACTIVE;
-
-done:
-	mutex_unlock(&uvc_driver.open_mutex);
-	return ret;
+	return 0;
 }
 
 static void uvc_dismiss_privileges(struct uvc_fh *handle)
@@ -421,18 +414,15 @@
 	int ret = 0;
 
 	uvc_trace(UVC_TRACE_CALLS, "uvc_v4l2_open\n");
-	mutex_lock(&uvc_driver.open_mutex);
 	stream = video_drvdata(file);
 
-	if (stream->dev->state & UVC_DEV_DISCONNECTED) {
-		ret = -ENODEV;
-		goto done;
-	}
+	if (stream->dev->state & UVC_DEV_DISCONNECTED)
+		return -ENODEV;
 
 #if LINUX_VERSION_CODE >= KERNEL_VERSION(2, 6, 19)
 	ret = usb_autopm_get_interface(stream->dev->intf);
 	if (ret < 0)
-		goto done;
+		return ret;
 #endif
 
 	/* Create the device handle. */
@@ -441,8 +431,7 @@
 #if LINUX_VERSION_CODE >= KERNEL_VERSION(2, 6, 19)
 		usb_autopm_put_interface(stream->dev->intf);
 #endif
-		ret = -ENOMEM;
-		goto done;
+		return -ENOMEM;
 	}
 
 	if (atomic_inc_return(&stream->dev->users) == 1) {
@@ -453,7 +442,7 @@
 #endif
 			atomic_dec(&stream->dev->users);
 			kfree(handle);
-			goto done;
+			return ret;
 		}
 	}
 
@@ -462,11 +451,7 @@
 	handle->state = UVC_HANDLE_PASSIVE;
 	file->private_data = handle;
 
-	kref_get(&stream->dev->kref);
-
-done:
-	mutex_unlock(&uvc_driver.open_mutex);
-	return ret;
+	return 0;
 }
 
 static int uvc_v4l2_release(struct file *file)
@@ -498,7 +483,6 @@
 #if LINUX_VERSION_CODE >= KERNEL_VERSION(2, 6, 19)
 	usb_autopm_put_interface(stream->dev->intf);
 #endif
-	kref_put(&stream->dev->kref, uvc_delete);
 	return 0;
 }
 
--- a/linux/drivers/media/video/uvc/uvcvideo.h	Wed Sep 02 08:12:26 2009 +0200
+++ b/linux/drivers/media/video/uvc/uvcvideo.h	Wed Sep 30 02:07:19 2009 +0200
@@ -476,7 +476,6 @@
 	char name[32];
 
 	enum uvc_device_state state;
-	struct kref kref;
 	struct list_head list;
 	atomic_t users;
 
@@ -489,6 +488,7 @@
 
 	/* Video Streaming interfaces */
 	struct list_head streams;
+	atomic_t nstreams;
 
 	/* Status Interrupt Endpoint */
 	struct usb_host_endpoint *int_ep;
@@ -512,8 +512,6 @@
 struct uvc_driver {
 	struct usb_driver driver;
 
-	struct mutex open_mutex;	/* protects from open/disconnect race */
-
 	struct list_head devices;	/* struct uvc_device list */
 	struct list_head controls;	/* struct uvc_control_info list */
 	struct mutex ctrl_mutex;	/* protects controls and devices
@@ -572,7 +570,6 @@
 
 /* Core driver */
 extern struct uvc_driver uvc_driver;
-extern void uvc_delete(struct kref *kref);
 
 /* Video buffers queue management. */
 extern void uvc_queue_init(struct uvc_video_queue *queue,



