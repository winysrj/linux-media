Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:35749 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750905AbcKGUP4 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 7 Nov 2016 15:15:56 -0500
Received: by mail-wm0-f68.google.com with SMTP id a20so7633606wme.2
        for <linux-media@vger.kernel.org>; Mon, 07 Nov 2016 12:15:56 -0800 (PST)
From: Philipp Zabel <philipp.zabel@gmail.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Thibaut Girka <thib@sitedethib.com>, linux-media@vger.kernel.org,
        Philipp Zabel <philipp.zabel@gmail.com>
Subject: [PATCH] [media] uvcvideo: add support for Oculus Rift Sensor
Date: Mon,  7 Nov 2016 21:15:47 +0100
Message-Id: <20161107201547.7537-1-philipp.zabel@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The Rift CV1 Sensor has bInterfaceClass set to vendor specific, so we
need an entry in uvc_ids to probe it. Just as the Rift DK2 IR tracker,
it misreports the pixel format as YUYV instead of Y8.

The sensor is configured with a low exposure time and high black level
by default, so that only bright IR sources can be seen.

Signed-off-by: Philipp Zabel <philipp.zabel@gmail.com>
---
 drivers/media/usb/uvc/uvc_driver.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/media/usb/uvc/uvc_driver.c b/drivers/media/usb/uvc/uvc_driver.c
index 0eaa9a9..b64bfe4 100644
--- a/drivers/media/usb/uvc/uvc_driver.c
+++ b/drivers/media/usb/uvc/uvc_driver.c
@@ -2583,6 +2583,15 @@ static struct usb_device_id uvc_ids[] = {
 	  .bInterfaceSubClass	= 1,
 	  .bInterfaceProtocol	= 0,
 	  .driver_info		= UVC_QUIRK_FORCE_Y8 },
+	/* Oculus VR Rift Sensor */
+	{ .match_flags		= USB_DEVICE_ID_MATCH_DEVICE
+				| USB_DEVICE_ID_MATCH_INT_INFO,
+	  .idVendor		= 0x2833,
+	  .idProduct		= 0x0211,
+	  .bInterfaceClass	= USB_CLASS_VENDOR_SPEC,
+	  .bInterfaceSubClass	= 1,
+	  .bInterfaceProtocol	= 0,
+	  .driver_info		= UVC_QUIRK_FORCE_Y8 },
 	/* Leap Motion Controller LM-010 */
 	{ .match_flags		= USB_DEVICE_ID_MATCH_DEVICE
 				| USB_DEVICE_ID_MATCH_INT_INFO,
-- 
2.10.2

