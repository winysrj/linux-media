Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f46.google.com ([209.85.218.46]:33713 "EHLO
	mail-oi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753934AbbFJBJJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 9 Jun 2015 21:09:09 -0400
Message-ID: <1433898546.11979.6.camel@gmail.com>
Subject: Re: [PATCH] USB: uvc: add support for the Microsoft Surface Pro 3
 Cameras
From: Dennis Chen <barracks510@gmail.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
	linux-media <linux-media@vger.kernel.org>
Date: Tue, 09 Jun 2015 18:09:06 -0700
In-Reply-To: <3765742.rat6LA2JPE@avalon>
References: <1433879614.3036.3.camel@gmail.com> <3765742.rat6LA2JPE@avalon>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add support for the Microsoft Surface Pro 3 Cameras.

Signed-off-by: Dennis Chen <barracks510@gmail.com>
---
 drivers/media/usb/uvc/uvc_driver.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/drivers/media/usb/uvc/uvc_driver.c b/drivers/media/usb/uvc/uvc_driver.c
index 5970dd6..ec5a407 100644
--- a/drivers/media/usb/uvc/uvc_driver.c
+++ b/drivers/media/usb/uvc/uvc_driver.c
@@ -2538,6 +2538,22 @@ static struct usb_device_id uvc_ids[] = {
          .bInterfaceSubClass   = 1,
          .bInterfaceProtocol   = 0,
          .driver_info          = UVC_QUIRK_FORCE_Y8 },
+       /*Microsoft Surface Pro 3 Front Camera*/
+       { .match_flags          = USB_DEVICE_ID_MATCH_DEVICE
+                               | USB_DEVICE_ID_MATCH_INT_INFO,
+         .idVendor             = 0x045e,
+         .idProduct            = 0x07be,
+         .bInterfaceClass      = USB_CLASS_VIDEO,
+         .bInterfaceSubClass   = 1,
+         .bInterfaceProtocol   = 1 },
+       /* Microsoft Surface Pro 3 Rear */
+       { .match_flags          = USB_DEVICE_ID_MATCH_DEVICE
+                               | USB_DEVICE_ID_MATCH_INT_INFO,
+         .idVendor             = 0x045e,
+         .idProduct            = 0x07bf,
+         .bInterfaceClass      = USB_CLASS_VIDEO,
+         .bInterfaceSubClass   = 1,
+         .bInterfaceProtocol   = 1 },
        /* Generic USB Video Class */
        { USB_INTERFACE_INFO(USB_CLASS_VIDEO, 1, 0) },
        {}
-- 
2.4.2
