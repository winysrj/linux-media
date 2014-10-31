Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:51710 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933791AbaJaPJs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 31 Oct 2014 11:09:48 -0400
Received: from avalon.ideasonboard.com (dsl-hkibrasgw3-50ddcc-40.dhcp.inet.fi [80.221.204.40])
	by galahad.ideasonboard.com (Postfix) with ESMTPSA id 24CCA217D5
	for <linux-media@vger.kernel.org>; Fri, 31 Oct 2014 16:07:35 +0100 (CET)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [PATCH v3 05/10] uvcvideo: Add function to convert from queue to stream
Date: Fri, 31 Oct 2014 17:09:46 +0200
Message-Id: <1414768191-4536-6-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1414768191-4536-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1414768191-4536-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Factorize the container_of() call into an inline function and update
callers.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/usb/uvc/uvc_queue.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/media/usb/uvc/uvc_queue.c b/drivers/media/usb/uvc/uvc_queue.c
index 6e92d20..9703655 100644
--- a/drivers/media/usb/uvc/uvc_queue.c
+++ b/drivers/media/usb/uvc/uvc_queue.c
@@ -36,6 +36,12 @@
  * the driver.
  */
 
+static inline struct uvc_streaming *
+uvc_queue_to_stream(struct uvc_video_queue *queue)
+{
+	return container_of(queue, struct uvc_streaming, queue);
+}
+
 /* -----------------------------------------------------------------------------
  * videobuf2 queue operations
  */
@@ -45,8 +51,7 @@ static int uvc_queue_setup(struct vb2_queue *vq, const struct v4l2_format *fmt,
 			   unsigned int sizes[], void *alloc_ctxs[])
 {
 	struct uvc_video_queue *queue = vb2_get_drv_priv(vq);
-	struct uvc_streaming *stream =
-			container_of(queue, struct uvc_streaming, queue);
+	struct uvc_streaming *stream = uvc_queue_to_stream(queue);
 
 	/* Make sure the image size is large enough. */
 	if (fmt && fmt->fmt.pix.sizeimage < stream->ctrl.dwMaxVideoFrameSize)
@@ -109,8 +114,7 @@ static void uvc_buffer_queue(struct vb2_buffer *vb)
 static void uvc_buffer_finish(struct vb2_buffer *vb)
 {
 	struct uvc_video_queue *queue = vb2_get_drv_priv(vb->vb2_queue);
-	struct uvc_streaming *stream =
-			container_of(queue, struct uvc_streaming, queue);
+	struct uvc_streaming *stream = uvc_queue_to_stream(queue);
 	struct uvc_buffer *buf = container_of(vb, struct uvc_buffer, buf);
 
 	if (vb->state == VB2_BUF_STATE_DONE)
-- 
2.0.4

