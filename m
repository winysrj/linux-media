Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (mx1.redhat.com [172.16.48.31])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n2E5QKrP016861
	for <video4linux-list@redhat.com>; Sat, 14 Mar 2009 01:26:20 -0400
Received: from s0be.servebeer.com (pool-71-115-160-52.gdrpmi.dsl-w.verizon.net
	[71.115.160.52])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id n2E5Q7g6030665
	for <video4linux-list@redhat.com>; Sat, 14 Mar 2009 01:26:07 -0400
Message-ID: <49BB3B49.4020405@erley.org>
Date: Sat, 14 Mar 2009 01:06:17 -0400
From: Pat Erley <pat-lkml@erley.org>
MIME-Version: 1.0
To: laurent.pinchart@skynet.be
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com
Subject: [PATCH v2] uvcvideo: Add DEV_RESET_ON_TIMEOUT Quirk
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

This patch provides a quirk that causes uvcvideo to reset certain
devices on -ETIMEOUT.  This is required for my Quickcam Orbit MP 
to function.  This is based on a patch provided by Michel Stempin
in January of 2008.  I've reworked it to be less intrusive for 
other devices.

Tested with:
 Philips SPC 1300NC Webcam (0471:0331)
 Logitech Quickcam Orbit MP (046d:08c2)
 
Signed-off-by: Pat Erley <pat-lkml@erley.org>
---
I've been using/updating this patch for 6 months regularly with
both tested devices, and have not had a problem with it.  


diff -r 39c257ae5063 linux/drivers/media/video/uvc/uvc_driver.c
--- a/linux/drivers/media/video/uvc/uvc_driver.c	Tue Mar 10 18:32:24 2009 -0300
+++ b/linux/drivers/media/video/uvc/uvc_driver.c	Sat Mar 14 01:01:08 2009 -0400
@@ -1510,7 +1510,25 @@
 	if ((ret = uvc_video_init(&dev->video)) < 0) {
 		uvc_printk(KERN_ERR, "Failed to initialize the device "
 			"(%d).\n", ret);
-		return ret;
+		if(dev->quirks & UVC_QUIRK_DEV_RESET_ON_TIMEOUT) {
+			uvc_printk(KERN_ERR, "Trying to reset\n");
+			
+			if ((ret = uvc_usb_reset(dev))) {
+				uvc_printk(KERN_ERR, 
+						"Reset failed (%d)\n",
+						ret);
+				return ret;
+			}
+
+			if ((ret = uvc_video_init(&dev->video)) < 0) {
+				uvc_printk(KERN_ERR, 
+						"Init after reset"
+						" failed(%d)\n", ret);
+				return ret;
+			}
+		} else {
+			return ret;
+		}
 	}
 
 	/* Register the device with V4L. */
@@ -1802,7 +1820,8 @@
 	  .idProduct		= 0x08c2,
 	  .bInterfaceClass	= USB_CLASS_VENDOR_SPEC,
 	  .bInterfaceSubClass	= 1,
-	  .bInterfaceProtocol	= 0 },
+	  .bInterfaceProtocol	= 0,
+	  .driver_info          = UVC_QUIRK_DEV_RESET_ON_TIMEOUT },
 	/* Logitech Quickcam Pro for Notebook */
 	{ .match_flags		= USB_DEVICE_ID_MATCH_DEVICE
 				| USB_DEVICE_ID_MATCH_INT_INFO,
diff -r 39c257ae5063 linux/drivers/media/video/uvc/uvc_v4l2.c
--- a/linux/drivers/media/video/uvc/uvc_v4l2.c	Tue Mar 10 18:32:24 2009 -0300
+++ b/linux/drivers/media/video/uvc/uvc_v4l2.c	Sat Mar 14 01:01:08 2009 -0400
@@ -466,6 +466,13 @@
 		mutex_unlock(&video->queue.mutex);
 	}
 
+	if(video->dev->quirks & UVC_QUIRK_DEV_RESET_ON_TIMEOUT)
+	{
+		/* leave usb device in a clean state */
+			if (video->dev->state & UVC_DEV_IOERROR)
+				uvc_video_reinit(video);
+	}
+
 	/* Release the file handle. */
 	uvc_dismiss_privileges(handle);
 	kfree(handle);
diff -r 39c257ae5063 linux/drivers/media/video/uvc/uvc_video.c
--- a/linux/drivers/media/video/uvc/uvc_video.c	Tue Mar 10 18:32:24 2009 -0300
+++ b/linux/drivers/media/video/uvc/uvc_video.c	Sat Mar 14 01:01:08 2009 -0400
@@ -55,6 +55,12 @@
 		uvc_printk(KERN_ERR, "Failed to query (%u) UVC control %u "
 			"(unit %u) : %d (exp. %u).\n", query, cs, unit, ret,
 			size);
+		
+		/* Reset 'Quirky' device on timeout (-110) */
+		if((dev->quirks & UVC_QUIRK_DEV_RESET_ON_TIMEOUT) &&
+		   (ret == -ETIMEDOUT))
+			dev->state |= UVC_DEV_IOERROR;   	
+			
 		return -EIO;
 	}
 
@@ -1160,3 +1166,43 @@
 	return uvc_init_video(video, GFP_KERNEL);
 }
 
+/* 
+ * Reset and Re-Initialize video device
+ */
+int uvc_video_reinit(struct uvc_video_device *video)
+{
+	int ret;
+
+	if ((ret = uvc_usb_reset(video->dev)) < 0)
+		return ret;
+
+	if ((ret = uvc_set_video_ctrl(video, &video->streaming->ctrl, 0)) < 0) {
+		uvc_printk(KERN_DEBUG, "uvc_video_reinit: Unable to commit format "
+			"(%d).\n", ret);
+		return ret;
+	}
+	return 0;
+}
+
+int uvc_usb_reset(struct uvc_device *dev)
+{
+	int l, ret;
+
+	l = usb_lock_device_for_reset(dev->udev, dev->intf);
+
+	if (l >= 0) {
+		ret = usb_reset_device(dev->udev);
+		if (l)
+			usb_unlock_device(dev->udev);
+	}
+	else
+	ret = -EBUSY;
+
+	if (ret)
+		uvc_printk(KERN_DEBUG, "uvc_usb_reset: Unable to reset usb device"
+			"(%d).\n", ret);
+	else
+		dev->state &= ~UVC_DEV_IOERROR;
+
+	return ret;
+}
diff -r 39c257ae5063 linux/drivers/media/video/uvc/uvcvideo.h
--- a/linux/drivers/media/video/uvc/uvcvideo.h	Tue Mar 10 18:32:24 2009 -0300
+++ b/linux/drivers/media/video/uvc/uvcvideo.h	Sat Mar 14 01:01:08 2009 -0400
@@ -316,6 +316,7 @@
 #define UVC_QUIRK_IGNORE_SELECTOR_UNIT	0x00000020
 #define UVC_QUIRK_PRUNE_CONTROLS	0x00000040
 #define UVC_QUIRK_FIX_BANDWIDTH		0x00000080
+#define UVC_QUIRK_DEV_RESET_ON_TIMEOUT	0x00000100
 
 /* Format flags */
 #define UVC_FMT_FLAG_COMPRESSED		0x00000001
@@ -622,6 +623,7 @@
 
 enum uvc_device_state {
 	UVC_DEV_DISCONNECTED = 1,
+	UVC_DEV_IOERROR = 2,
 };
 
 struct uvc_device {
@@ -815,6 +817,9 @@
 		struct usb_host_interface *alts, __u8 epaddr);
 
 /* Quirks support */
+extern int uvc_video_reinit(struct uvc_video_device *video);
+extern int uvc_usb_reset(struct uvc_device *dev);
+
 void uvc_video_decode_isight(struct urb *urb, struct uvc_video_device *video,
 		struct uvc_buffer *buf);
 

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
