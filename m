Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:55018 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932240AbbLECNJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 4 Dec 2015 21:13:09 -0500
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: linux-sh@vger.kernel.org
Subject: [PATCH v2 12/32] v4l: vsp1: Rename video pipeline functions to use vsp1_video prefix
Date: Sat,  5 Dec 2015 04:12:46 +0200
Message-Id: <1449281586-25726-13-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <1449281586-25726-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1449281586-25726-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Those functions are specific to video nodes, rename them for
consistency.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/media/platform/vsp1/vsp1_video.c | 28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/media/platform/vsp1/vsp1_video.c b/drivers/media/platform/vsp1/vsp1_video.c
index 6a55eba88dba..cd4c2481e4ec 100644
--- a/drivers/media/platform/vsp1/vsp1_video.c
+++ b/drivers/media/platform/vsp1/vsp1_video.c
@@ -308,9 +308,9 @@ vsp1_video_format_adjust(struct vsp1_video *video,
  * Pipeline Management
  */
 
-static int vsp1_pipeline_validate_branch(struct vsp1_pipeline *pipe,
-					 struct vsp1_rwpf *input,
-					 struct vsp1_rwpf *output)
+static int vsp1_video_pipeline_validate_branch(struct vsp1_pipeline *pipe,
+					       struct vsp1_rwpf *input,
+					       struct vsp1_rwpf *output)
 {
 	struct vsp1_entity *entity;
 	unsigned int entities = 0;
@@ -384,8 +384,8 @@ static int vsp1_pipeline_validate_branch(struct vsp1_pipeline *pipe,
 	return 0;
 }
 
-static int vsp1_pipeline_validate(struct vsp1_pipeline *pipe,
-				  struct vsp1_video *video)
+static int vsp1_video_pipeline_validate(struct vsp1_pipeline *pipe,
+					struct vsp1_video *video)
 {
 	struct media_entity_graph graph;
 	struct media_entity *entity = &video->video.entity;
@@ -437,8 +437,8 @@ static int vsp1_pipeline_validate(struct vsp1_pipeline *pipe,
 	 * contains no loop and that all branches end at the output WPF.
 	 */
 	for (i = 0; i < pipe->num_inputs; ++i) {
-		ret = vsp1_pipeline_validate_branch(pipe, pipe->inputs[i],
-						    pipe->output);
+		ret = vsp1_video_pipeline_validate_branch(pipe, pipe->inputs[i],
+							  pipe->output);
 		if (ret < 0)
 			goto error;
 	}
@@ -450,8 +450,8 @@ error:
 	return ret;
 }
 
-static int vsp1_pipeline_init(struct vsp1_pipeline *pipe,
-			      struct vsp1_video *video)
+static int vsp1_video_pipeline_init(struct vsp1_pipeline *pipe,
+				    struct vsp1_video *video)
 {
 	int ret;
 
@@ -459,7 +459,7 @@ static int vsp1_pipeline_init(struct vsp1_pipeline *pipe,
 
 	/* If we're the first user validate and initialize the pipeline. */
 	if (pipe->use_count == 0) {
-		ret = vsp1_pipeline_validate(pipe, video);
+		ret = vsp1_video_pipeline_validate(pipe, video);
 		if (ret < 0)
 			goto done;
 	}
@@ -472,7 +472,7 @@ done:
 	return ret;
 }
 
-static void vsp1_pipeline_cleanup(struct vsp1_pipeline *pipe)
+static void vsp1_video_pipeline_cleanup(struct vsp1_pipeline *pipe)
 {
 	mutex_lock(&pipe->lock);
 
@@ -742,7 +742,7 @@ static void vsp1_video_stop_streaming(struct vb2_queue *vq)
 	}
 	mutex_unlock(&pipe->lock);
 
-	vsp1_pipeline_cleanup(pipe);
+	vsp1_video_pipeline_cleanup(pipe);
 	media_entity_pipeline_stop(&video->video.entity);
 
 	/* Remove all buffers from the IRQ queue. */
@@ -883,7 +883,7 @@ vsp1_video_streamon(struct file *file, void *fh, enum v4l2_buf_type type)
 	if (ret < 0)
 		goto err_stop;
 
-	ret = vsp1_pipeline_init(pipe, video);
+	ret = vsp1_video_pipeline_init(pipe, video);
 	if (ret < 0)
 		goto err_stop;
 
@@ -895,7 +895,7 @@ vsp1_video_streamon(struct file *file, void *fh, enum v4l2_buf_type type)
 	return 0;
 
 err_cleanup:
-	vsp1_pipeline_cleanup(pipe);
+	vsp1_video_pipeline_cleanup(pipe);
 err_stop:
 	media_entity_pipeline_stop(&video->video.entity);
 	return ret;
-- 
2.4.10

