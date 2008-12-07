Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mB7CEQra020147
	for <video4linux-list@redhat.com>; Sun, 7 Dec 2008 07:14:26 -0500
Received: from mailrelay009.isp.belgacom.be (mailrelay009.isp.belgacom.be
	[195.238.6.176])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mB7CEDJ6023691
	for <video4linux-list@redhat.com>; Sun, 7 Dec 2008 07:14:13 -0500
From: Laurent Pinchart <laurent.pinchart@skynet.be>
To: v4l <video4linux-list@redhat.com>
Date: Sun, 7 Dec 2008 13:14:17 +0100
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_Z47OJ7Byqsvew74"
Message-Id: <200812071314.17267.laurent.pinchart@skynet.be>
Cc: 
Subject: [BUG] Race condition between open and disconnect
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

--Boundary-00=_Z47OJ7Byqsvew74
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi everybody,

I'm afraid to report that the move to the cdev interface in 2.6.28 has 
introduced a race condition between open and disconnect.

To avoid the need of a reference count in every v4l2 driver, v4l2 moved to 
cdev which includes its own reference counting infrastructure based on 
kobject.

kobject_(get|put) calls on which the reference counting code relies 
(kobject_get being called by cdev_get in chrdev_open, and kobject_put being 
called by device_unregister in video_device_unregister) call use the embedded 
kref_(get|put). Unfortunately, while those calls use atomic operations to 
access the reference counter, they are not thread-safe. A call to kref_get 
can succeed even though a call to kref_put has released the last reference.

I've modified the UVC driver to remove the thread-safe reference counting that 
was supposed not to be required anymore with the move to cdev and added an 
msleep(3000) at the beginning of v4l2_chardev_release to make the race 
condition easier to reproduce (patch against my hg tree attached).

Steps to reproduce:

- load the uvcvideo module
- connect a UVC camera
- start any video application
- close the application
- disconnect the camera
- within 3 seconds of the disconnection, start the video application
- check dmesg for the bug report and enjoy


usb 2-1: USB disconnect, address 6
------------[ cut here ]------------
WARNING: at lib/kref.c:43 kref_get+0x1c/0x20()
Modules linked in: snd_usb_audio snd_usb_lib snd_rawmidi snd_hwdep uvcvideo 
videodev v4l2_compat_ioctl32 v4l1_compat radeon drm arc4 ecb 
ieee80211_crypt_tkip rfcomm l2cap hci_usb ipw2200 bluetooth ieee80211 r8169 
snd_intel8x0m ieee80211_crypt
Pid: 19247, comm: luvcview Not tainted 2.6.27 #36
 [<c011cd6f>] warn_on_slowpath+0x5f/0x90
 [<c01192bf>] try_to_wake_up+0xaf/0xc0
 [<c01806e7>] __d_lookup+0xf7/0x150
 [<c01d70e0>] xattr_lookup_poison+0x0/0xa0
 [<c01762c5>] do_lookup+0x65/0x1a0
 [<c018005c>] dput+0x1c/0x160
 [<c0178331>] __link_path_walk+0xb01/0xc90
 [<c025e6ac>] kref_get+0x1c/0x20
 [<c025d8ef>] kobject_get+0xf/0x20
 [<c01710c2>] cdev_get+0x22/0x90
 [<c01717c7>] chrdev_open+0x37/0x1e0
 [<c0171790>] chrdev_open+0x0/0x1e0
 [<c016ce24>] __dentry_open+0xd4/0x260the 
 [<c016cff5>] nameidata_to_filp+0x45/0x60
 [<c0179617>] do_filp_open+0x187/0x720
 [<c02a2488>] tty_write+0x1b8/0x1e0
 [<c016cbfe>] do_sys_open+0x4e/0xe0
 [<c016cd0c>] sys_open+0x2c/0x40
 [<c0103119>] sysenter_do_call+0x12/0x21
 [<c0440000>] pfkey_add+0x4f0/0x7f0
 =======================
---[ end trace 32937b1bc9a02398 ]---
------------[ cut here ]------------
kernel BUG at drivers/media/video/v4l2-dev.c:119!
invalid opcode: 0000 [#1] PREEMPT
Modules linked in: snd_usb_audio snd_usb_lib snd_rawmidi snd_hwdep uvcvideo 
videodev v4l2_compat_ioctl32 v4l1_compat radeon drm arc4 ecb 
ieee80211_crypt_tkip rfcomm l2cap hci_usb ipw2200 bluetooth ieee80211 r8169 
snd_intel8x0m ieee80211_crypt

Pid: 19247, comm: luvcview Tainted: G        W (2.6.27 #36)
EIP: 0060:[<f09d14e7>] EFLAGS: 00010202 CPU: 0
EIP is at v4l2_chardev_release+0x37/0x80 [videodev]
EAX: f09d8a90 EBX: ed069c00 ECX: 00000003 EDX: 00000000
ESI: ed069d20 EDI: 00000000 EBP: d836968c ESP: e9005e6c
 DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
Process luvcview (pid: 19247, ti=e9004000 task=e90f31a0 task.ti=e9004000)
Stack: ed069d20 f09d8a9c c025d896 ed069d3c c025d860 ffffffed c025e659 f0c0f500
       00000001 c017121d ed069d20 c0171887 ed2ddb40 00000006 ed2ddb40 d836968c
       00000000 c0171790 c016ce24 ef80d1c0 d7861760 ed2ddb40 e9005f10 00000026
Call Trace:
 [<c025d896>] kobject_release+0x36/0x80
 [<c025d860>] kobject_release+0x0/0x80
 [<c025e659>] kref_put+0x29/0x60
 [<c017121d>] cdev_put+0xd/0x20
 [<c0171887>] chrdev_open+0xf7/0x1e0
 [<c0171790>] chrdev_open+0x0/0x1e0
 [<c016ce24>] __dentry_open+0xd4/0x260
 [<c016cff5>] nameidata_to_filp+0x45/0x60
 [<c0179617>] do_filp_open+0x187/0x720
 [<c02a2488>] tty_write+0x1b8/0x1e0
 [<c016cbfe>] do_sys_open+0x4e/0xe0
 [<c016cd0c>] sys_open+0x2c/0x40
 [<c0103119>] sysenter_do_call+0x12/0x21
 [<c0440000>] pfkey_add+0x4f0/0x7f0
 =======================
Code: 0b 00 00 e8 cc 47 75 cf b8 90 8a 9d f0 e8 a2 8b a7 cf 8b 83 88 01 00 00 
3b 1c 85 00 8d 9d f0 74 0e b8 90 8a 9d f0 e8 99 8b a7 cf <0f> 0b eb fe 31 c9 
89 0c 85 00 8d 9d f0 8b 83 84 01 00 00 0f b7
EIP: [<f09d14e7>] v4l2_chardev_release+0x37/0x80 [videodev] SS:ESP 
0068:e9005e6c
---[ end trace 32937b1bc9a02398 ]---

Best regards,

Laurent Pinchart

--Boundary-00=_Z47OJ7Byqsvew74
Content-Type: text/x-diff;
  charset="us-ascii";
  name="race.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="race.diff"

diff -r 0f0594461ca5 linux/drivers/media/video/uvc/uvc_driver.c
--- a/linux/drivers/media/video/uvc/uvc_driver.c	Sat Dec 06 21:43:40 2008 +0100
+++ b/linux/drivers/media/video/uvc/uvc_driver.c	Sun Dec 07 13:09:06 2008 +0100
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
diff -r 0f0594461ca5 linux/drivers/media/video/uvc/uvc_v4l2.c
--- a/linux/drivers/media/video/uvc/uvc_v4l2.c	Sat Dec 06 21:43:40 2008 +0100
+++ b/linux/drivers/media/video/uvc/uvc_v4l2.c	Sun Dec 07 13:09:06 2008 +0100
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
 
diff -r 0f0594461ca5 linux/drivers/media/video/uvc/uvcvideo.h
--- a/linux/drivers/media/video/uvc/uvcvideo.h	Sat Dec 06 21:43:40 2008 +0100
+++ b/linux/drivers/media/video/uvc/uvcvideo.h	Sun Dec 07 13:09:06 2008 +0100
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
diff -r 0f0594461ca5 linux/drivers/media/video/v4l2-dev.c
--- a/linux/drivers/media/video/v4l2-dev.c	Sat Dec 06 21:43:40 2008 +0100
+++ b/linux/drivers/media/video/v4l2-dev.c	Sun Dec 07 13:09:06 2008 +0100
@@ -107,10 +107,12 @@
 EXPORT_SYMBOL(video_device_release_empty);
 
 /* Called when the last user of the character device is gone. */
+#include <linux/delay.h>
 static void v4l2_chardev_release(struct kobject *kobj)
 {
 	struct video_device *vfd = container_of(kobj, struct video_device, cdev.kobj);
 
+	msleep(3000);
 	mutex_lock(&videodev_lock);
 	if (video_device[vfd->minor] != vfd) {
 		mutex_unlock(&videodev_lock);

--Boundary-00=_Z47OJ7Byqsvew74
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
--Boundary-00=_Z47OJ7Byqsvew74--
