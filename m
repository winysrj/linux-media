Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.irobotique.be ([92.243.18.41]:36539 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760286AbZLPAKn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 15 Dec 2009 19:10:43 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: "lcostantino@gmail.com" <lcostantino@gmail.com>
Subject: Re: uvcvideo kernel panic when using libv4l
Date: Wed, 16 Dec 2009 01:12:41 +0100
Cc: Pablo Baena <pbaena@gmail.com>, linux-media@vger.kernel.org,
	Hans de Goede <hdegoede@redhat.com>
References: <36be2c7a0912070918h23cee33bia26c85b13d242ca9@mail.gmail.com> <200912101646.26333.laurent.pinchart@ideasonboard.com> <alpine.DEB.2.00.0912130447360.13585@localhost.localdomain>
In-Reply-To: <alpine.DEB.2.00.0912130447360.13585@localhost.localdomain>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <200912160112.41754.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Leandro and Pablo,

could you please try the following patch ? It closes a race window that I
believe could be at the core of your kernel panic.

diff -r c1f376eae978 linux/drivers/media/video/uvc/uvc_queue.c
--- a/linux/drivers/media/video/uvc/uvc_queue.c	Sat Dec 12 18:57:17 2009 +0100
+++ b/linux/drivers/media/video/uvc/uvc_queue.c	Wed Dec 16 01:10:21 2009 +0100
@@ -59,7 +59,7 @@
  *    returns immediately.
  *
  *    When the buffer is full, the completion handler removes it from the irq
- *    queue, marks it as ready (UVC_BUF_STATE_DONE) and wakes its wait queue.
+ *    queue, marks it as ready (UVC_BUF_STATE_READY) and wakes its wait queue.
  *    At that point, any process waiting on the buffer will be woken up. If a
  *    process tries to dequeue a buffer after it has been marked ready, the
  *    dequeing will succeed immediately.
@@ -196,11 +196,12 @@
 
 	switch (buf->state) {
 	case UVC_BUF_STATE_ERROR:
-	case UVC_BUF_STATE_DONE:
+	case UVC_BUF_STATE_READY:
 		v4l2_buf->flags |= V4L2_BUF_FLAG_DONE;
 		break;
 	case UVC_BUF_STATE_QUEUED:
 	case UVC_BUF_STATE_ACTIVE:
+	case UVC_BUF_STATE_DONE:
 		v4l2_buf->flags |= V4L2_BUF_FLAG_QUEUED;
 		break;
 	case UVC_BUF_STATE_IDLE:
@@ -341,13 +342,14 @@
 		uvc_trace(UVC_TRACE_CAPTURE, "[W] Corrupted data "
 			"(transmission error).\n");
 		ret = -EIO;
-	case UVC_BUF_STATE_DONE:
+	case UVC_BUF_STATE_READY:
 		buf->state = UVC_BUF_STATE_IDLE;
 		break;
 
 	case UVC_BUF_STATE_IDLE:
 	case UVC_BUF_STATE_QUEUED:
 	case UVC_BUF_STATE_ACTIVE:
+	case UVC_BUF_STATE_DONE:
 	default:
 		uvc_trace(UVC_TRACE_CAPTURE, "[E] Invalid buffer state %u "
 			"(driver bug?).\n", buf->state);
@@ -383,7 +385,7 @@
 	buf = list_first_entry(&queue->mainqueue, struct uvc_buffer, stream);
 
 	poll_wait(file, &buf->wait, wait);
-	if (buf->state == UVC_BUF_STATE_DONE ||
+	if (buf->state == UVC_BUF_STATE_READY ||
 	    buf->state == UVC_BUF_STATE_ERROR)
 		mask |= POLLIN | POLLRDNORM;
 
@@ -489,6 +491,7 @@
 
 	spin_lock_irqsave(&queue->irqlock, flags);
 	list_del(&buf->queue);
+	buf->state = UVC_BUF_STATE_READY;
 	if (!list_empty(&queue->irqqueue))
 		nextbuf = list_first_entry(&queue->irqqueue, struct uvc_buffer,
 					   queue);
diff -r c1f376eae978 linux/drivers/media/video/uvc/uvc_video.c
--- a/linux/drivers/media/video/uvc/uvc_video.c	Sat Dec 12 18:57:17 2009 +0100
+++ b/linux/drivers/media/video/uvc/uvc_video.c	Wed Dec 16 01:10:21 2009 +0100
@@ -578,8 +578,7 @@
 		uvc_video_decode_end(stream, buf, mem,
 			urb->iso_frame_desc[i].actual_length);
 
-		if (buf->state == UVC_BUF_STATE_DONE ||
-		    buf->state == UVC_BUF_STATE_ERROR)
+		if (buf->state == UVC_BUF_STATE_DONE)
 			buf = uvc_queue_next_buffer(&stream->queue, buf);
 	}
 }
@@ -637,8 +636,7 @@
 		if (!stream->bulk.skip_payload && buf != NULL) {
 			uvc_video_decode_end(stream, buf, stream->bulk.header,
 				stream->bulk.payload_size);
-			if (buf->state == UVC_BUF_STATE_DONE ||
-			    buf->state == UVC_BUF_STATE_ERROR)
+			if (buf->state == UVC_BUF_STATE_DONE)
 				buf = uvc_queue_next_buffer(&stream->queue,
 							    buf);
 		}
diff -r c1f376eae978 linux/drivers/media/video/uvc/uvcvideo.h
--- a/linux/drivers/media/video/uvc/uvcvideo.h	Sat Dec 12 18:57:17 2009 +0100
+++ b/linux/drivers/media/video/uvc/uvcvideo.h	Wed Dec 16 01:10:21 2009 +0100
@@ -370,7 +370,8 @@
 	UVC_BUF_STATE_QUEUED	= 1,
 	UVC_BUF_STATE_ACTIVE	= 2,
 	UVC_BUF_STATE_DONE	= 3,
-	UVC_BUF_STATE_ERROR	= 4,
+	UVC_BUF_STATE_READY	= 4,
+	UVC_BUF_STATE_ERROR	= 5,
 };
 
 struct uvc_buffer {

-- 
Regards,

Laurent Pinchart
