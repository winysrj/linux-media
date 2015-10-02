Return-path: <linux-media-owner@vger.kernel.org>
Received: from resqmta-po-10v.sys.comcast.net ([96.114.154.169]:51997 "EHLO
	resqmta-po-10v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751839AbbJBWHl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 2 Oct 2015 18:07:41 -0400
From: Shuah Khan <shuahkh@osg.samsung.com>
To: mchehab@osg.samsung.com, hans.verkuil@cisco.com,
	laurent.pinchart@ideasonboard.com, sakari.ailus@linux.intel.com,
	tiwai@suse.de, pawel@osciak.com, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, perex@perex.cz,
	dan.carpenter@oracle.com, tskd08@gmail.com, arnd@arndb.de,
	ruchandani.tina@gmail.com, corbet@lwn.net, k.kozlowski@samsung.com,
	chehabrafael@gmail.com, prabhakar.csengg@gmail.com,
	elfring@users.sourceforge.net, Julia.Lawall@lip6.fr,
	p.zabel@pengutronix.de, ricardo.ribalda@gmail.com,
	labbott@fedoraproject.org, chris.j.arges@canonical.com,
	pierre-louis.bossart@linux.intel.com, johan@oljud.se,
	wsa@the-dreams.de, jcragg@gmail.com, clemens@ladisch.de,
	daniel@zonque.org, gtmkramer@xs4all.nl, misterpib@gmail.com,
	takamichiho@gmail.com, pmatilai@laiskiainen.org,
	vladcatoi@gmail.com, damien@zamaudio.com, normalperson@yhbt.net,
	joe@oampo.co.uk, jussi@sonarnerd.net, calcprogrammer1@gmail.com
Cc: Shuah Khan <shuahkh@osg.samsung.com>, linux-media@vger.kernel.org,
	alsa-devel@alsa-project.org
Subject: [PATCH MC Next Gen 06/20] media: Media Controller non-locking __media_entity_pipeline_start/stop()
Date: Fri,  2 Oct 2015 16:07:18 -0600
Message-Id: <ecc9a490c702dd88e5f4fb217cf827b1e9bd6073.1443822799.git.shuahkh@osg.samsung.com>
In-Reply-To: <cover.1443822799.git.shuahkh@osg.samsung.com>
References: <cover.1443822799.git.shuahkh@osg.samsung.com>
In-Reply-To: <cover.1443822799.git.shuahkh@osg.samsung.com>
References: <cover.1443822799.git.shuahkh@osg.samsung.com>
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
 drivers/media/media-entity.c | 45 +++++++++++++++++++++++++++++---------------
 include/media/media-entity.h |  3 +++
 2 files changed, 33 insertions(+), 15 deletions(-)

diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
index 49a8755..4bb824b 100644
--- a/drivers/media/media-entity.c
+++ b/drivers/media/media-entity.c
@@ -397,7 +397,7 @@ EXPORT_SYMBOL_GPL(media_entity_graph_walk_next);
  */
 
 /**
- * media_entity_pipeline_start - Mark a pipeline as streaming
+ * __media_entity_pipeline_start - Mark a pipeline as streaming
  * @entity: Starting entity
  * @pipe: Media pipeline to be assigned to all entities in the pipeline.
  *
@@ -408,19 +408,18 @@ EXPORT_SYMBOL_GPL(media_entity_graph_walk_next);
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
+						struct media_pipeline *pipe)
 {
-	struct media_device *mdev = entity->graph_obj.mdev;
 	struct media_entity_graph graph;
 	struct media_entity *entity_err = entity;
 	struct media_link *link;
 	int ret;
 
-	mutex_lock(&mdev->graph_mutex);
-
 	media_entity_graph_walk_start(&graph, entity);
 
 	while ((entity = media_entity_graph_walk_next(&graph))) {
@@ -490,8 +489,6 @@ __must_check int media_entity_pipeline_start(struct media_entity *entity,
 		}
 	}
 
-	mutex_unlock(&mdev->graph_mutex);
-
 	return 0;
 
 error:
@@ -517,14 +514,25 @@ error:
 			break;
 	}
 
-	mutex_unlock(&mdev->graph_mutex);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(__media_entity_pipeline_start);
+
+__must_check int media_entity_pipeline_start(struct media_entity *entity,
+					     struct media_pipeline *pipe)
+{
+	struct media_device *mdev = entity->graph_obj.mdev;
+	int ret;
 
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
@@ -534,14 +542,13 @@ EXPORT_SYMBOL_GPL(media_entity_pipeline_start);
  * If multiple calls to media_entity_pipeline_start() have been made, the same
  * number of calls to this function are required to mark the pipeline as not
  * streaming.
+ * User is expected to hold the graph_mutex. If not user can call
+ * media_entity_pipeline_stop()
  */
-void media_entity_pipeline_stop(struct media_entity *entity)
+void __media_entity_pipeline_stop(struct media_entity *entity)
 {
-	struct media_device *mdev = entity->graph_obj.mdev;
 	struct media_entity_graph graph;
 
-	mutex_lock(&mdev->graph_mutex);
-
 	media_entity_graph_walk_start(&graph, entity);
 
 	while ((entity = media_entity_graph_walk_next(&graph))) {
@@ -552,7 +559,15 @@ void media_entity_pipeline_stop(struct media_entity *entity)
 				entity->pipe = NULL;
 		}
 	}
+}
+EXPORT_SYMBOL_GPL(__media_entity_pipeline_stop);
 
+void media_entity_pipeline_stop(struct media_entity *entity)
+{
+	struct media_device *mdev = entity->graph_obj.mdev;
+
+	mutex_lock(&mdev->graph_mutex);
+	__media_entity_pipeline_stop(entity);
 	mutex_unlock(&mdev->graph_mutex);
 }
 EXPORT_SYMBOL_GPL(media_entity_pipeline_stop);
diff --git a/include/media/media-entity.h b/include/media/media-entity.h
index 44ab153..3b971f2 100644
--- a/include/media/media-entity.h
+++ b/include/media/media-entity.h
@@ -365,8 +365,11 @@ void media_entity_graph_walk_start(struct media_entity_graph *graph,
 		struct media_entity *entity);
 struct media_entity *
 media_entity_graph_walk_next(struct media_entity_graph *graph);
+__must_check int __media_entity_pipeline_start(struct media_entity *entity,
+						struct media_pipeline *pipe);
 __must_check int media_entity_pipeline_start(struct media_entity *entity,
 					     struct media_pipeline *pipe);
+void __media_entity_pipeline_stop(struct media_entity *entity);
 void media_entity_pipeline_stop(struct media_entity *entity);
 
 struct media_intf_devnode *
-- 
2.1.4

