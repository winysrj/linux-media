Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:35733 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751941Ab2IQNt4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 17 Sep 2012 09:49:56 -0400
Received: by yhmm54 with SMTP id m54so1498641yhm.19
        for <linux-media@vger.kernel.org>; Mon, 17 Sep 2012 06:49:56 -0700 (PDT)
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>,
	<linux-media@vger.kernel.org>
Cc: Ezequiel Garcia <elezegarcia@gmail.com>
Subject: [PATCH 4/4] uvc: Add return code check at vb2_queue_init()
Date: Mon, 17 Sep 2012 10:49:50 -0300
Message-Id: <1347889790-15187-1-git-send-email-elezegarcia@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This function returns an integer and it's mandatory
to check the return code.

Signed-off-by: Ezequiel Garcia <elezegarcia@gmail.com>
---
 drivers/media/usb/uvc/uvc_queue.c |    8 ++++++--
 drivers/media/usb/uvc/uvc_video.c |    4 +++-
 drivers/media/usb/uvc/uvcvideo.h  |    2 +-
 3 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/media/usb/uvc/uvc_queue.c b/drivers/media/usb/uvc/uvc_queue.c
index 5577381..2cec818 100644
--- a/drivers/media/usb/uvc/uvc_queue.c
+++ b/drivers/media/usb/uvc/uvc_queue.c
@@ -122,16 +122,20 @@ static struct vb2_ops uvc_queue_qops = {
 	.buf_finish = uvc_buffer_finish,
 };
 
-void uvc_queue_init(struct uvc_video_queue *queue, enum v4l2_buf_type type,
+int uvc_queue_init(struct uvc_video_queue *queue, enum v4l2_buf_type type,
 		    int drop_corrupted)
 {
+	int rc;
+
 	queue->queue.type = type;
 	queue->queue.io_modes = VB2_MMAP | VB2_USERPTR;
 	queue->queue.drv_priv = queue;
 	queue->queue.buf_struct_size = sizeof(struct uvc_buffer);
 	queue->queue.ops = &uvc_queue_qops;
 	queue->queue.mem_ops = &vb2_vmalloc_memops;
-	vb2_queue_init(&queue->queue);
+	rc = vb2_queue_init(&queue->queue);
+	if (rc)
+		return rc;
 
 	mutex_init(&queue->mutex);
 	spin_lock_init(&queue->irqlock);
diff --git a/drivers/media/usb/uvc/uvc_video.c b/drivers/media/usb/uvc/uvc_video.c
index 1c15b42..57c3076 100644
--- a/drivers/media/usb/uvc/uvc_video.c
+++ b/drivers/media/usb/uvc/uvc_video.c
@@ -1755,7 +1755,9 @@ int uvc_video_init(struct uvc_streaming *stream)
 	atomic_set(&stream->active, 0);
 
 	/* Initialize the video buffers queue. */
-	uvc_queue_init(&stream->queue, stream->type, !uvc_no_drop_param);
+	ret = uvc_queue_init(&stream->queue, stream->type, !uvc_no_drop_param);
+	if (ret)
+		return ret;
 
 	/* Alternate setting 0 should be the default, yet the XBox Live Vision
 	 * Cam (and possibly other devices) crash or otherwise misbehave if
diff --git a/drivers/media/usb/uvc/uvcvideo.h b/drivers/media/usb/uvc/uvcvideo.h
index 3764040..af216ec 100644
--- a/drivers/media/usb/uvc/uvcvideo.h
+++ b/drivers/media/usb/uvc/uvcvideo.h
@@ -600,7 +600,7 @@ extern struct uvc_driver uvc_driver;
 extern struct uvc_entity *uvc_entity_by_id(struct uvc_device *dev, int id);
 
 /* Video buffers queue management. */
-extern void uvc_queue_init(struct uvc_video_queue *queue,
+extern int uvc_queue_init(struct uvc_video_queue *queue,
 		enum v4l2_buf_type type, int drop_corrupted);
 extern int uvc_alloc_buffers(struct uvc_video_queue *queue,
 		struct v4l2_requestbuffers *rb);
-- 
1.7.8.6

