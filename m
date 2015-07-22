Return-path: <linux-media-owner@vger.kernel.org>
Received: from resqmta-po-04v.sys.comcast.net ([96.114.154.163]:51792 "EHLO
	resqmta-po-04v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752524AbbGVWmz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 22 Jul 2015 18:42:55 -0400
From: Shuah Khan <shuahkh@osg.samsung.com>
To: mchehab@osg.samsung.com, hans.verkuil@cisco.com,
	laurent.pinchart@ideasonboard.com, tiwai@suse.de,
	sakari.ailus@linux.intel.com, perex@perex.cz, crope@iki.fi,
	arnd@arndb.de, stefanr@s5r6.in-berlin.de,
	ruchandani.tina@gmail.com, chehabrafael@gmail.com,
	dan.carpenter@oracle.com, prabhakar.csengg@gmail.com,
	chris.j.arges@canonical.com, agoode@google.com,
	pierre-louis.bossart@linux.intel.com, gtmkramer@xs4all.nl,
	clemens@ladisch.de, daniel@zonque.org, vladcatoi@gmail.com,
	misterpib@gmail.com, damien@zamaudio.com, pmatilai@laiskiainen.org,
	takamichiho@gmail.com, normalperson@yhbt.net,
	bugzilla.frnkcg@spamgourmet.com, joe@oampo.co.uk,
	calcprogrammer1@gmail.com, jussi@sonarnerd.net,
	kyungmin.park@samsung.com, s.nawrocki@samsung.com,
	kgene@kernel.org, hyun.kwon@xilinx.com, michal.simek@xilinx.com,
	soren.brinkmann@xilinx.com, pawel@osciak.com,
	m.szyprowski@samsung.com, gregkh@linuxfoundation.org,
	skd08@gmail.com, nsekhar@ti.com,
	boris.brezillon@free-electrons.com, Julia.Lawall@lip6.fr,
	elfring@users.sourceforge.net, p.zabel@pengutronix.de,
	ricardo.ribalda@gmail.com
Cc: Shuah Khan <shuahkh@osg.samsung.com>, linux-media@vger.kernel.org,
	alsa-devel@alsa-project.org, linux-samsung-soc@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, devel@driverdev.osuosl.org
Subject: [PATCH v2 13/19] media: Add irq safe Media Controller start/stop pipeline API
Date: Wed, 22 Jul 2015 16:42:14 -0600
Message-Id: <84442c1c9f7f725189a935936751fc4117ae9c5f.1437599281.git.shuahkh@osg.samsung.com>
In-Reply-To: <cover.1437599281.git.shuahkh@osg.samsung.com>
References: <cover.1437599281.git.shuahkh@osg.samsung.com>
In-Reply-To: <cover.1437599281.git.shuahkh@osg.samsung.com>
References: <cover.1437599281.git.shuahkh@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add irq safe Media Controller start/stop pipeline API
media_entity_pipeline_start_irq()
media_entity_pipeline_stop_irq()
to be used from inside interrupt context.

Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
---
 drivers/media/media-entity.c | 80 +++++++++++++++++++++++++++++++++++++-------
 include/media/media-entity.h |  3 ++
 2 files changed, 70 insertions(+), 13 deletions(-)

diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
index 31132573..293cf25 100644
--- a/drivers/media/media-entity.c
+++ b/drivers/media/media-entity.c
@@ -210,6 +210,8 @@ EXPORT_SYMBOL_GPL(media_entity_graph_walk_next);
 
 /**
  * media_entity_pipeline_start - Mark a pipeline as streaming
+ * media_entity_pipeline_start_irq - Mark a pipeline as streaming
+ *			(safe to be used from inside interrupt context)
  * @entity: Starting entity
  * @pipe: Media pipeline to be assigned to all entities in the pipeline.
  *
@@ -222,16 +224,18 @@ EXPORT_SYMBOL_GPL(media_entity_graph_walk_next);
  * pipeline pointer must be identical for all nested calls to
  * media_entity_pipeline_start().
  */
-__must_check int media_entity_pipeline_start(struct media_entity *entity,
-					     struct media_pipeline *pipe)
+/*
+ * __media_entity_pipeline_start()
+ * Should be called with graph_lock held
+*/
+static __must_check int __media_entity_pipeline_start(
+						struct media_entity *entity,
+						struct media_pipeline *pipe)
 {
-	struct media_device *mdev = entity->parent;
 	struct media_entity_graph graph;
 	struct media_entity *entity_err = entity;
 	int ret;
 
-	spin_lock(&mdev->graph_lock);
-
 	media_entity_graph_walk_start(&graph, entity);
 
 	while ((entity = media_entity_graph_walk_next(&graph))) {
@@ -303,8 +307,6 @@ __must_check int media_entity_pipeline_start(struct media_entity *entity,
 		}
 	}
 
-	spin_unlock(&mdev->graph_lock);
-
 	return 0;
 
 error:
@@ -327,14 +329,46 @@ error:
 			break;
 	}
 
-	spin_unlock(&mdev->graph_lock);
+	return ret;
+}
 
+/*
+ * media_entity_pipeline_start - Mark a pipeline as streaming
+ *			(unsafe to be used from inside interrupt context)
+*/
+__must_check int media_entity_pipeline_start(struct media_entity *entity,
+					     struct media_pipeline *pipe)
+{
+	int ret;
+
+	spin_lock(&entity->parent->graph_lock);
+	ret = __media_entity_pipeline_start(entity, pipe);
+	spin_unlock(&entity->parent->graph_lock);
 	return ret;
 }
 EXPORT_SYMBOL_GPL(media_entity_pipeline_start);
 
+/*
+ * media_entity_pipeline_start_irq - Mark a pipeline as streaming
+ *			(safe to be used from inside interrupt context)
+*/
+__must_check int media_entity_pipeline_start_irq(struct media_entity *entity,
+						 struct media_pipeline *pipe)
+{
+	int ret;
+	unsigned long flags;
+
+	spin_lock_irqsave(&entity->parent->graph_lock, flags);
+	ret = __media_entity_pipeline_start(entity, pipe);
+	spin_unlock_irqrestore(&entity->parent->graph_lock, flags);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(media_entity_pipeline_start_irq);
+
 /**
  * media_entity_pipeline_stop - Mark a pipeline as not streaming
+ * media_entity_pipeline_stop_irq - Mark a pipeline as not streaming
+ *			(safe to be used from inside interrupt context)
  * @entity: Starting entity
  *
  * Mark all entities connected to a given entity through enabled links, either
@@ -345,13 +379,10 @@ EXPORT_SYMBOL_GPL(media_entity_pipeline_start);
  * number of calls to this function are required to mark the pipeline as not
  * streaming.
  */
-void media_entity_pipeline_stop(struct media_entity *entity)
+static void __media_entity_pipeline_stop(struct media_entity *entity)
 {
-	struct media_device *mdev = entity->parent;
 	struct media_entity_graph graph;
 
-	spin_lock(&mdev->graph_lock);
-
 	media_entity_graph_walk_start(&graph, entity);
 
 	while ((entity = media_entity_graph_walk_next(&graph))) {
@@ -359,11 +390,34 @@ void media_entity_pipeline_stop(struct media_entity *entity)
 		if (entity->stream_count == 0)
 			entity->pipe = NULL;
 	}
+}
 
-	spin_unlock(&mdev->graph_lock);
+/*
+ * media_entity_pipeline_stop - Mark a pipeline as not streaming
+ *			(unsafe to be used from inside interrupt context)
+*/
+void media_entity_pipeline_stop(struct media_entity *entity)
+{
+	spin_lock(&entity->parent->graph_lock);
+	__media_entity_pipeline_stop(entity);
+	spin_unlock(&entity->parent->graph_lock);
 }
 EXPORT_SYMBOL_GPL(media_entity_pipeline_stop);
 
+/*
+ * media_entity_pipeline_stop_irq - Mark a pipeline as not streaming
+ *			(safe to be used from inside interrupt context)
+*/
+void media_entity_pipeline_stop_irq(struct media_entity *entity)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&entity->parent->graph_lock, flags);
+	__media_entity_pipeline_stop(entity);
+	spin_unlock_irqrestore(&entity->parent->graph_lock, flags);
+}
+EXPORT_SYMBOL_GPL(media_entity_pipeline_stop_irq);
+
 /* -----------------------------------------------------------------------------
  * Module use count
  */
diff --git a/include/media/media-entity.h b/include/media/media-entity.h
index 0c003d8..a4be306 100644
--- a/include/media/media-entity.h
+++ b/include/media/media-entity.h
@@ -151,6 +151,9 @@ media_entity_graph_walk_next(struct media_entity_graph *graph);
 __must_check int media_entity_pipeline_start(struct media_entity *entity,
 					     struct media_pipeline *pipe);
 void media_entity_pipeline_stop(struct media_entity *entity);
+__must_check int media_entity_pipeline_start_irq(struct media_entity *entity,
+					     struct media_pipeline *pipe);
+void media_entity_pipeline_stop_irq(struct media_entity *entity);
 
 #define media_entity_call(entity, operation, args...)			\
 	(((entity)->ops && (entity)->ops->operation) ?			\
-- 
2.1.4

