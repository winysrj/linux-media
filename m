Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f54.google.com ([209.85.220.54]:55210 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754045Ab3H3CRk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 29 Aug 2013 22:17:40 -0400
Received: by mail-pa0-f54.google.com with SMTP id kx10so1693437pab.41
        for <linux-media@vger.kernel.org>; Thu, 29 Aug 2013 19:17:39 -0700 (PDT)
From: Pawel Osciak <posciak@chromium.org>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com,
	Pawel Osciak <posciak@chromium.org>
Subject: [PATCH v1 07/19] uvcvideo: Unify error reporting during format descriptor parsing.
Date: Fri, 30 Aug 2013 11:17:06 +0900
Message-Id: <1377829038-4726-8-git-send-email-posciak@chromium.org>
In-Reply-To: <1377829038-4726-1-git-send-email-posciak@chromium.org>
References: <1377829038-4726-1-git-send-email-posciak@chromium.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add common error handling paths for format parsing failures.

Signed-off-by: Pawel Osciak <posciak@chromium.org>
---
 drivers/media/usb/uvc/uvc_driver.c | 35 ++++++++++++++---------------------
 1 file changed, 14 insertions(+), 21 deletions(-)

diff --git a/drivers/media/usb/uvc/uvc_driver.c b/drivers/media/usb/uvc/uvc_driver.c
index d950b40..936ddc7 100644
--- a/drivers/media/usb/uvc/uvc_driver.c
+++ b/drivers/media/usb/uvc/uvc_driver.c
@@ -322,13 +322,8 @@ static int uvc_parse_format(struct uvc_device *dev,
 	case UVC_VS_FORMAT_UNCOMPRESSED:
 	case UVC_VS_FORMAT_FRAME_BASED:
 		n = buffer[2] == UVC_VS_FORMAT_UNCOMPRESSED ? 27 : 28;
-		if (buflen < n) {
-			uvc_trace(UVC_TRACE_DESCR, "device %d videostreaming "
-			       "interface %d FORMAT error\n",
-			       dev->udev->devnum,
-			       alts->desc.bInterfaceNumber);
-			return -EINVAL;
-		}
+		if (buflen < n)
+			goto format_error;
 
 		/* Find the format descriptor from its GUID. */
 		fmtdesc = uvc_format_by_guid(&buffer[5]);
@@ -356,13 +351,8 @@ static int uvc_parse_format(struct uvc_device *dev,
 		break;
 
 	case UVC_VS_FORMAT_MJPEG:
-		if (buflen < 11) {
-			uvc_trace(UVC_TRACE_DESCR, "device %d videostreaming "
-			       "interface %d FORMAT error\n",
-			       dev->udev->devnum,
-			       alts->desc.bInterfaceNumber);
-			return -EINVAL;
-		}
+		if (buflen < 11)
+			goto format_error;
 
 		strlcpy(format->name, "MJPEG", sizeof format->name);
 		format->fcc = V4L2_PIX_FMT_MJPEG;
@@ -372,13 +362,8 @@ static int uvc_parse_format(struct uvc_device *dev,
 		break;
 
 	case UVC_VS_FORMAT_DV:
-		if (buflen < 9) {
-			uvc_trace(UVC_TRACE_DESCR, "device %d videostreaming "
-			       "interface %d FORMAT error\n",
-			       dev->udev->devnum,
-			       alts->desc.bInterfaceNumber);
-			return -EINVAL;
-		}
+		if (buflen < 9)
+			goto format_error;
 
 		switch (buffer[8] & 0x7f) {
 		case 0:
@@ -542,6 +527,14 @@ static int uvc_parse_format(struct uvc_device *dev,
 	}
 
 	return buffer - start;
+
+format_error:
+	uvc_trace(UVC_TRACE_DESCR, "device %d videostreaming "
+			"interface %d FORMAT error\n",
+			dev->udev->devnum,
+			alts->desc.bInterfaceNumber);
+	return -EINVAL;
+
 }
 
 static int uvc_parse_streaming(struct uvc_device *dev,
-- 
1.8.4

