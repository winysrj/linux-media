Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f65.google.com ([74.125.83.65]:33424 "EHLO
        mail-pg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753368AbdDQIxQ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 17 Apr 2017 04:53:16 -0400
Received: by mail-pg0-f65.google.com with SMTP id 63so12584486pgh.0
        for <linux-media@vger.kernel.org>; Mon, 17 Apr 2017 01:53:16 -0700 (PDT)
From: Daniel Axtens <dja@axtens.net>
To: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Daniel Axtens <dja@axtens.net>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Dave Stevenson <linux-media@destevenson.freeserve.co.uk>,
        Greg KH <greg@kroah.com>
Subject: [PATCH 1/2] [media] uvcvideo: Refactor teardown of uvc on USB disconnect
Date: Mon, 17 Apr 2017 18:52:39 +1000
Message-Id: <20170417085240.12930-1-dja@axtens.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Currently, disconnecting a USB webcam while it is in use prints out a
number of warnings, such as:

WARNING: CPU: 2 PID: 3118 at /build/linux-ezBi1T/linux-4.8.0/fs/sysfs/group.c:237 sysfs_remove_group+0x8b/0x90
sysfs group ffffffffa7cd0780 not found for kobject 'event13'

This has been noticed before. [0]

This is because of the order in which things are torn down.

If there are no streams active during a USB disconnect:

 - uvc_disconnect() is invoked via device_del() through the bus
   notifier mechanism.

 - this calls uvc_unregister_video().

 - uvc_unregister_video() unregisters the video device for each
   stream,

 - because there are no streams open, it calls uvc_delete()

 - uvc_delete() calls uvc_status_cleanup(), which cleans up the status
   input device.

 - uvc_delete() calls media_device_unregister(), which cleans up the
   media device

 - uvc_delete(), uvc_unregister_video() and uvc_disconnect() all
   return, and we end up back in device_del().

 - device_del() then cleans up the sysfs folder for the camera with
   dpm_sysfs_remove(). Because uvc_status_cleanup() and
   media_device_unregister() have already been called, this all works
   nicely.

If, on the other hand, there *are* streams active during a USB disconnect:

 - uvc_disconnect() is invoked

 - this calls uvc_unregister_video()

 - uvc_unregister_video() unregisters the video device for each
   stream,

 - uvc_unregister_video() and uvc_disconnect() return, and we end up
   back in device_del().

 - device_del() then cleans up the sysfs folder for the camera with
   dpm_sysfs_remove(). Because the status input device and the media
   device are children of the USB device, this also deletes their
   sysfs folders.

 - Sometime later, the final stream is closed, invoking uvc_release().

 - uvc_release() calls uvc_delete()

 - uvc_delete() calls uvc_status_cleanup(), which cleans up the status
   input device. Because the sysfs directory has already been removed,
   this causes a WARNing.

 - uvc_delete() calls media_device_unregister(), which cleans up the
   media device. Because the sysfs directory has already been removed,
   this causes another WARNing.

To fix this, we need to make sure the devices are always unregistered
before the end of uvc_disconnect(). To this, move the unregistration
into the disconnect path:

 - split uvc_status_cleanup() into two parts, one on disconnect that
   unregisters and one on delete that frees.

 - move media_device_unregister() into the disconnect path.

[0]: https://lkml.org/lkml/2016/12/8/657

Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Dave Stevenson <linux-media@destevenson.freeserve.co.uk>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Daniel Axtens <dja@axtens.net>

---

Tested with cheese and yavta.
---
 drivers/media/usb/uvc/uvc_driver.c | 8 ++++++--
 drivers/media/usb/uvc/uvc_status.c | 8 ++++++--
 drivers/media/usb/uvc/uvcvideo.h   | 1 +
 3 files changed, 13 insertions(+), 4 deletions(-)

diff --git a/drivers/media/usb/uvc/uvc_driver.c b/drivers/media/usb/uvc/uvc_driver.c
index 46d6be0bb316..2390592f78e0 100644
--- a/drivers/media/usb/uvc/uvc_driver.c
+++ b/drivers/media/usb/uvc/uvc_driver.c
@@ -1815,8 +1815,6 @@ static void uvc_delete(struct uvc_device *dev)
 	if (dev->vdev.dev)
 		v4l2_device_unregister(&dev->vdev);
 #ifdef CONFIG_MEDIA_CONTROLLER
-	if (media_devnode_is_registered(dev->mdev.devnode))
-		media_device_unregister(&dev->mdev);
 	media_device_cleanup(&dev->mdev);
 #endif
 
@@ -1884,6 +1882,12 @@ static void uvc_unregister_video(struct uvc_device *dev)
 		uvc_debugfs_cleanup_stream(stream);
 	}
 
+	uvc_status_unregister(dev);
+#ifdef CONFIG_MEDIA_CONTROLLER
+	if (media_devnode_is_registered(dev->mdev.devnode))
+		media_device_unregister(&dev->mdev);
+#endif
+
 	/* Decrement the stream count and call uvc_delete explicitly if there
 	 * are no stream left.
 	 */
diff --git a/drivers/media/usb/uvc/uvc_status.c b/drivers/media/usb/uvc/uvc_status.c
index f552ab997956..95709b23d3b4 100644
--- a/drivers/media/usb/uvc/uvc_status.c
+++ b/drivers/media/usb/uvc/uvc_status.c
@@ -198,12 +198,16 @@ int uvc_status_init(struct uvc_device *dev)
 	return 0;
 }
 
-void uvc_status_cleanup(struct uvc_device *dev)
+void uvc_status_unregister(struct uvc_device *dev)
 {
 	usb_kill_urb(dev->int_urb);
+	uvc_input_cleanup(dev);
+}
+
+void uvc_status_cleanup(struct uvc_device *dev)
+{
 	usb_free_urb(dev->int_urb);
 	kfree(dev->status);
-	uvc_input_cleanup(dev);
 }
 
 int uvc_status_start(struct uvc_device *dev, gfp_t flags)
diff --git a/drivers/media/usb/uvc/uvcvideo.h b/drivers/media/usb/uvc/uvcvideo.h
index 15e415e32c7f..4b4814df35cd 100644
--- a/drivers/media/usb/uvc/uvcvideo.h
+++ b/drivers/media/usb/uvc/uvcvideo.h
@@ -712,6 +712,7 @@ void uvc_video_clock_update(struct uvc_streaming *stream,
 
 /* Status */
 extern int uvc_status_init(struct uvc_device *dev);
+extern void uvc_status_unregister(struct uvc_device *dev);
 extern void uvc_status_cleanup(struct uvc_device *dev);
 extern int uvc_status_start(struct uvc_device *dev, gfp_t flags);
 extern void uvc_status_stop(struct uvc_device *dev);
-- 
2.9.3
