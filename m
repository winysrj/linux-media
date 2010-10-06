Return-path: <mchehab@pedra>
Received: from perceval.irobotique.be ([92.243.18.41]:48874 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754363Ab0JFI7k (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 6 Oct 2010 04:59:40 -0400
Received: from localhost.localdomain (unknown [91.178.188.185])
	by perceval.irobotique.be (Postfix) with ESMTPSA id C43F935D63
	for <linux-media@vger.kernel.org>; Wed,  6 Oct 2010 08:59:38 +0000 (UTC)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [PATCH 02/14] uvcvideo: Restrict frame rates for Chicony CNF7129 webcam
Date: Wed,  6 Oct 2010 10:59:40 +0200
Message-Id: <1286355592-13603-3-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1286355592-13603-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1286355592-13603-1-git-send-email-laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

At all frame rates except 30fps and 5fps the camera produces very dark
pictures. Auto-exposure is probably disabled by the camera at all frame
rates except 30fps, making them pretty unusable.

Work around the problem by introducing a new RESTRICT_FRAME_RATE quirk
that disables all the frame rates except the default one.

Cc: stable.org
Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/video/uvc/uvc_driver.c |   15 +++++++++++++++
 drivers/media/video/uvc/uvcvideo.h   |    1 +
 2 files changed, 16 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/uvc/uvc_driver.c b/drivers/media/video/uvc/uvc_driver.c
index a4bdbac..93d78f6 100644
--- a/drivers/media/video/uvc/uvc_driver.c
+++ b/drivers/media/video/uvc/uvc_driver.c
@@ -486,6 +486,12 @@ static int uvc_parse_format(struct uvc_device *dev,
 			    max(frame->dwFrameInterval[0],
 				frame->dwDefaultFrameInterval));
 
+		if (dev->quirks & UVC_QUIRK_RESTRICT_FRAME_RATE) {
+			frame->bFrameIntervalType = 1;
+			frame->dwFrameInterval[0] =
+				frame->dwDefaultFrameInterval;
+		}
+
 		uvc_trace(UVC_TRACE_DESCR, "- %ux%u (%u.%u fps)\n",
 			frame->wWidth, frame->wHeight,
 			10000000/frame->dwDefaultFrameInterval,
@@ -2027,6 +2033,15 @@ static struct usb_device_id uvc_ids[] = {
 	  .bInterfaceClass	= USB_CLASS_VENDOR_SPEC,
 	  .bInterfaceSubClass	= 1,
 	  .bInterfaceProtocol	= 0 },
+	/* Chicony CNF7129 (Asus EEE 100HE) */
+	{ .match_flags		= USB_DEVICE_ID_MATCH_DEVICE
+				| USB_DEVICE_ID_MATCH_INT_INFO,
+	  .idVendor		= 0x04f2,
+	  .idProduct		= 0xb071,
+	  .bInterfaceClass	= USB_CLASS_VIDEO,
+	  .bInterfaceSubClass	= 1,
+	  .bInterfaceProtocol	= 0,
+	  .driver_info		= UVC_QUIRK_RESTRICT_FRAME_RATE },
 	/* Alcor Micro AU3820 (Future Boy PC USB Webcam) */
 	{ .match_flags		= USB_DEVICE_ID_MATCH_DEVICE
 				| USB_DEVICE_ID_MATCH_INT_INFO,
diff --git a/drivers/media/video/uvc/uvcvideo.h b/drivers/media/video/uvc/uvcvideo.h
index bdacf3b..892e0e5 100644
--- a/drivers/media/video/uvc/uvcvideo.h
+++ b/drivers/media/video/uvc/uvcvideo.h
@@ -182,6 +182,7 @@ struct uvc_xu_control {
 #define UVC_QUIRK_IGNORE_SELECTOR_UNIT	0x00000020
 #define UVC_QUIRK_FIX_BANDWIDTH		0x00000080
 #define UVC_QUIRK_PROBE_DEF		0x00000100
+#define UVC_QUIRK_RESTRICT_FRAME_RATE	0x00000200
 
 /* Format flags */
 #define UVC_FMT_FLAG_COMPRESSED		0x00000001
-- 
1.7.2.2

