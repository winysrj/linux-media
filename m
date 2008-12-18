Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mBI0AJqw031053
	for <video4linux-list@redhat.com>; Wed, 17 Dec 2008 19:10:20 -0500
Received: from smtp-vbr1.xs4all.nl (smtp-vbr1.xs4all.nl [194.109.24.21])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mBI0A3CO012712
	for <video4linux-list@redhat.com>; Wed, 17 Dec 2008 19:10:03 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Laurent Pinchart <laurent.pinchart@skynet.be>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Date: Thu, 18 Dec 2008 01:09:51 +0100
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_PTZSJTpKYq+ysRa"
Message-Id: <200812180109.51813.hverkuil@xs4all.nl>
Cc: v4l <video4linux-list@redhat.com>
Subject: Please test: using the device release() callback instead of the
	cdev release
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

--Boundary-00=_PTZSJTpKYq+ysRa
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi all,

My tree http://linuxtv.org/hg/~hverkuil/v4l-dvb drops the cdev release code 
in favor of using the refcounting and release callback from the device 
struct. Based on the discussion on the kernel list regarding the use of 
cdev refcounting it became clear that that was not the right solution, 
hence this change.

In combination with the cdev fix posted earlier in the cdev thread I am 
unable to force any races or oopses. I've tested with the uvc driver 
(bought a uvc webcam :-) ) in combination with Laurent's UVC patch 
(attached to this mail).

What's particularly nice is that if an app has /dev/video0 open and you 
disconnect followed by a reconnect, then this newly probed device ends up 
at /dev/video1 since internally /dev/video0 is still in use even though the 
actual device node has been removed already. That's the way it should work, 
so this looks very promising.

The only disadvantage of my change is that struct video_device gets a copy 
of the file_operations struct since I need to override the open and release 
to do the refcounting. In the future we can do this much more elegant but I 
don't want to make changes to drivers right now.

I'd appreciate it people can test it and if the change I made in v4l2-dev.c 
can be reviewed. It's not a big patch, but it's tricky code at the core of 
v4l. Basically you should see no difference at all in the behavior of 
drivers. It would be very nice as well if someone can test it on a 2.6.18 
kernel or older. It compiles, but I've no idea whether it also works...

Regards,

	Hans

PS: For those who missed it, this is my patch to fix a race condition in 
fs/char_dev.c:

--- fs/char_dev.c.orig  2008-12-17 20:28:40.000000000 +0100
+++ fs/char_dev.c       2008-12-17 20:28:49.000000000 +0100
@@ -345,7 +345,9 @@
 {
        if (p) {
                struct module *owner = p->owner;
+               spin_lock(&cdev_lock);
                kobject_put(&p->kobj);
+               spin_unlock(&cdev_lock);
                module_put(owner);
        }
 }
@@ -415,14 +417,12 @@
 
 static void cdev_purge(struct cdev *cdev)
 {
-       spin_lock(&cdev_lock);
        while (!list_empty(&cdev->list)) {
                struct inode *inode;
                inode = container_of(cdev->list.next, struct inode, 
i_devices);
                list_del_init(&inode->i_devices);
                inode->i_cdev = NULL;
        }
-       spin_unlock(&cdev_lock);
 }
 
 /*
@@ -478,7 +478,9 @@
 void cdev_del(struct cdev *p)
 {
        cdev_unmap(p->dev, p->count);
+       spin_lock(&cdev_lock);
        kobject_put(&p->kobj);
+       spin_unlock(&cdev_lock);
 }


-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG

--Boundary-00=_PTZSJTpKYq+ysRa
Content-Type: text/x-diff;
  charset="utf-8";
  name="uvc.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="uvc.diff"

diff -r c81af7a1a20a linux/drivers/media/video/uvc/uvc_driver.c
--- a/linux/drivers/media/video/uvc/uvc_driver.c	Tue Dec 16 12:32:37 2008 +0100
+++ b/linux/drivers/media/video/uvc/uvc_driver.c	Thu Dec 18 00:00:52 2008 +0100
@@ -1169,20 +1169,6 @@
  */
 
 /*
- * Unregister the video devices.
- */
-static void uvc_unregister_video(struct uvc_device *dev)
-{
-	if (dev->video.vdev) {
-		if (dev->video.vdev->minor == -1)
-			video_device_release(dev->video.vdev);
-		else
-			video_unregister_device(dev->video.vdev);
-		dev->video.vdev = NULL;
-	}
-}
-
-/*
  * Scan the UVC descriptors to locate a chain starting at an Output Terminal
  * and containing the following units:
  *
@@ -1398,6 +1384,64 @@
 }
 
 /*
+ * Delete the UVC device.
+ *
+ * Called by the kernel when the last reference to the V4L2 device (and thus
+ * the uvc_device structure) is released.
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
+	list_for_each_safe(p, n, &dev->entities) {
+		struct uvc_entity *entity;
+		entity = list_entry(p, struct uvc_entity, list);
+		kfree(entity);
+	}
+
+	list_for_each_safe(p, n, &dev->streaming) {
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
+	struct uvc_video_device *video = video_get_drvdata(vdev);
+	struct uvc_device *dev = video->dev;
+
+	video_device_release(vdev);
+	uvc_delete(dev);
+}
+
+/*
+ * Unregister the video devices.
+ */
+static void uvc_unregister_video(struct uvc_device *dev)
+{
+	video_unregister_device(dev->video.vdev);
+	dev->video.vdev = NULL;
+}
+
+/*
  * Register the video devices.
  *
  * The driver currently supports a single video device per control interface
@@ -1480,7 +1524,7 @@
 	vdev->parent = &dev->intf->dev;
 	vdev->minor = -1;
 	vdev->fops = &uvc_fops;
-	vdev->release = video_device_release;
+	vdev->release = uvc_release;
 	strncpy(vdev->name, dev->name, sizeof vdev->name);
 
 	/* Set the driver data before calling video_register_device, otherwise
@@ -1500,55 +1544,6 @@
 	}
 
 	return 0;
-}
-
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
-	/* Unregister the video device */
-	uvc_unregister_video(dev);
-	usb_put_intf(dev->intf);
-	usb_put_dev(dev->udev);
-
-	uvc_status_cleanup(dev);
-	uvc_ctrl_cleanup_device(dev);
-
-	list_for_each_safe(p, n, &dev->entities) {
-		struct uvc_entity *entity;
-		entity = list_entry(p, struct uvc_entity, list);
-		kfree(entity);
-	}
-
-	list_for_each_safe(p, n, &dev->streaming) {
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
 }
 
 static int uvc_probe(struct usb_interface *intf,
@@ -1572,7 +1567,6 @@
 
 	INIT_LIST_HEAD(&dev->entities);
 	INIT_LIST_HEAD(&dev->streaming);
-	kref_init(&dev->kref);
 
 	dev->udev = usb_get_dev(udev);
 	dev->intf = usb_get_intf(intf);
@@ -1629,7 +1623,7 @@
 	return 0;
 
 error:
-	kref_put(&dev->kref, uvc_delete);
+	uvc_delete(dev);
 	return -ENODEV;
 }
 
@@ -1645,21 +1639,9 @@
 	if (intf->cur_altsetting->desc.bInterfaceSubClass == SC_VIDEOSTREAMING)
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
diff -r c81af7a1a20a linux/drivers/media/video/uvc/uvc_v4l2.c
--- a/linux/drivers/media/video/uvc/uvc_v4l2.c	Tue Dec 16 12:32:37 2008 +0100
+++ b/linux/drivers/media/video/uvc/uvc_v4l2.c	Thu Dec 18 00:00:52 2008 +0100
@@ -398,7 +398,6 @@
 	int ret = 0;
 
 	uvc_trace(UVC_TRACE_CALLS, "uvc_v4l2_open\n");
-	mutex_lock(&uvc_driver.open_mutex);
 	video = video_drvdata(file);
 
 	if (video->dev->state & UVC_DEV_DISCONNECTED) {
@@ -426,10 +425,7 @@
 	handle->state = UVC_HANDLE_PASSIVE;
 	file->private_data = handle;
 
-	kref_get(&video->dev->kref);
-
 done:
-	mutex_unlock(&uvc_driver.open_mutex);
 	return ret;
 }
 
@@ -459,7 +455,6 @@
 #if LINUX_VERSION_CODE >= KERNEL_VERSION(2, 6, 19)
 	usb_autopm_put_interface(video->dev->intf);
 #endif
-	kref_put(&video->dev->kref, uvc_delete);
 	return 0;
 }
 
diff -r c81af7a1a20a linux/drivers/media/video/uvc/uvcvideo.h
--- a/linux/drivers/media/video/uvc/uvcvideo.h	Tue Dec 16 12:32:37 2008 +0100
+++ b/linux/drivers/media/video/uvc/uvcvideo.h	Thu Dec 18 00:00:52 2008 +0100
@@ -624,7 +624,6 @@
 	char name[32];
 
 	enum uvc_device_state state;
-	struct kref kref;
 	struct list_head list;
 
 	/* Video control interface */
@@ -718,7 +717,6 @@
 
 /* Core driver */
 extern struct uvc_driver uvc_driver;
-extern void uvc_delete(struct kref *kref);
 
 /* Video buffers queue management. */
 extern void uvc_queue_init(struct uvc_video_queue *queue);

--Boundary-00=_PTZSJTpKYq+ysRa
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
--Boundary-00=_PTZSJTpKYq+ysRa--
