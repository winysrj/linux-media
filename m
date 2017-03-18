Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.phoenitydawn.de ([213.202.223.74]:35945 "EHLO
        mail.phoenitydawn.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751181AbdCRW6v (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 18 Mar 2017 18:58:51 -0400
From: Daniel Roschka <danielroschka@phoenitydawn.de>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org
Subject: [PATCH] Quirk for webcam in MacBook Pro 2016
Date: Sat, 18 Mar 2017 22:02:01 +0100
Message-ID: <4643839.ui0SUBUoba@buzzard>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add the probe def quirk for the webcam found in the Apple MacBook Pro 2016,
to get it working out of the box.

Signed-off-by: Daniel Roschka <danielroschka@phoenitydawn.de>
---
 drivers/media/usb/uvc/uvc_driver.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/media/usb/uvc/uvc_driver.c b/drivers/media/usb/uvc/
uvc_driver.c
index 04bf35063c4c..4d05be1c1053 100644
--- a/drivers/media/usb/uvc/uvc_driver.c
+++ b/drivers/media/usb/uvc/uvc_driver.c
@@ -2426,6 +2426,15 @@ static struct usb_device_id uvc_ids[] = {
          .bInterfaceProtocol   = 0,
          .driver_info          = UVC_QUIRK_PROBE_MINMAX
                                | UVC_QUIRK_BUILTIN_ISIGHT },
+       /* Apple Built-In iSight via iBridge */
+       { .match_flags          = USB_DEVICE_ID_MATCH_DEVICE
+                               | USB_DEVICE_ID_MATCH_INT_INFO,
+         .idVendor             = 0x05ac,
+         .idProduct            = 0x8600,
+         .bInterfaceClass      = USB_CLASS_VIDEO,
+         .bInterfaceSubClass   = 1,
+         .bInterfaceProtocol   = 0,
+         .driver_info          = UVC_QUIRK_PROBE_DEF },
        /* Foxlink ("HP Webcam" on HP Mini 5103) */
        { .match_flags          = USB_DEVICE_ID_MATCH_DEVICE
                                | USB_DEVICE_ID_MATCH_INT_INFO,
-- 
2.11.0
