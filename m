Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f195.google.com ([209.85.128.195]:35955 "EHLO
        mail-wr0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753175AbeBUL0d (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 21 Feb 2018 06:26:33 -0500
Received: by mail-wr0-f195.google.com with SMTP id u15so3468714wrg.3
        for <linux-media@vger.kernel.org>; Wed, 21 Feb 2018 03:26:32 -0800 (PST)
Message-ID: <1519212389.11643.13.camel@googlemail.com>
Subject: [PATCH] uvcvideo: add quirk to force Phytec CAM 004H to GBRG
From: Christoph Fritz <chf.fritz@googlemail.com>
Reply-To: chf.fritz@googlemail.com
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: linux-media <linux-media@vger.kernel.org>,
        Norbert Wesp <n.wesp@phytec.de>
Date: Wed, 21 Feb 2018 12:26:29 +0100
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds a quirk to force Phytec CAM 004H to format GBRG because
it is announcing its format wrong.

Signed-off-by: Christoph Fritz <chf.fritz@googlemail.com>
Tested-by: Norbert Wesp <n.wesp@phytec.de>
---
 drivers/media/usb/uvc/uvc_driver.c | 16 ++++++++++++++++
 drivers/media/usb/uvc/uvcvideo.h   |  1 +
 2 files changed, 17 insertions(+)

diff --git a/drivers/media/usb/uvc/uvc_driver.c b/drivers/media/usb/uvc/uvc_driver.c
index cde43b6..8bfa40b 100644
--- a/drivers/media/usb/uvc/uvc_driver.c
+++ b/drivers/media/usb/uvc/uvc_driver.c
@@ -406,6 +406,13 @@ static int uvc_parse_format(struct uvc_device *dev,
 				width_multiplier = 2;
 			}
 		}
+		if (dev->quirks & UVC_QUIRK_FORCE_GBRG) {
+			if (format->fcc == V4L2_PIX_FMT_SGRBG8) {
+				strlcpy(format->name, "GBRG Bayer (GBRG)",
+					sizeof(format->name));
+				format->fcc = V4L2_PIX_FMT_SGBRG8;
+			}
+		}
 
 		if (buffer[2] == UVC_VS_FORMAT_UNCOMPRESSED) {
 			ftype = UVC_VS_FRAME_UNCOMPRESSED;
@@ -2631,6 +2638,15 @@ static struct usb_device_id uvc_ids[] = {
 	  .bInterfaceClass	= USB_CLASS_VENDOR_SPEC,
 	  .bInterfaceSubClass	= 1,
 	  .bInterfaceProtocol	= 0 },
+	/* PHYTEC CAM 004H cameras */
+	{ .match_flags		= USB_DEVICE_ID_MATCH_DEVICE
+				| USB_DEVICE_ID_MATCH_INT_INFO,
+	  .idVendor		= 0x199e,
+	  .idProduct		= 0x8302,
+	  .bInterfaceClass	= USB_CLASS_VIDEO,
+	  .bInterfaceSubClass	= 1,
+	  .bInterfaceProtocol	= 0,
+	  .driver_info		= UVC_QUIRK_FORCE_GBRG },
 	/* Bodelin ProScopeHR */
 	{ .match_flags		= USB_DEVICE_ID_MATCH_DEVICE
 				| USB_DEVICE_ID_MATCH_DEV_HI
diff --git a/drivers/media/usb/uvc/uvcvideo.h b/drivers/media/usb/uvc/uvcvideo.h
index 7e4d3ee..ad51002 100644
--- a/drivers/media/usb/uvc/uvcvideo.h
+++ b/drivers/media/usb/uvc/uvcvideo.h
@@ -164,6 +164,7 @@
 #define UVC_QUIRK_RESTRICT_FRAME_RATE	0x00000200
 #define UVC_QUIRK_RESTORE_CTRLS_ON_INIT	0x00000400
 #define UVC_QUIRK_FORCE_Y8		0x00000800
+#define UVC_QUIRK_FORCE_GBRG		0x00001000
 
 /* Format flags */
 #define UVC_FMT_FLAG_COMPRESSED		0x00000001
-- 
2.1.4
