Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout.easymail.ca ([64.68.201.169]:35853 "EHLO
	mailout.easymail.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751310AbcBKXl6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Feb 2016 18:41:58 -0500
From: Shuah Khan <shuahkh@osg.samsung.com>
To: mchehab@osg.samsung.com, tiwai@suse.com, clemens@ladisch.de,
	hans.verkuil@cisco.com, laurent.pinchart@ideasonboard.com,
	sakari.ailus@linux.intel.com, javier@osg.samsung.com
Cc: Shuah Khan <shuahkh@osg.samsung.com>, pawel@osciak.com,
	m.szyprowski@samsung.com, kyungmin.park@samsung.com,
	perex@perex.cz, arnd@arndb.de, dan.carpenter@oracle.com,
	tvboxspy@gmail.com, crope@iki.fi, ruchandani.tina@gmail.com,
	corbet@lwn.net, chehabrafael@gmail.com, k.kozlowski@samsung.com,
	stefanr@s5r6.in-berlin.de, inki.dae@samsung.com,
	jh1009.sung@samsung.com, elfring@users.sourceforge.net,
	prabhakar.csengg@gmail.com, sw0312.kim@samsung.com,
	p.zabel@pengutronix.de, ricardo.ribalda@gmail.com,
	labbott@fedoraproject.org, pierre-louis.bossart@linux.intel.com,
	ricard.wanderlof@axis.com, julian@jusst.de, takamichiho@gmail.com,
	dominic.sacre@gmx.de, misterpib@gmail.com, daniel@zonque.org,
	gtmkramer@xs4all.nl, normalperson@yhbt.net, joe@oampo.co.uk,
	linuxbugs@vittgam.net, johan@oljud.se, klock.android@gmail.com,
	nenggun.kim@samsung.com, j.anaszewski@samsung.com,
	geliangtang@163.com, albert@huitsing.nl,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	alsa-devel@alsa-project.org
Subject: [PATCH v3 08/22] media: Media Controller non-locking __media_entity_pipeline_start/stop()
Date: Thu, 11 Feb 2016 16:41:24 -0700
Message-Id: <9812e3c0d4c9133d05a38be29044efc269d5446a.1455233153.git.shuahkh@osg.samsung.com>
In-Reply-To: <cover.1455233150.git.shuahkh@osg.samsung.com>
References: <cover.1455233150.git.shuahkh@osg.samsung.com>
In-Reply-To: <cover.1455233150.git.shuahkh@osg.samsung.com>
References: <cover.1455233150.git.shuahkh@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add non-locking __media_entity_pipeline_start/stop()
interfaces to be called from code paths that hold the
graph_mutex.

Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
---
 drivers/media/media-entity.c | 34 ++++++++++++++++++++++++----------
 include/media/media-entity.h | 19 +++++++++++++++++++
 2 files changed, 43 insertions(+), 10 deletions(-)

diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
index 9b4d712..b78e4c2 100644
--- a/drivers/media/media-entity.c
+++ b/drivers/media/media-entity.c
@@ -365,8 +365,8 @@ EXPORT_SYMBOL_GPL(media_entity_graph_walk_next);
  * Pipeline management
  */
 
-__must_check int media_entity_pipeline_start(struct media_entity *entity,
-					     struct media_pipeline *pipe)
+__must_check int __media_entity_pipeline_start(struct media_entity *entity,
+					       struct media_pipeline *pipe)
 {
 	struct media_device *mdev = entity->graph_obj.mdev;
 	struct media_entity_graph *graph = &pipe->graph;
@@ -374,8 +374,6 @@ __must_check int media_entity_pipeline_start(struct media_entity *entity,
 	struct media_link *link;
 	int ret;
 
-	mutex_lock(&mdev->graph_mutex);
-
 	if (!pipe->streaming_count++) {
 		ret = media_entity_graph_walk_init(&pipe->graph, mdev);
 		if (ret)
@@ -456,8 +454,6 @@ __must_check int media_entity_pipeline_start(struct media_entity *entity,
 		}
 	}
 
-	mutex_unlock(&mdev->graph_mutex);
-
 	return 0;
 
 error:
@@ -487,19 +483,28 @@ error_graph_walk_start:
 	if (!--pipe->streaming_count)
 		media_entity_graph_walk_cleanup(graph);
 
-	mutex_unlock(&mdev->graph_mutex);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(__media_entity_pipeline_start);
 
+__must_check int media_entity_pipeline_start(struct media_entity *entity,
+					     struct media_pipeline *pipe)
+{
+	struct media_device *mdev = entity->graph_obj.mdev;
+	int ret;
+
+	mutex_lock(&mdev->graph_mutex);
+	ret = __media_entity_pipeline_start(entity, pipe);
+	mutex_unlock(&mdev->graph_mutex);
 	return ret;
 }
 EXPORT_SYMBOL_GPL(media_entity_pipeline_start);
 
-void media_entity_pipeline_stop(struct media_entity *entity)
+void __media_entity_pipeline_stop(struct media_entity *entity)
 {
-	struct media_device *mdev = entity->graph_obj.mdev;
 	struct media_entity_graph *graph = &entity->pipe->graph;
 	struct media_pipeline *pipe = entity->pipe;
 
-	mutex_lock(&mdev->graph_mutex);
 
 	WARN_ON(!pipe->streaming_count);
 	media_entity_graph_walk_start(graph, entity);
@@ -516,6 +521,15 @@ void media_entity_pipeline_stop(struct media_entity *entity)
 	if (!--pipe->streaming_count)
 		media_entity_graph_walk_cleanup(graph);
 
+}
+EXPORT_SYMBOL_GPL(__media_entity_pipeline_stop);
+
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
index fe485d3..d58e29d 100644
--- a/include/media/media-entity.h
+++ b/include/media/media-entity.h
@@ -832,6 +832,16 @@ media_entity_graph_walk_next(struct media_entity_graph *graph);
  */
 __must_check int media_entity_pipeline_start(struct media_entity *entity,
 					     struct media_pipeline *pipe);
+/**
+ * __media_entity_pipeline_start - Mark a pipeline as streaming
+ *
+ * @entity: Starting entity
+ * @pipe: Media pipeline to be assigned to all entities in the pipeline.
+ *
+ * Note: This is the non-locking version of media_entity_pipeline_start()
+ */
+__must_check int __media_entity_pipeline_start(struct media_entity *entity,
+					       struct media_pipeline *pipe);
 
 /**
  * media_entity_pipeline_stop - Mark a pipeline as not streaming
@@ -848,6 +858,15 @@ __must_check int media_entity_pipeline_start(struct media_entity *entity,
 void media_entity_pipeline_stop(struct media_entity *entity);
 
 /**
+ * __media_entity_pipeline_stop - Mark a pipeline as not streaming
+ *
+ * @entity: Starting entity
+ *
+ * Note: This is the non-locking version of media_entity_pipeline_stop()
+ */
+void __media_entity_pipeline_stop(struct media_entity *entity);
+
+/**
  * media_devnode_create() - creates and initializes a device node interface
  *
  * @mdev:	pointer to struct &media_device
-- 
2.5.0

