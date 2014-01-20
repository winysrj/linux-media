Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f175.google.com ([209.85.212.175]:47658 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750942AbaATIL3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Jan 2014 03:11:29 -0500
Received: by mail-wi0-f175.google.com with SMTP id hr1so2859033wib.8
        for <linux-media@vger.kernel.org>; Mon, 20 Jan 2014 00:11:28 -0800 (PST)
MIME-Version: 1.0
Date: Mon, 20 Jan 2014 09:11:28 +0100
Message-ID: <CAENiEt-OA==jH_tA4HBP68RW3vGga99dpuFE+Zx7=QNYBqeC5A@mail.gmail.com>
Subject: [PATCH] Added bayer 8-bit patterns to uvcvideo
From: Edgar Thier <info@edgarthier.net>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add bayer 8-bit GUIDs to uvcvideo and
associate them with the corresponding V4L2 pixel formats.

Signed-off-by: Edgar Thier <info@edgarthier.net>
---
 drivers/media/usb/uvc/uvc_driver.c | 22 +++++++++++++++++++++-
 drivers/media/usb/uvc/uvcvideo.h   | 12 ++++++++++++
 2 files changed, 33 insertions(+), 1 deletion(-)

diff --git a/drivers/media/usb/uvc/uvc_driver.c
b/drivers/media/usb/uvc/uvc_driver.c
index c3bb250..84da426 100644
--- a/drivers/media/usb/uvc/uvc_driver.c
+++ b/drivers/media/usb/uvc/uvc_driver.c
@@ -108,11 +108,31 @@ static struct uvc_format_desc uvc_fmts[] = {
         .fcc        = V4L2_PIX_FMT_Y16,
     },
     {
-        .name        = "RGB Bayer",
+        .name        = "RGB Bayer (bggr)",
         .guid        = UVC_GUID_FORMAT_BY8,
         .fcc        = V4L2_PIX_FMT_SBGGR8,
     },
     {
+        .name        = "RGB Bayer (bggr)",
+        .guid        = UVC_GUID_FORMAT_BY8_BA81,
+        .fcc        = V4L2_PIX_FMT_SBGGR8,
+    },
+    {
+        .name        = "RGB Bayer (grbg)",
+        .guid        = UVC_GUID_FORMAT_BY8_GRBG,
+        .fcc        = V4L2_PIX_FMT_SGRBG8,
+    },
+    {
+        .name        = "RGB Bayer (gbrg)",
+        .guid        = UVC_GUID_FORMAT_BY8_GBRG,
+        .fcc        = V4L2_PIX_FMT_SGBRG8,
+    },
+    {
+        .name        = "RGB Bayer (rggb)",
+        .guid        = UVC_GUID_FORMAT_BY8_RGGB,
+        .fcc        = V4L2_PIX_FMT_SRGGB8,
+    },
+    {
         .name        = "RGB565",
         .guid        = UVC_GUID_FORMAT_RGBP,
         .fcc        = V4L2_PIX_FMT_RGB565,
diff --git a/drivers/media/usb/uvc/uvcvideo.h b/drivers/media/usb/uvc/uvcvideo.h
index 9e35982..57357d9 100644
--- a/drivers/media/usb/uvc/uvcvideo.h
+++ b/drivers/media/usb/uvc/uvcvideo.h
@@ -94,6 +94,18 @@
 #define UVC_GUID_FORMAT_BY8 \
     { 'B',  'Y',  '8',  ' ', 0x00, 0x00, 0x10, 0x00, \
      0x80, 0x00, 0x00, 0xaa, 0x00, 0x38, 0x9b, 0x71}
+#define UVC_GUID_FORMAT_BY8_BA81 \
+    { 'B',  'A',  '8',  '1', 0x00, 0x00, 0x10, 0x00, \
+     0x80, 0x00, 0x00, 0xaa, 0x00, 0x38, 0x9b, 0x71}
+#define UVC_GUID_FORMAT_BY8_GRBG \
+    { 'G',  'R',  'B',  'G', 0x00, 0x00, 0x10, 0x00, \
+     0x80, 0x00, 0x00, 0xaa, 0x00, 0x38, 0x9b, 0x71}
+#define UVC_GUID_FORMAT_BY8_GBRG \
+    { 'G',  'B',  'R',  'G', 0x00, 0x00, 0x10, 0x00, \
+     0x80, 0x00, 0x00, 0xaa, 0x00, 0x38, 0x9b, 0x71}
+#define UVC_GUID_FORMAT_BY8_RGGB \
+    { 'R',  'G',  'G',  'B', 0x00, 0x00, 0x10, 0x00, \
+     0x80, 0x00, 0x00, 0xaa, 0x00, 0x38, 0x9b, 0x71}
 #define UVC_GUID_FORMAT_RGBP \
     { 'R',  'G',  'B',  'P', 0x00, 0x00, 0x10, 0x00, \
      0x80, 0x00, 0x00, 0xaa, 0x00, 0x38, 0x9b, 0x71}
-- 
1.8.5.3
