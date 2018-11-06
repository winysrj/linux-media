Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:55690 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726282AbeKGGyr (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 7 Nov 2018 01:54:47 -0500
From: Kieran Bingham <kieran@ksquared.org.uk>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Olivier BRAUN <olivier.braun@stereolabs.com>,
        Troy Kisky <troy.kisky@boundarydevices.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Philipp Zabel <philipp.zabel@gmail.com>,
        Ezequiel Garcia <ezequiel@collabora.com>,
        Kieran Bingham <kieran.bingham@ideasonboard.com>
Subject: [PATCH v5 7/9] media: uvcvideo: Split uvc_video_enable into two
Date: Tue,  6 Nov 2018 21:27:18 +0000
Message-Id: <5a6b4702bd9da438a0635901d2e44ca737842655.1541534872.git-series.kieran.bingham@ideasonboard.com>
In-Reply-To: <cover.dd42d667a7f7505b3639149635ef3a0b1431f280.1541534872.git-series.kieran.bingham@ideasonboard.com>
References: <cover.dd42d667a7f7505b3639149635ef3a0b1431f280.1541534872.git-series.kieran.bingham@ideasonboard.com>
In-Reply-To: <cover.dd42d667a7f7505b3639149635ef3a0b1431f280.1541534872.git-series.kieran.bingham@ideasonboard.com>
References: <cover.dd42d667a7f7505b3639149635ef3a0b1431f280.1541534872.git-series.kieran.bingham@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Kieran Bingham <kieran.bingham@ideasonboard.com>

uvc_video_enable() is used both to start and stop the video stream
object, however the single function entry point shares no code between
the two operations.

Split the function into two distinct calls, and rename to
uvc_video_start_streaming() and uvc_video_stop_streaming() as
appropriate.

Signed-off-by: Kieran Bingham <kieran.bingham@ideasonboard.com>
---
 drivers/media/usb/uvc/uvc_queue.c |  4 +-
 drivers/media/usb/uvc/uvc_video.c | 56 +++++++++++++++-----------------
 drivers/media/usb/uvc/uvcvideo.h  |  3 +-
 3 files changed, 31 insertions(+), 32 deletions(-)

diff --git a/drivers/media/usb/uvc/uvc_queue.c b/drivers/media/usb/uvc/uvc_queue.c
index cd8c03341de0..682698ec1118 100644
--- a/drivers/media/usb/uvc/uvc_queue.c
+++ b/drivers/media/usb/uvc/uvc_queue.c
@@ -176,7 +176,7 @@ static int uvc_start_streaming(struct vb2_queue *vq, unsigned int count)
 
 	queue->buf_used = 0;
 
-	ret = uvc_video_enable(stream, 1);
+	ret = uvc_video_start_streaming(stream);
 	if (ret == 0)
 		return 0;
 
@@ -194,7 +194,7 @@ static void uvc_stop_streaming(struct vb2_queue *vq)
 	lockdep_assert_irqs_enabled();
 
 	if (vq->type != V4L2_BUF_TYPE_META_CAPTURE)
-		uvc_video_enable(uvc_queue_to_stream(queue), 0);
+		uvc_video_stop_streaming(uvc_queue_to_stream(queue));
 
 	spin_lock_irq(&queue->irqlock);
 	uvc_queue_return_buffers(queue, UVC_BUF_STATE_ERROR);
diff --git a/drivers/media/usb/uvc/uvc_video.c b/drivers/media/usb/uvc/uvc_video.c
index ce9e40444507..0d35e933856a 100644
--- a/drivers/media/usb/uvc/uvc_video.c
+++ b/drivers/media/usb/uvc/uvc_video.c
@@ -2082,38 +2082,10 @@ int uvc_video_init(struct uvc_streaming *stream)
 	return 0;
 }
 
-/*
- * Enable or disable the video stream.
- */
-int uvc_video_enable(struct uvc_streaming *stream, int enable)
+int uvc_video_start_streaming(struct uvc_streaming *stream)
 {
 	int ret;
 
-	if (!enable) {
-		uvc_uninit_video(stream, 1);
-		if (stream->intf->num_altsetting > 1) {
-			usb_set_interface(stream->dev->udev,
-					  stream->intfnum, 0);
-		} else {
-			/* UVC doesn't specify how to inform a bulk-based device
-			 * when the video stream is stopped. Windows sends a
-			 * CLEAR_FEATURE(HALT) request to the video streaming
-			 * bulk endpoint, mimic the same behaviour.
-			 */
-			unsigned int epnum = stream->header.bEndpointAddress
-					   & USB_ENDPOINT_NUMBER_MASK;
-			unsigned int dir = stream->header.bEndpointAddress
-					 & USB_ENDPOINT_DIR_MASK;
-			unsigned int pipe;
-
-			pipe = usb_sndbulkpipe(stream->dev->udev, epnum) | dir;
-			usb_clear_halt(stream->dev->udev, pipe);
-		}
-
-		uvc_video_clock_cleanup(stream);
-		return 0;
-	}
-
 	ret = uvc_video_clock_init(stream);
 	if (ret < 0)
 		return ret;
@@ -2136,3 +2108,29 @@ int uvc_video_enable(struct uvc_streaming *stream, int enable)
 
 	return ret;
 }
+
+int uvc_video_stop_streaming(struct uvc_streaming *stream)
+{
+	uvc_uninit_video(stream, 1);
+	if (stream->intf->num_altsetting > 1) {
+		usb_set_interface(stream->dev->udev,
+				  stream->intfnum, 0);
+	} else {
+		/* UVC doesn't specify how to inform a bulk-based device
+		 * when the video stream is stopped. Windows sends a
+		 * CLEAR_FEATURE(HALT) request to the video streaming
+		 * bulk endpoint, mimic the same behaviour.
+		 */
+		unsigned int epnum = stream->header.bEndpointAddress
+				   & USB_ENDPOINT_NUMBER_MASK;
+		unsigned int dir = stream->header.bEndpointAddress
+				 & USB_ENDPOINT_DIR_MASK;
+		unsigned int pipe;
+
+		pipe = usb_sndbulkpipe(stream->dev->udev, epnum) | dir;
+		usb_clear_halt(stream->dev->udev, pipe);
+	}
+
+	uvc_video_clock_cleanup(stream);
+	return 0;
+}
diff --git a/drivers/media/usb/uvc/uvcvideo.h b/drivers/media/usb/uvc/uvcvideo.h
index 0953e2e59a79..c0a120496a1f 100644
--- a/drivers/media/usb/uvc/uvcvideo.h
+++ b/drivers/media/usb/uvc/uvcvideo.h
@@ -784,7 +784,8 @@ void uvc_mc_cleanup_entity(struct uvc_entity *entity);
 int uvc_video_init(struct uvc_streaming *stream);
 int uvc_video_suspend(struct uvc_streaming *stream);
 int uvc_video_resume(struct uvc_streaming *stream, int reset);
-int uvc_video_enable(struct uvc_streaming *stream, int enable);
+int uvc_video_start_streaming(struct uvc_streaming *stream);
+int uvc_video_stop_streaming(struct uvc_streaming *stream);
 int uvc_probe_video(struct uvc_streaming *stream,
 		    struct uvc_streaming_control *probe);
 int uvc_query_ctrl(struct uvc_device *dev, u8 query, u8 unit,
-- 
git-series 0.9.1
