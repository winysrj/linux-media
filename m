Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:42770 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754937AbcB1Uec (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 28 Feb 2016 15:34:32 -0500
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Subject: [PATCH v2 2/2] media: Rename is_media_entity_v4l2_io to is_media_entity_video_device
Date: Sun, 28 Feb 2016 22:34:34 +0200
Message-Id: <1456691674-23849-2-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <1456691674-23849-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1456691674-23849-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The purpose of the function is to identify whether the media entity
instance is an instance of the video_device object. Rename it
accordingly.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/media/platform/exynos4-is/fimc-lite.c   | 2 +-
 drivers/media/platform/exynos4-is/media-dev.c   | 4 ++--
 drivers/media/platform/omap3isp/isp.c           | 2 +-
 drivers/media/platform/omap3isp/ispvideo.c      | 2 +-
 drivers/media/platform/vsp1/vsp1_video.c        | 2 +-
 drivers/staging/media/davinci_vpfe/vpfe_video.c | 2 +-
 drivers/staging/media/omap4iss/iss.c            | 2 +-
 drivers/staging/media/omap4iss/iss_video.c      | 2 +-
 include/media/media-entity.h                    | 4 ++--
 9 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/media/platform/exynos4-is/fimc-lite.c b/drivers/media/platform/exynos4-is/fimc-lite.c
index e85649147dc8..7d72803fc2e4 100644
--- a/drivers/media/platform/exynos4-is/fimc-lite.c
+++ b/drivers/media/platform/exynos4-is/fimc-lite.c
@@ -1010,7 +1010,7 @@ static int fimc_lite_link_setup(struct media_entity *entity,
 	case FLITE_SD_PAD_SOURCE_DMA:
 		if (!(flags & MEDIA_LNK_FL_ENABLED))
 			atomic_set(&fimc->out_path, FIMC_IO_NONE);
-		else if (is_media_entity_v4l2_io(remote->entity))
+		else if (is_media_entity_video_device(remote->entity))
 			atomic_set(&fimc->out_path, FIMC_IO_DMA);
 		else
 			ret = -EINVAL;
diff --git a/drivers/media/platform/exynos4-is/media-dev.c b/drivers/media/platform/exynos4-is/media-dev.c
index feb521f28e14..b8dd67b2ef6f 100644
--- a/drivers/media/platform/exynos4-is/media-dev.c
+++ b/drivers/media/platform/exynos4-is/media-dev.c
@@ -1130,7 +1130,7 @@ static int __fimc_md_modify_pipelines(struct media_entity *entity, bool enable,
 	media_entity_graph_walk_start(graph, entity);
 
 	while ((entity = media_entity_graph_walk_next(graph))) {
-		if (!is_media_entity_v4l2_io(entity))
+		if (!is_media_entity_video_device(entity))
 			continue;
 
 		ret  = __fimc_md_modify_pipeline(entity, enable);
@@ -1145,7 +1145,7 @@ err:
 	media_entity_graph_walk_start(graph, entity_err);
 
 	while ((entity_err = media_entity_graph_walk_next(graph))) {
-		if (!is_media_entity_v4l2_io(entity_err))
+		if (!is_media_entity_video_device(entity_err))
 			continue;
 
 		__fimc_md_modify_pipeline(entity_err, !enable);
diff --git a/drivers/media/platform/omap3isp/isp.c b/drivers/media/platform/omap3isp/isp.c
index f9e5245f26ac..ac065799ad5d 100644
--- a/drivers/media/platform/omap3isp/isp.c
+++ b/drivers/media/platform/omap3isp/isp.c
@@ -691,7 +691,7 @@ static int isp_pipeline_pm_use_count(struct media_entity *entity,
 	media_entity_graph_walk_start(graph, entity);
 
 	while ((entity = media_entity_graph_walk_next(graph))) {
-		if (is_media_entity_v4l2_io(entity))
+		if (is_media_entity_video_device(entity))
 			use += entity->use_count;
 	}
 
diff --git a/drivers/media/platform/omap3isp/ispvideo.c b/drivers/media/platform/omap3isp/ispvideo.c
index 2aff755ff77c..07c64689cc2b 100644
--- a/drivers/media/platform/omap3isp/ispvideo.c
+++ b/drivers/media/platform/omap3isp/ispvideo.c
@@ -249,7 +249,7 @@ static int isp_video_get_graph_data(struct isp_video *video,
 		if (entity == &video->video.entity)
 			continue;
 
-		if (!is_media_entity_v4l2_io(entity))
+		if (!is_media_entity_video_device(entity))
 			continue;
 
 		__video = to_isp_video(media_entity_to_video_device(entity));
diff --git a/drivers/media/platform/vsp1/vsp1_video.c b/drivers/media/platform/vsp1/vsp1_video.c
index 61ee0f92c1e5..50b12a485e83 100644
--- a/drivers/media/platform/vsp1/vsp1_video.c
+++ b/drivers/media/platform/vsp1/vsp1_video.c
@@ -289,7 +289,7 @@ static int vsp1_video_pipeline_validate(struct vsp1_pipeline *pipe,
 		struct vsp1_rwpf *rwpf;
 		struct vsp1_entity *e;
 
-		if (is_media_entity_v4l2_io(entity))
+		if (is_media_entity_video_device(entity))
 			continue;
 
 		subdev = media_entity_to_v4l2_subdev(entity);
diff --git a/drivers/staging/media/davinci_vpfe/vpfe_video.c b/drivers/staging/media/davinci_vpfe/vpfe_video.c
index db49af90217e..3b75adb244d8 100644
--- a/drivers/staging/media/davinci_vpfe/vpfe_video.c
+++ b/drivers/staging/media/davinci_vpfe/vpfe_video.c
@@ -154,7 +154,7 @@ static int vpfe_prepare_pipeline(struct vpfe_video_device *video)
 	while ((entity = media_entity_graph_walk_next(&graph))) {
 		if (entity == &video->video_dev.entity)
 			continue;
-		if (!is_media_entity_v4l2_io(entity))
+		if (!is_media_entity_video_device(entity))
 			continue;
 		far_end = to_vpfe_video(media_entity_to_video_device(entity));
 		if (far_end->type == V4L2_BUF_TYPE_VIDEO_OUTPUT)
diff --git a/drivers/staging/media/omap4iss/iss.c b/drivers/staging/media/omap4iss/iss.c
index 30b473cfb020..dd038f9e37d2 100644
--- a/drivers/staging/media/omap4iss/iss.c
+++ b/drivers/staging/media/omap4iss/iss.c
@@ -397,7 +397,7 @@ static int iss_pipeline_pm_use_count(struct media_entity *entity,
 	media_entity_graph_walk_start(graph, entity);
 
 	while ((entity = media_entity_graph_walk_next(graph))) {
-		if (is_media_entity_v4l2_io(entity))
+		if (is_media_entity_video_device(entity))
 			use += entity->use_count;
 	}
 
diff --git a/drivers/staging/media/omap4iss/iss_video.c b/drivers/staging/media/omap4iss/iss_video.c
index 058233a9de67..c679a3a0e534 100644
--- a/drivers/staging/media/omap4iss/iss_video.c
+++ b/drivers/staging/media/omap4iss/iss_video.c
@@ -221,7 +221,7 @@ iss_video_far_end(struct iss_video *video)
 		if (entity == &video->video.entity)
 			continue;
 
-		if (!is_media_entity_v4l2_io(entity))
+		if (!is_media_entity_video_device(entity))
 			continue;
 
 		far_end = to_iss_video(media_entity_to_video_device(entity));
diff --git a/include/media/media-entity.h b/include/media/media-entity.h
index 31996e069439..2e681ab57efe 100644
--- a/include/media/media-entity.h
+++ b/include/media/media-entity.h
@@ -356,14 +356,14 @@ static inline u32 media_gobj_gen_id(enum media_gobj_type type, u64 local_id)
 }
 
 /**
- * is_media_entity_v4l2_io() - Check if the entity is a video_device
+ * is_media_entity_video_device() - Check if the entity is a video_device
  * @entity:	pointer to entity
  *
  * Return: true if the entity is an instance of a video_device object and can
  * safely be cast to a struct video_device using the container_of() macro, or
  * false otherwise.
  */
-static inline bool is_media_entity_v4l2_io(struct media_entity *entity)
+static inline bool is_media_entity_video_device(struct media_entity *entity)
 {
 	return entity && entity->type == MEDIA_ENTITY_TYPE_VIDEO_DEVICE;
 }
-- 
2.4.10

