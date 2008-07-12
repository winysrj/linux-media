Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m6CKiatB026468
	for <video4linux-list@redhat.com>; Sat, 12 Jul 2008 16:44:36 -0400
Received: from s0be.servebeer.com (pool-71-115-163-54.gdrpmi.dsl-w.verizon.net
	[71.115.163.54])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m6CKiPnI011572
	for <video4linux-list@redhat.com>; Sat, 12 Jul 2008 16:44:26 -0400
Received: from [IPv6:2001:4978:142:0:290:f5ff:fe3a:c66d] (unknown
	[IPv6:2001:4978:142:0:290:f5ff:fe3a:c66d])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by s0be.servebeer.com (Postfix) with ESMTP id E38F2CFAA3
	for <video4linux-list@redhat.com>; Sat, 12 Jul 2008 15:49:14 -0400 (EDT)
Message-ID: <48790AB9.8070609@erley.org>
Date: Sat, 12 Jul 2008 15:49:13 -0400
From: pat-lkml <pat-lkml@erley.org>
MIME-Version: 1.0
To: Linux and Kernel Video <video4linux-list@redhat.com>
Content-Type: multipart/mixed; boundary="------------030908060009080100050105"
Subject: [PATCH] uvcvideo: RESET_ON_TIMOUT Quirk 
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

This is a multi-part message in MIME format.
--------------030908060009080100050105
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

This patch provides another quirk that causes the driver to reset the 
device on -110.  This is a reworking of the patch provided by Michel 
Stempin in January.  I've tested it and it works for me with my Quickcam 
Orbit MP.  I'm not certain that it's a candidate for inclusion, 
especially in it's current state, but I thought I'd put it out there for 
others to try, and possibly make mainline worthy.


Pat Erley

--------------030908060009080100050105
Content-Type: text/plain;
 name="reset_on_timeout_quirk.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="reset_on_timeout_quirk.diff"

Only in linux-uvc-0.1.0_pre223-resetpatch: .tmp_versions
Only in linux-uvc-0.1.0_pre223-resetpatch: .uvc_ctrl.o.cmd
Only in linux-uvc-0.1.0_pre223-resetpatch: .uvc_driver.o.cmd
Only in linux-uvc-0.1.0_pre223-resetpatch: .uvc_isight.o.cmd
Only in linux-uvc-0.1.0_pre223-resetpatch: .uvc_queue.o.cmd
Only in linux-uvc-0.1.0_pre223-resetpatch: .uvc_status.o.cmd
Only in linux-uvc-0.1.0_pre223-resetpatch: .uvc_v4l2.o.cmd
Only in linux-uvc-0.1.0_pre223-resetpatch: .uvc_video.o.cmd
Only in linux-uvc-0.1.0_pre223-resetpatch: .uvcvideo.ko.cmd
Only in linux-uvc-0.1.0_pre223-resetpatch: .uvcvideo.mod.o.cmd
Only in linux-uvc-0.1.0_pre223-resetpatch: .uvcvideo.o.cmd
Only in linux-uvc-0.1.0_pre223-resetpatch: Module.symvers
Only in linux-uvc-0.1.0_pre223-resetpatch: modules.order
Only in linux-uvc-0.1.0_pre223-resetpatch: quirks
Only in linux-uvc-0.1.0_pre223-resetpatch: uvc_ctrl.o
diff -u linux-uvc-0.1.0_pre223/uvc_driver.c linux-uvc-0.1.0_pre223-resetpatch/uvc_driver.c
--- linux-uvc-0.1.0_pre223/uvc_driver.c	2008-07-05 11:52:01.000000000 -0400
+++ linux-uvc-0.1.0_pre223-resetpatch/uvc_driver.c	2008-07-12 15:42:09.000000000 -0400
@@ -145,6 +145,50 @@
 	return 0;
 }
 
+/* 
+ * Reset and Re-Initialize video device
+ */
+int uvc_video_reinit(struct uvc_video_device *video)
+{
+       int ret;
+
+       if ((ret = uvc_usb_reset(video->dev)) < 0)
+               return ret;
+
+       if ((ret = uvc_set_video_ctrl(video, &video->streaming->ctrl, 0)) < 0) {
+               uvc_printk(KERN_DEBUG, "uvc_video_reinit: Unable to commit format "
+                          "(%d).\n", ret);
+               return ret;
+       }
+
+       return 0;
+}
+
+
+int uvc_usb_reset(struct uvc_device *dev)
+{
+       int l, ret;
+
+       l = usb_lock_device_for_reset(dev->udev, dev->intf);
+
+       if (l >= 0) {
+               ret = usb_reset_device(dev->udev);
+               if (l)
+                       usb_unlock_device(dev->udev);
+       }
+       else
+               ret = -EBUSY;
+
+       if (ret)
+               uvc_printk(KERN_DEBUG, "uvc_usb_reset: Unable to reset usb device"
+                          "(%d).\n", ret);
+       else
+               dev->state &= ~UVC_DEV_IOERROR;
+
+       return ret;
+}
+
+
 /* Simplify a fraction using a simple continued fraction decomposition. The
  * idea here is to convert fractions such as 333333/10000000 to 1/30 using
  * 32 bit arithmetic only. The algorithm is not perfect and relies upon two
@@ -1447,9 +1491,24 @@
 	 * parameters.
 	 */
 	if ((ret = uvc_video_init(&dev->video)) < 0) {
+	  if(dev->quirks & UVC_QUIRK_DEV_RESET_ON_TIMEOUT)
+	  {
+               uvc_printk(KERN_ERR, "Failed to initialize the device, "
+                          "(%d). trying to reset ...\n", ret);
+
+               if ((ret = uvc_usb_reset(dev)))
+                       return ret;
+
+               if ((ret = uvc_video_init(&dev->video)) < 0) {
+                       uvc_printk(KERN_ERR, "Failed to initialize the device "
+                                  "(%d).\n", ret);
+                       return ret;
+               }
+          } else {
 		uvc_printk(KERN_ERR, "Failed to initialize the device "
 			"(%d).\n", ret);
 		return ret;
+	  }
 	}
 
 	/* Register the device with V4L. */
@@ -1563,6 +1622,7 @@
 	dev->udev = usb_get_dev(udev);
 	dev->intf = usb_get_intf(intf);
 	dev->intfnum = intf->cur_altsetting->desc.bInterfaceNumber;
+	dev->last_urb = 0;
 	dev->quirks = id->driver_info | uvc_quirks_param;
 
 	if (udev->product != NULL)
@@ -1750,7 +1810,8 @@
 	  .idProduct		= 0x08c2,
 	  .bInterfaceClass	= USB_CLASS_VENDOR_SPEC,
 	  .bInterfaceSubClass	= 1,
-	  .bInterfaceProtocol	= 0 },
+	  .bInterfaceProtocol	= 0,
+	  .driver_info          = UVC_QUIRK_DEV_RESET_ON_TIMEOUT},
 	/* Logitech Quickcam Pro for Notebook */
 	{ .match_flags		= USB_DEVICE_ID_MATCH_DEVICE
 				| USB_DEVICE_ID_MATCH_INT_INFO,
Only in linux-uvc-0.1.0_pre223-resetpatch: uvc_driver.o
Only in linux-uvc-0.1.0_pre223-resetpatch: uvc_isight.o
Only in linux-uvc-0.1.0_pre223-resetpatch: uvc_queue.o
diff -u linux-uvc-0.1.0_pre223/uvc_status.c linux-uvc-0.1.0_pre223-resetpatch/uvc_status.c
--- linux-uvc-0.1.0_pre223/uvc_status.c	2008-07-05 11:52:01.000000000 -0400
+++ linux-uvc-0.1.0_pre223-resetpatch/uvc_status.c	2008-07-07 21:26:37.000000000 -0400
@@ -160,9 +160,15 @@
 	/* Resubmit the URB. */
 	urb->interval = dev->int_ep->desc.bInterval;
 	if ((ret = usb_submit_urb(urb, GFP_ATOMIC)) < 0) {
-		uvc_printk(KERN_ERR, "Failed to resubmit status URB (%d).\n",
-			ret);
+               if (ret == -EL2NSYNC) {
+                       if ((ret = usb_submit_urb(urb, GFP_ATOMIC)) < 0) {
+                               uvc_printk(KERN_ERR, "Failed to resubmit status URB (%d).\n",
+                                       ret);
+                       }
+               }
+
 	}
+	dev->last_urb = jiffies;
 }
 
 int uvc_status_init(struct uvc_device *dev)
@@ -170,6 +176,7 @@
 	struct usb_host_endpoint *ep = dev->int_ep;
 	unsigned int pipe;
 	int interval;
+	int ret = 0;
 
 	if (ep == NULL)
 		return 0;
@@ -194,7 +201,16 @@
 		dev->status, sizeof dev->status, uvc_status_complete,
 		dev, interval);
 
-	return usb_submit_urb(dev->int_urb, GFP_KERNEL);
+        if ((ret = usb_submit_urb(dev->int_urb, GFP_KERNEL)) < 0) {
+               if (ret == -EL2NSYNC) {
+                       if ((ret = usb_submit_urb(dev->int_urb, GFP_KERNEL)) < 0) {
+                               uvc_printk(KERN_ERR, "Failed to resubmit status URB (%d).\n",
+                                       ret);
+                       }
+               }
+        }
+        dev->last_urb = jiffies;
+        return ret;
 }
 
 void uvc_status_cleanup(struct uvc_device *dev)
@@ -212,9 +228,19 @@
 
 int uvc_status_resume(struct uvc_device *dev)
 {
+	int ret = 0;
 	if (dev->int_urb == NULL)
 		return 0;
 
-	return usb_submit_urb(dev->int_urb, GFP_NOIO);
+       if ((ret = usb_submit_urb(dev->int_urb, GFP_KERNEL)) < 0) {
+               if (ret == -EL2NSYNC) {
+                       if ((ret = usb_submit_urb(dev->int_urb, GFP_KERNEL)) < 0) {
+                               uvc_printk(KERN_ERR, "Failed to resubmit status URB (%d).\n",
+                                       ret);
+                       }
+               }
+       }
+       dev->last_urb = jiffies;
+       return ret;
 }
 
Only in linux-uvc-0.1.0_pre223-resetpatch: uvc_status.o
diff -u linux-uvc-0.1.0_pre223/uvc_v4l2.c linux-uvc-0.1.0_pre223-resetpatch/uvc_v4l2.c
--- linux-uvc-0.1.0_pre223/uvc_v4l2.c	2008-07-05 11:52:01.000000000 -0400
+++ linux-uvc-0.1.0_pre223-resetpatch/uvc_v4l2.c	2008-07-12 15:42:24.000000000 -0400
@@ -457,6 +457,13 @@
 					"free buffers.\n");
 		mutex_unlock(&video->queue.mutex);
 	}
+	
+	if(video->dev->quirks & UVC_QUIRK_DEV_RESET_ON_TIMEOUT)
+	{
+		/* leave usb device in a clean state */
+       		if (video->dev->state & UVC_DEV_IOERROR)
+        		uvc_video_reinit(video);
+	}
 
 	/* Release the file handle. */
 	uvc_dismiss_privileges(handle);
Only in linux-uvc-0.1.0_pre223-resetpatch: uvc_v4l2.o
diff -u linux-uvc-0.1.0_pre223/uvc_video.c linux-uvc-0.1.0_pre223-resetpatch/uvc_video.c
--- linux-uvc-0.1.0_pre223/uvc_video.c	2008-07-05 11:52:01.000000000 -0400
+++ linux-uvc-0.1.0_pre223-resetpatch/uvc_video.c	2008-07-12 15:42:49.000000000 -0400
@@ -39,18 +39,40 @@
 	__u8 type = USB_TYPE_CLASS | USB_RECIP_INTERFACE;
 	unsigned int pipe;
 	int ret;
+	int delayed = 0;
 
 	pipe = (query & 0x80) ? usb_rcvctrlpipe(dev->udev, 0)
 			      : usb_sndctrlpipe(dev->udev, 0);
 	type |= (query & 0x80) ? USB_DIR_IN : USB_DIR_OUT;
 
+       if (dev->last_urb) {
+               while (time_before(jiffies,dev->last_urb + 2)) {
+                       schedule();
+                       delayed = 1;
+               }
+       }
+
 	ret = usb_control_msg(dev->udev, pipe, query, type, cs << 8,
 			unit << 8 | intfnum, data, size, timeout);
+	dev->last_urb = jiffies;
+
 
 	if (ret != size) {
 		uvc_printk(KERN_ERR, "Failed to query (%u) UVC control %u "
 			"(unit %u) : %d (exp. %u).\n", query, cs, unit, ret,
 			size);
+               if (delayed) {
+                       uvc_printk(KERN_ERR,"usb_control_msg was delayed\n");
+               } else {
+                       uvc_printk(KERN_ERR,"usb_control_msg was NOT delayed\n");
+               }
+	       if (dev->quirks & UVC_QUIRK_DEV_RESET_ON_TIMEOUT)
+	       {
+               		if (ret == -ETIMEDOUT) // reset the device in case of -110 error
+                       		dev->state |= UVC_DEV_IOERROR;
+		}
+
+
 		return -EIO;
 	}
 
@@ -554,9 +576,15 @@
 	video->decode(urb, video, buf);
 
 	if ((ret = usb_submit_urb(urb, GFP_ATOMIC)) < 0) {
-		uvc_printk(KERN_ERR, "Failed to resubmit video URB (%d).\n",
-			ret);
-	}
+
+               if (ret == -EL2NSYNC) {
+                       if ((ret = usb_submit_urb(urb, GFP_ATOMIC)) < 0) {
+                               uvc_printk(KERN_ERR, "Failed to resubmit video URB (%d).\n",
+                                       ret);
+                       }
+               }
+       }
+       video->dev->last_urb = jiffies;
 }
 
 /*
@@ -808,6 +836,7 @@
 			return ret;
 		}
 	}
+	video->dev->last_urb = jiffies;
 
 	return 0;
 }
Only in linux-uvc-0.1.0_pre223-resetpatch: uvc_video.o
diff -u linux-uvc-0.1.0_pre223/uvcvideo.h linux-uvc-0.1.0_pre223-resetpatch/uvcvideo.h
--- linux-uvc-0.1.0_pre223/uvcvideo.h	2008-07-05 11:52:01.000000000 -0400
+++ linux-uvc-0.1.0_pre223-resetpatch/uvcvideo.h	2008-07-12 15:43:13.000000000 -0400
@@ -315,11 +315,13 @@
 #define UVC_QUIRK_BUILTIN_ISIGHT	0x00000008
 #define UVC_QUIRK_STREAM_NO_FID		0x00000010
 #define UVC_QUIRK_IGNORE_SELECTOR_UNIT	0x00000020
+#define UVC_QUIRK_DEV_RESET_ON_TIMEOUT	0x00000040
 
 /* Format flags */
 #define UVC_FMT_FLAG_COMPRESSED		0x00000001
 #define UVC_FMT_FLAG_STREAM		0x00000002
 
+
 /* ------------------------------------------------------------------------
  * Structures.
  */
@@ -611,6 +613,7 @@
 
 enum uvc_device_state {
 	UVC_DEV_DISCONNECTED = 1,
+        UVC_DEV_IOERROR = 2,
 };
 
 struct uvc_device {
@@ -621,6 +624,7 @@
 	char name[32];
 
 	enum uvc_device_state state;
+	unsigned long last_urb;
 	struct kref kref;
 	struct list_head list;
 
@@ -790,6 +794,9 @@
 extern struct usb_host_endpoint *uvc_find_endpoint(
 		struct usb_host_interface *alts, __u8 epaddr);
 
+extern int uvc_video_reinit(struct uvc_video_device *video);
+extern int uvc_usb_reset(struct uvc_device *dev);
+
 /* Quirks support */
 void uvc_video_decode_isight(struct urb *urb, struct uvc_video_device *video,
 		struct uvc_buffer *buf);
Only in linux-uvc-0.1.0_pre223-resetpatch: uvcvideo.ko
Only in linux-uvc-0.1.0_pre223-resetpatch: uvcvideo.mod.c
Only in linux-uvc-0.1.0_pre223-resetpatch: uvcvideo.mod.o
Only in linux-uvc-0.1.0_pre223-resetpatch: uvcvideo.o
Only in linux-uvc-0.1.0_pre223-resetpatch: version.h

--------------030908060009080100050105
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
--------------030908060009080100050105--
