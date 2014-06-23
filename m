Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:47310 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753193AbaFWXyG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Jun 2014 19:54:06 -0400
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: linux-sh@vger.kernel.org
Subject: [PATCH v2 08/23] v4l: vsp1: Fix pipeline stop timeout
Date: Tue, 24 Jun 2014 01:54:14 +0200
Message-Id: <1403567669-18539-9-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <1403567669-18539-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1403567669-18539-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

If the pipeline was already stopped when stopping the stream, no
frame end interrupt will be generated and the driver will time out
waiting for the pipeline to stop.

Fix this by setting the pipeline state to STOPPED when the pipeline is
idle waiting for frames to process, and to STOPPING at stream stop time
only when the pipeline is currently RUNNING.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/media/platform/vsp1/vsp1_video.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/media/platform/vsp1/vsp1_video.c b/drivers/media/platform/vsp1/vsp1_video.c
index 9bb156c..a60332e 100644
--- a/drivers/media/platform/vsp1/vsp1_video.c
+++ b/drivers/media/platform/vsp1/vsp1_video.c
@@ -471,7 +471,8 @@ static int vsp1_pipeline_stop(struct vsp1_pipeline *pipe)
 	int ret;
 
 	spin_lock_irqsave(&pipe->irqlock, flags);
-	pipe->state = VSP1_PIPELINE_STOPPING;
+	if (pipe->state == VSP1_PIPELINE_RUNNING)
+		pipe->state = VSP1_PIPELINE_STOPPING;
 	spin_unlock_irqrestore(&pipe->irqlock, flags);
 
 	ret = wait_event_timeout(pipe->wq, pipe->state == VSP1_PIPELINE_STOPPED,
@@ -576,6 +577,7 @@ static void vsp1_video_frame_end(struct vsp1_pipeline *pipe,
 
 void vsp1_pipeline_frame_end(struct vsp1_pipeline *pipe)
 {
+	enum vsp1_pipeline_state state;
 	unsigned long flags;
 	unsigned int i;
 
@@ -591,11 +593,13 @@ void vsp1_pipeline_frame_end(struct vsp1_pipeline *pipe)
 
 	spin_lock_irqsave(&pipe->irqlock, flags);
 
+	state = pipe->state;
+	pipe->state = VSP1_PIPELINE_STOPPED;
+
 	/* If a stop has been requested, mark the pipeline as stopped and
 	 * return.
 	 */
-	if (pipe->state == VSP1_PIPELINE_STOPPING) {
-		pipe->state = VSP1_PIPELINE_STOPPED;
+	if (state == VSP1_PIPELINE_STOPPING) {
 		wake_up(&pipe->wq);
 		goto done;
 	}
-- 
1.8.5.5

