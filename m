Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:33917 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933548AbbICQBD (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 3 Sep 2015 12:01:03 -0400
From: Javier Martinez Canillas <javier@osg.samsung.com>
To: linux-kernel@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Javier Martinez Canillas <javier@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-sh@vger.kernel.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org
Subject: [PATCH 2/5] [media] v4l: vsp1: create pad links after subdev registration
Date: Thu,  3 Sep 2015 18:00:33 +0200
Message-Id: <1441296036-20727-3-git-send-email-javier@osg.samsung.com>
In-Reply-To: <1441296036-20727-1-git-send-email-javier@osg.samsung.com>
References: <1441296036-20727-1-git-send-email-javier@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The vsp1 driver creates the pads links before the media entities are
registered with the media device. This doesn't work now that object
IDs are used to create links so the media_device has to be set.

Move entities registration logic before pads links creation.

Signed-off-by: Javier Martinez Canillas <javier@osg.samsung.com>
---

 drivers/media/platform/vsp1/vsp1_drv.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/media/platform/vsp1/vsp1_drv.c b/drivers/media/platform/vsp1/vsp1_drv.c
index 9cd94a76a9ed..2aa427d3ff39 100644
--- a/drivers/media/platform/vsp1/vsp1_drv.c
+++ b/drivers/media/platform/vsp1/vsp1_drv.c
@@ -250,6 +250,14 @@ static int vsp1_create_entities(struct vsp1_device *vsp1)
 		list_add_tail(&wpf->entity.list_dev, &vsp1->entities);
 	}
 
+	/* Register all subdevs. */
+	list_for_each_entry(entity, &vsp1->entities, list_dev) {
+		ret = v4l2_device_register_subdev(&vsp1->v4l2_dev,
+						  &entity->subdev);
+		if (ret < 0)
+			goto done;
+	}
+
 	/* Create links. */
 	list_for_each_entry(entity, &vsp1->entities, list_dev) {
 		if (entity->type == VSP1_ENTITY_LIF ||
@@ -269,14 +277,6 @@ static int vsp1_create_entities(struct vsp1_device *vsp1)
 			return ret;
 	}
 
-	/* Register all subdevs. */
-	list_for_each_entry(entity, &vsp1->entities, list_dev) {
-		ret = v4l2_device_register_subdev(&vsp1->v4l2_dev,
-						  &entity->subdev);
-		if (ret < 0)
-			goto done;
-	}
-
 	ret = v4l2_device_register_subdev_nodes(&vsp1->v4l2_dev);
 
 done:
-- 
2.4.3

