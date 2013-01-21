Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:34689 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752440Ab3AUKuD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Jan 2013 05:50:03 -0500
Received: from avalon.ideasonboard.com (unknown [91.178.41.12])
	by perceval.ideasonboard.com (Postfix) with ESMTPSA id D0A4635A69
	for <linux-media@vger.kernel.org>; Mon, 21 Jan 2013 11:50:02 +0100 (CET)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [PATCH] uvcvideo: Implement videobuf2 .wait_prepare and .wait_finish operations
Date: Mon, 21 Jan 2013 11:51:41 +0100
Message-Id: <1358765501-29285-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Those optional operations are used to release and reacquire the queue
lock when videobuf2 needs to perform operations that sleep for a long
time, such as waiting for a buffer to be complete. Implement them to
avoid blocking qbuf or streamoff calls when a dqbuf is in progress.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/usb/uvc/uvc_queue.c |   16 ++++++++++++++++
 1 files changed, 16 insertions(+), 0 deletions(-)

diff --git a/drivers/media/usb/uvc/uvc_queue.c b/drivers/media/usb/uvc/uvc_queue.c
index 778addc..6c233a5 100644
--- a/drivers/media/usb/uvc/uvc_queue.c
+++ b/drivers/media/usb/uvc/uvc_queue.c
@@ -115,11 +115,27 @@ static int uvc_buffer_finish(struct vb2_buffer *vb)
 	return 0;
 }
 
+static void uvc_wait_prepare(struct vb2_queue *vq)
+{
+	struct uvc_video_queue *queue = vb2_get_drv_priv(vq);
+
+	mutex_unlock(&queue->mutex);
+}
+
+static void uvc_wait_finish(struct vb2_queue *vq)
+{
+	struct uvc_video_queue *queue = vb2_get_drv_priv(vq);
+
+	mutex_lock(&queue->mutex);
+}
+
 static struct vb2_ops uvc_queue_qops = {
 	.queue_setup = uvc_queue_setup,
 	.buf_prepare = uvc_buffer_prepare,
 	.buf_queue = uvc_buffer_queue,
 	.buf_finish = uvc_buffer_finish,
+	.wait_prepare = uvc_wait_prepare,
+	.wait_finish = uvc_wait_finish,
 };
 
 int uvc_queue_init(struct uvc_video_queue *queue, enum v4l2_buf_type type,
-- 
Regards,

Laurent Pinchart

