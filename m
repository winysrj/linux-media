Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:52349 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755384AbbIMU5R (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 13 Sep 2015 16:57:17 -0400
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: linux-sh@vger.kernel.org
Subject: [PATCH 09/32] v4l: vsp1: Remove struct vsp1_pipeline num_video field
Date: Sun, 13 Sep 2015 23:56:47 +0300
Message-Id: <1442177830-24536-10-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <1442177830-24536-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1442177830-24536-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The field always has the same value as the num_inputs field, remove the
duplicate.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/media/platform/vsp1/vsp1_video.c | 7 ++-----
 drivers/media/platform/vsp1/vsp1_video.h | 1 -
 2 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/media/platform/vsp1/vsp1_video.c b/drivers/media/platform/vsp1/vsp1_video.c
index 2d27e8334911..c726d76bd570 100644
--- a/drivers/media/platform/vsp1/vsp1_video.c
+++ b/drivers/media/platform/vsp1/vsp1_video.c
@@ -396,7 +396,6 @@ static void __vsp1_pipeline_cleanup(struct vsp1_pipeline *pipe)
 	INIT_LIST_HEAD(&pipe->entities);
 	pipe->state = VSP1_PIPELINE_STOPPED;
 	pipe->buffers_ready = 0;
-	pipe->num_video = 0;
 	pipe->num_inputs = 0;
 	pipe->output = NULL;
 	pipe->bru = NULL;
@@ -423,10 +422,8 @@ static int vsp1_pipeline_validate(struct vsp1_pipeline *pipe,
 		struct vsp1_rwpf *rwpf;
 		struct vsp1_entity *e;
 
-		if (media_entity_type(entity) != MEDIA_ENT_T_V4L2_SUBDEV) {
-			pipe->num_video++;
+		if (media_entity_type(entity) != MEDIA_ENT_T_V4L2_SUBDEV)
 			continue;
-		}
 
 		subdev = media_entity_to_v4l2_subdev(entity);
 		e = to_vsp1_entity(subdev);
@@ -890,7 +887,7 @@ static int vsp1_video_start_streaming(struct vb2_queue *vq, unsigned int count)
 	int ret;
 
 	mutex_lock(&pipe->lock);
-	if (pipe->stream_count == pipe->num_video - 1) {
+	if (pipe->stream_count == pipe->num_inputs - 1) {
 		if (pipe->uds) {
 			struct vsp1_uds *uds = to_uds(&pipe->uds->subdev);
 
diff --git a/drivers/media/platform/vsp1/vsp1_video.h b/drivers/media/platform/vsp1/vsp1_video.h
index b7eabe6bab70..cea6d1f3f07b 100644
--- a/drivers/media/platform/vsp1/vsp1_video.h
+++ b/drivers/media/platform/vsp1/vsp1_video.h
@@ -75,7 +75,6 @@ struct vsp1_pipeline {
 	unsigned int stream_count;
 	unsigned int buffers_ready;
 
-	unsigned int num_video;
 	unsigned int num_inputs;
 	struct vsp1_rwpf *inputs[VSP1_MAX_RPF];
 	struct vsp1_rwpf *output;
-- 
2.4.6

