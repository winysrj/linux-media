Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:37484 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752558AbdHDQcu (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 4 Aug 2017 12:32:50 -0400
From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        hans.verkuil@cisco.com
Cc: laurent.pinchart@ideasonboard.com, kieran.bingham@ideasonboard.com,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Subject: [PATCH v4 1/7] v4l: vsp1: Release buffers in start_streaming error path
Date: Fri,  4 Aug 2017 17:32:38 +0100
Message-Id: <abafc888a5872a6bc275849fa52f4d8f3c301a64.1501864274.git-series.kieran.bingham+renesas@ideasonboard.com>
In-Reply-To: <cover.b619f10db4b4618832ca73df5688ce9f2f36596b.1501864274.git-series.kieran.bingham+renesas@ideasonboard.com>
References: <cover.b619f10db4b4618832ca73df5688ce9f2f36596b.1501864274.git-series.kieran.bingham+renesas@ideasonboard.com>
In-Reply-To: <cover.b619f10db4b4618832ca73df5688ce9f2f36596b.1501864274.git-series.kieran.bingham+renesas@ideasonboard.com>
References: <cover.b619f10db4b4618832ca73df5688ce9f2f36596b.1501864274.git-series.kieran.bingham+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Presently any received buffers are only released back to vb2 if
vsp1_video_stop_streaming() is called. If vsp1_video_start_streaming()
encounters an error, we will be warned by the vb2 handlers that buffers
have not been returned.

Move the buffer cleanup code to its own function to prevent duplication
and call from both vsp1_video_stop_streaming() and the error path in
vsp1_video_start_streaming().

Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/platform/vsp1/vsp1_video.c | 24 ++++++++++++++++--------
 1 file changed, 16 insertions(+), 8 deletions(-)

diff --git a/drivers/media/platform/vsp1/vsp1_video.c b/drivers/media/platform/vsp1/vsp1_video.c
index 5af3486afe07..fdb135e45fea 100644
--- a/drivers/media/platform/vsp1/vsp1_video.c
+++ b/drivers/media/platform/vsp1/vsp1_video.c
@@ -822,6 +822,20 @@ static int vsp1_video_setup_pipeline(struct vsp1_pipeline *pipe)
 	return 0;
 }
 
+static void vsp1_video_cleanup_pipeline(struct vsp1_pipeline *pipe)
+{
+	struct vsp1_video *video = pipe->output->video;
+	struct vsp1_vb2_buffer *buffer;
+	unsigned long flags;
+
+	/* Remove all buffers from the IRQ queue. */
+	spin_lock_irqsave(&video->irqlock, flags);
+	list_for_each_entry(buffer, &video->irqqueue, queue)
+		vb2_buffer_done(&buffer->buf.vb2_buf, VB2_BUF_STATE_ERROR);
+	INIT_LIST_HEAD(&video->irqqueue);
+	spin_unlock_irqrestore(&video->irqlock, flags);
+}
+
 static int vsp1_video_start_streaming(struct vb2_queue *vq, unsigned int count)
 {
 	struct vsp1_video *video = vb2_get_drv_priv(vq);
@@ -835,6 +849,7 @@ static int vsp1_video_start_streaming(struct vb2_queue *vq, unsigned int count)
 		ret = vsp1_video_setup_pipeline(pipe);
 		if (ret < 0) {
 			mutex_unlock(&pipe->lock);
+			vsp1_video_cleanup_pipeline(pipe);
 			return ret;
 		}
 
@@ -866,7 +881,6 @@ static void vsp1_video_stop_streaming(struct vb2_queue *vq)
 {
 	struct vsp1_video *video = vb2_get_drv_priv(vq);
 	struct vsp1_pipeline *pipe = video->rwpf->pipe;
-	struct vsp1_vb2_buffer *buffer;
 	unsigned long flags;
 	int ret;
 
@@ -891,14 +905,8 @@ static void vsp1_video_stop_streaming(struct vb2_queue *vq)
 	mutex_unlock(&pipe->lock);
 
 	media_pipeline_stop(&video->video.entity);
+	vsp1_video_cleanup_pipeline(pipe);
 	vsp1_video_pipeline_put(pipe);
-
-	/* Remove all buffers from the IRQ queue. */
-	spin_lock_irqsave(&video->irqlock, flags);
-	list_for_each_entry(buffer, &video->irqqueue, queue)
-		vb2_buffer_done(&buffer->buf.vb2_buf, VB2_BUF_STATE_ERROR);
-	INIT_LIST_HEAD(&video->irqqueue);
-	spin_unlock_irqrestore(&video->irqlock, flags);
 }
 
 static const struct vb2_ops vsp1_video_queue_qops = {
-- 
git-series 0.9.1
