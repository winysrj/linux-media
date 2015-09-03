Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:33926 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933581AbbICQBI (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 3 Sep 2015 12:01:08 -0400
From: Javier Martinez Canillas <javier@osg.samsung.com>
To: linux-kernel@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Javier Martinez Canillas <javier@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org
Subject: [PATCH 4/5] [media] uvcvideo: create pad links after subdev registration
Date: Thu,  3 Sep 2015 18:00:35 +0200
Message-Id: <1441296036-20727-5-git-send-email-javier@osg.samsung.com>
In-Reply-To: <1441296036-20727-1-git-send-email-javier@osg.samsung.com>
References: <1441296036-20727-1-git-send-email-javier@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The uvc driver creates the pads links before the media entity is
registered with the media device. This doesn't work now that obj
IDs are used to create links so the media_device has to be set.

Move entities registration logic before pads links creation.

Signed-off-by: Javier Martinez Canillas <javier@osg.samsung.com>
---

 drivers/media/usb/uvc/uvc_entity.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/media/usb/uvc/uvc_entity.c b/drivers/media/usb/uvc/uvc_entity.c
index 429e428ccd93..9dde1f86cc4b 100644
--- a/drivers/media/usb/uvc/uvc_entity.c
+++ b/drivers/media/usb/uvc/uvc_entity.c
@@ -37,6 +37,10 @@ static int uvc_mc_register_entity(struct uvc_video_chain *chain,
 	if (sink == NULL)
 		return 0;
 
+	ret = v4l2_device_register_subdev(&chain->dev->vdev, &entity->subdev);
+	if (ret < 0)
+		return ret;
+
 	for (i = 0; i < entity->num_pads; ++i) {
 		struct media_entity *source;
 		struct uvc_entity *remote;
@@ -46,8 +50,10 @@ static int uvc_mc_register_entity(struct uvc_video_chain *chain,
 			continue;
 
 		remote = uvc_entity_by_id(chain->dev, entity->baSourceID[i]);
-		if (remote == NULL)
-			return -EINVAL;
+		if (remote == NULL) {
+			ret = -EINVAL;
+			goto error;
+		}
 
 		source = (UVC_ENTITY_TYPE(remote) == UVC_TT_STREAMING)
 		       ? (remote->vdev ? &remote->vdev->entity : NULL)
@@ -59,13 +65,15 @@ static int uvc_mc_register_entity(struct uvc_video_chain *chain,
 		ret = media_create_pad_link(source, remote_pad,
 					       sink, i, flags);
 		if (ret < 0)
-			return ret;
+			goto error;
 	}
 
 	if (UVC_ENTITY_TYPE(entity) == UVC_TT_STREAMING)
 		return 0;
 
-	return v4l2_device_register_subdev(&chain->dev->vdev, &entity->subdev);
+error:
+	v4l2_device_unregister_subdev(&entity->subdev);
+	return ret;
 }
 
 static struct v4l2_subdev_ops uvc_subdev_ops = {
-- 
2.4.3

