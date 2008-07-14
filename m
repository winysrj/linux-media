Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m6E4iuiv021871
	for <video4linux-list@redhat.com>; Mon, 14 Jul 2008 00:44:56 -0400
Received: from s0be.servebeer.com (pool-71-115-163-54.gdrpmi.dsl-w.verizon.net
	[71.115.163.54])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m6E4ijNi018651
	for <video4linux-list@redhat.com>; Mon, 14 Jul 2008 00:44:46 -0400
Received: from [IPv6:2001:4978:142:0:290:f5ff:fe3a:c66d] (unknown
	[IPv6:2001:4978:142:0:290:f5ff:fe3a:c66d])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by s0be.servebeer.com (Postfix) with ESMTP id E9362CFAA9
	for <video4linux-list@redhat.com>; Mon, 14 Jul 2008 00:44:44 -0400 (EDT)
Message-ID: <487AD9BB.8070400@erley.org>
Date: Mon, 14 Jul 2008 00:44:43 -0400
From: pat-lkml <pat-lkml@erley.org>
MIME-Version: 1.0
To: Linux and Kernel Video <video4linux-list@redhat.com>
References: <487AD82A.20801@erley.org> <487AD8FA.2010103@erley.org>
In-Reply-To: <487AD8FA.2010103@erley.org>
Content-Type: multipart/mixed; boundary="------------050904070808000105060108"
Subject: Re: [PATCH] uvcvideo: RESET_ON_TIMOUT Quirk [Against HG]
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
--------------050904070808000105060108
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

This patch provides another quirk that causes the driver to reset the
device on -110.  This is a reworking of the patch provided by Michel
Stempin in January.  I've updated it so that, aside from the last_urb
field, there are no differences in the code executed for non Quirk
devices.  Also, I fixed the whitespace issues that had crept into my
previous patch.  There are still some if/else nests that could be
simplified, but I'll save that for another night.  I've tested it and it
works for me with my Quickcam Orbit MP.  This version is likely safe for
inclusion into the tree.

Signed-off-by: Pat Erley <pat-lkml@erley.org>

--------------050904070808000105060108
Content-Type: text/plain;
 name="reset_on_timeout_quirk_hg_corrected.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
	filename="reset_on_timeout_quirk_hg_corrected.diff"

diff -r 0ebffe1cc136 linux/drivers/media/video/uvc/uvc_driver.c
--- a/linux/drivers/media/video/uvc/uvc_driver.c	Sat Jul 12 16:50:43 2008 -0300
+++ b/linux/drivers/media/video/uvc/uvc_driver.c	Sun Jul 13 20:57:37 2008 -0400
@@ -142,6 +142,47 @@ static __u32 uvc_colorspace(const __u8 p
 	return 0;
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
+
 /* Simplify a fraction using a simple continued fraction decomposition. The
  * idea here is to convert fractions such as 333333/10000000 to 1/30 using
  * 32 bit arithmetic only. The algorithm is not perfect and relies upon two
@@ -1444,9 +1485,23 @@ static int uvc_register_video(struct uvc
 	 * parameters.
 	 */
 	if ((ret = uvc_video_init(&dev->video)) < 0) {
-		uvc_printk(KERN_ERR, "Failed to initialize the device "
-			"(%d).\n", ret);
-		return ret;
+		if(dev->quirks & UVC_QUIRK_DEV_RESET_ON_TIMEOUT){
+			uvc_printk(KERN_ERR, "Failed to initialize the device, "
+				"(%d). trying to reset ...\n", ret);
+		
+			if ((ret = uvc_usb_reset(dev)))
+				return ret;
+		
+			if ((ret = uvc_video_init(&dev->video)) < 0) {
+				uvc_printk(KERN_ERR, "Failed to initialize the device "
+					"(%d).\n", ret);
+				return ret;
+			}
+		} else {
+			uvc_printk(KERN_ERR, "Failed to initialize the device "
+				"(%d).\n", ret);
+			return ret;
+		}
 	}
 
 	/* Register the device with V4L. */
@@ -1560,6 +1615,7 @@ static int uvc_probe(struct usb_interfac
 	dev->udev = usb_get_dev(udev);
 	dev->intf = usb_get_intf(intf);
 	dev->intfnum = intf->cur_altsetting->desc.bInterfaceNumber;
+	dev->last_urb = 0;
 	dev->quirks = id->driver_info | uvc_quirks_param;
 
 	if (udev->product != NULL)
@@ -1750,7 +1806,8 @@ static struct usb_device_id uvc_ids[] = 
 	  .idProduct		= 0x08c2,
 	  .bInterfaceClass	= USB_CLASS_VENDOR_SPEC,
 	  .bInterfaceSubClass	= 1,
-	  .bInterfaceProtocol	= 0 },
+	  .bInterfaceProtocol	= 0,
+	  .driver_info          = UVC_QUIRK_DEV_RESET_ON_TIMEOUT },
 	/* Logitech Quickcam Pro for Notebook */
 	{ .match_flags		= USB_DEVICE_ID_MATCH_DEVICE
 				| USB_DEVICE_ID_MATCH_INT_INFO,
diff -r 0ebffe1cc136 linux/drivers/media/video/uvc/uvc_status.c
--- a/linux/drivers/media/video/uvc/uvc_status.c	Sat Jul 12 16:50:43 2008 -0300
+++ b/linux/drivers/media/video/uvc/uvc_status.c	Sun Jul 13 20:57:37 2008 -0400
@@ -161,9 +161,24 @@ static void uvc_status_complete(struct u
 	/* Resubmit the URB. */
 	urb->interval = dev->int_ep->desc.bInterval;
 	if ((ret = usb_submit_urb(urb, GFP_ATOMIC)) < 0) {
-		uvc_printk(KERN_ERR, "Failed to resubmit status URB (%d).\n",
-			ret);
-	}
+		if(dev->quirks & UVC_QUIRK_DEV_RESET_ON_TIMEOUT)
+		{
+			uvc_printk(KERN_ERR, "Failed to resubmit status URB (%d).\n",
+				ret);
+		} else {
+			if (ret == -EL2NSYNC) {
+				if ((ret = usb_submit_urb(urb, GFP_ATOMIC)) < 0) {
+					uvc_printk(KERN_ERR, "Failed to resubmit status URB (%d).\n",
+						ret);
+				}
+			} else {
+				uvc_printk(KERN_ERR, "Failed to resubmit status URB (%d).\n",
+					ret);
+
+			}
+		}
+	}
+	dev->last_urb = jiffies;
 }
 
 int uvc_status_init(struct uvc_device *dev)
@@ -171,6 +186,7 @@ int uvc_status_init(struct uvc_device *d
 	struct usb_host_endpoint *ep = dev->int_ep;
 	unsigned int pipe;
 	int interval;
+	int ret = 0;
 
 	if (ep == NULL)
 		return 0;
@@ -195,7 +211,21 @@ int uvc_status_init(struct uvc_device *d
 		dev->status, sizeof dev->status, uvc_status_complete,
 		dev, interval);
 
-	return usb_submit_urb(dev->int_urb, GFP_KERNEL);
+	if(dev->quirks & UVC_QUIRK_DEV_RESET_ON_TIMEOUT) {
+		if ((ret = usb_submit_urb(dev->int_urb, GFP_KERNEL)) < 0) {
+			if (ret == -EL2NSYNC) {
+				if ((ret = usb_submit_urb(dev->int_urb, GFP_KERNEL)) < 0) {
+					uvc_printk(KERN_ERR, "Failed to resubmit status URB (%d).\n",
+						ret);
+				}
+			}
+		}
+
+	} else {
+		ret = usb_submit_urb(dev->int_urb, GFP_KERNEL);
+	}
+	dev->last_urb = jiffies;
+	return ret;
 }
 
 void uvc_status_cleanup(struct uvc_device *dev)
@@ -213,9 +243,25 @@ int uvc_status_suspend(struct uvc_device
 
 int uvc_status_resume(struct uvc_device *dev)
 {
+	int ret = 0;
 	if (dev->int_urb == NULL)
-		return 0;
-
-	return usb_submit_urb(dev->int_urb, GFP_NOIO);
-}
-
+		return ret;
+
+	if(dev->quirks & UVC_QUIRK_DEV_RESET_ON_TIMEOUT) {
+		if ((ret = usb_submit_urb(dev->int_urb, GFP_KERNEL)) < 0) {
+			if (ret == -EL2NSYNC) {
+				if ((ret = usb_submit_urb(dev->int_urb, GFP_KERNEL)) < 0) {
+					uvc_printk(KERN_ERR, "Failed to resubmit status URB (%d).\n",
+						ret);
+				}
+			}
+		}
+
+	} else {
+		ret = usb_submit_urb(dev->int_urb, GFP_NOIO);
+	}
+
+	dev->last_urb = jiffies;
+	return ret;
+}
+
diff -r 0ebffe1cc136 linux/drivers/media/video/uvc/uvc_v4l2.c
--- a/linux/drivers/media/video/uvc/uvc_v4l2.c	Sat Jul 12 16:50:43 2008 -0300
+++ b/linux/drivers/media/video/uvc/uvc_v4l2.c	Sun Jul 13 20:57:37 2008 -0400
@@ -456,6 +456,13 @@ static int uvc_v4l2_release(struct inode
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
diff -r 0ebffe1cc136 linux/drivers/media/video/uvc/uvc_video.c
--- a/linux/drivers/media/video/uvc/uvc_video.c	Sat Jul 12 16:50:43 2008 -0300
+++ b/linux/drivers/media/video/uvc/uvc_video.c	Sun Jul 13 21:05:54 2008 -0400
@@ -37,18 +37,37 @@ static int __uvc_query_ctrl(struct uvc_d
 	__u8 type = USB_TYPE_CLASS | USB_RECIP_INTERFACE;
 	unsigned int pipe;
 	int ret;
+	int delayed = 0;
 
 	pipe = (query & 0x80) ? usb_rcvctrlpipe(dev->udev, 0)
 			      : usb_sndctrlpipe(dev->udev, 0);
 	type |= (query & 0x80) ? USB_DIR_IN : USB_DIR_OUT;
 
+	if ((dev->quirks & UVC_QUIRK_DEV_RESET_ON_TIMEOUT) && (dev->last_urb)) {
+		while (time_before(jiffies,dev->last_urb + 2)) {
+			schedule();
+			delayed = 1;
+		}
+	}
+
 	ret = usb_control_msg(dev->udev, pipe, query, type, cs << 8,
 			unit << 8 | intfnum, data, size, timeout);
+	dev->last_urb = jiffies;
 
 	if (ret != size) {
 		uvc_printk(KERN_ERR, "Failed to query (%u) UVC control %u "
 			"(unit %u) : %d (exp. %u).\n", query, cs, unit, ret,
 			size);
+
+		if (dev->quirks & UVC_QUIRK_DEV_RESET_ON_TIMEOUT){
+			if (delayed) {
+				uvc_printk(KERN_ERR,"usb_control_msg was delayed\n");
+			} else {
+				uvc_printk(KERN_ERR,"usb_control_msg was NOT delayed\n");
+			}
+			if (ret == -ETIMEDOUT) // reset the device in case of -110 error
+				dev->state |= UVC_DEV_IOERROR;
+		}
 		return -EIO;
 	}
 
@@ -548,9 +567,23 @@ static void uvc_video_complete(struct ur
 	video->decode(urb, video, buf);
 
 	if ((ret = usb_submit_urb(urb, GFP_ATOMIC)) < 0) {
-		uvc_printk(KERN_ERR, "Failed to resubmit video URB (%d).\n",
-			ret);
-	}
+		if (video->dev->quirks & UVC_QUIRK_DEV_RESET_ON_TIMEOUT) {
+			if (ret == -EL2NSYNC) {
+				if ((ret = usb_submit_urb(urb, GFP_ATOMIC)) < 0) {
+					uvc_printk(KERN_ERR, "Failed to resubmit video URB (%d).\n",
+						ret);
+				}
+			} else {
+				 uvc_printk(KERN_ERR, "Failed to resubmit video URB (%d).\n",
+				 	ret);
+
+			}
+		} else {
+			uvc_printk(KERN_ERR, "Failed to resubmit video URB (%d).\n",
+				ret);
+		}
+	}
+	video->dev->last_urb = jiffies;
 }
 
 /*
@@ -802,6 +835,7 @@ static int uvc_init_video(struct uvc_vid
 			return ret;
 		}
 	}
+	video->dev->last_urb = jiffies;
 
 	return 0;
 }
diff -r 0ebffe1cc136 linux/drivers/media/video/uvc/uvcvideo.h
--- a/linux/drivers/media/video/uvc/uvcvideo.h	Sat Jul 12 16:50:43 2008 -0300
+++ b/linux/drivers/media/video/uvc/uvcvideo.h	Sun Jul 13 20:57:37 2008 -0400
@@ -314,6 +314,7 @@ struct uvc_xu_control {
 #define UVC_QUIRK_BUILTIN_ISIGHT	0x00000008
 #define UVC_QUIRK_STREAM_NO_FID		0x00000010
 #define UVC_QUIRK_IGNORE_SELECTOR_UNIT	0x00000020
+#define UVC_QUIRK_DEV_RESET_ON_TIMEOUT	0x00000040
 
 /* Format flags */
 #define UVC_FMT_FLAG_COMPRESSED		0x00000001
@@ -610,6 +611,7 @@ struct uvc_video_device {
 
 enum uvc_device_state {
 	UVC_DEV_DISCONNECTED = 1,
+	UVC_DEV_IOERROR = 2,
 };
 
 struct uvc_device {
@@ -620,6 +622,7 @@ struct uvc_device {
 	char name[32];
 
 	enum uvc_device_state state;
+	unsigned long last_urb;
 	struct kref kref;
 	struct list_head list;
 
@@ -789,6 +792,9 @@ extern struct usb_host_endpoint *uvc_fin
 extern struct usb_host_endpoint *uvc_find_endpoint(
 		struct usb_host_interface *alts, __u8 epaddr);
 
+extern int uvc_video_reinit(struct uvc_video_device *video);
+extern int uvc_usb_reset(struct uvc_device *dev);
+
 /* Quirks support */
 void uvc_video_decode_isight(struct urb *urb, struct uvc_video_device *video,
 		struct uvc_buffer *buf);

--------------050904070808000105060108
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
--------------050904070808000105060108--
