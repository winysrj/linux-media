Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:51196 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757639Ab2C0I6J (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 27 Mar 2012 04:58:09 -0400
Received: from localhost.localdomain (unknown [91.178.125.155])
	by perceval.ideasonboard.com (Postfix) with ESMTPSA id ADEED7B0B
	for <linux-media@vger.kernel.org>; Tue, 27 Mar 2012 10:58:07 +0200 (CEST)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [PATCH] uvcvideo: Fix race-related crash in uvc_video_clock_update()
Date: Tue, 27 Mar 2012 10:58:42 +0200
Message-Id: <1332838722-9309-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The driver frees the clock samples buffer before stopping the video
buffers queue. If a DQBUF call arrives in-between,
uvc_video_clock_update() will be called with a NULL clock samples
buffer, leading to a crash.

Move clock initialization/cleanup to uvc_video_enable() in order to free
the clock samples buffer after the queue is stopped. Make sure the clock
is reset at resume time to avoid miscalculating timestamps.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: stable@vger.kernel.org
---
 drivers/media/video/uvc/uvc_video.c |   50 ++++++++++++++++++++++------------
 1 files changed, 32 insertions(+), 18 deletions(-)

diff --git a/drivers/media/video/uvc/uvc_video.c b/drivers/media/video/uvc/uvc_video.c
index 4a44f9a..b76b0ac 100644
--- a/drivers/media/video/uvc/uvc_video.c
+++ b/drivers/media/video/uvc/uvc_video.c
@@ -468,22 +468,30 @@ uvc_video_clock_decode(struct uvc_streaming *stream, struct uvc_buffer *buf,
 	spin_unlock_irqrestore(&stream->clock.lock, flags);
 }
 
-static int uvc_video_clock_init(struct uvc_streaming *stream)
+static void uvc_video_clock_reset(struct uvc_streaming *stream)
 {
 	struct uvc_clock *clock = &stream->clock;
 
-	spin_lock_init(&clock->lock);
 	clock->head = 0;
 	clock->count = 0;
-	clock->size = 32;
 	clock->last_sof = -1;
 	clock->sof_offset = -1;
+}
+
+static int uvc_video_clock_init(struct uvc_streaming *stream)
+{
+	struct uvc_clock *clock = &stream->clock;
+
+	spin_lock_init(&clock->lock);
+	clock->size = 32;
 
 	clock->samples = kmalloc(clock->size * sizeof(*clock->samples),
 				 GFP_KERNEL);
 	if (clock->samples == NULL)
 		return -ENOMEM;
 
+	uvc_video_clock_reset(stream);
+
 	return 0;
 }
 
@@ -1424,8 +1432,6 @@ static void uvc_uninit_video(struct uvc_streaming *stream, int free_buffers)
 
 	if (free_buffers)
 		uvc_free_urb_buffers(stream);
-
-	uvc_video_clock_cleanup(stream);
 }
 
 /*
@@ -1555,10 +1561,6 @@ static int uvc_init_video(struct uvc_streaming *stream, gfp_t gfp_flags)
 
 	uvc_video_stats_start(stream);
 
-	ret = uvc_video_clock_init(stream);
-	if (ret < 0)
-		return ret;
-
 	if (intf->num_altsetting > 1) {
 		struct usb_host_endpoint *best_ep = NULL;
 		unsigned int best_psize = 3 * 1024;
@@ -1683,6 +1685,8 @@ int uvc_video_resume(struct uvc_streaming *stream, int reset)
 
 	stream->frozen = 0;
 
+	uvc_video_clock_reset(stream);
+
 	ret = uvc_commit_video(stream, &stream->ctrl);
 	if (ret < 0) {
 		uvc_queue_enable(&stream->queue, 0);
@@ -1819,25 +1823,35 @@ int uvc_video_enable(struct uvc_streaming *stream, int enable)
 		uvc_uninit_video(stream, 1);
 		usb_set_interface(stream->dev->udev, stream->intfnum, 0);
 		uvc_queue_enable(&stream->queue, 0);
+		uvc_video_clock_cleanup(stream);
 		return 0;
 	}
 
-	ret = uvc_queue_enable(&stream->queue, 1);
+	ret = uvc_video_clock_init(stream);
 	if (ret < 0)
 		return ret;
 
+	ret = uvc_queue_enable(&stream->queue, 1);
+	if (ret < 0)
+		goto error_queue;
+
 	/* Commit the streaming parameters. */
 	ret = uvc_commit_video(stream, &stream->ctrl);
-	if (ret < 0) {
-		uvc_queue_enable(&stream->queue, 0);
-		return ret;
-	}
+	if (ret < 0)
+		goto error_commit;
 
 	ret = uvc_init_video(stream, GFP_KERNEL);
-	if (ret < 0) {
-		usb_set_interface(stream->dev->udev, stream->intfnum, 0);
-		uvc_queue_enable(&stream->queue, 0);
-	}
+	if (ret < 0)
+		goto error_video;
+
+	return 0;
+
+error_video:
+	usb_set_interface(stream->dev->udev, stream->intfnum, 0);
+error_commit:
+	uvc_queue_enable(&stream->queue, 0);
+error_queue:
+	uvc_video_clock_cleanup(stream);
 
 	return ret;
 }
-- 
Regards,

Laurent Pinchart

