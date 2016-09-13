Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:46920 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1759217AbcIMXQg (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 13 Sep 2016 19:16:36 -0400
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org,
        Kieran Bingham <kieran+renesas@ksquared.org.uk>
Subject: [PATCH 04/13] v4l: vsp1: Repair race between frame end and qbuf handler
Date: Wed, 14 Sep 2016 02:16:57 +0300
Message-Id: <1473808626-19488-5-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <1473808626-19488-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1473808626-19488-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Kieran Bingham <kieran+renesas@bingham.xyz>

The frame-end function releases and completes the buffers on the input
and output entities of the pipe before marking the pipe->state as
'STOPPED'. This introduces a race whereby with the pipe->state still
'RUNNING', a QBUF handler can commence processing a frame before the
frame_end function has completed.

In the event that this happens, a frame queued by QBUF hangs due to the
incorrect pipe->state setting which prevents vsp1_pipeline_run from
issuing a CMD_STRCMD.

By locking the entire function we prevent this from occurring, but we
also change the locking state of the buffer release code. This has been
analysed visually as acceptable, but it must be considered that this now
causes the video->irqlock to be taken under the pipe->irqlock context.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/media/platform/vsp1/vsp1_video.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/drivers/media/platform/vsp1/vsp1_video.c b/drivers/media/platform/vsp1/vsp1_video.c
index ed9759e8a6fc..cd7d215ed455 100644
--- a/drivers/media/platform/vsp1/vsp1_video.c
+++ b/drivers/media/platform/vsp1/vsp1_video.c
@@ -234,18 +234,13 @@ static void vsp1_video_frame_end(struct vsp1_pipeline *pipe,
 {
 	struct vsp1_video *video = rwpf->video;
 	struct vsp1_vb2_buffer *buf;
-	unsigned long flags;
 
 	buf = vsp1_video_complete_buffer(video);
 	if (buf == NULL)
 		return;
 
-	spin_lock_irqsave(&pipe->irqlock, flags);
-
 	video->rwpf->mem = buf->mem;
 	pipe->buffers_ready |= 1 << video->pipe_index;
-
-	spin_unlock_irqrestore(&pipe->irqlock, flags);
 }
 
 static void vsp1_video_pipeline_run(struct vsp1_pipeline *pipe)
@@ -285,6 +280,8 @@ static void vsp1_video_pipeline_frame_end(struct vsp1_pipeline *pipe)
 	unsigned long flags;
 	unsigned int i;
 
+	spin_lock_irqsave(&pipe->irqlock, flags);
+
 	/* Complete buffers on all video nodes. */
 	for (i = 0; i < vsp1->info->rpf_count; ++i) {
 		if (!pipe->inputs[i])
@@ -295,8 +292,6 @@ static void vsp1_video_pipeline_frame_end(struct vsp1_pipeline *pipe)
 
 	vsp1_video_frame_end(pipe, pipe->output);
 
-	spin_lock_irqsave(&pipe->irqlock, flags);
-
 	state = pipe->state;
 	pipe->state = VSP1_PIPELINE_STOPPED;
 
-- 
Regards,

Laurent Pinchart

