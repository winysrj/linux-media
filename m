Return-path: <linux-media-owner@vger.kernel.org>
Received: from r0.smtpout1.paris1.alwaysdata.com ([188.72.70.1]:34725 "EHLO
        r0.smtpout1.paris1.alwaysdata.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752035AbdLACIz (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 30 Nov 2017 21:08:55 -0500
From: Alexandre Macabies <web+oss@zopieux.com>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: [PATCH 1/1] media: uvcvideo: Add quirk to support light switch on Dino-Lite cameras
Date: Fri,  1 Dec 2017 02:21:25 +0100
Message-Id: <20171201012125.8941-2-web+oss@zopieux.com>
In-Reply-To: <20171201012125.8941-1-web+oss@zopieux.com>
References: <20171201012125.8941-1-web+oss@zopieux.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The Dino-Lite cameras are equipped with LED lights that can be switched
on and off by setting a proprietary control. For this control, the
camera reports a length of 1 byte, but actually the value set by the
original Windows driver is 3 byte long. This makes it impossible to
toggle the camera lights from uvcvideo, as the length from GET_LEN is
trusted as being the right one.

This is to make GET_LEN indicate a length of 3 instead of 1 for this
specific device.

Signed-off-by: Alexandre Macabies <web+oss@zopieux.com>
---
 drivers/media/usb/uvc/uvc_driver.c |  9 +++++++++
 drivers/media/usb/uvc/uvc_video.c  | 10 ++++++++++
 drivers/media/usb/uvc/uvcvideo.h   |  1 +
 3 files changed, 20 insertions(+)

diff --git a/drivers/media/usb/uvc/uvc_driver.c b/drivers/media/usb/uvc/uvc_driver.c
index 28b91b7d7..17689a242 100644
--- a/drivers/media/usb/uvc/uvc_driver.c
+++ b/drivers/media/usb/uvc/uvc_driver.c
@@ -2734,6 +2734,15 @@ static const struct usb_device_id uvc_ids[] = {
 	  .bInterfaceSubClass	= 1,
 	  .bInterfaceProtocol	= 0,
 	  .driver_info		= UVC_QUIRK_FORCE_Y8 },
+	/* Dino-Lite Premier AM4111T */
+	{ .match_flags		= USB_DEVICE_ID_MATCH_DEVICE
+				| USB_DEVICE_ID_MATCH_INT_INFO,
+	  .idVendor		= 0xa168,
+	  .idProduct		= 0x0870,
+	  .bInterfaceClass	= USB_CLASS_VIDEO,
+	  .bInterfaceSubClass	= 1,
+	  .bInterfaceProtocol	= 0,
+	  .driver_info		= UVC_QUIRK_LIGHT_CTRL_LEN },
 	/* Generic USB Video Class */
 	{ USB_INTERFACE_INFO(USB_CLASS_VIDEO, 1, UVC_PC_PROTOCOL_UNDEFINED) },
 	{ USB_INTERFACE_INFO(USB_CLASS_VIDEO, 1, UVC_PC_PROTOCOL_15) },
diff --git a/drivers/media/usb/uvc/uvc_video.c b/drivers/media/usb/uvc/uvc_video.c
index fb86d6af3..702bf03c7 100644
--- a/drivers/media/usb/uvc/uvc_video.c
+++ b/drivers/media/usb/uvc/uvc_video.c
@@ -83,6 +83,16 @@ int uvc_query_ctrl(struct uvc_device *dev, __u8 query, __u8 unit,
 		return -EIO;
 	}
 
+	/* The Dino-Lite Premier camera lies about a specific query length:
+	 * control 3 unit 4 (LED light on/off) expects a 3 byte payload but
+	 * the camera reports only 1 byte when queried for GET_LEN.
+	 */
+	if ((dev->quirks & UVC_QUIRK_LIGHT_CTRL_LEN) && query == UVC_GET_LEN
+		&& cs == 3 && unit == 4 && size == 2) {
+		put_unaligned_le16(3, data);
+		return 0;
+	}
+
 	return 0;
 }
 
diff --git a/drivers/media/usb/uvc/uvcvideo.h b/drivers/media/usb/uvc/uvcvideo.h
index 05398784d..bb6a74920 100644
--- a/drivers/media/usb/uvc/uvcvideo.h
+++ b/drivers/media/usb/uvc/uvcvideo.h
@@ -186,6 +186,7 @@
 #define UVC_QUIRK_RESTRICT_FRAME_RATE	0x00000200
 #define UVC_QUIRK_RESTORE_CTRLS_ON_INIT	0x00000400
 #define UVC_QUIRK_FORCE_Y8		0x00000800
+#define UVC_QUIRK_LIGHT_CTRL_LEN	0x00001000
 
 /* Format flags */
 #define UVC_FMT_FLAG_COMPRESSED		0x00000001
-- 
2.15.1
