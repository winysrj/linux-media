Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:46912 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755700AbcIMXQb (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 13 Sep 2016 19:16:31 -0400
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org,
        Kieran Bingham <kieran+renesas@ksquared.org.uk>
Subject: [PATCH 01/13] v4l: vsp1: Prevent pipelines from running when not streaming
Date: Wed, 14 Sep 2016 02:16:54 +0300
Message-Id: <1473808626-19488-2-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <1473808626-19488-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1473808626-19488-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Pipelines can only be run if all their video nodes are streaming. Commit
b4dfb9b35a19 ("[media] v4l: vsp1: Stop the pipeline upon the first
STREAMOFF") fixed the pipeline stop sequence, but introduced a race
condition that makes it possible to run a pipeline after stopping the
stream on a video node by queuing a buffer on the other side of the
pipeline.

Fix this by clearing the buffers ready flag when stopping the stream,
which will prevent the QBUF handler from running the pipeline.

Fixes: b4dfb9b35a19 ("[media] v4l: vsp1: Stop the pipeline upon the first STREAMOFF")
Reported-by: Kieran Bingham <kieran@bingham.xyz>
Tested-by: Kieran Bingham <kieran@bingham.xyz>
Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/media/platform/vsp1/vsp1_video.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/media/platform/vsp1/vsp1_video.c b/drivers/media/platform/vsp1/vsp1_video.c
index 9fb4fc26a359..ed9759e8a6fc 100644
--- a/drivers/media/platform/vsp1/vsp1_video.c
+++ b/drivers/media/platform/vsp1/vsp1_video.c
@@ -675,6 +675,13 @@ static void vsp1_video_stop_streaming(struct vb2_queue *vq)
 	unsigned long flags;
 	int ret;
 
+	/* Clear the buffers ready flag to make sure the device won't be started
+	 * by a QBUF on the video node on the other side of the pipeline.
+	 */
+	spin_lock_irqsave(&video->irqlock, flags);
+	pipe->buffers_ready &= ~(1 << video->pipe_index);
+	spin_unlock_irqrestore(&video->irqlock, flags);
+
 	mutex_lock(&pipe->lock);
 	if (--pipe->stream_count == pipe->num_inputs) {
 		/* Stop the pipeline. */
-- 
Regards,

Laurent Pinchart

