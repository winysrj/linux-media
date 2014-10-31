Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:51711 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933774AbaJaPJu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 31 Oct 2014 11:09:50 -0400
Received: from avalon.ideasonboard.com (dsl-hkibrasgw3-50ddcc-40.dhcp.inet.fi [80.221.204.40])
	by galahad.ideasonboard.com (Postfix) with ESMTPSA id 1F7742000F
	for <linux-media@vger.kernel.org>; Fri, 31 Oct 2014 16:07:36 +0100 (CET)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [PATCH v3 08/10] uvcvideo: Rename uvc_alloc_buffers to uvc_request_buffers
Date: Fri, 31 Oct 2014 17:09:49 +0200
Message-Id: <1414768191-4536-9-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1414768191-4536-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1414768191-4536-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This brings the function name in line with the V4L2 API terminology.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/usb/uvc/uvc_queue.c | 4 ++--
 drivers/media/usb/uvc/uvc_v4l2.c  | 2 +-
 drivers/media/usb/uvc/uvcvideo.h  | 2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/media/usb/uvc/uvc_queue.c b/drivers/media/usb/uvc/uvc_queue.c
index 708478f..5c11de0 100644
--- a/drivers/media/usb/uvc/uvc_queue.c
+++ b/drivers/media/usb/uvc/uvc_queue.c
@@ -205,8 +205,8 @@ void uvc_queue_release(struct uvc_video_queue *queue)
  * V4L2 queue operations
  */
 
-int uvc_alloc_buffers(struct uvc_video_queue *queue,
-		      struct v4l2_requestbuffers *rb)
+int uvc_request_buffers(struct uvc_video_queue *queue,
+			struct v4l2_requestbuffers *rb)
 {
 	int ret;
 
diff --git a/drivers/media/usb/uvc/uvc_v4l2.c b/drivers/media/usb/uvc/uvc_v4l2.c
index 1b6b6db..5ba023b 100644
--- a/drivers/media/usb/uvc/uvc_v4l2.c
+++ b/drivers/media/usb/uvc/uvc_v4l2.c
@@ -690,7 +690,7 @@ static int uvc_ioctl_reqbufs(struct file *file, void *fh,
 		return ret;
 
 	mutex_lock(&stream->mutex);
-	ret = uvc_alloc_buffers(&stream->queue, rb);
+	ret = uvc_request_buffers(&stream->queue, rb);
 	mutex_unlock(&stream->mutex);
 	if (ret < 0)
 		return ret;
diff --git a/drivers/media/usb/uvc/uvcvideo.h b/drivers/media/usb/uvc/uvcvideo.h
index 344aede..2dc247a 100644
--- a/drivers/media/usb/uvc/uvcvideo.h
+++ b/drivers/media/usb/uvc/uvcvideo.h
@@ -624,7 +624,7 @@ extern struct uvc_entity *uvc_entity_by_id(struct uvc_device *dev, int id);
 extern int uvc_queue_init(struct uvc_video_queue *queue,
 		enum v4l2_buf_type type, int drop_corrupted);
 extern void uvc_queue_release(struct uvc_video_queue *queue);
-extern int uvc_alloc_buffers(struct uvc_video_queue *queue,
+extern int uvc_request_buffers(struct uvc_video_queue *queue,
 		struct v4l2_requestbuffers *rb);
 extern int uvc_query_buffer(struct uvc_video_queue *queue,
 		struct v4l2_buffer *v4l2_buf);
-- 
2.0.4

