Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:45384 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751020AbbDMSAx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 13 Apr 2015 14:00:53 -0400
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: linux-sh@vger.kernel.org
Subject: [PATCH] v4l: vsp1: Don't sleep in atomic context
Date: Mon, 13 Apr 2015 21:01:16 +0300
Message-Id: <1428948076-4971-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The vsp1_entity_is_streaming() function is called in atomic context when
queuing buffers, and sleeps due to a mutex. As the mutex just protects
access to one structure field, fix this by replace the mutex with a
spinlock.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/media/platform/vsp1/vsp1_entity.c | 18 +++++++++---------
 drivers/media/platform/vsp1/vsp1_entity.h |  4 ++--
 2 files changed, 11 insertions(+), 11 deletions(-)

This bug seems to have been there since the very first version of the VSP1
driver and never got caught. Amazing...

diff --git a/drivers/media/platform/vsp1/vsp1_entity.c b/drivers/media/platform/vsp1/vsp1_entity.c
index 79af71d5e270..622acd1c8d58 100644
--- a/drivers/media/platform/vsp1/vsp1_entity.c
+++ b/drivers/media/platform/vsp1/vsp1_entity.c
@@ -24,22 +24,24 @@
 
 bool vsp1_entity_is_streaming(struct vsp1_entity *entity)
 {
+	unsigned long flags;
 	bool streaming;
 
-	mutex_lock(&entity->lock);
+	spin_lock_irqsave(&entity->lock, flags);
 	streaming = entity->streaming;
-	mutex_unlock(&entity->lock);
+	spin_unlock_irqrestore(&entity->lock, flags);
 
 	return streaming;
 }
 
 int vsp1_entity_set_streaming(struct vsp1_entity *entity, bool streaming)
 {
+	unsigned long flags;
 	int ret;
 
-	mutex_lock(&entity->lock);
+	spin_lock_irqsave(&entity->lock, flags);
 	entity->streaming = streaming;
-	mutex_unlock(&entity->lock);
+	spin_unlock_irqrestore(&entity->lock, flags);
 
 	if (!streaming)
 		return 0;
@@ -49,9 +51,9 @@ int vsp1_entity_set_streaming(struct vsp1_entity *entity, bool streaming)
 
 	ret = v4l2_ctrl_handler_setup(entity->subdev.ctrl_handler);
 	if (ret < 0) {
-		mutex_lock(&entity->lock);
+		spin_lock_irqsave(&entity->lock, flags);
 		entity->streaming = false;
-		mutex_unlock(&entity->lock);
+		spin_unlock_irqrestore(&entity->lock, flags);
 	}
 
 	return ret;
@@ -193,7 +195,7 @@ int vsp1_entity_init(struct vsp1_device *vsp1, struct vsp1_entity *entity,
 	if (i == ARRAY_SIZE(vsp1_routes))
 		return -EINVAL;
 
-	mutex_init(&entity->lock);
+	spin_lock_init(&entity->lock);
 
 	entity->vsp1 = vsp1;
 	entity->source_pad = num_pads - 1;
@@ -228,6 +230,4 @@ void vsp1_entity_destroy(struct vsp1_entity *entity)
 	if (entity->subdev.ctrl_handler)
 		v4l2_ctrl_handler_free(entity->subdev.ctrl_handler);
 	media_entity_cleanup(&entity->subdev.entity);
-
-	mutex_destroy(&entity->lock);
 }
diff --git a/drivers/media/platform/vsp1/vsp1_entity.h b/drivers/media/platform/vsp1/vsp1_entity.h
index aa20aaa58208..b634013b0958 100644
--- a/drivers/media/platform/vsp1/vsp1_entity.h
+++ b/drivers/media/platform/vsp1/vsp1_entity.h
@@ -14,7 +14,7 @@
 #define __VSP1_ENTITY_H__
 
 #include <linux/list.h>
-#include <linux/mutex.h>
+#include <linux/spinlock.h>
 
 #include <media/v4l2-subdev.h>
 
@@ -73,7 +73,7 @@ struct vsp1_entity {
 
 	struct vsp1_video *video;
 
-	struct mutex lock;		/* Protects the streaming field */
+	spinlock_t lock;		/* Protects the streaming field */
 	bool streaming;
 };
 
-- 
Regards,

Laurent Pinchart

