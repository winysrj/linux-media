Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:56629 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752368AbbIKKL2 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Sep 2015 06:11:28 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, javier@osg.samsung.com,
	mchehab@osg.samsung.com, hverkuil@xs4all.nl
Subject: [RFC 9/9] staging: omap4iss: Use media entity enum API
Date: Fri, 11 Sep 2015 13:09:12 +0300
Message-Id: <1441966152-28444-10-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1441966152-28444-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1441966152-28444-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/staging/media/omap4iss/iss.c       | 7 ++++---
 drivers/staging/media/omap4iss/iss.h       | 4 ++--
 drivers/staging/media/omap4iss/iss_video.c | 4 ++--
 drivers/staging/media/omap4iss/iss_video.h | 4 ++--
 4 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/media/omap4iss/iss.c b/drivers/staging/media/omap4iss/iss.c
index 076ddd4..9f310e7 100644
--- a/drivers/staging/media/omap4iss/iss.c
+++ b/drivers/staging/media/omap4iss/iss.c
@@ -606,7 +606,7 @@ static int iss_pipeline_disable(struct iss_pipeline *pipe,
 			 * crashed. Mark it as such, the ISS will be reset when
 			 * applications will release it.
 			 */
-			iss->crashed |= 1U << media_entity_id(&subdev->entity);
+			media_entity_enum_set(iss->crashed, &subdev->entity);
 			failure = -ETIMEDOUT;
 		}
 	}
@@ -641,7 +641,7 @@ static int iss_pipeline_enable(struct iss_pipeline *pipe,
 	 * pipeline won't start anyway (those entities would then likely fail to
 	 * stop, making the problem worse).
 	 */
-	if (pipe->entities & iss->crashed)
+	if (media_entity_enum_intersects(pipe->entities, iss->crashed))
 		return -EIO;
 
 	spin_lock_irqsave(&pipe->lock, flags);
@@ -761,7 +761,8 @@ static int iss_reset(struct iss_device *iss)
 		return -ETIMEDOUT;
 	}
 
-	iss->crashed = 0;
+	media_entity_enum_init(iss->crashed);
+
 	return 0;
 }
 
diff --git a/drivers/staging/media/omap4iss/iss.h b/drivers/staging/media/omap4iss/iss.h
index 35df8b4..a124555 100644
--- a/drivers/staging/media/omap4iss/iss.h
+++ b/drivers/staging/media/omap4iss/iss.h
@@ -82,7 +82,7 @@ struct iss_reg {
 /*
  * struct iss_device - ISS device structure.
  * @syscon: Regmap for the syscon register space
- * @crashed: Bitmask of crashed entities (indexed by entity ID)
+ * @crashed: Crashed entities
  */
 struct iss_device {
 	struct v4l2_device v4l2_dev;
@@ -101,7 +101,7 @@ struct iss_device {
 	u64 raw_dmamask;
 
 	struct mutex iss_mutex;	/* For handling ref_count field */
-	unsigned int crashed;
+	DECLARE_MEDIA_ENTITY_ENUM(crashed);
 	int has_context;
 	int ref_count;
 
diff --git a/drivers/staging/media/omap4iss/iss_video.c b/drivers/staging/media/omap4iss/iss_video.c
index cbe5783..385b668 100644
--- a/drivers/staging/media/omap4iss/iss_video.c
+++ b/drivers/staging/media/omap4iss/iss_video.c
@@ -771,7 +771,7 @@ iss_video_streamon(struct file *file, void *fh, enum v4l2_buf_type type)
 	pipe->external = NULL;
 	pipe->external_rate = 0;
 	pipe->external_bpp = 0;
-	pipe->entities = 0;
+	media_entity_enum_init(pipe->entities);
 
 	if (video->iss->pdata->set_constraints)
 		video->iss->pdata->set_constraints(video->iss, true);
@@ -783,7 +783,7 @@ iss_video_streamon(struct file *file, void *fh, enum v4l2_buf_type type)
 	entity = &video->video.entity;
 	media_entity_graph_walk_start(&graph, entity);
 	while ((entity = media_entity_graph_walk_next(&graph)))
-		pipe->entities |= 1 << media_entity_id(entity);
+		media_entity_enum_set(pipe->entities, entity);
 
 	/* Verify that the currently configured format matches the output of
 	 * the connected subdev.
diff --git a/drivers/staging/media/omap4iss/iss_video.h b/drivers/staging/media/omap4iss/iss_video.h
index f11fce2..d415594 100644
--- a/drivers/staging/media/omap4iss/iss_video.h
+++ b/drivers/staging/media/omap4iss/iss_video.h
@@ -77,7 +77,7 @@ enum iss_pipeline_state {
 
 /*
  * struct iss_pipeline - An OMAP4 ISS hardware pipeline
- * @entities: Bitmask of entities in the pipeline (indexed by entity ID)
+ * @entities: Entities in the pipeline
  * @error: A hardware error occurred during capture
  */
 struct iss_pipeline {
@@ -87,7 +87,7 @@ struct iss_pipeline {
 	enum iss_pipeline_stream_state stream_state;
 	struct iss_video *input;
 	struct iss_video *output;
-	unsigned int entities;
+	DECLARE_MEDIA_ENTITY_ENUM(entities);
 	atomic_t frame_number;
 	bool do_propagation; /* of frame number */
 	bool error;
-- 
2.1.0.231.g7484e3b

