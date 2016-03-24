Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:40282 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750901AbcCXX2Z (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 24 Mar 2016 19:28:25 -0400
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org
Subject: [PATCH 36/51] v4l: vsp1: Rename pipeline validate functions to pipeline build
Date: Fri, 25 Mar 2016 01:27:32 +0200
Message-Id: <1458862067-19525-37-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <1458862067-19525-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1458862067-19525-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The primary purpose of those functions is to build the pipeline, rename
them to make this clearer.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/media/platform/vsp1/vsp1_video.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/media/platform/vsp1/vsp1_video.c b/drivers/media/platform/vsp1/vsp1_video.c
index a45bf68e0ba1..ddf440dc9a9c 100644
--- a/drivers/media/platform/vsp1/vsp1_video.c
+++ b/drivers/media/platform/vsp1/vsp1_video.c
@@ -172,9 +172,9 @@ static int __vsp1_video_try_format(struct vsp1_video *video,
  * Pipeline Management
  */
 
-static int vsp1_video_pipeline_validate_branch(struct vsp1_pipeline *pipe,
-					       struct vsp1_rwpf *input,
-					       struct vsp1_rwpf *output)
+static int vsp1_video_pipeline_build_branch(struct vsp1_pipeline *pipe,
+					    struct vsp1_rwpf *input,
+					    struct vsp1_rwpf *output)
 {
 	struct media_entity_enum ent_enum;
 	struct vsp1_entity *entity;
@@ -257,8 +257,8 @@ out:
 	return ret;
 }
 
-static int vsp1_video_pipeline_validate(struct vsp1_pipeline *pipe,
-					struct vsp1_video *video)
+static int vsp1_video_pipeline_build(struct vsp1_pipeline *pipe,
+				     struct vsp1_video *video)
 {
 	struct media_entity_graph graph;
 	struct media_entity *entity = &video->video.entity;
@@ -321,8 +321,8 @@ static int vsp1_video_pipeline_validate(struct vsp1_pipeline *pipe,
 		if (!pipe->inputs[i])
 			continue;
 
-		ret = vsp1_video_pipeline_validate_branch(pipe, pipe->inputs[i],
-							  pipe->output);
+		ret = vsp1_video_pipeline_build_branch(pipe, pipe->inputs[i],
+						       pipe->output);
 		if (ret < 0)
 			goto error;
 	}
@@ -341,9 +341,9 @@ static int vsp1_video_pipeline_init(struct vsp1_pipeline *pipe,
 
 	mutex_lock(&pipe->lock);
 
-	/* If we're the first user validate and initialize the pipeline. */
+	/* If we're the first user build and validate the pipeline. */
 	if (pipe->use_count == 0) {
-		ret = vsp1_video_pipeline_validate(pipe, video);
+		ret = vsp1_video_pipeline_build(pipe, video);
 		if (ret < 0)
 			goto done;
 	}
-- 
2.7.3

