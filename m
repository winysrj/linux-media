Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:47386 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752313AbdHHM4T (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 8 Aug 2017 08:56:19 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hans.verkuil@cisco.com>
Cc: linux-media@vger.kernel.org,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: [PATCH 3/5] uvcvideo: Fix .queue_setup() to check the number of planes
Date: Tue,  8 Aug 2017 15:56:22 +0300
Message-Id: <20170808125624.11328-4-laurent.pinchart@ideasonboard.com>
In-Reply-To: <20170808125624.11328-1-laurent.pinchart@ideasonboard.com>
References: <20170808125624.11328-1-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>

According to documentation of struct vb2_ops the .queue_setup() callback
should return an error if the number of planes parameter contains an
invalid value on input. Fix this instead of ignoring the value.

Signed-off-by: Guennadi Liakhovetski <guennadi.liakhovetski@intel.com>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/usb/uvc/uvc_queue.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/media/usb/uvc/uvc_queue.c b/drivers/media/usb/uvc/uvc_queue.c
index aa2199775cb8..c8d78b2f3de4 100644
--- a/drivers/media/usb/uvc/uvc_queue.c
+++ b/drivers/media/usb/uvc/uvc_queue.c
@@ -82,9 +82,14 @@ static int uvc_queue_setup(struct vb2_queue *vq,
 	struct uvc_streaming *stream = uvc_queue_to_stream(queue);
 	unsigned size = stream->ctrl.dwMaxVideoFrameSize;
 
-	/* Make sure the image size is large enough. */
+	/*
+	 * When called with plane sizes, validate them. The driver supports
+	 * single planar formats only, and requires buffers to be large enough
+	 * to store a complete frame.
+	 */
 	if (*nplanes)
-		return sizes[0] < size ? -EINVAL : 0;
+		return *nplanes != 1 || sizes[0] < size ? -EINVAL : 0;
+
 	*nplanes = 1;
 	sizes[0] = size;
 	return 0;
-- 
Regards,

Laurent Pinchart
