Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:41971 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755956AbaBRO0s (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 18 Feb 2014 09:26:48 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Philipp Zabel <p.zabel@pengutronix.de>
Cc: linux-media@vger.kernel.org
Subject: [PATCH 2/3] uvcvideo: Support allocating buffers larger than the current frame size
Date: Tue, 18 Feb 2014 15:27:48 +0100
Message-Id: <1392733669-5281-3-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1392733669-5281-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1392733669-5281-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The queue_setup handler takes an optional format argument that can be
used to allocate buffers for a format different than the current format.
The uvcvideo driver doesn't support changing the format when buffers
have been allocated, but there's no reason not to support allocating
buffers larger than the minimum size.

When the format argument isn't NULL verify that the requested image size
is large enough for the current format and use it for the buffer size.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/usb/uvc/uvc_queue.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/media/usb/uvc/uvc_queue.c b/drivers/media/usb/uvc/uvc_queue.c
index 254bc34..d46dd70 100644
--- a/drivers/media/usb/uvc/uvc_queue.c
+++ b/drivers/media/usb/uvc/uvc_queue.c
@@ -48,9 +48,14 @@ static int uvc_queue_setup(struct vb2_queue *vq, const struct v4l2_format *fmt,
 	struct uvc_streaming *stream =
 			container_of(queue, struct uvc_streaming, queue);
 
+	/* Make sure the image size is large enough. */
+	if (fmt && fmt->fmt.pix.sizeimage < stream->ctrl.dwMaxVideoFrameSize)
+		return -EINVAL;
+
 	*nplanes = 1;
 
-	sizes[0] = stream->ctrl.dwMaxVideoFrameSize;
+	sizes[0] = fmt ? fmt->fmt.pix.sizeimage
+		 : stream->ctrl.dwMaxVideoFrameSize;
 
 	return 0;
 }
-- 
1.8.3.2

