Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:35897 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752539AbcDWXtx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 23 Apr 2016 19:49:53 -0400
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org
Subject: [PATCH 09/13] v4l: vsp1: Move frame sequence number from video node to pipeline
Date: Sun, 24 Apr 2016 02:49:56 +0300
Message-Id: <1461455400-28767-10-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <1461455400-28767-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1461455400-28767-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The frame sequence number is global to the pipeline, there's no need to
store copies in each video node.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/media/platform/vsp1/vsp1_pipe.c  | 2 ++
 drivers/media/platform/vsp1/vsp1_pipe.h  | 2 ++
 drivers/media/platform/vsp1/vsp1_video.c | 4 +---
 drivers/media/platform/vsp1/vsp1_video.h | 1 -
 4 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/media/platform/vsp1/vsp1_pipe.c b/drivers/media/platform/vsp1/vsp1_pipe.c
index 0c1dc80eb304..be47c8a1a812 100644
--- a/drivers/media/platform/vsp1/vsp1_pipe.c
+++ b/drivers/media/platform/vsp1/vsp1_pipe.c
@@ -286,6 +286,8 @@ void vsp1_pipeline_frame_end(struct vsp1_pipeline *pipe)
 
 	if (pipe->frame_end)
 		pipe->frame_end(pipe);
+
+	pipe->sequence++;
 }
 
 /*
diff --git a/drivers/media/platform/vsp1/vsp1_pipe.h b/drivers/media/platform/vsp1/vsp1_pipe.h
index 7b56113511dd..febc62f99d6d 100644
--- a/drivers/media/platform/vsp1/vsp1_pipe.h
+++ b/drivers/media/platform/vsp1/vsp1_pipe.h
@@ -67,6 +67,7 @@ enum vsp1_pipeline_state {
  * @kref: pipeline reference count
  * @stream_count: number of streaming video nodes
  * @buffers_ready: bitmask of RPFs and WPFs with at least one buffer available
+ * @sequence: frame sequence number
  * @num_inputs: number of RPFs
  * @inputs: array of RPFs in the pipeline (indexed by RPF index)
  * @output: WPF at the output of the pipeline
@@ -90,6 +91,7 @@ struct vsp1_pipeline {
 	struct kref kref;
 	unsigned int stream_count;
 	unsigned int buffers_ready;
+	unsigned int sequence;
 
 	unsigned int num_inputs;
 	struct vsp1_rwpf *inputs[VSP1_MAX_RPF];
diff --git a/drivers/media/platform/vsp1/vsp1_video.c b/drivers/media/platform/vsp1/vsp1_video.c
index a9aec5c0bec6..34aa6427662d 100644
--- a/drivers/media/platform/vsp1/vsp1_video.c
+++ b/drivers/media/platform/vsp1/vsp1_video.c
@@ -219,7 +219,7 @@ vsp1_video_complete_buffer(struct vsp1_video *video)
 
 	spin_unlock_irqrestore(&video->irqlock, flags);
 
-	done->buf.sequence = video->sequence++;
+	done->buf.sequence = pipe->sequence;
 	done->buf.vb2_buf.timestamp = ktime_get_ns();
 	for (i = 0; i < done->buf.vb2_buf.num_planes; ++i)
 		vb2_set_plane_payload(&done->buf.vb2_buf, i,
@@ -805,8 +805,6 @@ vsp1_video_streamon(struct file *file, void *fh, enum v4l2_buf_type type)
 	if (video->queue.owner && video->queue.owner != file->private_data)
 		return -EBUSY;
 
-	video->sequence = 0;
-
 	/* Get a pipeline for the video node and start streaming on it. No link
 	 * touching an entity in the pipeline can be activated or deactivated
 	 * once streaming is started.
diff --git a/drivers/media/platform/vsp1/vsp1_video.h b/drivers/media/platform/vsp1/vsp1_video.h
index 867b00807c46..1595fd587fbc 100644
--- a/drivers/media/platform/vsp1/vsp1_video.h
+++ b/drivers/media/platform/vsp1/vsp1_video.h
@@ -49,7 +49,6 @@ struct vsp1_video {
 	void *alloc_ctx;
 	spinlock_t irqlock;
 	struct list_head irqqueue;
-	unsigned int sequence;
 };
 
 static inline struct vsp1_video *to_vsp1_video(struct video_device *vdev)
-- 
2.7.3

