Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:59811 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756878Ab1D3Ndn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 30 Apr 2011 09:33:43 -0400
Received: from localhost.localdomain (unknown [91.178.80.7])
	by perceval.ideasonboard.com (Postfix) with ESMTPSA id C202035B46
	for <linux-media@vger.kernel.org>; Sat, 30 Apr 2011 13:33:41 +0000 (UTC)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [PATCH 3/4] uvcvideo: Connect video devices to media entities
Date: Sat, 30 Apr 2011 15:34:04 +0200
Message-Id: <1304170445-11978-4-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1304170445-11978-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1304170445-11978-1-git-send-email-laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

The video devices associated to USB streaming terminals must be
connected to their associated terminal's media entity instead of being
standalone entities.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/video/uvc/uvc_driver.c |    8 +++++-
 drivers/media/video/uvc/uvc_entity.c |   40 +++++++++++++++++++++++++++------
 drivers/media/video/uvc/uvcvideo.h   |    1 +
 3 files changed, 39 insertions(+), 10 deletions(-)

diff --git a/drivers/media/video/uvc/uvc_driver.c b/drivers/media/video/uvc/uvc_driver.c
index 78e0836..b09a81d 100644
--- a/drivers/media/video/uvc/uvc_driver.c
+++ b/drivers/media/video/uvc/uvc_driver.c
@@ -1607,6 +1607,10 @@ static void uvc_delete(struct uvc_device *dev)
 		struct uvc_entity *entity;
 		entity = list_entry(p, struct uvc_entity, list);
 		uvc_mc_cleanup_entity(entity);
+		if (entity->vdev) {
+			video_device_release(entity->vdev);
+			entity->vdev = NULL;
+		}
 		kfree(entity);
 	}
 
@@ -1629,8 +1633,6 @@ static void uvc_release(struct video_device *vdev)
 	struct uvc_streaming *stream = video_get_drvdata(vdev);
 	struct uvc_device *dev = stream->dev;
 
-	video_device_release(vdev);
-
 	/* Decrement the registered streams count and delete the device when it
 	 * reaches zero.
 	 */
@@ -1744,6 +1746,8 @@ static int uvc_register_terms(struct uvc_device *dev,
 		ret = uvc_register_video(dev, stream);
 		if (ret < 0)
 			return ret;
+
+		term->vdev = stream->vdev;
 	}
 
 	return 0;
diff --git a/drivers/media/video/uvc/uvc_entity.c b/drivers/media/video/uvc/uvc_entity.c
index 8e8e7ef..ede7852 100644
--- a/drivers/media/video/uvc/uvc_entity.c
+++ b/drivers/media/video/uvc/uvc_entity.c
@@ -33,6 +33,9 @@ static int uvc_mc_register_entity(struct uvc_video_chain *chain,
 	int ret;
 
 	for (i = 0; i < entity->num_pads; ++i) {
+		struct media_entity *source;
+		struct media_entity *sink;
+
 		if (!(entity->pads[i].flags & MEDIA_PAD_FL_SINK))
 			continue;
 
@@ -40,14 +43,23 @@ static int uvc_mc_register_entity(struct uvc_video_chain *chain,
 		if (remote == NULL)
 			return -EINVAL;
 
+		source = (UVC_ENTITY_TYPE(remote) == UVC_TT_STREAMING)
+		       ? &remote->vdev->entity : &remote->subdev.entity;
+		sink = (UVC_ENTITY_TYPE(entity) == UVC_TT_STREAMING)
+		     ? &entity->vdev->entity : &entity->subdev.entity;
+
 		remote_pad = remote->num_pads - 1;
-		ret = media_entity_create_link(&remote->subdev.entity,
-				remote_pad, &entity->subdev.entity, i, flags);
+		ret = media_entity_create_link(source, remote_pad,
+					       sink, i, flags);
 		if (ret < 0)
 			return ret;
 	}
 
-	return v4l2_device_register_subdev(&chain->dev->vdev, &entity->subdev);
+	if (UVC_ENTITY_TYPE(entity) != UVC_TT_STREAMING)
+		ret = v4l2_device_register_subdev(&chain->dev->vdev,
+						  &entity->subdev);
+
+	return ret;
 }
 
 static struct v4l2_subdev_ops uvc_subdev_ops = {
@@ -55,16 +67,28 @@ static struct v4l2_subdev_ops uvc_subdev_ops = {
 
 void uvc_mc_cleanup_entity(struct uvc_entity *entity)
 {
-	media_entity_cleanup(&entity->subdev.entity);
+	if (UVC_ENTITY_TYPE(entity) != UVC_TT_STREAMING)
+		media_entity_cleanup(&entity->subdev.entity);
+	else if (entity->vdev != NULL)
+		media_entity_cleanup(&entity->vdev->entity);
 }
 
 static int uvc_mc_init_entity(struct uvc_entity *entity)
 {
-	v4l2_subdev_init(&entity->subdev, &uvc_subdev_ops);
-	strlcpy(entity->subdev.name, entity->name, sizeof(entity->subdev.name));
+	int ret;
+
+	if (UVC_ENTITY_TYPE(entity) != UVC_TT_STREAMING) {
+		v4l2_subdev_init(&entity->subdev, &uvc_subdev_ops);
+		strlcpy(entity->subdev.name, entity->name,
+			sizeof(entity->subdev.name));
+
+		ret = media_entity_init(&entity->subdev.entity,
+					entity->num_pads, entity->pads, 0);
+	} else
+		ret = media_entity_init(&entity->vdev->entity,
+					entity->num_pads, entity->pads, 0);
 
-	return media_entity_init(&entity->subdev.entity, entity->num_pads,
-				 entity->pads, 0);
+	return ret;
 }
 
 int uvc_mc_register_entities(struct uvc_video_chain *chain)
diff --git a/drivers/media/video/uvc/uvcvideo.h b/drivers/media/video/uvc/uvcvideo.h
index 87014fb..f4e298c 100644
--- a/drivers/media/video/uvc/uvcvideo.h
+++ b/drivers/media/video/uvc/uvcvideo.h
@@ -302,6 +302,7 @@ struct uvc_entity {
 	char name[64];
 
 	/* Media controller-related fields. */
+	struct video_device *vdev;
 	struct v4l2_subdev subdev;
 	unsigned int num_pads;
 	unsigned int num_links;
-- 
1.7.3.4

