Return-path: <mchehab@pedra>
Received: from mailfe06.c2i.net ([212.247.154.162]:33503 "EHLO swip.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756646Ab1FVKQy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 22 Jun 2011 06:16:54 -0400
Received: from [188.126.198.129] (account mc467741@c2i.net HELO laptop002.hselasky.homeunix.org)
  by mailfe06.swip.net (CommuniGate Pro SMTP 5.2.19)
  with ESMTPA id 142647963 for linux-media@vger.kernel.org; Wed, 22 Jun 2011 12:16:51 +0200
From: Hans Petter Selasky <hselasky@c2i.net>
To: linux-media@vger.kernel.org
Subject: [PATCH] Improve UVC buffering with regard to USB. Add checks to avoid division by zero.
Date: Wed, 22 Jun 2011 12:15:18 +0200
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Message-Id: <201106221215.18806.hselasky@c2i.net>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi,

In the UVC driver, the amount of buffering is controlled by the picture frame size divided by 
the USB packet size. This can sometimes lead to too small or too big buffers. The solution is 
to fix the buffer size with regard to the amount of buffering time:

This patch will fix ISOCHRONOUS buffers around 2x16ms of buffering time. This should give around 
1000 / 16 = 62 IRQ/s, which should suffice for up to 60 FPS unbuffered. If the frame rate goes 
beyond 60FPS it is likely that there will be data loss due to too small buffers.

BULK buffers are fixed around 2x16K for non FULL speed and 2x4K for FULL speed USB, 
regardless of the frame size. This is a well known good combination for BULK buffering.

--HPS

>From 9a9225cbfe22c978d3b92892580c2ca1e6f5abb2 Mon Sep 17 00:00:00 2001
From: Hans Petter Selasky <hselasky@c2i.net>
Date: Wed, 22 Jun 2011 12:02:15 +0200
Subject: [PATCH] Improve UVC buffering with regard to USB. Add checks to avoid division by zero.

Signed-off-by: Hans Petter Selasky <hselasky@c2i.net>
---
 drivers/media/video/uvc/uvc_video.c |   38 ++++++++++++++++++++++++++++++----
 drivers/media/video/uvc/uvcvideo.h  |    4 +-
 2 files changed, 35 insertions(+), 7 deletions(-)

diff --git a/drivers/media/video/uvc/uvc_video.c b/drivers/media/video/uvc/uvc_video.c
index fc766b9..dfc5978 100644
--- a/drivers/media/video/uvc/uvc_video.c
+++ b/drivers/media/video/uvc/uvc_video.c
@@ -823,9 +823,7 @@ static int uvc_alloc_urb_buffers(struct uvc_streaming *stream,
 	/* Compute the number of packets. Bulk endpoints might transfer UVC
 	 * payloads across multiple URBs.
 	 */
-	npackets = DIV_ROUND_UP(size, psize);
-	if (npackets > UVC_MAX_PACKETS)
-		npackets = UVC_MAX_PACKETS;
+	npackets = size / psize;
 
 	/* Retry allocations until one succeed. */
 	for (; npackets > 1; npackets /= 2) {
@@ -888,8 +886,25 @@ static int uvc_init_video_isoc(struct uvc_streaming *stream,
 	u32 size;
 
 	psize = le16_to_cpu(ep->desc.wMaxPacketSize);
-	psize = (psize & 0x07ff) * (1 + ((psize >> 11) & 3));
-	size = stream->ctrl.dwMaxVideoFrameSize;
+
+	if (stream->dev->udev->speed == USB_SPEED_FULL) {
+		/* (8000 >> 3) = 1000 FPS */
+		psize = (psize & 0x07ff);
+		size = (UVC_MAX_PACKETS >> 3) * psize;
+	} else {
+		/* 1000 - 8000 FPS, figure out */
+		psize = (psize & 0x07ff) * (1 + ((psize >> 11) & 3));
+		size = ep->desc.bInterval;
+		if (size > 0)
+			size --;
+		if (size > 3)
+			size = 3;
+		size = (UVC_MAX_PACKETS >> size) * psize;
+	}
+
+	/* avoid division by zero */
+	if (psize == 0)
+		return -EINVAL;
 
 	npackets = uvc_alloc_urb_buffers(stream, size, psize, gfp_flags);
 	if (npackets == 0)
@@ -943,6 +958,19 @@ static int uvc_init_video_bulk(struct uvc_streaming *stream,
 	size = stream->ctrl.dwMaxPayloadTransferSize;
 	stream->bulk.max_payload_size = size;
 
+	/* avoid division by zero */
+	if (psize == 0)
+		return -EINVAL;
+
+	/* roughly compute size for buffers */
+	if (stream->dev->udev->speed == USB_SPEED_FULL) {
+		size = 4096;
+	} else {
+		size = 16384;
+	}
+	/* align to packet boundary */
+	size += (psize - (size % psize)) % psize;
+
 	npackets = uvc_alloc_urb_buffers(stream, size, psize, gfp_flags);
 	if (npackets == 0)
 		return -ENOMEM;
diff --git a/drivers/media/video/uvc/uvcvideo.h b/drivers/media/video/uvc/uvcvideo.h
index 45f01e7..2adbaf2 100644
--- a/drivers/media/video/uvc/uvcvideo.h
+++ b/drivers/media/video/uvc/uvcvideo.h
@@ -161,9 +161,9 @@ struct uvc_xu_control {
 #define DRIVER_VERSION		"v1.0.0"
 
 /* Number of isochronous URBs. */
-#define UVC_URBS		5
+#define UVC_URBS		2U
 /* Maximum number of packets per URB. */
-#define UVC_MAX_PACKETS		32
+#define UVC_MAX_PACKETS		128U	/* at 8000 FPS */
 /* Maximum number of video buffers. */
 #define UVC_MAX_VIDEO_BUFFERS	32
 /* Maximum status buffer size in bytes of interrupt URB. */
-- 
1.7.1.1

