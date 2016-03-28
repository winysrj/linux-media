Return-path: <linux-media-owner@vger.kernel.org>
Received: from [198.137.202.9] ([198.137.202.9]:51209 "EHLO
	bombadil.infradead.org" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754086AbcC1SL6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 28 Mar 2016 14:11:58 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Shuah Khan <shuahkh@osg.samsung.com>,
	Sakari Ailus <sakari.ailus@iki.fi>
Subject: [PATCH 2/2] [media] avoid double locks with graph_mutex
Date: Mon, 28 Mar 2016 15:11:04 -0300
Message-Id: <3cabc4b828abac3c6dea240ae22d4754a438ad1b.1459188623.git.mchehab@osg.samsung.com>
In-Reply-To: <91b3d9b66d52707ca95d996edd423c0f5e36b6ca.1459188623.git.mchehab@osg.samsung.com>
References: <20160328150948.3efa93ee@recife.lan>
 <91b3d9b66d52707ca95d996edd423c0f5e36b6ca.1459188623.git.mchehab@osg.samsung.com>
In-Reply-To: <91b3d9b66d52707ca95d996edd423c0f5e36b6ca.1459188623.git.mchehab@osg.samsung.com>
References: <91b3d9b66d52707ca95d996edd423c0f5e36b6ca.1459188623.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add a note at the headers telling that the link setup
callbacks are called with the mutex hold. Also, removes a
double lock at the PM suspend callbacks.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
---
 drivers/media/media-device.c      | 1 -
 drivers/media/v4l2-core/v4l2-mc.c | 4 ----
 include/media/media-device.h      | 3 ++-
 include/media/media-entity.h      | 3 +++
 4 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
index 6cfa890af7b4..6af5e6932271 100644
--- a/drivers/media/media-device.c
+++ b/drivers/media/media-device.c
@@ -93,7 +93,6 @@ static struct media_entity *find_entity(struct media_device *mdev, u32 id)
 	media_device_for_each_entity(entity, mdev) {
 		if (((media_entity_id(entity) == id) && !next) ||
 		    ((media_entity_id(entity) > id) && next)) {
-			mutex_unlock(&mdev->graph_mutex);
 			return entity;
 		}
 	}
diff --git a/drivers/media/v4l2-core/v4l2-mc.c b/drivers/media/v4l2-core/v4l2-mc.c
index 2228cd3a846e..d44ff2ec314f 100644
--- a/drivers/media/v4l2-core/v4l2-mc.c
+++ b/drivers/media/v4l2-core/v4l2-mc.c
@@ -348,8 +348,6 @@ int v4l2_pipeline_pm_use(struct media_entity *entity, int use)
 	int change = use ? 1 : -1;
 	int ret;
 
-	mutex_lock(&mdev->graph_mutex);
-
 	/* Apply use count to node. */
 	entity->use_count += change;
 	WARN_ON(entity->use_count < 0);
@@ -359,8 +357,6 @@ int v4l2_pipeline_pm_use(struct media_entity *entity, int use)
 	if (ret < 0)
 		entity->use_count -= change;
 
-	mutex_unlock(&mdev->graph_mutex);
-
 	return ret;
 }
 EXPORT_SYMBOL_GPL(v4l2_pipeline_pm_use);
diff --git a/include/media/media-device.h b/include/media/media-device.h
index b04cfa907350..e6ad30c323fc 100644
--- a/include/media/media-device.h
+++ b/include/media/media-device.h
@@ -312,7 +312,8 @@ struct media_entity_notify {
  * @enable_source: Enable Source Handler function pointer
  * @disable_source: Disable Source Handler function pointer
  *
- * @link_notify: Link state change notification callback
+ * @link_notify: Link state change notification callback. This callback is
+ * Called with the graph_mutex hold.
  *
  * This structure represents an abstract high-level media device. It allows easy
  * access to entities and provides basic media device-level support. The
diff --git a/include/media/media-entity.h b/include/media/media-entity.h
index 6dc9e4e8cbd4..0b16ebe36db7 100644
--- a/include/media/media-entity.h
+++ b/include/media/media-entity.h
@@ -179,6 +179,9 @@ struct media_pad {
  * @link_validate:	Return whether a link is valid from the entity point of
  *			view. The media_entity_pipeline_start() function
  *			validates all links by calling this operation. Optional.
+ *
+ * Note: Those ioctls should not touch the struct media_device.@graph_mutex
+ * field, as they're called with it already hold.
  */
 struct media_entity_operations {
 	int (*link_setup)(struct media_entity *entity,
-- 
2.5.5

