Return-path: <linux-media-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.28]:3361 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751545AbZFLQx2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Jun 2009 12:53:28 -0400
Received: by yw-out-2324.google.com with SMTP id 5so1551849ywb.1
        for <linux-media@vger.kernel.org>; Fri, 12 Jun 2009 09:53:29 -0700 (PDT)
MIME-Version: 1.0
Date: Fri, 12 Jun 2009 12:53:29 -0400
Message-ID: <b24e53350906120953v7eeb595dpe58ca138dcf438b5@mail.gmail.com>
Subject: Fwd: [PATCH 2/2] uvc: Added two webcams with 'No FID' quirk.
From: Robert Krakora <rob.krakora@messagenetsystems.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Robert Krakora <rob.krakora@messagenetsystems.com>

Added two webcams with 'No FID' quirk.

Priority: normal

Signed-off-by: Robert Krakora <rob.krakora@messagenetsystems.com>

diff -r bff77ec33116 linux/drivers/media/video/uvc/uvc_driver.c
--- a/linux/drivers/media/video/uvc/uvc_driver.c        Thu Jun 11
18:44:23 2009 -0300
+++ b/linux/drivers/media/video/uvc/uvc_driver.c        Fri Jun 12
11:35:04 2009 -0400
@@ -1919,6 +1919,24 @@
          .bInterfaceSubClass   = 1,
          .bInterfaceProtocol   = 0,
          .driver_info          = UVC_QUIRK_STREAM_NO_FID },
+       /* Suyin Corp. HP Webcam */
+       { .match_flags          = USB_DEVICE_ID_MATCH_DEVICE
+                               | USB_DEVICE_ID_MATCH_INT_INFO,
+         .idVendor             = 0x064e,
+         .idProduct            = 0xa110,
+         .bInterfaceClass      = USB_CLASS_VIDEO,
+         .bInterfaceSubClass   = 1,
+         .bInterfaceProtocol   = 0,
+         .driver_info          = UVC_QUIRK_STREAM_NO_FID },
+       /* Creative Live! Cam Optia AF */
+       { .match_flags          = USB_DEVICE_ID_MATCH_DEVICE
+                               | USB_DEVICE_ID_MATCH_INT_INFO,
+         .idVendor             = 0x041e,
+         .idProduct            = 0x406d,
+         .bInterfaceClass      = USB_CLASS_VIDEO,
+         .bInterfaceSubClass   = 1,
+         .bInterfaceProtocol   = 0,
+         .driver_info          = UVC_QUIRK_STREAM_NO_FID },
        /* Aveo Technology USB 2.0 Camera */
        { .match_flags          = USB_DEVICE_ID_MATCH_DEVICE
                                | USB_DEVICE_ID_MATCH_INT_INFO,
