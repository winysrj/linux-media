Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:38886 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728198AbeKJCrM (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 9 Nov 2018 21:47:12 -0500
From: Kieran Bingham <kieran.bingham@ideasonboard.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Olivier BRAUN <olivier.braun@stereolabs.com>,
        Troy Kisky <troy.kisky@boundarydevices.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Philipp Zabel <philipp.zabel@gmail.com>,
        Ezequiel Garcia <ezequiel@collabora.com>,
        Kieran Bingham <kieran.bingham@ideasonboard.com>,
        Tomasz Figa <tfiga@google.com>,
        Keiichi Watanabe <keiichiw@chromium.org>
Subject: [PATCH v6 08/10] media: uvcvideo: Split uvc_video_enable into two
Date: Fri,  9 Nov 2018 17:05:31 +0000
Message-Id: <19c64dd691a1da00056545ea5bf19378f3d7ecfb.1541782862.git-series.kieran.bingham@ideasonboard.com>
In-Reply-To: <cover.cae3e85316d733416db58566a05055b6f30785a8.1541782862.git-series.kieran.bingham@ideasonboard.com>
References: <cover.cae3e85316d733416db58566a05055b6f30785a8.1541782862.git-series.kieran.bingham@ideasonboard.com>
In-Reply-To: <cover.cae3e85316d733416db58566a05055b6f30785a8.1541782862.git-series.kieran.bingham@ideasonboard.com>
References: <cover.cae3e85316d733416db58566a05055b6f30785a8.1541782862.git-series.kieran.bingham@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

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
index 2752e386f1e8..d09b0c882938 100644
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
index e19bdf089cc4..cd67506dc696 100644
--- a/drivers/media/usb/uvc/uvc_video.c
+++ b/drivers/media/usb/uvc/uvc_video.c
@@ -2076,38 +2076,10 @@ int uvc_video_init(struct uvc_streaming *stream)
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
@@ -2130,3 +2102,29 @@ int uvc_video_enable(struct uvc_streaming *stream, int enable)
 
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
index 94accfa3c009..b1b895c67122 100644
--- a/drivers/media/usb/uvc/uvcvideo.h
+++ b/drivers/media/usb/uvc/uvcvideo.h
@@ -786,7 +786,8 @@ void uvc_mc_cleanup_entity(struct uvc_entity *entity);
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
