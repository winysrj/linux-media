Return-path: <linux-media-owner@vger.kernel.org>
Received: from resqmta-po-08v.sys.comcast.net ([96.114.154.167]:33971 "EHLO
	resqmta-po-08v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751927AbbIVRZJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Sep 2015 13:25:09 -0400
From: Shuah Khan <shuahkh@osg.samsung.com>
To: mchehab@osg.samsung.com, hans.verkuil@cisco.com,
	laurent.pinchart@ideasonboard.com, sakari.ailus@linux.intel.com,
	tiwai@suse.de, pawel@osciak.com, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, perex@perex.cz,
	stefanr@s5r6.in-berlin.de, crope@iki.fi, dan.carpenter@oracle.com,
	tskd08@gmail.com, ruchandani.tina@gmail.com, arnd@arndb.de,
	chehabrafael@gmail.com, prabhakar.csengg@gmail.com,
	Julia.Lawall@lip6.fr, elfring@users.sourceforge.net,
	ricardo.ribalda@gmail.com, chris.j.arges@canonical.com,
	pierre-louis.bossart@linux.intel.com, gtmkramer@xs4all.nl,
	clemens@ladisch.de, misterpib@gmail.com, takamichiho@gmail.com,
	pmatilai@laiskiainen.org, damien@zamaudio.com, daniel@zonque.org,
	vladcatoi@gmail.com, normalperson@yhbt.net, joe@oampo.co.uk,
	bugzilla.frnkcg@spamgourmet.com, jussi@sonarnerd.net
Cc: Shuah Khan <shuahkh@osg.samsung.com>, linux-media@vger.kernel.org,
	alsa-devel@alsa-project.org
Subject: [PATCH v3 07/21] media: Media Controller non-locking __media_entity_pipeline_start/stop()
Date: Tue, 22 Sep 2015 11:19:26 -0600
Message-Id: <60b4a5067c665d2bc60bf10bb26aafefa7db4255.1442937669.git.shuahkh@osg.samsung.com>
In-Reply-To: <cover.1442937669.git.shuahkh@osg.samsung.com>
References: <cover.1442937669.git.shuahkh@osg.samsung.com>
In-Reply-To: <cover.1442937669.git.shuahkh@osg.samsung.com>
References: <cover.1442937669.git.shuahkh@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add non-locking __media_entity_pipeline_start/stop() interfaces
to be called from code paths that hold the graph_mutex. For this
change, the media_entity_pipeline_start() routine is renamed to
__media_entity_pipeline_start() minus the graph_mutex lock and
unlock. media_entity_pipeline_start() now calls the non-locking
__media_entity_pipeline_start() holding the graph_lock. The stop
interface, media_entity_pipeline_stop() routine is renamed to
__media_entity_pipeline_stop() minus the graph_mutex lock and
unlock. media_entity_pipeline_stop() now calls the non-locking
__media_entity_pipeline_stop() holding the graph_lock.

Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
---
 drivers/media/media-entity.c | 45 ++++++++++++++++++++++++++++++--------------
 include/media/media-entity.h |  3 +++
 2 files changed, 34 insertions(+), 14 deletions(-)

diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
index 03b3836..b87e773 100644
--- a/drivers/media/media-entity.c
+++ b/drivers/media/media-entity.c
@@ -210,6 +210,7 @@ EXPORT_SYMBOL_GPL(media_entity_graph_walk_next);
 
 /**
  * media_entity_pipeline_start - Mark a pipeline as streaming
+ * __media_entity_pipeline_start - Mark a pipeline as streaming
  * @entity: Starting entity
  * @pipe: Media pipeline to be assigned to all entities in the pipeline.
  *
@@ -220,18 +221,17 @@ EXPORT_SYMBOL_GPL(media_entity_graph_walk_next);
  * Calls to this function can be nested, in which case the same number of
  * media_entity_pipeline_stop() calls will be required to stop streaming. The
  * pipeline pointer must be identical for all nested calls to
- * media_entity_pipeline_start().
+ * __media_entity_pipeline_start().
+ * User is expected to hold the graph_mutex. If not user can call
+ * media_entity_pipeline_start()
  */
-__must_check int media_entity_pipeline_start(struct media_entity *entity,
-					     struct media_pipeline *pipe)
+__must_check int __media_entity_pipeline_start(struct media_entity *entity,
+					       struct media_pipeline *pipe)
 {
-	struct media_device *mdev = entity->parent;
 	struct media_entity_graph graph;
 	struct media_entity *entity_err = entity;
 	int ret;
 
-	mutex_lock(&mdev->graph_mutex);
-
 	media_entity_graph_walk_start(&graph, entity);
 
 	while ((entity = media_entity_graph_walk_next(&graph))) {
@@ -303,8 +303,6 @@ __must_check int media_entity_pipeline_start(struct media_entity *entity,
 		}
 	}
 
-	mutex_unlock(&mdev->graph_mutex);
-
 	return 0;
 
 error:
@@ -330,14 +328,25 @@ error:
 			break;
 	}
 
-	mutex_unlock(&mdev->graph_mutex);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(__media_entity_pipeline_start);
 
+__must_check int media_entity_pipeline_start(struct media_entity *entity,
+					     struct media_pipeline *pipe)
+{
+	struct media_device *mdev = entity->parent;
+	int ret;
+
+	mutex_lock(&mdev->graph_mutex);
+	ret = __media_entity_pipeline_start(entity, pipe);
+	mutex_unlock(&mdev->graph_mutex);
 	return ret;
 }
 EXPORT_SYMBOL_GPL(media_entity_pipeline_start);
 
 /**
- * media_entity_pipeline_stop - Mark a pipeline as not streaming
+ * __media_entity_pipeline_stop - Mark a pipeline as not streaming
  * @entity: Starting entity
  *
  * Mark all entities connected to a given entity through enabled links, either
@@ -347,14 +356,13 @@ EXPORT_SYMBOL_GPL(media_entity_pipeline_start);
  * If multiple calls to media_entity_pipeline_start() have been made, the same
  * number of calls to this function are required to mark the pipeline as not
  * streaming.
+ * User is expected to hold the graph_mutex. If not user can call
+ * media_entity_pipeline_stop()
  */
-void media_entity_pipeline_stop(struct media_entity *entity)
+void __media_entity_pipeline_stop(struct media_entity *entity)
 {
-	struct media_device *mdev = entity->parent;
 	struct media_entity_graph graph;
 
-	mutex_lock(&mdev->graph_mutex);
-
 	media_entity_graph_walk_start(&graph, entity);
 
 	while ((entity = media_entity_graph_walk_next(&graph))) {
@@ -366,6 +374,15 @@ void media_entity_pipeline_stop(struct media_entity *entity)
 		}
 	}
 
+}
+EXPORT_SYMBOL_GPL(__media_entity_pipeline_stop);
+
+void media_entity_pipeline_stop(struct media_entity *entity)
+{
+	struct media_device *mdev = entity->parent;
+
+	mutex_lock(&mdev->graph_mutex);
+	__media_entity_pipeline_stop(entity);
 	mutex_unlock(&mdev->graph_mutex);
 }
 EXPORT_SYMBOL_GPL(media_entity_pipeline_stop);
diff --git a/include/media/media-entity.h b/include/media/media-entity.h
index 0c003d8..cc0bbd0 100644
--- a/include/media/media-entity.h
+++ b/include/media/media-entity.h
@@ -148,8 +148,11 @@ void media_entity_graph_walk_start(struct media_entity_graph *graph,
 		struct media_entity *entity);
 struct media_entity *
 media_entity_graph_walk_next(struct media_entity_graph *graph);
+__must_check int __media_entity_pipeline_start(struct media_entity *entity,
+					       struct media_pipeline *pipe);
 __must_check int media_entity_pipeline_start(struct media_entity *entity,
 					     struct media_pipeline *pipe);
+void __media_entity_pipeline_stop(struct media_entity *entity);
 void media_entity_pipeline_stop(struct media_entity *entity);
 
 #define media_entity_call(entity, operation, args...)			\
-- 
2.1.4

