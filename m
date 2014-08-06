Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f43.google.com ([74.125.82.43]:63466 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752588AbaHFUuy (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 6 Aug 2014 16:50:54 -0400
Received: by mail-wg0-f43.google.com with SMTP id l18so3118891wgh.26
        for <linux-media@vger.kernel.org>; Wed, 06 Aug 2014 13:50:53 -0700 (PDT)
From: Philipp Zabel <philipp.zabel@gmail.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org,
	Philipp Zabel <philipp.zabel@gmail.com>
Subject: [PATCH v2] [media] uvcvideo: Add quirk to force the Oculus DK2 IR tracker to grayscale
Date: Wed,  6 Aug 2014 22:50:49 +0200
Message-Id: <1407358249-19605-1-git-send-email-philipp.zabel@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds a quirk to force Y8 pixel format even if the camera reports
half-width YUYV.

Signed-off-by: Philipp Zabel <philipp.zabel@gmail.com>
---
 drivers/media/usb/uvc/uvc_driver.c | 29 ++++++++++++++++++++++++++++-
 drivers/media/usb/uvc/uvcvideo.h   |  1 +
 2 files changed, 29 insertions(+), 1 deletion(-)

diff --git a/drivers/media/usb/uvc/uvc_driver.c b/drivers/media/usb/uvc/uvc_driver.c
index c3bb250..90a8f10 100644
--- a/drivers/media/usb/uvc/uvc_driver.c
+++ b/drivers/media/usb/uvc/uvc_driver.c
@@ -311,6 +311,7 @@ static int uvc_parse_format(struct uvc_device *dev,
 	struct uvc_format_desc *fmtdesc;
 	struct uvc_frame *frame;
 	const unsigned char *start = buffer;
+	bool force_yuy2_to_y8 = false;
 	unsigned int interval;
 	unsigned int i, n;
 	__u8 ftype;
@@ -333,6 +334,22 @@ static int uvc_parse_format(struct uvc_device *dev,
 		/* Find the format descriptor from its GUID. */
 		fmtdesc = uvc_format_by_guid(&buffer[5]);
 
+		format->bpp = buffer[21];
+
+		if (dev->quirks & UVC_QUIRK_FORCE_Y8) {
+			if (fmtdesc && fmtdesc->fcc == V4L2_PIX_FMT_YUYV &&
+			    format->bpp == 16) {
+				force_yuy2_to_y8 = true;
+				fmtdesc = &uvc_fmts[9];
+				format->bpp = 8;
+			} else {
+				uvc_printk(KERN_WARNING,
+					"Forcing %d-bit %s to %s not supported",
+					format->bpp, fmtdesc->name,
+					uvc_fmts[9].name);
+			}
+		}
+
 		if (fmtdesc != NULL) {
 			strlcpy(format->name, fmtdesc->name,
 				sizeof format->name);
@@ -345,7 +362,6 @@ static int uvc_parse_format(struct uvc_device *dev,
 			format->fcc = 0;
 		}
 
-		format->bpp = buffer[21];
 		if (buffer[2] == UVC_VS_FORMAT_UNCOMPRESSED) {
 			ftype = UVC_VS_FRAME_UNCOMPRESSED;
 		} else {
@@ -455,6 +471,8 @@ static int uvc_parse_format(struct uvc_device *dev,
 		frame->bFrameIndex = buffer[3];
 		frame->bmCapabilities = buffer[4];
 		frame->wWidth = get_unaligned_le16(&buffer[5]);
+		if (force_yuy2_to_y8)
+			frame->wWidth *= 2;
 		frame->wHeight = get_unaligned_le16(&buffer[7]);
 		frame->dwMinBitRate = get_unaligned_le32(&buffer[9]);
 		frame->dwMaxBitRate = get_unaligned_le32(&buffer[13]);
@@ -2467,6 +2485,15 @@ static struct usb_device_id uvc_ids[] = {
 	  .bInterfaceProtocol	= 0,
 	  .driver_info		= UVC_QUIRK_PROBE_MINMAX
 				| UVC_QUIRK_IGNORE_SELECTOR_UNIT },
+	/* Oculus VR Positional Tracker DK2 */
+	{ .match_flags		= USB_DEVICE_ID_MATCH_DEVICE
+				| USB_DEVICE_ID_MATCH_INT_INFO,
+	  .idVendor		= 0x2833,
+	  .idProduct		= 0x0201,
+	  .bInterfaceClass	= USB_CLASS_VIDEO,
+	  .bInterfaceSubClass	= 1,
+	  .bInterfaceProtocol	= 0,
+	  .driver_info		= UVC_QUIRK_FORCE_Y8 },
 	/* Generic USB Video Class */
 	{ USB_INTERFACE_INFO(USB_CLASS_VIDEO, 1, 0) },
 	{}
diff --git a/drivers/media/usb/uvc/uvcvideo.h b/drivers/media/usb/uvc/uvcvideo.h
index 9e35982..1dd78c0 100644
--- a/drivers/media/usb/uvc/uvcvideo.h
+++ b/drivers/media/usb/uvc/uvcvideo.h
@@ -137,6 +137,7 @@
 #define UVC_QUIRK_FIX_BANDWIDTH		0x00000080
 #define UVC_QUIRK_PROBE_DEF		0x00000100
 #define UVC_QUIRK_RESTRICT_FRAME_RATE	0x00000200
+#define UVC_QUIRK_FORCE_Y8		0x00000400
 
 /* Format flags */
 #define UVC_FMT_FLAG_COMPRESSED		0x00000001
-- 
2.0.1

