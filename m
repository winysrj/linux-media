Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:44974 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752279AbbKIRdx (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 9 Nov 2015 12:33:53 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Dennis Chen <barracks510@gmail.com>,
	Pawel Osciak <posciak@chromium.org>
Subject: [PATCH] uvcvideo: Enable UVC 1.5 device detection
Date: Mon,  9 Nov 2015 19:33:58 +0200
Message-Id: <1447090438-28681-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

UVC 1.5 devices report a bInterfaceProtocol value set to 1 in their
interface descriptors. The uvcvideo driver only matches on
bInterfaceProtocol 0, preventing those devices from being detected.

More changes to the driver are needed for full UVC 1.5 compatibility.
However, at least the UVC 1.5 Microsoft Surface Pro 3 cameras have been
reported to work out of the box with the driver with an updated match
table.

Enable UVC 1.5 support in the match table to support the devices that
can work with the current driver implementation. Devices that can't will
fail, but that's hardly a regression as they're currently not detected
at all anyway.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/usb/uvc/uvc_driver.c | 3 ++-
 include/uapi/linux/usb/video.h     | 1 +
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/media/usb/uvc/uvc_driver.c b/drivers/media/usb/uvc/uvc_driver.c
index f8e7793e2056..a978f7d9b81d 100644
--- a/drivers/media/usb/uvc/uvc_driver.c
+++ b/drivers/media/usb/uvc/uvc_driver.c
@@ -2597,7 +2597,8 @@ static struct usb_device_id uvc_ids[] = {
 	  .bInterfaceProtocol	= 0,
 	  .driver_info		= UVC_QUIRK_FORCE_Y8 },
 	/* Generic USB Video Class */
-	{ USB_INTERFACE_INFO(USB_CLASS_VIDEO, 1, 0) },
+	{ USB_INTERFACE_INFO(USB_CLASS_VIDEO, 1, UVC_PC_PROTOCOL_UNDEFINED) },
+	{ USB_INTERFACE_INFO(USB_CLASS_VIDEO, 1, UVC_PC_PROTOCOL_15) },
 	{}
 };
 
diff --git a/include/uapi/linux/usb/video.h b/include/uapi/linux/usb/video.h
index 3b3b95e01f71..69ab695fad2e 100644
--- a/include/uapi/linux/usb/video.h
+++ b/include/uapi/linux/usb/video.h
@@ -28,6 +28,7 @@
 
 /* A.3. Video Interface Protocol Codes */
 #define UVC_PC_PROTOCOL_UNDEFINED			0x00
+#define UVC_PC_PROTOCOL_15				0x01
 
 /* A.5. Video Class-Specific VC Interface Descriptor Subtypes */
 #define UVC_VC_DESCRIPTOR_UNDEFINED			0x00
-- 
Regards,

Laurent Pinchart

