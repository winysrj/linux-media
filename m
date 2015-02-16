Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:41978 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753114AbbBPSdo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Feb 2015 13:33:44 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Steven Zakulec <spzakulec@gmail.com>,
	Michael Hall <mhall119@gmail.com>
Subject: [PATCH] uvcvideo: Recognize the Tasco USB microscope
Date: Mon, 16 Feb 2015 20:34:36 +0200
Message-Id: <1424111676-26096-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The device is based on an Aveo chipset, implements UVC but advertises a
vendor-specific class on all interfaces.

Support it by listing the USB VID:PID explicitly.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/usb/uvc/uvc_driver.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/media/usb/uvc/uvc_driver.c b/drivers/media/usb/uvc/uvc_driver.c
index 7f5003c..62359f6 100644
--- a/drivers/media/usb/uvc/uvc_driver.c
+++ b/drivers/media/usb/uvc/uvc_driver.c
@@ -2482,6 +2482,14 @@ static struct usb_device_id uvc_ids[] = {
 	  .bInterfaceProtocol	= 0,
 	  .driver_info		= UVC_QUIRK_PROBE_MINMAX
 				| UVC_QUIRK_PROBE_EXTRAFIELDS },
+	/* Aveo Technology USB 2.0 Camera (Tasco USB Microscope) */
+	{ .match_flags		= USB_DEVICE_ID_MATCH_DEVICE
+				| USB_DEVICE_ID_MATCH_INT_INFO,
+	  .idVendor		= 0x1871,
+	  .idProduct		= 0x0516,
+	  .bInterfaceClass	= USB_CLASS_VENDOR_SPEC,
+	  .bInterfaceSubClass	= 1,
+	  .bInterfaceProtocol	= 0 },
 	/* Ecamm Pico iMage */
 	{ .match_flags		= USB_DEVICE_ID_MATCH_DEVICE
 				| USB_DEVICE_ID_MATCH_INT_INFO,
-- 
Regards,

Laurent Pinchart

