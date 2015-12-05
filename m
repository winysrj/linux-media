Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:55018 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932215AbbLECNG (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 4 Dec 2015 21:13:06 -0500
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: linux-sh@vger.kernel.org
Subject: [PATCH v2 08/32] v4l: vsp1: Move vsp1_video pointer from vsp1_entity to vsp1_rwpf
Date: Sat,  5 Dec 2015 04:12:42 +0200
Message-Id: <1449281586-25726-9-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <1449281586-25726-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1449281586-25726-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Only RPFs and WPFs can be associated with video nodes, don't waste
memory by storing the video pointer in all entities.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/media/platform/vsp1/vsp1_drv.c    |  6 +++---
 drivers/media/platform/vsp1/vsp1_entity.h |  3 ---
 drivers/media/platform/vsp1/vsp1_rwpf.h   |  3 +++
 drivers/media/platform/vsp1/vsp1_video.c  | 10 +++++-----
 4 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/media/platform/vsp1/vsp1_drv.c b/drivers/media/platform/vsp1/vsp1_drv.c
index 5f93cbdcb0f1..91ecf75119ba 100644
--- a/drivers/media/platform/vsp1/vsp1_drv.c
+++ b/drivers/media/platform/vsp1/vsp1_drv.c
@@ -289,8 +289,8 @@ static int vsp1_create_entities(struct vsp1_device *vsp1)
 	for (i = 0; i < vsp1->pdata.rpf_count; ++i) {
 		struct vsp1_rwpf *rpf = vsp1->rpf[i];
 
-		ret = media_entity_create_link(&rpf->entity.video->video.entity,
-					       0, &rpf->entity.subdev.entity,
+		ret = media_entity_create_link(&rpf->video->video.entity, 0,
+					       &rpf->entity.subdev.entity,
 					       RWPF_PAD_SINK,
 					       MEDIA_LNK_FL_ENABLED |
 					       MEDIA_LNK_FL_IMMUTABLE);
@@ -311,7 +311,7 @@ static int vsp1_create_entities(struct vsp1_device *vsp1)
 
 		ret = media_entity_create_link(&wpf->entity.subdev.entity,
 					       RWPF_PAD_SOURCE,
-					       &wpf->entity.video->video.entity,
+					       &wpf->video->video.entity,
 					       0, flags);
 		if (ret < 0)
 			goto done;
diff --git a/drivers/media/platform/vsp1/vsp1_entity.h b/drivers/media/platform/vsp1/vsp1_entity.h
index 8867a5787c28..9c95507ec762 100644
--- a/drivers/media/platform/vsp1/vsp1_entity.h
+++ b/drivers/media/platform/vsp1/vsp1_entity.h
@@ -19,7 +19,6 @@
 #include <media/v4l2-subdev.h>
 
 struct vsp1_device;
-struct vsp1_video;
 
 enum vsp1_entity_type {
 	VSP1_ENTITY_BRU,
@@ -71,8 +70,6 @@ struct vsp1_entity {
 	struct v4l2_subdev subdev;
 	struct v4l2_mbus_framefmt *formats;
 
-	struct vsp1_video *video;
-
 	spinlock_t lock;		/* Protects the streaming field */
 	bool streaming;
 };
diff --git a/drivers/media/platform/vsp1/vsp1_rwpf.h b/drivers/media/platform/vsp1/vsp1_rwpf.h
index 0076920adb28..1a90c7c8e972 100644
--- a/drivers/media/platform/vsp1/vsp1_rwpf.h
+++ b/drivers/media/platform/vsp1/vsp1_rwpf.h
@@ -24,6 +24,7 @@
 #define RWPF_PAD_SOURCE				1
 
 struct vsp1_rwpf;
+struct vsp1_video;
 
 struct vsp1_rwpf_memory {
 	unsigned int num_planes;
@@ -40,6 +41,8 @@ struct vsp1_rwpf {
 	struct vsp1_entity entity;
 	struct v4l2_ctrl_handler ctrls;
 
+	struct vsp1_video *video;
+
 	const struct vsp1_rwpf_operations *ops;
 
 	unsigned int max_width;
diff --git a/drivers/media/platform/vsp1/vsp1_video.c b/drivers/media/platform/vsp1/vsp1_video.c
index 0d600b8de6b1..8ffe54260725 100644
--- a/drivers/media/platform/vsp1/vsp1_video.c
+++ b/drivers/media/platform/vsp1/vsp1_video.c
@@ -435,11 +435,11 @@ static int vsp1_pipeline_validate(struct vsp1_pipeline *pipe,
 		if (e->type == VSP1_ENTITY_RPF) {
 			rwpf = to_rwpf(subdev);
 			pipe->inputs[pipe->num_inputs++] = rwpf;
-			rwpf->entity.video->pipe_index = pipe->num_inputs;
+			rwpf->video->pipe_index = pipe->num_inputs;
 		} else if (e->type == VSP1_ENTITY_WPF) {
 			rwpf = to_rwpf(subdev);
 			pipe->output = to_rwpf(subdev);
-			rwpf->entity.video->pipe_index = 0;
+			rwpf->video->pipe_index = 0;
 		} else if (e->type == VSP1_ENTITY_LIF) {
 			pipe->lif = e;
 		} else if (e->type == VSP1_ENTITY_BRU) {
@@ -649,10 +649,10 @@ void vsp1_pipeline_frame_end(struct vsp1_pipeline *pipe)
 
 	/* Complete buffers on all video nodes. */
 	for (i = 0; i < pipe->num_inputs; ++i)
-		vsp1_video_frame_end(pipe, pipe->inputs[i]->entity.video);
+		vsp1_video_frame_end(pipe, pipe->inputs[i]->video);
 
 	if (!pipe->lif)
-		vsp1_video_frame_end(pipe, pipe->output->entity.video);
+		vsp1_video_frame_end(pipe, pipe->output->video);
 
 	spin_lock_irqsave(&pipe->irqlock, flags);
 
@@ -1204,7 +1204,7 @@ struct vsp1_video *vsp1_video_create(struct vsp1_device *vsp1,
 	if (!video)
 		return ERR_PTR(-ENOMEM);
 
-	rwpf->entity.video = video;
+	rwpf->video = video;
 
 	video->vsp1 = vsp1;
 	video->rwpf = rwpf;
-- 
2.4.10

