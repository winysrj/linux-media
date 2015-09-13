Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:52348 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755359AbbIMU5T (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 13 Sep 2015 16:57:19 -0400
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: linux-sh@vger.kernel.org
Subject: [PATCH 10/32] v4l: vsp1: Decouple pipeline end of frame processing from vsp1_video
Date: Sun, 13 Sep 2015 23:56:48 +0300
Message-Id: <1442177830-24536-11-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <1442177830-24536-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1442177830-24536-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

To make the pipeline structure and operations usable without video
devices the frame end processing must be decoupled from struct
vsp1_video. Implement this by calling the video frame end function
indirectly through a function pointer in struct vsp1_pipeline.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/media/platform/vsp1/vsp1_video.c | 25 +++++++++++++++++--------
 drivers/media/platform/vsp1/vsp1_video.h |  2 ++
 2 files changed, 19 insertions(+), 8 deletions(-)

diff --git a/drivers/media/platform/vsp1/vsp1_video.c b/drivers/media/platform/vsp1/vsp1_video.c
index c726d76bd570..c86a4065ea9c 100644
--- a/drivers/media/platform/vsp1/vsp1_video.c
+++ b/drivers/media/platform/vsp1/vsp1_video.c
@@ -617,8 +617,9 @@ vsp1_video_complete_buffer(struct vsp1_video *video)
 }
 
 static void vsp1_video_frame_end(struct vsp1_pipeline *pipe,
-				 struct vsp1_video *video)
+				 struct vsp1_rwpf *rwpf)
 {
+	struct vsp1_video *video = rwpf->video;
 	struct vsp1_vb2_buffer *buf;
 	unsigned long flags;
 
@@ -634,21 +635,28 @@ static void vsp1_video_frame_end(struct vsp1_pipeline *pipe,
 	spin_unlock_irqrestore(&pipe->irqlock, flags);
 }
 
+static void vsp1_video_pipeline_frame_end(struct vsp1_pipeline *pipe)
+{
+	unsigned int i;
+
+	/* Complete buffers on all video nodes. */
+	for (i = 0; i < pipe->num_inputs; ++i)
+		vsp1_video_frame_end(pipe, pipe->inputs[i]);
+
+	if (!pipe->lif)
+		vsp1_video_frame_end(pipe, pipe->output);
+}
+
 void vsp1_pipeline_frame_end(struct vsp1_pipeline *pipe)
 {
 	enum vsp1_pipeline_state state;
 	unsigned long flags;
-	unsigned int i;
 
 	if (pipe == NULL)
 		return;
 
-	/* Complete buffers on all video nodes. */
-	for (i = 0; i < pipe->num_inputs; ++i)
-		vsp1_video_frame_end(pipe, pipe->inputs[i]->video);
-
-	if (!pipe->lif)
-		vsp1_video_frame_end(pipe, pipe->output->video);
+	/* Signal frame end to the pipeline handler. */
+	pipe->frame_end(pipe);
 
 	spin_lock_irqsave(&pipe->irqlock, flags);
 
@@ -1223,6 +1231,7 @@ struct vsp1_video *vsp1_video_create(struct vsp1_device *vsp1,
 	INIT_LIST_HEAD(&video->pipe.entities);
 	init_waitqueue_head(&video->pipe.wq);
 	video->pipe.state = VSP1_PIPELINE_STOPPED;
+	video->pipe.frame_end = vsp1_video_pipeline_frame_end;
 
 	/* Initialize the media entity... */
 	ret = media_entity_init(&video->video.entity, 1, &video->pad, 0);
diff --git a/drivers/media/platform/vsp1/vsp1_video.h b/drivers/media/platform/vsp1/vsp1_video.h
index cea6d1f3f07b..d2d229ed8aa7 100644
--- a/drivers/media/platform/vsp1/vsp1_video.h
+++ b/drivers/media/platform/vsp1/vsp1_video.h
@@ -70,6 +70,8 @@ struct vsp1_pipeline {
 	enum vsp1_pipeline_state state;
 	wait_queue_head_t wq;
 
+	void (*frame_end)(struct vsp1_pipeline *pipe);
+
 	struct mutex lock;
 	unsigned int use_count;
 	unsigned int stream_count;
-- 
2.4.6

