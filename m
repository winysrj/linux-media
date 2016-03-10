Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout.easymail.ca ([64.68.201.169]:33751 "EHLO
	mailout.easymail.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935061AbcCJFHR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Mar 2016 00:07:17 -0500
From: Shuah Khan <shuahkh@osg.samsung.com>
To: mchehab@osg.samsung.com, hans.verkuil@cisco.com,
	chehabrafael@gmail.com, javier@osg.samsung.com,
	inki.dae@samsung.com, jh1009.sung@samsung.com,
	sakari.ailus@linux.intel.com
Cc: Shuah Khan <shuahkh@osg.samsung.com>, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 3/4] media: au0828 add media device change_source handler
Date: Wed,  9 Mar 2016 22:07:09 -0700
Message-Id: <2d5a07078a83766aaf3f28be1616e7a4a3062ea3.1457585839.git.shuahkh@osg.samsung.com>
In-Reply-To: <cover.1457585839.git.shuahkh@osg.samsung.com>
References: <cover.1457585839.git.shuahkh@osg.samsung.com>
In-Reply-To: <cover.1457585839.git.shuahkh@osg.samsung.com>
References: <cover.1457585839.git.shuahkh@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add media device change_source handler. Using the change_source handler,
driver can disable current source and enable new one in one step when
user selects a new input.

Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
---
 drivers/media/usb/au0828/au0828-core.c | 64 ++++++++++++++++++++++++----------
 1 file changed, 46 insertions(+), 18 deletions(-)

diff --git a/drivers/media/usb/au0828/au0828-core.c b/drivers/media/usb/au0828/au0828-core.c
index 5dc82e8..01dba5a 100644
--- a/drivers/media/usb/au0828/au0828-core.c
+++ b/drivers/media/usb/au0828/au0828-core.c
@@ -258,8 +258,8 @@ create_link:
 	}
 }
 
-static int au0828_enable_source(struct media_entity *entity,
-				struct media_pipeline *pipe)
+static int __au0828_enable_source(struct media_entity *entity,
+				  struct media_pipeline *pipe)
 {
 	struct media_entity  *source, *find_source;
 	struct media_entity *sink;
@@ -268,11 +268,6 @@ static int au0828_enable_source(struct media_entity *entity,
 	struct media_device *mdev = entity->graph_obj.mdev;
 	struct au0828_dev *dev;
 
-	if (!mdev)
-		return -ENODEV;
-
-	mutex_lock(&mdev->graph_mutex);
-
 	dev = mdev->source_priv;
 
 	/*
@@ -399,28 +394,36 @@ static int au0828_enable_source(struct media_entity *entity,
 		 dev->active_source->name, dev->active_sink->name,
 		 dev->active_link_owner->name, ret);
 end:
-	mutex_unlock(&mdev->graph_mutex);
 	pr_debug("au0828_enable_source() end %s %d %d\n",
 		 entity->name, entity->function, ret);
 	return ret;
 }
 
-static void au0828_disable_source(struct media_entity *entity)
+static int au0828_enable_source(struct media_entity *entity,
+				struct media_pipeline *pipe)
 {
-	int ret = 0;
 	struct media_device *mdev = entity->graph_obj.mdev;
-	struct au0828_dev *dev;
+	int ret;
 
 	if (!mdev)
-		return;
+		return -ENODEV;
 
 	mutex_lock(&mdev->graph_mutex);
+	ret = __au0828_enable_source(entity, pipe);
+	mutex_unlock(&mdev->graph_mutex);
+	return ret;
+}
+
+static void __au0828_disable_source(struct media_entity *entity)
+{
+	int ret = 0;
+	struct media_device *mdev = entity->graph_obj.mdev;
+	struct au0828_dev *dev;
+
 	dev = mdev->source_priv;
 
-	if (!dev->active_link) {
-		ret = -ENODEV;
-		goto end;
-	}
+	if (!dev->active_link)
+		return;
 
 	/* link is active - stop pipeline from source (tuner) */
 	if (dev->active_link->sink->entity == dev->active_sink &&
@@ -430,7 +433,7 @@ static void au0828_disable_source(struct media_entity *entity)
 		 * has active pipeline
 		*/
 		if (dev->active_link_owner != entity)
-			goto end;
+			return;
 		__media_entity_pipeline_stop(entity);
 		ret = __media_entity_setup_link(dev->active_link, 0);
 		if (ret)
@@ -445,10 +448,34 @@ static void au0828_disable_source(struct media_entity *entity)
 		dev->active_source = NULL;
 		dev->active_sink = NULL;
 	}
+}
 
-end:
+static void au0828_disable_source(struct media_entity *entity)
+{
+	struct media_device *mdev = entity->graph_obj.mdev;
+
+	if (!mdev)
+		return;
+
+	mutex_lock(&mdev->graph_mutex);
+	__au0828_disable_source(entity);
 	mutex_unlock(&mdev->graph_mutex);
 }
+static int au0828_change_source(struct media_entity *entity,
+				struct media_pipeline *pipe)
+{
+	struct media_device *mdev = entity->graph_obj.mdev;
+	int ret;
+
+	if (!mdev)
+		return -ENODEV;
+
+	mutex_lock(&mdev->graph_mutex);
+	__au0828_disable_source(entity);
+	ret = __au0828_enable_source(entity, pipe);
+	mutex_unlock(&mdev->graph_mutex);
+	return ret;
+}
 #endif
 
 static int au0828_media_device_register(struct au0828_dev *dev,
@@ -520,6 +547,7 @@ static int au0828_media_device_register(struct au0828_dev *dev,
 	dev->media_dev->source_priv = (void *) dev;
 	dev->media_dev->enable_source = au0828_enable_source;
 	dev->media_dev->disable_source = au0828_disable_source;
+	dev->media_dev->change_source = au0828_change_source;
 #endif
 	return 0;
 }
-- 
2.5.0

