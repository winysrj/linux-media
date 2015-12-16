Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:60598 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754636AbbLPNev (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 16 Dec 2015 08:34:51 -0500
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, mchehab@osg.samsung.com,
	hverkuil@xs4all.nl, javier@osg.samsung.com,
	Sakari Ailus <sakari.ailus@linux.intel.com>
Subject: [PATCH v3 18/23] staging: v4l: omap4iss: Use media entity enumeration interface
Date: Wed, 16 Dec 2015 15:32:33 +0200
Message-Id: <1450272758-29446-19-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <1450272758-29446-1-git-send-email-sakari.ailus@iki.fi>
References: <1450272758-29446-1-git-send-email-sakari.ailus@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Sakari Ailus <sakari.ailus@linux.intel.com>

Instead of using a bitmap directly in a driver, use the new media
entity enumeration interface to perform the same.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/staging/media/omap4iss/iss.c       | 15 +++++++++++----
 drivers/staging/media/omap4iss/iss.h       |  4 ++--
 drivers/staging/media/omap4iss/iss_video.c | 23 ++++++++++++++++-------
 drivers/staging/media/omap4iss/iss_video.h |  4 ++--
 4 files changed, 31 insertions(+), 15 deletions(-)

diff --git a/drivers/staging/media/omap4iss/iss.c b/drivers/staging/media/omap4iss/iss.c
index c097fd5..6738d01 100644
--- a/drivers/staging/media/omap4iss/iss.c
+++ b/drivers/staging/media/omap4iss/iss.c
@@ -606,7 +606,7 @@ static int iss_pipeline_disable(struct iss_pipeline *pipe,
 			 * crashed. Mark it as such, the ISS will be reset when
 			 * applications will release it.
 			 */
-			iss->crashed |= 1U << media_entity_id(&subdev->entity);
+			media_entity_enum_set(&iss->crashed, &subdev->entity);
 			failure = -ETIMEDOUT;
 		}
 	}
@@ -641,7 +641,7 @@ static int iss_pipeline_enable(struct iss_pipeline *pipe,
 	 * pipeline won't start anyway (those entities would then likely fail to
 	 * stop, making the problem worse).
 	 */
-	if (pipe->entities & iss->crashed)
+	if (media_entity_enum_intersects(&pipe->ent_enum, &iss->crashed))
 		return -EIO;
 
 	spin_lock_irqsave(&pipe->lock, flags);
@@ -761,7 +761,8 @@ static int iss_reset(struct iss_device *iss)
 		return -ETIMEDOUT;
 	}
 
-	iss->crashed = 0;
+	media_entity_enum_zero(&iss->crashed);
+
 	return 0;
 }
 
@@ -1090,7 +1091,7 @@ void omap4iss_put(struct iss_device *iss)
 		 * be worth investigating whether resetting the ISP only can't
 		 * fix the problem in some cases.
 		 */
-		if (iss->crashed)
+		if (!media_entity_enum_empty(&iss->crashed))
 			iss_reset(iss);
 		iss_disable_clocks(iss);
 	}
@@ -1490,6 +1491,10 @@ static int iss_probe(struct platform_device *pdev)
 	if (ret < 0)
 		goto error_modules;
 
+	ret = media_entity_enum_init(&iss->crashed, &iss->media_dev);
+	if (ret)
+		goto error_entities;
+
 	ret = iss_create_pads_links(iss);
 	if (ret < 0)
 		goto error_entities;
@@ -1500,6 +1505,7 @@ static int iss_probe(struct platform_device *pdev)
 
 error_entities:
 	iss_unregister_entities(iss);
+	media_entity_enum_cleanup(&iss->crashed);
 error_modules:
 	iss_cleanup_modules(iss);
 error_iss:
@@ -1517,6 +1523,7 @@ static int iss_remove(struct platform_device *pdev)
 	struct iss_device *iss = platform_get_drvdata(pdev);
 
 	iss_unregister_entities(iss);
+	media_entity_enum_cleanup(&iss->crashed);
 	iss_cleanup_modules(iss);
 
 	return 0;
diff --git a/drivers/staging/media/omap4iss/iss.h b/drivers/staging/media/omap4iss/iss.h
index 35df8b4..5dd0d99 100644
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
+	struct media_entity_enum crashed;
 	int has_context;
 	int ref_count;
 
diff --git a/drivers/staging/media/omap4iss/iss_video.c b/drivers/staging/media/omap4iss/iss_video.c
index cbe5783..4fd5fc8 100644
--- a/drivers/staging/media/omap4iss/iss_video.c
+++ b/drivers/staging/media/omap4iss/iss_video.c
@@ -751,7 +751,7 @@ iss_video_streamon(struct file *file, void *fh, enum v4l2_buf_type type)
 	struct iss_video_fh *vfh = to_iss_video_fh(fh);
 	struct iss_video *video = video_drvdata(file);
 	struct media_entity_graph graph;
-	struct media_entity *entity;
+	struct media_entity *entity = &video->video.entity;
 	enum iss_pipeline_state state;
 	struct iss_pipeline *pipe;
 	struct iss_video *far_end;
@@ -766,24 +766,26 @@ iss_video_streamon(struct file *file, void *fh, enum v4l2_buf_type type)
 	/* Start streaming on the pipeline. No link touching an entity in the
 	 * pipeline can be activated or deactivated once streaming is started.
 	 */
-	pipe = video->video.entity.pipe
-	     ? to_iss_pipeline(&video->video.entity) : &video->pipe;
+	pipe = entity->pipe
+	     ? to_iss_pipeline(entity) : &video->pipe;
 	pipe->external = NULL;
 	pipe->external_rate = 0;
 	pipe->external_bpp = 0;
-	pipe->entities = 0;
+
+	ret = media_entity_enum_init(&pipe->ent_enum, entity->graph_obj.mdev);
+	if (ret)
+		goto err_enum_init;
 
 	if (video->iss->pdata->set_constraints)
 		video->iss->pdata->set_constraints(video->iss, true);
 
-	ret = media_entity_pipeline_start(&video->video.entity, &pipe->pipe);
+	ret = media_entity_pipeline_start(entity, &pipe->pipe);
 	if (ret < 0)
 		goto err_media_entity_pipeline_start;
 
-	entity = &video->video.entity;
 	media_entity_graph_walk_start(&graph, entity);
 	while ((entity = media_entity_graph_walk_next(&graph)))
-		pipe->entities |= 1 << media_entity_id(entity);
+		media_entity_enum_set(&pipe->ent_enum, entity);
 
 	/* Verify that the currently configured format matches the output of
 	 * the connected subdev.
@@ -854,6 +856,7 @@ iss_video_streamon(struct file *file, void *fh, enum v4l2_buf_type type)
 	}
 
 	mutex_unlock(&video->stream_lock);
+
 	return 0;
 
 err_omap4iss_set_stream:
@@ -865,7 +868,11 @@ err_media_entity_pipeline_start:
 		video->iss->pdata->set_constraints(video->iss, false);
 	video->queue = NULL;
 
+	media_entity_enum_cleanup(&pipe->ent_enum);
+
+err_enum_init:
 	mutex_unlock(&video->stream_lock);
+
 	return ret;
 }
 
@@ -903,6 +910,8 @@ iss_video_streamoff(struct file *file, void *fh, enum v4l2_buf_type type)
 	vb2_streamoff(&vfh->queue, type);
 	video->queue = NULL;
 
+	media_entity_enum_cleanup(&pipe->ent_enum);
+
 	if (video->iss->pdata->set_constraints)
 		video->iss->pdata->set_constraints(video->iss, false);
 	media_entity_pipeline_stop(&video->video.entity);
diff --git a/drivers/staging/media/omap4iss/iss_video.h b/drivers/staging/media/omap4iss/iss_video.h
index f11fce2..d16bc45 100644
--- a/drivers/staging/media/omap4iss/iss_video.h
+++ b/drivers/staging/media/omap4iss/iss_video.h
@@ -77,7 +77,7 @@ enum iss_pipeline_state {
 
 /*
  * struct iss_pipeline - An OMAP4 ISS hardware pipeline
- * @entities: Bitmask of entities in the pipeline (indexed by entity ID)
+ * @ent_enum: Entities in the pipeline
  * @error: A hardware error occurred during capture
  */
 struct iss_pipeline {
@@ -87,7 +87,7 @@ struct iss_pipeline {
 	enum iss_pipeline_stream_state stream_state;
 	struct iss_video *input;
 	struct iss_video *output;
-	unsigned int entities;
+	struct media_entity_enum ent_enum;
 	atomic_t frame_number;
 	bool do_propagation; /* of frame number */
 	bool error;
-- 
2.1.4

