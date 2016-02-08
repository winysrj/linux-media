Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:48304 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753143AbcBHLoI (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 8 Feb 2016 06:44:08 -0500
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org
Subject: [PATCH v3 16/35] v4l: vsp1: Extract pipeline initialization code into a function
Date: Mon,  8 Feb 2016 13:43:46 +0200
Message-Id: <1454931845-23864-17-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <1454931845-23864-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1454931845-23864-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The code will be reused outside of vsp1_video.c.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/media/platform/vsp1/vsp1_pipe.c  | 10 ++++++++++
 drivers/media/platform/vsp1/vsp1_pipe.h  |  1 +
 drivers/media/platform/vsp1/vsp1_video.c |  6 +-----
 3 files changed, 12 insertions(+), 5 deletions(-)

diff --git a/drivers/media/platform/vsp1/vsp1_pipe.c b/drivers/media/platform/vsp1/vsp1_pipe.c
index cdc670b88fcc..584a9d408144 100644
--- a/drivers/media/platform/vsp1/vsp1_pipe.c
+++ b/drivers/media/platform/vsp1/vsp1_pipe.c
@@ -49,6 +49,16 @@ void vsp1_pipeline_reset(struct vsp1_pipeline *pipe)
 	pipe->uds = NULL;
 }
 
+void vsp1_pipeline_init(struct vsp1_pipeline *pipe)
+{
+	mutex_init(&pipe->lock);
+	spin_lock_init(&pipe->irqlock);
+	init_waitqueue_head(&pipe->wq);
+
+	INIT_LIST_HEAD(&pipe->entities);
+	pipe->state = VSP1_PIPELINE_STOPPED;
+}
+
 void vsp1_pipeline_run(struct vsp1_pipeline *pipe)
 {
 	struct vsp1_device *vsp1 = pipe->output->entity.vsp1;
diff --git a/drivers/media/platform/vsp1/vsp1_pipe.h b/drivers/media/platform/vsp1/vsp1_pipe.h
index f8a099fba973..8553d5a03aa3 100644
--- a/drivers/media/platform/vsp1/vsp1_pipe.h
+++ b/drivers/media/platform/vsp1/vsp1_pipe.h
@@ -67,6 +67,7 @@ static inline struct vsp1_pipeline *to_vsp1_pipeline(struct media_entity *e)
 }
 
 void vsp1_pipeline_reset(struct vsp1_pipeline *pipe);
+void vsp1_pipeline_init(struct vsp1_pipeline *pipe);
 
 void vsp1_pipeline_run(struct vsp1_pipeline *pipe);
 bool vsp1_pipeline_stopped(struct vsp1_pipeline *pipe);
diff --git a/drivers/media/platform/vsp1/vsp1_video.c b/drivers/media/platform/vsp1/vsp1_video.c
index d616cbeb100a..3d5ea4a325ba 100644
--- a/drivers/media/platform/vsp1/vsp1_video.c
+++ b/drivers/media/platform/vsp1/vsp1_video.c
@@ -1026,11 +1026,7 @@ struct vsp1_video *vsp1_video_create(struct vsp1_device *vsp1,
 	spin_lock_init(&video->irqlock);
 	INIT_LIST_HEAD(&video->irqqueue);
 
-	mutex_init(&video->pipe.lock);
-	spin_lock_init(&video->pipe.irqlock);
-	INIT_LIST_HEAD(&video->pipe.entities);
-	init_waitqueue_head(&video->pipe.wq);
-	video->pipe.state = VSP1_PIPELINE_STOPPED;
+	vsp1_pipeline_init(&video->pipe);
 	video->pipe.frame_end = vsp1_video_pipeline_frame_end;
 
 	/* Initialize the media entity... */
-- 
2.4.10

