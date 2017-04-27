Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:48897 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S937504AbdD0M1M (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 27 Apr 2017 08:27:12 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hans.verkuil@cisco.com>
Cc: linux-media@vger.kernel.org
Subject: [PATCH 1/2] uvcvideo: Quirk for webcam in MacBook Pro 2016
Date: Thu, 27 Apr 2017 15:28:17 +0300
Message-Id: <20170427122818.13146-2-laurent.pinchart@ideasonboard.com>
In-Reply-To: <20170427122818.13146-1-laurent.pinchart@ideasonboard.com>
References: <20170427122818.13146-1-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daniel Roschka <danielroschka@phoenitydawn.de>

Add the probe def quirk for the webcam found in the Apple MacBook Pro
2016, to get it working out of the box.

Signed-off-by: Daniel Roschka <danielroschka@phoenitydawn.de>
Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/usb/uvc/uvc_driver.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/media/usb/uvc/uvc_driver.c b/drivers/media/usb/uvc/uvc_driver.c
index 46d6be0bb316..602256ffe14d 100644
--- a/drivers/media/usb/uvc/uvc_driver.c
+++ b/drivers/media/usb/uvc/uvc_driver.c
@@ -2441,6 +2441,15 @@ static struct usb_device_id uvc_ids[] = {
 	  .bInterfaceProtocol	= 0,
 	  .driver_info 		= UVC_QUIRK_PROBE_MINMAX
 				| UVC_QUIRK_BUILTIN_ISIGHT },
+	/* Apple Built-In iSight via iBridge */
+	{ .match_flags		= USB_DEVICE_ID_MATCH_DEVICE
+				| USB_DEVICE_ID_MATCH_INT_INFO,
+	  .idVendor		= 0x05ac,
+	  .idProduct		= 0x8600,
+	  .bInterfaceClass	= USB_CLASS_VIDEO,
+	  .bInterfaceSubClass	= 1,
+	  .bInterfaceProtocol	= 0,
+	  .driver_info		= UVC_QUIRK_PROBE_DEF },
 	/* Foxlink ("HP Webcam" on HP Mini 5103) */
 	{ .match_flags		= USB_DEVICE_ID_MATCH_DEVICE
 				| USB_DEVICE_ID_MATCH_INT_INFO,
-- 
Regards,

Laurent Pinchart
