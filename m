Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:44098 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755897Ab3LDA4k (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 3 Dec 2013 19:56:40 -0500
Received: from avalon.ideasonboard.com (unknown [91.177.177.98])
	by perceval.ideasonboard.com (Postfix) with ESMTPSA id 6E039366AD
	for <linux-media@vger.kernel.org>; Wed,  4 Dec 2013 01:55:41 +0100 (CET)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [PATCH 22/25] v4l: omap4iss: Reset the ISS when the pipeline can't be stopped
Date: Wed,  4 Dec 2013 01:56:22 +0100
Message-Id: <1386118585-12449-23-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1386118585-12449-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1386118585-12449-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When a failure to stop a module in the pipeline is detected, the only
way to recover is to reset the ISS. However, as other users can be using
a different pipeline with other modules, the ISS can't be reset
synchronously with the error detection.

Keep track of modules that have failed to stop, and reset the ISS
accordingly when the last user releases the last reference to the ISS.
Refuse to start streaming on a pipeline that contains a crashed module,
as the hardware wouldn't work anyway.

Modify the omap4iss_pipeline_set_stream() function to record the new ISS
pipeline state only when no error occurs, except when stopping the
pipeline in which case the pipeline is still marked as stopped.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/staging/media/omap4iss/iss.c       | 24 ++++++++++++++++++++++++
 drivers/staging/media/omap4iss/iss.h       |  5 +++++
 drivers/staging/media/omap4iss/iss_video.c |  8 ++++++++
 drivers/staging/media/omap4iss/iss_video.h |  2 ++
 4 files changed, 39 insertions(+)

diff --git a/drivers/staging/media/omap4iss/iss.c b/drivers/staging/media/omap4iss/iss.c
index dffa31e..5ad604d 100644
--- a/drivers/staging/media/omap4iss/iss.c
+++ b/drivers/staging/media/omap4iss/iss.c
@@ -573,12 +573,22 @@ static int iss_pipeline_link_notify(struct media_link *link, u32 flags,
 static int iss_pipeline_enable(struct iss_pipeline *pipe,
 			       enum iss_pipeline_stream_state mode)
 {
+	struct iss_device *iss = pipe->output->iss;
 	struct media_entity *entity;
 	struct media_pad *pad;
 	struct v4l2_subdev *subdev;
 	unsigned long flags;
 	int ret;
 
+	/* If one of the entities in the pipeline has crashed it will not work
+	 * properly. Refuse to start streaming in that case. This check must be
+	 * performed before the loop below to avoid starting entities if the
+	 * pipeline won't start anyway (those entities would then likely fail to
+	 * stop, making the problem worse).
+	 */
+	if (pipe->entities & iss->crashed)
+		return -EIO;
+
 	spin_lock_irqsave(&pipe->lock, flags);
 	pipe->state &= ~(ISS_PIPELINE_IDLE_INPUT | ISS_PIPELINE_IDLE_OUTPUT);
 	spin_unlock_irqrestore(&pipe->lock, flags);
@@ -617,6 +627,7 @@ static int iss_pipeline_enable(struct iss_pipeline *pipe,
  */
 static int iss_pipeline_disable(struct iss_pipeline *pipe)
 {
+	struct iss_device *iss = pipe->output->iss;
 	struct media_entity *entity;
 	struct media_pad *pad;
 	struct v4l2_subdev *subdev;
@@ -641,6 +652,11 @@ static int iss_pipeline_disable(struct iss_pipeline *pipe)
 		if (ret < 0) {
 			dev_dbg(iss->dev, "%s: module stop timeout.\n",
 				subdev->name);
+			/* If the entity failed to stopped, assume it has
+			 * crashed. Mark it as such, the ISS will be reset when
+			 * applications will release it.
+			 */
+			iss->crashed |= 1U << subdev->entity.id;
 			failure = -ETIMEDOUT;
 		}
 	}
@@ -715,6 +731,7 @@ static int iss_reset(struct iss_device *iss)
 		usleep_range(10, 10);
 	}
 
+	iss->crashed = 0;
 	return 0;
 }
 
@@ -1058,6 +1075,13 @@ void omap4iss_put(struct iss_device *iss)
 	BUG_ON(iss->ref_count == 0);
 	if (--iss->ref_count == 0) {
 		iss_disable_interrupts(iss);
+		/* Reset the ISS if an entity has failed to stop. This is the
+		 * only way to recover from such conditions, although it would
+		 * be worth investigating whether resetting the ISP only can't
+		 * fix the problem in some cases.
+		 */
+		if (iss->crashed)
+			iss_reset(iss);
 		iss_disable_clocks(iss);
 	}
 	mutex_unlock(&iss->iss_mutex);
diff --git a/drivers/staging/media/omap4iss/iss.h b/drivers/staging/media/omap4iss/iss.h
index f63caaf..3c1e920 100644
--- a/drivers/staging/media/omap4iss/iss.h
+++ b/drivers/staging/media/omap4iss/iss.h
@@ -77,6 +77,10 @@ struct iss_reg {
 	u32 val;
 };
 
+/*
+ * struct iss_device - ISS device structure.
+ * @crashed: Bitmask of crashed entities (indexed by entity ID)
+ */
 struct iss_device {
 	struct v4l2_device v4l2_dev;
 	struct media_device media_dev;
@@ -93,6 +97,7 @@ struct iss_device {
 	u64 raw_dmamask;
 
 	struct mutex iss_mutex;	/* For handling ref_count field */
+	bool crashed;
 	int has_context;
 	int ref_count;
 
diff --git a/drivers/staging/media/omap4iss/iss_video.c b/drivers/staging/media/omap4iss/iss_video.c
index 68eab6e..9106487 100644
--- a/drivers/staging/media/omap4iss/iss_video.c
+++ b/drivers/staging/media/omap4iss/iss_video.c
@@ -772,6 +772,8 @@ iss_video_streamon(struct file *file, void *fh, enum v4l2_buf_type type)
 {
 	struct iss_video_fh *vfh = to_iss_video_fh(fh);
 	struct iss_video *video = video_drvdata(file);
+	struct media_entity_graph graph;
+	struct media_entity *entity;
 	enum iss_pipeline_state state;
 	struct iss_pipeline *pipe;
 	struct iss_video *far_end;
@@ -791,6 +793,7 @@ iss_video_streamon(struct file *file, void *fh, enum v4l2_buf_type type)
 	pipe->external = NULL;
 	pipe->external_rate = 0;
 	pipe->external_bpp = 0;
+	pipe->entities = 0;
 
 	if (video->iss->pdata->set_constraints)
 		video->iss->pdata->set_constraints(video->iss, true);
@@ -799,6 +802,11 @@ iss_video_streamon(struct file *file, void *fh, enum v4l2_buf_type type)
 	if (ret < 0)
 		goto err_media_entity_pipeline_start;
 
+	entity = &video->video.entity;
+	media_entity_graph_walk_start(&graph, entity);
+	while ((entity = media_entity_graph_walk_next(&graph)))
+		pipe->entities |= 1 << entity->id;
+
 	/* Verify that the currently configured format matches the output of
 	 * the connected subdev.
 	 */
diff --git a/drivers/staging/media/omap4iss/iss_video.h b/drivers/staging/media/omap4iss/iss_video.h
index 2c8d256..73e1a34 100644
--- a/drivers/staging/media/omap4iss/iss_video.h
+++ b/drivers/staging/media/omap4iss/iss_video.h
@@ -77,6 +77,7 @@ enum iss_pipeline_state {
 
 /*
  * struct iss_pipeline - An OMAP4 ISS hardware pipeline
+ * @entities: Bitmask of entities in the pipeline (indexed by entity ID)
  * @error: A hardware error occurred during capture
  */
 struct iss_pipeline {
@@ -86,6 +87,7 @@ struct iss_pipeline {
 	enum iss_pipeline_stream_state stream_state;
 	struct iss_video *input;
 	struct iss_video *output;
+	unsigned int entities;
 	atomic_t frame_number;
 	bool do_propagation; /* of frame number */
 	bool error;
-- 
1.8.3.2

