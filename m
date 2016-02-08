Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:48304 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752613AbcBHLoG (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 8 Feb 2016 06:44:06 -0500
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org
Subject: [PATCH v3 12/35] v4l: vsp1: Remove struct vsp1_pipeline num_video field
Date: Mon,  8 Feb 2016 13:43:42 +0200
Message-Id: <1454931845-23864-13-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <1454931845-23864-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1454931845-23864-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The field is always equal to the num_inputs field plus one, remove the
duplicate.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/media/platform/vsp1/vsp1_video.c | 7 ++-----
 drivers/media/platform/vsp1/vsp1_video.h | 1 -
 2 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/media/platform/vsp1/vsp1_video.c b/drivers/media/platform/vsp1/vsp1_video.c
index e9a6f9f90c90..381447a4631a 100644
--- a/drivers/media/platform/vsp1/vsp1_video.c
+++ b/drivers/media/platform/vsp1/vsp1_video.c
@@ -403,7 +403,6 @@ static void __vsp1_pipeline_cleanup(struct vsp1_pipeline *pipe)
 	INIT_LIST_HEAD(&pipe->entities);
 	pipe->state = VSP1_PIPELINE_STOPPED;
 	pipe->buffers_ready = 0;
-	pipe->num_video = 0;
 	pipe->num_inputs = 0;
 	pipe->output = NULL;
 	pipe->bru = NULL;
@@ -436,10 +435,8 @@ static int vsp1_pipeline_validate(struct vsp1_pipeline *pipe,
 		struct vsp1_rwpf *rwpf;
 		struct vsp1_entity *e;
 
-		if (is_media_entity_v4l2_io(entity)) {
-			pipe->num_video++;
+		if (is_media_entity_v4l2_io(entity))
 			continue;
-		}
 
 		subdev = media_entity_to_v4l2_subdev(entity);
 		e = to_vsp1_entity(subdev);
@@ -907,7 +904,7 @@ static int vsp1_video_start_streaming(struct vb2_queue *vq, unsigned int count)
 	int ret;
 
 	mutex_lock(&pipe->lock);
-	if (pipe->stream_count == pipe->num_video - 1) {
+	if (pipe->stream_count == pipe->num_inputs) {
 		if (pipe->uds) {
 			struct vsp1_uds *uds = to_uds(&pipe->uds->subdev);
 
diff --git a/drivers/media/platform/vsp1/vsp1_video.h b/drivers/media/platform/vsp1/vsp1_video.h
index 21096d82af05..e9d0e1ab9162 100644
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
2.4.10

