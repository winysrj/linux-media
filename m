Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:52614 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753023AbcBURk2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 21 Feb 2016 12:40:28 -0500
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: mchehab@osg.samsung.com, Sakari Ailus <sakari.ailus@iki.fi>
Subject: [PATCH v3 1/4] media: Always keep a graph walk large enough around
Date: Sun, 21 Feb 2016 18:25:08 +0200
Message-Id: <1456071911-3284-2-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1456071911-3284-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1456071911-3284-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Sakari Ailus <sakari.ailus@iki.fi>

Re-create the graph walk object as needed in order to have one large enough
available for all entities in the graph.

This enumeration is used for pipeline power management in the future.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/media-device.c | 21 +++++++++++++++++++++
 include/media/media-device.h |  3 +++
 2 files changed, 24 insertions(+)

diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
index 5ebb3cd..c8c1626 100644
--- a/drivers/media/media-device.c
+++ b/drivers/media/media-device.c
@@ -581,6 +581,26 @@ int __must_check media_device_register_entity(struct media_device *mdev,
 
 	spin_unlock(&mdev->lock);
 
+	mutex_lock(&mdev->graph_mutex);
+	if (mdev->entity_internal_idx_max
+	    >= mdev->pm_count_walk.ent_enum.idx_max) {
+		struct media_entity_graph new = { .top = 0 };
+
+		/*
+		 * Initialise the new graph walk before cleaning up
+		 * the old one in order not to spoil the graph walk
+		 * object of the media device if graph walk init fails.
+		 */
+		ret = media_entity_graph_walk_init(&new, mdev);
+		if (ret) {
+			mutex_unlock(&mdev->graph_mutex);
+			return ret;
+		}
+		media_entity_graph_walk_cleanup(&mdev->pm_count_walk);
+		mdev->pm_count_walk = new;
+	}
+	mutex_unlock(&mdev->graph_mutex);
+
 	return 0;
 }
 EXPORT_SYMBOL_GPL(media_device_register_entity);
@@ -656,6 +676,7 @@ void media_device_cleanup(struct media_device *mdev)
 {
 	ida_destroy(&mdev->entity_internal_idx);
 	mdev->entity_internal_idx_max = 0;
+	media_entity_graph_walk_cleanup(&mdev->pm_count_walk);
 	mutex_destroy(&mdev->graph_mutex);
 }
 EXPORT_SYMBOL_GPL(media_device_cleanup);
diff --git a/include/media/media-device.h b/include/media/media-device.h
index 165451b..168ccb3 100644
--- a/include/media/media-device.h
+++ b/include/media/media-device.h
@@ -289,6 +289,8 @@ struct device;
  * @links:	List of registered links
  * @lock:	Entities list lock
  * @graph_mutex: Entities graph operation lock
+ * @pm_count_walk: Graph walk for power state walk. Access serialised using
+		   graph_mutex.
  * @link_notify: Link state change notification callback
  *
  * This structure represents an abstract high-level media device. It allows easy
@@ -328,6 +330,7 @@ struct media_device {
 	spinlock_t lock;
 	/* Serializes graph operations. */
 	struct mutex graph_mutex;
+	struct media_entity_graph pm_count_walk;
 
 	int (*link_notify)(struct media_link *link, u32 flags,
 			   unsigned int notification);
-- 
2.1.4

