Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.1.47]:53310 "EHLO mgw-sa01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932153Ab2CBRcz (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 2 Mar 2012 12:32:55 -0500
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, dacohen@gmail.com,
	snjw23@gmail.com, andriy.shevchenko@linux.intel.com,
	t.stanislaws@samsung.com, tuukkat76@gmail.com,
	k.debski@samsung.com, riverful@gmail.com, hverkuil@xs4all.nl,
	teturtia@gmail.com
Subject: [PATCH v4 16/34] media: Collect entities that are part of the pipeline before link validation
Date: Fri,  2 Mar 2012 19:30:24 +0200
Message-Id: <1330709442-16654-16-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <20120302173219.GA15695@valkosipuli.localdomain>
References: <20120302173219.GA15695@valkosipuli.localdomain>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Make information available which entities are part of the pipeline before
link_validate() ops are being called.

Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
---
 drivers/media/media-entity.c |   23 ++++++++++++++++++++---
 include/media/media-entity.h |    1 +
 2 files changed, 21 insertions(+), 3 deletions(-)

diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
index d6d0e81..55f66c6 100644
--- a/drivers/media/media-entity.c
+++ b/drivers/media/media-entity.c
@@ -220,12 +220,19 @@ __must_check int media_entity_pipeline_start(struct media_entity *entity,
 	struct media_device *mdev = entity->parent;
 	struct media_entity_graph graph;
 	struct media_entity *entity_err = entity;
+	struct {
+		struct media_entity *entity;
+		struct media_link *link;
+	} to_validate[MEDIA_ENTITY_ENUM_MAX_DEPTH];
+	int nto_validate = 0;
 	int ret;
 
 	mutex_lock(&mdev->graph_mutex);
 
 	media_entity_graph_walk_start(&graph, entity);
 
+	pipe->entities = 0;
+
 	while ((entity = media_entity_graph_walk_next(&graph))) {
 		unsigned int i;
 
@@ -237,6 +244,8 @@ __must_check int media_entity_pipeline_start(struct media_entity *entity,
 		if (entity->stream_count > 1)
 			continue;
 
+		pipe->entities |= 1 << entity->id;
+
 		if (!entity->ops || !entity->ops->link_validate)
 			continue;
 
@@ -251,12 +260,20 @@ __must_check int media_entity_pipeline_start(struct media_entity *entity,
 			if (link->sink->entity != entity)
 				continue;
 
-			ret = entity->ops->link_validate(link);
-			if (ret < 0 && ret != -ENOIOCTLCMD)
-				goto error;
+			BUG_ON(nto_validate >= MEDIA_ENTITY_ENUM_MAX_DEPTH);
+			to_validate[nto_validate].entity = entity;
+			to_validate[nto_validate].link = link;
+			nto_validate++;
 		}
 	}
 
+	for (nto_validate--; nto_validate >= 0; nto_validate--) {
+		ret = to_validate[nto_validate].entity->ops->
+			link_validate(to_validate[nto_validate].link);
+		if (ret < 0 && ret != -ENOIOCTLCMD)
+			goto error;
+	}
+
 	mutex_unlock(&mdev->graph_mutex);
 
 	return 0;
diff --git a/include/media/media-entity.h b/include/media/media-entity.h
index 0c16f51..bbfc8f2 100644
--- a/include/media/media-entity.h
+++ b/include/media/media-entity.h
@@ -27,6 +27,7 @@
 #include <linux/media.h>
 
 struct media_pipeline {
+	u32 entities;
 };
 
 struct media_link {
-- 
1.7.2.5

