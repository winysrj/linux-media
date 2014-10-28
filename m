Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f45.google.com ([74.125.82.45]:57961 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753918AbaJ1WaW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 28 Oct 2014 18:30:22 -0400
Received: by mail-wg0-f45.google.com with SMTP id x12so607222wgg.18
        for <linux-media@vger.kernel.org>; Tue, 28 Oct 2014 15:30:21 -0700 (PDT)
From: Arend van Spriel <aspriel@gmail.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org, Arend van Spriel <aspriel@gmail.com>
Subject: [PATCH] media: uvc: add support for Toshiba FHD Webcam
Date: Tue, 28 Oct 2014 23:30:18 +0100
Message-Id: <1414535418-6133-1-git-send-email-aspriel@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The webcam is identified as Toshiba webcam although it seems a module
from Chicony Electronics. Not sure about the model so just refering
to it as Toshiba webcam that is in Portege z30 laptop.

Signed-off-by: Arend van Spriel <aspriel@gmail.com>
---
 drivers/media/usb/uvc/uvc_driver.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/media/usb/uvc/uvc_driver.c b/drivers/media/usb/uvc/uvc_driver.c
index 7c8322d..f0b7eab 100644
--- a/drivers/media/usb/uvc/uvc_driver.c
+++ b/drivers/media/usb/uvc/uvc_driver.c
@@ -2193,6 +2193,14 @@ static struct usb_device_id uvc_ids[] = {
 	  .bInterfaceSubClass	= 1,
 	  .bInterfaceProtocol	= 0,
 	  .driver_info		= UVC_QUIRK_RESTRICT_FRAME_RATE },
+	/* Chicony (Toshiba FHD Webcam) */
+	{ .match_flags		= USB_DEVICE_ID_MATCH_DEVICE
+				| USB_DEVICE_ID_MATCH_INT_INFO,
+	  .idVendor		= 0x04f2,
+	  .idProduct		= 0xb3b2,
+	  .bInterfaceClass	= USB_CLASS_VIDEO,
+	  .bInterfaceSubClass	= 1,
+	  .bInterfaceProtocol	= 0 },
 	/* Alcor Micro AU3820 (Future Boy PC USB Webcam) */
 	{ .match_flags		= USB_DEVICE_ID_MATCH_DEVICE
 				| USB_DEVICE_ID_MATCH_INT_INFO,
-- 
1.9.1

