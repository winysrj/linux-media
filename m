Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:42357 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756369AbaBRPdV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 18 Feb 2014 10:33:21 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH v2 1/3] uvcvideo: Remove duplicate check for number of buffers in queue_setup
Date: Tue, 18 Feb 2014 16:34:14 +0100
Message-Id: <1392737656-16177-2-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1392737656-16177-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1392737656-16177-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

videobuf2 already ensures that the number of buffers will not exceed
VIDEO_MAX_FRAME, which is equal to our arbitraty limit of
UVC_MAX_VIDEO_BUFFERS. Remove the duplicate check.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Tested-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/usb/uvc/uvc_queue.c | 3 ---
 drivers/media/usb/uvc/uvcvideo.h  | 2 --
 2 files changed, 5 deletions(-)

diff --git a/drivers/media/usb/uvc/uvc_queue.c b/drivers/media/usb/uvc/uvc_queue.c
index cd962be..254bc34 100644
--- a/drivers/media/usb/uvc/uvc_queue.c
+++ b/drivers/media/usb/uvc/uvc_queue.c
@@ -48,9 +48,6 @@ static int uvc_queue_setup(struct vb2_queue *vq, const struct v4l2_format *fmt,
 	struct uvc_streaming *stream =
 			container_of(queue, struct uvc_streaming, queue);
 
-	if (*nbuffers > UVC_MAX_VIDEO_BUFFERS)
-		*nbuffers = UVC_MAX_VIDEO_BUFFERS;
-
 	*nplanes = 1;
 
 	sizes[0] = stream->ctrl.dwMaxVideoFrameSize;
diff --git a/drivers/media/usb/uvc/uvcvideo.h b/drivers/media/usb/uvc/uvcvideo.h
index 9e35982..6173632 100644
--- a/drivers/media/usb/uvc/uvcvideo.h
+++ b/drivers/media/usb/uvc/uvcvideo.h
@@ -115,8 +115,6 @@
 #define UVC_URBS		5
 /* Maximum number of packets per URB. */
 #define UVC_MAX_PACKETS		32
-/* Maximum number of video buffers. */
-#define UVC_MAX_VIDEO_BUFFERS	32
 /* Maximum status buffer size in bytes of interrupt URB. */
 #define UVC_MAX_STATUS_SIZE	16
 
-- 
1.8.3.2

