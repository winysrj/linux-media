Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:43766 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751506AbeERUmK (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 18 May 2018 16:42:10 -0400
From: Kieran Bingham <kieran@ksquared.org.uk>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        stable@vger.kernel.org
Subject: [PATCH v11 01/10] media: v4l: vsp1: Release buffers for each video node
Date: Fri, 18 May 2018 21:41:54 +0100
Message-Id: <f05e7c227e8ab1f0c5d65ccdcb92c7c20c00594a.1526675940.git-series.kieran.bingham+renesas@ideasonboard.com>
In-Reply-To: <cover.4fb0850a617881b465a66140fdf06941777212ae.1526675940.git-series.kieran.bingham+renesas@ideasonboard.com>
References: <cover.4fb0850a617881b465a66140fdf06941777212ae.1526675940.git-series.kieran.bingham+renesas@ideasonboard.com>
In-Reply-To: <cover.4fb0850a617881b465a66140fdf06941777212ae.1526675940.git-series.kieran.bingham+renesas@ideasonboard.com>
References: <cover.4fb0850a617881b465a66140fdf06941777212ae.1526675940.git-series.kieran.bingham+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>

Commit 372b2b0399fc ("media: v4l: vsp1: Release buffers in
start_streaming error path") introduced a helper to clean up buffers on
error paths, but inadvertently changed the code such that only the
output WPF buffers were cleaned, rather than the video node being
operated on.

Since then vsp1_video_cleanup_pipeline() has grown to perform both video
node cleanup, as well as pipeline cleanup. Split the implementation into
two distinct functions that perform the required work, so that each
video node can release it's buffers correctly on streamoff. The pipe
cleanup that was performed in the vsp1_video_stop_streaming() (releasing
the pipe->dl) is moved to the function for clarity.

Fixes: 372b2b0399fc ("media: v4l: vsp1: Release buffers in start_streaming error path")
Cc: stable@vger.kernel.org # v4.13+

Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
---
 drivers/media/platform/vsp1/vsp1_video.c | 21 +++++++++++++--------
 1 file changed, 13 insertions(+), 8 deletions(-)

diff --git a/drivers/media/platform/vsp1/vsp1_video.c b/drivers/media/platform/vsp1/vsp1_video.c
index c8c12223a267..ba89dd176a13 100644
--- a/drivers/media/platform/vsp1/vsp1_video.c
+++ b/drivers/media/platform/vsp1/vsp1_video.c
@@ -842,9 +842,8 @@ static int vsp1_video_setup_pipeline(struct vsp1_pipeline *pipe)
 	return 0;
 }
 
-static void vsp1_video_cleanup_pipeline(struct vsp1_pipeline *pipe)
+static void vsp1_video_release_buffers(struct vsp1_video *video)
 {
-	struct vsp1_video *video = pipe->output->video;
 	struct vsp1_vb2_buffer *buffer;
 	unsigned long flags;
 
@@ -854,12 +853,18 @@ static void vsp1_video_cleanup_pipeline(struct vsp1_pipeline *pipe)
 		vb2_buffer_done(&buffer->buf.vb2_buf, VB2_BUF_STATE_ERROR);
 	INIT_LIST_HEAD(&video->irqqueue);
 	spin_unlock_irqrestore(&video->irqlock, flags);
+}
+
+static void vsp1_video_cleanup_pipeline(struct vsp1_pipeline *pipe)
+{
+	lockdep_assert_held(&pipe->lock);
 
 	/* Release our partition table allocation */
-	mutex_lock(&pipe->lock);
 	kfree(pipe->part_table);
 	pipe->part_table = NULL;
-	mutex_unlock(&pipe->lock);
+
+	vsp1_dl_list_put(pipe->dl);
+	pipe->dl = NULL;
 }
 
 static int vsp1_video_start_streaming(struct vb2_queue *vq, unsigned int count)
@@ -874,8 +879,9 @@ static int vsp1_video_start_streaming(struct vb2_queue *vq, unsigned int count)
 	if (pipe->stream_count == pipe->num_inputs) {
 		ret = vsp1_video_setup_pipeline(pipe);
 		if (ret < 0) {
-			mutex_unlock(&pipe->lock);
+			vsp1_video_release_buffers(video);
 			vsp1_video_cleanup_pipeline(pipe);
+			mutex_unlock(&pipe->lock);
 			return ret;
 		}
 
@@ -925,13 +931,12 @@ static void vsp1_video_stop_streaming(struct vb2_queue *vq)
 		if (ret == -ETIMEDOUT)
 			dev_err(video->vsp1->dev, "pipeline stop timeout\n");
 
-		vsp1_dl_list_put(pipe->dl);
-		pipe->dl = NULL;
+		vsp1_video_cleanup_pipeline(pipe);
 	}
 	mutex_unlock(&pipe->lock);
 
 	media_pipeline_stop(&video->video.entity);
-	vsp1_video_cleanup_pipeline(pipe);
+	vsp1_video_release_buffers(video);
 	vsp1_video_pipeline_put(pipe);
 }
 
-- 
git-series 0.9.1
