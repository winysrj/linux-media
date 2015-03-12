Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yh0-f48.google.com ([209.85.213.48]:35482 "EHLO
	mail-yh0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754162AbbCLU7P (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Mar 2015 16:59:15 -0400
Received: by yhnv1 with SMTP id v1so9703227yhn.2
        for <linux-media@vger.kernel.org>; Thu, 12 Mar 2015 13:59:14 -0700 (PDT)
From: Daniel Drake <drake@endlessm.com>
To: laurent.pinchart@ideasonboard.com
Cc: linux-uvc-devel@lists.sourceforge.net, linux-media@vger.kernel.org
Subject: [PATCH] uvcvideo: Add quirk for Quanta NL3 laptop camera
Date: Thu, 12 Mar 2015 14:59:07 -0600
Message-Id: <1426193947-12850-1-git-send-email-drake@endlessm.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The Quanta NL3 laptop has a UVC camera which the descriptor says
comes from Realtek: https://gist.github.com/dsd/9a6567baa53c747fd306

Probe fails, because the output terminal (ID 3) references a
non-existent source with ID 6. Fixing it to add itself onto the
end of the chain makes the camera work.

Signed-off-by: Daniel Drake <drake@endlessm.com>
---
 drivers/media/usb/uvc/uvc_driver.c | 36 ++++++++++++++++++++++++++++++++++++
 drivers/media/usb/uvc/uvcvideo.h   |  1 +
 2 files changed, 37 insertions(+)

diff --git a/drivers/media/usb/uvc/uvc_driver.c b/drivers/media/usb/uvc/uvc_driver.c
index cf27006..3cb4be3 100644
--- a/drivers/media/usb/uvc/uvc_driver.c
+++ b/drivers/media/usb/uvc/uvc_driver.c
@@ -1575,6 +1575,30 @@ static const char *uvc_print_chain(struct uvc_video_chain *chain)
 }
 
 /*
+ * This Realtek camera has a broken descriptor. The output terminal
+ * references a non-existent source. The rest of the simple chain is
+ * fine. Fix the OT to chain on to the end.
+ */
+static void uvc_handle_rtl57a7(struct uvc_device *dev)
+{
+	struct uvc_entity *term;
+
+	term = uvc_entity_by_id(dev, 3);
+	if (!term) {
+		uvc_printk(KERN_INFO, "RTL57A7: no entity with id 3\n");
+		return;
+	}
+
+	if (!UVC_ENTITY_IS_OTERM(term)) {
+		uvc_printk(KERN_INFO, "RTL57A7: entity 3 is not OT\n");
+		return;
+	}
+
+	term->baSourceID[0] = 4;
+	uvc_printk(KERN_INFO, "Applied RTL57A7 chain quirk.\n");
+}
+
+/*
  * Scan the device for video chains and register video devices.
  *
  * Chains are scanned starting at their output terminals and walked backwards.
@@ -1584,6 +1608,9 @@ static int uvc_scan_device(struct uvc_device *dev)
 	struct uvc_video_chain *chain;
 	struct uvc_entity *term;
 
+	if (dev->quirks & UVC_QUIRK_RTL57A7)
+		uvc_handle_rtl57a7(dev);
+
 	list_for_each_entry(term, &dev->entities, list) {
 		if (!UVC_ENTITY_IS_OTERM(term))
 			continue;
@@ -2351,6 +2378,15 @@ static struct usb_device_id uvc_ids[] = {
 	  .bInterfaceSubClass	= 1,
 	  .bInterfaceProtocol	= 0,
 	  .driver_info		= UVC_QUIRK_PROBE_MINMAX },
+	/* Realtek camera in Quanta NL3 laptop */
+	{ .match_flags		= USB_DEVICE_ID_MATCH_DEVICE
+				| USB_DEVICE_ID_MATCH_INT_INFO,
+	  .idVendor		= 0x0bda,
+	  .idProduct		= 0x57a7,
+	  .bInterfaceClass	= USB_CLASS_VIDEO,
+	  .bInterfaceSubClass	= 1,
+	  .bInterfaceProtocol	= 0,
+	  .driver_info		= UVC_QUIRK_RTL57A7 },
 	/* MT6227 */
 	{ .match_flags		= USB_DEVICE_ID_MATCH_DEVICE
 				| USB_DEVICE_ID_MATCH_INT_INFO,
diff --git a/drivers/media/usb/uvc/uvcvideo.h b/drivers/media/usb/uvc/uvcvideo.h
index c63e5b5..710e480 100644
--- a/drivers/media/usb/uvc/uvcvideo.h
+++ b/drivers/media/usb/uvc/uvcvideo.h
@@ -152,6 +152,7 @@
 #define UVC_QUIRK_RESTRICT_FRAME_RATE	0x00000200
 #define UVC_QUIRK_RESTORE_CTRLS_ON_INIT	0x00000400
 #define UVC_QUIRK_FORCE_Y8		0x00000800
+#define UVC_QUIRK_RTL57A7		0x00001000
 
 /* Format flags */
 #define UVC_FMT_FLAG_COMPRESSED		0x00000001
-- 
2.1.0

