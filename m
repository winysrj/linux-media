Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:37565 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755635AbbLKRRV (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Dec 2015 12:17:21 -0500
From: Javier Martinez Canillas <javier@osg.samsung.com>
To: linux-kernel@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Shuah Khan <shuahkh@osg.samsung.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	linux-media@vger.kernel.org,
	Javier Martinez Canillas <javier@osg.samsung.com>
Subject: [PATCH 09/10] [media] uvcvideo: register entity subdev on init
Date: Fri, 11 Dec 2015 14:16:35 -0300
Message-Id: <1449854196-13296-10-git-send-email-javier@osg.samsung.com>
In-Reply-To: <1449854196-13296-1-git-send-email-javier@osg.samsung.com>
References: <1449854196-13296-1-git-send-email-javier@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The uvc_mc_register_entities() function iterated over the entities three
times to initialize the entities, register the subdev for the ones whose
type was UVC_TT_STREAMING and to create the entities links.

But this can be simplied by merging the init and registration logic in a
single loop.

Suggested-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Javier Martinez Canillas <javier@osg.samsung.com>

---

This patch addresses an issue Laurent pointed in patch [0]:

- Move the  v4l2_device_register_subdev() call to uvc_mc_init_entity().

[0]: https://lkml.org/lkml/2015/12/5/253

 drivers/media/usb/uvc/uvc_entity.c | 33 +++++++++------------------------
 1 file changed, 9 insertions(+), 24 deletions(-)

diff --git a/drivers/media/usb/uvc/uvc_entity.c b/drivers/media/usb/uvc/uvc_entity.c
index 33119dcb7cec..ac386bb547e6 100644
--- a/drivers/media/usb/uvc/uvc_entity.c
+++ b/drivers/media/usb/uvc/uvc_entity.c
@@ -19,19 +19,6 @@
 
 #include "uvcvideo.h"
 
-/* ------------------------------------------------------------------------
- * Video subdevices registration and unregistration
- */
-
-static int uvc_mc_register_entity(struct uvc_video_chain *chain,
-	struct uvc_entity *entity)
-{
-	if (UVC_ENTITY_TYPE(entity) == UVC_TT_STREAMING)
-		return 0;
-
-	return v4l2_device_register_subdev(&chain->dev->vdev, &entity->subdev);
-}
-
 static int uvc_mc_create_links(struct uvc_video_chain *chain,
 				    struct uvc_entity *entity)
 {
@@ -85,7 +72,8 @@ void uvc_mc_cleanup_entity(struct uvc_entity *entity)
 		media_entity_cleanup(&entity->vdev->entity);
 }
 
-static int uvc_mc_init_entity(struct uvc_entity *entity)
+static int uvc_mc_init_entity(struct uvc_video_chain *chain,
+			      struct uvc_entity *entity)
 {
 	int ret;
 
@@ -96,6 +84,12 @@ static int uvc_mc_init_entity(struct uvc_entity *entity)
 
 		ret = media_entity_pads_init(&entity->subdev.entity,
 					entity->num_pads, entity->pads);
+
+		if (ret < 0)
+			return ret;
+
+		ret = v4l2_device_register_subdev(&chain->dev->vdev,
+						  &entity->subdev);
 	} else if (entity->vdev != NULL) {
 		ret = media_entity_pads_init(&entity->vdev->entity,
 					entity->num_pads, entity->pads);
@@ -113,7 +107,7 @@ int uvc_mc_register_entities(struct uvc_video_chain *chain)
 	int ret;
 
 	list_for_each_entry(entity, &chain->entities, chain) {
-		ret = uvc_mc_init_entity(entity);
+		ret = uvc_mc_init_entity(chain, entity);
 		if (ret < 0) {
 			uvc_printk(KERN_INFO, "Failed to initialize entity for "
 				   "entity %u\n", entity->id);
@@ -122,15 +116,6 @@ int uvc_mc_register_entities(struct uvc_video_chain *chain)
 	}
 
 	list_for_each_entry(entity, &chain->entities, chain) {
-		ret = uvc_mc_register_entity(chain, entity);
-		if (ret < 0) {
-			uvc_printk(KERN_INFO, "Failed to register entity for "
-				   "entity %u\n", entity->id);
-			return ret;
-		}
-	}
-
-	list_for_each_entry(entity, &chain->entities, chain) {
 		ret = uvc_mc_create_links(chain, entity);
 		if (ret < 0) {
 			uvc_printk(KERN_INFO, "Failed to create links for "
-- 
2.4.3

