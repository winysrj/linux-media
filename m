Return-path: <mchehab@localhost>
Received: from adelie.canonical.com ([91.189.90.139]:33226 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752847Ab1GKJs2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Jul 2011 05:48:28 -0400
Date: Mon, 11 Jul 2011 17:48:11 +0800
From: Ming Lei <ming.lei@canonical.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org, linux-usb@vger.kernel.org,
	Jeremy Kerr <jeremy.kerr@canonical.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [PATCH] uvcvideo: add fix suspend/resume quirk for Microdia camera
Message-ID: <20110711174811.3c383595@tom-ThinkPad-T410>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@infradead.org>

>From 989d894a2af7ceadf2574f455d9e68779f4ae674 Mon Sep 17 00:00:00 2001
From: Ming Lei <ming.lei@canonical.com>
Date: Mon, 11 Jul 2011 17:04:31 +0800
Subject: [PATCH] uvcvideo: add fix suspend/resume quirk for Microdia camera

We found this type(0c45:6437) of Microdia camera does not
work(no stream packets sent out from camera any longer) after
resume from sleep, but unbind/bind driver will work again.

So introduce the quirk of UVC_QUIRK_FIX_SUSPEND_RESUME to
fix the problem for this type of Microdia camera.
---
 drivers/media/video/uvc/uvc_driver.c |  146 +++++++++++++++++++---------------
 drivers/media/video/uvc/uvcvideo.h   |    1 +
 2 files changed, 84 insertions(+), 63 deletions(-)

diff --git a/drivers/media/video/uvc/uvc_driver.c b/drivers/media/video/uvc/uvc_driver.c
index b6eae48..2b356c3 100644
--- a/drivers/media/video/uvc/uvc_driver.c
+++ b/drivers/media/video/uvc/uvc_driver.c
@@ -1787,6 +1787,68 @@ static int uvc_register_chains(struct uvc_device *dev)
 /* ------------------------------------------------------------------------
  * USB probe, disconnect, suspend and resume
  */
+static int uvc_suspend(struct usb_interface *intf, pm_message_t message)
+{
+	struct uvc_device *dev = usb_get_intfdata(intf);
+	struct uvc_streaming *stream;
+
+	uvc_trace(UVC_TRACE_SUSPEND, "Suspending interface %u\n",
+		intf->cur_altsetting->desc.bInterfaceNumber);
+
+	/* Controls are cached on the fly so they don't need to be saved. */
+	if (intf->cur_altsetting->desc.bInterfaceSubClass ==
+	    UVC_SC_VIDEOCONTROL)
+		return uvc_status_suspend(dev);
+
+	list_for_each_entry(stream, &dev->streams, list) {
+		if (stream->intf == intf)
+			return uvc_video_suspend(stream);
+	}
+
+	uvc_trace(UVC_TRACE_SUSPEND, "Suspend: video streaming USB interface "
+			"mismatch.\n");
+	return -EINVAL;
+}
+
+static int __uvc_resume(struct usb_interface *intf, int reset)
+{
+	struct uvc_device *dev = usb_get_intfdata(intf);
+	struct uvc_streaming *stream;
+
+	uvc_trace(UVC_TRACE_SUSPEND, "Resuming interface %u\n",
+		intf->cur_altsetting->desc.bInterfaceNumber);
+
+	if (intf->cur_altsetting->desc.bInterfaceSubClass ==
+	    UVC_SC_VIDEOCONTROL) {
+		if (reset) {
+			int ret = uvc_ctrl_resume_device(dev);
+
+			if (ret < 0)
+				return ret;
+		}
+
+		return uvc_status_resume(dev);
+	}
+
+	list_for_each_entry(stream, &dev->streams, list) {
+		if (stream->intf == intf)
+			return uvc_video_resume(stream);
+	}
+
+	uvc_trace(UVC_TRACE_SUSPEND, "Resume: video streaming USB interface "
+			"mismatch.\n");
+	return -EINVAL;
+}
+
+static int uvc_resume(struct usb_interface *intf)
+{
+	return __uvc_resume(intf, 0);
+}
+
+static int uvc_reset_resume(struct usb_interface *intf)
+{
+	return __uvc_resume(intf, 1);
+}
 
 static int uvc_probe(struct usb_interface *intf,
 		     const struct usb_device_id *id)
@@ -1888,6 +1950,18 @@ static int uvc_probe(struct usb_interface *intf,
 			"supported.\n", ret);
 	}
 
+	/* For some buggy cameras, they will not work after wakeup, so
+	 * do unbind in .usb_suspend and do rebind in .usb_resume to
+	 * make it work again.
+	 * */
+	if (dev->quirks & UVC_QUIRK_FIX_SUSPEND_RESUME) {
+		uvc_driver.driver.suspend = NULL;
+		uvc_driver.driver.resume = NULL;
+	} else {
+		uvc_driver.driver.suspend = uvc_suspend;
+		uvc_driver.driver.resume = uvc_resume;
+	}
+
 	uvc_trace(UVC_TRACE_PROBE, "UVC device initialized.\n");
 	usb_enable_autosuspend(udev);
 	return 0;
@@ -1915,69 +1989,6 @@ static void uvc_disconnect(struct usb_interface *intf)
 	uvc_unregister_video(dev);
 }
 
-static int uvc_suspend(struct usb_interface *intf, pm_message_t message)
-{
-	struct uvc_device *dev = usb_get_intfdata(intf);
-	struct uvc_streaming *stream;
-
-	uvc_trace(UVC_TRACE_SUSPEND, "Suspending interface %u\n",
-		intf->cur_altsetting->desc.bInterfaceNumber);
-
-	/* Controls are cached on the fly so they don't need to be saved. */
-	if (intf->cur_altsetting->desc.bInterfaceSubClass ==
-	    UVC_SC_VIDEOCONTROL)
-		return uvc_status_suspend(dev);
-
-	list_for_each_entry(stream, &dev->streams, list) {
-		if (stream->intf == intf)
-			return uvc_video_suspend(stream);
-	}
-
-	uvc_trace(UVC_TRACE_SUSPEND, "Suspend: video streaming USB interface "
-			"mismatch.\n");
-	return -EINVAL;
-}
-
-static int __uvc_resume(struct usb_interface *intf, int reset)
-{
-	struct uvc_device *dev = usb_get_intfdata(intf);
-	struct uvc_streaming *stream;
-
-	uvc_trace(UVC_TRACE_SUSPEND, "Resuming interface %u\n",
-		intf->cur_altsetting->desc.bInterfaceNumber);
-
-	if (intf->cur_altsetting->desc.bInterfaceSubClass ==
-	    UVC_SC_VIDEOCONTROL) {
-		if (reset) {
-			int ret = uvc_ctrl_resume_device(dev);
-
-			if (ret < 0)
-				return ret;
-		}
-
-		return uvc_status_resume(dev);
-	}
-
-	list_for_each_entry(stream, &dev->streams, list) {
-		if (stream->intf == intf)
-			return uvc_video_resume(stream);
-	}
-
-	uvc_trace(UVC_TRACE_SUSPEND, "Resume: video streaming USB interface "
-			"mismatch.\n");
-	return -EINVAL;
-}
-
-static int uvc_resume(struct usb_interface *intf)
-{
-	return __uvc_resume(intf, 0);
-}
-
-static int uvc_reset_resume(struct usb_interface *intf)
-{
-	return __uvc_resume(intf, 1);
-}
-
 /* ------------------------------------------------------------------------
  * Module parameters
  */
@@ -2175,6 +2186,15 @@ static struct usb_device_id uvc_ids[] = {
 	  .bInterfaceSubClass	= 1,
 	  .bInterfaceProtocol	= 0,
 	  .driver_info		= UVC_QUIRK_FIX_BANDWIDTH },
+	/* Microdia camera */
+	{ .match_flags		= USB_DEVICE_ID_MATCH_DEVICE
+				| USB_DEVICE_ID_MATCH_INT_INFO,
+	  .idVendor		= 0x0c45,
+	  .idProduct		= 0x6437,
+	  .bInterfaceClass	= USB_CLASS_VIDEO,
+	  .bInterfaceSubClass	= 1,
+	  .bInterfaceProtocol	= 0,
+	  .driver_info		= UVC_QUIRK_FIX_SUSPEND_RESUME },
 	/* MT6227 */
 	{ .match_flags		= USB_DEVICE_ID_MATCH_DEVICE
 				| USB_DEVICE_ID_MATCH_INT_INFO,
diff --git a/drivers/media/video/uvc/uvcvideo.h b/drivers/media/video/uvc/uvcvideo.h
index 20107fd..3c13b04 100644
--- a/drivers/media/video/uvc/uvcvideo.h
+++ b/drivers/media/video/uvc/uvcvideo.h
@@ -211,6 +211,7 @@ struct uvc_xu_control {
 #define UVC_QUIRK_FIX_BANDWIDTH		0x00000080
 #define UVC_QUIRK_PROBE_DEF		0x00000100
 #define UVC_QUIRK_RESTRICT_FRAME_RATE	0x00000200
+#define UVC_QUIRK_FIX_SUSPEND_RESUME	0x00000400
 
 /* Format flags */
 #define UVC_FMT_FLAG_COMPRESSED		0x00000001
-- 
1.7.4.1



-- 
Ming Lei
