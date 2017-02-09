Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f175.google.com ([209.85.128.175]:33772 "EHLO
        mail-wr0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751377AbdBINfZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 9 Feb 2017 08:35:25 -0500
Received: by mail-wr0-f175.google.com with SMTP id i10so83953536wrb.0
        for <linux-media@vger.kernel.org>; Thu, 09 Feb 2017 05:34:25 -0800 (PST)
From: Neil Armstrong <narmstrong@baylibre.com>
To: laurent.pinchart@ideasonboard.com
Cc: Neil Armstrong <narmstrong@baylibre.com>, mchehab@kernel.org,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] media: usb: uvc:  add a quirk for Generalplus Technology Inc. 808 Camera
Date: Thu,  9 Feb 2017 14:26:46 +0100
Message-Id: <1486646806-8217-1-git-send-email-narmstrong@baylibre.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As reported on [1], this device needs this quirk to be able to
reliably initialise the webcam.

[1] https://sourceforge.net/p/linux-uvc/mailman/message/33791098/

Signed-off-by: Neil Armstrong <narmstrong@baylibre.com>
---
 drivers/media/usb/uvc/uvc_driver.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/media/usb/uvc/uvc_driver.c b/drivers/media/usb/uvc/uvc_driver.c
index 04bf350..6b2d761 100644
--- a/drivers/media/usb/uvc/uvc_driver.c
+++ b/drivers/media/usb/uvc/uvc_driver.c
@@ -2671,6 +2671,15 @@ static int uvc_clock_param_set(const char *val, struct kernel_param *kp)
 	  .bInterfaceSubClass	= 1,
 	  .bInterfaceProtocol	= 0,
 	  .driver_info		= UVC_QUIRK_PROBE_MINMAX },
+	/* Generalplus Technology Inc. 808 Camera */
+	{ .match_flags		= USB_DEVICE_ID_MATCH_DEVICE
+				| USB_DEVICE_ID_MATCH_INT_INFO,
+	  .idVendor		= 0x1b3f,
+	  .idProduct		= 0x2002,
+	  .bInterfaceClass	= USB_CLASS_VIDEO,
+	  .bInterfaceSubClass	= 1,
+	  .bInterfaceProtocol	= 0,
+	  .driver_info		= UVC_QUIRK_PROBE_MINMAX },
 	/* SiGma Micro USB Web Camera */
 	{ .match_flags		= USB_DEVICE_ID_MATCH_DEVICE
 				| USB_DEVICE_ID_MATCH_INT_INFO,
-- 
1.9.1

